-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local Weapon = require(ReplicatedStorage.Components.Weapon)
local ComponentsManager = require(ReplicatedStorage.ComponentsManager)
local DynamicCrosshair = require(ReplicatedStorage.Components.DynamicCrosshair)
local Config = require(ReplicatedStorage:WaitForChild("Config"))

require(ReplicatedStorage.Modules.TypeModules.Types)

local Utility = require(ReplicatedStorage.Modules.Utility)
local CameraModel = ReplicatedStorage:WaitForChild("Components"):WaitForChild("Player"):WaitForChild("CameraModel")
local t = {}
local t2 = {}
local t3 = {}

t2.__index = t3
function t.new(p1) --[[ new | Line: 125 | Upvalues: t2 (copy) ]]
	local v2 = setmetatable({}, t2)

	v2.Player = p1
	v2.Camera = workspace.CurrentCamera
	v2.CameraModel = v2:SetupCameraModel(p1)
	v2.Animations = v2:SetupAnimations(p1)
	v2.AimPart = v2.CameraModel.Base
	v2.CurrentTool = nil
	v2.CurrentToolID = 0
	v2.CurrentState = "Hold"
	v2.Holster = true
	v2.Jumping = false
	v2.QuickAction = false
	v2.ActionDebounce = false
	v2.CurrentToolIndex = 0
	v2.ADSZoom = 1
	v2.Animations.Client.Holster:Play()
	v2:SetupTools(p1)
	v2:Died(p1)
	v2:SetupCrosshair()

	return v2
end
function t3.SetupAnimations(p1, p2) --[[ SetupAnimations | Line: 159 ]]
	local t = {
		Client = {},
		Server = {}
	}

	for v1, v2 in script.Animations:GetChildren() do
		for v3, v4 in v2:GetChildren() do
			if v2.Name == "Client" then
				t[v2.Name][v4.Name] = p1.CameraModel.Humanoid:LoadAnimation(v4)

				continue
			end

			if v2.Name == "Server" then
				local Character = p2.Character

				assert(Character, "SetupAnimations failed because there is no player character")
				t[v2.Name][v4.Name] = Character.Humanoid:LoadAnimation(v4)
			end
		end
	end

	return t
end
function t3.SoundCue(p1, p2, p3, p4) --[[ SoundCue | Line: 179 ]]
	p1:ServerSoundCue(p2, p3, p4)
	p1:ClientSoundCue(p2, p3)
end
function t3.ServerSoundCue(p1, p2, p3, p4) --[[ ServerSoundCue | Line: 184 | Upvalues: ReplicatedStorage (copy) ]]
	ReplicatedStorage.GameEvents.SoundCue:FireServer(p2, p3, p4)
end
function t3.ClientSoundCue(p1, p2, p3) --[[ ClientSoundCue | Line: 188 | Upvalues: Utility (copy) ]]
	local Character = p1.Player.Character

	assert(Character, "ClientSoundCue failed because there is no player character")

	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 1)

	if not HumanoidRootPart then
		warn(Utility.formatWarnInstanceIsNil("Player.Character", "HumanoidRootPart", "ClientSoundCue failed"))

		return
	end

	local v1 = HumanoidRootPart:FindFirstChild(p2)

	if not v1 then
		warn(debug.traceback(Utility.formatWarnInstanceIsNil(("%*.Character.HumanoidRootPart"):format(p1.Player), p2, "ClientSoundCue failed")))

		return
	end

	if not v1:IsA("Sound") then
		warn(Utility.warnCustom((("ClientSoundCue failed because \"%*\" is not a sound: %*"):format(p2, v1.ClassName))))

		return
	end

	if p3 then
		v1:Play()
	else
		v1:Stop()
	end
end
function t3.SetupCameraModel(p1, p2) --[[ SetupCameraModel | Line: 209 | Upvalues: CameraModel (copy), ReplicatedStorage (copy) ]]
	p1.Camera:ClearAllChildren()

	local v1 = CameraModel:Clone()

	v1.Base.Transparency = 1
	v1.Anim.Transparency = 1
	v1.Tool.Transparency = 1
	v1["Right Hand"].Transparency = 1
	v1["Left Hand"].Transparency = 1
	v1.TestWeapon:Destroy()
	pcall(function() --[[ Line: 230 | Upvalues: p2 (copy), ReplicatedStorage (ref), v1 (copy) ]]
		local PlayerData = p2:FindFirstChild("PlayerData")

		assert(PlayerData, "SetupCameraModel failed because PlayerData is nil")

		local v12 = p2:WaitForChild("PlayerData"):WaitForChild("Loadout"):FindFirstChild(PlayerData.Settings:GetAttribute("LoadoutName"))

		assert(v12, "SetupCameraModel failed because PlayerLoadout is nil")

		local v3 = ReplicatedStorage.Items.Head[v12:GetAttribute("Head")]:WaitForChild("Body Colors")

		v1["Left Arm"].Color = v3.LeftArmColor3
		v1["Right Arm"].Color = v3.RightArmColor3
	end)
	v1.Parent = p1.Camera
	p1.ClientHighlight = v1:FindFirstChild("Highlight")

	return v1
end
function t3.ValidateToolAnimations(p1, p2, p3, p4) --[[ ValidateToolAnimations | Line: 257 | Upvalues: Utility (copy) ]]
	if not p2 then
		warn(Utility.warnCustom("ValidateToolAnimations failed because ToolData is nil"))

		return false
	end

	if not p2.Tool then
		warn(Utility.warnCustom("ValidateToolAnimations failed because ToolData.Tool is nil"))

		return false
	end

	if not p2.Animations then
		warn(Utility.warnCustom((("ValidateToolAnimations failed because %* has no Animations table"):format(p2.Tool.Name))))

		return false
	end

	if not p2.Animations.Client then
		warn(Utility.warnCustom((("ValidateToolAnimations failed because %* has no Client animations table"):format(p2.Tool.Name))))

		return false
	end

	if not p2.Animations.Server then
		warn(Utility.warnCustom((("ValidateToolAnimations failed because %* has no Server animations table"):format(p2.Tool.Name))))

		return false
	end

	for v3, v4 in ipairs(if p3 then p3 else {}) do
		if not p2.Animations.Client[v4] then
			warn(Utility.warnCustom((("Missing CLIENT animation \"%*\" for %*"):format(v4, p2.Tool.Name))))

			return false
		end
	end

	for v7, v8 in ipairs(if p4 then p4 else {}) do
		if not p2.Animations.Server[v8] then
			warn(Utility.warnCustom((("Missing SERVER animation \"%*\" for %*"):format(v8, p2.Tool.Name))))

			return false
		end
	end

	return true
end
function t3.SetupToolAnimations(p1, p2, p3) --[[ SetupToolAnimations | Line: 306 | Upvalues: Utility (copy), ReplicatedStorage (copy), Config (copy) ]]
	local t = {
		Client = {},
		Server = {}
	}

	if not p3 then
		warn(Utility.warnCustom("SetupToolAnimations failed because toolAnimationFolder is nil"))

		return t
	end

	local v1 = p1.CameraModel and p1.CameraModel:FindFirstChildOfClass("Humanoid")

	if not v1 then
		warn(Utility.warnCustom("SetupToolAnimations failed because CameraModel Humanoid is missing"))

		return t
	end

	local Character = p2.Character

	if not Character then
		warn(Utility.warnCustom("SetupToolAnimations failed because player character is missing"))

		return t
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		warn(Utility.warnCustom("SetupToolAnimations failed because character Humanoid is missing"))

		return t
	end

	for i, v in ipairs(p3:GetChildren()) do
		if v.Name == "Client" or v.Name == "Server" then
			for i2, v3 in ipairs(v:GetChildren()) do
				local v2

				if v3:IsA("Animation") then
					if v.Name == "Client" then
						local v32 = v1:LoadAnimation(v3)

						t.Client[v3.Name] = v32
						v2 = v32
					else
						local v4 = Humanoid:LoadAnimation(v3)

						t.Server[v3.Name] = v4
						v2 = v4
					end

					if v.Name == "Client" then
						if v3.Name == "Reload" then
							v2:GetMarkerReachedSignal("MagOut"):Connect(function() --[[ Line: 359 | Upvalues: p1 (copy) ]]
								if not p1.CurrentTool then
									warn("Failed to MagOut because no CurrentTool exists")

									return
								end

								local v1 = p1.CurrentTool.Model and p1.CurrentTool.Model:FindFirstChild("Handle")
								local v2 = if v1 then v1:FindFirstChild("MagOut") else v1

								if not v2 then
									return
								end

								v2:Play()
								p1:ServerSoundCue("MagOut", true, p1.CurrentTool.Model.Name)
							end)
							v2:GetMarkerReachedSignal("MagIn"):Connect(function() --[[ Line: 371 | Upvalues: p1 (copy) ]]
								if not p1.CurrentTool then
									warn("Failed to MagIn because no CurrentTool exists")

									return
								end

								local v1 = p1.CurrentTool.Model and p1.CurrentTool.Model:FindFirstChild("Handle")
								local v2 = if v1 then v1:FindFirstChild("MagIn") else v1

								if not v2 then
									return
								end

								v2:Play()
								p1:ServerSoundCue("MagIn", true, p1.CurrentTool.Model.Name)
							end)
							v2:GetMarkerReachedSignal("Insert"):Connect(function() --[[ Line: 383 | Upvalues: p1 (copy) ]]
								if not p1.CurrentTool then
									warn("Failed to Insert because no CurrentTool exists")

									return
								end

								local v1 = p1.CurrentTool.Model and p1.CurrentTool.Model:FindFirstChild("Handle")
								local v2 = if v1 then v1:FindFirstChild("Insert") else v1

								if not v2 then
									return
								end

								v2:Play()
								p1:ServerSoundCue("Insert", true, p1.CurrentTool.Model.Name)
							end)
							v2:GetMarkerReachedSignal("Reload"):Connect(function() --[[ Line: 395 | Upvalues: p1 (copy), ReplicatedStorage (ref) ]]
								if not p1.CurrentTool then
									warn("Failed to Reload because no CurrentTool exists")

									return
								end

								if p1.CurrentTool.ReloadCancel ~= false then
									return
								end

								ReplicatedStorage.GameEvents.Reload:FireServer(p1.CurrentTool.Model.Name)
							end)
							v2:GetMarkerReachedSignal("ShellInsert"):Connect(function() --[[ Line: 403 | Upvalues: p1 (copy) ]]
								if not p1.CurrentTool then
									warn("Failed to ShellInsert because no CurrentTool exists")

									return
								end

								local v1 = p1.CurrentTool.Model and p1.CurrentTool.Model:FindFirstChild("Handle")
								local v2 = if v1 then v1:FindFirstChild("ShellInsert") else v1

								if not v2 then
									return
								end

								v2:Play()
								p1:ServerSoundCue("ShellInsert", true, p1.CurrentTool.Model.Name)
							end)

							continue
						end

						if v3.Name == "Action" then
							v2:GetMarkerReachedSignal("Throw"):Connect(function() --[[ Line: 416 | Upvalues: p1 (copy), Config (ref), ReplicatedStorage (ref) ]]
								if p1.CurrentTool then
									Config.AddSound("Knife_Swing", nil, true, game.SoundService, false)
									p1:ToggleToolModelVisible(p1.CurrentTool.Model, false)
									ReplicatedStorage.GameEvents.Tactical:FireServer(p1.CurrentTool.Tool.Name, p1.Camera.CFrame.LookVector + Vector3.new(0, 0.1, 0), p1.Camera.CFrame.Position, "Throwable")
								else
									warn("Failed to Throw because no CurrentTool exists")
								end
							end)

							continue
						end

						if v3.Name == "Bolt" then
							v2:GetMarkerReachedSignal("Pull"):Connect(function() --[[ Line: 430 | Upvalues: p1 (copy) ]]
								if not p1.CurrentTool then
									warn("Failed to Pull because no CurrentTool exists")

									return
								end

								local v1 = p1.CurrentTool.Model and p1.CurrentTool.Model:FindFirstChild("Handle")
								local v2 = if v1 then v1:FindFirstChild("Pull") else v1

								if not v2 then
									return
								end

								v2:Play()
								p1:ServerSoundCue("Pull", true, p1.CurrentTool.Model.Name)
							end)
							v2:GetMarkerReachedSignal("Push"):Connect(function() --[[ Line: 442 | Upvalues: p1 (copy) ]]
								if not p1.CurrentTool then
									warn("Failed to Push because no CurrentTool exists")

									return
								end

								local v1 = p1.CurrentTool.Model and p1.CurrentTool.Model:FindFirstChild("Handle")
								local v2 = if v1 then v1:FindFirstChild("Push") else v1

								if not v2 then
									return
								end

								v2:Play()
								p1:ServerSoundCue("Push", true, p1.CurrentTool.Model.Name)
							end)

							continue
						end

						if v3.Name == "Pump" then
							v2:GetMarkerReachedSignal("Pull"):Connect(function() --[[ Line: 455 | Upvalues: p1 (copy) ]]
								if not p1.CurrentTool then
									warn("Failed to Pull-2 because no CurrentTool exists")

									return
								end

								local v1 = p1.CurrentTool.Model and p1.CurrentTool.Model:FindFirstChild("Handle")
								local v2 = if v1 then v1:FindFirstChild("Pull") else v1

								if not v2 then
									return
								end

								v2:Play()
								p1:ServerSoundCue("Pull", true, p1.CurrentTool.Model.Name)
							end)
						end
					end

					continue
				end

				warn(Utility.warnCustom((("Ignoring non-animation object inside animation folder: %*"):format((v3:GetFullName())))))
			end

			continue
		end

		warn(Utility.warnCustom((("Ignoring unknown animation folder: %*"):format((v:GetFullName())))))
	end

	return t
end
function t3.SetTools(p1, p2, p3) --[[ SetTools | Line: 474 | Upvalues: ReplicatedStorage (copy), ComponentsManager (copy), Weapon (copy) ]]
	local v1 = p3:GetAttribute("Class")

	if not (p3:IsA("Tool") and v1) then
		return
	end

	if p1.Tools == nil then
		p1.Tools = {}
	end

	if p1.Tools[v1] ~= nil then
		return
	end

	if v1 == "Primary" or v1 == "Secondary" then
		p1.Tools[v1] = {}
		p1.Tools[v1].Model = ReplicatedStorage.Items.Weapon[p3.Name]:Clone()
		ComponentsManager.Weapon.WeldWeapon(p1.Tools[v1].Model)
		p1.Tools[v1].Model.Parent = script.ReserveModels
		ComponentsManager.Weapon.SetFullAttachmentOnWeapon(p1.Tools[v1].Model, p2)

		local PlayerData = p2:FindFirstChild("PlayerData")

		Weapon.SetAttachmentSkins(p1.Tools[v1].Model, PlayerData.Loadout[PlayerData.Settings:GetAttribute("LoadoutName")], v1)
		ComponentsManager.Weapon.SetSkinOnWep(p1.Tools[v1].Model, p3:GetAttribute("Skin"))
		ComponentsManager.Weapon.SetupWeaponEffects(p1.Tools[v1].Model)
		ComponentsManager.Weapon.SetModelProperties(p1.Tools[v1].Model, false, false)
		ComponentsManager.Weapon.SetPlayerArmSkin(p1.CameraModel, p2)
		p1.Tools[v1].Tool = p3
		p1.Tools[v1].Stats = {}
		p1.Tools[v1].Settings = require(p3:WaitForChild("Settings", 1))
		p1.Tools[v1].Settings.HRecoil = p1.Tools[v1].Settings.HRecoil * (100 - p1.Tools[v1].Model:GetAttribute("Horizontal") * 0.01)
		p1.Tools[v1].Settings.VRecoil = p1.Tools[v1].Settings.VRecoil * (100 - p1.Tools[v1].Model:GetAttribute("Vertical") * 0.01)
		p1.Tools[v1].Settings.HipFireReduction = p1.Tools[v1].Model:GetAttribute("HipFireReduction")

		local v2, v3 = p1:GetADSZoom(p1.Tools[v1].Model)

		p1.Tools[v1].Settings.ADSZoom = v2
		p1.Tools[v1].Settings.SightFront = v3
		p1.Tools[v1].CrosshairSpread = p1.Tools[v1].Settings.MaxSpread * (1 - p1.Tools[v1].Settings.HipFireReduction / 100)
		p1.Tools[v1].Aiming = false
		p1.Tools[v1].ReloadCancel = false
		p1.Tools[v1].Reloading = false
		p1.Tools[v1].Bolting = false
		p1.Tools[v1].Pumping = false
		p1.Tools[v1].SemiCooldown = false
		p1.Tools[v1].Animations = p1:SetupToolAnimations(p2, p3:WaitForChild("Settings"):WaitForChild("Animations"))
	else
		p1.Tools[v1] = {}
		p1.Tools[v1].Model = ReplicatedStorage.Items[v1][p3.Name]:Clone()
		ComponentsManager.Weapon.WeldWeapon(p1.Tools[v1].Model)
		p1.Tools[v1].Model.Parent = script.ReserveModels
		p1.Tools[v1].Tool = p3
		p1.Tools[v1].Stats = {}
		p1.Tools[v1].Animations = p1:SetupToolAnimations(p2, (p1.Tools[v1].Model:FindFirstChild("Handle") or p1.Tools[v1].Model:FindFirstChild("Base")).Animations)
	end

	p1:DetachToolModelFromArm(p1.Tools[v1].Model)
end
function t3.SetupTools(p1, p2) --[[ SetupTools | Line: 545 ]]
	p1.Tools = {}
	script.Parent.Parent.Tools.ChildAdded:Connect(function(p12) --[[ Line: 549 | Upvalues: p1 (copy), p2 (copy) ]]
		p1:SetTools(p2, p12)
	end)

	for v1, v2 in script.Parent.Parent.Tools:GetChildren() do
		p1:SetTools(p2, v2)
	end
end
function t3.Died(p1, p2) --[[ Died | Line: 558 ]]
	local Character = p1.Player.Character

	assert(Character, "Died failed because there is no player character")
	Character:WaitForChild("Humanoid").Died:Connect(function() --[[ Line: 562 | Upvalues: p1 (copy) ]]
		p1.CameraModel:Destroy()
		p1.CurrentTool = nil
		p1.Crosshair:Disable()
	end)
end
function t3.SetupCrosshair(p1) --[[ SetupCrosshair | Line: 569 | Upvalues: Config (copy), DynamicCrosshair (copy) ]]
	if Config.Crosshair then
		local Crosshair = p1.Player.PlayerGui.Crosshair

		Crosshair:ClearAllChildren()
		p1.Crosshair = DynamicCrosshair.New(Crosshair, 0, 150, 200, 0, false)
		p1.Crosshair.EasingStyle = Enum.EasingStyle.Sine
		p1.Crosshair.EasingDirection = Enum.EasingDirection.InOut
		p1.Crosshair:Size(6, 2)
		p1.Crosshair:Display({
			BackgroundTransparency = 0.6,
			BorderSizePixel = 0,
			Image = nil,
			ImageTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		})
	end
end
function t3.GetToolAnimationFolder(p1, p2, p3) --[[ GetToolAnimationFolder | Line: 604 ]]
	if not p2 then
		return nil
	end

	local function IsValidAnimationFolder(p1) --[[ IsValidAnimationFolder | Line: 609 ]]
		if not p1 then
			return false
		end

		if not p1:IsA("Folder") then
			return false
		end

		if p1.Name ~= "Animations" then
			return false
		end

		if p1:FindFirstChild("Client") then
			return p1:FindFirstChild("Server") and true or false
		end

		return false
	end

	local function FindAnimationsInside(p1) --[[ FindAnimationsInside | Line: 633 ]]
		if not p1 then
			return nil
		end

		local Animations = p1:FindFirstChild("Animations")

		if if Animations and (Animations:IsA("Folder") and (Animations.Name == "Animations" and Animations:FindFirstChild("Client"))) then if Animations:FindFirstChild("Server") then true else false else false then
			return Animations
		end

		local Settings = p1:FindFirstChild("Settings")

		if Settings then
			local Animations2 = Settings:FindFirstChild("Animations")

			if if Animations2 and (Animations2:IsA("Folder") and (Animations2.Name == "Animations" and Animations2:FindFirstChild("Client"))) then if Animations2:FindFirstChild("Server") then true else false else false then
				return Animations2
			end
		end

		for i, v in ipairs(p1:GetDescendants()) do
			if if v and (v:IsA("Folder") and (v.Name == "Animations" and v:FindFirstChild("Client"))) then if v:FindFirstChild("Server") then true else false else false then
				return v
			end
		end

		return nil
	end

	local v1 = FindAnimationsInside(p2.Tool)

	if v1 then
		return v1
	end

	local v2 = FindAnimationsInside(p2.Model)

	if v2 then
		return v2
	end

	return nil
end
function t3.SwapTools(p1, p2) --[[ SwapTools | Line: 678 | Upvalues: Utility (copy), ReplicatedStorage (copy) ]]
	if not p1.CameraModel then
		warn(Utility.warnCustom("Failed to swap tools because CameraModel is nil"))

		return false
	end

	if not p1.CameraModel:FindFirstChild("Tool") then
		warn(Utility.warnCustom("Failed to swap tools because CameraModel.Tool is missing"))

		return false
	end

	p1:SetFP(p1.Player)

	local v1

	if p2 == 1 then
		v1 = "Primary"
	elseif p2 == 2 then
		v1 = "Secondary"
	elseif p2 == 3 then
		v1 = "Knife"
	else
		if p2 ~= 4 then
			warn(Utility.warnCustom((("Failed to swap tools because weapon index %* is invalid"):format(p2))))

			return false
		end

		v1 = "Throwable"
	end

	local v2 = p1.Tools and p1.Tools[v1]

	if v2 then
		if not v2.Tool then
			warn(Utility.warnCustom((("Failed to swap tools because ToolData.Tool for %* is nil"):format(v1))))

			return false
		end

		if not v2.Model then
			warn(Utility.warnCustom((("Failed to swap tools because ToolData.Model for %* is nil"):format(v2.Tool.Name))))

			return false
		end

		local v3 = p1:GetToolAnimationFolder(v2, v1)

		if v3 then
			if not p1:ValidateToolAnimations(v2, { "Equip", "Hold" }, { "Equip", "Hold" }) then
				v2.Animations = p1:SetupToolAnimations(p1.Player, v3)
				warn(Utility.warnCustom((("Weapon animation repatch activated for %*"):format(v2.Tool.Name))))
			end

			if not p1:ValidateToolAnimations(v2, { "Equip", "Hold" }, { "Equip", "Hold" }) then
				warn(Utility.warnCustom((("Failed to swap to %* because required Equip/Hold animations are missing"):format(v2.Tool.Name))))

				return false
			end

			local v4 = pairs

			for v6, v7 in v4(p1.Tools or {}) do
				if v7 and v7.Model then
					p1:DetachToolModelFromArm(v7.Model)
				end
			end

			p1:AttachToolModelToArm(v2.Model)
			p1.CurrentTool = v2
			p1.CurrentToolID = math.random(-100, 100)
			p1.CurrentToolIndex = p2
			ReplicatedStorage.GameEvents.SwapWeapon:FireServer(p1.CurrentTool.Tool.Name)
			p1:MagazineActivation()
			p1:StopOtherToolsAnimations()
			p1.CurrentTool.Animations.Client.Equip:Play()
			p1.CurrentTool.Animations.Client.Hold:Play()
			p1.CurrentTool.Animations.Server.Equip:Play()
			p1.CurrentTool.Animations.Server.Hold:Play()
			p1.CurrentState = "Hold"

			if p1.CurrentTool.Bolting == true then
				p1:Bolt()
			elseif p1.CurrentTool.Pumping == true then
				p1:Pump()
			end

			if p1.Crosshair then
				if v2.CrosshairSpread then
					p1.Crosshair:Enable()
					p1.Crosshair:FollowMouse(false)
					p1.Crosshair:Size(6, 2)

					local v8 = v2.CrosshairSpread * 10

					if v8 < p1.Crosshair.Spreading.MinSpread then
						p1.Crosshair.Spreading.MinSpread = v8
						p1.Crosshair:SmoothSet(v8, 0.06)
					else
						p1.Crosshair:SmoothSet(v8, 0.06)
						p1.Crosshair.Spreading.MinSpread = v8
					end
				else
					p1.Crosshair:Size(3, 3)
					p1.Crosshair.Spreading.MinSpread = 0
					p1.Crosshair:SmoothSet(0, 0.06)
				end
			end

			p1:SoundCue("Equip", true)

			return true
		end

		warn(Utility.warnCustom((("Failed to swap tools because %* has no valid Animations folder with Client and Server folders. Checked Tool and Model."):format(v2.Tool.Name))))

		if v2.Tool then
			warn(Utility.warnCustom((("Tool path: %*"):format((v2.Tool:GetFullName())))))
		end

		if not v2.Model then
			return false
		end

		warn(Utility.warnCustom((("Model path: %*"):format((v2.Model:GetFullName())))))

		return false
	end

	if v1 == "Throwable" then
		return false
	end

	warn(Utility.warnCustom((("Failed to swap tools because ToolData for %* is nil"):format(v1))))

	return false
end
function t3.AttachToolModelToArm(p1, p2) --[[ AttachToolModelToArm | Line: 810 ]]
	local v1 = p2:FindFirstChild("Handle") or p2:FindFirstChild("Base")

	if not (p1.CameraModel and v1) then
		return
	end

	p2.Parent = p1.CameraModel

	local Motor = v1:FindFirstChild("Motor")

	if Motor == nil then
		local Motor2 = Instance.new("Motor6D", v1)

		Motor2.Name = "Motor"
		Motor = Motor2
	end

	Motor.Part1 = v1
	Motor.Part0 = p1.CameraModel.Tool
	v1.Anchored = false
	Motor.C1 = CFrame.new(0, 0, 0)
	p1.AimPart = p2:FindFirstChild("Aim")
end
function t3.DetachToolModelFromArm(p1, p2) --[[ DetachToolModelFromArm | Line: 832 | Upvalues: Utility (copy) ]]
	local v1 = p2:FindFirstChild("Handle") or p2:FindFirstChild("Base")

	if not (p1.CameraModel and v1) then
		return
	end

	local Motor = v1:FindFirstChild("Motor")

	if Motor == nil then
		local Motor2 = Instance.new("Motor6D", v1)

		Motor2.Name = "Motor"
		Motor = Motor2
	end

	Motor.Part1 = v1

	if p1.CameraModel and p1.CameraModel:FindFirstChild("Base") then
		Motor.Part0 = p1.CameraModel.Base
	else
		warn(Utility.formatWarnInstanceIsNil("self.CameraModel", "Base"))
	end

	v1.Anchored = false
	Motor.C1 = CFrame.new(0, 0, -10)
	p2.Parent = script.ReserveModels
end
function t3.MagazineActivation(p1) --[[ MagazineActivation | Line: 858 ]]
	for k, v in pairs(p1.Tools) do
		local MagazineDisabled = v.Model:FindFirstChild("Magazine", true)

		if MagazineDisabled then
			MagazineDisabled.Name = "MagazineDisabled"
		end
	end

	local Magazine = p1.CurrentTool.Model:FindFirstChild("MagazineDisabled")

	if not Magazine then
		return
	end

	Magazine.Name = "Magazine"
end
function t3.StopOtherToolsAnimations(p1) --[[ StopOtherToolsAnimations | Line: 872 ]]
	local v1 = pairs

	for v3, v4 in v1(p1.Tools or {}) do
		local v5 = pairs

		for v7, v8 in v5(v4.Animations or {}) do
			for k, v in pairs(v8) do
				if v and (typeof(v) == "Instance" and v:IsA("AnimationTrack")) then
					v:Stop()
				end
			end
		end
	end
end
function t3.ToggleToolModelVisible(p1, p2, p3) --[[ ToggleToolModelVisible | Line: 884 ]]
	if p3 == true then
		for k, v in pairs(p2:GetChildren()) do
			if v:IsA("BasePart") and (v.Name ~= "Base" and v.Name ~= "Handle") then
				v.Transparency = 0
			end
		end
	else
		for k, v in pairs(p2:GetChildren()) do
			if v:IsA("BasePart") and (v.Name ~= "Base" and v.Name ~= "Handle") then
				v.Transparency = 1
			end
		end
	end
end
function t3.Vault(p1) --[[ Vault | Line: 900 ]]
	p1:SoundCue("Vault", true)

	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to Vault because no CurrentTool exists")

	if CurrentTool.Aiming == false then
		p1.Animations.Client.Vault:Play()
		p1.Animations.Client.Vault:AdjustSpeed(1.2)
	end

	p1.Animations.Server.Vault:Play()
end
function t3.ADS(p1) --[[ ADS | Line: 913 ]]
	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to ADS because no CurrentTool exists")
	CurrentTool.Animations.Client.Equip:AdjustSpeed(20)
	p1.CurrentState = "ADS"
	CurrentTool.Aiming = true
	p1:SoundCue("ADS", true)

	if p1.Crosshair then
		p1.Crosshair:Disable()
	end

	if CurrentTool.Animations.Client.Reload then
		CurrentTool.ReloadCancel = true
		CurrentTool.Animations.Client.Reload:Stop()
		CurrentTool.Animations.Server.Reload:Stop()
	end

	if CurrentTool.Settings.SightFront then
		CurrentTool.Settings.SightFront.Transparency = 1
	end

	p1:StopCurrentToolAnimation(true)
end
function t3.ReleaseADS(p1) --[[ ReleaseADS | Line: 939 ]]
	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to ReleaseADS because no CurrentTool exists")
	p1.CurrentState = "Hold"
	CurrentTool.Aiming = false
	p1:SoundCue("ADSRelease", true)

	if p1.Crosshair then
		p1.Crosshair:Enable()
	end

	if not CurrentTool.Settings.SightFront then
		return
	end

	CurrentTool.Settings.SightFront.Transparency = 0
end
function t3.Inspect(p1) --[[ Inspect | Line: 955 ]]
	p1.CurrentState = "Inspect"

	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to Inspect because no CurrentTool exists")
	CurrentTool.Animations.Client.Inspect:Play()

	if not CurrentTool.Animations.Client.Reload then
		return
	end

	CurrentTool.ReloadCancel = true
	CurrentTool.Animations.Client.Reload:Stop()
	CurrentTool.Animations.Server.Reload:Stop()
end
function t3.Bolt(p1) --[[ Bolt | Line: 969 ]]
	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to Bolt because no CurrentTool exists")
	CurrentTool.Bolting = true

	if CurrentTool.Animations.Client.Bolt and CurrentTool.Animations.Server.Bolt then
		CurrentTool.Animations.Client.Bolt:Play()
		CurrentTool.Animations.Server.Bolt:Play()
	end

	if CurrentTool.Animations.Client.Bolt then
		CurrentTool.Animations.Client.Bolt.Stopped:Wait()
	end

	if CurrentTool ~= CurrentTool then
		return
	end

	CurrentTool.Bolting = false
end
function t3.Pump(p1) --[[ Pump | Line: 990 ]]
	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to Pump-1 because no CurrentTool exists")
	CurrentTool.Pumping = true

	if CurrentTool.Animations.Client.Pump and CurrentTool.Animations.Server.Pump then
		CurrentTool.Animations.Client.Pump:Play()
		CurrentTool.Animations.Server.Pump:Play()
	end

	if CurrentTool.Animations.Client.Pump then
		CurrentTool.Animations.Client.Pump.Stopped:Wait()
	end

	if CurrentTool ~= p1.CurrentTool then
		return
	end

	CurrentTool.Pumping = false
end
function t3.HolsterWeapon(p1, p2) --[[ HolsterWeapon | Line: 1010 ]]
	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to HolsterWeapon because no CurrentTool exists")

	if p2 == false then
		p1.Holster = false
		p1:DetachToolModelFromArm(CurrentTool.Model)

		return
	end

	if p2 ~= true then
		return
	end

	p1.Holster = true
	p1:AttachToolModelToArm(CurrentTool.Model)
end
function t3.Shoot(p1) --[[ Shoot | Line: 1023 | Upvalues: Config (copy) ]]
	if p1.CurrentTool and p1.CurrentTool.Animations.Client.Shoot then
		p1.CurrentTool.Animations.Client.Shoot:Play()
	end

	if Config.Crosshair ~= true or not (p1.Crosshair and (p1.CurrentTool and p1.CurrentTool.CrosshairSpread)) then
		return
	end

	p1.Crosshair:SmoothSet(p1.CurrentTool.CrosshairSpread * 10 + 20, 0.05)
end
function t3.Reload(p1) --[[ Reload | Line: 1034 ]]
	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to Reload-0 because no CurrentTool exists")
	p1.CurrentState = "Reload"
	CurrentTool.Animations.Client.Inspect:Stop()
	CurrentTool.ReloadCancel = false
	CurrentTool.Reloading = true
	CurrentTool.Animations.Client.Reload:Play()
	CurrentTool.Animations.Server.Reload:Play()
	CurrentTool.Animations.Client.Reload.Stopped:Wait()
	CurrentTool.Animations.Server.Reload:Stop()
	CurrentTool.Reloading = false

	if p1.CurrentTool ~= CurrentTool or CurrentTool.ReloadCancel ~= false then
		return
	end

	p1.CurrentState = "Hold"
end
function t3.Action(p1, p2) --[[ Action | Line: 1057 ]]
	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to Action-2 because no CurrentTool exists")

	if not CurrentTool.Animations.Client.Action then
		return
	end

	if p2 == "Knife" then
		p1:StopCurrentToolAnimation(true)
		CurrentTool.Animations.Client.Action:Play()
		CurrentTool.Animations.Server.Action:Play()

		if CurrentTool.Model.Handle:FindFirstChild("Action") then
			CurrentTool.Model.Handle:FindFirstChild("Action"):Play()
			p1:ServerSoundCue("Action", true, CurrentTool.Model.Name)
		end
	else
		if p2 ~= "Throwable" or p1.ActionDebounce ~= false then
			return
		end

		p1.ActionDebounce = true

		local CurrentTool2 = p1.CurrentTool

		assert(CurrentTool2, "Failed to Action because no CurrentTool exists")
		p1:ToggleToolModelVisible(CurrentTool2.Model, true)
		p1:StopCurrentToolAnimation(true)
		CurrentTool2.Animations.Client.Action:Play()
		CurrentTool2.Animations.Server.Action:Play()

		if CurrentTool2.Model.Handle:FindFirstChild("Action") then
			CurrentTool2.Model.Handle:FindFirstChild("Action"):Play()
			p1:ServerSoundCue("Action", true, CurrentTool2.Model.Name)
		end

		CurrentTool2.Animations.Client.Action.Stopped:Wait()
		p1:ToggleToolModelVisible(CurrentTool2.Model, true)
		p1.ActionDebounce = false
	end
end
function t3.StopCurrentToolAnimation(p1, p2) --[[ StopCurrentToolAnimation | Line: 1106 ]]
	local CurrentTool = p1.CurrentTool

	assert(CurrentTool, "Failed to StopCurrentToolAnimation because no CurrentTool exists")

	for k, v in pairs(CurrentTool.Animations.Client) do
		if p2 == true and k ~= "Hold" or p2 ~= true then
			v:Stop()
		end
	end

	for k, v in pairs(CurrentTool.Animations.Server) do
		if p2 == true and k ~= "Hold" or p2 ~= true then
			v:Stop()
		end
	end

	for k, v in pairs(p1.Animations.Client) do
		if k ~= "Run" then
			v:Stop()
		end
	end
end
function t3.GetADSZoom(p1, p2) --[[ GetADSZoom | Line: 1133 | Upvalues: CollectionService (copy) ]]
	local v1 = 1
	local v2 = nil

	for k, v in pairs(p2:GetChildren()) do
		if CollectionService:HasTag(v, "Sight") then
			local v3 = v:GetAttribute("Zoom")
			local Front = v:FindFirstChild("Front")

			v1 = v3
			v2 = Front
		end
	end

	return v1, v2
end
function t3.SetFP(p1, p2) --[[ SetFP | Line: 1146 | Upvalues: UserInputService (copy) ]]
	local ServerData = p2:FindFirstChild("ServerData")

	assert(ServerData, "Failed to SetFP because no ServerData folder exists")

	local Character = p2.Character

	assert(Character, "Failed to SetFP because no character exists")

	if ServerData:GetAttribute("Alive") ~= true or UserInputService.MouseIconEnabled == false and (p1.Camera.CameraType == Enum.CameraType.Custom and (p1.Camera.CameraSubject == Character.Humanoid and (p2.CameraMinZoomDistance == 0.5 and p2.CameraMaxZoomDistance == 0.5))) then
		return
	end

	UserInputService.MouseIconEnabled = false
	p1.Camera.CameraType = Enum.CameraType.Custom
	p1.Camera.CameraSubject = Character.Humanoid
	p2.CameraMinZoomDistance = 0.5
	p2.CameraMaxZoomDistance = 0.5
end
function t3.WeaponRuntime(p1, p2) --[[ WeaponRuntime | Line: 1173 ]]
	p1.CameraModel.Base.CFrame = p1.Camera.CFrame * CFrame.new(0, 0, -0.5)
end

return t