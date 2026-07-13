-- https://lua.expert/
return {
	getUserFlag = function(p1) --[[ getUserFlag | Line: 11 ]]
		local ok, result = pcall(function() --[[ Line: 12 | Upvalues: p1 (copy) ]]
			return UserSettings():IsUserFeatureEnabled(p1)
		end)

		return ok and result
	end
}