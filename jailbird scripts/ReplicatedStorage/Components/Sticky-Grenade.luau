
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
local Throwable = require(ReplicatedStorage.Components.Throwable);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 9
    -- upvalues: u1 (copy), Throwable (copy)
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.Throwable = Throwable.new(v3.Instance);
    v3.Damage = p2:GetAttribute("Damage");
    v3.Range = p2:GetAttribute("Range");
    v3.Delay = p2:GetAttribute("Delay");
    v3.MaxBarricade = p2:GetAttribute("MaxBarricade");
    v3.Proximity = p2:GetAttribute("Proximity");
    v3.Owner = p2:GetAttribute("Owner");
    v3.Stick = false;

    return v3;
end;

function u1.Init(p4) -- Line: 26
    -- upvalues: RunService (copy)
    if not RunService:IsClient() then
        local v5 = game.Players:FindFirstChild(p4.Owner);
        p4.Throwable:EnableCollisionAudio(v5);
        p4:SetUpSticky();
        p4:ServerAction();
    end;
end;

function u1.SetUpSticky(p6) -- Line: 35
    local v7 = game.Players:FindFirstChild(p6.Owner);

    if v7 == nil then
        return;
    end;

    p6.Throwable.StartStickyServerFallback(p6.Instance, v7);
end;

function u1.ServerAction(p8) -- Line: 44
    -- upvalues: Config (copy)
    local v9 = game.Players:FindFirstChild(p8.Owner);
    p8.Throwable:RecordReplayMilestone(v9, "EffectStart", {
        EffectName = "StickyFuse",
        SoundName = "Tick",
        Duration = p8.Delay
    });
    p8.Instance.Base.Tick:Play();
    Config.TweenOnce(p8.Instance.Base.Tick, {
        Volume = 2,
        PlaybackSpeed = 6
    }, p8.Delay - 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true);
    task.wait(1);
    p8.Instance.Base.Tick:Stop();
    p8.Throwable:RecordReplayMilestone(v9, "EffectStop", {
        EffectName = "StickyFuse"
    });
    p8.Stick = true;

    if p8.Instance:FindFirstChild("Handle") == nil then
        return nil;
    end;

    p8.Throwable:RecordReplayMilestone(v9, "Detonate", {
        HideModel = true,
        ParticleDuration = 0.2,
        SoundNames = { "Explode", "Explode2" }
    });
    p8.Instance.Base.Explode:Play();

    if p8.Instance.Base:FindFirstChild("Explode2") then
        p8.Instance.Base.Explode2:Play();
    end;

    for _, child in pairs(p8.Instance:GetChildren()) do
        if child.Name == "Object" or child.Name == "Others" then
            child.Transparency = 1;
        end;
    end;

    if v9 ~= nil then
        p8.Throwable:DamageSurround(v9, p8.Damage, p8.Range, p8.MaxBarricade, p8.Proximity, nil, nil, p8.Instance.Base.Position, "explosion");
    end;

    for _, child in pairs(p8.Instance.Base:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = true;
        end;
    end;

    wait(0.2);

    for _, child in pairs(p8.Instance.Base:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false;
        end;
    end;

    wait(1);
    p8.Throwable:RecordReplayDestroy(v9);
    p8.Instance:Destroy();
end;

return u1;