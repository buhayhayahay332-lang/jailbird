if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local KnifebotSettings = getgenv().KnifebotSettings or {
    Enabled = false,
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