
local u3 = {
    HasMenuCameraFrameVisible = function(p1) -- Line: 3, Name: HasMenuCameraFrameVisible
        if p1 then
            return (p1.PlayersJoining.Visible == true or (p1.MapChoose.Visible == true or p1.MapInfo.Visible == true)) and true or p1.RoundStart.Visible == true;
        end;

        return false;
    end,

    ReleaseMenuCameraToLiveControl = function(p2) -- Line: 14, Name: ReleaseMenuCameraToLiveControl
        if p2.MenuCameraActive ~= true then
            return;
        end;

        if p2.KillCamActive == true then
            return;
        end;

        if p2.ReplayKillCamActive == true then
            return;
        end;

        if p2.HasMenuCameraFrameVisible == true then
            return;
        end;

        if p2.SpectatingPlayer ~= nil then
            return;
        end;

        if p2.IsAlive(p2.Player) ~= true then
            return;
        end;

        local Character = p2.Player.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if not Character then
            return;
        end;

        p2.ClearMenuCameraState();
        p2.StopThirdPersonOrbit();
        p2.StopFreecamIfActive();
        p2.UpdateFirstPersonSpectateTarget(nil);
        p2.SetFirstPersonSpectateCameraActive(false);
        p2.RestoreSpectateCoreGuiState();
        p2.Camera.FieldOfView = p2.DefaultFOV;
        p2.Camera.CameraType = Enum.CameraType.Custom;
        p2.Camera.CameraSubject = Character;
        p2.RestoreThirdPersonSpectateCameraControls();
    end
};

function u3.TryFixMidGameJoinSpectate(p4) -- Line: 38
    -- upvalues: u3 (copy)
    if p4.KillCamActive == true then
        return;
    end;

    if p4.ReplayKillCamActive == true then
        return;
    end;

    if p4.HasMenuCameraFrameVisible == true then
        return;
    end;

    u3.ReleaseMenuCameraToLiveControl(p4);
    local v5 = p4.ServerFolder:GetAttribute("Phase");

    if v5 == "Round Started" then
        if p4.IsAlive(p4.Player) == false then
            p4.Spectate("Team");
        end;
    elseif v5 == "Preparation" and (p4.Player.Team.Name ~= p4.ServerFolder:GetAttribute("Attacker") and p4.IsAlive(p4.Player) == false) then
        p4.Spectate("Team");
    end;
end;

function u3.RefreshMenuCameraSpectateState(p6) -- Line: 57
    -- upvalues: u3 (copy)
    if p6.KillCamActive == true then
        return;
    end;

    if p6.ReplayKillCamActive == true then
        return;
    end;

    if u3.HasMenuCameraFrameVisible(p6.GameMenu) == true then
        p6.SpectateMap();

        return;
    end;

    u3.TryFixMidGameJoinSpectate(p6);
end;

function u3.BindMenuCameraSpectateState(u7, p8) -- Line: 68
    -- upvalues: u3 (copy)
    p8:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 69
        -- upvalues: u3 (ref), u7 (copy)
        u3.RefreshMenuCameraSpectateState(u7());
    end);
end;

return u3;