if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local SilentAimSettings = {
    Enabled = false,
    ToggleKey = "RightAlt",
    
    TeamCheck = true,
    VisibleCheck = false, 
    TargetPart = "Head",
    SilentAimMethod = "Raycast",
    
    FOVRadius = 150,
    FOVVisible = true,
    ShowSilentAimTarget = true, 
    HitChance = 100
}

local AimAssistSettings = {
    Enabled = false,
    Smoothness = 0.15,
    BindKey = "MouseButton2"
}

-- variables
local Global = getgenv()
Global.SilentAimSettings = SilentAimSettings
Global.AimAssistSettings = AimAssistSettings
if Global.__test_lua_cleanup then
    pcall(Global.__test_lua_cleanup)
end

local RuntimeState = {
    Connections = {},
    Drawings = {}
}

Global.__test_lua_state = RuntimeState
Global.__test_lua_cleanup = function()
    for _, Connection in ipairs(RuntimeState.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    for _, DrawingObject in ipairs(RuntimeState.Drawings) do
        pcall(function()
            if typeof(DrawingObject) == "Instance" then
                DrawingObject:Destroy()
            else
                DrawingObject:Remove()
            end
        end)
    end
end

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer


local GetPlayers = Players.GetPlayers
local WorldToScreen = Camera.WorldToScreenPoint
local WorldToViewportPoint = Camera.WorldToViewportPoint
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local FindFirstChild = game.FindFirstChild
local RenderStepped = RunService.RenderStepped
local GetMouseLocation = UserInputService.GetMouseLocation

local CoreGui = (gethui and gethui()) or (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")

local ValidTargetParts = {"Head", "HumanoidRootPart"}

local fov_gui = Instance.new("ScreenGui")
fov_gui.Name = "FOVGui"
fov_gui.ResetOnSpawn = false
fov_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fov_gui.IgnoreGuiInset = true
fov_gui.Parent = CoreGui

local fov_frame = Instance.new("Frame")
fov_frame.Name = "FOVCircle"
fov_frame.BackgroundTransparency = 1
fov_frame.BorderSizePixel = 0
fov_frame.AnchorPoint = Vector2.new(0.5, 0.5)
fov_frame.Position = UDim2.fromScale(0.5, 0.5)
fov_frame.Visible = SilentAimSettings.FOVVisible
fov_frame.Parent = fov_gui

local ui_stroke = Instance.new("UIStroke")
ui_stroke.Color = Color3.fromRGB(0, 255, 0)
ui_stroke.Thickness = 1
ui_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ui_stroke.Parent = fov_frame

local ui_corner = Instance.new("UICorner")
ui_corner.CornerRadius = UDim.new(1, 0)
ui_corner.Parent = fov_frame

table.insert(RuntimeState.Drawings, fov_gui)

local mouse_box = Drawing.new("Square")
mouse_box.Visible = true 
mouse_box.ZIndex = 999 
mouse_box.Color = Color3.fromRGB(54, 57, 241)
mouse_box.Thickness = 20 
mouse_box.Size = Vector2.new(20, 20)
mouse_box.Filled = true 
mouse_box.Visible = SilentAimSettings.Enabled and SilentAimSettings.ShowSilentAimTarget
table.insert(RuntimeState.Drawings, mouse_box)


local RadarSettings = {
    Enabled = true,
    Radius = 110,
    Range = 300,
    Anchor = Vector2.new(170, 170),
    Rotate = true,
    ShowOffscreen = true,
    DotSize = 4,
    SelfDotSize = 5
}

Global.RadarSettings = RadarSettings

local radar_background = Drawing.new("Circle")
radar_background.Filled = true
radar_background.Thickness = 1
radar_background.NumSides = 100
radar_background.Radius = RadarSettings.Radius
radar_background.Color = Color3.fromRGB(18, 18, 22)
radar_background.Transparency = 0.72
radar_background.Visible = RadarSettings.Enabled
radar_background.ZIndex = 990
table.insert(RuntimeState.Drawings, radar_background)

local radar_outline = Drawing.new("Circle")
radar_outline.Filled = false
radar_outline.Thickness = 1
radar_outline.NumSides = 100
radar_outline.Radius = RadarSettings.Radius
radar_outline.Color = Color3.fromRGB(80, 80, 90)
radar_outline.Transparency = 1
radar_outline.Visible = RadarSettings.Enabled
radar_outline.ZIndex = 991
table.insert(RuntimeState.Drawings, radar_outline)

local radar_cross_h = Drawing.new("Line")
radar_cross_h.Color = Color3.fromRGB(70, 70, 80)
radar_cross_h.Thickness = 1
radar_cross_h.Transparency = 0.7
radar_cross_h.Visible = RadarSettings.Enabled
radar_cross_h.ZIndex = 991
table.insert(RuntimeState.Drawings, radar_cross_h)

local radar_cross_v = Drawing.new("Line")
radar_cross_v.Color = Color3.fromRGB(70, 70, 80)
radar_cross_v.Thickness = 1
radar_cross_v.Transparency = 0.7
radar_cross_v.Visible = RadarSettings.Enabled
radar_cross_v.ZIndex = 991
table.insert(RuntimeState.Drawings, radar_cross_v)

local radar_self = Drawing.new("Circle")
radar_self.Filled = true
radar_self.Thickness = 1
radar_self.NumSides = 100
radar_self.Radius = RadarSettings.SelfDotSize
radar_self.Color = Color3.fromRGB(245, 245, 245)
radar_self.Transparency = 1
radar_self.Visible = RadarSettings.Enabled
radar_self.ZIndex = 992
table.insert(RuntimeState.Drawings, radar_self)

local radar_dots = {}



function CalculateChance(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
    return chance <= Percentage / 100
end

local function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then
        return false
    end
    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then
            Matches = Matches + 1
        end
    end
    return Matches >= RayMethod.ArgCountRequired
end

local function getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end

local function getMousePosition()
    return GetMouseLocation(UserInputService)
end

local function isSilentAimEnabled()
    return SilentAimSettings.Enabled
end

local function isFovVisible()
    return SilentAimSettings.FOVVisible
end

local function isTargetVisible()
    return SilentAimSettings.ShowSilentAimTarget
end

local function getTargetPartName()
    return SilentAimSettings.TargetPart
end

local function getMethod()
    return SilentAimSettings.SilentAimMethod
end

local function syncVisualState()
    mouse_box.Visible = isSilentAimEnabled() and isTargetVisible()
    fov_frame.Visible = isFovVisible()
    fov_frame.Size = UDim2.fromOffset(SilentAimSettings.FOVRadius * 2, SilentAimSettings.FOVRadius * 2)
end

local function getCharacterRoot(character)
    if not character then
        return nil
    end

    return FindFirstChild(character, "HumanoidRootPart")
        or FindFirstChild(character, "UpperTorso")
        or FindFirstChild(character, "Torso")
end

local function getRadarDot(player)
    local dot = radar_dots[player]
    if dot then
        return dot
    end

    dot = Drawing.new("Circle")
    dot.Filled = true
    dot.Thickness = 1
    dot.NumSides = 100
    dot.Radius = RadarSettings.DotSize
    dot.Transparency = 1
    dot.Visible = false
    dot.ZIndex = 992
    radar_dots[player] = dot
    table.insert(RuntimeState.Drawings, dot)
    return dot
end

local function removeRadarDot(player)
    local dot = radar_dots[player]
    if not dot then
        return
    end

    radar_dots[player] = nil
    local drawIndex = table.find(RuntimeState.Drawings, dot)
    if drawIndex then
        table.remove(RuntimeState.Drawings, drawIndex)
    end
    pcall(function()
        dot:Remove()
    end)
end

table.insert(RuntimeState.Connections, Players.PlayerRemoving:Connect(removeRadarDot))

local function updateRadar()
    if not RadarSettings.Enabled then
        radar_background.Visible = false
        radar_outline.Visible = false
        radar_cross_h.Visible = false
        radar_cross_v.Visible = false
        radar_self.Visible = false

        for _, dot in pairs(radar_dots) do
            dot.Visible = false
        end
        return
    end

    local character = LocalPlayer.Character
    local root = getCharacterRoot(character)
    if not root then
        radar_background.Visible = false
        radar_outline.Visible = false
        radar_cross_h.Visible = false
        radar_cross_v.Visible = false
        radar_self.Visible = false

        for _, dot in pairs(radar_dots) do
            dot.Visible = false
        end
        return
    end

    local center = Vector2.new(RadarSettings.Anchor.X, Camera.ViewportSize.Y - RadarSettings.Anchor.Y)
    local radius = RadarSettings.Radius
    local look = Camera.CFrame.LookVector
    local yaw = math.atan2(look.X, look.Z)
    local sinYaw = math.sin(-yaw)
    local cosYaw = math.cos(-yaw)

    radar_background.Visible = true
    radar_outline.Visible = true
    radar_cross_h.Visible = true
    radar_cross_v.Visible = true
    radar_self.Visible = true

    radar_background.Position = center
    radar_background.Radius = radius
    radar_outline.Position = center
    radar_outline.Radius = radius
    radar_cross_h.From = Vector2.new(center.X - radius, center.Y)
    radar_cross_h.To = Vector2.new(center.X + radius, center.Y)
    radar_cross_v.From = Vector2.new(center.X, center.Y - radius)
    radar_cross_v.To = Vector2.new(center.X, center.Y + radius)
    radar_self.Position = center
    radar_self.Radius = RadarSettings.SelfDotSize

    local localTeam = LocalPlayer.Team
    local localPos = root.Position

    for _, player in ipairs(GetPlayers(Players)) do
        if player == LocalPlayer then
            continue
        end

        local dot = getRadarDot(player)
        local character = player.Character
        local targetRoot = getCharacterRoot(character)
        local humanoid = character and FindFirstChild(character, "Humanoid")

        if not character or not targetRoot or not humanoid or humanoid.Health <= 0 then
            dot.Visible = false
            continue
        end

        if SilentAimSettings.TeamCheck and localTeam and player.Team == localTeam then
            dot.Visible = false
            continue
        end

        local delta = targetRoot.Position - localPos
        local rel = Vector2.new(delta.X, -delta.Z)

        if RadarSettings.Rotate then
            rel = Vector2.new(
                rel.X * cosYaw - rel.Y * sinYaw,
                rel.X * sinYaw + rel.Y * cosYaw
            )
        end

        local dist = rel.Magnitude
        if dist <= 0 then
            dot.Visible = false
            continue
        end

        if dist > RadarSettings.Range then
            if not RadarSettings.ShowOffscreen then
                dot.Visible = false
                continue
            end

            rel = rel.Unit * RadarSettings.Range
        end

        local finalPos = center + (rel / RadarSettings.Range) * radius
        dot.Position = finalPos
        dot.Radius = RadarSettings.DotSize
        dot.Color = (player.Team and localTeam and player.Team == localTeam) and Color3.fromRGB(54, 57, 241)
            or Color3.fromRGB(255, 80, 80)
        dot.Transparency = (SilentAimSettings.VisibleCheck and not IsPlayerVisible(player)) and 0.35 or 1
        dot.Visible = true
    end
end

local function getToggleKeyCode()
    return Enum.KeyCode[SilentAimSettings.ToggleKey]
end

local function IsPlayerVisible(Player)
    local PlayerCharacter = Player.Character
    local LocalPlayerCharacter = LocalPlayer.Character
    
    if not PlayerCharacter or not LocalPlayerCharacter then return end 
    
    local PlayerRoot = FindFirstChild(PlayerCharacter, getTargetPartName()) or FindFirstChild(PlayerCharacter, "HumanoidRootPart")
    
    if not PlayerRoot then return end 
    
    local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = #GetPartsObscuringTarget(Camera, CastPoints, IgnoreList)
    
    return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end

local function getClosestPlayer()
    if not getTargetPartName() then return end
    local Closest
    local DistanceToMouse
    for _, Player in next, GetPlayers(Players) do
        if Player == LocalPlayer then continue end
        if SilentAimSettings.TeamCheck and Player.Team == LocalPlayer.Team then continue end

        local Character = Player.Character
        if not Character then continue end
        
        if SilentAimSettings.VisibleCheck and not IsPlayerVisible(Player) then continue end

        local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
        if not OnScreen then continue end

        local Distance = (Camera.ViewportSize / 2 - ScreenPosition).Magnitude
        if Distance <= (DistanceToMouse or SilentAimSettings.FOVRadius or 2000) then
            local targetPartName = getTargetPartName()
            if targetPartName == "Random" then
                Closest = Character[ValidTargetParts[math.random(1, #ValidTargetParts)]]
            else
                Closest = Character[targetPartName]
            end
            DistanceToMouse = Distance
        end
    end
    return Closest
end

syncVisualState()

local function isAimAssistHeld()
    if AimAssistSettings.BindKey == "MouseButton2" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end
    return UserInputService:IsKeyDown(Enum.KeyCode[AimAssistSettings.BindKey])
end

local function applyAimAssist(ClosestPart)
    if not ClosestPart then return end
    if not isAimAssistHeld() then return end

    local TargetPosition = ClosestPart.Position
    local CurrentCFrame = Camera.CFrame
    local TargetCFrame = CFrame.lookAt(CurrentCFrame.Position, TargetPosition)

    Camera.CFrame = CurrentCFrame:Lerp(TargetCFrame, AimAssistSettings.Smoothness)
end

table.insert(RuntimeState.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if Global.__test_lua_state ~= RuntimeState then return end
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    local toggleKey = getToggleKeyCode()
    if toggleKey and input.KeyCode == toggleKey then
        SilentAimSettings.Enabled = not SilentAimSettings.Enabled
        local Toggles = Global.Toggles or (Library and Library.Toggles)
        if Toggles and Toggles.SAEnabled then
            Toggles.SAEnabled:SetValue(SilentAimSettings.Enabled)
        else
            syncVisualState()
        end
    end
end))

coroutine.resume(coroutine.create(function()
    table.insert(RuntimeState.Connections, RenderStepped:Connect(function()
        if Global.__test_lua_state ~= RuntimeState then return end
        local ClosestPlayer = getClosestPlayer()

      if AimAssistSettings.Enabled then
            applyAimAssist(ClosestPlayer)
        end

        if isTargetVisible() and isSilentAimEnabled() then
            if ClosestPlayer then 
                local Root = ClosestPlayer.Parent.PrimaryPart or ClosestPlayer
                local RootToViewportPoint, IsOnScreen = WorldToViewportPoint(Camera, Root.Position)
                
                mouse_box.Visible = IsOnScreen
                mouse_box.Position = Vector2.new(RootToViewportPoint.X, RootToViewportPoint.Y)
            else 
                mouse_box.Visible = false 
                mouse_box.Position = Vector2.new()
            end
        else
            mouse_box.Visible = false
        end
        
        if isFovVisible() then 
            fov_frame.Visible = true
            fov_frame.Position = UDim2.fromScale(0.5, 0.5)
            fov_frame.Size = UDim2.fromOffset(SilentAimSettings.FOVRadius * 2, SilentAimSettings.FOVRadius * 2)
        else
            fov_frame.Visible = false
        end

        updateRadar()
    end))
end))

for _, Value in next, getgc(true) do
    if typeof(Value) == "function"
    and not isexecutorclosure(Value)
    and not iscclosure(Value)
    and islclosure(Value) then
        local Info = debug.getinfo(Value)
        if Info and Info.name == "BulletRayCast" then
            local Hook
            Hook = hookfunction(Value, newcclosure(function(...)
                if Global.__test_lua_state ~= RuntimeState then
                    return Hook(...)
                end

                if not isSilentAimEnabled() then
                    return Hook(...)
                end

                if not CalculateChance(SilentAimSettings.HitChance) then
                    return Hook(...)
                end

                local Args   = { ... }
                local Origin = Args[1]
                local HitPart = getClosestPlayer()

                if HitPart and Origin then
                    Args[2] = getDirection(Origin, HitPart.Position)
                end

                return Hook(table.unpack(Args))
            end))
        end
    end
end