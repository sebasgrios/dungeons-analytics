local Fixture = {}

local addonPath = "addon/DungeonsAnalytics/"

function Fixture.Load(bootstrap)
    local namespace, manifest = {}, {}
    local file = assert(io.open(addonPath .. "DungeonsAnalytics.toc", "r"))
    for line in file:lines() do
        local path = line:gsub("%s+$", "")
        if path:match("%.lua$") then
            manifest[#manifest + 1] = path
        end
    end
    file:close()
    for _, path in ipairs(manifest) do
        local chunk = assert(loadfile(addonPath .. path))
        if path == "Core/Bootstrap.lua" then
            if bootstrap then
                setfenv(chunk, setmetatable({ _G = bootstrap }, { __index = _G }))
                chunk("DungeonsAnalytics", namespace)
            end
        else
            chunk("DungeonsAnalytics", namespace)
        end
    end
    return namespace, manifest
end

function Fixture.API()
    local function forbidden()
        error("Restricted table accessed")
    end
    local secret = setmetatable({}, { __index = forbidden, __len = forbidden, __tostring = forbidden })
    local restricted = setmetatable({}, { __index = forbidden })
    local names =
        { player = "Sensitive Player", party1 = "Sensitive Match", party2 = "Same", party3 = "Same" }
    local guids =
        { player = "Player-secret-1", party1 = "Player-secret-2", party2 = "Player-3", party3 = "Player-4" }
    local timers = {}
    local api = {
        issecretvalue = function(value)
            return rawequal(value, secret)
        end,
        canaccessvalue = function()
            return true
        end,
        canaccesstable = function(value)
            return not rawequal(value, restricted)
        end,
        GetBuildInfo = function()
            return "1.60.1", "70959", "", 16001
        end,
        GetLocale = function()
            return "esES"
        end,
        GetInstanceInfo = function()
            return "Sensitive Dungeon", "party", 1, "Normal", 5, nil, nil, 33
        end,
        C_CombatLog = {
            IsCombatLogRestricted = function()
                return true
            end,
        },
        GetNumSubgroupMembers = function()
            return 3
        end,
        UnitGUID = function(unit)
            return guids[unit]
        end,
        UnitName = function(unit)
            return names[unit]
        end,
        UnitGroupRolesAssigned = function()
            return "HEALER"
        end,
        UnitClass = function()
            return "Priest", "PRIEST"
        end,
        Enum = {
            DamageMeterType = {
                DamageDone = 0,
                Dps = 1,
                HealingDone = 2,
                Hps = 3,
                Absorbs = 4,
                Interrupts = 5,
                Dispels = 6,
                DamageTaken = 7,
                AvoidableDamageTaken = 8,
                Deaths = 9,
                EnemyDamageTaken = 10,
            },
            DamageMeterSessionType = { Current = 1, Overall = 0 },
        },
    }
    api.now = 100
    api.GetTime = function()
        return api.now
    end
    api.InCombatLockdown = function()
        return api.combat == true
    end
    api.C_Timer = {
        After = function(delay, callback)
            timers[#timers + 1] = { at = api.now + delay, callback = callback }
        end,
    }
    api.Advance = function(delta)
        api.now = api.now + delta
        table.sort(timers, function(a, b)
            return a.at < b.at
        end)
        while timers[1] and timers[1].at <= api.now do
            table.remove(timers, 1).callback()
        end
    end
    api.C_DamageMeter = {
        IsDamageMeterAvailable = function()
            return true
        end,
        GetSessionDurationSeconds = function()
            return 3
        end,
        GetAvailableCombatSessions = function()
            return api.sessions
                or { { sessionID = 17, name = "Sensitive native session", durationSeconds = 3 } }
        end,
        GetCombatSessionFromType = function()
            return api.combat and secret or { combatSources = {}, durationSeconds = 3, totalAmount = 0 }
        end,
        GetCombatSessionFromID = function(_, metric)
            if metric == 2 then
                return {
                    combatSources = {
                        {
                            sourceGUID = guids.player,
                            name = names.player,
                            totalAmount = 42,
                            classFilename = "PRIEST",
                        },
                        secret,
                    },
                    totalAmount = 42,
                    durationSeconds = 3,
                }
            end
            return { combatSources = { { sourceGUID = guids.party1, totalAmount = 0 } }, totalAmount = 0 }
        end,
        GetCombatSessionSourceFromID = function(id, metric, guid)
            assert(not api.combat)
            assert(type(id) == "number" and metric == 2 and guid == guids.player)
            api.drilldowns = (api.drilldowns or 0) + 1
            return {
                totalAmount = 42,
                combatSpells = {
                    {
                        combatSpellDetails = {
                            { unitName = names.player, amount = 12 },
                            { unitName = names.party1, amount = 20 },
                            { unitName = "Same", amount = 10 },
                        },
                    },
                    { combatSpellDetails = { unitName = names.party1, amount = secret } },
                    { combatSpellDetails = restricted },
                },
            }
        end,
        ResetAllCombatSessions = forbidden,
    }
    return api, secret, restricted
end

return Fixture
