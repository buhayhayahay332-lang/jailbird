
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
local Throwable = require(ReplicatedStorage.Components.Throwable);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 8
    -- upvalues: u1 (copy), Throwable (copy)
    p2.PrimaryPart = p2:WaitForChild("Base");
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.Throwable = Throwable.new(v3.Instance);
    v3.Damage = p2:GetAttribute("Damage");
    v3.Range = p2:GetAttribute("Range");
    v3.Owner = p2:GetAttribute("Owner");
    v3.Smoke = p2.Body.Smoke;
    v3.Break = false;
    v3.CanExplode = true;

    return v3;
end;

function u1.Init(p4) -- Line: 27
    p4:SetUp();
end;

function u1.SetUp(u5) -- Line: 31
    -- upvalues: Config (copy)
    Config.AddSound("Barricade_Build", 1, false, u5.Instance.PrimaryPart, false);
    u5.Instance:GetAttributeChangedSignal("Health"):Connect(function() -- Line: 33
        -- upvalues: u5 (copy)
        if u5.Instance:GetAttribute("Health") <= 0 and u5.Break == false then
            u5.Break = true;

            for _, child in pairs(u5.Instance:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Transparency = 1;
                end;
            end;

            u5.Smoke:Emit(10);
            u5.SlowPlayers = false;
            wait(2);
            u5.Instance:Destroy();
        end;
    end);
    u5.Instance.Body.Touched:Connect(function(p6) -- Line: 53
        -- upvalues: u5 (copy)
        if u5.CanExplode == true and p6.Parent:FindFirstChild("Humanoid") ~= nil then
            u5.CanExplode = false;
            u5:Action();
        end;
    end);
end;

function u1.Action(p7) -- Line: 69
    if p7.Instance:FindFirstChild("Base") == nil then
        return nil;
    end;

    p7.Instance.Core.Explode:Play();

    for _, child in pairs(p7.Instance:GetChildren()) do
        if child:IsA("BasePart") then
            child.Transparency = 1;
        end;
    end;

    local v8 = game.Players:FindFirstChild(p7.Owner);

    if v8 ~= nil then
        p7.Throwable:DamageSurround(v8, p7.Damage, p7.Range, p7.MaxBarricade);
    end;

    for _, child in pairs(p7.Instance.Core:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = true;
        end;
    end;

    wait(0.2);

    for _, child in pairs(p7.Instance.Core:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false;
        end;
    end;

    wait(2);
    p7.Instance:Destroy();
end;

return u1;