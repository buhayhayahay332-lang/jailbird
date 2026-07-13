
return {
    init = function(p1) -- Line: 4, Name: init
        local Services = p1.Services;
        local Refs = p1.Refs;
        local Modules = p1.Modules;
        local State = p1.State;
        local API = p1.API;
        local Player = Refs.Player;
        local Character = Refs.Character;
        local Humanoid = Refs.Humanoid;
        local Script = Refs.Script;
        local ServerFolder = Refs.ServerFolder;
        local ClientData = State.ClientData;
        local WeaponDataNew = State.WeaponDataNew;
        local Movement = State.Movement;

        local function GetMovement() -- Line: 23
            -- upvalues: Script (copy)
            return Script:GetAttribute("Movement");
        end;

        local function IsWeaponPresentationReady() -- Line: 27
            -- upvalues: Script (copy)
            local v2;

            if Script:GetAttribute("WeaponReady") == true then
                v2 = Script:GetAttribute("SwapInProgress") ~= true;
            else
                v2 = false;
            end;

            return v2;
        end;

        local function SetMovement(p3, p4) -- Line: 31
            -- upvalues: Player (copy), Script (copy), WeaponDataNew (copy)
            local v5 = p4 ~= false;

            if p3 == "Crouching" or p3 == "Proning" then
                if Player.ServerData:GetAttribute("Alive") == true then
                    Script:SetAttribute("Movement", p3);

                    if p3 == "Proning" then
                        WeaponDataNew:SoundCue("Prone", true);

                        return;
                    end;

                    if p3 == "Crouching" then
                        WeaponDataNew:SoundCue("Crouch", true);
                    end;
                end;
            else
                if v5 == true and (p3 == "Standing" or p3 == "Running" and (Script:GetAttribute("Movement") == "Proning" or Script:GetAttribute("Movement") == "Crouching")) then
                    WeaponDataNew:SoundCue("Stand", true);
                end;

                Script:SetAttribute("Movement", p3);
            end;
        end;

        local function GetVestWalkSpeedModifier() -- Line: 64
            -- upvalues: Services (copy), Player (copy)
            local v6 = Services.ReplicatedStorage.Items.Vest:FindFirstChild(Player.PlayerData.Loadout[Player.PlayerData.Settings:GetAttribute("LoadoutName")]:GetAttribute("Vest"));

            return v6 == nil and 0 or (v6:GetAttribute("WalkSpeed") or 0) / 100;
        end;

        local function GetToolWalkSpeedModifier() -- Line: 72
            -- upvalues: Character (copy)
            if not Character then
                return 0;
            end;

            local v7 = Character:FindFirstChildOfClass("Tool");

            if v7 == nil then
                return 0;
            end;

            local v8 = v7:GetAttribute("Weight") or 0;

            if v8 > 4.5 then
                return (v8 - 4.5) / 20 * -1;
            end;

            return v8 >= 2.5 and 0 or (2.5 - v8) / 20;
        end;

        local function IsADSWalkSpeedState(p9) -- Line: 92
            -- upvalues: WeaponDataNew (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;
            local v10;

            if CurrentTool == nil or CurrentTool.Aiming ~= true then
                v10 = false;
            else
                v10 = (p9 == "Walking" or p9 == "Standing") and true or p9 == "Creeping";
            end;

            return v10;
        end;

        local function ResolveMovementSpeedState(p11) -- Line: 99
            -- upvalues: WeaponDataNew (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;
            local v12;

            if CurrentTool == nil or CurrentTool.Aiming ~= true then
                v12 = false;
            else
                v12 = (p11 == "Walking" or p11 == "Standing") and true or p11 == "Creeping";
            end;

            return v12 == true and "Creeping" or p11;
        end;

        local function GetMovementBaseSpeed(p13) -- Line: 106
            -- upvalues: WeaponDataNew (copy), Modules (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;
            local v14;

            if CurrentTool == nil or CurrentTool.Aiming ~= true then
                v14 = false;
            else
                v14 = (p13 == "Walking" or p13 == "Standing") and true or p13 == "Creeping";
            end;

            local v15 = v14 == true and "Creeping" or p13;

            if v15 == "Walking" then
                return Modules.Config.NormalWalkSpeed;
            end;

            if v15 == "Creeping" then
                return Modules.Config.SlowPaceWalkSpeed;
            end;

            if v15 == "Running" then
                return Modules.Config.RunWalkSpeed;
            end;

            if v15 == "Proning" then
                return Modules.Config.ProneWalksSpeed;
            end;

            if v15 == "Crouching" then
                return Modules.Config.CrouchWalkSpeed;
            end;

            return v15 ~= "Standing" and 0 or Modules.Config.NormalWalkSpeed;
        end;

        local function CalculateTargetWalkSpeed(p16) -- Line: 125
            -- upvalues: WeaponDataNew (copy), GetMovementBaseSpeed (copy), GetVestWalkSpeedModifier (copy), Character (copy), Modules (copy), ServerFolder (copy), Player (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;
            local v17;

            if CurrentTool == nil or CurrentTool.Aiming ~= true then
                v17 = false;
            else
                v17 = (p16 == "Walking" or p16 == "Standing") and true or p16 == "Creeping";
            end;

            local v18 = GetMovementBaseSpeed(p16);

            if v18 <= 0 then
                return 0;
            end;

            local v19 = GetVestWalkSpeedModifier();
            local v20;

            if Character then
                local v21 = Character:FindFirstChildOfClass("Tool");

                if v21 == nil then
                    v20 = 0;
                else
                    local v22 = v21:GetAttribute("Weight") or 0;

                    if v22 > 4.5 then
                        v20 = (v22 - 4.5) / 20 * -1;
                    else
                        v20 = v22 >= 2.5 and 0 or (2.5 - v22) / 20;
                    end;
                end;
            else
                v20 = 0;
            end;

            local v23 = v18 + v19 * v18 + v20 * v18;

            if (v17 == true and "Creeping" or p16) == "Creeping" then
                local CurrentTool2 = WeaponDataNew.CurrentTool;
                local v24;

                if CurrentTool2 == nil or CurrentTool2.Aiming ~= true then
                    v24 = false;
                else
                    v24 = (p16 == "Walking" or p16 == "Standing") and true or p16 == "Creeping";
                end;

                if v24 == true then
                    local NormalWalkSpeed = Modules.Config.NormalWalkSpeed;
                    v23 = math.max(v23, (NormalWalkSpeed + v19 * NormalWalkSpeed + v20 * NormalWalkSpeed) * 0.9);
                end;
            end;

            if ServerFolder:GetAttribute("SpeedMode") == true and ServerFolder:GetAttribute("GameMode") == "Custom" then
                v23 = v23 * 2.5;
            end;

            if Character and (Character:GetAttribute("Frost") and Character:GetAttribute("Frost") > 0) then
                v23 = v23 * 0.3;
            end;

            return Player.Team and (Player.Team.Name == ServerFolder:GetAttribute("Attacker") and ServerFolder:GetAttribute("AttackerMovement") == false) and 0 or v23;
        end;

        local function StopWalkSpeedTween() -- Line: 157
            -- upvalues: Movement (copy)
            if Movement.ActiveWalkSpeedTween then
                Movement.ActiveWalkSpeedTween:Cancel();
                Movement.ActiveWalkSpeedTween = nil;
            end;
        end;

        local function TweenWalkSpeed(p25, p26) -- Line: 164
            -- upvalues: Movement (copy), Humanoid (copy), Modules (copy)
            if Movement.ActiveWalkSpeedTween then
                Movement.ActiveWalkSpeedTween:Cancel();
                Movement.ActiveWalkSpeedTween = nil;
            end;

            if p25 <= 0 then
                Humanoid.WalkSpeed = 0;

                return;
            end;

            if p26 == true then
                Humanoid.WalkSpeed = p25 * 0.75;
            end;

            local u27 = Modules.Components.Menu.TweenCreate(Humanoid, {
                WalkSpeed = p25
            }, Enum.EasingStyle.Sine, Movement.MovementStartTweenDuration, false);
            Movement.ActiveWalkSpeedTween = u27;
            u27.Completed:Connect(function() -- Line: 177
                -- upvalues: Movement (ref), u27 (copy)
                if Movement.ActiveWalkSpeedTween == u27 then
                    Movement.ActiveWalkSpeedTween = nil;
                end;
            end);
        end;

        local function UpdateWalkSpeedClient(p28, p29) -- Line: 184
            -- upvalues: Humanoid (copy), ServerFolder (copy), Movement (copy), CalculateTargetWalkSpeed (copy), TweenWalkSpeed (copy)
            if Humanoid.Health > 0 and ServerFolder:GetAttribute("Countdown") <= 0 then
                if Movement.PendingSprintExitActive == true and (Movement.PendingSprintExitMovement ~= nil and (p28 == "Standing" or p28 == "Walking")) then
                    p28 = Movement.PendingSprintExitMovement;
                end;

                local v30 = CalculateTargetWalkSpeed(p28);

                if p28 == "Proning" or (p28 == "Crouching" or p28 == "Freezing") then
                    Humanoid.JumpPower = 0;
                end;

                TweenWalkSpeed(v30, p29 == true);
                Movement.LastAppliedWalkState = p28;
            end;
        end;

        local function GetSprintExitRecoverySettings(p31) -- Line: 273
            if p31 == "Proning" then
                return 0.35, -0.75;
            end;

            return 0.2, -0.25;
        end;

        ClientData.CrouchingHoldTimer = os.clock();
        Script:SetAttribute("IsMoving", false);
        Services.ContentProvider:PreloadAsync({
            WeaponDataNew.Animations.Server.CrouchIdle,
            WeaponDataNew.Animations.Server.CrouchWalk,
            WeaponDataNew.Animations.Server.ProneWalk,
            WeaponDataNew.Animations.Server.ProneIdle
        });
        (function() -- Line: 437, Name: StanceConfig
            -- upvalues: Script (copy), WeaponDataNew (copy), Refs (copy), GetMovement (copy), Movement (copy), ClientData (copy), Modules (copy), Humanoid (copy), API (copy), CalculateTargetWalkSpeed (copy), State (copy), UpdateWalkSpeedClient (copy)
            Script:GetAttributeChangedSignal("Movement"):Connect(function() -- Line: 438
                -- upvalues: WeaponDataNew (ref), Refs (ref), GetMovement (ref), Script (ref), Movement (ref), ClientData (ref), Modules (ref), Humanoid (ref), API (ref), CalculateTargetWalkSpeed (ref), State (ref), UpdateWalkSpeedClient (ref)
                if WeaponDataNew.CurrentTool == nil then
                    return nil;
                end;

                Refs.GameEvents.ChangeMovement:FireServer(GetMovement());
                Refs.GameEvents.Stance:FireServer(Script:GetAttribute("Movement"), Script:GetAttribute("Lean") or 0);

                if Script:GetAttribute("Movement") == "Standing" or Script:GetAttribute("Movement") == "Freezing" then
                    Movement.WasActivelyMoving = false;

                    if Movement.ActiveWalkSpeedTween then
                        Movement.ActiveWalkSpeedTween:Cancel();
                        Movement.ActiveWalkSpeedTween = nil;
                    end;
                end;

                if Script:GetAttribute("Movement") == "Standing" then
                    WeaponDataNew:PlayServerHold();
                    ClientData.CameraY = 0;

                    if Movement.StanceCurrentTween then
                        Movement.StanceCurrentTween:Cancel();
                    end;

                    local TweenCreate = Modules.Components.Menu.TweenCreate;
                    local v32 = {};
                    local v33 = Script:GetAttribute("Lean") or 0;
                    v32.CameraOffset = Vector3.new(v33, ClientData.CameraY, 0);
                    Movement.StanceCurrentTween = TweenCreate(Humanoid, v32, Enum.EasingStyle.Sine, 0.3);
                elseif Script:GetAttribute("Movement") == "Crouching" then
                    WeaponDataNew:PlayServerHold();
                    WeaponDataNew.Animations.Client.Run:Stop(0.12);
                    WeaponDataNew:SoundCue("Run", false);
                    ClientData.CameraY = -1.6;

                    if Movement.StanceCurrentTween then
                        Movement.StanceCurrentTween:Cancel();
                    end;

                    local TweenCreate = Modules.Components.Menu.TweenCreate;
                    local v34 = {};
                    local v35 = Script:GetAttribute("Lean") or 0;
                    v34.CameraOffset = Vector3.new(v35, ClientData.CameraY, 0);
                    Movement.StanceCurrentTween = TweenCreate(Humanoid, v34, Enum.EasingStyle.Sine, 0.3);
                elseif Script:GetAttribute("Movement") == "Proning" then
                    WeaponDataNew:PlayServerHold();
                    WeaponDataNew.Animations.Client.Run:Stop(0.12);
                    WeaponDataNew:SoundCue("Run", false);
                    ClientData.CameraY = -3.25;

                    if Movement.StanceCurrentTween then
                        Movement.StanceCurrentTween:Cancel();
                    end;

                    local TweenCreate = Modules.Components.Menu.TweenCreate;
                    local v36 = {};
                    local v37 = Script:GetAttribute("Lean") or 0;
                    v36.CameraOffset = Vector3.new(v37, ClientData.CameraY, 0);
                    Movement.StanceCurrentTween = TweenCreate(Humanoid, v36, Enum.EasingStyle.Quad, 0.5);
                elseif Script:GetAttribute("Movement") == "Running" and WeaponDataNew.Animations.Client.Run then
                    if ClientData.ForwardMovement ~= 0 then
                        local CurrentTool = WeaponDataNew.CurrentTool;
                        local v38 = Script:GetAttribute("ServerVaultOverride") == true;

                        if API.WeaponAction and API.WeaponAction.AimDownSightRelease then
                            API.WeaponAction.AimDownSightRelease();
                        end;

                        if v38 ~= true then
                            WeaponDataNew:StopServerHold();
                        end;

                        WeaponDataNew.Animations.Client.Run:Play(0.2);
                        WeaponDataNew:SoundCue("Run", true);
                        local v39 = 0.67 / Modules.Config.RunWalkSpeed * CalculateTargetWalkSpeed(GetMovement());
                        WeaponDataNew.Animations.Client.Run:AdjustSpeed(v39);
                        ClientData.CameraY = 0;

                        if Movement.StanceCurrentTween then
                            Movement.StanceCurrentTween:Cancel();
                        end;

                        if (not CurrentTool or CurrentTool.Aiming ~= true) and (API.Presentation and API.Presentation.TweenFOV) then
                            API.Presentation.TweenFOV(State.PlayerSettings:GetAttribute("FieldOfView"), 0.15);
                        end;
                    end;
                elseif Script:GetAttribute("Movement") == "Walking" and WeaponDataNew.Animations.Client.Run then
                    WeaponDataNew.Animations.Client.Run:Stop(0.12);
                    WeaponDataNew:PlayServerHold();
                    WeaponDataNew:SoundCue("Run", false);
                    ClientData.CameraY = 0;

                    if Movement.StanceCurrentTween then
                        Movement.StanceCurrentTween:Cancel();
                    end;

                    local TweenCreate = Modules.Components.Menu.TweenCreate;
                    local v40 = {};
                    local v41 = Script:GetAttribute("Lean") or 0;
                    v40.CameraOffset = Vector3.new(v41, ClientData.CameraY, 0);
                    Movement.StanceCurrentTween = TweenCreate(Humanoid, v40, Enum.EasingStyle.Sine, 0.3);
                end;

                UpdateWalkSpeedClient(GetMovement());

                if API.Presentation and API.Presentation.PushSpectatePresentationState then
                    API.Presentation.PushSpectatePresentationState({
                        Movement = Script:GetAttribute("Movement"),
                        Lean = Script:GetAttribute("Lean") or 0
                    });
                end;
            end);
            Script:GetAttributeChangedSignal("Lean"):Connect(function() -- Line: 503
                -- upvalues: Refs (ref), GetMovement (ref), Script (ref), Movement (ref), Modules (ref), Humanoid (ref), ClientData (ref), API (ref)
                Refs.GameEvents.ChangeMovement:FireServer(GetMovement());
                Refs.GameEvents.Stance:FireServer(Script:GetAttribute("Movement"), Script:GetAttribute("Lean") or 0);

                if Movement.StanceCurrentTween then
                    Movement.StanceCurrentTween:Cancel();
                end;

                local TweenCreate = Modules.Components.Menu.TweenCreate;
                local v42 = {};
                local v43 = Script:GetAttribute("Lean") or 0;
                v42.CameraOffset = Vector3.new(v43, ClientData.CameraY, 0);
                Movement.StanceCurrentTween = TweenCreate(Humanoid, v42, Enum.EasingStyle.Sine, 0.4);

                if API.Presentation and API.Presentation.PushSpectatePresentationState then
                    API.Presentation.PushSpectatePresentationState({
                        Movement = Script:GetAttribute("Movement"),
                        Lean = Script:GetAttribute("Lean") or 0
                    });
                end;
            end);
        end)();
        task.spawn(function() -- Line: 518
            -- upvalues: Script (copy)
            Script:SetAttribute("Movement", "Standing");
        end);

        return {
            GetMovement = GetMovement,
            SetMovement = SetMovement,

            GetLean = function() -- Line: 50, Name: GetLean
                -- upvalues: Script (copy)
                return Script:GetAttribute("Lean") or 0;
            end,

            SetLean = function(p44) -- Line: 54, Name: SetLean
                -- upvalues: Script (copy), WeaponDataNew (copy)
                if Script:GetAttribute("Movement") ~= "Running" and Script:GetAttribute("Movement") ~= "Proning" then
                    Script:SetAttribute("Lean", p44);
                end;

                if p44 == -1 or p44 == 1 then
                    WeaponDataNew:SoundCue("Lean", true);
                end;
            end,

            CalculateTargetWalkSpeed = CalculateTargetWalkSpeed,
            UpdateWalkSpeedClient = UpdateWalkSpeedClient,

            UpdateMovementStartWalkSpeed = function(p45) -- Line: 201, Name: UpdateMovementStartWalkSpeed
                -- upvalues: Humanoid (copy), Movement (copy), UpdateWalkSpeedClient (copy)
                local v46 = Humanoid.MoveDirection.Magnitude > 0.05;

                if Movement.PendingSprintExitActive == true then
                    if v46 == true then
                        UpdateWalkSpeedClient(Movement.PendingSprintExitMovement or "Proning", Movement.WasActivelyMoving == false);
                    elseif Movement.ActiveWalkSpeedTween then
                        Movement.ActiveWalkSpeedTween:Cancel();
                        Movement.ActiveWalkSpeedTween = nil;
                    end;

                    Movement.WasActivelyMoving = v46;

                    return;
                end;

                local v47;

                if p45 == "Standing" then
                    v47 = false;
                else
                    v47 = p45 ~= "Freezing";
                end;

                local v48 = v47 and v46;

                if v48 == true and Movement.WasActivelyMoving == false then
                    UpdateWalkSpeedClient(p45, true);
                elseif v48 == true and Movement.LastAppliedWalkState ~= p45 then
                    UpdateWalkSpeedClient(p45, false);
                elseif v48 == false and (Movement.WasActivelyMoving == true and Movement.ActiveWalkSpeedTween) then
                    Movement.ActiveWalkSpeedTween:Cancel();
                    Movement.ActiveWalkSpeedTween = nil;
                end;

                Movement.WasActivelyMoving = v48;
            end,

            RuntimeMovementStateAnim = function() -- Line: 227, Name: RuntimeMovementStateAnim
                -- upvalues: Character (copy), Movement (copy), Script (copy), WeaponDataNew (copy)
                if Character and Character.PrimaryPart then
                    Movement.IsMoving = (Character.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude > 1;
                    local v49 = Script:GetAttribute("Movement");

                    if Movement.PrevMovementState ~= v49 or Movement.PrevMoving ~= Movement.IsMoving then
                        if Movement.PrevMovementState == "Crouching" and Movement.PrevMovementState ~= v49 then
                            WeaponDataNew.Animations.Server.CrouchIdle:Stop(0.35);
                            WeaponDataNew.Animations.Server.CrouchWalk:Stop(0.35);
                        elseif Movement.PrevMovementState == "Proning" and Movement.PrevMovementState ~= v49 then
                            WeaponDataNew.Animations.Server.ProneIdle:Stop(0.35);
                            WeaponDataNew.Animations.Server.ProneWalk:Stop(0.35);
                        end;

                        if v49 == "Crouching" then
                            if Movement.PrevMoving == false and Movement.IsMoving == true then
                                WeaponDataNew.Animations.Server.CrouchIdle:Stop(0.35);
                            elseif Movement.PrevMoving == true and Movement.IsMoving == false then
                                WeaponDataNew.Animations.Server.CrouchWalk:Stop(0.35);
                            end;
                        elseif v49 == "Proning" then
                            if Movement.PrevMoving == false and Movement.IsMoving == true then
                                WeaponDataNew.Animations.Server.ProneIdle:Stop(0.35);
                            elseif Movement.PrevMoving == true and Movement.IsMoving == false then
                                WeaponDataNew.Animations.Server.ProneWalk:Stop(0.35);
                            end;
                        end;

                        if v49 == "Crouching" and Movement.IsMoving == true then
                            WeaponDataNew.Animations.Server.CrouchWalk:Play(0.35);
                            WeaponDataNew.Animations.Server.CrouchWalk:AdjustSpeed(0.6);
                        elseif v49 == "Crouching" and Movement.IsMoving == false then
                            WeaponDataNew.Animations.Server.CrouchIdle:Play(0.35);
                        elseif v49 == "Proning" and Movement.IsMoving == true then
                            WeaponDataNew.Animations.Server.ProneWalk:Play(0.35);
                        elseif v49 == "Proning" and Movement.IsMoving == false then
                            WeaponDataNew.Animations.Server.ProneIdle:Play(0.35);
                        end;
                    end;

                    Movement.PrevMovementState = v49;
                    Movement.PrevMoving = Movement.IsMoving;
                end;
            end,

            UpdateSprinting = function(p50) -- Line: 286, Name: UpdateSprinting
                -- upvalues: Character (copy), WeaponDataNew (copy), Script (copy), Movement (copy), API (copy), SetMovement (copy), ClientData (copy), Humanoid (copy)
                if not (Character and Character.PrimaryPart) then
                    return;
                end;

                if WeaponDataNew.CurrentTool == nil then
                    return;
                end;

                local v51;

                if Script:GetAttribute("WeaponReady") == true then
                    v51 = Script:GetAttribute("SwapInProgress") ~= true;
                else
                    v51 = false;
                end;

                if v51 ~= true or Character:GetAttribute("Spawning") == true then
                    Movement.PendingSprintExitResumeAt = 0;
                    Movement.PendingSprintExitActive = false;
                    Movement.PendingSprintExitMovement = nil;
                    local v52;

                    if Script:GetAttribute("SwapInProgress") == true == true then
                        v52 = p50 == "Proning" and true or p50 == "Crouching";
                    else
                        v52 = false;
                    end;

                    if v52 ~= true and p50 ~= "Standing" then
                        Script:SetAttribute("Movement", "Standing");
                    end;

                    return;
                end;

                if Character:GetAttribute("Barricading") == true == true then
                    Movement.PendingSprintExitResumeAt = 0;
                    Movement.PendingSprintExitActive = false;
                    Movement.PendingSprintExitMovement = nil;

                    return;
                end;

                local v53 = API.WeaponAction and API.WeaponAction.IsSprintBlockedByHardAction and API.WeaponAction.IsSprintBlockedByHardAction() == true;
                local v54 = API.WeaponAction and API.WeaponAction.IsInspectBlockingSprint and API.WeaponAction.IsInspectBlockingSprint() == true;
                local v55 = v53 == true and true or v54 == true;
                local v56 = (Character.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude > 1;
                local v57 = os.clock();
                local v58 = WeaponDataNew.GetStateFolder and WeaponDataNew:GetStateFolder() or nil;
                local v59 = Script:GetAttribute("ServerVaultOverride") == true;

                if v59 ~= true and v58 then
                    v59 = v58:GetAttribute("VaultActive") == true;
                end;

                if v59 == true and Script:GetAttribute("ServerVaultOverride") ~= true then
                    local v60 = WeaponDataNew.Animations and WeaponDataNew.Animations.Server and WeaponDataNew.Animations.Server.Vault;
                    local v61 = WeaponDataNew.Animations and WeaponDataNew.Animations.Client and WeaponDataNew.Animations.Client.Vault;

                    if v60 then
                        v60 = v60.IsPlaying == true;
                    end;

                    if v61 then
                        v61 = v61.IsPlaying == true;
                    end;

                    if v60 ~= true and v61 ~= true then
                        v59 = false;

                        if v58 and v58:GetAttribute("VaultActive") == true then
                            v58:SetAttribute("VaultActive", false);
                        end;
                    end;
                end;

                if v59 == true then
                    Movement.PendingSprintExitResumeAt = 0;
                    Movement.PendingSprintExitActive = false;
                    Movement.PendingSprintExitMovement = nil;

                    if p50 == "Running" then
                        SetMovement(v56 == true and "Walking" or "Standing");
                    end;

                    return;
                end;

                if p50 == "Proning" or p50 == "Crouching" then
                    if ClientData.RunningHold ~= true or (v56 ~= true or (v53 == true or v54 ~= true)) then
                        if ClientData.RunningHold == true and (v55 ~= true and v56 == true) then
                            if Movement.PendingSprintExitActive ~= true then
                                Movement.PendingSprintExitActive = true;
                                Movement.PendingSprintExitMovement = p50;
                                Movement.PendingSprintExitResumeAt = v57 + (p50 == "Proning" and 0.35 or 0.2);
                                Script:SetAttribute("Movement", "Standing");

                                return;
                            end;
                        else
                            Movement.PendingSprintExitResumeAt = 0;
                            Movement.PendingSprintExitActive = false;
                            Movement.PendingSprintExitMovement = nil;
                        end;

                        return;
                    end;

                    if API.WeaponAction and API.WeaponAction.TryCancelInspectForSprint then
                        API.WeaponAction.TryCancelInspectForSprint();
                    end;

                    Movement.PendingSprintExitResumeAt = 0;
                    Movement.PendingSprintExitActive = false;
                    Movement.PendingSprintExitMovement = nil;

                    return;
                end;

                if Movement.PendingSprintExitActive == true then
                    local PendingSprintExitMovement = Movement.PendingSprintExitMovement;

                    if PendingSprintExitMovement == nil then
                        Movement.PendingSprintExitResumeAt = 0;
                        Movement.PendingSprintExitActive = false;
                        Movement.PendingSprintExitMovement = nil;
                    else
                        if ClientData.RunningHold == true and v55 ~= true then
                            if v56 ~= true then
                                Movement.PendingSprintExitResumeAt = 0;
                                Movement.PendingSprintExitActive = false;
                                Movement.PendingSprintExitMovement = nil;

                                if p50 ~= "Standing" then
                                    Script:SetAttribute("Movement", "Standing");
                                end;

                                return;
                            end;

                            if v57 < Movement.PendingSprintExitResumeAt and (PendingSprintExitMovement == "Proning" and -0.75 or -0.25) > Humanoid.CameraOffset.Y then
                                if p50 ~= "Standing" then
                                    Script:SetAttribute("Movement", "Standing");
                                end;

                                return;
                            end;

                            Movement.PendingSprintExitResumeAt = 0;
                            Movement.PendingSprintExitActive = false;
                            Movement.PendingSprintExitMovement = nil;

                            if Script:GetAttribute("Movement") ~= "Running" and Script:GetAttribute("Movement") ~= "Proning" then
                                Script:SetAttribute("Lean", 0);
                            end;

                            if p50 ~= "Running" then
                                if Script:GetAttribute("Movement") == "Proning" or Script:GetAttribute("Movement") == "Crouching" then
                                    WeaponDataNew:SoundCue("Stand", true);
                                end;

                                Script:SetAttribute("Movement", "Running");
                            end;

                            return;
                        end;

                        Movement.PendingSprintExitResumeAt = 0;
                        Movement.PendingSprintExitActive = false;
                        Movement.PendingSprintExitMovement = nil;
                    end;
                end;

                if v56 == false then
                    if p50 ~= "Standing" then
                        Script:SetAttribute("Movement", "Standing");
                    end;

                    return;
                end;

                if ClientData.RunningHold == true and (v53 ~= true and v54 == true) then
                    if API.WeaponAction and API.WeaponAction.TryCancelInspectForSprint then
                        API.WeaponAction.TryCancelInspectForSprint();
                    end;

                    return;
                end;

                local v62;

                if ClientData.RunningHold == true then
                    v62 = v55 ~= true;
                else
                    v62 = false;
                end;

                if v62 == true then
                    if p50 ~= "Running" then
                        if Script:GetAttribute("Movement") ~= "Running" and Script:GetAttribute("Movement") ~= "Proning" then
                            Script:SetAttribute("Lean", 0);
                        end;

                        if Script:GetAttribute("Movement") == "Proning" or Script:GetAttribute("Movement") == "Crouching" then
                            WeaponDataNew:SoundCue("Stand", true);
                        end;

                        Script:SetAttribute("Movement", "Running");
                    end;
                elseif p50 ~= "Walking" then
                    Script:SetAttribute("Movement", "Walking");
                end;
            end,

            UpdateJumpLock = function(p63) -- Line: 417, Name: UpdateJumpLock
                -- upvalues: WeaponDataNew (copy), Humanoid (copy), Modules (copy)
                if WeaponDataNew.Jumping == true or p63 == "Proning" then
                    Humanoid.JumpPower = 0;

                    return;
                end;

                Humanoid.JumpPower = Modules.Config.JumpPower;
            end,

            UpdateMobileCrouch = function() -- Line: 425, Name: UpdateMobileCrouch
                -- upvalues: Player (copy), ClientData (copy), Script (copy), WeaponDataNew (copy)
                if Player:GetAttribute("OnConsole") ~= true and Player:GetAttribute("OnMobile") ~= true then
                    return;
                end;

                if ClientData.CrouchingHold ~= true then
                    return;
                end;

                if os.clock() - ClientData.CrouchingHoldTimer <= 0.2 then
                    return;
                end;

                if Script:GetAttribute("Movement") == "Proning" then
                    return;
                end;

                ClientData.RunningHold = false;

                if Script:GetAttribute("Movement") ~= "Running" and Script:GetAttribute("Movement") ~= "Proning" then
                    Script:SetAttribute("Lean", 0);
                end;

                if Player.ServerData:GetAttribute("Alive") == true then
                    Script:SetAttribute("Movement", "Proning");
                    WeaponDataNew:SoundCue("Prone", true);
                end;

                ClientData.CrouchingHold = false;
            end,

            GetWalkSpeed = function() -- Line: 534, Name: GetWalkSpeed
                -- upvalues: CalculateTargetWalkSpeed (copy), Script (copy)
                return CalculateTargetWalkSpeed(Script:GetAttribute("Movement"));
            end,

            ResetPendingSprintExitState = function() -- Line: 280, Name: ResetPendingSprintExitState
                -- upvalues: Movement (copy)
                Movement.PendingSprintExitResumeAt = 0;
                Movement.PendingSprintExitActive = false;
                Movement.PendingSprintExitMovement = nil;
            end
        };
    end
};