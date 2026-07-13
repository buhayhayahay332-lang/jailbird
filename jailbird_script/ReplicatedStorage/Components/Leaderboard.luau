
local u1 = {};

local function singaporeDateTimeToUnix(p2, p3, p4, p5, p6, p7) -- Line: 4
    return DateTime.fromUniversalTime(p2, p3, p4, p5, p6, p7).UnixTimestamp - 28800;
end;

u1.LeaderboardPageSize = 30;
u1.WeekDurationSeconds = 604800;
u1.SingaporeUtcOffsetSeconds = 28800;
u1.AllTimeStoreBaseName = "Leaderboard_01";
u1.WeeklyStoreBaseName = "WeeklyLeaderboard_01";
u1.StatScanInterval = 5;
u1.WriteCycleInterval = 5;
u1.WeeklyWriteCycleInterval = 60;
u1.DisplayRefreshInterval = 15;
u1.RolloverPollInterval = 5;
u1.MaxStoredWeeklyEntries = 2;
u1.StartupWriteDelay = 10;
u1.StartupDisplayDelay = 15;
u1.StartupRolloverDelay = 5;
u1.MaxWritesPerCycle = 1;
u1.MaxWritesPerCycleLobby = 1;
u1.MaxWeeklyWritesPerCycle = 1;
u1.MaxWeeklyWritesPerCycleLobby = 3;
u1.OrderedListReserve = 3;
u1.OrderedWriteReserve = 10;
u1.LeaderboardThresholdMargin = 0;
u1.WeekOneStartLabel = "2026-05-15 22:00:00 SGT";
u1.WeeklyResetLabel = "Friday 10:00 PM SGT";
u1.ManualResetAnchorUnix = DateTime.fromUniversalTime(2026, 6, 5, 22, 0, 0).UnixTimestamp - 28800;
u1.ManualResetAnchorLabel = "Recurring weekly start at 10:38 PM SGT";
u1.AllTimeStats = { "Level", "Kills", "RankedRating", "SupportValue", "GameTime" };
u1.WeeklyStats = { "WeeklyKills", "WeeklySupportValue", "WeeklyGameTime" };
u1.WeeklyRewards = { {
        CreditAmount = 500,
        CharmName = "Leaderboard Gold"
    }, {
        CreditAmount = 300,
        CharmName = "Leaderboard Silver"
    }, {
        CreditAmount = 200,
        CharmName = "Leaderboard Bronze"
    } };
u1.SupportRankThresholds = { {
        Name = "S Ranker",
        MinimumValue = 100000
    }, {
        Name = "A Ranker",
        MinimumValue = 50000
    }, {
        Name = "B Ranker",
        MinimumValue = 10000
    }, {
        Name = "C Ranker",
        MinimumValue = 2000
    }, {
        Name = "D Ranker",
        MinimumValue = 500
    }, {
        Name = "E Ranker",
        MinimumValue = 1
    } };

for i = 4, 10 do
    u1.WeeklyRewards[i] = {
        CreditAmount = 100,
        CharmName = ""
    };
end;

for i = 11, u1.LeaderboardPageSize do
    u1.WeeklyRewards[i] = {
        CreditAmount = 50,
        CharmName = ""
    };
end;

local function cloneReward(p8) -- Line: 76
    return p8 ~= nil and {
        CreditAmount = p8.CreditAmount or 0,
        CharmName = p8.CharmName or ""
    } or nil;
end;

function u1.SingaporeDateTimeToUnix(p9, p10, p11, p12, p13, p14) -- Line: 87
    return DateTime.fromUniversalTime(p9, p10, p11, p12, p13, p14).UnixTimestamp - 28800;
end;

u1.WeekOneStartUnix = u1.SingaporeDateTimeToUnix(2026, 5, 15, 22, 0, 0);

function u1.GetNowUnix() -- Line: 93
    return os.time();
end;

function u1.GetWeekAnchorUnix() -- Line: 97
    -- upvalues: u1 (copy)
    if u1.ManualResetAnchorUnix > 0 then
        return u1.ManualResetAnchorUnix;
    end;

    return u1.WeekOneStartUnix;
end;

function u1.GetWeekStartUnix(p15) -- Line: 104
    -- upvalues: u1 (copy)
    local v16 = math.floor(p15);
    local v17 = math.max(1, v16);

    return u1.GetWeekAnchorUnix() + (v17 - 1) * u1.WeekDurationSeconds;
end;

function u1.GetCurrentWeek(p18) -- Line: 109
    -- upvalues: u1 (copy)
    local v19 = p18 or u1.GetNowUnix();
    local v20 = u1.GetWeekAnchorUnix();

    return v19 <= v20 and 1 or math.floor((v19 - v20) / u1.WeekDurationSeconds) + 1;
end;

function u1.IsWeeklyLeaderboardActive(p21) -- Line: 118
    -- upvalues: u1 (copy)
    return (p21 or u1.GetNowUnix()) >= u1.GetWeekAnchorUnix();
end;

function u1.GetCurrentWeekFolderName() -- Line: 122
    -- upvalues: u1 (copy)
    return tostring(u1.GetCurrentWeek());
end;

function u1.GetNextResetUnix(p22) -- Line: 126
    -- upvalues: u1 (copy)
    local v23 = u1.GetCurrentWeek(p22);

    return u1.GetWeekStartUnix(v23 + 1);
end;

function u1.GetSecondsUntilNextReset(p24) -- Line: 131
    -- upvalues: u1 (copy)
    local v25 = u1.GetNextResetUnix(p24);
    local v26 = p24 or u1.GetNowUnix();

    return math.max(0, v25 - v26);
end;

function u1.ClearManualResetAnchor() -- Line: 135
    -- upvalues: u1 (copy)
    u1.ManualResetAnchorUnix = 0;
    u1.ManualResetAnchorLabel = "";
end;

function u1.GetAllTimeStoreName(p27) -- Line: 140
    -- upvalues: u1 (copy)
    return string.format("%s_%s", u1.AllTimeStoreBaseName, p27);
end;

function u1.GetWeeklyStoreName(p28, p29) -- Line: 144
    -- upvalues: u1 (copy)
    return string.format("%s_%s_Week_%d", u1.WeeklyStoreBaseName, p28, p29);
end;

function u1.BuildRewardClaimId(p30, p31, p32) -- Line: 148
    return string.format("%d_%s_%d", p30, p31, p32);
end;

function u1.BuildRewardLogId(p33, p34, p35, p36) -- Line: 152
    return string.format("WeeklyReward_%d_%s_%d_%s", p33, p34, p35, p36);
end;

function u1.GetRewardForPlace(p37) -- Line: 156
    -- upvalues: u1 (copy)
    local v38 = u1.WeeklyRewards[p37];

    return v38 ~= nil and {
        CreditAmount = v38.CreditAmount or 0,
        CharmName = v38.CharmName or ""
    } or nil;
end;

function u1.IsWeeklyStat(p39) -- Line: 160
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1.WeeklyStats) do
        if v == p39 then
            return true;
        end;
    end;

    return false;
end;

function u1.GetDisplayNameForStat(p40) -- Line: 169
    if string.sub(p40, 1, 6) == "Weekly" then
        p40 = string.sub(p40, 7);
    end;

    return p40:gsub("(%l)(%u)", "%1 %2");
end;

function u1.IsSupportStat(p41) -- Line: 177
    return p41 == "SupportValue" and true or p41 == "WeeklySupportValue";
end;

function u1.IsGameTimeStat(p42) -- Line: 181
    return p42 == "GameTime" and true or p42 == "WeeklyGameTime";
end;

function u1.GetSupportRankLabel(p43) -- Line: 185
    -- upvalues: u1 (copy)
    local v44 = math.floor(p43 or 0);
    local v45 = math.max(0, v44);

    for _, v in ipairs(u1.SupportRankThresholds) do
        if v.MinimumValue <= v45 then
            return v.Name;
        end;
    end;

    return "Unranked";
end;

function u1.FormatMinutes(p46) -- Line: 195
    local v47 = math.floor(p46 or 0);
    local v48 = math.max(0, v47);
    local v49 = math.floor(v48 / 60);
    local v50 = v48 % 60;

    if v49 <= 0 then
        return string.format("%dm", v50);
    end;

    if v50 <= 0 then
        return string.format("%dh", v49);
    end;

    return string.format("%dh %dm", v49, v50);
end;

function u1.GetDisplayScoreText(p51, p52) -- Line: 209
    -- upvalues: u1 (copy)
    if u1.IsSupportStat(p51) then
        return u1.GetSupportRankLabel(p52);
    end;

    if u1.IsGameTimeStat(p51) then
        return u1.FormatMinutes(p52);
    end;

    local v53 = math.floor(p52 or 0);
    local v54 = math.max(0, v53);

    return tostring(v54);
end;

function u1.GetCategoryOrder() -- Line: 219
    -- upvalues: u1 (copy)
    local v55 = {};

    for _, v in ipairs(u1.AllTimeStats) do
        table.insert(v55, {
            IsWeekly = false,
            StatName = v
        });
    end;

    for _, v in ipairs(u1.WeeklyStats) do
        table.insert(v55, {
            IsWeekly = true,
            StatName = v
        });
    end;

    return v55;
end;

function u1.GetWriteCap(p56) -- Line: 230
    -- upvalues: u1 (copy)
    if p56 then
        return u1.MaxWritesPerCycleLobby;
    end;

    return u1.MaxWritesPerCycle;
end;

function u1.GetWeeklyWriteCap(p57) -- Line: 237
    -- upvalues: u1 (copy)
    if p57 then
        return u1.MaxWeeklyWritesPerCycleLobby;
    end;

    return u1.MaxWeeklyWritesPerCycle;
end;

function u1.EnsureWeeklyEntry(p58, p59) -- Line: 244
    -- upvalues: u1 (copy)
    local v60 = p59 or u1.GetCurrentWeek();
    local v61 = tostring(v60);
    local v62 = p58:FindFirstChild(v61);

    if v62 == nil then
        v62 = Instance.new("StringValue");
        v62.Name = v61;
        v62.Value = v61;
        v62.Parent = p58;

        for _, v in ipairs(u1.WeeklyStats) do
            v62:SetAttribute(v, 0);
        end;
    end;

    for _, v in ipairs(u1.WeeklyStats) do
        if v62:GetAttribute(v) == nil then
            v62:SetAttribute(v, 0);
        end;
    end;

    return v62;
end;

function u1.TrimWeeklyEntries(p63, p64) -- Line: 264
    -- upvalues: u1 (copy)
    local v65 = {};

    for i = 0, math.max(0, u1.MaxStoredWeeklyEntries - 1) do
        local v66 = math.max(1, p64 - i);
        v65[tostring(v66)] = true;
    end;

    for _, child in ipairs(p63:GetChildren()) do
        if v65[child.Name] ~= true then
            child:Destroy();
        end;
    end;
end;

return u1;