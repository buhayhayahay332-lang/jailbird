
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Modules.TypeModules.InvasionTypes);

return table.freeze({
    AMBIENCE_SOUND = {
        SoundId = "rbxassetid://98989762409634",
        Volume = 1
    },
    ROUND_START_SOUND = {
        SoundId = "rbxassetid://132082800658218",
        Volume = 1
    },
    ROUND_ENDED_SOUND = {
        SoundId = "rbxassetid://103074261201724",
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