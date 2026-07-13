
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Server = ReplicatedStorage.Server;
local Config = require(game.ReplicatedStorage.Config);
local Leaderboard = require(ReplicatedStorage.Components.Leaderboard);
local Challenges = require(ReplicatedStorage.Components.Challenges);
local Map_Cache = game.Workspace:WaitForChild("Map_Cache");
local v20 = {
    AddAccessory = function(p1, p2) -- Line: 12, Name: AddAccessory
        p1.Humanoid:AddAccessory(p2:Clone());
    end,

    AddClothing = function(p3, p4) -- Line: 18, Name: AddClothing
    end,

    SetUpCharacter = function(p5, p6) -- Line: 22, Name: SetUpCharacter
    end,

    UpdatePlayerStats = function(p7, p8, p9) -- Line: 26, Name: UpdatePlayerStats
        -- upvalues: Server (copy), Config (copy), Challenges (copy), Leaderboard (copy)
        if p7 ~= nil then
            if Server:GetAttribute("GameMode") ~= "Custom" and p9 ~= true then
                local Stats = p7.PlayerData.Stats;
                local v10 = Config.CheckPlayerBoostActive(p7, "Cash") and 2 or 1;
                local v11 = Config.CheckPlayerBoostActive(p7, "Experience") and 2 or 1;
                Stats:SetAttribute("Cash", Stats:GetAttribute("Cash") + p8.Cash * v10);
                Stats:SetAttribute("Experience", Stats:GetAttribute("Experience") + p8.Experience * v11);
                Stats:SetAttribute("Kills", Stats:GetAttribute("Kills") + p8.Kills);
                Stats:SetAttribute("Deaths", Stats:GetAttribute("Deaths") + p8.Deaths);
                Stats:SetAttribute("Headshots", Stats:GetAttribute("Headshots") + p8.Headshots);
                Stats:SetAttribute("Damage", Stats:GetAttribute("Damage") + p8.Damage);
                local v12 = Stats:GetAttribute("Kills") or 0;
                local v13 = Stats:GetAttribute("Deaths") or 0;
                Stats:SetAttribute("KDR", v12 / math.max(v13, 1));
                local v14 = (Stats:GetAttribute("KDR") or 0) * 10;
                Stats:SetAttribute("KDRScore", (math.floor(v14)));

                if p8.EventPoints then
                    Stats:SetAttribute("EventPoints", Stats:GetAttribute("EventPoints") + p8.EventPoints);
                end;

                if Server:GetAttribute("GameMode") == "Ranked" then
                    Stats:SetAttribute("RankedKills", Stats:GetAttribute("RankedKills") + p8.Kills);
                    Stats:SetAttribute("RankedDeaths", Stats:GetAttribute("RankedDeaths") + p8.Deaths);
                    Stats:SetAttribute("RankedHeadshots", Stats:GetAttribute("RankedHeadshots") + p8.Headshots);
                    Stats:SetAttribute("RankedDamage", Stats:GetAttribute("RankedDamage") + p8.Damage);
                    local v15 = Stats:GetAttribute("RankedKills") or 0;
                    local v16 = Stats:GetAttribute("RankedDeaths") or 0;
                    Stats:SetAttribute("KDRRanked", v15 / math.max(v16, 1));
                end;

                Challenges.UpdateMetric(p7, "DamageDealt", p8.Damage);
                local v17 = Leaderboard.IsWeeklyLeaderboardActive() == true and Leaderboard.EnsureWeeklyEntry(p7.PlayerData.WeeklyLeaderboard, Leaderboard.GetCurrentWeek());

                if v17 then
                    v17:SetAttribute("WeeklyKills", (v17:GetAttribute("WeeklyKills") or 0) + (p8.Kills or 0));
                end;

                for _, v in pairs({ "Cash", "Experience" }) do
                    local v18 = p7.ServerData.MatchReward:FindFirstChild(v);

                    if v18 == nil then
                        v18 = Instance.new("Folder", p7.ServerData.MatchReward);
                        v18.Name = v;
                        v18:SetAttribute("Type", v);
                        v18:SetAttribute("Value", 0);
                    end;

                    local v19 = Config.CheckPlayerBoostActive(p7, v) and 2 or 1;
                    v18:SetAttribute("Value", v18:GetAttribute("Value") + p8[v] * v19);
                end;
            end;

            local ServerData = p7.ServerData;
            ServerData:SetAttribute("Kills", ServerData:GetAttribute("Kills") + p8.Kills);
            ServerData:SetAttribute("Deaths", ServerData:GetAttribute("Deaths") + p8.Deaths);
            ServerData:SetAttribute("Headshots", ServerData:GetAttribute("Headshots") + p8.Headshots);
            ServerData:SetAttribute("Damage", ServerData:GetAttribute("Damage") + p8.Damage);
            ServerData:SetAttribute("Points", ServerData:GetAttribute("Points") + p8.Points);
        end;
    end
};

local function ShouldIgnoreRoundEndedHumanoidHit(p21) -- Line: 101
    -- upvalues: Server (copy)
    if Server:GetAttribute("Phase") ~= "Round Ended" then
        return false;
    end;

    if p21 == nil or p21.Parent == nil then
        return false;
    end;

    return p21.Parent:FindFirstChild("Humanoid") ~= nil;
end;

function v20.BulletRayCast(p22, p23, p24, p25) -- Line: 112
    -- upvalues: Config (copy), Map_Cache (copy), Server (copy), CollectionService (copy)
    local v26 = {};
    local v27 = Config.RaycastRetryLimit or 12;
    table.insert(p25, Map_Cache);
    local v28 = Config.RegularRayCast(p22, p23, p24, p25);

    if v28 and v28.Instance then
        local v29 = 0;

        while v29 < v27 do
            local v30 = v28 and v28.Instance;

            if v30 then
                local Instance2 = v28.Instance;

                if Server:GetAttribute("Phase") == "Round Ended" and (Instance2 ~= nil and Instance2.Parent ~= nil) then
                    v30 = Instance2.Parent:FindFirstChild("Humanoid") ~= nil;
                else
                    v30 = false;
                end;
            end;

            if not v28 or (not v28.Instance or v28.Instance.Transparency < 1 and (not CollectionService:HasTag(v28.Instance, "IgnoreBullet") and (v28.Instance.Name ~= "Glass_Breakable" and not v30))) then
                break;
            end;

            table.insert(p25, v28.Instance);
            v29 = v29 + 1;

            if v28.Instance.Name == "Glass_Breakable" then
                table.insert(v26, {
                    Instance = v28.Instance,
                    Position = v28.Position,
                    Normal = v28.Normal,
                    Material = v28.Material
                });
            end;

            v28 = Config.RegularRayCast(p22, p23, p24, p25);

            if v28 == nil or v28.Instance == nil then
                break;
            end;
        end;
    end;

    if v28 then
        return {
            Instance = v28.Instance,
            Position = v28.Position,
            Normal = v28.Normal,
            Material = v28.Material,
            Distance = v28.Distance
        }, v26;
    end;

    return nil, v26;
end;

function v20.KnifeRayCast(p31, p32, p33, p34) -- Line: 157
    -- upvalues: Config (copy), Map_Cache (copy), CollectionService (copy)
    local v35 = {};
    local v36 = Config.RaycastRetryLimit or 12;
    table.insert(p34, Map_Cache);
    local v37 = Config.RegularRayCast(p31, p32, p33, p34);

    if v37 and v37.Instance then
        local v38 = 0;

        while v38 < v36 and (v37 and (v37.Instance and (v37.Instance.Transparency >= 1 or CollectionService:HasTag(v37.Instance, "IgnoreBullet")))) do
            table.insert(p34, v37.Instance);
            v38 = v38 + 1;
            v37 = Config.RegularRayCast(p31, p32, p33, p34);

            if v37 == nil or v37.Instance == nil then
                break;
            end;
        end;
    end;

    if v37 then
        return {
            Instance = v37.Instance,
            Position = v37.Position,
            Normal = v37.Normal,
            Material = v37.Material,
            Distance = v37.Distance
        }, v35;
    end;

    return nil, v35;
end;

function v20.VaultRayCast(p39, p40, p41, p42) -- Line: 193
    -- upvalues: Config (copy), Map_Cache (copy), CollectionService (copy)
    local v43 = Config.RegularRayCast(p39, p40, p41, p42);
    table.insert(p42, Map_Cache);

    if v43 and v43.Instance then
        while v43 and (v43.Instance and (v43.Instance.Transparency >= 1 and not CollectionService:HasTag(v43.Instance, "Window"))) do
            table.insert(p42, v43.Instance);
            v43 = Config.RegularRayCast(p39, p40, p41, p42);
        end;
    end;

    return v43 and {
        Instance = v43.Instance,
        Position = v43.Position,
        Normal = v43.Normal,
        Material = v43.Material,
        Distance = v43.Distance
    } or nil;
end;

function v20.ClimbRayCast(p44, p45, p46, p47) -- Line: 219
    -- upvalues: Config (copy), Map_Cache (copy), CollectionService (copy)
    local v48 = Config.RegularRayCast(p44, p45, p46, p47);
    table.insert(p47, Map_Cache);

    if v48 and v48.Instance then
        while v48 and (v48.Instance and (v48.Instance.Transparency >= 1 and not CollectionService:HasTag(v48.Instance, "Climb"))) do
            table.insert(p47, v48.Instance);
            v48 = Config.RegularRayCast(p44, p45, p46, p47);
        end;
    end;

    return v48 and {
        Instance = v48.Instance,
        Position = v48.Position,
        Normal = v48.Normal,
        Material = v48.Material,
        Distance = v48.Distance
    } or nil;
end;

function v20.LaserRayCast(p49, p50, p51, p52) -- Line: 245
    -- upvalues: Config (copy), Map_Cache (copy)
    local v53 = Config.RegularRayCast(p49, p50, p51, p52);
    table.insert(p52, Map_Cache);

    if v53 and v53.Instance then
        local v54 = 0;

        while v54 < 8 and v53.Instance.Transparency >= 1 do
            table.insert(p52, v53.Instance);
            v53 = Config.RegularRayCast(p49, p50, p51, p52);
            v54 = v54 + 1;

            if v53 == nil or v53.Instance == nil then
                break;
            end;
        end;
    end;

    return v53 and {
        Instance = v53.Instance,
        Position = v53.Position,
        Normal = v53.Normal,
        Material = v53.Material,
        Distance = v53.Distance
    } or nil;
end;

function v20.FindHumanoidFromBulletHit(p55) -- Line: 274
    if p55 and p55.Parent then
        return p55.Parent:FindFirstChild("Humanoid");
    end;

    return nil;
end;

return v20;