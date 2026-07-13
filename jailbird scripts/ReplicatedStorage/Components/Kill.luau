-- https://lua.expert/
local t = {}

t.__index = t
function t.new(p1, p2) --[[ new | Line: 8 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)

	v2.Tycoon = p1
	v2.Instance = p2

	return v2
end
function t.Init(p1) --[[ Init | Line: 30 ]]
	p1.Instance.Touched:Connect(function(...) --[[ Line: 33 | Upvalues: p1 (copy) ]]
		p1:OnTouched(...)
	end)
end
function t.OnTouched(p1, p2) --[[ OnTouched | Line: 46 ]]
	local v1 = p2:FindFirstAncestorWhichIsA("Model")
	local v2 = if v1 then v1:FindFirstChild("Humanoid") else v1

	if not v2 or v1 == p1.Tycoon.Owner.Character then
		return
	end

	v2:TakeDamage(100)
end

return t