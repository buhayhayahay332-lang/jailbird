
local StarterPlayer = game:GetService("StarterPlayer");

return {
    new = function(p1) -- Line: 5, Name: new
        -- upvalues: StarterPlayer (copy)
        local Camera = p1.Camera;
        local LocalPlayer = p1.LocalPlayer;
        local PlayerGui = p1.PlayerGui;
        local UserInputService = p1.UserInputService;
        local RunService = p1.RunService;
        local Workspace = p1.Workspace;
        local u2 = math.max(StarterPlayer.CameraMinZoomDistance, 6);
        local u3 = math.max(StarterPlayer.CameraMaxZoomDistance, 12);
        local CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance;
        local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance;
        local u4 = nil;
        local u5 = {};
        local u6 = nil;
        local u7 = nil;
        local u8 = 8;
        local u9 = 0;
        local u10 = 0.20943951023931956;
        local u11 = false;
        local u12 = nil;
        local zero = Vector2.zero;
        local u13 = nil;
        local u14 = nil;
        local u15 = {};

        local function isThirdPersonSpectateOrbitActive() -- Line: 38
            -- upvalues: Camera (copy)
            return Camera:GetAttribute("ThirdPersonSpectateOrbitActive") == true;
        end;

        local function setThirdPersonSpectateOrbitActive(p16) -- Line: 42
            -- upvalues: Camera (copy)
            Camera:SetAttribute("ThirdPersonSpectateOrbitActive", p16 == true);
        end;

        local function disconnectThirdPersonOrbitInputConnections() -- Line: 46
            -- upvalues: u5 (copy)
            for _, v in ipairs(u5) do
                if v then
                    v:Disconnect();
                end;
            end;

            table.clear(u5);
        end;

        function u15.ReleaseMouse() -- Line: 55
            -- upvalues: u11 (ref), UserInputService (copy)
            u11 = false;
            UserInputService.MouseIconEnabled = true;
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        end;

        local function captureThirdPersonOrbitMouse() -- Line: 61
            -- upvalues: u11 (ref), UserInputService (copy)
            u11 = true;
            UserInputService.MouseIconEnabled = false;

            if pcall(function() -- Line: 64
                -- upvalues: UserInputService (ref)
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition;
            end) ~= true then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
            end;
        end;

        local function getThirdPersonOrbitFocus(p17) -- Line: 72
            if not p17 then
                return nil, nil;
            end;

            local HumanoidRootPart = p17:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                return HumanoidRootPart.Position + Vector3.new(0, 1.65, 0), HumanoidRootPart.CFrame.LookVector;
            end;

            local Head = p17:FindFirstChild("Head");

            if Head and Head:IsA("BasePart") then
                return Head.Position, Head.CFrame.LookVector;
            end;

            return nil, nil;
        end;

        local function captureThirdPersonSpectateCameraState() -- Line: 90
            -- upvalues: u4 (ref), UserInputService (copy), LocalPlayer (copy)
            if u4 ~= nil then
                return;
            end;

            u4 = {
                MouseIconEnabled = UserInputService.MouseIconEnabled,
                MouseBehavior = UserInputService.MouseBehavior,
                CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance,
                CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
            };
            pcall(function() -- Line: 102
                -- upvalues: u4 (ref), LocalPlayer (ref)
                u4.CameraMode = LocalPlayer.CameraMode;
            end);
        end;

        function u15.ApplyCameraControls() -- Line: 107
            -- upvalues: captureThirdPersonSpectateCameraState (copy), UserInputService (copy), LocalPlayer (copy), u2 (copy), u3 (copy)
            captureThirdPersonSpectateCameraState();
            UserInputService.MouseIconEnabled = true;
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
            LocalPlayer.CameraMinZoomDistance = u2;
            LocalPlayer.CameraMaxZoomDistance = u3;
            pcall(function() -- Line: 113
                -- upvalues: LocalPlayer (ref)
                LocalPlayer.CameraMode = Enum.CameraMode.Classic;
            end);
        end;

        function u15.RestoreCameraControls() -- Line: 118
            -- upvalues: u4 (ref), UserInputService (copy), LocalPlayer (copy), CameraMinZoomDistance (copy), CameraMaxZoomDistance (copy)
            if u4 == nil then
                UserInputService.MouseIconEnabled = true;
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default;

                return;
            end;

            UserInputService.MouseIconEnabled = u4.MouseIconEnabled;
            UserInputService.MouseBehavior = u4.MouseBehavior;
            LocalPlayer.CameraMinZoomDistance = u4.CameraMinZoomDistance or CameraMinZoomDistance;
            LocalPlayer.CameraMaxZoomDistance = u4.CameraMaxZoomDistance or CameraMaxZoomDistance;
            pcall(function() -- Line: 129
                -- upvalues: u4 (ref), LocalPlayer (ref)
                if u4.CameraMode ~= nil then
                    LocalPlayer.CameraMode = u4.CameraMode;
                end;
            end);
            u4 = nil;
        end;

        function u15.GetMinZoom() -- Line: 137
            -- upvalues: u2 (copy)
            return u2;
        end;

        function u15.GetMaxZoom() -- Line: 141
            -- upvalues: u3 (copy)
            return u3;
        end;

        function u15.HasSpectateRender() -- Line: 145
            -- upvalues: u13 (ref)
            return u13 ~= nil;
        end;

        function u15.HasKillCamRender() -- Line: 149
            -- upvalues: u14 (ref)
            return u14 ~= nil;
        end;

        function u15.StopOrbit() -- Line: 153
            -- upvalues: disconnectThirdPersonOrbitInputConnections (copy), u15 (copy), u13 (ref), u14 (ref), u6 (ref), u7 (ref), u11 (ref), u12 (ref), zero (ref), Camera (copy)
            disconnectThirdPersonOrbitInputConnections();
            u15.ReleaseMouse();

            if u13 then
                u13:Disconnect();
                u13 = nil;
            end;

            if u14 then
                u14:Disconnect();
                u14 = nil;
            end;

            u6 = nil;
            u7 = nil;
            u11 = false;
            u12 = nil;
            zero = Vector2.zero;
            Camera:SetAttribute("ThirdPersonSpectateOrbitActive", false);
        end;

        function u15.StartOrbit(p18, p19, p20) -- Line: 172
            -- upvalues: u15 (copy), u6 (ref), u7 (ref), u8 (ref), u2 (copy), u3 (copy), u10 (ref), u12 (ref), zero (ref), getThirdPersonOrbitFocus (copy), u9 (ref), Camera (copy), PlayerGui (copy), u5 (copy), UserInputService (copy), u11 (ref), LocalPlayer (copy), Workspace (copy), u14 (ref), RunService (copy), u13 (ref)
            u15.StopOrbit();

            if not (p18 and p19) then
                return;
            end;

            u6 = p18;
            u7 = p19;
            u8 = math.clamp(8, u2, u3);
            u10 = 0.20943951023931956;
            u15.ReleaseMouse();
            u12 = nil;
            zero = Vector2.zero;
            local _, v21 = getThirdPersonOrbitFocus(p18);

            if v21 then
                u9 = math.atan2(-v21.X, -v21.Z);
            else
                u9 = 0;
            end;

            Camera:SetAttribute("ThirdPersonSpectateOrbitActive", true);
            Camera.CameraType = Enum.CameraType.Scriptable;
            Camera.CameraSubject = nil;
            Camera.FieldOfView = 90;

            local function isThirdPersonOrbitTouchBlocked(p22) -- Line: 198
                -- upvalues: PlayerGui (ref)
                if typeof(p22) ~= "Vector3" and typeof(p22) ~= "Vector2" then
                    return false;
                end;

                if not PlayerGui or PlayerGui.Parent == nil then
                    return false;
                end;

                local v23 = PlayerGui:GetGuiObjectsAtPosition(p22.X, p22.Y);

                for _, v in ipairs(v23) do
                    if v.Visible == true and (v:IsA("GuiButton") or v:IsA("TextBox")) then
                        return true;
                    end;
                end;

                return false;
            end;

            local function canBeginThirdPersonOrbitTouch(p24) -- Line: 217
                -- upvalues: u12 (ref), isThirdPersonOrbitTouchBlocked (copy)
                if u12 == nil then
                    return isThirdPersonOrbitTouchBlocked(p24.Position) ~= true;
                end;

                return false;
            end;

            table.insert(u5, UserInputService.InputBegan:Connect(function(p25) -- Line: 229
                -- upvalues: Camera (ref), u11 (ref), UserInputService (ref), u12 (ref), isThirdPersonOrbitTouchBlocked (copy)
                if Camera:GetAttribute("ThirdPersonSpectateOrbitActive") == true ~= true then
                    return;
                end;

                if p25.UserInputType == Enum.UserInputType.MouseButton2 then
                    u11 = true;
                    UserInputService.MouseIconEnabled = false;

                    if pcall(function() -- Line: 64
                        -- upvalues: UserInputService (ref)
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition;
                    end) ~= true then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
                    end;
                elseif p25.UserInputType == Enum.UserInputType.Touch then
                    local v26;

                    if u12 == nil then
                        v26 = isThirdPersonOrbitTouchBlocked(p25.Position) ~= true;
                    else
                        v26 = false;
                    end;

                    if v26 ~= true then
                        return;
                    end;

                    u12 = p25;
                end;
            end));
            table.insert(u5, UserInputService.InputEnded:Connect(function(p27) -- Line: 244
                -- upvalues: u15 (ref), u12 (ref), zero (ref)
                if p27.UserInputType == Enum.UserInputType.MouseButton2 then
                    u15.ReleaseMouse();

                    return;
                end;

                if p27.UserInputType == Enum.UserInputType.Touch and u12 == p27 then
                    u12 = nil;

                    return;
                end;

                if p27.KeyCode == Enum.KeyCode.Thumbstick2 then
                    zero = Vector2.zero;
                end;
            end));
            table.insert(u5, UserInputService.InputChanged:Connect(function(p28) -- Line: 254
                -- upvalues: Camera (ref), u11 (ref), u9 (ref), u10 (ref), u8 (ref), u2 (ref), u3 (ref), u12 (ref), zero (ref)
                if Camera:GetAttribute("ThirdPersonSpectateOrbitActive") == true ~= true then
                    return;
                end;

                if p28.UserInputType == Enum.UserInputType.MouseMovement then
                    if u11 ~= true then
                        return;
                    end;

                    u9 = u9 - p28.Delta.X * 0.0045;
                    u10 = math.clamp(u10 + p28.Delta.Y * 0.0045, -1.2217304763960306, 1.2217304763960306);

                    return;
                end;

                if p28.UserInputType == Enum.UserInputType.MouseWheel then
                    u8 = math.clamp(u8 - p28.Position.Z, u2, u3);

                    return;
                end;

                if p28.UserInputType ~= Enum.UserInputType.Touch or u12 ~= p28 then
                    if p28.KeyCode == Enum.KeyCode.Thumbstick2 then
                        zero = p28.Position;
                    end;

                    return;
                end;

                u9 = u9 - p28.Delta.X * 0.0045;
                u10 = math.clamp(u10 + p28.Delta.Y * 0.0045, -1.2217304763960306, 1.2217304763960306);
            end));

            local function v41(p29) -- Line: 275
                -- upvalues: Camera (ref), getThirdPersonOrbitFocus (ref), u6 (ref), zero (ref), u9 (ref), u10 (ref), u8 (ref), LocalPlayer (ref), Workspace (ref)
                if Camera:GetAttribute("ThirdPersonSpectateOrbitActive") == true ~= true then
                    return;
                end;

                local v30 = select(1, getThirdPersonOrbitFocus(u6));

                if not v30 then
                    return;
                end;

                if zero.Magnitude > 0.05 then
                    u9 = u9 - zero.X * 3.5 * p29;
                    u10 = math.clamp(u10 - zero.Y * 3.5 * p29, -1.2217304763960306, 1.2217304763960306);
                end;

                local v31 = u8 * math.cos(u10);
                local v32 = math.sin(u9) * v31;
                local v33 = math.sin(u10) * u8;
                local v34 = math.cos(u9) * v31;
                local v35 = v30 + Vector3.new(v32, v33, v34);
                local v36 = v35 - v30;

                if v36.Magnitude > 0 then
                    local v37 = { u6 };

                    if LocalPlayer.Character then
                        table.insert(v37, LocalPlayer.Character);
                    end;

                    local v38 = RaycastParams.new();
                    v38.FilterType = Enum.RaycastFilterType.Exclude;
                    v38.FilterDescendantsInstances = v37;
                    v38.IgnoreWater = true;
                    local v39 = Workspace:Raycast(v30, v36, v38);

                    if v39 then
                        local v40 = math.max(2.5, v39.Distance - 0.35);
                        v35 = v30 + v36.Unit * math.min(v36.Magnitude, v40);
                    end;
                end;

                Camera.CFrame = CFrame.lookAt(v35, v30);
                Camera.Focus = CFrame.new(v30);
            end;

            if p20 == true then
                u14 = RunService.RenderStepped:Connect(v41);
            else
                u13 = RunService.RenderStepped:Connect(v41);
            end;

            v41(0);
        end;

        return u15;
    end
};