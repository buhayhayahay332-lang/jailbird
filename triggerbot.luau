if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local TriggerbotSettings = getgenv().TriggerbotSettings or {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = false,
    Delay = 0.1,
}
getgenv().TriggerbotSettings = TriggerbotSettings
local SilentAimSettings = getgenv().SilentAimSettings or { FOVRadius = 150 }

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

local function isVisible(targetPart)
    local cam = Workspace.CurrentCamera
    if not cam or not targetPart then return false end

    local origin = cam.CFrame.Position
    local dir = targetPart.Position - origin
    if dir.Magnitude == 0 then return false end

    local ignore = { LocalPlayer.Character }
    for _ = 1, 12 do
        VisParams.FilterDescendantsInstances = ignore
        local result = Workspace:Raycast(origin, dir.Unit * dir.Magnitude, VisParams)
        if not result then return true end

        local inst = result.Instance
        if inst:IsDescendantOf(targetPart.Parent) then return true end

        if (inst.Transparency >= 1) or (inst.CanCollide == false) then
            ignore[#ignore + 1] = inst
            origin = result.Position + dir.Unit * 0.01
        else
            return false
        end
    end

    return false
end

local function getClosestTarget(cam)
    local center    = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local best      = nil
    local bestDist  = SilentAimSettings.FOVRadius

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
        if TriggerbotSettings.VisibleCheck and not isVisible(hrp) then continue end
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
