
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
require(ReplicatedStorage.Modules.TypeModules.Types);
local u1 = {};
local u2 = { "Primary", "Secondary", "Knife", "Throwable" };
local u3 = {
    Primary = 1,
    Secondary = 2,
    Knife = 3,
    Throwable = 4
};
local u4 = {
    EquippedSlot = "",
    EquippedToolSerial = "",
    EquippedToolName = "",
    CurrentActionState = "Hold",
    Aiming = false,
    Inspecting = false,
    Reloading = false,
    Holstered = true,
    VaultActive = false,
    CrosshairStyle = "Dot",
    CrosshairSizeX = 3,
    CrosshairSizeY = 3,
    CrosshairMinSpread = 0,
    CrosshairFollowMouse = false,
    ThrowablePreviewActive = false,
    ThrowablePreviewToolName = "",
    PendingRequestId = "",
    SwapInProgress = false,
    WeaponPresentationReady = false,
    WeaponFullyReady = false,
    WeaponReady = false,
    InitialEquipReady = false
};

local function isWeaponTool(p5) -- Line: 48
    local v6;

    if p5 == nil then
        v6 = false;
    else
        v6 = p5:IsA("Tool") and typeof(p5:GetAttribute("Class")) == "string";
    end;

    return v6;
end;

local function isAuthoritativeParent(p7) -- Line: 52
    if p7 then
        return p7:IsA("Backpack") or p7:IsA("Model");
    end;

    return false;
end;

function u1.GetSupportedSlots() -- Line: 60
    -- upvalues: u2 (copy)
    return table.clone(u2);
end;

function u1.GetClassFromIndex(p8) -- Line: 64
    -- upvalues: u2 (copy)
    return u2[p8];
end;

function u1.GetIndexFromClass(p9) -- Line: 68
    -- upvalues: u3 (copy)
    if p9 then
        return u3[p9];
    end;

    return nil;
end;

function u1.IsSupportedSlot(p10) -- Line: 76
    -- upvalues: u1 (copy)
    return u1.GetIndexFromClass(p10) ~= nil;
end;

function u1.GetToolClass(p11) -- Line: 80
    -- upvalues: u1 (copy)
    if not p11 then
        return nil;
    end;

    local v12 = p11:GetAttribute("Class");

    if typeof(v12) ~= "string" then
        return nil;
    end;

    if u1.IsSupportedSlot(v12) == true then
        return v12;
    end;

    return nil;
end;

function u1.GetToolSerial(p13) -- Line: 97
    if not p13 then
        return nil;
    end;

    local v14 = p13:GetAttribute("ToolSerial");

    if typeof(v14) == "string" and v14 ~= "" then
        return v14;
    end;

    return nil;
end;

function u1.GetOrAssignToolSerial(p15) -- Line: 110
    -- upvalues: u1 (copy), Config (copy)
    local v16 = u1.GetToolSerial(p15);

    if v16 then
        return v16;
    end;

    local v17 = Config.CreateRandomSerialID();
    p15:SetAttribute("ToolSerial", v17);

    return v17;
end;

function u1.ResolveClientWeaponSystem(p18) -- Line: 121
    if not p18 then
        return nil;
    end;

    local ClientWeaponSystem = p18:FindFirstChild("ClientWeaponSystem");

    if ClientWeaponSystem and ClientWeaponSystem:IsA("LocalScript") then
        return ClientWeaponSystem;
    end;

    return nil;
end;

function u1.EnsureRuntimeFolders(p19) -- Line: 134
    -- upvalues: u1 (copy), u4 (copy)
    local v20 = u1.ResolveClientWeaponSystem(p19);

    if not v20 then
        return nil, nil, nil;
    end;

    local State = v20:FindFirstChild("State");

    if not State then
        State = Instance.new("Folder");
        State.Name = "State";
        State.Parent = v20;
    end;

    local ServerModels = v20:FindFirstChild("ServerModels");

    if not ServerModels then
        ServerModels = Instance.new("Folder");
        ServerModels.Name = "ServerModels";
        ServerModels.Parent = v20;
    end;

    for i, v in pairs(u4) do
        if State:GetAttribute(i) == nil then
            State:SetAttribute(i, v);
        end;
    end;

    return v20, State, ServerModels;
end;

function u1.GetStateFolder(p21) -- Line: 163
    -- upvalues: u1 (copy)
    local v22 = u1.ResolveClientWeaponSystem(p21);

    if not v22 then
        return nil;
    end;

    local State = v22:FindFirstChild("State");

    if State and State:IsA("Folder") then
        return State;
    end;

    return nil;
end;

function u1.GetServerModelsFolder(p23) -- Line: 177
    -- upvalues: u1 (copy)
    local v24 = u1.ResolveClientWeaponSystem(p23);

    if not v24 then
        return nil;
    end;

    local ServerModels = v24:FindFirstChild("ServerModels");

    if ServerModels and ServerModels:IsA("Folder") then
        return ServerModels;
    end;

    return nil;
end;

function u1.CollectAuthoritativeTools(p25) -- Line: 191
    -- upvalues: u1 (copy)
    local u26 = {};
    local u27 = {};
    local Character = p25.Character;
    local v28 = p25:FindFirstChildOfClass("Backpack");

    local function considerTool(p29) -- Line: 197
        -- upvalues: u1 (ref), u27 (copy), Character (copy), u26 (copy)
        local v30 = u1.GetToolClass(p29);

        if not v30 then
            return;
        end;

        local Parent = p29.Parent;
        local v31;

        if Parent then
            v31 = Parent:IsA("Backpack") or Parent:IsA("Model");
        else
            v31 = false;
        end;

        if v31 ~= true then
            return;
        end;

        local v32 = u1.GetOrAssignToolSerial(p29);
        local v33 = u27[v32];

        if v33 and v33.Parent == Character then
            return;
        end;

        if p29.Parent == Character or v33 == nil then
            u27[v32] = p29;
            u26[v30] = p29;
        end;
    end;

    if v28 then
        for _, child in ipairs(v28:GetChildren()) do
            if child:IsA("Tool") then
                considerTool(child);
            end;
        end;
    end;

    if Character then
        for _, child in ipairs(Character:GetChildren()) do
            if child:IsA("Tool") then
                considerTool(child);
            end;
        end;
    end;

    return u26;
end;

function u1.ResolveToolByClass(p34, p35) -- Line: 238
    -- upvalues: u1 (copy)
    return u1.CollectAuthoritativeTools(p34)[p35];
end;

function u1.ResolveEquippedTool(p36) -- Line: 242
    -- upvalues: u1 (copy)
    local Character = p36.Character;

    if not Character then
        return nil;
    end;

    for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("Tool") and u1.GetToolClass(child) ~= nil then
            u1.GetOrAssignToolSerial(child);

            return child;
        end;
    end;

    local v37 = u1.GetStateFolder(Character);

    if v37 then
        v37 = v37:GetAttribute("EquippedSlot");
    end;

    if typeof(v37) == "string" and v37 ~= "" then
        return u1.ResolveToolByClass(p36, v37);
    end;

    return nil;
end;

function u1.FindToolBySerial(p38, p39) -- Line: 264
    -- upvalues: u1 (copy)
    if typeof(p39) ~= "string" or p39 == "" then
        return nil;
    end;

    local v40 = p38:FindFirstChildOfClass("Backpack");

    if v40 then
        for _, child in ipairs(v40:GetChildren()) do
            if child:IsA("Tool") and u1.GetOrAssignToolSerial(child) == p39 then
                return child;
            end;
        end;
    end;

    local Character = p38.Character;

    if Character then
        for _, child in ipairs(Character:GetChildren()) do
            if child:IsA("Tool") and u1.GetOrAssignToolSerial(child) == p39 then
                return child;
            end;
        end;
    end;

    return nil;
end;

function u1.FindToolByName(p41, p42) -- Line: 290
    -- upvalues: u1 (copy)
    if typeof(p42) ~= "string" or p42 == "" then
        return nil;
    end;

    local v43 = u1.CollectAuthoritativeTools(p41);

    for _, v in pairs(v43) do
        if v.Name == p42 then
            return v;
        end;
    end;

    return nil;
end;

function u1.ResolveVisibleModel(p44, p45) -- Line: 305
    -- upvalues: u1 (copy)
    if not p44 or (typeof(p45) ~= "string" or p45 == "") then
        return nil;
    end;

    local v46 = u1.GetServerModelsFolder(p44);

    if not v46 then
        return nil;
    end;

    local v47 = v46:FindFirstChild(p45);

    if v47 and v47:IsA("Model") then
        return v47;
    end;

    for _, child in ipairs(v46:GetChildren()) do
        if child:IsA("Model") and child:GetAttribute("ToolName") == p45 then
            return child;
        end;
    end;

    return nil;
end;

function u1.UpdateStateFolder(p48, p49) -- Line: 329
    if not p48 then
        return;
    end;

    for i, v in pairs(p49) do
        if p48:GetAttribute(i) ~= v then
            p48:SetAttribute(i, v);
        end;
    end;
end;

return table.freeze(u1);