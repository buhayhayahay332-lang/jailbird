
local v1 = {};
local v2 = { "Cheating", "Hacking", "Abusive", "Trolling", "AFK", "Default" };
local v3 = { "Cheating", "Hacking", "Abusive", "Trolling", "AFK", "Default" };
table.freeze(v2);
table.freeze(v3);
v1.kickReasons = v2;
v1.reportReasons = v3;

return table.freeze(v1);