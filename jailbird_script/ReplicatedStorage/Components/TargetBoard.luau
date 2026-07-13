
local TweenService = game:GetService("TweenService");
local Config = require(game.ReplicatedStorage.Config);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 7
    -- upvalues: u1 (copy), Config (copy)
    p2.PrimaryPart = p2:WaitForChild("Core");
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.Pivot = p2:WaitForChild("Pivot");
    v3.FlipTime = p2:GetAttribute("FlipTime");
    v3.Cooldown = p2:GetAttribute("Cooldown");
    v3.Speed = p2:GetAttribute("Speed");
    v3.IdleSound = Config.AddSound("TargetBoard_Idle", 0.4, false, v3.Pivot, true);
    local v4 = p2.PrimaryPart.Position + p2.PrimaryPart.CFrame.RightVector * -p2:GetAttribute("Distance");
    v3.LeftLimit = CFrame.new(v4, v4 + p2.PrimaryPart.CFrame.LookVector);
    local v5 = p2.PrimaryPart.Position + p2.PrimaryPart.CFrame.RightVector * p2:GetAttribute("Distance");
    v3.RightLimit = CFrame.new(v5, v5 + p2.PrimaryPart.CFrame.LookVector);
    v3.TweenLeft = nil;
    v3.TweenRight = nil;
    v3.MovingDirection = "Left";

    return v3;
end;

function u1.Init(p6) -- Line: 30
    p6:SetUp();
    p6:Config();
end;

function u1.SetUp(u7) -- Line: 35
    -- upvalues: TweenService (copy)
    local Motor6D = Instance.new("Motor6D", u7.Pivot);
    Motor6D.Name = "Anim";
    Motor6D.Part0 = u7.Instance.Target;
    Motor6D.Part1 = u7.Pivot;
    Motor6D.C0 = u7.Instance.Target.CFrame:Inverse() * u7.Pivot.CFrame;

    for _, child in pairs(u7.Instance:GetChildren()) do
        if child.Name ~= "Target" then
            local WeldConstraint = Instance.new("WeldConstraint", u7.Instance.PrimaryPart);
            WeldConstraint.Part0 = child;
            WeldConstraint.Part1 = u7.Instance.PrimaryPart;

            if child.Name == "Others" then
                WeldConstraint.Part1 = u7.Instance.Target;
            end;
        end;

        if child.Name ~= "Core" then
            child.Anchored = false;
        end;
    end;

    u7.TweenLeft = TweenService:Create(u7.Instance.PrimaryPart, TweenInfo.new(10 / u7.Speed, Enum.EasingStyle.Linear), {
        CFrame = u7.LeftLimit
    });
    u7.TweenRight = TweenService:Create(u7.Instance.PrimaryPart, TweenInfo.new(10 / u7.Speed, Enum.EasingStyle.Linear), {
        CFrame = u7.RightLimit
    });
    u7.TweenHit = TweenService:Create(u7.Pivot.Anim, TweenInfo.new(u7.FlipTime, Enum.EasingStyle.Sine), {
        C0 = u7.Pivot.Anim.C0 * CFrame.fromAxisAngle(Vector3.new(1, 0, 0), 1.5707963267948966)
    });
    u7.TweenUp = TweenService:Create(u7.Pivot.Anim, TweenInfo.new(1, Enum.EasingStyle.Sine), {
        C0 = u7.Pivot.Anim.C0
    });
    u7.TweenLeft.Completed:Connect(function() -- Line: 63
        -- upvalues: u7 (copy)
        u7.MovingDirection = "Right";
        u7.TweenRight:Play();
    end);
    u7.TweenRight.Completed:Connect(function() -- Line: 68
        -- upvalues: u7 (copy)
        u7.MovingDirection = "Left";
        u7.TweenLeft:Play();
    end);
    u7.TweenLeft:Play();
end;

function u1.Config(u8) -- Line: 77
    -- upvalues: Config (copy)
    u8.Instance:GetAttributeChangedSignal("Hit"):Connect(function() -- Line: 79
        -- upvalues: u8 (copy), Config (ref)
        if u8.Instance:GetAttribute("Hit") ~= true then
            if u8.MovingDirection == "Right" then
                u8.TweenRight:Play();

                return;
            end;

            if u8.MovingDirection == "Left" then
                u8.TweenLeft:Play();
            end;

            return;
        end;

        Config.AddSound("TargetBoard_Hit", 1, true, u8.Pivot);
        u8.IdleSound:Stop();
        u8.TweenLeft:Pause();
        u8.TweenRight:Pause();
        u8.TweenHit:Play();
        wait(u8.FlipTime);
        wait(u8.Cooldown);
        u8.TweenUp:Play();
        Config.AddSound("TargetBoard_Up", 0.5, true, u8.Pivot);
        wait(1);
        u8.IdleSound:Play();
        u8.Instance:SetAttribute("Hit", false);
    end);
end;

function u1.Action(p9) -- Line: 110
end;

return u1;