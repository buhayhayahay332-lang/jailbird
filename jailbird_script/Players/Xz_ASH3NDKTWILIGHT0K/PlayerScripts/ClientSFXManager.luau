
local TweenService = game:GetService("TweenService");
local _ = game.ReplicatedStorage.Audio;

return {
    SoundTransition = function(p1, p2) -- Line: 8, Name: SoundTransition
        -- upvalues: TweenService (copy)
        TweenService:Create(p1, TweenInfo.new(1), {
            Volume = p2
        }):Play();
    end,

    SwapAudio = function(p3, p4) -- Line: 14, Name: SwapAudio
        -- upvalues: TweenService (copy)
        TweenService:Create(p3, TweenInfo.new(2), {
            Volume = 0
        }):Play();
        wait(1);
        p3.SoundId = p4.SoundId;
        TweenService:Create(p3, TweenInfo.new(2), {
            Volume = 0.1
        }):Play();
    end
};