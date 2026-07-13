
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
local v1 = {};
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = 0;

local function resolveAdornee(p4) -- Line: 16
    if typeof(p4) ~= "Instance" then
        return nil;
    end;

    if p4:IsA("Model") then
        return p4;
    end;

    if p4:IsA("BasePart") then
        return p4:FindFirstAncestorOfClass("Model") or p4;
    end;

    return nil;
end;

local function ensureHighlightFolder() -- Line: 29
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return nil;
    end;

    local ReplayKillCamHighlightFolder = CurrentCamera:FindFirstChild("ReplayKillCamHighlightFolder");

    if ReplayKillCamHighlightFolder and ReplayKillCamHighlightFolder:IsA("Folder") then
        return ReplayKillCamHighlightFolder;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "ReplayKillCamHighlightFolder";
    Folder.Parent = CurrentCamera;

    return Folder;
end;

local function ensurePulseFrame() -- Line: 46
    -- upvalues: LocalPlayer (copy), Config (copy)
    local v5 = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui");

    if v5 then
        v5 = v5:FindFirstChild("GameHUD");
    end;

    if not v5 then
        return nil;
    end;

    local ReplayKillCamDamagePulse = v5:FindFirstChild("ReplayKillCamDamagePulse");

    if ReplayKillCamDamagePulse and ReplayKillCamDamagePulse:IsA("Frame") then
        return ReplayKillCamDamagePulse;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "ReplayKillCamDamagePulse";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Config.FakeBloodHighlightColor or Color3.fromRGB(255, 60, 60);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Visible = false;
    Frame.ZIndex = 25;
    Frame.Parent = v5;

    return Frame;
end;

function v1.PlayHitHighlight(p6) -- Line: 72
    -- upvalues: Config (copy), TweenService (copy)
    if typeof(p6) == "Instance" then
        if not p6:IsA("Model") then
            if p6:IsA("BasePart") then
                p6 = p6:FindFirstAncestorOfClass("Model") or p6;
            else
                p6 = nil;
            end;
        end;
    else
        p6 = nil;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    local v7;

    if CurrentCamera then
        v7 = CurrentCamera:FindFirstChild("ReplayKillCamHighlightFolder");

        if not (v7 and v7:IsA("Folder")) then
            v7 = Instance.new("Folder");
            v7.Name = "ReplayKillCamHighlightFolder";
            v7.Parent = CurrentCamera;
        end;
    else
        v7 = nil;
    end;

    if not (p6 and v7) then
        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "ReplayKillCamHitHighlight";
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Adornee = p6;
    Highlight.FillColor = Config.FakeBloodHighlightColor or Color3.fromRGB(255, 60, 60);
    Highlight.FillTransparency = Config.FakeBloodHighlightStartTransparency or 0.2;
    Highlight.OutlineColor = Config.FakeBloodHighlightColor or Color3.fromRGB(255, 60, 60);
    Highlight.OutlineTransparency = Config.FakeBloodHighlightOutlineStartTransparency or 0.5;
    Highlight.Parent = v7;
    local v8 = TweenService:Create(Highlight, TweenInfo.new((Config.FakeBloodHighlightFlashTime or 0.18) + (Config.FakeBloodHighlightFadeTime or 0.32), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        FillTransparency = 1,
        OutlineTransparency = 1
    });
    v8:Play();
    v8.Completed:Once(function() -- Line: 95
        -- upvalues: Highlight (copy)
        if Highlight.Parent then
            Highlight:Destroy();
        end;
    end);
end;

function v1.PlayDamagePulse() -- Line: 102
    -- upvalues: ensurePulseFrame (copy), u3 (ref), u2 (ref), Config (copy), TweenService (copy)
    local u9 = ensurePulseFrame();

    if not u9 then
        return;
    end;

    u3 = u3 + 1;
    local u10 = u3;

    if u2 then
        u2:Cancel();
        u2 = nil;
    end;

    u9.Visible = true;
    u9.BackgroundColor3 = Config.FakeBloodHighlightColor or Color3.fromRGB(255, 60, 60);
    u9.BackgroundTransparency = 0.82;
    u2 = TweenService:Create(u9, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    });
    u2:Play();
    u2.Completed:Once(function() -- Line: 122
        -- upvalues: u3 (ref), u10 (copy), u9 (copy), u2 (ref)
        if u3 ~= u10 then
            return;
        end;

        u9.Visible = false;
        u2 = nil;
    end);
end;

return v1;