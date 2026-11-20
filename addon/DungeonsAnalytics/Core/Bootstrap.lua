local addonName, addon = ...

local api = _G
local frame = api.CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, _, loadedName)
    if loadedName ~= addonName then
        return
    end
    self:UnregisterEvent("ADDON_LOADED")

    local safe = addon.SafeValues.New(api)
    local context = addon.ClientContext.New(api, safe)
    local meter = addon.DamageMeter.New(api, safe)
    local store = addon.DiagnosticStore.Open(api.DungeonsAnalyticsDiagnosticsDB)
    if store then
        api.DungeonsAnalyticsDiagnosticsDB = store.data
    end
    local recorder = addon.Recorder.New(api, safe, context, meter, store)
    addon.Events.Bind(self, recorder)
    addon.Commands.Bind(api, recorder, addon.NativeProbe.New(api))
end)
