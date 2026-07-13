
local TweenService = game:GetService("TweenService");
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 6
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.OpenTime = p2:GetAttribute("OpenTime");
    v3.RightDoor = p2:FindFirstChild("RightDoor");
    v3.LeftDoor = p2:FindFirstChild("LeftDoor");
    v3.Block = p2:FindFirstChild("Block");
    v3.OpenSound = p2:FindFirstChild("Open", true);
    v3.CloseSound = p2:FindFirstChild("Close", true);
    v3.Handle = p2:FindFirstChild("Handle", true);
    v3.CanOpen = true;

    return v3;
end;

function u1.Init(p4) -- Line: 21
    p4:SetUp();
    p4:AddPrompt();
end;

function u1.SetUp(p5) -- Line: 26
    if p5.RightDoor ~= nil then
        for _, child in pairs(p5.RightDoor:GetChildren()) do
            if child.Name ~= "Core" then
                local WeldConstraint = Instance.new("WeldConstraint", p5.RightDoor.Core);
                WeldConstraint.Part0 = child;
                WeldConstraint.Part1 = p5.RightDoor.Core;
                child.Anchored = false;
            end;
        end;

        p5.RightDoor.PrimaryPart = p5.RightDoor.Core;
    end;

    if p5.LeftDoor ~= nil then
        for _, child in pairs(p5.LeftDoor:GetChildren()) do
            if child.Name ~= "Core" then
                local WeldConstraint = Instance.new("WeldConstraint", p5.LeftDoor.Core);
                WeldConstraint.Part0 = child;
                WeldConstraint.Part1 = p5.LeftDoor.Core;
                child.Anchored = false;
            end;
        end;

        p5.LeftDoor.PrimaryPart = p5.LeftDoor.Core;
    end;
end;

function u1.AddPrompt(u6) -- Line: 51
    -- upvalues: TweenService (copy)
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.F;
    ProximityPrompt.ActionText = "OPEN";
    ProximityPrompt.ObjectText = "DOOR";
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.MaxActivationDistance = 4;
    task.wait();
    ProximityPrompt.Parent = u6.Handle;
    ProximityPrompt.Triggered:Connect(function(p7) -- Line: 63
        -- upvalues: u6 (copy), ProximityPrompt (copy), TweenService (ref)
        if u6.CanOpen == true then
            u6.CanOpen = false;

            if ProximityPrompt.ActionText == "OPEN" then
                ProximityPrompt.ActionText = "CLOSE";

                if u6.RightDoor ~= nil then
                    TweenService:Create(u6.RightDoor.Core, TweenInfo.new(u6.OpenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        CFrame = u6.RightDoor.Core.CFrame * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -1.5707963267948966)
                    }):Play();
                end;

                if u6.LeftDoor ~= nil then
                    TweenService:Create(u6.LeftDoor.Core, TweenInfo.new(u6.OpenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        CFrame = u6.LeftDoor.Core.CFrame * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 1.5707963267948966)
                    }):Play();
                end;

                if u6.Block ~= nil then
                    u6.Block.CanCollide = false;
                end;

                u6.OpenSound:Play();
            elseif ProximityPrompt.ActionText == "CLOSE" then
                ProximityPrompt.ActionText = "OPEN";

                if u6.RightDoor ~= nil then
                    TweenService:Create(u6.RightDoor.Core, TweenInfo.new(u6.OpenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        CFrame = u6.RightDoor.Core.CFrame * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 1.5707963267948966)
                    }):Play();
                end;

                if u6.LeftDoor ~= nil then
                    TweenService:Create(u6.LeftDoor.Core, TweenInfo.new(u6.OpenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        CFrame = u6.LeftDoor.Core.CFrame * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -1.5707963267948966)
                    }):Play();
                end;

                if u6.Block ~= nil then
                    u6.Block.CanCollide = true;
                end;

                u6.CloseSound:Play();
            end;

            wait(u6.OpenTime);
            u6.CanOpen = true;
        end;
    end);
end;

return u1;