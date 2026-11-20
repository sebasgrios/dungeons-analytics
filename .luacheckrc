std = "lua51"
max_line_length = 110
exclude_files = { ".luacheckrc" }

files["addon/**"] = {
    read_globals = { "CreateFrame", "C_AddOns", "C_CombatLog", "C_DamageMeter", "C_Timer", "Enum",
                     "GetBuildInfo", "GetInstanceInfo", "GetLocale", "GetNumSubgroupMembers",
                     "GetTime", "InCombatLockdown", "canaccessvalue", "canaccesstable", "issecretvalue",
                     "UnitClass", "UnitExists", "UnitGUID", "UnitGroupRolesAssigned" },
}
