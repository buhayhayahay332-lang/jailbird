
local u1 = {};
local u2 = { 3, 9, 20 };
local u3 = {
    Casual = true,
    Ranked = true
};
local u4 = {
    Type = "Crate",
    Name = "Spectator",
    Amount = 1
};
u1.Attributes = {
    ResetId = "SpectatorRewardResetId",
    Rounds = "SpectatorRewardRounds",
    Claims = "SpectatorRewardClaims",
    ClaimSerial = "SpectatorRewardClaimSerial"
};

local function getNumberAttribute(p5, p6) -- Line: 22
    return tonumber(p5:GetAttribute(p6)) or 0;
end;

function u1.GetCurrentResetId() -- Line: 26
    local v7 = (os.time() - 54000) / 86400;

    return math.floor(v7);
end;

function u1.GetMilestones() -- Line: 30
    -- upvalues: u2 (copy)
    return table.clone(u2);
end;

function u1.GetRewardData() -- Line: 34
    -- upvalues: u4 (copy)
    return table.clone(u4);
end;

function u1.IsModeEligible(p8) -- Line: 38
    -- upvalues: u3 (copy)
    return u3[tostring(p8)] == true;
end;

function u1.RefreshStats(p9) -- Line: 42
    -- upvalues: u1 (copy)
    if not p9 then
        return false;
    end;

    local Attributes = u1.Attributes;
    local v10 = u1.GetCurrentResetId();
    local v11;

    if (tonumber(p9:GetAttribute(Attributes.ResetId)) or 0) == v10 then
        v11 = false;
    else
        p9:SetAttribute(Attributes.ResetId, v10);
        p9:SetAttribute(Attributes.Rounds, 0);
        p9:SetAttribute(Attributes.Claims, 0);
        v11 = true;
    end;

    if p9:GetAttribute(Attributes.ClaimSerial) == nil then
        p9:SetAttribute(Attributes.ClaimSerial, 0);
    end;

    if p9:GetAttribute(Attributes.Rounds) == nil then
        p9:SetAttribute(Attributes.Rounds, 0);
    end;

    if p9:GetAttribute(Attributes.Claims) == nil then
        p9:SetAttribute(Attributes.Claims, 0);
    end;

    return v11;
end;

function u1.GetRoundsPlayed(p12) -- Line: 73
    -- upvalues: u1 (copy)
    if not p12 then
        return 0;
    end;

    u1.RefreshStats(p12);

    return tonumber(p12:GetAttribute(u1.Attributes.Rounds)) or 0;
end;

function u1.GetClaimsMade(p13) -- Line: 82
    -- upvalues: u1 (copy)
    if not p13 then
        return 0;
    end;

    u1.RefreshStats(p13);

    return tonumber(p13:GetAttribute(u1.Attributes.Claims)) or 0;
end;

function u1.HasRemainingRewards(p14) -- Line: 91
    -- upvalues: u1 (copy), u2 (copy)
    return u1.GetClaimsMade(p14) < #u2;
end;

function u1.GetNextMilestone(p15) -- Line: 95
    -- upvalues: u1 (copy), u2 (copy)
    return u2[u1.GetClaimsMade(p15) + 1];
end;

function u1.GetRoundsUntilNextReward(p16) -- Line: 100
    -- upvalues: u1 (copy)
    local v17 = u1.GetNextMilestone(p16);

    if not v17 then
        return nil;
    end;

    local v18 = v17 - u1.GetRoundsPlayed(p16);

    return math.max(v18, 0);
end;

function u1.FormatNextRewardText(p19) -- Line: 109
    return p19 == nil and "" or (p19 <= 1 and "x1 Spectator Crate next round" or string.format("x1 Spectator Crate next %d rounds", p19));
end;

function u1.AdvanceRound(p20) -- Line: 121
    -- upvalues: u1 (copy), u2 (copy)
    if not p20 then
        return false, nil;
    end;

    u1.RefreshStats(p20);
    local Attributes = u1.Attributes;
    local v21 = (tonumber(p20:GetAttribute(Attributes.Rounds)) or 0) + 1;
    p20:SetAttribute(Attributes.Rounds, v21);
    local v22 = tonumber(p20:GetAttribute(Attributes.Claims)) or 0;
    local v23 = u2[v22 + 1];

    if not v23 or v21 < v23 then
        return false, nil;
    end;

    local v24 = v22 + 1;
    p20:SetAttribute(Attributes.Claims, v24);
    p20:SetAttribute(Attributes.ClaimSerial, (tonumber(p20:GetAttribute(Attributes.ClaimSerial)) or 0) + 1);

    return true, u1.GetRewardData(), v21, v24;
end;

return u1;