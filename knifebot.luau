if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local KnifebotSettings = getgenv().KnifebotSettings or {
    Enabled = false,
    ToggleKey = "V",
}
getgenv().KnifebotSettings = KnifebotSettings

local Global = getgenv()
if Global.__knifebot_cleanup then
    pcall(Global.__knifebot_cleanup)
end

local RuntimeState = {
    LoopStarted = false,
}

Global.__knifebot_state = RuntimeState
Global.__knifebot_cleanup = function()
    KnifebotSettings.Enabled = false
    RuntimeState.LoopStarted = false
end

local MouseButtons = {
    MB1 = Enum.UserInputType.MouseButton1,
    MB2 = Enum.UserInputType.MouseButton2,
    MB3 = Enum.UserInputType.MouseButton3,
}

local function resolveKey(key)
    if typeof(key) == "EnumItem" then return key end
    if type(key) == "string" then
        local stripped = key:match("%.([^%.]+)$") or key
        if MouseButtons[stripped] then return MouseButtons[stripped] end
        local ok1, r1 = pcall(function() return Enum.KeyCode[stripped] end)
        if ok1 and typeof(r1) == "EnumItem" then return r1 end
        local ok2, r2 = pcall(function() return Enum.UserInputType[stripped] end)
        if ok2 and typeof(r2) == "EnumItem" then return r2 end
    end
    return nil
end

local function keyMatches(input)
    local key = resolveKey(KnifebotSettings.ToggleKey)
    if not key then return false end
    if key.EnumType == Enum.KeyCode then return input.KeyCode == key end
    if key.EnumType == Enum.UserInputType then return input.UserInputType == key end
    return false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if Global.Library and Global.Library.IsPicking then return end
    if not keyMatches(input) then return end

    KnifebotSettings.Enabled = not KnifebotSettings.Enabled
    local Toggles = Global.Toggles or (Global.Library and Global.Library.Toggles)
    if Toggles and Toggles.KnifebotEnabled then
        Toggles.KnifebotEnabled:SetValue(KnifebotSettings.Enabled)
    end
end)

local function knifeLoop()
    while KnifebotSettings.Enabled do
        task.wait(0.05)

        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        for _, target in ipairs(Players:GetPlayers()) do
            if target == LocalPlayer then continue end
            if target.Team == LocalPlayer.Team then continue end
            local targetChar = target.Character
            if not targetChar then continue end
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
            if not targetHRP then continue end

            pcall(function()
                hrp.CFrame = targetHRP.CFrame
            end)

            pcall(function()
                local gameEvents = ReplicatedStorage:FindFirstChild("GameEvents")
                if not gameEvents then return end
                local damageEvent = gameEvents:FindFirstChild("Damage")
                if not damageEvent then return end
                damageEvent:FireServer(target, 200, "Bayonet", {
                    Normal        = Vector3.new(0, 0, 0),
                    Direction     = Vector3.zAxis,
                    StartPosition = targetHRP.Position,
                    Instance      = targetChar:FindFirstChild("Head") or targetHRP,
                    Material      = Enum.Material.Plastic,
                    EndPosition   = targetHRP.Position,
                })
            end)
        end
    end

    RuntimeState.LoopStarted = false
end

task.spawn(function()
    while true do
        if KnifebotSettings.Enabled and not RuntimeState.LoopStarted then
            RuntimeState.LoopStarted = true
            task.spawn(knifeLoop)
        end
        task.wait(0.1)
    end
end)