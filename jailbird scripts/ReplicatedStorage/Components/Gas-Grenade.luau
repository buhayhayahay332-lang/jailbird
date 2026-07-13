
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
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
    v3.Delay = p2:GetAttribute("Delay");

    return v3;
end;

function u1.Init(p4) -- Line: 41
    local v5 = game.Players:FindFirstChild(p4.Owner);
    p4.Throwable:EnableCollisionAudio(v5);
    p4:SetUp();
end;

function u1.SetUp(p6) -- Line: 47
    game.Players:FindFirstChild(p6.Owner);
    task.wait(p6.Delay);
    p6:Action();
end;

function u1.Action(u7) -- Line: 57
    -- upvalues: Config (copy)
    if u7.Instance:FindFirstChild("Base") == nil then
        return nil;
    end;

    local v8 = game.Players:FindFirstChild(u7.Owner);
    u7.Throwable:RecordReplayMilestone(v8, "Detonate", {
        HideModel = true,
        ParticleDuration = 0.2,
        SoundNames = { "Explode" }
    });
    u7:ExplodeEffect(v8);
    local v9 = Config.RayCast(u7.Instance.Object.Position + Vector3.new(0, 2, 0), Vector3.new(0, -1, 0), 10, { u7.Instance });

    if v9 then
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Size = Vector3.new(u7.ScaleWidth, u7.ScaleHeight, u7.ScaleWidth);
        Part.Transparency = 1;
        Part.CFrame = CFrame.new(v9.Position + Vector3.new(0, 1, 0) * (u7.ScaleHeight / 2));
        local Round_Cache = workspace:FindFirstChild("Round_Cache");

        if not (Round_Cache and Round_Cache:IsA("Folder")) then
            Round_Cache = Instance.new("Folder");
            Round_Cache.Name = "Round_Cache";
            Round_Cache.Parent = workspace;
        end;

        Part.Parent = Round_Cache;
        u7.Throwable:RecordReplayMilestone(v8, "EffectStart", {
            EffectName = "LingeringArea",
            Duration = u7.Lifetime,
            CFrame = Part.CFrame,
            Size = Part.Size
        });

        for _, child in pairs(u7.EffectsFolder:GetChildren()) do
            if child:IsA("Sound") then
                child:Play();
            else
                child.Enabled = true;
            end;

            child.Parent = Part;
        end;

        for _ = 1, math.floor(u7.Lifetime / u7.Rate) do
            local v10 = workspace:GetPartsInPart(Part);
            local v11 = {};

            for _, v in pairs(v10) do
                local Humanoid = v.Parent:FindFirstChild("Humanoid");

                if Humanoid ~= nil then
                    local u12 = game.Players:FindFirstChild(Humanoid.Parent.Name);
                    local v13 = game.Players:FindFirstChild(u7.Owner);

                    if u12 ~= nil and (u12.Team ~= v13.Team or v13 and u12 == v13) and v11[u12] == nil then
                        if u12.Character then
                            v11[u12] = true;

                            if u12.Character:GetAttribute(u7.DamageEffect) == nil then
                                u12.Character:SetAttribute(u7.DamageEffect, 0);
                            end;

                            u12.Character:SetAttribute(u7.DamageEffect, u12.Character:GetAttribute(u7.DamageEffect) + 1);
                            delay(math.clamp(1.5, u7.Rate, 1.5), function() -- Line: 126
                                -- upvalues: u12 (copy), u7 (copy)
                                u12.Character:SetAttribute(u7.DamageEffect, u12.Character:GetAttribute(u7.DamageEffect) - 1);
                            end);
                        end;

                        u7.Throwable:DamageFunction(v13, u12, u7.Damage, u7.Instance.Name, Part.Position, "lingering_area");
                    end;
                end;
            end;

            task.wait(u7.Rate);
        end;

        u7.Throwable:RecordReplayMilestone(v8, "EffectStop", {
            EffectName = "LingeringArea"
        });

        for _, child in pairs(Part:GetChildren()) do
            if child:IsA("Sound") then
                child:Stop();
            else
                child.Enabled = false;
            end;
        end;

        task.wait(5);
        Part:Destroy();
    end;
end;

function u1.ExplodeEffect(u14, u15) -- Line: 161
    coroutine.resume(coroutine.create(function() -- Line: 162
        -- upvalues: u14 (copy), u15 (copy)
        for _, child in pairs(u14.Instance.Base:GetChildren()) do
            if child.Name == "Explode" then
                child:Play();
            end;
        end;

        for _, child in pairs(u14.Instance:GetChildren()) do
            if child.Name == "Object" then
                child.Transparency = 1;
            end;
        end;

        for _, child in pairs(u14.Instance.Base:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                child.Enabled = true;
            end;
        end;

        wait(0.2);

        for _, child in pairs(u14.Instance.Base:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                child.Enabled = false;
            end;
        end;

        wait(2.5);
        u14.Throwable:RecordReplayDestroy(u15);
        u14.Instance:Destroy();
    end));
end;

return u1;