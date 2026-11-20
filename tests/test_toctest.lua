local fixture = dofile("tests/fixtures/forever_diagnostics.lua")
local api = fixture.API()
local events, handlers, messages = {}, {}, {}
local frame = {
    RegisterEvent = function(_, event)
        events[event] = true
    end,
    UnregisterEvent = function(_, event)
        events[event] = nil
    end,
    SetScript = function(_, script, handler)
        handlers[script] = handler
    end,
    Hide = function() end,
    CreateLine = function()
        return {}
    end,
}
api.CreateFrame = function(_, _, _, template)
    if template == "BasicFrameTemplateWithInset" then
        error("Missing template fixture")
    end
    return frame
end
api.SlashCmdList = {}
api.print = function(message)
    messages[#messages + 1] = message
end

local addon, manifest = fixture.Load(api)
assert(#manifest == 10 and manifest[#manifest] == "Core/Bootstrap.lua")
assert(events.ADDON_LOADED)
handlers.OnEvent(frame, "ADDON_LOADED", "OtherAddon")
assert(api.SlashCmdList.DUNGEONSANALYTICS == nil)
handlers.OnEvent(frame, "ADDON_LOADED", "DungeonsAnalytics")
assert(not events.ADDON_LOADED and events.PLAYER_LOGIN and events.DAMAGE_METER_RESET)
assert(api.SLASH_DUNGEONSANALYTICS1 == "/da")
assert(not api.DungeonsAnalyticsDiagnosticsDB.active)
local slash = api.SlashCmdList.DUNGEONSANALYTICS
slash("diag")
assert(messages[2]:find("desactivada", 1, true))
slash("diag start")
assert(api.DungeonsAnalyticsDiagnosticsDB.active)
api.combat = true
slash("diag ui")
assert(messages[#messages]:find("combate", 1, true))
api.combat = false
slash("diag ui")
assert(
    api.DungeonsAnalyticsDiagnosticsDB.events[#api.DungeonsAnalyticsDiagnosticsDB.events]:find(
        "NATIVE_UI",
        1,
        true
    )
)
local native = addon.NativeProbe.New(api):Inspect()
assert(native.widgets.ButtonFrameTemplate == "available" and native.apis.Line)
assert(native.widgets.BasicFrameTemplateWithInset == "failed")
slash("diag stop")
assert(api.DungeonsAnalyticsDiagnosticsDB.active == false)
print("TOC loading, slash command and native probe tests passed")
