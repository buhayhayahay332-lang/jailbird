
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BattlePass = require(ReplicatedStorage.Components.BattlePass);
local Gamepasses = require(ReplicatedStorage.Components.Gamepasses);
local u1 = {};

local function getEntryKey(p2, p3) -- Line: 463
    return string.format("%s:%s", tostring(p3), (tostring(p2)));
end;

local function addReservedItem(p4) -- Line: 467
    -- upvalues: u1 (copy)
    if typeof(p4) ~= "table" or not (p4.Name and p4.Type) then
        return;
    end;

    local Name = p4.Name;
    u1[string.format("%s:%s", tostring(p4.Type), (tostring(Name)))] = true;
end;

local u5 = {
    Elite = {
        Knife = {
            ["Black Frost"] = true
        }
    }
};
local u6 = {
    Rookie = true,
    Regular = true,
    Elite = true
};
local u7 = {};
local u8 = {
    Rookie = {
        {
            Name = "Sandtoon",
            Type = "Banner",
            Rarity = "Common",
            Weight = 220
        },
        {
            Name = "Robert",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Simple",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Sliced Watermelon",
            Type = "Charm",
            Rarity = "Common",
            Weight = 220
        },
        {
            Name = "Clapping",
            Type = "Emote",
            Rarity = "Common",
            Weight = 720
        },
        {
            Name = "Robert",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Simple",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Flat Brown",
            Type = "Skin",
            Rarity = "Common",
            Weight = 1000
        },
        {
            Name = "Flat Grey",
            Type = "Skin",
            Rarity = "Common",
            Weight = 1000
        },
        {
            Name = "Private",
            Type = "Title",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Robert",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Simple",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Sky Punches",
            Type = "Emote",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Hunting Camo",
            Type = "Skin",
            Rarity = "Rare",
            Weight = 250
        },
        {
            Name = "Dune Bowie",
            Type = "Knife",
            Rarity = "Legendary",
            Weight = 4
        }
    },
    Regular = {
        {
            Name = "Nighthawk",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Underhand",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Duck Plushy",
            Type = "Charm",
            Rarity = "Common",
            Weight = 720
        },
        {
            Name = "Nighthawk",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Underhand",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Dark Red",
            Type = "Skin",
            Rarity = "Common",
            Weight = 1000
        },
        {
            Name = "Flat Purple",
            Type = "Skin",
            Rarity = "Common",
            Weight = 1000
        },
        {
            Name = "Nighthawk",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Underhand",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Poly",
            Type = "Banner",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Soccer Ball",
            Type = "Charm",
            Rarity = "Uncommon",
            Weight = 300
        },
        {
            Name = "Bunny Hop",
            Type = "Emote",
            Rarity = "Uncommon",
            Weight = 300
        },
        {
            Name = "I Know I Know",
            Type = "Emote",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Pixel Flare",
            Type = "Skin",
            Rarity = "Epic",
            Weight = 50
        },
        {
            Name = "Aurora Glacier",
            Type = "Knife",
            Rarity = "Legendary",
            Weight = 4
        }
    },
    Elite = {
        {
            Name = "Dreamy",
            Type = "Banner",
            Rarity = "Common",
            Weight = 220
        },
        {
            Name = "Refresh",
            Type = "Banner",
            Rarity = "Common",
            Weight = 220
        },
        {
            Name = "Twiggy",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Twiggy",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Twiggy",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Contractor",
            Type = "Bottom",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Levitation Pose",
            Type = "Emote",
            Rarity = "Uncommon",
            Weight = 130
        },
        {
            Name = "Contractor",
            Type = "Head",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Lime Green",
            Type = "Skin",
            Rarity = "Uncommon",
            Weight = 360
        },
        {
            Name = "Royal Purple",
            Type = "Skin",
            Rarity = "Uncommon",
            Weight = 600
        },
        {
            Name = "Contractor",
            Type = "Top",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Evil Laughter",
            Type = "Emote",
            Rarity = "Rare",
            Weight = 52
        },
        {
            Name = "Venom",
            Type = "Bottom",
            Rarity = "Legendary",
            Weight = 8
        },
        {
            Name = "Divine Skull",
            Type = "Charm",
            Rarity = "Legendary",
            Weight = 6
        },
        {
            Name = "Venom",
            Type = "Head",
            Rarity = "Legendary",
            Weight = 8
        },
        {
            Name = "Aurora",
            Type = "Skin",
            Rarity = "Legendary",
            Weight = 8
        },
        {
            Name = "Triumph Card",
            Type = "Title",
            Rarity = "Legendary",
            Weight = 4
        },
        {
            Name = "Venom",
            Type = "Top",
            Rarity = "Legendary",
            Weight = 8
        },
        {
            Name = "Black Frost",
            Type = "Knife",
            Rarity = "Divine",
            Weight = 1
        }
    },
    Spectator = {
        {
            Name = "Mount Doodle",
            Type = "Banner",
            Rarity = "Common",
            Weight = 720
        },
        {
            Name = "Camo",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 720
        },
        {
            Name = "Violet",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Dio Pose",
            Type = "Emote",
            Rarity = "Common",
            Weight = 220
        },
        {
            Name = "Camo",
            Type = "Head",
            Rarity = "Common",
            Weight = 720
        },
        {
            Name = "Violet",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Flat Blue",
            Type = "Skin",
            Rarity = "Common",
            Weight = 720
        },
        {
            Name = "Flat Red",
            Type = "Skin",
            Rarity = "Common",
            Weight = 1000
        },
        {
            Name = "Recruit",
            Type = "Title",
            Rarity = "Common",
            Weight = 720
        },
        {
            Name = "Camo",
            Type = "Top",
            Rarity = "Common",
            Weight = 720
        },
        {
            Name = "Violet",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Burger",
            Type = "Charm",
            Rarity = "Uncommon",
            Weight = 300
        },
        {
            Name = "Chicken Leg",
            Type = "Charm",
            Rarity = "Uncommon",
            Weight = 300
        },
        {
            Name = "TPose",
            Type = "Emote",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Ocean Camo",
            Type = "Skin",
            Rarity = "Rare",
            Weight = 250
        },
        {
            Name = "Tint Bayonet",
            Type = "Knife",
            Rarity = "Legendary",
            Weight = 8
        }
    },
    Group = {
        {
            Name = "Scarface",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Skull",
            Type = "Charm",
            Rarity = "Common",
            Weight = 220
        },
        {
            Name = "Scarface",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Scarface",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Emy",
            Type = "Bottom",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Emy",
            Type = "Head",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Red Floral",
            Type = "Skin",
            Rarity = "Uncommon",
            Weight = 600
        },
        {
            Name = "Sand Crumb",
            Type = "Skin",
            Rarity = "Uncommon",
            Weight = 240
        },
        {
            Name = "Emy",
            Type = "Top",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Unbelievable",
            Type = "Emote",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Cirgle",
            Type = "Skin",
            Rarity = "Rare",
            Weight = 250
        },
        {
            Name = "Controller",
            Type = "Bottom",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Controller",
            Type = "Head",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Pink Camo",
            Type = "Skin",
            Rarity = "Epic",
            Weight = 50
        },
        {
            Name = "Noob",
            Type = "Title",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Controller",
            Type = "Top",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Mesozoic Majesty",
            Type = "Banner",
            Rarity = "Legendary",
            Weight = 6
        },
        {
            Name = "Jailbird",
            Type = "Title",
            Rarity = "Legendary",
            Weight = 6
        }
    },
    Crimson = { {
            Name = "Red Crystal",
            Type = "Skin",
            Rarity = "Rare",
            Weight = 250
        }, {
            Name = "Crimson Bloodline",
            Type = "Skin",
            Rarity = "Epic",
            Weight = 50
        }, {
            Name = "Crimson Eclispe",
            Type = "Skin",
            Rarity = "Epic",
            Weight = 50
        } },
    ["Cell-X"] = { {
            Name = "Cell-X",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 20
        }, {
            Name = "Digitech",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 75
        }, {
            Name = "Neotech",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 75
        } },
    Spooky = {
        {
            Name = "Bats And Moons",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Web And Spiders",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Wooo",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Blood Handmarks",
            Type = "Banner",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Creep Canvas",
            Type = "Banner",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Creepy Eyes",
            Type = "Banner",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Web Frame",
            Type = "Banner",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Dead Mullet",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Mr Hallow",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Dead Mullet",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Mr Hallow",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "BOO",
            Type = "Title",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooky 2023",
            Type = "Title",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Dead Mullet",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Mr Hallow",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Haunted Moon",
            Type = "Banner",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Undead",
            Type = "Banner",
            Rarity = "Epic",
            Weight = 10
        }
    },
    Spooky2024 = { {
            Name = "Bloodrush",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        }, {
            Name = "Skeletal",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        }, {
            Name = "Spooky Aurora",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        }, {
            Name = "Void Strider",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        }, {
            Name = "Bloody Ghostly",
            Type = "Charm",
            Rarity = "Limited",
            Weight = 20
        }, {
            Name = "Void Strider",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        }, {
            Name = "Void Strider",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        } },
    Spooky2025 = {
        {
            Name = "Demon Fire",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Ghost Corn",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Ghouled",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Grim Camo",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Pumpkin Fire",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Stary Horror",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Haunted Hallows",
            Type = "Banner",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Manor",
            Type = "Banner",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooky Dog",
            Type = "Banner",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooky2025",
            Type = "Banner",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Undead",
            Type = "Banner",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Bewitched",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Dumpkin",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Ms. Skeleton",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Ms. Vampire",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Reaper",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Skelly Bones",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spider",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooked",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooky Kitty",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Toon",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Zursa",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Bewitched",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Dumpkin",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Ms. Skeleton",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Ms. Vampire",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Reaper",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Skelly Bones",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spider",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooked",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooky Kitty",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Toon",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Zursa",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Carbon Monsterized",
            Type = "Knife",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Gold Ka-Bar",
            Type = "Knife",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "BOOsted",
            Type = "Title",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Skellybones",
            Type = "Title",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooky 2025",
            Type = "Title",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Zombie Slayer",
            Type = "Title",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Bewitched",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Dumpkin",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Ms. Skeleton",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Ms. Vampire",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Reaper",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Skelly Bones",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spider",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooked",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Spooky Kitty",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Toon",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Zursa",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        }
    },
    Winter2025 = {
        {
            Name = "Arctic Camo",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Borealis",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Crystalline",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Dark Ice",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Frosted Tech",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Galactic",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Pink Thorn",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Snow Camo",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Snowman",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Snowmetric",
            Type = "Skin",
            Rarity = "Limited",
            Weight = 100
        },
        {
            Name = "Anziano",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Commando",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Icie",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Operative",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowbot",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowbound",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowday",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snownaut",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowrush",
            Type = "Bottom",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Anziano",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Commando",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Icie",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Operative",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowbot",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowbound",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowday",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snownaut",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowrush",
            Type = "Head",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Anziano",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Commando",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Icie",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Operative",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowbot",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowbound",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowday",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snownaut",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        },
        {
            Name = "Snowrush",
            Type = "Top",
            Rarity = "Limited",
            Weight = 20
        }
    },
    Locker = {
        {
            Name = "Seamurve Yellow",
            Type = "Skin",
            Rarity = "Common",
            Weight = 1000
        },
        {
            Name = "Brushy",
            Type = "Skin",
            Rarity = "Uncommon",
            Weight = 240
        },
        {
            Name = "Silk World",
            Type = "Skin",
            Rarity = "Legendary",
            Weight = 8
        },
        {
            Name = "Spirit Neon",
            Type = "Skin",
            Rarity = "Divine",
            Weight = 5
        },
        {
            Name = "Cyberspace Fusion",
            Type = "Banner",
            Rarity = "Rare",
            Weight = 52
        },
        {
            Name = "Cone",
            Type = "Head",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Cone",
            Type = "Top",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Cone",
            Type = "Bottom",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Redfly",
            Type = "Head",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Redfly",
            Type = "Top",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Redfly",
            Type = "Bottom",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Armed Guest",
            Type = "Head",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Armed Guest",
            Type = "Top",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Armed Guest",
            Type = "Bottom",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Unicorn Plushy",
            Type = "Charm",
            Rarity = "Rare",
            Weight = 120
        },
        {
            Name = "Death Threat",
            Type = "Emote",
            Rarity = "Uncommon",
            Weight = 130
        },
        {
            Name = "No Mercy",
            Type = "Title",
            Rarity = "Epic",
            Weight = 10
        }
    },
    Vault = {
        {
            Name = "Seamurve Blue",
            Type = "Skin",
            Rarity = "Common",
            Weight = 1000
        },
        {
            Name = "Snowsaic",
            Type = "Skin",
            Rarity = "Uncommon",
            Weight = 240
        },
        {
            Name = "Modern Hexa",
            Type = "Banner",
            Rarity = "Rare",
            Weight = 52
        },
        {
            Name = "Noir",
            Type = "Head",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Noir",
            Type = "Top",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Noir",
            Type = "Bottom",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Scarlet",
            Type = "Head",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Scarlet",
            Type = "Top",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Scarlet",
            Type = "Bottom",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Hellion",
            Type = "Head",
            Rarity = "Legendary",
            Weight = 4
        },
        {
            Name = "Hellion",
            Type = "Top",
            Rarity = "Legendary",
            Weight = 4
        },
        {
            Name = "Hellion",
            Type = "Bottom",
            Rarity = "Legendary",
            Weight = 4
        },
        {
            Name = "Unicorn Plushy",
            Type = "Charm",
            Rarity = "Rare",
            Weight = 120
        },
        {
            Name = "Appled Bowie",
            Type = "Knife",
            Rarity = "Legendary",
            Weight = 4
        },
        {
            Name = "Penguin Walk",
            Type = "Emote",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Cheer",
            Type = "Emote",
            Rarity = "Rare",
            Weight = 120
        },
        {
            Name = "Kitty",
            Type = "Title",
            Rarity = "Rare",
            Weight = 52
        },
        {
            Name = "Grenade Guru",
            Type = "Title",
            Rarity = "Rare",
            Weight = 120
        }
    },
    Stellar = {
        {
            Name = "Sand Crumb",
            Type = "Skin",
            Rarity = "Uncommon",
            Weight = 240
        },
        {
            Name = "Majestic Nebula",
            Type = "Banner",
            Rarity = "Epic",
            Weight = 36
        },
        {
            Name = "Thug",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Thug",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Thug",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Mary",
            Type = "Head",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Mary",
            Type = "Top",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Mary",
            Type = "Bottom",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Psycho",
            Type = "Head",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Psycho",
            Type = "Top",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Psycho",
            Type = "Bottom",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Electra",
            Type = "Head",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Electra",
            Type = "Top",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Electra",
            Type = "Bottom",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Cosmic Bayonet",
            Type = "Knife",
            Rarity = "Divine",
            Weight = 1
        },
        {
            Name = "Comeback Dance",
            Type = "Emote",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Pro",
            Type = "Title",
            Rarity = "Uncommon",
            Weight = 130
        }
    },
    Cosmos = {
        {
            Name = "Pixel Camo",
            Type = "Skin",
            Rarity = "Rare",
            Weight = 250
        },
        {
            Name = "Aqua Moonlit",
            Type = "Banner",
            Rarity = "Epic",
            Weight = 36
        },
        {
            Name = "Lea",
            Type = "Head",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Lea",
            Type = "Top",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Lea",
            Type = "Bottom",
            Rarity = "Common",
            Weight = 200
        },
        {
            Name = "Bored",
            Type = "Head",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Bored",
            Type = "Top",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Bored",
            Type = "Bottom",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Parker",
            Type = "Head",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Parker",
            Type = "Top",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Parker",
            Type = "Bottom",
            Rarity = "Rare",
            Weight = 50
        },
        {
            Name = "Python",
            Type = "Head",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Python",
            Type = "Top",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Python",
            Type = "Bottom",
            Rarity = "Epic",
            Weight = 10
        },
        {
            Name = "Cosmic Karambit",
            Type = "Knife",
            Rarity = "Divine",
            Weight = 1
        },
        {
            Name = "Lazy Dance",
            Type = "Emote",
            Rarity = "Uncommon",
            Weight = 120
        },
        {
            Name = "Queen Bee",
            Type = "Title",
            Rarity = "Epic",
            Weight = 10
        }
    },
    Ranked = {}
};
local u9 = {};
local u10 = {
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Epic = 4,
    Legendary = 5,
    Divine = 6,
    Limited = 7
};
local u11 = {
    DuplicateShopOrder = { "Locker", "Vault", "Stellar", "Cosmos" },
    DuplicateShop = {
        Locker = 15,
        Vault = 20,
        Stellar = 50,
        Cosmos = 50
    },
    Settings = {
        AnimationsEnabled = true,
        AnimationDuration = 5,
        RewardHoldDuration = 0.5,
        PreviewYaw = -20,
        PreviewCameraY = 5.5,
        ShakeInterval = 0.12,
        ShakeAngle = 6,
        OpenAnimationSpeed = 2,
        ExpandedScale = 1.8
    }
};

for _, v in pairs(BattlePass.GetBattlePassIndex()) do
    for _, v2 in pairs(v) do
        if typeof(v2) == "table" and v2.Name then
            if v2.Type then
                local Name = v2.Name;
                u1[string.format("%s:%s", tostring(v2.Type), (tostring(Name)))] = true;
            end;
        end;
    end;
end;

for _, v in pairs(Gamepasses.GamePasses) do
    for _, v2 in pairs(v.Items or {}) do
        if typeof(v2) == "table" and v2.Name then
            if v2.Type then
                local Name = v2.Name;
                u1[string.format("%s:%s", tostring(v2.Type), (tostring(Name)))] = true;
            end;
        end;
    end;
end;

for _, v in pairs(Gamepasses.Additional) do
    for _, v2 in pairs(v.Items or {}) do
        if typeof(v2) == "table" and v2.Name then
            if v2.Type then
                local Name = v2.Name;
                u1[string.format("%s:%s", tostring(v2.Type), (tostring(Name)))] = true;
            end;
        end;
    end;
end;

local function cloneEntry(p12) -- Line: 493
    return {
        Name = p12.Name,
        Type = p12.Type,
        Rarity = p12.Rarity,
        Weight = p12.Weight
    };
end;

local function isEvergreenException(p13, p14) -- Line: 502
    -- upvalues: u5 (copy)
    local v15 = u5[p13];

    if not v15 then
        return false;
    end;

    local v16 = v15[p14.Type];
    local v17;

    if v16 == nil then
        v17 = false;
    else
        v17 = v16[p14.Name] == true;
    end;

    return v17;
end;

local function isEvergreenEntryAllowed(p18, p19, p20) -- Line: 512
    -- upvalues: u6 (copy), u5 (copy), u1 (copy)
    if not u6[p18] then
        return true;
    end;

    local v21 = u5[p18];
    local v22;

    if v21 then
        local v23 = v21[p19.Type];

        if v23 == nil then
            v22 = false;
        else
            v22 = v23[p19.Name] == true;
        end;
    else
        v22 = false;
    end;

    if v22 then
        return true;
    end;

    local Name = p19.Name;

    return not u1[string.format("%s:%s", tostring(p19.Type), (tostring(Name)))];
end;

local function resolveItemObject(p24) -- Line: 528
    -- upvalues: ReplicatedStorage (copy)
    local v25 = ReplicatedStorage.Items:FindFirstChild(p24.Type);

    if not v25 then
        warn(string.format("[Crates] Missing item type folder \'%s\'", (tostring(p24.Type))));

        return nil;
    end;

    local v26 = v25:FindFirstChild(p24.Name);

    if v26 then
        return v26;
    end;

    warn(string.format("[Crates] Missing item \'%s\' in type \'%s\'", tostring(p24.Name), (tostring(p24.Type))));

    return nil;
end;

local function compileCrate(p27, p28) -- Line: 544
    -- upvalues: resolveItemObject (copy), u6 (copy), u5 (copy), u1 (copy), u7 (copy)
    local v29 = {
        TotalWeight = 0,
        Entries = {}
    };

    for _, v in ipairs(p28) do
        local v30 = resolveItemObject(v);

        if v30 then
            local v31;

            if u6[p27] then
                local v32 = u5[p27];
                local v33;

                if v32 then
                    local v34 = v32[v.Type];

                    if v34 == nil then
                        v33 = false;
                    else
                        v33 = v34[v.Name] == true;
                    end;
                else
                    v33 = false;
                end;

                if v33 then
                    v31 = true;
                else
                    local Name = v.Name;
                    v31 = not u1[string.format("%s:%s", tostring(v.Type), (tostring(Name)))];
                end;
            else
                v31 = true;
            end;

            if v31 then
                local v35 = {
                    Name = v.Name,
                    Type = v.Type,
                    Rarity = v.Rarity,
                    Weight = v.Weight
                };
                local v36 = tonumber(v35.Weight) or 1;
                v35.Weight = math.max(1, v36);
                v35.Object = v30;
                v29.TotalWeight = v29.TotalWeight + v35.Weight;
                table.insert(v29.Entries, v35);
            else
                warn(string.format("[Crates] Skipping ineligible evergreen entry \'%s\' [%s] in crate \'%s\'", tostring(v.Name), tostring(v.Type), (tostring(p27))));
            end;
        end;
    end;

    u7[p27] = v29;
end;

for i, v in pairs(u8) do
    compileCrate(i, v);
end;

for i, v in pairs(u7) do
    for _, v2 in ipairs(v.Entries) do
        local Name = v2.Name;
        local v37 = string.format("%s:%s", tostring(v2.Type), (tostring(Name)));
        local v38 = u9[v37];

        if v38 == nil or (u10[v2.Rarity] or 0) > (u10[v38.Rarity] or 0) then
            u9[v37] = {
                Name = v2.Name,
                Type = v2.Type,
                Rarity = v2.Rarity,
                Weight = v2.Weight,
                CrateName = i
            };
        end;
    end;
end;

function u11.GetSettings() -- Line: 586
    -- upvalues: u11 (copy)
    return u11.Settings;
end;

function u11.GetDuplicateShopPrice(p39) -- Line: 590
    -- upvalues: u11 (copy)
    return u11.DuplicateShop and u11.DuplicateShop[p39];
end;

function u11.GetDuplicateShopCrates() -- Line: 594
    -- upvalues: u11 (copy)
    local v40 = {};

    for i, v in ipairs(u11.DuplicateShopOrder or {}) do
        v40[i] = v;
    end;

    return v40;
end;

function u11.GetCrate(p41) -- Line: 602
    -- upvalues: u8 (copy)
    return u8[p41];
end;

function u11.GetCrateContents(p42) -- Line: 606
    -- upvalues: u7 (copy)
    local v43 = u7[p42];

    if not v43 then
        return {};
    end;

    local v44 = {};

    for i, v in ipairs(v43.Entries) do
        v44[i] = {
            Name = v.Name,
            Type = v.Type,
            Rarity = v.Rarity,
            Weight = v.Weight
        };
    end;

    return v44;
end;

function u11.HasContents(p45) -- Line: 620
    -- upvalues: u7 (copy)
    local v46 = u7[p45];
    local v47;

    if v46 == nil then
        v47 = false;
    else
        v47 = #v46.Entries > 0;
    end;

    return v47;
end;

function u11.GetTotalWeight(p48) -- Line: 625
    -- upvalues: u7 (copy)
    local v49 = u7[p48];

    return not v49 and 0 or v49.TotalWeight;
end;

function u11.GetChancePercent(p50, p51) -- Line: 634
    -- upvalues: u11 (copy)
    local v52 = u11.GetTotalWeight(p50);

    if v52 <= 0 then
        return 0;
    end;

    local v53 = tonumber(p51.Weight) or 1;

    return math.max(1, v53) / v52 * 100;
end;

function u11.GetRarityRank(p54) -- Line: 644
    -- upvalues: u10 (copy)
    return u10[p54] or 0;
end;

function u11.IsRarityAtLeast(p55, p56) -- Line: 648
    -- upvalues: u11 (copy)
    return u11.GetRarityRank(p55) >= u11.GetRarityRank(p56);
end;

function u11.GetChanceText(p57, p58) -- Line: 652
    -- upvalues: u11 (copy)
    local v59 = u11.GetChancePercent(p57, p58);

    if v59 >= 1 then
        return string.format("%.2f%%", v59);
    end;

    return string.format("%.3f%%", v59);
end;

function u11.GetItemEntry(p60, p61) -- Line: 661
    -- upvalues: u9 (copy)
    local v62;

    if p61 and p60 or not p60 then
        v62 = p60;
    else
        v62 = p60.Name;
    end;

    if p61 then
        p60 = p61;
    elseif p60 then
        p60 = p60.Type;
    end;

    if typeof(v62) ~= "string" or typeof(p60) ~= "string" then
        return nil;
    end;

    local v63 = u9[string.format("%s:%s", tostring(p60), (tostring(v62)))];

    return v63 and {
        Name = v63.Name,
        Type = v63.Type,
        Rarity = v63.Rarity,
        Weight = v63.Weight
    } or nil;
end;

function u11.IsItemObtainable(p64, p65) -- Line: 677
    -- upvalues: u11 (copy)
    return u11.GetItemEntry(p64, p65) ~= nil;
end;

function u11.GetItemRarity(p66, p67) -- Line: 681
    -- upvalues: u11 (copy)
    local v68 = u11.GetItemEntry(p66, p67);

    return v68 and v68.Rarity or nil;
end;

function u11.GetEntriesWithChance(p69) -- Line: 686
    -- upvalues: u7 (copy), u11 (copy)
    local v70 = u7[p69];

    if not v70 then
        return {};
    end;

    local v71 = {};

    for i, v in ipairs(v70.Entries) do
        v71[i] = {
            Name = v.Name,
            Type = v.Type,
            Rarity = v.Rarity,
            Weight = v.Weight,
            Chance = u11.GetChancePercent(p69, v),
            ChanceText = u11.GetChanceText(p69, v)
        };
    end;

    return v71;
end;

function u11.RollItem(p72, p73) -- Line: 703
    -- upvalues: u7 (copy)
    local v74 = u7[p72];

    if not v74 or v74.TotalWeight <= 0 then
        return nil;
    end;

    local v75 = (p73 or Random.new()):NextNumber(0, v74.TotalWeight);
    local v76 = 0;

    for _, v in ipairs(v74.Entries) do
        v76 = v76 + v.Weight;

        if v75 <= v76 then
            return {
                Name = v.Name,
                Type = v.Type,
                Rarity = v.Rarity,
                Weight = v.Weight
            };
        end;
    end;

    local v77 = v74.Entries[#v74.Entries];

    return {
        Name = v77.Name,
        Type = v77.Type,
        Rarity = v77.Rarity,
        Weight = v77.Weight
    };
end;

return u11;