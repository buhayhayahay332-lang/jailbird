
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Workspace = game:GetService("Workspace");
local Config = require(ReplicatedStorage.Config);
local u1 = { Color3.fromRGB(171, 126, 72), Color3.fromRGB(135, 98, 57), Color3.fromRGB(147, 116, 62) };
local u2 = {};
local u3 = {};
u3.__index = u3;

local function GetReplayRelativePath(p4, p5) -- Line: 35
    local v6 = {};

    while p5 and p5 ~= p4 do
        table.insert(v6, 1, p5.Name);
        p5 = p5.Parent;
    end;

    if p5 == p4 then
        return table.concat(v6, "/");
    end;

    return nil;
end;

local function GetReplayBarricadePath(p7) -- Line: 48
    -- upvalues: Workspace (copy), GetReplayRelativePath (copy)
    local Map = Workspace:FindFirstChild("Map");

    if Map then
        return GetReplayRelativePath(Map, p7);
    end;

    return nil;
end;

local function GetReplayBarricadePlankKey(p8) -- Line: 56
    if not p8 then
        return nil;
    end;

    local v9 = p8:GetAttribute("Row");
    local v10 = p8:GetAttribute("Column");

    if v9 ~= nil and v10 ~= nil then
        return tostring(v9) .. ":" .. tostring(v10);
    end;

    local v11 = p8:GetAttribute("XMin");
    local v12 = p8:GetAttribute("XMax");

    return tostring(v9 or "?") .. ":" .. tostring(v10 or "?") .. ":" .. tostring(v11 or "") .. ":" .. tostring(v12 or "");
end;

local function BuildReplayBarricadeSnapshot(p13, p14) -- Line: 70
    -- upvalues: GetReplayBarricadePlankKey (copy)
    local v15 = {};

    for _, child in ipairs(p13:GetChildren()) do
        if child:IsA("BasePart") and child.Name == "BarricadePlank" then
            local v16 = GetReplayBarricadePlankKey(child);

            if v16 then
                local v17;

                if p14 then
                    v17 = p14[v16];
                else
                    v17 = p14;
                end;

                local v18 = typeof(v17) ~= "number" and (child:GetAttribute("Health") or 0) or v17;
                table.insert(v15, {
                    Key = v16,
                    Health = v18,
                    Broken = v18 <= 0
                });
            end;
        end;
    end;

    table.sort(v15, function(p19, p20) -- Line: 88
        return tostring(p19.Key) < tostring(p20.Key);
    end);

    return v15;
end;

local function AppendReplayBarricadeStateEvent(p21, p22, p23) -- Line: 94
    -- upvalues: Workspace (copy), GetReplayRelativePath (copy)
    local ReplayKillCamService = shared.ReplayKillCamService;

    if typeof(ReplayKillCamService) ~= "table" then
        return;
    end;

    local AppendBarricadeStateEvent = ReplayKillCamService.AppendBarricadeStateEvent;

    if typeof(AppendBarricadeStateEvent) ~= "function" then
        return;
    end;

    local Map = Workspace:FindFirstChild("Map");
    local v24;

    if Map then
        v24 = GetReplayRelativePath(Map, p21);
    else
        v24 = nil;
    end;

    if typeof(v24) ~= "string" or v24 == "" then
        return;
    end;

    if typeof(p23) ~= "table" or #p23 <= 0 then
        return;
    end;

    AppendBarricadeStateEvent(v24, p22, p23);
end;

local function AppendReplayBarricadeLifecycleEvent(p25, p26, p27) -- Line: 113
    -- upvalues: Workspace (copy), GetReplayRelativePath (copy)
    local ReplayKillCamService = shared.ReplayKillCamService;

    if typeof(ReplayKillCamService) ~= "table" or typeof(p25) ~= "Instance" then
        return;
    end;

    local AppendReplayEvent = ReplayKillCamService.AppendReplayEvent;

    if typeof(AppendReplayEvent) ~= "function" then
        return;
    end;

    local Map = Workspace:FindFirstChild("Map");
    local v28;

    if Map then
        v28 = GetReplayRelativePath(Map, p26);
    else
        v28 = nil;
    end;

    if typeof(v28) ~= "string" or (v28 == "" or (typeof(p27) ~= "string" or p27 == "")) then
        return;
    end;

    AppendReplayEvent(p25, "BarricadeLifecycle", {
        BarricadePath = v28,
        Action = p27
    });
end;

local function IsMapRefreshing() -- Line: 132
    -- upvalues: Workspace (copy)
    local Map = Workspace:FindFirstChild("Map");
    local v29;

    if Map == nil then
        v29 = false;
    else
        v29 = Map:GetAttribute("__MapRefreshing") == true;
    end;

    return v29;
end;

local function ZeroCharacterVelocity(p30) -- Line: 137
    if p30 and p30:IsA("BasePart") then
        p30.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        p30.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;
end;

local function ReleaseBarricadeLock(p31, p32) -- Line: 144
    -- upvalues: u2 (copy)
    local v33 = u2[p31];

    if not v33 then
        return;
    end;

    if p32 and v33.Character ~= p32 then
        return;
    end;

    u2[p31] = nil;

    if v33.DiedConnection then
        v33.DiedConnection:Disconnect();
    end;

    if v33.AncestryConnection then
        v33.AncestryConnection:Disconnect();
    end;

    local Character = v33.Character;
    local Humanoid = v33.Humanoid;
    local RootPart = v33.RootPart;

    if RootPart and RootPart.Parent then
        RootPart.Anchored = false;

        if RootPart and RootPart:IsA("BasePart") then
            RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end;

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = v33.WalkSpeed;
        Humanoid.JumpPower = v33.JumpPower;
        Humanoid.AutoRotate = v33.AutoRotate;
    end;

    if Character and Character.Parent then
        Character:SetAttribute("Barricading", false);
    end;
end;

local function ApplyBarricadeLock(u34) -- Line: 178
    -- upvalues: ReleaseBarricadeLock (copy), u2 (copy)
    if not (u34 and u34.Character) then
        return nil;
    end;

    ReleaseBarricadeLock(u34);
    local Character = u34.Character;
    local v35 = Character:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (v35 and HumanoidRootPart) then
        return nil;
    end;

    local v36 = {
        DiedConnection = nil,
        AncestryConnection = nil,
        Character = Character,
        Humanoid = v35,
        RootPart = HumanoidRootPart,
        WalkSpeed = v35.WalkSpeed,
        JumpPower = v35.JumpPower,
        AutoRotate = v35.AutoRotate
    };
    u2[u34] = v36;
    v36.DiedConnection = v35.Died:Connect(function() -- Line: 204
        -- upvalues: ReleaseBarricadeLock (ref), u34 (copy), Character (copy)
        ReleaseBarricadeLock(u34, Character);
    end);
    v36.AncestryConnection = Character.AncestryChanged:Connect(function(p37, p38) -- Line: 207
        -- upvalues: ReleaseBarricadeLock (ref), u34 (copy), Character (copy)
        if p38 == nil then
            ReleaseBarricadeLock(u34, Character);
        end;
    end);
    Character:SetAttribute("Barricading", true);
    v35.WalkSpeed = 0;
    v35.JumpPower = 0;
    v35.AutoRotate = false;

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    HumanoidRootPart.Anchored = true;

    return v36;
end;

local function IsAlivePlank(p39) -- Line: 222
    if p39 then
        if p39.Name == "BarricadePlank" then
            p39 = (p39:GetAttribute("Health") or 0) > 0;
        else
            p39 = false;
        end;
    end;

    return p39;
end;

local function GetBarricadeHealth(p40) -- Line: 228
    local v41 = 0;

    for _, child in pairs(p40:GetChildren()) do
        if child then
            local child;

            if child.Name == "BarricadePlank" then
                child = (child:GetAttribute("Health") or 0) > 0;
            else
                child = false;
            end;
        end;

        if child then
            v41 = v41 + 1;
        end;
    end;

    return v41;
end;

local function GetBarricadePlankCount(p42) -- Line: 240
    local v43 = 0;

    for _, child in pairs(p42:GetChildren()) do
        if child.Name == "BarricadePlank" then
            v43 = v43 + 1;
        end;
    end;

    return v43;
end;

local function RangesOverlap(p44, p45, p46, p47) -- Line: 252
    if p44 == nil or (p45 == nil or (p46 == nil or p47 == nil)) then
        return false;
    end;

    local v48;

    if p44 <= p47 - 0.05 then
        v48 = p46 + 0.05 <= p45;
    else
        v48 = false;
    end;

    return v48;
end;

local function GetAlivePlanks(p49) -- Line: 261
    local v50 = {};

    for _, child in pairs(p49:GetChildren()) do
        local v51;

        if child then
            if child.Name == "BarricadePlank" then
                v51 = (child:GetAttribute("Health") or 0) > 0;
            else
                v51 = false;
            end;
        else
            v51 = child;
        end;

        if v51 then
            table.insert(v50, child);
        end;
    end;

    return v50;
end;

local function ArePlanksConnected(p52, p53) -- Line: 273
    if not (p52 and p53) then
        return false;
    end;

    if p52 == p53 then
        return false;
    end;

    local v54 = p52:GetAttribute("Row");
    local v55 = p53:GetAttribute("Row");
    local v56 = p52:GetAttribute("Column");
    local v57 = p53:GetAttribute("Column");
    local v58 = p52:GetAttribute("XMin");
    local v59 = p52:GetAttribute("XMax");
    local v60 = p53:GetAttribute("XMin");
    local v61 = p53:GetAttribute("XMax");

    if v54 == nil or v55 == nil then
        return false;
    end;

    if v54 == v55 and (v56 ~= nil and (v57 ~= nil and math.abs(v56 - v57) == 1)) then
        return true;
    end;

    if math.abs(v54 - v55) == 1 then
        local v62;

        if v58 == nil or (v59 == nil or (v60 == nil or v61 == nil)) or v58 > v61 - 0.05 then
            v62 = false;
        else
            v62 = v60 + 0.05 <= v59;
        end;

        if v62 then
            return true;
        end;
    end;

    return false;
end;

local function IsPlankFrameAnchored(p63) -- Line: 308
    local v64 = p63:GetAttribute("Column");
    local v65 = p63:GetAttribute("ColumnCount");

    if v64 == nil or v65 == nil then
        return false;
    end;

    return v64 <= 1 and true or v65 <= v64;
end;

local function GetConnectedGroup(p66, p67, p68) -- Line: 321
    -- upvalues: ArePlanksConnected (copy)
    p68[p66] = true;
    local v69 = { p66 };
    local v70 = {};

    while #v69 > 0 do
        local v71 = table.remove(v69, 1);
        table.insert(v70, v71);

        for _, v in ipairs(p67) do
            if not p68[v] and ArePlanksConnected(v71, v) then
                p68[v] = true;
                table.insert(v69, v);
            end;
        end;
    end;

    return v70;
end;

local function IsGroupAnchored(p72) -- Line: 342
    for _, v in ipairs(p72) do
        local v73 = v:GetAttribute("Column");
        local v74 = v:GetAttribute("ColumnCount");
        local v75;

        if v73 == nil or v74 == nil then
            v75 = false;
        else
            v75 = v73 <= 1 and true or v74 <= v73;
        end;

        if v75 then
            return true;
        end;
    end;

    return false;
end;

local function CheckFloatingPlanks(p76) -- Line: 352
    -- upvalues: GetAlivePlanks (copy), GetConnectedGroup (copy)
    if p76:GetAttribute("Collapsing") == true then
        return;
    end;

    if p76:GetAttribute("CheckingFloating") == true then
        return;
    end;

    p76:SetAttribute("CheckingFloating", true);

    for _ = 1, 6 do
        local v77 = GetAlivePlanks(p76);
        local v78 = {};
        local v79 = false;

        for _, v in ipairs(v77) do
            if not v78[v] then
                local v80 = GetConnectedGroup(v, v77, v78);
                local v81 = false;

                for _, v2 in ipairs(v80) do
                    local v82 = v2:GetAttribute("Column");
                    local v83 = v2:GetAttribute("ColumnCount");
                    local v84;

                    if v82 == nil or v83 == nil then
                        v84 = false;
                    else
                        v84 = v82 <= 1 and true or v83 <= v82;
                    end;

                    if v84 then
                        v81 = true;
                        break;
                    end;
                end;

                if v81 == false then
                    for _, v2 in ipairs(v80) do
                        local v85;

                        if v2 then
                            if v2.Name == "BarricadePlank" then
                                v85 = (v2:GetAttribute("Health") or 0) > 0;
                            else
                                v85 = false;
                            end;
                        else
                            v85 = v2;
                        end;

                        if v85 then
                            v2:SetAttribute("Health", 0);
                            v79 = true;
                        end;
                    end;
                end;
            end;
        end;

        if v79 == false then
            break;
        end;
    end;

    p76:SetAttribute("CheckingFloating", false);
end;

local function GetPlankAmountForLevel(p86) -- Line: 386
    local v87 = math.ceil(p86 / 2.5);
    local v88 = math.clamp(v87, 2, 5);
    local v89 = math.floor(p86 / 1.1);
    local v90 = math.clamp(v89, v88, 5);

    if v90 <= v88 then
        return v88;
    end;

    return math.random(v88, v90);
end;

local function GeneratePlankLengths(p91, p92) -- Line: 400
    local v93 = math.min(1.1, p91 / p92 * 0.75);
    local v94 = {};

    for i = 1, p92 do
        local v95 = p92 - i + 1;

        if v95 == 1 then
            table.insert(v94, p91);

            return v94;
        end;

        local v96 = math.max(v93, p91 - (v95 - 1) * 2.5);
        local v97 = math.min(2.5, p91 - (v95 - 1) * v93);

        if v97 < v96 then
            v97 = v96;
        end;

        local v98 = p91 / v95 * (1 + math.random(-25, 25) / 100);
        local v99 = math.clamp(v98, v96, v97) * 100 + 0.5;
        local v100 = math.floor(v99) / 100;
        table.insert(v94, v100);
        p91 = p91 - v100;
    end;

    return v94;
end;

local function SetupBlockingPort(u101) -- Line: 434
    -- upvalues: ReplicatedStorage (copy)
    if not u101 then
        return;
    end;

    if u101:GetAttribute("BlockSetup") == true then
        return;
    end;

    u101:SetAttribute("BlockSetup", true);
    local Size = u101.Size;
    local Server = ReplicatedStorage:FindFirstChild("Server");

    if not Server then
        return;
    end;

    local u102 = 0;

    local function RemoveBlock() -- Line: 446
        -- upvalues: u101 (copy), Size (copy)
        if not u101 then
            return;
        end;

        if not u101.Parent then
            return;
        end;

        u101.CanCollide = false;
        u101.Transparency = 1;
        u101.Size = Size;
    end;

    local function OnPhaseChanged() -- Line: 455
        -- upvalues: u102 (ref), Server (copy), u101 (copy), Size (copy)
        u102 = u102 + 1;
        local u103 = u102;

        if Server:GetAttribute("Phase") == "Round Started" then
            task.delay(3, function() -- Line: 459
                -- upvalues: u103 (copy), u102 (ref), u101 (ref), Server (ref), Size (ref)
                if u103 ~= u102 then
                    return;
                end;

                if not (u101 and u101.Parent) then
                    return;
                end;

                if Server:GetAttribute("Phase") ~= "Round Started" then
                    return;
                end;

                if not u101 then
                    return;
                end;

                if not u101.Parent then
                    return;
                end;

                u101.CanCollide = false;
                u101.Transparency = 1;
                u101.Size = Size;
            end);
        end;
    end;

    u101.CanCollide = true;
    u101.Transparency = 0.5;
    u101.Color = Color3.fromRGB(255, 150, 150);
    u101.Material = Enum.Material.ForceField;
    u101.Size = Size + Vector3.new(0.2, 0.2, 0);
    u102 = u102 + 1;
    local u104 = u102;

    if Server:GetAttribute("Phase") == "Round Started" then
        task.delay(3, function() -- Line: 459
            -- upvalues: u104 (copy), u102 (ref), u101 (copy), Server (copy), Size (copy)
            if u104 ~= u102 then
                return;
            end;

            if not (u101 and u101.Parent) then
                return;
            end;

            if Server:GetAttribute("Phase") ~= "Round Started" then
                return;
            end;

            if not u101 then
                return;
            end;

            if not u101.Parent then
                return;
            end;

            u101.CanCollide = false;
            u101.Transparency = 1;
            u101.Size = Size;
        end);
    end;

    Server:GetAttributeChangedSignal("Phase"):Connect(OnPhaseChanged);
end;

local function SetupPlank(u105, u106, u107) -- Line: 478
    -- upvalues: Workspace (copy), GetReplayBarricadePlankKey (copy), BuildReplayBarricadeSnapshot (copy), AppendReplayBarricadeStateEvent (copy), Config (copy), GetBarricadeHealth (copy), CheckFloatingPlanks (copy), u1 (copy)
    local u108 = u105:GetAttribute("Health") or 0;
    u105:GetAttributeChangedSignal("Health"):Connect(function() -- Line: 480
        -- upvalues: u105 (copy), Workspace (ref), GetReplayBarricadePlankKey (ref), u108 (ref), BuildReplayBarricadeSnapshot (ref), u106 (copy), AppendReplayBarricadeStateEvent (ref), u107 (copy), Config (ref), GetBarricadeHealth (ref), CheckFloatingPlanks (ref), u1 (ref)
        local v109 = u105:GetAttribute("Health");

        if v109 == nil then
            return;
        end;

        local Map = Workspace:FindFirstChild("Map");
        local v110;

        if Map == nil then
            v110 = false;
        else
            v110 = Map:GetAttribute("__MapRefreshing") == true;
        end;

        local v111 = GetReplayBarricadePlankKey(u105);

        if v110 ~= true and (v111 and u108 ~= v109) then
            AppendReplayBarricadeStateEvent(u106, BuildReplayBarricadeSnapshot(u106, {
                [v111] = u108
            }), {
                {
                    Key = v111,
                    Health = v109,
                    Broken = v109 <= 0
                }
            });
        end;

        u108 = v109;

        if v109 > 0 then
            if v109 >= 3 then
                u105:SetAttribute("Broken", false);
                u105.Transparency = 0;
                u105.CanCollide = true;
                u105.Color = u1[math.random(1, #u1)];

                if v110 == true then
                    return;
                end;
            end;

            return;
        end;

        if u105:GetAttribute("Broken") == true then
            u105.Transparency = 1;
            u105.CanCollide = false;

            return;
        end;

        u105:SetAttribute("Broken", true);
        u105.Transparency = 1;
        u105.CanCollide = false;

        if v110 == true then
            return;
        end;

        if u106:GetAttribute("SilentPlankBreak") == true then
            u107:Emit(3);
        else
            u107:Emit(6);
            Config.AddSound("Barricade_Plank" .. math.random(1, 3), 1, true, u105, false);
        end;

        if u106:GetAttribute("Health") > 0 then
            u106:SetAttribute("Health", (GetBarricadeHealth(u106)));
        end;

        task.defer(function() -- Line: 525
            -- upvalues: u106 (ref), CheckFloatingPlanks (ref)
            if u106 and u106.Parent then
                CheckFloatingPlanks(u106);
            end;
        end);
    end);
end;

function u3.new(p112) -- Line: 546
    -- upvalues: u3 (copy)
    local v113 = setmetatable({}, u3);
    v113.Instance = p112;
    v113.Block = p112:GetAttribute("Block");
    v113.PreBarricade = p112:GetAttribute("PreBarricade");
    v113.BarricadePort = p112:WaitForChild("BarricadePort");

    return v113;
end;

function u3.Init(p114) -- Line: 556
    p114:Setup();
end;

function u3.Setup(p115) -- Line: 560
    -- upvalues: GeneratePlankLengths (copy), u1 (copy), Workspace (copy), GetReplayBarricadePlankKey (copy), BuildReplayBarricadeSnapshot (copy), AppendReplayBarricadeStateEvent (copy), Config (copy), GetBarricadeHealth (copy), CheckFloatingPlanks (copy), AppendReplayBarricadeLifecycleEvent (copy), ReleaseBarricadeLock (copy), ApplyBarricadeLock (copy), CollectionService (copy), ReplicatedStorage (copy), SetupBlockingPort (copy)
    local BarricadePort = p115.Instance:FindFirstChild("BarricadePort");

    if not BarricadePort then
        return;
    end;

    local X = BarricadePort.Size.X;
    local Y = BarricadePort.Size.Y;
    local Model = Instance.new("Model");
    Model.Name = "Barricade";
    Model.Parent = p115.Instance;
    local v116 = math.ceil(Y / 1.2);

    for i = 1, math.max(1, v116) do
        local v117 = math.ceil(X / 2.5);
        local v118 = math.clamp(v117, 2, 5);
        local v119 = math.floor(X / 1.1);
        local v120 = math.clamp(v119, v118, 5);

        if v120 > v118 then
            v118 = math.random(v118, v120);
        end;

        local v121 = GeneratePlankLengths(X, v118);
        local v122 = -(X / 2);

        for i2 = 1, v118 do
            local v123 = v121[i2];
            local Part = Instance.new("Part");
            Part.Name = "BarricadePlank";
            Part.Anchored = true;
            Part.Material = Enum.Material.WoodPlanks;
            Part.Color = u1[math.random(1, #u1)];
            Part.Size = Vector3.new(v123, 1.2, 0.3);
            Part.Transparency = 1;
            Part.CanCollide = false;
            Part.Position = Vector3.new(v122 + v123 / 2, (i - 1) * 1.2 + 0.6, 0);
            local v124 = math.random(-10, 10) / 10;
            Part.Rotation = Vector3.new(0, v124, 0);
            Part.Parent = Model;
            Part:SetAttribute("Health", 0);
            Part:SetAttribute("Broken", true);
            Part:SetAttribute("Row", i);
            Part:SetAttribute("Column", i2);
            Part:SetAttribute("ColumnCount", v118);
            Part:SetAttribute("XMin", v122);
            Part:SetAttribute("XMax", v122 + v123);
            local u125 = script.Plank_Break:Clone();
            u125.Parent = Part;
            local u126 = Part:GetAttribute("Health") or 0;
            Part:GetAttributeChangedSignal("Health"):Connect(function() -- Line: 480
                -- upvalues: Part (copy), Workspace (ref), GetReplayBarricadePlankKey (ref), u126 (ref), BuildReplayBarricadeSnapshot (ref), Model (copy), AppendReplayBarricadeStateEvent (ref), u125 (copy), Config (ref), GetBarricadeHealth (ref), CheckFloatingPlanks (ref), u1 (ref)
                local v127 = Part:GetAttribute("Health");

                if v127 == nil then
                    return;
                end;

                local Map = Workspace:FindFirstChild("Map");
                local v128;

                if Map == nil then
                    v128 = false;
                else
                    v128 = Map:GetAttribute("__MapRefreshing") == true;
                end;

                local v129 = GetReplayBarricadePlankKey(Part);

                if v128 ~= true and (v129 and u126 ~= v127) then
                    AppendReplayBarricadeStateEvent(Model, BuildReplayBarricadeSnapshot(Model, {
                        [v129] = u126
                    }), {
                        {
                            Key = v129,
                            Health = v127,
                            Broken = v127 <= 0
                        }
                    });
                end;

                u126 = v127;

                if v127 > 0 then
                    if v127 >= 3 then
                        Part:SetAttribute("Broken", false);
                        Part.Transparency = 0;
                        Part.CanCollide = true;
                        Part.Color = u1[math.random(1, #u1)];

                        if v128 == true then
                            return;
                        end;
                    end;

                    return;
                end;

                if Part:GetAttribute("Broken") == true then
                    Part.Transparency = 1;
                    Part.CanCollide = false;

                    return;
                end;

                Part:SetAttribute("Broken", true);
                Part.Transparency = 1;
                Part.CanCollide = false;

                if v128 == true then
                    return;
                end;

                if Model:GetAttribute("SilentPlankBreak") == true then
                    u125:Emit(3);
                else
                    u125:Emit(6);
                    Config.AddSound("Barricade_Plank" .. math.random(1, 3), 1, true, Part, false);
                end;

                if Model:GetAttribute("Health") > 0 then
                    Model:SetAttribute("Health", (GetBarricadeHealth(Model)));
                end;

                task.defer(function() -- Line: 525
                    -- upvalues: Model (ref), CheckFloatingPlanks (ref)
                    if Model and Model.Parent then
                        CheckFloatingPlanks(Model);
                    end;
                end);
            end);
            v122 = v122 + v123;
        end;
    end;

    local Part = Instance.new("Part");
    Part.Name = "Core";
    Part.Anchored = true;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Position = Vector3.new(0, Y / 2, 0);
    Part.CanCollide = false;
    Part.Parent = Model;
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.MaxActivationDistance = 4;
    ProximityPrompt.ActionText = "Barricade";
    ProximityPrompt.ObjectText = "Door Frame";
    ProximityPrompt.HoldDuration = 4.7;
    ProximityPrompt.Enabled = true;
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.F;
    ProximityPrompt.UIOffset = Vector2.new(0, -2);
    ProximityPrompt.Parent = Part;
    BarricadePort:SetAttribute("CanVault", true);
    local u130 = Config.Audio.Barricade_Building:Clone();
    u130.Parent = Part;
    ProximityPrompt.Triggered:Connect(function(p131) -- Line: 645
        -- upvalues: Config (ref), Part (copy), Model (copy), AppendReplayBarricadeLifecycleEvent (ref), ReleaseBarricadeLock (ref), u130 (copy)
        if not p131 then
            return;
        end;

        if not p131:FindFirstChild("ServerData") then
            return;
        end;

        if p131.ServerData:GetAttribute("Alive") ~= true then
            return;
        end;

        Config.AddSound("Barricade_Build", 1, false, Part, false);
        Model:SetAttribute("Health", Model:GetAttribute("MaxHealth"));
        AppendReplayBarricadeLifecycleEvent(p131, Model, "BuildComplete");
        AppendReplayBarricadeLifecycleEvent(p131, Model, "HoldEnd");
        ReleaseBarricadeLock(p131, p131.Character);

        if u130 then
            u130:Stop();
        end;
    end);
    ProximityPrompt.PromptButtonHoldBegan:Connect(function(p132) -- Line: 660
        -- upvalues: ApplyBarricadeLock (ref), AppendReplayBarricadeLifecycleEvent (ref), Model (copy), u130 (copy)
        if not p132 then
            return;
        end;

        if not p132.Character then
            return;
        end;

        if not p132:FindFirstChild("ServerData") then
            return;
        end;

        if p132.ServerData:GetAttribute("Alive") ~= true then
            return;
        end;

        ApplyBarricadeLock(p132);
        AppendReplayBarricadeLifecycleEvent(p132, Model, "HoldStart");

        if u130 and u130.IsPlaying == false then
            u130:Play();
        end;
    end);
    ProximityPrompt.PromptButtonHoldEnded:Connect(function(p133) -- Line: 674
        -- upvalues: ReleaseBarricadeLock (ref), u130 (copy)
        if not p133 then
            return;
        end;

        ReleaseBarricadeLock(p133, p133.Character);

        if u130 then
            u130:Stop();
        end;
    end);
    local v134 = 0;

    for _, child in pairs(Model:GetChildren()) do
        if child.Name == "BarricadePlank" then
            v134 = v134 + 1;
        end;
    end;

    Model:SetAttribute("MaxHealth", v134);
    Model:SetAttribute("Health", 0);
    Model:SetAttribute("Collapsing", false);
    Model:SetAttribute("SilentPlankBreak", false);
    Model:SetAttribute("CheckingFloating", false);
    Model.PrimaryPart = Part;
    Model:SetPrimaryPartCFrame(p115.BarricadePort.CFrame);
    Model:GetAttributeChangedSignal("Health"):Connect(function() -- Line: 692
        -- upvalues: Model (copy), ProximityPrompt (copy), CollectionService (ref), BarricadePort (copy), Workspace (ref), Config (ref), Part (copy)
        local v135 = Model:GetAttribute("MaxHealth");
        local v136 = Model:GetAttribute("Health");

        if not v135 or v135 <= 0 then
            return;
        end;

        if v136 == nil then
            return;
        end;

        if v136 <= 0 then
            ProximityPrompt.Enabled = true;

            if CollectionService:HasTag(BarricadePort, "Window") then
                BarricadePort:SetAttribute("CanVault", true);
            end;

            return;
        end;

        local Map = Workspace:FindFirstChild("Map");
        local v137;

        if Map == nil then
            v137 = false;
        else
            v137 = Map:GetAttribute("__MapRefreshing") == true;
        end;

        if not v137 then
            if v136 / v135 * 100 <= 50 then
                if Model:GetAttribute("Collapsing") == true then
                    return;
                end;

                Model:SetAttribute("Collapsing", true);
                Model:SetAttribute("SilentPlankBreak", true);
                Model:SetAttribute("Health", 0);
                Config.AddSound("Barricade_Break", 1, false, Part, false);

                for _, child in pairs(Model:GetChildren()) do
                    if child.Name == "BarricadePlank" and (child:GetAttribute("Health") or 0) ~= 0 then
                        child:SetAttribute("Health", 0);
                    end;
                end;

                Model:SetAttribute("SilentPlankBreak", false);
                Model:SetAttribute("Collapsing", false);
                ProximityPrompt.Enabled = true;

                if CollectionService:HasTag(BarricadePort, "Window") then
                    BarricadePort:SetAttribute("CanVault", true);

                    return;
                end;
            elseif v136 == v135 then
                Model:SetAttribute("Collapsing", false);
                Model:SetAttribute("SilentPlankBreak", false);
                Model:SetAttribute("CheckingFloating", false);

                for _, child in pairs(Model:GetChildren()) do
                    if child.Name == "BarricadePlank" then
                        child:SetAttribute("Health", 3);
                    end;
                end;

                ProximityPrompt.Enabled = false;

                if CollectionService:HasTag(BarricadePort, "Window") then
                    BarricadePort:SetAttribute("CanVault", false);
                end;
            end;

            return;
        end;

        ProximityPrompt.Enabled = false;

        if CollectionService:HasTag(BarricadePort, "Window") then
            BarricadePort:SetAttribute("CanVault", false);
        end;
    end);

    if p115.PreBarricade == true and (ReplicatedStorage:FindFirstChild("Server") and ReplicatedStorage.Server:GetAttribute("GameMode") == "Campaign" and 0 or 10) >= math.random(1, 10) then
        task.wait();
        ProximityPrompt.Enabled = false;

        if CollectionService:HasTag(BarricadePort, "Window") then
            BarricadePort:SetAttribute("CanVault", false);
        end;

        Model:SetAttribute("Health", Model:GetAttribute("MaxHealth"));
    end;

    if p115.Block == true then
        SetupBlockingPort(BarricadePort);
    end;
end;

function GetActionPosition(p138, p139)
    local v140 = p139.Position + p139.CFrame.LookVector * 2;
    local v141 = (1 / 0);

    for _, v in pairs({ v140, p139.Position - p139.CFrame.LookVector * 2 }) do
        if p138.Character and (p138.Character.PrimaryPart and (p138.Character.PrimaryPart.Position - v).Magnitude < v141) then
            v141 = (p138.Character.PrimaryPart.Position - v).Magnitude;
            v140 = v;
        end;
    end;

    return v140;
end;

return u3;