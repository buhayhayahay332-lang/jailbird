local v_u_1 = game:GetService("ContextActionService")
local v_u_2 = game:GetService("UserInputService")
local v3 = game:GetService("Players")
game:GetService("RunService")
local v_u_4 = UserSettings():GetService("UserGameSettings")
local v_u_5 = game:GetService("VRService")
local v_u_6 = game:GetService("GuiService")
local v7 = script.Parent.Parent:WaitForChild("CommonUtils")
local v8 = require(v7:WaitForChild("FlagUtil"))
local v_u_9 = v8.getUserFlag("UserPSSinkUnknownTouchEvents")
local v10 = v8.getUserFlag("UserPSTextboxResetCameraInput")
local v11 = v8.getUserFlag("UserFixVRCameraGamepadReset")
local v_u_12 = v3.LocalPlayer
local v_u_13 = Enum.ContextActionPriority.Medium.Value
local v_u_14 = Vector2.new(1, 0.77) * 0.06981317007977318 * 60
local v_u_15 = Vector2.new(1, 0.77) * 0.008726646259971648
local v_u_16 = Vector2.new(1, 0.77) * 0.12217304763960307
local v_u_17 = Vector2.new(1, 0.66) * 0.017453292519943295
local v_u_18 = Instance.new("BindableEvent")
local v_u_19 = Instance.new("BindableEvent")
local v_u_20 = v_u_18.Event
local v_u_21 = v_u_19.Event
v_u_2.InputBegan:Connect(function(p22, p23)
	-- upvalues: (copy) v_u_18
	if not p23 and p22.UserInputType == Enum.UserInputType.MouseButton2 then
		v_u_18:Fire()
	end
end)
v_u_2.InputEnded:Connect(function(p24, _)
	-- upvalues: (copy) v_u_19
	if p24.UserInputType == Enum.UserInputType.MouseButton2 then
		v_u_19:Fire()
	end
end)
local function v_u_28(p25) -- name: thumbstickCurve
	local v26 = (math.abs(p25) - 0.1) / 0.9 * 2
	local v27 = (math.exp(v26) - 1) / 6.38905609893065
	return math.sign(p25) * math.clamp(v27, 0, 1)
end
local function v_u_33(p29) -- name: adjustTouchPitchSensitivity
	local v30 = workspace.CurrentCamera
	if not v30 then
		return p29
	end
	local v31 = v30.CFrame:ToEulerAnglesYXZ()
	if p29.Y * v31 >= 0 then
		return p29
	end
	local v32 = (1 - (math.abs(v31) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25
	return Vector2.new(1, v32) * p29
end
local function v_u_40(p34) -- name: isInDynamicThumbstickArea
	-- upvalues: (copy) v_u_12
	local v35 = v_u_12:FindFirstChildOfClass("PlayerGui")
	if v35 then
		v35 = v35:FindFirstChild("TouchGui")
	end
	local v36
	if v35 then
		v36 = v35:FindFirstChild("TouchControlFrame")
	else
		v36 = v35
	end
	if v36 then
		v36 = v36:FindFirstChild("DynamicThumbstickFrame")
	end
	if not v36 then
		return false
	end
	if not v35.Enabled then
		return false
	end
	local v37 = v36.AbsolutePosition
	local v38 = v37 + v36.AbsoluteSize
	local v39
	if p34.X >= v37.X and (p34.Y >= v37.Y and p34.X <= v38.X) then
		v39 = p34.Y <= v38.Y
	else
		v39 = false
	end
	return v39
end
local v41 = {}
local v_u_42 = {}
local v_u_43 = 0
local v_u_44 = {
	["Thumbstick2"] = Vector2.new()
}
local v_u_45 = {
	["Left"] = 0,
	["Right"] = 0,
	["I"] = 0,
	["O"] = 0
}
local v_u_46 = {
	["Movement"] = nil,
	["Wheel"] = 0,
	["Pan"] = nil,
	["Pinch"] = 0,
	["Movement"] = Vector2.new(),
	["Pan"] = Vector2.new()
}
local v_u_47 = {
	["Move"] = nil,
	["Pinch"] = 0,
	["Move"] = Vector2.new()
}
local v_u_48 = Instance.new("BindableEvent")
v41.gamepadZoomPress = v_u_48.Event
local v_u_49
if v11 then
	v_u_49 = Instance.new("BindableEvent")
	v41.gamepadReset = v_u_49.Event
else
	v_u_49 = v_u_5.VREnabled and Instance.new("BindableEvent") or nil
	if v_u_5.VREnabled then
		v41.gamepadReset = v_u_49.Event
	end
end
function v41.getRotationActivated() -- name: getRotationActivated
	-- upvalues: (ref) v_u_43, (copy) v_u_44
	return v_u_43 > 0 and true or v_u_44.Thumbstick2.Magnitude > 0
end
function v41.getRotation(p50, p51) -- name: getRotation
	-- upvalues: (copy) v_u_4, (copy) v_u_45, (copy) v_u_44, (copy) v_u_46, (copy) v_u_33, (copy) v_u_47, (copy) v_u_14, (copy) v_u_15, (copy) v_u_16, (copy) v_u_17
	local v52 = Vector2.new(1, v_u_4:GetCameraYInvertValue())
	local v53 = Vector2.new(v_u_45.Right - v_u_45.Left, 0) * p50
	local v54 = v_u_44.Thumbstick2 * v_u_4.GamepadCameraSensitivity * p50
	local v55 = v_u_46.Movement
	local v56 = v_u_46.Pan
	local v57 = v_u_33(v_u_47.Move)
	if p51 then
		v53 = Vector2.new()
	end
	return (v53 * 2.0943951023931953 + v54 * v_u_14 + v55 * v_u_15 + v56 * v_u_16 + v57 * v_u_17) * v52
end
function v41.getZoomDelta() -- name: getZoomDelta
	-- upvalues: (copy) v_u_45, (copy) v_u_46, (copy) v_u_47
	local v58 = v_u_45.O - v_u_45.I
	local v59 = -v_u_46.Wheel + v_u_46.Pinch
	local v60 = -v_u_47.Pinch
	return v58 * 0.1 + v59 * 1 + v60 * 0.04
end
local function v_u_63(_, _, p61) -- name: thumbstick
	-- upvalues: (copy) v_u_44, (ref) v_u_28
	local v62 = p61.Position
	v_u_44[p61.KeyCode.Name] = Vector2.new(v_u_28(v62.X), -v_u_28(v62.Y))
	return Enum.ContextActionResult.Pass
end
local function v_u_66(_, p64, p65) -- name: keypress
	-- upvalues: (copy) v_u_45
	v_u_45[p65.KeyCode.Name] = p64 == Enum.UserInputState.Begin and 1 or 0
end
local function v_u_68(_, p67, _) -- name: gamepadZoomPress
	-- upvalues: (copy) v_u_48
	if p67 == Enum.UserInputState.Begin then
		v_u_48:Fire()
	end
end
local function v_u_70(_, p69, _) -- name: gamepadReset
	-- upvalues: (ref) v_u_49
	if p69 == Enum.UserInputState.Begin then
		v_u_49:Fire()
	end
end
local function v_u_75() -- name: resetInputDevices
	-- upvalues: (copy) v_u_44, (copy) v_u_45, (copy) v_u_46, (copy) v_u_47, (ref) v_u_43
	local v71 = {
		v_u_44,
		v_u_45,
		v_u_46,
		v_u_47
	}
	for _, v72 in pairs(v71) do
		for v73, v74 in pairs(v72) do
			if type(v74) == "boolean" then
				v72[v73] = false
			else
				v72[v73] = v72[v73] * 0
			end
		end
	end
	v_u_43 = 0
end
local v_u_76 = {}
local v_u_77 = nil
local v_u_78 = nil
local function v_u_84(p79, p80) -- name: touchBegan
	-- upvalues: (ref) v_u_77, (copy) v_u_40, (ref) v_u_43, (ref) v_u_76
	local v81 = p79.UserInputType == Enum.UserInputType.Touch
	assert(v81)
	local v82 = p79.UserInputState == Enum.UserInputState.Begin
	assert(v82)
	if v_u_77 == nil and (v_u_40(p79.Position) and not p80) then
		v_u_77 = p79
	else
		if not p80 then
			local v83 = v_u_43 + 1
			v_u_43 = math.max(0, v83)
		end
		v_u_76[p79] = p80
	end
end
local function v_u_89(p85, _) -- name: touchEnded
	-- upvalues: (ref) v_u_77, (ref) v_u_76, (ref) v_u_78, (ref) v_u_43
	local v86 = p85.UserInputType == Enum.UserInputType.Touch
	assert(v86)
	local v87 = p85.UserInputState == Enum.UserInputState.End
	assert(v87)
	if p85 == v_u_77 then
		v_u_77 = nil
	end
	if v_u_76[p85] == false then
		v_u_78 = nil
		local v88 = v_u_43 - 1
		v_u_43 = math.max(0, v88)
	end
	v_u_76[p85] = nil
end
local function v_u_101(p90, p91) -- name: touchChanged
	-- upvalues: (ref) v_u_77, (ref) v_u_76, (copy) v_u_9, (copy) v_u_47, (ref) v_u_78
	local v92 = p90.UserInputType == Enum.UserInputType.Touch
	assert(v92)
	local v93 = p90.UserInputState == Enum.UserInputState.Change
	assert(v93)
	if p90 == v_u_77 then
		return
	else
		if v_u_76[p90] == nil then
			if v_u_9 then
				v_u_76[p90] = true
			else
				v_u_76[p90] = p91
			end
		end
		local v94 = {}
		for v95, v96 in pairs(v_u_76) do
			if not v96 then
				table.insert(v94, v95)
			end
		end
		if #v94 == 1 and v_u_76[p90] == false then
			local v97 = p90.Delta
			local v98 = v_u_47
			v98.Move = v98.Move + Vector2.new(v97.X, v97.Y)
		end
		if #v94 == 2 then
			local v99 = (v94[1].Position - v94[2].Position).Magnitude
			if v_u_78 then
				local v100 = v_u_47
				v100.Pinch = v100.Pinch + (v99 - v_u_78)
			end
			v_u_78 = v99
		else
			v_u_78 = nil
		end
	end
end
local function v_u_102() -- name: resetTouchState
	-- upvalues: (ref) v_u_76, (ref) v_u_77, (ref) v_u_78, (ref) v_u_43
	v_u_76 = {}
	v_u_77 = nil
	v_u_78 = nil
	v_u_43 = 0
end
local function v_u_107(p103, p104, p105, p106) -- name: pointerAction
	-- upvalues: (copy) v_u_46
	if not p106 then
		v_u_46.Wheel = p103
		v_u_46.Pan = p104
		v_u_46.Pinch = -p105
	end
end
local function v_u_111(p108, p109) -- name: inputBegan
	-- upvalues: (ref) v_u_84, (ref) v_u_43
	if p108.UserInputType == Enum.UserInputType.Touch then
		v_u_84(p108, p109)
	elseif p108.UserInputType == Enum.UserInputType.MouseButton2 and not p109 then
		local v110 = v_u_43 + 1
		v_u_43 = math.max(0, v110)
	end
end
local function v_u_115(p112, p113) -- name: inputChanged
	-- upvalues: (ref) v_u_101, (copy) v_u_46
	if p112.UserInputType == Enum.UserInputType.Touch then
		v_u_101(p112, p113)
	elseif p112.UserInputType == Enum.UserInputType.MouseMovement then
		local v114 = p112.Delta
		v_u_46.Movement = Vector2.new(v114.X, v114.Y)
	end
end
local function v_u_119(p116, p117) -- name: inputEnded
	-- upvalues: (ref) v_u_89, (ref) v_u_43
	if p116.UserInputType == Enum.UserInputType.Touch then
		v_u_89(p116, p117)
	elseif p116.UserInputType == Enum.UserInputType.MouseButton2 then
		local v118 = v_u_43 - 1
		v_u_43 = math.max(0, v118)
	end
end
local v_u_120 = false
function v41.setInputEnabled(p121) -- name: setInputEnabled
	-- upvalues: (ref) v_u_120, (copy) v_u_75, (ref) v_u_102, (copy) v_u_1, (copy) v_u_63, (copy) v_u_13, (copy) v_u_66, (copy) v_u_5, (copy) v_u_70, (copy) v_u_68, (ref) v_u_42, (copy) v_u_2, (copy) v_u_111, (copy) v_u_115, (copy) v_u_119, (copy) v_u_107, (copy) v_u_6
	if v_u_120 == p121 then
		return
	else
		v_u_120 = p121
		v_u_75()
		v_u_102()
		if v_u_120 then
			v_u_1:BindActionAtPriority("RbxCameraThumbstick", v_u_63, false, v_u_13, Enum.KeyCode.Thumbstick2)
			v_u_1:BindActionAtPriority("RbxCameraKeypress", v_u_66, false, v_u_13, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.I, Enum.KeyCode.O)
			if v_u_5.VREnabled then
				v_u_1:BindAction("RbxCameraGamepadReset", v_u_70, false, Enum.KeyCode.ButtonL3)
			end
			v_u_1:BindAction("RbxCameraGamepadZoom", v_u_68, false, Enum.KeyCode.ButtonR3)
			local v122 = v_u_42
			local v123 = v_u_2.InputBegan
			local v124 = v_u_111
			table.insert(v122, v123:Connect(v124))
			local v125 = v_u_42
			local v126 = v_u_2.InputChanged
			local v127 = v_u_115
			table.insert(v125, v126:Connect(v127))
			local v128 = v_u_42
			local v129 = v_u_2.InputEnded
			local v130 = v_u_119
			table.insert(v128, v129:Connect(v130))
			local v131 = v_u_42
			local v132 = v_u_2.PointerAction
			local v133 = v_u_107
			table.insert(v131, v132:Connect(v133))
			local v134 = v_u_42
			local v135 = v_u_6.MenuOpened
			local v136 = v_u_102
			table.insert(v134, v135:connect(v136))
		else
			v_u_1:UnbindAction("RbxCameraThumbstick")
			v_u_1:UnbindAction("RbxCameraMouseMove")
			v_u_1:UnbindAction("RbxCameraMouseWheel")
			v_u_1:UnbindAction("RbxCameraKeypress")
			v_u_1:UnbindAction("RbxCameraGamepadZoom")
			if v_u_5.VREnabled then
				v_u_1:UnbindAction("RbxCameraGamepadReset")
			end
			for _, v137 in pairs(v_u_42) do
				v137:Disconnect()
			end
			v_u_42 = {}
		end
	end
end
function v41.getInputEnabled() -- name: getInputEnabled
	-- upvalues: (ref) v_u_120
	return v_u_120
end
function v41.resetInputForFrameEnd() -- name: resetInputForFrameEnd
	-- upvalues: (copy) v_u_46, (copy) v_u_47
	v_u_46.Movement = Vector2.new()
	v_u_47.Move = Vector2.new()
	v_u_47.Pinch = 0
	v_u_46.Wheel = 0
	v_u_46.Pan = Vector2.new()
	v_u_46.Pinch = 0
end
v_u_2.WindowFocused:Connect(v_u_75)
v_u_2.WindowFocusReleased:Connect(v_u_75)
if v10 then
	v_u_2.TextBoxFocusReleased:Connect(v_u_75)
end
local v_u_138 = false
local v_u_139 = false
local v_u_140 = 0
function v41.getHoldPan() -- name: getHoldPan
	-- upvalues: (ref) v_u_138
	return v_u_138
end
function v41.getTogglePan() -- name: getTogglePan
	-- upvalues: (ref) v_u_139
	return v_u_139
end
function v41.getPanning() -- name: getPanning
	-- upvalues: (ref) v_u_139, (ref) v_u_138
	return v_u_139 or v_u_138
end
function v41.setTogglePan(p141) -- name: setTogglePan
	-- upvalues: (ref) v_u_139
	v_u_139 = p141
end
local v_u_142 = false
local v_u_143 = nil
local v_u_144 = nil
function v41.enableCameraToggleInput() -- name: enableCameraToggleInput
	-- upvalues: (ref) v_u_142, (ref) v_u_138, (ref) v_u_139, (ref) v_u_143, (ref) v_u_144, (ref) v_u_20, (ref) v_u_140, (ref) v_u_21, (copy) v_u_2
	if not v_u_142 then
		v_u_142 = true
		v_u_138 = false
		v_u_139 = false
		if v_u_143 then
			v_u_143:Disconnect()
		end
		if v_u_144 then
			v_u_144:Disconnect()
		end
		v_u_143 = v_u_20:Connect(function()
			-- upvalues: (ref) v_u_138, (ref) v_u_140
			v_u_138 = true
			v_u_140 = tick()
		end)
		v_u_144 = v_u_21:Connect(function()
			-- upvalues: (ref) v_u_138, (ref) v_u_140, (ref) v_u_139, (ref) v_u_2
			v_u_138 = false
			if tick() - v_u_140 < 0.3 and (v_u_139 or v_u_2:GetMouseDelta().Magnitude < 2) then
				v_u_139 = not v_u_139
			end
		end)
	end
end
function v41.disableCameraToggleInput() -- name: disableCameraToggleInput
	-- upvalues: (ref) v_u_142, (ref) v_u_143, (ref) v_u_144
	if v_u_142 then
		v_u_142 = false
		if v_u_143 then
			v_u_143:Disconnect()
			v_u_143 = nil
		end
		if v_u_144 then
			v_u_144:Disconnect()
			v_u_144 = nil
		end
	end
end
return v41