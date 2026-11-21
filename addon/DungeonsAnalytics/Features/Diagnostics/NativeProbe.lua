local _, addon = ...

local NativeProbe = {}
NativeProbe.__index = NativeProbe
addon.NativeProbe = NativeProbe

local widgets = {
    { kind = "Frame", template = "ButtonFrameTemplate" },
    { kind = "Frame", template = "BasicFrameTemplateWithInset" },
    { kind = "Frame", template = "InsetFrameTemplate" },
    { kind = "Button", template = "UIPanelButtonTemplate" },
    { kind = "EditBox", template = "SearchBoxTemplate" },
    { kind = "Button", template = "MinimalTabTemplate" },
    { kind = "DropdownButton", template = "WowStyle1DropdownTemplate" },
    { kind = "Frame", template = "WowScrollBoxList" },
    { kind = "EventFrame", template = "MinimalScrollBar" },
}

function NativeProbe.New(api)
    return setmetatable({ api = api }, NativeProbe)
end

function NativeProbe:Inspect()
    if self.result then
        return self.result
    end
    local api = self.api
    local result = { widgets = {}, apis = {} }
    result.apis.Settings = api.Settings and type(api.Settings.RegisterAddOnCategory) == "function" or false
    result.apis.GameTooltip = api.GameTooltip ~= nil
    result.apis.MenuUtil = type(api.MenuUtil) == "table"
    result.apis.ScrollUtil = type(api.ScrollUtil) == "table"
    result.apis.DataProvider = type(api.CreateDataProvider) == "function"
    result.apis.NineSlice = type(api.NineSliceUtil) == "table"
    result.apis.FramePool = type(api.CreateFramePool) == "function"
    result.apis.TexturePool = type(api.CreateTexturePool) == "function"
    if not api.CreateFrame then
        return { widgets = {}, apis = result.apis, state = "unavailable" }
    end

    local ok, holder = pcall(api.CreateFrame, "Frame", nil, api.UIParent)
    if not ok or not holder then
        return { widgets = {}, apis = result.apis, state = "failed" }
    end
    holder:Hide()
    self.holder = holder
    if holder.CreateLine then
        local created, line = pcall(holder.CreateLine, holder, nil, "ARTWORK")
        result.apis.Line = created and line ~= nil
    else
        result.apis.Line = false
    end
    for _, widget in ipairs(widgets) do
        local created, frame = pcall(api.CreateFrame, widget.kind, nil, holder, widget.template)
        result.widgets[widget.template] = created and frame ~= nil and "available" or "failed"
    end
    self.result = result
    return result
end

local reportScrollTemplate = "DungeonsAnalyticsDiagnosticScrollTemplate"

local function drawWindow(self, uiTitle, text, hint, selectText)
    local api = self.api
    if not api.CreateFrame or not api.UIParent then
        return false
    end
    if not self.window then
        local ok, window = pcall(api.CreateFrame, "Frame", nil, api.UIParent, "BasicFrameTemplateWithInset")
        if not ok or not window then
            return false
        end
        window:Hide()
        window:SetSize(640, 400)
        window:SetPoint("CENTER")
        window:SetClampedToScreen(true)
        window:SetMovable(true)
        window:EnableMouse(true)
        window:RegisterForDrag("LeftButton")
        window:SetScript("OnDragStart", window.StartMoving)
        window:SetScript("OnDragStop", window.StopMovingOrSizing)
        window:SetFrameStrata("DIALOG")
        local title = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", 0, -6)
        local note = window:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        note:SetPoint("BOTTOMLEFT", 14, 12)
        note:SetPoint("BOTTOMRIGHT", -14, 12)
        note:SetJustifyH("LEFT")
        local scroll = api.CreateFrame("ScrollFrame", nil, window, reportScrollTemplate)
        scroll:SetPoint("TOPLEFT", 14, -34)
        scroll:SetPoint("BOTTOMRIGHT", -30, 32)
        scroll.CharCount:Hide()
        local editor = scroll.EditBox
        editor:SetWidth(575)
        window:SetScale(math.min(1, api.UIParent:GetWidth() / 660, api.UIParent:GetHeight() / 420))
        window:HookScript("OnHide", function()
            editor:ClearFocus()
        end)
        editor:SetScript("OnEscapePressed", function()
            window:Hide()
        end)
        self.window, self.title, self.note, self.editor, self.scroll = window, title, note, editor, scroll
    end

    self.title:SetText(uiTitle)
    self.note:SetText(hint or "")
    self.editor:SetText(text)
    self.scroll:SetVerticalScroll(0)
    self.window:Show()
    if selectText then
        self.editor:SetFocus()
        self.editor:HighlightText()
    end
    return true
end

function NativeProbe:Show(uiTitle, text, hint, selectText)
    local ok, displayed = pcall(drawWindow, self, uiTitle, text, hint, selectText)
    return ok and displayed
end
