
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("Players");
local BattlePass = require(ReplicatedStorage.Components.BattlePass);
local Config = require(ReplicatedStorage.Config);
local Utility = require(ReplicatedStorage.Modules.Utility);
require(ReplicatedStorage.Modules.TypeModules.Types);
local u1 = `[{script.Name}]`;
local u2 = {
    BattlepassRewards = BattlePass.GetBattlePassIndex(),
    GamePasses = {
        Cash1000 = {
            ID = 1646654307,
            Price = 60,
            Type = "Product",
            Items = {}
        },
        Cash8000 = {
            ID = 1646654801,
            Price = 480,
            Type = "Product",
            Items = {}
        },
        Cash20000 = {
            ID = 1646655015,
            Price = 1100,
            Type = "Product",
            Items = {}
        },
        Credit200 = {
            ID = 1646658206,
            Price = 60,
            Type = "Product",
            Items = {}
        },
        Credit1600 = {
            ID = 1646658566,
            Price = 480,
            Type = "Product",
            Items = {}
        },
        Credit4000 = {
            ID = 1646658920,
            Price = 1100,
            Type = "Product",
            Items = {}
        },
        BoosterCash = {
            ID = 1646670620,
            Price = 100,
            Type = "Product",
            Items = {}
        },
        BoosterExperience = {
            ID = 1646672141,
            Price = 100,
            Type = "Product",
            Items = {}
        },
        BattlePass = {
            ID = 1508136045,
            Price = 1000,
            Type = "Product",
            Items = {}
        },
        Skip1 = {
            ID = 3580166703,
            Price = 19,
            Type = "Product",
            Items = {}
        },
        Skip5 = {
            ID = 3580167108,
            Price = 89,
            Type = "Product",
            Items = {}
        },
        SkipAllEvent = {
            ID = 3589851241,
            Price = 149,
            Type = "Product",
            Items = {}
        },
        AdvertisementReward = {
            ID = 3590834882,
            Price = 19,
            Type = "Product",
            Items = {}
        },
        DoubleReward = {
            ID = 1826019154,
            Price = 299,
            Type = "GamePass",
            Items = { {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 10000,
                    ID = "DoubleReward1"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 2000,
                    ID = "DoubleReward2"
                }, {
                    Name = "Double Triple",
                    Type = "Banner",
                    Amount = 1,
                    ID = "DoubleTriple1"
                } }
        },
        TripleReward = {
            ID = 1826477129,
            Price = 599,
            Type = "GamePass",
            Items = { {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 20000,
                    ID = "TripleReward1"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 4000,
                    ID = "TripleReward2"
                }, {
                    Name = "Double Triple",
                    Type = "Banner",
                    Amount = 1,
                    ID = "DoubleTriple1"
                } }
        },
        Illusionist = {
            ID = 14712219,
            Price = 500,
            Type = "GamePass",
            Items = { {
                    Name = "Illusionist",
                    Type = "Head"
                }, {
                    Name = "Illusionist",
                    Type = "Top"
                }, {
                    Name = "Illusionist",
                    Type = "Bottom"
                }, {
                    Name = "Aiming",
                    Type = "Emote"
                }, {
                    Name = "Pure Black",
                    Type = "Skin"
                }, {
                    Name = "Mosaic Royal Purple",
                    Type = "Skin"
                } }
        },
        Scarecrow = {
            ID = 14712406,
            Price = 500,
            Type = "GamePass",
            Items = { {
                    Name = "Scarecrow",
                    Type = "Head"
                }, {
                    Name = "Scarecrow",
                    Type = "Top"
                }, {
                    Name = "Scarecrow",
                    Type = "Bottom"
                }, {
                    Name = "Tripattern Orange",
                    Type = "Skin"
                }, {
                    Name = "Crowz",
                    Type = "Skin"
                } }
        },
        SamuraiDevil = {
            ID = 25229882,
            Price = 499,
            Type = "GamePass",
            Items = { {
                    Name = "SamuraiDevil",
                    Type = "Head"
                }, {
                    Name = "SamuraiDevil",
                    Type = "Top"
                }, {
                    Name = "SamuraiDevil",
                    Type = "Bottom"
                }, {
                    Name = "Samurai Temple",
                    Type = "Skin"
                } }
        },
        Azure = {
            ID = 26146575,
            Price = 500,
            Type = "GamePass",
            Items = { {
                    Name = "Azure",
                    Type = "Head"
                }, {
                    Name = "Azure",
                    Type = "Top"
                }, {
                    Name = "Azure",
                    Type = "Bottom"
                }, {
                    Name = "KOI",
                    Type = "Skin"
                } }
        },
        ["Winter Combat"] = {
            ID = 26809083,
            Price = 500,
            Type = "GamePass",
            Items = { {
                    Name = "Winter Combat",
                    Type = "Head"
                }, {
                    Name = "Winter Combat",
                    Type = "Top"
                }, {
                    Name = "Winter Combat",
                    Type = "Bottom"
                }, {
                    Name = "Combat Camo",
                    Type = "Skin"
                }, {
                    Name = "Winter Camo Spoof",
                    Type = "Skin"
                } }
        },
        Stranger = {
            ID = 27680628,
            Price = 500,
            Type = "GamePass",
            Items = { {
                    Name = "Stranger",
                    Type = "Head"
                }, {
                    Name = "Stranger",
                    Type = "Top"
                }, {
                    Name = "Stranger",
                    Type = "Bottom"
                }, {
                    Name = "Unknown",
                    Type = "Skin"
                }, {
                    Name = "Street",
                    Type = "Skin"
                } }
        },
        ["E-Girl"] = {
            ID = 155975407,
            ID2 = 8600917158,
            Price = 500,
            Type = "GamePass",
            Items = { {
                    Name = "E-Girl",
                    Type = "Head"
                }, {
                    Name = "E-Girl",
                    Type = "Top"
                }, {
                    Name = "E-Girl",
                    Type = "Bottom"
                }, {
                    Name = "E-Snacks",
                    Type = "Skin"
                }, {
                    Name = "E-Patterns",
                    Type = "Skin"
                } }
        },
        Yury = {
            ID = 257405166,
            Price = 500,
            Type = "GamePass",
            Items = { {
                    Name = "Yury",
                    Type = "Head"
                }, {
                    Name = "Yury",
                    Type = "Top"
                }, {
                    Name = "Yury",
                    Type = "Bottom"
                }, {
                    Name = "Sweet Ocean",
                    Type = "Skin"
                } }
        },
        Phoenix = {
            ID = 800938590,
            Price = 599,
            Type = "GamePass",
            Items = { {
                    Name = "Phoenix",
                    Type = "Head"
                }, {
                    Name = "Phoenix",
                    Type = "Top"
                }, {
                    Name = "Phoenix",
                    Type = "Bottom"
                }, {
                    Name = "Phoenix Piece",
                    Type = "Charm"
                }, {
                    Name = "Phoenix Mask",
                    Type = "Banner"
                }, {
                    Name = "Phoenix Luxury Wall",
                    Type = "Banner"
                }, {
                    Name = "Phoenix Gold Cloak",
                    Type = "Skin"
                } }
        },
        Meowster = {
            ID = 802833593,
            Price = 199,
            Type = "GamePass",
            Items = { {
                    Name = "Meowster",
                    Type = "Head"
                }, {
                    Name = "Meowster",
                    Type = "Top"
                }, {
                    Name = "Meowster",
                    Type = "Bottom"
                }, {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 4000,
                    ID = "Meowster1"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 800,
                    ID = "Meowster2"
                }, {
                    Name = "Kitty Cat",
                    Type = "Banner"
                }, {
                    Name = "Pawster",
                    Type = "Skin"
                } }
        },
        Glitch = {
            ID = 982659820,
            Price = 799,
            Type = "GamePass",
            Items = { {
                    Name = "Glitch",
                    Type = "Head"
                }, {
                    Name = "Glitch",
                    Type = "Top"
                }, {
                    Name = "Glitch",
                    Type = "Bottom"
                }, {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 4000,
                    ID = "Glitch1"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 800,
                    ID = "Glitch2"
                }, {
                    Name = "Pixeled",
                    Type = "Skin"
                }, {
                    Name = "Glitch",
                    Type = "Skin"
                }, {
                    Name = "Cyber",
                    Type = "Skin"
                } }
        },
        Nyx = {
            ID = 842885224,
            Price = 599,
            Type = "GamePass",
            Items = { {
                    Name = "Nyx",
                    Type = "Head"
                }, {
                    Name = "Nyx",
                    Type = "Top"
                }, {
                    Name = "Nyx",
                    Type = "Bottom"
                }, {
                    Name = "Nyx",
                    Type = "Banner"
                }, {
                    Name = "Mythical Night",
                    Type = "Skin",
                    Weapon = "MAC10"
                }, {
                    Name = "Rose Nightmares",
                    Type = "Skin",
                    Weapon = "Vector"
                } }
        },
        Goldsune = {
            ID = 1121722923,
            Price = 599,
            Type = "GamePass",
            Items = { {
                    Name = "Goldsune",
                    Type = "Head"
                }, {
                    Name = "Goldsune",
                    Type = "Top"
                }, {
                    Name = "Goldsune",
                    Type = "Bottom"
                }, {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 4000,
                    ID = "Goldsune1"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 800,
                    ID = "Goldsune2"
                }, {
                    Name = "Boujie",
                    Type = "Skin"
                }, {
                    Name = "Royalty",
                    Type = "Skin"
                } }
        },
        ["Midnight Operator"] = {
            ID = 1538557312,
            Price = 599,
            Type = "GamePass",
            Items = { {
                    Name = "Midnight Operator",
                    Type = "Head"
                }, {
                    Name = "Midnight Operator",
                    Type = "Top"
                }, {
                    Name = "Midnight Operator",
                    Type = "Bottom"
                }, {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 1000,
                    ID = "MidnightOperator1"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 250,
                    ID = "MidnightOperator2"
                }, {
                    Name = "Midnight Operator",
                    Type = "Skin"
                }, {
                    Name = "Midnight Operator Bowie",
                    Type = "Knife"
                } }
        },
        CashBundle = {
            ID = 1251608841,
            Price = 2499,
            Type = "GamePass",
            Items = { {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 15000,
                    ID = "CashBundle01"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 7500,
                    ID = "CashBundle02"
                }, {
                    Name = "CampaignPoints",
                    Type = "CampaignPoints",
                    Amount = 15000,
                    ID = "CashBundle03"
                } }
        },
        CoopBundle = {
            ID = 942441735,
            Price = 800,
            Type = "GamePass",
            Items = { {
                    Name = "Cracked Glacier",
                    Type = "Skin",
                    Weapon = "AKS-74u"
                }, {
                    Name = "Inferno Forged",
                    Type = "Skin",
                    Weapon = "HK416"
                }, {
                    Name = "Stinger",
                    Type = "Skin",
                    Weapon = "Scorpion Evo 3"
                }, {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 1000,
                    ID = "CoopBundle01"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 500,
                    ID = "CoopBundle02"
                }, {
                    Name = "CampaignPoints",
                    Type = "CampaignPoints",
                    Amount = 15000,
                    ID = "CoopBundle03"
                } }
        },
        ["Dual Skin"] = {
            ID = 1647930107,
            Price = 67,
            Type = "GamePass",
            Items = { {
                    Name = "Ashfall",
                    Type = "Skin"
                }, {
                    Name = "Pinkscale",
                    Type = "Skin"
                } }
        },
        Hatchet = {
            ID = 1607636017,
            Price = 29,
            Type = "GamePass",
            Items = { {
                    Name = "Hatchet",
                    Type = "Knife"
                } }
        },
        Silence = {
            ID = 1673198728,
            Price = 300,
            Type = "GamePass",
            Items = { {
                    Name = "Silence",
                    Type = "Head"
                }, {
                    Name = "Silence",
                    Type = "Top"
                }, {
                    Name = "Silence",
                    Type = "Bottom"
                }, {
                    Name = "Wasteland",
                    Type = "Skin"
                } }
        },
        Lovestruck = {
            ID = 1711319754,
            Price = 300,
            Type = "GamePass",
            Items = { {
                    Name = "Lovestruck",
                    Type = "Head"
                }, {
                    Name = "Lovestruck",
                    Type = "Top"
                }, {
                    Name = "Lovestruck",
                    Type = "Bottom"
                }, {
                    Name = "Lovestruck",
                    Type = "Skin"
                } }
        },
        SupporterOrange = {
            ID = 8287433729,
            Price = 500,
            Type = "Asset",
            Items = { {
                    Name = "Jailbird Supporter Orange",
                    Type = "Head"
                }, {
                    Name = "Jailbird Supporter Orange",
                    Type = "Top"
                }, {
                    Name = "Jailbird Supporter Orange",
                    Type = "Bottom"
                } }
        },
        SupporterClassic = {
            ID = 8287432768,
            Price = 500,
            Type = "Asset",
            Items = { {
                    Name = "Jailbird Supporter Classic",
                    Type = "Head"
                }, {
                    Name = "Jailbird Supporter Classic",
                    Type = "Top"
                }, {
                    Name = "Jailbird Supporter Classic",
                    Type = "Bottom"
                }, {
                    Name = "Supporter Classic",
                    Type = "Skin"
                }, {
                    Name = "Mini Mushrooms",
                    Type = "Skin"
                } }
        }
    },
    Additional = {
        WhyY0uS0Mad = {
            Price = 0,
            Items = { {
                    Name = "Madders",
                    Type = "Charm"
                }, {
                    Name = "Madders",
                    Type = "Banner"
                }, {
                    Name = "Madders",
                    Type = "Head"
                }, {
                    Name = "Madders",
                    Type = "Top"
                }, {
                    Name = "Madders",
                    Type = "Bottom"
                }, {
                    Name = "MaddersCamo",
                    Type = "Head"
                }, {
                    Name = "MaddersCamo",
                    Type = "Top"
                }, {
                    Name = "MaddersCamo",
                    Type = "Bottom"
                }, {
                    Name = "Madders2",
                    Type = "Banner"
                }, {
                    Name = "MDRS",
                    Type = "Knife"
                }, {
                    Name = "Wasteland",
                    Type = "Skin"
                } }
        },
        CookieOdi = {
            Price = 0,
            Items = { {
                    Name = "CookieOdi",
                    Type = "Head"
                }, {
                    Name = "CookieOdi",
                    Type = "Top"
                }, {
                    Name = "CookieOdi",
                    Type = "Bottom"
                } }
        },
        spn_chivved = {
            Price = 0,
            Items = {
                [3] = {
                    Name = "Chivved",
                    Type = "Head"
                },
                [4] = {
                    Name = "Chivved",
                    Type = "Top"
                },
                [5] = {
                    Name = "Chivved",
                    Type = "Bottom"
                }
            }
        },
        Krupzy = {
            Price = 0,
            Items = { {
                    Name = "Krupzy",
                    Type = "Head"
                }, {
                    Name = "Krupzy",
                    Type = "Top"
                }, {
                    Name = "Krupzy",
                    Type = "Bottom"
                }, {
                    Name = "KrupzyDark",
                    Type = "Head"
                }, {
                    Name = "KrupzyDark",
                    Type = "Top"
                }, {
                    Name = "KrupzyDark",
                    Type = "Bottom"
                } }
        },
        DavoBlox = {
            Price = 0,
            Items = { {
                    Name = "DavoBlox",
                    Type = "Banner"
                }, {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 10000,
                    ID = "DavoBloxIncentives1"
                } }
        },
        ["Game Tester"] = {
            Price = 0,
            Items = {
                [1] = {
                    Name = "CoolKid",
                    Type = "Head"
                },
                [2] = {
                    Name = "CoolKid",
                    Type = "Top"
                },
                [3] = {
                    Name = "CoolKid",
                    Type = "Bottom"
                },
                [4] = {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 2000,
                    ID = "GameTesterGoodies1"
                },
                [5] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 500,
                    ID = "GameTesterGoodies2"
                },
                [7] = {
                    Name = "Game Tester",
                    Type = "Title"
                }
            }
        },
        Moderators = {
            Price = 0,
            Items = { {
                    Name = "CoolKid",
                    Type = "Head"
                }, {
                    Name = "CoolKid",
                    Type = "Top"
                }, {
                    Name = "CoolKid",
                    Type = "Bottom"
                } }
        },
        ["Server Booster"] = {
            Price = 0,
            Items = { {
                    Name = "Nitro",
                    Type = "Head"
                }, {
                    Name = "Nitro",
                    Type = "Top"
                }, {
                    Name = "Nitro",
                    Type = "Bottom"
                }, {
                    Name = "Nitro",
                    Type = "Banner"
                } }
        },
        MaddersYT = {
            Price = 0,
            Items = { {
                    Name = "Madderian",
                    Type = "Head"
                }, {
                    Name = "Madderian",
                    Type = "Top"
                }, {
                    Name = "Madderian",
                    Type = "Bottom"
                } }
        },
        Codebase = {
            Price = 0,
            Items = { {
                    Name = "Codebase",
                    Type = "Head"
                }, {
                    Name = "Codebase",
                    Type = "Top"
                }, {
                    Name = "Codebase",
                    Type = "Bottom"
                } }
        },
        RoyalTitle = {
            Price = 0,
            Items = { {
                    Name = "Royal",
                    Type = "Title"
                } }
        },
        ChivvedYT = {
            Price = 0,
            Items = { {
                    Name = "ChivvedYT",
                    Type = "Head"
                }, {
                    Name = "ChivvedYT",
                    Type = "Top"
                }, {
                    Name = "ChivvedYT",
                    Type = "Bottom"
                } }
        },
        VitalTitle = {
            Price = 0,
            Items = { {
                    Name = "Vital",
                    Type = "Title"
                } }
        },
        REV0LTED = {
            Price = 0,
            Items = { {
                    Name = "Clown",
                    Type = "Head"
                }, {
                    Name = "Clown",
                    Type = "Top"
                }, {
                    Name = "Clown",
                    Type = "Bottom"
                } }
        },
        SmileyGin = {
            Price = 0,
            Items = { {
                    Name = "SmileyGin",
                    Type = "Head"
                }, {
                    Name = "SmileyGin",
                    Type = "Top"
                }, {
                    Name = "SmileyGin",
                    Type = "Bottom"
                }, {
                    Name = "Pure White",
                    Type = "Skin"
                }, {
                    Name = "Undertaker",
                    Type = "Head"
                }, {
                    Name = "Undertaker",
                    Type = "Top"
                }, {
                    Name = "Undertaker",
                    Type = "Bottom"
                }, {
                    Name = "Miracle",
                    Type = "Head"
                }, {
                    Name = "Miracle",
                    Type = "Top"
                }, {
                    Name = "Miracle",
                    Type = "Bottom"
                }, {
                    Name = "SmileyGin",
                    Type = "Charm"
                }, {
                    Name = "Smiley Knife",
                    Type = "Knife"
                }, {
                    Name = "Hatchet",
                    Type = "Knife"
                } }
        },
        Secret = {
            Price = 0,
            Items = { {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 35000,
                    ID = "Secret1"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 10000,
                    ID = "Secret2"
                } }
        },
        Everyone = {
            Price = 0,
            Items = { {
                    Name = "Mafia",
                    Type = "Head"
                }, {
                    Name = "Mafia",
                    Type = "Top"
                }, {
                    Name = "Mafia",
                    Type = "Bottom"
                }, {
                    Name = "Bayonet",
                    Type = "Knife"
                } }
        },
        StaffIncentive1 = {
            Price = 0,
            Items = { {
                    Name = "Cash",
                    Type = "Cash",
                    Amount = 5000,
                    ID = "Incentive1_1"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = 2000,
                    ID = "Incentive1_2"
                } }
        },
        TesterIncentive2 = {
            Price = 0,
            Items = { {
                    Name = "Elite",
                    Type = "Crate",
                    Amount = 10,
                    ID = "Incentive2_1"
                }, {
                    Name = "Regular",
                    Type = "Crate",
                    Amount = 10,
                    ID = "Incentive2_2"
                }, {
                    Name = "Spectator",
                    Type = "Crate",
                    Amount = 10,
                    ID = "Incentive2_3"
                } }
        }
    }
};

function u2.GivePack(p3, p4, p5, p6, p7) -- Line: 567
    -- upvalues: u2 (copy), ReplicatedStorage (copy), Config (copy)
    local PlayerData = p3.PlayerData;
    local _ = PlayerData.Inventory;
    local v8 = false;

    for _, v in pairs(p5[p4].Items) do
        local v9 = {};

        for i, v2 in pairs(v) do
            v9[i] = v2;
        end;

        if u2.GiveItem(v9, PlayerData) == true then
            v8 = true;
        end;
    end;

    if v8 == true then
        ReplicatedStorage.Events.ReceivedItems:FireClient(p3);

        if p6 and p7 then
            Config.GivePlayerNotice(p3, p6, p7);
        end;
    end;
end;

function u2.GiveItem(p10, p11) -- Line: 601
    -- upvalues: Config (copy), ReplicatedStorage (copy), Utility (copy)
    if p10.Type == "Head" or (p10.Type == "Top" or (p10.Type == "Bottom" or (p10.Type == "Emote" or (p10.Type == "Banner" or (p10.Type == "Title" or (p10.Type == "Watch" or (p10.Type == "Charm" or p10.Type == "Knife"))))))) then
        local v12 = Config.GetItemIDFromItemData(p10);
        local v13 = p11.Inventory:FindFirstChild(v12);
        local v14 = p10.Amount or 1;
        local v15 = p10.ID or v12;

        if v13 == nil then
            local StringValue = Instance.new("StringValue", p11.Inventory);
            StringValue.Name = v12;
            StringValue:SetAttribute("Name", p10.Name);
            StringValue:SetAttribute("Type", p10.Type);
            StringValue:SetAttribute("Quantity", v14);
        elseif p10.AllowDuplicate == true then
            v13:SetAttribute("Quantity", (v13:GetAttribute("Quantity") or 1) + v14);
        end;

        if p11.ItemsLog:FindFirstChild(v15) == nil then
            local StringValue = Instance.new("StringValue");
            StringValue.Name = v15;
            StringValue:SetAttribute("Name", p10.Name);
            StringValue:SetAttribute("Type", p10.Type);
            StringValue:SetAttribute("Amount", v14);
            StringValue:SetAttribute("Seen", false);
            StringValue.Parent = p11.ItemsLog;
            ReplicatedStorage.Events.Action:FireClient(p11.Parent, "ItemsLog");

            return true;
        end;
    elseif p10.Type == "Skin" then
        if p10.Weapon == nil then
            local v16 = false;

            for _, child in pairs(ReplicatedStorage.Items.Weapon:GetChildren()) do
                p10.Weapon = child.Name;
                local v17 = Config.GetItemIDFromItemData(p10);

                if p11.Inventory:FindFirstChild(v17) == nil then
                    local StringValue = Instance.new("StringValue", p11.Inventory);
                    StringValue.Name = v17;
                    StringValue:SetAttribute("Name", p10.Name);
                    StringValue:SetAttribute("Type", p10.Type);
                    StringValue:SetAttribute("Weapon", child.Name);
                end;

                if p11.ItemsLog:FindFirstChild(v17) == nil then
                    local StringValue = Instance.new("StringValue", p11.ItemsLog);
                    StringValue.Name = v17;
                    StringValue:SetAttribute("Name", p10.Name);
                    StringValue:SetAttribute("Type", p10.Type);
                    StringValue:SetAttribute("Weapon", child.Name);
                    StringValue:SetAttribute("Seen", false);
                    ReplicatedStorage.Events.Action:FireClient(p11.Parent, "ItemsLog");
                    v16 = true;
                end;
            end;

            if v16 == true then
                return true;
            end;
        else
            local v18 = Config.GetItemIDFromItemData(p10);

            if p11.Inventory:FindFirstChild(v18) == nil then
                local StringValue = Instance.new("StringValue", p11.Inventory);
                StringValue.Name = v18;
                StringValue:SetAttribute("Name", p10.Name);
                StringValue:SetAttribute("Type", p10.Type);
                StringValue:SetAttribute("Weapon", p10.Weapon);
            end;

            if p11.ItemsLog:FindFirstChild(v18) == nil then
                local StringValue = Instance.new("StringValue", p11.ItemsLog);
                StringValue.Name = v18;
                StringValue:SetAttribute("Name", p10.Name);
                StringValue:SetAttribute("Type", p10.Type);
                StringValue:SetAttribute("Weapon", p10.Weapon);
                StringValue:SetAttribute("Seen", false);
                ReplicatedStorage.Events.Action:FireClient(p11.Parent, "ItemsLog");

                return true;
            end;
        end;
    elseif p10.Type == "Cash" or (p10.Type == "Credit" or (p10.Type == "Scrap" or (p10.Type == "CampaignPoints" or p10.Type == "CrateToken"))) then
        if p11.ItemsLog:FindFirstChild(p10.ID) == nil then
            p11.Stats:SetAttribute(p10.Type, p11.Stats:GetAttribute(p10.Type) + p10.Amount);
            local StringValue = Instance.new("StringValue", p11.ItemsLog);
            StringValue.Name = p10.ID;
            StringValue:SetAttribute("Name", p10.Name);
            StringValue:SetAttribute("Type", p10.Type);
            StringValue:SetAttribute("Amount", p10.Amount);
            StringValue:SetAttribute("Seen", false);

            if p10.Delete == true then
                StringValue:SetAttribute("Delete", true);
            end;

            ReplicatedStorage.Events.Action:FireClient(p11.Parent, "ItemsLog");

            return true;
        end;
    elseif p10.Type == "Crate" then
        if p11.ItemsLog:FindFirstChild(p10.ID) == nil then
            p11.Crates:SetAttribute(p10.Name, (p11.Crates:GetAttribute(p10.Name) or 0) + (p10.Amount or 1));
            local StringValue = Instance.new("StringValue", p11.ItemsLog);
            StringValue.Name = p10.ID;
            StringValue:SetAttribute("Name", p10.Name);
            StringValue:SetAttribute("Type", p10.Type);
            StringValue:SetAttribute("Amount", p10.Amount or 1);
            StringValue:SetAttribute("Seen", false);

            if p10.Delete == true then
                StringValue:SetAttribute("Delete", true);
            end;

            ReplicatedStorage.Events.Action:FireClient(p11.Parent, "ItemsLog");

            return true;
        end;
    else
        warn(Utility.warnCustom((`Tried to give item but the type is invalid: {p10.Type}`)));
        warn(p10);
    end;
end;

function u2.GiveBattlePassItems(p19, p20) -- Line: 756
    -- upvalues: u2 (copy), Utility (copy)
    local PlayerData = p19.PlayerData;

    for i = 1, PlayerData.Stats:GetAttribute("BattlePassTier") do
        if p20 == "Premium" then
            if u2.BattlepassRewards.Premium[i] == nil then
                warn(Utility.warnCustom((`Warning: No premium reward for battlepass level {i} was found`)));
            else
                u2.GiveItem(u2.BattlepassRewards.Premium[i], PlayerData, false);
            end;
        elseif p20 == "Free" and u2.BattlepassRewards.Free[i] ~= nil then
            u2.GiveItem(u2.BattlepassRewards.Free[i], PlayerData, false);
        end;
    end;
end;

function u2.RemovePack(p21, p22, p23) -- Line: 776
    -- upvalues: Config (copy)
    local PlayerData = p21.PlayerData;
    local Inventory = PlayerData.Inventory;
    local Loadout = PlayerData.Loadout;
    local v24 = false;

    for _, v in pairs(p23[p22].Items) do
        local v25 = Inventory:FindFirstChild((Config.GetItemIDFromItemData(v)));

        if v25 then
            v25:Destroy();
            v24 = true;
        end;

        for _, child in pairs(Loadout:GetChildren()) do
            if child:GetAttribute(v.Type) == v.Name then
                if v.Type == "Head" or (v.Type == "Top" or v.Type == "Bottom") then
                    child:SetAttribute(v.Type, "Mafia");
                else
                    child:SetAttribute(v.Type, "");
                end;
            end;
        end;
    end;

    return v24;
end;

local function onPromptGamePassPurchaseFinished(p26, p27, p28) -- Line: 810
    -- upvalues: u1 (copy), Utility (copy), u2 (copy), ReplicatedStorage (copy)
    print((`{u1} Processing game pass purchase... (ID: {tostring(p27)})`));
    local PlayerData = p26:WaitForChild("PlayerData", 20);

    if PlayerData == nil then
        warn(Utility.formatWarnInstanceIsNil("Player", "PlayerData", (`{tostring(p26)} purchased a gamepass ({tostring(p27)}) but the PlayerData folder is nil`)));
    end;

    local v29 = "?";

    if p28 ~= true then
        print((`{u1} Purchased failed for game pass {tostring(p27)}`));

        return;
    end;

    for i, v in pairs(u2.GamePasses) do
        if v.Items ~= nil and p27 == v.ID then
            u2.GivePack(p26, i, u2.GamePasses);
            v29 = i;
        end;
    end;

    if p27 == u2.GamePasses.BattlePass.ID then
        u2.GiveBattlePassItems(p26, "Premium");
    end;

    local v30 = false;

    for _, child in pairs(PlayerData.ItemsLog:GetChildren()) do
        if child:GetAttribute("Seen") == false then
            v30 = true;
        end;
    end;

    if v30 == true then
        ReplicatedStorage.Events.ReceivedItems:FireClient(p26);
    end;

    print((`{u1} Successfully purchased the "{v29}" game pass ({tostring(p27)})`));
    PlayerData.Stats:SetAttribute("SupportValue", PlayerData.Stats:GetAttribute("SupportValue") + u2.GamePasses[v29].Price);
end;

local function onPromptPurchaseFinished(p31, p32, p33) -- Line: 854
    -- upvalues: Utility (copy), u2 (copy), ReplicatedStorage (copy)
    if not p33 then
        return;
    end;

    local PlayerData = p31:WaitForChild("PlayerData", 20);

    if not PlayerData then
        warn(Utility.formatWarnInstanceIsNil("Player", "PlayerData", (`{p31} purchased a product ({p32}) but it failed to process because the PlayerData folder is nil`)));

        return;
    end;

    local v34 = "";

    for i, v in pairs(u2.GamePasses) do
        if v.Items ~= nil then
            if p32 == u2.GamePasses.SupporterOrange.ID or p32 == u2.GamePasses.SupporterClassic.ID then
                if p32 == v.ID then
                    u2.GivePack(p31, i, u2.GamePasses);
                end;
            elseif p32 == u2.GamePasses["E-Girl"].ID2 and p32 == v.ID2 then
                u2.GivePack(p31, i, u2.GamePasses);
            end;

            if p32 == v.ID then
                v34 = i;
            end;
        end;
    end;

    local v35 = false;

    for _, child in pairs(p31.PlayerData.ItemsLog:GetChildren()) do
        if child:GetAttribute("Seen") == false then
            v35 = true;
        end;
    end;

    if v35 == true then
        ReplicatedStorage.Events.ReceivedItems:FireClient(p31);
    end;

    if u2.GamePasses[v34] then
        PlayerData.Stats:SetAttribute("SupportValue", PlayerData.Stats:GetAttribute("SupportValue") + u2.GamePasses[v34].Price);
    end;
end;

if RunService:IsServer() then
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptGamePassPurchaseFinished);
    MarketplaceService.PromptPurchaseFinished:Connect(onPromptPurchaseFinished);
end;

return u2;