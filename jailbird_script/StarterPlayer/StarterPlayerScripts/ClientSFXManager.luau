local v_u_1 = game:GetService("TweenService")
local _ = game.ReplicatedStorage.Audio
return {
	["SoundTransition"] = function(p2, p3) -- name: SoundTransition
		-- upvalues: (copy) v_u_1
		v_u_1:Create(p2, TweenInfo.new(1), {
			["Volume"] = p3
		}):Play()
	end,
	["SwapAudio"] = function(p4, p5) -- name: SwapAudio
		-- upvalues: (copy) v_u_1
		v_u_1:Create(p4, TweenInfo.new(2), {
			["Volume"] = 0
		}):Play()
		wait(1)
		p4.SoundId = p5.SoundId
		v_u_1:Create(p4, TweenInfo.new(2), {
			["Volume"] = 0.1
		}):Play()
	end
}