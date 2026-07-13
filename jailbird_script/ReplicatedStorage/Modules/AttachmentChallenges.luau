
local _ = game:GetService("ReplicatedStorage").Items.AttachmentSkin;
require("./TypeModules/Types");
local v1 = {
    Sight = { {
            challengeType = "headshots",
            requirement = 10,
            skinName = "Navy"
        }, {
            challengeType = "headshots",
            requirement = 25,
            skinName = "White"
        }, {
            challengeType = "headshots",
            requirement = 50,
            skinName = "Tan"
        }, {
            challengeType = "headshots",
            requirement = 100,
            skinName = "Pink"
        }, {
            challengeType = "headshots",
            requirement = 250,
            skinName = "Purple Carbon"
        }, {
            challengeType = "headshots",
            requirement = 500,
            skinName = "Dragonscale"
        }, {
            challengeType = "headshots",
            requirement = 750,
            skinName = "Paintsplat"
        }, {
            challengeType = "headshots",
            requirement = 1000,
            skinName = "Bloodrush"
        }, {
            challengeType = "headshots",
            requirement = 1250,
            skinName = "Worn Metal"
        }, {
            challengeType = "headshots",
            requirement = 1500,
            skinName = "Red Arctic Camo"
        }, {
            challengeType = "headshots",
            requirement = 1750,
            skinName = "Astral"
        }, {
            challengeType = "headshots",
            requirement = 2000,
            skinName = "Gold"
        } },
    Grip = { {
            challengeType = "kills",
            requirement = 10,
            skinName = "Navy"
        }, {
            challengeType = "kills",
            requirement = 25,
            skinName = "White"
        }, {
            challengeType = "kills",
            requirement = 50,
            skinName = "Tan"
        }, {
            challengeType = "kills",
            requirement = 100,
            skinName = "Pink"
        }, {
            challengeType = "kills",
            requirement = 250,
            skinName = "Purple Carbon"
        }, {
            challengeType = "kills",
            requirement = 500,
            skinName = "Dragonscale"
        }, {
            challengeType = "kills",
            requirement = 750,
            skinName = "Paintsplat"
        }, {
            challengeType = "kills",
            requirement = 1000,
            skinName = "Bloodrush"
        }, {
            challengeType = "kills",
            requirement = 1250,
            skinName = "Worn Metal"
        }, {
            challengeType = "kills",
            requirement = 1500,
            skinName = "Red Arctic Camo"
        }, {
            challengeType = "kills",
            requirement = 1750,
            skinName = "Astral"
        }, {
            challengeType = "kills",
            requirement = 2000,
            skinName = "Gold"
        } },
    Muzzle = { {
            challengeType = "damage",
            requirement = 1000,
            skinName = "Navy"
        }, {
            challengeType = "damage",
            requirement = 5000,
            skinName = "White"
        }, {
            challengeType = "damage",
            requirement = 10000,
            skinName = "Tan"
        }, {
            challengeType = "damage",
            requirement = 25000,
            skinName = "Pink"
        }, {
            challengeType = "damage",
            requirement = 50000,
            skinName = "Purple Carbon"
        }, {
            challengeType = "damage",
            requirement = 75000,
            skinName = "Dragonscale"
        }, {
            challengeType = "damage",
            requirement = 100000,
            skinName = "Paintsplat"
        }, {
            challengeType = "damage",
            requirement = 125000,
            skinName = "Bloodrush"
        }, {
            challengeType = "damage",
            requirement = 150000,
            skinName = "Worn Metal"
        }, {
            challengeType = "damage",
            requirement = 200000,
            skinName = "Red Arctic Camo"
        }, {
            challengeType = "damage",
            requirement = 250000,
            skinName = "Astral"
        }, {
            challengeType = "damage",
            requirement = 300000,
            skinName = "Gold"
        } },
    Extra = { {
            challengeType = "wins",
            requirement = 5,
            skinName = "Navy"
        }, {
            challengeType = "wins",
            requirement = 10,
            skinName = "White"
        }, {
            challengeType = "wins",
            requirement = 15,
            skinName = "Tan"
        }, {
            challengeType = "wins",
            requirement = 20,
            skinName = "Pink"
        }, {
            challengeType = "wins",
            requirement = 25,
            skinName = "Purple Carbon"
        }, {
            challengeType = "wins",
            requirement = 35,
            skinName = "Dragonscale"
        }, {
            challengeType = "wins",
            requirement = 50,
            skinName = "Paintsplat"
        }, {
            challengeType = "wins",
            requirement = 65,
            skinName = "Bloodrush"
        }, {
            challengeType = "wins",
            requirement = 85,
            skinName = "Worn Metal"
        }, {
            challengeType = "wins",
            requirement = 100,
            skinName = "Red Arctic Camo"
        }, {
            challengeType = "wins",
            requirement = 125,
            skinName = "Astral"
        }, {
            challengeType = "wins",
            requirement = 150,
            skinName = "Gold"
        } }
};
table.freeze(v1.Sight);
table.freeze(v1.Grip);
table.freeze(v1.Muzzle);
table.freeze(v1.Extra);

return table.freeze(v1);