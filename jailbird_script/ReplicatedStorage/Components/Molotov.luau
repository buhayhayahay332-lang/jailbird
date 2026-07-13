
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Config);
local Throwable = require(ReplicatedStorage.Components.Throwable);
local u1 = {};
u1.__index = u1;

local function GetRoundCacheFolder() -- Line: 10
    local Round_Cache = workspace:FindFirstChild("Round_Cache");

    if Round_Cache and Round_Cache:IsA("Folder") then
        return Round_Cache;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "Round_Cache";
    Folder.Parent = workspace;

    return Folder;
end;

function u1.new(p2) -- Line: 22
    -- upvalues: u1 (copy), Throwable (copy)
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.Throwable = Throwable.new(v3.Instance);
    v3.Damage = p2:GetAttribute("Damage");
    v3.Owner = p2:GetAttribute("Owner");
    v3.Lifetime = p2:GetAttribute("Lifetime");
    v3.EffectsFolder = p2.Object.Effects;
    v3.Rate = p2:GetAttribute("Rate");
    v3.DamageEffect = p2:GetAttribute("DamageEffect");
    v3.ScaleWidth = p2:GetAttribute("ScaleWidth");
    v3.ScaleHeight = p2:GetAttribute("ScaleHeight");
    v3.Exploded = false;
    v3.Hit = false;

    return v3;
end;

function u1.Init(p4) -- Line: 42
    local v5 = game.Players:FindFirstChild(p4.Owner);
    p4.Throwable:EnableCollisionAudio(v5);
    p4:SetUp();
end;

function u1.SetUp(u6) -- Line: 48
    local v7 = game.Players:FindFirstChild(u6.Owner);

    if v7 == nil then
        return;
    end;

    u6.Throwable.StartImpactServerFallback(u6.Instance, v7, function(p8) -- Line: 54
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

        u6.Instance:PivotTo(CFrame.new(p8.Position + p8.Normal * 0.15, p8.Position));
        u6:Action(p8);
    end, {
        RequireUpwardNormal = true,
        UpwardNormalDotThreshold = 0.8191520442889918
    });
end;

function u1.Action(u9, p10) -- Line: 81
    if u9.Instance:FindFirstChild("Base") == nil then
        return nil;
    end;

    local v11 = game.Players:FindFirstChild(u9.Owner);
    u9.Throwable:RecordReplayMilestone(v11, "Detonate", {
        HideModel = true,
        ParticleDuration = 0.2,
        SoundNames = { "Explode" }
    });
    u9:ExplodeEffect(v11);

    if p10 then
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Size = Vector3.new(u9.ScaleWidth, u9.ScaleHeight, u9.ScaleWidth);
        Part.Transparency = 1;
        Part.CFrame = CFrame.new(p10.Position + Vector3.new(0, 1, 0) * (u9.ScaleHeight / 2));
        local Round_Cache = workspace:FindFirstChild("Round_Cache");

        if not (Round_Cache and Round_Cache:IsA("Folder")) then
            Round_Cache = Instance.new("Folder");
            Round_Cache.Name = "Round_Cache";
            Round_Cache.Parent = workspace;
        end;

        Part.Parent = Round_Cache;
        u9.Throwable:RecordReplayMilestone(v11, "EffectStart", {
            EffectName = "LingeringArea",
            Duration = u9.Lifetime,
            CFrame = Part.CFrame,
            Size = Part.Size
        });

        for _, child in pairs(u9.EffectsFolder:GetChildren()) do
            if child:IsA("Sound") then
                child:Play();
            else
                child.Enabled = true;
            end;

            child.Parent = Part;
        end;

        for _ = 1, math.floor(u9.Lifetime / u9.Rate) do
            local v12 = workspace:GetPartsInPart(Part);
            local v13 = {};

            for _, v in pairs(v12) do
                local Humanoid = v.Parent:FindFirstChild("Humanoid");

                if Humanoid ~= nil then
                    local u14 = game.Players:FindFirstChild(Humanoid.Parent.Name);
                    local v15 = game.Players:FindFirstChild(u9.Owner);

                    if u14 ~= nil and (u14.Team ~= v15.Team or v15 and u14 == v15) and v13[u14] == nil then
                        if u14.Character then
                            v13[u14] = true;

                            if u14.Character:GetAttribute(u9.DamageEffect) == nil then
                                u14.Character:SetAttribute(u9.DamageEffect, 0);
                            end;

                            u14.Character:SetAttribute(u9.DamageEffect, u14.Character:GetAttribute(u9.DamageEffect) + 1);
                            delay(math.clamp(1.5, u9.Rate, 1.5), function() -- Line: 149
                                -- upvalues: u14 (copy), u9 (copy)
                                u14.Character:SetAttribute(u9.DamageEffect, u14.Character:GetAttribute(u9.DamageEffect) - 1);
                            end);
                        end;

                        u9.Throwable:DamageFunction(v15, u14, u9.Damage, u9.Instance.Name, Part.Position, "lingering_area");
                    end;
                end;
            end;

            task.wait(u9.Rate);
        end;

        u9.Throwable:RecordReplayMilestone(v11, "EffectStop", {
            EffectName = "LingeringArea"
        });

        for _, child in pairs(Part:GetChildren()) do
            if child:IsA("Sound") then
                child:Stop();
            else
                child.Enabled = false;
            end;
        end;

        task.wait(4);
        Part:Destroy();
    end;
end;

function u1.ExplodeEffect(u16, u17) -- Line: 184
    coroutine.resume(coroutine.create(function() -- Line: 185
        -- upvalues: u16 (copy), u17 (copy)
        for _, child in pairs(u16.Instance.Base:GetChildren()) do
            if child.Name == "Explode" then
                child:Play();
            end;
        end;

        for _, child in pairs(u16.Instance:GetChildren()) do
            if child.Name == "Object" then
                child.Transparency = 1;
            end;
        end;

        for _, child in pairs(u16.Instance.Base:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                child.Enabled = true;
            end;
        end;

        wait(0.2);

        for _, child in pairs(u16.Instance.Base:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                child.Enabled = false;
            end;
        end;

        wait(2.5);
        u16.Throwable:RecordReplayDestroy(u17);
        u16.Instance:Destroy();
    end));
end;

return u1;