
local Config = require(game.ReplicatedStorage.Config);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 6
    -- upvalues: u1 (copy)
    p2.PrimaryPart = p2:WaitForChild("Base");
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.Smoke = p2.Body.Smoke;
    v3.Break = false;

    return v3;
end;

function u1.Init(p4) -- Line: 17
    p4:SetUp();
end;

function u1.SetUp(u5) -- Line: 21
    -- upvalues: Config (copy)
    Config.AddSound("Barricade_Build", 1, false, u5.Instance.PrimaryPart, false);
    u5.Instance:GetAttributeChangedSignal("Health"):Connect(function() -- Line: 25
        -- upvalues: u5 (copy), Config (ref)
        if u5.Instance:GetAttribute("Health") <= 0 and u5.Break == false then
            u5.Break = true;

            for _, child in pairs(u5.Instance:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Anchored = false;
                end;
            end;

            u5.Smoke:Emit(10);
            u5.Instance.PrimaryPart:ApplyAngularImpulse(u5.Instance.PrimaryPart.CFrame.RightVector * -600);
            Config.AddSound("Shield_Drop1", 1, true, u5.Smoke.Parent, false);
        end;
    end);
end;

return u1;