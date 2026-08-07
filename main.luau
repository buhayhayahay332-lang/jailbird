local base = "https://raw.githubusercontent.com/buhayhayahay332-lang/jailbird/main/"

local ESP = loadstring(game:HttpGet(base .. "c_esp.luau"))()
loadstring(game:HttpGet(base .. "gun_mod.luau"))()
loadstring(game:HttpGet(base .. "local_player.luau"))()
loadstring(game:HttpGet(base .. "silent.luau"))()
loadstring(game:HttpGet(base .. "unlock_all.luau"))()
loadstring(game:HttpGet(base .. "aimbot.luau"))()
loadstring(game:HttpGet(base .. "triggerbot.luau"))()
loadstring(game:HttpGet(base .. "knifebot.luau"))()
loadstring(game:HttpGet(base .. "combat.luau"))()

local SkinSettings = getgenv().SkinSettings or {
    Enabled = false,
    WeaponSkin = "Crystalline",
    AttachmentSkin = "Gold",
    AttachmentsEnabled = false,
    Attachments = {
        Sight  = "",
        Grip   = "",
        Muzzle = "",
        Charm  = "",
        Extra  = "",
    },
    KnifeEnabled = false,
    Knife = "Bayonet",
}
getgenv().SkinSettings = SkinSettings
local SilentAimSettings = getgenv().SilentAimSettings
local GunModSettings = getgenv().GunModSettings
local LocalPlayerSettings = getgenv().LocalPlayerSettings
local RadarSettings     = getgenv().RadarSettings
local AimbotSettings    = getgenv().AimbotSettings
local TriggerbotSettings = getgenv().TriggerbotSettings
local KnifebotSettings  = getgenv().KnifebotSettings
local CombatSettings    = getgenv().CombatSettings
local CombatHitSounds   = getgenv().CombatHitSounds or {}
local CombatKillSounds  = getgenv().CombatKillSounds or {}


local repo         = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
getgenv().Library = Library
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()


local replicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local weaponSkinList = {}
local attachSkinList = {}
local sightList   = { "None" }
local gripList    = { "None" }
local muzzleList  = { "None" }
local charmList   = { "None" }
local extraList   = { "None" }
local knifeList   = {}

for _, skin in ipairs(replicatedStorage.Items.Skin:GetChildren()) do
    table.insert(weaponSkinList, skin.Name)
end

for _, skin in ipairs(replicatedStorage.Items.AttachmentSkin:GetChildren()) do
    table.insert(attachSkinList, skin.Name)
end

if replicatedStorage.Items:FindFirstChild("Sight") then
    for _, item in ipairs(replicatedStorage.Items.Sight:GetChildren()) do
        table.insert(sightList, item.Name)
    end
end
if replicatedStorage.Items:FindFirstChild("Grip") then
    for _, item in ipairs(replicatedStorage.Items.Grip:GetChildren()) do
        table.insert(gripList, item.Name)
    end
end
if replicatedStorage.Items:FindFirstChild("Muzzle") then
    for _, item in ipairs(replicatedStorage.Items.Muzzle:GetChildren()) do
        table.insert(muzzleList, item.Name)
    end
end
if replicatedStorage.Items:FindFirstChild("Charm") then
    for _, item in ipairs(replicatedStorage.Items.Charm:GetChildren()) do
        table.insert(charmList, item.Name)
    end
end
if replicatedStorage.Items:FindFirstChild("Extra") then
    for _, item in ipairs(replicatedStorage.Items.Extra:GetChildren()) do
        table.insert(extraList, item.Name)
    end
end
if replicatedStorage.Items:FindFirstChild("Knife") then
    for _, item in ipairs(replicatedStorage.Items.Knife:GetChildren()) do
        table.insert(knifeList, item.Name)
    end
end

table.sort(weaponSkinList)
table.sort(attachSkinList)
table.sort(sightList)
table.sort(gripList)
table.sort(muzzleList)
table.sort(charmList)
table.sort(extraList)
table.sort(knifeList)

local Options = Library.Options
local Toggles = Library.Toggles

-- WINDOW

local Window = Library:CreateWindow({
    Title            = "jailbird",
    Footer           = " + ",
    ShowCustomCursor = true,
    NotifySide       = "Right",
    AutoShow         = true,
})

-- TABS

local Tabs = {
    SilentAim   = Window:AddTab("Silent Aim", "crosshair"),
    Visuals     = Window:AddTab("Visuals",    "eye"),
    GunMod      = Window:AddTab("Gun Mod",    "sliders-horizontal"),
    Skins      = Window:AddTab("Skins", "cog"),
    LocalPlayer = Window:AddTab("Local Player", "user"),
    Spoofer     = Window:AddTab("Spoofer",    "user-check"),
    Settings    = Window:AddTab("Settings",   "settings"),
}

-- SILENT AIM TAB

-- LEFT COLUMN
local SAMainGroup = Tabs.SilentAim:AddLeftGroupbox("Silent Aim", "crosshair")

SAMainGroup:AddToggle("SAEnabled", {
    Text     = "Enable Silent Aim",
    Default  = SilentAimSettings.Enabled,
    Callback = function(v)
        SilentAimSettings.Enabled = v
    end,
})

SAMainGroup:AddToggle("SATeamCheck", {
    Text     = "Team Check",
    Default  = SilentAimSettings.TeamCheck,
    Callback = function(v)
        SilentAimSettings.TeamCheck = v
    end,
})

SAMainGroup:AddToggle("SAVisibleCheck", {
    Text     = "Visible Check",
    Default  = SilentAimSettings.VisibleCheck,
    Callback = function(v)
        SilentAimSettings.VisibleCheck = v
    end,
})

SAMainGroup:AddDivider()

SAMainGroup:AddDropdown("SATargetPart", {
    Text     = "Target Part",
    Values   = { "Head", "HumanoidRootPart", "Random" },
    Default  = SilentAimSettings.TargetPart,
    Callback = function(v)
        SilentAimSettings.TargetPart = v
    end,
})

SAMainGroup:AddDivider()

SAMainGroup:AddSlider("SAHitChance", {
    Text     = "Hit Chance",
    Default  = SilentAimSettings.HitChance,
    Min      = 1,
    Max      = 100,
    Rounding = 0,
    Suffix   = "%",
    Callback = function(v)
        SilentAimSettings.HitChance = v
    end,
})

SAMainGroup:AddDivider()

SAMainGroup:AddLabel("Toggle Key"):AddKeyPicker("SAToggleKey", {
    Default  = SilentAimSettings.ToggleKey,
    NoUI     = true,
    Text     = "Silent Aim Toggle",
    Callback = function(v)
        SilentAimSettings.ToggleKey = v
    end,
})

SAMainGroup:AddDivider()

local KnifebotGroup = Tabs.SilentAim:AddLeftGroupbox("Knifebot", "scissors")

KnifebotGroup:AddToggle("KnifebotEnabled", {
    Text     = "Enable Knifebot",
    Default  = KnifebotSettings.Enabled,
    Callback = function(v)
        KnifebotSettings.Enabled = v
    end,
})

local AimbotGroup = Tabs.SilentAim:AddLeftGroupbox("Aimbot", "crosshair")

AimbotGroup:AddToggle("AimbotEnabled", {
    Text     = "Enable Aimbot",
    Default  = AimbotSettings.Enabled,
    Callback = function(v)
        AimbotSettings.Enabled = v
    end,
})

AimbotGroup:AddDropdown("AimbotMode", {
    Text     = "Mode",
    Values   = { "Hold", "Toggle", "Always" },
    Default  = AimbotSettings.Mode,
    Callback = function(v)
        AimbotSettings.Mode = v
    end,
})

AimbotGroup:AddLabel("Key"):AddKeyPicker("AimbotKey", {
    Default  = AimbotSettings.Key,
    NoUI     = true,
    Text     = "Aimbot Key",
    Callback = function(v)
        AimbotSettings.Key = v
    end,
})

AimbotGroup:AddDivider()

AimbotGroup:AddDropdown("AimbotTargetPart", {
    Text     = "Target Part",
    Values   = { "Head", "HumanoidRootPart", "UpperTorso" },
    Default  = AimbotSettings.TargetPart,
    Callback = function(v)
        AimbotSettings.TargetPart = v
    end,
})

AimbotGroup:AddDropdown("AimbotPriority", {
    Text     = "Target Priority",
    Values   = { "Closest to Crosshair", "Lowest Health", "Closest Distance" },
    Default  = AimbotSettings.Priority,
    Callback = function(v)
        AimbotSettings.Priority = v
    end,
})

AimbotGroup:AddToggle("AimbotTeamCheck", {
    Text     = "Team Check",
    Default  = AimbotSettings.TeamCheck,
    Callback = function(v)
        AimbotSettings.TeamCheck = v
    end,
})

AimbotGroup:AddToggle("AimbotWallCheck", {
    Text     = "Wall Check",
    Default  = AimbotSettings.WallCheck,
    Callback = function(v)
        AimbotSettings.WallCheck = v
    end,
})

AimbotGroup:AddDivider()

AimbotGroup:AddSlider("AimbotSharedFOV", {
    Text     = "FOV (Shared Circle)",
    Default  = SilentAimSettings.FOVRadius,
    Min      = 10,
    Max      = 500,
    Rounding = 0,
    Suffix   = "px",
    Callback = function(v)
        SilentAimSettings.FOVRadius = v
    end,
})

AimbotGroup:AddSlider("AimbotSmoothing", {
    Text     = "Smoothing",
    Default  = math.floor(AimbotSettings.Smoothing * 100),
    Min      = 0,
    Max      = 95,
    Rounding = 0,
    Suffix   = "%",
    Callback = function(v)
        AimbotSettings.Smoothing = v / 100
    end,
})

local TriggerbotGroup = Tabs.SilentAim:AddLeftGroupbox("Triggerbot", "zap")

TriggerbotGroup:AddToggle("TriggerbotEnabled", {
    Text     = "Enable Triggerbot",
    Default  = TriggerbotSettings.Enabled,
    Callback = function(v)
        TriggerbotSettings.Enabled = v
    end,
})

TriggerbotGroup:AddToggle("TriggerbotTeamCheck", {
    Text     = "Team Check",
    Default  = TriggerbotSettings.TeamCheck,
    Callback = function(v)
        TriggerbotSettings.TeamCheck = v
    end,
})

TriggerbotGroup:AddToggle("TriggerbotVisibleCheck", {
    Text     = "Visible Check",
    Default  = TriggerbotSettings.VisibleCheck,
    Callback = function(v)
        TriggerbotSettings.VisibleCheck = v
    end,
})

TriggerbotGroup:AddDivider()

TriggerbotGroup:AddSlider("TriggerbotDelay", {
    Text     = "Shoot Delay",
    Default  = math.floor(TriggerbotSettings.Delay * 100),
    Min      = 1,
    Max      = 100,
    Rounding = 0,
    Suffix   = "ms",
    Callback = function(v)
        TriggerbotSettings.Delay = v / 100
    end,
})

-- RIGHT COLUMN
local SAFOVGroup = Tabs.SilentAim:AddRightGroupbox("FOV", "circle")

SAFOVGroup:AddSlider("SAFOVRadius", {
    Text     = "FOV Radius",
    Default  = SilentAimSettings.FOVRadius,
    Min      = 10,
    Max      = 500,
    Rounding = 0,
    Suffix   = "px",
    Callback = function(v)
        SilentAimSettings.FOVRadius = v
    end,
})

SAFOVGroup:AddToggle("SAFOVVisible", {
    Text     = "Show FOV Circle",
    Default  = SilentAimSettings.FOVVisible,
    Callback = function(v)
        SilentAimSettings.FOVVisible = v
    end,
})

local HitmarkerGroup = Tabs.SilentAim:AddRightGroupbox("Hitmarker", "crosshair")

HitmarkerGroup:AddToggle("HitmarkerEnabled", {
    Text     = "Enable Hitmarker",
    Default  = CombatSettings.Hitmarker.Enabled,
    Callback = function(v)
        CombatSettings.Hitmarker.Enabled = v
    end,
})

HitmarkerGroup:AddToggle("HitIndicator", {
    Text     = "Hit Indicator",
    Default  = CombatSettings.HitIndicator.Enabled,
    Callback = function(v)
        CombatSettings.HitIndicator.Enabled = v
    end,
})

HitmarkerGroup:AddSlider("HitmarkerDuration", {
    Text     = "Duration",
    Default  = math.floor(CombatSettings.Hitmarker.Duration * 100),
    Min      = 10,
    Max      = 200,
    Rounding = 0,
    Suffix   = "ms",
    Callback = function(v)
        CombatSettings.Hitmarker.Duration = v / 100
    end,
})

HitmarkerGroup:AddLabel("Hit Color"):AddColorPicker("HitmarkerColor", {
    Default  = CombatSettings.Hitmarker.Color,
    Callback = function(v)
        CombatSettings.Hitmarker.Color = v
    end,
})

HitmarkerGroup:AddLabel("Kill Color"):AddColorPicker("HitmarkerKillColor", {
    Default  = CombatSettings.Hitmarker.KillColor,
    Callback = function(v)
        CombatSettings.Hitmarker.KillColor = v
    end,
})

HitmarkerGroup:AddDivider()

HitmarkerGroup:AddToggle("HitNotify", {
    Text     = "Hit Log",
    Default  = CombatSettings.NotifyEnabled,
    Callback = function(v)
        CombatSettings.NotifyEnabled = v
    end,
})

HitmarkerGroup:AddSlider("HitNotifyDuration", {
    Text     = "Notify Duration",
    Default  = CombatSettings.NotifyDuration,
    Min      = 1,
    Max      = 10,
    Rounding = 0,
    Suffix   = "s",
    Callback = function(v)
        CombatSettings.NotifyDuration = v
    end,
})

local SoundGroup = Tabs.SilentAim:AddRightGroupbox("Hit Sounds", "volume-2")

SoundGroup:AddToggle("HitSoundsEnabled", {
    Text     = "Enable Hit Sounds",
    Default  = CombatSettings.Sounds.HitEnabled,
    Callback = function(v)
        CombatSettings.Sounds.HitEnabled = v
    end,
})

SoundGroup:AddDropdown("HitSound", {
    Text     = "Hit Sound",
    Values   = CombatHitSounds,
    Default  = CombatSettings.Sounds.HitSound,
    Callback = function(v)
        CombatSettings.Sounds.HitSound = v
    end,
})

SoundGroup:AddSlider("HitSoundVolume", {
    Text     = "Hit Volume",
    Default  = math.floor(CombatSettings.Sounds.HitVolume * 100),
    Min      = 0,
    Max      = 100,
    Rounding = 0,
    Suffix   = "%",
    Callback = function(v)
        CombatSettings.Sounds.HitVolume = v / 100
    end,
})

SoundGroup:AddButton({
    Text = "Test Hit Sound",
    Func = function()
        pcall(function()
            local sounds = CombatSettings.Sounds
            if sounds.HitEnabled then
                local ids = getgenv().CombatSoundIds or {}
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://" .. (ids[sounds.HitSound] or "")
                sound.Volume  = sounds.HitVolume
                sound.Parent  = workspace.CurrentCamera
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 3)
            end
        end)
    end,
})

SoundGroup:AddDivider()

SoundGroup:AddToggle("KillSoundsEnabled", {
    Text     = "Enable Kill Sounds",
    Default  = CombatSettings.Sounds.KillEnabled,
    Callback = function(v)
        CombatSettings.Sounds.KillEnabled = v
    end,
})

SoundGroup:AddDropdown("KillSound", {
    Text     = "Kill Sound",
    Values   = CombatKillSounds,
    Default  = CombatSettings.Sounds.KillSound,
    Callback = function(v)
        CombatSettings.Sounds.KillSound = v
    end,
})

SoundGroup:AddSlider("KillSoundVolume", {
    Text     = "Kill Volume",
    Default  = math.floor(CombatSettings.Sounds.KillVolume * 100),
    Min      = 0,
    Max      = 100,
    Rounding = 0,
    Suffix   = "%",
    Callback = function(v)
        CombatSettings.Sounds.KillVolume = v / 100
    end,
})

SoundGroup:AddButton({
    Text = "Test Kill Sound",
    Func = function()
        pcall(function()
            local sounds = CombatSettings.Sounds
            if sounds.KillEnabled then
                local ids = getgenv().CombatSoundIds or {}
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://" .. (ids[sounds.KillSound] or "")
                sound.Volume  = sounds.KillVolume
                sound.Parent  = workspace.CurrentCamera
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 3)
            end
        end)
    end,
})


-- GUN MOD TAB

local GunModGroup = Tabs.GunMod:AddLeftGroupbox("Gun Mod", "sliders-horizontal")

GunModGroup:AddToggle("GunModEnabled", {
    Text     = "Enable Gun Mod",
    Default  = GunModSettings.Enabled,
    Callback = function(v)
        GunModSettings.Enabled = v
    end,
})

GunModGroup:AddToggle("GunModNoRecoil", {
    Text     = "No Recoil",
    Default  = GunModSettings.NoRecoil,
    Callback = function(v)
        GunModSettings.NoRecoil = v
    end,
})

GunModGroup:AddToggle("GunModNoSpread", {
    Text     = "No Spread",
    Default  = GunModSettings.NoSpread,
    Callback = function(v)
        GunModSettings.NoSpread = v
    end,
})

GunModGroup:AddToggle("GunModFasterFire", {
    Text     = "Faster Fire",
    Default  = GunModSettings.FasterFire,
    Callback = function(v)
        GunModSettings.FasterFire = v
    end,
})

GunModGroup:AddSlider("GunModFireRateMultiplier", {
    Text     = "Fire Rate Multiplier",
    Default  = GunModSettings.FireRateMultiplier,
    Min      = 1,
    Max      = 5,
    Rounding = 1,
    Callback = function(v)
        GunModSettings.FireRateMultiplier = v
    end,
})


-- LOCAL PLAYER TAB

local MovementGroup = Tabs.LocalPlayer:AddLeftGroupbox("Movement", "move")

MovementGroup:AddToggle("LPWalkSpeedEnabled", {
    Text     = "Enable Walk Speed",
    Default  = LocalPlayerSettings.WalkSpeedEnabled,
    Callback = function(v)
        LocalPlayerSettings.WalkSpeedEnabled = v
    end,
})

MovementGroup:AddSlider("LPWalkSpeed", {
    Text     = "Walk Speed",
    Default  = LocalPlayerSettings.WalkSpeed,
    Min      = 16,
    Max      = 120,
    Rounding = 0,
    Callback = function(v)
        LocalPlayerSettings.WalkSpeed = v
    end,
})

MovementGroup:AddDivider()

MovementGroup:AddToggle("LPPhaseEnabled", {
    Text     = "Phase Through Walls",
    Default  = LocalPlayerSettings.PhaseEnabled,
    Callback = function(v)
        LocalPlayerSettings.PhaseEnabled = v
    end,
})

local FlyGroup = Tabs.LocalPlayer:AddRightGroupbox("Fly", "plane")

FlyGroup:AddToggle("LPFlyEnabled", {
    Text     = "Enable Fly",
    Default  = LocalPlayerSettings.FlyEnabled,
    Callback = function(v)
        LocalPlayerSettings.FlyEnabled = v
    end,
})

FlyGroup:AddSlider("LPFlySpeed", {
    Text     = "Fly Speed",
    Default  = LocalPlayerSettings.FlySpeed,
    Min      = 10,
    Max      = 200,
    Rounding = 0,
    Callback = function(v)
        LocalPlayerSettings.FlySpeed = v
    end,
})

local DeviceGroup = Tabs.LocalPlayer:AddRightGroupbox("Device Spoofer", "smartphone")

local deviceSpoofCurrent = "Computer"

DeviceGroup:AddDropdown("DeviceSpoof", {
    Values   = { "Computer", "Mobile", "Console" },
    Default  = "Computer",
    Text     = "Device Spoofer",
    Callback = function(v)
        deviceSpoofCurrent = v
        pcall(function()
            local gameEvents = replicatedStorage:FindFirstChild("GameEvents")
            local deviceEvent = gameEvents and gameEvents:FindFirstChild("DeviceUpdate")
            if deviceEvent then deviceEvent:FireServer(deviceSpoofCurrent) end
        end)
    end,
})

local SpoofPlayer2 = game:GetService("Players").LocalPlayer
SpoofPlayer2.CharacterAdded:Connect(function()
    task.wait(0.3)
    pcall(function()
        local gameEvents = replicatedStorage:FindFirstChild("GameEvents")
        local deviceEvent = gameEvents and gameEvents:FindFirstChild("DeviceUpdate")
        if deviceEvent then deviceEvent:FireServer(deviceSpoofCurrent) end
    end)
end)

local PromoGroup = Tabs.LocalPlayer:AddRightGroupbox("Promo Codes", "gift")

local promocodes = {
    "JAILBIRDELITE",
    "FIRSTPERSONPOSTUPDATE1",
    "FIRSTPERSON",
    "NEWGUNSOUNDS",
    "JAILBIRDIANS",
    "SMILEYOVERHAUL",
    "80KLIKESJAILBIRD",
    "MADDERS",
    "MIRAGON",
    "SERVERFIX",
    "S5RELEASE",
    "OPTIMISATION",
    "DEV_CONSOLE",
    "JAILBIRDSTARTER",
    "REMASTERED",
    "JAILBIRD",
    "MADDERSYT",
    "CHIVVEDYT",
}

PromoGroup:AddButton({
    Text = "Claim All Codes",
    Func = function()
        task.spawn(function()
            local claimEvent = replicatedStorage:FindFirstChild("Events") and replicatedStorage.Events:FindFirstChild("ClaimPromocode")
            if not claimEvent then
                Library:Notify({ Title = "Promo Codes", Description = "Claim event not found!", Time = 2 })
                return
            end
            local claimed = 0
            for _, code in ipairs(promocodes) do
                pcall(function()
                    claimEvent:FireServer(code)
                    claimed = claimed + 1
                end)
                task.wait(0.2)
            end
            Library:Notify({ Title = "Promo Codes", Description = "Claimed " .. claimed .. "/" .. #promocodes .. " codes!", Time = 5 })
        end)
    end,
    Tooltip = "Fires the ClaimPromocode event for every known Jailbird code",
})

-- SKINS TAB


local SkinGroup = Tabs.Skins:AddLeftGroupbox("Weapon Skin", "cog")

SkinGroup:AddToggle("SkinEnabled", {
    Text     = "Enable Skin Changer",
    Default  = SkinSettings.Enabled,
    Callback = function(v)
        SkinSettings.Enabled = v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

SkinGroup:AddDivider()

SkinGroup:AddDropdown("WeaponSkinDropdown", {
    Text     = "Weapon Skin",
    Values   = weaponSkinList,
    Default  = SkinSettings.WeaponSkin,
    Callback = function(v)
        SkinSettings.WeaponSkin = v
        Library:Notify({ Title = "Skins", Description = "Weapon skin set to: " .. v, Time = 2 })
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

SkinGroup:AddDivider()

SkinGroup:AddButton({
    Text = "Apply Now",
    Func = function()
        local localPlayer = game:GetService("Players").LocalPlayer
        local ok, componentsWeapon = pcall(require, replicatedStorage.Components.Weapon)
        if not ok or not componentsWeapon then
            Library:Notify({ Title = "Skins", Description = "Failed to apply skin!", Time = 2 })
            return
        end

        local character = localPlayer.Character
        if not character then return end

        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, child in ipairs(tool:GetChildren()) do
                    if child:IsA("Model") then
                        pcall(componentsWeapon.SetSkinOnWep, child, SkinSettings.WeaponSkin)
                    end
                end
            end
        end

        Library:Notify({ Title = "Skins", Description = "Skin applied!", Time = 2 })
    end,
    Tooltip = "Force apply skin to current weapon",
})

local AttachGroup = Tabs.Skins:AddRightGroupbox("Attachment Skin", "layers")

AttachGroup:AddDropdown("AttachSkinDropdown", {
    Text     = "Attachment Skin",
    Values   = attachSkinList,
    Default  = SkinSettings.AttachmentSkin,
    Callback = function(v)
        SkinSettings.AttachmentSkin = v
        Library:Notify({ Title = "Skins", Description = "Attachment skin set to: " .. v, Time = 2 })
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

local AttachmentGroup = Tabs.Skins:AddRightGroupbox("Physical Attachments", "wrench")

AttachmentGroup:AddToggle("AttachmentsEnabled", {
    Text     = "Enable Attachments",
    Default  = SkinSettings.AttachmentsEnabled,
    Callback = function(v)
        SkinSettings.AttachmentsEnabled = v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

AttachmentGroup:AddDropdown("SightDropdown", {
    Text     = "Sight",
    Values   = sightList,
    Default  = SkinSettings.Attachments.Sight ~= "" and SkinSettings.Attachments.Sight or "None",
    Callback = function(v)
        SkinSettings.Attachments.Sight = v == "None" and "" or v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

AttachmentGroup:AddDropdown("GripDropdown", {
    Text     = "Grip",
    Values   = gripList,
    Default  = SkinSettings.Attachments.Grip ~= "" and SkinSettings.Attachments.Grip or "None",
    Callback = function(v)
        SkinSettings.Attachments.Grip = v == "None" and "" or v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

AttachmentGroup:AddDropdown("MuzzleDropdown", {
    Text     = "Muzzle",
    Values   = muzzleList,
    Default  = SkinSettings.Attachments.Muzzle ~= "" and SkinSettings.Attachments.Muzzle or "None",
    Callback = function(v)
        SkinSettings.Attachments.Muzzle = v == "None" and "" or v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

AttachmentGroup:AddDropdown("ExtraDropdown", {
    Text     = "Extra",
    Values   = extraList,
    Default  = SkinSettings.Attachments.Extra ~= "" and SkinSettings.Attachments.Extra or "None",
    Callback = function(v)
        SkinSettings.Attachments.Extra = v == "None" and "" or v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

AttachmentGroup:AddDropdown("CharmDropdown", {
    Text     = "Charm",
    Values   = charmList,
    Default  = (SkinSettings.Attachments.Charm and SkinSettings.Attachments.Charm ~= "") and SkinSettings.Attachments.Charm or "None",
    Callback = function(v)
        SkinSettings.Attachments.Charm = v == "None" and "" or v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

local KnifeGroup = Tabs.Skins:AddLeftGroupbox("Knife", "scissors")

KnifeGroup:AddToggle("KnifeEnabled", {
    Text     = "Enable Knife Changer",
    Default  = SkinSettings.KnifeEnabled,
    Callback = function(v)
        SkinSettings.KnifeEnabled = v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

KnifeGroup:AddDropdown("KnifeDropdown", {
    Text     = "Knife",
    Values   = knifeList,
    Default  = SkinSettings.Knife,
    Callback = function(v)
        SkinSettings.Knife = v
        if SkinSettings.ApplyToCharacter then
            pcall(SkinSettings.ApplyToCharacter)
        end
    end,
})

-- VISUALS TAB 

-- LEFT COLUMN
local GeneralGroup = Tabs.Visuals:AddLeftGroupbox("ESP General", "sliders-horizontal")

GeneralGroup:AddToggle("ESPEnabled", {
    Text     = "Enable ESP",
    Default  = ESP.Enabled,
    Callback = function(v) ESP.Enabled = v end,
})

GeneralGroup:AddSlider("ESPMaxDistance", {
    Text     = "Max Distance",
    Default  = ESP.MaxDistance,
    Min      = 50,
    Max      = 2000,
    Rounding = 0,
    Suffix   = " studs",
    Callback = function(v) ESP.MaxDistance = v end,
})

GeneralGroup:AddSlider("ESPFontSize", {
    Text     = "Font Size",
    Default  = ESP.FontSize,
    Min      = 8,
    Max      = 24,
    Rounding = 0,
    Callback = function(v)
        ESP.FontSize = v
        ESP.RefreshESPs()
    end,
})

GeneralGroup:AddDivider()

GeneralGroup:AddToggle("ESPFadeOut", {
    Text     = "Fade Out On Distance",
    Default  = ESP.FadeOut.OnDistance,
    Callback = function(v) ESP.FadeOut.OnDistance = v end,
})

GeneralGroup:AddToggle("ESPTeamCheck", {
    Text     = "Team Check",
    Default  = ESP.Drawing.TeamCheck.Enabled,
    Callback = function(v) ESP.Drawing.TeamCheck.Enabled = v end,
})

local NamesGroup = Tabs.Visuals:AddLeftGroupbox("Names & Distances", "tag")

NamesGroup:AddToggle("ESPNames", {
    Text     = "Show Names",
    Default  = ESP.Drawing.Names.Enabled,
    Callback = function(v) ESP.Drawing.Names.Enabled = v end,
})

NamesGroup:AddLabel("Name Color"):AddColorPicker("ESPNamesColor", {
    Default  = ESP.Drawing.Names.RGB,
    Callback = function(v) ESP.Drawing.Names.RGB = v end,
})

NamesGroup:AddDivider()

NamesGroup:AddToggle("ESPDistances", {
    Text     = "Show Distances",
    Default  = ESP.Drawing.Distances.Enabled,
    Callback = function(v) ESP.Drawing.Distances.Enabled = v end,
})

NamesGroup:AddLabel("Distance Color"):AddColorPicker("ESPDistancesColor", {
    Default  = ESP.Drawing.Distances.RGB,
    Callback = function(v) ESP.Drawing.Distances.RGB = v end,
})

NamesGroup:AddDivider()

NamesGroup:AddToggle("ESPHealthBar", {
    Text     = "Health Bar",
    Default  = ESP.Drawing.HealthBar.Enabled,
    Callback = function(v) ESP.Drawing.HealthBar.Enabled = v end,
})

local BoxTypeGroup = Tabs.Visuals:AddLeftGroupbox("Box Types", "square")

BoxTypeGroup:AddToggle("BoxFull", {
    Text     = "Full Box",
    Default  = ESP.Drawing.Boxes.Full.Enabled,
    Callback = function(v) ESP.Drawing.Boxes.Full.Enabled = v end,
})

BoxTypeGroup:AddLabel("Full Box Color"):AddColorPicker("BoxFullColor", {
    Default  = ESP.Drawing.Boxes.Full.RGB,
    Callback = function(v) ESP.Drawing.Boxes.Full.RGB = v end,
})

BoxTypeGroup:AddDivider()

BoxTypeGroup:AddToggle("BoxFilled", {
    Text     = "Filled Box",
    Default  = ESP.Drawing.Boxes.Filled.Enabled,
    Callback = function(v) ESP.Drawing.Boxes.Filled.Enabled = v end,
})

BoxTypeGroup:AddSlider("BoxFilledTransparency", {
    Text     = "Fill Transparency",
    Default  = ESP.Drawing.Boxes.Filled.Transparency * 100,
    Min      = 0,
    Max      = 100,
    Rounding = 0,
    Suffix   = "%",
    Callback = function(v) ESP.Drawing.Boxes.Filled.Transparency = v / 100 end,
})

BoxTypeGroup:AddLabel("Filled Box Color"):AddColorPicker("BoxFilledColor", {
    Default  = ESP.Drawing.Boxes.Filled.RGB,
    Callback = function(v) ESP.Drawing.Boxes.Filled.RGB = v end,
})

BoxTypeGroup:AddDivider()

BoxTypeGroup:AddToggle("BoxGradient", {
    Text     = "Gradient Outline",
    Default  = ESP.Drawing.Boxes.Gradient,
    Callback = function(v)
        ESP.Drawing.Boxes.Gradient = v
        ESP.RefreshESPs()
    end,
})

BoxTypeGroup:AddLabel("Gradient Color 1"):AddColorPicker("BoxGradientColor1", {
    Default  = ESP.Drawing.Boxes.GradientRGB1,
    Callback = function(v) ESP.Drawing.Boxes.GradientRGB1 = v end,
})

BoxTypeGroup:AddLabel("Gradient Color 2"):AddColorPicker("BoxGradientColor2", {
    Default  = ESP.Drawing.Boxes.GradientRGB2,
    Callback = function(v) ESP.Drawing.Boxes.GradientRGB2 = v end,
})

BoxTypeGroup:AddDivider()

BoxTypeGroup:AddToggle("BoxGradientFill", {
    Text     = "Gradient Fill",
    Default  = ESP.Drawing.Boxes.GradientFill,
    Callback = function(v)
        ESP.Drawing.Boxes.GradientFill = v
        ESP.RefreshESPs()
    end,
})

BoxTypeGroup:AddLabel("Gradient Fill Color 1"):AddColorPicker("BoxGradientFillColor1", {
    Default  = ESP.Drawing.Boxes.GradientFillRGB1,
    Callback = function(v) ESP.Drawing.Boxes.GradientFillRGB1 = v end,
})

BoxTypeGroup:AddLabel("Gradient Fill Color 2"):AddColorPicker("BoxGradientFillColor2", {
    Default  = ESP.Drawing.Boxes.GradientFillRGB2,
    Callback = function(v) ESP.Drawing.Boxes.GradientFillRGB2 = v end,
})

local RadarGroup = Tabs.Visuals:AddLeftGroupbox("Radar", "radio")

RadarGroup:AddToggle("RadarEnabled", {
    Text     = "Enable Radar",
    Default  = RadarSettings.Enabled,
    Callback = function(v) RadarSettings.Enabled = v end,
})

RadarGroup:AddDivider()

RadarGroup:AddSlider("RadarRadius", {
    Text     = "Radar Radius",
    Default  = RadarSettings.Radius,
    Min      = 50,
    Max      = 300,
    Rounding = 0,
    Callback = function(v) RadarSettings.Radius = v end,
})

RadarGroup:AddSlider("RadarRange", {
    Text     = "Radar Range",
    Default  = RadarSettings.Range,
    Min      = 50,
    Max      = 1000,
    Rounding = 0,
    Suffix   = " studs",
    Callback = function(v) RadarSettings.Range = v end,
})

RadarGroup:AddSlider("RadarDotSize", {
    Text     = "Enemy Dot Size",
    Default  = RadarSettings.DotSize,
    Min      = 1,
    Max      = 10,
    Rounding = 0,
    Callback = function(v) RadarSettings.DotSize = v end,
})

RadarGroup:AddSlider("RadarSelfDotSize", {
    Text     = "Self Dot Size",
    Default  = RadarSettings.SelfDotSize,
    Min      = 1,
    Max      = 10,
    Rounding = 0,
    Callback = function(v) RadarSettings.SelfDotSize = v end,
})

-- RIGHT COLUMN
local ActionsGroup = Tabs.Visuals:AddRightGroupbox("ESP Actions", "zap")

ActionsGroup:AddButton({
    Text    = "Refresh ESP",
    Func    = function()
        ESP.RefreshESPs()
        Library:Notify({ Title = "jailbird", Description = "ESP Refreshed!", Time = 2 })
    end,
    Tooltip = "Re-creates all ESP overlays",
})

ActionsGroup:AddButton({
    Text    = "Clean All ESPs",
    Func    = function()
        ESP.CleanAllESPs()
        Library:Notify({ Title = "jailbird", Description = "Cleaned all ESPs!", Time = 2 })
    end,
    Tooltip = "Destroys all active ESP overlays",
})

local ChamsGroup = Tabs.Visuals:AddRightGroupbox("Chams", "layers")

ChamsGroup:AddToggle("ESPChams", {
    Text     = "Enable Chams",
    Default  = ESP.Drawing.Chams.Enabled,
    Callback = function(v) ESP.Drawing.Chams.Enabled = v end,
})

ChamsGroup:AddToggle("ESPChamsVisCheck", {
    Text     = "Visible Check",
    Default  = ESP.Drawing.Chams.VisibleCheck,
    Callback = function(v) ESP.Drawing.Chams.VisibleCheck = v end,
})

ChamsGroup:AddDivider()

ChamsGroup:AddLabel("Fill Color"):AddColorPicker("ESPChamsFill", {
    Default      = ESP.Drawing.Chams.FillRGB,
    Transparency = ESP.Drawing.Chams.Fill_Transparency / 100,
    Callback     = function(v) ESP.Drawing.Chams.FillRGB = v end,
})

Options.ESPChamsFill:OnChanged(function()
    if Options.ESPChamsFill.Transparency then
        ESP.Drawing.Chams.Fill_Transparency = Options.ESPChamsFill.Transparency * 100
    end
end)

ChamsGroup:AddLabel("Outline Color"):AddColorPicker("ESPChamsOutline", {
    Default      = ESP.Drawing.Chams.OutlineRGB,
    Transparency = ESP.Drawing.Chams.Outline_Transparency / 100,
    Callback     = function(v) ESP.Drawing.Chams.OutlineRGB = v end,
})

Options.ESPChamsOutline:OnChanged(function()
    if Options.ESPChamsOutline.Transparency then
        ESP.Drawing.Chams.Outline_Transparency = Options.ESPChamsOutline.Transparency * 100
    end
end)

local CornerGroup = Tabs.Visuals:AddRightGroupbox("Corner Box", "corner-down-right")

CornerGroup:AddToggle("BoxCorner", {
    Text     = "Corner Box",
    Default  = ESP.Drawing.Boxes.Corner.Enabled,
    Callback = function(v) ESP.Drawing.Boxes.Corner.Enabled = v end,
})

CornerGroup:AddSlider("BoxCornerThickness", {
    Text     = "Thickness",
    Default  = ESP.Drawing.Boxes.Corner.Thickness,
    Min      = 1,
    Max      = 5,
    Rounding = 0,
    Callback = function(v)
        ESP.SetCornerThickness(v)
        ESP.RefreshESPs()
    end,
})

CornerGroup:AddSlider("BoxCornerLength", {
    Text     = "Length",
    Default  = ESP.Drawing.Boxes.Corner.Length,
    Min      = 5,
    Max      = 50,
    Rounding = 0,
    Callback = function(v)
        ESP.SetCornerLength(v)
        ESP.RefreshESPs()
    end,
})

CornerGroup:AddLabel("Corner Color"):AddColorPicker("BoxCornerColor", {
    Default  = ESP.Drawing.Boxes.Corner.RGB,
    Callback = function(v) ESP.SetCornerColor(v) end,
})

local AnimGroup = Tabs.Visuals:AddRightGroupbox("Animation", "rotate-cw")

AnimGroup:AddToggle("BoxAnimate", {
    Text     = "Animate Gradient",
    Default  = ESP.Drawing.Boxes.Animate,
    Callback = function(v) ESP.Drawing.Boxes.Animate = v end,
})

AnimGroup:AddSlider("BoxRotationSpeed", {
    Text     = "Rotation Speed",
    Default  = ESP.Drawing.Boxes.RotationSpeed,
    Min      = 50,
    Max      = 1000,
    Rounding = 0,
    Callback = function(v) ESP.Drawing.Boxes.RotationSpeed = v end,
})

local RadarOptGroup = Tabs.Visuals:AddRightGroupbox("Radar Options", "settings-2")

RadarOptGroup:AddToggle("RadarRotate", {
    Text     = "Rotate With Camera",
    Default  = RadarSettings.Rotate,
    Callback = function(v) RadarSettings.Rotate = v end,
})

RadarOptGroup:AddToggle("RadarShowOffscreen", {
    Text     = "Show Offscreen Players",
    Default  = RadarSettings.ShowOffscreen,
    Callback = function(v) RadarSettings.ShowOffscreen = v end,
})

RadarOptGroup:AddDivider()

RadarOptGroup:AddSlider("RadarAnchorX", {
    Text     = "Anchor X",
    Default  = RadarSettings.Anchor.X,
    Min      = 50,
    Max      = 500,
    Rounding = 0,
    Callback = function(v)
        RadarSettings.Anchor = Vector2.new(v, RadarSettings.Anchor.Y)
    end,
})

RadarOptGroup:AddSlider("RadarAnchorY", {
    Text     = "Anchor Y",
    Default  = RadarSettings.Anchor.Y,
    Min      = 50,
    Max      = 500,
    Rounding = 0,
    Callback = function(v)
        RadarSettings.Anchor = Vector2.new(RadarSettings.Anchor.X, v)
    end,
})

-- SPOOFER TAB

local SpoofPlayer = game:GetService("Players").LocalPlayer
local spoofPlayerData = SpoofPlayer:FindFirstChild("PlayerData")
local spoofStats = spoofPlayerData and spoofPlayerData:FindFirstChild("Stats")

local originalSpoofName = SpoofPlayer.Name
local originalSpoofDisplay = SpoofPlayer.DisplayName

local SpoofStatsGroup = Tabs.Spoofer:AddLeftGroupbox("Stats", "chart-line")
local SpoofPlayerGroup = Tabs.Spoofer:AddRightGroupbox("Player", "user")

local function spoofStat(attribute, value)
    local number = tonumber(value)
    if number == nil then return end
    if spoofStats then
        pcall(function() spoofStats:SetAttribute(attribute, number) end)
    end
end

SpoofStatsGroup:AddInput("SpoofCredit", {
    Text        = "Credit",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Numeric     = true,
    Callback    = function(v) spoofStat("Credit", v) end,
})

SpoofStatsGroup:AddInput("SpoofLevel", {
    Text        = "Level",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Numeric     = true,
    Callback    = function(v) spoofStat("Level", v) end,
})

SpoofStatsGroup:AddInput("SpoofKills", {
    Text        = "Kills",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Numeric     = true,
    Callback    = function(v) spoofStat("Kills", v) end,
})

SpoofStatsGroup:AddInput("SpoofDeaths", {
    Text        = "Deaths",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Numeric     = true,
    Callback    = function(v) spoofStat("Deaths", v) end,
})

SpoofStatsGroup:AddInput("SpoofDamage", {
    Text        = "Damage",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Numeric     = true,
    Callback    = function(v) spoofStat("Damage", v) end,
})

SpoofStatsGroup:AddInput("SpoofRankedRating", {
    Text        = "Ranked Rating",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Numeric     = true,
    Callback    = function(v) spoofStat("RankedRating", v) end,
})

SpoofStatsGroup:AddInput("SpoofRankedKills", {
    Text        = "Ranked Kills",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Numeric     = true,
    Callback    = function(v) spoofStat("RankedKills", v) end,
})

SpoofStatsGroup:AddInput("SpoofRankedDeaths", {
    Text        = "Ranked Deaths",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Numeric     = true,
    Callback    = function(v) spoofStat("RankedDeaths", v) end,
})

SpoofStatsGroup:AddDivider()

SpoofStatsGroup:AddButton({
    Text = "Restore Stats",
    Func = function()
        if not spoofStats then
            Library:Notify({ Title = "Spoofer", Description = "Stats not found!", Time = 2 })
            return
        end
        pcall(function() spoofStats:SetAttribute("Credit",       nil) end)
        pcall(function() spoofStats:SetAttribute("Level",        nil) end)
        pcall(function() spoofStats:SetAttribute("Kills",        nil) end)
        pcall(function() spoofStats:SetAttribute("Deaths",       nil) end)
        pcall(function() spoofStats:SetAttribute("Damage",       nil) end)
        pcall(function() spoofStats:SetAttribute("RankedRating", nil) end)
        pcall(function() spoofStats:SetAttribute("RankedKills",  nil) end)
        pcall(function() spoofStats:SetAttribute("RankedDeaths", nil) end)
        Library:Notify({ Title = "Spoofer", Description = "Stats reset!", Time = 2 })
    end,
    Tooltip = "Removes all spoofed stat attributes",
})

SpoofPlayerGroup:AddInput("SpoofUsername", {
    Text        = "Username",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Callback    = function(v)
        if v ~= "" then
            pcall(function() SpoofPlayer.Name = v end)
        end
    end,
})

SpoofPlayerGroup:AddInput("SpoofDisplayName", {
    Text        = "Display Name",
    Placeholder = "Leave empty to keep",
    Default     = "",
    Callback    = function(v)
        if v ~= "" then
            pcall(function() SpoofPlayer.DisplayName = v end)
        end
    end,
})

SpoofPlayerGroup:AddDivider()

SpoofPlayerGroup:AddButton({
    Text = "Restore Original Name",
    Func = function()
        pcall(function() SpoofPlayer.Name        = originalSpoofName    end)
        pcall(function() SpoofPlayer.DisplayName = originalSpoofDisplay end)
        Library:Notify({ Title = "Spoofer", Description = "Name restored!", Time = 2 })
    end,
})

-- SETTINGS TAB

local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = true,
    Callback = function(v) Library.ShowCustomCursor = v end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(v) Library:SetNotifySide(v) end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default  = "100%",
    Text     = "DPI Scale",
    Callback = function(v)
        v = v:gsub("%%", "")
        Library:SetDPIScale(tonumber(v))
    end,
})

MenuGroup:AddDivider()

local staffEnabled = true
local staffDetectedUsers = {}

local staffWatchlist = {
    [128547037]  = "tester",
    [1089888905] = "tester",
    [4269359593] = "tester",
    [4621670832] = "tester",
    [411845421]  = "tester",
    [1066505679] = "tester",
    [550183999]  = "tester",
    [7032328813] = "tester",
    [7660433176] = "tester",
    [1932714775] = "tester",
    [644109069]  = "tester",
    [8300163915] = "tester",
    [1885942346] = "tester",
    [94409100]   = "moderator",
    [7017152868] = "moderator",
    [70838151]   = "moderator",
    [4323561112] = "moderator",
    [1474440307] = "moderator",
    [2469896978] = "moderator",
    [1475316060] = "developer",
    [22502596]   = "head admin",
    [544645921]  = "founder",
}

local function detectStaff(player)
    if not staffEnabled then return end
    if staffDetectedUsers[player.UserId] then return end
    local role = staffWatchlist[player.UserId]
    if role then
        staffDetectedUsers[player.UserId] = true
        Library:Notify({
            Title       = role .. " detected",
            Description = player.Name .. " | user id: " .. player.UserId,
            Time        = 10,
        })
    end
end

MenuGroup:AddToggle("StaffDetector", {
    Text     = "Staff Detector",
    Default  = true,
    Callback = function(v)
        staffEnabled = v
        if v then
            for id in pairs(staffDetectedUsers) do
                staffDetectedUsers[id] = nil
            end
            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                detectStaff(p)
            end
        end
    end,
})

for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
    detectStaff(p)
end
game:GetService("Players").PlayerAdded:Connect(detectStaff)

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu Bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI    = true,
    Text    = "Menu Keybind",
})

MenuGroup:AddButton({
    Text = "Unload",
    Func = function() Library:Unload() end,
})

Library.ToggleKeybind = Options.MenuKeybind

-- THEME & SAVE MANAGER

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("jailbird")
SaveManager:SetFolder("jailbird")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:LoadAutoloadConfig()
