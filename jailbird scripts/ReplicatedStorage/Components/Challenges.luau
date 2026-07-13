
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
local Leaderboard = require(ReplicatedStorage.Components.Leaderboard);
local u1 = {
    Statuses = {
        Incomplete = "Incomplete",
        Ready = "Ready",
        Claimed = "Claimed"
    },
    TrackFolders = {
        Daily = "DailyChallenges",
        Weekly = "WeeklyChallenges"
    },
    ResetAttributes = {
        Daily = "DailyChallengeResetId",
        Weekly = "WeeklyChallengeResetId"
    },
    DailyDefinitions = { {
            Id = "DailyPlayMatches",
            Title = "Play 2 Matches",
            Type = "Daily",
            Metric = "MatchesPlayed",
            Goal = 2,
            RewardType = "Cash",
            RewardAmount = 250,
            RewardName = "Cash"
        }, {
            Id = "DailyWinRounds",
            Title = "Win 10 Rounds",
            Type = "Daily",
            Metric = "RoundsWon",
            Goal = 10,
            RewardType = "Crate",
            RewardAmount = 1,
            RewardName = "Rookie"
        }, {
            Id = "DailyOpenCrates",
            Title = "Open 5 Crates",
            Type = "Daily",
            Metric = "CratesOpened",
            Goal = 5,
            RewardType = "Crate",
            RewardAmount = 1,
            RewardName = "Regular"
        }, {
            Id = "DailyPlayMinutes",
            Title = "Play 60 Minutes",
            Type = "Daily",
            Metric = "PlayMinutes",
            Goal = 60,
            RewardType = "Crate",
            RewardAmount = 1,
            RewardName = "Regular"
        }, {
            Id = "DailyCompleteAllMissions",
            Title = "Complete All Missions",
            Type = "Daily",
            Metric = "CompleteAllDailyMissions",
            Goal = 4,
            RewardType = "Crate",
            RewardAmount = 1,
            RewardName = "Elite"
        } },
    WeeklyDefinitions = { {
            Id = "WeeklyPlayMatches",
            Title = "Play 35 Matches",
            Type = "Weekly",
            Metric = "MatchesPlayed",
            Goal = 35,
            RewardType = "Cash",
            RewardAmount = 3000,
            RewardName = "Cash"
        }, {
            Id = "WeeklyOpenCrates",
            Title = "Open 40 Crates",
            Type = "Weekly",
            Metric = "CratesOpened",
            Goal = 40,
            RewardType = "Crate",
            RewardAmount = 1,
            RewardName = "Elite"
        }, {
            Id = "WeeklyDealDamage",
            Title = "Deal 6000 Damage",
            Type = "Weekly",
            Metric = "DamageDealt",
            Goal = 6000,
            RewardType = "Crate",
            RewardAmount = 1,
            RewardName = "Elite"
        }, {
            Id = "WeeklyWinRounds",
            Title = "Win 70 Rounds",
            Type = "Weekly",
            Metric = "RoundsWon",
            Goal = 70,
            RewardType = "Credit",
            RewardAmount = 100,
            RewardName = "Credit"
        }, {
            Id = "WeeklyWinMatches",
            Title = "Win 15 Matches",
            Type = "Weekly",
            Metric = "MatchesWon",
            Goal = 15,
            RewardType = "Crate",
            RewardAmount = 1,
            RewardName = "Elite"
        } }
};
u1.DefinitionsByTrack = {
    Daily = u1.DailyDefinitions,
    Weekly = u1.WeeklyDefinitions
};
u1.DefinitionsById = {};

for _, v in pairs(u1.DefinitionsByTrack) do
    for i, v2 in ipairs(v) do
        v2.Order = i;
        u1.DefinitionsById[v2.Id] = v2;
    end;
end;

local function getPlayerData(p2) -- Line: 145
    if p2 then
        p2 = p2:FindFirstChild("PlayerData");
    end;

    return p2;
end;

local function getStatsFolder(p3) -- Line: 149
    if p3 then
        p3 = p3:FindFirstChild("PlayerData");
    end;

    if p3 then
        p3 = p3:FindFirstChild("Stats");
    end;

    return p3;
end;

local function getTrackFolder(p4, p5) -- Line: 154
    -- upvalues: u1 (copy)
    if p4 then
        p4 = p4:FindFirstChild("PlayerData");
    end;

    if p4 then
        return p4:FindFirstChild(u1.TrackFolders[p5]);
    end;

    return nil;
end;

local function getCurrentResetId(p6) -- Line: 163
    -- upvalues: Leaderboard (copy)
    if p6 ~= "Daily" then
        return Leaderboard.GetCurrentWeek();
    end;

    local v7 = (os.time() - 54000) / 86400;

    return math.floor(v7);
end;

local function setChallengeDefinitionAttributes(p8, p9) -- Line: 171
    -- upvalues: u1 (copy)
    p8.Value = p9.Title;
    p8:SetAttribute("Id", p9.Id);
    p8:SetAttribute("Title", p9.Title);
    p8:SetAttribute("Type", p9.Type);
    p8:SetAttribute("Metric", p9.Metric);
    p8:SetAttribute("Goal", p9.Goal);
    p8:SetAttribute("RewardType", p9.RewardType);
    p8:SetAttribute("RewardAmount", p9.RewardAmount);
    p8:SetAttribute("RewardName", p9.RewardName);
    p8:SetAttribute("Order", p9.Order);

    if p8:GetAttribute("Progression") == nil then
        p8:SetAttribute("Progression", 0);
    end;

    if p8:GetAttribute("Status") == nil then
        p8:SetAttribute("Status", u1.Statuses.Incomplete);
    end;
end;

local function createChallenge(p10, p11) -- Line: 192
    -- upvalues: setChallengeDefinitionAttributes (copy)
    local StringValue = Instance.new("StringValue");
    StringValue.Name = p11.Id;
    StringValue.Parent = p10;
    setChallengeDefinitionAttributes(StringValue, p11);

    return StringValue;
end;

local function rebuildTrack(p12, p13) -- Line: 200
    -- upvalues: u1 (copy), setChallengeDefinitionAttributes (copy), getCurrentResetId (copy)
    local v14;

    if p12 then
        v14 = p12:FindFirstChild("PlayerData");
    else
        v14 = p12;
    end;

    local v15;

    if v14 then
        v15 = v14:FindFirstChild(u1.TrackFolders[p13]);
    else
        v15 = nil;
    end;

    if p12 then
        p12 = p12:FindFirstChild("PlayerData");
    end;

    if p12 then
        p12 = p12:FindFirstChild("Stats");
    end;

    local v16 = u1.DefinitionsByTrack[p13];

    if not (v15 and (p12 and v16)) then
        return;
    end;

    v15:ClearAllChildren();

    for _, v in ipairs(v16) do
        local StringValue = Instance.new("StringValue");
        StringValue.Name = v.Id;
        StringValue.Parent = v15;
        setChallengeDefinitionAttributes(StringValue, v);
    end;

    p12:SetAttribute(u1.ResetAttributes[p13], getCurrentResetId(p13));
end;

local function ensureTrack(p17, p18) -- Line: 216
    -- upvalues: u1 (copy), Leaderboard (copy), rebuildTrack (copy), setChallengeDefinitionAttributes (copy)
    local v19;

    if p17 then
        v19 = p17:FindFirstChild("PlayerData");
    else
        v19 = p17;
    end;

    local v20;

    if v19 then
        v20 = v19:FindFirstChild(u1.TrackFolders[p18]);
    else
        v20 = nil;
    end;

    local v21;

    if p17 then
        v21 = p17:FindFirstChild("PlayerData");
    else
        v21 = p17;
    end;

    if v21 then
        v21 = v21:FindFirstChild("Stats");
    end;

    local v22 = u1.DefinitionsByTrack[p18];

    if not (v20 and (v21 and v22)) then
        return;
    end;

    local v23 = v21:GetAttribute(u1.ResetAttributes[p18]);
    local v24;

    if p18 == "Daily" then
        local v25 = (os.time() - 54000) / 86400;
        v24 = math.floor(v25);
    else
        v24 = Leaderboard.GetCurrentWeek();
    end;

    local v26 = v23 ~= v24 and true or (#v20:GetChildren() ~= #v22 and true or false);

    if not v26 then
        for _, v in ipairs(v22) do
            if not v20:FindFirstChild(v.Id) then
                v26 = true;
                break;
            end;
        end;
    end;

    if v26 then
        rebuildTrack(p17, p18);

        return;
    end;

    for _, v in ipairs(v22) do
        local v27 = v20:FindFirstChild(v.Id);

        if v27 then
            setChallengeDefinitionAttributes(v27, v);
        end;
    end;
end;

local function setChallengeReadyIfComplete(p28) -- Line: 254
    -- upvalues: u1 (copy)
    if not p28 then
        return;
    end;

    if (p28:GetAttribute("Progression") or 0) >= (p28:GetAttribute("Goal") or 0) and p28:GetAttribute("Status") == u1.Statuses.Incomplete then
        p28:SetAttribute("Status", u1.Statuses.Ready);
    end;
end;

local function syncCompleteAllDaily(p29) -- Line: 265
    -- upvalues: u1 (copy), setChallengeReadyIfComplete (copy)
    if p29 then
        p29 = p29:FindFirstChild("PlayerData");
    end;

    local v30;

    if p29 then
        v30 = p29:FindFirstChild(u1.TrackFolders.Daily);
    else
        v30 = nil;
    end;

    local v31;

    if v30 then
        v31 = v30:FindFirstChild("DailyCompleteAllMissions");
    else
        v31 = v30;
    end;

    if not (v30 and v31) then
        return;
    end;

    local v32 = 0;

    for _, v in ipairs(u1.DailyDefinitions) do
        if v.Id ~= "DailyCompleteAllMissions" then
            local v33 = v30:FindFirstChild(v.Id);

            if v33 and (v33:GetAttribute("Progression") or 0) >= (v33:GetAttribute("Goal") or 0) then
                v32 = v32 + 1;
            end;
        end;
    end;

    local v34 = v31:GetAttribute("Goal") or 0;
    v31:SetAttribute("Progression", (math.clamp(v32, 0, v34)));
    setChallengeReadyIfComplete(v31);
end;

local function updateChallengeStates(p35) -- Line: 286
    -- upvalues: u1 (copy), setChallengeReadyIfComplete (copy), syncCompleteAllDaily (copy)
    for i, v in pairs(u1.DefinitionsByTrack) do
        local v36;

        if p35 then
            v36 = p35:FindFirstChild("PlayerData");
        else
            v36 = p35;
        end;

        local v37;

        if v36 then
            v37 = v36:FindFirstChild(u1.TrackFolders[i]);
        else
            v37 = nil;
        end;

        if v37 then
            for _, v2 in ipairs(v) do
                setChallengeReadyIfComplete(v37:FindFirstChild(v2.Id));
            end;
        end;
    end;

    syncCompleteAllDaily(p35);
end;

function u1.GetDefinitions(p38) -- Line: 299
    -- upvalues: u1 (copy)
    return u1.DefinitionsByTrack[p38] or {};
end;

function u1.GetChallengeDefinition(p39) -- Line: 303
    -- upvalues: u1 (copy)
    return u1.DefinitionsById[p39];
end;

function u1.RefreshPlayerChallenges(p40) -- Line: 307
    -- upvalues: ensureTrack (copy), updateChallengeStates (copy), Config (copy), u1 (copy)
    ensureTrack(p40, "Daily");
    ensureTrack(p40, "Weekly");
    updateChallengeStates(p40);

    if game.PlaceId == Config.LobbyID then
        u1.AutoClaimReadyChallenges(p40);
    end;
end;

function u1.UpdateMetric(p41, p42, p43) -- Line: 317
    -- upvalues: u1 (copy), updateChallengeStates (copy), Config (copy)
    local v44 = tonumber(p43) or 0;

    if v44 <= 0 then
        return;
    end;

    u1.RefreshPlayerChallenges(p41);

    for i, v in pairs(u1.DefinitionsByTrack) do
        local v45;

        if p41 then
            v45 = p41:FindFirstChild("PlayerData");
        else
            v45 = p41;
        end;

        local v46;

        if v45 then
            v46 = v45:FindFirstChild(u1.TrackFolders[i]);
        else
            v46 = nil;
        end;

        if v46 then
            for _, v2 in ipairs(v) do
                if v2.Metric == p42 then
                    local v47 = v46:FindFirstChild(v2.Id);

                    if v47 and v47:GetAttribute("Status") ~= u1.Statuses.Claimed then
                        local v48 = (v47:GetAttribute("Progression") or 0) + v44;
                        v47:SetAttribute("Progression", (math.clamp(v48, 0, v2.Goal)));
                    end;
                end;
            end;
        end;
    end;

    updateChallengeStates(p41);

    if game.PlaceId == Config.LobbyID then
        u1.AutoClaimReadyChallenges(p41);
    end;
end;

function u1.UpdatePlayChallenge(p49, p50, p51) -- Line: 348
    -- upvalues: u1 (copy)
    u1.UpdateMetric(p49, "MatchesPlayed", 1);
end;

function u1.UpdateChallenge(p52, p53, p54) -- Line: 352
    -- upvalues: u1 (copy), updateChallengeStates (copy), Config (copy)
    local v55 = u1.DefinitionsById[p53];

    if not v55 then
        return;
    end;

    u1.RefreshPlayerChallenges(p52);
    local Type = v55.Type;
    local v56;

    if p52 then
        v56 = p52:FindFirstChild("PlayerData");
    else
        v56 = p52;
    end;

    local v57;

    if v56 then
        v57 = v56:FindFirstChild(u1.TrackFolders[Type]);
    else
        v57 = nil;
    end;

    if v57 then
        v57 = v57:FindFirstChild(p53);
    end;

    if not v57 or v57:GetAttribute("Status") == u1.Statuses.Claimed then
        return;
    end;

    local v58 = (v57:GetAttribute("Progression") or 0) + (tonumber(p54) or 0);
    v57:SetAttribute("Progression", (math.clamp(v58, 0, v55.Goal)));
    updateChallengeStates(p52);

    if game.PlaceId == Config.LobbyID then
        u1.AutoClaimReadyChallenges(p52);
    end;
end;

function u1.CheckCompleted(p59, p60) -- Line: 377
    -- upvalues: u1 (copy), Config (copy)
    u1.RefreshPlayerChallenges(p59);

    if game.PlaceId == Config.LobbyID then
        u1.AutoClaimReadyChallenges(p59);
    end;
end;

function u1.GiveRewards(p61, p62) -- Line: 384
    -- upvalues: u1 (copy), getCurrentResetId (copy), ReplicatedStorage (copy), Config (copy)
    local v63 = u1.DefinitionsById[p62];
    local v64;

    if p61 then
        v64 = p61:FindFirstChild("PlayerData");
    else
        v64 = p61;
    end;

    local v65;

    if v64 then
        v65 = v64:FindFirstChild("Stats");
    else
        v65 = v64;
    end;

    if not (v63 and (v64 and v65)) then
        return;
    end;

    local v66 = nil;
    local v67 = string.format("Challenge_%s_%s", p62, (tostring(getCurrentResetId(v63.Type))));

    if v63.RewardType == "Crate" then
        local Crates = v64:FindFirstChild("Crates");

        if Crates then
            Crates:SetAttribute(v63.RewardName, (Crates:GetAttribute(v63.RewardName) or 0) + v63.RewardAmount);
            ReplicatedStorage.Events.Notification:FireClient(p61, "Result", "Received " .. v63.RewardAmount .. " " .. string.lower(v63.RewardName) .. " crate", 1, 0.03);
            v66 = {
                Type = "Crate",
                ID = v67,
                Name = v63.RewardName,
                Amount = v63.RewardAmount
            };
        end;
    else
        v65:SetAttribute(v63.RewardType, (v65:GetAttribute(v63.RewardType) or 0) + v63.RewardAmount);
        ReplicatedStorage.Events.Notification:FireClient(p61, "Result", "Received " .. v63.RewardAmount .. " " .. v63.RewardType, 1, 0.03);
        v66 = {
            ID = v67,
            Name = v63.RewardType,
            Type = v63.RewardType,
            Amount = v63.RewardAmount
        };
    end;

    if v66 then
        Config.AddItemsLog(p61, v66, true);
        ReplicatedStorage.Events.Action:FireClient(p61, "ItemsLog");
    end;

    v65:SetAttribute("ChallengeCompleted", (v65:GetAttribute("ChallengeCompleted") or 0) + 1);
end;

function u1.AutoClaimReadyChallenges(p68) -- Line: 426
    -- upvalues: Config (copy), u1 (copy)
    if game.PlaceId ~= Config.LobbyID then
        return;
    end;

    for _, v in ipairs({ "Daily", "Weekly" }) do
        local v69;

        if p68 then
            v69 = p68:FindFirstChild("PlayerData");
        else
            v69 = p68;
        end;

        local v70;

        if v69 then
            v70 = v69:FindFirstChild(u1.TrackFolders[v]);
        else
            v70 = nil;
        end;

        local v71 = u1.DefinitionsByTrack[v];

        if v70 then
            for _, v2 in ipairs(v71) do
                local v72 = v70:FindFirstChild(v2.Id);

                if v72 and (v72:GetAttribute("Status") == u1.Statuses.Ready and (v72:GetAttribute("Progression") or 0) >= v2.Goal) then
                    u1.GiveRewards(p68, v2.Id);
                    v72:SetAttribute("Status", u1.Statuses.Claimed);
                end;
            end;
        end;
    end;
end;

function u1.RenewDailyChallenges(p73) -- Line: 448
    -- upvalues: u1 (copy)
    u1.RefreshPlayerChallenges(p73);
end;

return u1;