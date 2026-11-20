local _, addon = ...

local Meter = {}
Meter.__index = Meter
addon.DamageMeter = Meter

local metricNames = {
    "DamageDone",
    "Dps",
    "HealingDone",
    "Hps",
    "Absorbs",
    "Interrupts",
    "Dispels",
    "DamageTaken",
    "AvoidableDamageTaken",
    "Deaths",
    "EnemyDamageTaken",
}
local sourceFields = {
    sourceGUID = "string",
    name = "string",
    classFilename = "string",
    specIconID = "number",
    sourceCreatureID = "number",
    totalAmount = "number",
    amountPerSecond = "number",
    isLocalPlayer = "boolean",
    deathTimeSeconds = "number",
    deathRecapID = "number",
}
local limits = { sessions = 12, rows = 12, healers = 5, spells = 24, recipients = 10 }

function Meter.New(api, safe)
    return setmetatable({ api = api, safe = safe }, Meter)
end

function Meter:Capabilities()
    local meter, safe = self.api.C_DamageMeter, self.safe
    local report = { namespace = type(meter) == "table", functions = {}, metrics = {} }
    for _, name in ipairs({
        "IsDamageMeterAvailable",
        "GetAvailableCombatSessions",
        "GetCombatSessionFromID",
        "GetCombatSessionFromType",
        "GetCombatSessionSourceFromID",
        "GetSessionDurationSeconds",
    }) do
        report.functions[name] = meter ~= nil and type(meter[name]) == "function"
    end
    for _, name in ipairs(metricNames) do
        local state, value = self:Enum("DamageMeterType", name)
        report.metrics[name] = value or state
    end
    local state, available = safe:Call(meter and meter.IsDamageMeterAvailable, "boolean")
    report.availability = { state = state, value = available }
    return report
end

function Meter:Enum(enum, name)
    local values = self.api.Enum and self.api.Enum[enum]
    return self.safe:Field(values, name, "number")
end

function Meter:Catalogue()
    local safe = self.safe
    local meter = self.api.C_DamageMeter
    local state, rows = safe:Call(meter and meter.GetAvailableCombatSessions, "table")
    local result = { state = state, sessions = {}, fields = {}, rows = {} }
    if not rows then
        return result
    end
    result.scan = safe:Each(rows, limits.sessions, function(rowState, row)
        addon.SafeValues.Count(result.rows, rowState)
        if row then
            local idState, id = safe:Field(row, "sessionID", "number")
            local durationState, duration = safe:Field(row, "durationSeconds", "number")
            addon.SafeValues.Count(result.fields, idState)
            addon.SafeValues.Count(result.fields, durationState)
            if id then
                result.sessions[#result.sessions + 1] = { id = id, duration = duration }
            end
        end
    end)
    result.state = result.scan.state
    return result
end

function Meter:Duration(sessionType)
    local _, value = self:Enum("DamageMeterSessionType", sessionType)
    local meter = self.api.C_DamageMeter
    if value == nil then
        return { state = "unavailable" }
    end
    local state, duration = self.safe:Call(meter and meter.GetSessionDurationSeconds, "number", value)
    return { state = state, seconds = duration }
end

local function readSources(safe, sourceList, result, identities, collectHealers)
    local healing = {}
    result.rows = {}
    result.fields = {}
    result.joins = {}
    result.party = {}
    result.scan = safe:Each(sourceList, limits.rows, function(state, source)
        addon.SafeValues.Count(result.rows, state)
        if not source then
            return
        end
        local values = {}
        for field, expected in pairs(sourceFields) do
            local fieldState, value = safe:Field(source, field, expected)
            local states = result.fields[field] or {}
            addon.SafeValues.Count(states, fieldState)
            result.fields[field] = states
            -- Names and spec icons are counted only. Other values are scoped to this row.
            if field ~= "name" and field ~= "specIconID" then
                values[field] = value
            end
        end
        local alias
        if identities then
            alias = identities.byGUID[values.sourceGUID]
            if values.isLocalPlayer and alias == nil then
                alias = "player"
            end
            local joinState = alias and "matched" or (alias == false and "ambiguous" or "unmatched")
            addon.SafeValues.Count(result.joins, joinState)
            if alias then
                if result.party[alias] then
                    result.party[alias] = { ambiguous = true }
                else
                    result.party[alias] = {
                        total = values.totalAmount,
                        rate = values.amountPerSecond,
                        deathTime = values.deathTimeSeconds,
                        deathRecapAvailable = values.deathRecapID ~= nil,
                    }
                end
            end
        end
        if collectHealers and (values.sourceGUID or values.sourceCreatureID) then
            healing[#healing + 1] =
                { guid = values.sourceGUID, creature = values.sourceCreatureID, alias = alias }
        end
    end)
    return healing
end

function Meter:Metric(scope, metric, identities, collectHealers)
    local safe, meter = self.safe, self.api.C_DamageMeter
    local enumState, metricType = self:Enum("DamageMeterType", metric)
    if metricType == nil then
        return { state = enumState }
    end

    local reader, selector
    if scope.id then
        reader, selector = meter and meter.GetCombatSessionFromID, scope.id
    else
        local _, value = self:Enum("DamageMeterSessionType", scope.kind)
        reader, selector = meter and meter.GetCombatSessionFromType, value
    end
    if selector == nil then
        return { state = "unavailable" }
    end
    local state, session = safe:Call(reader, "table", selector, metricType)
    local result = { state = state }
    if not session then
        return result
    end

    local durationState, duration = safe:Field(session, "durationSeconds", "number")
    local totalState, total = safe:Field(session, "totalAmount", "number")
    local sourcesState, sources = safe:Field(session, "combatSources", "table")
    result.duration = { state = durationState, value = duration }
    result.total = { state = totalState, value = total }
    result.sources = sourcesState
    if sources then
        local healers = readSources(safe, sources, result, identities, collectHealers)
        return result, healers
    end
    return result
end

local function readRecipient(safe, entry, identities, report, healer)
    local nameState, name = safe:Field(entry, "unitName", "string")
    local amountState, amount = safe:Field(entry, "amount", "number")
    addon.SafeValues.Count(report.recipientNames, nameState)
    addon.SafeValues.Count(report.recipientAmounts, amountState)
    if amount ~= nil then
        report.observedAmount = report.observedAmount + amount
    end
    local alias = name and identities.byName[name]
    local state = alias and "matched" or (alias == false and "ambiguous" or "unmatched")
    addon.SafeValues.Count(report.recipientJoins, state)
    if amount ~= nil and alias then
        report.matchedAmount = report.matchedAmount + amount
        report.matchedAmountCount = report.matchedAmountCount + 1
        if healer.alias then
            local key = alias == healer.alias and "selfObservedAmount" or "otherObservedAmount"
            report[key] = (report[key] or 0) + amount
        end
    end
end

local function readSpell(safe, spell, identities, report, healer)
    local idState = safe:Field(spell, "spellID", "number")
    local totalState = safe:Field(spell, "totalAmount", "number")
    addon.SafeValues.Count(report.spellIDs, idState)
    addon.SafeValues.Count(report.spellAmounts, totalState)
    local detailState, details = safe:Field(spell, "combatSpellDetails", "table")
    if not details then
        addon.SafeValues.Count(report.detailShape, detailState)
        return
    end
    local firstState = safe:Field(details, 1, "table")
    if firstState == "missing" then
        local nameState = safe:Field(details, "unitName", "string")
        local amountState = safe:Field(details, "amount", "number")
        if nameState == "missing" and amountState == "missing" then
            addon.SafeValues.Count(report.detailShape, "empty")
        else
            addon.SafeValues.Count(report.detailShape, "single")
            report.recipientLowerBound = report.recipientLowerBound + 1
            readRecipient(safe, details, identities, report, healer)
        end
        return
    end

    addon.SafeValues.Count(report.detailShape, "list")
    local scan = safe:Each(details, limits.recipients, function(state, recipient)
        if recipient then
            readRecipient(safe, recipient, identities, report, healer)
        else
            addon.SafeValues.Count(report.recipientRows, state)
        end
    end)
    report.recipientLowerBound = report.recipientLowerBound + scan.lowerBound
    report.recipientCapped = report.recipientCapped or scan.capped or false
end

function Meter:Healing(sessionID, healers, identities)
    local meter, safe = self.api.C_DamageMeter, self.safe
    local _, metric = self:Enum("DamageMeterType", "HealingDone")
    if metric == nil or not healers then
        return { state = "unavailable" }
    end
    local report = {
        state = #healers == 0 and "empty" or "readable",
        healerCount = math.min(#healers, limits.healers),
        healerLowerBound = #healers,
        healerCapped = #healers > limits.healers,
        spellLowerBound = 0,
        recipientLowerBound = 0,
        sourceStates = {},
        spellStates = {},
        spellIDs = {},
        spellAmounts = {},
        detailShape = {},
        recipientRows = {},
        recipientNames = {},
        recipientAmounts = {},
        recipientJoins = {},
        sourceAmount = 0,
        sourceAmountCount = 0,
        observedAmount = 0,
        matchedAmount = 0,
        matchedAmountCount = 0,
    }

    for index = 1, report.healerCount do
        local healer = healers[index]
        local state, detail = safe:Call(
            meter and meter.GetCombatSessionSourceFromID,
            "table",
            sessionID,
            metric,
            healer.guid,
            healer.creature
        )
        addon.SafeValues.Count(report.sourceStates, state)
        if detail then
            local _, amount = safe:Field(detail, "totalAmount", "number")
            if amount ~= nil then
                report.sourceAmount = report.sourceAmount + amount
                report.sourceAmountCount = report.sourceAmountCount + 1
            end
            local spellState, spells = safe:Field(detail, "combatSpells", "table")
            addon.SafeValues.Count(report.spellStates, spellState)
            if spells then
                local scan = safe:Each(spells, limits.spells, function(rowState, spell)
                    if spell then
                        readSpell(safe, spell, identities, report, healer)
                    else
                        addon.SafeValues.Count(report.spellStates, rowState)
                    end
                end)
                report.spellLowerBound = report.spellLowerBound + scan.lowerBound
                report.spellCapped = report.spellCapped or scan.capped or false
            end
        end
    end
    report.sourceAmount = report.sourceAmountCount > 0 and report.sourceAmount or nil
    report.observedAmount = report.recipientAmounts.readable and report.observedAmount or nil
    report.matchedAmount = report.matchedAmountCount > 0 and report.matchedAmount or nil
    if report.sourceAmount ~= nil and report.observedAmount ~= nil then
        report.observedMinusSourceAmount = report.observedAmount - report.sourceAmount
    end
    if report.healerCount > 0 and not report.sourceStates.readable then
        report.state = "unavailable"
    end
    return report
end

function Meter:Read(identities, historicalID, quick)
    local result = { capabilities = self:Capabilities(), byType = {} }
    if result.capabilities.availability.value == false then
        return result
    end

    result.durations = { Current = self:Duration("Current") }
    if quick then
        result.byType.DamageDone = self:Metric({ kind = "Current" }, "DamageDone")
        return result
    end

    result.durations.Overall = self:Duration("Overall")
    result.catalogue = self:Catalogue()
    local fallback = result.catalogue.sessions[1]
    local id = historicalID or (fallback and fallback.id)
    if id then
        result.byID = { id = id, metrics = {} }
    end
    for _, name in ipairs(metricNames) do
        result.byType[name] = self:Metric({ kind = "Current" }, name, identities)
        if result.byID then
            local metric, healers = self:Metric({ id = id }, name, identities, name == "HealingDone")
            result.byID.metrics[name] = metric
            if name == "HealingDone" then
                result.healing = self:Healing(id, healers, identities)
            end
        end
    end
    return result
end
