
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Config = require(ReplicatedStorage.Config);
require(ReplicatedStorage.Modules.TypeModules.Types);
local u10 = {
    DefaultLoadout = {
        Head = "Mafia",
        Top = "Mafia",
        Bottom = "Mafia",
        Emote = "",
        Throwable = "",
        Deployable = "",
        Vest = "",
        PrimaryWeapon = "M4A1",
        PrimarySkin = "",
        PrimarySight = "",
        PrimaryMuzzle = "",
        PrimaryGrip = "",
        PrimaryCharm = "",
        PrimaryExtra = "",
        SecondaryWeapon = "G17",
        SecondarySkin = "",
        SecondarySight = "",
        SecondaryMuzzle = "",
        SecondaryGrip = "",
        SecondaryCharm = "",
        SecondaryExtra = "",
        Banner = "",
        Title = "",
        Watch = "",
        Knife = "Bayonet"
    },

    EquipItem = function(p1, p2, p3) -- Line: 24, Name: EquipItem
        -- upvalues: Config (copy), ReplicatedStorage (copy)
        local PlayerData = p1.PlayerData;
        local v4 = PlayerData.Loadout:FindFirstChild(PlayerData.Settings:GetAttribute("LoadoutName"));

        if v4 then
            if p2 == "" and p3 == "Vest" then
                v4:SetAttribute(p3, "");
            elseif p2 ~= "" and PlayerData.Inventory:FindFirstChild(Config.GetItemIDFromItemData(p2)) then
                if ReplicatedStorage.Items[p2.Type][p2.Name]:GetAttribute("Class") == nil and (p3 ~= "Primary" and p3 ~= "Secondary") then
                    if p2.Type == "AttachmentSkin" then
                        local v5 = nil;

                        for _, child in ReplicatedStorage.Weapons:GetChildren() do
                            if child.Name == p2.Weapon then
                                v5 = child;
                                break;
                            end;
                        end;

                        if not v5 then
                            warn("No tool with the name: " .. tostring(p2.Weapon));

                            return;
                        end;

                        local v6 = v5:GetAttribute("Class");

                        if not v6 then
                            warn("Could not get class");

                            return;
                        end;

                        v4:SetAttribute(v6 .. p2.Slot .. "Skin", p2.Name);
                    else
                        v4:SetAttribute(p2.Type, p2.Name);
                    end;
                elseif p2.Type == "Weapon" then
                    local v7 = game.ReplicatedStorage.Items.Weapon[p2.Name]:GetAttribute("Class");
                    v4:SetAttribute(v7 .. p2.Type, p2.Name);
                    v4:SetAttribute(v7 .. "Skin", "");
                    v4:SetAttribute(v7 .. "Sight", "");
                    v4:SetAttribute(v7 .. "Grip", "");
                    v4:SetAttribute(v7 .. "Muzzle", "");
                    v4:SetAttribute(v7 .. "Charm", "");
                    v4:SetAttribute(v7 .. "Extra", "");
                    v4:SetAttribute(v7 .. "GripSkin", "");
                    v4:SetAttribute(v7 .. "SightSkin", "");
                    v4:SetAttribute(v7 .. "ExtraSkin", "");
                    v4:SetAttribute(v7 .. "MuzzleSkin", "");
                else
                    v4:SetAttribute(p3 .. p2.Type, p2.Name);
                end;
            end;
        end;

        ReplicatedStorage.Events.Action:FireClient(p1, "RefreshLoadout");
    end,

    ChangeLoadout = function(p8, p9) -- Line: 92, Name: ChangeLoadout
        -- upvalues: ReplicatedStorage (copy)
        if type(p9) == "string" then
            if p8.PlayerData.Loadout:FindFirstChild(p9) then
                p8.PlayerData.Settings:SetAttribute("LoadoutName", p9);
            end;

            ReplicatedStorage.Events.ChangeLoadout:FireClient(p8);
        end;
    end
};

function u10.CreateNewLoadout(p11, p12) -- Line: 106
    -- upvalues: u10 (copy)
    local StringValue = Instance.new("StringValue", p12);
    StringValue.Name = p11;
    StringValue.Value = p11;

    for i, v in pairs(u10.DefaultLoadout) do
        StringValue:SetAttribute(i, v);
    end;

    return StringValue;
end;

function u10.CheckLoadoutName(p13, p14) -- Line: 120
end;

function u10.EditLoadout(u15, p16, p17) -- Line: 124
    -- upvalues: ReplicatedStorage (copy), u10 (copy), Config (copy)
    if p16 == "Create" and #u15.PlayerData.Loadout:GetChildren() >= 30 then
        ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
            Message = "30 Max Loadouts",
            Color = Color3.fromRGB(255, 100, 100)
        });

        return;
    end;

    local function GetNextLoadoutName() -- Line: 132
        -- upvalues: u15 (copy)
        for i = 1, 30 do
            local v18 = "Loadout" .. i;

            if not u15.PlayerData.Loadout:FindFirstChild(v18) then
                return v18;
            end;
        end;

        return nil;
    end;

    if p16 ~= "Create" or type(p17) == "string" then
        if type(p17) == "string" then
            local v19 = u15.PlayerData.Settings:GetAttribute("LoadoutName");
            local v20 = Config.GetFilteredText(u15, p17);
            local v21 = string.gsub(v20, "%w", "");

            if v20 == "" or v20:sub(1, 1) == "#" then
                ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
                    Message = "Name not allowed",
                    Color = Color3.fromRGB(255, 100, 100)
                });

                return nil;
            end;

            if v21 ~= "" then
                ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
                    Message = "No special characters allowed",
                    Color = Color3.fromRGB(255, 100, 100)
                });

                return nil;
            end;

            if p16 == "Rename" or p16 == "Create" then
                local v22 = false;

                for _, child in pairs(u15.PlayerData.Loadout:GetChildren()) do
                    if child.Name == v20 then
                        v22 = true;
                    end;
                end;

                if v22 ~= false then
                    ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
                        Message = "Name already exist",
                        Color = Color3.fromRGB(255, 100, 100)
                    });

                    return;
                end;

                if p16 == "Create" then
                    u10.CreateNewLoadout(v20, u15.PlayerData.Loadout);
                    u15.PlayerData.Settings:SetAttribute("LoadoutName", v20);
                    ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
                        Message = v20 .. " has been created"
                    });

                    return;
                end;

                local v23 = u15.PlayerData.Loadout:FindFirstChild(v19);

                if v23 == nil or v23.Name == "Default" then
                    ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
                        Message = "Default loadout is locked",
                        Color = Color3.fromRGB(255, 100, 100)
                    });

                    return;
                end;

                v23.Name = v20;
                v23.Value = v20;
                u15.PlayerData.Settings:SetAttribute("LoadoutName", v20);
                ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
                    Message = "Successfully renamed"
                });

                return;
            end;

            if p16 == "Delete" then
                local v24 = u15.PlayerData.Loadout:FindFirstChild(v19);

                if v24 ~= nil and v24.Name ~= "Default" then
                    u15.PlayerData.Settings:SetAttribute("LoadoutName", "Default");
                    v24:Destroy();
                    ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
                        Message = "Loadout successfully removed"
                    });

                    return;
                end;

                ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
                    Message = "Default loadout is locked",
                    Color = Color3.fromRGB(255, 100, 100)
                });
            end;
        end;

        return;
    end;

    local v25 = GetNextLoadoutName();

    if not v25 then
        return;
    end;

    u10.CreateNewLoadout(v25, u15.PlayerData.Loadout);
    u15.PlayerData.Settings:SetAttribute("LoadoutName", v25);
    ReplicatedStorage.Events.Action:FireClient(u15, "Notification", {
        Message = v25 .. " has been created"
    });
end;

return u10;