
return {
    init = function(u1) -- Line: 4, Name: init
        local Services = u1.Services;
        local Refs = u1.Refs;
        local Modules = u1.Modules;
        local State = u1.State;
        local Constants = u1.Constants;
        local Player = Refs.Player;
        local _ = Refs.PlayerGui;
        local Humanoid = Refs.Humanoid;
        local Camera = Refs.Camera;
        local Script = Refs.Script;
        local ServerFolder = Refs.ServerFolder;
        local _ = Refs.GameEvents;
        local ClientData = State.ClientData;
        local WeaponDataNew = State.WeaponDataNew;
        local Presentation = State.Presentation;
        local Keybinds = State.Keybinds;
        local PlayerSettings = State.PlayerSettings;
        local u2 = 0;

        local function ResolveActiveWeaponTargetFOV() -- Line: 26
            -- upvalues: WeaponDataNew (copy), PlayerSettings (copy)
            local v3 = WeaponDataNew and WeaponDataNew.CurrentTool;

            if not v3 or (v3.Aiming ~= true or not v3.Tool) then
                return nil;
            end;

            if v3.Tool:GetAttribute("ADSType") == "Scope" then
                return 25;
            end;

            if v3.Settings then
                return PlayerSettings:GetAttribute("FieldOfView") - 5 * v3.Settings.ADSZoom;
            end;

            return nil;
        end;

        local function TweenFOV(p4, u5) -- Line: 43
            -- upvalues: ResolveActiveWeaponTargetFOV (copy), u2 (ref), Modules (copy), Camera (copy)
            local u6 = ResolveActiveWeaponTargetFOV() or p4;
            u2 = u2 + 1;
            local u7 = u2;
            task.spawn(function() -- Line: 47
                -- upvalues: u7 (copy), u2 (ref), Modules (ref), Camera (ref), u6 (copy), u5 (copy)
                if u7 ~= u2 then
                    return;
                end;

                Modules.Components.Menu.TweenCreate(Camera, {
                    FieldOfView = u6
                }, Enum.EasingStyle.Linear, u5, true);
            end);
        end;

        local function GetEquipmentScroller() -- Line: 55
            -- upvalues: ClientData (copy)
            local v8 = ClientData and ClientData.PlayerHUD;

            if v8 then
                v8 = v8:FindFirstChild("Equipment");
            end;

            if v8 then
                v8 = v8:FindFirstChild("Scroller");
            end;

            if v8 and v8:IsA("GuiObject") then
                return v8;
            end;

            return nil;
        end;

        local function ResolveEquipmentRow(p9) -- Line: 65
            -- upvalues: ClientData (copy)
            if typeof(p9) ~= "string" or p9 == "" then
                return nil, nil;
            end;

            local v10 = ClientData and ClientData.PlayerHUD;

            if v10 then
                v10 = v10:FindFirstChild("Equipment");
            end;

            if v10 then
                v10 = v10:FindFirstChild("Scroller");
            end;

            if not (v10 and v10:IsA("GuiObject")) then
                v10 = nil;
            end;

            if not v10 then
                return nil, nil;
            end;

            local v11 = v10:FindFirstChild(p9);

            if not (v11 and v11:IsA("ImageButton")) then
                return nil, nil;
            end;

            local Button = v11:FindFirstChild("Button");

            if Button and Button:IsA("GuiObject") then
                return v11, Button;
            end;

            return v11, nil;
        end;

        local function ResolveEquipmentAmmoNodes(p12) -- Line: 84
            -- upvalues: ResolveEquipmentRow (copy)
            local v13, v14 = ResolveEquipmentRow(p12);

            if not v14 then
                return v13, v14, nil, nil, nil;
            end;

            local AmmoCount = v14:FindFirstChild("AmmoCount");

            if not (AmmoCount and AmmoCount:IsA("GuiObject")) then
                return v13, v14, nil, nil, nil;
            end;

            local Ammo = AmmoCount:FindFirstChild("Ammo");

            if Ammo and not Ammo:IsA("TextLabel") then
                Ammo = nil;
            end;

            local MaxAmmo = AmmoCount:FindFirstChild("MaxAmmo");
            local v15 = MaxAmmo and MaxAmmo:FindFirstChild("Ammo") or nil;

            if v15 and not v15:IsA("TextLabel") then
                v15 = nil;
            end;

            return v13, v14, AmmoCount, Ammo, v15;
        end;

        local function SelectHUDEquipment(p16) -- Line: 105
            -- upvalues: ClientData (copy), Modules (copy), Constants (copy), ResolveEquipmentRow (copy)
            local v17 = ClientData and ClientData.PlayerHUD;

            if v17 then
                v17 = v17:FindFirstChild("Equipment");
            end;

            if v17 then
                v17 = v17:FindFirstChild("Scroller");
            end;

            if not (v17 and v17:IsA("GuiObject")) then
                v17 = nil;
            end;

            if not v17 then
                return;
            end;

            for _, child in pairs(v17:GetChildren()) do
                if child:IsA("ImageButton") and child.Name ~= p16 then
                    local Button = child:FindFirstChild("Button");

                    if Button and Button:IsA("GuiObject") then
                        Modules.Components.Menu.TweenCreate(child, {
                            Size = UDim2.new(1, 0, 0.15, 0)
                        }, Enum.EasingStyle.Sine, 0.1, false);
                        Modules.Components.Menu.TweenCreate(Button, {
                            Size = UDim2.new(1, 0, 1, 0)
                        }, Enum.EasingStyle.Sine, 0.1, false);
                        local ItemPort = Button:FindFirstChild("ItemPort");

                        if ItemPort then
                            Modules.Components.Menu.TweenCreate(ItemPort, {
                                Size = UDim2.new(0.363, 0, 1, 0)
                            }, Enum.EasingStyle.Sine, 0.1, false);
                            ItemPort.Ambient = Constants.WHITE;
                        end;

                        Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                        local AmmoCount = Button:FindFirstChild("AmmoCount");
                        local v18;

                        if AmmoCount then
                            v18 = AmmoCount:FindFirstChild("Ammo") or nil;
                        else
                            v18 = nil;
                        end;

                        local v19 = AmmoCount and AmmoCount:FindFirstChild("MaxAmmo") or nil;
                        local v20 = v19 and v19:FindFirstChild("Ammo") or nil;

                        if v18 and v18:IsA("TextLabel") then
                            v18.TextColor3 = Constants.WHITE;
                        end;

                        if v20 and v20:IsA("TextLabel") then
                            v20.TextColor3 = Constants.WHITE;
                        end;
                    end;
                end;
            end;

            local v21, v22 = ResolveEquipmentRow(p16);

            if v21 and v22 then
                Modules.Components.Menu.TweenCreate(v21, {
                    Size = UDim2.new(1, 0, 0.2, 0)
                }, Enum.EasingStyle.Sine, 0.1, false);
                Modules.Components.Menu.TweenCreate(v22, {
                    Size = UDim2.new(1.05, 0, 1, 0)
                }, Enum.EasingStyle.Sine, 0.1, false);
                local ItemPort = v22:FindFirstChild("ItemPort");

                if ItemPort then
                    Modules.Components.Menu.TweenCreate(ItemPort, {
                        Size = UDim2.new(0.363, 0, 0.6, 0)
                    }, Enum.EasingStyle.Sine, 0.1, false);
                    ItemPort.Ambient = Color3.fromRGB(0, 0, 0);
                end;

                v22.BackgroundColor3 = Constants.WHITE;
                local AmmoCount = v22:FindFirstChild("AmmoCount");
                local v23;

                if AmmoCount then
                    v23 = AmmoCount:FindFirstChild("Ammo") or nil;
                else
                    v23 = nil;
                end;

                local v24 = AmmoCount and AmmoCount:FindFirstChild("MaxAmmo") or nil;
                local v25 = v24 and v24:FindFirstChild("Ammo") or nil;

                if v23 and v23:IsA("TextLabel") then
                    v23.TextColor3 = Color3.fromRGB(0, 0, 0);
                end;

                if v25 and v25:IsA("TextLabel") then
                    v25.TextColor3 = Color3.fromRGB(0, 0, 0);
                end;
            end;
        end;

        local function ResolvePresentationOverride(p26, p27, p28) -- Line: 160
            if p26[p27] == nil then
                return p28;
            end;

            return p26[p27];
        end;

        local function PushSpectatePresentationState(p29) -- Line: 168
            -- upvalues: WeaponDataNew (copy), Script (copy), u1 (copy), Camera (copy), ClientData (copy)
            if WeaponDataNew == nil or WeaponDataNew.PushRuntimeState == nil then
                return;
            end;

            local v30 = p29 or {};
            local CurrentTool = WeaponDataNew.CurrentTool;
            local v31 = WeaponDataNew.CurrentState or "Hold";
            local v32;

            if WeaponDataNew.Crosshair then
                v32 = WeaponDataNew.Crosshair.Enabled == true;
            else
                v32 = false;
            end;

            local v33, v34;

            if CurrentTool and CurrentTool.Tool then
                v33 = tonumber(CurrentTool.Tool:GetAttribute("Ammo")) or 0;
                v34 = tonumber(CurrentTool.Tool:GetAttribute("StoredAmmo")) or (tonumber(CurrentTool.Tool:GetAttribute("Amount")) or 0);
            else
                v33 = 0;
                v34 = 0;
            end;

            local v35 = {};
            local v36 = CurrentTool and CurrentTool.Aiming == true and true or false;

            if v30.Aiming ~= nil then
                v36 = v30.Aiming;
            end;

            v35.Aiming = v36;
            local v37 = v31 == "Inspect";

            if v30.Inspecting ~= nil then
                v37 = v30.Inspecting;
            end;

            v35.Inspecting = v37;
            local v38 = CurrentTool and CurrentTool.Reloading == true and true or false;

            if v30.Reloading ~= nil then
                v38 = v30.Reloading;
            end;

            v35.Reloading = v38;
            local Holster = WeaponDataNew.Holster;

            if v30.Holstered ~= nil then
                Holster = v30.Holstered;
            end;

            v35.Holstered = Holster;
            local v39 = Script:GetAttribute("ThrowablePreviewActive") == true;

            if v30.ThrowablePreviewActive ~= nil then
                v39 = v30.ThrowablePreviewActive;
            end;

            v35.ThrowablePreviewActive = v39;
            local v40 = Script:GetAttribute("ThrowablePreviewToolName") or "";

            if v30.ThrowablePreviewToolName ~= nil then
                v40 = v30.ThrowablePreviewToolName;
            end;

            v35.ThrowablePreviewToolName = v40;
            local v41 = u1.API.Movement.GetMovement();

            if v30.Movement ~= nil then
                v41 = v30.Movement;
            end;

            v35.Movement = v41;
            local v42 = u1.API.Movement.GetLean();

            if v30.Lean ~= nil then
                v42 = v30.Lean;
            end;

            v35.Lean = v42;
            local FieldOfView = Camera.FieldOfView;

            if v30.TargetFOV ~= nil then
                FieldOfView = v30.TargetFOV;
            end;

            v35.TargetFOV = FieldOfView;
            local v43 = ClientData.GameHUD.ScopeUI.Visible == true;

            if v30.ScopeVisible ~= nil then
                v43 = v30.ScopeVisible;
            end;

            v35.ScopeVisible = v43;

            if v30.CrosshairVisible ~= nil then
                v32 = v30.CrosshairVisible;
            end;

            v35.CrosshairVisible = v32;

            if v30.CurrentAmmo ~= nil then
                v33 = v30.CurrentAmmo;
            end;

            v35.CurrentAmmo = v33;

            if v30.StoredAmmo ~= nil then
                v34 = v30.StoredAmmo;
            end;

            v35.StoredAmmo = v34;
            WeaponDataNew:PushRuntimeState(v31, v35);
        end;

        local function IsInitialWeaponReady() -- Line: 237
            -- upvalues: WeaponDataNew (copy), Script (copy)
            local v44 = false;
            local v45;

            if WeaponDataNew.CurrentTool == nil or (WeaponDataNew.CurrentTool.Tool == nil or WeaponDataNew.CurrentTool.Model == nil) then
                v45 = false;
            else
                v45 = WeaponDataNew.CurrentToolIndex ~= 0;
            end;

            if v45 == true then
                if Script:GetAttribute("WeaponReady") == true and Script:GetAttribute("SwapInProgress") ~= true then
                    v44 = Script:GetAttribute("InitialEquipReady") == true;
                else
                    v44 = false;
                end;
            end;

            return v44;
        end;

        local function TryInitialWeaponEquip(p46) -- Line: 244
            -- upvalues: Presentation (copy), WeaponDataNew (copy), Script (copy), SelectHUDEquipment (copy)
            if Presentation.InitialWeaponEquipCompleted == true then
                local v47 = false;
                local v48;

                if WeaponDataNew.CurrentTool == nil or (WeaponDataNew.CurrentTool.Tool == nil or WeaponDataNew.CurrentTool.Model == nil) then
                    v48 = false;
                else
                    v48 = WeaponDataNew.CurrentToolIndex ~= 0;
                end;

                if v48 == true then
                    if Script:GetAttribute("WeaponReady") == true and Script:GetAttribute("SwapInProgress") ~= true then
                        v47 = Script:GetAttribute("InitialEquipReady") == true;
                    else
                        v47 = false;
                    end;
                end;

                return v47 == true;
            end;

            local v49 = false;
            local v50;

            if WeaponDataNew.CurrentTool == nil or (WeaponDataNew.CurrentTool.Tool == nil or WeaponDataNew.CurrentTool.Model == nil) then
                v50 = false;
            else
                v50 = WeaponDataNew.CurrentToolIndex ~= 0;
            end;

            if v50 == true then
                if Script:GetAttribute("WeaponReady") == true and Script:GetAttribute("SwapInProgress") ~= true then
                    v49 = Script:GetAttribute("InitialEquipReady") == true;
                else
                    v49 = false;
                end;
            end;

            if v49 == true then
                Presentation.InitialWeaponEquipCompleted = true;
                Presentation.InitialWeaponEquipVisualized = true;

                return true;
            end;

            if Presentation.InitialEquipRetryInProgress == true then
                return false;
            end;

            Presentation.InitialEquipRetryInProgress = true;
            local v51 = false;

            for _ = 1, 12 do
                for _, v in ipairs({ 1, 2, 3, 4 }) do
                    if WeaponDataNew:HasRegisteredTool(v) and WeaponDataNew:SwapTools(v) == true then
                        if WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Tool then
                            SelectHUDEquipment(WeaponDataNew.CurrentTool.Tool.Name);
                            v51 = true;
                        else
                            v51 = true;
                        end;

                        break;
                    end;
                end;

                if v51 == true then
                    break;
                end;

                task.wait(0.25);
            end;

            if v51 == true then
                for _ = 1, 30 do
                    local v52 = false;
                    local v53;

                    if WeaponDataNew.CurrentTool == nil or (WeaponDataNew.CurrentTool.Tool == nil or WeaponDataNew.CurrentTool.Model == nil) then
                        v53 = false;
                    else
                        v53 = WeaponDataNew.CurrentToolIndex ~= 0;
                    end;

                    if v53 == true then
                        if Script:GetAttribute("WeaponReady") == true and Script:GetAttribute("SwapInProgress") ~= true then
                            v52 = Script:GetAttribute("InitialEquipReady") == true;
                        else
                            v52 = false;
                        end;
                    end;

                    if v52 == true then
                        Presentation.InitialWeaponEquipCompleted = true;
                        Presentation.InitialWeaponEquipVisualized = true;
                        break;
                    end;

                    task.wait(0.1);
                end;

                if Presentation.InitialWeaponEquipCompleted ~= true then
                    warn((`[ClientWeaponSystemHotfix] Initial weapon equip never reached ready state ({p46})`));
                    v51 = false;
                end;
            else
                warn((`[ClientWeaponSystemHotfix] Initial weapon equip recovery failed ({p46})`));
            end;

            Presentation.InitialEquipRetryInProgress = false;

            return v51;
        end;

        Services.ReplicatedStorage:WaitForChild("Binds"):WaitForChild("SensitivityUpdated").Event:Connect(function(p54, p55) -- Line: 300
            -- upvalues: Keybinds (copy), WeaponDataNew (copy), Modules (copy)
            Keybinds.CameraSensitivity = p54;
            Keybinds.ADSSensitivity = p55;

            if not WeaponDataNew.CurrentTool then
                return;
            end;

            if not WeaponDataNew.CurrentTool.Aiming then
                Modules.CameraSens:AdjustSensitivity(Keybinds.CameraSensitivity);

                return;
            end;

            if WeaponDataNew.CurrentTool.Tool:GetAttribute("ADSType") == "Scope" then
                Modules.CameraSens:AdjustSensitivity(Keybinds.ADSSensitivity * 0.5);

                return;
            end;

            Modules.CameraSens:AdjustSensitivity(Keybinds.ADSSensitivity);
        end);
        task.delay(1, function() -- Line: 319
            -- upvalues: WeaponDataNew (copy), ClientData (copy), Script (copy), Modules (copy), Constants (copy), ResolveEquipmentAmmoNodes (copy), Player (copy), ServerFolder (copy), Humanoid (copy), Services (copy), Presentation (copy), TryInitialWeaponEquip (copy), PlayerSettings (copy), ResolveActiveWeaponTargetFOV (copy), u2 (ref), Camera (copy), PushSpectatePresentationState (copy)
            repeat
                task.wait(0.1);
            until WeaponDataNew and (WeaponDataNew.Tools and (WeaponDataNew.Tools.Primary and (WeaponDataNew.Tools.Secondary and (WeaponDataNew.Tools.Knife and (WeaponDataNew.Tools.Primary.Tool and (WeaponDataNew.Tools.Primary.Model and (WeaponDataNew.Tools.Primary.Tool:FindFirstChild("Settings") and WeaponDataNew.Tools.Primary.Tool.Settings:FindFirstChild("Animations"))))))));

            task.wait(0.5);
            (function() -- Line: 333, Name: HUDConfig
                -- upvalues: ClientData (ref), WeaponDataNew (ref), Script (ref), Modules (ref), Constants (ref), ResolveEquipmentAmmoNodes (ref), Player (ref), ServerFolder (ref), Humanoid (ref)
                local v56 = ClientData and ClientData.PlayerHUD;

                if v56 then
                    v56 = v56:FindFirstChild("Equipment");
                end;

                if v56 then
                    v56 = v56:FindFirstChild("Scroller");
                end;

                if not (v56 and v56:IsA("GuiObject")) then
                    v56 = nil;
                end;

                if not v56 then
                    return;
                end;

                for _, child in pairs(v56:GetChildren()) do
                    if child:IsA("ImageButton") then
                        child:Destroy();
                    end;
                end;

                for i, v in pairs(WeaponDataNew.Tools) do
                    if v and v.Tool then
                        local Name = v.Tool.Name;
                        local v57 = Script.Prefabs.SampleLoadoutHUD:Clone();
                        v57.Parent = v56;
                        v57.Name = Name;
                        local Button = v57:FindFirstChild("Button");

                        if Button and Button:IsA("GuiObject") then
                            local ItemPort = Button:FindFirstChild("ItemPort");

                            if ItemPort and ItemPort:IsA("ViewportFrame") then
                                if i == "Primary" or i == "Secondary" then
                                    Modules.Components.Menu.AddItemToViewport({
                                        Type = "Weapon",
                                        Name = Name
                                    }, ItemPort);
                                else
                                    Modules.Components.Menu.AddItemToViewport({
                                        Name = Name,
                                        Type = i
                                    }, ItemPort);
                                end;

                                for _, descendant in pairs(ItemPort:GetDescendants()) do
                                    if descendant:IsA("BasePart") then
                                        descendant.Color = Constants.WHITE;
                                        descendant.Material = Enum.Material.SmoothPlastic;

                                        if descendant:IsA("MeshPart") then
                                            descendant.TextureID = "";
                                        end;
                                    end;
                                end;
                            end;

                            if i == "Primary" then
                                v57.LayoutOrder = 1;
                            elseif i == "Secondary" then
                                v57.LayoutOrder = 2;
                            elseif i == "Knife" then
                                v57.LayoutOrder = 3;
                            elseif i == "Throwable" then
                                v57.LayoutOrder = 4;
                            end;

                            local function UpdateFirearmHud(p58) -- Line: 387
                                -- upvalues: ResolveEquipmentAmmoNodes (ref), Name (copy), v (copy), Modules (ref)
                                local _, _, v59, v60, v61 = ResolveEquipmentAmmoNodes(Name);

                                if not v59 then
                                    return;
                                end;

                                local v62 = tonumber(v.Tool:GetAttribute("Ammo")) or 0;
                                local v63 = math.floor(v62);
                                local v64 = tonumber(v.Tool:GetAttribute("StoredAmmo")) or 0;
                                local v65 = math.floor(v64);

                                if v60 then
                                    v60.Text = tostring(v63);

                                    if p58 == true then
                                        Modules.Components.Menu.TweenCreate(v60, {
                                            TextColor3 = Color3.fromRGB(255, 50, 50)
                                        }, Enum.EasingStyle.Bounce, 0.03, true);
                                        Modules.Components.Menu.TweenCreate(v60, {
                                            TextColor3 = Color3.fromRGB(0, 0, 0)
                                        }, Enum.EasingStyle.Bounce, 0.03, false);
                                    end;

                                    v60.TextColor3 = v63 <= 0 and Color3.fromRGB(160, 50, 50) or Color3.fromRGB(0, 0, 0);
                                end;

                                if v61 then
                                    v61.Text = tostring(v65);
                                end;
                            end;

                            local function UpdateThrowableHud(p66) -- Line: 407
                                -- upvalues: ResolveEquipmentAmmoNodes (ref), Name (copy), v (copy), Modules (ref)
                                local _, v67, v68, v69, v70 = ResolveEquipmentAmmoNodes(Name);

                                if not v67 then
                                    return;
                                end;

                                local Infinie = v67:FindFirstChild("Infinie");

                                if v68 then
                                    v68.Visible = true;
                                end;

                                if Infinie and Infinie:IsA("GuiObject") then
                                    Infinie.Visible = false;
                                end;

                                local v71 = tonumber(v.Tool:GetAttribute("Amount")) or 0;
                                local v72 = math.floor(v71);

                                if v69 then
                                    v69.Text = tostring(v72);

                                    if p66 == true then
                                        Modules.Components.Menu.TweenCreate(v69, {
                                            TextColor3 = Color3.fromRGB(255, 50, 50)
                                        }, Enum.EasingStyle.Bounce, 0.03, true);
                                        Modules.Components.Menu.TweenCreate(v69, {
                                            TextColor3 = Color3.fromRGB(0, 0, 0)
                                        }, Enum.EasingStyle.Bounce, 0.03, false);
                                    end;

                                    v69.TextColor3 = v72 <= 0 and Color3.fromRGB(160, 50, 50) or Color3.fromRGB(0, 0, 0);
                                end;

                                if v70 then
                                    v70.Text = "";
                                end;
                            end;

                            if i == "Primary" or i == "Secondary" then
                                UpdateFirearmHud(false);
                                v.Tool:GetAttributeChangedSignal("Ammo"):Connect(function() -- Line: 435
                                    -- upvalues: UpdateFirearmHud (copy)
                                    UpdateFirearmHud(true);
                                end);
                                v.Tool:GetAttributeChangedSignal("StoredAmmo"):Connect(function() -- Line: 438
                                    -- upvalues: UpdateFirearmHud (copy)
                                    UpdateFirearmHud(false);
                                end);
                            elseif i == "Knife" then
                                local AmmoCount = Button:FindFirstChild("AmmoCount");
                                local Infinie = Button:FindFirstChild("Infinie");

                                if AmmoCount and AmmoCount:IsA("GuiObject") then
                                    AmmoCount.Visible = false;
                                end;

                                if Infinie and Infinie:IsA("GuiObject") then
                                    Infinie.Visible = true;
                                end;
                            elseif i == "Throwable" then
                                UpdateThrowableHud(false);
                                v.Tool:GetAttributeChangedSignal("Amount"):Connect(function() -- Line: 452
                                    -- upvalues: UpdateThrowableHud (copy)
                                    UpdateThrowableHud(true);
                                end);
                            end;
                        else
                            v57:Destroy();
                        end;
                    end;
                end;

                (function() -- Line: 459, Name: ConfigPlayerHUDVisibility
                    -- upvalues: ClientData (ref), Player (ref), ServerFolder (ref)
                    if ClientData.PlayerHUDVisibilityConfigured then
                        return;
                    end;

                    ClientData.PlayerHUDVisibilityConfigured = true;

                    local function Refresh() -- Line: 465
                        -- upvalues: Player (ref), ClientData (ref), ServerFolder (ref)
                        local ServerData = Player:FindFirstChild("ServerData");

                        if not ServerData then
                            ClientData.PlayerHUD.Visible = false;

                            return;
                        end;

                        local v73 = ServerFolder:GetAttribute("Phase");
                        local v74 = ServerFolder:GetAttribute("Attacker");
                        local v75 = ServerData:GetAttribute("Alive") == true;
                        local v76 = Player.Team and Player.Team.Name == v74;
                        local v77 = v73 == "Round Started";
                        local v78 = v73 == "Round Ended";
                        local v79 = v73 == "Preparation";

                        if v75 then
                            if v77 then
                                v79 = v77;
                            elseif v78 then
                                v79 = v78;
                            elseif v79 then
                                v79 = not v76;
                            end;
                        else
                            v79 = v75;
                        end;

                        ClientData.PlayerHUD.Visible = v79;
                    end;

                    Refresh();
                    ServerFolder:GetAttributeChangedSignal("Phase"):Connect(Refresh);
                    ServerFolder:GetAttributeChangedSignal("Attacker"):Connect(Refresh);
                    Player:GetPropertyChangedSignal("Team"):Connect(Refresh);
                    local ServerData = Player:WaitForChild("ServerData", 10);

                    if ServerData then
                        ServerData:GetAttributeChangedSignal("Alive"):Connect(Refresh);
                    end;
                end)();

                for _, child in pairs(ClientData.PlayerHUD.Health.HealthBar:GetChildren()) do
                    if child:IsA("Frame") then
                        child:Destroy();
                    end;
                end;

                ClientData.PlayerHUD.Health.HealthAmount.Health.Text = math.floor(Humanoid.Health);
                ClientData.PlayerHUD.Health.HealthAmount.MaxHealth.Health.Text = "/" .. math.floor(Humanoid.MaxHealth);
                local v80 = math.ceil(Humanoid.MaxHealth / 50);
                local u81 = Humanoid.MaxHealth % 50;

                for i = 1, v80 do
                    local u82 = Script:WaitForChild("Prefabs").HealthSample:Clone();
                    u82.Parent = ClientData.PlayerHUD.Health.HealthBar;
                    u82.LayoutOrder = i;

                    if i == v80 and (v80 ~= 1 and u81 ~= 0) then
                        u82.Size = UDim2.new(0.25 * (u81 / 50), 0, 1, 0);
                        Humanoid.HealthChanged:Connect(function() -- Line: 519
                            -- upvalues: u82 (copy), Humanoid (ref), i (copy), u81 (copy)
                            if u82 and u82:FindFirstChild("Bar") then
                                local v83 = math.clamp(Humanoid.Health - (i - 1) * 50, 0, u81);
                                u82.Bar.Size = UDim2.new(v83 / u81, 0, 1, 0);
                            end;
                        end);
                    else
                        Humanoid.HealthChanged:Connect(function() -- Line: 511
                            -- upvalues: u82 (copy), Humanoid (ref), i (copy)
                            if u82 and u82:FindFirstChild("Bar") then
                                local v84 = math.clamp(Humanoid.Health - (i - 1) * 50, 0, 50);
                                u82.Bar.Size = UDim2.new(v84 / 50, 0, 1, 0);
                            end;
                        end);
                    end;
                end;

                Humanoid.HealthChanged:Connect(function() -- Line: 528
                    -- upvalues: ClientData (ref), Humanoid (ref)
                    ClientData.PlayerHUD.Health.HealthAmount.Health.Text = math.floor(Humanoid.Health);
                    ClientData.PlayerHUD.Health.HealthAmount.MaxHealth.Health.Text = "/" .. math.floor(Humanoid.MaxHealth);
                end);
            end)();
            Services.ReplicatedStorage.GameEvents.SpawnTransition:FireServer();
            task.wait(0.5);

            if Presentation.InitialWeaponEquipCompleted ~= true then
                local v85 = false;
                local v86;

                if WeaponDataNew.CurrentTool == nil or (WeaponDataNew.CurrentTool.Tool == nil or WeaponDataNew.CurrentTool.Model == nil) then
                    v86 = false;
                else
                    v86 = WeaponDataNew.CurrentToolIndex ~= 0;
                end;

                if v86 == true then
                    if Script:GetAttribute("WeaponReady") == true and Script:GetAttribute("SwapInProgress") ~= true then
                        v85 = Script:GetAttribute("InitialEquipReady") == true;
                    else
                        v85 = false;
                    end;
                end;

                if v85 == true then
                    Presentation.InitialWeaponEquipCompleted = true;
                    Presentation.InitialWeaponEquipVisualized = true;
                elseif Presentation.InitialWeaponEquipVisualized ~= true and TryInitialWeaponEquip("initial startup fallback") ~= true then
                    warn("Initial weapon equip retry sequence failed. HUD equipment selection cancelled.");

                    return;
                end;
            end;

            for _ = 1, 30 do
                local v87 = false;
                local v88;

                if WeaponDataNew.CurrentTool == nil or (WeaponDataNew.CurrentTool.Tool == nil or WeaponDataNew.CurrentTool.Model == nil) then
                    v88 = false;
                else
                    v88 = WeaponDataNew.CurrentToolIndex ~= 0;
                end;

                if v88 == true then
                    if Script:GetAttribute("WeaponReady") == true and Script:GetAttribute("SwapInProgress") ~= true then
                        v87 = Script:GetAttribute("InitialEquipReady") == true;
                    else
                        v87 = false;
                    end;
                end;

                if v87 == true then
                    break;
                end;

                task.wait(0.1);
            end;

            local v89 = false;
            local v90;

            if WeaponDataNew.CurrentTool == nil or (WeaponDataNew.CurrentTool.Tool == nil or WeaponDataNew.CurrentTool.Model == nil) then
                v90 = false;
            else
                v90 = WeaponDataNew.CurrentToolIndex ~= 0;
            end;

            if v90 == true then
                if Script:GetAttribute("WeaponReady") == true and Script:GetAttribute("SwapInProgress") ~= true then
                    v89 = Script:GetAttribute("InitialEquipReady") == true;
                else
                    v89 = false;
                end;
            end;

            if v89 ~= true then
                warn("Initial weapon readiness gate timed out before presentation finished.");

                return;
            end;

            local v91 = PlayerSettings:GetAttribute("FieldOfView");
            local u92 = ResolveActiveWeaponTargetFOV() or v91;
            u2 = u2 + 1;
            local u93 = u2;
            local u94 = 0.15;
            task.spawn(function() -- Line: 47
                -- upvalues: u93 (copy), u2 (ref), Modules (ref), Camera (ref), u92 (copy), u94 (copy)
                if u93 ~= u2 then
                    return;
                end;

                Modules.Components.Menu.TweenCreate(Camera, {
                    FieldOfView = u92
                }, Enum.EasingStyle.Linear, u94, true);
            end);
            PushSpectatePresentationState({
                ScopeVisible = false,
                TargetFOV = PlayerSettings:GetAttribute("FieldOfView"),
                CrosshairVisible = WeaponDataNew.Crosshair and WeaponDataNew.Crosshair.Enabled == true and true or false
            });
        end);

        return {
            TweenFOV = TweenFOV,
            SelectHUDEquipment = SelectHUDEquipment,
            PushSpectatePresentationState = PushSpectatePresentationState,

            SyncSpectateAmmoState = function() -- Line: 205, Name: SyncSpectateAmmoState
                -- upvalues: WeaponDataNew (copy), Presentation (copy), PushSpectatePresentationState (copy)
                local v95 = WeaponDataNew and WeaponDataNew.CurrentTool;

                if v95 then
                    v95 = v95.Tool;
                end;

                if v95 then
                    local v96 = tonumber(v95:GetAttribute("Ammo")) or 0;
                    local v97 = tonumber(v95:GetAttribute("StoredAmmo")) or (tonumber(v95:GetAttribute("Amount")) or 0);

                    if v95 ~= Presentation.LastSyncedSpectateAmmoTool or (v96 ~= Presentation.LastSyncedSpectateAmmo or v97 ~= Presentation.LastSyncedSpectateStoredAmmo) then
                        Presentation.LastSyncedSpectateAmmoTool = v95;
                        Presentation.LastSyncedSpectateAmmo = v96;
                        Presentation.LastSyncedSpectateStoredAmmo = v97;
                        PushSpectatePresentationState({
                            CurrentAmmo = v96,
                            StoredAmmo = v97
                        });
                    end;

                    return;
                end;

                Presentation.LastSyncedSpectateAmmoTool = nil;
                Presentation.LastSyncedSpectateAmmo = nil;
                Presentation.LastSyncedSpectateStoredAmmo = nil;
            end,

            TryInitialWeaponEquip = TryInitialWeaponEquip,

            HasValidCurrentTool = function() -- Line: 230, Name: HasValidCurrentTool
                -- upvalues: WeaponDataNew (copy)
                local v98;

                if WeaponDataNew.CurrentTool == nil or (WeaponDataNew.CurrentTool.Tool == nil or WeaponDataNew.CurrentTool.Model == nil) then
                    v98 = false;
                else
                    v98 = WeaponDataNew.CurrentToolIndex ~= 0;
                end;

                return v98;
            end
        };
    end
};