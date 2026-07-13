-- https://lua.expert/
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Utility"))
local t = {
	fadeOffBody = function(p1, p2) --[[ fadeOffBody | Line: 13 | Upvalues: RunService (copy) ]]
		if not p2 then
			return
		end

		local list = {}
		local v1 = nil

		for i, v in ipairs(p2:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("MeshPart") then
				if v.Transparency ~= 1 then
					table.insert(list, v)

					if v.Name == "face" then
						v1 = v
					end
				end
			elseif v.Name == "face" then
				v1 = v
			end
		end

		for i, v in ipairs(list) do
			v.CollisionGroup = "DeadPlayers"
		end

		task.wait(5)

		local v2 = 0
		local v3 = 0
		local v4 = nil

		v4 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 41 | Upvalues: p2 (copy), v4 (ref), v2 (ref), v3 (ref), list (copy), v1 (ref) ]]
			if not p2 then
				v4:Disconnect()
			end

			v2 = math.clamp(v3 / 2, 0, 1)

			for i, v in ipairs(list) do
				if v then
					v.Transparency = v2
				end
			end

			if v1 then
				v1.Transparency = v2
			end

			if v3 >= 2 then
				v4:Disconnect()
			end

			v3 = v3 + p1
		end)
	end,
	connectFadeOffEvent = function(p1, p2) --[[ connectFadeOffEvent | Line: 69 ]] end
}

for i, v in ipairs(Players:GetPlayers()) do
	task.spawn(function() --[[ Line: 75 | Upvalues: v (copy), t (copy) ]]
		v.CharacterAdded:Connect(function(p1) --[[ Line: 76 | Upvalues: t (ref) ]]
			t:connectFadeOffEvent(p1)
		end)

		if not v.Character then
			return
		end

		t:connectFadeOffEvent(v.Character)
	end)
end

Players.PlayerAdded:Connect(function(p1) --[[ Line: 87 | Upvalues: t (copy) ]]
	p1.CharacterAdded:Connect(function(p1) --[[ Line: 88 | Upvalues: t (ref) ]]
		t:connectFadeOffEvent(p1)
	end)
end)
Utility:DeepFreeze(t)

return t