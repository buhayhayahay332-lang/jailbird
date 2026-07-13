
local Config = require(game.ReplicatedStorage.Config);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 6
    -- upvalues: u1 (copy)
    p2.PrimaryPart = p2:WaitForChild("Base");
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.Smoke = p2.Body.Smoke;
    v3.Speed = p2:GetAttribute("Speed");
    v3.Break = false;
    v3.SlowPlayers = true;
    v3.Connection = nil;

    return v3;
end;

function u1.Init(p4) -- Line: 20
    p4:SetUp();
end;

function u1.SetUp(u5) -- Line: 24
    -- upvalues: Config (copy)
    Config.AddSound("Barricade_Build", 1, false, u5.Instance.PrimaryPart, false);
    u5.Instance:GetAttributeChangedSignal("Health"):Connect(function() -- Line: 28
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
            task.wait(2);

            if u5.Connection then
                u5.Connection:Disconnect();
            end;

            u5.Instance:Destroy();
        end;
    end);
    u5.Instance.Body.Touched:Connect(function(p6) -- Line: 50
        -- upvalues: u5 (copy)
        if u5.SlowPlayers == true then
            local Humanoid = p6.Parent:FindFirstChild("Humanoid");

            if Humanoid ~= nil then
                Humanoid.WalkSpeed = u5.Speed;
            end;
        end;
    end);
end;

return u1;