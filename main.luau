local base = "https://raw.githubusercontent.com/buhayhayahay332-lang/jailbird/main/"

local ESP = loadstring(game:HttpGet(base .. "c_esp.luau"))()
loadstring(game:HttpGet(base .. "silent.luau"))()

local SilentAimSettings = getgenv().SilentAimSettings
local RadarSettings     = getgenv().RadarSettings
local AimAssistSettings = getgenv().AimAssistSettings

local repo         = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

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
    SilentAim = Window:AddTab("Silent Aim", "crosshair"),
    Visuals   = Window:AddTab("Visuals",    "eye"),
    Settings  = Window:AddTab("Settings",   "settings"),
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