local v_u_1 = {}
v_u_1.__index = v_u_1
setmetatable(v_u_1, {
	["__call"] = function(_, ...) -- name: __call
		-- upvalues: (copy) v_u_1
		return v_u_1.new(...)
	end
})
function v_u_1.new() -- name: new
	-- upvalues: (copy) v_u_1
	local v2 = v_u_1
	return setmetatable({}, v2)
end
function v_u_1.CharacterAdded(_, _, _) -- name: CharacterAdded end
function v_u_1.CharacterRemoving(_, _, _) -- name: CharacterRemoving end
function v_u_1.OnCameraSubjectChanged(_, _) -- name: OnCameraSubjectChanged end
function v_u_1.GetOcclusionMode(_) -- name: GetOcclusionMode
	warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")
	return nil
end
function v_u_1.Enable(_, _) -- name: Enable
	warn("BaseOcclusion Enable must be overridden by derived classes")
end
function v_u_1.Update(_, _, p3, p4) -- name: Update
	warn("BaseOcclusion Update must be overridden by derived classes")
	return p3, p4
end
return v_u_1