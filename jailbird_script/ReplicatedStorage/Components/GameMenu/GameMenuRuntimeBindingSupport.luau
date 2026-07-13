
local v1 = {};

local function routePendingDeathSpectate(u2) -- Line: 3
    if u2.ServerData:GetAttribute("Alive") == true then
        return;
    end;

    if u2.IsKillCamActive() == true or u2.IsReplayKillCamActive() == true then
        return;
    end;

    if u2.IsReplayPending and u2.IsReplayPending() == true then
        return;
    end;

    if u2.IsReplayStartupInProgress and u2.IsReplayStartupInProgress() == true then
        return;
    end;

    if u2.GameMenuCameraSupport.HasMenuCameraFrameVisible(u2.GameMenu) == true then
        if u2.QueuePostDeathTransition(function() -- Line: 17
            -- upvalues: u2 (copy)
            u2.SpectateMap();
        end) ~= true then
            u2.SpectateMap();
        end;
    else
        u2.SpectateTeam();
    end;
end;

function v1.BindRuntime(u3) -- Line: 27
    -- upvalues: routePendingDeathSpectate (copy)
    u3.SpawnPlayerRemote.OnClientEvent:Connect(function() -- Line: 28
        -- upvalues: u3 (copy)
        u3.ResetPostDeathTransitionState();
        task.defer(function() -- Line: 30
            -- upvalues: u3 (ref)
            u3.GameMenuCameraSupport.ReleaseMenuCameraToLiveControl(u3.BuildReleaseMenuCameraArgs());
        end);
    end);
    u3.ServerData:GetAttributeChangedSignal("Alive"):Connect(function() -- Line: 35
        -- upvalues: u3 (copy), routePendingDeathSpectate (ref)
        if u3.ServerData:GetAttribute("Alive") == true then
            u3.ResetPostDeathTransitionState();
            task.defer(function() -- Line: 38
                -- upvalues: u3 (ref)
                u3.GameMenuCameraSupport.ReleaseMenuCameraToLiveControl(u3.BuildReleaseMenuCameraArgs());
            end);

            return;
        end;

        u3.ArmPostDeathTransition();
        task.defer(function() -- Line: 43
            -- upvalues: routePendingDeathSpectate (ref), u3 (ref)
            routePendingDeathSpectate(u3);
        end);
    end);

    if u3.IsReplayPending then
        u3.ServerData:GetAttributeChangedSignal("ReplayKillCamPending"):Connect(function() -- Line: 50
            -- upvalues: u3 (copy), routePendingDeathSpectate (ref)
            if u3.IsReplayPending() ~= true then
                task.defer(function() -- Line: 52
                    -- upvalues: routePendingDeathSpectate (ref), u3 (ref)
                    routePendingDeathSpectate(u3);
                end);
            end;
        end);
    end;

    task.delay(1, function() -- Line: 59
        -- upvalues: u3 (copy)
        u3.GameMenuCameraSupport.RefreshMenuCameraSpectateState(u3.BuildMenuCameraSpectateStateArgs());
    end);

    for _, v in ipairs(u3.MenuCameraFrames) do
        u3.GameMenuCameraSupport.BindMenuCameraSpectateState(u3.BuildMenuCameraSpectateStateArgs, v);
    end;

    u3.NotificationFrame:GetPropertyChangedSignal("Visible"):Connect(u3.RefreshNextCrate);
    u3.PlayerStats:GetAttributeChangedSignal(u3.SpectatorRewards.Attributes.Rounds):Connect(u3.RefreshNextCrate);
    u3.PlayerStats:GetAttributeChangedSignal(u3.SpectatorRewards.Attributes.Claims):Connect(u3.RefreshNextCrate);
    u3.PlayerStats:GetAttributeChangedSignal(u3.SpectatorRewards.Attributes.ResetId):Connect(u3.RefreshNextCrate);
    u3.ServerFolder:GetAttributeChangedSignal("GameMode"):Connect(u3.RefreshNextCrate);
    u3.PlayerStats:GetAttributeChangedSignal(u3.SpectatorRewards.Attributes.ClaimSerial):Connect(function() -- Line: 72
        -- upvalues: u3 (copy)
        local v4 = u3.PlayerStats:GetAttribute(u3.SpectatorRewards.Attributes.ClaimSerial) or 0;

        if u3.GetLastSpectatorRewardSerial() < v4 then
            u3.SetLastSpectatorRewardSerial(v4);
            u3.PlaySpectatorRewardNotification();
        end;

        u3.RefreshNextCrate();
    end);
    u3.RefreshNextCrate();
end;

return v1;