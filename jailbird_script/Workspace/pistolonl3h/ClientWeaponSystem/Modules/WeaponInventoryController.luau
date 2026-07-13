
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local WeaponSlotResolver = require(ReplicatedStorage.Modules.WeaponSlotResolver);
local u1 = {};

local function disconnectConnections(p2) -- Line: 8
    for _, v in ipairs(p2) do
        v:Disconnect();
    end;

    table.clear(p2);
end;

local function bindContainer(p3, p4, u5) -- Line: 15
    if not p4 then
        return;
    end;

    table.insert(p3, p4.ChildAdded:Connect(function(p6) -- Line: 20
        -- upvalues: u5 (copy)
        if p6:IsA("Tool") then
            u5();
        end;
    end));
    table.insert(p3, p4.ChildRemoved:Connect(function(p7) -- Line: 26
        -- upvalues: u5 (copy)
        if p7:IsA("Tool") then
            u5();
        end;
    end));
end;

function u1.GetAuthoritativeTools(p8) -- Line: 33
    -- upvalues: WeaponSlotResolver (copy)
    return WeaponSlotResolver.CollectAuthoritativeTools(p8);
end;

function u1.WatchPlayerInventory(u9, u10) -- Line: 37
    -- upvalues: u1 (copy), bindContainer (copy)
    local u11 = {};
    local u12 = {};
    local u13 = {};
    local u14 = false;

    local function emitCurrentInventory() -- Line: 43
        -- upvalues: u10 (copy), u1 (ref), u9 (copy)
        u10(u1.GetAuthoritativeTools(u9));
    end;

    local function scheduleEmitCurrentInventory() -- Line: 47
        -- upvalues: u14 (ref), u10 (copy), u1 (ref), u9 (copy)
        if u14 == true then
            return;
        end;

        u14 = true;
        task.defer(function() -- Line: 53
            -- upvalues: u14 (ref), u10 (ref), u1 (ref), u9 (ref)
            u14 = false;
            u10(u1.GetAuthoritativeTools(u9));
        end);
    end;

    local function bindCharacter(p15) -- Line: 59
        -- upvalues: u12 (copy), bindContainer (ref), scheduleEmitCurrentInventory (copy)
        local v16 = u12;

        for _, v in ipairs(v16) do
            v:Disconnect();
        end;

        table.clear(v16);
        bindContainer(u12, p15, scheduleEmitCurrentInventory);
    end;

    local function bindBackpack(p17) -- Line: 64
        -- upvalues: u13 (copy), bindContainer (ref), scheduleEmitCurrentInventory (copy)
        local v18 = u13;

        for _, v in ipairs(v18) do
            v:Disconnect();
        end;

        table.clear(v18);
        bindContainer(u13, p17, scheduleEmitCurrentInventory);
    end;

    local v19 = u9:FindFirstChildOfClass("Backpack");

    for _, v in ipairs(u13) do
        v:Disconnect();
    end;

    table.clear(u13);
    bindContainer(u13, v19, scheduleEmitCurrentInventory);
    local Character = u9.Character;

    for _, v in ipairs(u12) do
        v:Disconnect();
    end;

    table.clear(u12);
    bindContainer(u12, Character, scheduleEmitCurrentInventory);
    table.insert(u11, u9.CharacterAdded:Connect(function(p20) -- Line: 72
        -- upvalues: u12 (copy), bindContainer (ref), scheduleEmitCurrentInventory (copy), u14 (ref), u10 (copy), u1 (ref), u9 (copy)
        local v21 = u12;

        for _, v in ipairs(v21) do
            v:Disconnect();
        end;

        table.clear(v21);
        bindContainer(u12, p20, scheduleEmitCurrentInventory);

        if u14 == true then
            return;
        end;

        u14 = true;
        task.defer(function() -- Line: 53
            -- upvalues: u14 (ref), u10 (ref), u1 (ref), u9 (ref)
            u14 = false;
            u10(u1.GetAuthoritativeTools(u9));
        end);
    end));
    table.insert(u11, u9.ChildAdded:Connect(function(p22) -- Line: 77
        -- upvalues: u13 (copy), bindContainer (ref), scheduleEmitCurrentInventory (copy), u14 (ref), u10 (copy), u1 (ref), u9 (copy)
        if p22:IsA("Backpack") then
            local v23 = u13;

            for _, v in ipairs(v23) do
                v:Disconnect();
            end;

            table.clear(v23);
            bindContainer(u13, p22, scheduleEmitCurrentInventory);

            if u14 == true then
                return;
            end;

            u14 = true;
            task.defer(function() -- Line: 53
                -- upvalues: u14 (ref), u10 (ref), u1 (ref), u9 (ref)
                u14 = false;
                u10(u1.GetAuthoritativeTools(u9));
            end);
        end;
    end));
    u10(u1.GetAuthoritativeTools(u9));

    return function() -- Line: 86
        -- upvalues: u12 (copy), u13 (copy), u11 (copy)
        local v24 = u12;

        for _, v in ipairs(v24) do
            v:Disconnect();
        end;

        table.clear(v24);
        local v25 = u13;

        for _, v in ipairs(v25) do
            v:Disconnect();
        end;

        table.clear(v25);
        local v26 = u11;

        for _, v in ipairs(v26) do
            v:Disconnect();
        end;

        table.clear(v26);
    end;
end;

return u1;