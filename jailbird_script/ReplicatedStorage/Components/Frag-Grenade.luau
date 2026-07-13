
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Throwable = require(ReplicatedStorage.Components.Throwable);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 7
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

    return v3;
end;

function u1.Init(p4) -- Line: 23
    local v5 = game.Players:FindFirstChild(p4.Owner);
    p4.Throwable:EnableCollisionAudio(v5);
    p4:Action();
end;

function u1.Action(p6) -- Line: 29
    wait(p6.Delay);

    if p6.Instance:FindFirstChild("Base") == nil then
        return nil;
    end;

    local v7 = game.Players:FindFirstChild(p6.Owner);
    p6.Throwable:RecordReplayMilestone(v7, "Detonate", {
        HideModel = true,
        ParticleDuration = 0.2,
        SoundNames = { "Explode", "Explode2" }
    });
    p6.Instance.Base.Explode:Play();

    if p6.Instance.Base:FindFirstChild("Explode2") then
        p6.Instance.Base.Explode2:Play();
    end;

    for _, child in pairs(p6.Instance:GetChildren()) do
        if child.Name == "Object" or child.Name == "Others" then
            child.Transparency = 1;
        end;
    end;

    if v7 ~= nil then
        p6.Throwable:DamageSurround(v7, p6.Damage, p6.Range, p6.MaxBarricade, p6.Proximity, nil, nil, p6.Instance.Base.Position, "explosion");
    end;

    for _, child in pairs(p6.Instance.Base:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = true;
        end;
    end;

    wait(0.2);

    for _, child in pairs(p6.Instance.Base:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false;
        end;
    end;

    wait(3.5);
    p6.Throwable:RecordReplayDestroy(v7);
    p6.Instance:Destroy();
end;

return u1;