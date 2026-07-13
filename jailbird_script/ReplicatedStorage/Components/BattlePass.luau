
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u7 = {
    Season = 5,
    FillPattern = { "Skin", "Skin", "Skin", "Skin", "Currency" },
    FreeLoot = { {
            Name = "Orange Striped",
            Type = "Skin"
        }, {
            Name = "Scuffed Metal",
            Type = "Skin"
        }, {
            Name = "Navy",
            Type = "Skin"
        }, {
            Name = "Red Zone",
            Type = "Skin"
        }, {
            Name = "Cyberwave",
            Type = "Skin"
        }, {
            Name = "Cash",
            Type = "Cash",
            Amount = "300"
        } },
    PremiumLoot = { {
            Name = "Digital Cloud",
            Type = "Skin"
        }, {
            Name = "Neon Topography",
            Type = "Skin"
        }, {
            Name = "Candy Crystal",
            Type = "Skin"
        }, {
            Name = "Dark Topography",
            Type = "Skin"
        }, {
            Name = "Purplewave",
            Type = "Skin"
        }, {
            Name = "Cash",
            Type = "Cash",
            Amount = "300"
        }, {
            Name = "Credit",
            Type = "Credit",
            Amount = "50"
        } },

    GetPreAssignedFree = function() -- Line: 51, Name: GetPreAssignedFree
        return {
            [3] = {
                Name = "SWAT",
                Type = "Title"
            },
            [10] = {
                Name = "Inmate 247363",
                Type = "Bottom"
            },
            [17] = {
                Name = "Inmate 247363",
                Type = "Top"
            },
            [22] = {
                Name = "Handcuffs",
                Type = "Charm"
            },
            [27] = {
                Name = "Inmate 247363",
                Type = "Head"
            },
            [42] = {
                Name = "Inmate 142",
                Type = "Bottom"
            },
            [49] = {
                Name = "Inmate 142",
                Type = "Top"
            },
            [55] = {
                Name = "Neo-Pol",
                Type = "Banner"
            },
            [62] = {
                Name = "Inmate 142",
                Type = "Head"
            },
            [69] = {
                Name = "Sheriff",
                Type = "Bottom"
            },
            [82] = {
                Name = "SWAT Helmet",
                Type = "Charm"
            },
            [87] = {
                Name = "Sheriff",
                Type = "Top"
            },
            [98] = {
                Name = "Jailbroken",
                Type = "Banner"
            },
            [112] = {
                Name = "Sheriff",
                Type = "Head"
            },
            [135] = {
                Name = "Lieutenant",
                Type = "Head"
            },
            [138] = {
                Name = "Taser",
                Type = "Charm"
            },
            [144] = {
                Name = "Lieutenant",
                Type = "Bottom"
            },
            [147] = {
                Name = "Lieutenant",
                Type = "Top"
            }
        };
    end,

    GetPreAssignedPremium = function() -- Line: 76, Name: GetPreAssignedPremium
        return {
            [5] = {
                Name = "Officer Bacon",
                Type = "Bottom"
            },
            [9] = {
                Name = "Neon Topography",
                Type = "Banner"
            },
            [12] = {
                Name = "Officer Bacon",
                Type = "Top"
            },
            [15] = {
                Name = "Criminal",
                Type = "Title"
            },
            [22] = {
                Name = "Officer Bacon",
                Type = "Head"
            },
            [35] = {
                Name = "Ulitsa",
                Type = "Banner"
            },
            [42] = {
                Name = "Ulitsa",
                Type = "Bottom"
            },
            [50] = {
                Name = "Chibi Soldier",
                Type = "Charm"
            },
            [54] = {
                Name = "Ulitsa",
                Type = "Top"
            },
            [62] = {
                Name = "Ulitsa",
                Type = "Head"
            },
            [75] = {
                Name = "Inmate",
                Type = "Head"
            },
            [100] = {
                Name = "Jailed Bird",
                Type = "Charm"
            },
            [109] = {
                Name = "Inmate",
                Type = "Bottom"
            },
            [116] = {
                Name = "Inmate",
                Type = "Top"
            },
            [125] = {
                Name = "SWAT",
                Type = "Bottom"
            },
            [130] = {
                Name = "SWAT",
                Type = "Top"
            },
            [135] = {
                Name = "SWAT",
                Type = "Head"
            },
            [139] = {
                Name = "Chibi Soldier",
                Type = "Charm"
            },
            [145] = {
                Name = "Yakuza",
                Type = "Bottom"
            },
            [152] = {
                Name = "Yakuza",
                Type = "Top"
            },
            [156] = {
                Name = "Break Out",
                Type = "Title"
            },
            [159] = {
                Name = "Yakuza",
                Type = "Head"
            }
        };
    end,

    GetWeaponList = function() -- Line: 113, Name: GetWeaponList
        -- upvalues: ReplicatedStorage (copy)
        local v1 = ReplicatedStorage:WaitForChild("Items"):WaitForChild("Weapon"):GetChildren();
        table.sort(v1, function(p2, p3) -- Line: 117
            return p2.Name:byte() < p3.Name:byte();
        end);
        local v4 = {};

        for _, v in pairs(v1) do
            v4[#v4 + 1] = v.Name;
        end;

        return v4;
    end,

    FindNextAvailableSlotIndex = function(p5) -- Line: 129, Name: FindNextAvailableSlotIndex
        local v6 = 0;

        repeat
            v6 = v6 + 1;
        until p5[v6] == nil;

        return v6;
    end
};

function u7.FillRewards(p8, p9) -- Line: 146
    -- upvalues: u7 (copy)
    local v10 = u7.GetWeaponList();

    for _, v in ipairs(p9) do
        if v.Type == "Skin" then
            local v11 = 1;

            while v11 < #v10 do
                for _, v2 in pairs(u7.FillPattern) do
                    if v2 == "Skin" and v11 <= #v10 then
                        p8[u7.FindNextAvailableSlotIndex(p8)] = {
                            Name = v.Name,
                            Type = v.Type,
                            Weapon = v10[v11]
                        };
                        v11 = v11 + 1;
                    elseif v2 == "Currency" then
                        for _, v3 in pairs(p9) do
                            if v3.Type == "Cash" or v3.Type == "Credit" then
                                local v12 = u7.FindNextAvailableSlotIndex(p8);
                                p8[v12] = v3;
                                p8[v12].ID = "S" .. u7.Season .. v12;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function u7.GetBattlePassIndex() -- Line: 188
    -- upvalues: u7 (copy)
    local v13 = u7.GetPreAssignedPremium();
    u7.FillRewards(v13, u7.PremiumLoot);
    local v14 = u7.GetPreAssignedFree();
    u7.FillRewards(v14, u7.FreeLoot);

    return {
        Free = v14,
        Premium = v13
    };
end;

return u7;