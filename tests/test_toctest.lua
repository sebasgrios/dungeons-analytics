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
assert(manifest[#manifest] == "Core/Bootstrap.lua")
local templatePath = "Features/Diagnostics/DiagnosticTemplates.xml"
local templateIndex
for index, path in ipairs(manifest) do
    if path == templatePath then
        templateIndex = index
    end
end
assert(templateIndex and manifest[templateIndex + 1] == "Features/Diagnostics/NativeProbe.lua")
local templateFile = assert(io.open("addon/DungeonsAnalytics/" .. templatePath, "r"))
local xml = templateFile:read("*a")
templateFile:close()
assert(xml:find('inherits="InputScrollFrameTemplate"', 1, true))
local width, height = xml:match('<Size x="(%d+)" y="(%d+)"/>')
assert(tonumber(width) > 18 and tonumber(height) > 0)
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
local function noop() end
local reportText, focused, highlighted, windowsCreated = "", false, false, 0
local windowScripts, editorScripts = {}, {}
local label = { SetPoint = noop, SetJustifyH = noop, SetText = noop }
local editor = {
    SetWidth = noop,
    SetText = function(_, text)
        reportText = text
    end,
    SetFocus = function()
        focused = true
    end,
    ClearFocus = function()
        focused = false
    end,
    HighlightText = function()
        highlighted = true
    end,
    SetScript = function(_, name, handler)
        editorScripts[name] = handler
    end,
}
local window = {
    SetSize = noop,
    SetPoint = noop,
    SetClampedToScreen = noop,
    SetMovable = noop,
    EnableMouse = noop,
    RegisterForDrag = noop,
    SetScript = noop,
    SetFrameStrata = noop,
    SetScale = noop,
    Show = noop,
    CreateFontString = function()
        return label
    end,
    HookScript = function(_, name, handler)
        windowScripts[name] = handler
    end,
    Hide = function()
        if windowScripts.OnHide then
            windowScripts.OnHide()
        end
    end,
}
api.UIParent = {
    GetWidth = function()
        return 660
    end,
    GetHeight = function()
        return 420
    end,
}
api.CreateFrame = function(kind, _, _, template)
    if kind == "ScrollFrame" then
        assert(template == "DungeonsAnalyticsDiagnosticScrollTemplate")
        return { CharCount = { Hide = noop }, EditBox = editor, SetPoint = noop, SetVerticalScroll = noop }
    end
    assert(template == "BasicFrameTemplateWithInset")
    windowsCreated = windowsCreated + 1
    return window
end

slash("diag export")
assert(focused and highlighted and reportText:find("Dungeons Analytics", 1, true))
local firstReport = reportText
editorScripts.OnEscapePressed()
assert(not focused)
slash("diag snapshot")
slash("diag export")
assert(windowsCreated == 1 and focused and reportText ~= firstReport)
window:Hide()
assert(not focused)
slash("diag stop")
assert(api.DungeonsAnalyticsDiagnosticsDB.active == false)
print("TOC loading, slash command and native probe tests passed")
