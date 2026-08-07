if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local TriggerbotSettings = getgenv().TriggerbotSettings or {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = false,
    FOV = 150,
    Delay = 0.1,
}
getgenv().TriggerbotSettings = TriggerbotSettings

local Global = getgenv()
if Global.__triggerbot_cleanup then
    pcall(Global.__triggerbot_cleanup)
end

local RuntimeState = {
    Connections = {},
}

Global.__triggerbot_state = RuntimeState
Global.__triggerbot_cleanup = function()
    for _, Connection in ipairs(RuntimeState.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end
end

local VisParams = RaycastParams.new()
VisParams.FilterType = Enum.RaycastFilterType.Exclude

local function isVisible(hrp, targetPart)
    local char = LocalPlayer.Character
    if not char or not hrp or not targetPart then return false end
    VisParams.FilterDescendantsInstances = { char }
    local dir = targetPart.Position - hrp.Position
    if dir.Magnitude == 0 then return false end
    local result = Workspace:Raycast(hrp.Position, dir.Unit * dir.Magnitude, VisParams)
    return not result or (result.Instance and result.Instance:IsDescendantOf(targetPart.Parent))
end

local function getClosestTarget(cam)
    local center    = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local best      = nil
    local bestDist  = TriggerbotSettings.FOV

    for _, player in next, Players:GetPlayers() do
        if player == LocalPlayer then continue end
        if TriggerbotSettings.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local s, onScreen = cam:WorldToScreenPoint(hrp.Position)
        if not onScreen then continue end
        local dist = (Vector2.new(s.X, s.Y) - center).Magnitude
        if dist > bestDist then continue end
        if TriggerbotSettings.VisibleCheck and not isVisible(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), hrp) then continue end
        bestDist = dist
        best = hrp
    end

    return best
end

local lastShot = 0

table.insert(RuntimeState.Connections,
    RunService.Heartbeat:Connect(function()
        if not TriggerbotSettings.Enabled then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end

        local target = getClosestTarget(cam)
        if not target then return end

        local now = tick()
        if (now - lastShot) < TriggerbotSettings.Delay then return end
        lastShot = now

        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        end)
        task.delay(0.05, function()
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end)
    end)
)