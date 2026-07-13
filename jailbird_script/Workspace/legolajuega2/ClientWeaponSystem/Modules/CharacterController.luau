-- https://lua.expert/
return {
	init = function(p1) --[[ init | Line: 4 ]]
		local Services = p1.Services
		local Refs = p1.Refs
		local Modules = p1.Modules
		local State = p1.State
		local API = p1.API
		local Player = Refs.Player
		local PlayerGui = Refs.PlayerGui
		local Character = Refs.Character
		local Humanoid = Refs.Humanoid
		local Camera = Refs.Camera
		local Script = Refs.Script
		local GameEvents = Refs.GameEvents
		local ClientData = State.ClientData
		local WeaponDataNew = State.WeaponDataNew
		local Presentation = State.Presentation
		local Character2 = State.Character
		local Helpers = State.Helpers

		local function ClearCacheCamera() --[[ ClearCacheCamera | Line: 26 | Upvalues: Camera (copy) ]]
			for k, v in pairs(Camera:GetChildren()) do
				if v.Name ~= "HeadBase" and v:IsA("Model") then
					v:Destroy()
				end
			end
		end

		local function IsInitialEquipReady() --[[ IsInitialEquipReady | Line: 34 | Upvalues: Script (copy) ]]
			return if Script:GetAttribute("InitialEquipReady") == true and Script:GetAttribute("WeaponReady") == true then Script:GetAttribute("SwapInProgress") ~= true else false
		end

		local function RunWhenInitialEquipReady(p1) --[[ RunWhenInitialEquipReady | Line: 40 | Upvalues: Character2 (copy), Script (copy) ]]
			task.spawn(function() --[[ Line: 41 | Upvalues: Character2 (ref), Script (ref), p1 (copy) ]]
				for i = 1, 30 do
					if Character2.RoundEndCleanupTriggered == true then
						return
					end

					if (if Script:GetAttribute("InitialEquipReady") == true and Script:GetAttribute("WeaponReady") == true then Script:GetAttribute("SwapInProgress") ~= true else false) == true then
						break
					end

					task.wait(0.1)
				end

				p1()
			end)
		end

		local function CleanupClientWeaponSystem(p1) --[[ CleanupClientWeaponSystem | Line: 56 | Upvalues: Character2 (copy), Presentation (copy), API (copy), ClientData (copy), ClearCacheCamera (copy), WeaponDataNew (copy), State (copy), Script (copy) ]]
			if Character2.RoundEndCleanupTriggered == true then
				return
			end

			Character2.RoundEndCleanupTriggered = true
			Presentation.InitialEquipRetryInProgress = false
			Presentation.InitialWeaponEquipCompleted = false
			Presentation.InitialWeaponEquipVisualized = false
			API.Movement.ResetPendingSprintExitState()
			ClientData.PlayerHUD.Visible = false
			ClientData.MobileControlsMenu.Visible = false
			ClearCacheCamera()

			if WeaponDataNew then
				WeaponDataNew.CurrentTool = nil
				WeaponDataNew.CurrentToolIndex = 0
				WeaponDataNew.Reloading = false
			end

			State.Runtime.SampledLaserTarget = nil
			State.Runtime.ActiveLocalLaserWeaponModel = nil
			State.WeaponAction.QuickThrowHoldActive = false
			State.WeaponAction.QuickThrowPreviousWeaponIndex = 0
			State.WeaponAction.ThrowableRecoveryActive = false
			API.WeaponAction.SetThrowablePreviewBridgeState(false)
			task.defer(function() --[[ Line: 83 | Upvalues: Script (ref) ]]
				if not Script.Parent then
					return
				end

				Script:Destroy()
			end)
		end

		local function onBarricadingAttributeSignalChanged() --[[ onBarricadingAttributeSignalChanged | Line: 90 | Upvalues: Character (copy), API (copy), WeaponDataNew (copy) ]]
			local v1 = Character:GetAttribute("Barricading")

			if v1 == true then
				API.Movement.ResetPendingSprintExitState()
				API.Movement.SetMovement("Standing", false)

				if not WeaponDataNew.CurrentTool then
					WeaponDataNew.Animations.Client.Barricade:Play()

					return
				end

				WeaponDataNew:EnterBarricadePresentation()
				WeaponDataNew:HolsterWeapon(false)
				WeaponDataNew.Animations.Client.Barricade:Play()
			else
				if v1 ~= false then
					return
				end

				API.Movement.SetMovement("Standing", false)

				if WeaponDataNew.CurrentTool then
					WeaponDataNew:HolsterWeapon(true)
					WeaponDataNew:ExitBarricadePresentation()
				end

				WeaponDataNew.Animations.Client.Barricade:Stop()
			end
		end

		local function CastClimbRay() --[[ CastClimbRay | Line: 110 | Upvalues: Modules (copy), Camera (copy), Character (copy), Services (copy) ]]
			local v1 = Modules.Components.Player.ClimbRayCast(Camera.CFrame.Position, Camera.CFrame.LookVector, 5, { Character, Camera })

			return v1 and (v1.Instance and Services.CollectionService:HasTag(v1.Instance, "Climb")) and true or false
		end

		local function GetActionPositions(p1, p2) --[[ GetActionPositions | Line: 118 | Upvalues: Character (copy) ]]
			local v1 = p2.Position + p2.CFrame.LookVector * 1 - Vector3.new(0, 0.5, 0)
			local v2 = p2.Position - p2.CFrame.LookVector * 1 - Vector3.new(0, 0.5, 0)
			local t = {}

			if (Character.PrimaryPart.Position - v1).Magnitude < (Character.PrimaryPart.Position - v2).Magnitude then
				t.Start = v1
				t.End = v2 - p2.CFrame.LookVector * 1
			else
				t.Start = v2
				t.End = v1 + p2.CFrame.LookVector * 1
			end

			return t
		end

		local function CastVaultRay() --[[ CastVaultRay | Line: 134 | Upvalues: Modules (copy), Camera (copy), Character (copy), Services (copy), GetActionPositions (copy), Player (copy), GameEvents (copy), WeaponDataNew (copy) ]]
			local v1 = Modules.Components.Player.VaultRayCast(Camera.CFrame.Position, Camera.CFrame.LookVector, Modules.Config.DefaultVaultDistance, { Character, Camera })

			if not (v1 and v1.Instance) then
				return
			end

			if not Services.CollectionService:HasTag(v1.Instance, "Window") or (not ((v1.Instance.Position - Character.PrimaryPart.Position).Magnitude <= Modules.Config.VaultPromptDistance) or v1.Instance:GetAttribute("CanVault") ~= true) then
				return
			end

			local v2 = GetActionPositions(Player, v1.Instance)
			local v3 = v2.End - v2.Start
			local v4 = Vector3.new(v3.X, 0, v3.Z)

			if v4.Magnitude <= 0.001 then
				local LookVector = v1.Instance.CFrame.LookVector

				v4 = Vector3.new(LookVector.X, 0, LookVector.Z)
			end

			local v6 = if v4.Magnitude <= 0.001 then Vector3.new(0, 0, -1) else v4.Unit
			local v7 = CFrame.lookAt(v2.Start, v2.Start + v6)
			local v8 = CFrame.lookAt(v2.End, v2.End + v6)

			GameEvents:WaitForChild("VaultSync"):FireServer({
				EntryDuration = 0.25,
				CrossDuration = 0.35,
				Window = v1.Instance,
				StartCFrame = v7,
				EndCFrame = v8
			})
			WeaponDataNew:Vault()
			Character.PrimaryPart.Anchored = true
			Modules.Components.Menu.TweenCreate(Character.PrimaryPart, {
				CFrame = v7
			}, Enum.EasingStyle.Linear, 0.25, true)
			Modules.Components.Menu.TweenCreate(Character.PrimaryPart, {
				CFrame = v8
			}, Enum.EasingStyle.Linear, 0.35, true)
			Character.PrimaryPart.Anchored = false
		end

		local function Vault() --[[ Vault | Line: 172 | Upvalues: WeaponDataNew (copy), Player (copy), API (copy), CastVaultRay (copy) ]]
			if WeaponDataNew.Animations.Client.Vault.IsPlaying ~= false or (Player.ServerData:GetAttribute("Alive") ~= true or API.Movement.GetMovement() == "Proning") then
				return
			end

			if API.Movement.GetMovement() == "Crouching" or API.Movement.GetMovement() == "Proning" then
				API.Movement.SetMovement("Standing", false)
			end

			CastVaultRay()
		end

		local function onHumanoidStateChanged(p1, p2) --[[ onHumanoidStateChanged | Line: 181 | Upvalues: CastClimbRay (copy), WeaponDataNew (copy) ]]
			if p2 == Enum.HumanoidStateType.Climbing and p1 ~= Enum.HumanoidStateType.Climbing then
				if CastClimbRay() == true then
					WeaponDataNew:HolsterWeapon(false)
					WeaponDataNew.Animations.Client.Climb:Play()
					WeaponDataNew.Animations.Server.Climb:Play()
				end
			else
				if p2 == Enum.HumanoidStateType.Climbing or (p1 ~= Enum.HumanoidStateType.Climbing or WeaponDataNew.Holster ~= false) then
					return
				end

				WeaponDataNew:HolsterWeapon(true)
				WeaponDataNew.Animations.Client.Climb:Stop()
				WeaponDataNew.Animations.Server.Climb:Stop()
			end
		end

		local function onHumanoidDied() --[[ onHumanoidDied | Line: 198 | Upvalues: API (copy), ClientData (copy) ]]
			API.Movement.ResetPendingSprintExitState()
			ClientData.GameHUD.ScopeUI.Visible = false
		end

		local function onHumanoidJumping(p1) --[[ onHumanoidJumping | Line: 203 | Upvalues: API (copy), WeaponDataNew (copy), Modules (copy) ]]
			local v1 = API.Movement.GetMovement()

			if WeaponDataNew.Jumping ~= false or (not p1 or (v1 == "Proning" or (v1 == "Crouching" or v1 == "Freezing"))) then
				return
			end

			WeaponDataNew.Jumping = true
			task.wait(Modules.Config.JumpCooldown)
			WeaponDataNew.Jumping = false
		end

		Character:SetAttribute("Barricading", false)
		Script.Destroying:Connect(function() --[[ Line: 214 | Upvalues: Character2 (copy), API (copy), ClientData (copy), State (copy), ClearCacheCamera (copy) ]]
			Character2.RoundEndCleanupTriggered = true
			API.Movement.ResetPendingSprintExitState()
			ClientData.PlayerHUD.Visible = false
			ClientData.MobileControlsMenu.Visible = false
			State.WeaponAction.QuickThrowHoldActive = false
			State.WeaponAction.ThrowableRecoveryActive = false
			API.WeaponAction.SetThrowablePreviewBridgeState(false)
			ClearCacheCamera()
		end)
		Refs.ServerFolder:GetAttributeChangedSignal("Phase"):Connect(function() --[[ Line: 225 | Upvalues: Character2 (copy), ClientData (copy), API (copy) ]]
			if Character2.RoundEndCleanupTriggered == true then
				return
			end

			if not ClientData.MobileControlsMenu then
				return
			end

			ClientData.MobileControlsMenu.Visible = API.Input.CanShowMobileControlsMenu()

			if not ClientData.MobileControlsMenu.Visible then
				return
			end

			API.Input.UpdateClawMode()
			API.Input.RefreshMobileControlsPosition()
		end)
		GameEvents.SwapWeapon.OnClientEvent:Connect(function(p1, p2) --[[ Line: 238 | Upvalues: API (copy), WeaponDataNew (copy), Presentation (copy), Character2 (copy), Script (copy) ]]
			if p1 == "Equip" then
				API.WeaponAction.SwapWeapon(p2.Index)

				return
			end

			if p1 == "Confirm" then
				WeaponDataNew:ConfirmServerEquip(if p2 then p2 else {})
				API.WeaponAction.ApplyConfirmedWeaponSlot(if p2 then p2 else {})
			elseif p1 == "Reject" then
				WeaponDataNew:RejectPendingEquip(p2)
				API.WeaponAction.ApplyConfirmedWeaponSlot(if p2 then p2 else {})
			else
				if p1 ~= "SetUp" then
					return
				end

				task.defer(function() --[[ Line: 248 | Upvalues: Presentation (ref), Character2 (ref), Script (ref), API (ref) ]]
					if Presentation.InitialWeaponEquipCompleted == true or Character2.RoundEndCleanupTriggered == true then
						return
					end

					local v1 = if Script:GetAttribute("InitialEquipReady") == true and Script:GetAttribute("WeaponReady") == true then Script:GetAttribute("SwapInProgress") ~= true else false

					if v1 ~= true and API.Presentation.TryInitialWeaponEquip("server setup") ~= true then
						return
					end

					Presentation.InitialWeaponEquipCompleted = true
					Presentation.InitialWeaponEquipVisualized = true
				end)
			end
		end)
		GameEvents.SoundCue.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 265 | Upvalues: API (copy), Player (copy) ]]
			if p1:IsA("Model") then
				local v1 = p1.HumanoidRootPart:FindFirstChild(p2)

				if v1 == nil and p4 then
					v1 = if p1:FindFirstChild(p4) then p1:FindFirstChild(p4).Handle:FindFirstChild(p2) else nil
				end

				if not v1 or p1 == Player then
					return
				end

				if p3 == true then
					v1:Play()

					return
				end

				v1:Stop()
			else
				if not (p1.Character and p1.Character:FindFirstChild("HumanoidRootPart")) then
					return
				end

				local v3 = p1.Character.HumanoidRootPart:FindFirstChild(p2)

				if v3 == nil and p4 then
					local v4 = API.WeaponAction.resolveEquippedCharacterWeaponModel(p1.Character, p4)
					local v5 = if v4 then v4:FindFirstChild("Handle", true) else v4

					v3 = if v5 then v5:FindFirstChild(p2) else v5
				end

				if not v3 or p1 == Player then
					return
				end

				if p3 == true then
					v3:Play()
				else
					v3:Stop()
				end
			end
		end)
		GameEvents.Hit.OnClientEvent:Connect(function(p1, p2, p3, p4, p5, p6) --[[ Line: 301 | Upvalues: Player (copy), Modules (copy) ]]
			if p1 ~= Player then
				Modules.Components.HitEffect.Hit(p2, p3, p4, p5, p6, p1)
			end
		end)
		GameEvents.HitFromServer.OnClientEvent:Connect(function(p1, p2, p3, p4, p5, p6) --[[ Line: 308 | Upvalues: Modules (copy) ]]
			Modules.Components.HitEffect.Hit(p2, p3, p4, p5, p6, p1)
		end)
		GameEvents.Shoot.OnClientEvent:Connect(function(p1, p2) --[[ Line: 312 | Upvalues: API (copy) ]]
			API.WeaponAction.ShootEffect(p1, p2)
		end)
		GameEvents.PingLocation.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 316 | Upvalues: Player (copy), Services (copy), Modules (copy) ]]
			if Player.Team ~= p1.Team then
				return
			end

			local v1 = workspace.Map_Cache:FindFirstChild("Ping" .. p1.Name)
			local v2

			if v1 then
				v1:Destroy()
			end

			v2 = Services.ReplicatedStorage.Components.GameMenu.Ping:Clone()
			v2.Parent = workspace.Map_Cache
			v2.CFrame = CFrame.new(p2, p2 + p4)
			v2.PingFrame.Enabled = true
			v2.Name = "Ping" .. p1.Name
			v2.Beep:Play()
			v2.PingFrame.Pin.Player.Image = p1.ServerData:GetAttribute("ProfilePicture")
			v2.SurfaceGui.Circle.Size = UDim2.new(0, 0, 0, 0)
			v2.PingFrame.Enabled = true
			v2.SurfaceGui.Enabled = true
			Modules.Components.Menu.TweenCreate(v2.SurfaceGui.Circle, {
				ImageTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, Enum.EasingStyle.Sine, 1, false)
			Modules.Components.Menu.TweenCreate(v2.PingFrame, {
				ExtentsOffset = Vector3.new(0, 2, 0),
				Size = UDim2.new(0, 50, 0, 50)
			}, Enum.EasingStyle.Sine, 0.2, false)
			task.wait(0.5)
			pcall(function() --[[ Line: 335 | Upvalues: Modules (ref), v2 (copy), Services (ref) ]]
				Modules.Components.Menu.TweenCreate(v2.PingFrame, {
					ExtentsOffset = Vector3.new(0, 0, 0),
					Size = UDim2.new(0, 25, 0, 25)
				}, Enum.EasingStyle.Bounce, 0.2, false)
				Services.Debris:AddItem(v2, 5)
			end)
		end)
		GameEvents.SpawnPlayer.OnClientEvent:Connect(function(p1) --[[ Line: 341 | Upvalues: Helpers (copy), Character2 (copy), Script (copy) ]]
			local function ApplySpawnLook() --[[ ApplySpawnLook | Line: 342 | Upvalues: p1 (copy), Helpers (ref) ]]
				local CurrentCamera = workspace.CurrentCamera
				local v1 = p1 * Vector3.new(1, 0, 1)

				if v1.Magnitude <= 0 then
					return
				end

				if Helpers.IsFirstPersonSpectateCameraActive() ~= true then
					CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + v1.Unit)
				end
			end

			local function f1() --[[ Line: 354 | Upvalues: p1 (copy), Helpers (ref), ApplySpawnLook (copy) ]]
				local CurrentCamera = workspace.CurrentCamera
				local v1 = p1 * Vector3.new(1, 0, 1)

				if not (v1.Magnitude <= 0) and Helpers.IsFirstPersonSpectateCameraActive() ~= true then
					CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + v1.Unit)
				end

				task.defer(ApplySpawnLook)
				task.delay(0.1, ApplySpawnLook)
			end

			task.spawn(function() --[[ Line: 41 | Upvalues: Character2 (ref), Script (ref), f1 (copy) ]]
				for i = 1, 30 do
					if Character2.RoundEndCleanupTriggered == true then
						return
					end

					if (if Script:GetAttribute("InitialEquipReady") == true and Script:GetAttribute("WeaponReady") == true then Script:GetAttribute("SwapInProgress") ~= true else false) == true then
						break
					end

					task.wait(0.1)
				end

				f1()
			end)
		end)
		task.spawn(function() --[[ Line: 361 | Upvalues: PlayerGui (copy) ]]
			PlayerGui.GameHUD.DamageFeed.Heal.ImageTransparency = 1
		end)
		GameEvents.HitMarker.OnClientEvent:Connect(function(p1) --[[ Line: 365 | Upvalues: Modules (copy) ]]
			local isHitMarker = Modules.Config.HitMarker == true
		end)
		Humanoid.StateChanged:Connect(onHumanoidStateChanged)
		Humanoid.Jumping:Connect(onHumanoidJumping)
		Humanoid.Died:Connect(onHumanoidDied)
		Character:GetAttributeChangedSignal("Barricading"):Connect(onBarricadingAttributeSignalChanged)
		ClientData.GameHUD.ScopeUI.Scope.Position = UDim2.new(0.5, State.Runtime.ScopeSwaySin, 0.5, State.Runtime.ScopeSwayCos + Helpers.getGuiInset())

		return {
			CleanupClientWeaponSystem = CleanupClientWeaponSystem,
			ClearCacheCamera = ClearCacheCamera,
			CastClimbRay = CastClimbRay,
			CastVaultRay = CastVaultRay,
			Vault = Vault
		}
	end
}