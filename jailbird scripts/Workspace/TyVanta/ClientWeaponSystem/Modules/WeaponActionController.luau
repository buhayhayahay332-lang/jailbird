
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
        local Script = Refs.Script;
        local ServerFolder = Refs.ServerFolder;
        local GameEvents = Refs.GameEvents;
        local ClientData = State.ClientData;
        local WeaponDataNew = State.WeaponDataNew;
        local WeaponAction = State.WeaponAction;
        local Runtime = State.Runtime;
        local _ = State.Presentation;
        local Ping = State.Ping;
        local Keybinds = State.Keybinds;
        local PlayerSettings = State.PlayerSettings;
        local Helpers = State.Helpers;

        local function u2(...) -- Line: 30
            -- upvalues: API (copy)
            if API.Presentation and API.Presentation.SelectHUDEquipment then
                return API.Presentation.SelectHUDEquipment(...);
            end;
        end;

        local function u3(...) -- Line: 36
            -- upvalues: API (copy)
            if API.Presentation and API.Presentation.PushSpectatePresentationState then
                return API.Presentation.PushSpectatePresentationState(...);
            end;
        end;

        local function _(p4, p5) -- Line: 42
            -- upvalues: WeaponDataNew (copy)
            if WeaponDataNew and WeaponDataNew.SendPresentationEvent then
                return WeaponDataNew:SendPresentationEvent(p4, p5);
            end;
        end;

        local function resolveEquippedCharacterWeaponModel(p6, p7) -- Line: 53
            -- upvalues: Modules (copy)
            if not p6 then
                return nil;
            end;

            local v8 = typeof(p7) == "string" and p7 ~= "" and Modules.WeaponSlotResolver.ResolveVisibleModel(p6, p7);

            if v8 then
                return v8;
            end;

            local v9 = Modules.WeaponSlotResolver.GetStateFolder(p6);

            if v9 then
                v9 = v9:GetAttribute("EquippedToolName");
            end;

            if typeof(v9) == "string" and v9 ~= "" then
                return Modules.WeaponSlotResolver.ResolveVisibleModel(p6, v9);
            end;

            return nil;
        end;

        function Helpers.getCurrentStateFolder() -- Line: 48
            -- upvalues: Player (copy), Modules (copy)
            local Character2 = Player.Character;

            return Character2 and Modules.WeaponSlotResolver.GetStateFolder(Character2) or nil;
        end;

        Helpers.resolveEquippedCharacterWeaponModel = resolveEquippedCharacterWeaponModel;

        local function SetThrowablePreviewBridgeState(p10, p11) -- Line: 130
            -- upvalues: Script (copy), Modules (copy), Player (copy), u3 (copy)
            local v12 = p10 == true and (p11 or "") or "";

            if Script:GetAttribute("ThrowablePreviewActive") ~= p10 then
                Script:SetAttribute("ThrowablePreviewActive", p10);
            end;

            if Script:GetAttribute("ThrowablePreviewToolName") ~= v12 then
                Script:SetAttribute("ThrowablePreviewToolName", v12);
            end;

            local Character2 = Player.Character;
            Modules.WeaponSlotResolver.UpdateStateFolder(Character2 and Modules.WeaponSlotResolver.GetStateFolder(Character2) or nil, {
                ThrowablePreviewActive = p10,
                ThrowablePreviewToolName = v12
            });
            u3({
                ThrowablePreviewActive = p10,
                ThrowablePreviewToolName = v12
            });
        end;

        local function SyncThrowablePreviewState() -- Line: 149
            -- upvalues: WeaponDataNew (copy), WeaponAction (copy), SetThrowablePreviewBridgeState (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;
            local v13;

            if WeaponAction.ThrowableRecoveryActive == true or (CurrentTool == nil or (CurrentTool.Tool == nil or CurrentTool.Tool:GetAttribute("Class") ~= "Throwable")) then
                v13 = false;
            else
                if CurrentTool and CurrentTool.Tool and CurrentTool.Tool:GetAttribute("Class") == "Throwable" then
                    v13 = (tonumber(CurrentTool.Tool:GetAttribute("Amount")) or 0) > 0;
                else
                    v13 = false;
                end;

                if v13 then
                    v13 = WeaponDataNew.CurrentToolIndex == 4 and true or WeaponAction.QuickThrowHoldActive == true;
                end;
            end;

            if v13 == true then
                SetThrowablePreviewBridgeState(true, CurrentTool.Tool.Name);

                return;
            end;

            SetThrowablePreviewBridgeState(false);
        end;

        local function BuildThrowableIgnoreList(p14) -- Line: 166
            -- upvalues: Character (copy), Camera (copy), WeaponDataNew (copy)
            local v15 = { Character, Camera };

            if WeaponDataNew.CameraModel then
                table.insert(v15, WeaponDataNew.CameraModel);
            end;

            if p14 then
                table.insert(v15, p14);
            end;

            return v15;
        end;

        local function ClearThrowableThrowSnapshot() -- Line: 177
            -- upvalues: WeaponDataNew (copy)
            WeaponDataNew.ThrowableSnapshot = nil;
        end;

        local function CaptureThrowableThrowSnapshot() -- Line: 181
            -- upvalues: WeaponDataNew (copy), Modules (copy), Character (copy), Camera (copy), PlayerGui (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;

            if not CurrentTool or (not CurrentTool.Tool or CurrentTool.Tool:GetAttribute("Class") ~= "Throwable") then
                WeaponDataNew.ThrowableSnapshot = nil;

                return nil;
            end;

            local BuildClientThrowData = Modules.Throwable.BuildClientThrowData;
            local Crosshair = PlayerGui.Crosshair;
            local Model = CurrentTool.Model;
            local Model2 = CurrentTool.Model;
            local v16 = { Character, Camera };

            if WeaponDataNew.CameraModel then
                table.insert(v16, WeaponDataNew.CameraModel);
            end;

            if Model2 then
                table.insert(v16, Model2);
            end;

            local v17 = BuildClientThrowData(Character, Camera, Crosshair, Model, v16);

            if not v17 then
                WeaponDataNew.ThrowableSnapshot = nil;

                return nil;
            end;

            local v18 = {
                ToolName = CurrentTool.Tool.Name,
                CameraPosition = v17.CameraPosition,
                ViewDirection = v17.ViewDirection or v17.Direction,
                StartPosition = v17.Origin,
                ThrowData = v17
            };
            WeaponDataNew.ThrowableSnapshot = v18;

            return v18;
        end;

        local function SetThrowableRecoveryState(p19) -- Line: 205
            -- upvalues: WeaponAction (copy), SyncThrowablePreviewState (copy)
            WeaponAction.ThrowableRecoveryActive = p19;
            SyncThrowablePreviewState();
        end;

        local u20 = nil;
        local u21 = nil;
        local u22 = nil;
        local u23 = nil;
        local u24 = nil;

        local function IsWeaponPresentationReady() -- Line: 216
            -- upvalues: WeaponDataNew (copy)
            local v25;

            if WeaponDataNew == nil or WeaponDataNew.IsWeaponPresentationReady == nil then
                v25 = false;
            else
                v25 = WeaponDataNew:IsWeaponPresentationReady() == true;
            end;

            return v25;
        end;

        local function IsWeaponFullyReady() -- Line: 220
            -- upvalues: WeaponDataNew (copy)
            local v26;

            if WeaponDataNew == nil or WeaponDataNew.IsWeaponReady == nil then
                v26 = false;
            else
                v26 = WeaponDataNew:IsWeaponReady() == true;
            end;

            return v26;
        end;

        local function GetCurrentBufferedADSToolSerial() -- Line: 224
            -- upvalues: WeaponDataNew (copy), Modules (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;

            return not (CurrentTool and CurrentTool.Tool) and "" or Modules.WeaponSlotResolver.GetOrAssignToolSerial(CurrentTool.Tool);
        end;

        local function SyncBufferedADSIntentAttributes() -- Line: 232
            -- upvalues: Script (copy), WeaponAction (copy)
            Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
            Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
            Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
        end;

        local function SetBufferedADSIntent(p27) -- Line: 238
            -- upvalues: WeaponAction (copy), Script (copy)
            WeaponAction.BufferedADSIntent = p27;
            Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
            Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
            Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
        end;

        local function ClearBufferedADSIntent() -- Line: 243
            -- upvalues: WeaponAction (copy), Script (copy)
            WeaponAction.BufferedADSIntent = false;
            WeaponAction.BufferedADSSwapGeneration = 0;
            WeaponAction.BufferedADSToolSerial = "";
            Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
            Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
            Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
        end;

        local function ShouldMaintainBufferedADSIntent() -- Line: 250
            -- upvalues: WeaponAction (copy), PlayerSettings (copy), ClientData (copy)
            if WeaponAction.BufferedADSIntent == true then
                return PlayerSettings:GetAttribute("ADSToggle") == true and true or ClientData.ADSInputHeld == true;
            end;

            return false;
        end;

        local function BufferADSForCurrentSwap() -- Line: 260
            -- upvalues: WeaponAction (copy), WeaponDataNew (copy), Modules (copy), Script (copy)
            WeaponAction.BufferedADSIntent = true;
            WeaponAction.BufferedADSSwapGeneration = WeaponAction.SwapGeneration or 0;
            local CurrentTool = WeaponDataNew.CurrentTool;
            WeaponAction.BufferedADSToolSerial = not (CurrentTool and CurrentTool.Tool) and "" or Modules.WeaponSlotResolver.GetOrAssignToolSerial(CurrentTool.Tool);
            Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
            Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
            Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
        end;

        local function IsADSOnSwapCooldown() -- Line: 267
            -- upvalues: WeaponAction (copy)
            return (WeaponAction.ADSUnlockAt or 0) > os.clock();
        end;

        local u28 = nil;

        local function ScheduleBufferedADSRetry(p29) -- Line: 273
            -- upvalues: WeaponAction (copy), u28 (ref)
            if not p29 then
                local v30 = (WeaponAction.ADSUnlockAt or 0) - os.clock();
                p29 = math.max(v30, 0);
            end;

            if p29 <= 0 then
                task.defer(u28);

                return;
            end;

            task.delay(p29, function() -- Line: 279
                -- upvalues: WeaponAction (ref), u28 (ref)
                if WeaponAction.BufferedADSIntent == true then
                    u28();
                end;
            end);
        end;

        local function ApplyHoldPresentationState(p31) -- Line: 286
            -- upvalues: WeaponDataNew (copy), u24 (ref), Modules (copy), Keybinds (copy), API (copy), PlayerSettings (copy), ClientData (copy), u3 (copy)
            local v32 = WeaponDataNew and WeaponDataNew.CurrentTool;

            if v32 and v32.Aiming == true then
                u24(v32, p31);

                return;
            end;

            local v33 = p31 or 0.12;
            Modules.CameraSens:AdjustSensitivity(Keybinds.CameraSensitivity);

            if API.Presentation and API.Presentation.TweenFOV then
                API.Presentation.TweenFOV(PlayerSettings:GetAttribute("FieldOfView"), v33);
            end;

            if ClientData.GameHUD and ClientData.GameHUD.ScopeUI then
                ClientData.GameHUD.ScopeUI.Visible = false;
            end;

            u3({
                ScopeVisible = false,
                Aiming = false,
                TargetFOV = PlayerSettings:GetAttribute("FieldOfView"),
                CrosshairVisible = WeaponDataNew.Crosshair and WeaponDataNew.Crosshair.Enabled == true and true or false
            });
        end;

        u24 = function(p34, p35) -- Line: 308
            -- upvalues: Modules (copy), Keybinds (copy), API (copy), ClientData (copy), u3 (copy), PlayerSettings (copy)
            if not (p34 and (p34.Tool and p34.Settings)) then
                return;
            end;

            local v36 = p35 or 0.12;

            if p34.Tool:GetAttribute("ADSType") == "Scope" then
                Modules.CameraSens:AdjustSensitivity(Keybinds.ADSSensitivity * 0.5);

                if API.Presentation and API.Presentation.TweenFOV then
                    API.Presentation.TweenFOV(25, v36);
                end;

                if ClientData.GameHUD and ClientData.GameHUD.ScopeUI then
                    ClientData.GameHUD.ScopeUI.Visible = true;
                end;

                u3({
                    TargetFOV = 25,
                    ScopeVisible = true,
                    CrosshairVisible = false,
                    Aiming = true
                });

                return;
            end;

            local v37 = PlayerSettings:GetAttribute("FieldOfView") - 5 * p34.Settings.ADSZoom;
            Modules.CameraSens:AdjustSensitivity(Keybinds.ADSSensitivity);

            if API.Presentation and API.Presentation.TweenFOV then
                API.Presentation.TweenFOV(v37, v36);
            end;

            if ClientData.GameHUD and ClientData.GameHUD.ScopeUI then
                ClientData.GameHUD.ScopeUI.Visible = false;
            end;

            u3({
                ScopeVisible = false,
                CrosshairVisible = false,
                Aiming = true,
                TargetFOV = v37
            });
        end;

        u28 = function() -- Line: 345
            -- upvalues: WeaponAction (copy), PlayerSettings (copy), ClientData (copy), Script (copy), WeaponDataNew (copy), Modules (copy), ScheduleBufferedADSRetry (copy), u20 (ref)
            if WeaponAction.BufferedADSIntent ~= true then
                return;
            end;

            local v38;

            if WeaponAction.BufferedADSIntent == true then
                v38 = PlayerSettings:GetAttribute("ADSToggle") == true and true or ClientData.ADSInputHeld == true;
            else
                v38 = false;
            end;

            if v38 ~= true then
                WeaponAction.BufferedADSIntent = false;
                WeaponAction.BufferedADSSwapGeneration = 0;
                WeaponAction.BufferedADSToolSerial = "";
                Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");

                return;
            end;

            local v39;

            if WeaponDataNew == nil or WeaponDataNew.IsWeaponPresentationReady == nil then
                v39 = false;
            else
                v39 = WeaponDataNew:IsWeaponPresentationReady() == true;
            end;

            if v39 ~= true then
                return;
            end;

            if (WeaponAction.BufferedADSSwapGeneration or 0) ~= (WeaponAction.SwapGeneration or 0) then
                WeaponAction.BufferedADSIntent = false;
                WeaponAction.BufferedADSSwapGeneration = 0;
                WeaponAction.BufferedADSToolSerial = "";
                Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");

                return;
            end;

            local CurrentTool = WeaponDataNew.CurrentTool;
            local v40 = WeaponAction.BufferedADSToolSerial or "";
            local v41 = CurrentTool and CurrentTool.Tool and (Modules.WeaponSlotResolver.GetOrAssignToolSerial(CurrentTool.Tool) or "") or "";

            if v40 == "" or v40 ~= v41 then
                WeaponAction.BufferedADSIntent = false;
                WeaponAction.BufferedADSSwapGeneration = 0;
                WeaponAction.BufferedADSToolSerial = "";
                Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");

                return;
            end;

            if not (CurrentTool and CurrentTool.Tool) then
                WeaponAction.BufferedADSIntent = false;
                WeaponAction.BufferedADSSwapGeneration = 0;
                WeaponAction.BufferedADSToolSerial = "";
                Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");

                return;
            end;

            if CurrentTool.Tool:GetAttribute("Class") == "Primary" or CurrentTool.Tool:GetAttribute("Class") == "Secondary" then
                if CurrentTool.Aiming == true then
                    local v42;

                    if WeaponDataNew == nil or WeaponDataNew.IsWeaponReady == nil then
                        v42 = false;
                    else
                        v42 = WeaponDataNew:IsWeaponReady() == true;
                    end;

                    if v42 == true then
                        WeaponAction.BufferedADSIntent = false;
                        WeaponAction.BufferedADSSwapGeneration = 0;
                        WeaponAction.BufferedADSToolSerial = "";
                        Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                        Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                        Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
                    end;

                    return;
                end;

                local v43 = (WeaponAction.ADSUnlockAt or 0) - os.clock();

                if v43 > 0 then
                    ScheduleBufferedADSRetry(v43);

                    return;
                end;

                if u20 then
                    u20();
                end;

                local CurrentTool2 = WeaponDataNew.CurrentTool;

                if CurrentTool2 and CurrentTool2.Aiming == true then
                    local v44;

                    if WeaponDataNew == nil or WeaponDataNew.IsWeaponReady == nil then
                        v44 = false;
                    else
                        v44 = WeaponDataNew:IsWeaponReady() == true;
                    end;

                    if v44 == true then
                        WeaponAction.BufferedADSIntent = false;
                        WeaponAction.BufferedADSSwapGeneration = 0;
                        WeaponAction.BufferedADSToolSerial = "";
                        Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                        Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                        Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
                    end;
                end;

                return;
            end;

            WeaponAction.BufferedADSIntent = false;
            WeaponAction.BufferedADSSwapGeneration = 0;
            WeaponAction.BufferedADSToolSerial = "";
            Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
            Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
            Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
        end;

        Script:GetAttributeChangedSignal("WeaponPresentationReady"):Connect(function() -- Line: 401
            -- upvalues: Script (copy), u28 (ref)
            if Script:GetAttribute("WeaponPresentationReady") == true then
                task.defer(u28);
            end;
        end);
        Script:GetAttributeChangedSignal("WeaponFullyReady"):Connect(function() -- Line: 407
            -- upvalues: Script (copy), u28 (ref)
            if Script:GetAttribute("WeaponFullyReady") == true then
                task.defer(u28);
            end;
        end);

        local function ReturnToPreviousWeaponIfNeeded(p45) -- Line: 413
            -- upvalues: WeaponDataNew (copy), WeaponAction (copy), u22 (ref)
            local CurrentTool = WeaponDataNew.CurrentTool;

            if not CurrentTool or (not CurrentTool.Tool or CurrentTool.Tool:GetAttribute("Class") ~= "Throwable") then
                return;
            end;

            local v46 = tonumber(CurrentTool.Tool:GetAttribute("Amount")) or 0;
            local v47 = p45 or WeaponAction.LastNonThrowableWeaponIndex;

            if v46 <= 0 and (type(v47) == "number" and (v47 >= 1 and v47 ~= 4)) then
                u22(v47);
            end;
        end;

        local function FindBarricadeModelFromHitInstance(p48) -- Line: 426
            while p48 do
                if p48:IsA("Model") and p48.Name == "Barricade" then
                    return p48;
                end;

                local Barricade = p48:FindFirstChild("Barricade");

                if Barricade and Barricade:IsA("Model") then
                    return Barricade;
                end;

                p48 = p48.Parent;
            end;

            return nil;
        end;

        local function GetClosestPointOnPart(p49, p50) -- Line: 444
            local v51 = p49.CFrame:PointToObjectSpace(p50);
            local v52 = p49.Size * 0.5;
            local CFrame2 = p49.CFrame;
            local v53 = math.clamp(v51.X, -v52.X, v52.X);
            local v54 = math.clamp(v51.Y, -v52.Y, v52.Y);
            local v55 = math.clamp(v51.Z, -v52.Z, v52.Z);

            return CFrame2:PointToWorldSpace((Vector3.new(v53, v54, v55)));
        end;

        local function IsActiveBarricadeBlocker(p56) -- Line: 454
            if not (p56 and p56:IsA("BasePart")) then
                return false;
            end;

            if p56.Name == "BarricadePort" or p56:GetAttribute("BlockSetup") == true then
                return p56.CanCollide == true;
            end;

            return false;
        end;

        local function ResolveKnifeBarricadeHit(p57) -- Line: 466
            -- upvalues: FindBarricadeModelFromHitInstance (copy), GetClosestPointOnPart (copy), Modules (copy)
            if not p57 or (not p57.Instance or p57.Instance.Name == "BarricadePlank") then
                return p57;
            end;

            local Instance = p57.Instance;
            local v58;

            if Instance and Instance:IsA("BasePart") and (Instance.Name == "BarricadePort" or Instance:GetAttribute("BlockSetup") == true) then
                v58 = Instance.CanCollide == true;
            else
                v58 = false;
            end;

            if v58 == true then
                return p57;
            end;

            local v59 = FindBarricadeModelFromHitInstance(p57.Instance);

            if not v59 then
                return p57;
            end;

            local v60 = (1 / 0);
            local v61 = nil;
            local v62 = nil;

            for _, child in ipairs(v59:GetChildren()) do
                if child:IsA("BasePart") and (child.Name == "BarricadePlank" and (child:GetAttribute("Health") or 0) > 0) then
                    local v63 = GetClosestPointOnPart(child, p57.Position);
                    local Magnitude = (v63 - p57.Position).Magnitude;

                    if Magnitude < v60 then
                        v62 = v63;
                        v61 = child;
                        v60 = Magnitude;
                    end;
                end;
            end;

            return v61 and math.max(1.5, Modules.Config.KnifeDistance * 0.5) >= v60 and {
                Instance = v61,
                Position = v62 or p57.Position,
                Normal = p57.Normal,
                Material = v61.Material,
                Distance = p57.Distance
            } or p57;
        end;

        local function CastBulletRay(p64) -- Line: 508
            -- upvalues: ClientData (copy), Character (copy), Camera (copy), WeaponDataNew (copy), Modules (copy), ResolveKnifeBarricadeHit (copy), Player (copy), GameEvents (copy), Services (copy)
            ClientData.Ray_Ignore = { Character, Camera };
            local v65 = Vector3.new();

            if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Tool:GetAttribute("Class") ~= "Knife" then
                local v66 = math.random(-WeaponDataNew.CurrentTool.Settings.MinSpread * 10, WeaponDataNew.CurrentTool.Settings.MinSpread * 10) / 10;
                local v67 = math.rad(v66);
                local v68 = math.random(-WeaponDataNew.CurrentTool.Settings.MinSpread * 10, WeaponDataNew.CurrentTool.Settings.MinSpread * 10) / 10;
                local v69 = math.rad(v68);
                local v70 = math.random(-WeaponDataNew.CurrentTool.Settings.MinSpread * 10, WeaponDataNew.CurrentTool.Settings.MinSpread * 10) / 10;
                local v71 = math.rad(v70);
                v65 = Vector3.new(v67, v69, v71);

                if WeaponDataNew.CurrentTool.Aiming == false then
                    local v72 = math.random(-WeaponDataNew.CurrentTool.Settings.MaxSpread * 10, WeaponDataNew.CurrentTool.Settings.MaxSpread * 10) / 10;
                    local v73 = math.rad(v72);
                    local v74 = math.random(-WeaponDataNew.CurrentTool.Settings.MaxSpread * 10, WeaponDataNew.CurrentTool.Settings.MaxSpread * 10) / 10;
                    local v75 = math.rad(v74);
                    local v76 = math.random(-WeaponDataNew.CurrentTool.Settings.MaxSpread * 10, WeaponDataNew.CurrentTool.Settings.MaxSpread * 10) / 10;
                    local v77 = math.rad(v76);
                    v65 = Vector3.new(v73, v75, v77) * (1 - WeaponDataNew.CurrentTool.Settings.HipFireReduction / 100 or 1);
                end;
            end;

            local Position = Camera.CFrame.Position;
            local v78 = Camera.CFrame.LookVector + v65;
            local BulletRayCast = Modules.Components.Player.BulletRayCast;

            if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
                BulletRayCast = Modules.Components.Player.KnifeRayCast;
            end;

            local v79, v80 = BulletRayCast(Position, v78, p64 or 500, { Character, Camera });

            if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
                v79 = ResolveKnifeBarricadeHit(v79);
            end;

            local v81 = v79 and {
                StartPosition = Position,
                Direction = v78,
                EndPosition = v79.Position,
                Instance = v79.Instance,
                Normal = v79.Normal,
                Material = v79.Material
            } or nil;
            local v82 = typeof(v80) ~= "table" and {} or v80;

            for _, v in pairs(v82) do
                Modules.Components.HitEffect.Hit(v.Instance, v.Position, v.Normal, v.Material, WeaponDataNew.CurrentTool.Settings, Player);
                GameEvents.Hit:FireServer(v, {
                    StartPosition = Position,
                    Direction = v78,
                    EndPosition = v.Position,
                    Instance = v.Instance,
                    Normal = v.Normal,
                    Material = v.Material
                });
            end;

            local v83 = nil;
            local v84 = nil;

            if v79 and WeaponDataNew.CurrentTool then
                if Services.CollectionService:HasTag(v79.Instance, "PlayerHitRegistration") then
                    local v85 = Modules.Components.Player.FindHumanoidFromBulletHit(v79.Instance);

                    if v85 and v85.Health > 0 then
                        v83 = Services.Players:FindFirstChild(v85.Parent.Name) or v85.Parent;

                        if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
                            v84 = Modules.Config.HeadDamage;
                        elseif Services.CollectionService:HasTag(v79.Instance, "PlayerHead") then
                            v84 = Modules.Config.HeadDamage;
                        elseif Services.CollectionService:HasTag(v79.Instance, "PlayerTorso") then
                            v84 = WeaponDataNew.CurrentTool.Settings.TorsoDamage;
                        elseif Services.CollectionService:HasTag(v79.Instance, "PlayerLimb") then
                            v84 = WeaponDataNew.CurrentTool.Settings.LimbsDamage;
                        else
                            v84 = WeaponDataNew.CurrentTool.Settings.LimbsDamage;
                            warn("Missing tags");
                        end;
                    end;
                elseif WeaponDataNew.CurrentTool then
                    if WeaponDataNew.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
                        Modules.Components.HitEffect.Hit(v79.Instance, v79.Position, v79.Normal, v79.Material, true, Player);
                    else
                        Modules.Components.HitEffect.Hit(v79.Instance, v79.Position, v79.Normal, v79.Material, nil, Player);
                    end;

                    GameEvents.Hit:FireServer(v79, v81);
                end;

                if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
                    WeaponDataNew.CurrentTool.Model.Handle:FindFirstChild("Hit"):Play();
                    WeaponDataNew:ServerSoundCue("Hit", true, WeaponDataNew.CurrentTool.Model.Name);
                end;
            end;

            if WeaponDataNew.CurrentTool then
                GameEvents.Damage:FireServer(v83, v84, WeaponDataNew.CurrentTool.Model.Name, v81);
            end;
        end;

        local function Recoil() -- Line: 635
            -- upvalues: WeaponDataNew (copy), Runtime (copy), Modules (copy), Helpers (copy), Camera (copy), ClientData (copy)
            task.spawn(function() -- Line: 636
                -- upvalues: WeaponDataNew (ref), Runtime (ref), Modules (ref), Helpers (ref), Camera (ref), ClientData (ref)
                if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Settings then
                    Runtime.CameraShake:Shake(Modules.CShakeModule.Presets.Bullet);
                    local v86 = WeaponDataNew.CurrentTool.Settings.VRecoil * Modules.Config.RecoilMultiplier;
                    local v87 = WeaponDataNew.CurrentTool.Settings.HRecoil * math.random(-1, 1);
                    local v88 = CFrame.Angles(v86 * 0.00001, v87 * 0.00001, 0);

                    if Helpers.IsFirstPersonSpectateCameraActive() ~= true then
                        Camera.CFrame = Camera.CFrame * v88;
                    end;

                    if WeaponDataNew.CurrentTool.Aiming == true then
                        ClientData.Recoil = CFrame.Angles(0, v87 * 0.00001, 0) * CFrame.new(0, 0, -0.15);
                    else
                        ClientData.Recoil = CFrame.Angles(0, v87 * 0.00001, 0) * CFrame.new(0, 0, -0.8);
                    end;
                end;

                WeaponDataNew:Shoot();
            end);

            if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Model then
                Modules.Components.Weapon.MuzzleShootEffect(WeaponDataNew.CurrentTool.Model);
            end;
        end;

        local function IsSprintBlockedByHardAction() -- Line: 708
            -- upvalues: WeaponDataNew (copy)
            local CurrentTool = WeaponDataNew.CurrentTool;

            if not (CurrentTool and CurrentTool.Tool) then
                return false;
            end;

            if WeaponDataNew.QuickAction == true or WeaponDataNew.ActionDebounce == true then
                return true;
            end;

            if CurrentTool.Reloading == true or (CurrentTool.Bolting == true or (CurrentTool.Pumping == true or CurrentTool.SemiCooldown == true)) then
                return true;
            end;

            local v89 = CurrentTool.Animations and CurrentTool.Animations.Client;

            if v89 then
                if v89.Action and v89.Action.IsPlaying == true then
                    return true;
                end;

                if v89.Equip and v89.Equip.IsPlaying == true then
                    return true;
                end;
            end;

            return false;
        end;

        local function Knife() -- Line: 739
            -- upvalues: WeaponDataNew (copy), u21 (ref), CastBulletRay (copy), Modules (copy)
            if not WeaponDataNew.CurrentTool then
                return;
            end;

            if WeaponDataNew.ActionDebounce == false and WeaponDataNew.CurrentTool.Animations.Client.Action then
                WeaponDataNew.ActionDebounce = true;
                u21();

                if not WeaponDataNew.CurrentTool.Animations.Client.Action.IsPlaying then
                    WeaponDataNew:Action("Knife");
                    CastBulletRay(Modules.Config.KnifeDistance);
                end;

                task.wait(Modules.Config.KnifeCooldown / 1.5);
                WeaponDataNew.ActionDebounce = false;
            end;
        end;

        local function QuickKnife() -- Line: 753
            -- upvalues: WeaponDataNew (copy), u22 (ref), Knife (copy)
            local CurrentToolIndex = WeaponDataNew.CurrentToolIndex;
            u22(3);
            WeaponDataNew.QuickAction = true;
            Knife();
            WeaponDataNew.QuickAction = false;
            u22(CurrentToolIndex);
        end;

        local function Shoot() -- Line: 762
            -- upvalues: WeaponDataNew (copy), Humanoid (copy), API (copy), GameEvents (copy), CastBulletRay (copy), Recoil (copy), Modules (copy), u21 (ref), ClientData (copy), Services (copy), Knife (copy), u23 (ref)
            local v90;

            if WeaponDataNew == nil or WeaponDataNew.IsWeaponReady == nil then
                v90 = false;
            else
                v90 = WeaponDataNew:IsWeaponReady() == true;
            end;

            if v90 ~= true then
                return;
            end;

            if not WeaponDataNew.CurrentTool then
                return;
            end;

            if WeaponDataNew.Holster == true and Humanoid.Health > 0 then
                local CurrentTool = WeaponDataNew.CurrentTool;
                local v91 = CurrentTool.Tool:GetAttribute("Class");

                if v91 == "Primary" or v91 == "Secondary" then
                    local v92 = CurrentTool.Tool:GetAttribute("Ammo");

                    if math.floor(v92) <= 0 then
                        local Handle = CurrentTool.Model:FindFirstChild("Handle");

                        if not Handle then
                            return;
                        end;

                        local FirePoint = Handle:FindFirstChild("FirePoint");
                        Modules.Components.Weapon.AddSFX(Services.ReplicatedStorage.Config.Audio.GunClick, FirePoint, 0.5, true);

                        return;
                    end;

                    if WeaponDataNew.QuickAction == false and (CurrentTool.Bolting ~= true and (CurrentTool.Pumping ~= true and CurrentTool.SemiCooldown ~= true)) then
                        WeaponDataNew.Animations.Client.Run:Play();
                        WeaponDataNew.Animations.Client.Run:Stop(0.02);
                        WeaponDataNew:SoundCue("Run", false);

                        if CurrentTool.Animations.Client.Inspect then
                            CurrentTool.Animations.Client.Inspect:Stop();
                        end;

                        if CurrentTool.Reloading == true then
                            CurrentTool.ReloadCancel = true;
                            CurrentTool.Animations.Client.Reload:Stop();
                            CurrentTool.Animations.Server.Reload:Stop();
                        end;

                        if API.Movement.GetMovement() == "Running" then
                            API.Movement.SetMovement("Walking");
                        end;

                        if CurrentTool.Settings.Mode == "Semi" or CurrentTool.Settings.Mode == "Pump-Action" then
                            local v93 = CurrentTool.Tool:GetAttribute("Ammo");

                            if math.floor(v93) > 0 then
                                CurrentTool.SemiCooldown = true;
                                GameEvents.Shoot:FireServer();

                                for _ = 1, CurrentTool.Settings.Bullets do
                                    CastBulletRay();
                                end;

                                Recoil();
                                local v94 = 1 / (CurrentTool.Settings.FireRate * Modules.Config.FireRateMultiplier / 60);

                                if CurrentTool.Settings.Mode == "Pump-Action" then
                                    WeaponDataNew:Pump();
                                else
                                    task.wait(v94);
                                end;

                                CurrentTool.SemiCooldown = false;

                                return;
                            end;
                        end;

                        if CurrentTool.Settings.Mode == "Bolt-Action" then
                            local v95 = CurrentTool.Tool:GetAttribute("Ammo");

                            if math.floor(v95) > 0 then
                                CurrentTool.SemiCooldown = true;
                                GameEvents.Shoot:FireServer();

                                for _ = 1, CurrentTool.Settings.Bullets do
                                    CastBulletRay();
                                end;

                                Recoil();
                                local Aiming = CurrentTool.Aiming;
                                local Name = CurrentTool.Tool.Name;
                                u21();
                                WeaponDataNew:Bolt();

                                if Name == CurrentTool.Tool.Name and Aiming == true then
                                    ClientData.RunningHold = false;

                                    if API.WeaponAction and API.WeaponAction.AimDownSight then
                                        API.WeaponAction.AimDownSight();
                                    end;
                                end;

                                CurrentTool.SemiCooldown = false;

                                return;
                            end;
                        end;

                        if CurrentTool.Settings.Mode == "Auto" then
                            while ClientData.MouseHeld and (CurrentTool and (CurrentTool.Model ~= nil and (CurrentTool.Tool:GetAttribute("Ammo") > 0 and WeaponDataNew.QuickAction == false))) do
                                CurrentTool.SemiCooldown = true;
                                local CurrentToolID = WeaponDataNew.CurrentToolID;
                                GameEvents.Shoot:FireServer();

                                for _ = 1, CurrentTool.Settings.Bullets do
                                    CastBulletRay();
                                end;

                                Recoil();
                                task.wait(1 / (CurrentTool.Settings.FireRate * Modules.Config.FireRateMultiplier / 60));

                                if WeaponDataNew.CurrentToolID ~= CurrentToolID then
                                    ClientData.MouseHeld = false;
                                end;

                                CurrentTool.SemiCooldown = false;
                            end;
                        end;
                    end;
                else
                    if v91 == "Knife" then
                        Knife();

                        return;
                    end;

                    if v91 == "Throwable" then
                        u23();
                    end;
                end;
            end;
        end;

        local function StartQuickThrowHold() -- Line: 855
            -- upvalues: WeaponAction (copy), Player (copy), WeaponDataNew (copy), u22 (ref), SetThrowablePreviewBridgeState (copy), SyncThrowablePreviewState (copy)
            if WeaponAction.QuickThrowHoldActive == true or Player.ServerData:GetAttribute("Alive") ~= true then
                return;
            end;

            local v96 = WeaponDataNew.Tools and WeaponDataNew.Tools.Throwable;
            local v97;

            if v96 and v96.Tool and v96.Tool:GetAttribute("Class") == "Throwable" then
                v97 = (tonumber(v96.Tool:GetAttribute("Amount")) or 0) > 0;
            else
                v97 = false;
            end;

            if v97 ~= true then
                return;
            end;

            WeaponAction.QuickThrowPreviousWeaponIndex = WeaponDataNew.CurrentToolIndex ~= 4 and WeaponDataNew.CurrentToolIndex or WeaponAction.LastNonThrowableWeaponIndex;

            if WeaponDataNew.CurrentToolIndex ~= 4 then
                u22(4);
            end;

            local CurrentTool = WeaponDataNew.CurrentTool;
            local v98;

            if CurrentTool and CurrentTool.Tool and CurrentTool.Tool:GetAttribute("Class") == "Throwable" then
                v98 = (tonumber(CurrentTool.Tool:GetAttribute("Amount")) or 0) > 0;
            else
                v98 = false;
            end;

            if v98 ~= true then
                WeaponAction.QuickThrowPreviousWeaponIndex = 0;
                SetThrowablePreviewBridgeState(false);
                WeaponDataNew.ThrowableSnapshot = nil;

                return;
            end;

            WeaponDataNew.ThrowableSnapshot = nil;
            WeaponDataNew.QuickAction = true;
            WeaponAction.QuickThrowHoldActive = true;
            WeaponAction.ThrowableRecoveryActive = false;
            SyncThrowablePreviewState();
            SyncThrowablePreviewState();
        end;

        local function ReleaseQuickThrowHold(p99) -- Line: 884
            -- upvalues: WeaponAction (copy), SetThrowablePreviewBridgeState (copy), u23 (ref), WeaponDataNew (copy), u22 (ref)
            if WeaponAction.QuickThrowHoldActive ~= true then
                return;
            end;

            WeaponAction.QuickThrowHoldActive = false;
            SetThrowablePreviewBridgeState(false);
            local QuickThrowPreviousWeaponIndex = WeaponAction.QuickThrowPreviousWeaponIndex;
            WeaponAction.QuickThrowPreviousWeaponIndex = 0;

            if p99 == true then
                u23();
            else
                WeaponDataNew.ThrowableSnapshot = nil;
                WeaponDataNew.QuickAction = false;
            end;

            if WeaponDataNew.QuickAction == true then
                WeaponDataNew.QuickAction = false;
            end;

            if type(QuickThrowPreviousWeaponIndex) == "number" and (QuickThrowPreviousWeaponIndex >= 1 and QuickThrowPreviousWeaponIndex ~= 4) then
                u22(QuickThrowPreviousWeaponIndex);
            end;
        end;

        u23 = function() -- Line: 910
            -- upvalues: WeaponDataNew (copy), u21 (ref), SetThrowablePreviewBridgeState (copy), CaptureThrowableThrowSnapshot (copy), WeaponAction (copy), SyncThrowablePreviewState (copy), ReturnToPreviousWeaponIfNeeded (copy)
            if not WeaponDataNew.CurrentTool then
                return;
            end;

            if WeaponDataNew.CurrentTool.Tool:GetAttribute("Amount") then
                u21();

                if tonumber(WeaponDataNew.CurrentTool.Tool:GetAttribute("Amount")) > 0 then
                    SetThrowablePreviewBridgeState(false);

                    if not CaptureThrowableThrowSnapshot() then
                        WeaponDataNew.ThrowableSnapshot = nil;

                        return;
                    end;

                    WeaponAction.ThrowableRecoveryActive = true;
                    SyncThrowablePreviewState();
                    WeaponDataNew:Action("Throwable");
                    ReturnToPreviousWeaponIfNeeded();
                    WeaponAction.ThrowableRecoveryActive = false;
                    SyncThrowablePreviewState();
                    SetThrowablePreviewBridgeState(false);
                    WeaponDataNew.ThrowableSnapshot = nil;
                end;
            end;
        end;

        local function Reload() -- Line: 935
            -- upvalues: WeaponDataNew (copy), Modules (copy), u21 (ref), API (copy)
            local v100;

            if WeaponDataNew == nil or WeaponDataNew.IsWeaponReady == nil then
                v100 = false;
            else
                v100 = WeaponDataNew:IsWeaponReady() == true;
            end;

            if v100 ~= true then
                return;
            end;

            if not WeaponDataNew.CurrentTool then
                warn(Modules.Utility.formatWarnInstanceIsNil("WeaponDataNew (type: table)", "CurrentTool", "Failed to reload because CurrentTool is nil"));

                return;
            end;

            if WeaponDataNew.CurrentTool.Animations then
                if WeaponDataNew.CurrentTool.Animations.Client.Reload ~= nil and WeaponDataNew.CurrentTool.Tool:GetAttribute("StoredAmmo") > 0 then
                    local v101 = WeaponDataNew.CurrentTool.Tool:GetAttribute("Ammo");

                    if math.floor(v101) < WeaponDataNew.CurrentTool.Settings.Ammo and (WeaponDataNew.CurrentTool.Reloading ~= true and (WeaponDataNew.QuickAction == false and (WeaponDataNew.CurrentTool.Bolting ~= true and WeaponDataNew.CurrentTool.Pumping ~= true))) then
                        u21();

                        if WeaponDataNew.CurrentTool.Settings.ReloadType == 1 then
                            if API.Movement.GetMovement() == "Running" then
                                API.Movement.SetMovement("Walking");
                            end;

                            WeaponDataNew:Reload();

                            return;
                        end;

                        if WeaponDataNew.CurrentTool.Settings.ReloadType == 2 then
                            local Ammo = WeaponDataNew.CurrentTool.Settings.Ammo;
                            local v102 = WeaponDataNew.CurrentTool.Tool:GetAttribute("Ammo");
                            local v103 = Ammo - math.floor(v102);
                            local v104 = WeaponDataNew.CurrentTool.Tool:GetAttribute("StoredAmmo");
                            local v105 = math.floor(v104);

                            for _ = 1, math.clamp(v103, 0, v105) do
                                if WeaponDataNew.CurrentTool.Tool:GetAttribute("StoredAmmo") and WeaponDataNew.CurrentTool.Tool:GetAttribute("StoredAmmo") > 0 then
                                    local v106 = WeaponDataNew.CurrentTool.Tool:GetAttribute("Ammo");

                                    if math.floor(v106) < WeaponDataNew.CurrentTool.Settings.Ammo and (WeaponDataNew.CurrentTool.Reloading ~= true and (WeaponDataNew.QuickAction == false and (WeaponDataNew.CurrentTool.Bolting ~= true and WeaponDataNew.CurrentTool.Pumping ~= true))) then
                                        WeaponDataNew:Reload();
                                    end;
                                end;

                                if WeaponDataNew.CurrentTool.ReloadCancel == true then
                                    break;
                                end;
                            end;
                        end;
                    end;
                end;

                return;
            end;

            warn(Modules.Utility.formatWarnInstanceIsNil(
                "WeaponDataNew.CurrentTool (type: table)",
                "Animations",
                "Failed to reload because Animations is nil"
            ));
        end;

        u20 = function() -- Line: 974
            -- upvalues: WeaponAction (copy), WeaponDataNew (copy), Modules (copy), Script (copy), ScheduleBufferedADSRetry (copy), ServerFolder (copy), Player (copy), API (copy), GameEvents (copy), u24 (ref), Services (copy), PlayerSettings (copy)
            if (WeaponAction.ADSUnlockAt or 0) > os.clock() == true then
                WeaponAction.BufferedADSIntent = true;
                WeaponAction.BufferedADSSwapGeneration = WeaponAction.SwapGeneration or 0;
                local CurrentTool = WeaponDataNew.CurrentTool;
                WeaponAction.BufferedADSToolSerial = not (CurrentTool and CurrentTool.Tool) and "" or Modules.WeaponSlotResolver.GetOrAssignToolSerial(CurrentTool.Tool);
                Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
                ScheduleBufferedADSRetry();

                return;
            end;

            local v107;

            if WeaponDataNew == nil or WeaponDataNew.IsWeaponPresentationReady == nil then
                v107 = false;
            else
                v107 = WeaponDataNew:IsWeaponPresentationReady() == true;
            end;

            if v107 ~= true then
                WeaponAction.BufferedADSIntent = true;
                WeaponAction.BufferedADSSwapGeneration = WeaponAction.SwapGeneration or 0;
                local CurrentTool = WeaponDataNew.CurrentTool;
                WeaponAction.BufferedADSToolSerial = not (CurrentTool and CurrentTool.Tool) and "" or Modules.WeaponSlotResolver.GetOrAssignToolSerial(CurrentTool.Tool);
                Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");

                return;
            end;

            local CurrentTool = WeaponDataNew.CurrentTool;

            if CurrentTool and (CurrentTool.Tool and (CurrentTool.Tool:GetAttribute("Class") == "Primary" or CurrentTool.Tool:GetAttribute("Class") == "Secondary")) and ((ServerFolder:GetAttribute("Phase") == "Round Started" or (ServerFolder:GetAttribute("Phase") == "Preparation" or ServerFolder:GetAttribute("Phase") == "Round Ended")) and (CurrentTool.Bolting ~= true and Player.ServerData:GetAttribute("Alive") == true)) then
                if (WeaponAction.SwapGeneration or 0) > 0 then
                    local v108, v109;

                    if Script:GetAttribute("SwapInProgress") == true then
                        WeaponAction.BufferedADSIntent = true;
                        WeaponAction.BufferedADSSwapGeneration = WeaponAction.SwapGeneration or 0;
                        v108 = WeaponAction;
                        v109 = WeaponDataNew.CurrentTool;
                        v108.BufferedADSToolSerial = not (v109 and v109.Tool) and "" or Modules.WeaponSlotResolver.GetOrAssignToolSerial(v109.Tool);
                        Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                        Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                        Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
                    else
                        local v110;

                        if WeaponDataNew == nil or WeaponDataNew.IsWeaponReady == nil then
                            v110 = false;
                        else
                            v110 = WeaponDataNew:IsWeaponReady() == true;
                        end;

                        if v110 ~= true then
                            WeaponAction.BufferedADSIntent = true;
                            WeaponAction.BufferedADSSwapGeneration = WeaponAction.SwapGeneration or 0;
                            v108 = WeaponAction;
                            v109 = WeaponDataNew.CurrentTool;
                            v108.BufferedADSToolSerial = not (v109 and v109.Tool) and "" or Modules.WeaponSlotResolver.GetOrAssignToolSerial(v109.Tool);
                            Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                            Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                            Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
                        end;
                    end;
                end;

                WeaponDataNew:ADS();
                WeaponDataNew.Animations.Client.Run:Play();
                WeaponDataNew.Animations.Client.Run:Stop(0.02);
                WeaponDataNew:SoundCue("Run", false);

                if API.Movement.GetMovement() == "Running" then
                    API.Movement.SetMovement("Walking");
                end;

                API.Movement.UpdateWalkSpeedClient(API.Movement.GetMovement());
                GameEvents.ChangeMovement:FireServer(API.Movement.GetMovement());

                if CurrentTool.Tool:GetAttribute("ADSType") == "Scope" then
                    local v111 = {
                        CurrentState = "ADS",
                        Aiming = true,
                        ScopeVisible = true,
                        CrosshairVisible = false,
                        TargetFOV = 25,
                        FOVDuration = 0.2
                    };

                    if WeaponDataNew and WeaponDataNew.SendPresentationEvent then
                        WeaponDataNew:SendPresentationEvent("ADSBegin", v111);
                    end;

                    u24(CurrentTool, 0.2);
                    Modules.Config.AddSound("Scope_In", nil, false, Services.SoundService, false);
                else
                    local v112 = {
                        CurrentState = "ADS",
                        Aiming = true,
                        ScopeVisible = false,
                        CrosshairVisible = false,
                        FOVDuration = 0.2,
                        TargetFOV = PlayerSettings:GetAttribute("FieldOfView") - 5 * CurrentTool.Settings.ADSZoom
                    };

                    if WeaponDataNew and WeaponDataNew.SendPresentationEvent then
                        WeaponDataNew:SendPresentationEvent("ADSBegin", v112);
                    end;

                    u24(CurrentTool, 0.2);
                end;

                local v113;

                if WeaponDataNew == nil or WeaponDataNew.IsWeaponReady == nil then
                    v113 = false;
                else
                    v113 = WeaponDataNew:IsWeaponReady() == true;
                end;

                if v113 == true then
                    WeaponAction.BufferedADSIntent = false;
                    WeaponAction.BufferedADSSwapGeneration = 0;
                    WeaponAction.BufferedADSToolSerial = "";
                    Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                    Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                    Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
                end;
            end;
        end;

        u21 = function() -- Line: 1029
            -- upvalues: WeaponAction (copy), Script (copy), WeaponDataNew (copy), ServerFolder (copy), Player (copy), API (copy), GameEvents (copy), PlayerSettings (copy), ApplyHoldPresentationState (copy), Modules (copy), Services (copy)
            WeaponAction.BufferedADSIntent = false;
            WeaponAction.BufferedADSSwapGeneration = 0;
            WeaponAction.BufferedADSToolSerial = "";
            Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
            Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
            Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
            local CurrentTool = WeaponDataNew.CurrentTool;

            if CurrentTool and (CurrentTool.Tool and (CurrentTool.Tool:GetAttribute("Class") == "Primary" or CurrentTool.Tool:GetAttribute("Class") == "Secondary")) and ((ServerFolder:GetAttribute("Phase") == "Round Started" or (ServerFolder:GetAttribute("Phase") == "Preparation" or ServerFolder:GetAttribute("Phase") == "Round Ended")) and (CurrentTool.Aiming == true and (CurrentTool.Bolting ~= true and Player.ServerData:GetAttribute("Alive") == true))) then
                WeaponDataNew:ReleaseADS();
                API.Movement.UpdateWalkSpeedClient(API.Movement.GetMovement());
                GameEvents.ChangeMovement:FireServer(API.Movement.GetMovement());
                local v114 = {
                    CurrentState = "Hold",
                    Aiming = false,
                    ScopeVisible = false,
                    FOVDuration = 0.2,
                    CrosshairVisible = WeaponDataNew.Crosshair and WeaponDataNew.Crosshair.Enabled == true and true or false,
                    TargetFOV = PlayerSettings:GetAttribute("FieldOfView")
                };

                if WeaponDataNew and WeaponDataNew.SendPresentationEvent then
                    WeaponDataNew:SendPresentationEvent("ADSEnd", v114);
                end;

                ApplyHoldPresentationState(0.2);

                if CurrentTool.Tool:GetAttribute("ADSType") == "Scope" then
                    Modules.Config.AddSound("Scope_Out", nil, false, Services.SoundService, false);
                end;
            end;
        end;

        u22 = function(p115) -- Line: 1053
            -- upvalues: Player (copy), WeaponDataNew (copy), WeaponAction (copy), Script (copy), u21 (ref), ApplyHoldPresentationState (copy), u2 (copy), u3 (copy)
            if Player.ServerData:GetAttribute("Alive") == true and (WeaponDataNew.CurrentToolIndex ~= p115 and (WeaponDataNew.QuickAction == false and (WeaponDataNew.Holster == true and WeaponDataNew.CurrentTool))) then
                WeaponAction.SwapGeneration = (WeaponAction.SwapGeneration or 0) + 1;
                Script:SetAttribute("SwapGeneration", WeaponAction.SwapGeneration);
                WeaponAction.BufferedADSToolSerial = "";
                Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
                WeaponAction.ADSUnlockAt = os.clock() + 0.01;
                u21();
                WeaponAction.BufferedADSIntent = false;
                WeaponAction.BufferedADSSwapGeneration = 0;
                WeaponAction.BufferedADSToolSerial = "";
                Script:SetAttribute("BufferedADSIntent", WeaponAction.BufferedADSIntent == true);
                Script:SetAttribute("BufferedADSSwapGeneration", WeaponAction.BufferedADSSwapGeneration or 0);
                Script:SetAttribute("BufferedADSToolSerial", WeaponAction.BufferedADSToolSerial or "");
                local v116 = ({ "Primary", "Secondary", "Knife", "Throwable" })[p115];

                if not v116 then
                    return;
                end;

                if not WeaponDataNew.Tools[v116] then
                    return;
                end;

                if v116 == "Throwable" then
                    local v117 = WeaponDataNew.Tools[v116];
                    local v118;

                    if v117 and v117.Tool and v117.Tool:GetAttribute("Class") == "Throwable" then
                        v118 = (tonumber(v117.Tool:GetAttribute("Amount")) or 0) > 0;
                    else
                        v118 = false;
                    end;

                    if v118 ~= true then
                        return;
                    end;
                end;

                if WeaponDataNew.SetReadinessState then
                    WeaponDataNew:SetReadinessState(true, false, false);
                end;

                WeaponAction.SwapFinalizing = true;

                if WeaponDataNew:SwapTools(p115) ~= true then
                    WeaponAction.SwapFinalizing = false;

                    if WeaponDataNew.SetReadinessState then
                        local v119 = WeaponDataNew.CurrentTool ~= nil;
                        WeaponDataNew:SetReadinessState(false, v119, v119);
                    end;

                    return;
                end;

                ApplyHoldPresentationState(0.05);
                WeaponAction.SwapFinalizing = false;

                if p115 ~= 4 then
                    WeaponAction.LastNonThrowableWeaponIndex = p115;
                end;

                u2(WeaponDataNew.CurrentTool.Tool.Name);
                u3({
                    CrosshairVisible = WeaponDataNew.Crosshair and WeaponDataNew.Crosshair.Enabled == true and true or false
                });
            end;
        end;

        return {
            CastBulletRay = CastBulletRay,

            ShootEffect = function(p120, p121) -- Line: 610, Name: ShootEffect
                -- upvalues: Player (copy), Modules (copy)
                if p120:IsA("Model") then
                    local v122 = p120:FindFirstChild(p120:GetAttribute(p120:GetAttribute("CurrentWeapon")));

                    if v122 then
                        Modules.Components.Weapon.MuzzleShootEffect(v122);
                    end;
                elseif p120 ~= Player then
                    local Character2 = p120.Character;
                    local v123;

                    if Character2 then
                        local v124 = Modules.WeaponSlotResolver.GetStateFolder(Character2);

                        if v124 then
                            v124 = v124:GetAttribute("EquippedToolName");
                        end;

                        if typeof(v124) == "string" and v124 ~= "" then
                            v123 = Modules.WeaponSlotResolver.ResolveVisibleModel(Character2, v124);
                        else
                            v123 = nil;
                        end;
                    else
                        v123 = nil;
                    end;

                    if v123 ~= nil then
                        Modules.Components.Weapon.MuzzleShootEffect(v123);
                    end;

                    local AnimBase = p120.Character:FindFirstChild("AnimBase");

                    if AnimBase and AnimBase:FindFirstChild("Shoulder") then
                        AnimBase.Shoulder.C1 = CFrame.new(0, 0, 0.15);
                        task.wait(p121 / 2);

                        if AnimBase:FindFirstChild("Shoulder") then
                            AnimBase.Shoulder.C1 = CFrame.new();
                        end;
                    end;
                end;
            end,

            Recoil = Recoil,
            Shoot = Shoot,

            Ping = function() -- Line: 662, Name: Ping
                -- upvalues: Ping (copy), Modules (copy), Camera (copy), ClientData (copy), GameEvents (copy)
                if Ping.CanPing == true then
                    Ping.CanPing = false;
                    local v125 = Modules.Config.RayCast(Camera.CFrame.Position, Camera.CFrame.LookVector, Ping.MaxDistance, ClientData.Ray_Ignore);
                    local v126;

                    if v125 then
                        v126 = v125.Instance or nil;
                    else
                        v126 = nil;
                    end;

                    local v127;

                    if v125 then
                        v127 = v125.Position or nil;
                    else
                        v127 = nil;
                    end;

                    local v128 = v125 and v125.Normal or nil;

                    if v126 ~= nil then
                        GameEvents.PingLocation:FireServer(v127, v126.Name, v128);
                    end;

                    task.wait(Ping.Cooldown);
                    Ping.CanPing = true;
                end;
            end,

            IsInspectBlockingSprint = function() -- Line: 677, Name: IsInspectBlockingSprint
                -- upvalues: WeaponDataNew (copy)
                local CurrentTool = WeaponDataNew.CurrentTool;

                if not CurrentTool then
                    return false;
                end;

                local v129 = CurrentTool.Animations and CurrentTool.Animations.Client;

                if v129 then
                    v129 = v129.Inspect;
                end;

                local v130;

                if v129 == nil then
                    v130 = false;
                else
                    v130 = v129.IsPlaying == true;
                end;

                return v130;
            end,

            TryCancelInspectForSprint = function() -- Line: 688, Name: TryCancelInspectForSprint
                -- upvalues: WeaponDataNew (copy)
                if WeaponDataNew and WeaponDataNew.CancelInspect then
                    return WeaponDataNew:CancelInspect();
                end;

                local CurrentTool = WeaponDataNew.CurrentTool;

                if not CurrentTool then
                    return false;
                end;

                local v131 = CurrentTool.Animations and CurrentTool.Animations.Client;

                if v131 then
                    v131 = v131.Inspect;
                end;

                if not v131 or v131.IsPlaying ~= true then
                    return false;
                end;

                v131:Stop();

                return true;
            end,

            IsSprintBlockedByHardAction = IsSprintBlockedByHardAction,

            IsSprintBlockedByCurrentAction = function() -- Line: 735, Name: IsSprintBlockedByCurrentAction
                -- upvalues: IsSprintBlockedByHardAction (copy), WeaponDataNew (copy)
                local v132;

                if IsSprintBlockedByHardAction() == true then
                    v132 = true;
                else
                    local CurrentTool = WeaponDataNew.CurrentTool;
                    local v133;

                    if CurrentTool then
                        local v134 = CurrentTool.Animations and CurrentTool.Animations.Client;

                        if v134 then
                            v134 = v134.Inspect;
                        end;

                        if v134 == nil then
                            v133 = false;
                        else
                            v133 = v134.IsPlaying == true;
                        end;
                    else
                        v133 = false;
                    end;

                    v132 = v133 == true;
                end;

                return v132;
            end,

            Knife = Knife,
            QuickKnife = QuickKnife,
            StartQuickThrowHold = StartQuickThrowHold,
            ReleaseQuickThrowHold = ReleaseQuickThrowHold,
            TacticalThrow = u23,

            QuickThrow = function() -- Line: 931, Name: QuickThrow
                -- upvalues: StartQuickThrowHold (copy)
                StartQuickThrowHold();
            end,

            Reload = Reload,
            AimDownSight = u20,
            AimDownSightRelease = u21,
            SwapWeapon = u22,

            ApplyConfirmedWeaponSlot = function(p135) -- Line: 77, Name: ApplyConfirmedWeaponSlot
                -- upvalues: Modules (copy), WeaponDataNew (copy), u2 (copy)
                if typeof(p135) ~= "table" then
                    return;
                end;

                local Slot = p135.Slot;

                if typeof(Slot) ~= "string" then
                    return;
                end;

                local v136 = Modules.WeaponSlotResolver.GetIndexFromClass(Slot);

                if not v136 then
                    return;
                end;

                local v137 = WeaponDataNew.Tools and WeaponDataNew.Tools[Slot];

                if not (v137 and (v137.Tool and v137.Model)) then
                    return;
                end;

                if typeof(p135.ToolName) == "string" and (p135.ToolName ~= "" and v137.Tool.Name ~= p135.ToolName) then
                    return;
                end;

                local v138 = WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Tool and Modules.WeaponSlotResolver.GetToolSerial(WeaponDataNew.CurrentTool.Tool);
                local v139 = Modules.WeaponSlotResolver.GetOrAssignToolSerial(v137.Tool);

                if typeof(p135.ToolSerial) == "string" and p135.ToolSerial ~= "" then
                    v139 = p135.ToolSerial;
                end;

                if WeaponDataNew.CurrentToolIndex == v136 and v138 == v139 then
                    if WeaponDataNew.EnsureCurrentToolPresentation then
                        WeaponDataNew:EnsureCurrentToolPresentation();
                    end;
                else
                    WeaponDataNew:SwapTools(v136, true);
                end;

                if v137.Tool then
                    u2(v137.Tool.Name);
                end;
            end,

            SetThrowablePreviewBridgeState = SetThrowablePreviewBridgeState,
            SyncThrowablePreviewState = SyncThrowablePreviewState,

            IsThrowableAvailable = function(p140) -- Line: 118, Name: IsThrowableAvailable
                if not (p140 and p140.Tool) then
                    return false;
                end;

                if p140.Tool:GetAttribute("Class") == "Throwable" then
                    return (tonumber(p140.Tool:GetAttribute("Amount")) or 0) > 0;
                end;

                return false;
            end,

            resolveEquippedCharacterWeaponModel = resolveEquippedCharacterWeaponModel
        };
    end
};