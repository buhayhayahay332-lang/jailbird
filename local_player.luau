local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local LocalPlayerSettings = getgenv().LocalPlayerSettings or {
    WalkSpeedEnabled = false,
    WalkSpeed = 24,
    PhaseEnabled = false,
    FlyEnabled = false,
    FlySpeed = 60,
}

getgenv().LocalPlayerSettings = LocalPlayerSettings

local originalWalkSpeeds = setmetatable({}, { __mode = "k" })
local originalCollision = setmetatable({}, { __mode = "k" })
local originalHumanoidState = setmetatable({}, { __mode = "k" })
local wasFlying = false

local function getCharacter()
    return LocalPlayer and LocalPlayer.Character or nil
end

local function getHumanoid(character)
    character = character or getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function getRootPart(character)
    character = character or getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart") or nil
end

local function captureHumanoidState(humanoid)
    if not humanoid or originalHumanoidState[humanoid] then
        return
    end

    originalHumanoidState[humanoid] = {
        PlatformStand = humanoid.PlatformStand,
        AutoRotate = humanoid.AutoRotate,
    }
end

local function restoreHumanoidState(humanoid)
    local original = humanoid and originalHumanoidState[humanoid]
    if not original then
        return
    end

    humanoid.PlatformStand = original.PlatformStand
    humanoid.AutoRotate = original.AutoRotate
    originalHumanoidState[humanoid] = nil
end

local function applyWalkSpeed()
    local humanoid = getHumanoid()
    if not humanoid then
        return
    end

    if not originalWalkSpeeds[humanoid] then
        originalWalkSpeeds[humanoid] = humanoid.WalkSpeed
    end

    if LocalPlayerSettings.WalkSpeedEnabled == true then
        humanoid.WalkSpeed = tonumber(LocalPlayerSettings.WalkSpeed) or 16
    else
        local original = originalWalkSpeeds[humanoid]
        if original then
            humanoid.WalkSpeed = original
            originalWalkSpeeds[humanoid] = nil
        end
    end
end

local function setCharacterCollision(character, canCollide)
    if not character then
        return
    end

    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if originalCollision[descendant] == nil then
                originalCollision[descendant] = descendant.CanCollide
            end

            descendant.CanCollide = canCollide
        end
    end
end

local function applyPhase()
    local character = getCharacter()
    if LocalPlayerSettings.PhaseEnabled == true then
        setCharacterCollision(character, false)
        return
    end

    for part, original in pairs(originalCollision) do
        if part and part.Parent then
            part.CanCollide = original
        end

        originalCollision[part] = nil
    end
end

local function getFlyDirection()
    local camera = Workspace.CurrentCamera
    if not camera then
        return Vector3.new()
    end

    local direction = Vector3.new()
    local look = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction += look
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction -= look
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction += right
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction -= right
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction += Vector3.new(0, 1, 0)
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction -= Vector3.new(0, 1, 0)
    end

    if direction.Magnitude > 0 then
        return direction.Unit
    end

    return Vector3.new()
end

local function applyFly()
    local character = getCharacter()
    local humanoid = getHumanoid(character)
    local root = getRootPart(character)

    if not humanoid or not root then
        return
    end

    if LocalPlayerSettings.FlyEnabled == true then
        wasFlying = true
        captureHumanoidState(humanoid)

        humanoid.PlatformStand = true
        humanoid.AutoRotate = false

        local speed = tonumber(LocalPlayerSettings.FlySpeed) or 60
        root.AssemblyLinearVelocity = getFlyDirection() * speed
        root.AssemblyAngularVelocity = Vector3.new()
        return
    end

    if wasFlying then
        wasFlying = false
        root.AssemblyLinearVelocity = Vector3.new()
        root.AssemblyAngularVelocity = Vector3.new()
    end

    restoreHumanoidState(humanoid)
end

RunService.Heartbeat:Connect(function()
    applyWalkSpeed()
    applyPhase()
end)

RunService.RenderStepped:Connect(function()
    applyFly()
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid", 5)
    character:WaitForChild("HumanoidRootPart", 5)
    task.defer(function()
        applyWalkSpeed()
        applyPhase()
        applyFly()
    end)
end)

return LocalPlayerSettings
