 pcall(function() setthreadidentity(8) end)
pcall(function() game:GetService("WebViewService"):Destroy() end)

local cloneref = cloneref or function(o) return o end

local Workspace  = cloneref(game:GetService("Workspace"))
local RunService = cloneref(game:GetService("RunService"))
local Players    = cloneref(game:GetService("Players"))
local CoreGui    = cloneref(game:GetService("CoreGui"))
local GuiService = cloneref(game:GetService("GuiService"))

local LocalPlayer = Players.LocalPlayer

-- CONFIG
local ESP = {
    Enabled     = false,
    MaxDistance = 1000,
    FontSize    = 11,
    FadeOut = {
        OnDistance = false,
    },
    Drawing = {
        Chams = {
            Enabled              = false,
            FillRGB              = Color3.fromRGB(243, 116, 166),
            Fill_Transparency    = 50,
            OutlineRGB           = Color3.fromRGB(243, 116, 166),
            Outline_Transparency = 50,
            VisibleCheck         = false,
        },
        HealthBar = {
            Enabled = false,
        },
        Names = {
            Enabled = false,
            RGB     = Color3.fromRGB(255, 255, 255),
        },
        Distances = {
            Enabled = false,
            RGB     = Color3.fromRGB(255, 255, 255),
        },
        Boxes = {
            Animate          = false,
            RotationSpeed    = 300,
            Gradient         = true,
            GradientRGB1     = Color3.fromRGB(255, 255, 255),
            GradientRGB2     = Color3.fromRGB(0, 0, 0),
            GradientFill     = true,
            GradientFillRGB1 = Color3.fromRGB(255, 255, 255),
            GradientFillRGB2 = Color3.fromRGB(0, 0, 0),
            Filled = {
                Enabled      = false,
                Transparency = 0.75,
                RGB          = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = false,
                RGB     = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled   = false,
                RGB       = Color3.fromRGB(255, 255, 255),
                Thickness = 1,
                Length    = 15,
            },
        },
        TeamCheck = {
            Enabled = false,
        },
    },
}

-- STATE
local ESPCounter       = 0
local ActiveESPs       = {}   -- character model → espData
local PlayerConns      = {}   -- player → { charAdded, charRemoving } connections
local MasterConnection = nil

local _Camera    = nil
local _CamPos    = nil
local _ViewSize  = nil
local _Tick      = nil
local _GuiInsetY = 0
local ScreenGui  = nil

-- shared corners buffer
local _cb = {}
for i = 1, 8 do _cb[i] = Vector3.new() end

-- HELPERS
local function getRealPlayerFromCharacter(character)
    return Players:GetPlayerFromCharacter(character)
end

local function isRealCharacter(model)
    if not model or not model:IsA("Model") then return false end
    local player = Players:GetPlayerFromCharacter(model)
    if not player then return false end
    if player == LocalPlayer then return false end
    -- intentionally NO health check here — Humanoid.Health is briefly 0
    -- right at spawn and would cause the character to be permanently skipped.
    -- ProcessESP already hides the overlay when health == 0 each frame.
    local hum  = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    return true
end

-- PROJECTED BOUNDS (R6 + R15 compatible)
local function getProjectedModelBounds(model)
    if not model then return nil end

    local minX, minY =  math.huge,  math.huge
    local maxX, maxY = -math.huge, -math.huge
    local any = false

    local widthNames  = { "Torso", "UpperTorso", "LowerTorso", "Head" }
    local heightNames = {
        "Head",
        "Torso",       "UpperTorso",  "LowerTorso",
        "Left Leg",    "Right Leg",
        "LeftUpperLeg","RightUpperLeg",
        "LeftLowerLeg","RightLowerLeg",
        "LeftFoot",    "RightFoot",
    }

    local widthSet = {}
    for _, name in ipairs(widthNames) do
        local p = model:FindFirstChild(name)
        if p then widthSet[p] = true end
    end

    for _, name in ipairs(heightNames) do
        local d = model:FindFirstChild(name)
        if d and d:IsA("BasePart") and d.Transparency < 1 then
            local cf   = d.CFrame
            local half = d.Size * 0.5
            local hx, hy, hz = half.X, half.Y, half.Z
            local isW = widthSet[d]

            _cb[1] = cf * Vector3.new(-hx, -hy, -hz)
            _cb[2] = cf * Vector3.new(-hx, -hy,  hz)
            _cb[3] = cf * Vector3.new(-hx,  hy, -hz)
            _cb[4] = cf * Vector3.new(-hx,  hy,  hz)
            _cb[5] = cf * Vector3.new( hx, -hy, -hz)
            _cb[6] = cf * Vector3.new( hx, -hy,  hz)
            _cb[7] = cf * Vector3.new( hx,  hy, -hz)
            _cb[8] = cf * Vector3.new( hx,  hy,  hz)

            for i = 1, 8 do
                local p, on = _Camera:WorldToViewportPoint(_cb[i])
                if on and p.Z > 0 then
                    any = true
                    if p.Y < minY then minY = p.Y end
                    if p.Y > maxY then maxY = p.Y end
                    if isW then
                        if p.X < minX then minX = p.X end
                        if p.X > maxX then maxX = p.X end
                    end
                end
            end
        end
    end

    -- fallback to HumanoidRootPart if no parts found
    if minX == math.huge or maxX == -math.huge then
        local root = model:FindFirstChild("HumanoidRootPart")
        if root and root:IsA("BasePart") then
            local p, on = _Camera:WorldToViewportPoint(root.Position)
            if on and p.Z > 0 then
                minX = p.X - 10
                maxX = p.X + 10
            end
        end
    end

    if not any then return nil end
    return minX, minY, maxX, maxY
end

-- FUNCTIONS UTILITY
local Functions = {}

function Functions:Create(Class, Properties)
    local inst = typeof(Class) == "string" and Instance.new(Class) or Class
    for k, v in pairs(Properties) do inst[k] = v end
    return inst
end

-- PROCESS ESP (character-based)
local function ProcessESP(character, espData)
    local el = espData.elements

    local function Hide()
        el.Box.Visible         = false
        el.Name.Visible        = false
        el.Chams.Enabled       = false
        el.HealthBarBG.Visible = false
        el.LTH.Visible = false; el.LTV.Visible = false
        el.RTH.Visible = false; el.RTV.Visible = false
        el.LBH.Visible = false; el.LBV.Visible = false
        el.RBH.Visible = false; el.RBV.Visible = false
    end

    if not ESP.Enabled then Hide() return end

    if not character or not character.Parent then
        task.defer(function()
            if espData.folder then espData.folder:Destroy() end
            ActiveESPs[character] = nil
        end)
        return
    end

    local player = getRealPlayerFromCharacter(character)
    if not player then Hide() return end

if ESP.Drawing.TeamCheck.Enabled then
    local player = getRealPlayerFromCharacter(character)
    if player and player.Team == LocalPlayer.Team and player.Team ~= nil then
        Hide() return
    end
end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then Hide() return end

    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then Hide() return end

    local Pos, OnScreen = _Camera:WorldToViewportPoint(root.Position)
    local Dist = (_CamPos - root.Position).Magnitude
    if not OnScreen or Dist > ESP.MaxDistance then Hide() return end

    local yInset = _GuiInsetY

    -- fade
    if ESP.FadeOut.OnDistance then
        local fade = math.max(0.1, 1 - (Dist / ESP.MaxDistance))
        local inv  = 1 - fade
        el.Outline.Transparency       = inv
        el.Name.TextTransparency      = inv
        el.LTH.BackgroundTransparency = inv; el.LTV.BackgroundTransparency = inv
        el.RTH.BackgroundTransparency = inv; el.RTV.BackgroundTransparency = inv
        el.LBH.BackgroundTransparency = inv; el.LBV.BackgroundTransparency = inv
        el.RBH.BackgroundTransparency = inv; el.RBV.BackgroundTransparency = inv
    end

    -- bounds
    local x0, y0, x1, y1 = getProjectedModelBounds(character)
    if not x0 then
        local scaleFactor = (3.5 * _ViewSize.Y) / (Pos.Z * 2)
        local fw = 2.5  * scaleFactor
        local fh = 4.75 * scaleFactor
        x0, y0 = Pos.X - fw * 0.5, Pos.Y - fh * 0.5
        x1, y1 = Pos.X + fw * 0.5, Pos.Y + fh * 0.5
    end
    local w = math.max(2, x1 - x0)
    local h = math.max(2, y1 - y0)
    local padX = math.max(2, w * 0.15)
    local padY = math.max(2, h * 0.07)
    x0 = x0 - padX; x1 = x1 + padX
    y0 = y0 - padY; y1 = y1 + padY
    w = math.max(2, x1 - x0)
    h = math.max(2, y1 - y0)

    local cLen   = ESP.Drawing.Boxes.Corner.Length
    local cThick = ESP.Drawing.Boxes.Corner.Thickness
    local dynCL  = math.min(cLen, w * 0.2, h * 0.2)
    local y0yi   = y0 - yInset
    local y1yi   = y1 - yInset

    -- chams
    local chams = el.Chams
    chams.Adornee      = character
    chams.Enabled      = ESP.Drawing.Chams.Enabled
    chams.FillColor    = ESP.Drawing.Chams.FillRGB
    chams.OutlineColor = ESP.Drawing.Chams.OutlineRGB
    chams.DepthMode    = ESP.Drawing.Chams.VisibleCheck and "Occluded" or "AlwaysOnTop"
    if ESP.Drawing.Chams.Enabled then
        chams.FillTransparency    = ESP.Drawing.Chams.Fill_Transparency    / 100
        chams.OutlineTransparency = ESP.Drawing.Chams.Outline_Transparency / 100
    end

    -- corner boxes
    local cv = ESP.Drawing.Boxes.Corner.Enabled
    local cc = ESP.Drawing.Boxes.Corner.RGB
    el.LTH.Visible = cv; el.LTH.Position = UDim2.new(0, x0,           0, y0yi);          el.LTH.Size = UDim2.new(0, dynCL,  0, cThick); el.LTH.BackgroundColor3 = cc
    el.LTV.Visible = cv; el.LTV.Position = UDim2.new(0, x0,           0, y0yi);          el.LTV.Size = UDim2.new(0, cThick, 0, dynCL);  el.LTV.BackgroundColor3 = cc
    el.RTH.Visible = cv; el.RTH.Position = UDim2.new(0, x1 - dynCL,  0, y0yi);          el.RTH.Size = UDim2.new(0, dynCL,  0, cThick); el.RTH.BackgroundColor3 = cc
    el.RTV.Visible = cv; el.RTV.Position = UDim2.new(0, x1 - cThick, 0, y0yi);          el.RTV.Size = UDim2.new(0, cThick, 0, dynCL);  el.RTV.BackgroundColor3 = cc
    el.LBH.Visible = cv; el.LBH.Position = UDim2.new(0, x0,           0, y1yi - cThick); el.LBH.Size = UDim2.new(0, dynCL,  0, cThick); el.LBH.BackgroundColor3 = cc
    el.LBV.Visible = cv; el.LBV.Position = UDim2.new(0, x0,           0, y1yi - dynCL);  el.LBV.Size = UDim2.new(0, cThick, 0, dynCL);  el.LBV.BackgroundColor3 = cc
    el.RBH.Visible = cv; el.RBH.Position = UDim2.new(0, x1 - dynCL,  0, y1yi - cThick); el.RBH.Size = UDim2.new(0, dynCL,  0, cThick); el.RBH.BackgroundColor3 = cc
    el.RBV.Visible = cv; el.RBV.Position = UDim2.new(0, x1 - cThick, 0, y1yi - dynCL);  el.RBV.Size = UDim2.new(0, cThick, 0, dynCL);  el.RBV.BackgroundColor3 = cc

    -- full/filled box
    local full   = ESP.Drawing.Boxes.Full.Enabled
    local filled = ESP.Drawing.Boxes.Filled.Enabled
    el.Box.Position               = UDim2.new(0, x0, 0, y0 - yInset)
    el.Box.Size                   = UDim2.new(0, w,  0, h)
    el.Box.Visible                = full or (cv and filled)
    el.Box.BackgroundTransparency = filled and ESP.Drawing.Boxes.Filled.Transparency or 1
    el.Outline.Enabled            = full and ESP.Drawing.Boxes.Gradient

    el.Gradient1.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1),
        ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2),
    })
    el.Gradient2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1),
        ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2),
    })

    if ESP.Drawing.Boxes.Animate then
        local dt = _Tick - espData.lastTick
        espData.rotAngle = espData.rotAngle + dt * ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi / 4 * _Tick - math.pi / 2)
        el.Gradient1.Rotation = espData.rotAngle
        el.Gradient2.Rotation = espData.rotAngle
    else
        el.Gradient1.Rotation = -45
        el.Gradient2.Rotation = -45
    end
    espData.lastTick = _Tick

    -- names
    el.Name.Visible = ESP.Drawing.Names.Enabled
    if ESP.Drawing.Names.Enabled then
        local nameText = player.Name
        if ESP.Drawing.Distances.Enabled then
            nameText = string.format("%s [%dm]", nameText, math.floor(Dist))
        end
        el.Name.Text       = nameText
        el.Name.TextColor3 = ESP.Drawing.Names.RGB
        el.Name.Position   = UDim2.new(0, x0 + w * 0.5, 0, y0yi - 2)
    end

    -- health bar
    el.HealthBarBG.Visible          = ESP.Drawing.HealthBar.Enabled
    el.HealthBarBG.BackgroundColor3 = Color3.fromRGB(30, 10, 40)
    if ESP.Drawing.HealthBar.Enabled then
        local hpPct    = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local barWidth = 4
        el.HealthBarBG.Position = UDim2.new(0, x0 - barWidth - 2, 0, y0yi)
        el.HealthBarBG.Size     = UDim2.new(0, barWidth, 0, h)
        el.HealthBar.Size       = UDim2.new(1, 0, hpPct, 0)
        el.HealthBar.Position   = UDim2.new(0, 0, 1 - hpPct, 0)
        el.HealthBar.BackgroundColor3 = Color3.fromRGB(
            255,
            math.floor(220 * hpPct),
            math.floor(200 * (1 - hpPct))
        )
    end
end

-- RENDER LOOP
local function st()
    if MasterConnection then
        MasterConnection:Disconnect()
        MasterConnection = nil
    end

    MasterConnection = RunService.RenderStepped:Connect(function()
        _Camera = Workspace.CurrentCamera
        if not _Camera then return end  -- camera can be nil briefly during respawn

        _CamPos   = _Camera.CFrame.Position
        _ViewSize = _Camera.ViewportSize
        _Tick     = tick()

        local okInset, inset = pcall(function() return GuiService:GetGuiInset() end)
        if okInset and inset then
            _GuiInsetY = (ScreenGui and ScreenGui.IgnoreGuiInset) and 0 or inset.Y
        else
            _GuiInsetY = 0
        end

        for character, espData in pairs(ActiveESPs) do
            ProcessESP(character, espData)
        end
    end)
end

local guiHideName = "ESP_" .. tostring(math.random(100000000, 999999999))
local parentGui   = gethui and gethui() or CoreGui

local function cleanupESPGuids(container)
    if not container then return end
    for _, v in pairs(container:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:sub(1, 4) == "ESP_" then
            v:Destroy()
        end
    end
end

cleanupESPGuids(CoreGui)
if parentGui ~= gethui then cleanupESPGuids(parentGui) end

ScreenGui = Functions:Create("ScreenGui", {
    Parent         = parentGui,
    Name           = guiHideName,
    ResetOnSpawn   = false,
    IgnoreGuiInset = true,
    DisplayOrder   = 999999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui)
    elseif protect_gui then protect_gui(ScreenGui) end
end)

-- CREATE ESP PER CHARACTER
local function CreateESP(character)
    if not character then return end
    if not isRealCharacter(character) then return end
    if ActiveESPs[character] then return end

    ESPCounter = ESPCounter + 1
    local folder = Functions:Create("Folder", { Parent = ScreenGui, Name = "E_" .. ESPCounter })

    local Name = Functions:Create("TextLabel", {
        Parent               = folder, Name = "N",
        Position             = UDim2.new(0.5, 0, 0, 0),
        Size                 = UDim2.new(0, 200, 0, ESP.FontSize + 4),
        AnchorPoint          = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        TextColor3           = Color3.fromRGB(255, 255, 255),
        Font                 = Enum.Font.Code,
        TextSize             = ESP.FontSize,
        TextStrokeTransparency = 0,
        TextStrokeColor3     = Color3.fromRGB(0, 0, 0),
        RichText             = true,
        TextScaled           = false,
        Visible              = false,
    })

    local Box = Functions:Create("Frame", {
        Parent               = folder, Name = "B",
        BackgroundColor3     = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.75,
        BorderSizePixel      = 0,
    })

    local Gradient1 = Functions:Create("UIGradient", {
        Parent  = Box,
        Enabled = ESP.Drawing.Boxes.GradientFill,
        Color   = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1),
            ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2),
        }),
    })

    local Outline = Functions:Create("UIStroke", {
        Parent       = Box,
        Enabled      = ESP.Drawing.Boxes.Gradient,
        Transparency = 0,
        Color        = Color3.fromRGB(255, 255, 255),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    local Gradient2 = Functions:Create("UIGradient", {
        Parent  = Outline,
        Enabled = ESP.Drawing.Boxes.Gradient,
        Color   = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1),
            ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2),
        }),
    })

    local Chams = Functions:Create("Highlight", {
        Parent              = folder, Name = "C",
        FillTransparency    = 1,
        OutlineTransparency = 0,
        OutlineColor        = Color3.fromRGB(119, 120, 255),
        DepthMode           = "AlwaysOnTop",
    })

    local HealthBarBG = Functions:Create("Frame", {
        Parent               = folder, Name = "HBG",
        BackgroundColor3     = Color3.fromRGB(30, 10, 40),
        BackgroundTransparency = 0.3,
        BorderSizePixel      = 0,
    })

    local HealthBar = Functions:Create("Frame", {
        Parent               = HealthBarBG, Name = "HB",
        BackgroundColor3     = Color3.fromRGB(0, 255, 0),
        BackgroundTransparency = 0,
        BorderSizePixel      = 0,
        Position             = UDim2.new(0, 0, 0, 0),
        Size                 = UDim2.new(1, 0, 1, 0),
    })

    local cThick = ESP.Drawing.Boxes.Corner.Thickness
    local cLen   = ESP.Drawing.Boxes.Corner.Length
    local cc     = ESP.Drawing.Boxes.Corner.RGB

    local function mc(name, w, h)
        return Functions:Create("Frame", {
            Parent               = folder, Name = name,
            BackgroundColor3     = cc,
            BackgroundTransparency = 0,
            BorderSizePixel      = 0,
            Position             = UDim2.new(0, 0, 0, 0),
            Size                 = UDim2.new(0, w, 0, h),
        })
    end

    ActiveESPs[character] = {
        folder   = folder,
        rotAngle = -45,
        lastTick = tick(),
        elements = {
            Name        = Name,
            Box         = Box,
            Gradient1   = Gradient1,
            Gradient2   = Gradient2,
            Outline     = Outline,
            Chams       = Chams,
            HealthBarBG = HealthBarBG,
            HealthBar   = HealthBar,
            LTH = mc("LTH", cLen,   cThick),
            LTV = mc("LTV", cThick, cLen),
            RTH = mc("RTH", cLen,   cThick),
            RTV = mc("RTV", cThick, cLen),
            LBH = mc("LBH", cLen,   cThick),
            LBV = mc("LBV", cThick, cLen),
            RBH = mc("RBH", cLen,   cThick),
            RBV = mc("RBV", cThick, cLen),
        },
    }
end

local function RemoveESP(character)
    local espData = ActiveESPs[character]
    if espData then
        if espData.folder then espData.folder:Destroy() end
        ActiveESPs[character] = nil
    end
end

-- PLAYER WATCHERS
local function unwatchPlayer(player)
    local conns = PlayerConns[player]
    if conns then
        if conns.charAdded    then conns.charAdded:Disconnect()    end
        if conns.charRemoving then conns.charRemoving:Disconnect() end
        PlayerConns[player] = nil
    end
end

local function watchPlayer(player)
    if player == LocalPlayer then return end

    -- handle already-spawned character
    if player.Character then
        task.defer(CreateESP, player.Character)
    end

    -- store connections so they can be cleaned up on PlayerRemoving
    PlayerConns[player] = {
        charAdded = player.CharacterAdded:Connect(function(character)
            -- wait for HumanoidRootPart and Humanoid to fully exist before trying to create
            character:WaitForChild("HumanoidRootPart", 5)
            character:WaitForChild("Humanoid", 5)
            task.defer(CreateESP, character)
        end),
        charRemoving = player.CharacterRemoving:Connect(function(character)
            RemoveESP(character)
        end),
    }
end

-- init existing players
for _, player in ipairs(Players:GetPlayers()) do
    watchPlayer(player)
end

Players.PlayerAdded:Connect(function(player)
    watchPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        RemoveESP(player.Character)
    end
    unwatchPlayer(player)
end)

-- When LocalPlayer respawns, fill in any characters that were missed
-- (e.g. players whose character existed while LocalPlayer was dead)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)  -- let the new camera and character settle
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not ActiveESPs[player.Character] then
            task.defer(CreateESP, player.Character)
        end
    end
end)

-- CLEANUP
function Functions:CleanAllESPs()
    for character, espData in pairs(ActiveESPs) do
        if espData.folder then espData.folder:Destroy() end
        ActiveESPs[character] = nil
    end
end

ESP.RefreshESPs = function()
    Functions:CleanAllESPs()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            task.defer(CreateESP, player.Character)
        end
    end
end

ESP.CleanAllESPs = function() Functions:CleanAllESPs() end

ESP.SetCornerColor     = function(c) if typeof(c) == "Color3" then ESP.Drawing.Boxes.Corner.RGB = c end end
ESP.SetCornerThickness = function(t) if type(t) == "number" and t > 0 then ESP.Drawing.Boxes.Corner.Thickness = t end end
ESP.SetCornerLength    = function(l) if type(l) == "number" and l > 0 then ESP.Drawing.Boxes.Corner.Length    = l end end

st()

return ESP
