
local AdService = game:GetService("AdService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {};
local u2 = {
    Enum.AdAvailabilityResult.PlayerIneligible,
    Enum.AdAvailabilityResult.DeviceIneligible,
    Enum.AdAvailabilityResult.PublisherIneligible,
    Enum.AdAvailabilityResult.ExperienceIneligible
};

local function IsIneligible(p3) -- Line: 13
    -- upvalues: u2 (copy)
    for _, v in ipairs(u2) do
        if p3 == v then
            return true;
        end;
    end;

    return false;
end;

function v1.CheckForAds() -- Line: 23
    -- upvalues: AdService (copy), ReplicatedStorage (copy), u2 (copy)
    local success, result = pcall(function() -- Line: 24
        -- upvalues: AdService (ref)
        return AdService:GetAdAvailabilityNowAsync(Enum.AdFormat.RewardedVideo);
    end);

    if not success then
        warn("[RewardedAds] Failed to check ad availability:", result);

        return false;
    end;

    if not (result and result.AdAvailabilityResult) then
        warn("[RewardedAds] Invalid ad availability result.");

        return false;
    end;

    if result.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable then
        ReplicatedStorage.Events.Action:FireServer("DailyAdvertisementWatch");

        return true;
    end;

    local AdAvailabilityResult = result.AdAvailabilityResult;
    local v4 = false;

    for _, v in ipairs(u2) do
        if AdAvailabilityResult == v then
            v4 = true;
            break;
        end;
    end;

    if v4 then
        warn("[RewardedAds] Ineligible:", result.AdAvailabilityResult);

        return false;
    end;

    warn("[RewardedAds] Not available:", result.AdAvailabilityResult);

    return false;
end;

return v1;