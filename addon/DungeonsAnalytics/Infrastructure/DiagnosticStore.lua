local _, addon = ...

local Store = {}
Store.__index = Store
addon.DiagnosticStore = Store

local version = 1
local limits = { events = 200, samples = 24, eventBytes = 4096, sampleBytes = 30000, catalogue = 12 }

local function copyWindow(source, limit, maxBytes)
    local result = {}
    if type(source) == "table" then
        for index = math.max(1, #source - limit + 1), #source do
            local value = source[index]
            if type(value) == "string" and #value <= maxBytes then
                result[#result + 1] = value
            end
        end
    end
    return result
end

local function copyCatalogue(source)
    local result = {}
    if type(source) == "table" then
        for index = 1, limits.catalogue do
            local id = source[index]
            if type(id) == "number" and id == id and math.abs(id) < math.huge then
                result[#result + 1] = id
            end
        end
    end
    return result
end

function Store.Open(saved)
    if saved ~= nil and (type(saved) ~= "table" or saved.version ~= version) then
        return nil
    end
    saved = saved or {}
    local epoch = saved.epoch
    if type(epoch) ~= "number" or epoch < 0 or epoch > 1000000000 or epoch ~= math.floor(epoch) then
        epoch = 0
    end
    return setmetatable({
        data = {
            version = version,
            active = saved.active == true,
            epoch = epoch,
            events = copyWindow(saved.events, limits.events, limits.eventBytes),
            samples = copyWindow(saved.samples, limits.samples, limits.sampleBytes),
            catalogue = copyCatalogue(saved.catalogue),
        },
    }, Store)
end

-- The recorder passes owned, projected structures. Formatting never receives client API tables.
local function encode(value, parts)
    local kind = type(value)
    if kind == "table" then
        local keys = {}
        for key in pairs(value) do
            keys[#keys + 1] = key
        end
        table.sort(keys, function(a, b)
            if type(a) == type(b) then
                return a < b
            end
            return type(a) < type(b)
        end)
        parts[#parts + 1] = "{"
        for index, key in ipairs(keys) do
            if index ~= 1 then
                parts[#parts + 1] = ", "
            end
            parts[#parts + 1] = tostring(key) .. "="
            encode(value[key], parts)
        end
        parts[#parts + 1] = "}"
    elseif kind == "string" then
        parts[#parts + 1] = string.format("%q", value)
    elseif kind == "boolean" or kind == "number" then
        parts[#parts + 1] = tostring(value)
    end
end

local function isBackground(stream, kind, reason)
    if stream == "samples" then
        return reason == "meter-update"
    end
    return kind == "DAMAGE_METER_COMBAT_SESSION_UPDATED" or kind == "DAMAGE_METER_CURRENT_SESSION_UPDATED"
end

local function oldestBackground(stream, records)
    for index, record in ipairs(records) do
        local kind = record:match("^(%S+)")
        local reason = stream == "samples" and record:match('[{,]%s*reason="([^"]+)"')
        if isBackground(stream, kind, reason) then
            return index
        end
    end
end

function Store:Record(stream, kind, epoch, sequence, elapsed, data)
    local records = self.data[stream]
    local discard
    local background = isBackground(stream, kind, data.reason)
    if #records >= limits[stream] then
        discard = oldestBackground(stream, records)
        if not discard and background then
            return
        end
        discard = discard or 1
    end

    local prefix = string.format("%s epoch=%d seq=%d elapsed=%.3f ", kind, epoch, sequence, elapsed)
    local segments = { prefix }
    encode(data, segments)
    local bytes = stream == "events" and limits.eventBytes or limits.sampleBytes
    local text = table.concat(segments)
    if #text > bytes then
        local suffix = stream == "samples" and background and ', reason="meter-update"' or ""
        local summary = '{state="record-too-large", bytes=%d, retainedLimit=%d%s}'
        text = prefix .. string.format(summary, #text, bytes, suffix)
    end
    if discard then
        table.remove(records, discard)
    end
    records[#records + 1] = text
end

function Store:Counts()
    return { events = #self.data.events, samples = #self.data.samples }
end

function Store:ObserveCatalogue(catalogue)
    local before = self.data.catalogue
    local after = {}
    local known = {}
    local repeated = 0
    local new = 0
    local duplicate = 0
    for _, id in ipairs(before) do
        known[id] = true
    end
    local current = {}
    for _, session in ipairs(catalogue.sessions) do
        local id = session.id
        if current[id] then
            duplicate = duplicate + 1
        else
            current[id] = true
            after[#after + 1] = id
            if known[id] then
                repeated = repeated + 1
            else
                new = new + 1
            end
        end
    end
    self.data.catalogue = after
    return { previous = #before, observed = #after, repeated = repeated, new = new, duplicates = duplicate }
end

function Store:Export()
    local result = { "Dungeons Analytics diagnostic schema " .. version, "Events" }
    for _, record in ipairs(self.data.events) do
        result[#result + 1] = record
    end
    result[#result + 1] = "Samples"
    for _, record in ipairs(self.data.samples) do
        result[#result + 1] = record
    end
    return table.concat(result, "\n")
end
