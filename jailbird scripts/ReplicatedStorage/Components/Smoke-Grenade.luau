
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Throwable = require(ReplicatedStorage.Components.Throwable);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 7
    -- upvalues: u1 (copy), Throwable (copy)
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.Throwable = Throwable.new(p2);
    v3.Owner = p2:GetAttribute("Owner");
    v3.SmokeAmount = p2:GetAttribute("Amount");
    v3.Lifetime = p2:GetAttribute("Lifetime");
    v3.Color = p2:GetAttribute("Color");
    v3.Delay = p2:GetAttribute("Delay");

    return v3;
end;

function u1.Init(p4) -- Line: 20
    local v5 = p4.Owner and game.Players:FindFirstChild(p4.Owner);
    p4.Throwable:EnableCollisionAudio(v5);
    p4:Action();
end;

function u1.Action(p6) -- Line: 26
    wait(p6.Delay);
    local v7 = p6.Owner and game.Players:FindFirstChild(p6.Owner);
    p6.Throwable:RecordReplayMilestone(v7, "EffectStart", {
        EffectName = "SmokeCloud",
        BurstInterval = 0.75,
        EmitCount = 5,
        Duration = p6.Lifetime + math.max(p6.SmokeAmount - 1, 0) * 0.75,
        BurstCount = p6.SmokeAmount,
        ParticleLifetime = p6.Lifetime,
        SoundNames = { "Explode", "ExplodeSmoke" }
    });
    p6.Instance.Base.Explode:Play();
    p6.Instance.Base.ExplodeSmoke:Play();

    for _ = 1, p6.SmokeAmount do
        for _, child in pairs(p6.Instance.Base:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                child.Lifetime = NumberRange.new(p6.Lifetime, p6.Lifetime);
                child:Emit(5);
            end;
        end;

        wait(0.75);
    end;
end;

return u1;