
local u1 = {};
local u2 = {};
u1.__index = u1;
local GetService = game.GetService;
local u3 = GetService(game, "TweenService");
local u4 = GetService(game, "RunService");
local u5 = GetService(game, "UserInputService");
local GuiService = game:GetService("GuiService");
local Functions = require(script:WaitForChild("Functions"));

function u1.New(p6, p7, p8, p9, p10, p11) -- Line: 57
    -- upvalues: Functions (copy), u2 (copy), u1 (copy)
    local v12 = {
        UI = p6,
        SizeX = 5,
        SizeY = 1
    };
    local v13, v14, v15, v16, v17, v18, v19 = Functions:CreateHairs(p6, v12.SizeX, v12.SizeY);
    v12.Top = v13;
    v12.Bottom = v14;
    v12.Left = v15;
    v12.Right = v16;
    v12.HitMarker = v17;
    v12.CenterDot = v18;
    v12.ImageCrosshair = v19;
    v12.Spreading = {
        Spread = p7 or 20,
        MaxSpread = p8 or 60,
        MinSpread = p7 or 20,
        DecreasePerSecond = p9 or 40,
        IncreasePerSecond = p10 or 30
    };
    v12.FollowingMouse = p11;
    v12.Locked = false;
    v12.Hairs = {
        v12.Top,
        v12.Bottom,
        v12.Left,
        v12.Right
    };
    v12.EasingStyle = Enum.EasingStyle.Linear;
    v12.EasingDirection = Enum.EasingDirection.InOut;
    v12.Hidden = false;
    v12.ControlsMouseIcon = true;
    v12.HitMarker = {
        fadeTime = 0.25,
        hitmarker = v12.HitMarker,
        size = UDim2.fromOffset(50, 50),
        default = Color3.fromRGB(255, 255, 255),
        headshot = Color3.fromRGB(255, 0, 0),
        easingStyle = Enum.EasingStyle.Linear,
        easingDirection = Enum.EasingDirection.InOut,
        Image = {
            default = "rbxassetid://285779644",
            headshot = nil
        }
    };
    v12.CenterDot = {
        enabled = false,
        transparency = 0,
        Image = "rbxassetid://11003529439",
        centerdot = v12.CenterDot,
        size = UDim2.fromOffset(7.5, 7.5)
    };
    v12.ImageCrosshair = {
        enabled = false,
        Image = "rbxassetid://12550071496",
        crosshair = v12.ImageCrosshair
    };
    table.insert(u2, v12);
    Functions:UpdateEnabled(v12.Hairs, false);

    return setmetatable(v12, u1);
end;

function u1.Enable(p20) -- Line: 127
    -- upvalues: u5 (copy), Functions (copy)
    p20.Enabled = true;

    if p20.ControlsMouseIcon == true then
        u5.MouseIconEnabled = false;
    end;

    Functions:UpdateEnabled(p20.Hairs, p20.Enabled);
end;

function u1.Disable(p21) -- Line: 136
    -- upvalues: Functions (copy)
    p21.Enabled = false;
    Functions:UpdateEnabled(p21.Hairs, p21.Enabled);
end;

function u1.Lock(p22, p23) -- Line: 143
    p22.Locked = p23 or true;
end;

function u1.FollowMouse(p24, p25) -- Line: 147
    p24.FollowingMouse = p25;
end;

function u1.Hitmarker(p26, p27, p28, p29, p30) -- Line: 151
    -- upvalues: u3 (copy)
    if p27 then
        p26.HitMarker.hitmarker.ImageColor3 = p26.HitMarker.headshot;
    else
        p26.HitMarker.hitmarker.ImageColor3 = p26.HitMarker.default;
    end;

    p26.HitMarker.hitmarker.Size = p26.HitMarker.size;
    p26.HitMarker.hitmarker.ImageTransparency = 0;
    u3:Create(p26.HitMarker.hitmarker, TweenInfo.new(p28 or p26.HitMarker.fadeTime, p29 or p26.HitMarker.easingStyle, p30 or p26.HitMarker.easingDirection), {
        ImageTransparency = 1
    }):Play();
end;

function u1.Size(p31, p32, p33) -- Line: 169
    if type(p32) ~= "number" or type(p33) ~= "number" then
        return;
    end;

    p31.SizeX = p32;
    p31.SizeY = p33 or p31.SizeY;
    p31.Top.Size = UDim2.fromOffset(p33, p32);
    p31.Bottom.Size = UDim2.fromOffset(p33, p32);
    p31.Left.Size = UDim2.fromOffset(p32, p33);
    p31.Right.Size = UDim2.fromOffset(p32, p33);
end;

function u1.Destroy(p34) -- Line: 181
    -- upvalues: u2 (copy)
    for _, v in pairs(p34.Hairs) do
        v:Destroy();
    end;

    table.remove(u2, table.find(u2, p34));
    table.clear(p34);
end;

function u1.Display(u35, p36) -- Line: 189
    local function ApplyAll(p37, p38) -- Line: 190
        -- upvalues: u35 (copy)
        for _, v in pairs(u35.Hairs) do
            v[p37] = p38;
        end;
    end;

    for i, v in pairs(p36) do
        if pcall(function() -- Line: 197
            -- upvalues: u35 (copy), i (copy)
            local _ = u35.Top[i];
        end) then
            for _, v2 in pairs(u35.Hairs) do
                v2[i] = v;
            end;
        end;
    end;
end;

function u1.Set(p39, p40) -- Line: 205
    p39.Spreading.Spread = tonumber(p40);
end;

function u1.SmoothSet(p41, p42, p43, p44) -- Line: 209
    -- upvalues: u3 (copy), u4 (copy)
    local v45 = tick();
    local Spread = p41.Spreading.Spread;

    while tick() - v45 < p43 do
        local v46 = u3:GetValue((tick() - v45) / p43, p41.EasingStyle or Enum.EasingStyle.Linear, p41.EasingDirection or Enum.EasingDirection.InOut);
        p41.Spreading.Spread = Spread + (p42 - Spread) * v46;
        u4.Heartbeat:Wait();
    end;

    if p44 then
        p41.Spreading.MinSpread = p41.Spreading.Spread;
    end;

    p41.Spreading.Spread = p42;
end;

function u1.Shove(p47) -- Line: 233
    -- upvalues: u4 (copy)
    local Spreading = p47.Spreading;
    Spreading.Spread = Spreading.Spread + p47.Spreading.IncreasePerSecond * u4.Heartbeat:Wait();
end;

function u1.Update(p48, p49) -- Line: 237
    -- upvalues: u5 (copy), GuiService (copy), Functions (copy)
    if p48.Enabled == false then
        return;
    end;

    if p48.Locked == false then
        local Spreading = p48.Spreading;
        Spreading.Spread = Spreading.Spread - p48.Spreading.DecreasePerSecond * p49;
    end;

    p48.Spreading.Spread = math.clamp(p48.Spreading.Spread, p48.Spreading.MinSpread, p48.Spreading.MaxSpread);
    local AbsoluteSize = p48.UI.AbsoluteSize;
    local v50 = p48.FollowingMouse and UDim2.fromOffset(u5:GetMouseLocation().X, u5:GetMouseLocation().Y - GuiService:GetGuiInset().Y) or UDim2.fromOffset(AbsoluteSize.X / 2, AbsoluteSize.Y / 2);
    local v51 = UDim2.fromOffset(0, p48.Spreading.Spread);
    local v52 = UDim2.fromOffset(p48.Spreading.Spread, 0);
    p48.Top.Position = v50 + -v51;
    p48.Bottom.Position = v50 + v51;
    p48.Right.Position = v50 + -v52;
    p48.Left.Position = v50 + v52;
    p48.HitMarker.hitmarker.Position = v50;

    if p48.CenterDot.enabled then
        p48.CenterDot.centerdot.Visible = true;
        p48.CenterDot.centerdot.Image = p48.CenterDot.Image;
        p48.CenterDot.centerdot.Size = p48.CenterDot.size;
        p48.CenterDot.centerdot.ImageTransparency = p48.CenterDot.transparency;
        p48.CenterDot.centerdot.Position = v50;
    else
        p48.CenterDot.centerdot.Visible = false;
    end;

    if not p48.ImageCrosshair.enabled then
        p48.ImageCrosshair.crosshair.Visible = false;

        if p48.Hidden then
            Functions:UpdateEnabled(p48.Hairs, false);

            return;
        end;

        Functions:UpdateEnabled(p48.Hairs, true);

        return;
    end;

    p48.ImageCrosshair.crosshair.Visible = true;
    p48.ImageCrosshair.crosshair.Image = p48.ImageCrosshair.Image;
    p48.ImageCrosshair.crosshair.Size = UDim2.fromOffset(p48.SizeX * 2 + p48.Spreading.Spread, p48.SizeX * 2 + p48.Spreading.Spread);
    p48.ImageCrosshair.crosshair.Position = v50;
    Functions:UpdateEnabled(p48.Hairs, false);
end;

function u1.Raycast(p53) -- Line: 290
    -- upvalues: Functions (copy)
    local v54, v55 = Functions:RandomPointsInsideCrosshair(p53.Spreading.Spread);
    local AbsoluteSize = p53.UI.AbsoluteSize;
    local v56 = workspace.CurrentCamera:ViewportPointToRay(AbsoluteSize.X / 2 + v54, AbsoluteSize.Y / 2 + v55);

    return v56.Origin, v56.Direction;
end;

u4.RenderStepped:Connect(function(p57) -- Line: 303
    -- upvalues: u2 (copy)
    for _, v in pairs(u2) do
        v:Update(p57);
    end;
end);

return u1;