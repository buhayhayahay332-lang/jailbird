
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Keybinds = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Keybinds");
local GetKeybinds = Keybinds:WaitForChild("GetKeybinds");
local SaveKeybinds = Keybinds:WaitForChild("SaveKeybinds");
local DefaultKeybinds = require(Modules:WaitForChild("DefaultKeybinds"));
local Utility = require(Modules:WaitForChild("Utility"));
local Config = require(ReplicatedStorage.Config);
local Hover_General = SoundService:WaitForChild("UI"):WaitForChild("Hover_General");
local Click_2 = SoundService:WaitForChild("UI"):WaitForChild("Click_2");
local v1 = {};
local u2 = false;
local u3 = {};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.MouseButton2] = true
};
local u14 = {
    Primary = "SwapTool1",
    Secondary = "SwapTool2",
    Knife = "SwapTool3",
    Throwable = "SwapTool4",
    QuickThrow = "QuickThrow",
    QuickKnife = "QuickKnife",
    Crouch = "Crouch",
    Prone = "Prone",
    Shoot = "Shoot",
    ADS = "Aim",
    Ping = "Ping",
    WepInspect = "InspectTool",
    Jump = "Jump",
    Reload = "Reload",
    LeanLeft = "LeanLeft",
    LeanRight = "LeanRight",
    Sprint = "Run"
};
local u15 = {
    ControllerAim = "Aim",
    ControllerCrouch = "Crouch",
    ControllerJump = "Jump",
    ControllerShoot = "Shoot",
    ControllerLeanLeft = "LeanLeft",
    ControllerLeanRight = "LeanRight",
    ControllerSprint = "Run",
    ControllerSwapGun = "SwapTool",
    ControllerProne = "Prone",
    ControllerQuickKnife = "QuickKnife",
    ControllerQuickThrow = "QuickThrow",
    ControllerReload = "Reload",
    ControllerPing = "Ping"
};
local u16 = {
    [Enum.UserInputType.MouseButton1.Name] = "LMB",
    [Enum.UserInputType.MouseButton2.Name] = "RMB",
    [Enum.UserInputType.MouseButton3.Name] = "MMB",
    [Enum.KeyCode.LeftShift.Name] = "SHIFT",
    [Enum.KeyCode.RightShift.Name] = "SHIFT",
    [Enum.KeyCode.Space.Name] = "SPACE"
};

local function deepCopy(p17) -- Line: 85
    -- upvalues: deepCopy (copy)
    local v18 = {};

    for i, v in p17 do
        if type(v) == "table" then
            local v = deepCopy(v) or v;
        end;

        v18[i] = v;
    end;

    return v18;
end;

local function playHoverSFX(p19) -- Line: 93
    -- upvalues: Hover_General (copy)
    p19.MouseEnter:Connect(function() -- Line: 94
        -- upvalues: Hover_General (ref)
        Hover_General:Play();
    end);
end;

local function getDisplayName(p20) -- Line: 99
    -- upvalues: u16 (copy)
    return u16[p20] or p20;
end;

local function getBindableInputData(p21) -- Line: 103
    -- upvalues: u13 (copy)
    local KeyCode = p21.KeyCode;
    local UserInputType = p21.UserInputType;

    if u13[UserInputType] then
        return UserInputType.Name, "UserInputType";
    end;

    if KeyCode == Enum.KeyCode.Unknown then
        return nil, nil;
    end;

    return KeyCode.Name, "KeyCode";
end;

local function updatePromptVisible(p22) -- Line: 118
    -- upvalues: u6 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref)
    u6.Visible = p22;

    if not p22 and u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    if not p22 then
        u10 = nil;
        u11 = nil;
        u12 = nil;
    end;
end;

local function getKeybindsFromServer() -- Line: 131
    -- upvalues: GetKeybinds (copy), u3 (ref), Utility (copy)
    local v23, v24 = GetKeybinds:InvokeServer();

    if v23 then
        u3 = v24;

        return v23;
    end;

    warn(Utility.warnCustom("Failed to load keybinds: " .. tostring(v24)));

    return v23;
end;

local function saveKeybindsToServer() -- Line: 141
    -- upvalues: SaveKeybinds (copy), u3 (ref), Utility (copy)
    local v25, v26 = SaveKeybinds:InvokeServer(u3);

    if not v25 then
        warn(Utility.warnCustom("Failed to save keybinds: " .. tostring(v26)));
    end;

    return v25;
end;

local function updateButtonRow(p27, p28, p29) -- Line: 149
    -- upvalues: u5 (ref), u3 (ref), u16 (copy)
    local v30 = u5:FindFirstChild(p27);

    if not (v30 and v30:IsA("Frame")) then
        return;
    end;

    local KeybindButton = v30:FindFirstChild("KeybindButton");

    if not (KeybindButton and KeybindButton:IsA("TextButton")) then
        return;
    end;

    local v31 = u3[p28][p29][1];
    KeybindButton.Text = u16[v31] or v31;
end;

local function setToggleRow(p32, p33) -- Line: 163
    -- upvalues: u5 (ref)
    local v34 = u5:FindFirstChild(p32);

    if not (v34 and v34:IsA("Frame")) then
        return;
    end;

    local Value = v34:FindFirstChild("Value");

    if Value and Value:IsA("TextBox") then
        Value.Text = p33 and "ON" or "OFF";
    end;
end;

local function setSliderRow(p35, p36) -- Line: 175
    -- upvalues: u5 (ref)
    local v37 = u5:FindFirstChild(p35);

    if not (v37 and v37:IsA("Frame")) then
        return;
    end;

    local Number = v37:FindFirstChild("Number");

    if Number and Number:IsA("TextLabel") then
        Number.Text = string.format("%.2f", p36);
    end;

    local BackgroundBar = v37:FindFirstChild("BackgroundBar");

    if BackgroundBar then
        BackgroundBar = BackgroundBar:FindFirstChild("DragBar");
    end;

    if BackgroundBar and BackgroundBar:IsA("Frame") then
        BackgroundBar.Size = UDim2.fromScale(math.clamp(p36, 0, 1), 1);
    end;
end;

local function refreshAllRows() -- Line: 193
    -- upvalues: u14 (copy), updateButtonRow (copy), u15 (copy), setToggleRow (copy), u3 (ref), setSliderRow (copy)
    for i, v in pairs(u14) do
        updateButtonRow(i, "PC", v);
    end;

    for i, v in pairs(u15) do
        updateButtonRow(i, "Controller", v);
    end;

    setToggleRow("ADSToggle", u3.ADSToggle == true);
    setToggleRow("LeanToggle", u3.LeanToggle == true);
    setSliderRow("Sensitivity", u3.ADSSensitivity or 1);
    setSliderRow("HipfireSens", u3.CameraSensitivity or 1);
end;

local function beginBinding(p38, p39, p40) -- Line: 208
    -- upvalues: u6 (ref), u10 (ref), u11 (ref), u12 (ref), Click_2 (copy), u9 (ref), UserInputService (copy), u13 (copy), u3 (ref), u16 (copy)
    if u6.Visible then
        return;
    end;

    u10 = p38;
    u11 = p40;
    u12 = p39;
    u6.Visible = true;
    Click_2:Play();
    u9 = UserInputService.InputBegan:Connect(function(p41, p42) -- Line: 219
        -- upvalues: u13 (ref), u10 (ref), u11 (ref), u12 (ref), u3 (ref), u16 (ref), u6 (ref), u9 (ref)
        if p42 then
            return;
        end;

        local KeyCode = p41.KeyCode;
        local UserInputType = p41.UserInputType;
        local v43, v44;

        if u13[UserInputType] then
            v43 = UserInputType.Name;
            v44 = "UserInputType";
        elseif KeyCode == Enum.KeyCode.Unknown then
            v43 = nil;
            v44 = nil;
        else
            v43 = KeyCode.Name;
            v44 = "KeyCode";
        end;

        if not (v43 and (v44 and (u10 and (u11 and u12)))) then
            return;
        end;

        u3[u11][u12][1] = v43;
        u3[u11][u12][2] = v44;
        u10.Text = u16[v43] or v43;
        u6.Visible = false;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        u10 = nil;
        u11 = nil;
        u12 = nil;
    end);
end;

local function connectButtonRow(p45, u46, u47) -- Line: 236
    -- upvalues: u5 (ref), Hover_General (copy), beginBinding (copy)
    local v48 = u5:FindFirstChild(p45);

    if not (v48 and v48:IsA("Frame")) then
        return;
    end;

    local KeybindButton = v48:FindFirstChild("KeybindButton");

    if not (KeybindButton and KeybindButton:IsA("TextButton")) then
        return;
    end;

    KeybindButton.MouseEnter:Connect(function() -- Line: 94
        -- upvalues: Hover_General (ref)
        Hover_General:Play();
    end);
    KeybindButton.MouseButton1Up:Connect(function() -- Line: 248
        -- upvalues: beginBinding (ref), KeybindButton (copy), u47 (copy), u46 (copy)
        beginBinding(KeybindButton, u47, u46);
    end);
end;

local function connectToggleRow(p49, u50) -- Line: 253
    -- upvalues: u5 (ref), Hover_General (copy), u3 (ref), Click_2 (copy)
    local v51 = u5:FindFirstChild(p49);

    if not (v51 and v51:IsA("Frame")) then
        return;
    end;

    local Toggle = v51:FindFirstChild("Toggle");
    local Value = v51:FindFirstChild("Value");

    if not (Toggle and (Toggle:IsA("ImageButton") and (Value and Value:IsA("TextBox")))) then
        return;
    end;

    Toggle.MouseEnter:Connect(function() -- Line: 94
        -- upvalues: Hover_General (ref)
        Hover_General:Play();
    end);
    Toggle.MouseButton1Down:Connect(function() -- Line: 266
        -- upvalues: u3 (ref), u50 (copy), Value (copy), Click_2 (ref)
        u3[u50] = not u3[u50];
        Value.Text = u3[u50] and "ON" or "OFF";
        Click_2:Play();
    end);
end;

local function connectSliderRow(u52, u53) -- Line: 273
    -- upvalues: u5 (ref), u3 (ref), setSliderRow (copy), Click_2 (copy), UserInputService (copy)
    local v54 = u5:FindFirstChild(u52);

    if not (v54 and v54:IsA("Frame")) then
        return;
    end;

    local BackgroundBar = v54:FindFirstChild("BackgroundBar");
    local v55;

    if BackgroundBar then
        v55 = BackgroundBar:FindFirstChild("DragBar");
    else
        v55 = BackgroundBar;
    end;

    if not (BackgroundBar and (BackgroundBar:IsA("Frame") and (v55 and v55:IsA("Frame")))) then
        return;
    end;

    BackgroundBar.Active = true;
    v55.Active = true;
    local u56 = false;

    local function updateFromPosition(p57) -- Line: 290
        -- upvalues: BackgroundBar (copy), u3 (ref), u53 (copy), setSliderRow (ref), u52 (copy)
        local X = BackgroundBar.AbsoluteSize.X;

        if X <= 0 then
            return;
        end;

        local v58 = math.clamp((p57 - BackgroundBar.AbsolutePosition.X) / X, 0, 1);
        u3[u53] = v58;
        setSliderRow(u52, v58);
    end;

    local function beginDrag(p59) -- Line: 302
        -- upvalues: u56 (ref), BackgroundBar (copy), u3 (ref), u53 (copy), setSliderRow (ref), u52 (copy), Click_2 (ref)
        if p59.UserInputType == Enum.UserInputType.MouseButton1 or p59.UserInputType == Enum.UserInputType.Touch then
            u56 = true;
            local X = p59.Position.X;
            local X2 = BackgroundBar.AbsolutePosition.X;
            local X3 = BackgroundBar.AbsoluteSize.X;

            if X3 > 0 then
                local v60 = math.clamp((X - X2) / X3, 0, 1);
                u3[u53] = v60;
                setSliderRow(u52, v60);
            end;

            Click_2:Play();
        end;
    end;

    local function endDrag(p61) -- Line: 310
        -- upvalues: u56 (ref)
        if p61.UserInputType == Enum.UserInputType.MouseButton1 or p61.UserInputType == Enum.UserInputType.Touch then
            u56 = false;
        end;
    end;

    BackgroundBar.InputBegan:Connect(beginDrag);
    BackgroundBar.InputEnded:Connect(endDrag);
    v55.InputBegan:Connect(beginDrag);
    v55.InputEnded:Connect(endDrag);
    UserInputService.InputChanged:Connect(function(p62) -- Line: 321
        -- upvalues: u56 (ref), BackgroundBar (copy), u3 (ref), u53 (copy), setSliderRow (ref), u52 (copy)
        if not u56 then
            return;
        end;

        if p62.UserInputType == Enum.UserInputType.MouseMovement or p62.UserInputType == Enum.UserInputType.Touch then
            local X = BackgroundBar.AbsoluteSize.X;

            if X <= 0 then
                return;
            end;

            local v63 = math.clamp((p62.Position.X - BackgroundBar.AbsolutePosition.X) / X, 0, 1);
            u3[u53] = v63;
            setSliderRow(u52, v63);
        end;
    end);
end;

local function setupInputDisplay() -- Line: 331
    -- upvalues: u7 (ref), UserInputService (copy)
    local KeyPressedDisplay = u7:WaitForChild("KeyPressedDisplay");
    local u64 = Color3.fromRGB(60, 95, 60);

    local function highlightLabel(p65, p66) -- Line: 335
        -- upvalues: KeyPressedDisplay (copy), u64 (copy)
        KeyPressedDisplay.Text = p65;
        KeyPressedDisplay.TextColor3 = p66 and u64 or Color3.new(0.5, 0.5, 0.5);
        KeyPressedDisplay.BackgroundColor3 = p66 and Color3.fromRGB(84, 84, 84) or Color3.fromRGB(44, 44, 44);
    end;

    UserInputService.InputBegan:Connect(function(p67) -- Line: 341
        -- upvalues: highlightLabel (copy)
        local Name = p67.KeyCode.Name;

        if Name == "Unknown" then
            Name = p67.UserInputType.Name;
        end;

        highlightLabel(Name, true);
    end);
    UserInputService.InputEnded:Connect(function(p68) -- Line: 349
        -- upvalues: KeyPressedDisplay (copy)
        local Name = p68.KeyCode.Name;

        if Name == "Unknown" then
            Name = p68.UserInputType.Name;
        end;

        if Name == KeyPressedDisplay.Text then
            KeyPressedDisplay.Text = Name;
            KeyPressedDisplay.TextColor3 = Color3.new(0.5, 0.5, 0.5);
            KeyPressedDisplay.BackgroundColor3 = Color3.fromRGB(44, 44, 44);
        end;
    end);
end;

local function setupControllerViewport() -- Line: 360
    -- upvalues: u8 (ref), UserInputService (copy), RunService (copy)
    local ViewportFrameController = u8:WaitForChild("ViewportFrameController");
    local ViewportFrameButtons = u8:WaitForChild("ViewportFrameButtons");
    local Controller = ViewportFrameController:WaitForChild("WorldModel"):WaitForChild("Controller");
    local Controller2 = ViewportFrameButtons:WaitForChild("WorldModel"):WaitForChild("Controller");
    local Buttons = Controller2:WaitForChild("Buttons");
    local u69 = ViewportFrameController:FindFirstChildOfClass("Camera");

    if not u69 then
        u69 = Instance.new("Camera");
        u69.Parent = ViewportFrameController;
    end;

    u69.FieldOfView = 0;
    u69.CFrame = CFrame.new();
    ViewportFrameController.CurrentCamera = u69;
    local u70 = CFrame.fromOrientation(-1.5707963267948966, 0, 0);
    local u71 = CFrame.new();

    local function toggleButtonHighlight(p72, p73) -- Line: 382
        -- upvalues: Buttons (copy)
        local v74 = Buttons:FindFirstChild(p72);

        if not (v74 and v74:IsA("BasePart")) then
            return;
        end;

        v74.Transparency = p73 and 0 or 1;
    end;

    UserInputService.InputChanged:Connect(function(p75) -- Line: 390
        -- upvalues: u71 (ref)
        if p75.KeyCode == Enum.KeyCode.Thumbstick1 then
            local v76 = math.round(p75.Position.X * 20) / 20;
            local v77 = math.round(p75.Position.Y * 20) / 20;
            local v78 = math.rad(v76 * 90);
            local v79 = math.rad(v77 * 90);
            u71 = CFrame.fromOrientation(v79, -v78, 0);
        end;
    end);
    UserInputService.InputBegan:Connect(function(p80) -- Line: 400
        -- upvalues: Buttons (copy)
        local v81 = Buttons:FindFirstChild(p80.KeyCode.Name);

        if v81 then
            if not v81:IsA("BasePart") then
                return;
            end;

            v81.Transparency = 0;
        end;
    end);
    UserInputService.InputEnded:Connect(function(p82) -- Line: 404
        -- upvalues: Buttons (copy)
        local v83 = Buttons:FindFirstChild(p82.KeyCode.Name);

        if v83 then
            if not v83:IsA("BasePart") then
                return;
            end;

            v83.Transparency = 1;
        end;
    end);
    RunService.RenderStepped:Connect(function(p84) -- Line: 408
        -- upvalues: u69 (ref), Controller (copy), u70 (copy), u71 (ref), Controller2 (copy)
        local Position = u69.CFrame.Position;
        local v85 = Position + u69.CFrame.LookVector * 150;
        local v86 = Controller:GetPivot():Lerp(CFrame.lookAt(v85, Position) * u70 * u71, p84 * 10);
        Controller:PivotTo(v86);
        Controller2:PivotTo(v86);
    end);
end;

function v1.CancelBinding() -- Line: 419
    -- upvalues: u2 (ref), u6 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref)
    if not u2 then
        return;
    end;

    u6.Visible = false;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u10 = nil;
    u11 = nil;
    u12 = nil;
end;

function v1.Configure() -- Line: 426
    -- upvalues: u2 (ref), Config (copy), LocalPlayer (copy), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), GetKeybinds (copy), u3 (ref), Utility (copy), deepCopy (copy), DefaultKeybinds (copy), u14 (copy), connectButtonRow (copy), u15 (copy), connectToggleRow (copy), connectSliderRow (copy), Hover_General (copy), Click_2 (copy), SaveKeybinds (copy), refreshAllRows (copy), u9 (ref), u10 (ref), u11 (ref), u12 (ref), setupInputDisplay (copy), setupControllerViewport (copy)
    if u2 then
        return;
    end;

    u2 = true;
    local v87;

    if game.PlaceId == Config.LobbyID then
        v87 = LocalPlayer.PlayerGui:WaitForChild("Main");
    else
        v87 = LocalPlayer.PlayerGui:WaitForChild("Menu");
    end;

    u4 = v87:WaitForChild("Pages"):WaitForChild("Keybinds");
    u5 = u4:WaitForChild("Keybinds");
    u6 = u4:WaitForChild("BindPrompt");
    u7 = u4:WaitForChild("KeyVisualizer");
    u8 = u4:WaitForChild("ControllerViewport");
    local v88, v89 = GetKeybinds:InvokeServer();

    if v88 then
        u3 = v89;
    else
        warn(Utility.warnCustom("Failed to load keybinds: " .. tostring(v89)));
    end;

    if not v88 then
        u3 = deepCopy(DefaultKeybinds);
    end;

    for i, v in pairs(u14) do
        connectButtonRow(i, "PC", v);
    end;

    for i, v in pairs(u15) do
        connectButtonRow(i, "Controller", v);
    end;

    connectToggleRow("ADSToggle", "ADSToggle");
    connectToggleRow("LeanToggle", "LeanToggle");
    connectSliderRow("Sensitivity", "ADSSensitivity");
    connectSliderRow("HipfireSens", "CameraSensitivity");
    local Save = u4:WaitForChild("Save");
    local Reset = u4:WaitForChild("Reset");
    Save.MouseEnter:Connect(function() -- Line: 94
        -- upvalues: Hover_General (ref)
        Hover_General:Play();
    end);
    Reset.MouseEnter:Connect(function() -- Line: 94
        -- upvalues: Hover_General (ref)
        Hover_General:Play();
    end);
    Save.MouseButton1Down:Connect(function() -- Line: 469
        -- upvalues: Click_2 (ref), SaveKeybinds (ref), u3 (ref), Utility (ref)
        Click_2:Play();
        local v90, v91 = SaveKeybinds:InvokeServer(u3);

        if not v90 then
            warn(Utility.warnCustom("Failed to save keybinds: " .. tostring(v91)));
        end;
    end);
    Reset.MouseButton1Down:Connect(function() -- Line: 474
        -- upvalues: Click_2 (ref), u3 (ref), deepCopy (ref), DefaultKeybinds (ref), refreshAllRows (ref), u6 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref)
        Click_2:Play();
        u3 = deepCopy(DefaultKeybinds);
        refreshAllRows();
        u6.Visible = false;

        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        u10 = nil;
        u11 = nil;
        u12 = nil;
    end);
    local TextLabel = u6:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = "[Press any key to bind]";
    end;

    setupInputDisplay();
    setupControllerViewport();
    refreshAllRows();
    u6.Visible = false;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u10 = nil;
    u11 = nil;
    u12 = nil;
end;

return v1;