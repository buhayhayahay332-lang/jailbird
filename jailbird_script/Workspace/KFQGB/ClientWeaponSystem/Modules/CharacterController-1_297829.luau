
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
        local Presentation = State.Presentation;
        local Character2 = State.Character;
        local Helpers = State.Helpers;

        local function ClearCacheCamera() -- Line: 26
            -- upvalues: Camera (copy)
            for _, child in pairs(Camera:GetChildren()) do
                if child.Name ~= "HeadBase" and child:IsA("Model") then
                    child:Destroy();
                end;
            end;
        end;

        local function IsInitialEquipReady() -- Line: 34
            -- upvalues: Script (copy)
            local v2;

            if Script:GetAttribute("InitialEquipReady") == true and Script:GetAttribute("WeaponReady") == true then
                v2 = Script:GetAttribute("SwapInProgress") ~= true;
            else
                v2 = false;
            end;

            return v2;
        end;

        local function RunWhenInitialEquipReady(u3) -- Line: 40
            -- upvalues: Character2 (copy), Script (copy)
            task.spawn(function() -- Line: 41
                -- upvalues: Character2 (ref), Script (ref), u3 (copy)
                for _ = 1, 30 do
                    if Character2.RoundEndCleanupTriggered == true then
                        return;
                    end;

                    local v4;

                    if Script:GetAttribute("InitialEquipReady") == true and Script:GetAttribute("WeaponReady") == true then
                        v4 = Script:GetAttribute("SwapInProgress") ~= true;
                    else
                        v4 = false;
                    end;

                    if v4 == true then
                        u3();

                        return;
                    end;

                    task.wait(0.1);
                end;

                u3();
            end);
        end;

        local function CastClimbRay() -- Line: 110
            -- upvalues: Modules (copy), Camera (copy), Character (copy), Services (copy)
            local v5 = Modules.Components.Player.ClimbRayCast(Camera.CFrame.Position, Camera.CFrame.LookVector, 5, { Character, Camera });

            return v5 and (v5.Instance and Services.CollectionService:HasTag(v5.Instance, "Climb")) and true or false;
        end;

        local function GetActionPositions(p6, p7) -- Line: 118
            -- upvalues: Character (copy)
            local v8 = p7.Position + p7.CFrame.LookVector * 1 - Vector3.new(0, 0.5, 0);
            local v9 = p7.Position - p7.CFrame.LookVector * 1 - Vector3.new(0, 0.5, 0);
            local v10 = {};

            if (Character.PrimaryPart.Position - v8).Magnitude < (Character.PrimaryPart.Position - v9).Magnitude then
                v10.Start = v8;
                v10.End = v9 - p7.CFrame.LookVector * 1;

                return v10;
            end;

            v10.Start = v9;
            v10.End = v8 + p7.CFrame.LookVector * 1;

            return v10;
        end;

        local function CastVaultRay() -- Line: 134
            -- upvalues: Modules (copy), Camera (copy), Character (copy), Services (copy), GetActionPositions (copy), Player (copy), GameEvents (copy), WeaponDataNew (copy)
            local v11 = Modules.Components.Player.VaultRayCast(Camera.CFrame.Position, Camera.CFrame.LookVector, Modules.Config.DefaultVaultDistance, { Character, Camera });

            if v11 and v11.Instance then
                local Magnitude = (v11.Instance.Position - Character.PrimaryPart.Position).Magnitude;

                if Services.CollectionService:HasTag(v11.Instance, "Window") and (Magnitude <= Modules.Config.VaultPromptDistance and v11.Instance:GetAttribute("CanVault") == true) then
                    local v12 = GetActionPositions(Player, v11.Instance);
                    local v13 = v12.End - v12.Start;
                    local v14 = Vector3.new(v13.X, 0, v13.Z);

                    if v14.Magnitude <= 0.001 then
                        local LookVector = v11.Instance.CFrame.LookVector;
                        v14 = Vector3.new(LookVector.X, 0, LookVector.Z);
                    end;

                    local v15 = v14.Magnitude <= 0.001 and Vector3.new(0, 0, -1) or v14.Unit;
                    local v16 = CFrame.lookAt(v12.Start, v12.Start + v15);
                    local v17 = CFrame.lookAt(v12.End, v12.End + v15);
                    GameEvents:WaitForChild("VaultSync"):FireServer({
                        EntryDuration = 0.25,
                        CrossDuration = 0.35,
                        Window = v11.Instance,
                        StartCFrame = v16,
                        EndCFrame = v17
                    });
                    WeaponDataNew:Vault();
                    Character.PrimaryPart.Anchored = true;
                    Modules.Components.Menu.TweenCreate(Character.PrimaryPart, {
                        CFrame = v16
                    }, Enum.EasingStyle.Linear, 0.25, true);
                    Modules.Components.Menu.TweenCreate(Character.PrimaryPart, {
                        CFrame = v17
                    }, Enum.EasingStyle.Linear, 0.35, true);
                    Character.PrimaryPart.Anchored = false;
                end;
            end;
        end;

        Character:SetAttribute("Barricading", false);
        Script.Destroying:Connect(function() -- Line: 214
            -- upvalues: Character2 (copy), API (copy), ClientData (copy), State (copy), ClearCacheCamera (copy)
            Character2.RoundEndCleanupTriggered = true;
            API.Movement.ResetPendingSprintExitState();
            ClientData.PlayerHUD.Visible = false;
            ClientData.MobileControlsMenu.Visible = false;
            State.WeaponAction.QuickThrowHoldActive = false;
            State.WeaponAction.ThrowableRecoveryActive = false;
            API.WeaponAction.SetThrowablePreviewBridgeState(false);
            ClearCacheCamera();
        end);
        ServerFolder:GetAttributeChangedSignal("Phase"):Connect(function() -- Line: 225
            -- upvalues: Character2 (copy), ClientData (copy), API (copy)
            if Character2.RoundEndCleanupTriggered == true then
                return;
            end;

            if ClientData.MobileControlsMenu then
                ClientData.MobileControlsMenu.Visible = API.Input.CanShowMobileControlsMenu();

                if ClientData.MobileControlsMenu.Visible then
                    API.Input.UpdateClawMode();
                    API.Input.RefreshMobileControlsPosition();
                end;
            end;
        end);
        GameEvents.SwapWeapon.OnClientEvent:Connect(function(p18, p19) -- Line: 238
            -- upvalues: API (copy), WeaponDataNew (copy), Presentation (copy), Character2 (copy), Script (copy)
            if p18 == "Equip" then
                API.WeaponAction.SwapWeapon(p19.Index);

                return;
            end;

            if p18 == "Confirm" then
                WeaponDataNew:ConfirmServerEquip(p19 or {});
                API.WeaponAction.ApplyConfirmedWeaponSlot(p19 or {});

                return;
            end;

            if p18 ~= "Reject" then
                if p18 == "SetUp" then
                    task.defer(function() -- Line: 248
                        -- upvalues: Presentation (ref), Character2 (ref), Script (ref), API (ref)
                        if Presentation.InitialWeaponEquipCompleted == true or Character2.RoundEndCleanupTriggered == true then
                            return;
                        end;

                        local v20;

                        if Script:GetAttribute("InitialEquipReady") == true and Script:GetAttribute("WeaponReady") == true then
                            v20 = Script:GetAttribute("SwapInProgress") ~= true;
                        else
                            v20 = false;
                        end;

                        if v20 ~= true then
                            if API.Presentation.TryInitialWeaponEquip("server setup") == true then
                                Presentation.InitialWeaponEquipCompleted = true;
                                Presentation.InitialWeaponEquipVisualized = true;
                            end;

                            return;
                        end;

                        Presentation.InitialWeaponEquipCompleted = true;
                        Presentation.InitialWeaponEquipVisualized = true;
                    end);
                end;

                return;
            end;

            WeaponDataNew:RejectPendingEquip(p19);
            API.WeaponAction.ApplyConfirmedWeaponSlot(p19 or {});
        end);
        GameEvents.SoundCue.OnClientEvent:Connect(function(p21, p22, p23, p24) -- Line: 265
            -- upvalues: API (copy), Player (copy)
            if p21:IsA("Model") then
                local v25 = p21.HumanoidRootPart:FindFirstChild(p22);

                if v25 == nil and p24 then
                    if p21:FindFirstChild(p24) then
                        v25 = p21:FindFirstChild(p24).Handle:FindFirstChild(p22);
                    else
                        v25 = nil;
                    end;
                end;

                if v25 and p21 ~= Player then
                    if p23 == true then
                        v25:Play();

                        return;
                    end;

                    v25:Stop();
                end;
            elseif p21.Character and p21.Character:FindFirstChild("HumanoidRootPart") then
                local v26 = p21.Character.HumanoidRootPart:FindFirstChild(p22);

                if v26 == nil and p24 then
                    v26 = API.WeaponAction.resolveEquippedCharacterWeaponModel(p21.Character, p24);

                    if v26 then
                        v26 = v26:FindFirstChild("Handle", true);
                    end;

                    if v26 then
                        v26 = v26:FindFirstChild(p22);
                    end;
                end;

                if v26 and p21 ~= Player then
                    if p23 == true then
                        v26:Play();

                        return;
                    end;

                    v26:Stop();
                end;
            end;
        end);
        GameEvents.Hit.OnClientEvent:Connect(function(p27, p28, p29, p30, p31, p32) -- Line: 301
            -- upvalues: Player (copy), Modules (copy)
            if p27 == Player then
                return;
            end;

            Modules.Components.HitEffect.Hit(p28, p29, p30, p31, p32, p27);
        end);
        GameEvents.HitFromServer.OnClientEvent:Connect(function(p33, p34, p35, p36, p37, p38) -- Line: 308
            -- upvalues: Modules (copy)
            Modules.Components.HitEffect.Hit(p34, p35, p36, p37, p38, p33);
        end);
        GameEvents.Shoot.OnClientEvent:Connect(function(p39, p40) -- Line: 312
            -- upvalues: API (copy)
            API.WeaponAction.ShootEffect(p39, p40);
        end);
        GameEvents.PingLocation.OnClientEvent:Connect(function(p41, p42, p43, p44) -- Line: 316
            -- upvalues: Player (copy), Services (copy), Modules (copy)
            if Player.Team ~= p41.Team then
                return;
            end;

            local v45 = workspace.Map_Cache:FindFirstChild("Ping" .. p41.Name);

            if v45 then
                v45:Destroy();
            end;

            local u46 = Services.ReplicatedStorage.Components.GameMenu.Ping:Clone();
            u46.Parent = workspace.Map_Cache;
            u46.CFrame = CFrame.new(p42, p42 + p44);
            u46.PingFrame.Enabled = true;
            u46.Name = "Ping" .. p41.Name;
            u46.Beep:Play();
            u46.PingFrame.Pin.Player.Image = p41.ServerData:GetAttribute("ProfilePicture");
            u46.SurfaceGui.Circle.Size = UDim2.new(0, 0, 0, 0);
            u46.PingFrame.Enabled = true;
            u46.SurfaceGui.Enabled = true;
            Modules.Components.Menu.TweenCreate(u46.SurfaceGui.Circle, {
                ImageTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0)
            }, Enum.EasingStyle.Sine, 1, false);
            Modules.Components.Menu.TweenCreate(u46.PingFrame, {
                ExtentsOffset = Vector3.new(0, 2, 0),
                Size = UDim2.new(0, 50, 0, 50)
            }, Enum.EasingStyle.Sine, 0.2, false);
            task.wait(0.5);
            pcall(function() -- Line: 335
                -- upvalues: Modules (ref), u46 (copy), Services (ref)
                Modules.Components.Menu.TweenCreate(u46.PingFrame, {
                    ExtentsOffset = Vector3.new(0, 0, 0),
                    Size = UDim2.new(0, 25, 0, 25)
                }, Enum.EasingStyle.Bounce, 0.2, false);
                Services.Debris:AddItem(u46, 5);
            end);
        end);
        GameEvents.SpawnPlayer.OnClientEvent:Connect(function(u47) -- Line: 341
            -- upvalues: Helpers (copy), Character2 (copy), Script (copy)
            local function ApplySpawnLook() -- Line: 342
                -- upvalues: u47 (copy), Helpers (ref)
                local CurrentCamera = workspace.CurrentCamera;
                local v48 = u47 * Vector3.new(1, 0, 1);

                if v48.Magnitude <= 0 then
                    return;
                end;

                if Helpers.IsFirstPersonSpectateCameraActive() == true then
                    return;
                end;

                CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + v48.Unit);
            end;

            local function u50() -- Line: 354
                -- upvalues: u47 (copy), Helpers (ref), ApplySpawnLook (copy)
                local CurrentCamera = workspace.CurrentCamera;
                local v49 = u47 * Vector3.new(1, 0, 1);

                if v49.Magnitude > 0 and Helpers.IsFirstPersonSpectateCameraActive() ~= true then
                    CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + v49.Unit);
                end;

                task.defer(ApplySpawnLook);
                task.delay(0.1, ApplySpawnLook);
            end;

            task.spawn(function() -- Line: 41
                -- upvalues: Character2 (ref), Script (ref), u50 (copy)
                for _ = 1, 30 do
                    if Character2.RoundEndCleanupTriggered == true then
                        return;
                    end;

                    local v51;

                    if Script:GetAttribute("InitialEquipReady") == true and Script:GetAttribute("WeaponReady") == true then
                        v51 = Script:GetAttribute("SwapInProgress") ~= true;
                    else
                        v51 = false;
                    end;

                    if v51 == true then
                        u50();

                        return;
                    end;

                    task.wait(0.1);
                end;

                u50();
            end);
        end);
        task.spawn(function() -- Line: 361
            -- upvalues: PlayerGui (copy)
            PlayerGui.GameHUD.DamageFeed.Heal.ImageTransparency = 1;
        end);
        GameEvents.HitMarker.OnClientEvent:Connect(function(p52) -- Line: 365
            -- upvalues: Modules (copy)
            local _ = Modules.Config.HitMarker == true;
        end);
        Humanoid.StateChanged:Connect(function(p53, p54) -- Line: 181, Name: onHumanoidStateChanged
            -- upvalues: CastClimbRay (copy), WeaponDataNew (copy)
            if p54 == Enum.HumanoidStateType.Climbing and p53 ~= Enum.HumanoidStateType.Climbing then
                if CastClimbRay() == true then
                    WeaponDataNew:HolsterWeapon(false);
                    WeaponDataNew.Animations.Client.Climb:Play();
                    WeaponDataNew.Animations.Server.Climb:Play();
                end;
            elseif p54 ~= Enum.HumanoidStateType.Climbing and (p53 == Enum.HumanoidStateType.Climbing and WeaponDataNew.Holster == false) then
                WeaponDataNew:HolsterWeapon(true);
                WeaponDataNew.Animations.Client.Climb:Stop();
                WeaponDataNew.Animations.Server.Climb:Stop();
            end;
        end);
        Humanoid.Jumping:Connect(function(p55) -- Line: 203, Name: onHumanoidJumping
            -- upvalues: API (copy), WeaponDataNew (copy), Modules (copy)
            local v56 = API.Movement.GetMovement();

            if WeaponDataNew.Jumping == false and (p55 and (v56 ~= "Proning" and (v56 ~= "Crouching" and v56 ~= "Freezing"))) then
                WeaponDataNew.Jumping = true;
                task.wait(Modules.Config.JumpCooldown);
                WeaponDataNew.Jumping = false;
            end;
        end);
        Humanoid.Died:Connect(function() -- Line: 198, Name: onHumanoidDied
            -- upvalues: API (copy), ClientData (copy)
            API.Movement.ResetPendingSprintExitState();
            ClientData.GameHUD.ScopeUI.Visible = false;
        end);
        Character:GetAttributeChangedSignal("Barricading"):Connect(function() -- Line: 90, Name: onBarricadingAttributeSignalChanged
            -- upvalues: Character (copy), API (copy), WeaponDataNew (copy)
            local v57 = Character:GetAttribute("Barricading");

            if v57 ~= true then
                if v57 == false then
                    API.Movement.SetMovement("Standing", false);

                    if WeaponDataNew.CurrentTool then
                        WeaponDataNew:HolsterWeapon(true);
                        WeaponDataNew:ExitBarricadePresentation();
                    end;

                    WeaponDataNew.Animations.Client.Barricade:Stop();
                end;

                return;
            end;

            API.Movement.ResetPendingSprintExitState();
            API.Movement.SetMovement("Standing", false);

            if WeaponDataNew.CurrentTool then
                WeaponDataNew:EnterBarricadePresentation();
                WeaponDataNew:HolsterWeapon(false);
            end;

            WeaponDataNew.Animations.Client.Barricade:Play();
        end);
        local v58 = Helpers.getGuiInset();
        ClientData.GameHUD.ScopeUI.Scope.Position = UDim2.new(0.5, State.Runtime.ScopeSwaySin, 0.5, State.Runtime.ScopeSwayCos + v58);

        return {
            CleanupClientWeaponSystem = function(p59) -- Line: 56, Name: CleanupClientWeaponSystem
                -- upvalues: Character2 (copy), Presentation (copy), API (copy), ClientData (copy), ClearCacheCamera (copy), WeaponDataNew (copy), State (copy), Script (copy)
                if Character2.RoundEndCleanupTriggered == true then
                    return;
                end;

                Character2.RoundEndCleanupTriggered = true;
                Presentation.InitialEquipRetryInProgress = false;
                Presentation.InitialWeaponEquipCompleted = false;
                Presentation.InitialWeaponEquipVisualized = false;
                API.Movement.ResetPendingSprintExitState();
                ClientData.PlayerHUD.Visible = false;
                ClientData.MobileControlsMenu.Visible = false;
                ClearCacheCamera();

                if WeaponDataNew then
                    WeaponDataNew.CurrentTool = nil;
                    WeaponDataNew.CurrentToolIndex = 0;
                    WeaponDataNew.Reloading = false;
                end;

                State.Runtime.SampledLaserTarget = nil;
                State.Runtime.ActiveLocalLaserWeaponModel = nil;
                State.WeaponAction.QuickThrowHoldActive = false;
                State.WeaponAction.QuickThrowPreviousWeaponIndex = 0;
                State.WeaponAction.ThrowableRecoveryActive = false;
                API.WeaponAction.SetThrowablePreviewBridgeState(false);
                task.defer(function() -- Line: 83
                    -- upvalues: Script (ref)
                    if Script.Parent then
                        Script:Destroy();
                    end;
                end);
            end,

            ClearCacheCamera = ClearCacheCamera,
            CastClimbRay = CastClimbRay,
            CastVaultRay = CastVaultRay,

            Vault = function() -- Line: 172, Name: Vault
                -- upvalues: WeaponDataNew (copy), Player (copy), API (copy), CastVaultRay (copy)
                if WeaponDataNew.Animations.Client.Vault.IsPlaying == false and (Player.ServerData:GetAttribute("Alive") == true and API.Movement.GetMovement() ~= "Proning") then
                    if API.Movement.GetMovement() == "Crouching" or API.Movement.GetMovement() == "Proning" then
                        API.Movement.SetMovement("Standing", false);
                    end;

                    CastVaultRay();
                end;
            end
        };
    end
};