
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
local u1 = {
    Renovation = {
        Chapter = 1,
        Objective = "Attack",
        Difficulty = 1,
        Scale = 3,
        Lives = 4,
        Description = "These Raiders come to rob. Get rid of them.",
        RewardCash = 200,
        RewardExperience = 500,
        RewardCampaignPoints = 200,
        EnemyName = "Raiders",
        Tag = "RAID",
        Stages = { 1, 2, 3, 4 },
        Objectives = { "Attack", "Attack", "Attack", "Defend" },
        Color = Color3.fromRGB(108, 86, 61)
    },
    Checkpoint = {
        Chapter = 2,
        Objective = "Attack",
        Difficulty = 8,
        Scale = 3,
        Lives = 4,
        Description = "A rival syndicate harbouring in Checkpoint. Eliminate them and show dominance!",
        RewardCash = 400,
        RewardExperience = 1000,
        RewardCampaignPoints = 400,
        EnemyName = "Checkpoint Syndicate",
        Tag = "CS",
        Stages = { 1, 2, 3, 4 },
        Objectives = { "Attack", "Attack", "Attack", "Defend" },
        Color = Color3.fromRGB(160, 60, 60)
    },
    Ascension = {
        Chapter = 3,
        Objective = "Attack",
        Difficulty = 13,
        Scale = 3,
        Lives = 3,
        Description = "Ascension is their territory. They are known to be one of the wealthy clans. Take over their base once and for all.",
        RewardCash = 600,
        RewardExperience = 1500,
        RewardCampaignPoints = 600,
        EnemyName = "Ascension Heroes",
        Tag = "VAL",
        Stages = { 1, 2, 3, 4 },
        Objectives = { "Attack", "Attack", "Attack", "Defend" },
        Color = Color3.fromRGB(20, 180, 150)
    },
    ["Blizzards Keep"] = {
        Chapter = 4,
        Objective = "Attack",
        Difficulty = 18,
        Scale = 3,
        Lives = 3,
        Description = "Fight through the Castle Keepers, known to be some of the toughest opponents around",
        RewardCash = 800,
        RewardExperience = 2000,
        RewardCampaignPoints = 800,
        EnemyName = "Castle Keepers",
        Tag = "CK",
        Stages = { 1, 2, 3, 4 },
        Objectives = { "Attack", "Attack", "Attack", "Defend" },
        Color = Color3.fromRGB(62, 62, 131)
    },
    Airport = {
        Chapter = 5,
        Objective = "Attack",
        Difficulty = 22,
        Scale = 3,
        Lives = 3,
        Description = "You\'ve alerted the airport security, secure and control the zone",
        RewardCash = 1000,
        RewardExperience = 2200,
        RewardCampaignPoints = 1000,
        EnemyName = "Airport Security",
        Tag = "AS",
        Stages = { 1, 2, 3, 4 },
        Objectives = { "Attack", "Attack", "Attack", "Defend" },
        Color = Color3.fromRGB(255, 48, 48)
    },
    Driftline = {
        Chapter = 6,
        Objective = "Attack",
        Difficulty = 28,
        Scale = 3,
        Lives = 4,
        Description = "Pirates have boarded the ship, secure and defend",
        RewardCash = 1250,
        RewardExperience = 2500,
        RewardCampaignPoints = 1100,
        EnemyName = "Pirates",
        Tag = "PR",
        Stages = { 1, 2, 3, 4, 5 },
        Objectives = { "Attack", "Attack", "Attack", "Defend", "Defend" },
        Color = Color3.fromRGB(141, 0, 2)
    }
};

function u1.CalculateCampaignRewards(p2, p3, p4) -- Line: 123
    -- upvalues: u1 (copy), Config (copy)
    local v5 = u1[p2];
    local v6 = Config.RoundToNearest(v5.RewardCash * ((1 + p3) / 2), 50);
    local v7 = math.ceil(v6);
    local v8 = Config.RoundToNearest(v5.RewardExperience * ((1 + p3) / 2), 50);
    local v9 = math.ceil(v8);
    local v10 = Config.RoundToNearest(v5.RewardCampaignPoints * ((1 + p3) / 2), 50);
    local v11 = math.ceil(v10);

    return {
        CashReward = v7,
        ExperienceReward = v9,
        CampaignPointsReward = v11,
        FirstTimeCash = v5.RewardCash * 2,
        FirstTimeExperience = v5.RewardExperience * 2,
        FirstTimeCampaignPoints = v5.RewardCampaignPoints * 2,
        LoseCashReward = v7 * 0.25 * (math.clamp(p4 or 1, 0, 5) / 5),
        LoseExperienceReward = v9 * 0.25 * (math.clamp(p4 or 1, 0, 5) / 5),
        LoseCampaignPointsReward = v11 * 0.25 * (math.clamp(p4 or 1, 0, 5) / 5)
    };
end;

function u1.MatchRewardTracker(p12, p13) -- Line: 148
    local MatchReward = p12.ServerData.MatchReward;

    for i, v in pairs(p13) do
        local v14 = MatchReward:FindFirstChild(i);

        if v14 then
            v14:SetAttribute("Value", v14:GetAttribute("Value") + v);
        else
            local Folder = Instance.new("Folder", MatchReward);
            Folder.Name = i;
            Folder:SetAttribute("Type", "Cash");
            Folder:SetAttribute("Value", v);
        end;
    end;
end;

function u1.GetDifficultyStage(p15, p16) -- Line: 165
    -- upvalues: u1 (copy)
    local v17 = math.clamp(u1[p15].Difficulty + p16 * 10, 0, 100);
    local v18 = "Easy";

    if v17 < 30 then
        return v17, "Easy";
    end;

    if v17 < 60 then
        return v17, "Normal";
    end;

    if v17 < 80 then
        return v17, "Hard";
    end;

    return v17, v18 <= 100 and "Insane" or v18;
end;

function u1.CheckUnlockedCampaign(p19, p20, p21) -- Line: 184
    -- upvalues: u1 (copy)
    local PlayerData = p19:FindFirstChild("PlayerData");

    if not PlayerData then
        return;
    end;

    local CampaignIndex = PlayerData:FindFirstChild("CampaignIndex");

    if not CampaignIndex then
        return;
    end;

    local v22 = u1[p20];

    if not v22 then
        return;
    end;

    if #v22.Stages < p21 then
        return;
    end;

    if v22.Chapter == 1 and p21 == 1 then
        return true;
    end;

    local Chapter = v22.Chapter;

    if p21 <= 1 then
        for i, v in pairs(u1) do
            if typeof(v) == "table" and v.Chapter == Chapter - 1 then
                local v23 = CampaignIndex:FindFirstChild(i);

                if v23 and (v23:GetAttribute(#v.Stages) and v23:GetAttribute(#v.Stages) > 0) then
                    return true;
                end;
            end;
        end;
    else
        local v24 = CampaignIndex:FindFirstChild(p20);

        if v24 and (v24:GetAttribute(p21 - 1) and v24:GetAttribute(p21 - 1) > 0) then
            return true;
        end;
    end;

    local v25 = CampaignIndex:FindFirstChild(p20);

    if not v25 then
        return;
    end;

    local v26 = v25:GetAttribute(p21);

    if v26 ~= nil and v26 >= 1 then
        return true;
    end;
end;

return u1;