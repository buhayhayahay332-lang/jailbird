
local AnalyticsService = game:GetService("AnalyticsService");
local Players = game:GetService("Players");
local u1 = {
    OnboardingFunnelName = "JBR_Onboarding",
    GameplayFunnelName = "JBR_Gameplay",
    OnboardingSteps = {
        JoinedLobby = 1,
        OpenedCrate = 2,
        QueueMatch = 3,
        MatchFound = 4
    },
    GameplaySteps = {
        JoinedMatch = 1,
        ChooseMap = 2,
        Round1 = 3,
        Round2 = 4,
        Round3 = 5,
        Round4 = 6,
        Round5 = 7,
        Round6 = 8,
        Round7 = 9,
        Round8 = 10,
        Round9 = 11,
        Round10 = 12,
        MatchEnded = 13,
        ChooseReward = 14,
        ReturnLobby = 15
    }
};

local function GetPlayerData(p2) -- Line: 46
    if p2 == nil then
        return nil;
    end;

    return p2:FindFirstChild("PlayerData");
end;

local function GetFunnelServiceFolder(p3) -- Line: 51
    local v4;

    if p3 == nil then
        v4 = nil;
    else
        v4 = p3:FindFirstChild("PlayerData");
    end;

    if v4 == nil then
        return nil;
    end;

    local FunnelService = v4:FindFirstChild("FunnelService");

    if FunnelService == nil then
        FunnelService = Instance.new("Folder");
        FunnelService.Name = "FunnelService";
        FunnelService.Parent = v4;
    end;

    return FunnelService;
end;

local function SafeLogFunnelStep(u5, u6, u7, u8, u9, u10) -- Line: 66
    -- upvalues: Players (copy), AnalyticsService (copy)
    if u5 == nil then
        return false;
    end;

    if u5:IsDescendantOf(Players) == false then
        return false;
    end;

    if typeof(u6) ~= "string" then
        return false;
    end;

    if typeof(u7) ~= "string" then
        return false;
    end;

    if typeof(u8) ~= "number" then
        return false;
    end;

    if typeof(u9) ~= "string" then
        return false;
    end;

    if u10 ~= nil and typeof(u10) ~= "table" then
        u10 = nil;
    end;

    local success, result = pcall(function() -- Line: 78
        -- upvalues: AnalyticsService (ref), u5 (copy), u6 (copy), u7 (copy), u8 (copy), u9 (copy), u10 (ref)
        AnalyticsService:LogFunnelStepEvent(u5, u6, u7, u8, u9, u10);
    end);

    if success ~= false then
        return true;
    end;

    warn("[FunnelService] Failed to log funnel:", u6, u9, result);

    return false;
end;

function u1.LogOnboardingStep(p11, p12, p13) -- Line: 101
    -- upvalues: u1 (copy), SafeLogFunnelStep (copy)
    if p11 == nil then
        return false;
    end;

    if typeof(p12) ~= "string" then
        return false;
    end;

    local v14 = u1.OnboardingSteps[p12];

    if v14 == nil then
        warn("[FunnelService] Invalid onboarding step:", p12);

        return false;
    end;

    local v15;

    if p11 == nil then
        v15 = nil;
    else
        v15 = p11:FindFirstChild("PlayerData");
    end;

    local v16;

    if v15 == nil then
        v16 = nil;
    else
        v16 = v15:FindFirstChild("FunnelService");

        if v16 == nil then
            v16 = Instance.new("Folder");
            v16.Name = "FunnelService";
            v16.Parent = v15;
        end;
    end;

    if v16 == nil then
        return false;
    end;

    local v17 = "Onboarding_" .. p12;

    if v16:GetAttribute(v17) == true then
        return false;
    end;

    local v18 = "Onboarding_" .. tostring(p11.UserId);
    local v19 = SafeLogFunnelStep(p11, u1.OnboardingFunnelName, v18, v14, p12, p13);

    if v19 == true then
        v16:SetAttribute(v17, true);
    end;

    return v19;
end;

function u1.LogGameplayStep(p20, p21, p22, p23) -- Line: 145
    -- upvalues: u1 (copy), SafeLogFunnelStep (copy)
    if p20 == nil then
        return false;
    end;

    if typeof(p21) ~= "string" then
        return false;
    end;

    local v24 = u1.GameplaySteps[p21];

    if v24 == nil then
        warn("[FunnelService] Invalid gameplay step:", p21);

        return false;
    end;

    if p22 == nil then
        p22 = game.JobId;
    end;

    local v25 = tostring(p22);

    return SafeLogFunnelStep(p20, u1.GameplayFunnelName, v25, v24, p21, p23);
end;

return u1;