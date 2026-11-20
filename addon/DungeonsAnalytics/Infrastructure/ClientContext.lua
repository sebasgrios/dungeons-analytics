local _, addon = ...

local Context = {}
Context.__index = Context
addon.ClientContext = Context

local classes = {
    DEATHKNIGHT = true,
    DEMONHUNTER = true,
    DRUID = true,
    EVOKER = true,
    HUNTER = true,
    MAGE = true,
    MONK = true,
    PALADIN = true,
    PRIEST = true,
    ROGUE = true,
    SHAMAN = true,
    WARLOCK = true,
    WARRIOR = true,
}
local roles = { TANK = true, HEALER = true, DAMAGER = true, NONE = true }
local instanceTypes = { none = true, party = true, raid = true, arena = true, pvp = true, scenario = true }

function Context.New(api, safe)
    return setmetatable({ api = api, safe = safe }, Context)
end

function Context:Build()
    -- Build and locale are documented public client metadata, outside the meter boundary.
    local version, build, interface
    if type(self.api.GetBuildInfo) == "function" then
        local _
        version, build, _, interface = self.api.GetBuildInfo()
    end
    local locale = type(self.api.GetLocale) == "function" and self.api.GetLocale() or "unknown"
    local supported = type(version) == "string"
        and version:match("^1%.60%.") ~= nil
        and type(interface) == "number"
        and interface >= 16000
        and interface < 17000
    return {
        version = version,
        build = build,
        interface = interface,
        locale = locale,
        flavor = supported and "forever" or "unknown",
    }
end

function Context:Instance()
    local fn = self.api.GetInstanceInfo
    if type(fn) ~= "function" then
        return { state = "unavailable" }
    end
    local ok, _, kind, difficulty, _, _, _, _, mapID = pcall(fn)
    if not ok then
        return { state = "failed" }
    end
    local state, readableKind = self.safe:Classify(kind, "string")
    local _, readableMap = self.safe:Classify(mapID, "number")
    local _, readableDifficulty = self.safe:Classify(difficulty, "number")
    return {
        state = state,
        kind = instanceTypes[readableKind] and readableKind or nil,
        mapID = readableMap,
        difficulty = readableDifficulty,
    }
end

local function addIdentity(index, value, alias)
    if value and value ~= "" then
        if index[value] == nil then
            index[value] = alias
        elseif index[value] ~= alias then
            index[value] = false
        end
    end
end

function Context:Roster()
    local api, safe = self.api, self.safe
    local state, partyCount = safe:Call(api.GetNumSubgroupMembers, "number")
    local report = { state = state, members = {}, guid = {}, name = {} }
    local private = { byGUID = {}, byName = {} }
    local count = math.min(math.max(math.floor(partyCount or 0), 0), 4)
    report.partyCount = partyCount
    report.capped = partyCount ~= nil and partyCount > count

    for index = 0, count do
        local token = index == 0 and "player" or "party" .. index
        local guidState, guid = safe:Call(api.UnitGUID, "string", token)
        local nameState, name = safe:Call(api.UnitName, "string", token)
        local _, fullName = safe:Call(api.GetUnitName, "string", token, true)
        local _, role = safe:Call(api.UnitGroupRolesAssigned, "string", token)
        local class
        if type(api.UnitClass) == "function" then
            local ok, _, classToken = pcall(api.UnitClass, token)
            if ok then
                local _, readableClass = safe:Classify(classToken, "string")
                class = classes[readableClass] and readableClass or nil
            end
        end
        report.members[token] = { class = class, role = roles[role] and role or nil }
        addon.SafeValues.Count(report.guid, guidState)
        addon.SafeValues.Count(report.name, nameState)
        addIdentity(private.byGUID, guid, token)
        addIdentity(private.byName, name, token)
        addIdentity(private.byName, fullName, token)
    end
    return report, private
end

function Context:CombatLog()
    local api = self.api.C_CombatLog
    local state, restricted = self.safe:Call(api and api.IsCombatLogRestricted, "boolean")
    return { state = state, restricted = restricted }
end
