
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
    v3.Lifetime = p2:GetAttribute("Lifetime");
    v3.MaxBarricade = p2:GetAttribute("MaxBarricade");
    v3.Owner = p2:GetAttribute("Owner");
    v3.Sound = p2.Base:FindFirstChild("DecoySound");

    return v3;
end;

function u1.Init(p4) -- Line: 23
    local v5 = game.Players:FindFirstChild(p4.Owner);
    p4.Throwable:EnableCollisionAudio(v5);
    p4:Action();
end;

function u1.Action(p6) -- Line: 29
    p6:GetSound();
    local v7 = game.Players:FindFirstChild(p6.Owner);
    p6.Throwable:RecordReplayMilestone(v7, "EffectStart", {
        EffectName = "DecoyLoop",
        Duration = p6.Lifetime
    });
    local PlaybackSpeed = p6.Sound.PlaybackSpeed;
    local v8 = math.random(1, 20) / 10;
    local v9 = 0;

    while wait(v8) do
        if math.random(1, 3) == 3 then
            v8 = math.random(1, 20) / 10;
        end;

        p6.Sound.PlaybackSpeed = PlaybackSpeed + math.random(-100, 100) / 1000;
        p6.Throwable:RecordReplayMilestone(v7, "DecoyPulse", {
            PulseDuration = 0.1,
            PlaybackSpeed = p6.Sound.PlaybackSpeed
        });
        p6.Sound:Play();

        for _, child in pairs(p6.Instance.Base:GetChildren()) do
            if child.Name == "Decoy" then
                child.Enabled = true;
            end;
        end;

        task.wait(0.1);

        for _, child in pairs(p6.Instance.Base:GetChildren()) do
            if child.Name == "Decoy" then
                child.Enabled = false;
            end;
        end;

        v9 = v9 + v8;

        if p6.Lifetime <= v9 then
            break;
        end;
    end;

    wait(1);
    p6.Throwable:RecordReplayMilestone(v7, "EffectStop", {
        EffectName = "DecoyLoop"
    });

    if p6.Instance:FindFirstChild("Base") == nil then
        return nil;
    end;

    p6.Throwable:RecordReplayMilestone(v7, "Detonate", {
        HideModel = true,
        ParticleDuration = 0.2,
        SoundNames = { "Explode" }
    });
    p6.Instance.Base.Explode:Play();

    for _, child in pairs(p6.Instance:GetChildren()) do
        if child.Name == "Object" or child.Name == "Others" then
            child.Transparency = 1;
        end;
    end;

    if v7 ~= nil then
        p6.Throwable:DamageSurround(v7, p6.Damage, p6.Range, p6.MaxBarricade);
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

    wait(2.5);
    p6.Throwable:RecordReplayDestroy(v7);
    p6.Instance:Destroy();
end;

function u1.GetSound(u10) -- Line: 117
    local v11 = game.Players:FindFirstChild(u10.Owner);

    if v11 ~= nil and v11.Character ~= nil then
        local v12 = v11.Character:FindFirstChildOfClass("Tool");
        local u13 = v12 ~= nil and v11.Character:FindFirstChild(v12.Name .. "Model");

        if u13 then
            pcall(function() -- Line: 124
                -- upvalues: u10 (copy), u13 (copy)
                u10.Sound.SoundId = u13.Handle.Fire.SoundId;
            end);
        end;
    end;
end;

return u1;