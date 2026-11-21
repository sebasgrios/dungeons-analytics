local fixture = dofile("tests/fixtures/forever_diagnostics.lua")
local addon = fixture.Load()
local api = fixture.API()
local safe = addon.SafeValues.New(api)
local context = addon.ClientContext.New(api, safe)
local meter = addon.DamageMeter.New(api, safe)
local store = addon.DiagnosticStore.Open()
local recorder = addon.Recorder.New(api, safe, context, meter, store)

recorder:OnEvent("PLAYER_LOGIN")
recorder:OnEvent("ENCOUNTER_START", 7, "Sensitive Name", 1, 5)
assert(store:Counts().events == 0)
assert(recorder:Start() == "started" and recorder:Start() == "alreadyActive")
assert(store.data.active and store:Counts().samples == 1)
assert(store:Export():find("loginObserved=true", 1, true))

api.combat = true
recorder:OnEvent("PLAYER_REGEN_DISABLED")
recorder:OnEvent("ENCOUNTER_START", 7, "Sensitive Name", 1, 5)
recorder:OnEvent("DAMAGE_METER_CURRENT_SESSION_UPDATED")
assert(store:Export():find('reason="combat-start"', 1, true))
api.combat = false
recorder:OnEvent("ENCOUNTER_END", 7, "Sensitive Name", 1, 5, 0)
recorder:OnEvent("PLAYER_REGEN_ENABLED")
api.sessions = { { sessionID = 17 }, { sessionID = 18 } }
for _ = 1, 2 do
    recorder:OnEvent("DAMAGE_METER_COMBAT_SESSION_UPDATED", 0, 18)
    recorder:OnEvent("DAMAGE_METER_COMBAT_SESSION_UPDATED", 0, 0)
end
recorder:OnEvent("LFG_COMPLETION_REWARD")
api.Advance(0.2)
assert(store:Export():find('reason="combat-end-1"', 1, true))
assert(store:Export():find("outcome=0", 1, true))
assert(store:Export():find("LFG_COMPLETION_REWARD", 1, true))
assert(store:Export():find("byID={id=18", 1, true))
assert(not store:Export():find("byID={id=0", 1, true))
assert(store:Export():find("meterEventsSinceSample=5", 1, true))
assert(store:Counts().events < 8)

api.sessions = {}
recorder:OnEvent("DAMAGE_METER_RESET")
api.Advance(5)
assert(store:Export():find('reason="meter-reset"', 1, true))
assert(not store:Export():find('reason="combat-end-4"', 1, true))
assert(store.data.epoch == 2)

local persisted = addon.DiagnosticStore.Open(store.data)
local reloaded = addon.Recorder.New(api, safe, context, meter, persisted)
reloaded:OnEvent("PLAYER_LOGIN")
reloaded:OnEvent("PLAYER_ENTERING_WORLD", false, true)
assert(reloaded.active and persisted.data.epoch == 3)
assert(persisted:Export():find("RELOAD epoch=3", 1, true))
assert(persisted:Export():find("persisted={events=", 1, true))
local report = persisted:Export()
assert(not report:find("Sensitive", 1, true))
assert(not report:find("Player-secret", 1, true))

reloaded:OnEvent("DAMAGE_METER_COMBAT_SESSION_UPDATED", 0, 23)
assert(reloaded:Stop() == "stopped")
local count = persisted:Counts().samples
api.Advance(10)
assert(persisted:Counts().samples == count)
assert(addon.DiagnosticStore.Open({ version = 999 }) == nil)

for index = 1, 250 do
    persisted:Record("events", "BOUNDED", 3, index, 0, {})
    persisted:Record("samples", "BOUNDED", 3, index, 0, {})
end
assert(persisted:Counts().events == 200 and persisted:Counts().samples == 24)
assert(persisted.data.events[1]:find("seq=51", 1, true))
assert(persisted.data.samples[1]:find("seq=227", 1, true))
persisted:Record("events", "DAMAGE_METER_COMBAT_SESSION_UPDATED", 3, 251, 0, {})
persisted:Record("samples", "METER", 3, 251, 0, { reason = "meter-update" })
assert(persisted.data.events[1]:find("seq=51", 1, true))
assert(persisted.data.samples[1]:find("seq=227", 1, true))

local legacyStart = "START epoch=1 seq=1 elapsed=0.000 {}"
local pressure = addon.DiagnosticStore.Open({ version = 1, events = { legacyStart } })
pressure:Record("samples", "METER", 1, 2, 0, { reason = "manual" })
for sequence = 3, 252 do
    pressure:Record("events", "DAMAGE_METER_COMBAT_SESSION_UPDATED", 1, sequence, 0, {})
    pressure:Record("samples", "METER", 1, sequence, 0, { reason = "meter-update" })
end
pressure = addon.DiagnosticStore.Open(pressure.data)
pressure:Record("events", "ENCOUNTER_END", 1, 253, 1, { outcome = 1 })
pressure:Record("samples", "METER", 1, 254, 1, { reason = "combat-end-1" })
assert(pressure:Counts().events == 200 and pressure:Counts().samples == 24)
assert(pressure.data.events[1]:find("START epoch=1", 1, true))
assert(pressure.data.events[200]:find("ENCOUNTER_END", 1, true))
assert(pressure.data.samples[1]:find('reason="manual"', 1, true))
assert(pressure.data.samples[24]:find('reason="combat-end-1"', 1, true))
print("Recorder and SavedVariables tests passed")
