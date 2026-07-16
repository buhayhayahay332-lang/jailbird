local base = "https://raw.githubusercontent.com/buhayhayahay332-lang/jailbird/main/"

local ESP = loadstring(game:HttpGet(base .. "c_esp.luau"))()
loadstring(game:HttpGet(base .. "gun_mod.luau"))()
loadstring(game:HttpGet(base .. "local_player.luau"))()
loadstring(game:HttpGet(base .. "silent.luau"))()
loadstring(game:HttpGet(base .. "unlock_all.luau"))()

local SkinSettings = getgenv().SkinSettings
local SilentAimSettings = getgenv().SilentAimSettings
local GunModSettings = getgenv().GunModSettings
local LocalPlayerSettings = getgenv().LocalPlayerSettings
local RadarSettings     = getgenv().RadarSettings
local AimAssistSettings = getgenv().AimAssistSettings

local repo         = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()


local replicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local weaponSkinList = {}
local attachSkinList = {}

for _, skin in ipairs(replicatedStorage.Items.Skin:GetChildren()) do
    table.insert(weaponSkinList, skin.Name)
end

for _, skin in ipairs(replicatedStorage.Items.AttachmentSkin:GetChildren()) do
    table.insert(attachSkinList, skin.Name)
end

table.sort(weaponSkinList)
table.sort(attachSkinList)

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
    Skins      = Window:AddTab("Skins", "cog")
    LocalPlayer = Window:AddTab("Local Player", "user"),
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

local SAAimAssistGroup = Tabs.SilentAim:AddLeftGroupbox("Aim Assist", "mouse-pointer")

SAAimAssistGroup:AddToggle("AimAssistEnabled", {
    Text     = "Enable Aim Assist",
    Default  = AimAssistSettings.Enabled,
    Callback = function(v)
        AimAssistSettings.Enabled = v
    end,
})

SAAimAssistGroup:AddSlider("AimAssistSmoothness", {
    Text     = "Smoothness",
    Default  = AimAssistSettings.Smoothness * 100,
    Min      = 1,
    Max      = 100,
    Rounding = 0,
    Suffix   = "%",
    Callback = function(v)
        AimAssistSettings.Smoothness = v / 100
    end,
})

SAAimAssistGroup:AddLabel("Hold Key"):AddKeyPicker("AimAssistKey", {
    Default  = AimAssistSettings.BindKey,
    NoUI     = true,
    Text     = "Aim Assist Key",
    Callback = function(v)
        AimAssistSettings.BindKey = v
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

SAFOVGroup:AddToggle("SAShowTarget", {
    Text     = "Show Target Indicator",
    Default  = SilentAimSettings.ShowSilentAimTarget,
    Callback = function(v)
        SilentAimSettings.ShowSilentAimTarget = v
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

GunModGroup:AddToggle("GunModVerbose", {
    Text     = "Verbose Logging",
    Default  = GunModSettings.Verbose,
    Callback = function(v)
        GunModSettings.Verbose = v
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

-- SKINS TAB


local SkinGroup = Tabs.Skins:AddLeftGroupbox("Weapon Skin", "cog")

SkinGroup:AddToggle("SkinEnabled", {
    Text     = "Enable Skin Changer",
    Default  = SkinSettings.Enabled,
    Callback = function(v)
        SkinSettings.Enabled = v
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
