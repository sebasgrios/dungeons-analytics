local _, addon = ...

local Events = {}
addon.Events = Events

local candidates = {
    "PLAYER_LOGIN",
    "PLAYER_LOGOUT",
    "PLAYER_ENTERING_WORLD",
    "ZONE_CHANGED_NEW_AREA",
    "GROUP_ROSTER_UPDATE",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "ENCOUNTER_START",
    "ENCOUNTER_END",
    "LFG_COMPLETION_REWARD",
    "DAMAGE_METER_COMBAT_SESSION_UPDATED",
    "DAMAGE_METER_CURRENT_SESSION_UPDATED",
    "DAMAGE_METER_RESET",
}

function Events.Bind(frame, recorder)
    recorder.registrations.ADDON_LOADED = true
    for _, event in ipairs(candidates) do
        local ok, result = pcall(frame.RegisterEvent, frame, event)
        recorder.registrations[event] = ok and result ~= false
    end
    frame:SetScript("OnEvent", function(_, event, ...)
        if recorder.registrations[event] then
            recorder:OnEvent(event, ...)
        end
    end)
end
