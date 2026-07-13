
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
local Throwable = require(ReplicatedStorage.Components.Throwable);
local u1 = {};
u1.__index = u1;
local u2 = Color3.fromRGB(0, 90, 110);
local u3 = Color3.fromRGB(0, 220, 255);

local function getRuntimeParts(p4) -- Line: 12
    if not (p4 and p4.Parent) then
        return nil;
    end;

    local Base = p4:FindFirstChild("Base");
    local Neon = p4:FindFirstChild("Neon");
    local v5;

    if Base then
        v5 = Base:FindFirstChild("Tick");
    else
        v5 = Base;
    end;

    if not (Base and Base:IsA("BasePart")) then
        return nil;
    end;

    if Neon and Neon:IsA("BasePart") then
        return v5 and v5:IsA("Sound") and {
            Base = Base,
            Neon = Neon,
            Tick = v5
        } or nil;
    end;

    return nil;
end;

function u1.new(p6) -- Line: 37
    -- upvalues: u1 (copy), Throwable (copy)
    local v7 = setmetatable({}, u1);
    v7.Instance = p6;
    v7.Throwable = Throwable.new(v7.Instance);
    v7.Range = p6:GetAttribute("Range");
    v7.Owner = p6:GetAttribute("Owner");
    v7.Stick = false;

    return v7;
end;

function u1.Init(p8) -- Line: 50
    -- upvalues: RunService (copy)
    if not RunService:IsClient() then
        local v9 = game.Players:FindFirstChild(p8.Owner);
        p8.Throwable:EnableCollisionAudio(v9);
        p8:SetUpSticky();
    end;
end;

function u1.SetUpSticky(p10) -- Line: 58
    -- upvalues: getRuntimeParts (copy), u2 (copy), Config (copy), u3 (copy)
    local v11 = game.Players:FindFirstChild(p10.Owner);

    if v11 == nil then
        return;
    end;

    p10.Team = v11.Team;
    p10.Throwable.StartStickyServerFallback(p10.Instance, v11);

    while p10.Instance and (p10.Instance.Parent and p10.Instance:GetAttribute("StickResolved") ~= true) do
        task.wait();
    end;

    if not (p10.Instance and p10.Instance.Parent) then
        return;
    end;

    local v12 = getRuntimeParts(p10.Instance);

    if not v12 then
        return;
    end;

    p10.Stick = true;
    p10.Throwable:RecordReplayMilestone(v11, "EffectStart", {
        EffectName = "AlarmArmed"
    });
    v12.Neon.Color = u2;
    v12.Tick.Volume = 0.15;
    v12.Tick:Play();

    while true do
        local v13 = task.wait(0.3) and (p10.Instance and (p10.Instance.Parent and getRuntimeParts(p10.Instance)));

        if not v13 then
            break;
        end;

        local v14 = p10:GetCloseEnemies();

        if v14 and v14.Parent then
            local v15 = Config.RayCast(v13.Base.Position, (v14.Position - v13.Base.Position).Unit, p10.Range * 1.2, { p10.Instance });

            if v15 and (v15.Instance and v15.Instance:IsDescendantOf(v14.Parent)) then
                v13.Tick.Volume = 1;
                p10.Throwable:RecordReplayMilestone(v11, "AlarmPulse", {
                    AlertDuration = 0.2,
                    Volume = 1
                });
                v13.Neon.Color = u3;
                v13.Tick:Play();
                task.wait(0.2);
                local v16 = getRuntimeParts(p10.Instance);

                if not v16 then
                    break;
                end;

                v16.Neon.Color = u2;
                task.wait(0.5);
                local v17 = getRuntimeParts(p10.Instance);

                if not v17 then
                    break;
                end;

                p10.Throwable:RecordReplayMilestone(v11, "AlarmPulse", {
                    AlertDuration = 0.2,
                    Volume = 1
                });
                v17.Neon.Color = u3;
                v17.Tick:Play();
                task.wait(0.2);
                local v18 = getRuntimeParts(p10.Instance);

                if not v18 then
                    break;
                end;

                v18.Neon.Color = u2;
                task.wait(1);
            end;
        end;
    end;
end;

function u1.GetCloseEnemies(p19) -- Line: 138
    -- upvalues: getRuntimeParts (copy)
    local v20 = getRuntimeParts(p19.Instance);

    if not v20 then
        return nil;
    end;

    for _, v in pairs(game.Players:GetPlayers()) do
        if v:WaitForChild("ServerData"):GetAttribute("Alive") == true and v.Team ~= p19.Team then
            local v21 = v.Character or v.CharacterAdded:Wait();

            if v21 then
                local HumanoidRootPart = v21:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart and (v20.Base.Position - HumanoidRootPart.Position).Magnitude <= p19.Range then
                    return HumanoidRootPart;
                end;
            end;
        end;
    end;

    return nil;
end;

return u1;