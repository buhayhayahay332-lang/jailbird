
return {
    init = function(p1) -- Line: 4, Name: init
        local Services = p1.Services;
        local Refs = p1.Refs;
        local Modules = p1.Modules;
        local State = p1.State;
        local API = p1.API;
        local Player = Refs.Player;
        local PlayerGui = Refs.PlayerGui;
        local Character = Refs.Character;
        local Humanoid = Refs.Humanoid;
        local Camera = Refs.Camera;
        local GameEvents = Refs.GameEvents;
        local ServerFolder = Refs.ServerFolder;
        local ClientData = State.ClientData;
        local WeaponDataNew = State.WeaponDataNew;
        local Movement = State.Movement;
        local Runtime = State.Runtime;
        local WeaponAction = State.WeaponAction;
        local Helpers = State.Helpers;

        local function Lerp(p2, p3, p4) -- Line: 30
            return p2 + (p3 - p2) * p4;
        end;

        local function SyncMovement(p5, p6, p7) -- Line: 34
            -- upvalues: Player (copy), ClientData (copy)
            if p6 ~= nil and (p5 ~= Player and (p5.Character and (p5.Character:FindFirstChild("HumanoidRootPart") ~= nil and p5.Character:FindFirstChild("Torso") ~= nil))) then
                local v8 = ClientData.PlayersMovementSyncData[p5];

                if v8 == nil then
                    v8 = {
                        LastReceivedAt = 0,
                        Snapshots = {}
                    };
                    ClientData.PlayersMovementSyncData[p5] = v8;
                end;

                local v9 = os.clock();
                local Snapshots = v8.Snapshots;
                local v10 = {
                    CFrame = p6,
                    Velocity = typeof(p7) == "Vector3" and p7 and p7 or Vector3.new(0, 0, 0),
                    ReceivedAt = v9
                };
                table.insert(Snapshots, v10);
                v8.LastReceivedAt = v9;

                while #Snapshots > 4 do
                    table.remove(Snapshots, 1);
                end;
            end;
        end;

        local function SyncVaultMovement(p11, p12, p13, p14, p15) -- Line: 60
            -- upvalues: Player (copy), ClientData (copy)
            if p11 == Player or (typeof(p12) ~= "CFrame" or typeof(p13) ~= "CFrame") then
                return;
            end;

            if not p11.Character then
                return;
            end;

            local HumanoidRootPart = p11.Character:FindFirstChild("HumanoidRootPart");

            if not HumanoidRootPart then
                return;
            end;

            local v16 = ClientData.PlayersMovementSyncData[p11];

            if v16 == nil then
                v16 = {
                    LastReceivedAt = 0,
                    Snapshots = {}
                };
                ClientData.PlayersMovementSyncData[p11] = v16;
            end;

            local v17 = {
                OriginCFrame = HumanoidRootPart.CFrame,
                StartCFrame = p12,
                EndCFrame = p13
            };
            local v18 = tonumber(p14) or 0.3;
            v17.EntryDuration = math.max(v18, 0.05);
            local v19 = tonumber(p15) or 0.4;
            v17.CrossDuration = math.max(v19, 0.05);
            v17.StartedAt = os.clock();
            v16.Vault = v17;
            v16.Snapshots = {};
            v16.LastReceivedAt = os.clock();
        end;

        local function BuildPredictedMovementCFrame(p20, p21) -- Line: 91
            local v22 = typeof(p20.Velocity) == "Vector3" and (p20.Velocity or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0);

            if p21 <= 0 then
                return p20.CFrame;
            end;

            return p20.CFrame + v22 * p21;
        end;

        local function MovementBobbleEffect() -- Line: 99
            -- upvalues: API (copy), WeaponDataNew (copy), Humanoid (copy), Runtime (copy), Movement (copy), Modules (copy), ClientData (copy)
            local v23 = tick();

            if API.Movement.GetMovement() == "Running" and WeaponDataNew.CurrentTool.Aiming ~= true then
                if Humanoid.MoveDirection.Magnitude > 0 then
                    local v24 = math.cos(v23 * 8) * 0.4;
                    local v25 = math.sin(v23 * 8);
                    local v26 = math.abs(v25) * 0.4;
                    local v27 = Vector3.new(v24, v26, 0);
                    Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(v27, 0.25);
                    Runtime.BobbleDebounce = true;
                end;
            elseif API.Movement.GetMovement() == "Standing" and Runtime.BobbleDebounce == true then
                if Movement.StanceCurrentTween then
                    Movement.StanceCurrentTween:Cancel();
                end;

                local TweenCreate = Modules.Components.Menu.TweenCreate;
                local v28 = {};
                local v29 = API.Movement.GetLean();
                v28.CameraOffset = Vector3.new(v29, ClientData.CameraY, 0);
                Movement.StanceCurrentTween = TweenCreate(Humanoid, v28, Enum.EasingStyle.Sine, 0.3, false);
                Runtime.BobbleDebounce = false;
            end;
        end;

        local function CanSampleCurrentLaser(p30) -- Line: 118
            -- upvalues: Player (copy), WeaponDataNew (copy), Modules (copy), Character (copy)
            if Player.ServerData:GetAttribute("Alive") ~= true then
                return false;
            end;

            if WeaponDataNew.CurrentTool == nil or WeaponDataNew.CurrentTool.Model == nil then
                return false;
            end;

            if WeaponDataNew.Holster ~= true then
                return false;
            end;

            if Modules.Components.Weapon.HasLaser(WeaponDataNew.CurrentTool.Model) ~= true then
                return false;
            end;

            if WeaponDataNew.CurrentState ~= "Hold" and WeaponDataNew.CurrentState ~= "ADS" then
                return false;
            end;

            if p30 == "Running" then
                return false;
            end;

            if Character:GetAttribute("Barricading") == true then
                return false;
            end;

            return WeaponDataNew.Animations.Client.Climb.IsPlaying ~= true and (WeaponDataNew.Animations.Client.Vault.IsPlaying ~= true and WeaponDataNew.Animations.Client.Barricade.IsPlaying ~= true);
        end;

        local function SampleLocalLaserTarget(p31) -- Line: 146
            -- upvalues: WeaponDataNew (copy), Runtime (copy), Modules (copy), CanSampleCurrentLaser (copy), PlayerGui (copy), Camera (copy), Character (copy)
            local v32 = WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Model or nil;

            if Runtime.ActiveLocalLaserWeaponModel and Runtime.ActiveLocalLaserWeaponModel ~= v32 then
                Modules.Components.Weapon.SetExtraTarget(Runtime.ActiveLocalLaserWeaponModel, nil);
                Runtime.ActiveLocalLaserWeaponModel = nil;
            end;

            if CanSampleCurrentLaser(p31) ~= true or v32 == nil then
                Runtime.SampledLaserTarget = nil;

                if v32 then
                    Modules.Components.Weapon.SetExtraTarget(v32, nil);
                end;

                return nil;
            end;

            local AbsoluteSize = PlayerGui.Crosshair.AbsoluteSize;
            local v33 = Camera:ViewportPointToRay(AbsoluteSize.X * 0.5, AbsoluteSize.Y * 0.5, 0);
            local v34 = Modules.Components.Player.LaserRayCast(v33.Origin, v33.Direction, Runtime.LaserSampleDistance, {
                Character,
                Camera,
                WeaponDataNew.CameraModel,
                v32
            });

            if v34 and v34.Position then
                Runtime.SampledLaserTarget = v34.Position;
            else
                Runtime.SampledLaserTarget = v33.Origin + v33.Direction * Runtime.LaserSampleDistance;
            end;

            Runtime.ActiveLocalLaserWeaponModel = v32;
            Modules.Components.Weapon.SetExtraTarget(v32, Runtime.SampledLaserTarget);

            return Runtime.SampledLaserTarget;
        end;

        local u35 = CFrame.new(0, 0, 0);

        local function HasMeaningfulShoulderRotation(p36) -- Line: 183
            local v37;

            if typeof(p36) == "number" then
                v37 = math.abs(p36) > 0.0001;
            else
                v37 = false;
            end;

            return v37;
        end;

        local function UpdateHeldShoulderRotation(p38) -- Line: 187
            -- upvalues: Runtime (copy)
            local v39;

            if typeof(p38) == "number" then
                v39 = math.abs(p38) > 0.0001;
            else
                v39 = false;
            end;

            if v39 then
                Runtime.LastHeldShoulderRotation = p38;

                return;
            end;

            Runtime.LastHeldShoulderRotation = nil;
        end;

        local function ResolveHeldShoulderC0() -- Line: 195
            -- upvalues: Runtime (copy), u35 (copy)
            local LastHeldShoulderRotation = Runtime.LastHeldShoulderRotation;
            local v40;

            if typeof(LastHeldShoulderRotation) == "number" then
                v40 = math.abs(LastHeldShoulderRotation) > 0.0001;
            else
                v40 = false;
            end;

            if v40 ~= true then
                return u35;
            end;

            local v41 = (math.deg(LastHeldShoulderRotation) + 80) / 160;
            local v42 = math.clamp(-0.5 - v41, -1, -0.5);
            local v43 = math.clamp(v41, 0, 1);
            local v44 = math.deg(LastHeldShoulderRotation);
            local v45 = math.abs(v44) / 80;

            return u35 * CFrame.new(0, v42 * v45, v43 * v45);
        end;

        local function ApplyLocalLookRotationPreview(p46) -- Line: 208
            -- upvalues: Character (copy), Camera (copy), Modules (copy), Runtime (copy), API (copy), ResolveHeldShoulderC0 (copy)
            if not Character then
                return;
            end;

            local Torso = Character:FindFirstChild("Torso");
            local Head = Character:FindFirstChild("Head");
            local v47;

            if Torso then
                v47 = Torso:FindFirstChild("Neck");
            else
                v47 = Torso;
            end;

            local AnimBase = Character:FindFirstChild("AnimBase");

            if AnimBase then
                AnimBase = AnimBase:FindFirstChild("Shoulder");
            end;

            if not (Torso and (Head and (v47 and v47:IsA("Motor6D")))) then
                return;
            end;

            local v48;

            if typeof(p46) == "number" then
                v48 = math.round(p46 / Modules.Config.HeadRotationDecimal) * Modules.Config.HeadRotationDecimal;
            else
                local v49 = -math.asin(Camera.CFrame.LookVector.Y) / Modules.Config.HeadRotationDecimal;
                v48 = math.round(v49) * Modules.Config.HeadRotationDecimal + Runtime.AdditionalRotation;
            end;

            local v50;

            if typeof(v48) == "number" then
                v50 = math.abs(v48) > 0.0001;
            else
                v50 = false;
            end;

            if v50 then
                Runtime.LastHeldShoulderRotation = v48;
            else
                Runtime.LastHeldShoulderRotation = nil;
            end;

            local v51 = Torso.Position + Torso.CFrame.LookVector * math.clamp(v48 / 2.6, -0.5, 0.5);
            local v52 = CFrame.new(v51) + Torso.CFrame.UpVector * 1.5;
            v47.C0 = CFrame.new(Torso.CFrame:ToObjectSpace(v52).Position);
            v47.C1 = CFrame.Angles(v48, 0, 0);

            if AnimBase and AnimBase:IsA("Motor6D") then
                local v53 = API.Movement.GetMovement();
                local v54 = Character:GetAttribute("Barricading") == true;

                if v53 == "Running" or v54 == true then
                    AnimBase.C0 = CFrame.new();
                else
                    AnimBase.C0 = ResolveHeldShoulderC0();
                end;

                AnimBase.C1 = CFrame.new();
            end;
        end;

        local function UpdateLookRotation(p55) -- Line: 245
            -- upvalues: Character (copy), Camera (copy), Modules (copy), Runtime (copy), Helpers (copy), GameEvents (copy)
            if not (Character and (Character.PrimaryPart and Character:FindFirstChild("HumanoidRootPart"))) then
                return;
            end;

            local CFrame2 = Camera.CFrame;
            local v56 = -math.asin(CFrame2.LookVector.Y) / Modules.Config.HeadRotationDecimal;
            local v57 = math.round(v56) * Modules.Config.HeadRotationDecimal + Runtime.AdditionalRotation;
            local CFrame3 = Character.HumanoidRootPart.CFrame;
            local SampledLaserTarget = Runtime.SampledLaserTarget;
            local v58 = SampledLaserTarget ~= nil;
            local v59 = Helpers.HasFirstPersonSpectators();
            local v60 = Modules.GameModes.ShouldCaptureReplayData(Helpers.ResolveCurrentSpectateMode()) == true;
            local Magnitude = (CFrame3.Position - Runtime.PreviousCharacterCFrame.Position).Magnitude;
            local _, v61 = Runtime.PreviousCharacterCFrame:ToEulerAnglesXYZ();
            local _, v62 = CFrame3:ToEulerAnglesXYZ();
            local v63 = math.deg(v62) - math.deg(v61);
            local v64 = math.abs(v63);
            local v65 = v59 == true and true or v60 == true;
            local v66 = v65 and 0.08 or 0.35;
            local Magnitude2 = (CFrame2.Position - Runtime.PreviousSpectateCameraCFrame.Position).Magnitude;
            local v67 = CFrame2.LookVector:Dot(Runtime.PreviousSpectateCameraCFrame.LookVector);
            local v68 = math.clamp(v67, -1, 1);
            local v69 = math.acos(v68);
            local v70 = math.deg(v69);
            local v71 = CFrame2.UpVector:Dot(Runtime.PreviousSpectateCameraCFrame.UpVector);
            local v72 = math.clamp(v71, -1, 1);
            local v73 = math.acos(v72);
            local v74 = math.deg(v73);
            local v75 = v57 ~= Runtime.PreviousRotation;
            local v76 = Runtime.CharacterCFrameDistance <= Magnitude and true or Runtime.CharacterCFrameAngleDifference <= v64;
            local v77 = v58 ~= Runtime.PreviousLaserActive;

            if v77 == false and (SampledLaserTarget and Runtime.PreviousLaserTarget) then
                v77 = (SampledLaserTarget - Runtime.PreviousLaserTarget).Magnitude >= Runtime.LaserTargetSendThreshold;
            end;

            local v78 = os.clock();
            local v79;

            if v75 == true or (v76 == true or v77 == true) then
                v79 = v78 - Runtime.LastLookRotationSend >= Runtime.LookRotationRate;
            else
                v79 = false;
            end;

            local v80 = v59 == true and Runtime.SpectateCameraLookRotationRate or Runtime.ReplaySpectateCameraRate;
            local v81;

            if (v59 == true or v60 == true) and ((((v65 and 0.004 or 0.02) <= Magnitude2 or v66 <= v70) and true or v66 <= v74) == true or v60 == true) then
                v81 = v80 <= v78 - Runtime.LastSpectateCameraSend;
            else
                v81 = false;
            end;

            if v79 ~= true and v81 ~= true then
                return;
            end;

            local v82;

            if v79 == true and (v75 and v57) then
                v82 = v57;
            else
                v82 = nil;
            end;

            local v83;

            if v79 == true and (v76 and CFrame3) then
                v83 = CFrame3;
            else
                v83 = nil;
            end;

            local v84;

            if v79 == true and (v77 and SampledLaserTarget) then
                v84 = SampledLaserTarget;
            else
                v84 = nil;
            end;

            GameEvents.LookRotation:FireServer(v82, v83, Character.PrimaryPart.AssemblyLinearVelocity, v84, v81 == true and CFrame2 and CFrame2 or nil, Camera.FieldOfView);

            if v79 == true then
                Runtime.LastLookRotationSend = v78;
                Runtime.PreviousLaserActive = v58;
                Runtime.PreviousLaserTarget = SampledLaserTarget;

                if v75 then
                    Runtime.PreviousRotation = v57;
                end;

                if v76 then
                    Runtime.PreviousCharacterCFrame = CFrame3;
                end;
            end;

            if v81 == true then
                Runtime.LastSpectateCameraSend = v78;
                Runtime.PreviousSpectateCameraCFrame = CFrame2;
            end;
        end;

        local function UpdateFigure8Arm(p85, p86) -- Line: 306
            -- upvalues: Character (copy), Runtime (copy)
            if not (Character and Character.PrimaryPart) then
                return CFrame.new();
            end;

            local Magnitude = (Character.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude;

            if math.floor(Magnitude) > 0 then
                local v87 = Runtime;
                v87.ArmLerp = v87.ArmLerp + p85 * Magnitude * 1.1;
                Runtime.ArmZ = 1;
                local v88;

                if p86 == "Running" then
                    Runtime.ArmZ = 0;
                    v88 = 0.4;
                else
                    v88 = 0.1;
                end;

                local ArmSin = Runtime.ArmSin;
                Runtime.ArmSin = ArmSin + (math.sin(Runtime.ArmLerp / 2) * Magnitude * v88 - ArmSin) * 0.4;
                local ArmSin2 = Runtime.ArmSin2;
                Runtime.ArmSin2 = ArmSin2 + (math.sin(Runtime.ArmLerp) * Magnitude * v88 - ArmSin2) * 0.4;
            else
                Runtime.ArmLerp = 0;
                local ArmSin = Runtime.ArmSin;
                Runtime.ArmSin = ArmSin + (0 - ArmSin) * 0.3;
                local ArmSin2 = Runtime.ArmSin2;
                Runtime.ArmSin2 = ArmSin2 + (0 - ArmSin2) * 0.3;
            end;

            return CFrame.Angles(math.rad(Runtime.ArmSin2), math.rad(Runtime.ArmSin), (math.rad(Runtime.ArmZ * Runtime.ArmSin2)));
        end;

        local function SetSightReticleSurfaceGuiEnabled(p89, p90) -- Line: 327
            -- upvalues: Runtime (copy)
            if Runtime.LastSightReticleTool ~= p89 then
                if Runtime.LastSightReticleGuis then
                    for _, v in ipairs(Runtime.LastSightReticleGuis) do
                        if v and v.Parent then
                            v.Enabled = false;
                        end;
                    end;
                end;

                Runtime.LastSightReticleTool = p89;
                Runtime.LastSightReticleGuis = nil;
                Runtime.LastSightReticleEnabled = nil;
            end;

            if not p89 then
                return;
            end;

            local LastSightReticleGuis = Runtime.LastSightReticleGuis;

            if LastSightReticleGuis == nil then
                LastSightReticleGuis = {};

                for _, descendant in ipairs(p89:GetDescendants()) do
                    if descendant:IsA("SurfaceGui") and (descendant.Parent and descendant.Parent.Name == "Reticle") then
                        table.insert(LastSightReticleGuis, descendant);
                    end;
                end;

                Runtime.LastSightReticleGuis = LastSightReticleGuis;
            end;

            if Runtime.LastSightReticleEnabled == p90 then
                return;
            end;

            Runtime.LastSightReticleEnabled = p90;

            for _, v in ipairs(LastSightReticleGuis) do
                if v and v.Parent then
                    v.Enabled = p90;
                end;
            end;
        end;

        local function UpdateViewmodel(p91, p92, p93) -- Line: 368
            -- upvalues: WeaponDataNew (copy), Runtime (copy), Humanoid (copy), SetSightReticleSurfaceGuiEnabled (copy), Camera (copy), MovementBobbleEffect (copy), UpdateFigure8Arm (copy), ClientData (copy)
            if WeaponDataNew.CurrentTool == nil then
                if Runtime.LastSightReticleTool ~= nil then
                    if Runtime.LastSightReticleGuis then
                        for _, v in ipairs(Runtime.LastSightReticleGuis) do
                            if v and v.Parent then
                                v.Enabled = false;
                            end;
                        end;
                    end;

                    Runtime.LastSightReticleTool = nil;
                    Runtime.LastSightReticleGuis = nil;
                    Runtime.LastSightReticleEnabled = nil;
                end;

                return;
            end;

            if Humanoid.Health <= 0 then
                SetSightReticleSurfaceGuiEnabled(WeaponDataNew.CurrentTool.Model, false);

                return;
            end;

            if not WeaponDataNew.CameraModel then
                SetSightReticleSurfaceGuiEnabled(WeaponDataNew.CurrentTool.Model, false);

                return;
            end;

            local v94 = WeaponDataNew.CurrentTool.Settings and WeaponDataNew.CurrentTool.Settings.SightFront;

            if Runtime.LastSightFront and Runtime.LastSightFront ~= v94 then
                Runtime.LastSightFront.Transparency = 0;
            end;

            Runtime.LastSightFront = v94;

            if WeaponDataNew.CurrentTool.Model == nil then
                if Runtime.LastSightReticleTool ~= nil then
                    if Runtime.LastSightReticleGuis then
                        for _, v in ipairs(Runtime.LastSightReticleGuis) do
                            if v and v.Parent then
                                v.Enabled = false;
                            end;
                        end;
                    end;

                    Runtime.LastSightReticleTool = nil;
                    Runtime.LastSightReticleGuis = nil;
                    Runtime.LastSightReticleEnabled = nil;
                end;

                WeaponDataNew.CameraModel.Base.CFrame = Camera.CFrame * CFrame.new(0, 0, -0.5);

                return;
            end;

            MovementBobbleEffect();
            local AdditionalRotation = Runtime.AdditionalRotation;
            Runtime.AdditionalRotation = AdditionalRotation + (0 - AdditionalRotation) * (0.15 * p92);
            local v95 = UpdateFigure8Arm(p91, p93);
            local v96 = WeaponDataNew.CurrentTool.Tool:GetAttribute("Class");

            if v96 == "Primary" or v96 == "Secondary" then
                if WeaponDataNew.CurrentTool.Aiming == false then
                    ClientData.Recoil = ClientData.Recoil:Lerp(CFrame.new(), WeaponDataNew.CurrentTool.Settings.PunchRecover * 0.7);
                else
                    ClientData.Recoil = ClientData.Recoil:Lerp(CFrame.new(), WeaponDataNew.CurrentTool.Settings.PunchRecover);
                end;

                local v97 = 0.4 * p92;

                if not WeaponDataNew.CameraModel.Parent then
                    return;
                end;

                if not WeaponDataNew.AimPart then
                    return;
                end;

                local v98 = WeaponDataNew.CameraModel.Anim.CFrame:ToObjectSpace(WeaponDataNew.AimPart.CFrame);
                local v99 = WeaponDataNew.CurrentTool.Aiming == true;
                local v100;

                if v99 then
                    v100 = CFrame.new(0, 0, WeaponDataNew.AimPart:GetAttribute("AimZ") or 0.2);
                else
                    v100 = CFrame.new(0, 0, 0);
                end;

                local v101;

                if v99 then
                    v101 = ClientData.Recoil * v98;
                else
                    v101 = v100:Inverse() * ClientData.Recoil * v95;
                end;

                if Runtime.LastADSTransitionTool ~= WeaponDataNew.CurrentTool then
                    Runtime.LastADSTransitionTool = WeaponDataNew.CurrentTool;
                    Runtime.LastADSTransitionAiming = v99;
                    Runtime.ADSTransitionActive = false;
                end;

                if Runtime.LastADSTransitionAiming ~= v99 then
                    Runtime.LastADSTransitionAiming = v99;
                    Runtime.ADSTransitionActive = true;
                    Runtime.ADSTransitionStartedAt = os.clock();
                    Runtime.ADSTransitionFromC0 = WeaponDataNew.CameraModel.Anim.Base.C0;
                    Runtime.ADSTransitionFromC1 = WeaponDataNew.CameraModel.Anim.Base.C1;
                end;

                if Runtime.ADSTransitionActive == true then
                    local v102 = (os.clock() - (Runtime.ADSTransitionStartedAt or 0)) / 0.12;
                    local v103 = math.clamp(v102, 0, 1);
                    local v104 = Runtime.ADSTransitionFromC1 or WeaponDataNew.CameraModel.Anim.Base.C1;
                    local v105;

                    if v99 then
                        v105 = v103 >= 0.5;
                    else
                        v105 = v99;
                    end;

                    WeaponDataNew.CameraModel.Anim.Base.C0 = (Runtime.ADSTransitionFromC0 or WeaponDataNew.CameraModel.Anim.Base.C0):Lerp(v100, v103);
                    WeaponDataNew.CameraModel.Anim.Base.C1 = v104:Lerp(v101, v103);
                    SetSightReticleSurfaceGuiEnabled(WeaponDataNew.CurrentTool.Model, v105);

                    if v94 then
                        local v106 = math.clamp((v103 - 0.5) / 0.5, 0, 1);
                        v94.Transparency = v99 and v106 and v106 or 0;
                    end;

                    if v103 >= 1 then
                        Runtime.ADSTransitionActive = false;
                    end;
                else
                    WeaponDataNew.CameraModel.Anim.Base.C1 = WeaponDataNew.CameraModel.Anim.Base.C1:Lerp(v101, v97);
                    WeaponDataNew.CameraModel.Anim.Base.C0 = v100;
                    SetSightReticleSurfaceGuiEnabled(WeaponDataNew.CurrentTool.Model, v99);

                    if v94 then
                        v94.Transparency = v99 and 1 or 0;
                    end;
                end;
            else
                Runtime.ADSTransitionActive = false;
                Runtime.LastADSTransitionTool = WeaponDataNew.CurrentTool;
                Runtime.LastADSTransitionAiming = false;
                SetSightReticleSurfaceGuiEnabled(WeaponDataNew.CurrentTool.Model, false);

                if not WeaponDataNew.CameraModel.Parent then
                    return;
                end;

                WeaponDataNew.CameraModel.Anim.Base.C1 = WeaponDataNew.CameraModel.Anim.Base.C1:Lerp(WeaponDataNew.CameraModel.Anim.Base.C0:Inverse() * v95, 0.4 * p92);
                WeaponDataNew.CameraModel.Anim.Base.C0 = CFrame.new(0, 0, 0);

                if v94 then
                    v94.Transparency = 0;
                end;
            end;
        end;

        local function UpdateLeaning(p107) -- Line: 466
            -- upvalues: API (copy), Runtime (copy), WeaponDataNew (copy), Modules (copy), Helpers (copy), Camera (copy)
            local v108 = API.Movement.GetLean() or 0;
            local v109 = 0.13 * p107;

            if v108 == 0 then
                local NextLeanDirection = Runtime.NextLeanDirection;
                Runtime.NextLeanDirection = NextLeanDirection + (-v108 - NextLeanDirection) * v109;
            else
                Runtime.NextLeanDirection = math.clamp(Runtime.NextLeanDirection + -v108 * v109, -1, 1);
            end;

            if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Model then
                local NextLeanAngle = Runtime.NextLeanAngle;
                Runtime.NextLeanAngle = NextLeanAngle + (Modules.Config.LeanAngle * Runtime.NextLeanDirection - NextLeanAngle) * (v109 * 2);
            else
                local NextLeanAngle = Runtime.NextLeanAngle;
                Runtime.NextLeanAngle = NextLeanAngle + (0 - NextLeanAngle) * 1;
            end;

            local v110 = CFrame.fromAxisAngle(Vector3.new(0, 0, 1), (math.rad(Runtime.NextLeanAngle)));

            if Helpers.IsFirstPersonSpectateCameraActive() ~= true then
                Camera.CFrame = Camera.CFrame * v110;
            end;

            if WeaponDataNew.CameraModel then
                WeaponDataNew.CameraModel.Base.CFrame = Camera.CFrame * CFrame.new(0, 0, -0.5) * v110;
            end;
        end;

        local function UpdateAttackerMovement() -- Line: 491
            -- upvalues: Player (copy), ServerFolder (copy), Humanoid (copy), Character (copy), API (copy)
            if Player.Team.Name ~= ServerFolder:GetAttribute("Attacker") then
                return;
            end;

            if ServerFolder:GetAttribute("AttackerMovement") == false then
                Humanoid.WalkSpeed = 0;

                return;
            end;

            if Character:GetAttribute("MovedOnce") ~= true then
                Humanoid.WalkSpeed = API.Movement.GetWalkSpeed();
                Character:SetAttribute("MovedOnce", true);
            end;
        end;

        local function UpdateBarrier() -- Line: 503
            -- upvalues: ServerFolder (copy), ClientData (copy), Player (copy)
            if ServerFolder:GetAttribute("GameMode") ~= "Skirmish" then
                return;
            end;

            if ClientData.EnemyBarrier == nil and ClientData.TeamBarrier == nil then
                if Player.Team.Name ~= ServerFolder:GetAttribute("Defender") then
                    if Player.Team.Name == ServerFolder:GetAttribute("Attacker") then
                        ClientData.EnemyBarrier = workspace.Map:FindFirstChild("DefenderBarrier", true);
                        ClientData.EnemyColor = ServerFolder:GetAttribute(ServerFolder:GetAttribute("Defender") .. "Color");
                        ClientData.TeamBarrier = workspace.Map:FindFirstChild("AttackerBarrier", true);
                        ClientData.TeamColor = ServerFolder:GetAttribute(ServerFolder:GetAttribute("Attacker") .. "Color");
                    end;

                    return;
                end;

                ClientData.EnemyBarrier = workspace.Map:FindFirstChild("AttackerBarrier", true);
                ClientData.EnemyColor = ServerFolder:GetAttribute(ServerFolder:GetAttribute("Attacker") .. "Color");
                ClientData.TeamBarrier = workspace.Map:FindFirstChild("DefenderBarrier", true);
                ClientData.TeamColor = ServerFolder:GetAttribute(ServerFolder:GetAttribute("Defender") .. "Color");

                return;
            end;

            if not (ClientData.EnemyBarrier and ClientData.TeamBarrier) then
                return;
            end;

            if ClientData.EnemyBarrier:GetAttribute("CanCollide") == true then
                return;
            end;

            ClientData.EnemyBarrier:SetAttribute("CanCollide", true);

            for _, child in pairs(ClientData.EnemyBarrier:GetChildren()) do
                child.CanCollide = true;

                if child:FindFirstChild("Mesh") then
                    child.Mesh.VertexColor = Vector3.new(ClientData.EnemyColor.R, ClientData.EnemyColor.G, ClientData.EnemyColor.B);
                end;
            end;

            for _, child in pairs(ClientData.TeamBarrier:GetChildren()) do
                child.CanCollide = false;

                if child:FindFirstChild("Mesh") then
                    child.Mesh.VertexColor = Vector3.new(ClientData.TeamColor.R, ClientData.TeamColor.G, ClientData.TeamColor.B);
                end;
            end;
        end;

        local function UpdateMapZone() -- Line: 537
            -- upvalues: Runtime (copy), Player (copy), ServerFolder (copy), Character (copy), ClientData (copy), Services (copy)
            if os.clock() - Runtime.LastMapZoneCheck < Runtime.MapZoneCheckRate then
                return;
            end;

            Runtime.LastMapZoneCheck = os.clock();
            local v111;

            if Player.Team.Name == ServerFolder:GetAttribute("Defender") then
                v111 = Character:FindFirstChild("HumanoidRootPart");

                if v111 then
                    if ServerFolder:GetAttribute("Phase") == "Round Started" and (ServerFolder:GetAttribute("GameMode") ~= "Skirmish" and ServerFolder:GetAttribute("GameMode") ~= "Invasion") then
                        if ServerFolder:GetAttribute("GameMode") == "Custom" then
                            v111 = workspace.Map:FindFirstChild(ServerFolder:GetAttribute("Map")) and workspace.Map:FindFirstChild(ServerFolder:GetAttribute("Map")):GetAttribute("GameMode") == "Casual";
                        else
                            v111 = true;
                        end;
                    else
                        v111 = false;
                    end;
                end;
            else
                v111 = false;
            end;

            if v111 == false then
                ClientData.PlayerHUD.MapZone.Text = "";

                return;
            end;

            local v112 = Character.HumanoidRootPart:GetTouchingParts();
            local v113 = false;

            for _, v in pairs(v112) do
                if Services.CollectionService:HasTag(v, "MapZone") then
                    ClientData.PlayerHUD.MapZone.Text = v.Name;
                    v113 = true;
                    break;
                end;
            end;

            if v113 == false then
                ClientData.PlayerHUD.MapZone.Text = "";
            end;
        end;

        local function UpdateMovementSync(p114, p115) -- Line: 564
            -- upvalues: Player (copy), Helpers (copy), Runtime (copy), ClientData (copy)
            if (Player.ServerData:GetAttribute("Alive") == true and true or Helpers.ShouldReceiveFirstPersonSpectateSync() == true) == false then
                return;
            end;

            local v116 = os.clock() - Runtime.RemoteMovementBufferDelay;

            for i, v in pairs(ClientData.PlayersMovementSyncData) do
                if v == nil or not i then
                    ClientData.PlayersMovementSyncData[i] = nil;
                elseif i.Character then
                    local HumanoidRootPart = i.Character:FindFirstChild("HumanoidRootPart");

                    if HumanoidRootPart then
                        if i:FindFirstChild("ServerData") and i.ServerData:GetAttribute("Alive") == true then
                            local Vault = v.Vault;
                            local v117, v118, v119, v120, v121, v122, v123, v124, v125, v126;

                            if typeof(Vault) == "table" then
                                local v127 = tonumber(Vault.EntryDuration) or 0.3;
                                local v128 = tonumber(Vault.CrossDuration) or 0.4;
                                local v129 = os.clock() - (tonumber(Vault.StartedAt) or 0);

                                if v129 > v127 + v128 then
                                    HumanoidRootPart.CFrame = Vault.EndCFrame;
                                    v.Vault = nil;
                                    v117 = v.Snapshots;

                                    if typeof(v117) == "table" and #v117 > 0 then
                                        while #v117 >= 2 and v117[2].ReceivedAt <= v116 do
                                            table.remove(v117, 1);
                                        end;

                                        if #v117 >= 2 then
                                            v118 = v117[1];
                                            v119 = v117[2];
                                            v120 = math.max(v119.ReceivedAt - v118.ReceivedAt, 0.008333333333333333);
                                            v121 = math.clamp((v116 - v118.ReceivedAt) / v120, 0, 1);
                                            v122 = v118.CFrame:Lerp(v119.CFrame, v121);
                                        else
                                            v123 = v117[1];
                                            v124 = math.clamp(v116 - v123.ReceivedAt, 0, Runtime.RemoteMovementMaxExtrapolation);
                                            v125 = typeof(v123.Velocity) == "Vector3" and (v123.Velocity or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0);

                                            if v124 <= 0 then
                                                v122 = v123.CFrame;
                                            else
                                                v122 = v123.CFrame + v125 * v124;
                                            end;
                                        end;

                                        if v122 ~= nil then
                                            if (HumanoidRootPart.Position - v122.Position).Magnitude >= Runtime.RemoteMovementWarpDistance then
                                                HumanoidRootPart.CFrame = v122;
                                            else
                                                v126 = math.clamp(Runtime.RemoteMovementBlendAlpha * p115, 0, 1);
                                                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(v122, v126);
                                            end;
                                        end;

                                        if (v.LastReceivedAt or 0) + Runtime.RemoteMovementStaleAfter < os.clock() and #v117 <= 1 then
                                            ClientData.PlayersMovementSyncData[i] = nil;
                                        end;
                                    elseif (v.LastReceivedAt or 0) + Runtime.RemoteMovementStaleAfter < os.clock() then
                                        ClientData.PlayersMovementSyncData[i] = nil;
                                    end;
                                end;

                                local v130;

                                if v129 <= v127 then
                                    local v131 = v129 / math.max(v127, 0.008333333333333333);
                                    local v132 = math.clamp(v131, 0, 1);
                                    v130 = Vault.OriginCFrame:Lerp(Vault.StartCFrame, v132);
                                else
                                    local v133 = (v129 - v127) / math.max(v128, 0.008333333333333333);
                                    local v134 = math.clamp(v133, 0, 1);
                                    v130 = Vault.StartCFrame:Lerp(Vault.EndCFrame, v134);
                                end;

                                if v130 then
                                    HumanoidRootPart.CFrame = v130;
                                end;
                            else
                                v117 = v.Snapshots;

                                if typeof(v117) == "table" and #v117 > 0 then
                                    while #v117 >= 2 and v117[2].ReceivedAt <= v116 do
                                        table.remove(v117, 1);
                                    end;

                                    if #v117 >= 2 then
                                        v118 = v117[1];
                                        v119 = v117[2];
                                        v120 = math.max(v119.ReceivedAt - v118.ReceivedAt, 0.008333333333333333);
                                        v121 = math.clamp((v116 - v118.ReceivedAt) / v120, 0, 1);
                                        v122 = v118.CFrame:Lerp(v119.CFrame, v121);
                                    else
                                        v123 = v117[1];
                                        v124 = math.clamp(v116 - v123.ReceivedAt, 0, Runtime.RemoteMovementMaxExtrapolation);
                                        v125 = typeof(v123.Velocity) == "Vector3" and (v123.Velocity or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0);

                                        if v124 <= 0 then
                                            v122 = v123.CFrame;
                                        else
                                            v122 = v123.CFrame + v125 * v124;
                                        end;
                                    end;

                                    if v122 ~= nil then
                                        if (HumanoidRootPart.Position - v122.Position).Magnitude >= Runtime.RemoteMovementWarpDistance then
                                            HumanoidRootPart.CFrame = v122;
                                        else
                                            v126 = math.clamp(Runtime.RemoteMovementBlendAlpha * p115, 0, 1);
                                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(v122, v126);
                                        end;
                                    end;

                                    if (v.LastReceivedAt or 0) + Runtime.RemoteMovementStaleAfter < os.clock() and #v117 <= 1 then
                                        ClientData.PlayersMovementSyncData[i] = nil;
                                    end;
                                elseif (v.LastReceivedAt or 0) + Runtime.RemoteMovementStaleAfter < os.clock() then
                                    ClientData.PlayersMovementSyncData[i] = nil;
                                end;
                            end;
                        else
                            ClientData.PlayersMovementSyncData[i] = nil;
                        end;
                    else
                        ClientData.PlayersMovementSyncData[i] = nil;
                    end;
                else
                    ClientData.PlayersMovementSyncData[i] = nil;
                end;
            end;
        end;

        local function UpdateClimbAnimation() -- Line: 654
            -- upvalues: WeaponDataNew (copy), Character (copy), Modules (copy)
            if WeaponDataNew.Animations.Client.Climb.IsPlaying ~= true then
                return;
            end;

            if not (Character and Character.PrimaryPart) then
                return;
            end;

            local Magnitude = (Character.PrimaryPart.AssemblyLinearVelocity * Vector3.new(0, 1, 0)).Magnitude;
            WeaponDataNew.Animations.Client.Climb:AdjustSpeed(Magnitude / Modules.Config.CrouchWalkSpeed);
            WeaponDataNew.Animations.Server.Climb:AdjustSpeed(Magnitude / Modules.Config.CrouchWalkSpeed);
        end;

        local function UpdateScopeSway(p135) -- Line: 662
            -- upvalues: Character (copy), WeaponDataNew (copy), ClientData (copy), Runtime (copy), Helpers (copy)
            if not (Character and Character.PrimaryPart) then
                return;
            end;

            local Magnitude = (Character.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude;

            if WeaponDataNew.CurrentTool.Aiming ~= false or ClientData.GameHUD.ScopeUI.Visible ~= true then
                if ClientData.ScopeAiming == nil then
                    ClientData.ScopeAiming = 0;
                end;

                return;
            end;

            if math.floor(Magnitude) > 0 then
                local v136 = ClientData;
                v136.ScopeAiming = v136.ScopeAiming + p135 * Magnitude * 1.05;
                local ScopeSwaySin = Runtime.ScopeSwaySin;
                Runtime.ScopeSwaySin = ScopeSwaySin + (math.sin(ClientData.ScopeAiming / 2) * Magnitude * 2 - ScopeSwaySin) * 0.4;
                local ScopeSwayCos = Runtime.ScopeSwayCos;
                Runtime.ScopeSwayCos = ScopeSwayCos + (math.sin(ClientData.ScopeAiming) * Magnitude * 2 - ScopeSwayCos) * 0.4;
            else
                ClientData.ScopeAiming = 0;
                local ScopeSwaySin = Runtime.ScopeSwaySin;
                Runtime.ScopeSwaySin = ScopeSwaySin + (0 - ScopeSwaySin) * 0.3;
                local ScopeSwayCos = Runtime.ScopeSwayCos;
                Runtime.ScopeSwayCos = ScopeSwayCos + (0 - ScopeSwayCos) * 0.3;
            end;

            local v137 = Helpers.getGuiInset();
            ClientData.GameHUD.ScopeUI.Scope.Position = UDim2.new(0.5, Runtime.ScopeSwaySin, 0.5, Runtime.ScopeSwayCos + v137);
        end;

        GameEvents.LookRotation.OnClientEvent:Connect(function(p138, p139, p140, p141) -- Line: 684
            -- upvalues: SyncMovement (copy)
            SyncMovement(p138, p139, p141);
        end);
        GameEvents:WaitForChild("VaultSync").OnClientEvent:Connect(function(p142, p143, p144, p145, p146) -- Line: 688
            -- upvalues: SyncVaultMovement (copy)
            SyncVaultMovement(p142, p143, p144, p145, p146);
        end);
        GameEvents.CameraShake.OnClientEvent:Connect(function(p147, p148) -- Line: 692
            -- upvalues: Runtime (copy), Modules (copy)
            Runtime.CameraShake:Shake(Modules.CShakeModule.Presets[p147]);
        end);
        Services.RunService.PreRender:Connect(function(p149) -- Line: 696
            -- upvalues: WeaponDataNew (copy), WeaponAction (copy), API (copy), Humanoid (copy), SampleLocalLaserTarget (copy), UpdateViewmodel (copy), UpdateLeaning (copy), UpdateLookRotation (copy), UpdateAttackerMovement (copy), UpdateBarrier (copy), UpdateMapZone (copy), UpdateMovementSync (copy), UpdateClimbAnimation (copy), UpdateScopeSway (copy), ApplyLocalLookRotationPreview (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;

            if CurrentTool == nil then
                WeaponAction.QuickThrowHoldActive = false;
                WeaponAction.QuickThrowPreviousWeaponIndex = 0;
                WeaponAction.ThrowableRecoveryActive = false;
                WeaponDataNew.QuickAction = false;
                API.Movement.ResetPendingSprintExitState();
                API.WeaponAction.SetThrowablePreviewBridgeState(false);

                return;
            end;

            local v150 = p149 * 60;
            local v151 = API.Movement.GetMovement();
            local v152 = Humanoid.Health > 0;
            local v153;

            if CurrentTool.Model == nil or WeaponDataNew.CameraModel == nil then
                v153 = false;
            else
                v153 = WeaponDataNew.CameraModel.Parent ~= nil;
            end;

            SampleLocalLaserTarget(v151);
            API.WeaponAction.SyncThrowablePreviewState();
            API.Presentation.SyncSpectateAmmoState();

            if v152 then
                if v153 then
                    UpdateViewmodel(p149, v150, v151);
                    UpdateLeaning(v150);
                end;

                UpdateLookRotation(v150);
                API.Input.AdditionalMobileThumbstickFunction();
                API.Movement.UpdateJumpLock(v151);
            end;

            UpdateAttackerMovement();
            UpdateBarrier();
            UpdateMapZone();
            UpdateMovementSync(p149, v150);

            if v153 then
                UpdateClimbAnimation();
                API.Movement.RuntimeMovementStateAnim();
                API.Movement.UpdateSprinting(v151);
                API.Movement.UpdateMovementStartWalkSpeed(v151);
                UpdateScopeSway(p149);
            end;

            API.Movement.UpdateMobileCrouch();

            if v152 then
                ApplyLocalLookRotationPreview();
            end;
        end);

        return {
            SyncMovement = SyncMovement,
            ApplyLocalLookRotationPreview = ApplyLocalLookRotationPreview
        };
    end
};