-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")

game:GetService("Players")

return table.freeze({
	setProximityPrompts = function(p1) --[[ setProximityPrompts | Line: 13 | Upvalues: CollectionService (copy) ]]
		local v1 = CollectionService:GetTagged("BarricadeFrame")

		if not (#v1 > 0) then
			return
		end

		for k, v in pairs(v1) do
			local ProximityPrompt = v:FindFirstChild("ProximityPrompt", true)

			if ProximityPrompt then
				ProximityPrompt.Enabled = p1
			end
		end
	end
})