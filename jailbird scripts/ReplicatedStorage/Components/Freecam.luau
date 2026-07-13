
local v1 = {};
local abs = math.abs;
local clamp = math.clamp;
local exp = math.exp;
local rad = math.rad;
local sign = math.sign;
local sqrt = math.sqrt;
local tan = math.tan;
local ContextActionService = game:GetService("ContextActionService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");

if not Players.LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait();
    local _ = Players.LocalPlayer;
end;

local CurrentCamera = Workspace.CurrentCamera;
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 26
    -- upvalues: Workspace (copy), CurrentCamera (ref)
    local CurrentCamera2 = Workspace.CurrentCamera;

    if CurrentCamera2 then
        CurrentCamera = CurrentCamera2;
    end;
end);
local _ = Enum.ContextActionPriority.Low.Value;
local Value = Enum.ContextActionPriority.High.Value;
local _ = { Enum.KeyCode.LeftShift, Enum.KeyCode.P };
local u2 = Vector2.new(0.75, 1) * 8;
local u3 = {};
u3.__index = u3;

function u3.new(p4, p5) -- Line: 50
    -- upvalues: u3 (copy)
    local v6 = setmetatable({}, u3);
    v6.f = p4;
    v6.p = p5;
    v6.v = p5 * 0;

    return v6;
end;

function u3.Update(p7, p8, p9) -- Line: 58
    -- upvalues: exp (copy)
    local v10 = p7.f * 2 * 3.141592653589793;
    local v = p7.v;
    local v11 = p9 - p7.p;
    local v12 = exp(-v10 * p8);
    local v13 = p9 + (v * p8 - v11 * (v10 * p8 + 1)) * v12;
    p7.p = v13;
    p7.v = (v10 * p8 * (v11 * v10 - v) + v) * v12;

    return v13;
end;

function u3.Reset(p14, p15) -- Line: 75
    p14.p = p15;
    p14.v = p15 * 0;
end;

local u16 = Vector3.new();
local u17 = Vector2.new();
local u18 = 0;
local u19 = false;
local u20 = u3.new(10, (Vector3.new()));
local u21 = u3.new(10, Vector2.new());
local u22 = u3.new(10, 0);
local u23 = {};

local function fCurve(p24) -- Line: 95
    -- upvalues: exp (copy)
    return (exp(2 * p24) - 1) / 6.38905609893065;
end;

local function fDeadzone(p25) -- Line: 99
    -- upvalues: exp (copy)
    return (exp(2 * ((p25 - 0.15) / 0.85)) - 1) / 6.38905609893065;
end;

local function thumbstickCurve(p26) -- Line: 103
    -- upvalues: sign (copy), abs (copy), exp (copy), clamp (copy)
    return sign(p26) * clamp((exp(2 * ((abs(p26) - 0.15) / 0.85)) - 1) / 6.38905609893065, 0, 1);
end;

local u27 = {
    ButtonX = 0,
    ButtonY = 0,
    DPadDown = 0,
    DPadUp = 0,
    ButtonL2 = 0,
    ButtonR2 = 0,
    Thumbstick1 = Vector2.new(),
    Thumbstick2 = Vector2.new()
};
local u28 = {
    W = 0,
    A = 0,
    S = 0,
    D = 0,
    E = 0,
    Q = 0,
    U = 0,
    H = 0,
    J = 0,
    K = 0,
    I = 0,
    Y = 0,
    Up = 0,
    Down = 0,
    LeftShift = 0,
    RightShift = 0
};
local u29 = {
    MouseWheel = 0,
    Delta = Vector2.new()
};
local u30 = Vector2.new(1, 1) * 0.04908738521234052;
local u31 = Vector2.new(1, 1) * 0.39269908169872414;
local u32 = 1;

function u23.Vel(p33) -- Line: 154
    -- upvalues: u32 (ref), u28 (copy), clamp (copy), thumbstickCurve (ref), u27 (copy), UserInputService (copy)
    u32 = clamp(u32 + p33 * (u28.Up - u28.Down) * 0.75, 0.01, 4);
    local v34 = thumbstickCurve(u27.Thumbstick1.X);
    local v35 = thumbstickCurve(u27.ButtonR2) - thumbstickCurve(u27.ButtonL2);
    local v36 = Vector3.new(v34, v35, thumbstickCurve(-u27.Thumbstick1.Y)) * Vector3.new(1, 1, 1);
    local v37 = Vector3.new(u28.D - u28.A + u28.K - u28.H, u28.E - u28.Q + u28.I - u28.Y, u28.S - u28.W + u28.J - u28.U) * Vector3.new(1, 1, 1);
    local v38 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift);

    return (v36 + v37) * (u32 * (v38 and 0.25 or 1));
end;

function u23.Pan(p39) -- Line: 174
    -- upvalues: thumbstickCurve (ref), u27 (copy), u31 (copy), u29 (copy), u30 (copy)
    local v40 = Vector2.new(thumbstickCurve(u27.Thumbstick2.Y), thumbstickCurve(-u27.Thumbstick2.X)) * u31;
    local v41 = u29.Delta * u30;
    u29.Delta = Vector2.new();

    return v40 + v41;
end;

function u23.Fov(p42) -- Line: 184
    -- upvalues: u27 (copy), u29 (copy)
    local v43 = (u27.ButtonX - u27.ButtonY) * 0.25;
    local v44 = u29.MouseWheel * 1;
    u29.MouseWheel = 0;

    return v43 + v44;
end;

local function Keypress(p45, p46, p47) -- Line: 192
    -- upvalues: u28 (copy)
    u28[p47.KeyCode.Name] = p46 == Enum.UserInputState.Begin and 1 or 0;

    return Enum.ContextActionResult.Sink;
end;

local function GpButton(p48, p49, p50) -- Line: 197
    -- upvalues: u27 (copy)
    u27[p50.KeyCode.Name] = p49 == Enum.UserInputState.Begin and 1 or 0;

    return Enum.ContextActionResult.Sink;
end;

local function MousePan(p51, p52, p53) -- Line: 202
    -- upvalues: u29 (copy)
    local Delta = p53.Delta;
    u29.Delta = Vector2.new(-Delta.y, -Delta.x);

    return Enum.ContextActionResult.Sink;
end;

local function Thumb(p54, p55, p56) -- Line: 208
    -- upvalues: u27 (copy)
    u27[p56.KeyCode.Name] = p56.Position;

    return Enum.ContextActionResult.Sink;
end;

local function Trigger(p57, p58, p59) -- Line: 213
    -- upvalues: u27 (copy)
    u27[p59.KeyCode.Name] = p59.Position.z;

    return Enum.ContextActionResult.Sink;
end;

local function MouseWheel(p60, p61, p62) -- Line: 218
    -- upvalues: u29 (copy)
    u29[p62.UserInputType.Name] = -p62.Position.z;

    return Enum.ContextActionResult.Sink;
end;

local function Zero(p63) -- Line: 223
    for i, v in pairs(p63) do
        p63[i] = v * 0;
    end;
end;

function u23.StartCapture() -- Line: 229
    -- upvalues: ContextActionService (copy), Keypress (copy), Value (copy), MousePan (copy), MouseWheel (copy), GpButton (copy), Trigger (copy), Thumb (copy)
    ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, Value, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y, Enum.KeyCode.Up, Enum.KeyCode.Down);
    ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, Value, Enum.UserInputType.MouseMovement);
    ContextActionService:BindActionAtPriority("FreecamMouseWheel", MouseWheel, false, Value, Enum.UserInputType.MouseWheel);
    ContextActionService:BindActionAtPriority("FreecamGamepadButton", GpButton, false, Value, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY);
    ContextActionService:BindActionAtPriority("FreecamGamepadTrigger", Trigger, false, Value, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2);
    ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb, false, Value, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2);
end;

function u23.StopCapture() -- Line: 246
    -- upvalues: u32 (ref), u27 (copy), u28 (copy), u29 (copy), ContextActionService (copy)
    u32 = 1;
    local v64 = u27;

    for i, v in pairs(v64) do
        v64[i] = v * 0;
    end;

    local v65 = u28;

    for i, v in pairs(v65) do
        v65[i] = v * 0;
    end;

    local v66 = u29;

    for i, v in pairs(v66) do
        v66[i] = v * 0;
    end;

    ContextActionService:UnbindAction("FreecamKeyboard");
    ContextActionService:UnbindAction("FreecamMousePan");
    ContextActionService:UnbindAction("FreecamMouseWheel");
    ContextActionService:UnbindAction("FreecamGamepadButton");
    ContextActionService:UnbindAction("FreecamGamepadTrigger");
    ContextActionService:UnbindAction("FreecamGamepadThumbstick");
end;

local function GetFocusDistance(p67) -- Line: 261
    -- upvalues: CurrentCamera (ref), u18 (ref), tan (copy), Workspace (copy)
    local ViewportSize = CurrentCamera.ViewportSize;
    local v68 = tan(u18 / 2) * 2;
    local v69 = ViewportSize.x / ViewportSize.y * v68;
    local rightVector = p67.rightVector;
    local upVector = p67.upVector;
    local lookVector = p67.lookVector;
    local v70 = Vector3.new();
    local v71 = 512;

    for i = 0, 1, 0.5 do
        for i2 = 0, 1, 0.5 do
            local v72 = rightVector * ((i - 0.5) * v69) - upVector * ((i2 - 0.5) * v68) + lookVector;
            local v73 = p67.p + v72 * 0.1;
            local _, v74 = Workspace:FindPartOnRay(Ray.new(v73, v72.unit * v71));
            local magnitude = (v74 - v73).magnitude;

            if magnitude < v71 then
                v70 = v72.unit;
                v71 = magnitude;
            end;
        end;
    end;

    return lookVector:Dot(v70) * v71;
end;

local function StepFreecam(p75) -- Line: 291
    -- upvalues: u20 (copy), u23 (copy), u21 (copy), u22 (copy), u18 (ref), rad (copy), tan (copy), sqrt (copy), clamp (copy), u17 (ref), u2 (copy), u16 (ref), CurrentCamera (ref), GetFocusDistance (copy)
    local v76 = u20:Update(p75, u23.Vel(p75));
    local v77 = u21:Update(p75, u23.Pan(p75));
    local v78 = u22:Update(p75, u23.Fov(p75));
    local v79 = sqrt(0.7002075382097097 / tan((rad(u18 / 2))));
    u18 = clamp(u18 + v78 * 300 * (p75 / v79), 1, 120);
    u17 = u17 + v77 * u2 * (p75 / v79);
    u17 = Vector2.new(clamp(u17.x, -1.5707963267948966, 1.5707963267948966), u17.y % 6.283185307179586);
    local v80 = CFrame.new(u16) * CFrame.fromOrientation(u17.x, u17.y, 0) * CFrame.new(v76 * Vector3.new(64, 64, 64) * p75);
    u16 = v80.p;
    CurrentCamera.CFrame = v80;
    CurrentCamera.Focus = v80 * CFrame.new(0, 0, -GetFocusDistance(v80));
    CurrentCamera.FieldOfView = u18;
end;

local u81 = {};
local u82 = nil;
local u83 = nil;
local u84 = nil;
local u85 = nil;
local u86 = nil;
local u87 = nil;
local u88 = {};
local u89 = false;
local u90 = {
    Backpack = true,
    Chat = true,
    Health = true,
    PlayerList = true
};
local u91 = {
    BadgesNotificationsActive = true,
    PointsNotificationsActive = true
};

function u81.Push() -- Line: 330
    -- upvalues: u89 (ref), u87 (ref), CurrentCamera (ref), u84 (ref), u86 (ref), u85 (ref), u83 (ref), UserInputService (copy), u82 (ref)
    if u89 == true then
        return;
    end;

    u89 = true;
    u87 = CurrentCamera.FieldOfView;
    CurrentCamera.FieldOfView = 70;
    u84 = CurrentCamera.CameraType;
    CurrentCamera.CameraType = Enum.CameraType.Custom;
    u86 = CurrentCamera.CFrame;
    u85 = CurrentCamera.Focus;
    u83 = UserInputService.MouseIconEnabled;
    UserInputService.MouseIconEnabled = true;
    u82 = UserInputService.MouseBehavior;
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
end;

function u81.Pop() -- Line: 371
    -- upvalues: u89 (ref), u90 (copy), StarterGui (copy), u91 (copy), u88 (copy), CurrentCamera (ref), u87 (ref), u84 (ref), u86 (ref), u85 (ref), UserInputService (copy), u83 (ref), u82 (ref)
    if u89 ~= true then
        return;
    end;

    u89 = false;

    for i, v in pairs(u90) do
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[i], v);
    end;

    for i, v in pairs(u91) do
        StarterGui:SetCore(i, v);
    end;

    for _, v in pairs(u88) do
        if v.Parent then
            v.Enabled = true;
        end;
    end;

    CurrentCamera.FieldOfView = u87;
    u87 = nil;
    CurrentCamera.CameraType = u84;
    u84 = nil;
    CurrentCamera.CFrame = u86;
    u86 = nil;
    CurrentCamera.Focus = u85;
    u85 = nil;
    UserInputService.MouseIconEnabled = u83;
    u83 = nil;
    UserInputService.MouseBehavior = u82;
    u82 = nil;
end;

local function StartFreecam() -- Line: 408
    -- upvalues: u19 (ref), CurrentCamera (ref), u17 (ref), u16 (ref), u18 (ref), u20 (copy), u21 (copy), u22 (copy), u81 (copy), RunService (copy), StepFreecam (copy), u23 (copy)
    if u19 == true then
        return;
    end;

    u19 = true;
    local CFrame2 = CurrentCamera.CFrame;
    u17 = Vector2.new(CFrame2:toEulerAnglesYXZ());
    u16 = CFrame2.p;
    u18 = CurrentCamera.FieldOfView;
    u20:Reset((Vector3.new()));
    u21:Reset(Vector2.new());
    u22:Reset(0);
    u81.Push();
    RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam);
    u23.StartCapture();
end;

local function StopFreecam() -- Line: 428
    -- upvalues: u19 (ref), u23 (copy), RunService (copy), u81 (copy)
    if u19 ~= true then
        return;
    end;

    u19 = false;
    u23.StopCapture();
    RunService:UnbindFromRenderStep("Freecam");
    u81.Pop();
end;

function v1.EnableFreecam(p92) -- Line: 439
    -- upvalues: StartFreecam (copy)
    StartFreecam();
end;

function v1.StopFreecam(p93) -- Line: 443
    -- upvalues: u19 (ref), u23 (copy), RunService (copy), u81 (copy)
    if u19 ~= true then
        return;
    end;

    u19 = false;
    u23.StopCapture();
    RunService:UnbindFromRenderStep("Freecam");
    u81.Pop();
end;

function v1.IsActive(p94) -- Line: 447
    -- upvalues: u19 (ref)
    return u19 == true;
end;

return v1;