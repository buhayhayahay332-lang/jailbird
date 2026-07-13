
return {
    GetDailyRewards = function(p1) -- Line: 10, Name: GetDailyRewards
        return {
            Game = {
                [1800] = {
                    Name = "Regular",
                    Type = "Crate",
                    ID = "Day" .. p1 .. "_Game_1"
                },
                [3600] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "30",
                    ID = "Day" .. p1 .. "_Game_2"
                },
                [5400] = {
                    Name = "Daily",
                    Type = "Crate",
                    ID = "Day" .. p1 .. "_Game_3"
                },
                [7200] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "30",
                    ID = "Day" .. p1 .. "_Game_4"
                },
                [9000] = {
                    Name = "Regular",
                    Type = "Crate",
                    ID = "Day" .. p1 .. "_Game_5"
                },
                [10800] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "30",
                    ID = "Day" .. p1 .. "_Game_6"
                },
                [12600] = {
                    Name = "Daily",
                    Type = "Crate",
                    ID = "Day" .. p1 .. "_Game_7"
                },
                [14400] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "100",
                    ID = "Day" .. p1 .. "_Game_8"
                }
            },
            Lobby = {
                [1800] = {
                    Name = "Regular",
                    Type = "Crate",
                    ID = "Day" .. p1 .. "_Lobby_1"
                },
                [3600] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "30",
                    ID = "Day" .. p1 .. "_Lobby_2"
                },
                [5400] = {
                    Name = "Daily",
                    Type = "Crate",
                    ID = "Day" .. p1 .. "_Lobby_3"
                },
                [7200] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "30",
                    ID = "Day" .. p1 .. "_Lobby_4"
                },
                [9000] = {
                    Name = "Regular",
                    Type = "Crate",
                    ID = "Day" .. p1 .. "_Lobby_5"
                },
                [10800] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "30",
                    ID = "Day" .. p1 .. "_Lobby_6"
                },
                [12600] = {
                    Name = "Daily",
                    Type = "Crate",
                    ID = "Day" .. p1 .. "_Lobby_7"
                },
                [14400] = {
                    Name = "Credit",
                    Type = "Credit",
                    Amount = "100",
                    ID = "Day" .. p1 .. "_Lobby_8"
                }
            }
        };
    end
};