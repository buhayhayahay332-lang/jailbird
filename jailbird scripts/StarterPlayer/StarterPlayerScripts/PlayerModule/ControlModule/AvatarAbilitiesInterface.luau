local v1 = script.Parent.Parent:WaitForChild("CommonUtils")
if require(v1:WaitForChild("FlagUtil")).getUserFlag("UserAllowAbilityControls") then
	local v_u_2 = game:GetService("Players")
	local v3 = {}
	local v_u_4 = nil
	local v_u_5 = nil
	local v_u_6 = Instance.new("BindableEvent")
	local v_u_7 = nil
	local v_u_8 = false
	local function v_u_10(p9) -- name: characterAdded
		-- upvalues: (ref) v_u_4, (ref) v_u_5, (ref) v_u_7, (copy) v_u_6
		v_u_4 = nil
		v_u_5 = nil
		if v_u_7 then
			v_u_7:Disconnect()
			v_u_7 = nil
		end
		if p9 then
			v_u_4 = p9:FindFirstChild("AbilityManagerActor")
			v_u_5 = p9:FindFirstChildOfClass("Humanoid")
			while not v_u_5 do
				p9.ChildAdded:wait()
				v_u_5 = p9:FindFirstChildOfClass("Humanoid")
			end
			v_u_6:Fire()
			v_u_7 = v_u_5:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function()
				-- upvalues: (ref) v_u_6
				v_u_6:Fire()
			end)
		end
	end
	function v3.isEnabled() -- name: isEnabled
		-- upvalues: (ref) v_u_8, (copy) v_u_2, (copy) v_u_10, (ref) v_u_4, (ref) v_u_5
		if not v_u_8 then
			v_u_8 = true
			local v11 = v_u_2.LocalPlayer
			if v11 then
				v11.characterAdded:Connect(v_u_10)
				if v11.Character then
					v_u_10(v11.Character)
				end
			end
		end
		local v12 = v_u_4 ~= nil and v_u_5
		if v12 then
			v12 = not v_u_5.EvaluateStateMachine
		end
		return v12
	end
	function v3.GetEnabledChangedSignal() -- name: GetEnabledChangedSignal
		-- upvalues: (ref) v_u_8, (copy) v_u_2, (copy) v_u_10, (copy) v_u_6
		if not v_u_8 then
			v_u_8 = true
			local v13 = v_u_2.LocalPlayer
			if v13 then
				v13.characterAdded:Connect(v_u_10)
				if v13.Character then
					v_u_10(v13.Character)
				end
			end
		end
		return v_u_6.Event
	end
	return v3
end