
local Workspace = game:GetService("Workspace");

return {
    new = function(p1) -- Line: 5, Name: new
        -- upvalues: Workspace (copy)
        local HideSpectatedInstanceTree = p1.HideSpectatedInstanceTree;
        local ResetSpectatedInstanceTree = p1.ResetSpectatedInstanceTree;
        local u2 = {};
        local u3 = nil;
        local u4 = {};

        local function getReplayBarricadeMapRoot() -- Line: 13
            -- upvalues: Workspace (ref)
            return Workspace:FindFirstChild("Map");
        end;

        local function resolveReplayBarricade(p5) -- Line: 17
            -- upvalues: Workspace (ref)
            local Map = Workspace:FindFirstChild("Map");

            if typeof(p5) ~= "string" or (p5 == "" or not Map) then
                return nil;
            end;

            for i in string.gmatch(p5, "[^/]+") do
                if Map then
                    Map = Map:FindFirstChild(i);
                end;

                if not Map then
                    return nil;
                end;
            end;

            return Map;
        end;

        local function setReplayBarricadePlankState(p6, p7) -- Line: 31
            if not (p6 and p6:IsA("BasePart")) then
                return;
            end;

            local v8;

            if p7 then
                v8 = p7.Broken == true;
            else
                v8 = p7;
            end;

            p6:SetAttribute("ReplayBroken", v8);
            p6.Transparency = v8 and 1 or 0;
            p6.CanCollide = not v8;
            p6.CanTouch = not v8;
            p6.CanQuery = not v8;
            p6.CastShadow = not v8;

            if p6:FindFirstChildOfClass("Decal") then
                for _, child in ipairs(p6:GetChildren()) do
                    if child:IsA("Decal") then
                        child.Transparency = v8 and 1 or 0;
                    end;
                end;
            end;

            if typeof(p7) == "table" and p7.Health ~= nil then
                p6:SetAttribute("Health", p7.Health);
            end;

            p6:SetAttribute("Broken", v8);
        end;

        local function applyReplayBarricadeSnapshot(p9, p10) -- Line: 55
            -- upvalues: setReplayBarricadePlankState (copy), HideSpectatedInstanceTree (copy)
            if typeof(p10) == "table" then
                if typeof(p10.Planks) == "table" then
                    p10 = p10.Planks or p10;
                end;
            else
                p10 = nil;
            end;

            if typeof(p10) ~= "table" then
                return;
            end;

            for _, v in ipairs(p10) do
                local v11 = p9.Planks[v.Key];

                if v11 then
                    setReplayBarricadePlankState(v11, v);
                end;
            end;

            if p9.Clone then
                p9.Clone:SetAttribute("ReplaySnapshotApplied", true);
            end;

            if p9.LiveModel then
                HideSpectatedInstanceTree(p9.LiveModel);
            end;
        end;

        local function applyReplayBarricadeChanges(p12, p13) -- Line: 77
            -- upvalues: setReplayBarricadePlankState (copy), HideSpectatedInstanceTree (copy)
            if typeof(p13) ~= "table" then
                return;
            end;

            for _, v in ipairs(p13) do
                local v14 = p12.Planks[v.Key];

                if v14 then
                    setReplayBarricadePlankState(v14, v);
                end;
            end;

            if p12.LiveModel then
                HideSpectatedInstanceTree(p12.LiveModel);
            end;
        end;

        local function buildReplayBarricadePlankMap(p15) -- Line: 92
            local v16 = {};

            for _, descendant in ipairs(p15:GetDescendants()) do
                if descendant:IsA("BasePart") and descendant.Name == "BarricadePlank" then
                    local v17 = descendant:GetAttribute("Row");
                    local v18 = descendant:GetAttribute("Column");

                    if v17 ~= nil and v18 ~= nil then
                        v16[tostring(v17) .. ":" .. tostring(v18)] = descendant;
                    end;
                end;
            end;

            return v16;
        end;

        local function createReplayBarricadeEntry(p19, p20) -- Line: 106
            -- upvalues: resolveReplayBarricade (copy), u4 (copy), HideSpectatedInstanceTree (copy), u3 (ref), buildReplayBarricadePlankMap (copy), applyReplayBarricadeSnapshot (copy)
            if typeof(p20) ~= "table" then
                return nil;
            end;

            local v21;

            if typeof(p20.Path) == "string" then
                v21 = p20.Path or nil;
            else
                v21 = nil;
            end;

            if not v21 or v21 == "" then
                return nil;
            end;

            local u22 = resolveReplayBarricade(v21);

            if not (u22 and u22:IsA("Model")) then
                warn("[GameMenuReplayBarricadeController] Replay barricade source missing", v21);

                return nil;
            end;

            if u4[v21] then
                return u4[v21];
            end;

            HideSpectatedInstanceTree(u22);
            local v23 = {
                Clone = nil,
                EventCursor = 1,
                LiveModel = u22,
                Planks = {},
                Events = typeof(p20.Events) == "table" and (p20.Events or {}) or {}
            };
            u4[v21] = v23;

            if typeof(p20.InitialSnapshot) ~= "table" then
                warn("[GameMenuReplayBarricadeController] Replay barricade snapshot missing", v21);

                return v23;
            end;

            if not u3 then
                u3 = Instance.new("Folder");
                u3.Name = "ReplayBarricades";
                u3.Parent = p19;
            end;

            local success, result = pcall(function() -- Line: 144
                -- upvalues: u22 (copy), u3 (ref)
                local v24 = u22:Clone();
                v24.Name = u22.Name .. "_Replay";

                for _, descendant in ipairs(v24:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true;
                        descendant.CanCollide = false;
                        descendant.CanTouch = false;
                        descendant.CanQuery = false;
                    elseif descendant:IsA("BaseScript") or (descendant:IsA("Script") or descendant:IsA("LocalScript")) then
                        descendant:Destroy();
                    elseif descendant:IsA("ProximityPrompt") then
                        descendant.Enabled = false;
                    elseif descendant:IsA("Sound") then
                        descendant:Destroy();
                    end;
                end;

                v24.Parent = u3;

                return v24;
            end);

            if success ~= true or not result then
                warn("[GameMenuReplayBarricadeController] Replay barricade clone failed", v21, result);

                return v23;
            end;

            v23.Clone = result;
            v23.Planks = buildReplayBarricadePlankMap(result);
            applyReplayBarricadeSnapshot(v23, p20.InitialSnapshot);

            return v23;
        end;

        function u2.Clear() -- Line: 175
            -- upvalues: u4 (copy), ResetSpectatedInstanceTree (copy), u3 (ref)
            for _, v in pairs(u4) do
                if v.LiveModel then
                    ResetSpectatedInstanceTree(v.LiveModel);
                end;

                if v.Clone and v.Clone.Parent then
                    v.Clone:Destroy();
                end;

                v.LiveModel = nil;
                v.Clone = nil;
                v.Events = nil;
            end;

            if u3 then
                u3:Destroy();
                u3 = nil;
            end;

            table.clear(u4);
        end;

        function u2.Build(p25, p26) -- Line: 194
            -- upvalues: u2 (copy), createReplayBarricadeEntry (copy)
            u2.Clear();

            if p26 then
                p26 = p26.Barricades;
            end;

            if typeof(p26) ~= "table" then
                return;
            end;

            for _, v in ipairs(p26) do
                createReplayBarricadeEntry(p25, v);
            end;
        end;

        function u2.Update(p27) -- Line: 205
            -- upvalues: u4 (copy), applyReplayBarricadeChanges (copy)
            for _, v in pairs(u4) do
                local Events = v.Events;

                while v.EventCursor <= #Events do
                    local v28 = Events[v.EventCursor];

                    if not v28 or p27 < (v28.Time or 0) then
                        break;
                    end;

                    applyReplayBarricadeChanges(v, v28.ChangedPlanks);
                    v.EventCursor = v.EventCursor + 1;
                end;
            end;
        end;

        return u2;
    end
};