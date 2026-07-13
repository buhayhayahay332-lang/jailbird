
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Utility = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Utility"));
local u11 = {
    fadeOffBody = function(p1, u2) -- Line: 13, Name: fadeOffBody
        -- upvalues: RunService (copy)
        if not u2 then
            return;
        end;

        local u3 = {};
        local u4 = nil;

        for _, descendant in ipairs(u2:GetDescendants()) do
            if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                if descendant.Transparency ~= 1 then
                    table.insert(u3, descendant);

                    if descendant.Name == "face" then
                        u4 = descendant;
                    end;
                end;
            elseif descendant.Name == "face" then
                u4 = descendant;
            end;
        end;

        for _, v in ipairs(u3) do
            v.CollisionGroup = "DeadPlayers";
        end;

        task.wait(5);
        local u5 = 0;
        local u6 = 0;
        local u7 = nil;
        u7 = RunService.Heartbeat:Connect(function(p8) -- Line: 41
            -- upvalues: u2 (copy), u7 (ref), u5 (ref), u6 (ref), u3 (copy), u4 (ref)
            if not u2 then
                u7:Disconnect();
            end;

            u5 = math.clamp(u6 / 2, 0, 1);

            for _, v in ipairs(u3) do
                if v then
                    v.Transparency = u5;
                end;
            end;

            if u4 then
                u4.Transparency = u5;
            end;

            if u6 >= 2 then
                u7:Disconnect();
            end;

            u6 = u6 + p8;
        end);
    end,

    connectFadeOffEvent = function(p9, p10) -- Line: 69, Name: connectFadeOffEvent
    end
};

for _, v in ipairs(Players:GetPlayers()) do
    task.spawn(function() -- Line: 75
        -- upvalues: v (copy), u11 (copy)
        v.CharacterAdded:Connect(function(p12) -- Line: 76
            -- upvalues: u11 (ref)
            u11:connectFadeOffEvent(p12);
        end);

        if v.Character then
            u11:connectFadeOffEvent(v.Character);
        end;
    end);
end;

Players.PlayerAdded:Connect(function(p13) -- Line: 87
    -- upvalues: u11 (copy)
    p13.CharacterAdded:Connect(function(p14) -- Line: 88
        -- upvalues: u11 (ref)
        u11:connectFadeOffEvent(p14);
    end);
end);
Utility:DeepFreeze(u11);

return u11;