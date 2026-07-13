
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.InvasionTypes);

return table.freeze({
    AMBIENCE_SOUND = {
        SoundId = "rbxassetid://112434650594360",
        Volume = 1
    },
    ROUND_START_SOUND = {
        SoundId = "rbxassetid://133603874583192",
        Volume = 1
    },
    ROUND_ENDED_SOUND = {
        SoundId = "rbxassetid://97599619803773",
        Volume = 1
    },
    GAME_WON_SOUND = {
        SoundId = "rbxassetid://83735906984296",
        Volume = 1
    },
    GAME_LOST_SOUND = {
        SoundId = "rbxassetid://106423447854005",
        Volume = 1
    }
});