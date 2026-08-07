if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

local AllSounds = {
    ["default"]   = "160432334",
    ["dink"]      = "988593556",
    ["tf2"]       = "8255306220",
    ["gamesense"] = "4817809188",
    ["rust"]      = "1255040462",
    ["neverlose"] = "8726881116",
    ["bubble"]    = "198598793",
    ["bubble2"]   = "132948338000932",
    ["quake"]     = "1455817260",
    ["among-us"]  = "7227567562",
    ["ding"]      = "72656167409567",
    ["minecraft"] = "6361963422",
    ["blackout"]  = "3748776946",
    ["osu"]       = "7151989073",
    ["paintball"] = "117404476273393",
    ["key"]       = "140134596265975",
    ["hit"]       = "133749572213659",
    ["bamboo"]    = "123464486116204",
    ["skeet"]     = "80534344648365",
    ["critical"]  = "13471740561",
    ["sonicexe"]  = "137584754609456",
    ["hint"]      = "134763632925481",
    ["slap"]      = "121788398947572",
    ["bell"]      = "124010691633262",
}

local SoundNames = {}
for name in next, AllSounds do table.insert(SoundNames, name) end
table.sort(SoundNames)

local CombatSettings = getgenv().CombatSettings or {
    NotifyEnabled  = true,
    NotifyDuration = 3,

    Hitmarker = {
        Enabled  = false,
        Duration = 0.5,
        Color    = Color3.fromRGB(255, 50, 50),
        KillColor = Color3.fromRGB(255, 200, 0),
    },

    HitIndicator = {
        Enabled = false,
    },

    Sounds = {
        HitEnabled  = true,
        KillEnabled = true,
        HitVolume   = 0.5,
        KillVolume  = 0.5,
        HitSound    = "default",
        KillSound   = "default",
    },
}
getgenv().CombatSettings = CombatSettings
getgenv().CombatHitSounds = SoundNames
getgenv().CombatKillSounds = SoundNames
getgenv().CombatSoundIds = AllSounds

local Global = getgenv()
if Global.__combat_cleanup then
    pcall(Global.__combat_cleanup)
end

local RuntimeState = {
    Connections = {},
    ActiveSounds = {},
}

Global.__combat_state = RuntimeState
Global.__combat_cleanup = function()
    for _, Connection in ipairs(RuntimeState.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end
end

local function notify(title, description)
    pcall(function()
        local library = getgenv().Library
        if library and library.Notify then
            library:Notify({
                Title       = title,
                Description = description,
                Time        = CombatSettings.NotifyDuration,
            })
        end
    end)
end

local function playSound(soundId, volume)
    if not soundId or soundId == "" then return end
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume  = volume
    sound.Parent  = Workspace.CurrentCamera
    sound:Play()
    RuntimeState.ActiveSounds[sound] = true
    sound.Ended:Connect(function() RuntimeState.ActiveSounds[sound] = nil end)
    Debris:AddItem(sound, 3)
end

local REAL_HITMARKER_ID = "rbxassetid://76962155018"
local mutedConnections = {}
local descendantConnection = nil

local function muteSound(sound)
    if not sound:IsA("Sound") then return end
    local sounds = CombatSettings.Sounds
    if not (sounds.HitEnabled or sounds.KillEnabled) then return end
    if tostring(sound.SoundId) == REAL_HITMARKER_ID or sound.Name == "HitMarker" or sound.Name == "Hit" then
        sound.Volume = 0
        if not mutedConnections[sound] then
            mutedConnections[sound] = sound:GetPropertyChangedSignal("Volume"):Connect(function()
                local sounds2 = CombatSettings.Sounds
                if sounds2.HitEnabled or sounds2.KillEnabled then
                    sound.Volume = 0
                end
            end)
        end
    end
end

local function muteGameHitSounds()
    if descendantConnection then
        descendantConnection:Disconnect()
        descendantConnection = nil
    end
    for _, v in ipairs(Workspace:GetDescendants()) do muteSound(v) end
    descendantConnection = game.DescendantAdded:Connect(muteSound)
end

local FIRE_LINGER_SECONDS = 0.6
local recentTargets = {}

local function flashHitmarker(player, isKill)
    local char = player and player.Character
    if not char then return end

    if CombatSettings.Hitmarker.Enabled then
        task.spawn(function()
            local settings = CombatSettings.Hitmarker
            local col = isKill and settings.KillColor or settings.Color
            local hl = Instance.new("Highlight")
            hl.FillColor           = col
            hl.OutlineColor        = col
            hl.FillTransparency    = 0.2
            hl.OutlineTransparency = 0
            hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee             = char
            hl.Parent              = Workspace
            local duration = math.max(settings.Duration, 0.01)
            local start = tick()
            local conn
            conn = RunService.RenderStepped:Connect(function()
                local t = math.clamp((tick() - start) / duration, 0, 1)
                hl.FillTransparency    = 0.2 + 0.8 * t
                hl.OutlineTransparency = t
                if t >= 1 then hl:Destroy(); conn:Disconnect() end
            end)
        end)
    end

    if CombatSettings.HitIndicator.Enabled then
        task.spawn(function()
            local head = char:FindFirstChild("Head")
            if not head then return end
            local msg = isKill and "kill" or "hit"
            local col = isKill and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 50, 50)
            local bb = Instance.new("BillboardGui")
            bb.AlwaysOnTop = true
            bb.Size        = UDim2.new(0, 60, 0, 30)
            bb.StudsOffset = Vector3.new(math.random(-1, 1), 3, 0)
            bb.Parent      = head
            local lbl = Instance.new("TextLabel", bb)
            lbl.Size                   = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text                   = msg
            lbl.TextColor3             = col
            lbl.TextStrokeColor3       = Color3.new(0, 0, 0)
            lbl.TextStrokeTransparency = 0
            lbl.Font                   = Enum.Font.GothamBold
            lbl.TextSize               = 18
            local rise = 0
            local conn
            conn = RunService.RenderStepped:Connect(function(dt)
                rise = rise + dt * 2.5
                bb.StudsOffset = Vector3.new(bb.StudsOffset.X, 3 + rise, 0)
                local t = math.clamp(rise / 1.5, 0, 1)
                lbl.TextTransparency       = t
                lbl.TextStrokeTransparency = t
                if t >= 1 then bb:Destroy(); conn:Disconnect() end
            end)
        end)
    end
end

local function resolvePlayerFromDescendant(instance)
    local current = instance
    while current and current ~= Workspace do
        local parent = current.Parent
        if parent == Workspace then
            for _, p in next, Players:GetPlayers() do
                if p.Character == current then return p end
            end
            return nil
        end
        current = parent
    end
    return nil
end

local function initHitDetection()
    local sounds = CombatSettings.Sounds
    local lastHitTime  = 0
    local lastKillTime = 0
    local COOLDOWN     = 0.15

    local function onHitSoundAdded(sound)
        if not sound:IsA("Sound") then return end
        if sound.Name ~= "HitMarker" and sound.Name ~= "Hit" then return end
        if not sound:IsDescendantOf(Workspace) then return end
        if sound.Parent == Workspace then return end

        sound.Volume = 0
        if not mutedConnections[sound] then
            mutedConnections[sound] = sound:GetPropertyChangedSignal("Volume"):Connect(function()
                sound.Volume = 0
            end)
        end

        local hitPlayer = resolvePlayerFromDescendant(sound)
        if not hitPlayer then return end

        local expiry = recentTargets[hitPlayer]
        if not expiry or tick() > expiry then return end

        task.defer(function()
            local now = tick()
            local isKill = false
            if hitPlayer.Character then
                local hum = hitPlayer.Character:FindFirstChildOfClass("Humanoid")
                isKill = hum ~= nil and hum.Health <= 0
            end

            if CombatSettings.NotifyEnabled then
                task.spawn(function()
                    pcall(function()
                        local lc   = LocalPlayer.Character
                        local lhrp = lc and lc:FindFirstChild("HumanoidRootPart")
                        local ehrp = hitPlayer.Character and hitPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local dist = (lhrp and ehrp) and math.floor((lhrp.Position - ehrp.Position).Magnitude / 3) or 0
                        local msg = isKill
                            and ("killed " .. hitPlayer.Name .. " [" .. dist .. "m]")
                            or  ("hit "    .. hitPlayer.Name .. " [" .. dist .. "m]")
                        notify("Combat", msg)
                    end)
                end)
            end

            pcall(function() flashHitmarker(hitPlayer, isKill) end)

            if isKill then
                if now - lastKillTime >= COOLDOWN then
                    lastKillTime = now
                    if sounds.KillEnabled then
                        pcall(function() playSound(AllSounds[sounds.KillSound], sounds.KillVolume) end)
                    end
                end
            else
                if now - lastHitTime >= COOLDOWN then
                    lastHitTime = now
                    if sounds.HitEnabled then
                        pcall(function() playSound(AllSounds[sounds.HitSound], sounds.HitVolume) end)
                    end
                end
            end
        end)
    end

    local hitmarkerWatcher = Workspace.DescendantAdded:Connect(onHitSoundAdded)
    table.insert(RuntimeState.Connections, hitmarkerWatcher)

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Sound") and (v.Name == "HitMarker" or v.Name == "Hit") then
            onHitSoundAdded(v)
        end
    end

    if LocalPlayer.Character then muteGameHitSounds() end
    table.insert(RuntimeState.Connections, LocalPlayer.CharacterAdded:Connect(muteGameHitSounds))

    table.insert(RuntimeState.Connections,
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local cam = Workspace.CurrentCamera
                if not cam then return end
                for _, p in next, Players:GetPlayers() do
                    if p == LocalPlayer then continue end
                    local pchar = p.Character
                    local phrp  = pchar and pchar:FindFirstChild("HumanoidRootPart")
                    if not phrp then continue end
                    local _, onScreen = cam:WorldToViewportPoint(phrp.Position)
                    if onScreen then recentTargets[p] = tick() + FIRE_LINGER_SECONDS end
                end
            end
        end)
    )
end

RuntimeState.Connections = {}

initHitDetection()

-- restore volumes on unload
RuntimeState.PrevCleanup = Global.__combat_cleanup
Global.__combat_cleanup = function()
    pcall(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Sound") and v.Name == "HitMarker" then v.Volume = 1 end
        end
    end)
    if descendantConnection then
        pcall(function() descendantConnection:Disconnect() end)
        descendantConnection = nil
    end
    for sound in pairs(RuntimeState.ActiveSounds) do
        pcall(function() sound:Stop(); sound:Destroy() end)
    end
    for _, Connection in ipairs(RuntimeState.Connections) do
        pcall(function() Connection:Disconnect() end)
    end
    RuntimeState.Connections = {}
    if RuntimeState.PrevCleanup then pcall(RuntimeState.PrevCleanup) end
end