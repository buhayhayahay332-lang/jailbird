
local u1 = {
    SpectateModes = {
        FirstPerson = "FirstPerson",
        ThirdPerson = "ThirdPerson"
    },
    PlayerReplayKillCamEnabled = true,
    RoundReplayKillCamEnabled = true
};
u1.GameModes = {
    Casual = {
        DefaultSpectateMode = u1.SpectateModes.FirstPerson
    },
    Ranked = {
        DefaultSpectateMode = u1.SpectateModes.FirstPerson
    },
    Custom = {
        DefaultSpectateMode = u1.SpectateModes.ThirdPerson
    },
    Invasion = {
        DefaultSpectateMode = u1.SpectateModes.ThirdPerson
    },
    Skirmish = {
        DefaultSpectateMode = u1.SpectateModes.ThirdPerson
    }
};

function u1.GetGameModeConfig(p2) -- Line: 19
    -- upvalues: u1 (copy)
    if typeof(p2) == "string" and p2 ~= "" then
        return u1.GameModes[p2];
    end;

    return nil;
end;

function u1.GetDefaultSpectateMode(p3) -- Line: 27
    -- upvalues: u1 (copy)
    local v4 = u1.GetGameModeConfig(p3);

    if v4 and v4.DefaultSpectateMode == u1.SpectateModes.ThirdPerson then
        return u1.SpectateModes.ThirdPerson;
    end;

    return u1.SpectateModes.FirstPerson;
end;

function u1.IsFirstPersonSpectate(p5) -- Line: 36
    -- upvalues: u1 (copy)
    return u1.GetDefaultSpectateMode(p5) == u1.SpectateModes.FirstPerson;
end;

function u1.ResolveSpectateMode(p6, p7) -- Line: 40
    -- upvalues: u1 (copy)
    if p6 ~= "Custom" then
        return u1.GetDefaultSpectateMode(p6);
    end;

    if p7 == true then
        return u1.SpectateModes.FirstPerson;
    end;

    return u1.SpectateModes.ThirdPerson;
end;

function u1.IsReplaySpectateSupported(p8) -- Line: 52
    -- upvalues: u1 (copy)
    return p8 == u1.SpectateModes.FirstPerson;
end;

function u1.ShouldAllowPlayerReplayKillCam(p9) -- Line: 56
    -- upvalues: u1 (copy)
    local v10;

    if u1.PlayerReplayKillCamEnabled == true then
        v10 = u1.IsReplaySpectateSupported(p9);
    else
        v10 = false;
    end;

    return v10;
end;

function u1.ShouldAllowRoundReplayKillCam(p11) -- Line: 60
    -- upvalues: u1 (copy)
    local v12;

    if u1.RoundReplayKillCamEnabled == true then
        v12 = u1.IsReplaySpectateSupported(p11);
    else
        v12 = false;
    end;

    return v12;
end;

function u1.ShouldCaptureReplayData(p13) -- Line: 64
    -- upvalues: u1 (copy)
    if u1.IsReplaySpectateSupported(p13) == true then
        return u1.PlayerReplayKillCamEnabled == true and true or u1.RoundReplayKillCamEnabled == true;
    end;

    return false;
end;

return u1;