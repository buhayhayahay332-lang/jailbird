
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplayDebugLogger = require(ReplicatedStorage.Components.ReplayDebugLogger);
local u1 = {};

local function shouldForceRoundReplayMapSpectate(p2, p3) -- Line: 9
    if p3 ~= "Round" then
        return false;
    end;

    if typeof(p2.ShouldForceMapSpectateBeforeRoundReplay) ~= "function" then
        return false;
    end;

    local success, result = pcall(p2.ShouldForceMapSpectateBeforeRoundReplay);
    local v4;

    if success == true then
        v4 = result == true;
    else
        v4 = false;
    end;

    return v4;
end;

local function hasCompletedRoundReplayMapSpectatePrep(p5) -- Line: 21
    if typeof(p5.HasCompletedRoundReplayMapSpectatePrep) ~= "function" then
        return true;
    end;

    local success, result = pcall(p5.HasCompletedRoundReplayMapSpectatePrep);
    local v6;

    if success == true then
        v6 = result == true;
    else
        v6 = false;
    end;

    return v6;
end;

local function prepareRoundReplayMapSpectate(p7, p8) -- Line: 30
    -- upvalues: ReplayDebugLogger (copy)
    local v9;

    if p8 == "Round" and typeof(p7.ShouldForceMapSpectateBeforeRoundReplay) == "function" then
        local success, result = pcall(p7.ShouldForceMapSpectateBeforeRoundReplay);

        if success == true then
            v9 = result == true;
        else
            v9 = false;
        end;
    else
        v9 = false;
    end;

    if v9 ~= true then
        return false;
    end;

    if typeof(p7.SpectateMap) ~= "function" then
        return false;
    end;

    ReplayDebugLogger.Warn("[GameMenu] Force map spectate before round replay");
    p7.SpectateMap();
    local v10;

    if typeof(p7.HasCompletedRoundReplayMapSpectatePrep) == "function" then
        local success, result = pcall(p7.HasCompletedRoundReplayMapSpectatePrep);

        if success == true then
            v10 = result == true;
        else
            v10 = false;
        end;
    else
        v10 = true;
    end;

    if v10 == true then
        ReplayDebugLogger.Warn("[GameMenu] Map spectate ready for round replay");

        return true;
    end;

    local v11 = os.clock() + (tonumber(p7.RoundReplayMapSpectatePrepTimeout) or 0.35);

    while os.clock() < v11 do
        local v12 = p7.RunService and p7.RunService.Heartbeat;

        if v12 then
            v12:Wait();
        else
            task.wait();
        end;

        local v13;

        if typeof(p7.HasCompletedRoundReplayMapSpectatePrep) == "function" then
            local success, result = pcall(p7.HasCompletedRoundReplayMapSpectatePrep);

            if success == true then
                v13 = result == true;
            else
                v13 = false;
            end;
        else
            v13 = true;
        end;

        if v13 == true then
            ReplayDebugLogger.Warn("[GameMenu] Map spectate ready for round replay");

            return true;
        end;
    end;

    ReplayDebugLogger.Warn("[GameMenu] Map spectate prep timeout before round replay");

    return false;
end;

function u1.DisconnectReplayActorConnection(p14) -- Line: 65
    local v15 = p14.GetReplayActorConnection();

    if v15 then
        v15:Disconnect();
        p14.SetReplayActorConnection(nil);
    end;
end;

function u1.StopReplayKillCam(p16, p17, p18) -- Line: 73
    -- upvalues: u1 (copy)
    u1.DisconnectReplayActorConnection(p16);

    if p16.SpectateObserver and p16.SpectateObserver.Stop then
        p16.SpectateObserver:Stop(p18 or "ReplayStop");
    end;

    if p16.SetReplayStartupSpectateDetachActive then
        p16.SetReplayStartupSpectateDetachActive(false);
    end;

    if p16.SetReplayStartupInProgress then
        p16.SetReplayStartupInProgress(false);
    end;

    p16.SetReplayKillCamAllowMapSpectate(false);
    p16.SetReplayKillCamActive(false);
    p16.SetReplayKillCamStartedAt(0);
    p16.IncrementReplayKillCamToken();
    p16.RestoreReplayIsolation();
    p16.ResetSpectatorHeader();

    if p17 ~= true then
        p16.SetFrameVisible(false);
    end;
end;

local function DestroyToolsInContainer(p19) -- Line: 95
    if not p19 then
        return false;
    end;

    local v20 = false;

    for _, child in ipairs(p19:GetChildren()) do
        if child:IsA("Tool") then
            child:Destroy();
            v20 = true;
        end;
    end;

    return v20;
end;

function u1.CleanupPostRoundReplayPresentation(p21) -- Line: 111
    -- upvalues: DestroyToolsInContainer (copy), ReplayDebugLogger (copy)
    if not p21 or (not p21.ServerFolder or p21.ServerFolder:GetAttribute("Phase") ~= "Round Ended") then
        return false;
    end;

    local v22 = false;
    local Camera = p21.Camera;

    if Camera then
        for _, child in ipairs(Camera:GetChildren()) do
            if child.Name ~= "HeadBase" and (child:IsA("Model") or child:IsA("Folder")) then
                child:Destroy();
                v22 = true;
            end;
        end;
    end;

    local Player = p21.Player;
    local v23;

    if Player then
        v23 = Player.Character;
    else
        v23 = Player;
    end;

    local v24;

    if Player then
        v24 = Player:FindFirstChildOfClass("Backpack");
    else
        v24 = Player;
    end;

    local v25;

    if Player then
        v25 = Player:FindFirstChild("ServerData");
    else
        v25 = Player;
    end;

    if v25 then
        v25 = v25:GetAttribute("Alive") == true;
    end;

    if v23 then
        local ClientWeaponSystem = v23:FindFirstChild("ClientWeaponSystem");

        if ClientWeaponSystem then
            ClientWeaponSystem:Destroy();
            v22 = true;
        end;

        v22 = DestroyToolsInContainer(v23) == true and true or v22;
    end;

    local v26 = DestroyToolsInContainer(v24) == true and true or v22;

    if v26 == true then
        ReplayDebugLogger.Warn("[GameMenu] Cleaned round replay presentation", Player and Player.Name or "", v25);
    end;

    return v26;
end;

function u1.RoutePostReplayKillCam(p27) -- Line: 155
    if p27.ServerFolder:GetAttribute("Phase") == "Round Ended" then
        p27.SpectateMap();

        return;
    end;

    if p27.Player:FindFirstChild("ServerData") and p27.Player.ServerData:GetAttribute("Alive") == true then
        p27.GameMenuCameraSupport.ReleaseMenuCameraToLiveControl(p27.BuildReleaseMenuCameraArgs());

        return;
    end;

    p27.Spectate("Team");
end;

function u1.FinalizeReplayKillCam(p28, p29, p30) -- Line: 165
    -- upvalues: ReplayDebugLogger (copy), u1 (copy)
    if p28.GetReplayKillCamActive() ~= true or p28.GetReplayKillCamToken() ~= p29 then
        return false;
    end;

    ReplayDebugLogger.Warn("[GameMenu] Finalize replay kill cam", p29, p30);
    u1.StopReplayKillCam(p28, false, "ReplayFinalize:" .. tostring(p30));
    u1.CleanupPostRoundReplayPresentation(p28);
    u1.RoutePostReplayKillCam(p28);

    return true;
end;

function u1.StartReplayKillCam(u31, u32, u33, p34, u35) -- Line: 176
    -- upvalues: u1 (copy), prepareRoundReplayMapSpectate (copy), ReplayDebugLogger (copy)
    if u33 == "Player" == true then
        if u31.SetReplayStartupInProgress then
            u31.SetReplayStartupInProgress(true);
        end;

        if u31.CancelPostDeathTransitionForReplay then
            u31.CancelPostDeathTransitionForReplay("PlayerReplayStart");
        end;
    elseif p34 ~= true and u31.QueuePostDeathTransition(function() -- Line: 185
        -- upvalues: u1 (ref), u31 (copy), u32 (copy), u33 (copy)
        u1.StartReplayKillCam(u31, u32, u33, true, true);
    end) then
        return true;
    end;

    if typeof(u32) ~= "table" then
        if u31.SetReplayStartupInProgress then
            u31.SetReplayStartupInProgress(false);
        end;

        return false;
    end;

    local u36 = u31.Players:GetPlayerByUserId(tonumber(u32.KillerUserId) or 0);

    if not u36 then
        if u31.SetReplayStartupInProgress then
            u31.SetReplayStartupInProgress(false);
        end;

        return false;
    end;

    prepareRoundReplayMapSpectate(u31, u33);

    if u31.GetReplayKillCamActive() == true == true then
        u1.StopReplayKillCam(u31, true, "ReplayStartReplacement");
    end;

    local u37 = nil;
    local v53, v54 = xpcall(function() -- Line: 214
        -- upvalues: u31 (copy), u37 (ref), ReplayDebugLogger (ref), u33 (copy), u35 (copy), u36 (copy), u32 (copy), u1 (ref)
        u31.CancelPostDeathTransitionForReplay("ReplayStart");
        u31.SetReplayKillCamAllowMapSpectate(false);
        u31.SetReplayKillCamActive(true);
        u37 = u31.IncrementReplayKillCamToken();
        ReplayDebugLogger.Warn("[GameMenu] Replay kill cam start", u33, u37);
        local v38 = false;

        if u33 == "Round" and u31.ForceShutdownFirstPersonSpectateForReplay then
            v38 = u31.ForceShutdownFirstPersonSpectateForReplay("ReplayStart") == true;
        elseif u33 == "Round" and u31.PrepareReplayStartupSpectateDetach then
            v38 = u31.PrepareReplayStartupSpectateDetach("ReplayStart") == true;
        end;

        if v38 == true then
            if u31.SetReplayStartupSpectateDetachActive then
                u31.SetReplayStartupSpectateDetachActive(true);
            end;
        else
            u31.TeardownLiveSpectateControllers("ReplayStart", true);
        end;

        if u35 ~= true then
            u31.PlayScreenTransition();
        end;

        u31.ClearMenuCameraState();
        u31.ReleaseSpectateMouse();
        u31.ApplySpectateCoreGuiState();
        u31.SetSpectatingPlayer(u36);

        if u33 ~= "Round" then
            u31.SetFrameVisible(true);
            u31.RefreshSpectatorUI();
            u31.SetSpectatorHeader("Replay Kill Cam", Color3.fromRGB(220, 80, 80), false);
        end;

        u31.ApplyReplayIsolation(u32, u33, {
            SuppressUiReveal = u33 == "Round"
        });
        local v39 = u31.ResolveReplayActorRecord and u31.ResolveReplayActorRecord(u36.UserId) or nil;
        local v40 = v39 and v39.Model or nil;

        if u33 == "Round" and not v40 then
            ReplayDebugLogger.Warn("[GameMenu] Replay killer clone missing for observer startup", u36.UserId, u37);
        end;

        u31.Camera.CameraType = Enum.CameraType.Scriptable;
        u31.Camera.CameraSubject = nil;
        u31.Camera.FieldOfView = u31.DefaultFOV;
        u31.Player.CameraMinZoomDistance = 0.5;
        u31.Player.CameraMaxZoomDistance = 0.5;

        if u33 ~= "Round" then
            u31.UpdateSpectateUI(u36);
        end;

        local v41 = tonumber(u32.Duration) or 0;
        local u42 = math.max(v41, 0);
        local v43 = tonumber(u32.ReplayStartTime) or 0;
        local v44;

        if v43 > 0 then
            local v45 = workspace:GetServerTimeNow() - v43;
            local v46 = math.max(v45, 0);
            v44 = math.min(v46, u42);
        else
            v44 = 0;
        end;

        local v47 = u31.SpectateObserver:StartReplay(u36, u32, function() -- Line: 267
            -- upvalues: ReplayDebugLogger (ref), u37 (ref), u1 (ref), u31 (ref)
            ReplayDebugLogger.Warn("[GameMenu] Replay observer finished", u37);
            u1.FinalizeReplayKillCam(u31, u37, "observer-finished");
        end, {
            ReplayCameraOnly = true,
            InitialPlaybackTime = v44,
            TargetCharacter = v40
        });
        local v48 = u31.SpectateObserver.GetReplayDebugState and u31.SpectateObserver:GetReplayDebugState() or nil;

        if v47 ~= true then
            error("Replay observer failed to start");
        end;

        if typeof(v48) ~= "table" or (v48.ReplayStartValidated ~= true or (v48.ReplayRenderActive ~= true or v48.ReplayFirstSampleApplied ~= true)) then
            error("Replay observer did not validate startup");
        end;

        ReplayDebugLogger.Warn("[GameMenu] Replay observer validated", u37);

        if u33 == "Round" then
            if u31.RevealReplayUiState then
                u31.RevealReplayUiState();
            end;

            u31.SetFrameVisible(true);
            u31.RefreshSpectatorUI();
            u31.SetSpectatorHeader("Replay Kill Cam", Color3.fromRGB(220, 80, 80), false);
            u31.UpdateSpectateUI(u36, v40);
        end;

        if u31.SetReplayStartupSpectateDetachActive then
            u31.SetReplayStartupSpectateDetachActive(false);
        end;

        if u31.SetReplayStartupInProgress then
            u31.SetReplayStartupInProgress(false);
        end;

        u1.DisconnectReplayActorConnection(u31);
        u31.SetReplayEventCursor(1);

        if v43 <= 0 then
            v43 = workspace:GetServerTimeNow();
        end;

        u31.SetReplayKillCamStartedAt(v43);
        u31.SetReplayActorConnection(u31.RunService.PreRender:Connect(function() -- Line: 309
            -- upvalues: u31 (ref), u37 (ref), u1 (ref), u32 (ref), u42 (copy), ReplayDebugLogger (ref)
            if u31.GetReplayKillCamActive() ~= true or u31.GetReplayKillCamToken() ~= u37 then
                return;
            end;

            local v49 = u31.SpectateObserver.GetReplayDebugState and u31.SpectateObserver:GetReplayDebugState() or nil;

            if typeof(v49) == "table" and (v49.ReplayClipActive == true and v49.ReplayRenderActive == true) then
                local v50 = workspace:GetServerTimeNow() - u31.GetReplayKillCamStartedAt();
                local v51 = math.max(v50, 0);
                u31.UpdateReplayActors(u32, v51);
                u31.ReplayBarricadeController.Update(v51);
                u31.ReplayThrowableController.Update(v51);
                u31.ProcessReplayEvents(u32, v51);

                if u42 > 0 and u42 + 0.25 <= v51 then
                    ReplayDebugLogger.Warn("[GameMenu] Replay watchdog finalize", u37, v51, u42);
                    u1.FinalizeReplayKillCam(u31, u37, "watchdog-timeout");
                end;

                return;
            end;

            local v52;

            if v49 then
                v52 = v49.ReplayLastLifecycleSource;
            else
                v52 = v49;
            end;

            if v49 then
                v49 = v49.ReplayLastBlockedLifecycleSource;
            end;

            warn("[GameMenu] Replay observer desynced", u37, v52, v49);
            u1.FinalizeReplayKillCam(u31, u37, "observer-desynced");
        end));
    end, debug.traceback);

    if v53 == true then
        return true;
    end;

    warn("[GameMenu] Replay kill cam startup error", u33, v54);

    if u31.SetReplayStartupSpectateDetachActive then
        u31.SetReplayStartupSpectateDetachActive(false);
    end;

    if u31.SetReplayStartupInProgress then
        u31.SetReplayStartupInProgress(false);
    end;

    u31.SetReplayKillCamAllowMapSpectate(false);
    u31.SetReplayKillCamActive(false);
    u31.SetReplayKillCamStartedAt(0);
    u31.IncrementReplayKillCamToken();
    u1.DisconnectReplayActorConnection(u31);
    pcall(function() -- Line: 346
        -- upvalues: u31 (copy)
        u31.RestoreReplayIsolation();
    end);
    pcall(function() -- Line: 349
        -- upvalues: u31 (copy)
        u31.ResetSpectatorHeader();
    end);
    pcall(function() -- Line: 352
        -- upvalues: u31 (copy)
        u31.SetFrameVisible(false);
    end);

    return false;
end;

function u1.BindReplayRemote(u55) -- Line: 361
    -- upvalues: prepareRoundReplayMapSpectate (copy), ReplayDebugLogger (copy)
    local u56 = 0;
    local u57 = 0;

    local function scheduleRoundEndedMapSpectatePrep() -- Line: 365
        -- upvalues: u57 (ref), u55 (copy), prepareRoundReplayMapSpectate (ref)
        u57 = u57 + 1;
        local u58 = u57;

        if u55.ServerFolder:GetAttribute("Phase") ~= "Round Ended" then
            return;
        end;

        task.delay(2, function() -- Line: 372
            -- upvalues: u57 (ref), u58 (copy), u55 (ref), prepareRoundReplayMapSpectate (ref)
            if u57 ~= u58 then
                return;
            end;

            if u55.ServerFolder:GetAttribute("Phase") ~= "Round Ended" then
                return;
            end;

            prepareRoundReplayMapSpectate(u55, "Round");
        end);
    end;

    u55.ServerFolder:GetAttributeChangedSignal("Phase"):Connect(function() -- Line: 383
        -- upvalues: u55 (copy), u57 (ref), prepareRoundReplayMapSpectate (ref)
        if u55.ServerFolder:GetAttribute("Phase") ~= "Round Ended" then
            u57 = u57 + 1;

            return;
        end;

        u57 = u57 + 1;
        local u59 = u57;

        if u55.ServerFolder:GetAttribute("Phase") ~= "Round Ended" then
            return;
        end;

        task.delay(2, function() -- Line: 372
            -- upvalues: u57 (ref), u59 (copy), u55 (ref), prepareRoundReplayMapSpectate (ref)
            if u57 ~= u59 then
                return;
            end;

            if u55.ServerFolder:GetAttribute("Phase") ~= "Round Ended" then
                return;
            end;

            prepareRoundReplayMapSpectate(u55, "Round");
        end);
    end);

    if u55.ServerFolder:GetAttribute("Phase") == "Round Ended" then
        u57 = u57 + 1;
        local u60 = u57;

        if u55.ServerFolder:GetAttribute("Phase") == "Round Ended" then
            task.delay(2, function() -- Line: 372
                -- upvalues: u57 (ref), u60 (copy), u55 (copy), prepareRoundReplayMapSpectate (ref)
                if u57 ~= u60 then
                    return;
                end;

                if u55.ServerFolder:GetAttribute("Phase") ~= "Round Ended" then
                    return;
                end;

                prepareRoundReplayMapSpectate(u55, "Round");
            end);
        end;
    end;

    local function routeReplayFailure(p61) -- Line: 394
        -- upvalues: u55 (copy)
        if u55.SetReplayStartupInProgress then
            u55.SetReplayStartupInProgress(false);
        end;

        u55.StopReplayKillCam(false);

        if p61.Action == "RoundReplayStart" then
            if typeof(u55.SpectateMap) == "function" and u55.ServerFolder:GetAttribute("Phase") == "Round Ended" then
                u55.SpectateMap();
            end;
        elseif p61.Action == "PlayerReplayStart" and typeof(u55.Spectate) == "function" then
            u55.Spectate("Team");
        end;
    end;

    local function handleReplayKillCamPayload(u62) -- Line: 410
        -- upvalues: u55 (copy), ReplayDebugLogger (ref), routeReplayFailure (copy)
        local success, result = pcall(function() -- Line: 411
            -- upvalues: u62 (copy), u55 (ref), ReplayDebugLogger (ref)
            local Clip = u62.Clip;

            if typeof(Clip) == "table" and typeof(u62.StartAt) == "number" then
                Clip = table.clone(Clip);
                Clip.ReplayStartTime = u62.StartAt;
            end;

            if u62.Action == "PlayerReplayStart" then
                if u55.ServerFolder:GetAttribute("Phase") == "Round Ended" then
                    ReplayDebugLogger.Warn("[GameMenu] Block player replay during round ended");

                    return false;
                end;

                if u55.SetReplayStartupInProgress then
                    u55.SetReplayStartupInProgress(true);
                end;

                return u55.StartReplayKillCam(Clip, "Player", true, true);
            end;

            if u62.Action == "RoundReplayStart" then
                return u55.StartReplayKillCam(Clip, "Round", true);
            end;

            if u62.Action ~= "Stop" then
                return false;
            end;

            u55.StopReplayKillCam(false);

            return true;
        end);

        if success == true and result ~= false then
            return;
        end;

        if success == true then
            warn("[GameMenu] Replay kill cam event did not start", u62.Action);
        else
            warn("[GameMenu] Replay kill cam event failed", u62.Action, result);
        end;

        routeReplayFailure(u62);
    end;

    u55.ReplayKillCamRemote.OnClientEvent:Connect(function(u63) -- Line: 448
        -- upvalues: u56 (ref), handleReplayKillCamPayload (copy)
        if typeof(u63) ~= "table" then
            return;
        end;

        u56 = u56 + 1;
        local u64 = u56;

        if u63.Action == "Stop" then
            handleReplayKillCamPayload(u63);

            return;
        end;

        local v65 = (tonumber(u63.StartAt) or 0) - workspace:GetServerTimeNow();
        local v66 = math.max(v65, 0);

        if v66 > 0 then
            task.delay(v66, function() -- Line: 460
                -- upvalues: u56 (ref), u64 (copy), handleReplayKillCamPayload (ref), u63 (copy)
                if u56 ~= u64 then
                    return;
                end;

                handleReplayKillCamPayload(u63);
            end);

            return;
        end;

        handleReplayKillCamPayload(u63);
    end);
end;

return u1;