game:GetService("Players")
local v_u_1 = game:GetService("GuiService")
local v2 = script.Parent.Parent:WaitForChild("CommonUtils")
local v_u_3 = require(v2:WaitForChild("ConnectionUtil"))
local v_u_4 = require(v2:WaitForChild("CharacterUtil"))
local v_u_5 = require(v2:WaitForChild("FlagUtil")).getUserFlag("UserAllowAbilityControls")
local v_u_6
if v_u_5 then
	v_u_6 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
else
	v_u_6 = nil
end
local v_u_7 = { "rbxasset://textures/ui/Input/JumpButtonRegular.png", "rbxasset://textures/ui/Input/JumpButtonPressed.png" }
local v_u_8 = require(script.Parent:WaitForChild("BaseCharacterController"))
local v_u_9 = setmetatable({}, v_u_8)
v_u_9.__index = v_u_9
function v_u_9.new() -- name: new
	-- upvalues: (copy) v_u_8, (copy) v_u_9, (copy) v_u_3
	local v10 = v_u_8.new()
	local v11 = v_u_9
	local v12 = setmetatable(v10, v11)
	v12.parentUIFrame = nil
	v12.jumpButton = nil
	v12.externallyEnabled = false
	v12.isJumping = false
	v12._active = false
	v12._connectionUtil = v_u_3.new()
	return v12
end
function v_u_9._reset(p13) -- name: _reset
	-- upvalues: (copy) v_u_5, (ref) v_u_6, (copy) v_u_7
	p13.isJumping = false
	p13.touchObject = nil
	if p13.jumpButton then
		if v_u_5 and v_u_6.isEnabled() then
			p13.jumpButton.Image = v_u_7[1]
			return
		end
		p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
	end
end
function v_u_9.EnableButton(p_u_14, p15) -- name: EnableButton
	-- upvalues: (copy) v_u_1
	if p15 ~= p_u_14._active then
		if p15 then
			if not p_u_14.jumpButton then
				p_u_14:Create()
			end
			p_u_14.jumpButton.Visible = true
			p_u_14._connectionUtil:trackConnection("JUMP_INPUT_ENDED", p_u_14.jumpButton.InputEnded:Connect(function(p16)
				-- upvalues: (copy) p_u_14
				if p16 == p_u_14.touchObject then
					p_u_14:_reset()
				end
			end))
			p_u_14._connectionUtil:trackConnection("MENU_OPENED", v_u_1.MenuOpened:Connect(function()
				-- upvalues: (copy) p_u_14
				if p_u_14.touchObject then
					p_u_14:_reset()
				end
			end))
		else
			if p_u_14.jumpButton then
				p_u_14.jumpButton.Visible = false
			end
			p_u_14._connectionUtil:disconnect("JUMP_INPUT_ENDED")
			p_u_14._connectionUtil:disconnect("MENU_OPENED")
		end
		p_u_14:_reset()
		p_u_14._active = p15
	end
end
function v_u_9.UpdateEnabled(p17) -- name: UpdateEnabled
	-- upvalues: (copy) v_u_4
	local v18 = v_u_4.getChild("Humanoid", "Humanoid")
	if v18 and p17.externallyEnabled and (v18.UseJumpPower and v18.JumpPower > 0 or not v18.UseJumpPower and v18.JumpHeight > 0) and v18:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
		p17:EnableButton(true)
	else
		p17:EnableButton(false)
	end
end
function v_u_9._setupConfigurations(p_u_19) -- name: _setupConfigurations
	-- upvalues: (copy) v_u_4
	local function v_u_20() -- name: update
		-- upvalues: (copy) p_u_19
		p_u_19:UpdateEnabled()
	end
	local v24 = v_u_4.onChild("Humanoid", "Humanoid", function(p21)
		-- upvalues: (copy) p_u_19, (copy) v_u_20
		p_u_19:UpdateEnabled()
		p_u_19:_reset()
		p_u_19._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p21:GetPropertyChangedSignal("JumpPower"):Connect(v_u_20))
		p_u_19._connectionUtil:trackConnection("HUMANOID_JUMP_HEIGHT", p21:GetPropertyChangedSignal("JumpHeight"):Connect(v_u_20))
		p_u_19._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p21.StateEnabledChanged:Connect(function(p22, p23)
			-- upvalues: (ref) p_u_19
			if p22 == Enum.HumanoidStateType.Jumping and p23 ~= p_u_19._active then
				p_u_19:UpdateEnabled()
			end
		end))
	end)
	p_u_19._connectionUtil:trackConnection("HUMANOID", v24)
end
function v_u_9.Enable(p25, p26, p27) -- name: Enable
	if p27 then
		p25.parentUIFrame = p27
	end
	if p25.externallyEnabled == p26 then
		return
	else
		p25.externallyEnabled = p26
		p25:UpdateEnabled()
		if p26 then
			p25:_setupConfigurations()
		else
			p25._connectionUtil:disconnectAll()
		end
	end
end
function v_u_9.Create(p_u_28) -- name: Create
	-- upvalues: (copy) v_u_5, (ref) v_u_6, (copy) v_u_7
	if p_u_28.parentUIFrame then
		if p_u_28.jumpButton then
			p_u_28.jumpButton:Destroy()
			p_u_28.jumpButton = nil
		end
		if p_u_28.absoluteSizeChangedConn then
			p_u_28.absoluteSizeChangedConn:Disconnect()
			p_u_28.absoluteSizeChangedConn = nil
		end
		if v_u_5 and p_u_28.avatarAbilitiesEnabledChangedConn then
			p_u_28.avatarAbilitiesEnabledChangedConn:Disconnect()
			p_u_28.avatarAbilitiesEnabledChangedConn = nil
		end
		p_u_28.jumpButton = Instance.new("ImageButton")
		p_u_28.jumpButton.Name = "JumpButton"
		p_u_28.jumpButton.Visible = false
		p_u_28.jumpButton.BackgroundTransparency = 1
		if v_u_5 and v_u_6.isEnabled() then
			p_u_28.jumpButton.Image = v_u_7[1]
		else
			p_u_28.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
			p_u_28.jumpButton.ImageRectOffset = Vector2.new(1, 146)
			p_u_28.jumpButton.ImageRectSize = Vector2.new(144, 144)
		end
		local function v36() -- name: ResizeJumpButton
			-- upvalues: (copy) p_u_28, (ref) v_u_5, (ref) v_u_6, (ref) v_u_7
			local v29 = p_u_28.parentUIFrame.AbsoluteSize.x
			local v30 = p_u_28.parentUIFrame.AbsoluteSize.y
			local v31 = math.min(v29, v30) <= 500
			if v_u_5 and v_u_6.isEnabled() then
				local v32 = v31 and 72 or 120
				local v33 = -v32 - (v31 and 64 or 100)
				local v34 = -v32 - (v31 and 64 or 112)
				p_u_28.jumpButton.Image = v_u_7[1]
				p_u_28.jumpButton.ImageRectOffset = Vector2.new(0, 0)
				p_u_28.jumpButton.ImageRectSize = Vector2.new(0, 0)
				p_u_28.jumpButton.Size = UDim2.new(0, v32, 0, v32)
				p_u_28.jumpButton.Position = UDim2.new(1, v33, 1, v34)
			else
				local v35 = v31 and 70 or 120
				if v_u_5 then
					p_u_28.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
					p_u_28.jumpButton.ImageRectOffset = Vector2.new(1, 146)
					p_u_28.jumpButton.ImageRectSize = Vector2.new(144, 144)
				end
				p_u_28.jumpButton.Size = UDim2.new(0, v35, 0, v35)
				p_u_28.jumpButton.Position = v31 and UDim2.new(1, -(v35 * 1.5 - 10), 1, -v35 - 20) or UDim2.new(1, -(v35 * 1.5 - 10), 1, -v35 * 1.75)
			end
		end
		v36()
		p_u_28.absoluteSizeChangedConn = p_u_28.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(v36)
		if v_u_5 then
			p_u_28.avatarAbilitiesEnabledChangedConn = v_u_6.GetEnabledChangedSignal():Connect(v36)
		end
		p_u_28.touchObject = nil
		p_u_28.jumpButton.InputBegan:connect(function(p37)
			-- upvalues: (copy) p_u_28, (ref) v_u_5, (ref) v_u_6, (ref) v_u_7
			if not p_u_28.touchObject and (p37.UserInputType == Enum.UserInputType.Touch and p37.UserInputState == Enum.UserInputState.Begin) then
				p_u_28.touchObject = p37
				if v_u_5 and v_u_6.isEnabled() then
					p_u_28.jumpButton.Image = v_u_7[2]
				else
					p_u_28.jumpButton.ImageRectOffset = Vector2.new(146, 146)
				end
				p_u_28.isJumping = true
			end
		end)
		p_u_28.jumpButton.Parent = p_u_28.parentUIFrame
	end
end
return v_u_9