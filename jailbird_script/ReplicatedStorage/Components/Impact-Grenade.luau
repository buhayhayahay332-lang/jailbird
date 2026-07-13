
game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Config);
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
    v3.Owner = p2:GetAttribute("Owner");
    v3.Exploded = false;
    v3.Hit = false;

    return v3;
end;

function u1.Init(p4) -- Line: 26
    local v5 = game.Players:FindFirstChild(p4.Owner);
    p4.Throwable:EnableCollisionAudio(v5);
    p4:SetUp();
end;

function u1.SetUp(u6) -- Line: 32
    local v7 = game.Players:FindFirstChild(u6.Owner);

    if v7 == nil then
        return;
    end;

    u6.Throwable.StartImpactServerFallback(u6.Instance, v7, function(p8) -- Line: 38
        -- upvalues: u6 (copy)
        if u6.Exploded == true then
            return;
        end;

        u6.Exploded = true;
        u6.Instance.PrimaryPart = u6.Instance.PrimaryPart or (u6.Instance:FindFirstChild("Handle") or u6.Instance:FindFirstChild("Base"));

        if u6.Instance.PrimaryPart then
            u6.Instance.PrimaryPart.Anchored = true;
        end;

        for _, child in pairs(u6.Instance:GetChildren()) do
            if child:IsA("BasePart") then
                child.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                child.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                child.CanCollide = false;
            end;
        end;

        u6.Instance:PivotTo(CFrame.new(p8.Position + p8.Normal * 0.3, p8.Position));
        u6:Action(p8);
    end);
end;

function u1.Action(p9) -- Line: 63
    if p9.Instance:FindFirstChild("Base") == nil then
        return nil;
    end;

    local v10 = game.Players:FindFirstChild(p9.Owner);
    p9.Throwable:RecordReplayMilestone(v10, "Detonate", {
        HideModel = true,
        ParticleDuration = 0.2,
        SoundNames = { "Explode", "Explode2" }
    });
    p9.Instance.Base.Explode:Play();

    if p9.Instance.Base:FindFirstChild("Explode2") then
        p9.Instance.Base.Explode2:Play();
    end;

    for _, child in pairs(p9.Instance:GetChildren()) do
        if child.Name == "Object" or child.Name == "Others" then
            child.Transparency = 1;
        end;
    end;

    if v10 ~= nil then
        p9.Throwable:DamageSurround(v10, p9.Damage, p9.Range, p9.MaxBarricade, p9.Proximity, nil, nil, p9.Instance.Base.Position, "explosion");
    end;

    for _, child in pairs(p9.Instance.Base:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = true;
        end;
    end;

    wait(0.2);

    for _, child in pairs(p9.Instance.Base:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false;
        end;
    end;

    wait(1.5);
    p9.Throwable:RecordReplayDestroy(v10);
    p9.Instance:Destroy();
end;

return u1;