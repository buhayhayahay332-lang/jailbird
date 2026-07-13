
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
        local ServerFolder = Refs.ServerFolder;
        local GameEvents = Refs.GameEvents;
        local ClientData = State.ClientData;
        local WeaponDataNew = State.WeaponDataNew;
        local Keybinds = State.Keybinds;
        local ADSToggle = State.ADSToggle;
        local LeanToggle = State.LeanToggle;
        local PlayerSettings = State.PlayerSettings;

        local function IsDeadOrSpectating() -- Line: 26
            -- upvalues: Player (copy), State (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            return (not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true;
        end;

        local function IsGamepadInputType(p2) -- Line: 34
            return p2.Name:match("^Gamepad") ~= nil;
        end;

        local function GetTouchMovementControls() -- Line: 38
            -- upvalues: ClientData (copy), Player (copy)
            if ClientData.TouchMovementControls ~= nil then
                return ClientData.TouchMovementControls;
            end;

            local PlayerScripts = Player:FindFirstChild("PlayerScripts");

            if not PlayerScripts then
                return nil;
            end;

            local PlayerModule = PlayerScripts:FindFirstChild("PlayerModule");

            if not (PlayerModule and PlayerModule:IsA("ModuleScript")) then
                return nil;
            end;

            local success, result = pcall(require, PlayerModule);

            if success ~= true or (result == nil or result.GetControls == nil) then
                return nil;
            end;

            ClientData.TouchMovementControls = result:GetControls();

            return ClientData.TouchMovementControls;
        end;

        local function SetRobloxTouchMovementEnabled(p3) -- Line: 58
            -- upvalues: Services (copy), GetTouchMovementControls (copy), ClientData (copy)
            if Services.UserInputService.TouchEnabled ~= true then
                return;
            end;

            local v4 = GetTouchMovementControls();

            if not v4 then
                return;
            end;

            if p3 == true then
                if ClientData.TouchMovementControlsDisabled == true then
                    v4:Enable();
                    ClientData.TouchMovementControlsDisabled = false;
                end;
            elseif ClientData.TouchMovementControlsDisabled ~= true then
                v4:Disable();
                ClientData.TouchMovementControlsDisabled = true;
            end;
        end;

        local function GetMobileJoystickObjects() -- Line: 77
            -- upvalues: ClientData (copy)
            local JoystickRectangle = ClientData.MobileControlsMenu:FindFirstChild("JoystickRectangle");

            if not (JoystickRectangle and JoystickRectangle:IsA("ImageButton")) then
                return nil, nil, nil;
            end;

            local JoystickBase = JoystickRectangle:FindFirstChild("JoystickBase");

            if not (JoystickBase and JoystickBase:IsA("ImageButton")) then
                return JoystickRectangle, nil, nil;
            end;

            local JoystickButton = JoystickBase:FindFirstChild("JoystickButton");

            if JoystickButton and JoystickButton:IsA("ImageButton") then
                return JoystickRectangle, JoystickBase, JoystickButton;
            end;

            return JoystickRectangle, JoystickBase, nil;
        end;

        local function IsPointInsideGuiObject(p5, p6) -- Line: 90
            if not p5 then
                return false;
            end;

            local AbsolutePosition = p5.AbsolutePosition;
            local AbsoluteSize = p5.AbsoluteSize;
            local v7;

            if p6.X >= AbsolutePosition.X and (p6.X <= AbsolutePosition.X + AbsoluteSize.X and p6.Y >= AbsolutePosition.Y) then
                v7 = p6.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
            else
                v7 = false;
            end;

            return v7;
        end;

        local function CanShowMobileControlsMenu() -- Line: 100
            -- upvalues: Player (copy), ServerFolder (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ServerData then
                ServerData = ServerData:GetAttribute("Alive") == true;
            end;

            if Player:GetAttribute("OnMobile") ~= true or ServerData ~= true then
                return false;
            end;

            local v8 = ServerFolder:GetAttribute("Phase");
            local v9 = ServerFolder:GetAttribute("Attacker");

            return (v8 == "Round Started" or v8 == "Round Ended") and true or (v8 == "Preparation" and not (Player.Team and Player.Team.Name == v9) and true or false);
        end;

        local function IsTouchOnMobileControl(p10) -- Line: 123
            -- upvalues: ClientData (copy)
            if not ClientData.MobileControlsMenu then
                return false;
            end;

            for _, v in ipairs({ "Aim", "Jump", "Crouch", "Prone", "LeanLeft", "LeanRight", "Reload", "Ping", "Grenade", "Swap", "Knife", "Shoot", "ShootStatic", "JoystickRectangle" }) do
                local v11 = ClientData.MobileControlsMenu:FindFirstChild(v);

                if v11 and v11:IsA("GuiObject") then
                    local v12;

                    if v11 then
                        local AbsolutePosition = v11.AbsolutePosition;
                        local AbsoluteSize = v11.AbsoluteSize;

                        if p10.X >= AbsolutePosition.X and (p10.X <= AbsolutePosition.X + AbsoluteSize.X and p10.Y >= AbsolutePosition.Y) then
                            v12 = p10.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                        else
                            v12 = false;
                        end;
                    else
                        v12 = false;
                    end;

                    if v12 then
                        return true;
                    end;
                end;
            end;

            return false;
        end;

        local function IsTouchInsideJoystickRectangle(p13) -- Line: 150
            -- upvalues: GetMobileJoystickObjects (copy)
            local v14 = GetMobileJoystickObjects();

            if not v14 then
                return false;
            end;

            local AbsolutePosition = v14.AbsolutePosition;
            local AbsoluteSize = v14.AbsoluteSize;
            local v15;

            if p13.X >= AbsolutePosition.X and (p13.X <= AbsolutePosition.X + AbsoluteSize.X and p13.Y >= AbsolutePosition.Y) then
                v15 = p13.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
            else
                v15 = false;
            end;

            return v15;
        end;

        local function GetMobileShootTouchKey(p16) -- Line: 155
            -- upvalues: ClientData (copy)
            if not ClientData.MobileControlsMenu then
                return nil;
            end;

            local Shoot = ClientData.MobileControlsMenu:FindFirstChild("Shoot");

            if Shoot and Shoot:IsA("GuiObject") then
                local v17;

                if Shoot then
                    local AbsolutePosition = Shoot.AbsolutePosition;
                    local AbsoluteSize = Shoot.AbsoluteSize;

                    if p16.X >= AbsolutePosition.X and (p16.X <= AbsolutePosition.X + AbsoluteSize.X and p16.Y >= AbsolutePosition.Y) then
                        v17 = p16.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                    else
                        v17 = false;
                    end;
                else
                    v17 = false;
                end;

                if v17 then
                    return "ShootTouch";
                end;
            end;

            local ShootStatic = ClientData.MobileControlsMenu:FindFirstChild("ShootStatic");

            if ShootStatic and ShootStatic:IsA("GuiObject") then
                local v18;

                if ShootStatic then
                    local AbsolutePosition = ShootStatic.AbsolutePosition;
                    local AbsoluteSize = ShootStatic.AbsoluteSize;

                    if p16.X >= AbsolutePosition.X and (p16.X <= AbsolutePosition.X + AbsoluteSize.X and p16.Y >= AbsolutePosition.Y) then
                        v18 = p16.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                    else
                        v18 = false;
                    end;
                else
                    v18 = false;
                end;

                if v18 then
                    return "ShootStaticTouch";
                end;
            end;

            return nil;
        end;

        local function ResetMobileJoystick() -- Line: 170
            -- upvalues: ClientData (copy), GetMobileJoystickObjects (copy), Humanoid (copy)
            ClientData.JoystickTouch = nil;
            ClientData.JoystickTouchPosition = nil;
            ClientData.MobileMovementVector = Vector2.zero;
            ClientData.JoystickBaseCenter = nil;
            ClientData.JoystickBaseRadius = nil;
            ClientData.JoystickSprint = false;
            ClientData.RunningHold = false;
            local _, v19, v20 = GetMobileJoystickObjects();

            if v19 and v20 then
                v19.Visible = false;
                v20.Position = UDim2.fromScale(0.5, 0.5);
            end;

            if Humanoid then
                Humanoid:Move(Vector3.new(0, 0, 0), false);
            end;
        end;

        local function BeginMobileJoystick(p21) -- Line: 190
            -- upvalues: Player (copy), ClientData (copy), GetMobileJoystickObjects (copy)
            if p21.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if Player:GetAttribute("OnMobile") ~= true then
                return;
            end;

            if not ClientData.MobileControlsMenu or ClientData.MobileControlsMenu.Visible ~= true then
                return;
            end;

            if ClientData.JoystickTouch and ClientData.JoystickTouch ~= p21 then
                return;
            end;

            local v22, v23, v24 = GetMobileJoystickObjects();

            if not (v22 and (v23 and v24)) then
                return;
            end;

            local v25 = math.min(v23.AbsoluteSize.X, v23.AbsoluteSize.Y) * 0.5;
            local v26 = math.max(1, v25);
            local AbsoluteSize = v22.AbsoluteSize;
            local AbsolutePosition = v22.AbsolutePosition;
            local v27 = Vector2.new(p21.Position.X - AbsolutePosition.X, p21.Position.Y - AbsolutePosition.Y);
            local v28 = Vector2.new(math.clamp(v27.X, v26, AbsoluteSize.X - v26), (math.clamp(v27.Y, v26, AbsoluteSize.Y - v26)));
            ClientData.JoystickTouch = p21;
            ClientData.JoystickTouchPosition = Vector2.new(p21.Position.X, p21.Position.Y);
            ClientData.JoystickBaseCenter = v28;
            ClientData.JoystickBaseRadius = v26;
            ClientData.MobileMovementVector = Vector2.zero;
            ClientData.JoystickSprint = false;
            v23.Position = UDim2.fromOffset(v28.X, v28.Y);
            v23.Visible = true;
            v24.Position = UDim2.fromScale(0.5, 0.5);
        end;

        local function StopMobileFireTouch(p29) -- Line: 220
            -- upvalues: ClientData (copy), PlayerSettings (copy), WeaponDataNew (copy), API (copy)
            local v30 = ClientData.ShootTouch == p29;
            local v31 = ClientData.ShootStaticTouch == p29;

            if v30 ~= true and v31 ~= true then
                return;
            end;

            if v30 then
                ClientData.ShootTouch = nil;
            end;

            if v31 then
                ClientData.ShootStaticTouch = nil;
            end;

            if ClientData.ShootTouch == nil and ClientData.ShootStaticTouch == nil then
                ClientData.MouseHeld = false;

                if PlayerSettings:GetAttribute("MobileAutoADS") == true and (WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Aiming == true) then
                    API.WeaponAction.AimDownSightRelease();
                end;
            end;
        end;

        local function SwitchToControllerMode(p32) -- Line: 240
            -- upvalues: ClientData (copy), Player (copy), ResetMobileJoystick (copy), Services (copy), GetTouchMovementControls (copy), GameEvents (copy)
            ClientData.LastInputType = p32 or Enum.UserInputType.Gamepad1;
            Player:SetAttribute("OnMobile", false);
            Player:SetAttribute("OnConsole", true);
            Player:SetAttribute("OnComputer", false);

            if ClientData.MobileControlsMenu then
                ClientData.MobileControlsMenu.Visible = false;
            end;

            ResetMobileJoystick();
            ClientData.ShootTouch = nil;
            ClientData.ShootStaticTouch = nil;
            ClientData.MouseHeld = false;

            if Services.UserInputService.TouchEnabled == true then
                local v33 = GetTouchMovementControls();

                if v33 and ClientData.TouchMovementControlsDisabled == true then
                    v33:Enable();
                    ClientData.TouchMovementControlsDisabled = false;
                end;
            end;

            GameEvents.DeviceUpdate:FireServer("Console");
        end;

        local function UpdateClawMode() -- Line: 258
            -- upvalues: ClientData (copy)
            for _, child in pairs(ClientData.MobileControlsMenu:GetChildren()) do
                if child:IsA("GuiButton") then
                    child.Active = true;
                end;
            end;

            local JoystickRectangle = ClientData.MobileControlsMenu:FindFirstChild("JoystickRectangle");

            if JoystickRectangle and JoystickRectangle:IsA("ImageButton") then
                JoystickRectangle.Active = true;
                local JoystickBase = JoystickRectangle:FindFirstChild("JoystickBase");

                if JoystickBase and JoystickBase:IsA("ImageButton") then
                    JoystickBase.Active = false;
                end;
            end;

            local Shoot = ClientData.MobileControlsMenu:FindFirstChild("Shoot");

            if Shoot and Shoot:IsA("ImageButton") then
                Shoot.Active = false;
            end;

            local ShootStatic = ClientData.MobileControlsMenu:FindFirstChild("ShootStatic");

            if ShootStatic and ShootStatic:IsA("ImageButton") then
                ShootStatic.Active = true;
            end;
        end;

        local function SwitchToMobileMode(p34) -- Line: 294
            -- upvalues: Services (copy), ClientData (copy), Player (copy), PlayerGui (copy), CanShowMobileControlsMenu (copy), UpdateClawMode (copy), Modules (copy), GetMobileJoystickObjects (copy), ResetMobileJoystick (copy), GetTouchMovementControls (copy), GameEvents (copy)
            if Services.UserInputService.TouchEnabled ~= true then
                return;
            end;

            ClientData.LastInputType = p34 or Enum.UserInputType.Touch;
            Player:SetAttribute("OnMobile", true);
            Player:SetAttribute("OnConsole", false);
            Player:SetAttribute("OnComputer", false);
            local MobileControlsMenu = PlayerGui.GameHUD:FindFirstChild("MobileControlsMenu");

            if MobileControlsMenu and MobileControlsMenu ~= ClientData.MobileControlsMenu then
                MobileControlsMenu:Destroy();
            end;

            ClientData.MobileControlsMenu.Visible = false;
            ClientData.MobileControlsMenu.Parent = PlayerGui.GameHUD;
            ClientData.MobileControlsMenu.Visible = CanShowMobileControlsMenu();

            if ClientData.MobileControlsMenu.Visible then
                UpdateClawMode();
                Modules.Components.Menu.RefreshMobileControlsMenu(ClientData.MobileControlsMenu);
                local _, v35, v36 = GetMobileJoystickObjects();

                if v35 and v36 then
                    v35.Visible = false;
                    v36.Position = UDim2.fromScale(0.5, 0.5);
                end;
            else
                ResetMobileJoystick();

                if Services.UserInputService.TouchEnabled == true then
                    local v37 = GetTouchMovementControls();

                    if v37 and ClientData.TouchMovementControlsDisabled == true then
                        v37:Enable();
                        ClientData.TouchMovementControlsDisabled = false;
                    end;
                end;
            end;

            GameEvents.DeviceUpdate:FireServer("Mobile");
        end;

        local function HandleRuntimeDeviceInput(p38) -- Line: 321
            -- upvalues: Player (copy), SwitchToControllerMode (copy), IsTouchOnMobileControl (copy), SwitchToMobileMode (copy), ClientData (copy)
            if p38.UserInputType.Name:match("^Gamepad") ~= nil then
                if Player:GetAttribute("OnConsole") ~= true then
                    SwitchToControllerMode(p38.UserInputType);
                end;

                return;
            end;

            if p38.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if IsTouchOnMobileControl((Vector2.new(p38.Position.X, p38.Position.Y))) ~= true then
                return;
            end;

            if Player:GetAttribute("OnMobile") == true then
                ClientData.LastInputType = p38.UserInputType;

                return;
            end;

            SwitchToMobileMode(p38.UserInputType);
        end;

        local function StartMobileFireTouch(p39, p40, p41) -- Line: 340
            -- upvalues: Player (copy), State (copy), WeaponDataNew (copy), ClientData (copy), PlayerSettings (copy), API (copy)
            if p39.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return;
            end;

            if not (WeaponDataNew.CurrentTool and WeaponDataNew.CurrentTool.Model) then
                return;
            end;

            if ClientData[p40] ~= nil then
                return;
            end;

            if ClientData.ShootTouch ~= nil or ClientData.ShootStaticTouch ~= nil then
                return;
            end;

            ClientData[p40] = p39;
            ClientData.MouseHeld = true;

            if p41 == true and (PlayerSettings:GetAttribute("MobileAutoADS") == true and WeaponDataNew.CurrentTool.Aiming == false) then
                API.WeaponAction.AimDownSight();
            end;

            API.WeaponAction.Shoot();
        end;

        local function ConfigMobileControlsMenuVisibility() -- Line: 355
            -- upvalues: ClientData (copy), CanShowMobileControlsMenu (copy), UpdateClawMode (copy), Modules (copy), GetMobileJoystickObjects (copy), ResetMobileJoystick (copy), Services (copy), GetTouchMovementControls (copy), ServerFolder (copy), Player (copy)
            if ClientData.MobileControlsVisibilityConfigured then
                return;
            end;

            ClientData.MobileControlsVisibilityConfigured = true;

            local function Refresh() -- Line: 359
                -- upvalues: ClientData (ref), CanShowMobileControlsMenu (ref), UpdateClawMode (ref), Modules (ref), GetMobileJoystickObjects (ref), ResetMobileJoystick (ref), Services (ref), GetTouchMovementControls (ref)
                ClientData.MobileControlsMenu.Visible = CanShowMobileControlsMenu();

                if ClientData.MobileControlsMenu.Visible then
                    UpdateClawMode();
                    Modules.Components.Menu.RefreshMobileControlsMenu(ClientData.MobileControlsMenu);
                    local _, v42, v43 = GetMobileJoystickObjects();

                    if v42 and v43 then
                        v42.Visible = false;
                        v43.Position = UDim2.fromScale(0.5, 0.5);
                    end;
                else
                    ResetMobileJoystick();

                    if Services.UserInputService.TouchEnabled == true then
                        local v44 = GetTouchMovementControls();

                        if v44 and ClientData.TouchMovementControlsDisabled == true then
                            v44:Enable();
                            ClientData.TouchMovementControlsDisabled = false;
                        end;
                    end;

                    ClientData.ShootTouch = nil;
                    ClientData.ShootStaticTouch = nil;
                    ClientData.MouseHeld = false;
                end;
            end;

            ClientData.MobileControlsMenu.Visible = CanShowMobileControlsMenu();

            if ClientData.MobileControlsMenu.Visible then
                UpdateClawMode();
                Modules.Components.Menu.RefreshMobileControlsMenu(ClientData.MobileControlsMenu);
                local _, v45, v46 = GetMobileJoystickObjects();

                if v45 and v46 then
                    v45.Visible = false;
                    v46.Position = UDim2.fromScale(0.5, 0.5);
                end;
            else
                ResetMobileJoystick();

                if Services.UserInputService.TouchEnabled == true then
                    local v47 = GetTouchMovementControls();

                    if v47 and ClientData.TouchMovementControlsDisabled == true then
                        v47:Enable();
                        ClientData.TouchMovementControlsDisabled = false;
                    end;
                end;

                ClientData.ShootTouch = nil;
                ClientData.ShootStaticTouch = nil;
                ClientData.MouseHeld = false;
            end;

            ServerFolder:GetAttributeChangedSignal("Phase"):Connect(Refresh);
            ServerFolder:GetAttributeChangedSignal("Attacker"):Connect(Refresh);
            Player:GetPropertyChangedSignal("Team"):Connect(Refresh);
            local ServerData = Player:WaitForChild("ServerData", 10);

            if ServerData then
                ServerData:GetAttributeChangedSignal("Alive"):Connect(Refresh);
            end;

            Services.UserInputService.LastInputTypeChanged:Connect(function(p48) -- Line: 383
                -- upvalues: ClientData (ref)
                ClientData.LastInputType = p48;
            end);
        end;

        local function convertSwapToolInputToInt(p49) -- Line: 631
            -- upvalues: Keybinds (copy), WeaponDataNew (copy)
            return p49 == Keybinds.PC.SwapTool1 and 1 or (p49 == Keybinds.PC.SwapTool2 and 2 or (p49 == Keybinds.PC.SwapTool3 and 3 or (p49 == Keybinds.PC.SwapTool4 and 4 or (WeaponDataNew.CurrentToolIndex == 1 and 2 or 1))));
        end;

        UpdateClawMode();
        (function() -- Line: 388, Name: CheckForDevice
            -- upvalues: Services (copy), ClientData (copy), SwitchToControllerMode (copy), SwitchToMobileMode (copy), Player (copy), ResetMobileJoystick (copy), GetTouchMovementControls (copy), GameEvents (copy), ConfigMobileControlsMenuVisibility (copy)
            local v50 = Services.UserInputService:GetLastInputType();
            ClientData.LastInputType = v50;

            if v50.Name:match("^Gamepad") ~= nil then
                SwitchToControllerMode(v50);
            elseif Services.UserInputService.TouchEnabled and not Services.UserInputService.KeyboardEnabled or v50 == Enum.UserInputType.Touch then
                SwitchToMobileMode(v50);
            elseif Services.UserInputService.KeyboardEnabled and not Services.UserInputService.TouchEnabled then
                Player:SetAttribute("OnMobile", false);
                Player:SetAttribute("OnConsole", false);
                Player:SetAttribute("OnComputer", true);
                ResetMobileJoystick();

                if Services.UserInputService.TouchEnabled == true then
                    local v51 = GetTouchMovementControls();

                    if v51 and ClientData.TouchMovementControlsDisabled == true then
                        v51:Enable();
                        ClientData.TouchMovementControlsDisabled = false;
                    end;
                end;

                GameEvents.DeviceUpdate:FireServer("Computer");
            end;

            ConfigMobileControlsMenuVisibility();
        end)();
        (function(p52) -- Line: 481, Name: MobileBindingConfig
            -- upvalues: Services (copy), HandleRuntimeDeviceInput (copy), GetMobileShootTouchKey (copy), StartMobileFireTouch (copy), ClientData (copy), GetMobileJoystickObjects (copy), BeginMobileJoystick (copy), ResetMobileJoystick (copy), StopMobileFireTouch (copy), PlayerSettings (copy), WeaponDataNew (copy), API (copy), LeanToggle (copy), Character (copy), Modules (copy)
            p52:WaitForChild("JoystickRectangle");
            p52:WaitForChild("Shoot");
            p52:WaitForChild("ShootStatic");
            Services.UserInputService.InputBegan:Connect(function(p53) -- Line: 486
                -- upvalues: HandleRuntimeDeviceInput (ref), GetMobileShootTouchKey (ref), StartMobileFireTouch (ref), ClientData (ref), GetMobileJoystickObjects (ref), BeginMobileJoystick (ref)
                HandleRuntimeDeviceInput(p53);

                if p53.UserInputType == Enum.UserInputType.Touch then
                    local v54 = Vector2.new(p53.Position.X, p53.Position.Y);
                    local v55 = GetMobileShootTouchKey(v54);

                    if v55 ~= nil then
                        StartMobileFireTouch(p53, v55, true);

                        return;
                    end;

                    if ClientData.JoystickTouch == nil then
                        local v56 = GetMobileJoystickObjects();
                        local v57;

                        if v56 then
                            local AbsolutePosition = v56.AbsolutePosition;
                            local AbsoluteSize = v56.AbsoluteSize;

                            if v54.X >= AbsolutePosition.X and (v54.X <= AbsolutePosition.X + AbsoluteSize.X and v54.Y >= AbsolutePosition.Y) then
                                v57 = v54.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                            else
                                v57 = false;
                            end;
                        else
                            v57 = false;
                        end;

                        if v57 then
                            BeginMobileJoystick(p53);
                        end;
                    end;
                end;
            end);
            Services.UserInputService.InputChanged:Connect(function(p58) -- Line: 501
                -- upvalues: ClientData (ref)
                if p58 == ClientData.JoystickTouch then
                    ClientData.JoystickTouchPosition = Vector2.new(p58.Position.X, p58.Position.Y);
                end;
            end);
            Services.UserInputService.InputEnded:Connect(function(p59) -- Line: 507
                -- upvalues: ClientData (ref), ResetMobileJoystick (ref), StopMobileFireTouch (ref)
                if p59 == ClientData.JoystickTouch then
                    ResetMobileJoystick();
                end;

                StopMobileFireTouch(p59);
            end);
            p52:WaitForChild("Aim").MouseButton1Down:Connect(function() -- Line: 514
                -- upvalues: ClientData (ref), PlayerSettings (ref), WeaponDataNew (ref), API (ref)
                ClientData.ADSInputHeld = true;

                if PlayerSettings:GetAttribute("ADSToggle") ~= true then
                    if PlayerSettings:GetAttribute("ADSToggle") == false then
                        if WeaponDataNew.CurrentTool.Aiming == false then
                            API.WeaponAction.AimDownSight();
                        end;

                        ClientData.AimingToggleOff = true;
                    end;

                    return;
                end;

                if WeaponDataNew.CurrentTool.Aiming == false then
                    API.WeaponAction.AimDownSight();

                    return;
                end;

                API.WeaponAction.AimDownSightRelease();
            end);
            p52.Aim.MouseButton1Up:Connect(function() -- Line: 530
                -- upvalues: ClientData (ref), PlayerSettings (ref), API (ref)
                ClientData.ADSInputHeld = false;

                if PlayerSettings:GetAttribute("ADSToggle") == false then
                    API.WeaponAction.AimDownSightRelease();
                    ClientData.AimingToggleOff = false;
                end;
            end);
            p52:WaitForChild("LeanLeft").MouseButton1Down:Connect(function() -- Line: 538
                -- upvalues: API (ref)
                if API.Movement.GetLean() == -1 then
                    API.Movement.SetLean(0);

                    return;
                end;

                API.Movement.SetLean(-1);
            end);
            p52:WaitForChild("LeanRight").MouseButton1Down:Connect(function() -- Line: 546
                -- upvalues: API (ref)
                if API.Movement.GetLean() == 1 then
                    API.Movement.SetLean(0);

                    return;
                end;

                API.Movement.SetLean(1);
            end);
            p52.LeanLeft.MouseButton1Up:Connect(function() -- Line: 554
                -- upvalues: LeanToggle (ref), API (ref)
                if LeanToggle == false then
                    API.Movement.SetLean(0);
                end;
            end);
            p52.LeanRight.MouseButton1Up:Connect(function() -- Line: 560
                -- upvalues: LeanToggle (ref), API (ref)
                if LeanToggle == false then
                    API.Movement.SetLean(0);
                end;
            end);
            p52:WaitForChild("Knife").MouseButton1Click:Connect(function() -- Line: 566
                -- upvalues: API (ref)
                API.WeaponAction.QuickKnife();
            end);
            p52:WaitForChild("Reload").MouseButton1Click:Connect(function() -- Line: 570
                -- upvalues: API (ref)
                API.WeaponAction.Reload();
            end);
            p52:WaitForChild("Ping").MouseButton1Click:Connect(function() -- Line: 574
                -- upvalues: API (ref)
                API.WeaponAction.Ping();
            end);
            local Grenade = p52:WaitForChild("Grenade");
            Grenade.MouseButton1Down:Connect(function() -- Line: 579
                -- upvalues: API (ref)
                API.WeaponAction.StartQuickThrowHold();
            end);
            Grenade.MouseButton1Up:Connect(function() -- Line: 582
                -- upvalues: API (ref)
                API.WeaponAction.ReleaseQuickThrowHold(true);
            end);
            local u60 = 1;
            p52:WaitForChild("Swap").MouseButton1Click:Connect(function() -- Line: 587
                -- upvalues: u60 (ref), API (ref)
                if u60 == 1 then
                    API.WeaponAction.SwapWeapon(u60);
                    u60 = 2;

                    return;
                end;

                API.WeaponAction.SwapWeapon(u60);
                u60 = 1;
            end);
            p52:WaitForChild("Jump").MouseButton1Click:Connect(function() -- Line: 597
                -- upvalues: Character (ref), WeaponDataNew (ref), API (ref)
                if Character:FindFirstChild("Humanoid") ~= nil and WeaponDataNew.Jumping == false then
                    Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping);

                    if API.Character and API.Character.Vault then
                        API.Character.Vault();
                    end;
                end;
            end);
            p52:WaitForChild("Crouch").MouseButton1Click:Connect(function() -- Line: 608
                -- upvalues: API (ref)
                if API.Movement.GetMovement() == "Crouching" then
                    API.Movement.SetMovement("Standing", true);

                    return;
                end;

                API.Movement.SetMovement("Crouching");
            end);
            p52:WaitForChild("Prone").MouseButton1Click:Connect(function() -- Line: 616
                -- upvalues: ClientData (ref), API (ref), Modules (ref)
                if ClientData.ProneCooldown ~= true then
                    if API.Movement.GetMovement() == "Proning" then
                        API.Movement.SetMovement("Standing", true);
                    else
                        API.Movement.SetLean(0);
                        API.Movement.SetMovement("Proning");
                    end;

                    ClientData.ProneCooldown = true;
                    task.wait(Modules.Config.ProneCooldown);
                    ClientData.ProneCooldown = false;
                end;
            end);
        end)(ClientData.MobileControlsMenu);
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_AIM, function(p61, p62, p63) -- Line: 642, Name: handleAim
            -- upvalues: Modules (copy), Player (copy), State (copy), WeaponDataNew (copy), ClientData (copy), ADSToggle (copy), API (copy)
            if p61 ~= Modules.Constants.ACTION_AIM then
                return Enum.ContextActionResult.Pass;
            end;

            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if not WeaponDataNew.CurrentTool then
                return Enum.ContextActionResult.Pass;
            end;

            if p62 == Enum.UserInputState.Begin then
                ClientData.ADSInputHeld = true;

                if ADSToggle then
                    if WeaponDataNew.CurrentTool.Aiming == false then
                        ClientData.RunningHold = false;
                        API.WeaponAction.AimDownSight();
                    else
                        API.WeaponAction.AimDownSightRelease();
                    end;
                else
                    if WeaponDataNew.CurrentTool.Aiming == false then
                        ClientData.RunningHold = false;
                        API.WeaponAction.AimDownSight();
                    else
                        warn(Modules.Utility.warnCustom("Failed to aim in because player is already aiming in with ADS toggled off"));
                    end;

                    ClientData.AimingToggleOff = true;
                end;
            elseif ADSToggle then
                ClientData.ADSInputHeld = false;
            else
                ClientData.ADSInputHeld = false;
                API.WeaponAction.AimDownSightRelease();
                ClientData.AimingToggleOff = false;
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetAimKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_RUN, function(p64, p65, p66) -- Line: 676, Name: handleRun
            -- upvalues: Player (copy), State (copy), Modules (copy), WeaponDataNew (copy), API (copy), ClientData (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p64 == Modules.Constants.ACTION_RUN then
                if p65 == Enum.UserInputState.Begin then
                    local CurrentTool = WeaponDataNew.CurrentTool;

                    if CurrentTool and CurrentTool.Aiming == true then
                        API.WeaponAction.AimDownSightRelease();
                    end;

                    ClientData.RunningHold = true;
                elseif p65 == Enum.UserInputState.End then
                    ClientData.RunningHold = false;
                end;
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetRunKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_LEAN, function(p67, p68, p69) -- Line: 709, Name: handleLean
            -- upvalues: Player (copy), State (copy), Modules (copy), Keybinds (copy), API (copy), LeanToggle (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p67 == Modules.Constants.ACTION_LEAN then
                local v70 = (p69.KeyCode == Keybinds.PC.LeanLeft or p69.KeyCode == Keybinds.Controller.LeanLeft) and -1 or ((p69.KeyCode == Keybinds.PC.LeanRight or p69.KeyCode == Keybinds.Controller.LeanRight) and 1 or 0);
                local v71 = API.Movement.GetLean();

                if p68 == Enum.UserInputState.Begin then
                    if v71 == v70 then
                        API.Movement.SetLean(0);
                    else
                        API.Movement.SetLean(v70);
                    end;
                elseif p68 == Enum.UserInputState.End and (LeanToggle == false and v71 == v70) then
                    API.Movement.SetLean(0);
                end;
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetLeanKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_PING, function(p72, p73, p74) -- Line: 701, Name: handlePing
            -- upvalues: Player (copy), State (copy), Modules (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p72 == Modules.Constants.ACTION_PING and p73 == Enum.UserInputState.Begin then
                API.WeaponAction.Ping();
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetPingKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_SWAP, function(p75, p76, p77) -- Line: 692, Name: handleSwap
            -- upvalues: Player (copy), State (copy), Modules (copy), Keybinds (copy), WeaponDataNew (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p75 == Modules.Constants.ACTION_SWAP and p76 == Enum.UserInputState.Begin then
                local KeyCode = p77.KeyCode;
                API.WeaponAction.SwapWeapon(KeyCode == Keybinds.PC.SwapTool1 and 1 or (KeyCode == Keybinds.PC.SwapTool2 and 2 or (KeyCode == Keybinds.PC.SwapTool3 and 3 or (KeyCode == Keybinds.PC.SwapTool4 and 4 or (WeaponDataNew.CurrentToolIndex == 1 and 2 or 1)))));
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetSwapKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_VAULT, function(p78, p79, p80) -- Line: 782, Name: handleVault
            -- upvalues: Player (copy), State (copy), Modules (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p78 == Modules.Constants.ACTION_VAULT and (p79 == Enum.UserInputState.Begin and (API.Character and API.Character.Vault)) then
                API.Character.Vault();
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetJumpKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_PRONE, function(p81, p82, p83) -- Line: 736, Name: handleProne
            -- upvalues: Player (copy), State (copy), Modules (copy), Keybinds (copy), ClientData (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p81 == Modules.Constants.ACTION_PRONE and p82 == Enum.UserInputState.Begin then
                if p83.KeyCode == Keybinds.Controller.Prone then
                    ClientData.CrouchingHold = true;
                    ClientData.CrouchingHoldTimer = os.clock();

                    return Enum.ContextActionResult.Pass;
                end;

                if ClientData.ProneCooldown then
                    return Enum.ContextActionResult.Pass;
                end;

                ClientData.ProneCooldown = true;

                if API.Movement.GetMovement() == "Proning" then
                    API.Movement.SetMovement("Standing", true);
                else
                    ClientData.RunningHold = false;
                    API.Movement.SetLean(0);
                    API.Movement.SetMovement("Proning");
                end;

                task.spawn(function() -- Line: 758
                    -- upvalues: Modules (ref), ClientData (ref)
                    task.wait(Modules.Config.ProneCooldown);
                    ClientData.ProneCooldown = false;
                end);
            else
                ClientData.CrouchingHold = false;
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetProneKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_SHOOT, function(p84, p85, p86) -- Line: 769, Name: handleShoot
            -- upvalues: Player (copy), State (copy), Modules (copy), ClientData (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p84 == Modules.Constants.ACTION_SHOOT then
                if p85 == Enum.UserInputState.Begin then
                    ClientData.MouseHeld = true;
                    API.WeaponAction.Shoot();
                else
                    ClientData.MouseHeld = false;
                end;
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetShootKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_RELOAD, function(p87, p88, p89) -- Line: 792, Name: handleReload
            -- upvalues: Player (copy), State (copy), Modules (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p87 == Modules.Constants.ACTION_RELOAD and p88 == Enum.UserInputState.Begin then
                API.WeaponAction.Reload();
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetReloadKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_INSPECT, function(p90, p91, p92) -- Line: 800, Name: handleInspect
            -- upvalues: Player (copy), State (copy), Modules (copy), WeaponDataNew (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p90 == Modules.Constants.ACTION_INSPECT and p91 == Enum.UserInputState.Begin then
                local Character2 = Player.Character;

                if Character2 then
                    Character2 = Character2:FindFirstChild("Humanoid");
                end;

                if Character2 then
                    Character2 = Character2.Health > 0;
                end;

                if State.Helpers.IsFirstPersonSpectateCameraActive() or not (Character2 and (WeaponDataNew and WeaponDataNew.CurrentTool)) then
                    return Enum.ContextActionResult.Pass;
                end;

                API.WeaponAction.AimDownSightRelease();
                WeaponDataNew:Inspect();
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds.PC.InspectTool);
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_CROUCH, function(p93, p94, p95) -- Line: 815, Name: handleCrouching
            -- upvalues: Player (copy), State (copy), Modules (copy), API (copy), ClientData (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p93 == Modules.Constants.ACTION_CROUCH and p94 == Enum.UserInputState.Begin then
                if API.Movement.GetMovement() == "Crouching" then
                    API.Movement.SetMovement("Standing", true);
                else
                    ClientData.RunningHold = false;
                    API.Movement.SetMovement("Crouching");
                end;
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetCrouchKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_QUICKKNIFE, function(p96, p97, p98) -- Line: 828, Name: handleQuickKnife
            -- upvalues: Player (copy), State (copy), Modules (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p96 == Modules.Constants.ACTION_QUICKKNIFE and p97 == Enum.UserInputState.Begin then
                API.WeaponAction.QuickKnife();
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetQuickKnifeKeys());
        Services.ContextActionService:BindActionAtPriority(Modules.Constants.ACTION_QUICKTHROW, function(p99, p100, p101) -- Line: 836, Name: handleQuickThrow
            -- upvalues: Player (copy), State (copy), Modules (copy), API (copy)
            local ServerData = Player:FindFirstChild("ServerData");

            if ((not ServerData or ServerData:GetAttribute("Alive") ~= true) and true or State.Helpers.IsFirstPersonSpectateCameraActive() == true) == true then
                return Enum.ContextActionResult.Pass;
            end;

            if p99 == Modules.Constants.ACTION_QUICKTHROW then
                if p100 == Enum.UserInputState.Begin then
                    API.WeaponAction.StartQuickThrowHold();
                elseif p100 == Enum.UserInputState.End or p100 == Enum.UserInputState.Cancel then
                    API.WeaponAction.ReleaseQuickThrowHold(true);
                end;
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Modules.Constants.ACTION_PRIORITY, Keybinds:GetQuickThrowKeys());

        return {
            CanShowMobileControlsMenu = CanShowMobileControlsMenu,
            UpdateClawMode = UpdateClawMode,

            RefreshMobileControlsPosition = function() -- Line: 285, Name: RefreshMobileControlsPosition
                -- upvalues: Modules (copy), ClientData (copy), GetMobileJoystickObjects (copy)
                Modules.Components.Menu.RefreshMobileControlsMenu(ClientData.MobileControlsMenu);
                local _, v102, v103 = GetMobileJoystickObjects();

                if v102 and v103 then
                    v102.Visible = false;
                    v103.Position = UDim2.fromScale(0.5, 0.5);
                end;
            end,

            AdditionalMobileThumbstickFunction = function() -- Line: 408, Name: AdditionalMobileThumbstickFunction
                -- upvalues: Player (copy), ClientData (copy), Services (copy), GetTouchMovementControls (copy), ResetMobileJoystick (copy), WeaponDataNew (copy), GetMobileJoystickObjects (copy), Camera (copy), Humanoid (copy), API (copy)
                if Player:GetAttribute("OnMobile") ~= true or (ClientData.MobileControlsMenu == nil or ClientData.MobileControlsMenu.Visible ~= true) then
                    if Services.UserInputService.TouchEnabled == true then
                        local v104 = GetTouchMovementControls();

                        if v104 and ClientData.TouchMovementControlsDisabled == true then
                            v104:Enable();
                            ClientData.TouchMovementControlsDisabled = false;
                        end;
                    end;

                    if ClientData.JoystickTouch ~= nil then
                        ResetMobileJoystick();
                    end;

                    return;
                end;

                if Services.UserInputService.TouchEnabled == true then
                    local v105 = GetTouchMovementControls();

                    if v105 and ClientData.TouchMovementControlsDisabled ~= true then
                        v105:Disable();
                        ClientData.TouchMovementControlsDisabled = true;
                    end;
                end;

                if ClientData.JoystickTouch == nil or (ClientData.JoystickTouchPosition == nil or ClientData.JoystickBaseCenter == nil) then
                    if ClientData.JoystickSprint == true then
                        ClientData.JoystickSprint = false;
                        ClientData.RunningHold = false;
                    end;

                    return;
                end;

                local CurrentTool = WeaponDataNew.CurrentTool;

                if not CurrentTool then
                    ClientData.JoystickSprint = false;
                    ClientData.RunningHold = false;

                    return;
                end;

                local v106, v107, v108 = GetMobileJoystickObjects();

                if not (v106 and (v107 and v108)) then
                    return;
                end;

                local AbsolutePosition = v106.AbsolutePosition;
                local v109 = Vector2.new(ClientData.JoystickTouchPosition.X - AbsolutePosition.X, ClientData.JoystickTouchPosition.Y - AbsolutePosition.Y) - ClientData.JoystickBaseCenter;
                local JoystickBaseRadius = ClientData.JoystickBaseRadius;

                if not JoystickBaseRadius then
                    local v110 = math.min(v107.AbsoluteSize.X, v107.AbsoluteSize.Y) * 0.5;
                    JoystickBaseRadius = math.max(1, v110);
                end;

                local v111 = JoystickBaseRadius - math.min(v108.AbsoluteSize.X, v108.AbsoluteSize.Y) * 0.5;
                local v112 = math.max(v111, 0);
                local v113;

                if v112 > 0 and v112 < v109.Magnitude then
                    v113 = v109.Unit * v112;
                else
                    v113 = v109;
                end;

                local v114 = Vector2.new(v107.AbsoluteSize.X * 0.5, v107.AbsoluteSize.Y * 0.5);
                v108.Position = UDim2.fromOffset(v114.X + v113.X, v114.Y + v113.Y);

                if v112 > 0 then
                    ClientData.MobileMovementVector = v113 / v112;
                else
                    ClientData.MobileMovementVector = Vector2.zero;
                end;

                local v115 = ClientData.MobileMovementVector or Vector2.zero;
                local v116 = Camera.CFrame.LookVector * Vector3.new(1, 0, 1);
                local v117 = Camera.CFrame.RightVector * Vector3.new(1, 0, 1);

                if v116.Magnitude > 0 then
                    v116 = v116.Unit;
                end;

                if v117.Magnitude > 0 then
                    v117 = v117.Unit;
                end;

                local v118 = v117 * v115.X + v116 * -v115.Y;

                if v118.Magnitude > 1 then
                    v118 = v118.Unit;
                end;

                Humanoid:Move(v118, false);
                local v119 = API.Movement.GetMovement();
                local v120;

                if v109.Magnitude > JoystickBaseRadius * 1.05 and (v115.Magnitude > 0 and (v119 ~= "Crouching" and (v119 ~= "Proning" and (CurrentTool.Aiming ~= true and CurrentTool.Reloading ~= true)))) then
                    v120 = ClientData.MouseHeld ~= true;
                else
                    v120 = false;
                end;

                ClientData.JoystickSprint = v120;
                ClientData.RunningHold = v120;
            end,

            ResetMobileJoystick = ResetMobileJoystick
        };
    end
};