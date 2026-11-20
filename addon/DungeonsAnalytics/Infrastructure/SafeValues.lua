local _, addon = ...

local SafeValues = {}
SafeValues.__index = SafeValues
addon.SafeValues = SafeValues

function SafeValues.New(api)
    return setmetatable({
        isSecret = api.issecretvalue,
        canAccessValue = api.canaccessvalue,
        canAccessTable = api.canaccesstable,
    }, SafeValues)
end

function SafeValues:Classify(value, expected)
    if type(self.isSecret) ~= "function" or type(self.canAccessValue) ~= "function" then
        return "guard-unavailable"
    end
    if self.isSecret(value) then
        return "secret"
    end
    if not self.canAccessValue(value) then
        return "restricted"
    end
    if value == nil then
        return "missing"
    end

    local kind = type(value)
    if expected and kind ~= expected then
        return "unexpected"
    end
    if kind == "table" then
        if type(self.canAccessTable) ~= "function" then
            return "guard-unavailable"
        end
        if not self.canAccessTable(value) then
            return "restricted"
        end
    elseif kind == "number" and (value ~= value or value == math.huge or value == -math.huge) then
        return "unexpected"
    end
    return "readable", value
end

local function readField(container, key)
    return container[key]
end

function SafeValues:Field(container, key, expected)
    local state, readable = self:Classify(container, "table")
    if not readable then
        return state
    end
    local ok, value = pcall(readField, readable, key)
    if not ok then
        return "failed"
    end
    return self:Classify(value, expected)
end

function SafeValues:Call(fn, expected, ...)
    if type(fn) ~= "function" then
        return "unavailable"
    end
    local ok, value = pcall(fn, ...)
    if not ok then
        return "failed"
    end
    return self:Classify(value, expected)
end

function SafeValues.Count(counts, state)
    counts[state] = (counts[state] or 0) + 1
end

-- Blizzard returns compact arrays. Read one additional slot to identify a lower bound.
function SafeValues:Each(container, limit, visit)
    local state, readable = self:Classify(container, "table")
    local result = { state = state, scanned = 0 }
    if not readable then
        return result
    end
    for index = 1, limit do
        local rowState, row = self:Field(readable, index, "table")
        if rowState == "missing" then
            break
        end
        result.scanned = index
        visit(rowState, row)
    end
    if result.scanned == limit then
        result.capped = self:Field(readable, limit + 1, "table") ~= "missing"
    end
    if result.scanned == 0 then
        result.state = "empty"
    end
    result.lowerBound = result.scanned + (result.capped and 1 or 0)
    return result
end
