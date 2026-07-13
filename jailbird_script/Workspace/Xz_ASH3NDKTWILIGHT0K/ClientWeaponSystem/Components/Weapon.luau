local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("CollectionService")
local v_u_3 = game:GetService("UserInputService")
local v_u_4 = require(v_u_1.Components.Weapon)
local v_u_5 = require(v_u_1.ComponentsManager)
local v_u_6 = require(v_u_1.Components.DynamicCrosshair)
local v_u_7 = require(v_u_1.Components.Throwable)
local v_u_8 = require(v_u_1:WaitForChild("Config"))
require(v_u_1.Modules.TypeModules.Types)
local v_u_9 = require(v_u_1.Modules.Utility)
local v_u_10 = require(v_u_1.Modules.WeaponSlotResolver)
local v11 = script.Parent.Parent:WaitForChild("Modules")
local v_u_12 = require(v11:WaitForChild("WeaponInventoryController"))
local v_u_13 = require(v11:WaitForChild("WeaponStateReplicator"))
local v_u_14 = v_u_1:WaitForChild("Components"):WaitForChild("Player"):WaitForChild("CameraModel")
local v_u_15 = v_u_1:WaitForChild("GameEvents"):WaitForChild("ReplayAudioCue")
local v_u_16 = {
	["ADS"] = true,
	["ADSRelease"] = true,
	["Crouch"] = true,
	["Lean"] = true,
	["Prone"] = true,
	["Run"] = true,
	["Stand"] = true,
	["Vault"] = true
}
local v17 = {}
local v_u_18 = {}
local v19 = {}
v_u_18.__index = v19
function v17.new(p20) -- name: new
	-- upvalues: (copy) v_u_18, (copy) v_u_13, (copy) v_u_1, (copy) v_u_10
	local v21 = v_u_18
	local v22 = setmetatable({}, v21)
	v22.Player = p20
	v22.Camera = workspace.CurrentCamera
	v22.CameraModel = v22:SetupCameraModel(p20)
	v22.Animations = v22:SetupAnimations(p20)
	v22.AimPart = v22.CameraModel.Base
	v22.CurrentTool = nil
	v22.CurrentToolID = 0
	v22.CurrentState = "Hold"
	v22.Holster = true
	v22.Jumping = false
	v22.QuickAction = false
	v22.ActionDebounce = false
	v22.CurrentToolIndex = 0
	v22.ADSZoom = 1
	v22.SpawnEquipPresentationPending = true
	v22.ThrowableSnapshot = nil
	v22.StateFolder = nil
	v22.StateReplicator = v_u_13.new(v_u_1.GameEvents, nil)
	v22.InventoryDisconnect = nil
	v22.ClientWeaponSystemScript = v_u_10.ResolveClientWeaponSystem(p20.Character)
	v22:SetupTools(p20)
	v22:Died(p20)
	v22:SetupCrosshair()
	v22:SetFP(p20)
	v22:SetReadinessState(false, false, false, false)
	return v22
end
function v19.SetupAnimations(p23, p24) -- name: SetupAnimations
	local v25 = {
		["Client"] = {},
		["Server"] = {}
	}
	for _, v26 in script.Animations:GetChildren() do
		for _, v27 in v26:GetChildren() do
			if v26.Name == "Client" then
				v25[v26.Name][v27.Name] = p23.CameraModel.Humanoid:LoadAnimation(v27)
			elseif v26.Name == "Server" then
				local v28 = p24.Character
				assert(v28, "SetupAnimations failed because there is no player character")
				v25[v26.Name][v27.Name] = v28.Humanoid:LoadAnimation(v27)
			end
		end
	end
	return v25
end
local function v_u_38(p29, p30, p31) -- name: ResolveSoundCueInstance
	local v32 = p29.Player.Character
	if not v32 then
		return nil
	end
	local v33 = v32:FindFirstChild("HumanoidRootPart")
	local v34
	if v33 then
		v34 = v33:FindFirstChild(p30)
	else
		v34 = nil
	end
	if not v34 and (typeof(p31) == "string" and p31 ~= "") then
		local v35 = v32:FindFirstChild(p31, true)
		if v35 then
			v35 = v35:FindFirstChild("Handle", true)
		end
		if v35 then
			v34 = v35:FindFirstChild(p30) or nil
		else
			v34 = nil
		end
	end
	if not v34 and (p29.CurrentTool and p29.CurrentTool.Model) then
		local v36 = p29.CurrentTool.Model:FindFirstChild("Handle", true)
		if v36 then
			v34 = v36:FindFirstChild(p30) or nil
		else
			v34 = nil
		end
	end
	if not v34 then
		for _, v37 in ipairs(v32:GetDescendants()) do
			if v37:IsA("Sound") and v37.Name == p30 then
				v34 = v37
				break
			end
		end
	end
	if v34 and v34:IsA("Sound") then
		return v34
	else
		return nil
	end
end
local function v_u_44(p39, p40, p41, p42) -- name: EmitReplayAudioCue
	-- upvalues: (copy) v_u_16, (copy) v_u_38, (copy) v_u_15
	if v_u_16[p40] == true then
		local v43 = v_u_38(p39, p40, p42)
		if v43 then
			v_u_15:FireServer({
				["CueType"] = p40,
				["IsPlaying"] = p41,
				["Looped"] = v43.Looped == true,
				["SoundId"] = v43.SoundId,
				["SoundName"] = v43.Name,
				["Volume"] = v43.Volume,
				["PlaybackSpeed"] = v43.PlaybackSpeed,
				["RollOffMinDistance"] = v43.RollOffMinDistance,
				["RollOffMaxDistance"] = v43.RollOffMaxDistance
			})
		end
	else
		return
	end
end
function v19.SoundCue(p45, p46, p47, p48) -- name: SoundCue
	-- upvalues: (copy) v_u_44
	p45:ServerSoundCue(p46, p47, p48)
	v_u_44(p45, p46, p47, p48)
	p45:ClientSoundCue(p46, p47, p48)
end
function v19.ServerSoundCue(_, p49, p50, p51) -- name: ServerSoundCue
	-- upvalues: (copy) v_u_1
	v_u_1.GameEvents.SoundCue:FireServer(p49, p50, p51)
end
function v19.ClientSoundCue(p52, p53, p54, p55) -- name: ClientSoundCue
	-- upvalues: (copy) v_u_38
	local v56 = v_u_38(p52, p53, p55)
	if v56 then
		if p54 then
			v56:Play()
		else
			v56:Stop()
		end
	else
		return
	end
end
function v19.SetupCameraModel(p57, p_u_58) -- name: SetupCameraModel
	-- upvalues: (copy) v_u_14, (copy) v_u_1
	p57.Camera:ClearAllChildren()
	local v_u_59 = v_u_14:Clone()
	v_u_59.Base.Transparency = 1
	v_u_59.Anim.Transparency = 1
	v_u_59.Tool.Transparency = 1
	v_u_59["Right Hand"].Transparency = 1
	v_u_59["Left Hand"].Transparency = 1
	v_u_59.TestWeapon:Destroy()
	pcall(function()
		-- upvalues: (copy) p_u_58, (ref) v_u_1, (copy) v_u_59
		local v60 = p_u_58:FindFirstChild("PlayerData")
		assert(v60, "SetupCameraModel failed because PlayerData is nil")
		local v61 = p_u_58:WaitForChild("PlayerData"):WaitForChild("Loadout"):FindFirstChild(v60.Settings:GetAttribute("LoadoutName"))
		assert(v61, "SetupCameraModel failed because PlayerLoadout is nil")
		local v62 = v61:GetAttribute("Head")
		local v63 = v_u_1.Items.Head[v62]:WaitForChild("Body Colors")
		v_u_59["Left Arm"].Color = v63.LeftArmColor3
		v_u_59["Right Arm"].Color = v63.RightArmColor3
	end)
	v_u_59.Parent = p57.Camera
	p57.ClientHighlight = v_u_59:FindFirstChild("Highlight")
	return v_u_59
end
function v19.ValidateToolAnimations(_, p64, p65, p66) -- name: ValidateToolAnimations
	-- upvalues: (copy) v_u_9
	if not p64 then
		warn(v_u_9.warnCustom("ValidateToolAnimations failed because ToolData is nil"))
		return false
	end
	if not p64.Tool then
		warn(v_u_9.warnCustom("ValidateToolAnimations failed because ToolData.Tool is nil"))
		return false
	end
	if not p64.Animations then
		warn(v_u_9.warnCustom((("ValidateToolAnimations failed because %* has no Animations table"):format(p64.Tool.Name))))
		return false
	end
	if not p64.Animations.Client then
		warn(v_u_9.warnCustom((("ValidateToolAnimations failed because %* has no Client animations table"):format(p64.Tool.Name))))
		return false
	end
	if not p64.Animations.Server then
		warn(v_u_9.warnCustom((("ValidateToolAnimations failed because %* has no Server animations table"):format(p64.Tool.Name))))
		return false
	end
	for _, v67 in ipairs(p65 or {}) do
		if not p64.Animations.Client[v67] then
			warn(v_u_9.warnCustom((("Missing CLIENT animation \"%*\" for %*"):format(v67, p64.Tool.Name))))
			return false
		end
	end
	for _, v68 in ipairs(p66 or {}) do
		if not p64.Animations.Server[v68] then
			warn(v_u_9.warnCustom((("Missing SERVER animation \"%*\" for %*"):format(v68, p64.Tool.Name))))
			return false
		end
	end
	return true
end
function v19.SetupToolAnimations(p_u_69, p70, p71) -- name: SetupToolAnimations
	-- upvalues: (copy) v_u_9, (copy) v_u_1, (copy) v_u_8, (copy) v_u_7
	local v72 = {
		["Client"] = {},
		["Server"] = {}
	}
	if p71 then
		local v73 = p_u_69.CameraModel
		if v73 then
			v73 = p_u_69.CameraModel:FindFirstChildOfClass("Humanoid")
		end
		if v73 then
			local v74 = p70.Character
			if v74 then
				local v75 = v74:FindFirstChildOfClass("Humanoid")
				if v75 then
					for _, v76 in ipairs(p71:GetChildren()) do
						if v76.Name == "Client" or v76.Name == "Server" then
							for _, v77 in ipairs(v76:GetChildren()) do
								if v77:IsA("Animation") then
									local v78
									if v76.Name == "Client" then
										v78 = v73:LoadAnimation(v77)
										v72.Client[v77.Name] = v78
									else
										v78 = v75:LoadAnimation(v77)
										v72.Server[v77.Name] = v78
									end
									if v76.Name == "Client" then
										if v77.Name == "Reload" then
											v78:GetMarkerReachedSignal("MagOut"):Connect(function()
												-- upvalues: (copy) p_u_69
												if p_u_69.CurrentTool then
													local v79 = p_u_69.CurrentTool.Model
													if v79 then
														v79 = p_u_69.CurrentTool.Model:FindFirstChild("Handle")
													end
													if v79 then
														v79 = v79:FindFirstChild("MagOut")
													end
													if v79 then
														v79:Play()
														p_u_69:ServerSoundCue("MagOut", true, p_u_69.CurrentTool.Model.Name)
													end
												else
													warn("Failed to MagOut because no CurrentTool exists")
												end
											end)
											v78:GetMarkerReachedSignal("MagIn"):Connect(function()
												-- upvalues: (copy) p_u_69
												if p_u_69.CurrentTool then
													local v80 = p_u_69.CurrentTool.Model
													if v80 then
														v80 = p_u_69.CurrentTool.Model:FindFirstChild("Handle")
													end
													if v80 then
														v80 = v80:FindFirstChild("MagIn")
													end
													if v80 then
														v80:Play()
														p_u_69:ServerSoundCue("MagIn", true, p_u_69.CurrentTool.Model.Name)
													end
												else
													warn("Failed to MagIn because no CurrentTool exists")
												end
											end)
											v78:GetMarkerReachedSignal("Insert"):Connect(function()
												-- upvalues: (copy) p_u_69
												if p_u_69.CurrentTool then
													local v81 = p_u_69.CurrentTool.Model
													if v81 then
														v81 = p_u_69.CurrentTool.Model:FindFirstChild("Handle")
													end
													if v81 then
														v81 = v81:FindFirstChild("Insert")
													end
													if v81 then
														v81:Play()
														p_u_69:ServerSoundCue("Insert", true, p_u_69.CurrentTool.Model.Name)
													end
												else
													warn("Failed to Insert because no CurrentTool exists")
												end
											end)
											v78:GetMarkerReachedSignal("Reload"):Connect(function()
												-- upvalues: (copy) p_u_69, (ref) v_u_1
												if p_u_69.CurrentTool then
													if p_u_69.CurrentTool.ReloadCancel == false then
														v_u_1.GameEvents.Reload:FireServer(p_u_69.CurrentTool.Model.Name)
													end
												else
													warn("Failed to Reload because no CurrentTool exists")
												end
											end)
											v78:GetMarkerReachedSignal("ShellInsert"):Connect(function()
												-- upvalues: (copy) p_u_69
												if p_u_69.CurrentTool then
													local v82 = p_u_69.CurrentTool.Model
													if v82 then
														v82 = p_u_69.CurrentTool.Model:FindFirstChild("Handle")
													end
													if v82 then
														v82 = v82:FindFirstChild("ShellInsert")
													end
													if v82 then
														v82:Play()
														p_u_69:ServerSoundCue("ShellInsert", true, p_u_69.CurrentTool.Model.Name)
													end
												else
													warn("Failed to ShellInsert because no CurrentTool exists")
												end
											end)
										elseif v77.Name == "Action" then
											v78:GetMarkerReachedSignal("Throw"):Connect(function()
												-- upvalues: (copy) p_u_69, (ref) v_u_8, (ref) v_u_7, (ref) v_u_1
												if p_u_69.CurrentTool then
													v_u_8.AddSound("Knife_Swing", nil, true, game.SoundService, false)
													p_u_69:ToggleToolModelVisible(p_u_69.CurrentTool.Model, false)
													local v83 = p_u_69.ThrowableSnapshot
													if not v83 then
														local v84 = p_u_69.Player.Character
														if v84 then
															v84 = v_u_7.BuildClientThrowData(v84, p_u_69.Camera, p_u_69.Player.PlayerGui.Crosshair, p_u_69.CurrentTool.Model, {
																v84,
																p_u_69.Camera,
																p_u_69.CameraModel,
																p_u_69.CurrentTool.Model
															})
														end
														if v84 then
															v83 = {
																["ToolName"] = p_u_69.CurrentTool.Tool.Name,
																["CameraPosition"] = v84.CameraPosition,
																["ViewDirection"] = v84.ViewDirection or v84.Direction,
																["StartPosition"] = v84.Origin,
																["ThrowData"] = v84
															}
															p_u_69.ThrowableSnapshot = v83
														end
													end
													if v83 then
														v_u_1.GameEvents.Tactical:FireServer(v83.ToolName, v83.ViewDirection, v83.CameraPosition, v83.StartPosition, "Throwable")
													end
												else
													warn("Failed to Throw because no CurrentTool exists")
												end
											end)
										elseif v77.Name == "Bolt" then
											v78:GetMarkerReachedSignal("Pull"):Connect(function()
												-- upvalues: (copy) p_u_69
												if p_u_69.CurrentTool then
													local v85 = p_u_69.CurrentTool.Model
													if v85 then
														v85 = p_u_69.CurrentTool.Model:FindFirstChild("Handle")
													end
													if v85 then
														v85 = v85:FindFirstChild("Pull")
													end
													if v85 then
														v85:Play()
														p_u_69:ServerSoundCue("Pull", true, p_u_69.CurrentTool.Model.Name)
													end
												else
													warn("Failed to Pull because no CurrentTool exists")
												end
											end)
											v78:GetMarkerReachedSignal("Push"):Connect(function()
												-- upvalues: (copy) p_u_69
												if p_u_69.CurrentTool then
													local v86 = p_u_69.CurrentTool.Model
													if v86 then
														v86 = p_u_69.CurrentTool.Model:FindFirstChild("Handle")
													end
													if v86 then
														v86 = v86:FindFirstChild("Push")
													end
													if v86 then
														v86:Play()
														p_u_69:ServerSoundCue("Push", true, p_u_69.CurrentTool.Model.Name)
													end
												else
													warn("Failed to Push because no CurrentTool exists")
												end
											end)
										elseif v77.Name == "Pump" then
											v78:GetMarkerReachedSignal("Pull"):Connect(function()
												-- upvalues: (copy) p_u_69
												if p_u_69.CurrentTool then
													local v87 = p_u_69.CurrentTool.Model
													if v87 then
														v87 = p_u_69.CurrentTool.Model:FindFirstChild("Handle")
													end
													if v87 then
														v87 = v87:FindFirstChild("Pull")
													end
													if v87 then
														v87:Play()
														p_u_69:ServerSoundCue("Pull", true, p_u_69.CurrentTool.Model.Name)
													end
												else
													warn("Failed to Pull-2 because no CurrentTool exists")
												end
											end)
										end
									end
								else
									warn(v_u_9.warnCustom((("Ignoring non-animation object inside animation folder: %*"):format((v77:GetFullName())))))
								end
							end
						else
							warn(v_u_9.warnCustom((("Ignoring unknown animation folder: %*"):format((v76:GetFullName())))))
						end
					end
					return v72
				else
					warn(v_u_9.warnCustom("SetupToolAnimations failed because character Humanoid is missing"))
					return v72
				end
			else
				warn(v_u_9.warnCustom("SetupToolAnimations failed because player character is missing"))
				return v72
			end
		else
			warn(v_u_9.warnCustom("SetupToolAnimations failed because CameraModel Humanoid is missing"))
			return v72
		end
	else
		warn(v_u_9.warnCustom("SetupToolAnimations failed because toolAnimationFolder is nil"))
		return v72
	end
end
function v19.GetClassFromIndex(_, p88) -- name: GetClassFromIndex
	return p88 == 1 and "Primary" or (p88 == 2 and "Secondary" or (p88 == 3 and "Knife" or (p88 == 4 and "Throwable" or nil)))
end
function v19.GetStateFolder(p89) -- name: GetStateFolder
	-- upvalues: (copy) v_u_10
	local v90 = p89.Player.Character
	p89.StateFolder = v90 and v_u_10.GetStateFolder(v90) or nil
	if p89.StateReplicator then
		p89.StateReplicator:SetStateFolder(p89.StateFolder)
	end
	return p89.StateFolder
end
function v19.GetClientWeaponSystemScript(p91) -- name: GetClientWeaponSystemScript
	-- upvalues: (copy) v_u_10
	local v92 = p91.Player.Character
	p91.ClientWeaponSystemScript = v_u_10.ResolveClientWeaponSystem(v92)
	return p91.ClientWeaponSystemScript
end
function v19.SetReadinessState(p93, p94, p95, p96, p97) -- name: SetReadinessState
	-- upvalues: (copy) v_u_10
	local v98 = p93:GetClientWeaponSystemScript()
	if v98 then
		v98:SetAttribute("SwapInProgress", p94)
		v98:SetAttribute("WeaponPresentationReady", p95)
		v98:SetAttribute("WeaponFullyReady", p96)
		v98:SetAttribute("WeaponReady", p96)
		if p97 ~= nil then
			v98:SetAttribute("InitialEquipReady", p97)
		end
	end
	v_u_10.UpdateStateFolder(p93:GetStateFolder(), {
		["SwapInProgress"] = p94,
		["WeaponPresentationReady"] = p95,
		["WeaponFullyReady"] = p96,
		["WeaponReady"] = p96,
		["InitialEquipReady"] = p97
	})
end
function v19.IsWeaponPresentationReady(p99) -- name: IsWeaponPresentationReady
	local v100 = p99:GetClientWeaponSystemScript()
	if v100 then
		return v100:GetAttribute("WeaponPresentationReady") == true
	else
		return false
	end
end
function v19.IsWeaponReady(p101) -- name: IsWeaponReady
	local v102 = p101:GetClientWeaponSystemScript()
	if not v102 then
		return false
	end
	local v103
	if v102:GetAttribute("SwapInProgress") == true then
		v103 = false
	else
		v103 = v102:GetAttribute("WeaponFullyReady") == true
	end
	return v103
end
function v19.ResetWeaponPresentationState(p104, p105) -- name: ResetWeaponPresentationState
	if p105 then
		p104.CurrentState = "Hold"
		if p105.Aiming ~= nil then
			p105.Aiming = false
		end
		if p105.ReloadCancel ~= nil then
			p105.ReloadCancel = false
		end
		if p105.Reloading ~= nil then
			p105.Reloading = false
		end
		if p105.Bolting ~= nil then
			p105.Bolting = false
		end
		if p105.Pumping ~= nil then
			p105.Pumping = false
		end
		if p105.SemiCooldown ~= nil then
			p105.SemiCooldown = false
		end
		if p105.Settings and p105.Settings.SightFront then
			p105.Settings.SightFront.Transparency = 0
		end
		if p104.Crosshair then
			p104.Crosshair:Enable()
		end
		local v106 = p104.Player:FindFirstChild("PlayerGui")
		if v106 then
			v106 = v106:FindFirstChild("GameHUD")
		end
		if v106 then
			v106 = v106:FindFirstChild("ScopeUI")
		end
		if v106 and v106:IsA("ScreenGui") then
			v106.Visible = false
		elseif v106 and v106:IsA("GuiObject") then
			v106.Visible = false
		end
	else
		return
	end
end
function v19.GetCrosshairPresentationState(p107) -- name: GetCrosshairPresentationState
	local v108 = "Dot"
	local v109 = 3
	local v110 = 3
	local v111 = 0
	local v112
	if p107.Crosshair then
		v109 = p107.Crosshair.SizeX or v109
		v110 = p107.Crosshair.SizeY or v110
		local v113 = p107.Crosshair.Spreading.MinSpread
		v111 = tonumber(v113) or v111
		if p107.Crosshair.FollowingMouse == true then
			v112 = true
		else
			v112 = false
		end
	else
		v112 = false
	end
	return {
		["CrosshairStyle"] = p107.CurrentTool and (p107.CurrentTool.Tool and p107.CurrentTool.Tool:GetAttribute("Class") == "Throwable") and "Throwable" or (p107.CurrentTool and p107.CurrentTool.CrosshairSpread and "Gun" or v108),
		["CrosshairSizeX"] = v109,
		["CrosshairSizeY"] = v110,
		["CrosshairMinSpread"] = v111,
		["CrosshairFollowMouse"] = v112
	}
end
function v19.PushRuntimeState(p114, p115, p116) -- name: PushRuntimeState
	if p114.StateReplicator then
		local v117 = p116 or {}
		for v118, v119 in pairs(p114:GetCrosshairPresentationState()) do
			if v117[v118] == nil then
				v117[v118] = v119
			end
		end
		p114:GetStateFolder()
		p114.StateReplicator:SendActionState(p115, v117)
	end
end
function v19.SendEquipRequest(p120, p121, p122) -- name: SendEquipRequest
	-- upvalues: (copy) v_u_1, (copy) v_u_10
	if p120.StateReplicator then
		p120:GetStateFolder()
		local v123 = v_u_10.GetOrAssignToolSerial(p122)
		p120.StateReplicator:SendEquipRequest(p121, v123, p122.Name)
	else
		v_u_1.GameEvents.SwapWeapon:FireServer(p122.Name)
	end
end
function v19.ConfirmServerEquip(p124, p125) -- name: ConfirmServerEquip
	if p124.StateReplicator then
		p124:GetStateFolder()
		p124.StateReplicator:ConfirmEquip(p125)
	end
end
function v19.RejectPendingEquip(p126, p127) -- name: RejectPendingEquip
	if p126.StateReplicator then
		p126:GetStateFolder()
		p126.StateReplicator:RejectPendingEquip(p127)
	end
end
function v19.BuildPresentationEventContext(p128, p129) -- name: BuildPresentationEventContext
	-- upvalues: (copy) v_u_10
	local v130 = p128.CurrentTool
	local v131
	if v130 then
		v131 = v130.Tool or nil
	else
		v131 = nil
	end
	local v132 = v131 and (v_u_10.GetToolClass(v131) or "") or ""
	local v133 = v131 and (v_u_10.GetOrAssignToolSerial(v131) or "") or ""
	local v134 = v131 and (v131.Name or "") or ""
	local v135 = v131 and (tonumber(v131:GetAttribute("Ammo")) or 0) or 0
	local v136 = not v131 or tonumber(v131:GetAttribute("StoredAmmo")) or (tonumber(v131:GetAttribute("Amount")) or 0)
	local v137 = {
		["Slot"] = nil,
		["ToolSerial"] = nil,
		["ToolName"] = nil,
		["CurrentState"] = nil,
		["Aiming"] = nil,
		["ScopeVisible"] = false,
		["CrosshairVisible"] = nil,
		["TargetFOV"] = nil,
		["CurrentAmmo"] = nil,
		["StoredAmmo"] = nil,
		["Slot"] = v132,
		["ToolSerial"] = v133,
		["ToolName"] = v134,
		["CurrentState"] = p128.CurrentState,
		["Aiming"] = v130 and v130.Aiming == true and true or false,
		["CrosshairVisible"] = p128.Crosshair and p128.Crosshair.Enabled == true and true or false,
		["TargetFOV"] = p128.Camera and p128.Camera.FieldOfView or workspace.CurrentCamera.FieldOfView,
		["CurrentAmmo"] = v135,
		["StoredAmmo"] = v136
	}
	for v138, v139 in pairs(p129 or {}) do
		v137[v138] = v139
	end
	return v137
end
function v19.SendPresentationEvent(p140, p141, p142) -- name: SendPresentationEvent
	if not p140.StateReplicator then
		return nil
	end
	p140:GetStateFolder()
	return p140.StateReplicator:SendPresentationEvent(p141, p140:BuildPresentationEventContext(p142))
end
function v19.HasRegisteredTool(p143, p144) -- name: HasRegisteredTool
	if typeof(p144) == "number" then
		p144 = p143:GetClassFromIndex(p144)
	end
	if not p144 then
		return false
	end
	local v145 = p143.Tools
	if v145 then
		v145 = p143.Tools[p144]
	end
	local v146
	if v145 == nil or v145.Tool == nil then
		v146 = false
	else
		v146 = v145.Model ~= nil
	end
	return v146
end
function v19.GetFirstAvailableToolIndex(p147) -- name: GetFirstAvailableToolIndex
	for _, v148 in ipairs({
		1,
		2,
		3,
		4
	}) do
		if p147:HasRegisteredTool(v148) then
			return v148
		end
	end
	return nil
end
function v19.GetRegisteredToolModels(p149) -- name: GetRegisteredToolModels
	local v150 = {}
	for _, v151 in pairs(p149.Tools or {}) do
		if v151 and v151.Model then
			local v152 = v151.Model
			table.insert(v150, v152)
		end
	end
	return v150
end
function v19.RefreshWeaponExtras(p153) -- name: RefreshWeaponExtras
	-- upvalues: (copy) v_u_4
	local v154
	if p153.CurrentTool and (p153.CurrentTool.Model and p153.Holster ~= false) then
		v154 = p153.CurrentTool.Model
	else
		v154 = nil
	end
	v_u_4.SetExclusiveExtraState(p153:GetRegisteredToolModels(), v154, false)
end
function v19.IsToolModelAttachedToArm(p155, p156) -- name: IsToolModelAttachedToArm
	local v157
	if p156 then
		v157 = p156:FindFirstChild("Handle") or p156:FindFirstChild("Base")
	else
		v157 = p156
	end
	if not p155.CameraModel or (not v157 or p156.Parent ~= p155.CameraModel) then
		return false
	end
	local v158 = v157:FindFirstChild("Motor")
	local v159 = v158 ~= nil and v158:IsA("Motor6D")
	if v159 then
		if v158.Part0 == p155.CameraModel.Tool then
			v159 = v158.Part1 == v157
		else
			v159 = false
		end
	end
	return v159
end
function v19.EnsureToolModelPresentation(p160, p161) -- name: EnsureToolModelPresentation
	if p161 and p161.Model then
		if p160.CurrentTool == p161 == true and p160.Holster ~= false then
			if p160:IsToolModelAttachedToArm(p161.Model) ~= true then
				p160:AttachToolModelToArm(p161.Model)
			end
		elseif p161.Model.Parent ~= script.ReserveModels or p160:IsToolModelAttachedToArm(p161.Model) == true then
			p160:DetachToolModelFromArm(p161.Model)
		end
		p160:RefreshWeaponExtras()
	end
end
function v19.EnsureCurrentToolPresentation(p162) -- name: EnsureCurrentToolPresentation
	if p162.CurrentTool then
		p162:EnsureToolModelPresentation(p162.CurrentTool)
	end
end
function v19.SetTools(p163, p164, p165) -- name: SetTools
	-- upvalues: (copy) v_u_10, (copy) v_u_1, (copy) v_u_5, (copy) v_u_4
	local v166 = p165:GetAttribute("Class")
	if p165:IsA("Tool") and v166 then
		if p163.Tools == nil then
			p163.Tools = {}
		end
		local v167 = p163.Tools[v166]
		local v168 = nil
		local v169
		if v167 == nil then
			v169 = false
		else
			local v170 = v167.Tool
			local v171
			if v170 then
				v171 = v170.Name == p165.Name
			else
				v171 = v170
			end
			local v172
			if v170 then
				v172 = v170:GetAttribute("Skin") == p165:GetAttribute("Skin")
			else
				v172 = v170
			end
			local v173
			if v170 then
				v173 = v170:GetAttribute("Class") == v166
			else
				v173 = v170
			end
			local v174
			if v167.Model == nil then
				v174 = false
			else
				v174 = v167.Model.Parent ~= nil
			end
			local v175 = v170 and (v_u_10.GetOrAssignToolSerial(v170) or "") or ""
			local v176 = v_u_10.GetOrAssignToolSerial(p165)
			local v177
			if v170 == p165 then
				v177 = true
			elseif v175 == "" then
				v177 = false
			else
				v177 = v175 == v176
			end
			if v171 == true and (v172 == true and v173 == true) then
				v169 = v174 == true
			else
				v169 = false
			end
			v168 = v169 == true and (p163.CurrentTool == v167 and v177 == true) and {
				["Aiming"] = v167.Aiming == true,
				["ReloadCancel"] = v167.ReloadCancel == true,
				["Reloading"] = v167.Reloading == true,
				["Bolting"] = v167.Bolting == true,
				["Pumping"] = v167.Pumping == true,
				["SemiCooldown"] = v167.SemiCooldown == true
			} or v168
			if v169 ~= true then
				if p163.CurrentTool == v167 then
					p163.CurrentTool = nil
					p163.CurrentToolIndex = 0
				end
				if v167.Model then
					v167.Model:Destroy()
				end
				p163.Tools[v166] = nil
				v167 = nil
			end
		end
		if v167 == nil then
			p163.Tools[v166] = {}
			v167 = p163.Tools[v166]
			if v166 == "Primary" or v166 == "Secondary" then
				v167.Model = v_u_1.Items.Weapon[p165.Name]:Clone()
				v_u_5.Weapon.WeldWeapon(v167.Model)
				v167.Model.Parent = script.ReserveModels
				v_u_5.Weapon.SetFullAttachmentOnWeapon(v167.Model, p164)
				local v178 = p164:FindFirstChild("PlayerData")
				v_u_4.SetAttachmentSkins(v167.Model, v178.Loadout[v178.Settings:GetAttribute("LoadoutName")], v166)
				v_u_5.Weapon.SetSkinOnWep(v167.Model, p165:GetAttribute("Skin"))
				v_u_5.Weapon.SetupWeaponEffects(v167.Model)
				v_u_5.Weapon.SetModelProperties(v167.Model, false, false)
				v_u_5.Weapon.SetPlayerArmSkin(p163.CameraModel, p164)
			else
				v167.Model = v_u_1.Items[v166][p165.Name]:Clone()
				v_u_5.Weapon.WeldWeapon(v167.Model)
				v167.Model.Parent = script.ReserveModels
				v_u_5.Weapon.SetModelProperties(v167.Model, false, false)
			end
		end
		v167.Tool = p165
		v167.Stats = v167.Stats or {}
		if v166 == "Primary" or v166 == "Secondary" then
			local v179 = require(p165:WaitForChild("Settings", 1))
			v167.Settings = table.clone(v179)
			v167.Settings.HRecoil = v167.Settings.HRecoil * (100 - v167.Model:GetAttribute("Horizontal") * 0.01)
			v167.Settings.VRecoil = v167.Settings.VRecoil * (100 - v167.Model:GetAttribute("Vertical") * 0.01)
			v167.Settings.HipFireReduction = v167.Model:GetAttribute("HipFireReduction")
			local v180 = v167.Settings
			local v181 = v167.Settings
			local v182, v183 = p163:GetADSZoom(v167.Model)
			v180.ADSZoom = v182
			v181.SightFront = v183
			v167.CrosshairSpread = v167.Settings.MaxSpread * (1 - v167.Settings.HipFireReduction / 100)
			if v167.Animations == nil or v169 ~= true then
				v167.Animations = p163:SetupToolAnimations(p164, p165:WaitForChild("Settings"):WaitForChild("Animations"))
			end
		elseif v167.Animations == nil or v169 ~= true then
			v167.Animations = p163:SetupToolAnimations(p164, (v167.Model:FindFirstChild("Handle") or v167.Model:FindFirstChild("Base")).Animations)
		end
		if v168 then
			v167.Aiming = v168.Aiming
			v167.ReloadCancel = v168.ReloadCancel
			v167.Reloading = v168.Reloading
			v167.Bolting = v168.Bolting
			v167.Pumping = v168.Pumping
			v167.SemiCooldown = v168.SemiCooldown
		else
			v167.Aiming = false
			v167.ReloadCancel = false
			v167.Reloading = false
			v167.Bolting = false
			v167.Pumping = false
			v167.SemiCooldown = false
		end
		v_u_4.SetExtraState(v167.Model, false, false)
		p163:EnsureToolModelPresentation(v167)
	end
end
function v19.RemoveToolClass(p184, p185) -- name: RemoveToolClass
	-- upvalues: (copy) v_u_10
	local v186 = p184.Tools
	if v186 then
		v186 = p184.Tools[p185]
	end
	if v186 then
		local v187 = p184.CurrentTool == v186
		if v186.Model then
			v186.Model:Destroy()
		end
		p184.Tools[p185] = nil
		if v187 then
			p184.CurrentTool = nil
			if p184.CurrentToolIndex == v_u_10.GetIndexFromClass(p185) then
				p184.CurrentToolIndex = 0
			end
		end
		p184:RefreshWeaponExtras()
	end
end
function v19.SyncToolsFromInventory(p_u_188, p189, p190) -- name: SyncToolsFromInventory
	-- upvalues: (copy) v_u_10
	p_u_188.Tools = p_u_188.Tools or {}
	local v_u_191 = p_u_188.CurrentToolIndex
	local v192
	if v_u_191 == 0 then
		v192 = nil
	else
		v192 = p_u_188:GetClassFromIndex(v_u_191) or nil
	end
	local v193 = false
	for _, v194 in ipairs(v_u_10.GetSupportedSlots()) do
		local v195 = p190[v194]
		if v195 then
			local v196 = p_u_188.Tools[v194]
			if v196 then
				v196 = p_u_188.Tools[v194].Tool
			end
			p_u_188:SetTools(p189, v195)
			if v192 == v194 and v196 ~= v195 then
				v193 = true
			end
		else
			p_u_188:RemoveToolClass(v194)
		end
	end
	if v192 and (v193 == true and p_u_188:HasRegisteredTool(v_u_191)) then
		task.defer(function()
			-- upvalues: (copy) p_u_188, (copy) v_u_191
			if p_u_188:HasRegisteredTool(v_u_191) then
				p_u_188:SwapTools(v_u_191, true)
			end
		end)
	end
end
function v19.SetupTools(p_u_197, p_u_198) -- name: SetupTools
	-- upvalues: (copy) v_u_12
	p_u_197.Tools = {}
	p_u_197:GetStateFolder()
	if p_u_197.InventoryDisconnect then
		p_u_197.InventoryDisconnect()
		p_u_197.InventoryDisconnect = nil
	end
	p_u_197.InventoryDisconnect = v_u_12.WatchPlayerInventory(p_u_198, function(p199)
		-- upvalues: (copy) p_u_197, (copy) p_u_198
		p_u_197:SyncToolsFromInventory(p_u_198, p199)
	end)
end
function v19.Died(p_u_200, _) -- name: Died
	local v201 = p_u_200.Player.Character
	assert(v201, "Died failed because there is no player character")
	v201:WaitForChild("Humanoid").Died:Connect(function()
		-- upvalues: (copy) p_u_200
		if p_u_200.InventoryDisconnect then
			p_u_200.InventoryDisconnect()
			p_u_200.InventoryDisconnect = nil
		end
		p_u_200.CameraModel:Destroy()
		p_u_200.CurrentTool = nil
		p_u_200.Crosshair:Disable()
	end)
end
function v19.SetupCrosshair(p202) -- name: SetupCrosshair
	-- upvalues: (copy) v_u_8, (copy) v_u_6
	if v_u_8.Crosshair then
		local v203 = p202.Player.PlayerGui.Crosshair
		v203:ClearAllChildren()
		p202.Crosshair = v_u_6.New(v203, 0, 150, 200, 0, false)
		p202.Crosshair.EasingStyle = Enum.EasingStyle.Sine
		p202.Crosshair.EasingDirection = Enum.EasingDirection.InOut
		p202.Crosshair:Size(6, 2)
		p202.Crosshair:Display({
			["BackgroundTransparency"] = 0.6,
			["BorderSizePixel"] = 0,
			["Image"] = nil,
			["ImageTransparency"] = 0,
			["BackgroundColor3"] = nil,
			["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		})
	end
end
function v19.GetToolAnimationFolder(_, p204, _) -- name: GetToolAnimationFolder
	if not p204 then
		return nil
	end
	local function v213(p205) -- name: FindAnimationsInside
		if not p205 then
			return nil
		end
		local v206 = p205:FindFirstChild("Animations")
		local v207
		if v206 and (v206:IsA("Folder") and (v206.Name == "Animations" and v206:FindFirstChild("Client"))) then
			v207 = v206:FindFirstChild("Server") and true or false
		else
			v207 = false
		end
		if v207 then
			return v206
		end
		local v208 = p205:FindFirstChild("Settings")
		if v208 then
			local v209 = v208:FindFirstChild("Animations")
			local v210
			if v209 and (v209:IsA("Folder") and (v209.Name == "Animations" and v209:FindFirstChild("Client"))) then
				v210 = v209:FindFirstChild("Server") and true or false
			else
				v210 = false
			end
			if v210 then
				return v209
			end
		end
		for _, v211 in ipairs(p205:GetDescendants()) do
			local v212
			if v211 and (v211:IsA("Folder") and (v211.Name == "Animations" and v211:FindFirstChild("Client"))) then
				v212 = v211:FindFirstChild("Server") and true or false
			else
				v212 = false
			end
			if v212 then
				return v211
			end
		end
		return nil
	end
	return v213(p204.Tool) or (v213(p204.Model) or nil)
end
function v19.SwapTools(p_u_214, p215, p216) -- name: SwapTools
	-- upvalues: (copy) v_u_9, (copy) v_u_10
	if not p_u_214.CameraModel then
		warn(v_u_9.warnCustom("Failed to swap tools because CameraModel is nil"))
		return false
	end
	if not p_u_214.CameraModel:FindFirstChild("Tool") then
		warn(v_u_9.warnCustom("Failed to swap tools because CameraModel.Tool is missing"))
		return false
	end
	p_u_214:SetFP(p_u_214.Player)
	local v217
	if p215 == 1 then
		v217 = "Primary"
	elseif p215 == 2 then
		v217 = "Secondary"
	elseif p215 == 3 then
		v217 = "Knife"
	else
		if p215 ~= 4 then
			warn(v_u_9.warnCustom((("Failed to swap tools because weapon index %* is invalid"):format(p215))))
			return false
		end
		v217 = "Throwable"
	end
	local v218 = p_u_214.Tools
	if v218 then
		v218 = p_u_214.Tools[v217]
	end
	if not v218 then
		if v217 ~= "Throwable" then
			warn(v_u_9.warnCustom((("Failed to swap tools because ToolData for %* is nil on index %* for %*"):format(v217, p215, p_u_214.Player.Name))))
		end
		return false
	end
	if not v218.Tool then
		warn(v_u_9.warnCustom((("Failed to swap tools because ToolData.Tool for %* is nil on index %* for %*"):format(v217, p215, p_u_214.Player.Name))))
		return false
	end
	if not v218.Model then
		warn(v_u_9.warnCustom((("Failed to swap tools because ToolData.Model for %* is nil on index %* for %*"):format(v218.Tool.Name, p215, p_u_214.Player.Name))))
		return false
	end
	local v219 = p_u_214:GetToolAnimationFolder(v218, v217)
	if not v219 then
		warn(v_u_9.warnCustom((("Failed to swap tools because %* has no valid Animations folder with Client and Server folders. Checked Tool and Model."):format(v218.Tool.Name))))
		if v218.Tool then
			warn(v_u_9.warnCustom((("Tool path: %*"):format((v218.Tool:GetFullName())))))
		end
		if v218.Model then
			warn(v_u_9.warnCustom((("Model path: %*"):format((v218.Model:GetFullName())))))
		end
		return false
	end
	if not p_u_214:ValidateToolAnimations(v218, { "Equip", "Hold" }, { "Equip", "Hold" }) then
		v218.Animations = p_u_214:SetupToolAnimations(p_u_214.Player, v219)
		warn(v_u_9.warnCustom((("Weapon animation repatch activated for %*"):format(v218.Tool.Name))))
	end
	if not p_u_214:ValidateToolAnimations(v218, { "Equip", "Hold" }, { "Equip", "Hold" }) then
		warn(v_u_9.warnCustom((("Failed to swap to %* because required Equip/Hold animations are missing for %* on index %*"):format(v218.Tool.Name, p_u_214.Player.Name, p215))))
		return false
	end
	for _, v220 in pairs(p_u_214.Tools or {}) do
		if v220 and v220.Model then
			p_u_214:DetachToolModelFromArm(v220.Model)
		end
	end
	local v_u_221 = p_u_214.SpawnEquipPresentationPending == true
	local v222 = true
	local v223 = false
	local v224 = false
	local v225
	if v_u_221 == true then
		v225 = false
	else
		v225 = nil
	end
	p_u_214:SetReadinessState(v222, v223, v224, v225)
	p_u_214:AttachToolModelToArm(v218.Model)
	p_u_214.CurrentTool = v218
	p_u_214.CurrentToolID = math.random(-100, 100)
	p_u_214.CurrentToolIndex = p215
	p_u_214:ResetWeaponPresentationState(v218)
	p_u_214:EnsureCurrentToolPresentation()
	local v226 = true
	local v227 = true
	local v228 = false
	local v229
	if v_u_221 == true then
		v229 = false
	else
		v229 = nil
	end
	p_u_214:SetReadinessState(v226, v227, v228, v229)
	local v230 = v_u_10.GetOrAssignToolSerial(v218.Tool)
	if p216 == true then
		p_u_214:ConfirmServerEquip({
			["Slot"] = v217,
			["ToolSerial"] = v230,
			["ToolName"] = v218.Tool.Name
		})
	else
		p_u_214:SendEquipRequest(v217, v218.Tool)
	end
	p_u_214:MagazineActivation()
	p_u_214:StopOtherToolsAnimations()
	p_u_214.SpawnEquipPresentationPending = false
	p_u_214.CurrentTool.Animations.Client.Equip:Play()
	p_u_214.CurrentTool.Animations.Server.Equip:Play()
	p_u_214:SendPresentationEvent("ToolSwapPresented", {
		["Slot"] = nil,
		["ToolSerial"] = nil,
		["ToolName"] = nil,
		["CurrentState"] = "Hold",
		["Aiming"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["IsInitialSpawnPresentation"] = nil,
		["Slot"] = v217,
		["ToolSerial"] = v230,
		["ToolName"] = v218.Tool.Name,
		["Holstered"] = p_u_214.Holster,
		["IsInitialSpawnPresentation"] = v_u_221
	})
	local v_u_231 = p_u_214.CurrentTool
	local v_u_232 = p_u_214.CurrentToolID
	task.spawn(function()
		-- upvalues: (copy) v_u_231, (copy) p_u_214, (copy) v_u_232, (ref) v_u_10, (copy) v_u_221
		if v_u_231 and (v_u_231.Animations and (v_u_231.Animations.Client and v_u_231.Animations.Client.Equip)) then
			v_u_231.Animations.Client.Equip.Stopped:Wait()
		end
		if p_u_214.CurrentTool == v_u_231 and p_u_214.CurrentToolID == v_u_232 then
			local v233 = v_u_231.Aiming == true and true or p_u_214.CurrentState == "ADS"
			if v233 ~= true then
				local v234 = p_u_214:GetClientWeaponSystemScript()
				if v234 then
					local v235 = v234:GetAttribute("BufferedADSIntent") == true
					local v236 = tonumber(v234:GetAttribute("BufferedADSSwapGeneration")) or 0
					local v237 = tonumber(v234:GetAttribute("SwapGeneration")) or 0
					local v238 = v234:GetAttribute("BufferedADSToolSerial") or ""
					local v239 = tostring(v238)
					local v240 = v_u_231.Tool and v_u_10.GetOrAssignToolSerial(v_u_231.Tool) or ""
					if v235 == true and (v236 ~= 0 and (v236 == v237 and v239 ~= "")) then
						v233 = v239 == v240
					else
						v233 = false
					end
				end
			end
			if v233 == true then
				v_u_231.Aiming = true
				p_u_214:PrepareEquipTransitionForADS(v_u_231)
				p_u_214.CurrentState = "ADS"
				p_u_214:PushRuntimeState("ADS", {
					["Aiming"] = true,
					["Inspecting"] = false,
					["Reloading"] = false,
					["Holstered"] = nil,
					["Holstered"] = p_u_214.Holster
				})
				if p_u_214.Crosshair then
					p_u_214.Crosshair:Disable()
				end
				if v_u_231.Settings and v_u_231.Settings.SightFront then
					v_u_231.Settings.SightFront.Transparency = 0
				end
			else
				p_u_214:ResumeHoldPresentation(v_u_231)
			end
			p_u_214:SetReadinessState(false, true, true, v_u_221 == true and true or nil)
		end
	end)
	p_u_214.CurrentState = p_u_214.CurrentTool.Aiming == true and "ADS" or "Hold"
	p_u_214:PushRuntimeState(p_u_214.CurrentState, {
		["Aiming"] = nil,
		["Inspecting"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["Aiming"] = p_u_214.CurrentTool.Aiming == true,
		["Holstered"] = p_u_214.Holster
	})
	if p_u_214.CurrentTool.Bolting == true then
		p_u_214:Bolt()
	elseif p_u_214.CurrentTool.Pumping == true then
		p_u_214:Pump()
	end
	if p_u_214.Crosshair then
		if v218.CrosshairSpread then
			p_u_214.Crosshair:Enable()
			p_u_214.Crosshair:FollowMouse(false)
			p_u_214.Crosshair:Size(6, 2)
			local v241 = v218.CrosshairSpread * 10
			if v241 < p_u_214.Crosshair.Spreading.MinSpread then
				p_u_214.Crosshair.Spreading.MinSpread = v241
				p_u_214.Crosshair:SmoothSet(v241, 0.06)
			else
				p_u_214.Crosshair:SmoothSet(v241, 0.06)
				p_u_214.Crosshair.Spreading.MinSpread = v241
			end
		elseif v217 == "Throwable" then
			p_u_214.Crosshair:Enable()
			p_u_214.Crosshair:FollowMouse(false)
			p_u_214.Crosshair:Size(2, 16)
			p_u_214.Crosshair.Spreading.MinSpread = 50
			p_u_214.Crosshair:Set(50)
		else
			p_u_214.Crosshair:Size(3, 3)
			p_u_214.Crosshair.Spreading.MinSpread = 0
			p_u_214.Crosshair:SmoothSet(0, 0.06)
		end
	end
	p_u_214:SoundCue("Equip", true)
	return true
end
function v19.SetToolSurfaceGuiEnabled(_, p242, p243, p244) -- name: SetToolSurfaceGuiEnabled
	if p242 then
		local v245 = p244 == nil and true or p244
		for _, v246 in ipairs(p242:GetDescendants()) do
			if v246:IsA("SurfaceGui") then
				local v247 = v246.Parent
				if v247 then
					v247 = v246.Parent.Name == "Reticle"
				end
				if v245 == true or v247 ~= true then
					v246.Enabled = p243
				end
			end
		end
	end
end
function v19.AttachToolModelToArm(p248, p249) -- name: AttachToolModelToArm
	-- upvalues: (copy) v_u_4
	local v250 = p249:FindFirstChild("Handle") or p249:FindFirstChild("Base")
	if p248.CameraModel and v250 then
		p249.Parent = p248.CameraModel
		local v251 = v250:FindFirstChild("Motor")
		if v251 == nil then
			v251 = Instance.new("Motor6D", v250)
			v251.Name = "Motor"
		end
		v251.Part1 = v250
		v251.Part0 = p248.CameraModel.Tool
		v250.Anchored = false
		v251.C1 = CFrame.new(0, 0, 0)
		local v252 = v_u_4.GetWeaponExtra(p249)
		if v252 then
			v_u_4.InitializeExtraAttachment(v252)
		end
		p248:SetToolSurfaceGuiEnabled(p249, true, false)
		p248.AimPart = p249:FindFirstChild("Aim")
	end
end
function v19.DetachToolModelFromArm(p253, p254) -- name: DetachToolModelFromArm
	-- upvalues: (copy) v_u_9, (copy) v_u_4
	local v255 = p254:FindFirstChild("Handle") or p254:FindFirstChild("Base")
	if p253.CameraModel and v255 then
		local v256 = v255:FindFirstChild("Motor")
		if v256 == nil then
			v256 = Instance.new("Motor6D", v255)
			v256.Name = "Motor"
		end
		v256.Part1 = v255
		if p253.CameraModel and p253.CameraModel:FindFirstChild("Base") then
			v256.Part0 = p253.CameraModel.Base
		else
			warn(v_u_9.formatWarnInstanceIsNil("self.CameraModel", "Base"))
		end
		v255.Anchored = false
		v256.C1 = CFrame.new(0, 0, -10)
		p253:SetToolSurfaceGuiEnabled(p254, false)
		v_u_4.SetExtraState(p254, false, false)
		p254.Parent = script.ReserveModels
	end
end
function v19.MagazineActivation(p257) -- name: MagazineActivation
	for _, v258 in pairs(p257.Tools) do
		local v259 = v258.Model:FindFirstChild("Magazine", true)
		if v259 then
			v259.Name = "MagazineDisabled"
		end
	end
	local v260 = p257.CurrentTool.Model:FindFirstChild("MagazineDisabled")
	if v260 then
		v260.Name = "Magazine"
	end
end
function v19.StopOtherToolsAnimations(p261) -- name: StopOtherToolsAnimations
	for _, v262 in pairs(p261.Tools or {}) do
		for _, v263 in pairs(v262.Animations or {}) do
			for _, v264 in pairs(v263) do
				if v264 and (typeof(v264) == "Instance" and v264:IsA("AnimationTrack")) then
					v264:Stop()
				end
			end
		end
	end
end
function v19.ToggleToolModelVisible(p265, p266, p267) -- name: ToggleToolModelVisible
	p265:SetToolSurfaceGuiEnabled(p266, p267)
	if p267 == true then
		for _, v268 in pairs(p266:GetChildren()) do
			if v268:IsA("BasePart") and (v268.Name ~= "Base" and v268.Name ~= "Handle") then
				v268.Transparency = 0
			end
		end
	else
		for _, v269 in pairs(p266:GetChildren()) do
			if v269:IsA("BasePart") and (v269.Name ~= "Base" and v269.Name ~= "Handle") then
				v269.Transparency = 1
			end
		end
	end
end
function v19.Vault(p_u_270) -- name: Vault
	p_u_270:SoundCue("Vault", true)
	local v_u_271 = p_u_270.CurrentTool
	assert(v_u_271, "Failed to Vault because no CurrentTool exists")
	local v_u_272 = p_u_270:GetClientWeaponSystemScript()
	local v_u_273 = p_u_270:GetStateFolder()
	if v_u_272 then
		v_u_272:SetAttribute("ServerVaultOverride", true)
	end
	p_u_270:PushRuntimeState(v_u_271.Aiming == true and "ADS" or "Hold", {
		["Aiming"] = nil,
		["Inspecting"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["VaultActive"] = true,
		["Aiming"] = v_u_271.Aiming == true,
		["Holstered"] = p_u_270.Holster
	})
	if p_u_270.Animations.Server.Run then
		p_u_270.Animations.Server.Run:Stop(0.05)
	end
	if v_u_271.Aiming == false then
		p_u_270.CurrentState = "Hold"
		p_u_270:SendPresentationEvent("VaultStart", {
			["CurrentState"] = "Hold",
			["Aiming"] = false,
			["Inspecting"] = false,
			["Reloading"] = false,
			["Holstered"] = nil,
			["Holstered"] = p_u_270.Holster
		})
		p_u_270.Animations.Client.Vault:Play()
		p_u_270.Animations.Client.Vault:AdjustSpeed(1)
	end
	local v_u_274 = p_u_270.Animations.Server.Vault
	v_u_274:Play()
	task.spawn(function()
		-- upvalues: (copy) v_u_274, (copy) v_u_272, (copy) p_u_270, (copy) v_u_271, (copy) v_u_273
		v_u_274.Stopped:Wait()
		if v_u_272 then
			v_u_272:SetAttribute("ServerVaultOverride", false)
		end
		p_u_270:PushRuntimeState(p_u_270.CurrentState, {
			["VaultActive"] = false
		})
		if p_u_270.CurrentTool == v_u_271 and p_u_270.Animations.Server.Vault == v_u_274 then
			task.defer(function()
				-- upvalues: (ref) p_u_270, (ref) v_u_271, (ref) v_u_274, (ref) v_u_273
				if p_u_270.CurrentTool == v_u_271 and p_u_270.Animations.Server.Vault == v_u_274 then
					if (v_u_273 and v_u_273:GetAttribute("Movement") or nil) == "Running" then
						p_u_270:StopServerHold()
						if p_u_270.Animations.Server.Run and p_u_270.Animations.Server.Run.IsPlaying ~= true then
							p_u_270.Animations.Server.Run:Play(0.05)
							return
						end
					else
						p_u_270:PlayServerHold()
					end
				end
			end)
		end
	end)
end
function v19.PrepareEquipTransitionForHold(_, p275, p276) -- name: PrepareEquipTransitionForHold
	if p275 and p275.Animations then
		local v277 = p276 or 0.08
		local v278 = p275.Animations.Client
		local v279 = p275.Animations.Server
		local v280
		if v278 then
			v280 = v278.Equip
		else
			v280 = v278
		end
		local v281
		if v279 then
			v281 = v279.Equip
		else
			v281 = v279
		end
		if v278 then
			v278 = v278.Hold
		end
		if v279 then
			v279 = v279.Hold
		end
		local v282
		if v280 and v280.IsPlaying == true then
			v282 = true
		elseif v281 then
			v282 = v281.IsPlaying == true
		else
			v282 = v281
		end
		if v282 == true then
			if v278 and v278.IsPlaying ~= true then
				v278:Play(v277)
			end
			if v279 and v279.IsPlaying ~= true then
				v279:Play(v277)
			end
			if v280 and v280.IsPlaying == true then
				v280:Stop(v277)
			end
			if v281 and v281.IsPlaying == true then
				v281:Stop(v277)
			end
		end
	else
		return
	end
end
function v19.PrepareEquipTransitionForADS(p283, p284) -- name: PrepareEquipTransitionForADS
	if p284 and (p283.CurrentTool == p284 and p284.Animations) then
		local v285 = p284.Animations.Client
		local v286 = p284.Animations.Server
		local v287
		if v285 then
			v287 = v285.Hold
		else
			v287 = v285
		end
		local v288
		if v286 then
			v288 = v286.Hold
		else
			v288 = v286
		end
		local v289 = p283.Animations
		if v289 then
			v289 = p283.Animations.Client
		end
		local v290 = p283.Animations
		if v290 then
			v290 = p283.Animations.Server
		end
		local v291
		if v285 then
			v291 = v285.Equip
		else
			v291 = v285
		end
		if v291 and v291.IsPlaying == true then
			v291:Stop(0)
		end
		local v292
		if v286 then
			v292 = v286.Equip
		else
			v292 = v286
		end
		if v292 and v292.IsPlaying == true then
			v292:Stop(0)
		end
		local v293
		if v285 then
			v293 = v285.Inspect
		else
			v293 = v285
		end
		if v293 and v293.IsPlaying == true then
			v293:Stop(0)
		end
		local v294
		if v286 then
			v294 = v286.Inspect
		else
			v294 = v286
		end
		if v294 and v294.IsPlaying == true then
			v294:Stop(0)
		end
		local v295
		if v285 then
			v295 = v285.Action
		else
			v295 = v285
		end
		if v295 and v295.IsPlaying == true then
			v295:Stop(0)
		end
		local v296
		if v286 then
			v296 = v286.Action
		else
			v296 = v286
		end
		if v296 and v296.IsPlaying == true then
			v296:Stop(0)
		end
		local v297
		if v285 then
			v297 = v285.Reload
		else
			v297 = v285
		end
		if v297 and v297.IsPlaying == true then
			v297:Stop(0)
		end
		local v298
		if v286 then
			v298 = v286.Reload
		else
			v298 = v286
		end
		if v298 and v298.IsPlaying == true then
			v298:Stop(0)
		end
		if v285 then
			v285 = v285.Vault
		end
		if v285 and v285.IsPlaying == true then
			v285:Stop(0)
		end
		if v286 then
			v286 = v286.Vault
		end
		if v286 and v286.IsPlaying == true then
			v286:Stop(0)
		end
		if v289 then
			v289 = v289.Vault
		end
		if v289 and v289.IsPlaying == true then
			v289:Stop(0)
		end
		if v290 then
			v290 = v290.Vault
		end
		if v290 and v290.IsPlaying == true then
			v290:Stop(0)
		end
		if v287 then
			if v287 and v287.IsPlaying == true then
				v287:Stop(0)
			end
			v287:Play(0)
		end
		if v288 then
			if v288 and v288.IsPlaying == true then
				v288:Stop(0)
			end
			v288:Play(0)
		end
	end
end
function v19.ResumeHoldPresentation(p299, p300) -- name: ResumeHoldPresentation
	if not p300 or (p299.CurrentTool ~= p300 or p299.CurrentState ~= "Hold") then
		return false
	end
	local v301 = p299.Player.Character
	if p300.Aiming == true or (p300.Reloading == true or (p300.Bolting == true or (p300.Pumping == true or (p299.Holster ~= true or v301 and v301:GetAttribute("Barricading") == true)))) then
		return false
	end
	p299:PrepareEquipTransitionForHold(p300, 0.08)
	local v302 = p300.Animations
	if v302 then
		v302 = p300.Animations.Client
	end
	local v303 = p300.Animations
	if v303 then
		v303 = p300.Animations.Server
	end
	local v304
	if v302 then
		v304 = v302.Hold
	else
		v304 = v302
	end
	local v305
	if v303 then
		v305 = v303.Hold
	else
		v305 = v303
	end
	local v306
	if v302 then
		v306 = v302.Inspect
	else
		v306 = v302
	end
	local v307
	if v303 then
		v307 = v303.Inspect
	else
		v307 = v303
	end
	local v308
	if v302 then
		v308 = v302.Action
	else
		v308 = v302
	end
	local v309
	if v303 then
		v309 = v303.Action
	else
		v309 = v303
	end
	local v310
	if v302 then
		v310 = v302.Reload
	else
		v310 = v302
	end
	local v311
	if v303 then
		v311 = v303.Reload
	else
		v311 = v303
	end
	if v302 then
		v302 = v302.Vault
	end
	if v303 then
		v303 = v303.Vault
	end
	if v306 and v306.IsPlaying == true then
		v306:Stop(0.05)
	end
	if v307 and v307.IsPlaying == true then
		v307:Stop(0.05)
	end
	if v308 and v308.IsPlaying == true then
		v308:Stop(0.05)
	end
	if v309 and v309.IsPlaying == true then
		v309:Stop(0.05)
	end
	if v310 and v310.IsPlaying == true then
		v310:Stop(0.05)
	end
	if v311 and v311.IsPlaying == true then
		v311:Stop(0.05)
	end
	if v302 and v302.IsPlaying == true then
		v302:Stop(0.05)
	end
	if v303 and v303.IsPlaying == true then
		v303:Stop(0.05)
	end
	if v304 then
		if v304 and v304.IsPlaying == true then
			v304:Stop(0.05)
		end
		v304:Play(0.12)
	end
	if v305 then
		if v305 and v305.IsPlaying == true then
			v305:Stop(0.05)
		end
		v305:Play(0.12)
	end
	return v304 ~= nil and true or v305 ~= nil
end
function v19.ADS(p312) -- name: ADS
	local v313 = p312.CurrentTool
	assert(v313, "Failed to ADS because no CurrentTool exists")
	p312:PrepareEquipTransitionForADS(v313)
	p312.CurrentState = "ADS"
	v313.Aiming = true
	p312:PushRuntimeState("ADS", {
		["Aiming"] = true,
		["Inspecting"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["Holstered"] = p312.Holster
	})
	p312:SoundCue("ADS", true)
	if p312.Crosshair then
		p312.Crosshair:Disable()
	end
	if v313.Settings.SightFront then
		v313.Settings.SightFront.Transparency = 0
	end
end
function v19.ReleaseADS(p314) -- name: ReleaseADS
	local v315 = p314.CurrentTool
	assert(v315, "Failed to ReleaseADS because no CurrentTool exists")
	p314.CurrentState = "Hold"
	v315.Aiming = false
	p314:ResumeHoldPresentation(v315)
	p314:PushRuntimeState("Hold", {
		["Aiming"] = false,
		["Inspecting"] = false,
		["Reloading"] = nil,
		["Holstered"] = nil,
		["Reloading"] = v315.Reloading == true,
		["Holstered"] = p314.Holster
	})
	p314:SoundCue("ADSRelease", true)
	if p314.Crosshair then
		p314.Crosshair:Enable()
	end
	if v315.Settings.SightFront then
		v315.Settings.SightFront.Transparency = 0
	end
end
function v19.Inspect(p_u_316) -- name: Inspect
	local v_u_317 = p_u_316.CurrentTool
	if v_u_317 then
		p_u_316.CurrentState = "Inspect"
		p_u_316:PushRuntimeState("Inspect", {
			["Aiming"] = false,
			["Inspecting"] = true,
			["Reloading"] = false,
			["Holstered"] = nil,
			["Holstered"] = p_u_316.Holster
		})
		p_u_316:SendPresentationEvent("InspectStart", {
			["CurrentState"] = "Inspect",
			["Aiming"] = false,
			["Inspecting"] = true,
			["Reloading"] = false,
			["Holstered"] = nil,
			["Holstered"] = p_u_316.Holster
		})
		v_u_317.Animations.Client.Inspect:Play()
		if v_u_317.Animations.Client.Reload then
			v_u_317.ReloadCancel = true
			v_u_317.Animations.Client.Reload:Stop()
			v_u_317.Animations.Server.Reload:Stop()
		end
		task.spawn(function()
			-- upvalues: (copy) v_u_317, (copy) p_u_316
			v_u_317.Animations.Client.Inspect.Stopped:Wait()
			if p_u_316.CurrentTool == v_u_317 and p_u_316.CurrentState == "Inspect" then
				p_u_316.CurrentState = "Hold"
				p_u_316:ResumeHoldPresentation(v_u_317)
				p_u_316:PushRuntimeState("Hold", {
					["Aiming"] = nil,
					["Inspecting"] = false,
					["Reloading"] = nil,
					["Holstered"] = nil,
					["Aiming"] = v_u_317.Aiming == true,
					["Reloading"] = v_u_317.Reloading == true,
					["Holstered"] = p_u_316.Holster
				})
			end
		end)
	end
end
function v19.CancelInspect(p318) -- name: CancelInspect
	local v319 = p318.CurrentTool
	if not v319 then
		return false
	end
	local v320 = v319.Animations
	if v320 then
		v320 = v319.Animations.Client
	end
	local v321 = v319.Animations
	if v321 then
		v321 = v319.Animations.Server
	end
	if v320 then
		v320 = v320.Inspect
	end
	if v321 then
		v321 = v321.Inspect
	end
	local v322
	if p318.CurrentState == "Inspect" or v320 and v320.IsPlaying == true then
		v322 = true
	elseif v321 then
		v322 = v321.IsPlaying == true
	else
		v322 = v321
	end
	if v322 ~= true then
		return false
	end
	if v321 and v321.IsPlaying == true then
		v321:Stop(0.05)
	end
	if v320 and v320.IsPlaying == true then
		v320:Stop(0.05)
	end
	p318.CurrentState = "Hold"
	p318:ResumeHoldPresentation(v319)
	p318:PushRuntimeState("Hold", {
		["Aiming"] = nil,
		["Inspecting"] = false,
		["Reloading"] = nil,
		["Holstered"] = nil,
		["Aiming"] = v319.Aiming == true,
		["Reloading"] = v319.Reloading == true,
		["Holstered"] = p318.Holster
	})
	return true
end
function v19.Bolt(p323) -- name: Bolt
	local v324 = p323.CurrentTool
	assert(v324, "Failed to Bolt because no CurrentTool exists")
	v324.Bolting = true
	p323.CurrentState = "Action"
	p323:PushRuntimeState("Action", {
		["Aiming"] = nil,
		["Inspecting"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["Aiming"] = v324.Aiming == true,
		["Holstered"] = p323.Holster
	})
	p323:SendPresentationEvent("BoltStart", {
		["CurrentState"] = "Action",
		["Aiming"] = nil,
		["Inspecting"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["Aiming"] = v324.Aiming == true,
		["Holstered"] = p323.Holster
	})
	if v324.Animations.Client.Bolt and v324.Animations.Server.Bolt then
		v324.Animations.Client.Bolt:Play()
		v324.Animations.Server.Bolt:Play()
	end
	if v324.Animations.Client.Bolt then
		v324.Animations.Client.Bolt.Stopped:Wait()
	end
	if v324 == v324 then
		v324.Bolting = false
		p323.CurrentState = v324.Aiming == true and "ADS" or "Hold"
		if p323.CurrentState == "Hold" then
			p323:ResumeHoldPresentation(v324)
		end
		p323:PushRuntimeState(p323.CurrentState, {
			["Aiming"] = nil,
			["Inspecting"] = false,
			["Reloading"] = nil,
			["Holstered"] = nil,
			["Aiming"] = v324.Aiming == true,
			["Reloading"] = v324.Reloading == true,
			["Holstered"] = p323.Holster
		})
	end
end
function v19.Pump(p325) -- name: Pump
	local v326 = p325.CurrentTool
	assert(v326, "Failed to Pump-1 because no CurrentTool exists")
	v326.Pumping = true
	local v327 = p325.CurrentTool
	p325.CurrentState = "Action"
	p325:PushRuntimeState("Action", {
		["Aiming"] = nil,
		["Inspecting"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["Aiming"] = v326.Aiming == true,
		["Holstered"] = p325.Holster
	})
	p325:SendPresentationEvent("PumpStart", {
		["CurrentState"] = "Action",
		["Aiming"] = nil,
		["Inspecting"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["Aiming"] = v326.Aiming == true,
		["Holstered"] = p325.Holster
	})
	if v326.Animations.Client.Pump and v326.Animations.Server.Pump then
		v326.Animations.Client.Pump:Play()
		v326.Animations.Server.Pump:Play()
	end
	if v326.Animations.Client.Pump then
		v326.Animations.Client.Pump.Stopped:Wait()
	end
	if v326 == v327 then
		v326.Pumping = false
		p325.CurrentState = v326.Aiming == true and "ADS" or "Hold"
		if p325.CurrentState == "Hold" then
			p325:ResumeHoldPresentation(v326)
		end
		p325:PushRuntimeState(p325.CurrentState, {
			["Aiming"] = nil,
			["Inspecting"] = false,
			["Reloading"] = nil,
			["Holstered"] = nil,
			["Aiming"] = v326.Aiming == true,
			["Reloading"] = v326.Reloading == true,
			["Holstered"] = p325.Holster
		})
	end
end
function v19.HolsterWeapon(p328, p329) -- name: HolsterWeapon
	local v330 = p328.CurrentTool
	assert(v330, "Failed to HolsterWeapon because no CurrentTool exists")
	if p329 == false then
		p328.Holster = false
		p328:DetachToolModelFromArm(v330.Model)
	elseif p329 == true then
		p328.Holster = true
		p328:AttachToolModelToArm(v330.Model)
	end
	p328:RefreshWeaponExtras()
	p328:PushRuntimeState(p328.CurrentState, {
		["Holstered"] = p328.Holster,
		["Aiming"] = v330.Aiming == true,
		["Inspecting"] = p328.CurrentState == "Inspect",
		["Reloading"] = v330.Reloading == true
	})
end
function v19.EnterBarricadePresentation(p331) -- name: EnterBarricadePresentation
	local v332 = p331.CurrentTool
	assert(v332, "Failed to EnterBarricadePresentation because no CurrentTool exists")
	if v332.Aiming == true then
		p331:ReleaseADS()
	end
	if v332.Reloading == true then
		v332.ReloadCancel = true
	end
	p331:StopCurrentToolAnimation(false)
	if p331.Animations.Client.Run and p331.Animations.Client.Run.IsPlaying == true then
		p331.Animations.Client.Run:Stop()
	end
	if p331.Animations.Server.Run and p331.Animations.Server.Run.IsPlaying == true then
		p331.Animations.Server.Run:Stop()
	end
	p331.CurrentState = "Hold"
	p331:PushRuntimeState("Hold", {
		["Aiming"] = false,
		["Inspecting"] = false,
		["Reloading"] = nil,
		["Holstered"] = nil,
		["Reloading"] = v332.Reloading == true,
		["Holstered"] = p331.Holster
	})
end
function v19.ExitBarricadePresentation(p333) -- name: ExitBarricadePresentation
	local v334 = p333.CurrentTool
	if v334 then
		if v334.Aiming == true or (v334.Reloading == true or (v334.Bolting == true or (v334.Pumping == true or p333.ActionDebounce == true))) then
			p333:PushRuntimeState(p333.CurrentState, {
				["Aiming"] = v334.Aiming == true,
				["Inspecting"] = p333.CurrentState == "Inspect",
				["Reloading"] = v334.Reloading == true,
				["Holstered"] = p333.Holster
			})
		else
			p333.CurrentState = "Hold"
			p333:ResumeHoldPresentation(v334)
			p333:PushRuntimeState("Hold", {
				["Aiming"] = false,
				["Inspecting"] = false,
				["Reloading"] = false,
				["Holstered"] = nil,
				["Holstered"] = p333.Holster
			})
		end
	else
		return
	end
end
function v19.Shoot(p335) -- name: Shoot
	-- upvalues: (copy) v_u_8
	if p335.CurrentTool and p335.CurrentTool.Animations.Client.Shoot then
		p335.CurrentTool.Animations.Client.Shoot:Play()
	end
	if v_u_8.Crosshair == true and (p335.Crosshair and (p335.CurrentTool and p335.CurrentTool.CrosshairSpread)) then
		p335.Crosshair:SmoothSet(p335.CurrentTool.CrosshairSpread * 10 + 20, 0.05)
	end
end
function v19.Reload(p336) -- name: Reload
	local v337 = p336.CurrentTool
	assert(v337, "Failed to Reload-0 because no CurrentTool exists")
	p336.CurrentState = "Reload"
	v337.Animations.Client.Inspect:Stop()
	v337.ReloadCancel = false
	v337.Reloading = true
	p336:PushRuntimeState("Reload", {
		["Aiming"] = false,
		["Inspecting"] = false,
		["Reloading"] = true,
		["Holstered"] = nil,
		["Holstered"] = p336.Holster
	})
	p336:SendPresentationEvent("ReloadStart", {
		["CurrentState"] = "Reload",
		["Aiming"] = false,
		["Inspecting"] = false,
		["Reloading"] = true,
		["Holstered"] = nil,
		["Holstered"] = p336.Holster
	})
	v337.Animations.Client.Reload:Play()
	if v337.Animations.Server.Hold and v337.Animations.Server.Hold.IsPlaying == true then
		v337.Animations.Server.Hold:Stop()
	end
	v337.Animations.Server.Reload:Play()
	v337.Animations.Client.Reload.Stopped:Wait()
	v337.Animations.Server.Reload:Stop()
	v337.Reloading = false
	local v338
	if p336.CurrentTool == v337 then
		v338 = v337.ReloadCancel == false
	else
		v338 = false
	end
	if v338 == true then
		p336.CurrentState = "Hold"
		p336:ResumeHoldPresentation(v337)
	end
	p336:PushRuntimeState(p336.CurrentState, {
		["Aiming"] = nil,
		["Inspecting"] = false,
		["Reloading"] = false,
		["Holstered"] = nil,
		["Aiming"] = v337.Aiming == true,
		["Holstered"] = p336.Holster
	})
end
function v19.Action(p_u_339, p340) -- name: Action
	local v_u_341 = p_u_339.CurrentTool
	assert(v_u_341, "Failed to Action-2 because no CurrentTool exists")
	if v_u_341.Animations.Client.Action then
		p_u_339.CurrentState = "Action"
		p_u_339:PushRuntimeState("Action", {
			["Aiming"] = nil,
			["Inspecting"] = false,
			["Reloading"] = false,
			["Holstered"] = nil,
			["Aiming"] = v_u_341.Aiming == true,
			["Holstered"] = p_u_339.Holster
		})
		p_u_339:SendPresentationEvent("ActionStart", {
			["CurrentState"] = "Action",
			["Aiming"] = nil,
			["Inspecting"] = false,
			["Reloading"] = false,
			["Holstered"] = nil,
			["ActionClass"] = nil,
			["Aiming"] = v_u_341.Aiming == true,
			["Holstered"] = p_u_339.Holster,
			["ActionClass"] = p340
		})
		if p340 == "Knife" then
			p_u_339:StopCurrentToolAnimation(true)
			v_u_341.Animations.Client.Action:Play()
			v_u_341.Animations.Server.Action:Play()
			if v_u_341.Model.Handle:FindFirstChild("Action") then
				v_u_341.Model.Handle:FindFirstChild("Action"):Play()
				p_u_339:ServerSoundCue("Action", true, v_u_341.Model.Name)
			end
			task.spawn(function()
				-- upvalues: (copy) v_u_341, (copy) p_u_339
				v_u_341.Animations.Client.Action.Stopped:Wait()
				if p_u_339.CurrentTool == v_u_341 and p_u_339.CurrentState == "Action" then
					p_u_339.CurrentState = v_u_341.Aiming == true and "ADS" or "Hold"
					if p_u_339.CurrentState == "Hold" then
						p_u_339:ResumeHoldPresentation(v_u_341)
					end
					p_u_339:PushRuntimeState(p_u_339.CurrentState, {
						["Aiming"] = nil,
						["Inspecting"] = false,
						["Reloading"] = nil,
						["Holstered"] = nil,
						["Aiming"] = v_u_341.Aiming == true,
						["Reloading"] = v_u_341.Reloading == true,
						["Holstered"] = p_u_339.Holster
					})
				end
			end)
			return
		end
		if p340 == "Throwable" and p_u_339.ActionDebounce == false then
			p_u_339.ActionDebounce = true
			local v342 = p_u_339.CurrentTool
			assert(v342, "Failed to Action because no CurrentTool exists")
			p_u_339:ToggleToolModelVisible(v342.Model, true)
			p_u_339:StopCurrentToolAnimation(true)
			v342.Animations.Client.Action:Play()
			v342.Animations.Server.Action:Play()
			if v342.Model.Handle:FindFirstChild("Action") then
				v342.Model.Handle:FindFirstChild("Action"):Play()
				p_u_339:ServerSoundCue("Action", true, v342.Model.Name)
			end
			v342.Animations.Client.Action.Stopped:Wait()
			local v343 = v342.Tool
			local v344 = tonumber(v343:GetAttribute("Amount")) or 0
			p_u_339:ToggleToolModelVisible(v342.Model, v344 > 0)
			p_u_339.ActionDebounce = false
			if p_u_339.CurrentTool == v342 and p_u_339.CurrentState == "Action" then
				p_u_339.CurrentState = v342.Aiming == true and "ADS" or "Hold"
				if p_u_339.CurrentState == "Hold" then
					p_u_339:ResumeHoldPresentation(v342)
				end
				p_u_339:PushRuntimeState(p_u_339.CurrentState, {
					["Aiming"] = nil,
					["Inspecting"] = false,
					["Reloading"] = nil,
					["Holstered"] = nil,
					["Aiming"] = v342.Aiming == true,
					["Reloading"] = v342.Reloading == true,
					["Holstered"] = p_u_339.Holster
				})
			end
		end
	end
end
function v19.StopServerHold(p345) -- name: StopServerHold
	local v346 = p345.CurrentTool
	if v346 and (v346.Animations and v346.Animations.Server) then
		local v347 = v346.Animations.Server.Hold
		if v347 and v347.IsPlaying then
			v347:Stop(0.12)
		end
	end
end
function v19.PlayServerHold(p348) -- name: PlayServerHold
	local v349 = p348.CurrentTool
	if v349 and (v349.Animations and v349.Animations.Server) then
		local v350 = v349.Animations.Server.Hold
		if v350 and v350.IsPlaying ~= true then
			v350:Play(0.12)
		end
	end
end
function v19.StopCurrentToolAnimation(p351, p352) -- name: StopCurrentToolAnimation
	local v353 = p351.CurrentTool
	assert(v353, "Failed to StopCurrentToolAnimation because no CurrentTool exists")
	for v354, v355 in pairs(v353.Animations.Client) do
		if p352 == true and v354 ~= "Hold" or p352 ~= true then
			v355:Stop()
		end
	end
	for v356, v357 in pairs(v353.Animations.Server) do
		if p352 == true and v356 ~= "Hold" or p352 ~= true then
			v357:Stop()
		end
	end
	for v358, v359 in pairs(p351.Animations.Client) do
		if v358 ~= "Run" then
			v359:Stop()
		end
	end
end
function v19.GetADSZoom(_, p360) -- name: GetADSZoom
	-- upvalues: (copy) v_u_2
	local v361 = 1
	local v362 = nil
	for _, v363 in pairs(p360:GetChildren()) do
		if v_u_2:HasTag(v363, "Sight") then
			v361 = v363:GetAttribute("Zoom")
			v362 = v363:FindFirstChild("Front")
		end
	end
	return v361, v362
end
function v19.SetFP(p364, p365) -- name: SetFP
	-- upvalues: (copy) v_u_3
	local v366 = p365:FindFirstChild("ServerData")
	assert(v366, "Failed to SetFP because no ServerData folder exists")
	local v367 = p365.Character
	assert(v367, "Failed to SetFP because no character exists")
	if v366:GetAttribute("Alive") == true and (v_u_3.MouseIconEnabled ~= false or (p364.Camera.CameraType ~= Enum.CameraType.Custom or (p364.Camera.CameraSubject ~= v367.Humanoid or (p365.CameraMinZoomDistance ~= 0.5 or p365.CameraMaxZoomDistance ~= 0.5)))) then
		v_u_3.MouseIconEnabled = false
		p364.Camera.CameraType = Enum.CameraType.Custom
		p364.Camera.CameraSubject = v367.Humanoid
		p365.CameraMinZoomDistance = 0.5
		p365.CameraMaxZoomDistance = 0.5
	end
end
function v19.WeaponRuntime(p368, _) -- name: WeaponRuntime
	p368.CameraModel.Base.CFrame = p368.Camera.CFrame * CFrame.new(0, 0, -0.5)
end
return v17