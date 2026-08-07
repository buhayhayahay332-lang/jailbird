if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local AimbotSettings = getgenv().AimbotSettings or {
    Enabled = false,
    Mode = "Hold",
    Key = "V",
    TargetPart = "Head",
    TeamCheck = true,
    WallCheck = false,
    Smoothing = 0.25,
    Priority = "Closest to Crosshair",
}
getgenv().AimbotSettings = AimbotSettings

local SilentAimSettings = getgenv().SilentAimSettings or { FOVRadius = 150 }

local Global = getgenv()
if Global.__aimbot_cleanup then
    pcall(Global.__aimbot_cleanup)
end

local RuntimeState = {
    Connections = {},
}

local camControlled = false

Global.__aimbot_state = RuntimeState
Global.__aimbot_cleanup = function()
    if camControlled then
        camControlled = false
        pcall(function()
            Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end)
    end

    for _, Connection in ipairs(RuntimeState.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end
end

local WallCheckParams = RaycastParams.new()
WallCheckParams.FilterType = Enum.RaycastFilterType.Exclude

local function isVisible(part)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not part then return false end
    WallCheckParams.FilterDescendantsInstances = { char }
    local result = Workspace:Raycast(hrp.Position, part.Position - hrp.Position, WallCheckParams)
    if not result then return true end
    return result.Instance and result.Instance:IsDescendantOf(part.Parent)
end

local function resolveKey(key)
    if typeof(key) == "EnumItem" then return key end
    if type(key) == "string" then
        local stripped = key:match("%.([^%.]+)$") or key
        local ok1, r1 = pcall(function() return Enum.KeyCode[stripped] end)
        if ok1 and typeof(r1) == "EnumItem" then return r1 end
        local ok2, r2 = pcall(function() return Enum.UserInputType[stripped] end)
        if ok2 and typeof(r2) == "EnumItem" then return r2 end
    end
    return nil
end

local function isKeyDown()
    local key = resolveKey(AimbotSettings.Key)
    if not key then return false end
    if key.EnumType == Enum.KeyCode then return UserInputService:IsKeyDown(key) end
    if key.EnumType == Enum.UserInputType then return UserInputService:IsMouseButtonPressed(key) end
    return false
end

local function keyMatches(input)
    local key = resolveKey(AimbotSettings.Key)
    if not key then return false end
    if key.EnumType == Enum.KeyCode then return input.KeyCode == key end
    if key.EnumType == Enum.UserInputType then return input.UserInputType == key end
    return false
end

local aimToggled = false

local function getTargetPart(char)
    for _, child in pairs(char:GetChildren()) do
        if child.Name:lower() == AimbotSettings.TargetPart:lower() then
            return child
        end
    end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getBestTarget(cam)
    local center = cam.ViewportSize / 2
    local maxDist = SilentAimSettings.FOVRadius or 150
    local bestPart, bestScore = nil, math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if AimbotSettings.TeamCheck and player.Team and player.Team == LocalPlayer.Team then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local part = getTargetPart(char) or hrp

        local s, onScreen = cam:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local screenDist = (Vector2.new(s.X, s.Y) - center).Magnitude
        if screenDist > maxDist then continue end
        if AimbotSettings.WallCheck and not isVisible(part) then continue end

        local score
        if AimbotSettings.Priority == "Lowest Health" then
            score = hum.Health
        elseif AimbotSettings.Priority == "Closest Distance" then
            score = (cam.CFrame.Position - hrp.Position).Magnitude
        else
            score = screenDist
        end

        if score < bestScore then
            bestScore = score
            bestPart = part
        end
    end

    return bestPart
end

local function shouldAim()
    if not AimbotSettings.Enabled then return false end
    if AimbotSettings.Mode == "Always" then return true end
    if AimbotSettings.Mode == "Hold" then return isKeyDown() end
    if AimbotSettings.Mode == "Toggle" then return aimToggled end
    return false
end

table.insert(RuntimeState.Connections,
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if AimbotSettings.Enabled and AimbotSettings.Mode == "Toggle" then
            if keyMatches(input) then aimToggled = not aimToggled end
        end
    end)
)

table.insert(RuntimeState.Connections,
    RunService.RenderStepped:Connect(function()
        local cam = Workspace.CurrentCamera
        if not cam then return end

        local aiming = AimbotSettings.Enabled and shouldAim()

        if aiming then
            if not camControlled then
                camControlled = true
                cam.CameraType = Enum.CameraType.Scriptable
            end

            local target = getBestTarget(cam)
            if target then
                local lerpAmount = math.clamp(1 - AimbotSettings.Smoothing, 0.01, 1)
                local targetCFrame = CFrame.lookAt(cam.CFrame.Position, target.Position)
                cam.CFrame = cam.CFrame:Lerp(targetCFrame, lerpAmount)
            end
        elseif camControlled then
            camControlled = false
            cam.CameraType = Enum.CameraType.Custom
        end
    end)
)
