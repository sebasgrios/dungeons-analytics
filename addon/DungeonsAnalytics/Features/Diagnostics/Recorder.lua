local _, addon = ...

local Recorder = {}
Recorder.__index = Recorder
addon.Recorder = Recorder

local checkpoints = { 0.15, 0.6, 1.5, 3 }
local historyLimit = 12
local meterEvents = {
    DAMAGE_METER_COMBAT_SESSION_UPDATED = true,
    DAMAGE_METER_CURRENT_SESSION_UPDATED = true,
}

function Recorder.New(api, safe, context, meter, store)
    local resume = store and store.data.active
    if store then
        store.data.active = false
    end
    return setmetatable({
        api = api,
        safe = safe,
        context = context,
        meter = meter,
        store = store,
        build = context:Build(),
        active = false,
        resume = resume,
        sequence = 0,
        generation = 0,
        updates = 0,
        registrations = {},
        historyIDs = {},
    }, Recorder)
end

function Recorder:Locked()
    return type(self.api.InCombatLockdown) ~= "function" or self.api.InCombatLockdown()
end

function Recorder:NewEpoch()
    self.store.data.epoch = self.store.data.epoch + 1
    self.startedAt = self.api.GetTime()
    self.sequence = 0
end

function Recorder:Invalidate()
    self.generation = self.generation + 1
    self.queued = nil
    self.updates = 0
    self.historyIDs = {}
end

function Recorder:Log(stream, kind, data)
    self.sequence = self.sequence + 1
    self.store:Record(
        stream,
        kind,
        self.store.data.epoch,
        self.sequence,
        math.max(0, self.api.GetTime() - self.startedAt),
        data
    )
end

function Recorder:Start(reason, persisted)
    if not self.store then
        return "storeUnavailable"
    end
    if self.build.flavor ~= "forever" then
        return "wrongClient"
    end
    if self.active then
        return "alreadyActive"
    end
    self.resume = false
    self.active = true
    self.store.data.active = true
    self:NewEpoch()
    self:Log("events", reason or "START", {
        build = self.build,
        persisted = persisted,
        registrations = self.registrations,
        combatLog = self.context:CombatLog(),
        loginObserved = self.loginObserved,
    })
    self:Capture(reason == "RELOAD" and "reload" or "baseline", self:Locked())
    return "started"
end

function Recorder:Stop()
    if not self.active then
        return "alreadyStopped"
    end
    self:Log("events", "STOP", {})
    self.active = false
    self.store.data.active = false
    self:Invalidate()
    return "stopped"
end

function Recorder:Capture(reason, quick)
    local roster, identities
    if not quick then
        roster, identities = self.context:Roster()
    end
    local report = self.meter:Read(identities, self.historyIDs, quick)
    report.reason = reason
    report.combat = quick and true or false
    report.roster = roster
    if not quick then
        report.instance = self.context:Instance()
    end
    if report.catalogue and (report.catalogue.state == "readable" or report.catalogue.state == "empty") then
        report.catalogue.comparison = self.store:ObserveCatalogue(report.catalogue)
    end
    report.meterEventsSinceSample = self.updates
    self.updates = 0
    self:Log("samples", "METER", report)
end

function Recorder:After(delay, callback)
    local timer = self.api.C_Timer
    if not timer or type(timer.After) ~= "function" then
        return false
    end
    local generation = self.generation
    timer.After(delay, function()
        if self.active and self.generation == generation then
            callback()
        end
    end)
    return true
end

function Recorder:Defer(reason, delay)
    if self.queued then
        return
    end
    self.queued = self:After(delay, function()
        self.queued = nil
        if not self:Locked() then
            self:Capture(reason, false)
        end
    end)
end

function Recorder:Sample()
    if not self.active then
        return "alreadyStopped"
    end
    self:Capture("manual", self:Locked())
    return "snapshotSaved"
end

function Recorder:OnMeterEvent(event, metric, session)
    self.updates = math.min(self.updates + 1, 1000000)
    local _, sessionID = self.safe:Classify(session, "number")
    local candidates = self.historyIDs
    if sessionID and sessionID ~= candidates[1] then
        for index, id in ipairs(candidates) do
            if id == sessionID then
                table.remove(candidates, index)
                break
            end
        end
        if #candidates >= historyLimit then
            table.remove(candidates)
        end
        table.insert(candidates, 1, sessionID)
    end
    if self.updates == 1 then
        local _, metricType = self.safe:Classify(metric, "number")
        self:Log("events", event, { metric = metricType, id = sessionID })
    end
    if not self:Locked() then
        self:Defer("meter-update", 1)
    end
end

function Recorder:OnEvent(event, ...)
    local a, b, c, d, e = ...
    if event == "PLAYER_LOGIN" then
        self.loginObserved = true
    end
    if event == "PLAYER_ENTERING_WORLD" and self.resume then
        self.resume = false
        local _, reload = self.safe:Classify(b, "boolean")
        if reload then
            self:Start("RELOAD", self.store:Counts())
        end
    end
    if not self.active then
        return
    end
    if meterEvents[event] then
        self:OnMeterEvent(event, a, b)
        return
    end

    local facts = {}
    if event == "PLAYER_REGEN_DISABLED" then
        self:Invalidate()
        self:Log("events", event, facts)
        self:Capture("combat-start", true)
        return
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:Log("events", event, { meterEventsDuringCombat = self.updates })
        for index, seconds in ipairs(checkpoints) do
            local label = "combat-end-" .. index
            self:After(seconds, function()
                if not self:Locked() then
                    self:Capture(label, false)
                end
            end)
        end
        return
    elseif event == "DAMAGE_METER_RESET" then
        self:Invalidate()
        self:Log("events", event, facts)
        self:NewEpoch()
        self:Defer("meter-reset", 0.35)
        return
    elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
        self:Invalidate()
        facts.instance = self.context:Instance()
        if event == "PLAYER_ENTERING_WORLD" then
            local _, initial = self.safe:Classify(a, "boolean")
            local _, reload = self.safe:Classify(b, "boolean")
            facts.initialLogin, facts.reload = initial, reload
        end
        self:Defer("zone-change", 0.35)
    elseif event == "GROUP_ROSTER_UPDATE" and not self:Locked() then
        facts.roster = self.context:Roster()
    elseif event == "ENCOUNTER_START" or event == "ENCOUNTER_END" then
        local _, encounterID = self.safe:Classify(a, "number")
        local _, difficulty = self.safe:Classify(c, "number")
        local _, groupSize = self.safe:Classify(d, "number")
        local _, outcome = self.safe:Classify(e, "number")
        facts.encounterID, facts.difficulty, facts.groupSize, facts.outcome =
            encounterID, difficulty, groupSize, outcome
    elseif event == "LFG_COMPLETION_REWARD" then
        self:Defer("lfg-completion", 0.6)
    end
    self:Log("events", event, facts)
end
