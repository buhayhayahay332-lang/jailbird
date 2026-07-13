
game:GetService("Players");
local u1 = {
    RankCategories = {
        {
            Name = "Bronze",
            Image = 14837648984,
            MinRating = 0,
            MaxRating = 500,
            Color = Color3.fromRGB(120, 85, 55)
        },
        {
            Name = "Silver",
            Image = 14837648026,
            MinRating = 500,
            MaxRating = 1400,
            Color = Color3.fromRGB(80, 80, 80)
        },
        {
            Name = "Gold",
            Image = 14837649910,
            MinRating = 1400,
            MaxRating = 2400,
            Color = Color3.fromRGB(175, 125, 0)
        },
        {
            Name = "Diamond",
            Image = 15111463612,
            MinRating = 2400,
            MaxRating = 3700,
            Color = Color3.fromRGB(157, 229, 255)
        },
        {
            Name = "Supreme",
            Image = 14837647148,
            MinRating = 3700,
            MaxRating = 5600,
            Color = Color3.fromRGB(190, 49, 52)
        },
        {
            Name = "Champion",
            Image = 14837651185,
            MinRating = 5600,
            MaxRating = 8000,
            Color = Color3.fromRGB(77, 35, 215)
        },
        {
            Name = "Global",
            Image = 14837650200,
            MinRating = 8000,
            MaxRating = 20000,
            Color = Color3.fromRGB(255, 255, 200)
        },
        {
            Name = "Apex",
            Image = 15111463942,
            MinRating = 20000,
            MaxRating = 50000,
            Color = Color3.fromRGB(255, 0, 100)
        },
        {
            Name = "Emperor",
            Image = 15111462776,
            MinRating = 50000,
            MaxRating = 1000000,
            Color = Color3.fromRGB(0, 255, 65)
        }
    },
    UniversalRewards = {
        Season1 = { {
                Name = "Season 1 Player",
                Type = "Title"
            } }
    },
    Ranks = {
        {
            Name = "Unranked",
            Image = 14837715026,
            MinRating = 0,
            MaxRating = 1
        },
        {
            Name = "Bronze1",
            Image = 14837648984,
            MinRating = 1,
            MaxRating = 150
        },
        {
            Name = "Bronze2",
            Image = 14837648603,
            MinRating = 150,
            MaxRating = 300
        },
        {
            Name = "Bronze3",
            Image = 14837648362,
            MinRating = 300,
            MaxRating = 500
        },
        {
            Name = "Silver1",
            Image = 14837648026,
            MinRating = 500,
            MaxRating = 700
        },
        {
            Name = "Silver2",
            Image = 14837647818,
            MinRating = 700,
            MaxRating = 900
        },
        {
            Name = "Silver3",
            Image = 14837647599,
            MinRating = 900,
            MaxRating = 1100
        },
        {
            Name = "Silver4",
            Image = 14837647396,
            MinRating = 1100,
            MaxRating = 1400
        },
        {
            Name = "Gold1",
            Image = 14837649910,
            MinRating = 1400,
            MaxRating = 1700
        },
        {
            Name = "Gold2",
            Image = 14837649557,
            MinRating = 1700,
            MaxRating = 2000
        },
        {
            Name = "Gold3",
            Image = 14837649238,
            MinRating = 2000,
            MaxRating = 2400
        },
        {
            Name = "Diamond1",
            Image = 15111463612,
            MinRating = 2400,
            MaxRating = 2800
        },
        {
            Name = "Diamond2",
            Image = 15111463387,
            MinRating = 2800,
            MaxRating = 3200
        },
        {
            Name = "Diamond3",
            Image = 15111463170,
            MinRating = 3200,
            MaxRating = 3700
        },
        {
            Name = "Supreme1",
            Image = 14837647148,
            MinRating = 3700,
            MaxRating = 4300
        },
        {
            Name = "Supreme2",
            Image = 14837646904,
            MinRating = 4300,
            MaxRating = 5000
        },
        {
            Name = "Supreme3",
            Image = 14837646550,
            MinRating = 5000,
            MaxRating = 5800
        },
        {
            Name = "Champion1",
            Image = 14837651185,
            MinRating = 5800,
            MaxRating = 7600
        },
        {
            Name = "Champion2",
            Image = 14837650647,
            MinRating = 7600,
            MaxRating = 8400
        },
        {
            Name = "Global",
            Image = 14837650200,
            MinRating = 8400,
            MaxRating = 25000
        },
        {
            Name = "Apex",
            Image = 15111463942,
            MinRating = 25000,
            MaxRating = 60000
        },
        {
            Name = "Emperor",
            Image = 15111462776,
            MinRating = 60000,
            MaxRating = (1 / 0)
        }
    },
    RankedRewards = {
        Season1 = {
            [2] = { {
                    Name = "Season 1 Bronze",
                    Type = "Title"
                } },
            [5] = { {
                    Name = "Season 1 Silver",
                    Type = "Title"
                } },
            [9] = { {
                    Name = "Season 1 Gold",
                    Type = "Title"
                } },
            [12] = { {
                    Name = "Season 1 Diamond",
                    Type = "Title"
                } },
            [15] = { {
                    Name = "Season 1 Supreme",
                    Type = "Title"
                } },
            [18] = { {
                    Name = "Season 1 Champion",
                    Type = "Title"
                } },
            [20] = { {
                    Name = "Season 1 Global",
                    Type = "Title"
                } },
            [21] = { {
                    Name = "Season 1 Apex",
                    Type = "Title"
                } },
            [22] = { {
                    Name = "Season 1 Emperor",
                    Type = "Title"
                } }
        },
        Season2 = {
            [2] = { {
                    Name = "Season 2 Bronze",
                    Type = "Title"
                } },
            [4] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S2_Ranked_4_1"
                } },
            [5] = { {
                    Name = "Season 2 Silver",
                    Type = "Title"
                } },
            [8] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S2_Ranked_8_1"
                } },
            [9] = { {
                    Name = "Season 2 Gold",
                    Type = "Title"
                } },
            [11] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S2_Ranked_11_1"
                } },
            [12] = { {
                    Name = "Season 2 Diamond",
                    Type = "Title"
                } },
            [14] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S2_Ranked_14_1"
                } },
            [15] = { {
                    Name = "Season 2 Supreme",
                    Type = "Title"
                } },
            [17] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S2_Ranked_17_1"
                } },
            [18] = { {
                    Name = "Season 2 Champion",
                    Type = "Title"
                } },
            [19] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "500",
                    ID = "S2_Ranked_19_1"
                } },
            [20] = { {
                    Name = "Season 2 Global",
                    Type = "Title"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "700",
                    ID = "S2_Ranked_20_2"
                } },
            [21] = { {
                    Name = "Season 2 Apex",
                    Type = "Title"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "1300",
                    ID = "S2_Ranked_21_2"
                } },
            [22] = { {
                    Name = "Season 2 Emperor",
                    Type = "Title"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "3000",
                    ID = "S2_Ranked_22_2"
                } }
        },
        Season3 = {
            [2] = { {
                    Name = "Season 3 Bronze",
                    Type = "Title"
                }, {
                    Name = "Season 3 Bronze",
                    Type = "Charm"
                } },
            [4] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_4_1"
                } },
            [5] = { {
                    Name = "Season 3 Silver",
                    Type = "Title"
                }, {
                    Name = "Season 3 Silver",
                    Type = "Charm"
                } },
            [8] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_8_1"
                } },
            [9] = { {
                    Name = "Season 3 Gold",
                    Type = "Title"
                }, {
                    Name = "Season 3 Gold",
                    Type = "Charm"
                } },
            [11] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_11_1"
                } },
            [12] = { {
                    Name = "Season 3 Diamond",
                    Type = "Title"
                }, {
                    Name = "Season 3 Diamond",
                    Type = "Charm"
                } },
            [14] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_14_1"
                } },
            [15] = { {
                    Name = "Season 3 Supreme",
                    Type = "Title"
                }, {
                    Name = "Season 3 Supreme",
                    Type = "Charm"
                } },
            [17] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_17_1"
                } },
            [18] = { {
                    Name = "Season 3 Champion",
                    Type = "Title"
                }, {
                    Name = "Season 3 Champion",
                    Type = "Charm"
                } },
            [19] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "500",
                    ID = "S3_Ranked_19_1"
                } },
            [20] = { {
                    Name = "Season 3 Global",
                    Type = "Title"
                }, {
                    Name = "Season 3 Global",
                    Type = "Charm"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "700",
                    ID = "S3_Ranked_20_3"
                } },
            [21] = { {
                    Name = "Season 3 Apex",
                    Type = "Title"
                }, {
                    Name = "Season 3 Apex",
                    Type = "Charm"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "1300",
                    ID = "S3_Ranked_21_3"
                } },
            [22] = { {
                    Name = "Season 3 Emperor",
                    Type = "Title"
                }, {
                    Name = "Season 3 Emperor",
                    Type = "Charm"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "3000",
                    ID = "S3_Ranked_22_3"
                } }
        },
        Season4 = {
            [2] = { {
                    Name = "S4Ranked Bronze",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Bronze",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Bronze",
                    Type = "Bottom"
                } },
            [4] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_4_1"
                } },
            [5] = { {
                    Name = "S4Ranked Silver",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Silver",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Silver",
                    Type = "Bottom"
                } },
            [8] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_8_1"
                } },
            [9] = { {
                    Name = "S4Ranked Gold",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Gold",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Gold",
                    Type = "Bottom"
                } },
            [11] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_11_1"
                } },
            [12] = { {
                    Name = "S4Ranked Diamond",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Diamond",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Diamond",
                    Type = "Bottom"
                } },
            [14] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_14_1"
                } },
            [15] = { {
                    Name = "S4Ranked Supreme",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Supreme",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Supreme",
                    Type = "Bottom"
                } },
            [17] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S3_Ranked_17_1"
                } },
            [18] = { {
                    Name = "S4Ranked Champion",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Champion",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Champion",
                    Type = "Bottom"
                } },
            [19] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "500",
                    ID = "S3_Ranked_19_1"
                } },
            [20] = { {
                    Name = "S4Ranked Global",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Global",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Global",
                    Type = "Bottom"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "700",
                    ID = "S3_Ranked_20_3"
                } },
            [21] = { {
                    Name = "S4Ranked Apex",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Apex",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Apex",
                    Type = "Bottom"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "1300",
                    ID = "S3_Ranked_21_3"
                } },
            [22] = { {
                    Name = "S4Ranked Emperor",
                    Type = "Head"
                }, {
                    Name = "S4Ranked Emperor",
                    Type = "Top"
                }, {
                    Name = "S4Ranked Emperor",
                    Type = "Bottom"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "3000",
                    ID = "S3_Ranked_22_3"
                } }
        },
        Season5 = {
            [2] = { {
                    Name = "S5 Ranked Bronze",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Bronze",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Bronze",
                    Type = "Bottom"
                }, {
                    Name = "S5 Ranked Bronze",
                    Type = "Skin"
                } },
            [4] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S5_Ranked_4_1"
                } },
            [5] = { {
                    Name = "S5 Ranked Silver",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Silver",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Silver",
                    Type = "Bottom"
                }, {
                    Name = "S5 Ranked Silver",
                    Type = "Skin"
                } },
            [8] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S5_Ranked_8_1"
                } },
            [9] = { {
                    Name = "S5 Ranked Gold",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Gold",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Gold",
                    Type = "Bottom"
                }, {
                    Name = "S5 Ranked Gold",
                    Type = "Skin"
                } },
            [11] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S5_Ranked_11_1"
                } },
            [12] = { {
                    Name = "S5 Ranked Diamond",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Diamond",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Diamond",
                    Type = "Bottom"
                }, {
                    Name = "S5 Ranked Diamond",
                    Type = "Skin"
                } },
            [14] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S5_Ranked_14_1"
                } },
            [15] = { {
                    Name = "S5 Ranked Supreme",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Supreme",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Supreme",
                    Type = "Bottom"
                }, {
                    Name = "S5 Ranked Supreme",
                    Type = "Skin"
                } },
            [17] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "200",
                    ID = "S5_Ranked_17_1"
                } },
            [18] = { {
                    Name = "S5 Ranked Champion",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Champion",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Champion",
                    Type = "Bottom"
                }, {
                    Name = "S5 Ranked Champion",
                    Type = "Skin"
                } },
            [19] = { {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "500",
                    ID = "S5_Ranked_19_1"
                } },
            [20] = { {
                    Name = "S5 Ranked Global",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Global",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Global",
                    Type = "Bottom"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "700",
                    ID = "S5_Ranked_20_3"
                }, {
                    Name = "S5 Ranked Global",
                    Type = "Skin"
                } },
            [21] = { {
                    Name = "S5 Ranked Apex",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Apex",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Apex",
                    Type = "Bottom"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "1300",
                    ID = "S5_Ranked_21_3"
                }, {
                    Name = "S5 Ranked Apex",
                    Type = "Skin"
                } },
            [22] = { {
                    Name = "S5 Ranked Emperor",
                    Type = "Head"
                }, {
                    Name = "S5 Ranked Emperor",
                    Type = "Top"
                }, {
                    Name = "S5 Ranked Emperor",
                    Type = "Bottom"
                }, {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "3000",
                    ID = "S5_Ranked_22_3"
                }, {
                    Name = "S5 Ranked Emperor",
                    Type = "Skin"
                } }
        }
    }
};

function u1.GetRankedImage(p2) -- Line: 474
    -- upvalues: u1 (copy)
    for i, v in pairs(u1.Ranks) do
        if v.MinRating <= p2 and p2 < v.MaxRating then
            return v.Image, i;
        end;
    end;
end;

function u1.GetNextRanked(p3) -- Line: 483
    -- upvalues: u1 (copy)
    local v4 = (1 / 0);
    local v5 = {};

    for _, v in pairs(u1.Ranks) do
        if p3 < v.MinRating and v.MinRating < v4 then
            v4 = v.MinRating;
            v5 = v;
        end;
    end;

    return v5;
end;

return u1;