
local success, result = pcall(function() -- Line: 17
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2");
end);
local u1 = success and result;
local VRService = game:GetService("VRService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local ZoomController = require(script.Parent:WaitForChild("ZoomController"));
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
require(CommonUtils:WaitForChild("FlagUtil"));
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u2 = setmetatable({}, BaseCamera);
u2.__index = u2;

function u2.new() -- Line: 40
    -- upvalues: BaseCamera (copy), u2 (copy)
    local v3 = BaseCamera.new();
    local v4 = setmetatable(v3, u2);
    v4.gamepadZoomLevels = { 0, 7 };
    v4.headScale = 1;
    v4:SetCameraToSubjectDistance(7);
    v4.VRFadeResetTimer = 0;
    v4.VREdgeBlurTimer = 0;
    v4.gamepadResetConnection = nil;
    v4.needsReset = true;
    v4.recentered = false;
    v4:Reset();

    return v4;
end;

function u2.Reset(p5) -- Line: 66
    p5.stepRotateTimeout = 0;
end;

function u2.GetModuleName(p6) -- Line: 70
    return "VRBaseCamera";
end;

function u2.GamepadZoomPress(p7) -- Line: 74
    -- upvalues: BaseCamera (copy)
    BaseCamera.GamepadZoomPress(p7);
    p7:GamepadReset();
    p7:ResetZoom();
end;

function u2.GamepadReset(p8) -- Line: 82
    p8.stepRotateTimeout = 0;
    p8.needsReset = true;
end;

function u2.ResetZoom(p9) -- Line: 87
    -- upvalues: ZoomController (copy)
    ZoomController.SetZoomParameters(p9.currentSubjectDistance, 0);
    ZoomController.ReleaseSpring();
end;

function u2.OnEnabledChanged(u10) -- Line: 92
    -- upvalues: BaseCamera (copy), CameraInput (copy), VRService (copy), u1 (ref), LocalPlayer (copy), Lighting (copy)
    BaseCamera.OnEnabledChanged(u10);

    if u10.enabled then
        u10.gamepadResetConnection = CameraInput.gamepadReset:Connect(function() -- Line: 96
            -- upvalues: u10 (copy)
            u10:GamepadReset();
        end);
        u10.thirdPersonOptionChanged = VRService:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled"):Connect(function() -- Line: 101
            -- upvalues: u1 (ref), u10 (copy)
            if u1 then
                u10:Reset();

                return;
            end;

            if not u10:IsInFirstPerson() then
                u10:Reset();
            end;
        end);
        u10.vrRecentered = VRService.UserCFrameChanged:Connect(function(p11, p12) -- Line: 112
            -- upvalues: u10 (copy)
            if p11 == Enum.UserCFrame.Floor then
                u10.recentered = true;
            end;
        end);

        return;
    end;

    if u10.inFirstPerson then
        u10:GamepadZoomPress();
    end;

    if u10.thirdPersonOptionChanged then
        u10.thirdPersonOptionChanged:Disconnect();
        u10.thirdPersonOptionChanged = nil;
    end;

    if u10.vrRecentered then
        u10.vrRecentered:Disconnect();
        u10.vrRecentered = nil;
    end;

    if u10.cameraHeadScaleChangedConn then
        u10.cameraHeadScaleChangedConn:Disconnect();
        u10.cameraHeadScaleChangedConn = nil;
    end;

    if u10.gamepadResetConnection then
        u10.gamepadResetConnection:Disconnect();
        u10.gamepadResetConnection = nil;
    end;

    u10.VREdgeBlurTimer = 0;
    u10:UpdateEdgeBlur(LocalPlayer, 1);
    local VRFade = Lighting:FindFirstChild("VRFade");

    if VRFade then
        VRFade.Brightness = 0;
    end;
end;

function u2.OnCurrentCameraChanged(u13) -- Line: 154
    -- upvalues: BaseCamera (copy)
    BaseCamera.OnCurrentCameraChanged(u13);

    if u13.cameraHeadScaleChangedConn then
        u13.cameraHeadScaleChangedConn:Disconnect();
        u13.cameraHeadScaleChangedConn = nil;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        u13.cameraHeadScaleChangedConn = CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function() -- Line: 166
            -- upvalues: u13 (copy)
            u13:OnHeadScaleChanged();
        end);
        u13:OnHeadScaleChanged();
    end;
end;

function u2.OnHeadScaleChanged(p14) -- Line: 171
    local HeadScale = workspace.CurrentCamera.HeadScale;

    for i, v in p14.gamepadZoomLevels do
        p14.gamepadZoomLevels[i] = v * HeadScale / p14.headScale;
    end;

    p14:SetCameraToSubjectDistance(p14:GetCameraToSubjectDistance() * HeadScale / p14.headScale);
    p14.headScale = HeadScale;
end;

function u2.GetVRFocus(p15, p16, p17) -- Line: 187
    local v18 = p15.lastCameraFocus or p16;
    local x = p15.cameraTranslationConstraints.x;
    local v19 = math.min(1, p15.cameraTranslationConstraints.y + p17);
    p15.cameraTranslationConstraints = Vector3.new(x, v19, p15.cameraTranslationConstraints.z);
    local v20 = p15:GetCameraHeight();
    local v21 = Vector3.new(0, v20, 0);

    return CFrame.new(Vector3.new(p16.x, v18.y, p16.z):Lerp(p16 + v21, p15.cameraTranslationConstraints.y));
end;

function u2.StartFadeFromBlack(p22) -- Line: 203
    -- upvalues: UserGameSettings (copy), Lighting (copy)
    if UserGameSettings.VignetteEnabled == false then
        return;
    end;

    local VRFade = Lighting:FindFirstChild("VRFade");

    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect");
        VRFade.Name = "VRFade";
        VRFade.Parent = Lighting;
    end;

    VRFade.Brightness = -1;
    p22.VRFadeResetTimer = 0.1;
end;

function u2.UpdateFadeFromBlack(p23, p24) -- Line: 218
    -- upvalues: Lighting (copy)
    local VRFade = Lighting:FindFirstChild("VRFade");

    if p23.VRFadeResetTimer > 0 then
        p23.VRFadeResetTimer = math.max(p23.VRFadeResetTimer - p24, 0);
        local VRFade2 = Lighting:FindFirstChild("VRFade");

        if VRFade2 and VRFade2.Brightness < 0 then
            VRFade2.Brightness = math.min(VRFade2.Brightness + p24 * 10, 0);
        end;
    elseif VRFade then
        VRFade.Brightness = 0;
    end;
end;

function u2.StartVREdgeBlur(p25, p26) -- Line: 234
    -- upvalues: UserGameSettings (copy), RunService (copy), VRService (copy)
    if UserGameSettings.VignetteEnabled == false then
        return;
    end;

    local VRBlurPart = workspace.CurrentCamera:FindFirstChild("VRBlurPart");

    if not VRBlurPart then
        VRBlurPart = Instance.new("Part");
        VRBlurPart.Name = "VRBlurPart";
        VRBlurPart.Parent = workspace.CurrentCamera;
        VRBlurPart.CanTouch = false;
        VRBlurPart.CanCollide = false;
        VRBlurPart.CanQuery = false;
        VRBlurPart.Anchored = true;
        VRBlurPart.Size = Vector3.new(0.44, 0.47, 1);
        VRBlurPart.Transparency = 1;
        VRBlurPart.CastShadow = false;
        RunService.RenderStepped:Connect(function(p27) -- Line: 254
            -- upvalues: VRService (ref), VRBlurPart (ref)
            local v28 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
            local v29 = workspace.CurrentCamera.CFrame * (CFrame.new(v28.p * workspace.CurrentCamera.HeadScale) * (v28 - v28.p));
            VRBlurPart.CFrame = v29 * CFrame.Angles(0, 3.141592653589793, 0) + v29.LookVector * (1.05 * workspace.CurrentCamera.HeadScale);
            VRBlurPart.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale;
        end);
    end;

    local VRBlurScreen = p26.PlayerGui:FindFirstChild("VRBlurScreen");
    local v30;

    if VRBlurScreen then
        v30 = VRBlurScreen:FindFirstChild("VRBlur");
    else
        v30 = nil;
    end;

    if not v30 then
        local v31 = VRBlurScreen or (Instance.new("SurfaceGui") or Instance.new("ScreenGui"));
        v31.Name = "VRBlurScreen";
        v31.Parent = p26.PlayerGui;
        v31.Adornee = VRBlurPart;
        v30 = Instance.new("ImageLabel");
        v30.Name = "VRBlur";
        v30.Parent = v31;
        v30.Image = "rbxasset://textures/ui/VR/edgeBlur.png";
        v30.AnchorPoint = Vector2.new(0.5, 0.5);
        v30.Position = UDim2.new(0.5, 0, 0.5, 0);
        v30.Size = UDim2.fromScale(workspace.CurrentCamera.ViewportSize.X * 2.3 / 512, workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512);
        v30.BackgroundTransparency = 1;
        v30.Active = true;
        v30.ScaleType = Enum.ScaleType.Stretch;
    end;

    v30.Visible = true;
    v30.ImageTransparency = 0;
    p25.VREdgeBlurTimer = 0.14;
end;

function u2.UpdateEdgeBlur(p32, p33, p34) -- Line: 303
    local VRBlurScreen = p33.PlayerGui:FindFirstChild("VRBlurScreen");
    local v35;

    if VRBlurScreen then
        v35 = VRBlurScreen:FindFirstChild("VRBlur");
    else
        v35 = nil;
    end;

    if v35 then
        if p32.VREdgeBlurTimer > 0 then
            p32.VREdgeBlurTimer = p32.VREdgeBlurTimer - p34;
            local VRBlurScreen2 = p33.PlayerGui:FindFirstChild("VRBlurScreen");
            local v36 = VRBlurScreen2 and VRBlurScreen2:FindFirstChild("VRBlur");

            if v36 then
                v36.ImageTransparency = 1 - math.clamp(p32.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142;
            end;
        else
            v35.Visible = false;
        end;
    end;
end;

function u2.GetCameraHeight(p37) -- Line: 328
    return p37.inFirstPerson and 0 or 0.25881904510252074 * p37.currentSubjectDistance;
end;

function u2.GetSubjectCFrame(p38) -- Line: 335
    -- upvalues: BaseCamera (copy)
    local v39 = BaseCamera.GetSubjectCFrame(p38);
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return v39;
    end;

    if CurrentCamera:IsA("Humanoid") and (CurrentCamera:GetState() == Enum.HumanoidStateType.Dead and CurrentCamera == p38.lastSubject) then
        v39 = p38.lastSubjectCFrame;
    end;

    if v39 then
        p38.lastSubjectCFrame = v39;
    end;

    return v39;
end;

function u2.GetSubjectPosition(p40) -- Line: 361
    -- upvalues: BaseCamera (copy)
    local v41 = BaseCamera.GetSubjectPosition(p40);
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera:IsA("Humanoid") then
        if CurrentCamera:GetState() == Enum.HumanoidStateType.Dead and CurrentCamera == p40.lastSubject then
            v41 = p40.lastSubjectPosition;
        end;
    elseif CurrentCamera:IsA("VehicleSeat") then
        v41 = CurrentCamera.CFrame.p + CurrentCamera.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0));
    end;

    p40.lastSubjectPosition = v41;

    return v41;
end;

function u2.getRotation(p42, p43) -- Line: 390
    -- upvalues: CameraInput (copy), UserGameSettings (copy)
    local v44 = CameraInput.getRotation(p43);

    if UserGameSettings.VRSmoothRotationEnabled then
        return v44.X;
    end;

    if math.abs(v44.X) > 0.03 then
        if p42.stepRotateTimeout > 0 then
            p42.stepRotateTimeout = p42.stepRotateTimeout - p43;
        end;

        if p42.stepRotateTimeout <= 0 then
            local v45 = (v44.X < 0 and -1 or 1) * 0.5235987755982988;
            p42:StartFadeFromBlack();
            p42.stepRotateTimeout = 0.25;

            return v45;
        end;
    elseif math.abs(v44.X) < 0.02 then
        p42.stepRotateTimeout = 0;
    end;

    return 0;
end;

return u2;