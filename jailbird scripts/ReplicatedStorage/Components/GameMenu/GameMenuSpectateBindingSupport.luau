
return {
    BindSpectateControls = function(u1) -- Line: 3, Name: BindSpectateControls
        local function connectSpectateCyclePlayer(u2) -- Line: 28
            -- upvalues: u1 (copy)
            task.defer(function() -- Line: 29
                -- upvalues: u2 (copy), u1 (ref)
                local v3 = u2:FindFirstChild("ServerData") or u2:WaitForChild("ServerData", 10);

                if not v3 then
                    return;
                end;

                v3:GetAttributeChangedSignal("Alive"):Connect(function() -- Line: 34
                    -- upvalues: u1 (ref)
                    task.defer(function() -- Line: 35
                        -- upvalues: u1 (ref)
                        local v4 = u1.GetCurrentSpectatingPlayer();

                        if v4 and (u1.IsKillCamActive() ~= true and (u1.IsReplayKillCamActive() ~= true and u1.IsAlive(v4) ~= true)) then
                            u1.SpectateTeam();

                            return;
                        end;

                        u1.RefreshSpectateControls();
                    end);
                end);
            end);
        end;

        u1.ContextActionService:BindActionAtPriority(u1.ActionName, function(p5, p6, p7) -- Line: 4, Name: handleSpectateCycleAction
            -- upvalues: u1 (copy)
            if p6 ~= Enum.UserInputState.Begin then
                return Enum.ContextActionResult.Pass;
            end;

            if u1.CanCycleTeamSpectate() ~= true then
                return Enum.ContextActionResult.Pass;
            end;

            local v8 = p7 and p7.KeyCode or Enum.KeyCode.Unknown;

            if v8 == Enum.KeyCode.Q or v8 == Enum.KeyCode.ButtonL1 then
                if u1.TryManualCycleTeamSpectate(-1) ~= true then
                    return Enum.ContextActionResult.Sink;
                end;
            else
                if v8 ~= Enum.KeyCode.E and v8 ~= Enum.KeyCode.ButtonR1 then
                    return Enum.ContextActionResult.Pass;
                end;

                if u1.TryManualCycleTeamSpectate(1) ~= true then
                    return Enum.ContextActionResult.Sink;
                end;
            end;

            return Enum.ContextActionResult.Sink;
        end, false, u1.ActionPriority, Enum.KeyCode.Q, Enum.KeyCode.E, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
        u1.LocalPlayer:GetAttributeChangedSignal("OnMobile"):Connect(u1.RefreshSpectateControls);
        u1.LocalPlayer:GetAttributeChangedSignal("OnConsole"):Connect(u1.RefreshSpectateControls);
        u1.LocalPlayer:GetAttributeChangedSignal("OnComputer"):Connect(u1.RefreshSpectateControls);

        for _, v in ipairs(u1.Players:GetPlayers()) do
            task.defer(function() -- Line: 29
                -- upvalues: v (copy), u1 (copy)
                local v9 = v:FindFirstChild("ServerData") or v:WaitForChild("ServerData", 10);

                if not v9 then
                    return;
                end;

                v9:GetAttributeChangedSignal("Alive"):Connect(function() -- Line: 34
                    -- upvalues: u1 (ref)
                    task.defer(function() -- Line: 35
                        -- upvalues: u1 (ref)
                        local v10 = u1.GetCurrentSpectatingPlayer();

                        if v10 and (u1.IsKillCamActive() ~= true and (u1.IsReplayKillCamActive() ~= true and u1.IsAlive(v10) ~= true)) then
                            u1.SpectateTeam();

                            return;
                        end;

                        u1.RefreshSpectateControls();
                    end);
                end);
            end);
        end;

        u1.Players.PlayerAdded:Connect(function(u11) -- Line: 54
            -- upvalues: u1 (copy)
            task.defer(function() -- Line: 29
                -- upvalues: u11 (copy), u1 (ref)
                local v12 = u11:FindFirstChild("ServerData") or u11:WaitForChild("ServerData", 10);

                if not v12 then
                    return;
                end;

                v12:GetAttributeChangedSignal("Alive"):Connect(function() -- Line: 34
                    -- upvalues: u1 (ref)
                    task.defer(function() -- Line: 35
                        -- upvalues: u1 (ref)
                        local v13 = u1.GetCurrentSpectatingPlayer();

                        if v13 and (u1.IsKillCamActive() ~= true and (u1.IsReplayKillCamActive() ~= true and u1.IsAlive(v13) ~= true)) then
                            u1.SpectateTeam();

                            return;
                        end;

                        u1.RefreshSpectateControls();
                    end);
                end);
            end);
            task.defer(u1.RefreshSpectateControls);
        end);
        u1.Players.PlayerRemoving:Connect(function() -- Line: 58
            -- upvalues: u1 (copy)
            task.defer(u1.RefreshSpectateControls);
        end);
        u1.RefreshSpectateControls();
    end
};