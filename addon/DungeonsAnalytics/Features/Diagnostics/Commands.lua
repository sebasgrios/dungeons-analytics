local _, addon = ...

local Commands = {}
addon.Commands = Commands

local function reportWidgets(results)
    local lines = {}
    for name, value in pairs(results.widgets) do
        lines[#lines + 1] = name .. " = " .. value
    end
    for name, value in pairs(results.apis) do
        lines[#lines + 1] = name .. " = " .. tostring(value)
    end
    table.sort(lines)
    return table.concat(lines, "\n")
end

function Commands.Bind(api, recorder, native)
    local text = addon.GetMessages(recorder.build.locale)
    local function say(message)
        api.print("Dungeons Analytics — " .. message)
    end

    api.SLASH_DUNGEONSANALYTICS1 = "/da"
    api.SLASH_DUNGEONSANALYTICS2 = "/dungeonsanalytics"
    api.SlashCmdList.DUNGEONSANALYTICS = function(input)
        local command = input:lower():match("^%s*diag%s+(%a+)%s*$")
        if command == "start" then
            say(text[recorder:Start()])
        elseif command == "stop" then
            say(text[recorder:Stop()])
        elseif command == "snapshot" then
            say(text[recorder:Sample()])
        elseif command == "ui" or command == "export" then
            if recorder:Locked() then
                say(text.outOfCombat)
                return
            end
            if command == "export" then
                if not recorder.store then
                    say(text.storeUnavailable)
                elseif not native:Show(text.exportTitle, recorder.store:Export(), text.exportHint, true) then
                    say(text.uiUnavailable)
                end
                return
            end

            local result = native:Inspect()
            if recorder.active then
                recorder:Log("events", "NATIVE_UI", result)
            end
            if not native:Show(text.uiTitle, reportWidgets(result)) then
                say(text.uiUnavailable)
            end
        else
            say(text.help)
            say(recorder.active and text.active or text.inactive)
        end
    end
end
