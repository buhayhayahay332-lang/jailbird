local v_u_1 = game:GetService("ContextActionService")
local v_u_2 = game:GetService("UserInputService")
game:GetService("MarketplaceService")
local v_u_3 = game:GetService("CollectionService")
game:GetService("ReplicatedStorage")
local v_u_4 = game:GetService("ReplicatedStorage")
local v_u_5 = game:GetService("TeleportService")
game:GetService("TweenService")
local v_u_6 = game:GetService("SoundService")
local v_u_7 = game:GetService("StarterGui")
local v_u_8 = game:GetService("RunService")
local v_u_9 = game:GetService("Lighting")
local v_u_10 = game:GetService("Players")
local v_u_11 = game:GetService("Debris")
local v_u_12 = game:GetService("Teams")
local v13 = v_u_4:WaitForChild("Modules")
require(v13:WaitForChild("ReasonStrings"))
local v_u_14 = require(v_u_4.Components.Weapon)
local v_u_15 = require(v_u_4.Components.HitEffect)
local v_u_16 = require(v_u_4.Config)
local v_u_17 = require(v_u_4.Components.Event)
require(v_u_4.Components.Player)
local v_u_18 = require(v_u_4.ComponentsManager)
local v_u_19 = require(v_u_4.Components.CameraShaker)
local v_u_20 = require(v_u_4.Components.Freecam)
require(v_u_4.Modules.Utility)
local v_u_21 = require(v_u_4.Components.Icon)
require(v_u_4.Components.Gamepasses)
local v_u_22 = require(v_u_4.Components.SpectatorRewards)
local v_u_23 = require(v_u_4.Components.FirstPersonSpectateObserver)
local v_u_24 = require(v_u_4.Components.ReplayKillCamEffects)
local v_u_25 = require(script:WaitForChild("GameMenuCameraSupport"))
local v_u_26 = require(script:WaitForChild("GameMenuThirdPersonSpectateController"))
local v_u_27 = require(script:WaitForChild("GameMenuReplayBarricadeController"))
local v_u_28 = require(script:WaitForChild("GameMenuBarricadePromptController"))
local v_u_29 = require(script:WaitForChild("GameMenuReplayThrowableController"))
local v_u_30 = require(script:WaitForChild("GameMenuReplaySupport"))
local v_u_31 = require(script:WaitForChild("GameMenuSpectateBindingSupport"))
local v_u_32 = require(script:WaitForChild("GameMenuRuntimeBindingSupport"))
local v_u_33 = require(v_u_4.Components.ReplayDebugLogger)
local v_u_34 = require(v_u_4.Modules.WeaponSlotResolver)
local v_u_35 = require(v_u_4.Modules.GameModes)
local v_u_36 = require(v13:WaitForChild("Constants"))
local v_u_37 = v_u_4:WaitForChild("GameEvents"):WaitForChild("SpectateTargetUpdate")
local v_u_38 = v_u_4:WaitForChild("GameEvents"):WaitForChild("SpectatorDamageFeed")
local v_u_39 = v_u_4.Server
local v_u_40 = v_u_39.Tournament
local v_u_41 = workspace.Map
local v_u_42 = nil
local v_u_43 = {
	["IsBlurTweening"] = false,
	["CurrentSpectatingPlayer"] = nil
}
local v_u_44 = workspace.CurrentCamera
local function v_u_46(p45) -- name: SetFirstPersonSpectateCameraActive
	-- upvalues: (copy) v_u_44
	v_u_44:SetAttribute("FirstPersonSpectateActive", p45)
end
local v_u_47 = {
	["Captured"] = false,
	["Backpack"] = false,
	["PlayerList"] = false
}
local function v_u_62() -- name: ApplySpectateCoreGuiState
	-- upvalues: (copy) v_u_47, (copy) v_u_7
	if v_u_47.Captured ~= true then
		local v48 = v_u_47
		local v_u_49 = Enum.CoreGuiType.Backpack
		local v50, v51 = pcall(function()
			-- upvalues: (ref) v_u_7, (copy) v_u_49
			return v_u_7:GetCoreGuiEnabled(v_u_49)
		end)
		local v52
		if v50 == true then
			v52 = v51 == true
		else
			v52 = false
		end
		v48.Backpack = v52
		local v53 = v_u_47
		local v_u_54 = Enum.CoreGuiType.PlayerList
		local v55, v56 = pcall(function()
			-- upvalues: (ref) v_u_7, (copy) v_u_54
			return v_u_7:GetCoreGuiEnabled(v_u_54)
		end)
		local v57
		if v55 == true then
			v57 = v56 == true
		else
			v57 = false
		end
		v53.PlayerList = v57
		v_u_47.Captured = true
	end
	local v_u_58 = Enum.CoreGuiType.Backpack
	local v_u_59 = false
	pcall(function()
		-- upvalues: (ref) v_u_7, (copy) v_u_58, (copy) v_u_59
		v_u_7:SetCoreGuiEnabled(v_u_58, v_u_59)
	end)
	local v_u_60 = Enum.CoreGuiType.PlayerList
	local v_u_61 = false
	pcall(function()
		-- upvalues: (ref) v_u_7, (copy) v_u_60, (copy) v_u_61
		v_u_7:SetCoreGuiEnabled(v_u_60, v_u_61)
	end)
end
local function v_u_67() -- name: RestoreSpectateCoreGuiState
	-- upvalues: (copy) v_u_47, (copy) v_u_7
	if v_u_47.Captured == true then
		local v_u_63 = Enum.CoreGuiType.Backpack
		local v_u_64 = v_u_47.Backpack
		pcall(function()
			-- upvalues: (ref) v_u_7, (copy) v_u_63, (copy) v_u_64
			v_u_7:SetCoreGuiEnabled(v_u_63, v_u_64)
		end)
		local v_u_65 = Enum.CoreGuiType.PlayerList
		local v_u_66 = v_u_47.PlayerList
		pcall(function()
			-- upvalues: (ref) v_u_7, (copy) v_u_65, (copy) v_u_66
			v_u_7:SetCoreGuiEnabled(v_u_65, v_u_66)
		end)
		v_u_47.Captured = false
	end
end
local v_u_69 = v_u_19.new(Enum.RenderPriority.Camera.Value, function(p68)
	-- upvalues: (copy) v_u_44
	if v_u_44:GetAttribute("FirstPersonSpectateActive") == true ~= true and v_u_44:GetAttribute("ThirdPersonSpectateOrbitActive") == true ~= true then
		v_u_44.CFrame = v_u_44.CFrame * p68
	end
end)
v_u_69:Start()
v_u_44:SetAttribute("FirstPersonSpectateActive", false)
v_u_44:SetAttribute("ThirdPersonSpectateOrbitActive", false)
function v_u_43.Blur(p70, p71, p72) -- name: Blur
	-- upvalues: (copy) v_u_16, (copy) v_u_9
	v_u_16.TweenCreate(v_u_9.Blur, {
		["Size"] = p70
	}, p71, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, p72)
end
function v_u_43.GetViewportResponsiveScale() -- name: GetViewportResponsiveScale
	local v73 = workspace.CurrentCamera
	if not v73 then
		return 1
	end
	local v74 = v73.ViewportSize
	local v75 = v74.X
	local v76 = v74.Y
	local v77 = math.min(v75, v76)
	if v77 <= 0 then
		return 1
	end
	local v78 = v77 / 720
	return math.clamp(v78, 0.5, 1)
end
function v_u_43.GetResponsiveOffsetSize(p79, p80) -- name: GetResponsiveOffsetSize
	-- upvalues: (copy) v_u_43
	local v81 = v_u_43.GetViewportResponsiveScale()
	local v82 = UDim2.new
	local v83 = p79 * v81 + 0.5
	local v84 = math.floor(v83)
	local v85 = p80 * v81 + 0.5
	return v82(0, v84, 0, (math.floor(v85)))
end
function v_u_43.AddPlayerCharacter(p_u_86) -- name: AddPlayerCharacter
	-- upvalues: (copy) v_u_4
	local v_u_87 = nil
	pcall(function()
		-- upvalues: (copy) p_u_86, (ref) v_u_4, (ref) v_u_87
		local v88 = p_u_86.PlayerData.Loadout:FindFirstChild(p_u_86.PlayerData.Settings:GetAttribute("LoadoutName"))
		local v89 = v_u_4.Items.Head[v88:GetAttribute("Head")]:Clone()
		v_u_4.Items.Top[v88:GetAttribute("Top")]:Clone().Parent = v89
		v_u_4.Items.Bottom[v88:GetAttribute("Bottom")]:Clone().Parent = v89
		v_u_87 = v89
	end)
	return v_u_87
end
function v_u_43.AddAIKillFeed(p90, p91, p92, p93, p94) -- name: AddAIKillFeed
	-- upvalues: (copy) v_u_43, (copy) v_u_12, (copy) v_u_39, (copy) v_u_10, (copy) v_u_11
	local v95 = script.FeedSample:Clone()
	if v_u_43.AddWeaponToFeed(p93, v95.Info2.ItemPort) == nil then
		v95.Info2.Visible = false
		v95.Info2Text.Visible = true
		v95.Info2Text.Text = "  " .. p93 .. "  "
	end
	if p94 then
		v95.Info3.Visible = true
	else
		v95.Info3.Visible = false
	end
	v95.Info1.Text = "  " .. p91 .. "  "
	v95.Info1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	v95.Info4.Text = "  " .. p92.DisplayName .. "  "
	if p92.Team == v_u_12.Blue then
		v95.Info4.BackgroundColor3 = v_u_39:GetAttribute("BlueColor")
	else
		v95.Info4.BackgroundColor3 = v_u_39:GetAttribute("RedColor")
	end
	if p92 == v_u_10.LocalPlayer then
		v95.Info2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		v95.Info2Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		v95.Info3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		v95.Info3.Display.ImageColor3 = Color3.fromRGB(0, 0, 0)
		v95.Info2.ItemPort.Ambient = Color3.fromRGB(0, 0, 0)
		v95.Info2.ItemPort.LightColor = Color3.fromRGB(0, 0, 0)
		v95.Info2.ItemPort.ImageColor3 = Color3.fromRGB(0, 0, 0)
		v95.Info2Text.TextColor3 = Color3.fromRGB(0, 0, 0)
	end
	v95.Parent = p90.Frame
	v_u_11:AddItem(v95, 10)
	return v95
end
function v_u_43.AddKillFeed(p96, p97, p98, p99, p100) -- name: AddKillFeed
	-- upvalues: (copy) v_u_43, (copy) v_u_10, (copy) v_u_12, (copy) v_u_39, (copy) v_u_11
	local v101 = script.FeedSample:Clone()
	local v102 = v_u_43.AddWeaponToFeed(p99, v101.Info2.ItemPort)
	local v103 = p97 == v_u_10.LocalPlayer
	for _, v104 in pairs(v101.Info2.ItemPort:GetDescendants()) do
		if v104:IsA("BasePart") then
			v104.Color = v103 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
			v104.Material = Enum.Material.SmoothPlastic
			if v104:IsA("MeshPart") then
				v104.TextureID = ""
			end
		end
	end
	if v102 == nil then
		v101.Info2.Visible = false
		v101.Info2Text.Visible = true
		v101.Info2Text.Text = p99
	end
	if p100 then
		v101.Info3.Visible = true
	else
		v101.Info3.Visible = false
	end
	v101.Info1.Text = "  " .. p97.DisplayName .. "  "
	local v105 = p98.Parent == v_u_10 and p98.DisplayName or tostring(p98)
	v101.Info4.Text = ("  %*  "):format(v105)
	if p97.Team == v_u_12.Blue then
		v101.Info1.BackgroundColor3 = v_u_39:GetAttribute("BlueColor")
		v101.Info4.BackgroundColor3 = v_u_39:GetAttribute("RedColor")
	else
		v101.Info1.BackgroundColor3 = v_u_39:GetAttribute("RedColor")
		v101.Info4.BackgroundColor3 = v_u_39:GetAttribute("BlueColor")
	end
	if v103 then
		v101.Info2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		v101.Info2Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		v101.Info3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		v101.Info3.Display.ImageColor3 = Color3.fromRGB(0, 0, 0)
		v101.Info2.ItemPort.Ambient = Color3.fromRGB(0, 0, 0)
		v101.Info2.ItemPort.LightColor = Color3.fromRGB(0, 0, 0)
		v101.Info2.ItemPort.ImageColor3 = Color3.fromRGB(0, 0, 0)
	end
	v101.Parent = p96.Frame
	v_u_11:AddItem(v101, 10)
	return v101
end
function v_u_43.AddBagFeed(p106, p107, p108, p109) -- name: AddBagFeed
	-- upvalues: (copy) v_u_16, (copy) v_u_39, (copy) v_u_11
	local v110 = script.BagFeedSample:Clone()
	v110.Info1.Text = " " .. p107.DisplayName .. " " .. p108 .. " "
	v110.Info2.Display.ImageColor3 = v_u_16.TeamColors[p109]
	v110.Info1.BackgroundColor3 = v_u_39:GetAttribute(p107.Team.Name .. "Color")
	v110.Info2.BackgroundColor3 = v_u_39:GetAttribute(p107.Team.Name .. "Color")
	v110.Parent = p106.Frame
	v_u_11:AddItem(v110, 10)
	return v110
end
function v_u_43.AddWeaponToFeed(p111, p112) -- name: AddWeaponToFeed
	-- upvalues: (copy) v_u_4, (copy) v_u_16, (copy) v_u_18
	local v113 = v_u_4.Items.Weapon:FindFirstChild(p111)
	if v113 == nil then
		v113 = v_u_4.Items.Throwable:FindFirstChild(p111)
		if v113 == nil then
			v113 = v_u_4.Items.Deployable:FindFirstChild(p111)
			if v113 == nil then
				v113 = v_u_4.Items.Knife:FindFirstChild(p111)
			end
		end
	end
	if v113 == nil then
		return nil
	end
	local v114 = v_u_16.GetItemDataFromObject(v113)
	local v115 = v_u_18.Menu.AddItemToViewport(v114, p112)
	if v114.Type == "Weapon" then
		v115:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 1.5707963267948966, 0))
	end
	return true
end
function v_u_43.GetAlivePlayers() -- name: GetAlivePlayers
	-- upvalues: (copy) v_u_10, (copy) v_u_12
	local v116 = 0
	local v117 = 0
	for _, v118 in pairs(v_u_10:GetChildren()) do
		if v118:FindFirstChild("ServerData") and v118.ServerData:GetAttribute("Alive") == true then
			if v118.Team == v_u_12.Blue then
				v116 = v116 + 1
			elseif v118.Team == v_u_12.Red then
				v117 = v117 + 1
			end
		end
	end
	return v117, v116
end
local v_u_119 = {
	["Fire"] = true,
	["Tear"] = true,
	["Frost"] = true,
	["Poison"] = true
}
local v_u_120 = {
	["Player"] = nil,
	["LocalPlayer"] = nil,
	["Frame"] = nil,
	["Character"] = nil,
	["Humanoid"] = nil,
	["SourcePlayer"] = nil,
	["SourceServerData"] = nil,
	["SourcePlayerConnections"] = nil,
	["MirroredHealth"] = nil,
	["MirroredMaxHealth"] = nil,
	["MirroredStatusValues"] = nil,
	["MirroredFlashValue"] = 0,
	["PreviousHealth"] = nil,
	["Moving"] = "UP",
	["Slider"] = 0,
	["EffectMultiplier"] = 0.4,
	["DownSlider"] = 1,
	["DownSliderTimer"] = 0,
	["EffectSlider"] = 1,
	["EffectSliderTimer"] = 0,
	["FlashSlider"] = 1,
	["CharacterConnections"] = nil,
	["MainConnections"] = nil,
	["SourcePlayerConnections"] = {},
	["MirroredStatusValues"] = {},
	["CharacterConnections"] = {},
	["MainConnections"] = {}
}
function v_u_43.ConfigDamageFeed() -- name: ConfigDamageFeed
	-- upvalues: (copy) v_u_10, (copy) v_u_120, (copy) v_u_43, (copy) v_u_44, (copy) v_u_39, (copy) v_u_9, (copy) v_u_16, (copy) v_u_6, (copy) v_u_119, (copy) v_u_69, (copy) v_u_19, (copy) v_u_4, (copy) v_u_38
	local v_u_121 = v_u_10.LocalPlayer
	local v_u_122 = v_u_121:WaitForChild("PlayerGui"):WaitForChild("GameHUD"):WaitForChild("DamageFeed")
	local v123 = v_u_121:WaitForChild("ServerData")
	v_u_120.Player = v_u_121
	v_u_120.LocalPlayer = v_u_121
	v_u_120.Frame = v_u_122
	v_u_120.SourcePlayer = v_u_121
	v_u_120.SourceServerData = v123
	local v_u_124 = {
		["Blood1"] = 0.5,
		["Blood2"] = 0.5,
		["Blood3"] = 0.7,
		["Blood4"] = 0.2,
		["Fade1"] = 0.5
	}
	local function v_u_127(p125) -- name: DisconnectConnections
		for _, v126 in pairs(p125) do
			if v126 then
				v126:Disconnect()
			end
		end
		table.clear(p125)
	end
	local v_u_128 = nil
	local v_u_129 = nil
	local function v142(p130) -- name: SetDamageFeedSourcePlayer
		-- upvalues: (copy) v_u_121, (ref) v_u_120, (ref) v_u_129, (copy) v_u_127, (ref) v_u_128
		local v131 = p130 or v_u_121
		if v_u_120.SourcePlayer == v131 then
			local v132 = v_u_120.SourceServerData
			local v133
			if v131 then
				v133 = v131:FindFirstChild("ServerData")
			else
				v133 = v131
			end
			if v132 == v133 then
				v_u_129()
				return
			end
		end
		v_u_127(v_u_120.SourcePlayerConnections)
		v_u_120.MirroredHealth = nil
		v_u_120.MirroredMaxHealth = nil
		v_u_120.MirroredStatusValues = {}
		v_u_120.MirroredFlashValue = 0
		v_u_120.ReplayLastStatusValues = {}
		v_u_120.ReplayLastFlashValue = 0
		v_u_120.SourcePlayer = v131
		v_u_120.SourceServerData = not v131 or v131:FindFirstChild("ServerData") or (v131:WaitForChild("ServerData", 10) or nil)
		if v131 then
			local v134 = v_u_120.SourcePlayerConnections
			local v135 = v131.CharacterAdded
			local function v137(p136)
				-- upvalues: (ref) v_u_128
				v_u_128(p136)
			end
			table.insert(v134, v135:Connect(v137))
			local v138 = v_u_120.SourceServerData
			if v138 then
				local v139 = v_u_120.SourcePlayerConnections
				local v140 = v138:GetAttributeChangedSignal("Alive")
				local function v141()
					-- upvalues: (ref) v_u_129
					v_u_129()
				end
				table.insert(v139, v140:Connect(v141))
			end
		end
		v_u_128(v131 and v131.Character or nil)
	end
	v_u_43.SetDamageFeedSourcePlayer = v142
	local function v_u_144() -- name: ResetDamageFeed
		-- upvalues: (ref) v_u_9, (copy) v_u_122, (ref) v_u_120
		v_u_9.Blur.Size = 0
		v_u_9.ColorCorrection.Saturation = 0
		for _, v143 in pairs({
			"Blood1",
			"Blood2",
			"Blood3",
			"Blood4",
			"Fade1",
			"Fade2",
			"Fade3",
			"Fire",
			"Tear",
			"Frost",
			"Heal",
			"Poison"
		}) do
			if v_u_122:FindFirstChild(v143) then
				v_u_122[v143].ImageTransparency = 1
			end
		end
		if v_u_122:FindFirstChild("Flash") then
			v_u_122.Flash.BackgroundTransparency = 1
		end
		v_u_120.Moving = "UP"
		v_u_120.Slider = 0
		v_u_120.DownSlider = 1
		v_u_120.DownSliderTimer = 0
		v_u_120.EffectSlider = 1
		v_u_120.EffectSliderTimer = 0
		v_u_120.FlashSlider = 1
	end
	v_u_129 = function() -- name: RefreshDamageFeedState
		-- upvalues: (ref) v_u_120, (ref) v_u_39, (copy) v_u_121, (ref) v_u_44, (copy) v_u_122, (copy) v_u_144
		local v145 = v_u_120.SourceServerData
		local v146
		if v_u_39:GetAttribute("Phase") == "Round Started" and (v145 and v145:GetAttribute("Alive") == true) then
			v146 = v_u_120.SourcePlayer == v_u_121 and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true
		else
			v146 = false
		end
		if v146 == true then
			v_u_122.Visible = true
		else
			v_u_122.Visible = false
			v_u_144()
		end
	end
	local function v_u_152(p147, p148) -- name: PlayFlash
		-- upvalues: (ref) v_u_120, (ref) v_u_39, (copy) v_u_121, (ref) v_u_44, (copy) v_u_122, (ref) v_u_6, (ref) v_u_16
		local v149 = v_u_120.SourceServerData
		local v150
		if v_u_39:GetAttribute("Phase") == "Round Started" and (v149 and v149:GetAttribute("Alive") == true) then
			v150 = v_u_120.SourcePlayer == v_u_121 and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true
		else
			v150 = false
		end
		if v150 == false then
			return
		elseif p147 == nil then
			return
		elseif v_u_122:FindFirstChild("Flash") ~= nil then
			local v151 = typeof(p148) == "number" and p148 and p148 or (p147:GetAttribute("Flash") or 0)
			if v151 == 1 then
				v_u_122.Flash.BackgroundTransparency = 0.5
				v_u_120.FlashSlider = 0.5
				if v_u_6.Flashbang.Playing == false then
					v_u_6.Flashbang.Volume = 0
					v_u_6.Flashbang:Play()
					v_u_16.TweenCreate(v_u_6.Flashbang, {
						["Volume"] = 0.5
					}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
					return
				end
			elseif v151 > 1 then
				v_u_122.Flash.BackgroundTransparency = 0
				v_u_120.FlashSlider = 0
				if v_u_6.Flashbang.Playing == false then
					v_u_6.Flashbang.Volume = 0
					v_u_6.Flashbang:Play()
					v_u_16.TweenCreate(v_u_6.Flashbang, {
						["Volume"] = 0.5
					}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
					return
				end
			elseif v151 <= 0 then
				coroutine.resume(coroutine.create(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6
					v_u_16.TweenCreate(v_u_6.Flashbang, {
						["Volume"] = 0
					}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true)
					if v_u_6.Flashbang.Volume <= 0.05 then
						v_u_6.Flashbang:Stop()
					end
				end))
			end
		end
	end
	local function v_u_161(p153, p154, p155) -- name: PlayStatusEffect
		-- upvalues: (ref) v_u_120, (ref) v_u_39, (copy) v_u_121, (ref) v_u_44, (ref) v_u_119, (copy) v_u_122, (ref) v_u_16, (ref) v_u_69, (ref) v_u_19, (ref) v_u_4
		local v156 = v_u_120.SourceServerData
		local v157
		if v_u_39:GetAttribute("Phase") == "Round Started" and (v156 and v156:GetAttribute("Alive") == true) then
			v157 = v_u_120.SourcePlayer == v_u_121 and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true
		else
			v157 = false
		end
		if v157 == false then
			return
		elseif p153 == nil then
			return
		elseif v_u_119[p154] == true then
			if v_u_122:FindFirstChild(p154) == nil then
				return
			else
				local v158 = typeof(p155) == "number" and p155 and p155 or (p153:GetAttribute(p154) or 0)
				if v158 > 0 then
					v_u_122[p154].ImageTransparency = 0
					local v_u_159 = v_u_122[p154]
					if v_u_159 ~= nil and v_u_159.Parent ~= nil then
						coroutine.resume(coroutine.create(function()
							-- upvalues: (copy) v_u_159, (ref) v_u_16
							local v160 = v_u_159.Size
							v_u_16.TweenCreate(v_u_159, {
								["Size"] = UDim2.new(v160.X.Scale * 1.08, v160.X.Offset, v160.Y.Scale * 1.08, v160.Y.Offset)
							}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, true)
							if v_u_159 ~= nil and v_u_159.Parent ~= nil then
								v_u_16.TweenCreate(v_u_159, {
									["Size"] = v160
								}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
							end
						end))
					end
					if p154 == "Tear" then
						v_u_69:Shake(v_u_19.Presets.Tear)
					end
					if p154 == "Frost" then
						if v158 <= 1 then
							v_u_16.AddSound("Damage_Freeze", 0.2, true, nil, false)
						end
						if v_u_120.SourcePlayer == v_u_121 and (p153:FindFirstChild("ClientWeaponSystem") and p153.ClientWeaponSystem:GetAttribute("Movement")) then
							v_u_4.GameEvents.ChangeMovement:FireServer(p153.ClientWeaponSystem:GetAttribute("Movement"))
						end
					end
				end
			end
		else
			return
		end
	end
	local function v_u_169() -- name: PlayHeal
		-- upvalues: (ref) v_u_120, (ref) v_u_39, (copy) v_u_121, (ref) v_u_44, (copy) v_u_122, (ref) v_u_16
		local v162 = v_u_120.SourceServerData
		local v163
		if v_u_39:GetAttribute("Phase") == "Round Started" and (v162 and v162:GetAttribute("Alive") == true) then
			v163 = v_u_120.SourcePlayer == v_u_121 and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true
		else
			v163 = false
		end
		if v163 == false then
			return
		elseif v_u_122:FindFirstChild("Heal") ~= nil then
			local v_u_164 = (v_u_122:GetAttribute("HealId") or 0) + 1
			v_u_122:SetAttribute("HealId", v_u_164)
			v_u_122.Heal.ImageTransparency = 0.6
			local v_u_165 = v_u_122.Heal
			if v_u_165 ~= nil and v_u_165.Parent ~= nil then
				coroutine.resume(coroutine.create(function()
					-- upvalues: (copy) v_u_165, (ref) v_u_16
					local v166 = v_u_165.Size
					v_u_16.TweenCreate(v_u_165, {
						["Size"] = UDim2.new(v166.X.Scale * 1.08, v166.X.Offset, v166.Y.Scale * 1.08, v166.Y.Offset)
					}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, true)
					if v_u_165 ~= nil and v_u_165.Parent ~= nil then
						v_u_16.TweenCreate(v_u_165, {
							["Size"] = v166
						}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
					end
				end))
			end
			task.delay(1, function()
				-- upvalues: (ref) v_u_122, (copy) v_u_164, (ref) v_u_120, (ref) v_u_39, (ref) v_u_121, (ref) v_u_44, (ref) v_u_16
				if v_u_122:GetAttribute("HealId") == v_u_164 then
					local v167 = v_u_120.SourceServerData
					local v168
					if v_u_39:GetAttribute("Phase") == "Round Started" and (v167 and v167:GetAttribute("Alive") == true) then
						v168 = v_u_120.SourcePlayer == v_u_121 and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true
					else
						v168 = false
					end
					if v168 == false then
						return
					elseif v_u_122.Heal ~= nil and v_u_122.Heal.Parent ~= nil then
						v_u_16.TweenCreate(v_u_122.Heal, {
							["ImageTransparency"] = 1
						}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
					end
				else
					return
				end
			end)
		end
	end
	local function v_u_180(p170, p171) -- name: PlayDamage
		-- upvalues: (ref) v_u_120, (ref) v_u_39, (copy) v_u_121, (ref) v_u_44, (ref) v_u_9, (copy) v_u_124, (copy) v_u_122, (ref) v_u_16
		local v172 = v_u_120.SourceServerData
		local v173
		if v_u_39:GetAttribute("Phase") == "Round Started" and (v172 and v172:GetAttribute("Alive") == true) then
			v173 = v_u_120.SourcePlayer == v_u_121 and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true
		else
			v173 = false
		end
		if v173 == false then
			return
		elseif p170 <= 0 then
			return
		elseif p171 > 0 then
			local v174 = p170 / p171
			local v175 = math.clamp(v174, 0, 1)
			v_u_9.Blur.Size = v175 * 10
			v_u_9.ColorCorrection.Saturation = v175 * -0.5
			for v176, v177 in pairs(v_u_124) do
				if v_u_122:FindFirstChild(v176) then
					v_u_122[v176].ImageTransparency = v177
					local v_u_178 = v_u_122[v176]
					if v_u_178 ~= nil then
						if v_u_178.Parent ~= nil then
							coroutine.resume(coroutine.create(function()
								-- upvalues: (copy) v_u_178, (ref) v_u_16
								local v179 = v_u_178.Size
								v_u_16.TweenCreate(v_u_178, {
									["Size"] = UDim2.new(v179.X.Scale * 1.08, v179.X.Offset, v179.Y.Scale * 1.08, v179.Y.Offset)
								}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, true)
								if v_u_178 ~= nil and v_u_178.Parent ~= nil then
									v_u_16.TweenCreate(v_u_178, {
										["Size"] = v179
									}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
								end
							end))
						end
					end
				end
			end
			v_u_16.TweenCreate(v_u_9.Blur, {
				["Size"] = 0
			}, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
			v_u_16.TweenCreate(v_u_9.ColorCorrection, {
				["Saturation"] = 0
			}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
			v_u_120.DownSliderTimer = v_u_16.BloodCooldown
			v_u_120.EffectSliderTimer = v_u_16.EffectCooldown
			v_u_120.DownSlider = 0
			v_u_120.EffectSlider = 0
		end
	end
	local function v_u_206(p181, p182) -- name: ApplyMirroredDamageFeedPayload
		-- upvalues: (copy) v_u_121, (ref) v_u_120, (copy) v_u_144, (ref) v_u_129, (ref) v_u_119, (copy) v_u_161, (copy) v_u_152, (copy) v_u_180, (copy) v_u_169
		if p181 == nil or p181 == v_u_121 then
			return
		elseif v_u_120.SourcePlayer == p181 then
			if typeof(p182) == "table" then
				local v183 = p182.Action
				if v183 == "Reset" then
					v_u_120.MirroredHealth = nil
					v_u_120.MirroredMaxHealth = nil
					v_u_120.MirroredStatusValues = {}
					v_u_120.MirroredFlashValue = 0
					v_u_120.ReplayLastStatusValues = {}
					v_u_120.ReplayLastFlashValue = 0
					v_u_144()
					v_u_129()
					return
				elseif v183 == "Sync" then
					local v184 = v_u_120
					local v185 = p182.Health
					v184.MirroredHealth = tonumber(v185)
					local v186 = v_u_120
					local v187 = p182.MaxHealth
					v186.MirroredMaxHealth = tonumber(v187)
					v_u_120.PreviousHealth = v_u_120.MirroredHealth
					local v188 = v_u_120
					local v189 = p182.Flash
					v188.MirroredFlashValue = tonumber(v189) or 0
					local v190 = p182.Statuses
					local v191 = typeof(v190) == "table" and p182.Statuses or {}
					for v192, _ in pairs(v_u_119) do
						local v193 = v191[v192]
						local v194 = tonumber(v193) or 0
						v_u_120.MirroredStatusValues[v192] = v194
						if v194 > 0 then
							v_u_161(v_u_120.Character, v192, v194)
						end
					end
					if v_u_120.MirroredFlashValue > 0 then
						v_u_152(v_u_120.Character, v_u_120.MirroredFlashValue)
					end
					v_u_129()
					return
				elseif v183 == "Health" then
					local v195 = p182.PreviousHealth
					local v196 = tonumber(v195)
					local v197 = p182.Health
					local v198 = tonumber(v197)
					local v199 = p182.MaxHealth
					local v200 = tonumber(v199) or v_u_120.MirroredMaxHealth or (v_u_120.Humanoid and v_u_120.Humanoid.MaxHealth or 0)
					if v198 ~= nil then
						if v196 ~= nil then
							if v198 < v196 then
								v_u_180(v196 - v198, v200)
							elseif v196 < v198 then
								v_u_169()
							end
						end
						v_u_120.MirroredHealth = v198
						v_u_120.MirroredMaxHealth = v200
						v_u_120.PreviousHealth = v198
					end
				elseif v183 == "Status" then
					local v201 = p182.EffectName
					if v_u_119[v201] == true then
						local v202 = p182.Value
						local v203 = tonumber(v202) or 0
						v_u_120.MirroredStatusValues[v201] = v203
						if v203 > 0 then
							v_u_161(v_u_120.Character, v201, v203)
						end
					end
				elseif v183 == "Flash" then
					local v204 = p182.Value
					local v205 = tonumber(v204) or 0
					v_u_120.MirroredFlashValue = v205
					if v205 > 0 then
						v_u_152(v_u_120.Character, v205)
					end
				end
			else
				return
			end
		else
			return
		end
	end
	v_u_128 = function(p_u_207) -- name: SetupCharacter
		-- upvalues: (copy) v_u_127, (ref) v_u_120, (ref) v_u_129, (copy) v_u_121, (ref) v_u_39, (ref) v_u_44, (copy) v_u_180, (copy) v_u_169, (ref) v_u_119, (copy) v_u_161, (copy) v_u_152
		v_u_127(v_u_120.CharacterConnections)
		v_u_120.Character = p_u_207
		v_u_120.Humanoid = nil
		v_u_120.PreviousHealth = nil
		if p_u_207 == nil then
			v_u_129()
			return
		else
			local v208 = p_u_207:FindFirstChild("Humanoid")
			if v208 == nil then
				v208 = p_u_207:WaitForChild("Humanoid", 5)
			end
			if v208 == nil then
				v_u_129()
				return
			else
				v_u_120.Humanoid = v208
				v_u_120.PreviousHealth = v208.Health
				if v_u_120.SourcePlayer == v_u_121 then
					local v209 = v_u_120.CharacterConnections
					local v210 = v208.HealthChanged
					local function v216(p211)
						-- upvalues: (ref) v_u_120, (ref) v_u_39, (ref) v_u_121, (ref) v_u_44, (ref) v_u_180, (ref) v_u_169
						if v_u_120.Humanoid == nil then
							return
						else
							local v212 = v_u_120.Humanoid.MaxHealth
							local v213 = v_u_120.PreviousHealth or p211
							local v214 = v_u_120.SourceServerData
							local v215
							if v_u_39:GetAttribute("Phase") == "Round Started" and (v214 and v214:GetAttribute("Alive") == true) then
								v215 = v_u_120.SourcePlayer == v_u_121 and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true
							else
								v215 = false
							end
							if v215 == false then
								v_u_120.PreviousHealth = p211
							else
								if p211 < v213 then
									v_u_180(v213 - p211, v212)
								elseif v213 < p211 then
									v_u_169()
								end
								v_u_120.PreviousHealth = p211
							end
						end
					end
					table.insert(v209, v210:Connect(v216))
					for v_u_217, _ in pairs(v_u_119) do
						local v218 = v_u_120.CharacterConnections
						local v219 = p_u_207:GetAttributeChangedSignal(v_u_217)
						local function v220()
							-- upvalues: (ref) v_u_161, (copy) p_u_207, (copy) v_u_217
							v_u_161(p_u_207, v_u_217)
						end
						table.insert(v218, v219:Connect(v220))
					end
					local v221 = v_u_120.CharacterConnections
					local v222 = p_u_207:GetAttributeChangedSignal("Flash")
					local function v223()
						-- upvalues: (ref) v_u_152, (copy) p_u_207
						v_u_152(p_u_207)
					end
					table.insert(v221, v222:Connect(v223))
					v_u_129()
				else
					v_u_129()
				end
			end
		end
	end
	v_u_127(v_u_120.MainConnections)
	local v224 = v_u_120.MainConnections
	local v225 = v_u_39:GetAttributeChangedSignal("Phase")
	local function v226()
		-- upvalues: (ref) v_u_129
		v_u_129()
	end
	table.insert(v224, v225:Connect(v226))
	local v227 = v_u_120.MainConnections
	local v228 = v_u_121.CharacterAdded
	local function v230(p229)
		-- upvalues: (ref) v_u_120, (copy) v_u_121, (ref) v_u_128, (ref) v_u_129
		if v_u_120.SourcePlayer == v_u_121 then
			v_u_128(p229)
		end
		v_u_129()
	end
	table.insert(v227, v228:Connect(v230))
	local v231 = v_u_120.MainConnections
	local v232 = v_u_38.OnClientEvent
	table.insert(v231, v232:Connect(function(p233, p234)
		-- upvalues: (copy) v_u_206
		if typeof(p233) == "Instance" and p233:IsA("Player") then
			v_u_206(p233, p234)
		end
	end))
	local v235 = v_u_43.CurrentSpectatingPlayer
	if v_u_44:GetAttribute("FirstPersonSpectateActive") == true ~= true or (typeof(v235) ~= "Instance" or (not v235:IsA("Player") or v235 == v_u_121)) then
		v235 = v_u_121
	end
	v142(v235)
	v_u_129()
end
function v_u_43.DamageFeedRuntime(p236, p237) -- name: DamageFeedRuntime
	-- upvalues: (copy) v_u_120, (copy) v_u_10, (copy) v_u_39, (copy) v_u_44, (copy) v_u_119, (copy) v_u_12
	local v238 = v_u_120.LocalPlayer or (v_u_120.Player or v_u_10.LocalPlayer)
	local v239 = v_u_120.SourcePlayer or v238
	local v240 = v_u_120.Frame
	if v240 == nil then
		local v241 = v238:FindFirstChild("PlayerGui")
		if v241 == nil then
			return
		end
		local v242 = v241:FindFirstChild("GameHUD")
		if v242 == nil then
			return
		end
		v240 = v242:FindFirstChild("DamageFeed")
		if v240 == nil then
			return
		end
		v_u_120.Frame = v240
	end
	local v243
	if v239 then
		v243 = v239.Character
	else
		v243 = v239
	end
	local v244 = v_u_120.Humanoid
	if not v244 then
		if v243 then
			v244 = v243:FindFirstChild("Humanoid")
		else
			v244 = v243
		end
	end
	local v245 = v239 ~= v238
	if v244 == nil then
		return
	else
		local v246 = v_u_120.SourceServerData
		if not v246 then
			if v239 then
				v246 = v239:FindFirstChild("ServerData")
			else
				v246 = v239
			end
		end
		if v246 == nil then
			return
		else
			local v247
			if v_u_39:GetAttribute("Phase") == "Round Started" and v246:GetAttribute("Alive") == true then
				v247 = v239 == v238 and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true
			else
				v247 = false
			end
			if v247 == false then
				if v240:FindFirstChild("Fade2") then
					v240.Fade2.ImageTransparency = 1
				end
				if v240:FindFirstChild("Fade3") then
					v240.Fade3.ImageTransparency = 1
				end
				return
			else
				local v248 = v240.Parent
				local v249
				if v248 and v248:FindFirstChild("SpectatorUI") then
					v249 = v248.SpectatorUI.Visible
				else
					v249 = false
				end
				local v250, v251, v252
				if ReplayKillCamActive == true and (v239 ~= v238 and (SpectateObserver and SpectateObserver.GetReplayStatusState)) then
					v250 = SpectateObserver:GetReplayStatusState()
					if typeof(v250) == "table" then
						local v253 = v250.Statuses
						if typeof(v253) == "table" then
							v251 = v250.Statuses or nil
						else
							v251 = nil
						end
					else
						v251 = nil
					end
					if v251 == nil then
						if typeof(v250) == "table" then
							local v254 = v250.Flash
							v252 = tonumber(v254) ~= nil
						else
							v252 = false
						end
					else
						v252 = true
					end
				else
					v252 = false
					v251 = nil
					v250 = nil
				end
				if v252 then
					v_u_120.ReplayLastStatusValues = v_u_120.ReplayLastStatusValues or {}
					for v255 in pairs(v_u_119) do
						local v256
						if v251 then
							local v257 = v251[v255]
							v256 = tonumber(v257) or 0
						else
							v256 = 0
						end
						local v258 = v_u_120.ReplayLastStatusValues[v255]
						local v259 = tonumber(v258) or 0
						if v256 > 0 and v256 ~= v259 then
							PlayStatusEffect(v243, v255, v256)
						end
						v_u_120.ReplayLastStatusValues[v255] = v256
					end
					local v260
					if typeof(v250) == "table" then
						local v261 = v250.Flash
						v260 = tonumber(v261) or 0
					else
						v260 = 0
					end
					local v262 = v_u_120.ReplayLastFlashValue
					local v263 = tonumber(v262) or 0
					if v260 > 0 and v260 ~= v263 then
						PlayFlash(v243, v260)
					end
					v_u_120.ReplayLastFlashValue = v260
				else
					v_u_120.ReplayLastStatusValues = v_u_120.ReplayLastStatusValues or {}
					for v264 in pairs(v_u_119) do
						v_u_120.ReplayLastStatusValues[v264] = 0
					end
					v_u_120.ReplayLastFlashValue = 0
				end
				local v265 = v245 and (v_u_120.MirroredHealth or v244.Health) or v244.Health
				local v266 = v245 and (v_u_120.MirroredMaxHealth or v244.MaxHealth) or v244.MaxHealth
				if v266 > 0 then
					if v265 < v266 and (v249 == false or v239 ~= v238) and v238.Team ~= v_u_12.Spectator then
						local v267 = 1 - v265 / v266
						local v268 = math.clamp(v267, 0, 1)
						if v_u_120.Moving == "UP" then
							v_u_120.Slider = LerpNumber(v_u_120.Slider, 1, p237 * p236 * v268)
							if v_u_120.Slider >= 0.99 then
								v_u_120.Slider = 1
								v_u_120.Moving = "DOWN"
							end
						else
							v_u_120.Slider = LerpNumberInverse(v_u_120.Slider, 0, p237 * p236 * v268)
							if v_u_120.Slider <= 0.01 then
								v_u_120.Slider = 0
								v_u_120.Moving = "UP"
							end
						end
						local v269 = 1 - v_u_120.EffectMultiplier * v268 * v_u_120.Slider
						local v270 = v_u_120.Slider * v_u_120.EffectMultiplier * v268
						local v271 = math.clamp(v270, 0, v268) + 1.2
						local v272 = math.clamp(v271, 0, 1.4)
						if v240:FindFirstChild("Fade2") then
							v240.Fade2.ImageTransparency = v269
							v240.Fade2.Size = UDim2.new(v272, 0, v272, 0)
						end
						if v240:FindFirstChild("Fade3") then
							v240.Fade3.ImageTransparency = v269
							v240.Fade3.Size = UDim2.new(v272, 0, v272, 0)
						end
					else
						if v240:FindFirstChild("Fade2") then
							v240.Fade2.ImageTransparency = 1
						end
						if v240:FindFirstChild("Fade3") then
							v240.Fade3.ImageTransparency = 1
						end
					end
					local v273 = v_u_120
					local v274 = v_u_120.DownSliderTimer - p237
					v273.DownSliderTimer = math.clamp(v274, 0, (1 / 0))
					if v_u_120.DownSliderTimer <= 0 then
						v_u_120.DownSlider = LerpNumber(v_u_120.DownSlider, 1, p237)
						for v275, v276 in pairs({
							["Blood1"] = 0.5,
							["Blood2"] = 0.5,
							["Blood3"] = 0.7,
							["Blood4"] = 0.2,
							["Fade1"] = 0.5
						}) do
							if v240:FindFirstChild(v275) then
								local v277 = v240[v275]
								local v278 = v276 + v_u_120.DownSlider
								v277.ImageTransparency = math.clamp(v278, v276, 1)
							end
						end
					end
					local v279 = v_u_120
					local v280 = v_u_120.EffectSliderTimer - p237
					v279.EffectSliderTimer = math.clamp(v280, 0, (1 / 0))
					if v_u_120.EffectSliderTimer <= 0 then
						v_u_120.EffectSlider = LerpNumber(v_u_120.EffectSlider, 1, p237)
						for _, v281 in pairs({
							"Fire",
							"Tear",
							"Frost",
							"Poison"
						}) do
							if v240:FindFirstChild(v281) then
								local v282
								if v252 then
									if v251 then
										local v283 = v251[v281]
										v282 = tonumber(v283) or 0
									else
										v282 = 0
									end
								elseif v245 then
									local v284 = v_u_120.MirroredStatusValues[v281]
									v282 = tonumber(v284) or 0
								else
									v282 = v243:GetAttribute(v281) or 0
								end
								if v282 <= 0 and v240[v281].ImageTransparency < 1 then
									local v285 = v240[v281]
									local v286 = v_u_120.EffectSlider
									v285.ImageTransparency = math.clamp(v286, 0, 1)
								end
							end
						end
					end
					if v240:FindFirstChild("Flash") then
						local v287
						if v252 then
							if typeof(v250) == "table" then
								local v288 = v250.Flash
								v287 = tonumber(v288) or 0
							else
								v287 = 0
							end
						elseif v245 then
							local v289 = v_u_120.MirroredFlashValue
							v287 = tonumber(v289) or 0
						else
							v287 = v243:GetAttribute("Flash") or 0
						end
						if v287 <= 0 and v240.Flash.BackgroundTransparency < 1 then
							v_u_120.FlashSlider = LerpNumber(v_u_120.FlashSlider, 1, p237)
							local v290 = v240.Flash
							local v291 = v_u_120.FlashSlider
							v290.BackgroundTransparency = math.clamp(v291, 0, 1)
						end
					end
				end
			end
		end
	end
end
local function v_u_301(p_u_292, p293, p294, p295, p296) -- name: PlayPointsFeedLabelAnimation
	-- upvalues: (copy) v_u_16
	if p_u_292 ~= nil and p_u_292.Parent ~= nil then
		local v_u_297 = p295 or UDim2.new(1, 0, 1, 0)
		local v_u_298 = p296 or UDim2.new(v_u_297.X.Scale, v_u_297.X.Offset, v_u_297.Y.Scale * 1.2, v_u_297.Y.Offset)
		if p294 == true then
			p_u_292.TextTransparency = 1
		end
		p_u_292.Text = p293
		p_u_292.Size = v_u_297
		if p294 == true then
			v_u_16.TweenCreate(p_u_292, {
				["TextTransparency"] = 0
			}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
		end
		coroutine.resume(coroutine.create(function()
			-- upvalues: (copy) p_u_292, (ref) v_u_297, (ref) v_u_16, (ref) v_u_298
			if p_u_292 == nil or p_u_292.Parent == nil then
				return
			else
				p_u_292.Size = v_u_297
				local v299 = {
					["Size"] = v_u_298
				}
				v_u_16.TweenCreate(p_u_292, v299, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, true)
				if p_u_292 ~= nil and p_u_292.Parent ~= nil then
					local v300 = {
						["Size"] = v_u_297
					}
					v_u_16.TweenCreate(p_u_292, v300, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
				end
			end
		end))
	end
end
function v_u_43.AddPointsFeed(p_u_302, p303) -- name: AddPointsFeed
	-- upvalues: (copy) v_u_10, (copy) v_u_43, (copy) v_u_301, (copy) v_u_16
	local v304 = p303 or {}
	local v305 = v304.SourcePlayer
	if typeof(v305) == "Instance" and (v305:IsA("Player") and (v305 ~= v_u_10.LocalPlayer and v_u_43.CurrentSpectatingPlayer ~= v305)) then
		return
	else
		local v306 = v304.Points or 0
		local v307 = math.floor(v306)
		local v308 = v304.Damage or 0
		local v309 = math.floor(v308)
		if v307 <= 0 and v309 <= 0 then
			return
		else
			local v310 = p_u_302:FindFirstChild("Frame")
			if v310 ~= nil then
				local v311 = p_u_302:GetAttribute("Points") or 0
				local v312 = math.floor(v311)
				local v313 = p_u_302:GetAttribute("Damage") or 0
				local v314 = math.floor(v313)
				local v315 = p_u_302:GetAttribute("Kills") or 0
				math.floor(v315)
				local v316 = UDim2.new(1, 0, 1, 0)
				local v317 = UDim2.new(1, 0, 1.2, 0)
				local v318 = UDim2.new(1, 0, 0.6, 0)
				local v319 = UDim2.new(1, 0, 0.72, 0)
				if v307 > 0 then
					local v320 = v312 + v307
					p_u_302:SetAttribute("Points", (math.floor(v320)))
					local v_u_321 = (p_u_302:GetAttribute("PointsId") or 0) + 1
					p_u_302:SetAttribute("PointsId", v_u_321)
					task.delay(3, function()
						-- upvalues: (copy) p_u_302, (copy) v_u_321
						if p_u_302:GetAttribute("PointsId") == v_u_321 then
							p_u_302:SetAttribute("Points", 0)
						end
					end)
				end
				if v309 > 0 then
					local v322 = v314 + v309
					p_u_302:SetAttribute("Damage", (math.floor(v322)))
					local v_u_323 = (p_u_302:GetAttribute("DamageId") or 0) + 1
					p_u_302:SetAttribute("DamageId", v_u_323)
					task.delay(3, function()
						-- upvalues: (copy) p_u_302, (copy) v_u_323
						if p_u_302:GetAttribute("DamageId") == v_u_323 then
							p_u_302:SetAttribute("Damage", 0)
						end
					end)
				end
				local v324 = p_u_302:GetAttribute("Points") or 0
				local v325 = math.floor(v324)
				local v326 = p_u_302:GetAttribute("Damage") or 0
				local v327 = math.floor(v326)
				local v328 = math.max(v325, v327)
				local v329 = math.floor(v328)
				if v329 > 0 then
					p_u_302:SetAttribute("FeedId", (p_u_302:GetAttribute("FeedId") or 0) + 1)
					local v330 = v310:FindFirstChild("CurrentPoint")
					if v330 == nil then
						v330 = script.SamplePoint:Clone()
						v330.Name = "CurrentPoint"
						v330.Parent = v310
					end
					v330.LayoutOrder = 1
					v330.Visible = true
					if v316 ~= nil then
						v330.Size = v316
					end
					v_u_301(v330, "+" .. tostring(v329), v330.TextTransparency >= 1, v316, v317)
					local v_u_331 = {
						["Points"] = 0,
						["Damage"] = 0
					}
					local v_u_332 = p_u_302:GetAttribute("FeedId")
					local v_u_333 = "FeedId"
					local v_u_334 = "CurrentPoint"
					task.delay(7, function()
						-- upvalues: (copy) p_u_302, (copy) v_u_333, (copy) v_u_332, (copy) v_u_334, (ref) v_u_16, (copy) v_u_331
						if p_u_302:GetAttribute(v_u_333) == v_u_332 then
							local v335 = p_u_302:FindFirstChild("Frame")
							if v335 == nil then
								return
							else
								local v336 = v335:FindFirstChild(v_u_334)
								if v336 ~= nil and v336.Parent ~= nil then
									v_u_16.TweenCreate(v336, {
										["TextTransparency"] = 1
									}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true)
									if v336 ~= nil and v336.Parent ~= nil then
										v336:Destroy()
									end
									for v337, v338 in pairs(v_u_331) do
										p_u_302:SetAttribute(v337, v338)
									end
								end
							end
						else
							return
						end
					end)
				end
				local v339 = p_u_302:GetAttribute("Kills") or 0
				local v340 = math.floor(v339)
				local v341 = v340 > 0 and (v340 == 1 and "CONFIRMED KILL" or (v340 == 2 and "DOUBLE KILL" or (v340 == 3 and "TRIPLE KILL" or (v340 == 4 and "QUADRUPLE KILL" or (v340 == 5 and "ACE" or (v340 == 6 and "ULTRA ACE" or "UNDEFEATABLE++")))))) or nil
				if v341 ~= nil then
					p_u_302:SetAttribute("KillFeedId", (p_u_302:GetAttribute("KillFeedId") or 0) + 1)
					local v342 = v310:FindFirstChild("CurrentKillPoint")
					if v342 == nil then
						v342 = script.SamplePoint:Clone()
						v342.Name = "CurrentKillPoint"
						v342.Parent = v310
					end
					v342.LayoutOrder = 2
					v342.Visible = true
					if v318 ~= nil then
						v342.Size = v318
					end
					v_u_301(v342, v341, v342.TextTransparency >= 1, v318, v319)
					local v_u_343 = {
						["Kills"] = 0
					}
					local v_u_344 = p_u_302:GetAttribute("KillFeedId")
					local v_u_345 = "KillFeedId"
					local v_u_346 = "CurrentKillPoint"
					task.delay(7, function()
						-- upvalues: (copy) p_u_302, (copy) v_u_345, (copy) v_u_344, (copy) v_u_346, (ref) v_u_16, (copy) v_u_343
						if p_u_302:GetAttribute(v_u_345) == v_u_344 then
							local v347 = p_u_302:FindFirstChild("Frame")
							if v347 == nil then
								return
							else
								local v348 = v347:FindFirstChild(v_u_346)
								if v348 ~= nil and v348.Parent ~= nil then
									v_u_16.TweenCreate(v348, {
										["TextTransparency"] = 1
									}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true)
									if v348 ~= nil and v348.Parent ~= nil then
										v348:Destroy()
									end
									for v349, v350 in pairs(v_u_343) do
										p_u_302:SetAttribute(v349, v350)
									end
								end
							end
						else
							return
						end
					end)
				end
			end
		end
	end
end
function LerpNumber(p351, p352, p353) -- name: LerpNumber
	local v354 = p351 + p352 * math.min(p353, 1)
	return math.clamp(v354, 0, p352)
end
function LerpNumberInverse(p355, _, p356) -- name: LerpNumberInverse
	local v357 = p355 - 1 * math.min(p356, 1)
	return math.clamp(v357, 0, 1)
end
function v_u_43.ConfigMouseIcon() -- name: ConfigMouseIcon
	-- upvalues: (copy) v_u_10, (copy) v_u_44, (copy) v_u_2
	local v358 = v_u_10.LocalPlayer:WaitForChild("PlayerGui")
	local v_u_359 = v358:WaitForChild("GameHUD")
	local v_u_360 = v358:WaitForChild("GameMenu")
	local v_u_361 = v358:WaitForChild("Menu")
	local function v362() -- name: Refresh
		-- upvalues: (copy) v_u_359, (ref) v_u_44, (ref) v_u_2, (copy) v_u_361, (copy) v_u_360
		if (v_u_359.SpectatorUI.Visible == true and true or v_u_44:GetAttribute("FirstPersonSpectateActive") == true) == true then
			v_u_2.MouseIconEnabled = true
			v_u_2.MouseBehavior = Enum.MouseBehavior.Default
			return
		elseif v_u_361.Enabled == true or (v_u_359.PlayersTab.Visible == true or (v_u_360.MapChoose.Visible == true or (v_u_360.AttackerPrompt.Visible == true or v_u_360.GameEnd.Visible == true))) then
			v_u_2.MouseIconEnabled = true
		else
			v_u_2.MouseIconEnabled = false
		end
	end
	v_u_361:GetPropertyChangedSignal("Enabled"):Connect(v362)
	v_u_359.PlayersTab:GetPropertyChangedSignal("Visible"):Connect(v362)
	v_u_360.AttackerPrompt:GetPropertyChangedSignal("Visible"):Connect(v362)
	v_u_359.SpectatorUI:GetPropertyChangedSignal("Visible"):Connect(v362)
	v_u_360.GameEnd:GetPropertyChangedSignal("Visible"):Connect(v362)
	v_u_360.MapChoose:GetPropertyChangedSignal("Visible"):Connect(v362)
	v_u_44:GetAttributeChangedSignal("FirstPersonSpectateActive"):Connect(v362)
	v362()
end
function v_u_43.ConfigTopBorder() -- name: ConfigTopBorder
	-- upvalues: (copy) v_u_10, (copy) v_u_1, (copy) v_u_39, (copy) v_u_16
	local v_u_363 = v_u_10.LocalPlayer
	local v_u_364 = v_u_363:WaitForChild("PlayerGui"):WaitForChild("GameHUD")
	local v_u_365 = v_u_364:WaitForChild("TopBorder")
	v_u_365.Middle.Scoreboard.Activated:Connect(function() -- name: TogglePlayersTabActivate
		-- upvalues: (copy) v_u_364
		v_u_364.PlayersTab.Visible = not v_u_364.PlayersTab.Visible
		if v_u_364.PlayersTab.Visible == true then
			v_u_364.PlayersTab.ProfileFrame.Visible = false
		end
	end)
	v_u_1:BindAction("Tab", function(_, p366, _) -- name: TogglePlayersTab
		-- upvalues: (copy) v_u_364
		if p366 == Enum.UserInputState.Begin then
			v_u_364.PlayersTab.Visible = true
			v_u_364.PlayersTab.ProfileFrame.Visible = false
		else
			v_u_364.PlayersTab.Visible = false
		end
	end, false, Enum.KeyCode.Tab, Enum.KeyCode.DPadRight)
	local v_u_367 = {}
	local function v_u_373(p368) -- name: DisconnectPlayerBorder
		-- upvalues: (copy) v_u_367
		if typeof(p368) == "Instance" then
			local v369 = p368.UserId
			v372 = tostring(v369)
			if v372 then
				::l3::
				local v370 = v_u_367[v372]
				if v370 then
					for _, v371 in pairs(v370) do
						if typeof(v371) == "RBXScriptConnection" then
							v371:Disconnect()
						end
					end
					v_u_367[v372] = nil
				end
			end
		end
		local v372 = tostring(p368)
		goto l3
	end
	local function v_u_376(p374, p375) -- name: RefreshPlayerAlive
		if p374 then
			if p374:FindFirstChild("ServerData") then
				if p375 and p375.Parent then
					if p374.ServerData:GetAttribute("Alive") == true then
						p375.PlayerImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
						p375.Cross.Visible = false
					else
						p375.PlayerImage.ImageColor3 = Color3.fromRGB(100, 100, 100)
						p375.Cross.Visible = true
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_383(p377, p378) -- name: RefreshPlayerHealth
		-- upvalues: (copy) v_u_363
		if p377 then
			if p378 and p378.Parent then
				local v379
				if p377 and (v_u_363.Team and p377.Team) then
					v379 = p377.Team == v_u_363.Team
				else
					v379 = false
				end
				if p378:FindFirstChild("Health") then
					p378.Health.Visible = v379
				end
				if v379 == true then
					local v380 = p377.Character
					if v380 then
						v380 = v380:FindFirstChildOfClass("Humanoid")
					end
					if v380 and v380.MaxHealth > 0 then
						local v381 = v380.Health / v380.MaxHealth
						local v382 = math.clamp(v381, 0, 1)
						p378.Health.Bar.Size = UDim2.new(v382, 0, 1, 0)
					else
						p378.Health.Bar.Size = UDim2.new(0, 0, 1, 0)
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_396(p_u_384, p_u_385) -- name: SetupPlayerConnections
		-- upvalues: (copy) v_u_373, (copy) v_u_367, (copy) v_u_383, (copy) v_u_376
		if p_u_384 then
			if p_u_385 then
				v_u_373(p_u_384)
				local v386 = p_u_384.UserId
				local v387 = tostring(v386)
				v_u_367[v387] = {}
				local v_u_388 = v_u_367[v387]
				local function v_u_393(p389) -- name: SetCharacterConnection
					-- upvalues: (copy) v_u_388, (copy) p_u_384, (ref) v_u_383, (copy) p_u_385, (ref) v_u_376
					if v_u_388.Health then
						v_u_388.Health:Disconnect()
						v_u_388.Health = nil
					end
					if v_u_388.MaxHealth then
						v_u_388.MaxHealth:Disconnect()
						v_u_388.MaxHealth = nil
					end
					local v390 = p389 or p_u_384.Character
					if v390 then
						local v391 = v390:FindFirstChildOfClass("Humanoid")
						if not v391 then
							local v392 = os.clock()
							while true do
								v391 = v390:FindFirstChildOfClass("Humanoid")
								if v391 then
									break
								end
								task.wait()
								if os.clock() - v392 >= 5 then
									break
								end
							end
						end
						if v391 then
							v_u_388.Health = v391.HealthChanged:Connect(function()
								-- upvalues: (ref) v_u_383, (ref) p_u_384, (ref) p_u_385
								v_u_383(p_u_384, p_u_385)
							end)
							v_u_388.MaxHealth = v391:GetPropertyChangedSignal("MaxHealth"):Connect(function()
								-- upvalues: (ref) v_u_383, (ref) p_u_384, (ref) p_u_385
								v_u_383(p_u_384, p_u_385)
							end)
							v_u_388.Died = v391.Died:Connect(function()
								-- upvalues: (ref) v_u_383, (ref) p_u_384, (ref) p_u_385, (ref) v_u_376
								v_u_383(p_u_384, p_u_385)
								v_u_376(p_u_384, p_u_385)
							end)
						end
						v_u_383(p_u_384, p_u_385)
						v_u_376(p_u_384, p_u_385)
					else
						v_u_383(p_u_384, p_u_385)
						v_u_376(p_u_384, p_u_385)
					end
				end
				if p_u_384:FindFirstChild("ServerData") then
					v_u_388.Alive = p_u_384.ServerData:GetAttributeChangedSignal("Alive"):Connect(function()
						-- upvalues: (ref) v_u_376, (copy) p_u_384, (copy) p_u_385
						v_u_376(p_u_384, p_u_385)
					end)
					v_u_388.ProfilePicture = p_u_384.ServerData:GetAttributeChangedSignal("ProfilePicture"):Connect(function()
						-- upvalues: (copy) p_u_385, (copy) p_u_384
						if p_u_385 and p_u_385.Parent then
							p_u_385.PlayerImage.Image = p_u_384.ServerData:GetAttribute("ProfilePicture") or "rbxassetid://7992557358"
						end
					end)
				else
					v_u_388.ServerDataAdded = p_u_384.ChildAdded:Connect(function(p_u_394)
						-- upvalues: (copy) v_u_388, (ref) v_u_376, (copy) p_u_384, (copy) p_u_385
						if p_u_394.Name == "ServerData" then
							if v_u_388.Alive then
								v_u_388.Alive:Disconnect()
							end
							if v_u_388.ProfilePicture then
								v_u_388.ProfilePicture:Disconnect()
							end
							v_u_388.Alive = p_u_394:GetAttributeChangedSignal("Alive"):Connect(function()
								-- upvalues: (ref) v_u_376, (ref) p_u_384, (ref) p_u_385
								v_u_376(p_u_384, p_u_385)
							end)
							v_u_388.ProfilePicture = p_u_394:GetAttributeChangedSignal("ProfilePicture"):Connect(function()
								-- upvalues: (ref) p_u_385, (copy) p_u_394
								if p_u_385 and p_u_385.Parent then
									p_u_385.PlayerImage.Image = p_u_394:GetAttribute("ProfilePicture") or "rbxassetid://7992557358"
								end
							end)
							v_u_376(p_u_384, p_u_385)
						end
					end)
				end
				v_u_388.CharacterAdded = p_u_384.CharacterAdded:Connect(function(p_u_395)
					-- upvalues: (copy) v_u_393
					task.spawn(function()
						-- upvalues: (ref) v_u_393, (copy) p_u_395
						v_u_393(p_u_395)
					end)
				end)
				v_u_388.TeamChanged = p_u_384:GetPropertyChangedSignal("Team"):Connect(function()
					-- upvalues: (ref) v_u_383, (copy) p_u_384, (copy) p_u_385, (ref) v_u_376
					v_u_383(p_u_384, p_u_385)
					v_u_376(p_u_384, p_u_385)
				end)
				task.spawn(function()
					-- upvalues: (copy) v_u_393, (copy) p_u_384
					v_u_393(p_u_384.Character)
				end)
			end
		else
			return
		end
	end
	local function v_u_406(p397) -- name: RefreshTeamBorder
		-- upvalues: (copy) v_u_365, (ref) v_u_39, (ref) v_u_10, (copy) v_u_363, (copy) v_u_367, (copy) v_u_396, (copy) v_u_383, (copy) v_u_376, (copy) v_u_373
		local v398 = v_u_365:WaitForChild(p397)
		local v399 = v_u_39:GetAttribute(p397 .. "Wins")
		local v400 = v_u_39:GetAttribute(p397 .. "Color")
		v398.Round.Amount.Text = v399 or 0
		if v400 then
			v398.Round.BackgroundColor3 = v400
		end
		if v_u_39:GetAttribute("Attacker") == p397 then
			v398.Round.Objective.Image = "rbxassetid://14890410835"
		else
			v398.Round.Objective.Image = "rbxassetid://14890410668"
		end
		for _, v401 in pairs(v_u_10:GetPlayers()) do
			if v401:FindFirstChild("ServerData") and (v401:FindFirstChild("PlayerData") and (v401.Team and v401.Team.Name == p397)) then
				local v402 = v398.Players:FindFirstChild(v401.Name)
				if v402 == nil then
					v402 = script.SampleTopBorderPlayer:Clone()
					v402.Name = v401.Name
					v402.Parent = v398.Players
				end
				if v401 == v_u_363 then
					v402.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				else
					v402.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				end
				local v403 = v401.UserId
				if not v_u_367[tostring(v403)] then
					v_u_396(v401, v402)
				end
				v402.PlayerImage.Image = v401.ServerData:GetAttribute("ProfilePicture") or "rbxassetid://7992557358"
				v_u_383(v401, v402)
				v_u_376(v401, v402)
			end
		end
		for _, v404 in pairs(v398.Players:GetChildren()) do
			if v404:IsA("ImageLabel") then
				local v405 = v_u_10:FindFirstChild(v404.Name)
				if not v405 or (not v405.Team or v405.Team.Name ~= p397) then
					if v405 then
						v_u_373(v405)
					else
						v_u_373(v404.Name)
					end
					v404:Destroy()
				end
			end
		end
	end
	local function v_u_407() -- name: RefreshAllTeam
		-- upvalues: (copy) v_u_406
		v_u_406("Red")
		v_u_406("Blue")
	end
	local function v409() -- name: RefreshRounds
		-- upvalues: (ref) v_u_39, (copy) v_u_365
		local v408 = v_u_39:GetAttribute("Rounds")
		v_u_365.Middle.RoundDisplay.Text = "ROUND " .. tostring(v408 or 0)
	end
	local function v412() -- name: RefreshTimer
		-- upvalues: (ref) v_u_39, (copy) v_u_365, (ref) v_u_16
		local v410 = v_u_39:GetAttribute("Timer") or 0
		local v411 = v_u_39:GetAttribute("Phase")
		if v411 == "Round Ended" or v411 == "Show Round" then
			v_u_365.Middle.RoundTimer.Text = ""
			return
		else
			v_u_365.Middle.RoundTimer.Text = v_u_16.toMS(v410)
			if v410 <= 15 and v410 > 0 then
				v_u_365.Middle.RoundTimer.TextColor3 = Color3.fromRGB(255, 150, 150)
				if v411 == "Round Started" then
					v_u_16.AddSound("Round_Timer", nil, false, nil, false)
				else
					v_u_16.AddSound("Clock_Tick2", nil, false, nil, false)
				end
			else
				v_u_365.Middle.RoundTimer.TextColor3 = Color3.fromRGB(255, 255, 255)
				return
			end
		end
	end
	v_u_39:GetAttributeChangedSignal("Timer"):Connect(v412)
	v_u_39:GetAttributeChangedSignal("Phase"):Connect(v412)
	v_u_39:GetAttributeChangedSignal("Rounds"):Connect(v409)
	v_u_39:GetAttributeChangedSignal("Phase"):Connect(v_u_407)
	v_u_39:GetAttributeChangedSignal("Attacker"):Connect(v_u_407)
	v_u_39:GetAttributeChangedSignal("RedWins"):Connect(v_u_407)
	v_u_39:GetAttributeChangedSignal("BlueWins"):Connect(v_u_407)
	v_u_39:GetAttributeChangedSignal("RedColor"):Connect(v_u_407)
	v_u_39:GetAttributeChangedSignal("BlueColor"):Connect(v_u_407)
	v_u_363:GetPropertyChangedSignal("Team"):Connect(v_u_407)
	v_u_10.PlayerAdded:Connect(function()
		-- upvalues: (copy) v_u_407
		task.defer(v_u_407)
	end)
	v_u_10.PlayerRemoving:Connect(function(p413)
		-- upvalues: (copy) v_u_373, (copy) v_u_407
		v_u_373(p413)
		task.defer(v_u_407)
	end)
	local v414 = v_u_39:GetAttribute("Rounds")
	v_u_365.Middle.RoundDisplay.Text = "ROUND " .. tostring(v414 or 0)
	v412()
	v_u_406("Red")
	v_u_406("Blue")
	v_u_16.ConfigTopInset(v_u_365)
end
local v_u_415 = {}
local function v_u_421(p416) -- name: DisconnectPlayersTabRow
	-- upvalues: (copy) v_u_415
	local v417
	if typeof(p416) == "Instance" and p416:IsA("Player") then
		local v418 = p416.UserId
		v417 = tostring(v418)
	else
		v417 = tostring(p416)
	end
	local v419 = v_u_415[v417]
	if v419 then
		for _, v420 in pairs(v419.Connections or {}) do
			if typeof(v420) == "RBXScriptConnection" then
				v420:Disconnect()
			end
		end
		v_u_415[v417] = nil
	end
end
local function v_u_433(p422) -- name: GetReplayActorTimelines
	local v423 = {}
	local v424
	if p422 then
		v424 = p422.VictimUserId
	else
		v424 = p422
	end
	local v425 = tonumber(v424) or 0
	local v426
	if p422 then
		v426 = p422.VictimTimeline
	else
		v426 = p422
	end
	if v425 <= 0 or typeof(v426) ~= "table" then
		v426 = nil
	else
		local v427 = v426.UserId
		if tonumber(v427) == v425 then
			local v428 = v426.Samples
			if typeof(v428) ~= "table" or #v426.Samples <= 0 then
				v426 = nil
			end
		else
			v426 = nil
		end
	end
	local v429
	if p422 then
		v429 = p422.VictimUserId
	else
		v429 = p422
	end
	local v430 = tonumber(v429) or 0
	if v426 then
		table.insert(v423, v426)
	end
	for _, v431 in ipairs(p422 and p422.NearbyActors or {}) do
		if typeof(v431) == "table" then
			if v426 then
				local v432 = v431.UserId
				if tonumber(v432) ~= v430 then
					goto l25
				end
			else
				::l25::
				table.insert(v423, v431)
			end
		end
	end
	return v423
end
function v_u_43.ConfigPlayersTab() -- name: ConfigPlayersTab
	-- upvalues: (copy) v_u_10, (copy) v_u_43, (copy) v_u_4, (copy) v_u_39
	local v_u_434 = v_u_10.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameHUD"):WaitForChild("PlayersTab")
	v_u_434:GetPropertyChangedSignal("Visible"):Connect(function()
		-- upvalues: (ref) v_u_43
		v_u_43.RefreshPlayersTab()
	end)
	v_u_10.PlayerAdded:Connect(function()
		-- upvalues: (ref) v_u_43
		v_u_43.RefreshPlayersTab()
	end)
	v_u_10.PlayerRemoving:Connect(function()
		-- upvalues: (ref) v_u_43
		task.defer(function()
			-- upvalues: (ref) v_u_43
			v_u_43.RefreshPlayersTab()
		end)
	end)
	v_u_434.ProfileFrame.Scroller.Cancel.Activated:Connect(function()
		-- upvalues: (copy) v_u_434
		v_u_434.ProfileFrame.Visible = false
	end)
	v_u_434.ProfileFrame.Scroller.Commend.Activated:Connect(function()
		-- upvalues: (ref) v_u_4, (copy) v_u_434
		v_u_4.GameEvents.PlayerOption:FireServer("Commend", v_u_434.ProfileFrame:GetAttribute("Player"))
		v_u_434.ProfileFrame.Visible = false
	end)
	v_u_434.ProfileFrame.Scroller.Kick.Activated:Connect(function()
		-- upvalues: (ref) v_u_4, (copy) v_u_434
		v_u_4.GameEvents.VoteKick:FireServer("Request", v_u_434.ProfileFrame:GetAttribute("Player"))
		v_u_434.ProfileFrame.Visible = false
	end)
	task.spawn(function()
		-- upvalues: (ref) v_u_4
		while task.wait(4) do
			local v435 = time()
			if pcall(function()
				-- upvalues: (ref) v_u_4
				v_u_4.GameEvents.CheckPing:InvokeServer()
			end) then
				local v436 = (time() - v435) * 1000
				local v437 = math.max(0, v436) * 0.5 + 0.5
				local v438 = math.floor(v437)
				local v439 = math.clamp(v438, 0, 999)
				v_u_4.GameEvents.Latency:FireServer(v439)
			end
		end
	end)
	local function v440() -- name: RefreshAdditional
		-- upvalues: (copy) v_u_434, (ref) v_u_39
		v_u_434.MapName.Text = v_u_39:GetAttribute("Map")
		v_u_434.Server.Text = v_u_39:GetAttribute("Region")
	end
	v_u_434.Server.Text = v_u_39:GetAttribute("Region")
	v_u_39:GetAttributeChangedSignal("Map"):Connect(v440)
	v_u_39:GetAttributeChangedSignal("Region"):Connect(v440)
end
function v_u_43.RefreshPlayersTab() -- name: RefreshPlayersTab
	-- upvalues: (copy) v_u_43
	v_u_43.RefreshPlayersTabTeam("Blue")
	v_u_43.RefreshPlayersTabTeam("Red")
end
function v_u_43.RefreshPlayersTabTeam(p441) -- name: RefreshPlayersTabTeam
	-- upvalues: (copy) v_u_10, (copy) v_u_39, (copy) v_u_421, (copy) v_u_18, (copy) v_u_415, (copy) v_u_43
	local v_u_442 = p441 or "Blue"
	local v_u_443 = v_u_10.LocalPlayer
	local v_u_444 = v_u_443:WaitForChild("PlayerGui"):WaitForChild("GameHUD"):WaitForChild("PlayersTab")
	local v445 = v_u_39:GetAttribute(v_u_442 .. "Wins") or 0
	local v446 = v_u_39:GetAttribute(v_u_442 .. "Color") or Color3.fromRGB(60, 60, 60)
	local v447 = v_u_39:GetAttribute(v_u_442 .. "Tag") or v_u_442
	v_u_444[v_u_442 .. "Score"].Round.Text = v445
	v_u_444[v_u_442 .. "Score"].BackgroundColor3 = v446
	v_u_444[v_u_442 .. "Score"].Title.Text = v447
	if v_u_39:GetAttribute("Attacker") == v_u_442 then
		v_u_444[v_u_442 .. "Score"].Objective.Image = "rbxassetid://14890410835"
	else
		v_u_444[v_u_442 .. "Score"].Objective.Image = "rbxassetid://14890410668"
	end
	local v448 = v_u_10:GetPlayers()
	table.sort(v448, function(p449, p450)
		local v451 = p449:FindFirstChild("ServerData") and (p449.ServerData:GetAttribute("Points") or 0) or -1
		local v452 = p450:FindFirstChild("ServerData") and (p450.ServerData:GetAttribute("Points") or 0) or -1
		if v451 == v452 then
			return p449.UserId < p450.UserId
		else
			return v452 < v451
		end
	end)
	local function v_u_456(p453) -- name: IsValidPlayersTabEntry
		if typeof(p453) ~= "Instance" or not p453:IsA("Frame") then
			return false
		end
		local v454 = p453:FindFirstChild("Scroller")
		local v455 = p453:FindFirstChild("PlayerImage") and p453.PlayerImage:IsA("ImageLabel") and (p453:FindFirstChild("PlayerHighlight") and p453.PlayerHighlight:IsA("GuiObject")) and (p453:FindFirstChild("Died") and p453.Died:IsA("GuiObject") and (p453:FindFirstChild("Points") and p453.Points:IsA("TextLabel")) and (p453:FindFirstChild("Kills") and p453.Kills:IsA("TextLabel") and (p453:FindFirstChild("Deaths") and p453.Deaths:IsA("TextLabel")))) and (p453:FindFirstChild("Level") and p453.Level:IsA("TextLabel") and (p453:FindFirstChild("Ping") and p453.Ping:IsA("TextLabel")) and (p453:FindFirstChild("DeviceIcon") and p453.DeviceIcon:IsA("ImageLabel") and (p453:FindFirstChild("Option") and p453.Option:IsA("GuiButton"))) and (v454 and (v454:IsA("ScrollingFrame") and v454:FindFirstChild("PlayerName") and (v454.PlayerName:IsA("TextLabel") and v454:FindFirstChild("GangIcon")) and (v454.GangIcon:IsA("ImageLabel") and v454:FindFirstChild("GangName") and (v454.GangName:IsA("TextLabel") and v454:FindFirstChild("Rank"))))))
		if v455 then
			v455 = v454.Rank:IsA("ImageLabel")
		end
		return v455
	end
	local function v461(p457, p458) -- name: GetOrCreatePlayersTabEntry
		-- upvalues: (copy) v_u_456, (ref) v_u_421
		local v459 = p457:FindFirstChild(p458.Name)
		local v460 = false
		if v459 and v_u_456(v459) ~= true then
			v_u_421(p458)
			v459:Destroy()
			v459 = nil
		end
		if not v459 then
			v459 = script.SamplePlayerTab:Clone()
			v459.Name = p458.Name
			v459.Parent = p457
			v460 = true
		end
		v459:SetAttribute("PlayerUserId", p458.UserId)
		return v459, v460
	end
	local function v_u_465(p462, p463) -- name: RefreshDeviceIcon
		-- upvalues: (copy) v_u_456
		if v_u_456(p462) == true then
			if p463 then
				p463 = p463:FindFirstChild("ServerData")
			end
			if p463 then
				local v464 = p463:GetAttribute("Device")
				p462.DeviceIcon.Visible = (v464 == "Mobile" or v464 == "Console") and true or v464 == "Computer"
				if v464 == "Mobile" then
					p462.DeviceIcon.Image = "rbxassetid://14972030879"
					return
				elseif v464 == "Console" then
					p462.DeviceIcon.Image = "rbxassetid://14972031004"
					return
				elseif v464 == "Computer" then
					p462.DeviceIcon.Image = "rbxassetid://14972031099"
				else
					p462.DeviceIcon.Image = ""
				end
			else
				p462.DeviceIcon.Visible = false
				p462.DeviceIcon.Image = ""
				return
			end
		else
			return
		end
	end
	local function v_u_470(p466, p467) -- name: RefreshPingDisplay
		-- upvalues: (copy) v_u_456
		if v_u_456(p466) == true then
			if p467 then
				p467 = p467:FindFirstChild("ServerData")
			end
			if p467 then
				local v468 = p467:GetAttribute("Ping") or 0
				local v469 = math.clamp(v468, 0, 999)
				p466.Ping.Text = tostring(v469)
				if v469 <= 5 then
					p466.Ping.TextColor3 = Color3.fromRGB(70, 210, 65)
					return
				elseif v469 <= 50 then
					p466.Ping.TextColor3 = Color3.fromRGB(180, 210, 105)
					return
				elseif v469 <= 150 then
					p466.Ping.TextColor3 = Color3.fromRGB(210, 155, 90)
					return
				elseif v469 <= 500 then
					p466.Ping.TextColor3 = Color3.fromRGB(210, 100, 65)
				else
					p466.Ping.TextColor3 = Color3.fromRGB(140, 40, 40)
				end
			else
				p466.Ping.Text = "--"
				p466.Ping.TextColor3 = Color3.fromRGB(180, 180, 180)
				return
			end
		else
			return
		end
	end
	local function v_u_487(p471, p472, p473) -- name: ApplyPlayersTabEntry
		-- upvalues: (copy) v_u_456, (copy) v_u_443, (ref) v_u_39, (ref) v_u_18, (copy) v_u_465, (copy) v_u_470
		if v_u_456(p472) ~= true then
			return false
		end
		local v474 = p471:FindFirstChild("ServerData")
		local v475 = p471:FindFirstChild("PlayerData")
		local v476
		if v475 then
			v476 = v475:FindFirstChild("Stats")
		else
			v476 = v475
		end
		if v475 then
			v475 = v475:FindFirstChild("Gang")
		end
		local v477 = p471.Team
		p472:SetAttribute("PlayerUserId", p471.UserId)
		p472.LayoutOrder = p473 or 0
		p472.PlayerHighlight.Visible = p471 == v_u_443
		p472.Scroller.PlayerName.Text = p471.DisplayName
		p472.PlayerImage.Image = v474 and (v474:GetAttribute("ProfilePicture") or "rbxassetid://7992557358") or "rbxassetid://7992557358"
		p472.Died.Visible = v474 and v474:GetAttribute("Alive") == false and true or false
		local v478 = p472.Points
		local v479 = v474 and (v474:GetAttribute("Points") or 0) or 0
		v478.Text = tostring(v479)
		local v480 = p472.Kills
		local v481 = v474 and (v474:GetAttribute("Kills") or 0) or 0
		v480.Text = tostring(v481)
		local v482 = p472.Deaths
		local v483 = v474 and (v474:GetAttribute("Deaths") or 0) or 0
		v482.Text = tostring(v483)
		local v484 = p472.Level
		local v485 = v476 and (v476:GetAttribute("Level") or 0) or 0
		v484.Text = tostring(v485)
		if v475 and (v475:GetAttribute("Tag") ~= "" and v475:GetAttribute("Name") ~= "") then
			p472.Scroller.GangIcon.Image = v475:GetAttribute("Icon")
			p472.Scroller.GangIcon.Visible = true
			p472.Scroller.GangName.Text = v475:GetAttribute("Tag")
			p472.Scroller.GangName.TextColor3 = Color3.fromRGB(v475:GetAttribute("ColorR"), v475:GetAttribute("ColorG"), v475:GetAttribute("ColorB"))
			p472.Scroller.GangName.Visible = true
		else
			p472.Scroller.GangIcon.Visible = false
			p472.Scroller.GangName.Visible = false
		end
		if v477 and (v477.Name == "Blue" or v477.Name == "Red") then
			p472.BackgroundColor3 = v_u_39:GetAttribute(v477.Name .. "Color")
		end
		if v_u_39:GetAttribute("GameMode") == "Ranked" and v476 then
			local v486 = v_u_18.Rank.GetRankedImage(v476:GetAttribute("RankedRating"))
			if v486 then
				p472.Scroller.Rank.Image = "rbxassetid://" .. v486
				p472.Scroller.Rank.Visible = true
			else
				p472.Scroller.Rank.Visible = false
			end
		else
			p472.Scroller.Rank.Visible = false
		end
		v_u_465(p472, p471)
		v_u_470(p472, p471)
		return true
	end
	local function v549(p_u_488, p_u_489) -- name: EnsurePlayersTabRowConnections
		-- upvalues: (ref) v_u_415, (ref) v_u_421, (ref) v_u_10, (ref) v_u_442, (ref) v_u_43, (copy) v_u_487, (ref) v_u_18, (copy) v_u_444
		local v_u_490
		if typeof(p_u_488) == "Instance" and p_u_488:IsA("Player") then
			local v491 = p_u_488.UserId
			v_u_490 = tostring(v491)
		else
			v_u_490 = tostring(p_u_488)
		end
		local v492 = v_u_415[v_u_490]
		if v492 and v492.Row == p_u_489 then
			return v492
		end
		v_u_421(v_u_490)
		local v_u_493 = {
			["Row"] = p_u_489,
			["Connections"] = {}
		}
		v_u_415[v_u_490] = v_u_493
		local function v_u_494() -- name: SafeApplyPlayersTabEntry
			-- upvalues: (ref) v_u_415, (copy) v_u_490, (copy) v_u_493, (copy) p_u_489, (ref) v_u_421, (copy) p_u_488, (ref) v_u_10, (ref) v_u_442, (ref) v_u_43, (ref) v_u_487
			if v_u_415[v_u_490] == v_u_493 then
				if p_u_489.Parent == nil then
					v_u_421(v_u_490)
					return
				elseif p_u_488.Parent == v_u_10 then
					if p_u_488.Team and p_u_488.Team.Name == v_u_442 then
						v_u_487(p_u_488, p_u_489, p_u_489.LayoutOrder)
					else
						task.defer(v_u_43.RefreshPlayersTab)
					end
				else
					v_u_421(v_u_490)
					return
				end
			else
				return
			end
		end
		local function v_u_503(p495) -- name: BindServerDataConnections
			-- upvalues: (copy) v_u_493, (copy) v_u_494
			local v496 = v_u_493.Connections.Alive
			if typeof(v496) == "RBXScriptConnection" then
				v496:Disconnect()
			end
			v_u_493.Connections.Alive = nil
			local v497 = v_u_493.Connections.Ping
			if typeof(v497) == "RBXScriptConnection" then
				v497:Disconnect()
			end
			v_u_493.Connections.Ping = nil
			local v498 = v_u_493.Connections.Device
			if typeof(v498) == "RBXScriptConnection" then
				v498:Disconnect()
			end
			v_u_493.Connections.Device = nil
			local v499 = v_u_493.Connections.ProfilePicture
			if typeof(v499) == "RBXScriptConnection" then
				v499:Disconnect()
			end
			v_u_493.Connections.ProfilePicture = nil
			local v500 = v_u_493.Connections.Points
			if typeof(v500) == "RBXScriptConnection" then
				v500:Disconnect()
			end
			v_u_493.Connections.Points = nil
			local v501 = v_u_493.Connections.Kills
			if typeof(v501) == "RBXScriptConnection" then
				v501:Disconnect()
			end
			v_u_493.Connections.Kills = nil
			local v502 = v_u_493.Connections.Deaths
			if typeof(v502) == "RBXScriptConnection" then
				v502:Disconnect()
			end
			v_u_493.Connections.Deaths = nil
			if p495 then
				v_u_493.Connections.Alive = p495:GetAttributeChangedSignal("Alive"):Connect(v_u_494)
				v_u_493.Connections.Ping = p495:GetAttributeChangedSignal("Ping"):Connect(v_u_494)
				v_u_493.Connections.Device = p495:GetAttributeChangedSignal("Device"):Connect(v_u_494)
				v_u_493.Connections.ProfilePicture = p495:GetAttributeChangedSignal("ProfilePicture"):Connect(v_u_494)
				v_u_493.Connections.Points = p495:GetAttributeChangedSignal("Points"):Connect(v_u_494)
				v_u_493.Connections.Kills = p495:GetAttributeChangedSignal("Kills"):Connect(v_u_494)
				v_u_493.Connections.Deaths = p495:GetAttributeChangedSignal("Deaths"):Connect(v_u_494)
			end
		end
		local function v_u_511(p504) -- name: BindGangConnections
			-- upvalues: (copy) v_u_493, (copy) v_u_494
			local v505 = v_u_493.Connections.GangTag
			if typeof(v505) == "RBXScriptConnection" then
				v505:Disconnect()
			end
			v_u_493.Connections.GangTag = nil
			local v506 = v_u_493.Connections.GangName
			if typeof(v506) == "RBXScriptConnection" then
				v506:Disconnect()
			end
			v_u_493.Connections.GangName = nil
			local v507 = v_u_493.Connections.GangIcon
			if typeof(v507) == "RBXScriptConnection" then
				v507:Disconnect()
			end
			v_u_493.Connections.GangIcon = nil
			local v508 = v_u_493.Connections.GangColorR
			if typeof(v508) == "RBXScriptConnection" then
				v508:Disconnect()
			end
			v_u_493.Connections.GangColorR = nil
			local v509 = v_u_493.Connections.GangColorG
			if typeof(v509) == "RBXScriptConnection" then
				v509:Disconnect()
			end
			v_u_493.Connections.GangColorG = nil
			local v510 = v_u_493.Connections.GangColorB
			if typeof(v510) == "RBXScriptConnection" then
				v510:Disconnect()
			end
			v_u_493.Connections.GangColorB = nil
			if p504 then
				v_u_493.Connections.GangTag = p504:GetAttributeChangedSignal("Tag"):Connect(v_u_494)
				v_u_493.Connections.GangName = p504:GetAttributeChangedSignal("Name"):Connect(v_u_494)
				v_u_493.Connections.GangIcon = p504:GetAttributeChangedSignal("Icon"):Connect(v_u_494)
				v_u_493.Connections.GangColorR = p504:GetAttributeChangedSignal("ColorR"):Connect(v_u_494)
				v_u_493.Connections.GangColorG = p504:GetAttributeChangedSignal("ColorG"):Connect(v_u_494)
				v_u_493.Connections.GangColorB = p504:GetAttributeChangedSignal("ColorB"):Connect(v_u_494)
			end
		end
		local function v_u_515(p512) -- name: BindStatsConnections
			-- upvalues: (copy) v_u_493, (copy) v_u_494
			local v513 = v_u_493.Connections.Level
			if typeof(v513) == "RBXScriptConnection" then
				v513:Disconnect()
			end
			v_u_493.Connections.Level = nil
			local v514 = v_u_493.Connections.RankedRating
			if typeof(v514) == "RBXScriptConnection" then
				v514:Disconnect()
			end
			v_u_493.Connections.RankedRating = nil
			if p512 then
				v_u_493.Connections.Level = p512:GetAttributeChangedSignal("Level"):Connect(v_u_494)
				v_u_493.Connections.RankedRating = p512:GetAttributeChangedSignal("RankedRating"):Connect(v_u_494)
			end
		end
		local function v_u_529(p516) -- name: BindPlayerDataConnections
			-- upvalues: (copy) v_u_493, (ref) v_u_415, (copy) v_u_490, (copy) v_u_529, (copy) p_u_488, (copy) v_u_494, (copy) v_u_515, (copy) v_u_511
			local v517 = v_u_493.Connections.PlayerDataChildAdded
			if typeof(v517) == "RBXScriptConnection" then
				v517:Disconnect()
			end
			v_u_493.Connections.PlayerDataChildAdded = nil
			local v518 = v_u_493.Connections.PlayerDataChildRemoved
			if typeof(v518) == "RBXScriptConnection" then
				v518:Disconnect()
			end
			v_u_493.Connections.PlayerDataChildRemoved = nil
			local v519 = v_u_493.Connections.Level
			if typeof(v519) == "RBXScriptConnection" then
				v519:Disconnect()
			end
			v_u_493.Connections.Level = nil
			local v520 = v_u_493.Connections.RankedRating
			if typeof(v520) == "RBXScriptConnection" then
				v520:Disconnect()
			end
			v_u_493.Connections.RankedRating = nil
			local v521 = v_u_493.Connections.GangTag
			if typeof(v521) == "RBXScriptConnection" then
				v521:Disconnect()
			end
			v_u_493.Connections.GangTag = nil
			local v522 = v_u_493.Connections.GangName
			if typeof(v522) == "RBXScriptConnection" then
				v522:Disconnect()
			end
			v_u_493.Connections.GangName = nil
			local v523 = v_u_493.Connections.GangIcon
			if typeof(v523) == "RBXScriptConnection" then
				v523:Disconnect()
			end
			v_u_493.Connections.GangIcon = nil
			local v524 = v_u_493.Connections.GangColorR
			if typeof(v524) == "RBXScriptConnection" then
				v524:Disconnect()
			end
			v_u_493.Connections.GangColorR = nil
			local v525 = v_u_493.Connections.GangColorG
			if typeof(v525) == "RBXScriptConnection" then
				v525:Disconnect()
			end
			v_u_493.Connections.GangColorG = nil
			local v526 = v_u_493.Connections.GangColorB
			if typeof(v526) == "RBXScriptConnection" then
				v526:Disconnect()
			end
			v_u_493.Connections.GangColorB = nil
			if p516 then
				v_u_493.Connections.PlayerDataChildAdded = p516.ChildAdded:Connect(function(p527)
					-- upvalues: (ref) v_u_415, (ref) v_u_490, (ref) v_u_493, (ref) v_u_529, (ref) p_u_488, (ref) v_u_494
					if p527.Name == "Stats" or p527.Name == "Gang" then
						task.defer(function()
							-- upvalues: (ref) v_u_415, (ref) v_u_490, (ref) v_u_493, (ref) v_u_529, (ref) p_u_488, (ref) v_u_494
							if v_u_415[v_u_490] == v_u_493 then
								v_u_529(p_u_488:FindFirstChild("PlayerData"))
								v_u_494()
							end
						end)
					end
				end)
				v_u_493.Connections.PlayerDataChildRemoved = p516.ChildRemoved:Connect(function(p528)
					-- upvalues: (ref) v_u_415, (ref) v_u_490, (ref) v_u_493, (ref) v_u_529, (ref) p_u_488, (ref) v_u_494
					if p528.Name == "Stats" or p528.Name == "Gang" then
						task.defer(function()
							-- upvalues: (ref) v_u_415, (ref) v_u_490, (ref) v_u_493, (ref) v_u_529, (ref) p_u_488, (ref) v_u_494
							if v_u_415[v_u_490] == v_u_493 then
								v_u_529(p_u_488:FindFirstChild("PlayerData"))
								v_u_494()
							end
						end)
					end
				end)
				v_u_515(p516:FindFirstChild("Stats"))
				v_u_511(p516:FindFirstChild("Gang"))
			end
		end
		v_u_493.Connections.OptionActivated = p_u_489.Option.Activated:Connect(function()
			-- upvalues: (ref) v_u_18, (copy) p_u_488, (ref) v_u_444, (ref) v_u_10
			v_u_18.Menu.RefreshProfileFrame(p_u_488, v_u_444.ProfileFrame)
			v_u_444.ProfileFrame.Visible = true
			v_u_444.ProfileFrame:SetAttribute("Player", p_u_488.Name)
			if p_u_488.Team == v_u_10.LocalPlayer.Team then
				v_u_444.ProfileFrame.Scroller.Kick.Visible = true
			else
				v_u_444.ProfileFrame.Scroller.Kick.Visible = false
			end
		end)
		v_u_493.Connections.PlayerChildAdded = p_u_488.ChildAdded:Connect(function(p530)
			-- upvalues: (copy) v_u_503, (copy) v_u_494, (copy) v_u_529
			if p530.Name == "ServerData" then
				v_u_503(p530)
				v_u_494()
			elseif p530.Name == "PlayerData" then
				v_u_529(p530)
				v_u_494()
			end
		end)
		v_u_493.Connections.PlayerChildRemoved = p_u_488.ChildRemoved:Connect(function(p531)
			-- upvalues: (copy) v_u_493, (copy) v_u_494
			if p531.Name == "ServerData" then
				local v532 = v_u_493.Connections.Alive
				if typeof(v532) == "RBXScriptConnection" then
					v532:Disconnect()
				end
				v_u_493.Connections.Alive = nil
				local v533 = v_u_493.Connections.Ping
				if typeof(v533) == "RBXScriptConnection" then
					v533:Disconnect()
				end
				v_u_493.Connections.Ping = nil
				local v534 = v_u_493.Connections.Device
				if typeof(v534) == "RBXScriptConnection" then
					v534:Disconnect()
				end
				v_u_493.Connections.Device = nil
				local v535 = v_u_493.Connections.ProfilePicture
				if typeof(v535) == "RBXScriptConnection" then
					v535:Disconnect()
				end
				v_u_493.Connections.ProfilePicture = nil
				local v536 = v_u_493.Connections.Points
				if typeof(v536) == "RBXScriptConnection" then
					v536:Disconnect()
				end
				v_u_493.Connections.Points = nil
				local v537 = v_u_493.Connections.Kills
				if typeof(v537) == "RBXScriptConnection" then
					v537:Disconnect()
				end
				v_u_493.Connections.Kills = nil
				local v538 = v_u_493.Connections.Deaths
				if typeof(v538) == "RBXScriptConnection" then
					v538:Disconnect()
				end
				v_u_493.Connections.Deaths = nil
				v_u_494()
			elseif p531.Name == "PlayerData" then
				local v539 = v_u_493.Connections.PlayerDataChildAdded
				if typeof(v539) == "RBXScriptConnection" then
					v539:Disconnect()
				end
				v_u_493.Connections.PlayerDataChildAdded = nil
				local v540 = v_u_493.Connections.PlayerDataChildRemoved
				if typeof(v540) == "RBXScriptConnection" then
					v540:Disconnect()
				end
				v_u_493.Connections.PlayerDataChildRemoved = nil
				local v541 = v_u_493.Connections.Level
				if typeof(v541) == "RBXScriptConnection" then
					v541:Disconnect()
				end
				v_u_493.Connections.Level = nil
				local v542 = v_u_493.Connections.RankedRating
				if typeof(v542) == "RBXScriptConnection" then
					v542:Disconnect()
				end
				v_u_493.Connections.RankedRating = nil
				local v543 = v_u_493.Connections.GangTag
				if typeof(v543) == "RBXScriptConnection" then
					v543:Disconnect()
				end
				v_u_493.Connections.GangTag = nil
				local v544 = v_u_493.Connections.GangName
				if typeof(v544) == "RBXScriptConnection" then
					v544:Disconnect()
				end
				v_u_493.Connections.GangName = nil
				local v545 = v_u_493.Connections.GangIcon
				if typeof(v545) == "RBXScriptConnection" then
					v545:Disconnect()
				end
				v_u_493.Connections.GangIcon = nil
				local v546 = v_u_493.Connections.GangColorR
				if typeof(v546) == "RBXScriptConnection" then
					v546:Disconnect()
				end
				v_u_493.Connections.GangColorR = nil
				local v547 = v_u_493.Connections.GangColorG
				if typeof(v547) == "RBXScriptConnection" then
					v547:Disconnect()
				end
				v_u_493.Connections.GangColorG = nil
				local v548 = v_u_493.Connections.GangColorB
				if typeof(v548) == "RBXScriptConnection" then
					v548:Disconnect()
				end
				v_u_493.Connections.GangColorB = nil
				v_u_494()
			end
		end)
		v_u_493.Connections.TeamChanged = p_u_488:GetPropertyChangedSignal("Team"):Connect(function()
			-- upvalues: (ref) v_u_43
			task.defer(v_u_43.RefreshPlayersTab)
		end)
		v_u_493.Connections.CharacterAdded = p_u_488.CharacterAdded:Connect(function()
			-- upvalues: (copy) v_u_494
			task.defer(v_u_494)
		end)
		v_u_493.Connections.RowDestroying = p_u_489.Destroying:Connect(function()
			-- upvalues: (ref) v_u_421, (copy) v_u_490
			v_u_421(v_u_490)
		end)
		v_u_503(p_u_488:FindFirstChild("ServerData"))
		v_u_529(p_u_488:FindFirstChild("PlayerData"))
		return v_u_493
	end
	for v550, v551 in ipairs(v448) do
		if v551.Team and v551.Team.Name == v_u_442 then
			local v552 = v461(v_u_444[v_u_442], v551)
			if v_u_456(v552) == true then
				v549(v551, v552)
				v_u_487(v551, v552, v550)
			end
		end
	end
	for _, v553 in pairs(v_u_444[v_u_442]:GetChildren()) do
		if v553:IsA("Frame") then
			local v554 = v_u_10:FindFirstChild(v553.Name)
			if v_u_456(v553) ~= true or (not v554 or (not v554.Team or v554.Team.Name ~= v_u_442)) then
				v_u_421(v553:GetAttribute("PlayerUserId") or (v554 or v553.Name))
				v553:Destroy()
			end
		end
	end
end
function v_u_43.PlayPlayersLeft(p555) -- name: PlayPlayersLeft
	-- upvalues: (copy) v_u_10, (copy) v_u_16, (copy) v_u_6, (copy) v_u_43
	local v556 = p555 or "Blue"
	local v_u_557 = v_u_10.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameHUD"):WaitForChild("PlayersLeft")
	v_u_557.Visible = true
	v_u_557:SetAttribute("Overlap", v_u_557:GetAttribute("Overlap") + 1)
	task.delay(4, function()
		-- upvalues: (copy) v_u_557
		v_u_557:SetAttribute("Overlap", v_u_557:GetAttribute("Overlap") - 1)
		if v_u_557:GetAttribute("Overlap") <= 0 then
			v_u_557.Visible = false
		end
	end)
	v_u_16.AddSound("Round_PlayerLeft", 0.8, false, v_u_6, false)
	local v558, v559 = v_u_43.GetAlivePlayers()
	local v560 = v_u_557.Red.Amount
	if v556 == "Red" then
		v558 = v558 - 1 or v558
	end
	v560.Text = v558
	local v561 = v_u_557.Blue.Amount
	if v556 == "Blue" then
		v559 = v559 - 1 or v559
	end
	v561.Text = v559
	v_u_557.Size = UDim2.new(0.35, 0, 0.15, 0)
	v_u_16.TweenCreate(v_u_557, {
		["Size"] = UDim2.new(0.21, 0, 0.07, 0)
	}, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true)
end
function v_u_43.ConfigVoteKick() -- name: ConfigVoteKick
	-- upvalues: (copy) v_u_10, (copy) v_u_4, (copy) v_u_39, (copy) v_u_16, (copy) v_u_6
	local v_u_562 = v_u_10.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameHUD"):WaitForChild("VoteKick")
	v_u_562.Yes.Activated:Connect(function()
		-- upvalues: (ref) v_u_4
		v_u_4.GameEvents.VoteKick:FireServer("Vote", "Yes")
	end)
	v_u_562.No.Activated:Connect(function()
		-- upvalues: (ref) v_u_4
		v_u_4.GameEvents.VoteKick:FireServer("Vote", "No")
	end)
	v_u_39.VoteKick:GetAttributeChangedSignal("VoteKickTimer"):Connect(function()
		-- upvalues: (ref) v_u_39, (ref) v_u_16, (ref) v_u_6, (copy) v_u_562
		local v563 = v_u_39.VoteKick:GetAttribute("VoteKickTimer")
		if v563 == v_u_16.VoteKickTimer then
			v_u_16.AddSound("VoteKick_Prompt", 1, true, v_u_6, false)
		end
		if v563 <= 0 then
			v_u_562.Visible = false
			return
		else
			v_u_562.Visible = true
			v_u_562.Title.VoteBy.Text = "Voted by " .. v_u_39.VoteKick:GetAttribute("Request")
			v_u_562.Title.Timer.Text = v_u_39.VoteKick:GetAttribute("VoteKickTimer")
			if v_u_39.VoteKick:GetAttribute("Target") == "Rebalance" and v_u_39.VoteKick:GetAttribute("Reason") == "Rebalance" then
				v_u_562.PlayerName.Text = "Team rebalance"
			else
				local v564 = v_u_39.VoteKick:GetAttribute("TargetDisplayName") or v_u_39.VoteKick:GetAttribute("Target")
				v_u_562.PlayerName.Text = "Kick " .. v564
			end
			local v565 = v_u_39.VoteKick:GetAttribute("Yes")
			local v566 = v_u_39.VoteKick:GetAttribute("No")
			v_u_562.Yes.Amount.Text = v565
			v_u_562.No.Amount.Text = v566
			local v567 = v565 / (v565 + v566) * 1000
			local v568 = math.floor(v567) / 10
			v_u_562.Percentage.Text = v_u_16.RoundToNearest(v568, 1) .. "%"
			if v565 == 0 or v566 == 0 then
				v_u_562.Percentage.Text = "-"
			end
			if v568 >= 75 and v565 + v566 >= 5 then
				v_u_562.Percentage.TextColor3 = Color3.fromRGB(115, 255, 130)
			else
				v_u_562.Percentage.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
	end)
end
function v_u_43.ConfigTeamHighlight() -- name: ConfigTeamHighlight
	-- upvalues: (copy) v_u_10, (copy) v_u_16, (copy) v_u_39, (copy) v_u_4
	local v_u_569 = v_u_10.LocalPlayer
	local v_u_570 = workspace.CurrentCamera
	local v571 = v_u_16.CreateRandomSerialID()
	local v_u_572 = v571 .. "TeamIdentity"
	local v_u_573 = v571 .. "TeamHighlight"
	local v_u_574 = {
		["Highlight"] = true,
		["BillboardGui"] = true,
		["SurfaceGui"] = true,
		["SelectionBox"] = true,
		["BoxHandleAdornment"] = true
	}
	local function v_u_579(p575, p576) -- name: IsAllowedVisual
		-- upvalues: (ref) v_u_570, (copy) v_u_572, (copy) v_u_573, (copy) v_u_569
		local v577 = v_u_570
		if v577 then
			v577 = p575:IsDescendantOf(v_u_570)
		end
		if v577 then
			if p575:IsA("SurfaceGui") then
				p575.AlwaysOnTop = false
			end
			return true
		end
		if p575.Name == v_u_572 or p575.Name == v_u_573 then
			return true
		end
		local v578
		if p576 == v_u_569 then
			v578 = (p575:IsA("SurfaceGui") or (p575:IsA("BillboardGui") or p575:IsA("Highlight"))) and true or false
		else
			v578 = false
		end
		if not v578 then
			return false
		end
		if p575:IsA("SurfaceGui") then
			p575.AlwaysOnTop = false
		end
		return true
	end
	local function v_u_583(p580, p581) -- name: CleanCharacter
		-- upvalues: (copy) v_u_574, (copy) v_u_579
		if p580 then
			for _, v_u_582 in ipairs(p580:GetDescendants()) do
				if v_u_582 then
					if v_u_574[v_u_582.ClassName] then
						if not v_u_579(v_u_582, p581) then
							task.defer(function()
								-- upvalues: (copy) v_u_582
								if v_u_582 and v_u_582.Parent then
									pcall(function()
										-- upvalues: (ref) v_u_582
										v_u_582:Destroy()
									end)
								end
							end)
						end
					end
				end
			end
		end
	end
	local function v_u_600(p584) -- name: UpdateIdentity
		-- upvalues: (copy) v_u_569, (copy) v_u_572
		if p584 == v_u_569 then
			local v585
			if p584.Character then
				v585 = p584.Character:FindFirstChild("Head")
			else
				v585 = nil
			end
			if v585 then
				local v586 = v585:FindFirstChild(v_u_572)
				if v586 then
					v586:Destroy()
				end
			end
		else
			local v587 = p584:FindFirstChild("ServerData")
			local v588
			if v587 and v587:GetAttribute("Alive") ~= true then
				v588 = false
			else
				local v589 = p584.Character
				if v589 then
					local v590 = v589:FindFirstChildOfClass("Humanoid")
					v588 = (not v590 or v590.Health > 0) and true or false
				else
					v588 = false
				end
			end
			if v588 then
				local v591
				if v_u_569.Team == nil or p584.Team == nil then
					v591 = false
				else
					v591 = p584.Team == v_u_569.Team
				end
				if v591 then
					local v592
					if p584.Character then
						v592 = p584.Character:FindFirstChild("Head")
					else
						v592 = nil
					end
					local v593
					if v592 then
						v593 = v592:FindFirstChild(v_u_572)
						if not v593 then
							v593 = script.SampleTeamIdentity:Clone()
							v593.Name = v_u_572
							v593.Parent = v592
						end
					else
						v593 = nil
					end
					if v593 then
						local v594 = 1
						local v595 = p584:FindFirstChild("PlayerData")
						if v595 then
							v595 = v595:FindFirstChild("Stats")
						end
						if v595 then
							v594 = v595:GetAttribute("Level") or v594
						end
						v593.PlayerName.Text = p584.DisplayName .. "  [" .. v594 .. "]"
					end
				else
					local v596
					if p584.Character then
						v596 = p584.Character:FindFirstChild("Head")
					else
						v596 = nil
					end
					if v596 then
						local v597 = v596:FindFirstChild(v_u_572)
						if v597 then
							v597:Destroy()
						end
					end
				end
			else
				local v598
				if p584.Character then
					v598 = p584.Character:FindFirstChild("Head")
				else
					v598 = nil
				end
				if v598 then
					local v599 = v598:FindFirstChild(v_u_572)
					if v599 then
						v599:Destroy()
					end
				end
			end
		end
	end
	local function v_u_613(p601) -- name: ShouldShowDetectedHighlight
		-- upvalues: (ref) v_u_39, (copy) v_u_569
		if v_u_39:GetAttribute("Phase") ~= "Round Started" then
			return false
		end
		local v602 = p601:FindFirstChild("ServerData")
		local v603
		if v602 and v602:GetAttribute("Alive") ~= true then
			v603 = false
		else
			local v604 = p601.Character
			if v604 then
				local v605 = v604:FindFirstChildOfClass("Humanoid")
				v603 = (not v605 or v605.Health > 0) and true or false
			else
				v603 = false
			end
		end
		if not v603 then
			return false
		end
		local v606
		if p601.Team == nil then
			v606 = false
		else
			v606 = p601.Team.Name == v_u_39:GetAttribute("Defender")
		end
		if not v606 then
			return false
		end
		local v607
		if p601.Character then
			v607 = p601.Character:GetAttribute("Detected") == true
		else
			v607 = false
		end
		if not v607 then
			return false
		end
		local v608 = v_u_569
		local v609
		if v608.Team == nil then
			v609 = false
		else
			v609 = v608.Team.Name == v_u_39:GetAttribute("Attacker")
		end
		if v609 then
			return true
		end
		local v610 = v_u_569
		local v611
		if v610.Team == nil then
			v611 = false
		else
			v611 = v610.Team.Name == v_u_39:GetAttribute("Defender")
		end
		if v611 then
			local v612
			if v_u_569.Team == nil or p601.Team == nil then
				v612 = false
			else
				v612 = p601.Team == v_u_569.Team
			end
			if v612 then
				return true
			end
		end
		return false
	end
	local function v_u_624(p614) -- name: UpdateCharacterHighlight
		-- upvalues: (copy) v_u_613, (copy) v_u_569, (copy) v_u_573
		if p614.Character then
			local v615 = v_u_613(p614)
			local v616
			if p614 == v_u_569 then
				v616 = false
			else
				local v617 = p614:FindFirstChild("ServerData")
				local v618
				if v617 and v617:GetAttribute("Alive") ~= true then
					v618 = false
				else
					local v619 = p614.Character
					if v619 then
						local v620 = v619:FindFirstChildOfClass("Humanoid")
						v618 = (not v620 or v620.Health > 0) and true or false
					else
						v618 = false
					end
				end
				if v618 then
					local v621
					if v_u_569.Team == nil or p614.Team == nil then
						v621 = false
					else
						v621 = p614.Team == v_u_569.Team
					end
					if v621 then
						v616 = not v_u_613(p614)
					else
						v616 = false
					end
				else
					v616 = false
				end
			end
			if v615 or v616 then
				local v622
				if p614.Character then
					v622 = p614.Character:FindFirstChild(v_u_573)
					if not v622 then
						v622 = Instance.new("Highlight")
						v622.Name = v_u_573
						v622.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						v622.Parent = p614.Character
					end
				else
					v622 = nil
				end
				if v622 then
					v622.Enabled = true
					if v615 then
						v622.FillColor = Color3.fromRGB(255, 60, 60)
						v622.FillTransparency = 0.8
						v622.OutlineColor = Color3.fromRGB(85, 255, 85)
						v622.OutlineTransparency = 1
					else
						v622.FillTransparency = 1
						v622.OutlineColor = Color3.fromRGB(85, 255, 85)
						v622.OutlineTransparency = 0.75
					end
				else
					return
				end
			elseif p614.Character then
				local v623 = p614.Character:FindFirstChild(v_u_573)
				if v623 then
					v623:Destroy()
				end
			end
		else
			return
		end
	end
	local function v_u_632() -- name: AnyDefenderDetected
		-- upvalues: (ref) v_u_39, (ref) v_u_10
		if v_u_39:GetAttribute("Phase") ~= "Round Started" then
			return false
		end
		for _, v625 in ipairs(v_u_10:GetPlayers()) do
			local v626 = v625:FindFirstChild("ServerData")
			local v627
			if v626 and v626:GetAttribute("Alive") ~= true then
				v627 = false
			else
				local v628 = v625.Character
				if v628 then
					local v629 = v628:FindFirstChildOfClass("Humanoid")
					v627 = (not v629 or v629.Health > 0) and true or false
				else
					v627 = false
				end
			end
			if v627 then
				local v630
				if v625.Team == nil then
					v630 = false
				else
					v630 = v625.Team.Name == v_u_39:GetAttribute("Defender")
				end
				if v630 then
					local v631
					if v625.Character then
						v631 = v625.Character:GetAttribute("Detected") == true
					else
						v631 = false
					end
					if v631 then
						return true
					end
				end
			end
		end
		return false
	end
	local function v_u_637(p633) -- name: SetSpottedWarning
		-- upvalues: (copy) v_u_569
		local v634 = v_u_569.PlayerGui:FindFirstChild("GameHUD")
		if v634 then
			local v635 = v634:FindFirstChild("SpottedWarn")
			if v635 then
				local v636 = v635:FindFirstChild("Title")
				if v636 then
					v636.Text = p633
					v636.TextTransparency = 0
					if v636:FindFirstChild("UIStroke") then
						v636.UIStroke.Transparency = 0
					end
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_641() -- name: HideSpottedWarning
		-- upvalues: (copy) v_u_569
		local v638 = v_u_569.PlayerGui:FindFirstChild("GameHUD")
		if v638 then
			local v639 = v638:FindFirstChild("SpottedWarn")
			if v639 then
				local v640 = v639:FindFirstChild("Title")
				if v640 then
					v640.TextTransparency = 1
					if v640:FindFirstChild("UIStroke") then
						v640.UIStroke.Transparency = 1
					end
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_650() -- name: UpdateSpottedWarning
		-- upvalues: (copy) v_u_569, (ref) v_u_39, (copy) v_u_637, (copy) v_u_632, (copy) v_u_641
		local v642 = v_u_569.Character
		local v643 = v_u_569
		local v644 = v643:FindFirstChild("ServerData")
		local v645
		if v644 and v644:GetAttribute("Alive") ~= true then
			v645 = false
		else
			local v646 = v643.Character
			if v646 then
				local v647 = v646:FindFirstChildOfClass("Humanoid")
				v645 = (not v647 or v647.Health > 0) and true or false
			else
				v645 = false
			end
		end
		if v645 and (v642 and v642:GetAttribute("Detected") == true) and v_u_39:GetAttribute("Phase") == "Round Started" then
			v_u_637("YOU ARE SPOTTED BY ENEMY")
			return
		elseif v_u_632() then
			local v648 = v_u_569
			local v649
			if v648.Team == nil then
				v649 = false
			else
				v649 = v648.Team.Name == v_u_39:GetAttribute("Attacker")
			end
			if v649 then
				v_u_637("ENEMY SPOTTED OUTSIDE")
			else
				v_u_637("ALLIES SPOTTED OUTSIDE")
			end
		else
			v_u_641()
			return
		end
	end
	local function v_u_652() -- name: SanitizeCameraModel
		-- upvalues: (ref) v_u_570
		v_u_570 = workspace.CurrentCamera
		if v_u_570 then
			for _, v651 in ipairs(v_u_570:GetDescendants()) do
				if v651:IsA("SurfaceGui") then
					v651.AlwaysOnTop = false
				end
			end
		end
	end
	local function v_u_658() -- name: RefreshAll
		-- upvalues: (copy) v_u_652, (ref) v_u_10, (copy) v_u_583, (copy) v_u_600, (copy) v_u_624, (copy) v_u_650, (ref) v_u_570, (copy) v_u_569, (ref) v_u_39
		v_u_652()
		for _, v653 in ipairs(v_u_10:GetPlayers()) do
			if v653.Character then
				v_u_583(v653.Character, v653)
			end
			v_u_600(v653)
			v_u_624(v653)
		end
		v_u_650()
		v_u_570 = workspace.CurrentCamera
		local v654
		if v_u_570 then
			local v655 = v_u_570:FindFirstChild("CameraModel")
			if v655 then
				v654 = v655:FindFirstChild("Highlight", true)
			else
				v654 = nil
			end
		else
			v654 = nil
		end
		if v654 then
			local v656 = v_u_569.Character
			if v656 then
				v656 = v656:GetAttribute("Detected") == true
			end
			local v657
			if v656 == true then
				v657 = v_u_39:GetAttribute("Phase") == "Round Started"
			else
				v657 = false
			end
			v654.Enabled = v657
		end
	end
	local function v_u_663(p_u_659, p_u_660) -- name: ConfigureCharacter
		-- upvalues: (copy) v_u_583, (copy) v_u_574, (copy) v_u_579, (copy) v_u_658
		v_u_583(p_u_660, p_u_659)
		p_u_660.DescendantAdded:Connect(function(p_u_661)
			-- upvalues: (copy) p_u_659, (ref) v_u_574, (ref) v_u_579
			local v662 = p_u_659
			if p_u_661 then
				if v_u_574[p_u_661.ClassName] then
					if not v_u_579(p_u_661, v662) then
						task.defer(function()
							-- upvalues: (copy) p_u_661
							if p_u_661 and p_u_661.Parent then
								pcall(function()
									-- upvalues: (ref) p_u_661
									p_u_661:Destroy()
								end)
							end
						end)
					end
				else
					return
				end
			else
				return
			end
		end)
		p_u_660:GetAttributeChangedSignal("Detected"):Connect(function()
			-- upvalues: (ref) v_u_658
			v_u_658()
		end)
		task.defer(function()
			-- upvalues: (copy) p_u_660, (ref) v_u_658
			p_u_660:WaitForChild("Head", 5)
			v_u_658()
		end)
	end
	local v_u_664 = v_u_570
	local function v_u_669(p_u_665) -- name: ConfigurePlayer
		-- upvalues: (copy) v_u_663, (copy) v_u_658, (copy) v_u_600
		if p_u_665.Character then
			v_u_663(p_u_665, p_u_665.Character)
		end
		p_u_665.CharacterAdded:Connect(function(p666)
			-- upvalues: (ref) v_u_663, (copy) p_u_665
			v_u_663(p_u_665, p666)
		end)
		p_u_665:GetPropertyChangedSignal("Team"):Connect(function()
			-- upvalues: (ref) v_u_658
			v_u_658()
		end)
		local v_u_667 = p_u_665:FindFirstChild("ServerData")
		if v_u_667 then
			v_u_667:GetAttributeChangedSignal("Alive"):Connect(function()
				-- upvalues: (ref) v_u_658
				v_u_658()
			end)
		else
			task.spawn(function()
				-- upvalues: (ref) v_u_667, (copy) p_u_665, (ref) v_u_658
				v_u_667 = p_u_665:WaitForChild("ServerData", 10)
				if v_u_667 then
					v_u_667:GetAttributeChangedSignal("Alive"):Connect(function()
						-- upvalues: (ref) v_u_658
						v_u_658()
					end)
				end
			end)
		end
		local v668 = p_u_665:FindFirstChild("PlayerData")
		if v668 then
			v668 = v668:FindFirstChild("Stats")
		end
		if v668 then
			v668:GetAttributeChangedSignal("Level"):Connect(function()
				-- upvalues: (ref) v_u_600, (copy) p_u_665
				v_u_600(p_u_665)
			end)
		end
	end
	for _, v670 in ipairs(v_u_10:GetPlayers()) do
		v_u_669(v670)
	end
	v_u_10.PlayerAdded:Connect(function(p671)
		-- upvalues: (copy) v_u_669, (copy) v_u_658
		v_u_669(p671)
		v_u_658()
	end)
	v_u_10.PlayerRemoving:Connect(function()
		-- upvalues: (copy) v_u_658
		task.defer(v_u_658)
	end)
	v_u_39:GetAttributeChangedSignal("Phase"):Connect(function()
		-- upvalues: (copy) v_u_658
		v_u_658()
	end)
	v_u_39:GetAttributeChangedSignal("Attacker"):Connect(function()
		-- upvalues: (copy) v_u_658
		v_u_658()
	end)
	v_u_39:GetAttributeChangedSignal("Defender"):Connect(function()
		-- upvalues: (copy) v_u_658
		v_u_658()
	end)
	v_u_4.GameEvents.SetIdentity.OnClientEvent:Connect(function()
		-- upvalues: (copy) v_u_658
		v_u_658()
	end)
	v_u_664.ChildAdded:Connect(function(p672)
		-- upvalues: (copy) v_u_652, (ref) v_u_664, (copy) v_u_569, (ref) v_u_39
		if p672.Name == "CameraModel" then
			task.defer(function()
				-- upvalues: (ref) v_u_652, (ref) v_u_664, (ref) v_u_569, (ref) v_u_39
				v_u_652()
				v_u_664 = workspace.CurrentCamera
				local v673
				if v_u_664 then
					local v674 = v_u_664:FindFirstChild("CameraModel")
					if v674 then
						v673 = v674:FindFirstChild("Highlight", true)
					else
						v673 = nil
					end
				else
					v673 = nil
				end
				if v673 then
					local v675 = v_u_569.Character
					if v675 then
						v675 = v675:GetAttribute("Detected") == true
					end
					local v676
					if v675 == true then
						v676 = v_u_39:GetAttribute("Phase") == "Round Started"
					else
						v676 = false
					end
					v673.Enabled = v676
				end
			end)
		end
	end)
	v_u_664.DescendantAdded:Connect(function(p677)
		if p677:IsA("SurfaceGui") then
			p677.AlwaysOnTop = false
		end
	end)
	v_u_658()
end
function v_u_43.ConfigRealtimeSettings() -- name: ConfigRealtimeSettings
	-- upvalues: (copy) v_u_10
	local v_u_678 = v_u_10.LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Settings")
	v_u_678:GetAttributeChangedSignal("Brightness"):Connect(function()
		-- upvalues: (copy) v_u_678
		local v679 = game.Lighting:FindFirstChild("ColorCorrection")
		if v679 then
			v679.Brightness = v_u_678:GetAttribute("Brightness") / 35
		end
	end)
	local v680 = game.Lighting:FindFirstChild("ColorCorrection")
	if v680 then
		v680.Brightness = v_u_678:GetAttribute("Brightness") / 35
	end
end
function v_u_43.ConfigCountdown(_) -- name: ConfigCountdown
	-- upvalues: (copy) v_u_10, (copy) v_u_39, (copy) v_u_16, (copy) v_u_43
	local v_u_681 = v_u_10.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameMenu"):WaitForChild("Countdown")
	v_u_39:GetAttributeChangedSignal("Countdown"):Connect(function()
		-- upvalues: (ref) v_u_39, (copy) v_u_681, (ref) v_u_16, (ref) v_u_43
		local v682 = v_u_39:GetAttribute("Countdown")
		if v682 > 0 then
			v_u_681.Visible = true
			v_u_16.AddSound("Round_Countdown", nil, false, nil, false)
			v_u_681.Display.Time.Text = v_u_39:GetAttribute("Countdown")
			v_u_681.Display.Size = UDim2.new(0.07, 0, 0.07, 0)
			v_u_43.TweenCreate(v_u_681.Display, {
				["Size"] = UDim2.new(0.09, 0, 0.09, 0)
			}, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
			task.wait(0.25)
			v_u_43.TweenCreate(v_u_681.Display, {
				["Size"] = UDim2.new(0.07, 0, 0.07, 0)
			}, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
			if v682 == 1 then
				task.wait(0.9)
				v_u_43.TweenCreate(v_u_681.Display, {
					["Size"] = UDim2.new(0, 0, 0, 0)
				}, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
				v_u_16.AddSound("Intermission_Begin", nil, false, nil, false)
				return
			end
		elseif v682 <= 0 then
			v_u_16.AddSound("Round_CountdownLast", nil, false, nil, false)
			v_u_681.Visible = false
		end
	end)
end
function v_u_43.ConfigCaptureFeed() -- name: ConfigCaptureFeed
	-- upvalues: (copy) v_u_10, (copy) v_u_39
	local v_u_683 = v_u_10.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameHUD"):WaitForChild("TopBorder"):WaitForChild("CaptureFeed")
	v_u_39:GetAttributeChangedSignal("CapturePoint"):Connect(function()
		-- upvalues: (ref) v_u_39, (copy) v_u_683
		if v_u_39:GetAttribute("CapturePoint") > 0 then
			v_u_683.Visible = true
		else
			v_u_683.Visible = false
		end
		if v_u_39:GetAttribute("Contested") == false then
			v_u_683.Bar.Size = UDim2.new(v_u_39:GetAttribute("CapturePoint") / 100, 0, 1, 0)
		end
	end)
	v_u_39:GetAttributeChangedSignal("Contested"):Connect(function()
		-- upvalues: (ref) v_u_39, (copy) v_u_683
		if v_u_39:GetAttribute("Contested") == true then
			v_u_683.Visible = true
			v_u_683.Bar.BackgroundColor3 = Color3.fromRGB(255, 115, 40)
			v_u_683.Title.Text = "CONTESTED"
		else
			if v_u_39:GetAttribute("CapturePoint") == 0 then
				v_u_683.Visible = false
			end
			v_u_683.Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
			v_u_683.Title.Text = ""
		end
	end)
end
function v_u_43.ConfigSpectateUI() -- name: ConfigSpectateUI
	-- upvalues: (copy) v_u_4, (copy) v_u_16, (copy) v_u_22, (copy) v_u_26, (copy) v_u_2, (copy) v_u_8, (copy) v_u_23, (copy) v_u_33, (copy) v_u_43, (copy) v_u_18, (copy) v_u_39, (copy) v_u_35, (copy) v_u_37, (copy) v_u_44, (copy) v_u_34, (copy) v_u_14, (copy) v_u_15, (copy) v_u_20, (copy) v_u_28, (copy) v_u_3, (copy) v_u_27, (copy) v_u_29, (copy) v_u_11, (copy) v_u_433, (copy) v_u_24, (copy) v_u_25, (copy) v_u_46, (copy) v_u_67, (copy) v_u_30, (copy) v_u_62, (copy) v_u_47, (copy) v_u_7, (copy) v_u_31, (copy) v_u_1, (copy) v_u_36, (copy) v_u_32
	local v_u_684 = game:GetService("Players")
	local v_u_685 = v_u_684.LocalPlayer
	local v_u_686 = workspace.CurrentCamera
	local v_u_687 = v_u_685:WaitForChild("PlayerGui")
	local v688 = v_u_687:WaitForChild("GameHUD")
	local v_u_689 = v_u_687:WaitForChild("GameMenu")
	local v_u_690 = v688:WaitForChild("DeathScreen")
	local v_u_691 = v688:WaitForChild("SpectatorUI")
	local v_u_692 = v_u_685:WaitForChild("PlayerData"):WaitForChild("Stats")
	local v_u_693 = v_u_691:FindFirstChild("NextCrate")
	local v_u_694 = v688:WaitForChild("GameNotification"):WaitForChild("Reward")
	local v_u_695 = v_u_4.Components.GameMenu:WaitForChild("SampleRewardNotification")
	local v_u_696 = v_u_4.Items:WaitForChild("Crate"):FindFirstChild("Spectator")
	local v_u_697
	if v_u_696 then
		v_u_697 = v_u_16.GetItemDataFromObject(v_u_696) or nil
	else
		v_u_697 = nil
	end
	local v_u_698 = v_u_692:GetAttribute(v_u_22.Attributes.ClaimSerial) or 0
	local v_u_699 = 1
	local v_u_700 = nil
	local v_u_701 = 0
	local v_u_702 = nil
	local v_u_703 = nil
	local v_u_704 = {}
	local v_u_705 = {}
	local v_u_706 = {}
	local v_u_707 = {}
	local v_u_708 = nil
	local v_u_709 = false
	local v_u_710 = false
	local v_u_711 = false
	local v_u_712 = false
	local v_u_713 = 0
	local v_u_714 = 0
	local v_u_715 = nil
	local v_u_716 = {}
	local v_u_717 = nil
	local v_u_718 = {}
	local v_u_719 = {}
	local v_u_720 = nil
	local v_u_721 = nil
	local v_u_722 = nil
	local v_u_723 = 1
	local v_u_724 = false
	local v_u_725 = false
	ReplaySuppressSpottedWarning = false
	local v_u_731 = {
		["Suppress"] = function() -- name: Suppress
			-- upvalues: (copy) v_u_687
			ReplaySuppressSpottedWarning = true
			local v726 = v_u_687
			if v726 then
				v726 = v_u_687:FindFirstChild("GameHUD")
			end
			if v726 then
				v726 = v726:FindFirstChild("SpottedWarn")
			end
			if v726 then
				v726.Visible = false
				local v727 = v726:FindFirstChild("Title")
				if v727 and v727:IsA("TextLabel") then
					v727.Visible = false
				end
			end
		end,
		["Restore"] = function() -- name: Restore
			-- upvalues: (copy) v_u_687
			ReplaySuppressSpottedWarning = false
			local v728 = UpdateSpottedWarning
			if typeof(v728) == "function" then
				v728()
			else
				local v729 = v_u_687
				if v729 then
					v729 = v_u_687:FindFirstChild("GameHUD")
				end
				if v729 then
					v729 = v729:FindFirstChild("SpottedWarn")
				end
				if v729 then
					v729.Visible = false
					local v730 = v729:FindFirstChild("Title")
					if v730 and v730:IsA("TextLabel") then
						v730.Visible = false
					end
				end
			end
		end
	}
	local v_u_732 = false
	local v_u_733 = false
	local v_u_734 = false
	local v_u_735 = false
	local v_u_736 = 0
	local v_u_737 = nil
	local v_u_738 = v_u_686.FieldOfView
	local v_u_739 = v_u_26.new({
		["Camera"] = v_u_686,
		["LocalPlayer"] = v_u_685,
		["PlayerGui"] = v_u_687,
		["UserInputService"] = v_u_2,
		["RunService"] = v_u_8,
		["Workspace"] = workspace
	})
	local v_u_740 = 0
	local v_u_741 = nil
	local v_u_742 = v_u_23.new(v_u_685, v_u_686)
	local v743 = v_u_4:WaitForChild("GameEvents"):WaitForChild("ReplayKillCam")
	local v744 = v_u_4:WaitForChild("GameEvents"):WaitForChild("SoundCue")
	local v745 = v_u_4:WaitForChild("GameEvents"):WaitForChild("Shoot")
	local v746 = v_u_4:WaitForChild("GameEvents"):WaitForChild("Hit")
	local v747 = v_u_4:WaitForChild("GameEvents"):WaitForChild("HitFromServer")
	local v_u_748 = {
		["Mobile"] = "rbxassetid://14972030879",
		["Console"] = "rbxassetid://14972031004",
		["Computer"] = "rbxassetid://14972031099"
	}
	local v_u_749 = true
	local v_u_750 = nil
	local function v751() -- name: ResetPostDeathTransitionState
		-- upvalues: (ref) v_u_736, (ref) v_u_733, (ref) v_u_734, (ref) v_u_735, (ref) v_u_737, (copy) v_u_690
		v_u_736 = v_u_736 + 1
		v_u_733 = false
		v_u_734 = false
		v_u_735 = false
		v_u_737 = nil
		if v_u_690 and v_u_690:IsA("GuiObject") then
			v_u_690.Visible = false
		end
	end
	local function v753(p752) -- name: CancelPostDeathTransitionForReplay
		-- upvalues: (ref) v_u_733, (ref) v_u_735, (ref) v_u_737, (ref) v_u_33, (ref) v_u_736, (ref) v_u_734, (copy) v_u_690
		if ((v_u_733 == true or v_u_735 == true) and true or v_u_737 ~= nil) == true then
			v_u_33.Warn("[GameMenu] Cancel post-death transition for replay", p752 or "Unknown", v_u_736)
		end
		v_u_736 = v_u_736 + 1
		v_u_733 = false
		v_u_734 = false
		v_u_735 = false
		v_u_737 = nil
		if v_u_690 and v_u_690:IsA("GuiObject") then
			v_u_690.Visible = false
		end
	end
	local function v756() -- name: ArmPostDeathTransition
		-- upvalues: (ref) v_u_733, (ref) v_u_736, (ref) v_u_734, (copy) v_u_690
		if v_u_733 ~= true then
			v_u_736 = v_u_736 + 1
		end
		v_u_733 = true
		v_u_734 = false
		if v_u_690 and v_u_690:IsA("GuiObject") then
			v_u_690.Visible = true
		end
		local v754 = workspace.CurrentCamera
		local v755 = v754 and v754:FindFirstChild("CameraModel")
		if v755 then
			v755:Destroy()
		end
		return v_u_736
	end
	local function v760(p757) -- name: QueuePostDeathTransition
		-- upvalues: (ref) v_u_733, (ref) v_u_734, (ref) v_u_737, (ref) v_u_735, (ref) v_u_736, (copy) v_u_690, (ref) v_u_43
		if v_u_733 ~= true or v_u_734 == true then
			return false
		end
		v_u_737 = p757
		if v_u_735 == true then
			return true
		end
		v_u_735 = true
		local v_u_758 = v_u_736
		task.delay(2, function()
			-- upvalues: (ref) v_u_735, (ref) v_u_736, (copy) v_u_758, (ref) v_u_737, (ref) v_u_734, (ref) v_u_690, (ref) v_u_43
			if v_u_735 == true and v_u_736 == v_u_758 then
				local v759 = v_u_737
				v_u_737 = nil
				v_u_735 = false
				v_u_734 = true
				if v_u_690 and v_u_690:IsA("GuiObject") then
					v_u_690.Visible = false
				end
				v_u_43.PlayScreenTransition()
				if v759 then
					v759()
				end
			end
		end)
		return true
	end
	if v_u_690 and v_u_690:IsA("GuiObject") then
		v_u_690.Visible = false
	end
	local function v_u_764(p761) -- name: RefreshSpectatedDeviceIcon
		-- upvalues: (copy) v_u_691, (copy) v_u_748
		local v762 = v_u_691:FindFirstChild("Profile")
		if v762 then
			v762 = v762:FindFirstChild("DeviceIcon")
		end
		if v762 and v762:IsA("ImageLabel") then
			if p761 then
				p761 = p761:FindFirstChild("ServerData")
			end
			if p761 then
				p761 = p761:GetAttribute("Device")
			end
			local v763
			if typeof(p761) == "string" then
				v763 = v_u_748[p761] or nil
			else
				v763 = nil
			end
			v762.Visible = v763 ~= nil
			v762.Image = v763 or ""
		end
	end
	local function v_u_773() -- name: RefreshSpectateButtonDisplay
		-- upvalues: (copy) v_u_691, (copy) v_u_685
		local v765 = v_u_691:FindFirstChild("Profile")
		local v766
		if v765 then
			v766 = v765:FindFirstChild("Next")
		else
			v766 = v765
		end
		if v765 then
			v765 = v765:FindFirstChild("Previous")
		end
		if v766 and v765 then
			local v767 = v766:FindFirstChild("Title")
			local v768 = v765:FindFirstChild("Title")
			local v769 = v_u_685:GetAttribute("OnMobile") == true and "Mobile" or (v_u_685:GetAttribute("OnConsole") == true and "Console" or "Computer")
			local v770 = 1
			local v771 = "Q"
			local v772 = "E"
			if v769 == "Mobile" then
				v770 = 0
				v772 = ">"
				v771 = "<"
			elseif v769 == "Console" then
				v772 = "R1"
				v771 = "L1"
			end
			v766.BackgroundTransparency = v770
			v765.BackgroundTransparency = v770
			if v767 and v767:IsA("TextLabel") then
				v767.Text = v772
			end
			if v768 and v768:IsA("TextLabel") then
				v768.Text = v771
			end
		end
	end
	local function v776() -- name: CanCycleTeamSpectate
		-- upvalues: (copy) v_u_691, (ref) v_u_700, (ref) v_u_710, (ref) v_u_711, (ref) v_u_749, (ref) v_u_750
		local v774
		if v_u_691.Visible == true and (v_u_700 ~= nil and v_u_710 ~= true) then
			v774 = v_u_711 ~= true
		else
			v774 = false
		end
		if v774 ~= true then
			return false
		end
		if v_u_749 == true then
			local v775 = v_u_750
			if typeof(v775) == "function" then
				return #v_u_750() > 1
			end
		end
		return false
	end
	local function v_u_783(p777) -- name: RefreshSpectateControls
		-- upvalues: (copy) v_u_691, (ref) v_u_700, (ref) v_u_710, (ref) v_u_711, (ref) v_u_749, (ref) v_u_750, (copy) v_u_773, (copy) v_u_764
		local v778 = v_u_691:FindFirstChild("Profile")
		local v779
		if v778 then
			v779 = v778:FindFirstChild("Next")
		else
			v779 = v778
		end
		if v778 then
			v778 = v778:FindFirstChild("Previous")
		end
		local v780
		if v_u_691.Visible == true and (v_u_700 ~= nil and v_u_710 ~= true) then
			v780 = v_u_711 ~= true
		else
			v780 = false
		end
		local v781
		if v780 == true and v_u_749 == true then
			local v782 = v_u_750
			if typeof(v782) == "function" then
				v781 = #v_u_750() > 1
			else
				v781 = false
			end
		else
			v781 = false
		end
		if v779 then
			v779.Visible = v781
		end
		if v778 then
			v778.Visible = v781
		end
		v_u_773()
		v_u_764(p777 or v_u_700)
	end
	local function v785(p784) -- name: SetFrameVisible
		-- upvalues: (ref) v_u_732, (copy) v_u_691, (copy) v_u_783, (ref) v_u_741
		v_u_732 = true
		v_u_691.Visible = p784
		v_u_732 = false
		v_u_783()
		if v_u_741 then
			v_u_741()
		end
	end
	local function v_u_788(p786) -- name: SetSpectatorCrateViewportStyle
		-- upvalues: (ref) v_u_18
		if p786 and p786:IsA("ViewportFrame") then
			local v787 = p786:FindFirstChild("WorldModel")
			if v787 then
				v787 = v787:FindFirstChildWhichIsA("Model")
			end
			if v787 then
				if not v787.PrimaryPart then
					v787.PrimaryPart = v787:FindFirstChild("Base") or v787.PrimaryPart
				end
				v787:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, -0.3490658503988659, 0))
				v_u_18.Menu.SetNewViewPort(p786, Vector3.new(0, 0, 0), Vector3.new(0, 4.5, -8))
				if p786:FindFirstChild("Camera") then
					p786.Camera.FieldOfView = 70
				end
			end
		else
			return
		end
	end
	local function v_u_797(p789, p790, p791) -- name: PopulateSpectatorCrateDisplay
		-- upvalues: (copy) v_u_697, (ref) v_u_18, (copy) v_u_788, (copy) v_u_696, (ref) v_u_16
		if p789 and v_u_697 then
			local v792 = p789:FindFirstChild("ItemPort")
			if v792 and v792:IsA("ViewportFrame") then
				v792.Visible = true
				v_u_18.Menu.AddItemToViewport(table.clone(v_u_697), v792, true)
				if p791 == true then
					v_u_788(v792)
				end
			end
			local v793 = p789:FindFirstChild("ImageDisplay")
			if v793 and v793:IsA("ImageLabel") then
				v793.Image = ""
				v793.Visible = false
			end
			local v794 = p789:FindFirstChild("Amount")
			if v794 and v794:IsA("TextLabel") then
				v794.Text = p790
			end
			local v795 = p789:FindFirstChild("Rarity")
			local v796 = v_u_696
			if v796 then
				v796 = v_u_696:GetAttribute("Rarity")
			end
			if v796 then
				v796 = v_u_16.Rarity[v796]
			end
			if v795 and v796 then
				v795.ImageColor3 = v796.Color
			end
		end
	end
	local function v805() -- name: PlaySpectatorRewardNotification
		-- upvalues: (copy) v_u_695, (copy) v_u_697, (ref) v_u_16, (copy) v_u_694, (copy) v_u_797
		if v_u_695 and v_u_697 then
			v_u_16.AddSound("Notification_Party", nil, false, nil, false)
			local v_u_798 = v_u_695:Clone()
			v_u_798.Parent = v_u_694
			v_u_798.Visible = true
			v_u_798.Active = false
			v_u_798.AutoButtonColor = false
			local v_u_799 = UDim2.new(3, 0, v_u_798.Position.Y.Scale, v_u_798.Position.Y.Offset)
			local v800 = UDim2.new(0.5, 0, v_u_798.Position.Y.Scale, v_u_798.Position.Y.Offset)
			v_u_798.Position = v_u_799
			local v801 = v_u_798.Title
			local v802
			if v_u_697 then
				local v803 = v_u_697.DisplayName or v_u_697.Name or "Crate"
				v802 = string.format("x%d %s Crate", 1, v803)
			else
				v802 = ""
			end
			v801.Text = v802
			v_u_797(v_u_798.ItemDisplay, "x1", true)
			v_u_16.TweenCreate(v_u_798, {
				["Position"] = v800
			}, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
			task.delay(8, function()
				-- upvalues: (copy) v_u_798, (ref) v_u_16, (copy) v_u_799
				if v_u_798 ~= nil and v_u_798.Parent ~= nil then
					local v804 = {
						["Position"] = v_u_799
					}
					v_u_16.TweenCreate(v_u_798, v804, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
					task.delay(0.5, function()
						-- upvalues: (ref) v_u_798
						if v_u_798 and v_u_798.Parent then
							v_u_798:Destroy()
						end
					end)
				end
			end)
		end
	end
	local function v_u_809()
		-- upvalues: (copy) v_u_693, (ref) v_u_22, (copy) v_u_692, (copy) v_u_697, (copy) v_u_691, (ref) v_u_711, (ref) v_u_39, (copy) v_u_797
		if v_u_693 then
			v_u_22.RefreshStats(v_u_692)
			if v_u_697 then
				local v806
				if v_u_691.Visible == true and (v_u_711 ~= true and v_u_22.IsModeEligible(v_u_39:GetAttribute("GameMode")) == true) then
					v806 = v_u_22.HasRemainingRewards(v_u_692)
				else
					v806 = false
				end
				v_u_693.Visible = v806
				if v806 then
					v_u_797(v_u_693.ItemDisplay, "x1")
					local v807 = v_u_22.GetRoundsUntilNextReward(v_u_692)
					local v808 = v_u_693:FindFirstChild("Title")
					if v808 and v808:IsA("TextLabel") then
						v808.Text = v_u_22.FormatNextRewardText(v807)
					end
				end
			else
				v_u_693.Visible = false
				return
			end
		else
			return
		end
	end
	local function v_u_815() -- name: RefreshSpectatorUI
		-- upvalues: (ref) v_u_700, (copy) v_u_691, (ref) v_u_4, (ref) v_u_16
		if v_u_700 then
			local v810 = v_u_700:FindFirstChild("PlayerData")
			local v811 = v_u_700:FindFirstChild("ServerData")
			if v810 and v811 then
				v_u_691.Profile.PlayerName.Text = v_u_700.DisplayName
				v_u_691.Profile.Level.Text = v810.Stats:GetAttribute("Level")
				v_u_691.Profile.PlayerImage.Image = v811:GetAttribute("ProfilePicture")
				local v812 = v810.Settings:GetAttribute("LoadoutName")
				local v813 = v810.Loadout:FindFirstChild(v812)
				if v813 then
					local v814 = v_u_4.Items.Banner:FindFirstChild(v813:GetAttribute("Banner"))
					if v814 == nil then
						v_u_691.Profile.PlayerBanner.Image = ""
					else
						v_u_691.Profile.PlayerBanner.Image = v814.Texture
					end
					v_u_16.SetTitle(v_u_691.Profile.PlayerTitle, v_u_4.Items.Title:FindFirstChild(v813:GetAttribute("Title")))
				else
					v_u_691.Profile.PlayerBanner.Image = ""
				end
				v_u_691.Profile.Kills.Text = v811:GetAttribute("Kills")
				v_u_691.Profile.Deaths.Text = v811:GetAttribute("Deaths")
			end
		else
			return
		end
	end
	local function v_u_816() -- name: ClearMenuCameraState
		-- upvalues: (ref) v_u_708, (ref) v_u_709
		if v_u_708 then
			v_u_708:Cancel()
			v_u_708 = nil
		end
		v_u_709 = false
	end
	local function v_u_819(p817) -- name: IsAlive
		if not p817 then
			return false
		end
		if not p817:FindFirstChild("ServerData") then
			return false
		end
		if p817.ServerData:GetAttribute("Alive") ~= true then
			return false
		end
		if not p817.Character then
			return false
		end
		local v818 = p817.Character:FindFirstChildOfClass("Humanoid")
		return v818 and v818.Health > 0 and true or false
	end
	local function v_u_822()
		-- upvalues: (copy) v_u_684, (copy) v_u_819, (copy) v_u_685
		local v820 = {}
		for _, v821 in pairs(v_u_684:GetPlayers()) do
			if (v_u_819(v821) and v821.Team == v_u_685.Team and true or false) and v821 ~= v_u_685 then
				table.insert(v820, v821)
			end
		end
		return v820
	end
	local v_u_823 = nil
	local v_u_824 = nil
	local function v_u_829(p825) -- name: UpdateFirstPersonSpectateTarget
		-- upvalues: (ref) v_u_39, (ref) v_u_35, (copy) v_u_685, (ref) v_u_37
		local v_u_826 = nil
		local v827 = v_u_39:GetAttribute("GameMode")
		local v828
		if v827 == "Custom" then
			v828 = v_u_39:GetAttribute("SpectateFirstPerson") == true
		else
			v828 = false
		end
		if v_u_35.ResolveSpectateMode(v827, v828) == v_u_35.SpectateModes.FirstPerson == true and (p825 and p825 ~= v_u_685) then
			v_u_826 = p825
		end
		pcall(function()
			-- upvalues: (ref) v_u_37, (ref) v_u_826
			v_u_37:FireServer(v_u_826)
		end)
	end
	local function v_u_837(p830, p831, p832) -- name: ResolveSpectateSound
		if typeof(p830) ~= "Instance" or not p830:IsA("Player") then
			return nil
		end
		local v833 = p830.Character
		if not v833 then
			return nil
		end
		if typeof(p832) == "string" and p832 ~= "" then
			local v834 = v833:FindFirstChild(p832, true)
			if v834 then
				v834 = v834:FindFirstChild("Handle", true)
			end
			if v834 then
				v834 = v834:FindFirstChild(p831)
			end
			if v834 and v834:IsA("Sound") then
				return v834
			end
		end
		local v835 = v833:FindFirstChild("HumanoidRootPart")
		if v835 then
			v835 = v835:FindFirstChild(p831)
		end
		if v835 and v835:IsA("Sound") then
			return v835
		end
		for _, v836 in ipairs(v833:GetDescendants()) do
			if v836:IsA("Sound") and v836.Name == p831 then
				return v836
			end
		end
		return nil
	end
	local function v_u_844(p838, p839, p840, p841) -- name: HandleSpectateSoundCue
		-- upvalues: (ref) v_u_44, (copy) v_u_837
		local v842
		if v_u_44:GetAttribute("ThirdPersonSpectateOrbitActive") == true == true then
			v842 = v_u_44:GetAttribute("FirstPersonSpectateActive") == true ~= true
		else
			v842 = false
		end
		if v842 == true then
			if typeof(p839) == "string" and p839 ~= "" then
				local v843 = v_u_837(p838, p839, p841)
				if v843 then
					if p840 == true then
						v843:Play()
					else
						v843:Stop()
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_848(p845) -- name: ResolveThirdPersonSpectateWeaponModel
		-- upvalues: (ref) v_u_34
		if typeof(p845) == "Instance" and p845:IsA("Player") then
			local v846 = p845.Character
			if v846 then
				local v847 = v_u_34.GetStateFolder(v846)
				if v847 then
					v847 = v847:GetAttribute("EquippedToolName")
				end
				if typeof(v847) == "string" and v847 ~= "" then
					return v_u_34.ResolveVisibleModel(v846, v847)
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	end
	local function v_u_856(p849, p850, p851, p852, p853, p854) -- name: HandleThirdPersonSpectateImpact
		-- upvalues: (ref) v_u_44, (ref) v_u_15
		local v855
		if v_u_44:GetAttribute("ThirdPersonSpectateOrbitActive") == true == true then
			v855 = v_u_44:GetAttribute("FirstPersonSpectateActive") == true ~= true
		else
			v855 = false
		end
		if v855 == true then
			if typeof(p850) == "Instance" and p850:IsA("BasePart") then
				if typeof(p851) == "Vector3" and typeof(p852) == "Vector3" then
					v_u_15.Hit(p850, p851, p852, p853, p854, p849)
				end
			else
				return
			end
		else
			return
		end
	end
	v744.OnClientEvent:Connect(function(p857, p858, p859, p860)
		-- upvalues: (copy) v_u_844
		if typeof(p857) == "Instance" and p857:IsA("Player") then
			v_u_844(p857, p858, p859, p860)
		end
	end)
	v745.OnClientEvent:Connect(function(p861)
		-- upvalues: (ref) v_u_44, (copy) v_u_848, (ref) v_u_14
		if typeof(p861) == "Instance" and p861:IsA("Player") then
			local v862
			if v_u_44:GetAttribute("ThirdPersonSpectateOrbitActive") == true == true then
				v862 = v_u_44:GetAttribute("FirstPersonSpectateActive") == true ~= true
			else
				v862 = false
			end
			if v862 ~= true then
				return
			end
			local v863 = v_u_848(p861)
			if v863 then
				v_u_14.MuzzleShootEffect(v863)
			end
		end
	end)
	v746.OnClientEvent:Connect(function(p864, p865, p866, p867, p868, p869)
		-- upvalues: (copy) v_u_856
		if typeof(p864) == "Instance" and p864:IsA("Player") then
			v_u_856(p864, p865, p866, p867, p868, p869)
		end
	end)
	v747.OnClientEvent:Connect(function(p870, p871, p872, p873, p874, p875)
		-- upvalues: (copy) v_u_856
		if typeof(p870) == "Instance" and p870:IsA("Player") then
			v_u_856(p870, p871, p872, p873, p874, p875)
		end
	end)
	local function v_u_877(p876) -- name: SetLocalSpectateHidden
		-- upvalues: (copy) v_u_704
		if v_u_704[p876] == nil then
			if p876:IsA("BasePart") then
				v_u_704[p876] = {
					["Kind"] = "BasePart",
					["LocalTransparencyModifier"] = nil,
					["LocalTransparencyModifier"] = p876.LocalTransparencyModifier
				}
				p876.LocalTransparencyModifier = 1
				return
			elseif p876:IsA("BillboardGui") or p876:IsA("SurfaceGui") then
				v_u_704[p876] = {
					["Kind"] = "LayerCollector",
					["Enabled"] = nil,
					["Enabled"] = p876.Enabled
				}
				p876.Enabled = false
				return
			elseif p876:IsA("Highlight") then
				v_u_704[p876] = {
					["Kind"] = "Highlight",
					["Enabled"] = nil,
					["Enabled"] = p876.Enabled
				}
				p876.Enabled = false
				return
			elseif p876:IsA("ProximityPrompt") then
				v_u_704[p876] = {
					["Kind"] = "ProximityPrompt",
					["Enabled"] = nil,
					["Enabled"] = p876.Enabled
				}
				p876.Enabled = false
			elseif p876:IsA("Decal") or p876:IsA("Texture") then
				v_u_704[p876] = {
					["Kind"] = "TransparencyObject",
					["Transparency"] = nil,
					["Transparency"] = p876.Transparency
				}
				p876.Transparency = 1
			end
		else
			return
		end
	end
	local function v_u_879() -- name: DisconnectSpectatedCharacterConnections
		-- upvalues: (copy) v_u_705
		for _, v878 in ipairs(v_u_705) do
			if v878 then
				v878:Disconnect()
			end
		end
		table.clear(v_u_705)
	end
	local function v_u_881() -- name: DisconnectSpectatedHumanoidConnections
		-- upvalues: (copy) v_u_707
		for _, v880 in ipairs(v_u_707) do
			if v880 then
				v880:Disconnect()
			end
		end
		table.clear(v_u_707)
	end
	local function v_u_884(p882) -- name: ApplyLocalHumanoidSpectateOverride
		-- upvalues: (copy) v_u_685, (copy) v_u_706
		if p882 then
			local v883 = v_u_685.Character
			if not (v883 and p882:IsDescendantOf(v883)) then
				if v_u_706[p882] == nil then
					v_u_706[p882] = {
						["DisplayDistanceType"] = p882.DisplayDistanceType,
						["HealthDisplayDistance"] = p882.HealthDisplayDistance,
						["NameDisplayDistance"] = p882.NameDisplayDistance
					}
				end
				p882.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				p882.HealthDisplayDistance = 0
				p882.NameDisplayDistance = 0
			end
		else
			return
		end
	end
	local function v_u_896(p885) -- name: ObserveSpectatedHumanoidCharacter
		-- upvalues: (copy) v_u_884, (copy) v_u_707
		if p885 then
			local function v_u_891(p_u_886) -- name: bindHumanoid
				-- upvalues: (ref) v_u_884, (ref) v_u_707
				if p_u_886 then
					v_u_884(p_u_886)
					for _, v887 in ipairs({ "DisplayDistanceType", "HealthDisplayDistance", "NameDisplayDistance" }) do
						local v888 = v_u_707
						local v889 = p_u_886:GetPropertyChangedSignal(v887)
						local function v890()
							-- upvalues: (ref) v_u_884, (copy) p_u_886
							v_u_884(p_u_886)
						end
						table.insert(v888, v889:Connect(v890))
					end
				end
			end
			local v892 = p885:FindFirstChildOfClass("Humanoid")
			if v892 then
				v_u_891(v892)
			end
			local v893 = v_u_707
			local v894 = p885.DescendantAdded
			table.insert(v893, v894:Connect(function(p895)
				-- upvalues: (copy) v_u_891
				if p895:IsA("Humanoid") then
					v_u_891(p895)
				end
			end))
		end
	end
	local function v_u_910() -- name: BindSpectatedHumanoidDisplayOverrides
		-- upvalues: (copy) v_u_881, (copy) v_u_684, (copy) v_u_685, (copy) v_u_896, (copy) v_u_707
		v_u_881()
		for _, v897 in ipairs(v_u_684:GetPlayers()) do
			if v897 ~= v_u_685 then
				v_u_896(v897.Character)
				local v898 = v_u_707
				local v899 = v897.CharacterAdded
				local function v901(p900)
					-- upvalues: (ref) v_u_896
					v_u_896(p900)
				end
				table.insert(v898, v899:Connect(v901))
			end
		end
		local v902 = v_u_707
		local v903 = v_u_684.PlayerAdded
		local function v909(p904)
			-- upvalues: (ref) v_u_685, (ref) v_u_896, (ref) v_u_707
			if p904 ~= v_u_685 then
				v_u_896(p904.Character)
				local v905 = v_u_707
				local v906 = p904.CharacterAdded
				local function v908(p907)
					-- upvalues: (ref) v_u_896
					v_u_896(p907)
				end
				table.insert(v905, v906:Connect(v908))
			end
		end
		table.insert(v902, v903:Connect(v909))
	end
	local function v_u_913(p911) -- name: HideSpectatedInstanceTree
		-- upvalues: (copy) v_u_877
		if p911 then
			v_u_877(p911)
			for _, v912 in ipairs(p911:GetDescendants()) do
				v_u_877(v912)
			end
		end
	end
	local function v_u_916(p914) -- name: ResetLocalSpectateHidden
		-- upvalues: (copy) v_u_704
		local v915 = v_u_704[p914]
		if v915 ~= nil then
			if p914 and p914.Parent then
				if v915.Kind == "BasePart" and p914:IsA("BasePart") then
					p914.LocalTransparencyModifier = v915.LocalTransparencyModifier or 0
				elseif v915.Kind == "LayerCollector" and (p914:IsA("BillboardGui") or p914:IsA("SurfaceGui")) then
					p914.Enabled = v915.Enabled == true
				elseif v915.Kind == "Highlight" and p914:IsA("Highlight") then
					p914.Enabled = v915.Enabled == true
				elseif v915.Kind == "ProximityPrompt" and p914:IsA("ProximityPrompt") then
					p914.Enabled = v915.Enabled == true
				elseif v915.Kind == "TransparencyObject" and (p914:IsA("Decal") or p914:IsA("Texture")) then
					p914.Transparency = v915.Transparency or 0
				end
			end
			v_u_704[p914] = nil
		end
	end
	local function v_u_919(p917) -- name: ResetSpectatedInstanceTree
		-- upvalues: (copy) v_u_916
		if p917 then
			v_u_916(p917)
			for _, v918 in ipairs(p917:GetDescendants()) do
				v_u_916(v918)
			end
		end
	end
	local function v_u_932(p920, p_u_921) -- name: BindSpectatedCharacterVisibility
		-- upvalues: (copy) v_u_879, (copy) v_u_705, (copy) v_u_913, (copy) v_u_684, (copy) v_u_932, (ref) v_u_700, (ref) v_u_44
		v_u_879()
		if p920 then
			local v_u_922
			if typeof(p_u_921) == "table" then
				v_u_922 = p_u_921.PersistDuringReplay == true
			else
				v_u_922 = false
			end
			local v923 = v_u_705
			local v924 = p920.DescendantAdded
			local function v926(p925)
				-- upvalues: (ref) v_u_913
				v_u_913(p925)
			end
			table.insert(v923, v924:Connect(v926))
			local v_u_927 = v_u_684:GetPlayerFromCharacter(p920)
			if v_u_927 then
				local v928 = v_u_705
				local v929 = v_u_927.CharacterAdded
				local function v931(p930)
					-- upvalues: (copy) v_u_922, (ref) v_u_913, (ref) v_u_932, (copy) p_u_921, (ref) v_u_700, (copy) v_u_927, (ref) v_u_44
					if v_u_922 == true then
						v_u_913(p930)
						v_u_932(p930, p_u_921)
						return
					elseif v_u_700 == v_u_927 and v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true then
						v_u_913(p930)
						v_u_932(p930, p_u_921)
					end
				end
				table.insert(v928, v929:Connect(v931))
			end
		end
	end
	local function v_u_943(p933) -- name: PrepareFirstPersonSpectateTarget
		-- upvalues: (ref) v_u_39, (ref) v_u_35, (copy) v_u_685, (ref) v_u_37, (ref) v_u_43, (copy) v_u_913, (copy) v_u_932, (copy) v_u_742
		local v934 = v_u_39:GetAttribute("GameMode")
		local v935
		if v934 == "Custom" then
			v935 = v_u_39:GetAttribute("SpectateFirstPerson") == true
		else
			v935 = false
		end
		if v_u_35.ResolveSpectateMode(v934, v935) == v_u_35.SpectateModes.FirstPerson ~= true or (not p933 or p933 == v_u_685) then
			local v_u_936 = nil
			local v937 = v_u_39:GetAttribute("GameMode")
			local v938
			if v937 == "Custom" then
				v938 = v_u_39:GetAttribute("SpectateFirstPerson") == true
			else
				v938 = false
			end
			local _ = v_u_35.ResolveSpectateMode(v937, v938) == v_u_35.SpectateModes.FirstPerson == true
			pcall(function()
				-- upvalues: (ref) v_u_37, (ref) v_u_936
				v_u_37:FireServer(v_u_936)
			end)
			if v_u_43.SetDamageFeedSourcePlayer then
				v_u_43.SetDamageFeedSourcePlayer(v_u_685)
			end
			return nil
		end
		local v939 = p933.Character
		if v939 then
			if v939 then
				v_u_913(v939)
			end
			v_u_932(v939)
		end
		local v_u_940 = nil
		local v941 = v_u_39:GetAttribute("GameMode")
		local v942
		if v941 == "Custom" then
			v942 = v_u_39:GetAttribute("SpectateFirstPerson") == true
		else
			v942 = false
		end
		if v_u_35.ResolveSpectateMode(v941, v942) == v_u_35.SpectateModes.FirstPerson == true and (p933 and p933 ~= v_u_685) then
			v_u_940 = p933
		end
		pcall(function()
			-- upvalues: (ref) v_u_37, (ref) v_u_940
			v_u_37:FireServer(v_u_940)
		end)
		if v_u_43.SetDamageFeedSourcePlayer then
			v_u_43.SetDamageFeedSourcePlayer(p933)
		end
		if v_u_742 and v_u_742.Prewarm then
			v_u_742:Prewarm(p933)
		end
		return v939
	end
	local function v_u_945() -- name: ResetSpectatedTransparency
		-- upvalues: (copy) v_u_879, (copy) v_u_704, (copy) v_u_916
		v_u_879()
		for v944 in pairs(v_u_704) do
			v_u_916(v944)
		end
		table.clear(v_u_704)
	end
	local function v_u_948() -- name: ResetSpectatedHumanoidDisplay
		-- upvalues: (copy) v_u_881, (copy) v_u_706
		v_u_881()
		for v946, v947 in pairs(v_u_706) do
			if v946 and v946.Parent then
				v946.DisplayDistanceType = v947.DisplayDistanceType
				v946.HealthDisplayDistance = v947.HealthDisplayDistance
				v946.NameDisplayDistance = v947.NameDisplayDistance
			end
		end
		table.clear(v_u_706)
	end
	local function v_u_953(p_u_949, p950) -- name: UpdateSpectateUI
		-- upvalues: (ref) v_u_702, (ref) v_u_703, (copy) v_u_783, (ref) v_u_700, (ref) v_u_710, (ref) v_u_711, (ref) v_u_824
		if v_u_702 then
			v_u_702:Disconnect()
			v_u_702 = nil
		end
		if v_u_703 then
			v_u_703:Disconnect()
			v_u_703 = nil
		end
		v_u_783(p_u_949)
		local v951
		if p_u_949 then
			v951 = p_u_949:FindFirstChild("ServerData") or p_u_949:WaitForChild("ServerData", 10)
		else
			v951 = p_u_949
		end
		if v951 then
			v_u_703 = v951:GetAttributeChangedSignal("Device"):Connect(function()
				-- upvalues: (ref) v_u_700, (copy) p_u_949, (ref) v_u_783
				if v_u_700 == p_u_949 then
					v_u_783(p_u_949)
				end
			end)
		end
		if not p950 then
			if p_u_949 then
				p950 = p_u_949.Character
			else
				p950 = p_u_949
			end
		end
		if p_u_949 and p950 then
			local v952 = p950:FindFirstChildOfClass("Humanoid")
			if v952 then
				v_u_702 = v952.Died:Connect(function()
					-- upvalues: (ref) v_u_710, (ref) v_u_711, (ref) v_u_700, (copy) p_u_949, (ref) v_u_824
					task.delay(0.15, function()
						-- upvalues: (ref) v_u_710, (ref) v_u_711, (ref) v_u_700, (ref) p_u_949, (ref) v_u_824
						if v_u_710 == true or v_u_711 == true then
							return
						elseif v_u_700 == p_u_949 then
							v_u_824("Team")
						end
					end)
				end)
			end
		else
			return
		end
	end
	local function v_u_954() -- name: StopFreecamIfActive
		-- upvalues: (ref) v_u_20
		if v_u_20 and (v_u_20.IsActive and v_u_20.StopFreecam) then
			if v_u_20:IsActive() == true then
				v_u_20:StopFreecam()
			end
		end
	end
	local function v955() -- name: ReleaseSpectateMouse
		-- upvalues: (ref) v_u_2
		v_u_2.MouseIconEnabled = true
		v_u_2.MouseBehavior = Enum.MouseBehavior.Default
	end
	local function v_u_957() -- name: DisconnectReplaySoundConnections
		-- upvalues: (copy) v_u_719
		for _, v956 in ipairs(v_u_719) do
			if v956 then
				v956:Disconnect()
			end
		end
		table.clear(v_u_719)
	end
	local function v_u_960() -- name: RestoreReplaySounds
		-- upvalues: (copy) v_u_957, (copy) v_u_718
		v_u_957()
		for v958, v959 in pairs(v_u_718) do
			if v958 and (v958.Parent and v958:IsA("Sound")) then
				v958.Volume = v959
			end
		end
		table.clear(v_u_718)
	end
	local function v_u_967(p961) -- name: MuteReplayCharacterSounds
		-- upvalues: (copy) v_u_718, (copy) v_u_719
		if p961 then
			for _, v962 in ipairs(p961:GetDescendants()) do
				if v962:IsA("Sound") and v_u_718[v962] == nil then
					v_u_718[v962] = v962.Volume
					v962.Volume = 0
				end
			end
			local v963 = v_u_719
			local v964 = p961.DescendantAdded
			local function v966(p965)
				-- upvalues: (ref) v_u_718
				if p965:IsA("Sound") and v_u_718[p965] == nil then
					v_u_718[p965] = p965.Volume
					p965.Volume = 0
				end
			end
			table.insert(v963, v964:Connect(v966))
		end
	end
	local function v_u_972(p968, p969) -- name: GetReplayRelativePath
		local v970 = {}
		while p969 and p969 ~= p968 do
			local v971 = p969.Name
			table.insert(v970, 1, v971)
			p969 = p969.Parent
		end
		if p969 == p968 then
			return table.concat(v970, "/")
		else
			return nil
		end
	end
	local function v_u_977(p973) -- name: BuildReplayPartMap
		-- upvalues: (copy) v_u_972
		local v974 = {}
		for _, v975 in ipairs(p973:GetDescendants()) do
			if v975:IsA("BasePart") then
				local v976 = v_u_972(p973, v975)
				if v976 then
					v974[v976] = v975
				end
			end
		end
		return v974
	end
	local v978 = {
		["Camera"] = v_u_686,
		["Player"] = v_u_685,
		["CollectionService"] = v_u_3,
		["IsReplayKillCamActive"] = function() -- name: IsReplayKillCamActive
			-- upvalues: (ref) v_u_711
			return v_u_711 == true
		end
	}
	local v_u_979 = v_u_28.new(v978)
	local v_u_980 = v_u_27.new({
		["HideSpectatedInstanceTree"] = v_u_913,
		["ResetSpectatedInstanceTree"] = v_u_919
	})
	local v982 = {
		["ReplicatedStorage"] = nil,
		["Debris"] = nil,
		["ROUND_CACHE_FOLDER_NAME"] = "Round_Cache",
		["ResolveReplayActorRecord"] = nil,
		["ReplicatedStorage"] = v_u_4,
		["Debris"] = v_u_11,
		["ResolveReplayActorRecord"] = function(p981) -- name: ResolveReplayActorRecord
			-- upvalues: (copy) v_u_716
			return v_u_716[tonumber(p981) or 0]
		end
	}
	local v_u_983 = v_u_29.new(v982)
	local function v_u_984() -- name: ClearReplayActors
		-- upvalues: (ref) v_u_717, (copy) v_u_983, (copy) v_u_980, (ref) v_u_715, (ref) v_u_723, (copy) v_u_716
		if v_u_717 then
			v_u_717:Disconnect()
			v_u_717 = nil
		end
		v_u_983.Clear()
		v_u_980.Clear()
		if v_u_715 then
			v_u_715:Destroy()
			v_u_715 = nil
		end
		v_u_723 = 1
		table.clear(v_u_716)
	end
	local function v_u_991(p985, p986) -- name: FindReplayPrefabCharacterSource
		-- upvalues: (ref) v_u_39
		local v987 = v_u_39:FindFirstChild("ReplayPrefabs")
		if not v987 then
			return nil
		end
		if typeof(p985) == "number" and p985 > 0 then
			local v988 = v987:FindFirstChild((tostring(p985)))
			if v988 and v988:IsA("Model") then
				return v988
			end
			for _, v989 in ipairs(v987:GetChildren()) do
				if v989:IsA("Model") and tonumber(v989:GetAttribute("ReplayUserId")) == p985 then
					return v989
				end
			end
		end
		if typeof(p986) == "string" and p986 ~= "" then
			for _, v990 in ipairs(v987:GetChildren()) do
				if v990:IsA("Model") and (v990:GetAttribute("ReplayPlayerName") == p986 or v990.Name == p986) then
					return v990
				end
			end
		end
		return nil
	end
	local function v_u_999(p992, p993, p994) -- name: GetReplayCharacterSource
		-- upvalues: (copy) v_u_991
		local v995 = p994 and p994.Name
		if v995 then
			p993 = v995
		elseif p992 then
			p993 = p992.Name or p993
		end
		local v996 = p994 and p994.UserId or (p992 and (p992.UserId or 0) or 0)
		local v997 = v_u_991(v996, p993)
		if v997 then
			return v997
		end
		if p992 then
			p992 = p992.Character
		end
		local v998
		if p992 or not p993 then
			v998 = p992
		else
			v998 = workspace:FindFirstChild("Map_Cache")
			if v998 then
				v998 = v998:FindFirstChild(p993)
			end
			if v998 then
				if not v998:IsA("Model") then
					v998 = p992
				end
			else
				v998 = p992
			end
		end
		if not v998 then
			warn("[GameMenu] Replay character source missing", v996, p993 or "")
		end
		return v998
	end
	local function v_u_1003(p1000) -- name: GetReplayLoadout
		if p1000 then
			local v1001 = p1000:FindFirstChild("PlayerData")
			local v1002
			if v1001 then
				v1002 = v1001:FindFirstChild("Settings")
			else
				v1002 = v1001
			end
			if v1001 then
				v1001 = v1001:FindFirstChild("Loadout")
			end
			if v1002 then
				v1002 = v1002:GetAttribute("LoadoutName")
			end
			if typeof(v1002) == "string" and v1001 then
				return v1001:FindFirstChild(v1002) or v1001:FindFirstChild("Default")
			else
				return nil
			end
		else
			return nil
		end
	end
	local function v_u_1006(p1004) -- name: SanitizeReplayActorVisibility
		for _, v1005 in ipairs(p1004:GetDescendants()) do
			if v1005:IsA("BasePart") then
				v1005.CastShadow = false
				if v1005.Name == "HumanoidRootPart" then
					v1005.Transparency = 1
				else
					v1005.Transparency = 0
				end
				v1005.LocalTransparencyModifier = 0
			elseif v1005:IsA("Decal") or v1005:IsA("Texture") then
				v1005.Transparency = 0
			end
		end
	end
	local function v_u_1011(p1007) -- name: ClearReplayHeadCosmetics
		for _, v1008 in ipairs(p1007:GetChildren()) do
			if v1008:IsA("Accessory") or (v1008.Name == "Hat" or v1008.Name == "Hair") then
				v1008:Destroy()
			end
		end
		local v1009 = p1007:FindFirstChild("Head")
		if v1009 then
			v1009 = v1009:FindFirstChild("face")
		end
		if v1009 and v1009:IsA("Decal") then
			v1009:Destroy()
		end
		for _, v1010 in ipairs(p1007:GetDescendants()) do
			if v1010:IsA("Weld") and v1010.Name == "AccessoryWeld" then
				v1010:Destroy()
			end
		end
	end
	local function v_u_1025(p1012, p1013) -- name: ApplyReplayHeadCosmetics
		-- upvalues: (copy) v_u_1003, (ref) v_u_4, (copy) v_u_1011
		local v1014 = p1012:FindFirstChild("Head")
		if v1014 then
			local v1015 = v_u_1003(p1013)
			if v1015 then
				v1015 = v1015:GetAttribute("Head")
			end
			if typeof(v1015) == "string" and v1015 ~= "" then
				local v1016 = v_u_4.Items.Head:FindFirstChild(v1015)
				if v1016 then
					v_u_1011(p1012)
					for _, v1017 in ipairs(v1016:GetChildren()) do
						if v1017.Name == "Head" then
							local v1018 = v1017:FindFirstChild("face")
							if v1018 and v1018:IsA("Decal") then
								v1018:Clone().Parent = v1014
							end
						elseif v1017.Name == "Hat" or (v1017.Name == "Hair" or v1017:IsA("Accessory")) then
							local v_u_1019 = v1017:Clone()
							for _, v1020 in ipairs(v_u_1019:GetDescendants()) do
								if v1020:IsA("BasePart") then
									v1020.Anchored = false
									v1020.CanCollide = false
									v1020.CanTouch = false
									v1020.CanQuery = false
									v1020.AudioCanCollide = false
									v1020.CastShadow = false
									v1020.Massless = true
									v1020.Transparency = 0
									v1020.LocalTransparencyModifier = 0
								end
							end
							if v_u_1019:IsA("Accessory") then
								local v1021 = p1012:FindFirstChildOfClass("Humanoid")
								if v1021 then
									v1021:AddAccessory(v_u_1019)
								else
									v_u_1019.Parent = p1012
								end
							else
								v_u_1019.Parent = p1012
							end
							local v1022 = v_u_1019:FindFirstChild("Handle")
							if v1022 and v1022:IsA("BasePart") then
								local v_u_1023 = CFrame.new()
								pcall(function()
									-- upvalues: (ref) v_u_1023, (copy) v_u_1019
									v_u_1023 = v_u_1019.AttachmentPoint
								end)
								local v1024 = v1022:FindFirstChild("AccessoryWeld", true)
								if not v1024 then
									v1024 = Instance.new("Weld")
									v1024.Name = "AccessoryWeld"
									v1024.Parent = v1014
								end
								v1024.Part0 = v1022
								v1024.Part1 = v1014
								v1024.C0 = v_u_1023
								v1024.C1 = CFrame.new(0, 0.5, 0)
							end
						end
					end
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_1033(p1026, p1027, p1028) -- name: BuildReplayWeaponModel
		-- upvalues: (ref) v_u_4, (ref) v_u_14, (copy) v_u_1003, (ref) v_u_34
		if typeof(p1027) ~= "string" or p1027 == "" then
			return nil
		end
		if typeof(p1028) ~= "string" or p1028 == "" then
			return nil
		end
		local v1029
		if p1027 == "Primary" or p1027 == "Secondary" then
			v1029 = v_u_4.Items.Weapon:FindFirstChild(p1028)
		else
			v1029 = v_u_4.Items:FindFirstChild(p1027)
			if v1029 then
				v1029 = v1029:FindFirstChild(p1028)
			end
		end
		if not (v1029 and v1029:IsA("Model")) then
			return nil
		end
		local v1030 = v1029:Clone()
		v_u_14.WeldWeapon(v1030)
		if p1027 == "Primary" or p1027 == "Secondary" then
			if p1026 then
				v_u_14.SetFullAttachmentOnWeapon(v1030, p1026)
			end
			local v1031 = v_u_1003(p1026)
			if v1031 then
				v_u_14.SetAttachmentSkins(v1030, v1031, p1027)
			end
			local v1032 = not p1026 or v_u_34.FindToolByName(p1026, p1028)
			if not v1032 then
				if v_u_34.IsSupportedSlot(p1027) then
					v1032 = v_u_34.ResolveToolByClass(p1026, p1027)
				else
					v1032 = nil
				end
			end
			if v1032 then
				v1032 = v1032:GetAttribute("Skin")
			end
			if typeof(v1032) == "string" and v1032 ~= "" then
				v_u_14.SetSkinOnWep(v1030, v1032)
			end
			v_u_14.SetupWeaponEffects(v1030)
		end
		v_u_14.SetModelProperties(v1030, false, false)
		v1030.Name = p1028
		v1030:SetAttribute("Class", p1027)
		v1030:SetAttribute("ToolName", p1028)
		return v1030
	end
	local function v_u_1041(p1034, p1035, p1036) -- name: AttachReplayWeaponModel
		local v1037 = p1034:FindFirstChild("Right Arm")
		if not (v1037 and v1037:IsA("BasePart")) then
			p1035:Destroy()
			return nil
		end
		p1035.Parent = p1034
		local v1038 = Instance.new("Motor6D")
		local v1039 = p1035:FindFirstChild("Handle")
		if p1036 == "Primary" or p1036 == "Secondary" then
			if not (v1039 and v1039:IsA("BasePart")) then
				p1035:Destroy()
				return nil
			end
			v1038.Parent = v1039
			v1038.Part1 = v1039
		else
			local v1040 = p1035.PrimaryPart or p1035:FindFirstChildWhichIsA("BasePart")
			if not (v1040 and v1040:IsA("BasePart")) then
				p1035:Destroy()
				return nil
			end
			p1035.PrimaryPart = v1040
			v1038.Parent = v1040
			v1038.Part1 = v1040
		end
		v1038.Name = "Handle"
		v1038.Part0 = v1037
		v1038.C1 = CFrame.new(0.3, -0.4, 1) * CFrame.Angles(1.5707963267948966, 0, 0)
		return p1035
	end
	local function v_u_1048(p1042, p1043) -- name: SyncReplayActorWeapon
		-- upvalues: (copy) v_u_1033, (copy) v_u_1041
		if p1042 and p1042.Model then
			local v1044 = p1043 and (p1043.EquippedSlot or "") or ""
			local v1045 = p1043 and p1043.EquippedToolName or ""
			local v1046 = tostring(v1044) .. "|" .. tostring(v1045)
			if p1042.WeaponSignature == v1046 then
				return
			else
				p1042.WeaponSignature = v1046
				if p1042.WeaponModel and p1042.WeaponModel.Parent then
					p1042.WeaponModel:Destroy()
				end
				p1042.WeaponModel = nil
				if v1044 ~= "" and v1045 ~= "" then
					local v1047 = v_u_1033(p1042.Player, v1044, v1045)
					if v1047 then
						p1042.WeaponModel = v_u_1041(p1042.Model, v1047, v1044)
					end
				end
			end
		else
			return
		end
	end
	local function v_u_1058(p1049, p1050) -- name: BuildReplayActorClone
		-- upvalues: (copy) v_u_999, (ref) v_u_715, (copy) v_u_1025, (copy) v_u_1006
		local v1051 = p1050 and p1050.Name or (p1049 and (p1049.Name or "ReplayActor") or "ReplayActor")
		local v_u_1052 = v_u_999(p1049, v1051, p1050)
		if not v_u_1052 then
			return nil
		end
		local v1053, v1054 = pcall(function()
			-- upvalues: (copy) v_u_1052
			v_u_1052.Archivable = true
			return v_u_1052:Clone()
		end)
		if v1053 ~= true or not v1054 then
			return nil
		end
		for _, v1055 in ipairs(v1054:GetChildren()) do
			if v1055:IsA("Tool") then
				v1055:Destroy()
			end
		end
		local v1056 = v1054:FindFirstChild("ClientWeaponSystem")
		if v1056 then
			v1056 = v1056:FindFirstChild("ServerModels")
		end
		if v1056 then
			v1056:ClearAllChildren()
		end
		for _, v1057 in ipairs(v1054:GetDescendants()) do
			if v1057:IsA("BaseScript") or (v1057:IsA("LocalScript") or v1057:IsA("Script")) then
				v1057:Destroy()
			elseif v1057:IsA("BasePart") then
				v1057.Anchored = true
				v1057.CanCollide = false
				v1057.CanTouch = false
				v1057.CanQuery = false
				v1057.Massless = true
				v1057.LocalTransparencyModifier = 0
				if v1057.Name == "HumanoidRootPart" then
					v1057.Transparency = 1
				end
			elseif v1057:IsA("Humanoid") then
				v1057.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				v1057.HealthDisplayDistance = 0
				v1057.NameDisplayDistance = 0
				v1057.BreakJointsOnDeath = false
			end
		end
		v1054.Name = v1051 .. "_ReplayClone"
		v1054.Parent = v_u_715
		v_u_1025(v1054, p1049)
		v_u_1006(v1054)
		return v1054
	end
	local function v_u_1062(p1059, p1060) -- name: SetReplayActorLocalVisibility
		if p1059 then
			for _, v1061 in ipairs(p1059:GetDescendants()) do
				if v1061:IsA("BasePart") then
					v1061.LocalTransparencyModifier = p1060 and 0 or 1
				elseif v1061:IsA("Decal") or v1061:IsA("Texture") then
					v1061.Transparency = p1060 and 0 or 1
				elseif v1061:IsA("BillboardGui") or (v1061:IsA("SurfaceGui") or v1061:IsA("Highlight")) then
					v1061.Enabled = p1060
				end
			end
		end
	end
	local v_u_1063 = {}
	local function v_u_1077(p1064) -- name: configureReplayActorIdentity
		-- upvalues: (copy) v_u_685
		if p1064 and p1064.UserId == v_u_685.UserId then
			local v1065 = p1064.Model
			if v1065 and v1065.Parent ~= nil then
				local v1066 = v1065:FindFirstChild("Head")
				if v1066 then
					local v1067 = TEAM_IDENTITY_NAME
					local v1068 = typeof(v1067) == "string" and TEAM_IDENTITY_NAME ~= "" and (TEAM_IDENTITY_NAME or "ReplayTeamIdentity") or "ReplayTeamIdentity"
					local v1069 = v1066:FindFirstChild(v1068)
					if not v1069 then
						v1069 = script:FindFirstChild("SampleTeamIdentity")
						if v1069 then
							v1069 = v1069:Clone()
						end
						if not v1069 then
							return
						end
						v1069.Name = v1068
						v1069.Parent = v1066
					end
					v1069.Enabled = true
					v1069.AlwaysOnTop = true
					if not v1069:GetAttribute("ReplayYouScaleApplied") then
						local v1070 = UDim2.new
						local v1071 = v1069.Size.X.Scale * 1.5
						local v1072 = v1069.Size.X.Offset * 1.5
						local v1073 = math.round(v1072)
						local v1074 = v1069.Size.Y.Scale * 1.5
						local v1075 = v1069.Size.Y.Offset * 1.5
						v1069.Size = v1070(v1071, v1073, v1074, (math.round(v1075)))
						v1069:SetAttribute("ReplayYouScaleApplied", true)
					end
					local v_u_1076 = v1069:FindFirstChild("PlayerName")
					if v_u_1076 and v_u_1076:IsA("TextLabel") then
						v_u_1076.Text = "YOU"
						v_u_1076.TextColor3 = Color3.new(1, 1, 1)
						v_u_1076.Font = Enum.Font.Oswald
						pcall(function()
							-- upvalues: (copy) v_u_1076
							v_u_1076.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
						end)
					end
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_1083(p1078, p1079) -- name: configureReplayActorHighlight
		if p1078 and p1078.UserId ~= p1079.KillerUserId then
			local v1080 = p1079.KillerTeamName
			local v1081 = p1078.TeamName
			if typeof(v1080) == "string" and v1080 ~= "" then
				if typeof(v1081) == "string" and (v1081 ~= "" and v1081 ~= v1080) then
					local v1082 = p1078.Model
					if v1082 then
						v1082 = p1078.Model:FindFirstChild("ReplayEnemyHighlight")
					end
					if not v1082 then
						v1082 = Instance.new("Highlight")
						v1082.Name = "ReplayEnemyHighlight"
						v1082.Parent = p1078.Model
					end
					v1082.Adornee = p1078.Model
					v1082.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					v1082.FillTransparency = 1
					v1082.OutlineTransparency = 0.4
					v1082.OutlineColor = Color3.fromRGB(255, 70, 70)
					v1082.Enabled = true
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_1086(p1084, p1085) -- name: configureReplayActorPerspective
		-- upvalues: (copy) v_u_1062
		if p1084 and (p1084.Model and p1084.Model.Parent ~= nil) then
			if p1084.UserId == p1085.KillerUserId then
				v_u_1062(p1084.Model, false)
			end
		end
	end
	function v_u_1063.Configure(p1087, p1088) -- name: Configure
		-- upvalues: (copy) v_u_1077, (ref) v_u_33, (copy) v_u_1083, (copy) v_u_1086
		local v1089, v1090 = pcall(v_u_1077, p1087)
		if v1089 ~= true then
			v_u_33.Warn("[GameMenu] Replay actor identity setup failed", v1090)
		end
		local v1091, v1092 = pcall(v_u_1083, p1087, p1088)
		if v1091 ~= true then
			v_u_33.Warn("[GameMenu] Replay actor highlight setup failed", v1092)
		end
		local v1093, v1094 = pcall(v_u_1086, p1087, p1088)
		if v1093 ~= true then
			v_u_33.Warn("[GameMenu] Replay actor perspective setup failed", v1094)
		end
	end
	local function v_u_1103(p1095) -- name: GetReplayRagdollRigParts
		local v1096
		if p1095 then
			v1096 = p1095:FindFirstChild("Head")
		else
			v1096 = p1095
		end
		local v1097
		if p1095 then
			v1097 = p1095:FindFirstChild("Torso")
		else
			v1097 = p1095
		end
		local v1098
		if p1095 then
			v1098 = p1095:FindFirstChild("Left Arm")
		else
			v1098 = p1095
		end
		local v1099
		if p1095 then
			v1099 = p1095:FindFirstChild("Right Arm")
		else
			v1099 = p1095
		end
		local v1100
		if p1095 then
			v1100 = p1095:FindFirstChild("Left Leg")
		else
			v1100 = p1095
		end
		local v1101
		if p1095 then
			v1101 = p1095:FindFirstChild("Right Leg")
		else
			v1101 = p1095
		end
		local v1102
		if p1095 then
			v1102 = p1095:FindFirstChildOfClass("Humanoid")
		else
			v1102 = p1095
		end
		return v1096 and (v1097 and (v1098 and (v1099 and (v1100 and (v1101 and v1102))))) and {
			["head"] = v1096,
			["torso"] = v1097,
			["leftArm"] = v1098,
			["rightArm"] = v1099,
			["leftLeg"] = v1100,
			["rightLeg"] = v1101,
			["humanoid"] = v1102,
			["humanoidRootPart"] = p1095:FindFirstChild("HumanoidRootPart"),
			["parts"] = {
				v1097,
				v1096,
				v1098,
				v1099,
				v1100,
				v1101
			}
		} or nil
	end
	local function v_u_1111(p1104, p1105) -- name: ResolveReplayRagdollPushDirection
		local v1106
		if p1105 then
			v1106 = p1105.MotionProfile
		else
			v1106 = p1105
		end
		local v1107 = v1106 == "projectile_head" and p1104.head or p1104.torso
		if v1106 == "explosion" then
			local v1108
			if p1105 then
				v1108 = p1105.SourcePosition
			else
				v1108 = p1105
			end
			if typeof(v1108) == "Vector3" then
				local v1109 = v1107.Position - p1105.SourcePosition
				if v1109.Magnitude > 0 then
					return v1109.Unit
				end
				goto l12
			end
		end
		local v1110
		if p1105 then
			v1110 = p1105.PushDirection
		else
			v1110 = p1105
		end
		if typeof(v1110) == "Vector3" and p1105.PushDirection.Magnitude > 0 then
			return p1105.PushDirection.Unit
		end
		::l12::
		return nil
	end
	local function v_u_1141(p1112, p1113) -- name: ApplyReplayRagdollImpulse
		-- upvalues: (copy) v_u_1111, (ref) v_u_16
		local v1114
		if p1113 then
			v1114 = p1113.CarryVelocity
		else
			v1114 = p1113
		end
		local v1115 = typeof(v1114) == "Vector3" and (p1113.CarryVelocity or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0)
		local v1116 = v1115 * Vector3.new(1, 0, 1)
		if v1116.Magnitude > 52 then
			v1116 = v1116.Unit * 52
		end
		local v1117 = v1116.X
		local v1118 = v1115.Y
		local v1119 = v1116.Z
		local v1120 = Vector3.new(v1117, v1118, v1119)
		for _, v1121 in ipairs(p1112.parts) do
			if v1121 and v1121.Parent then
				v1121.AssemblyLinearVelocity = v1120
			end
		end
		local v1122 = p1113 and p1113.MotionProfile or (p1113 and p1113.HitPartName == "Head" and "projectile_head" or "projectile_body")
		local v1123 = v_u_1111(p1112, p1113)
		if v1123 then
			if v1122 == "projectile_head" then
				local v1124 = v_u_16.AllowWeaponKnockback
				if typeof(v1124) ~= "boolean" then
					v1124 = false
				end
				if v1124 == true then
					local v1125 = p1112.head
					local v1126 = v1125.AssemblyLinearVelocity
					local v1127 = v_u_16.RagdollHeadKnockback
					v1125.AssemblyLinearVelocity = v1126 + v1123 * (typeof(v1127) ~= "number" and 32 or v1127)
				end
			elseif v1122 == "projectile_body" then
				local v1128 = v_u_16.AllowWeaponKnockback
				if typeof(v1128) ~= "boolean" then
					v1128 = false
				end
				if v1128 == true then
					local v1129 = v_u_16.RagdollTorsoKnockback
					local v1130 = typeof(v1129) ~= "number" and 22 or v1129
					local v1131 = p1112.torso
					v1131.AssemblyLinearVelocity = v1131.AssemblyLinearVelocity + v1123 * v1130
					local v1132 = v1130 * 0.18
					for _, v1133 in ipairs({
						p1112.leftArm,
						p1112.rightArm,
						p1112.leftLeg,
						p1112.rightLeg
					}) do
						if v1133 and v1133.Parent then
							v1133.AssemblyLinearVelocity = v1133.AssemblyLinearVelocity + v1123 * v1132
						end
					end
				end
			else
				if v1122 == "explosion" then
					local v1134 = v_u_16.AllowExplosionKnockback
					if (typeof(v1134) ~= "boolean" and true or v1134) ~= true then
						return
					end
					local v1135 = v_u_16.RagdollExplosionKnockback
					local v1136 = v1123 * (typeof(v1135) ~= "number" and 90 or v1135)
					local v1137 = v_u_16.RagdollExplosionKnockbackY
					local v1138 = typeof(v1137) ~= "number" and 30 or v1137
					local v1139 = Vector3.new(0, v1138, 0)
					local v1140 = p1112.torso
					v1140.AssemblyLinearVelocity = v1140.AssemblyLinearVelocity + (v1136 + v1139)
				end
				return
			end
		else
			return
		end
	end
	local function v_u_1191(p1142, p1143) -- name: ActivateReplayActorRagdoll
		-- upvalues: (copy) v_u_1103, (copy) v_u_1141
		if p1142 and p1142.RagdollActive ~= true then
			if p1142.Model and p1142.Model.Parent ~= nil then
				local v_u_1144 = v_u_1103(p1142.Model)
				if v_u_1144 then
					p1142.RagdollActive = true
					if p1142.WeaponModel and p1142.WeaponModel.Parent then
						p1142.WeaponModel:Destroy()
					end
					p1142.WeaponModel = nil
					p1142.WeaponSignature = nil
					v_u_1144.humanoid.BreakJointsOnDeath = false
					v_u_1144.humanoid.AutoRotate = false
					v_u_1144.humanoid.PlatformStand = true
					local v1145 = {}
					local v1146 = v_u_1144.head
					local v1147 = v1146:FindFirstChild("HeadA")
					if not (v1147 and v1147:IsA("Attachment")) then
						v1147 = Instance.new("Attachment")
						v1147.Name = "HeadA"
						v1147.Parent = v1146
					end
					v1147.Position = Vector3.new(0, -0.5, 0)
					v1147.Rotation = Vector3.new(0, 0, -90)
					v1147.Axis = Vector3.new(0, -1, 0)
					v1147.SecondaryAxis = Vector3.new(1, 0, 0)
					v1145.HeadA = v1147
					local v1148 = v_u_1144.leftArm
					local v1149 = v1148:FindFirstChild("LeftArmA")
					if not (v1149 and v1149:IsA("Attachment")) then
						v1149 = Instance.new("Attachment")
						v1149.Name = "LeftArmA"
						v1149.Parent = v1148
					end
					v1149.Position = Vector3.new(0.5, 0.6, 0)
					v1149.Rotation = Vector3.new(0, 0, 0)
					v1149.Axis = Vector3.new(1, 0, 0)
					v1149.SecondaryAxis = Vector3.new(0, 1, 0)
					v1145.LeftArmA = v1149
					local v1150 = v_u_1144.leftLeg
					local v1151 = v1150:FindFirstChild("LeftLegA")
					if not (v1151 and v1151:IsA("Attachment")) then
						v1151 = Instance.new("Attachment")
						v1151.Name = "LeftLegA"
						v1151.Parent = v1150
					end
					v1151.Position = Vector3.new(0.1, 1, 0)
					v1151.Rotation = Vector3.new(0, 0, -90)
					v1151.Axis = Vector3.new(0, -1, 0)
					v1151.SecondaryAxis = Vector3.new(1, 0, 0)
					v1145.LeftLegA = v1151
					local v1152 = v_u_1144.rightArm
					local v1153 = v1152:FindFirstChild("RightArmA")
					if not (v1153 and v1153:IsA("Attachment")) then
						v1153 = Instance.new("Attachment")
						v1153.Name = "RightArmA"
						v1153.Parent = v1152
					end
					v1153.Position = Vector3.new(-0.5, 0.6, 0)
					v1153.Rotation = Vector3.new(-180, 0, -180)
					v1153.Axis = Vector3.new(-1, 0, 0)
					v1153.SecondaryAxis = Vector3.new(0, 1, 0)
					v1145.RightArmA = v1153
					local v1154 = v_u_1144.rightLeg
					local v1155 = v1154:FindFirstChild("RightLegA")
					if not (v1155 and v1155:IsA("Attachment")) then
						v1155 = Instance.new("Attachment")
						v1155.Name = "RightLegA"
						v1155.Parent = v1154
					end
					v1155.Position = Vector3.new(-0.1, 1, 0)
					v1155.Rotation = Vector3.new(0, 0, -90)
					v1155.Axis = Vector3.new(0, -1, 0)
					v1155.SecondaryAxis = Vector3.new(1, 0, 0)
					v1145.RightLegA = v1155
					local v1156 = v_u_1144.torso
					local v1157 = v1156:FindFirstChild("TorsoA")
					if not (v1157 and v1157:IsA("Attachment")) then
						v1157 = Instance.new("Attachment")
						v1157.Name = "TorsoA"
						v1157.Parent = v1156
					end
					v1157.Position = Vector3.new(0.4, -1, 0)
					v1157.Rotation = Vector3.new(0, 0, -90)
					v1157.Axis = Vector3.new(0, -1, 0)
					v1157.SecondaryAxis = Vector3.new(1, 0, 0)
					v1145.TorsoA = v1157
					local v1158 = v_u_1144.torso
					local v1159 = v1158:FindFirstChild("TorsoA1")
					if not (v1159 and v1159:IsA("Attachment")) then
						v1159 = Instance.new("Attachment")
						v1159.Name = "TorsoA1"
						v1159.Parent = v1158
					end
					v1159.Position = Vector3.new(-0.4, -1, 0)
					v1159.Rotation = Vector3.new(0, 0, -90)
					v1159.Axis = Vector3.new(0, -1, 0)
					v1159.SecondaryAxis = Vector3.new(1, 0, 0)
					v1145.TorsoA1 = v1159
					local v1160 = v_u_1144.torso
					local v1161 = v1160:FindFirstChild("TorsoA2")
					if not (v1161 and v1161:IsA("Attachment")) then
						v1161 = Instance.new("Attachment")
						v1161.Name = "TorsoA2"
						v1161.Parent = v1160
					end
					v1161.Position = Vector3.new(-1, 0.8, 0)
					v1161.Rotation = Vector3.new(0, 0, 0)
					v1161.Axis = Vector3.new(1, 0, 0)
					v1161.SecondaryAxis = Vector3.new(0, 1, 0)
					v1145.TorsoA2 = v1161
					local v1162 = v_u_1144.torso
					local v1163 = v1162:FindFirstChild("TorsoA3")
					if not (v1163 and v1163:IsA("Attachment")) then
						v1163 = Instance.new("Attachment")
						v1163.Name = "TorsoA3"
						v1163.Parent = v1162
					end
					v1163.Position = Vector3.new(1, 0.8, 0)
					v1163.Rotation = Vector3.new(180, 0, 180)
					v1163.Axis = Vector3.new(-1, 0, 0)
					v1163.SecondaryAxis = Vector3.new(0, 1, 0)
					v1145.TorsoA3 = v1163
					local v1164 = v_u_1144.torso
					local v1165 = v1164:FindFirstChild("TorsoA4")
					if not (v1165 and v1165:IsA("Attachment")) then
						v1165 = Instance.new("Attachment")
						v1165.Name = "TorsoA4"
						v1165.Parent = v1164
					end
					v1165.Position = Vector3.new(0, 1, 0)
					v1165.Rotation = Vector3.new(0, 0, -90)
					v1165.Axis = Vector3.new(0, -1, 0)
					v1165.SecondaryAxis = Vector3.new(1, 0, 0)
					v1145.TorsoA4 = v1165
					local v1166 = {}
					local v1167 = v_u_1144.head
					local v1168 = v1145.HeadA
					local v1169 = v1145.TorsoA4
					local v1170 = v1167:FindFirstChild("HeadConstraint")
					if not (v1170 and v1170:IsA("BallSocketConstraint")) then
						v1170 = Instance.new("BallSocketConstraint")
						v1170.Name = "HeadConstraint"
						v1170.Parent = v1167
					end
					v1170.Attachment0 = v1168
					v1170.Attachment1 = v1169
					v1170.Enabled = false
					v1170.LimitsEnabled = true
					v1170.Restitution = 0
					v1170.UpperAngle = 35
					v1170.TwistLimitsEnabled = true
					v1170.TwistLowerAngle = -20
					v1170.TwistUpperAngle = 20
					local v1171 = v_u_1144.leftArm
					local v1172 = v1145.LeftArmA
					local v1173 = v1145.TorsoA2
					local v1174 = v1171:FindFirstChild("LeftArmConstraint")
					if not (v1174 and v1174:IsA("BallSocketConstraint")) then
						v1174 = Instance.new("BallSocketConstraint")
						v1174.Name = "LeftArmConstraint"
						v1174.Parent = v1171
					end
					v1174.Attachment0 = v1172
					v1174.Attachment1 = v1173
					v1174.Enabled = false
					v1174.LimitsEnabled = true
					v1174.Restitution = 0
					v1174.UpperAngle = 55
					v1174.TwistLimitsEnabled = true
					v1174.TwistLowerAngle = -35
					v1174.TwistUpperAngle = 35
					local v1175 = v_u_1144.rightArm
					local v1176 = v1145.RightArmA
					local v1177 = v1145.TorsoA3
					local v1178 = v1175:FindFirstChild("RightArmConstraint")
					if not (v1178 and v1178:IsA("BallSocketConstraint")) then
						v1178 = Instance.new("BallSocketConstraint")
						v1178.Name = "RightArmConstraint"
						v1178.Parent = v1175
					end
					v1178.Attachment0 = v1176
					v1178.Attachment1 = v1177
					v1178.Enabled = false
					v1178.LimitsEnabled = true
					v1178.Restitution = 0
					v1178.UpperAngle = 55
					v1178.TwistLimitsEnabled = true
					v1178.TwistLowerAngle = -35
					v1178.TwistUpperAngle = 35
					local v1179 = v_u_1144.torso
					local v1180 = v1145.TorsoA1
					local v1181 = v1145.LeftLegA
					local v1182 = v1179:FindFirstChild("LeftLegConstraint")
					if not (v1182 and v1182:IsA("BallSocketConstraint")) then
						v1182 = Instance.new("BallSocketConstraint")
						v1182.Name = "LeftLegConstraint"
						v1182.Parent = v1179
					end
					v1182.Attachment0 = v1180
					v1182.Attachment1 = v1181
					v1182.Enabled = false
					v1182.LimitsEnabled = true
					v1182.Restitution = 0
					v1182.UpperAngle = 30
					v1182.TwistLimitsEnabled = true
					v1182.TwistLowerAngle = -15
					v1182.TwistUpperAngle = 15
					local v1183 = v_u_1144.torso
					local v1184 = v1145.TorsoA
					local v1185 = v1145.RightLegA
					local v1186 = v1183:FindFirstChild("RightLegConstraint")
					if not (v1186 and v1186:IsA("BallSocketConstraint")) then
						v1186 = Instance.new("BallSocketConstraint")
						v1186.Name = "RightLegConstraint"
						v1186.Parent = v1183
					end
					v1186.Attachment0 = v1184
					v1186.Attachment1 = v1185
					v1186.Enabled = false
					v1186.LimitsEnabled = true
					v1186.Restitution = 0
					v1186.UpperAngle = 30
					v1186.TwistLimitsEnabled = true
					v1186.TwistLowerAngle = -15
					v1186.TwistUpperAngle = 15
					__set_list(v1166, 1, {v1170, v1174, v1178, v1182, v1186})
					local v1187 = {}
					for _, v1188 in ipairs(v_u_1144.parts) do
						v1187[v1188] = true
					end
					for _, v1189 in ipairs(p1142.Model:GetDescendants()) do
						if v1189:IsA("Motor6D") then
							v1189:Destroy()
						elseif v1189:IsA("BasePart") then
							v1189.Anchored = false
							v1189.CanTouch = false
							v1189.CanQuery = false
							if v1187[v1189] == true then
								v1189.CanCollide = true
								v1189.Massless = false
							else
								v1189.CanCollide = false
								v1189.Massless = true
							end
						end
					end
					for _, v1190 in ipairs(v1166) do
						v1190.Enabled = true
					end
					if v_u_1144.humanoidRootPart and v_u_1144.humanoidRootPart.Parent then
						v_u_1144.humanoidRootPart:Destroy()
						v_u_1144.humanoidRootPart = nil
					end
					v_u_1144.humanoid.Health = 0
					pcall(function()
						-- upvalues: (copy) v_u_1144
						v_u_1144.humanoid:ChangeState(Enum.HumanoidStateType.Physics)
					end)
					v_u_1141(v_u_1144, p1143)
				end
			else
				return
			end
		else
			return
		end
	end
	local function v_u_1203(p1192, p1193) -- name: ResolveReplayActorSampleWindow
		if typeof(p1192) ~= "table" then
			return nil, nil, 0
		end
		local v1194 = p1192.Samples or {}
		local v1195 = v1194[1]
		local v1196 = v1195
		for v1197, v1198 in ipairs(v1194) do
			if (v1198.Time or 0) > p1193 then
				v1196 = v1198
				break
			end
			v1196 = v1194[v1197 + 1] or v1198
			v1195 = v1198
		end
		local v1199 = 0
		if v1195 and (v1196 and v1195 ~= v1196) then
			local v1200 = v1195.Time or 0
			local v1201 = v1196.Time or v1200
			if v1200 < v1201 then
				local v1202 = (p1193 - v1200) / (v1201 - v1200)
				v1199 = math.clamp(v1202, 0, 1)
			end
		end
		return v1195, v1196, v1199
	end
	local v_u_1204 = nil
	local function v_u_1219(p1205, p1206) -- name: UpdateReplayActors
		-- upvalues: (ref) v_u_433, (copy) v_u_716, (copy) v_u_1203, (copy) v_u_1048, (ref) v_u_1204
		for _, v1207 in ipairs((v_u_433(p1205))) do
			local v1208 = v_u_716[v1207.UserId]
			if v1208 and (v1208.Model and (v1208.Model.Parent and v1208.RagdollActive ~= true)) then
				local v1209, v1210, v1211 = v_u_1203(v1207, p1206)
				if v1209 then
					for v1212, v1213 in pairs(v1208.PartMap or {}) do
						if v1213 and v1213.Parent then
							local v1214 = v1209.PoseCFrames
							if v1214 then
								v1214 = v1209.PoseCFrames[v1212]
							end
							local v1215
							if v1210 and v1210.PoseCFrames then
								v1215 = v1210.PoseCFrames[v1212] or v1214
							else
								v1215 = v1214
							end
							if v1214 then
								if typeof(v1214) == "CFrame" then
									if typeof(v1215) == "CFrame" then
										v1214 = v1214:Lerp(v1215, (math.clamp(v1211 or 0, 0, 1)))
									end
								else
									v1214 = v1215
								end
								v1213.CFrame = v1214
							end
						end
					end
					v_u_1048(v1208, v1209)
					local v1216 = v1208.Humanoid
					if v1216 then
						local v1217 = v1209.Health
						if typeof(v1217) == "number" then
							local v1218 = v1209.Health
							v1216.Health = math.max(v1218, 0)
						end
					end
					v_u_1204(v1208, p1206)
				end
			end
		end
	end
	local function v_u_1229(p1220, p1221) -- name: ApplyReplayUiState
		-- upvalues: (copy) v_u_687, (copy) v_u_691, (ref) v_u_721, (ref) v_u_722, (copy) v_u_731, (ref) v_u_720
		local v1222 = v_u_687:FindFirstChild("GameHUD")
		local v1223
		if v1222 then
			v1223 = v1222:FindFirstChild("TopBorder")
		else
			v1223 = v1222
		end
		if v1222 then
			v1222 = v1222:FindFirstChild("ReplayKillCam")
		end
		local v1224 = v_u_691:FindFirstChild("Profile")
		if v1224 then
			v1224 = v_u_691.Profile:FindFirstChild("Title")
		end
		v_u_721 = v_u_721 or {}
		if v1223 and v_u_721.TopBorderVisible == nil then
			v_u_721.TopBorderVisible = v1223.Visible
		end
		if v1224 and v_u_721.ProfileTitleVisible == nil then
			v_u_721.ProfileTitleVisible = v1224.Visible
		end
		if v1222 and v_u_722 == nil then
			v_u_722 = v1222.Visible
		end
		v_u_731.Suppress()
		if v1223 then
			v1223.Visible = false
		end
		if v1222 then
			v1222.Visible = p1221 ~= true
		end
		if v1224 then
			v1224.Visible = false
		end
		if p1220 == "Round" then
			local v1225 = FrameMain
			if v1225 then
				v1225 = FrameMain:FindFirstChild("RoundEnd")
			end
			if v1225 then
				v_u_720 = v_u_720 or {}
				local v1226 = v1225:FindFirstChild("Banner")
				local v1227 = v1225:FindFirstChild("Background")
				local v1228 = v1225:FindFirstChild("Round")
				if v_u_720.FrameVisible == nil then
					v_u_720.FrameVisible = v1225.Visible
				end
				if v1226 and v_u_720.BannerVisible == nil then
					v_u_720.BannerVisible = v1226.Visible
				end
				if v1227 and v_u_720.BackgroundVisible == nil then
					v_u_720.BackgroundVisible = v1227.Visible
				end
				if v1228 and v_u_720.RoundVisible == nil then
					v_u_720.RoundVisible = v1228.Visible
				end
				v1225.Visible = false
				if v1226 then
					v1226.Visible = false
				end
				if v1227 then
					v1227.Visible = false
				end
				if v1228 then
					v1228.Visible = false
				end
			end
		end
	end
	local function v_u_1237() -- name: RestoreReplayUiState
		-- upvalues: (copy) v_u_687, (copy) v_u_691, (ref) v_u_721, (ref) v_u_722, (ref) v_u_720, (copy) v_u_731
		local v1230 = v_u_687:FindFirstChild("GameHUD")
		local v1231
		if v1230 then
			v1231 = v1230:FindFirstChild("TopBorder")
		else
			v1231 = v1230
		end
		if v1230 then
			v1230 = v1230:FindFirstChild("ReplayKillCam")
		end
		local v1232 = v_u_691:FindFirstChild("Profile")
		if v1232 then
			v1232 = v_u_691.Profile:FindFirstChild("Title")
		end
		if v_u_721 then
			if v1231 and v_u_721.TopBorderVisible ~= nil then
				v1231.Visible = v_u_721.TopBorderVisible
			end
			if v1232 and v_u_721.ProfileTitleVisible ~= nil then
				v1232.Visible = v_u_721.ProfileTitleVisible
			end
		end
		v_u_721 = nil
		if v1230 and v_u_722 ~= nil then
			v1230.Visible = v_u_722
		end
		v_u_722 = nil
		local v1233 = FrameMain
		if v1233 then
			v1233 = FrameMain:FindFirstChild("RoundEnd")
		end
		if v1233 and v_u_720 ~= nil then
			local v1234 = v1233:FindFirstChild("Banner")
			local v1235 = v1233:FindFirstChild("Background")
			local v1236 = v1233:FindFirstChild("Round")
			v1233.Visible = false
			if v1234 and v_u_720.BannerVisible ~= nil then
				v1234.Visible = v_u_720.BannerVisible
			end
			if v1235 and v_u_720.BackgroundVisible ~= nil then
				v1235.Visible = v_u_720.BackgroundVisible
			end
			if v1236 and v_u_720.RoundVisible ~= nil then
				v1236.Visible = v_u_720.RoundVisible
			end
		end
		v_u_720 = nil
		v_u_731.Restore()
	end
	local function v_u_1242(p1238, p1239) -- name: GetReplayEventActor
		-- upvalues: (copy) v_u_716
		local v1240 = v_u_716[tonumber(p1238) or 0]
		if not v1240 or (not v1240.Model or v1240.Model.Parent == nil) then
			return nil
		end
		if typeof(p1239) == "string" and p1239 ~= "" then
			local v1241 = v1240.Model:FindFirstChild(p1239, true)
			if v1241 and v1241:IsA("BasePart") then
				return v1241
			end
		end
		return v1240.Model
	end
	local function v_u_1246(p1243, p1244) -- name: ResolveReplayRelativeInstance
		if not p1243 or (typeof(p1244) ~= "string" or p1244 == "") then
			return nil
		end
		for v1245 in string.gmatch(p1244, "[^/]+") do
			if p1243 then
				p1243 = p1243:FindFirstChild(v1245)
			end
			if not p1243 then
				return nil
			end
		end
		return p1243
	end
	local function v_u_1251(p1247) -- name: ResolveReplayImpactMaterial
		if typeof(p1247) == "string" and p1247 ~= "" then
			local v_u_1248 = string.match(p1247, "([^%.]+)$") or p1247
			local v1249, v1250 = pcall(function()
				-- upvalues: (copy) v_u_1248
				return Enum.Material[v_u_1248]
			end)
			if v1249 == true and typeof(v1250) == "EnumItem" then
				return v1250
			else
				return Enum.Material.Concrete
			end
		else
			return Enum.Material.Concrete
		end
	end
	local function v_u_1262(p1252) -- name: ResolveReplayImpactTarget
		-- upvalues: (copy) v_u_1246, (copy) v_u_1242
		local v1253
		if p1252 then
			v1253 = p1252.TargetLocator
		else
			v1253 = p1252
		end
		if typeof(v1253) == "table" then
			if v1253.Kind == "Map" then
				local v1254 = v_u_1246(workspace:FindFirstChild("Map"), v1253.Path)
				if v1254 and v1254:IsA("BasePart") then
					return v1254
				end
			elseif v1253.Kind == "RoundCache" then
				local v1255 = v_u_1246(workspace:FindFirstChild("Round_Cache"), v1253.Path)
				if v1255 and v1255:IsA("BasePart") then
					return v1255
				end
			elseif v1253.Kind == "World" then
				local v1256 = v_u_1246(workspace, v1253.Path)
				if v1256 and v1256:IsA("BasePart") then
					return v1256
				end
				local v1257 = v1253.Name
				if typeof(v1257) == "string" and v1253.Name ~= "" then
					local v1258 = workspace:FindFirstChild(v1253.Name, true)
					if v1258 and v1258:IsA("BasePart") then
						return v1258
					end
				end
			end
		end
		local v1259 = v_u_1242(v1253 and v1253.UserId or p1252.TargetUserId, v1253 and v1253.HitPartName or p1252.HitPartName)
		if v1259 and v1259:IsA("BasePart") then
			return v1259
		end
		if not (v1259 and v1259:IsA("Model")) then
			return nil
		end
		local v1260 = v1253 and v1253.HitPartName or p1252.HitPartName
		if typeof(v1260) == "string" and v1260 ~= "" then
			local v1261 = v1259:FindFirstChild(v1260, true)
			if v1261 and v1261:IsA("BasePart") then
				return v1261
			end
		end
		return v1259:FindFirstChild("Torso") or (v1259:FindFirstChild("HumanoidRootPart") or v1259:FindFirstChildWhichIsA("BasePart", true))
	end
	local function v_u_1269(p1263, p1264) -- name: ResolveReplayActorSoundRoot
		if p1263 and p1263.WeaponModel then
			local v1265 = p1263.WeaponModel:FindFirstChild("Handle", true)
			if v1265 and v1265:IsA("BasePart") then
				return p1263.WeaponModel, v1265
			end
		end
		if p1263 and p1263.Model then
			if typeof(p1264) == "string" and p1264 ~= "" then
				local v1266 = p1263.Model:FindFirstChild(p1264, true)
				local v1267
				if v1266 then
					v1267 = v1266:FindFirstChild("Handle", true)
				else
					v1267 = v1266
				end
				if v1267 and v1267:IsA("BasePart") then
					return v1266, v1267
				end
			end
			local v1268 = p1263.Model:FindFirstChild("HumanoidRootPart")
			if v1268 and v1268:IsA("BasePart") then
				return p1263.Model, v1268
			end
		end
		return nil, nil
	end
	local function v_u_1276(p1270, p1271) -- name: PlayReplayActorSoundCue
		-- upvalues: (copy) v_u_1269, (ref) v_u_14
		local v1272
		if p1271 then
			v1272 = p1271.SoundName
		else
			v1272 = p1271
		end
		if typeof(v1272) == "string" and (v1272 ~= "" and (v1272 ~= "Fire" and v1272 ~= "Suppressor")) then
			local v1273, v1274 = v_u_1269(p1270, p1271.WeaponName)
			if v1273 and v1274 then
				local v1275 = v1273:FindFirstChild(v1272, true)
				if v1275 and v1275:IsA("Sound") then
					v_u_14.AddSFX(v1275, v1274, 1, true)
				end
			end
		else
			return
		end
	end
	local function v_u_1296(p1277, p1278) -- name: PlayReplayActorAudioCue
		-- upvalues: (copy) v_u_1269, (ref) v_u_11
		if typeof(p1278) == "table" then
			local v1279 = p1278.SoundId
			local v1280 = typeof(v1279) == "string" and (p1278.SoundId or "") or ""
			if v1280 == "" then
				return
			else
				local _, v1281 = v_u_1269(p1277, p1278.WeaponName)
				if v1281 then
					local v_u_1282 = Instance.new("Sound")
					local v1283 = p1278.SoundName
					v_u_1282.Name = typeof(v1283) == "string" and p1278.SoundName ~= "" and (p1278.SoundName or "ReplayActorAudioCue") or "ReplayActorAudioCue"
					v_u_1282.SoundId = v1280
					local v1284 = p1278.Volume
					local v1285 = tonumber(v1284) or 0.65
					v_u_1282.Volume = math.max(v1285, 0)
					local v1286 = p1278.PlaybackSpeed
					local v1287 = tonumber(v1286) or 1
					v_u_1282.PlaybackSpeed = math.max(v1287, 0.05)
					local v1288 = p1278.RollOffMinDistance
					local v1289 = tonumber(v1288) or 5
					v_u_1282.RollOffMinDistance = math.max(v1289, 0)
					local v1290 = p1278.RollOffMaxDistance
					local v1291 = tonumber(v1290) or 45
					local v1292 = v_u_1282.RollOffMinDistance
					v_u_1282.RollOffMaxDistance = math.max(v1291, v1292)
					v_u_1282.RollOffMode = Enum.RollOffMode.Inverse
					v_u_1282.Looped = p1278.Looped == true
					v_u_1282.Parent = v1281
					local v1293 = v_u_11
					local v1294
					if v_u_1282.Looped == true then
						v1294 = 8
					else
						local v1295 = v_u_1282.TimeLength + 2
						v1294 = math.max(v1295, 8)
					end
					v1293:AddItem(v_u_1282, v1294)
					pcall(function()
						-- upvalues: (copy) v_u_1282
						v_u_1282:Play()
					end)
				end
			end
		else
			return
		end
	end
	local function v_u_1302(p1297, p1298) -- name: PlayReplayActorImpact
		-- upvalues: (copy) v_u_1262, (ref) v_u_15, (copy) v_u_1251
		local v1299 = v_u_1262(p1298)
		if v1299 and v1299:IsA("BasePart") then
			local v1300 = p1298.Position
			if typeof(v1300) == "Vector3" then
				local v1301 = p1298.Normal
				if typeof(v1301) == "Vector3" then
					v_u_15.Hit(v1299, p1298.Position, p1298.Normal, v_u_1251(p1298.Material), p1298.Knife == true, not p1297 or p1297.Player or (p1297.Model or nil))
					return
				end
			end
		end
	end
	v_u_1204 = function(p1303, p1304)
		-- upvalues: (ref) v_u_14, (copy) v_u_1276, (copy) v_u_1296, (copy) v_u_1302
		local v1305
		if p1303 then
			v1305 = p1303.Events
		else
			v1305 = p1303
		end
		if typeof(v1305) ~= "table" then
			return
		end
		while p1303.EventCursor <= #v1305 do
			local v1306 = v1305[p1303.EventCursor]
			if not v1306 or p1304 < (v1306.Time or 0) then
				break
			end
			if v1306.Type == "Shoot" then
				if p1303 and (p1303.WeaponModel and p1303.WeaponModel.Parent) then
					v_u_14.MuzzleShootEffect(p1303.WeaponModel)
				end
			elseif v1306.Type == "SoundCue" then
				v_u_1276(p1303, v1306)
			elseif v1306.Type == "ReplayAudioCue" then
				v_u_1296(p1303, v1306)
			elseif v1306.Type == "Impact" then
				v_u_1302(p1303, v1306)
			end
			p1303.EventCursor = p1303.EventCursor + 1
		end
	end
	local function v1315(p1307, p1308) -- name: ProcessReplayEvents
		-- upvalues: (ref) v_u_723, (copy) v_u_1242, (ref) v_u_24, (copy) v_u_1191, (copy) v_u_716
		local v1309 = p1307.Events
		if not v1309 then
			v1309 = {}
		end
		while v_u_723 <= #v1309 and (v1309[v_u_723].Time or 0) <= p1308 do
			local v1310 = v1309[v_u_723]
			if v1310.Type == "VerifiedHit" then
				local v1311 = v_u_1242(v1310.TargetUserId, v1310.HitPartName)
				if v1311 then
					v_u_24.PlayHitHighlight(v1311)
				end
			elseif v1310.Type == "DamageTaken" then
				v_u_24.PlayDamagePulse()
			elseif v1310.Type == "ReplayDeath" then
				local v1312 = v_u_1191
				local v1313 = v_u_716
				local v1314 = v1310.TargetUserId
				v1312(v1313[tonumber(v1314) or 0], v1310)
			end
			v_u_723 = v_u_723 + 1
		end
	end
	local function v1360(p_u_1316, p1317, p1318) -- name: ApplyReplayIsolation
		-- upvalues: (copy) v_u_910, (copy) v_u_1229, (ref) v_u_717, (copy) v_u_983, (copy) v_u_980, (ref) v_u_715, (ref) v_u_723, (copy) v_u_716, (ref) v_u_433, (copy) v_u_684, (copy) v_u_1058, (copy) v_u_977, (copy) v_u_1063, (copy) v_u_913, (copy) v_u_967, (copy) v_u_932, (copy) v_u_705, (copy) v_u_1219
		v_u_910()
		local v1319
		if typeof(p1318) == "table" then
			v1319 = p1318.SuppressUiReveal == true
		else
			v1319 = false
		end
		v_u_1229(p1317, v1319)
		if v_u_717 then
			v_u_717:Disconnect()
			v_u_717 = nil
		end
		v_u_983.Clear()
		v_u_980.Clear()
		if v_u_715 then
			v_u_715:Destroy()
			v_u_715 = nil
		end
		v_u_723 = 1
		table.clear(v_u_716)
		v_u_715 = Instance.new("Folder")
		v_u_715.Name = "ReplayActors"
		v_u_715.Parent = workspace.CurrentCamera
		v_u_980.Build(workspace.CurrentCamera, p_u_1316)
		local v1320 = v_u_433(p_u_1316)
		if #v1320 <= 0 then
			local v1321 = warn
			local v1322 = "[GameMenu] Replay actor timeline list empty"
			local v1323
			if p_u_1316 then
				v1323 = p_u_1316.VictimUserId
			else
				v1323 = p_u_1316
			end
			local v1324 = tonumber(v1323) or 0
			local v1325 = #(p_u_1316 and (p_u_1316.NearbyActors or {}) or {})
			local v1326
			if p_u_1316 then
				v1326 = p_u_1316.KillerTimeline ~= nil
			else
				v1326 = p_u_1316
			end
			v1321(v1322, v1324, v1325, v1326)
		end
		for _, v1327 in ipairs(v1320) do
			local v1328 = v_u_684:GetPlayerByUserId(v1327.UserId)
			local v1329 = v_u_1058(v1328, v1327)
			if v1329 then
				local v1330 = {
					["Player"] = nil,
					["UserId"] = nil,
					["TeamName"] = nil,
					["Model"] = nil,
					["Humanoid"] = nil,
					["PartMap"] = nil,
					["WeaponModel"] = nil,
					["WeaponSignature"] = nil,
					["Events"] = nil,
					["EventCursor"] = 1,
					["RagdollActive"] = false,
					["Player"] = v1328,
					["UserId"] = v1327.UserId,
					["TeamName"] = v1327.TeamName,
					["Model"] = v1329,
					["Humanoid"] = v1329:FindFirstChildOfClass("Humanoid"),
					["PartMap"] = v_u_977(v1329)
				}
				local v1331 = v1327.Events
				v1330.Events = typeof(v1331) == "table" and (v1327.Events or {}) or {}
				v_u_716[v1327.UserId] = v1330
				v_u_1063.Configure(v1330, p_u_1316)
			else
				local v1332 = warn
				local v1333 = v1327.UserId
				local v1334 = v1327.Name
				local v1335 = v1328 ~= nil
				local v1336 = v1327.Samples
				v1332("[GameMenu] Replay actor clone skipped", v1333, v1334, v1335, typeof(v1336) == "table" and (#v1327.Samples or 0) or 0)
			end
		end
		for _, v_u_1337 in ipairs(v_u_684:GetPlayers()) do
			if v_u_1337.Character then
				local v1338 = v_u_1337.Character
				if v1338 then
					v_u_913(v1338)
				end
				v_u_967(v_u_1337.Character)
				local v1339 = v_u_1337.UserId
				local v1340 = tonumber(v1339)
				local v1341 = p_u_1316.KillerUserId
				if v1340 == tonumber(v1341) then
					v_u_932(v_u_1337.Character, {
						["PersistDuringReplay"] = true
					})
				end
			end
			local v1342 = v_u_705
			local v1343 = v_u_1337.CharacterAdded
			local function v1348(p1344)
				-- upvalues: (ref) v_u_913, (ref) v_u_967, (copy) v_u_1337, (copy) p_u_1316
				if p1344 then
					v_u_913(p1344)
				end
				v_u_967(p1344)
				local v1345 = v_u_1337.UserId
				local v1346 = tonumber(v1345)
				local v1347 = p_u_1316.KillerUserId
				if v1346 == tonumber(v1347) then
					v_u_913(p1344)
				end
			end
			table.insert(v1342, v1343:Connect(v1348))
		end
		local v1349 = workspace:FindFirstChild("Map_Cache")
		if v1349 then
			v_u_913(v1349)
			local v1350 = v_u_705
			local v1351 = v1349.DescendantAdded
			local function v1353(p1352)
				-- upvalues: (ref) v_u_913
				v_u_913(p1352)
			end
			table.insert(v1350, v1351:Connect(v1353))
		end
		local v1354 = workspace:FindFirstChild("Round_Cache")
		if v1354 then
			v_u_913(v1354)
			local v1355 = v_u_705
			local v1356 = v1354.DescendantAdded
			local function v1358(p1357)
				-- upvalues: (ref) v_u_913
				v_u_913(p1357)
			end
			table.insert(v1355, v1356:Connect(v1358))
		end
		local v1359 = workspace.CurrentCamera
		if v1359 then
			v1359 = v1359:FindFirstChild("CameraModel")
		end
		if v1359 then
			v_u_913(v1359)
		end
		v_u_983.Build(workspace.CurrentCamera, p_u_1316)
		v_u_1219(p_u_1316, 0)
		v_u_980.Update(0)
		v_u_983.Update(0)
	end
	local function v1391() -- name: RestoreReplayIsolation
		-- upvalues: (copy) v_u_984, (copy) v_u_919, (copy) v_u_960, (copy) v_u_945, (copy) v_u_948, (copy) v_u_1237, (ref) v_u_809
		local v1361 = {}
		local v1362 = v_u_984
		local v1363, v1364 = pcall(v1362)
		if v1363 ~= true then
			local v1365 = "ClearReplayActors" .. ": " .. tostring(v1364)
			table.insert(v1361, v1365)
		end
		local function v1367()
			-- upvalues: (ref) v_u_919
			local v1366 = workspace:FindFirstChild("Round_Cache")
			if v1366 then
				v_u_919(v1366)
			end
		end
		local v1368, v1369 = pcall(v1367)
		if v1368 ~= true then
			local v1370 = "RestoreReplayRoundCache" .. ": " .. tostring(v1369)
			table.insert(v1361, v1370)
		end
		local v1371 = v_u_960
		local v1372, v1373 = pcall(v1371)
		if v1372 ~= true then
			local v1374 = "RestoreReplaySounds" .. ": " .. tostring(v1373)
			table.insert(v1361, v1374)
		end
		local v1375 = v_u_945
		local v1376, v1377 = pcall(v1375)
		if v1376 ~= true then
			local v1378 = "ResetSpectatedTransparency" .. ": " .. tostring(v1377)
			table.insert(v1361, v1378)
		end
		local v1379 = v_u_948
		local v1380, v1381 = pcall(v1379)
		if v1380 ~= true then
			local v1382 = "ResetSpectatedHumanoidDisplay" .. ": " .. tostring(v1381)
			table.insert(v1361, v1382)
		end
		local v1383 = v_u_1237
		local v1384, v1385 = pcall(v1383)
		if v1384 ~= true then
			local v1386 = "RestoreReplayUiState" .. ": " .. tostring(v1385)
			table.insert(v1361, v1386)
		end
		if v_u_809 then
			local v1387 = v_u_809
			local v1388, v1389 = pcall(v1387)
			if v1388 ~= true then
				local v1390 = "RefreshNextCrate" .. ": " .. tostring(v1389)
				table.insert(v1361, v1390)
			end
		end
		if #v1361 > 0 then
			warn("[GameMenu] Replay cleanup error", table.concat(v1361, " | "))
		end
	end
	local v_u_1392 = nil
	local function v_u_1393() -- name: BuildReleaseMenuCameraArgs
		-- upvalues: (ref) v_u_709, (ref) v_u_710, (ref) v_u_711, (ref) v_u_25, (copy) v_u_689, (ref) v_u_700, (copy) v_u_685, (copy) v_u_819, (copy) v_u_816, (copy) v_u_739, (copy) v_u_954, (copy) v_u_829, (ref) v_u_46, (ref) v_u_67, (copy) v_u_686, (copy) v_u_738
		return {
			["MenuCameraActive"] = v_u_709,
			["KillCamActive"] = v_u_710,
			["ReplayKillCamActive"] = v_u_711,
			["HasMenuCameraFrameVisible"] = v_u_25.HasMenuCameraFrameVisible(v_u_689),
			["SpectatingPlayer"] = v_u_700,
			["Player"] = v_u_685,
			["IsAlive"] = v_u_819,
			["ClearMenuCameraState"] = v_u_816,
			["StopThirdPersonOrbit"] = function() -- name: StopThirdPersonOrbit
				-- upvalues: (ref) v_u_739
				v_u_739.StopOrbit()
			end,
			["StopFreecamIfActive"] = v_u_954,
			["UpdateFirstPersonSpectateTarget"] = v_u_829,
			["SetFirstPersonSpectateCameraActive"] = v_u_46,
			["RestoreSpectateCoreGuiState"] = v_u_67,
			["Camera"] = v_u_686,
			["DefaultFOV"] = v_u_738,
			["RestoreThirdPersonSpectateCameraControls"] = function() -- name: RestoreThirdPersonSpectateCameraControls
				-- upvalues: (ref) v_u_739
				v_u_739.RestoreCameraControls()
			end
		}
	end
	local function v1395() -- name: BuildMenuCameraSpectateStateArgs
		-- upvalues: (copy) v_u_1393, (copy) v_u_689, (ref) v_u_823, (ref) v_u_39, (ref) v_u_824
		local v1394 = v_u_1393()
		v1394.GameMenu = v_u_689
		v1394.SpectateMap = v_u_823
		v1394.ServerFolder = v_u_39
		v1394.Spectate = v_u_824
		return v1394
	end
	local function v1397(p1396) -- name: StopReplayKillCam
		-- upvalues: (ref) v_u_1392, (ref) v_u_30
		if v_u_1392 ~= nil then
			return v_u_30.StopReplayKillCam(v_u_1392, p1396)
		end
	end
	local function v1402(p1398, p1399, p1400, p1401) -- name: StartReplayKillCam
		-- upvalues: (ref) v_u_1392, (ref) v_u_30
		if v_u_1392 == nil then
			return false
		else
			return v_u_30.StartReplayKillCam(v_u_1392, p1398, p1399, p1400, p1401)
		end
	end
	local function v_u_1410(p1403, p1404)
		-- upvalues: (ref) v_u_711, (ref) v_u_33, (ref) v_u_713, (copy) v_u_739, (ref) v_u_20, (ref) v_u_2, (ref) v_u_701, (ref) v_u_710, (ref) v_u_702, (ref) v_u_703, (copy) v_u_945, (copy) v_u_948, (ref) v_u_39, (ref) v_u_35, (copy) v_u_685, (ref) v_u_37, (ref) v_u_43, (copy) v_u_742, (ref) v_u_44, (ref) v_u_708, (ref) v_u_709, (ref) v_u_700, (ref) v_u_732, (copy) v_u_691, (copy) v_u_783, (ref) v_u_809, (copy) v_u_686, (copy) v_u_738
		if v_u_711 == true and p1404 ~= true then
			v_u_33.Warn("[GameMenu] Block live spectate teardown during replay", p1403 or "Unknown", v_u_713)
		else
			v_u_739.StopOrbit()
			if v_u_20 and (v_u_20.IsActive and (v_u_20.StopFreecam and v_u_20:IsActive() == true)) then
				v_u_20:StopFreecam()
			end
			v_u_739.RestoreCameraControls()
			v_u_2.MouseIconEnabled = true
			v_u_2.MouseBehavior = Enum.MouseBehavior.Default
			v_u_739.StopOrbit()
			v_u_739.StopOrbit()
			v_u_701 = v_u_701 + 1
			v_u_710 = false
			if v_u_702 then
				v_u_702:Disconnect()
				v_u_702 = nil
			end
			if v_u_703 then
				v_u_703:Disconnect()
				v_u_703 = nil
			end
			v_u_945()
			v_u_948()
			local v_u_1405 = nil
			local v1406 = v_u_39:GetAttribute("GameMode")
			local v1407
			if v1406 == "Custom" then
				v1407 = v_u_39:GetAttribute("SpectateFirstPerson") == true
			else
				v1407 = false
			end
			local _ = v_u_35.ResolveSpectateMode(v1406, v1407) == v_u_35.SpectateModes.FirstPerson == true
			pcall(function()
				-- upvalues: (ref) v_u_37, (ref) v_u_1405
				v_u_37:FireServer(v_u_1405)
			end)
			if v_u_43.SetDamageFeedSourcePlayer then
				v_u_43.SetDamageFeedSourcePlayer(v_u_685)
			end
			v_u_742:Stop(p1404 == true and tostring(p1403 or "ReplayTeardown") or tostring(p1403 or "LiveSpectateTeardown"))
			v_u_44:SetAttribute("FirstPersonSpectateActive", false)
			if v_u_708 then
				v_u_708:Cancel()
				v_u_708 = nil
			end
			v_u_709 = false
			v_u_700 = nil
			v_u_43.CurrentSpectatingPlayer = nil
			v_u_732 = true
			v_u_691.Visible = false
			v_u_732 = false
			v_u_783()
			if v_u_809 then
				v_u_809()
			end
			local v1408 = v_u_686
			local v1409 = v_u_685:FindFirstChild("PlayerData")
			if v1409 then
				v1409 = v1409:FindFirstChild("Settings")
			end
			if v1409 then
				v1409 = tonumber(v1409:GetAttribute("FieldOfView"))
			end
			v1408.FieldOfView = v1409 or v_u_738
			v_u_686.CameraSubject = nil
		end
	end
	local function v_u_1412(p1411)
		-- upvalues: (ref) v_u_724
		v_u_724 = p1411 == true
	end
	local function v_u_1414(p1413)
		-- upvalues: (copy) v_u_686, (ref) v_u_724, (ref) v_u_1410
		if v_u_686:GetAttribute("FirstPersonSpectateActive") ~= true then
			v_u_724 = false
			return false
		end
		v_u_724 = true
		v_u_1410(p1413 or "ReplayStartDetach", true)
		return true
	end
	function ForceShutdownFirstPersonSpectateForReplay(p1415)
		-- upvalues: (copy) v_u_686, (ref) v_u_39, (ref) v_u_35, (ref) v_u_700, (ref) v_u_724, (copy) v_u_742, (copy) v_u_739, (ref) v_u_20, (ref) v_u_2, (ref) v_u_701, (ref) v_u_710, (ref) v_u_702, (ref) v_u_703, (copy) v_u_945, (copy) v_u_948, (copy) v_u_685, (ref) v_u_37, (ref) v_u_43, (ref) v_u_44, (ref) v_u_708, (ref) v_u_709, (ref) v_u_732, (copy) v_u_691, (copy) v_u_783, (ref) v_u_809, (copy) v_u_738
		local v1416
		if v_u_686:GetAttribute("FirstPersonSpectateActive") == true then
			v1416 = true
		else
			v1416 = false
			local v1417 = v_u_39:GetAttribute("GameMode")
			local v1418
			if v1417 == "Custom" then
				v1418 = v_u_39:GetAttribute("SpectateFirstPerson") == true
			else
				v1418 = false
			end
			if v_u_35.ResolveSpectateMode(v1417, v1418) == v_u_35.SpectateModes.FirstPerson == true then
				v1416 = v_u_700 ~= nil
			end
		end
		if v1416 ~= true then
			v_u_724 = false
			return false
		end
		v_u_724 = true
		if v_u_742 and v_u_742.PrepareReplayTakeover then
			v_u_742:PrepareReplayTakeover(p1415 or "ReplayTakeover")
		end
		v_u_739.StopOrbit()
		if v_u_20 and (v_u_20.IsActive and (v_u_20.StopFreecam and v_u_20:IsActive() == true)) then
			v_u_20:StopFreecam()
		end
		v_u_739.RestoreCameraControls()
		v_u_2.MouseIconEnabled = true
		v_u_2.MouseBehavior = Enum.MouseBehavior.Default
		v_u_739.StopOrbit()
		v_u_739.StopOrbit()
		v_u_701 = v_u_701 + 1
		v_u_710 = false
		if v_u_702 then
			v_u_702:Disconnect()
			v_u_702 = nil
		end
		if v_u_703 then
			v_u_703:Disconnect()
			v_u_703 = nil
		end
		if v_u_742 then
			v_u_742:Stop("ReplayFirstPersonForceShutdown")
		end
		v_u_945()
		v_u_948()
		local v_u_1419 = nil
		local v1420 = v_u_39:GetAttribute("GameMode")
		local v1421
		if v1420 == "Custom" then
			v1421 = v_u_39:GetAttribute("SpectateFirstPerson") == true
		else
			v1421 = false
		end
		local _ = v_u_35.ResolveSpectateMode(v1420, v1421) == v_u_35.SpectateModes.FirstPerson == true
		pcall(function()
			-- upvalues: (ref) v_u_37, (ref) v_u_1419
			v_u_37:FireServer(v_u_1419)
		end)
		if v_u_43.SetDamageFeedSourcePlayer then
			v_u_43.SetDamageFeedSourcePlayer(v_u_685)
		end
		v_u_44:SetAttribute("FirstPersonSpectateActive", false)
		v_u_44:SetAttribute("ThirdPersonSpectateOrbitActive", false)
		if v_u_708 then
			v_u_708:Cancel()
			v_u_708 = nil
		end
		v_u_709 = false
		v_u_700 = nil
		v_u_43.CurrentSpectatingPlayer = nil
		v_u_732 = true
		v_u_691.Visible = false
		v_u_732 = false
		v_u_783()
		if v_u_809 then
			v_u_809()
		end
		local v1422 = v_u_686
		local v1423 = v_u_685:FindFirstChild("PlayerData")
		if v1423 then
			v1423 = v1423:FindFirstChild("Settings")
		end
		if v1423 then
			v1423 = tonumber(v1423:GetAttribute("FieldOfView"))
		end
		v1422.FieldOfView = v1423 or v_u_738
		v_u_686.CameraSubject = nil
		return true
	end
	local function v_u_1427(p1424)
		-- upvalues: (ref) v_u_711, (ref) v_u_712, (ref) v_u_1392, (ref) v_u_30, (ref) v_u_1410
		local v1425
		if v_u_711 == true then
			v1425 = v_u_712 ~= true
		else
			v1425 = false
		end
		if v1425 ~= true or typeof(p1424) == "table" and p1424.AllowReplayTeardown == true then
			if v_u_711 == true then
				local v1426
				if typeof(p1424) == "table" then
					v1426 = p1424.KeepFrameVisible == true
				else
					v1426 = false
				end
				if v_u_1392 ~= nil then
					v_u_30.StopReplayKillCam(v_u_1392, v1426)
				end
			end
			v_u_1410()
		end
	end
	v_u_1392 = {
		["Players"] = v_u_684,
		["Player"] = v_u_685,
		["ServerFolder"] = v_u_39,
		["Camera"] = v_u_686,
		["DefaultFOV"] = v_u_738,
		["RunService"] = v_u_8,
		["GameMenuCameraSupport"] = v_u_25,
		["SpectateObserver"] = v_u_742,
		["ReplayBarricadeController"] = v_u_980,
		["ReplayThrowableController"] = v_u_983,
		["QueuePostDeathTransition"] = v760,
		["PlayScreenTransition"] = v_u_43.PlayScreenTransition,
		["ClearMenuCameraState"] = v_u_816,
		["ReleaseSpectateMouse"] = v955,
		["ApplySpectateCoreGuiState"] = v_u_62,
		["SetFrameVisible"] = v785,
		["SetSpectatingPlayer"] = function(p1428) -- name: SetSpectatingPlayer
			-- upvalues: (ref) v_u_700, (ref) v_u_43
			v_u_700 = p1428
			v_u_43.CurrentSpectatingPlayer = p1428
		end,
		["RefreshSpectatorUI"] = v_u_815,
		["SetSpectatorHeader"] = function(p1429, p1430, p1431) -- name: SetSpectatorHeader
			-- upvalues: (copy) v_u_691, (ref) v_u_749, (copy) v_u_783
			if v_u_691:FindFirstChild("Profile") and v_u_691.Profile:FindFirstChild("Title") then
				v_u_691.Profile.Title.Text = p1429
				v_u_691.Profile.Title.TextColor3 = p1430
			end
			v_u_749 = p1431 == true
			v_u_783()
		end,
		["ApplyReplayIsolation"] = v1360,
		["RevealReplayUiState"] = function() -- name: RevealReplayUiState
			-- upvalues: (copy) v_u_687
			local v1432 = v_u_687:FindFirstChild("GameHUD")
			if v1432 then
				v1432 = v1432:FindFirstChild("ReplayKillCam")
			end
			if v1432 then
				v1432.Visible = true
			end
		end,
		["UpdateSpectateUI"] = v_u_953,
		["TeardownLiveSpectateControllers"] = v_u_1410,
		["SpectateMap"] = function() -- name: SpectateMap
			-- upvalues: (ref) v_u_823
			local v1433 = v_u_823
			if typeof(v1433) == "function" then
				v_u_823()
			end
		end,
		["Spectate"] = function(p1434) -- name: Spectate
			-- upvalues: (ref) v_u_824
			local v1435 = v_u_824
			if typeof(v1435) == "function" then
				v_u_824(p1434)
			end
		end,
		["BuildReleaseMenuCameraArgs"] = v_u_1393,
		["GetReplayKillCamActive"] = function() -- name: GetReplayKillCamActive
			-- upvalues: (ref) v_u_711
			return v_u_711 == true
		end,
		["SetReplayKillCamActive"] = function(p1436) -- name: SetReplayKillCamActive
			-- upvalues: (ref) v_u_711, (ref) v_u_979
			v_u_711 = p1436 == true
			if v_u_979 then
				v_u_979.Refresh()
			end
		end,
		["GetReplayKillCamAllowMapSpectate"] = function() -- name: GetReplayKillCamAllowMapSpectate
			-- upvalues: (ref) v_u_712
			return v_u_712 == true
		end,
		["SetReplayKillCamAllowMapSpectate"] = function(p1437) -- name: SetReplayKillCamAllowMapSpectate
			-- upvalues: (ref) v_u_712
			v_u_712 = p1437 == true
		end,
		["CancelPostDeathTransitionForReplay"] = v753,
		["GetReplayKillCamToken"] = function() -- name: GetReplayKillCamToken
			-- upvalues: (ref) v_u_713
			return v_u_713
		end,
		["IncrementReplayKillCamToken"] = function() -- name: IncrementReplayKillCamToken
			-- upvalues: (ref) v_u_713
			v_u_713 = v_u_713 + 1
			return v_u_713
		end,
		["GetReplayKillCamStartedAt"] = function() -- name: GetReplayKillCamStartedAt
			-- upvalues: (ref) v_u_714
			return v_u_714
		end,
		["SetReplayKillCamStartedAt"] = function(p1438) -- name: SetReplayKillCamStartedAt
			-- upvalues: (ref) v_u_714
			v_u_714 = tonumber(p1438) or 0
		end,
		["SetReplayStartupInProgress"] = function(p1439) -- name: SetReplayStartupInProgress
			-- upvalues: (ref) v_u_725
			v_u_725 = p1439 == true
		end,
		["GetReplayStartupInProgress"] = function() -- name: GetReplayStartupInProgress
			-- upvalues: (ref) v_u_725
			return v_u_725 == true
		end,
		["GetReplayActorConnection"] = function() -- name: GetReplayActorConnection
			-- upvalues: (ref) v_u_717
			return v_u_717
		end,
		["SetReplayActorConnection"] = function(p1440) -- name: SetReplayActorConnection
			-- upvalues: (ref) v_u_717
			v_u_717 = p1440
		end,
		["SetReplayEventCursor"] = function(p1441) -- name: SetReplayEventCursor
			-- upvalues: (ref) v_u_723
			v_u_723 = p1441
		end,
		["ResolveReplayActorRecord"] = function(p1442) -- name: ResolveReplayActorRecord
			-- upvalues: (copy) v_u_716
			return v_u_716[tonumber(p1442) or 0]
		end,
		["RestoreReplayIsolation"] = v1391,
		["ResetSpectatorHeader"] = function() -- name: ResetSpectatorHeader
			-- upvalues: (ref) v_u_724, (copy) v_u_691, (ref) v_u_749, (copy) v_u_783
			if v_u_724 ~= true then
				local v1443 = Color3.fromRGB(255, 255, 255)
				if v_u_691:FindFirstChild("Profile") and v_u_691.Profile:FindFirstChild("Title") then
					v_u_691.Profile.Title.Text = "You are spectating"
					v_u_691.Profile.Title.TextColor3 = v1443
				end
				v_u_749 = true
				v_u_783()
			end
		end,
		["UpdateReplayActors"] = v_u_1219,
		["ProcessReplayEvents"] = v1315,
		["SetReplayStartupSpectateDetachActive"] = function(p1444) -- name: SetReplayStartupSpectateDetachActive
			-- upvalues: (ref) v_u_1412
			v_u_1412(p1444)
		end,
		["PrepareReplayStartupSpectateDetach"] = function(p1445) -- name: PrepareReplayStartupSpectateDetach
			-- upvalues: (ref) v_u_1414
			return v_u_1414(p1445)
		end,
		["ForceShutdownFirstPersonSpectateForReplay"] = function(p1446) -- name: ForceShutdownFirstPersonSpectateForReplay
			return ForceShutdownFirstPersonSpectateForReplay(p1446)
		end
	}
	local function v1447() -- name: HasActiveSpectateController
		-- upvalues: (ref) v_u_700, (ref) v_u_710, (ref) v_u_711, (copy) v_u_739, (ref) v_u_44, (ref) v_u_709
		return (v_u_700 ~= nil or (v_u_710 == true or (v_u_711 == true or (v_u_739.HasSpectateRender() == true or v_u_739.HasKillCamRender() == true)))) and true or (v_u_44:GetAttribute("FirstPersonSpectateActive") == true == true and true or (v_u_44:GetAttribute("ThirdPersonSpectateOrbitActive") == true == true and true or v_u_709 == true))
	end
	v_u_43.TeardownSpectateControllers = v_u_1427
	v_u_43.HasActiveSpectateController = v1447
	v_u_823 = function()
		-- upvalues: (ref) v_u_711, (ref) v_u_712, (ref) v_u_1427, (copy) v_u_819, (copy) v_u_685, (ref) v_u_62, (ref) v_u_47, (ref) v_u_7, (ref) v_u_3, (copy) v_u_686, (ref) v_u_709, (copy) v_u_689, (ref) v_u_43, (ref) v_u_708, (ref) v_u_16, (copy) v_u_739
		local v1448
		if v_u_711 == true then
			v1448 = v_u_712 ~= true
		else
			v1448 = false
		end
		if v1448 == true then
			return
		else
			v_u_1427()
			if v_u_819(v_u_685) == true then
				if v_u_47.Captured == true then
					local v_u_1449 = Enum.CoreGuiType.Backpack
					local v_u_1450 = v_u_47.Backpack
					pcall(function()
						-- upvalues: (ref) v_u_7, (copy) v_u_1449, (copy) v_u_1450
						v_u_7:SetCoreGuiEnabled(v_u_1449, v_u_1450)
					end)
					local v_u_1451 = Enum.CoreGuiType.PlayerList
					local v_u_1452 = v_u_47.PlayerList
					pcall(function()
						-- upvalues: (ref) v_u_7, (copy) v_u_1451, (copy) v_u_1452
						v_u_7:SetCoreGuiEnabled(v_u_1451, v_u_1452)
					end)
					v_u_47.Captured = false
				end
			else
				v_u_62()
			end
			local v1453 = v_u_3:GetTagged("MapCamera")
			local v1454 = workspace:FindFirstChild("Map")
			local v1455
			if v1454 then
				v1455 = v1454:FindFirstChild("CameraPort", true)
			else
				v1455 = nil
			end
			local v1456 = v1455 or (v1453[1] or workspace:FindFirstChild("MapBase"))
			if v1456 then
				v_u_686.CameraType = Enum.CameraType.Scriptable
				v_u_712 = false
				v_u_686.CameraSubject = v1456
				v_u_709 = true
				local v1457 = v1456.CFrame
				local v1458 = v1457 * CFrame.Angles(0, 0.08726646259971647, 0)
				local v1459 = v1457 * CFrame.Angles(0, -0.08726646259971647, 0)
				v_u_686.CFrame = v1457
				if v_u_689.MapInfo.Visible == true or v_u_689.RoundStart.Visible == true then
					v_u_686.CFrame = v1458
					v_u_43.PlayScreenTransition()
					v_u_708 = v_u_16.TweenCreate(v_u_686, {
						["CFrame"] = v1459
					}, 6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, false)
				end
				v_u_685.CameraMinZoomDistance = v_u_739.GetMinZoom()
				v_u_685.CameraMaxZoomDistance = v_u_739.GetMaxZoom()
			end
		end
	end
	local function v_u_1475(p1460) -- name: SpectatePlayer
		-- upvalues: (ref) v_u_711, (ref) v_u_712, (ref) v_u_708, (ref) v_u_709, (ref) v_u_2, (copy) v_u_819, (ref) v_u_823, (copy) v_u_739, (ref) v_u_701, (ref) v_u_710, (ref) v_u_702, (ref) v_u_703, (copy) v_u_945, (copy) v_u_948, (ref) v_u_39, (ref) v_u_35, (copy) v_u_943, (ref) v_u_700, (ref) v_u_43, (copy) v_u_685, (ref) v_u_732, (copy) v_u_691, (copy) v_u_783, (ref) v_u_809, (copy) v_u_815, (ref) v_u_62, (copy) v_u_910, (ref) v_u_20, (copy) v_u_913, (copy) v_u_932, (ref) v_u_44, (copy) v_u_686, (copy) v_u_738, (ref) v_u_33, (ref) v_u_713, (copy) v_u_742, (ref) v_u_37, (copy) v_u_953
		local v1461
		if v_u_711 == true then
			v1461 = v_u_712 ~= true
		else
			v1461 = false
		end
		if v1461 == true then
			return
		else
			if v_u_708 then
				v_u_708:Cancel()
				v_u_708 = nil
			end
			v_u_709 = false
			v_u_2.MouseIconEnabled = true
			v_u_2.MouseBehavior = Enum.MouseBehavior.Default
			if v_u_819(p1460) then
				v_u_739.StopOrbit()
				v_u_739.StopOrbit()
				v_u_701 = v_u_701 + 1
				v_u_710 = false
				if v_u_702 then
					v_u_702:Disconnect()
					v_u_702 = nil
				end
				if v_u_703 then
					v_u_703:Disconnect()
					v_u_703 = nil
				end
				v_u_945()
				v_u_948()
				local v1462 = nil
				local v1463 = v_u_39:GetAttribute("GameMode")
				local v1464
				if v1463 == "Custom" then
					v1464 = v_u_39:GetAttribute("SpectateFirstPerson") == true
				else
					v1464 = false
				end
				if v_u_35.ResolveSpectateMode(v1463, v1464) == v_u_35.SpectateModes.FirstPerson == true then
					v1462 = v_u_943(p1460)
				end
				v_u_700 = p1460
				v_u_43.CurrentSpectatingPlayer = p1460
				if v_u_700 == v_u_685 then
					v_u_732 = true
					v_u_691.Visible = false
					v_u_732 = false
					v_u_783()
					if v_u_809 then
						v_u_809()
					end
				else
					v_u_732 = true
					v_u_691.Visible = true
					v_u_732 = false
					v_u_783()
					if v_u_809 then
						v_u_809()
					end
				end
				v_u_815()
				v_u_62()
				local v1465 = v1462 or p1460.Character
				local v1466
				if v1465 then
					v1466 = v1465:FindFirstChildOfClass("Humanoid")
				else
					v1466 = v1465
				end
				local v1467
				if v1465 then
					v1467 = v1465:FindFirstChild("Head")
				else
					v1467 = v1465
				end
				if v1466 and v1467 then
					v_u_910()
					if v_u_20 and (v_u_20.IsActive and (v_u_20.StopFreecam and v_u_20:IsActive() == true)) then
						v_u_20:StopFreecam()
					end
					local v1468 = v_u_39:GetAttribute("GameMode")
					local v1469
					if v1468 == "Custom" then
						v1469 = v_u_39:GetAttribute("SpectateFirstPerson") == true
					else
						v1469 = false
					end
					if v_u_35.ResolveSpectateMode(v1468, v1469) == v_u_35.SpectateModes.FirstPerson then
						v_u_739.StopOrbit()
						v_u_739.RestoreCameraControls()
						if v1462 == nil then
							v_u_943(p1460)
							v1465 = p1460.Character
						end
						if v1465 then
							v_u_913(v1465)
						end
						v_u_932(v1465)
						v_u_44:SetAttribute("FirstPersonSpectateActive", true)
						v_u_686.CameraType = Enum.CameraType.Scriptable
						v_u_686.CameraSubject = nil
						local v1470 = v_u_686
						local v1471 = v_u_685:FindFirstChild("PlayerData")
						if v1471 then
							v1471 = v1471:FindFirstChild("Settings")
						end
						if v1471 then
							v1471 = tonumber(v1471:GetAttribute("FieldOfView"))
						end
						v1470.FieldOfView = v1471 or v_u_738
						v_u_685.CameraMinZoomDistance = 0.5
						v_u_685.CameraMaxZoomDistance = 0.5
						if v_u_711 == true then
							v_u_33.Warn("[GameMenu] Block live first-person spectate start during replay", p1460.Name, v_u_713)
							return
						end
						if v_u_742 and v_u_742.FinalizePreparedStart then
							v_u_742:FinalizePreparedStart(p1460, "LiveSpectateStart")
						else
							v_u_742:Start(p1460, "LiveSpectateStart")
						end
					else
						local v_u_1472 = nil
						local v1473 = v_u_39:GetAttribute("GameMode")
						local v1474
						if v1473 == "Custom" then
							v1474 = v_u_39:GetAttribute("SpectateFirstPerson") == true
						else
							v1474 = false
						end
						local _ = v_u_35.ResolveSpectateMode(v1473, v1474) == v_u_35.SpectateModes.FirstPerson == true
						pcall(function()
							-- upvalues: (ref) v_u_37, (ref) v_u_1472
							v_u_37:FireServer(v_u_1472)
						end)
						if v_u_43.SetDamageFeedSourcePlayer then
							v_u_43.SetDamageFeedSourcePlayer(v_u_685)
						end
						if v_u_711 == true then
							v_u_33.Warn("[GameMenu] Block live observer stop during replay", p1460.Name, v_u_713)
						else
							v_u_742:Stop("LiveSpectateThirdPerson")
						end
						v_u_44:SetAttribute("FirstPersonSpectateActive", false)
						v_u_739.ApplyCameraControls()
						v_u_739.StartOrbit(v1465, v1466, false)
					end
					v_u_953(p1460)
				else
					v_u_823()
				end
			else
				v_u_823()
				return
			end
		end
	end
	local function v_u_1478(p1476) -- name: CycleTeamSpectate
		-- upvalues: (ref) v_u_822, (ref) v_u_823, (ref) v_u_699, (copy) v_u_1475
		local v1477 = v_u_822()
		if #v1477 <= 0 then
			v_u_823()
		else
			if v_u_699 > #v1477 then
				v_u_699 = 1
			elseif v_u_699 < 1 then
				v_u_699 = #v1477
			end
			if #v1477 > 1 then
				v_u_699 = v_u_699 + p1476
				if v_u_699 > #v1477 then
					v_u_699 = 1
				elseif v_u_699 < 1 then
					v_u_699 = #v1477
				end
			else
				v_u_699 = 1
			end
			v_u_1475(v1477[v_u_699])
		end
	end
	local function v1481(p1479) -- name: TryManualCycleTeamSpectate
		-- upvalues: (ref) v_u_740, (copy) v_u_1478
		local v1480 = os.clock()
		if v1480 - v_u_740 < 0.3 then
			return false
		end
		v_u_740 = v1480
		v_u_1478(p1479)
		return true
	end
	local function v_u_1495(p_u_1482, p_u_1483, p1484) -- name: PlayKillCam
		-- upvalues: (copy) v_u_1495, (ref) v_u_733, (ref) v_u_734, (ref) v_u_737, (ref) v_u_735, (ref) v_u_736, (copy) v_u_690, (ref) v_u_43, (ref) v_u_1427, (ref) v_u_39, (ref) v_u_35, (ref) v_u_824, (ref) v_u_710, (ref) v_u_701, (ref) v_u_700, (ref) v_u_732, (copy) v_u_691, (copy) v_u_783, (ref) v_u_809, (ref) v_u_62, (copy) v_u_910, (ref) v_u_20, (copy) v_u_739
		if p1484 ~= true then
			local function v1485()
				-- upvalues: (ref) v_u_1495, (copy) p_u_1482, (copy) p_u_1483
				v_u_1495(p_u_1482, p_u_1483, true)
			end
			local v1486
			if v_u_733 == true and v_u_734 ~= true then
				v_u_737 = v1485
				if v_u_735 == true then
					v1486 = true
				else
					v_u_735 = true
					local v_u_1487 = v_u_736
					task.delay(2, function()
						-- upvalues: (ref) v_u_735, (ref) v_u_736, (copy) v_u_1487, (ref) v_u_737, (ref) v_u_734, (ref) v_u_690, (ref) v_u_43
						if v_u_735 == true and v_u_736 == v_u_1487 then
							local v1488 = v_u_737
							v_u_737 = nil
							v_u_735 = false
							v_u_734 = true
							if v_u_690 and v_u_690:IsA("GuiObject") then
								v_u_690.Visible = false
							end
							v_u_43.PlayScreenTransition()
							if v1488 then
								v1488()
							end
						end
					end)
					v1486 = true
				end
			else
				v1486 = false
			end
			if v1486 then
				return
			end
		end
		v_u_1427()
		local v1489 = v_u_39:GetAttribute("GameMode")
		local v1490
		if v1489 == "Custom" then
			v1490 = v_u_39:GetAttribute("SpectateFirstPerson") == true
		else
			v1490 = false
		end
		if v_u_35.ResolveSpectateMode(v1489, v1490) == v_u_35.SpectateModes.FirstPerson == true then
			v_u_824("Team")
			return
		else
			local v1491 = nil
			if typeof(p_u_1482) == "Instance" then
				if p_u_1482:IsA("Player") then
					p_u_1482 = p_u_1482.Character
				elseif not p_u_1482:IsA("Model") then
					p_u_1482 = v1491
				end
			else
				p_u_1482 = v1491
			end
			local v1492
			if p_u_1482 then
				v1492 = p_u_1482:FindFirstChildOfClass("Humanoid")
			else
				v1492 = p_u_1482
			end
			if v1492 and v1492.Health > 0 then
				v_u_710 = true
				v_u_701 = v_u_701 + 1
				local v_u_1493 = v_u_701
				v_u_700 = nil
				v_u_43.CurrentSpectatingPlayer = nil
				v_u_732 = true
				v_u_691.Visible = false
				v_u_732 = false
				v_u_783()
				if v_u_809 then
					v_u_809()
				end
				v_u_62()
				v_u_910()
				if v_u_20 and (v_u_20.IsActive and (v_u_20.StopFreecam and v_u_20:IsActive() == true)) then
					v_u_20:StopFreecam()
				end
				v_u_739.ApplyCameraControls()
				v_u_739.StartOrbit(p_u_1482, v1492, true)
				local v1494 = 5
				if typeof(p_u_1483) == "number" then
					if v1494 >= p_u_1483 then
						p_u_1483 = v1494
					end
				else
					p_u_1483 = v1494
				end
				task.delay(p_u_1483, function()
					-- upvalues: (ref) v_u_701, (copy) v_u_1493, (ref) v_u_710, (ref) v_u_824
					if v_u_701 == v_u_1493 and v_u_710 == true then
						v_u_710 = false
						v_u_824("Team")
					end
				end)
			else
				v_u_824("Team")
			end
		end
	end
	v_u_824 = function(p1496, p1497, p1498)
		-- upvalues: (ref) v_u_711, (ref) v_u_712, (ref) v_u_823, (copy) v_u_1475, (copy) v_u_685, (ref) v_u_824, (ref) v_u_733, (ref) v_u_734, (ref) v_u_737, (ref) v_u_735, (ref) v_u_736, (copy) v_u_690, (ref) v_u_43, (copy) v_u_1478, (ref) v_u_1427, (ref) v_u_47, (ref) v_u_7, (copy) v_u_686, (copy) v_u_739
		if p1496 then
			local v1499
			if v_u_711 == true then
				v1499 = v_u_712 ~= true
			else
				v1499 = false
			end
			if v1499 == true then
				return
			else
				local v1500 = string.lower(p1496)
				if v1500 == "map" then
					v_u_823()
					return
				elseif v1500 == "player" then
					v_u_1475(p1497 or v_u_685)
					return
				elseif v1500 == "team" then
					if p1498 ~= true then
						local function v1502()
							-- upvalues: (ref) v_u_824
							local v1501 = v_u_824
							if typeof(v1501) == "function" then
								v_u_824("Team", nil, true)
							end
						end
						local v1503
						if v_u_733 == true and v_u_734 ~= true then
							v_u_737 = v1502
							if v_u_735 == true then
								v1503 = true
							else
								v_u_735 = true
								local v_u_1504 = v_u_736
								task.delay(2, function()
									-- upvalues: (ref) v_u_735, (ref) v_u_736, (copy) v_u_1504, (ref) v_u_737, (ref) v_u_734, (ref) v_u_690, (ref) v_u_43
									if v_u_735 == true and v_u_736 == v_u_1504 then
										local v1505 = v_u_737
										v_u_737 = nil
										v_u_735 = false
										v_u_734 = true
										if v_u_690 and v_u_690:IsA("GuiObject") then
											v_u_690.Visible = false
										end
										v_u_43.PlayScreenTransition()
										if v1505 then
											v1505()
										end
									end
								end)
								v1503 = true
							end
						else
							v1503 = false
						end
						if v1503 then
							return
						end
					end
					v_u_1478(0)
				elseif v1500 == "exit" then
					v_u_1427()
					if v_u_47.Captured == true then
						local v_u_1506 = Enum.CoreGuiType.Backpack
						local v_u_1507 = v_u_47.Backpack
						pcall(function()
							-- upvalues: (ref) v_u_7, (copy) v_u_1506, (copy) v_u_1507
							v_u_7:SetCoreGuiEnabled(v_u_1506, v_u_1507)
						end)
						local v_u_1508 = Enum.CoreGuiType.PlayerList
						local v_u_1509 = v_u_47.PlayerList
						pcall(function()
							-- upvalues: (ref) v_u_7, (copy) v_u_1508, (copy) v_u_1509
							v_u_7:SetCoreGuiEnabled(v_u_1508, v_u_1509)
						end)
						v_u_47.Captured = false
					end
					local v1510 = v_u_685.Character and v_u_685.Character:FindFirstChildOfClass("Humanoid")
					if v1510 then
						v_u_686.CameraType = Enum.CameraType.Custom
						v_u_686.CameraSubject = v1510
					end
					v_u_739.RestoreCameraControls()
				end
			end
		else
			return
		end
	end
	if v_u_691:FindFirstChild("Profile") then
		if v_u_691.Profile:FindFirstChild("Next") then
			v_u_691.Profile.Next.Activated:Connect(function()
				-- upvalues: (copy) v_u_691, (ref) v_u_700, (ref) v_u_710, (ref) v_u_711, (ref) v_u_749, (ref) v_u_822, (ref) v_u_740, (copy) v_u_1478
				local v1511
				if v_u_691.Visible == true and (v_u_700 ~= nil and v_u_710 ~= true) then
					v1511 = v_u_711 ~= true
				else
					v1511 = false
				end
				local v1512
				if v1511 == true and v_u_749 == true then
					local v1513 = v_u_822
					if typeof(v1513) == "function" then
						v1512 = #v_u_822() > 1
					else
						v1512 = false
					end
				else
					v1512 = false
				end
				if v1512 == true then
					local v1514 = os.clock()
					if v1514 - v_u_740 < 0.3 then
						return
					end
					v_u_740 = v1514
					v_u_1478(1)
				end
			end)
		end
		if v_u_691.Profile:FindFirstChild("Previous") then
			v_u_691.Profile.Previous.Activated:Connect(function()
				-- upvalues: (copy) v_u_691, (ref) v_u_700, (ref) v_u_710, (ref) v_u_711, (ref) v_u_749, (ref) v_u_822, (ref) v_u_740, (copy) v_u_1478
				local v1515
				if v_u_691.Visible == true and (v_u_700 ~= nil and v_u_710 ~= true) then
					v1515 = v_u_711 ~= true
				else
					v1515 = false
				end
				local v1516
				if v1515 == true and v_u_749 == true then
					local v1517 = v_u_822
					if typeof(v1517) == "function" then
						v1516 = #v_u_822() > 1
					else
						v1516 = false
					end
				else
					v1516 = false
				end
				if v1516 == true then
					local v1518 = os.clock()
					if v1518 - v_u_740 < 0.3 then
						return
					end
					v_u_740 = v1518
					v_u_1478(-1)
				end
			end)
		end
	end
	v_u_31.BindSpectateControls({
		["ContextActionService"] = nil,
		["ActionName"] = "SpectateCycle",
		["ActionPriority"] = nil,
		["LocalPlayer"] = nil,
		["Players"] = nil,
		["CanCycleTeamSpectate"] = nil,
		["TryManualCycleTeamSpectate"] = nil,
		["RefreshSpectateControls"] = nil,
		["GetCurrentSpectatingPlayer"] = nil,
		["IsKillCamActive"] = nil,
		["IsReplayKillCamActive"] = nil,
		["IsAlive"] = nil,
		["SpectateTeam"] = nil,
		["ContextActionService"] = v_u_1,
		["ActionPriority"] = v_u_36.ACTION_PRIORITY + 1,
		["LocalPlayer"] = v_u_685,
		["Players"] = v_u_684,
		["CanCycleTeamSpectate"] = v776,
		["TryManualCycleTeamSpectate"] = v1481,
		["RefreshSpectateControls"] = v_u_783,
		["GetCurrentSpectatingPlayer"] = function() -- name: GetCurrentSpectatingPlayer
			-- upvalues: (ref) v_u_700
			return v_u_700
		end,
		["IsKillCamActive"] = function() -- name: IsKillCamActive
			-- upvalues: (ref) v_u_710
			return v_u_710 == true
		end,
		["IsReplayKillCamActive"] = function() -- name: IsReplayKillCamActive
			-- upvalues: (ref) v_u_711
			return v_u_711 == true
		end,
		["IsAlive"] = v_u_819,
		["SpectateTeam"] = function() -- name: SpectateTeam
			-- upvalues: (ref) v_u_824
			v_u_824("Team")
		end
	})
	v_u_4.GameEvents.KillCam.OnClientEvent:Connect(function(p1519)
		-- upvalues: (ref) v_u_711, (copy) v_u_1495
		if v_u_711 ~= true then
			v_u_1495(p1519, 0)
		end
	end)
	local v1523 = {
		["ShouldForceMapSpectateBeforeRoundReplay"] = nil,
		["HasCompletedRoundReplayMapSpectatePrep"] = nil,
		["RoundReplayMapSpectatePrepTimeout"] = 0.35,
		["ReplayKillCamRemote"] = nil,
		["StartReplayKillCam"] = nil,
		["StopReplayKillCam"] = nil,
		["SpectateMap"] = nil,
		["Spectate"] = nil,
		["ServerFolder"] = nil,
		["ShouldForceMapSpectateBeforeRoundReplay"] = function() -- name: ShouldForceMapSpectateBeforeRoundReplay
			-- upvalues: (copy) v_u_685, (copy) v_u_686, (ref) v_u_43
			local v1520 = v_u_685:FindFirstChild("ServerData")
			if v1520 and v1520:GetAttribute("Alive") ~= true then
				if v_u_686:GetAttribute("FirstPersonSpectateActive") == true then
					local v1521 = v_u_43.CurrentSpectatingPlayer
					if typeof(v1521) == "Instance" and v1521:IsA("Player") then
						if v1521 == v_u_685 then
							return false
						else
							return v_u_685.Team ~= nil and (v1521.Team ~= nil and v1521.Team == v_u_685.Team)
						end
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		end,
		["HasCompletedRoundReplayMapSpectatePrep"] = function() -- name: HasCompletedRoundReplayMapSpectatePrep
			-- upvalues: (copy) v_u_686, (ref) v_u_43, (copy) v_u_685
			if v_u_686:GetAttribute("FirstPersonSpectateActive") == true then
				return false
			end
			local v1522 = v_u_43.CurrentSpectatingPlayer
			return (typeof(v1522) ~= "Instance" or (not v1522:IsA("Player") or v1522 == v_u_685)) and true or false
		end,
		["ReplayKillCamRemote"] = v743,
		["StartReplayKillCam"] = v1402,
		["StopReplayKillCam"] = v1397,
		["SpectateMap"] = v_u_823,
		["Spectate"] = v_u_824,
		["ServerFolder"] = v_u_39
	}
	v_u_30.BindReplayRemote(v1523)
	v_u_32.BindRuntime({
		["SpawnPlayerRemote"] = v_u_4.GameEvents.SpawnPlayer,
		["ServerData"] = v_u_685:WaitForChild("ServerData"),
		["ResetPostDeathTransitionState"] = v751,
		["BuildReleaseMenuCameraArgs"] = v_u_1393,
		["GameMenuCameraSupport"] = v_u_25,
		["ArmPostDeathTransition"] = v756,
		["QueuePostDeathTransition"] = v760,
		["IsKillCamActive"] = function() -- name: IsKillCamActive
			-- upvalues: (ref) v_u_710
			return v_u_710 == true
		end,
		["IsReplayKillCamActive"] = function() -- name: IsReplayKillCamActive
			-- upvalues: (ref) v_u_711
			return v_u_711 == true
		end,
		["IsReplayStartupInProgress"] = function() -- name: IsReplayStartupInProgress
			-- upvalues: (ref) v_u_725
			return v_u_725 == true
		end,
		["GameMenu"] = v_u_689,
		["SpectateMap"] = v_u_823,
		["SpectateTeam"] = function() -- name: SpectateTeam
			-- upvalues: (ref) v_u_824
			v_u_824("Team")
		end,
		["BuildMenuCameraSpectateStateArgs"] = v1395,
		["MenuCameraFrames"] = {
			v_u_689:WaitForChild("PlayersJoining"),
			v_u_689:WaitForChild("MapChoose"),
			v_u_689:WaitForChild("MapInfo"),
			v_u_689:WaitForChild("RoundStart")
		},
		["NotificationFrame"] = v_u_691,
		["PlayerStats"] = v_u_692,
		["SpectatorRewards"] = v_u_22,
		["ServerFolder"] = v_u_39,
		["RefreshNextCrate"] = v_u_809,
		["GetLastSpectatorRewardSerial"] = function() -- name: GetLastSpectatorRewardSerial
			-- upvalues: (ref) v_u_698
			return v_u_698
		end,
		["SetLastSpectatorRewardSerial"] = function(p1524) -- name: SetLastSpectatorRewardSerial
			-- upvalues: (ref) v_u_698
			v_u_698 = p1524
		end,
		["PlaySpectatorRewardNotification"] = v805,
		["IsReplayPending"] = function() -- name: IsReplayPending
			-- upvalues: (copy) v_u_685
			return v_u_685:WaitForChild("ServerData"):GetAttribute("ReplayKillCamPending") == true
		end
	})
end
function v_u_43.ConfigMapComponents() -- name: ConfigMapComponents
	-- upvalues: (copy) v_u_3, (copy) v_u_16
	local function v_u_1528(p1525) -- name: ConnectRoundCacheComponentObservers
		-- upvalues: (ref) v_u_3, (ref) v_u_16
		if p1525 and p1525:IsA("Folder") then
			for _, v1526 in ipairs(p1525:GetDescendants()) do
				if v_u_3:HasTag(v1526, "Sticky Grenade") then
					v_u_16.AddComponents(v1526)
				end
			end
			p1525.DescendantAdded:Connect(function(p1527)
				-- upvalues: (ref) v_u_3, (ref) v_u_16
				if v_u_3:HasTag(p1527, "Sticky Grenade") then
					v_u_16.AddComponents(p1527)
				end
			end)
		end
	end
	for _, v1529 in pairs(game.Workspace.Map:GetDescendants()) do
		if v_u_3:HasTag(v1529, "TargetBoard") or v_u_3:HasTag(v1529, "Sticky Grenade") then
			v_u_16.AddComponents(v1529)
		end
	end
	game.Workspace.Map.DescendantAdded:Connect(function(p1530)
		-- upvalues: (ref) v_u_3, (ref) v_u_16
		if v_u_3:HasTag(p1530, "TargetBoard") or (v_u_3:HasTag(p1530, "Sticky Grenade") or v_u_3:HasTag(p1530, "Laser")) then
			v_u_16.AddComponents(p1530)
		end
	end)
	local v1531 = workspace:FindFirstChild("Round_Cache")
	if v1531 then
		v_u_1528(v1531)
	end
	workspace.ChildAdded:Connect(function(p1532)
		-- upvalues: (copy) v_u_1528
		if p1532:IsA("Folder") and p1532.Name == "Round_Cache" then
			v_u_1528(p1532)
		end
	end)
	game.Workspace.DescendantAdded:Connect(function(p1533)
		-- upvalues: (ref) v_u_3, (ref) v_u_16
		if v_u_3:HasTag(p1533, "Laser") or v_u_3:HasTag(p1533, "Tactical Light") then
			v_u_16.AddComponents(p1533)
		end
	end)
end
function v_u_43.ConfigOtherEvents() -- name: ConfigOtherEvents
	-- upvalues: (copy) v_u_10, (copy) v_u_4, (copy) v_u_18, (copy) v_u_43, (copy) v_u_5, (copy) v_u_16, (copy) v_u_7, (ref) v_u_42, (copy) v_u_8, (copy) v_u_39
	local v_u_1534 = v_u_10.LocalPlayer
	local v_u_1535 = v_u_1534:WaitForChild("PlayerGui"):WaitForChild("GameHUD")
	local v_u_1536 = v_u_1535:WaitForChild("GameNotification")
	v_u_4.GameEvents.InGameNotification.OnClientEvent:Connect(function(p1537, p1538)
		-- upvalues: (ref) v_u_18, (copy) v_u_1536
		v_u_18.Menu.AddNotification(p1537, p1538, v_u_1536.Frame)
	end)
	v_u_4.GameEvents.SpawnTransition.OnClientEvent:Connect(function()
		-- upvalues: (ref) v_u_43
		v_u_43.PlayScreenTransition()
	end)
	v_u_4.Events.ReturnLobby.OnClientEvent:Connect(function(p1539, p1540)
		-- upvalues: (ref) v_u_18, (ref) v_u_5, (ref) v_u_16, (copy) v_u_1534, (copy) v_u_1536
		v_u_18.Menu.ShowTeleportScreen()
		v_u_5:Teleport(v_u_16.LobbyID, v_u_1534, nil, p1540)
		v_u_18.Menu.AddNotification(p1539 or "Returning back to Lobby", nil, v_u_1536.Frame)
	end)
	v_u_4.Events:WaitForChild("ModNotification").OnClientEvent:Connect(function(p1541)
		-- upvalues: (ref) v_u_7
		v_u_7:SetCore("SendNotification", {
			["Title"] = "MODERATION",
			["Text"] = nil,
			["Text"] = p1541
		})
	end)
	v_u_4.GameEvents.PointsFeed.OnClientEvent:Connect(function(p1542)
		-- upvalues: (ref) v_u_43, (copy) v_u_1535
		v_u_43.AddPointsFeed(v_u_1535.PointsFeed, p1542)
	end)
	local v_u_1543 = 0
	local function v_u_1546() -- name: PlayKillMarker
		-- upvalues: (copy) v_u_1535, (ref) v_u_1543, (ref) v_u_16
		local v1544 = v_u_1535.PlayerHUD:FindFirstChild("Killmarker")
		if v1544 then
			v_u_1543 = v_u_1543 + 1
			local v1545 = v_u_1543
			v1544.Visible = true
			v1544.Size = UDim2.new(0.03, 0, 0.03, 0)
			v_u_16.TweenCreate(v1544, {
				["Size"] = UDim2.new(0.04, 0, 0.04, 0)
			}, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, true)
			if v1545 == v_u_1543 then
				v_u_16.TweenCreate(v1544, {
					["Size"] = UDim2.new(0.03, 0, 0.03, 0)
				}, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In, true)
				if v1545 == v_u_1543 then
					v1544.Visible = false
				end
			else
				return
			end
		else
			return
		end
	end
	v_u_4.GameEvents.KillFeed.OnClientEvent:Connect(function(p1547, p1548, p1549, p1550, p1551)
		-- upvalues: (ref) v_u_10, (copy) v_u_1546, (ref) v_u_43, (copy) v_u_1535
		if p1547 == v_u_10.LocalPlayer then
			task.spawn(v_u_1546)
		end
		if p1548 == "Bag" then
			v_u_43.AddBagFeed(v_u_1535.KillFeed, p1547, p1549, p1550)
		elseif p1551 == "Bot" then
			v_u_43.AddAIKillFeed(v_u_1535.KillFeed, p1547, p1548, p1549, p1550)
		else
			v_u_43.AddKillFeed(v_u_1535.KillFeed, p1547, p1548, p1549, p1550)
		end
		v_u_43.PlayPlayersLeft(p1548.Team.Name)
	end)
	local function v_u_1563(p1552) -- name: IsLookingAtObjective
		local v1553 = workspace.CurrentCamera
		if not v1553 then
			return false
		end
		if not p1552 then
			return false
		end
		local v1554 = p1552.Adornee
		local v1555
		if v1554 and v1554:IsA("BasePart") then
			v1555 = v1554.Position
		else
			if not (p1552.Parent and p1552.Parent:IsA("BasePart")) then
				return false
			end
			v1555 = p1552.Parent.Position
		end
		local v1556, v1557 = v1553:WorldToViewportPoint(v1555)
		if not v1557 then
			return false
		end
		local v1558 = v1553.ViewportSize
		local v1559 = v1558 / 2
		local v1560 = (Vector2.new(v1556.X, v1556.Y) - v1559).Magnitude
		local v1561 = v1558.X
		local v1562 = v1558.Y
		return v1560 <= math.min(v1561, v1562) * 0.1
	end
	local v_u_1564 = nil
	local function v_u_1566() -- name: HideObjectiveUI
		-- upvalues: (ref) v_u_42
		if not (v_u_42 and v_u_42.Parent) then
			v_u_42 = game.Workspace:FindFirstChild("ObjectiveModel", true)
		end
		if v_u_42 then
			if v_u_42:FindFirstChild("Core") then
				if v_u_42.Core:FindFirstChild("Frame") then
					local v1565 = v_u_42.Core.Frame
					if v1565:IsA("BillboardGui") then
						v1565.Enabled = false
					elseif v1565:IsA("GuiObject") then
						v1565.Visible = false
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	end
	local v_u_1567 = v_u_1534.PlayerData:WaitForChild("Settings")
	local function v_u_1574() -- name: RefreshObjectiveUI
		-- upvalues: (ref) v_u_42, (copy) v_u_1567, (ref) v_u_43, (copy) v_u_1563
		if not (v_u_42 and v_u_42.Parent) then
			v_u_42 = game.Workspace:FindFirstChild("ObjectiveModel", true)
		end
		if v_u_42 then
			if v_u_42:FindFirstChild("Core") then
				if v_u_42.Core:FindFirstChild("Frame") then
					local v1568 = v_u_42.Core.Frame
					if v_u_1567:GetAttribute("ObjectiveUI") == false then
						v1568.Enabled = false
						return
					else
						v1568.Enabled = true
						if v1568:FindFirstChild("Icon") and (v1568:FindFirstChild("Target") and v1568:FindFirstChild("Distance")) then
							local v1569 = (game.Workspace.CurrentCamera.CFrame.Position - v_u_42.Core.Position).Magnitude
							local v1570 = math.abs(v1569) / 5
							local v1571 = math.floor(v1570)
							local v1572 = v_u_43.GetResponsiveOffsetSize(80, 80)
							local v1573 = v_u_43.GetResponsiveOffsetSize(100, 100)
							v1568.Distance.Text = v1571 .. "m"
							if v1571 < 2 then
								v1568.Size = v1572
								v1568.Icon.ImageTransparency = 0.8
								v1568.Target.ImageTransparency = 0.8
								v1568.Distance.TextTransparency = 0.8
								v1568.Distance.Text = ""
								return
							elseif v_u_1563(v1568) == true then
								v1568.Size = v1572
								v1568.Icon.ImageTransparency = 0.8
								v1568.Target.ImageTransparency = 0.8
								v1568.Distance.TextTransparency = 0.8
							else
								v1568.Size = v1573
								v1568.Icon.ImageTransparency = 0
								v1568.Target.ImageTransparency = 0
								v1568.Distance.TextTransparency = 0
							end
						else
							return
						end
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	end
	v_u_1564 = v_u_8.Heartbeat:Connect(function(p1575)
		-- upvalues: (ref) v_u_39, (copy) v_u_1566, (ref) v_u_1564, (ref) v_u_43, (copy) v_u_1574
		if v_u_39:GetAttribute("Phase") == "Game Ended" then
			v_u_1566()
			if v_u_1564 then
				v_u_1564:Disconnect()
				v_u_1564 = nil
			end
		else
			v_u_43.DamageFeedRuntime(0.3, p1575)
			v_u_1574()
		end
	end)
end
function v_u_43.ConfigMainMenu() -- name: ConfigMainMenu
	-- upvalues: (copy) v_u_10, (copy) v_u_18, (copy) v_u_39, (copy) v_u_16, (copy) v_u_6, (copy) v_u_5, (copy) v_u_4, (copy) v_u_21, (copy) v_u_43
	local v_u_1576 = v_u_10.LocalPlayer
	local v_u_1577 = v_u_1576:WaitForChild("PlayerGui"):WaitForChild("Menu")
	local function v1579() -- name: ConfigMenuPage
		-- upvalues: (copy) v_u_1577, (ref) v_u_39, (ref) v_u_16, (ref) v_u_18
		local v1578 = v_u_1577:WaitForChild("Pages"):WaitForChild("Menu")
		v1578.Leave.Activated:Connect(function()
			-- upvalues: (ref) v_u_39, (ref) v_u_16, (ref) v_u_18, (ref) v_u_1577
			if v_u_39:GetAttribute("Phase") == "Game Ended" then
				v_u_16.AddSound("Wrong", false, false, nil, false)
				v_u_18.Menu.AddNotification("Game ended, leave button locked", Color3.fromRGB(255, 100, 100), v_u_1577.Top.Notification)
			else
				v_u_1577.Pages.Prompt.Visible = true
				v_u_1577.Pages.Prompt.Title.Text = "Confirm leave? Leaving early will not earn you match rewards!"
				v_u_1577.Pages.Prompt:SetAttribute("Event", "LEAVE")
			end
		end)
		v1578.RebalanceTeam.Activated:Connect(function()
			-- upvalues: (ref) v_u_39, (ref) v_u_1577, (ref) v_u_18
			if v_u_39:GetAttribute("GameMode") == "Ranked" then
				v_u_18.Menu.AddNotification("This feature is not available in Ranked", Color3.fromRGB(255, 100, 100), v_u_1577.Top.Notification)
			else
				v_u_1577.Pages.Prompt.Visible = true
				v_u_1577.Pages.Prompt.Title.Text = "Request for team rebalance?"
				v_u_1577.Pages.Prompt:SetAttribute("Event", "REBALANCE")
			end
		end)
	end
	local function v1582() -- name: ConfigTopBar
		-- upvalues: (copy) v_u_1576, (ref) v_u_21, (copy) v_u_1577, (ref) v_u_39, (ref) v_u_18, (ref) v_u_16
		v_u_1576:WaitForChild("PlayerGui")
		pcall(function()
			-- upvalues: (ref) v_u_21, (ref) v_u_1577
			v_u_21.new():setName("Menu"):setLabel("Menu", "deselected"):setLabel("Close menu", "selected"):setCaption("Open Menu"):setImage("rbxassetid://16009597038"):bindToggleKey(Enum.KeyCode.M):bindEvent("toggled", function()
				-- upvalues: (ref) v_u_1577
				game:GetService("UserInputService")
				v_u_1577.Enabled = not v_u_1577.Enabled
			end):align("Right")
		end)
		for _, v_u_1580 in pairs(v_u_1577.Top.Menu:GetChildren()) do
			if v_u_1580:IsA("ImageButton") then
				v_u_1580.MouseButton1Down:Connect(function()
					-- upvalues: (copy) v_u_1580, (ref) v_u_39, (ref) v_u_18, (ref) v_u_1577
					if v_u_1580.Name == "Custom" and v_u_39:GetAttribute("GameMode") ~= "Custom" then
						v_u_18.Menu.AddNotification("Not custom mode", Color3.fromRGB(255, 100, 100), v_u_1577.Top.Notification)
					else
						local v1581 = v_u_1580.Name
						v_u_18.Menu.OpenPage(v1581)
					end
				end)
			end
		end
		v_u_16.ConfigTopInset(v_u_1577.Top)
	end
	(function() -- name: ConfigPrompt
		-- upvalues: (copy) v_u_1577, (ref) v_u_39, (copy) v_u_1576, (ref) v_u_18, (ref) v_u_16, (ref) v_u_6, (ref) v_u_5, (ref) v_u_4
		local v_u_1583 = v_u_1577:WaitForChild("Pages")
		v_u_1583.Prompt.Cancel.Activated:Connect(function()
			-- upvalues: (copy) v_u_1583
			v_u_1583.Prompt.Visible = false
		end)
		v_u_1583.Prompt.Accept.Activated:Connect(function()
			-- upvalues: (ref) v_u_16, (ref) v_u_6, (copy) v_u_1583, (ref) v_u_5, (ref) v_u_1576, (ref) v_u_4, (ref) v_u_39, (ref) v_u_18, (ref) v_u_1577
			v_u_16.AddSound("Click_3", 1, true, v_u_6, false)
			local v1584 = v_u_1583.Prompt:GetAttribute("Event")
			if v1584 then
				if v1584 == "LEAVE" then
					v_u_5:Teleport(v_u_16.LobbyID, v_u_1576)
					v_u_4.Events.ReturnLobby:FireServer()
				elseif v1584 == "RESTART MATCH" then
					local v1585
					if v_u_39:GetAttribute("GameMode") == "Custom" then
						v1585 = v_u_39:GetAttribute("Host") == v_u_1576.Name
					else
						v1585 = false
					end
					if not v1585 then
						v_u_18.Menu.AddNotification("Only the host can change custom match settings", Color3.fromRGB(255, 100, 100), v_u_1577.Top.Notification)
						v_u_1583.Prompt.Visible = false
						return
					end
					v_u_4.GameEvents.EditCustomSettings:FireServer(v_u_1583.Prompt:GetAttribute("Event"), nil)
					v_u_1577.Enabled = false
				elseif v1584 == "MAP CHANGE" then
					local v1586
					if v_u_39:GetAttribute("GameMode") == "Custom" then
						v1586 = v_u_39:GetAttribute("Host") == v_u_1576.Name
					else
						v1586 = false
					end
					if not v1586 then
						v_u_18.Menu.AddNotification("Only the host can change custom match settings", Color3.fromRGB(255, 100, 100), v_u_1577.Top.Notification)
						v_u_1583.Prompt.Visible = false
						return
					end
					v_u_4.GameEvents.EditCustomSettings:FireServer(v_u_1583.Prompt:GetAttribute("Event"), v_u_1583.Prompt:GetAttribute("MAP"))
					v_u_4.GameEvents.EditCustomSettings:FireServer("RESTART MATCH", nil)
					v_u_1577.Enabled = false
				elseif v1584 == "REBALANCE" then
					v_u_4.GameEvents.VoteRebalance:FireServer("Request", "Rebalance")
				elseif v1584 == "CHANGELOADOUT" then
					v_u_4.GameEvents.ChangeLoadoutInGame:FireServer(v_u_1583.Prompt:GetAttribute("LoadoutSelected"), true)
				elseif v1584 then
					local v1587
					if v_u_39:GetAttribute("GameMode") == "Custom" then
						v1587 = v_u_39:GetAttribute("Host") == v_u_1576.Name
					else
						v1587 = false
					end
					if not v1587 then
						v_u_18.Menu.AddNotification("Only the host can change custom match settings", Color3.fromRGB(255, 100, 100), v_u_1577.Top.Notification)
						v_u_1583.Prompt.Visible = false
						return
					end
					local v1588 = {
						["RoundTime"] = v_u_1583.Prompt:GetAttribute("RoundTime"),
						["TacticalAmount"] = v_u_1583.Prompt:GetAttribute("TacticalAmount"),
						["Gravity"] = v_u_1583.Prompt:GetAttribute("Gravity"),
						["Speed"] = v_u_1583.Prompt:GetAttribute("Speed"),
						["TournamentMode"] = v_u_1583.Prompt:GetAttribute("TournamentMode"),
						["AllowVest"] = v_u_1583.Prompt:GetAttribute("AllowVest"),
						["SpectateFirstPerson"] = v_u_1583.Prompt:GetAttribute("SpectateFirstPerson"),
						["BlueWear"] = v_u_1583.Prompt:GetAttribute("BlueWear"),
						["RedWear"] = v_u_1583.Prompt:GetAttribute("RedWear")
					}
					v_u_4.GameEvents.EditCustomSettings:FireServer(v_u_1583.Prompt:GetAttribute("Event"), v1588)
					v_u_1577.Enabled = false
				end
				v_u_1583.Prompt.Visible = false
			end
		end)
	end)()
	v1579()
	v1582()
	v_u_18.Menu.ConfigSettingButtons()
	v_u_18.Menu.ConfigLoadoutButtons()
	v_u_43.ConfigCustomMenu()
end
function v_u_43.ConfigCustomMenu() -- name: ConfigCustomMenu
	-- upvalues: (copy) v_u_10, (copy) v_u_39, (copy) v_u_18, (copy) v_u_40, (copy) v_u_16, (copy) v_u_6, (copy) v_u_43, (copy) v_u_4, (copy) v_u_12, (copy) v_u_41, (copy) v_u_44, (copy) v_u_20
	local v1589 = v_u_10.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Menu")
	local v_u_1590 = v1589:WaitForChild("Pages"):WaitForChild("Custom")
	local v_u_1591 = v1589:WaitForChild("Pages"):WaitForChild("Prompt")
	local v_u_1592 = v1589:WaitForChild("Top"):WaitForChild("Notification")
	local v_u_1593 = {
		["BlueWear"] = 1,
		["RedWear"] = 1
	}
	local function v_u_1599(p1594, p1595, p1596, p1597) -- name: SetBooleanToggle
		local v1598 = p1595 == true
		p1594.Toggle.Title.Text = v1598 and (p1596 or "ON") or (p1597 or "OFF")
		p1594.Background.Value.BackgroundColor3 = v1598 and Color3.fromRGB(85, 160, 30) or Color3.fromRGB(170, 80, 80)
		return v1598
	end
	local function v_u_1604() -- name: ApplyPromptDefaults
		-- upvalues: (copy) v_u_1591, (ref) v_u_39, (ref) v_u_40, (copy) v_u_1593
		local v1600 = v_u_1591
		local v1601 = v_u_39:GetAttribute("RoundTime") or 600
		v1600:SetAttribute("RoundTime", (tostring(v1601)))
		local v1602 = v_u_1591
		local v1603 = v_u_39:GetAttribute("TacticalAmount") or 100
		v1602:SetAttribute("TacticalAmount", (tostring(v1603)))
		v_u_1591:SetAttribute("Gravity", v_u_39:GetAttribute("AntiGravity") == true)
		v_u_1591:SetAttribute("Speed", v_u_39:GetAttribute("SpeedMode") == true)
		v_u_1591:SetAttribute("TournamentMode", v_u_40:GetAttribute("TournamentMode") == true)
		v_u_1591:SetAttribute("AllowVest", v_u_40:GetAttribute("AllowVest") == true)
		v_u_1591:SetAttribute("SpectateFirstPerson", v_u_39:GetAttribute("SpectateFirstPerson") == true)
		v_u_1591:SetAttribute("BlueWear", v_u_40:GetAttribute("BlueWear") or 1)
		v_u_1591:SetAttribute("RedWear", v_u_40:GetAttribute("RedWear") or 1)
		v_u_1593.BlueWear = v_u_1591:GetAttribute("BlueWear") or 1
		v_u_1593.RedWear = v_u_1591:GetAttribute("RedWear") or 1
	end
	local function v_u_1620() -- name: RefreshCustomMenuState
		-- upvalues: (copy) v_u_1604, (ref) v_u_39, (ref) v_u_10, (copy) v_u_1590, (copy) v_u_1591, (copy) v_u_1599, (copy) v_u_1593
		v_u_1604()
		local v1605
		if v_u_39:GetAttribute("GameMode") == "Custom" then
			v1605 = v_u_39:GetAttribute("Host") == v_u_10.LocalPlayer.Name
		else
			v1605 = false
		end
		if v_u_1590.Save:FindFirstChild("Title") then
			v_u_1590.Save.Title.Text = v1605 and "SAVE" or "HOST ONLY"
		end
		local v1606 = v_u_1590.Scroller:FindFirstChild("Round Time")
		if v1606 and v1606:FindFirstChild("Value") then
			local v1607 = v1606.Value
			local v1608 = v_u_1591:GetAttribute("RoundTime") or "600"
			v1607.Text = tostring(v1608)
		end
		local v1609 = v_u_1590.Scroller:FindFirstChild("Tactical Amount")
		if v1609 and v1609:FindFirstChild("Value") then
			local v1610 = v1609.Value
			local v1611 = v_u_1591:GetAttribute("TacticalAmount") or "100"
			v1610.Text = tostring(v1611)
		end
		local v1612 = v_u_1590.Scroller:FindFirstChild("Gravity")
		if v1612 then
			v_u_1599(v1612, v_u_1591:GetAttribute("Gravity"))
		end
		local v1613 = v_u_1590.Scroller:FindFirstChild("Speed")
		if v1613 then
			v_u_1599(v1613, v_u_1591:GetAttribute("Speed"))
		end
		local v1614 = v_u_1590.Scroller:FindFirstChild("SpectateFirstPerson")
		if v1614 then
			v_u_1599(v1614, v_u_1591:GetAttribute("SpectateFirstPerson"))
		end
		local v1615 = v_u_1590.Scroller:FindFirstChild("TeamsAssignment")
		if v1615 and (v1615:FindFirstChild("Toggle") and v1615.Toggle:FindFirstChild("Title")) then
			v1615.Toggle.Title.Text = "ADJUST"
		end
		v_u_1590.Scroller.TeamsMenu.Visible = false
		local v1616 = v_u_1590.Scroller:FindFirstChild("TournamentMode")
		local v1617
		if v1616 then
			v1617 = v_u_1599(v1616, v_u_1591:GetAttribute("TournamentMode"))
		else
			v1617 = false
		end
		v_u_1590.Scroller.TournamentMenu.Visible = v1617
		for _, v1618 in pairs(v_u_1590.Scroller.TournamentMenu:GetChildren()) do
			if v1618:IsA("Frame") then
				if v1618.Name == "BlueWear" or v1618.Name == "RedWear" then
					local v1619 = v_u_1591:GetAttribute(v1618.Name) or 1
					v_u_1593[v1618.Name] = v1619
					v1618.Toggle.Title.Text = "SET " .. tostring(v1619)
				elseif v1618.Name == "AllowVest" then
					v_u_1599(v1618, v_u_1591:GetAttribute(v1618.Name))
				end
			end
		end
	end
	for _, v_u_1621 in pairs(v_u_1590.Scroller:GetChildren()) do
		if v_u_1621:IsA("Frame") then
			if v_u_1621.Name == "Restart Match" then
				v_u_1621.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6, (ref) v_u_39, (ref) v_u_10, (ref) v_u_18, (copy) v_u_1592, (copy) v_u_1591
					v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
					local v1622
					if v_u_39:GetAttribute("GameMode") == "Custom" then
						v1622 = v_u_39:GetAttribute("Host") == v_u_10.LocalPlayer.Name
					else
						v1622 = false
					end
					if v1622 then
						v_u_18.Menu.ShowPrompt(v_u_1591, "ARE YOU SURE TO RESTART MATCH?", "RESTART MATCH")
					else
						v_u_18.Menu.AddNotification("Only the host can change custom match settings", Color3.fromRGB(255, 100, 100), v_u_1592)
					end
				end)
			elseif v_u_1621.Name == "Gravity" then
				v_u_1621.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6, (copy) v_u_1591, (copy) v_u_1621
					v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
					local v1623 = v_u_1591:GetAttribute("Gravity") ~= true
					local v1624 = v_u_1621
					local v1625 = v1623 == true
					v1624.Toggle.Title.Text = v1625 and "ON" or "OFF"
					v1624.Background.Value.BackgroundColor3 = v1625 and Color3.fromRGB(85, 160, 30) or Color3.fromRGB(170, 80, 80)
					v_u_1591:SetAttribute("Gravity", v1623)
				end)
			elseif v_u_1621.Name == "Speed" then
				v_u_1621.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6, (copy) v_u_1591, (copy) v_u_1621
					v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
					local v1626 = v_u_1591:GetAttribute("Speed") ~= true
					local v1627 = v_u_1621
					local v1628 = v1626 == true
					v1627.Toggle.Title.Text = v1628 and "ON" or "OFF"
					v1627.Background.Value.BackgroundColor3 = v1628 and Color3.fromRGB(85, 160, 30) or Color3.fromRGB(170, 80, 80)
					v_u_1591:SetAttribute("Speed", v1626)
				end)
			elseif v_u_1621.Name == "SpectateFirstPerson" then
				v_u_1621.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6, (copy) v_u_1591, (copy) v_u_1621
					v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
					local v1629 = v_u_1591:GetAttribute("SpectateFirstPerson") ~= true
					local v1630 = v_u_1621
					local v1631 = v1629 == true
					v1630.Toggle.Title.Text = v1631 and "ON" or "OFF"
					v1630.Background.Value.BackgroundColor3 = v1631 and Color3.fromRGB(85, 160, 30) or Color3.fromRGB(170, 80, 80)
					v_u_1591:SetAttribute("SpectateFirstPerson", v1629)
				end)
			elseif v_u_1621.Name == "TournamentMode" then
				v_u_1621.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6, (copy) v_u_1591, (copy) v_u_1621, (copy) v_u_1590
					v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
					local v1632 = v_u_1591:GetAttribute("TournamentMode") ~= true
					v_u_1591:SetAttribute("TournamentMode", v1632)
					local v1633 = v_u_1621
					local v1634 = v1632 == true
					v1633.Toggle.Title.Text = v1634 and "ON" or "OFF"
					v1633.Background.Value.BackgroundColor3 = v1634 and Color3.fromRGB(85, 160, 30) or Color3.fromRGB(170, 80, 80)
					v_u_1590.Scroller.TournamentMenu.Visible = v1632
					if v1632 then
						v_u_1590.Scroller.CanvasPosition = Vector2.new(0, 707.07)
					end
				end)
			elseif v_u_1621.Name == "Round Time" then
				local v_u_1635 = v_u_1621.Value.Text
				v_u_1621.Value.Focused:Connect(function()
					-- upvalues: (ref) v_u_1635, (copy) v_u_1621
					v_u_1635 = v_u_1621.Value.Text
				end)
				v_u_1621.Value.FocusLost:Connect(function()
					-- upvalues: (copy) v_u_1621, (ref) v_u_1635
					local v1636 = v_u_1621.Value.Text
					local v1637 = tonumber(v1636)
					if v1637 then
						local v1638 = v_u_1621.Value
						local v1639 = math.clamp(v1637, 60, (1 / 0))
						v1638.Text = tostring(v1639)
					else
						v_u_1621.Value.Text = v_u_1635
					end
				end)
			elseif v_u_1621.Name == "Tactical Amount" then
				local v_u_1640 = v_u_1621.Value.Text
				v_u_1621.Value.Focused:Connect(function()
					-- upvalues: (ref) v_u_1640, (copy) v_u_1621
					v_u_1640 = v_u_1621.Value.Text
				end)
				v_u_1621.Value.FocusLost:Connect(function()
					-- upvalues: (copy) v_u_1621, (ref) v_u_1640
					local v1641 = v_u_1621.Value.Text
					local v1642 = tonumber(v1641)
					if v1642 then
						local v1643 = v_u_1621.Value
						local v1644 = math.clamp(v1642, 0, (1 / 0))
						v1643.Text = tostring(v1644)
					else
						v_u_1621.Value.Text = v_u_1640
					end
				end)
			elseif v_u_1621.Name == "Map" then
				v_u_1621.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_39, (ref) v_u_10, (ref) v_u_18, (copy) v_u_1592, (copy) v_u_1590
					local v1645
					if v_u_39:GetAttribute("GameMode") == "Custom" then
						v1645 = v_u_39:GetAttribute("Host") == v_u_10.LocalPlayer.Name
					else
						v1645 = false
					end
					if v1645 then
						v_u_1590.Scroller.MapScroller.Visible = not v_u_1590.Scroller.MapScroller.Visible
					else
						v_u_18.Menu.AddNotification("Only the host can change custom match settings", Color3.fromRGB(255, 100, 100), v_u_1592)
					end
				end)
			end
		end
	end
	local v_u_1646 = v_u_1590.Scroller:FindFirstChild("TeamsAssignment")
	if v_u_1646 and v_u_1646:FindFirstChild("Toggle") then
		v_u_1646.Toggle.Activated:Connect(function()
			-- upvalues: (ref) v_u_16, (ref) v_u_6, (ref) v_u_39, (ref) v_u_10, (ref) v_u_18, (copy) v_u_1592, (copy) v_u_1646, (ref) v_u_43, (copy) v_u_1590
			v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
			local v1647
			if v_u_39:GetAttribute("GameMode") == "Custom" then
				v1647 = v_u_39:GetAttribute("Host") == v_u_10.LocalPlayer.Name
			else
				v1647 = false
			end
			if v1647 then
				if v_u_1646.Toggle.Title.Text == "ADJUST" then
					v_u_1646.Toggle.Title.Text = "CLOSE"
					v_u_43.RefreshTournamentTeamScroller(v_u_1590.Scroller.TeamsMenu)
					v_u_1590.Scroller.TeamsMenu.Visible = true
				else
					v_u_1646.Toggle.Title.Text = "ADJUST"
					v_u_1590.Scroller.TeamsMenu.Visible = false
				end
			else
				v_u_18.Menu.AddNotification("Only the host can change custom match settings", Color3.fromRGB(255, 100, 100), v_u_1592)
				return
			end
		end)
	end
	v_u_1590.Save.Activated:Connect(function()
		-- upvalues: (ref) v_u_39, (ref) v_u_10, (ref) v_u_18, (copy) v_u_1592, (copy) v_u_1591, (copy) v_u_1590
		local v1648
		if v_u_39:GetAttribute("GameMode") == "Custom" then
			v1648 = v_u_39:GetAttribute("Host") == v_u_10.LocalPlayer.Name
		else
			v1648 = false
		end
		if v1648 then
			v_u_1591:SetAttribute("RoundTime", v_u_1590.Scroller:FindFirstChild("Round Time").Value.Text)
			v_u_1591:SetAttribute("TacticalAmount", v_u_1590.Scroller:FindFirstChild("Tactical Amount").Value.Text)
			v_u_18.Menu.ShowPrompt(v_u_1591, "SAVE CUSTOM CHANGES?", "SAVE CUSTOM")
		else
			v_u_18.Menu.AddNotification("Only the host can change custom match settings", Color3.fromRGB(255, 100, 100), v_u_1592)
		end
	end)
	for _, v_u_1649 in pairs(v_u_4.MapImages:GetChildren()) do
		if v_u_1649.Name ~= "Cafeteria" and v_u_1649:IsA("Decal") then
			local v_u_1650 = script.CustomMapSample:Clone()
			v_u_1650.Parent = v_u_1590.Scroller.MapScroller
			v_u_1650.Image = v_u_1649.Texture
			v_u_1650.Title.Text = string.upper(v_u_1649.Name)
			v_u_1650.Activated:Connect(function()
				-- upvalues: (ref) v_u_16, (ref) v_u_6, (ref) v_u_39, (ref) v_u_10, (ref) v_u_18, (copy) v_u_1592, (copy) v_u_1591, (copy) v_u_1649, (copy) v_u_1650
				v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
				local v1651
				if v_u_39:GetAttribute("GameMode") == "Custom" then
					v1651 = v_u_39:GetAttribute("Host") == v_u_10.LocalPlayer.Name
				else
					v1651 = false
				end
				if v1651 then
					v_u_1591:SetAttribute("MAP", v_u_1649.Name)
					v_u_18.Menu.ShowPrompt(v_u_1591, "CONFIRM MAP CHANGE TO " .. v_u_1650.Title.Text .. "?", "MAP CHANGE")
				else
					v_u_18.Menu.AddNotification("Only the host can change custom match settings", Color3.fromRGB(255, 100, 100), v_u_1592)
				end
			end)
		end
	end
	for _, v_u_1652 in pairs(v_u_1590.Scroller.TournamentMenu:GetChildren()) do
		if v_u_1652:IsA("Frame") then
			if v_u_1652.Name == "BlueWear" or v_u_1652.Name == "RedWear" then
				v_u_1652.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6, (copy) v_u_1593, (copy) v_u_1652, (copy) v_u_1591
					v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
					local v1653 = v_u_1593
					local v1654 = v_u_1652.Name
					v1653[v1654] = v1653[v1654] + 1
					if v_u_1593[v_u_1652.Name] > 3 then
						v_u_1593[v_u_1652.Name] = 1
					end
					local v1655 = v_u_1652.Toggle.Title
					local v1656 = v_u_1593[v_u_1652.Name]
					v1655.Text = "SET " .. tostring(v1656)
					v_u_1591:SetAttribute(v_u_1652.Name, v_u_1593[v_u_1652.Name])
				end)
			elseif v_u_1652.Name == "AllowVest" then
				v_u_1652.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6, (copy) v_u_1591, (copy) v_u_1652
					v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
					local v1657 = v_u_1591:GetAttribute(v_u_1652.Name) ~= true
					v_u_1591:SetAttribute(v_u_1652.Name, v1657)
					local v1658 = v_u_1652
					local v1659 = v1657 == true
					v1658.Toggle.Title.Text = v1659 and "ON" or "OFF"
					v1658.Background.Value.BackgroundColor3 = v1659 and Color3.fromRGB(85, 160, 30) or Color3.fromRGB(170, 80, 80)
				end)
			elseif v_u_1652.Name == "FreeCam" or v_u_1652.Name == "FreeCamUI" then
				v_u_1652.Toggle.Activated:Connect(function()
					-- upvalues: (ref) v_u_16, (ref) v_u_6, (copy) v_u_1652, (ref) v_u_10, (ref) v_u_12, (ref) v_u_41, (ref) v_u_44, (ref) v_u_20
					v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
					local v1660 = v_u_1652.Toggle.Title.Text == "OFF"
					local v1661 = v_u_1652
					local v1662 = v1660 == true
					v1661.Toggle.Title.Text = v1662 and "ON" or "OFF"
					v1661.Background.Value.BackgroundColor3 = v1662 and Color3.fromRGB(85, 160, 30) or Color3.fromRGB(170, 80, 80)
					if v_u_1652.Name == "FreeCam" and v_u_10.LocalPlayer.Team == v_u_12.Spectator then
						if v1660 then
							local v1663 = v_u_41:FindFirstChild("CameraPort", true) or workspace.MapBase
							v_u_44.CFrame = v1663.CFrame
							v_u_20:EnableFreecam()
							task.wait(1)
							v_u_44.CFrame = v1663.CFrame
						else
							pcall(function()
								-- upvalues: (ref) v_u_20
								v_u_20:StopFreecam()
							end)
						end
					else
						if v_u_1652.Name == "FreeCamUI" then
							v_u_10.LocalPlayer:SetAttribute("FreeCamUI", v1660)
						end
						return
					end
				end)
			end
		end
	end
	for _, v1664 in ipairs({
		"RoundTime",
		"TacticalAmount",
		"AntiGravity",
		"SpeedMode",
		"SpectateFirstPerson",
		"Host",
		"GameMode"
	}) do
		v_u_39:GetAttributeChangedSignal(v1664):Connect(function()
			-- upvalues: (copy) v_u_1590, (copy) v_u_1620
			if v_u_1590.Visible == true then
				v_u_1620()
			end
		end)
	end
	for _, v1665 in ipairs({
		"TournamentMode",
		"AllowVest",
		"BlueWear",
		"RedWear"
	}) do
		v_u_40:GetAttributeChangedSignal(v1665):Connect(function()
			-- upvalues: (copy) v_u_1590, (copy) v_u_1620
			if v_u_1590.Visible == true then
				v_u_1620()
			end
		end)
	end
	v_u_1590:GetPropertyChangedSignal("Visible"):Connect(function()
		-- upvalues: (copy) v_u_1590, (copy) v_u_1620
		if v_u_1590.Visible == true then
			v_u_1620()
		end
	end)
	v_u_4.GameEvents.SwitchTeam.OnClientEvent:Connect(function()
		-- upvalues: (ref) v_u_43, (copy) v_u_1590, (copy) v_u_1620
		v_u_43.RefreshTournamentTeamScroller(v_u_1590.Scroller.TeamsMenu)
		if v_u_1590.Visible == true then
			v_u_1620()
		end
	end)
	v_u_1620()
end
function v_u_43.RefreshTournamentTeamScroller(p1666) -- name: RefreshTournamentTeamScroller
	-- upvalues: (copy) v_u_10, (copy) v_u_39, (copy) v_u_4, (copy) v_u_12
	for _, v1667 in pairs(p1666:GetChildren()) do
		if v1667:IsA("Frame") then
			v1667:Destroy()
		end
	end
	for _, v_u_1668 in pairs(v_u_10:GetPlayers()) do
		local v1669 = script.SampleCustomTeamEdit:Clone()
		v1669.Parent = p1666
		v1669.Name = v_u_1668.Name
		v1669.Title.Text = v_u_1668.Name
		v1669.BackgroundColor3 = v_u_39:GetAttribute(v_u_1668.Team.Name .. "Color")
		v1669.Spectator.Activated:Connect(function()
			-- upvalues: (ref) v_u_4, (copy) v_u_1668, (ref) v_u_12
			v_u_4.GameEvents.SwitchTeam:FireServer(v_u_1668.Name, v_u_12.Spectator)
		end)
		v1669.Blue.Activated:Connect(function()
			-- upvalues: (ref) v_u_4, (copy) v_u_1668, (ref) v_u_12
			v_u_4.GameEvents.SwitchTeam:FireServer(v_u_1668.Name, v_u_12.Blue)
		end)
		v1669.Red.Activated:Connect(function()
			-- upvalues: (ref) v_u_4, (copy) v_u_1668, (ref) v_u_12
			v_u_4.GameEvents.SwitchTeam:FireServer(v_u_1668.Name, v_u_12.Red)
		end)
	end
end
function v_u_43.PlayScreenTransition(p1670) -- name: PlayScreenTransition
	-- upvalues: (copy) v_u_10, (copy) v_u_16
	local v_u_1671 = v_u_10.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GameMenu"):WaitForChild("CoverScreen")
	v_u_1671.Visible = true
	v_u_16.TweenCreate(v_u_1671, {
		["BackgroundTransparency"] = 0
	}, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
	task.wait(0.5)
	task.delay((p1670 or 1) - 0.5, function()
		-- upvalues: (ref) v_u_16, (copy) v_u_1671
		v_u_16.TweenCreate(v_u_1671, {
			["BackgroundTransparency"] = 1
		}, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true)
		v_u_1671.Visible = false
	end)
end
function v_u_43.ConfigPhases() -- name: ConfigPhases
	-- upvalues: (copy) v_u_10, (copy) v_u_12, (copy) v_u_39, (copy) v_u_4, (copy) v_u_16, (copy) v_u_6, (copy) v_u_18, (copy) v_u_43, (copy) v_u_17
	local v_u_1672 = v_u_10.LocalPlayer
	local v_u_1673 = v_u_1672:WaitForChild("PlayerGui")
	local v_u_1674 = v_u_1673:WaitForChild("GameMenu")
	local function v1684() -- name: ConfigMapChooseFrame
		-- upvalues: (copy) v_u_1674, (ref) v_u_39, (ref) v_u_4, (ref) v_u_16, (ref) v_u_6
		local v_u_1675 = v_u_1674:WaitForChild("MapChoose")
		local function v_u_1683() -- name: SetOnce
			-- upvalues: (ref) v_u_39, (copy) v_u_1675, (ref) v_u_4, (ref) v_u_16, (ref) v_u_6
			v_u_39:GetAttribute("Phase")
			if v_u_39:GetAttribute("Phase") == "Choose Map" then
				v_u_1675.Visible = true
				for _, v1676 in pairs(v_u_1675.Scroller:GetChildren()) do
					if v1676:IsA("ImageButton") then
						v1676:Destroy()
					end
				end
				local v_u_1677 = false
				for _, v_u_1678 in pairs(v_u_39.MapChoose:GetChildren()) do
					local v_u_1679 = script.MapSample:Clone()
					v_u_1679.Name = v_u_1678.Name
					v_u_1679.Parent = v_u_1675.Scroller
					v_u_1679.Button.Title.Text = string.upper(v_u_1678.Name)
					v_u_1679.Button.Display.Image = v_u_4.MapImages[v_u_1678.Name].Texture
					v_u_39.MapChoose[v_u_1678.Name].Changed:Connect(function()
						-- upvalues: (copy) v_u_1679, (ref) v_u_39, (copy) v_u_1678
						v_u_1679.Votes.Text = v_u_39.MapChoose[v_u_1678.Name].Value
					end)
					v_u_1679.Button.Activated:Connect(function()
						-- upvalues: (ref) v_u_1677, (ref) v_u_16, (ref) v_u_6, (ref) v_u_4, (copy) v_u_1678, (ref) v_u_1675, (copy) v_u_1679
						if v_u_1677 ~= true then
							v_u_1677 = true
							task.delay(0.4, function()
								-- upvalues: (ref) v_u_1677
								v_u_1677 = false
							end)
							v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
							v_u_4.GameEvents.ChooseMap:FireServer(v_u_1678.Name)
							for _, v1680 in pairs(v_u_1675.Scroller:GetChildren()) do
								if v1680:IsA("ImageButton") then
									v1680.Button.ImageColor3 = Color3.fromRGB(150, 150, 150)
									v1680.Button.Size = UDim2.new(1, 0, 1, 0)
									v1680.ZIndex = 1
								end
							end
							v_u_1679.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
							v_u_1679.ZIndex = 2
							v_u_16.TweenCreate(v_u_1679.Button, {
								["Size"] = UDim2.new(1.2, 0, 1.08, 0)
							}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
						end
					end)
				end
				v_u_39:GetAttributeChangedSignal("Phase"):Once(function()
					-- upvalues: (ref) v_u_39, (ref) v_u_1675, (ref) v_u_16
					if v_u_39:GetAttribute("Phase") ~= "Choose Map" then
						local v1681 = v_u_1675.Scroller:FindFirstChild(v_u_39:GetAttribute("Map"))
						if v1681 then
							for _, v_u_1682 in pairs(v_u_1675.Scroller:GetChildren()) do
								if v_u_1682 ~= v1681 and v_u_1682:IsA("ImageButton") then
									v_u_16.TweenCreate(v_u_1682, {
										["Size"] = UDim2.new(0, 0, 0.8, 0)
									}, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
									delay(0.5, function()
										-- upvalues: (copy) v_u_1682
										v_u_1682.Visible = false
									end)
								end
							end
							v_u_16.TweenCreate(v_u_1675.Scroller.UIListLayout, {
								["Padding"] = UDim.new(0, 0)
							}, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
							task.wait(0.5)
							v_u_16.TweenCreate(v1681.Button, {
								["Size"] = UDim2.new(2.2, 0, 1.1, 0)
							}, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
							task.wait(0.3)
							v_u_16.AddSound("Intermission_Transition2", nil, false, nil, false)
							v_u_16.TweenCreate(v1681.Button.Display, {
								["Size"] = UDim2.new(1.2, 0, 1.5, 0)
							}, 5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
						end
						task.wait(5)
						v_u_1675.Visible = false
					end
				end)
			end
		end
		v_u_1683()
		v_u_39:GetAttributeChangedSignal("Phase"):Connect(function()
			-- upvalues: (copy) v_u_1683
			v_u_1683()
		end)
	end
	(function() -- name: ConfigPlayersJoining
		-- upvalues: (copy) v_u_1674, (ref) v_u_10, (ref) v_u_12, (ref) v_u_39
		local v_u_1685 = v_u_1674:WaitForChild("PlayersJoining")
		local function v1691() -- name: RefreshPlayers
			-- upvalues: (copy) v_u_1685, (ref) v_u_10, (ref) v_u_12, (ref) v_u_39
			v_u_1685.PlayersAmount.Text = #v_u_10:GetChildren()
			for _, v1686 in pairs({ v_u_1685.Blue, v_u_1685.Red }) do
				for _, v1687 in pairs(v1686:GetChildren()) do
					if v1687:IsA("Frame") and v_u_10:FindFirstChild(v1687.Name) == nil then
						v1687:Destroy()
					end
				end
			end
			for _, v_u_1688 in pairs(v_u_10:GetPlayers()) do
				if v_u_1688.Team == v_u_12.Blue or v_u_1688.Team == v_u_12.Red then
					local v1689 = v_u_1685:WaitForChild(v_u_1688.Team.Name):FindFirstChild(v_u_1688.Name)
					if v1689 == nil then
						local _, _ = pcall(function()
							-- upvalues: (copy) v_u_1688, (ref) v_u_39, (ref) v_u_1685
							local v1690 = script.PlayerJoiningSample:Clone()
							v1690.BackgroundTransparency = 1
							v1690.Name = v_u_1688.Name
							v1690.Scroller.PlayerName.Text = v_u_1688.Name
							v1690.Level.Text = v_u_1688:WaitForChild("PlayerData"):WaitForChild("Stats"):GetAttribute("Level")
							v1690.Scroller.PlayerImage.Image = v_u_1688:WaitForChild("ServerData"):GetAttribute("ProfilePicture")
							v1690.Scroller.PlayerImage.BackgroundColor3 = v_u_39:GetAttribute(v_u_1688.Team.Name .. "Color")
							v1690.Background.BackgroundColor3 = v_u_39:GetAttribute(v_u_1688.Team.Name .. "Color")
							if v_u_1688.Team.Name == "Blue" then
								v1690.Scroller.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
								v1690.Scroller.PlayerImage.LayoutOrder = 3
								v1690.Background.UIGradient.Rotation = 180
							end
							v1690.Parent = v_u_1685:WaitForChild(v_u_1688.Team.Name)
						end)
					else
						v1689.Background.BackgroundColor3 = v_u_39:GetAttribute(v_u_1688.Team.Name .. "Color")
						v1689.Scroller.PlayerImage.BackgroundColor3 = v_u_39:GetAttribute(v_u_1688.Team.Name .. "Color")
					end
				end
			end
		end
		local v_u_1692 = {
			["a"] = v_u_10.PlayerAdded:Connect(v1691),
			["b"] = v_u_10.PlayerRemoving:Connect(v1691)
		}
		v_u_39:GetAttributeChangedSignal("Phase"):Connect(function()
			-- upvalues: (ref) v_u_39, (copy) v_u_1685, (copy) v_u_1692
			if v_u_39:GetAttribute("Phase") == "PlayersJoining" then
				v_u_1685.Visible = true
				v_u_39:GetAttributeChangedSignal("Phase"):Once(function()
					-- upvalues: (ref) v_u_39, (ref) v_u_1692
					if v_u_39:GetAttribute("Phase") ~= "PlayersJoining" then
						for _, v1693 in pairs(v_u_1692) do
							v1693:Disconnect()
						end
					end
				end)
			else
				v_u_1685.Visible = false
			end
		end)
		if v_u_39:GetAttribute("Phase") == "PlayersJoining" then
			v_u_1685.Visible = true
		end
	end)()
	v1684()
	local v_u_1694 = v_u_1674:WaitForChild("MapInfo")
	v_u_39:GetAttributeChangedSignal("Phase"):Connect(function()
		-- upvalues: (ref) v_u_39, (copy) v_u_1694
		if v_u_39:GetAttribute("Phase") == "Show Map" then
			v_u_1694.Visible = true
			v_u_1694.MapName.Text = v_u_39:GetAttribute("Map")
			v_u_1694.GameMode.Text = string.upper(v_u_39:GetAttribute("GameMode"))
		else
			v_u_1694.Visible = false
		end
	end)
	local v_u_1695 = v_u_1674:WaitForChild("RoundStart")
	v_u_39:GetAttributeChangedSignal("Phase"):Connect(function()
		-- upvalues: (ref) v_u_39, (copy) v_u_1695, (ref) v_u_16, (copy) v_u_1672, (copy) v_u_1673
		if v_u_39:GetAttribute("Phase") == "Show Round" then
			v_u_16.AddSound("Intermission_Transition", nil, false, nil, false)
			v_u_1695.Visible = true
			v_u_1695.Round.Text = "ROUND " .. v_u_39:GetAttribute("Rounds")
			if v_u_39:GetAttribute("Attacker") == v_u_1672.Team.Name then
				v_u_1695.ObjectiveImage.Image = "rbxassetid://7059100536"
				v_u_1695.Objective.Text = "ATTACK"
				v_u_1673.GameHUD.TopBorder.Middle.Objective.Text = "ATTACK"
			else
				v_u_1695.ObjectiveImage.Image = "rbxassetid://5647507800"
				v_u_1695.Objective.Text = "DEFEND"
				v_u_1673.GameHUD.TopBorder.Middle.Objective.Text = "DEFEND"
			end
		else
			v_u_1695.Visible = false
			return
		end
	end)
	local v_u_1696 = v_u_1674:WaitForChild("RoundEnd")
	local v_u_1697 = 0
	v_u_39:GetAttributeChangedSignal("Phase"):Connect(function()
		-- upvalues: (ref) v_u_1697, (ref) v_u_39, (copy) v_u_1696, (ref) v_u_16, (copy) v_u_1672
		v_u_1697 = v_u_1697 + 1
		local v_u_1698 = v_u_1697
		if v_u_39:GetAttribute("Phase") == "Round Ended" then
			v_u_16.AddSound("Round_End" .. math.random(1, 5), nil, false, nil, false)
			if v_u_39:GetAttribute("RoundWinner") == v_u_1672.Team.Name then
				v_u_1696.Round.Text = "ROUND " .. v_u_39:GetAttribute("Rounds") .. " WON"
			else
				v_u_1696.Round.Text = "ROUND " .. v_u_39:GetAttribute("Rounds") .. " LOST"
			end
			if ReplayKillCamActive == true then
				v_u_1696.Visible = false
			else
				v_u_1696.Visible = true
				task.delay(3, function()
					-- upvalues: (ref) v_u_1697, (copy) v_u_1698, (ref) v_u_39, (ref) v_u_1696
					if v_u_1697 == v_u_1698 then
						if v_u_39:GetAttribute("Phase") == "Round Ended" then
							v_u_1696.Visible = false
						end
					else
						return
					end
				end)
			end
		else
			v_u_1696.Visible = false
			return
		end
	end)
	local v_u_1699 = v_u_1674:WaitForChild("GameEnd")
	v_u_39:GetAttributeChangedSignal("Phase"):Connect(function()
		-- upvalues: (ref) v_u_39, (copy) v_u_1699, (ref) v_u_16, (ref) v_u_4, (ref) v_u_10, (copy) v_u_1672, (ref) v_u_18, (copy) v_u_1673, (ref) v_u_43, (ref) v_u_17
		if v_u_39:GetAttribute("Phase") == "Game Ended" then
			v_u_1699.Visible = true
			local v_u_1700 = true
			v_u_16.TweenCreate(v_u_1699.Lobby.Bar, {
				["Size"] = UDim2.new(0, 0, 1, 0)
			}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
			task.delay(2, function()
				-- upvalues: (ref) v_u_1700
				v_u_1700 = false
			end)
			v_u_1699.Lobby.Activated:Connect(function()
				-- upvalues: (ref) v_u_1700, (ref) v_u_4
				if v_u_1700 ~= true then
					v_u_1700 = true
					task.delay(1, function()
						-- upvalues: (ref) v_u_1700
						v_u_1700 = false
					end)
					v_u_4.Events.ReturnLobby:FireServer()
				end
			end)
			v_u_1699.Rewards.Visible = false
			v_u_1699.RewardCash.Visible = false
			v_u_1699.Info.Visible = false
			v_u_1699.Lobby.Visible = false
			v_u_1699.RewardVictory.Visible = false
			v_u_1699.RewardEvent.Visible = false
			v_u_1699.RewardEvent.Visible = false
			local v1701 = {}
			for _, v1702 in pairs(v_u_10:GetPlayers()) do
				if v1702.Team == v_u_1672.Team then
					table.insert(v1701, v1702)
				end
			end
			table.sort(v1701, function(p1703, p1704)
				local v1705 = p1703:FindFirstChild("ServerData")
				local v1706 = p1704:FindFirstChild("ServerData")
				if v1705 and v1706 then
					return v1705:GetAttribute("Points") > v1706:GetAttribute("Points")
				else
					return false
				end
			end)
			local v1707 = game.Workspace.Map:FindFirstChild("WinnerPort", true)
			if v1707 then
				local v1708 = v1707:FindFirstChild("Players")
				if v1708 then
					v_u_18.Menu.RefreshPlayerPorts(v1708, v1701, true)
					workspace.CurrentCamera:ClearAllChildren()
					if v_u_1672.Character and v_u_1672.Character:FindFirstChild("ClientWeaponSystem") then
						v_u_1672.Character:FindFirstChild("ClientWeaponSystem"):Destroy()
					end
					v_u_1673.GameHUD.PlayerHUD.Visible = false
					v_u_1673.GameHUD.SpectatorUI.Visible = false
					v_u_1673.GameHUD.TopBorder.Middle.RoundDisplay.Visible = false
					v_u_1673.GameHUD.TopBorder.Middle.Objective.Visible = false
					v_u_1673.GameHUD.TopBorder.Middle.VictoryStatus.Visible = true
					v_u_43.PlayScreenTransition()
					if v_u_43.HasActiveSpectateController and v_u_43.HasActiveSpectateController() == true then
						v_u_43.TeardownSpectateControllers()
					end
					workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
					workspace.CurrentCamera.FieldOfView = 85
					workspace.CurrentCamera.CFrame = v1707.CameraPort.CFrame
					v_u_16.AddSound("MatchFound", nil, false, nil, false)
					v_u_16.AddSound("Intermission_Transition", nil, false, nil, false)
					v_u_16.TweenCreate(workspace.CurrentCamera, {
						["FieldOfView"] = 95
					}, 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true)
					task.wait(1)
					v_u_1699.Rewards.Visible = true
					v_u_1699.RewardCash.Visible = true
					v_u_1699.Info.Visible = true
					v_u_1699.Lobby.Visible = true
					v_u_1699.RewardVictory.Visible = true
					local v1709 = v_u_1672.PlayerData.Stats:GetAttribute("BoosterCashTime") > 0
					local v1710 = v_u_1672.ServerData:GetAttribute("MatchWon")
					if v1710 == nil then
						v1710 = v_u_39:GetAttribute("MatchWinner") == v_u_1672.Team.Name
					end
					if v1710 then
						v_u_1673.GameHUD.TopBorder.Middle.VictoryStatus.Text = "YOU WON"
					else
						v_u_1673.GameHUD.TopBorder.Middle.VictoryStatus.Text = "YOU LOST"
					end
					local v1711 = v_u_17.GetCurrentEvent()
					local v1712 = v1709 and 100 or 50
					v_u_1699.RewardCash.Text = "+" .. (v1709 and 100 or 50) .. " Cash  |  Match Completion"
					if v1710 then
						v_u_1699.RewardVictory.Text = "+" .. v1712 .. " Cash  |  Match Victory"
					else
						v_u_1699.RewardVictory.Text = "+0 Cash  |  Match Lost"
					end
					local v1713
					if v1711 then
						local v1714 = v1711.EndGameCurrencyBonus
						v1713 = tonumber(v1714) or 0
					else
						v1713 = 0
					end
					if v1711 == nil or v1713 <= 0 then
						v_u_1699.RewardEvent.Visible = false
						v_u_1699.RewardEvent.Text = "+0 Nil  |  Event"
						v_u_1699.RewardEvent.TextColor3 = Color3.new(1, 1, 1)
					else
						v_u_1699.RewardEvent.Visible = true
						v_u_1699.RewardEvent.Text = "+" .. v1713 .. " " .. (v1711.CurrencyName or "Event") .. "  |  Event"
						v_u_1699.RewardEvent.TextColor3 = v1711.CurrencyColor or Color3.new(1, 1, 1)
					end
					local v_u_1715 = v_u_4.GameEvents.EndGameRewards
					local v_u_1716 = {}
					local function v_u_1723() -- name: GetEndGameRewardPoolForDisplay
						-- upvalues: (ref) v_u_16, (ref) v_u_17
						local v1717 = {}
						for _, v1718 in ipairs(v_u_16.EndGameRewards) do
							local v1719 = table.clone(v1718)
							local _ = v1719.Type == "EventCurrency"
							table.insert(v1717, v1719)
						end
						local v1720 = v_u_17.GetCurrentEvent()
						if v1720 ~= nil then
							for _, v1721 in ipairs(v1720.EndGameRewardEvent or {}) do
								local v1722 = table.clone(v1721)
								if v1722.Type == "EventCurrency" and v1720 ~= nil then
									v1722.DisplayName = v1722.DisplayName or (v1720.CurrencyName or v1722.Name)
								end
								table.insert(v1717, v1722)
							end
						end
						return v1717
					end
					local function v_u_1728(p1724) -- name: PlayEndGameRewardSound
						-- upvalues: (ref) v_u_16
						if p1724 then
							local v1725 = v_u_16.Rarity[p1724.Rarity]
							if v1725 then
								local v1726 = v1725.Sound
								if typeof(v1726) == "Instance" and v1726:IsA("Sound") then
									local v1727 = v1726:Clone()
									v1727.Parent = workspace.CurrentCamera
									v1727:Play()
									game:GetService("Debris"):AddItem(v1727, v1727.TimeLength + 1)
								else
									v_u_16.AddSound("Receive_1", nil, false, nil, false)
								end
							else
								v_u_16.AddSound("Receive_1", nil, false, nil, false)
								return
							end
						else
							return
						end
					end
					local function v_u_1730(p1729) -- name: GetRewardTitleText
						if p1729 then
							if p1729.Type == "Cash" or (p1729.Type == "Credit" or p1729.Type == "EventCurrency") then
								return p1729.Amount .. " " .. (p1729.DisplayName or p1729.Name)
							elseif p1729.Type == "Crate" then
								return p1729.Name .. " " .. p1729.Type
							else
								return p1729.DisplayName or p1729.Name
							end
						else
							return ""
						end
					end
					local function v_u_1739(p1731) -- name: RevealChosenReward
						-- upvalues: (ref) v_u_1716, (copy) v_u_1728, (ref) v_u_16
						local v1732 = v_u_1716[p1731]
						if v1732 then
							local v1733 = v1732.Clone
							local v1734 = v1732.RewardData
							if v1733 then
								if v1733.Parent == nil then
									return
								elseif v1733:GetAttribute("Flipped") == true then
									return
								else
									local v1735 = v1733:FindFirstChild("Back")
									local v1736 = v1733:FindFirstChild("Front")
									local v1737 = v1733:FindFirstChild("Reward")
									if v1735 and (v1736 and (v1737 and v1734)) then
										v1733:SetAttribute("Flipped", true)
										v1733:SetAttribute("Hidden", false)
										if v1733 and v1733.Parent ~= nil then
											local v1738 = v1733:FindFirstChild("Back")
											if v1738 and v1738:IsA("GuiButton") then
												v1738.Active = false
												v1738.AutoButtonColor = false
											end
										end
										v_u_1728(v1734)
										v_u_16.TweenCreate(v1735, {
											["Size"] = UDim2.new(0, 0, 1, 0)
										}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true)
										v1736.Visible = true
										v1737.Visible = true
										v1736.Size = UDim2.new(0, 0, 1, 0)
										v1737.Size = UDim2.new(0, 0, 1, 0)
										v_u_16.TweenCreate(v1736, {
											["Size"] = UDim2.new(1, 0, 1, 0)
										}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
										v_u_16.TweenCreate(v1737, {
											["Size"] = UDim2.new(1, 0, 1, 0)
										}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
									end
								end
							else
								return
							end
						else
							return
						end
					end
					local function v_u_1746(p1740) -- name: HideUnchosenReward
						-- upvalues: (ref) v_u_1716, (ref) v_u_16
						local v1741 = v_u_1716[p1740]
						if v1741 then
							local v1742 = v1741.Clone
							if v1742 then
								if v1742.Parent == nil then
									return
								elseif v1742:GetAttribute("Flipped") == true then
									return
								elseif v1742:GetAttribute("Hidden") == true then
									return
								else
									local v1743 = v1742:FindFirstChild("Back")
									if v1743 then
										v1742:SetAttribute("Hidden", true)
										if v1742 and v1742.Parent ~= nil then
											local v1744 = v1742:FindFirstChild("Back")
											if v1744 and v1744:IsA("GuiButton") then
												v1744.Active = false
												v1744.AutoButtonColor = false
											end
										end
										local v1745 = v1743.Size
										v_u_16.TweenCreate(v1743, {
											["Size"] = UDim2.new(v1745.X.Scale, v1745.X.Offset, 0, 0)
										}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
									end
								end
							else
								return
							end
						else
							return
						end
					end
					local function v_u_1752(p1747) -- name: ResolveClaimedReward
						-- upvalues: (ref) v_u_1716, (copy) v_u_1739, (copy) v_u_1746
						if typeof(p1747) == "number" then
							for v1748, v1750 in pairs(v_u_1716) do
								if v1750 then
									local v1750 = v1750.Clone
								end
								if v1750 and v1750.Parent then
									if v1750 and v1750.Parent ~= nil then
										local v1751 = v1750:FindFirstChild("Back")
										if v1751 and v1751:IsA("GuiButton") then
											v1751.Active = false
											v1751.AutoButtonColor = false
										end
									end
									if v1748 == p1747 then
										v_u_1739(v1748)
									else
										v_u_1746(v1748)
									end
								end
							end
						end
					end
					local function v_u_1766(p1753) -- name: BuildEndGameRewards
						-- upvalues: (ref) v_u_1716, (ref) v_u_1699, (ref) v_u_16, (copy) v_u_1730, (copy) v_u_1723, (ref) v_u_1672, (copy) v_u_1715
						v_u_1716 = {}
						for _, v1754 in ipairs(v_u_1699.Rewards:GetChildren()) do
							if v1754.Name:match("^Reward%d+$") then
								v1754:Destroy()
							end
						end
						for v_u_1755 = 1, v_u_16.EndGameRewardsAmount do
							local v1756 = p1753[v_u_1755]
							if v1756 then
								local v_u_1757 = script.SampleEndGameReward:Clone()
								v_u_1757.Name = "Reward" .. v_u_1755
								v_u_1757.Parent = v_u_1699.Rewards
								v_u_1757:SetAttribute("SlotNumber", v_u_1755)
								v_u_1757:SetAttribute("Flipped", false)
								v_u_1757:SetAttribute("Hidden", false)
								v_u_1716[v_u_1755] = {
									["Clone"] = v_u_1757,
									["RewardData"] = v1756
								}
								v_u_1757.Back.Size = UDim2.new(0, 0, 1, 0)
								v_u_16.TweenCreate(v_u_1757.Back, {
									["Size"] = UDim2.new(1, 0, 1, 0)
								}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true)
								local v1758 = v_u_1757:WaitForChild("Reward")
								local v1759 = v1758:WaitForChild("Title")
								local v1760 = v1758:WaitForChild("Chance")
								local v1761 = v_u_16.Rarity[v1756.Rarity]
								if v1761 then
									v_u_1757.Front.BackgroundColor3 = v1761.Color
								end
								v1759.Text = v_u_1730(v1756)
								local v1762 = 0
								for _, v1763 in ipairs((v_u_1723())) do
									v1762 = v1762 + (v1763.Chance or 0)
								end
								local v1764 = v1762 <= 0 and 0 or (v1756.Chance or 0) / v1762 * 100
								v1760.Text = string.format("%.1f%%", v1764)
								v_u_1757.Back.Activated:Connect(function()
									-- upvalues: (copy) v_u_1757, (ref) v_u_1672, (ref) v_u_16, (ref) v_u_1715, (copy) v_u_1755
									if v_u_1757:GetAttribute("Flipped") == true then
										return
									else
										local v1765 = v_u_1672.ServerData:GetAttribute("EndGameRewardsClaim") or 0
										if v_u_16.EndGameRewardsAmount <= v1765 then
											return
										elseif v1765 <= 0 then
											v_u_1715:FireServer("Claim", v_u_1755)
										end
									end
								end)
							end
						end
					end
					v_u_1715.OnClientEvent:Connect(function(p1767, p1768)
						-- upvalues: (copy) v_u_1766, (copy) v_u_1752, (ref) v_u_16
						if p1767 == "Generated" then
							v_u_1766(p1768)
							return
						elseif p1767 == "Claimed" then
							v_u_1752(p1768)
						elseif p1767 == "Rejected" and typeof(p1768) == "string" then
							v_u_16.AddNotification(p1768, Color3.fromRGB(255, 150, 150))
						end
					end)
					v_u_1715:FireServer("Generate")
				end
			else
				return
			end
		else
			v_u_1699.Visible = false
			return
		end
	end)
end
function v_u_43.ConfigAttackerPrompt() -- name: ConfigAttackerPrompt
	-- upvalues: (copy) v_u_10, (copy) v_u_39, (copy) v_u_16, (copy) v_u_43, (copy) v_u_6, (copy) v_u_4
	local v_u_1769 = v_u_10.LocalPlayer
	local v_u_1770 = v_u_1769:WaitForChild("PlayerGui"):WaitForChild("GameMenu"):WaitForChild("AttackerPrompt")
	local v_u_1771 = workspace.CurrentCamera
	local v_u_1772 = workspace:WaitForChild("Map")
	local v_u_1773 = nil
	local v_u_1774 = {}
	local function v_u_1776() -- name: DisconnectConnections
		-- upvalues: (copy) v_u_1774
		for _, v1775 in pairs(v_u_1774) do
			if v1775 then
				v1775:Disconnect()
			end
		end
		table.clear(v_u_1774)
	end
	local function v_u_1779() -- name: ClearFrame
		-- upvalues: (copy) v_u_1776, (ref) v_u_1773, (copy) v_u_1770
		v_u_1776()
		v_u_1773 = nil
		v_u_1770.Visible = false
		if v_u_1770:FindFirstChild("Selection") then
			for _, v1777 in pairs(v_u_1770.Selection:GetChildren()) do
				v1777:Destroy()
			end
		end
		if v_u_1770:FindFirstChild("Options") then
			for _, v1778 in pairs(v_u_1770.Options:GetChildren()) do
				if v1778:IsA("ImageButton") or v1778:IsA("Frame") then
					v1778:Destroy()
				end
			end
		end
	end
	local function v_u_1786() -- name: GetAttackerSpawns
		-- upvalues: (copy) v_u_1772
		local v1780 = {}
		for _, v1781 in pairs(v_u_1772:GetDescendants()) do
			if v1781.Name == "AttackerSpawn" and v1781:IsA("BasePart") then
				table.insert(v1780, v1781)
			end
		end
		table.sort(v1780, function(p1782, p1783)
			local v1784 = p1782:GetAttribute("LayoutOrder") or 1
			local v1785 = p1783:GetAttribute("LayoutOrder") or 1
			if v1784 == v1785 then
				return p1782.Name < p1783.Name
			else
				return v1784 < v1785
			end
		end)
		return v1780
	end
	local function v_u_1813(p1787) -- name: TweenCameraToSpawns
		-- upvalues: (copy) v_u_1771, (ref) v_u_16
		if #p1787 > 0 then
			local v1788 = p1787[1].Position.X
			local v1789 = p1787[1].Position.X
			local v1790 = p1787[1].Position.Z
			local v1791 = p1787[1].Position.Z
			local v1792 = 0
			for _, v1793 in pairs(p1787) do
				local v1794 = v1793.Position.X
				v1788 = math.min(v1788, v1794)
				local v1795 = v1793.Position.X
				v1789 = math.max(v1789, v1795)
				local v1796 = v1793.Position.Z
				v1790 = math.min(v1790, v1796)
				local v1797 = v1793.Position.Z
				v1791 = math.max(v1791, v1797)
				v1792 = v1792 + v1793.Position.Y
			end
			local v1798 = (v1788 + v1789) / 2
			local v1799 = v1792 / #p1787
			local v1800 = (v1790 + v1791) / 2
			local v1801 = Vector3.new(v1798, v1799, v1800) + Vector3.new(0, 0, 15)
			local v1802 = v1789 - v1788
			local v1803 = v1791 - v1790
			local v1804 = math.max(v1802, v1803)
			local v1805 = math.max(v1804, 80)
			local v1806 = v_u_1771.FieldOfView
			local v1807 = math.rad(v1806)
			local v1808 = v1805 * 1.35
			local v1809 = v1807 / 2
			local v1810 = v1808 / (math.tan(v1809) * 2)
			local v1811 = math.clamp(v1810, 120, 420)
			local v1812 = v1801 + Vector3.new(0, v1811, 0)
			v_u_1771.CameraType = Enum.CameraType.Scriptable
			v_u_16.TweenCreate(v_u_1771, {
				["CFrame"] = CFrame.new(v1812, v1801)
			}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false)
		end
	end
	local function v_u_1816(p1814) -- name: SetSelected
		-- upvalues: (copy) v_u_1770
		for _, v1815 in pairs(v_u_1770.Selection:GetChildren()) do
			if v1815:FindFirstChild("Button") then
				v1815.Square.ImageColor3 = Color3.fromRGB(255, 255, 255)
				v1815.Square.Size = UDim2.new(0.39, 0, 0.39, 0)
				v1815.InnerSquare.Size = UDim2.new(0.23, 0, 0.23, 0)
			end
		end
		p1814.Square.ImageColor3 = Color3.fromRGB(50, 220, 255)
		p1814.Square.Size = UDim2.new(0.42, 0, 0.42, 0)
		p1814.InnerSquare.Size = UDim2.new(0.25, 0, 0.25, 0)
	end
	local function v_u_1828() -- name: SetupPrompt
		-- upvalues: (copy) v_u_1779, (ref) v_u_39, (copy) v_u_1769, (copy) v_u_1770, (copy) v_u_1786, (copy) v_u_1813, (ref) v_u_43, (ref) v_u_1773, (ref) v_u_16, (ref) v_u_6, (ref) v_u_4, (copy) v_u_1816, (copy) v_u_1774
		v_u_1779()
		if v_u_39:GetAttribute("Phase") == "Preparation" then
			local v1817
			if v_u_1769.Team == nil or v_u_39:GetAttribute("Attacker") == nil then
				v1817 = false
			else
				v1817 = v_u_1769.Team.Name == v_u_39:GetAttribute("Attacker")
			end
			if v1817 == false then
				return
			else
				v_u_1770.Visible = true
				if v_u_1770:FindFirstChild("Selection") == nil then
					warn("AttackerPrompt missing Selection")
				else
					local v1818 = v_u_1786()
					v_u_1813(v1818)
					local v1819 = script.SampleAttackerSelection.Size
					local v1820 = v_u_43.GetResponsiveOffsetSize(v1819.X.Offset, v1819.Y.Offset)
					local v_u_1821 = false
					for _, v_u_1822 in pairs(v1818) do
						local v_u_1823 = v_u_1822:GetAttribute("SpawnName") or v_u_1822.Name
						local v_u_1824 = script.SampleAttackerSelection:Clone()
						v_u_1824.Name = v_u_1823
						v_u_1824.Parent = v_u_1770.Selection
						v_u_1824.Size = v1820
						v_u_1824.Adornee = v_u_1822
						v_u_1824.Enabled = true
						v_u_1824.Active = true
						v_u_1824.AlwaysOnTop = true
						v_u_1824.MaxDistance = 10000
						v_u_1824.SpawnName.Text = v_u_1823
						if v_u_1824:FindFirstChild("Button") then
							local v1826 = v_u_1824.Button.Activated:Connect(function()
								-- upvalues: (ref) v_u_1821, (ref) v_u_39, (ref) v_u_1769, (ref) v_u_1773, (copy) v_u_1822, (ref) v_u_16, (ref) v_u_6, (ref) v_u_4, (copy) v_u_1823, (ref) v_u_1816, (copy) v_u_1824
								if v_u_1821 == true then
									return
								else
									v_u_1821 = true
									task.delay(0.4, function()
										-- upvalues: (ref) v_u_1821
										v_u_1821 = false
									end)
									if v_u_39:GetAttribute("Phase") == "Preparation" then
										local v1825
										if v_u_1769.Team == nil or v_u_39:GetAttribute("Attacker") == nil then
											v1825 = false
										else
											v1825 = v_u_1769.Team.Name == v_u_39:GetAttribute("Attacker")
										end
										if v1825 == false then
											return
										elseif v_u_1773 ~= v_u_1822 then
											v_u_1773 = v_u_1822
											v_u_16.AddSound("Click_2", 1, true, v_u_6, false)
											v_u_4.GameEvents.AttackerSpawn:FireServer("Select", v_u_1823)
											v_u_1816(v_u_1824)
										end
									else
										return
									end
								end
							end)
							local v1827 = v_u_1774
							table.insert(v1827, v1826)
						end
					end
				end
			end
		else
			return
		end
	end
	v_u_1770:GetPropertyChangedSignal("Visible"):Connect(function()
		-- upvalues: (copy) v_u_1770, (copy) v_u_1779
		if v_u_1770.Visible == false then
			v_u_1779()
		end
	end)
	v_u_1769:WaitForChild("ServerData"):GetAttributeChangedSignal("Alive"):Connect(function()
		-- upvalues: (copy) v_u_1769, (copy) v_u_1779
		if v_u_1769.ServerData:GetAttribute("Alive") == true then
			v_u_1779()
		end
	end)
	v_u_4.GameEvents.SpawnPlayer.OnClientEvent:Connect(function()
		-- upvalues: (copy) v_u_1779
		v_u_1779()
	end)
	v_u_39:GetAttributeChangedSignal("Phase"):Connect(function()
		-- upvalues: (ref) v_u_39, (copy) v_u_1779, (copy) v_u_1828
		if v_u_39:GetAttribute("Phase") == "Preparation" then
			v_u_1828()
		else
			v_u_1779()
		end
	end)
	v_u_4.GameEvents.AttackerSpawn.OnClientEvent:Connect(function(p1829, p1830)
		-- upvalues: (copy) v_u_1770
		local v1831 = v_u_1770.Selection:FindFirstChild(p1830)
		if v1831 ~= nil then
			local v1832 = v_u_1770.Selection:FindFirstChild(p1829.Name, true)
			if v1832 == nil then
				v1832 = script.SampleAttackerPlayer:Clone()
				v1832.Name = p1829.Name
				v1832.Image = p1829.ServerData:GetAttribute("ProfilePicture")
			end
			v1832.Parent = v1831.Players
		end
	end)
	v_u_1828()
end
return v_u_43