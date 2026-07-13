local v_u_1 = Enum.ContextActionPriority.High.Value
local v_u_2 = {
	0.10999999999999999,
	0.30000000000000004,
	0.4,
	0.5,
	0.6,
	0.7,
	0.75
}
local v_u_3 = #v_u_2
local v_u_4 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local v5 = game:GetService("Players")
local v_u_6 = game:GetService("GuiService")
local v_u_7 = game:GetService("UserInputService")
local v_u_8 = game:GetService("ContextActionService")
local v_u_9 = game:GetService("RunService")
local v_u_10 = game:GetService("TweenService")
local v11 = script.Parent.Parent:WaitForChild("CommonUtils")
local v12 = require(v11:WaitForChild("FlagUtil"))
local v_u_13 = v12.getUserFlag("UserAllowAbilityControls")
local v_u_14 = v12.getUserFlag("UserAllowAbilityControlsBonus")
local v15, v16 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local v_u_17 = v15 and v16
local v_u_18
if v_u_13 then
	v_u_18 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
else
	v_u_18 = nil
end
local v_u_19 = v5.LocalPlayer
if not v_u_19 then
	v5:GetPropertyChangedSignal("LocalPlayer"):Wait()
	v_u_19 = v5.LocalPlayer
end
local v_u_20 = require(script.Parent:WaitForChild("BaseCharacterController"))
local v_u_21 = setmetatable({}, v_u_20)
v_u_21.__index = v_u_21
function v_u_21.new() -- name: new
	-- upvalues: (copy) v_u_20, (copy) v_u_21
	local v22 = v_u_20.new()
	local v23 = v_u_21
	local v24 = setmetatable(v22, v23)
	v24.moveTouchObject = nil
	v24.moveTouchLockedIn = false
	v24.moveTouchFirstChanged = false
	v24.moveTouchStartPosition = nil
	v24.startImage = nil
	v24.endImage = nil
	v24.middleImages = {}
	v24.startImageFadeTween = nil
	v24.endImageFadeTween = nil
	v24.middleImageFadeTweens = {}
	v24.isFirstTouch = true
	v24.thumbstickFrame = nil
	v24.onRenderSteppedConn = nil
	v24.fadeInAndOutBalance = 0.5
	v24.fadeInAndOutHalfDuration = 0.3
	v24.hasFadedBackgroundInPortrait = false
	v24.hasFadedBackgroundInLandscape = false
	v24.tweenInAlphaStart = nil
	v24.tweenOutAlphaStart = nil
	return v24
end
function v_u_21.GetIsJumping(p25) -- name: GetIsJumping
	local v26 = p25.isJumping
	p25.isJumping = false
	return v26
end
function v_u_21.Enable(p27, p28, p29) -- name: Enable
	if p28 == nil then
		return false
	end
	local v30 = p28 and true or false
	if p27.enabled == v30 then
		return true
	end
	if v30 then
		if not p27.thumbstickFrame then
			p27:Create(p29)
		end
		p27:BindContextActions()
	else
		p27:UnbindContextActions()
		p27:OnInputEnded()
	end
	p27.enabled = v30
	p27.thumbstickFrame.Visible = v30
	return nil
end
function v_u_21.OnInputEnded(p31) -- name: OnInputEnded
	p31.moveTouchObject = nil
	p31.moveVector = Vector3.new(0, 0, 0)
	p31:FadeThumbstick(false)
end
function v_u_21.FadeThumbstick(p32, p33) -- name: FadeThumbstick
	-- upvalues: (copy) v_u_10, (copy) v_u_4, (copy) v_u_2
	if p33 or not p32.moveTouchObject then
		if p32.isFirstTouch then
			return
		else
			if p32.startImageFadeTween then
				p32.startImageFadeTween:Cancel()
			end
			if p32.endImageFadeTween then
				p32.endImageFadeTween:Cancel()
			end
			for v34 = 1, #p32.middleImages do
				if p32.middleImageFadeTweens[v34] then
					p32.middleImageFadeTweens[v34]:Cancel()
				end
			end
			if p33 then
				p32.startImageFadeTween = v_u_10:Create(p32.startImage, v_u_4, {
					["ImageTransparency"] = 0
				})
				p32.startImageFadeTween:Play()
				p32.endImageFadeTween = v_u_10:Create(p32.endImage, v_u_4, {
					["ImageTransparency"] = 0.2
				})
				p32.endImageFadeTween:Play()
				for v35 = 1, #p32.middleImages do
					p32.middleImageFadeTweens[v35] = v_u_10:Create(p32.middleImages[v35], v_u_4, {
						["ImageTransparency"] = v_u_2[v35]
					})
					p32.middleImageFadeTweens[v35]:Play()
				end
			else
				p32.startImageFadeTween = v_u_10:Create(p32.startImage, v_u_4, {
					["ImageTransparency"] = 1
				})
				p32.startImageFadeTween:Play()
				p32.endImageFadeTween = v_u_10:Create(p32.endImage, v_u_4, {
					["ImageTransparency"] = 1
				})
				p32.endImageFadeTween:Play()
				for v36 = 1, #p32.middleImages do
					p32.middleImageFadeTweens[v36] = v_u_10:Create(p32.middleImages[v36], v_u_4, {
						["ImageTransparency"] = 1
					})
					p32.middleImageFadeTweens[v36]:Play()
				end
			end
		end
	else
		return
	end
end
function v_u_21.FadeThumbstickFrame(p37, p38, p39) -- name: FadeThumbstickFrame
	p37.fadeInAndOutHalfDuration = p38 * 0.5
	p37.fadeInAndOutBalance = p39
	p37.tweenInAlphaStart = tick()
end
function v_u_21.InputInFrame(p40, p41) -- name: InputInFrame
	local v42 = p40.thumbstickFrame.AbsolutePosition
	local v43 = v42 + p40.thumbstickFrame.AbsoluteSize
	local v44 = p41.Position
	return v44.X >= v42.X and (v44.Y >= v42.Y and (v44.X <= v43.X and v44.Y <= v43.Y))
end
function v_u_21.DoFadeInBackground(p45) -- name: DoFadeInBackground
	-- upvalues: (ref) v_u_19
	local v46 = v_u_19:FindFirstChildOfClass("PlayerGui")
	local v47 = false
	if v46 then
		if v46.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or v46.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
			v47 = p45.hasFadedBackgroundInLandscape
			p45.hasFadedBackgroundInLandscape = true
		elseif v46.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
			v47 = p45.hasFadedBackgroundInPortrait
			p45.hasFadedBackgroundInPortrait = true
		end
	end
	if not v47 then
		p45.fadeInAndOutHalfDuration = 0.3
		p45.fadeInAndOutBalance = 0.5
		p45.tweenInAlphaStart = tick()
	end
end
function v_u_21.DoMove(p48, p49) -- name: DoMove
	local v50
	if p49.Magnitude < p48.radiusOfDeadZone then
		v50 = Vector3.new(0, 0, 0)
	else
		local v51 = p49.Unit
		local v52 = (p48.radiusOfMaxSpeed - p49.Magnitude) / p48.radiusOfMaxSpeed
		local v53 = v51 * (1 - math.max(0, v52))
		local v54 = v53.X
		local v55 = v53.Y
		v50 = Vector3.new(v54, 0, v55)
	end
	p48.moveVector = v50
end
function v_u_21.LayoutMiddleImages(p56, p57, p58) -- name: LayoutMiddleImages
	-- upvalues: (copy) v_u_3
	local v59 = p56.thumbstickSize / 2 + p56.middleSize
	local v60 = p58 - p57
	local v61 = v60.Magnitude - p56.thumbstickRingSize / 2 - p56.middleSize
	local v62 = v60.Unit
	local v63 = p56.middleSpacing * v_u_3
	local v64 = p56.middleSpacing
	if v63 < v61 then
		v64 = v61 / v_u_3
	end
	for v65 = 1, v_u_3 do
		local v66 = p56.middleImages[v65]
		local v67 = v59 + v64 * (v65 - 2)
		local v68 = v59 + v64 * (v65 - 1)
		if v67 < v61 then
			local v69 = p58 - v62 * v68
			local v70 = 1 - (v68 - v61) / v64
			local v71 = math.clamp(v70, 0, 1)
			v66.Visible = true
			v66.Position = UDim2.new(0, v69.X, 0, v69.Y)
			v66.Size = UDim2.new(0, p56.middleSize * v71, 0, p56.middleSize * v71)
		else
			v66.Visible = false
		end
	end
end
function v_u_21.MoveStick(p72, p73) -- name: MoveStick
	local v74 = Vector2.new(p72.moveTouchStartPosition.X, p72.moveTouchStartPosition.Y) - p72.thumbstickFrame.AbsolutePosition
	local v75 = Vector2.new(p73.X, p73.Y) - p72.thumbstickFrame.AbsolutePosition
	p72.endImage.Position = UDim2.new(0, v75.X, 0, v75.Y)
	p72:LayoutMiddleImages(v74, v75)
end
function v_u_21.BindContextActions(p_u_76) -- name: BindContextActions
	-- upvalues: (copy) v_u_10, (copy) v_u_8, (copy) v_u_1, (copy) v_u_7
	local function v_u_79(p77) -- name: inputBegan
		-- upvalues: (copy) p_u_76, (ref) v_u_10
		if p_u_76.moveTouchObject then
			return Enum.ContextActionResult.Pass
		end
		if not p_u_76:InputInFrame(p77) then
			return Enum.ContextActionResult.Pass
		end
		if p_u_76.isFirstTouch then
			p_u_76.isFirstTouch = false
			local v78 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
			v_u_10:Create(p_u_76.startImage, v78, {
				["Size"] = UDim2.new(0, 0, 0, 0)
			}):Play()
			v_u_10:Create(p_u_76.endImage, v78, {
				["Size"] = UDim2.new(0, p_u_76.thumbstickSize, 0, p_u_76.thumbstickSize),
				["ImageColor3"] = Color3.new(0, 0, 0)
			}):Play()
		end
		p_u_76.moveTouchLockedIn = false
		p_u_76.moveTouchObject = p77
		p_u_76.moveTouchStartPosition = p77.Position
		p_u_76.moveTouchFirstChanged = true
		p_u_76:DoFadeInBackground()
		return Enum.ContextActionResult.Pass
	end
	local function v_u_85(p80) -- name: inputChanged
		-- upvalues: (copy) p_u_76
		if p80 ~= p_u_76.moveTouchObject then
			return Enum.ContextActionResult.Pass
		end
		if p_u_76.moveTouchFirstChanged then
			p_u_76.moveTouchFirstChanged = false
			local v81 = Vector2.new(p80.Position.X - p_u_76.thumbstickFrame.AbsolutePosition.X, p80.Position.Y - p_u_76.thumbstickFrame.AbsolutePosition.Y)
			p_u_76.startImage.Visible = true
			p_u_76.startImage.Position = UDim2.new(0, v81.X, 0, v81.Y)
			p_u_76.endImage.Visible = true
			p_u_76.endImage.Position = p_u_76.startImage.Position
			p_u_76:FadeThumbstick(true)
			p_u_76:MoveStick(p80.Position)
		end
		p_u_76.moveTouchLockedIn = true
		local v82 = Vector2.new(p80.Position.X - p_u_76.moveTouchStartPosition.X, p80.Position.Y - p_u_76.moveTouchStartPosition.Y)
		local v83 = v82.X
		if math.abs(v83) <= 0 then
			local v84 = v82.Y
			if math.abs(v84) <= 0 then
				::l7::
				return Enum.ContextActionResult.Sink
			end
		end
		p_u_76:DoMove(v82)
		p_u_76:MoveStick(p80.Position)
		goto l7
	end
	v_u_8:BindActionAtPriority("DynamicThumbstickAction", function(_, p86, p87) -- name: handleInput
		-- upvalues: (copy) v_u_79, (copy) p_u_76
		if p86 == Enum.UserInputState.Begin then
			return v_u_79(p87)
		elseif p86 == Enum.UserInputState.Change then
			if p87 == p_u_76.moveTouchObject then
				return Enum.ContextActionResult.Sink
			else
				return Enum.ContextActionResult.Pass
			end
		else
			if p86 == Enum.UserInputState.End then
				if p87 == p_u_76.moveTouchObject then
					p_u_76:OnInputEnded()
					if p_u_76.moveTouchLockedIn then
						return Enum.ContextActionResult.Sink
					end
				end
				return Enum.ContextActionResult.Pass
			end
			if p86 == Enum.UserInputState.Cancel then
				p_u_76:OnInputEnded()
			end
			return
		end
	end, false, v_u_1, Enum.UserInputType.Touch)
	p_u_76.TouchMovedCon = v_u_7.TouchMoved:Connect(function(p88, _)
		-- upvalues: (copy) v_u_85
		v_u_85(p88)
	end)
end
function v_u_21.UnbindContextActions(p89) -- name: UnbindContextActions
	-- upvalues: (copy) v_u_8
	v_u_8:UnbindAction("DynamicThumbstickAction")
	if p89.TouchMovedCon then
		p89.TouchMovedCon:Disconnect()
	end
end
function v_u_21.Create(p_u_90, p_u_91) -- name: Create
	-- upvalues: (copy) v_u_13, (ref) v_u_17, (copy) v_u_3, (copy) v_u_2, (copy) v_u_14, (ref) v_u_18, (copy) v_u_9, (copy) v_u_7, (copy) v_u_6, (ref) v_u_19
	if p_u_90.thumbstickFrame then
		p_u_90.thumbstickFrame:Destroy()
		p_u_90.thumbstickFrame = nil
		if p_u_90.onRenderSteppedConn then
			p_u_90.onRenderSteppedConn:Disconnect()
			p_u_90.onRenderSteppedConn = nil
		end
		if p_u_90.absoluteSizeChangedConn then
			p_u_90.absoluteSizeChangedConn:Disconnect()
			p_u_90.absoluteSizeChangedConn = nil
		end
		if v_u_13 and p_u_90.avatarAbilitiesEnabledChangedConn then
			p_u_90.avatarAbilitiesEnabledChangedConn:Disconnect()
			p_u_90.avatarAbilitiesEnabledChangedConn = nil
		end
	end
	local v_u_92 = v_u_17 and 100 or 0
	p_u_90.thumbstickFrame = Instance.new("Frame")
	p_u_90.thumbstickFrame.BorderSizePixel = 0
	p_u_90.thumbstickFrame.Name = "DynamicThumbstickFrame"
	p_u_90.thumbstickFrame.Visible = false
	p_u_90.thumbstickFrame.BackgroundTransparency = 1
	p_u_90.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	p_u_90.thumbstickFrame.Active = false
	p_u_90.thumbstickFrame.Size = UDim2.new(0.4, v_u_92, 0.6666666666666666, v_u_92)
	p_u_90.thumbstickFrame.Position = UDim2.new(0, -v_u_92, 0.3333333333333333, 0)
	p_u_90.startImage = Instance.new("ImageLabel")
	p_u_90.startImage.Name = "ThumbstickStart"
	p_u_90.startImage.Visible = true
	p_u_90.startImage.BackgroundTransparency = 1
	p_u_90.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	p_u_90.startImage.ImageRectOffset = Vector2.new(1, 1)
	p_u_90.startImage.ImageRectSize = Vector2.new(144, 144)
	p_u_90.startImage.ImageColor3 = Color3.new(0, 0, 0)
	p_u_90.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
	p_u_90.startImage.ZIndex = 10
	p_u_90.startImage.Parent = p_u_90.thumbstickFrame
	p_u_90.endImage = Instance.new("ImageLabel")
	p_u_90.endImage.Name = "ThumbstickEnd"
	p_u_90.endImage.Visible = true
	p_u_90.endImage.BackgroundTransparency = 1
	p_u_90.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	p_u_90.endImage.ImageRectOffset = Vector2.new(1, 1)
	p_u_90.endImage.ImageRectSize = Vector2.new(144, 144)
	p_u_90.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
	p_u_90.endImage.ZIndex = 10
	p_u_90.endImage.Parent = p_u_90.thumbstickFrame
	local function v_u_94(p93) -- name: layoutThumbstickFrame
		-- upvalues: (copy) p_u_90, (copy) v_u_92
		if p93 then
			p_u_90.thumbstickFrame.Size = UDim2.new(1, v_u_92, 0.4, v_u_92)
			p_u_90.thumbstickFrame.Position = UDim2.new(0, -v_u_92, 0.6, 0)
		else
			p_u_90.thumbstickFrame.Size = UDim2.new(0.4, v_u_92, 0.6666666666666666, v_u_92)
			p_u_90.thumbstickFrame.Position = UDim2.new(0, -v_u_92, 0.3333333333333333, 0)
		end
	end
	for v95 = 1, v_u_3 do
		p_u_90.middleImages[v95] = Instance.new("ImageLabel")
		p_u_90.middleImages[v95].Name = "ThumbstickMiddle"
		p_u_90.middleImages[v95].Visible = false
		p_u_90.middleImages[v95].BackgroundTransparency = 1
		p_u_90.middleImages[v95].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
		p_u_90.middleImages[v95].ImageRectOffset = Vector2.new(1, 1)
		p_u_90.middleImages[v95].ImageRectSize = Vector2.new(144, 144)
		p_u_90.middleImages[v95].ImageTransparency = v_u_2[v95]
		p_u_90.middleImages[v95].AnchorPoint = Vector2.new(0.5, 0.5)
		p_u_90.middleImages[v95].ZIndex = 9
		p_u_90.middleImages[v95].Parent = p_u_90.thumbstickFrame
	end
	local function v102() -- name: ResizeThumbstick
		-- upvalues: (copy) p_u_91, (ref) v_u_13, (ref) v_u_14, (ref) v_u_18, (copy) p_u_90, (copy) v_u_92
		local v96 = p_u_91.AbsoluteSize
		local v97 = v96.X
		local v98 = v96.Y
		local v99 = math.min(v97, v98) > 500
		if v_u_13 then
			local v100 = v_u_14 and (v_u_18.isEnabled() and v99) and 1.6216216216216217 or (v99 and 2 or 1)
			p_u_90.thumbstickSize = 45 * v100
			p_u_90.thumbstickRingSize = 20 * v100
			p_u_90.middleSize = 10 * v100
			p_u_90.middleSpacing = 14 * v100
			p_u_90.radiusOfDeadZone = 2 * v100
			p_u_90.radiusOfMaxSpeed = 20 * v100
			local v101 = 74 * v100
			if v_u_18.isEnabled() then
				p_u_90.startImage.Position = UDim2.new(0, v101 * 0.5 + v_u_92 + (v99 and 100 or 64), 1, -v101 * 0.5 - v_u_92 - (v99 and 112 or 64))
				p_u_90.startImage.Size = UDim2.new(0, v101, 0, v101)
			else
				p_u_90.startImage.Position = UDim2.new(0, p_u_90.thumbstickRingSize * 3.3 + v_u_92, 1, -p_u_90.thumbstickRingSize * 2.8 - v_u_92)
				p_u_90.startImage.Size = UDim2.new(0, v101, 0, v101)
			end
		else
			if v99 then
				p_u_90.thumbstickSize = 90
				p_u_90.thumbstickRingSize = 40
				p_u_90.middleSize = 20
				p_u_90.middleSpacing = 28
				p_u_90.radiusOfDeadZone = 4
				p_u_90.radiusOfMaxSpeed = 40
			else
				p_u_90.thumbstickSize = 45
				p_u_90.thumbstickRingSize = 20
				p_u_90.middleSize = 10
				p_u_90.middleSpacing = 14
				p_u_90.radiusOfDeadZone = 2
				p_u_90.radiusOfMaxSpeed = 20
			end
			p_u_90.startImage.Position = UDim2.new(0, p_u_90.thumbstickRingSize * 3.3 + v_u_92, 1, -p_u_90.thumbstickRingSize * 2.8 - v_u_92)
			p_u_90.startImage.Size = UDim2.new(0, p_u_90.thumbstickRingSize * 3.7, 0, p_u_90.thumbstickRingSize * 3.7)
		end
		p_u_90.endImage.Position = p_u_90.startImage.Position
		p_u_90.endImage.Size = UDim2.new(0, p_u_90.thumbstickSize * 0.8, 0, p_u_90.thumbstickSize * 0.8)
	end
	v102()
	p_u_90.absoluteSizeChangedConn = p_u_91:GetPropertyChangedSignal("AbsoluteSize"):Connect(v102)
	if v_u_13 then
		p_u_90.avatarAbilitiesEnabledChangedConn = v_u_18.GetEnabledChangedSignal():Connect(v102)
	end
	local v_u_103 = nil
	local function v108() -- name: onCurrentCameraChanged
		-- upvalues: (ref) v_u_103, (copy) v_u_94
		if v_u_103 then
			v_u_103:Disconnect()
			v_u_103 = nil
		end
		local v_u_104 = workspace.CurrentCamera
		if v_u_104 then
			local function v106() -- name: onViewportSizeChanged
				-- upvalues: (copy) v_u_104, (ref) v_u_94
				local v105 = v_u_104.ViewportSize
				v_u_94(v105.X < v105.Y)
			end
			v_u_103 = v_u_104:GetPropertyChangedSignal("ViewportSize"):Connect(v106)
			local v107 = v_u_104.ViewportSize
			v_u_94(v107.X < v107.Y)
		end
	end
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(v108)
	if workspace.CurrentCamera then
		v108()
	end
	p_u_90.moveTouchStartPosition = nil
	p_u_90.startImageFadeTween = nil
	p_u_90.endImageFadeTween = nil
	p_u_90.middleImageFadeTweens = {}
	p_u_90.onRenderSteppedConn = v_u_9.RenderStepped:Connect(function()
		-- upvalues: (copy) p_u_90
		if p_u_90.tweenInAlphaStart == nil then
			if p_u_90.tweenOutAlphaStart ~= nil then
				local v109 = tick() - p_u_90.tweenOutAlphaStart
				local v110 = p_u_90.fadeInAndOutHalfDuration * 2 - p_u_90.fadeInAndOutHalfDuration * 2 * p_u_90.fadeInAndOutBalance
				local v111 = p_u_90.thumbstickFrame
				local v112 = v109 / v110
				v111.BackgroundTransparency = math.min(v112, 1) * 0.35 + 0.65
				if v110 < v109 then
					p_u_90.tweenOutAlphaStart = nil
				end
			end
		else
			local v113 = tick() - p_u_90.tweenInAlphaStart
			local v114 = p_u_90.fadeInAndOutHalfDuration * 2 * p_u_90.fadeInAndOutBalance
			local v115 = p_u_90.thumbstickFrame
			local v116 = v113 / v114
			v115.BackgroundTransparency = 1 - math.min(v116, 1) * 0.35
			if v114 < v113 then
				p_u_90.tweenOutAlphaStart = tick()
				p_u_90.tweenInAlphaStart = nil
				return
			end
		end
	end)
	p_u_90.onTouchEndedConn = v_u_7.TouchEnded:connect(function(p117)
		-- upvalues: (copy) p_u_90
		if p117 == p_u_90.moveTouchObject then
			p_u_90:OnInputEnded()
		end
	end)
	v_u_6.MenuOpened:connect(function()
		-- upvalues: (copy) p_u_90
		if p_u_90.moveTouchObject then
			p_u_90:OnInputEnded()
		end
	end)
	local v_u_118 = v_u_19:FindFirstChildOfClass("PlayerGui")
	while not v_u_118 do
		v_u_19.ChildAdded:wait()
		v_u_118 = v_u_19:FindFirstChildOfClass("PlayerGui")
	end
	local v_u_119 = nil
	local v_u_120 = v_u_118.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft and true or v_u_118.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
	local _ = v_u_118:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
		-- upvalues: (copy) v_u_120, (ref) v_u_118, (ref) v_u_119, (copy) p_u_90
		if v_u_120 and v_u_118.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait or not v_u_120 and v_u_118.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait then
			v_u_119:disconnect()
			p_u_90.fadeInAndOutHalfDuration = 2.5
			p_u_90.fadeInAndOutBalance = 0.05
			p_u_90.tweenInAlphaStart = tick()
			if v_u_120 then
				p_u_90.hasFadedBackgroundInPortrait = true
				return
			end
			p_u_90.hasFadedBackgroundInLandscape = true
		end
	end)
	p_u_90.thumbstickFrame.Parent = p_u_91
	if game:IsLoaded() then
		p_u_90.fadeInAndOutHalfDuration = 2.5
		p_u_90.fadeInAndOutBalance = 0.05
		p_u_90.tweenInAlphaStart = tick()
	else
		coroutine.wrap(function()
			-- upvalues: (copy) p_u_90
			game.Loaded:Wait()
			p_u_90.fadeInAndOutHalfDuration = 2.5
			p_u_90.fadeInAndOutBalance = 0.05
			p_u_90.tweenInAlphaStart = tick()
		end)()
	end
end
return v_u_21