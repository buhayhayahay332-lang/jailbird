
return {
    new = function(p1) -- Line: 3, Name: new
        local Camera = p1.Camera;
        local Player = p1.Player;
        local CollectionService = p1.CollectionService;
        local IsReplayKillCamActive = p1.IsReplayKillCamActive;
        local u2 = {};
        local u3 = {};
        local u4 = {};
        local u5 = {};
        local u6 = nil;
        local u7 = nil;

        local function disconnectConnection(p8) -- Line: 16
            if p8 then
                p8:Disconnect();
            end;
        end;

        local function isSuppressed() -- Line: 22
            -- upvalues: u6 (ref), Camera (copy), IsReplayKillCamActive (copy)
            local v9 = u6 and u6:GetAttribute("Alive") == true;

            return v9 ~= true and true or (Camera and Camera:GetAttribute("FirstPersonSpectateActive") == true and true or typeof(IsReplayKillCamActive) == "function" and IsReplayKillCamActive() == true);
        end;

        local function getPromptEntry(p10) -- Line: 39
            -- upvalues: u3 (copy)
            return u3[p10];
        end;

        local function setPromptEnabled(p11, p12) -- Line: 43
            if not p11 or (not p11.Prompt or p11.Prompt.Parent == nil) then
                return;
            end;

            if p11.Prompt.Enabled == p12 then
                return;
            end;

            p11.Applying = true;
            p11.Prompt.Enabled = p12;
            p11.Applying = false;
        end;

        local function u16(p13) -- Line: 55
            -- upvalues: u6 (ref), Camera (copy), IsReplayKillCamActive (copy)
            if not p13 or (not p13.Prompt or p13.Prompt.Parent == nil) then
                return;
            end;

            local v14 = u6 and u6:GetAttribute("Alive") == true;

            if (v14 ~= true and true or (Camera and Camera:GetAttribute("FirstPersonSpectateActive") == true and true or typeof(IsReplayKillCamActive) == "function" and IsReplayKillCamActive() == true)) == true then
                if p13 and p13.Prompt then
                    if p13.Prompt.Parent == nil then
                        return;
                    end;

                    if p13.Prompt.Enabled == false then
                        return;
                    end;

                    p13.Applying = true;
                    p13.Prompt.Enabled = false;
                    p13.Applying = false;
                end;

                return;
            end;

            local v15 = p13.BaselineEnabled == true;

            if p13 and p13.Prompt then
                if p13.Prompt.Parent == nil then
                    return;
                end;

                if p13.Prompt.Enabled == v15 then
                    return;
                end;

                p13.Applying = true;
                p13.Prompt.Enabled = v15;
                p13.Applying = false;
            end;
        end;

        local function u19(p17) -- Line: 66
            -- upvalues: u3 (copy)
            local v18 = u3[p17];

            if not v18 then
                return;
            end;

            local EnabledConnection = v18.EnabledConnection;

            if EnabledConnection then
                EnabledConnection:Disconnect();
            end;

            local AncestryConnection = v18.AncestryConnection;

            if AncestryConnection then
                AncestryConnection:Disconnect();
            end;

            u3[p17] = nil;
        end;

        local function trackPrompt(u20) -- Line: 76
            -- upvalues: u3 (copy), u16 (ref), u19 (ref)
            if not u3[u20] then
                local u21 = {
                    Applying = false,
                    EnabledConnection = nil,
                    AncestryConnection = nil,
                    Prompt = u20,
                    BaselineEnabled = u20.Enabled == true
                };
                u21.EnabledConnection = u20:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 85
                    -- upvalues: u21 (copy), u20 (copy), u16 (ref)
                    if u21.Applying == true then
                        return;
                    end;

                    u21.BaselineEnabled = u20.Enabled == true;
                    u16(u21);
                end);
                u21.AncestryConnection = u20.AncestryChanged:Connect(function(p22, p23) -- Line: 92
                    -- upvalues: u19 (ref), u20 (copy)
                    if p23 == nil then
                        u19(u20);
                    end;
                end);
                u3[u20] = u21;
            end;

            u16(u3[u20]);
        end;

        local function scanFrame(u24) -- Line: 102
            -- upvalues: trackPrompt (copy), u4 (copy), u3 (copy), u19 (ref)
            if not u24 then
                return;
            end;

            local v25 = u24:FindFirstChildWhichIsA("ProximityPrompt", true);

            if v25 then
                trackPrompt(v25);
            end;

            if not u4[u24] then
                u4[u24] = { u24.DescendantAdded:Connect(function(p26) -- Line: 112
                        -- upvalues: trackPrompt (ref)
                        if p26:IsA("ProximityPrompt") then
                            trackPrompt(p26);
                        end;
                    end), u24.AncestryChanged:Connect(function(p27, p28) -- Line: 117
                        -- upvalues: u4 (ref), u24 (copy), u3 (ref), u19 (ref)
                        if p28 == nil then
                            local v29 = u4[u24];

                            if v29 then
                                for _, v in ipairs(v29) do
                                    if v then
                                        v:Disconnect();
                                    end;
                                end;

                                u4[u24] = nil;
                            end;

                            for i, _ in pairs(u3) do
                                if i:IsDescendantOf(u24) then
                                    u19(i);
                                end;
                            end;
                        end;
                    end) };
            end;
        end;

        local function refreshServerDataConnection() -- Line: 137
            -- upvalues: u7 (ref), u6 (ref), Player (copy), u2 (copy)
            local v30 = u7;

            if v30 then
                v30:Disconnect();
            end;

            u7 = nil;
            u6 = Player and Player:FindFirstChild("ServerData") or nil;

            if u6 then
                u7 = u6:GetAttributeChangedSignal("Alive"):Connect(function() -- Line: 142
                    -- upvalues: u2 (ref)
                    u2.Refresh();
                end);
            end;
        end;

        function u2.Refresh() -- Line: 148
            -- upvalues: u3 (copy), u16 (ref)
            for _, v in pairs(u3) do
                u16(v);
            end;
        end;

        function u2.Destroy() -- Line: 154
            -- upvalues: u7 (ref), u3 (copy), u19 (ref), u4 (copy), u5 (copy)
            local v31 = u7;

            if v31 then
                v31:Disconnect();
            end;

            u7 = nil;

            for i, _ in pairs(u3) do
                u19(i);
            end;

            for i, v in pairs(u4) do
                for _, v2 in ipairs(v) do
                    if v2 then
                        v2:Disconnect();
                    end;
                end;

                u4[i] = nil;
            end;

            for _, v in ipairs(u5) do
                if v then
                    v:Disconnect();
                end;
            end;

            table.clear(u5);
        end;

        refreshServerDataConnection();

        for _, v in ipairs(CollectionService:GetTagged("BarricadeFrame")) do
            scanFrame(v);
        end;

        local v32 = CollectionService:GetInstanceAddedSignal("BarricadeFrame");
        table.insert(u5, v32:Connect(function(p33) -- Line: 177
            -- upvalues: scanFrame (copy), u2 (copy)
            scanFrame(p33);
            u2.Refresh();
        end));
        local v34 = CollectionService:GetInstanceRemovedSignal("BarricadeFrame");
        table.insert(u5, v34:Connect(function(p35) -- Line: 181
            -- upvalues: u4 (copy), u3 (copy), u19 (ref)
            local v36 = u4[p35];

            if v36 then
                for _, v in ipairs(v36) do
                    if v then
                        v:Disconnect();
                    end;
                end;

                u4[p35] = nil;
            end;

            for i, _ in pairs(u3) do
                if i:IsDescendantOf(p35) then
                    u19(i);
                end;
            end;
        end));
        local v37 = Camera:GetAttributeChangedSignal("FirstPersonSpectateActive");
        table.insert(u5, v37:Connect(function() -- Line: 195
            -- upvalues: u2 (copy)
            u2.Refresh();
        end));
        table.insert(u5, Player.ChildAdded:Connect(function(p38) -- Line: 198
            -- upvalues: refreshServerDataConnection (copy), u2 (copy)
            if p38.Name == "ServerData" then
                refreshServerDataConnection();
                u2.Refresh();
            end;
        end));
        table.insert(u5, Player.ChildRemoved:Connect(function(p39) -- Line: 204
            -- upvalues: u6 (ref), refreshServerDataConnection (copy), u2 (copy)
            if p39 == u6 then
                refreshServerDataConnection();
                u2.Refresh();
            end;
        end));
        u2.Refresh();

        return u2;
    end
};