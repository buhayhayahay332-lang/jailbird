-- https://lua.expert/
return {
	init = function(p1) --[[ init | Line: 4 ]]
		local Services = p1.Services
		local Refs = p1.Refs
		local Modules = p1.Modules
		local State = p1.State
		local API = p1.API
		local Player = Refs.Player
		local Character = Refs.Character
		local Humanoid = Refs.Humanoid
		local Script = Refs.Script
		local ServerFolder = Refs.ServerFolder
		local ClientData = State.ClientData
		local WeaponDataNew = State.WeaponDataNew
		local Movement = State.Movement

		local function GetMovement() --[[ GetMovement | Line: 23 | Upvalues: Script (copy) ]]
			return Script:GetAttribute("Movement")
		end

		local function IsWeaponPresentationReady() --[[ IsWeaponPresentationReady | Line: 27 | Upvalues: Script (copy) ]]
			return if Script:GetAttribute("WeaponReady") == true then Script:GetAttribute("SwapInProgress") ~= true else false
		end

		local function SetMovement(p1, p2) --[[ SetMovement | Line: 31 | Upvalues: Player (copy), Script (copy), WeaponDataNew (copy) ]]
			local v1 = if p2 == false then false else true

			if p1 == "Crouching" or p1 == "Proning" then
				if Player.ServerData:GetAttribute("Alive") ~= true then
					return
				end

				Script:SetAttribute("Movement", p1)

				if p1 == "Proning" then
					WeaponDataNew:SoundCue("Prone", true)

					return
				end

				if p1 == "Crouching" then
					WeaponDataNew:SoundCue("Crouch", true)
				end
			else
				if v1 == true and (p1 == "Standing" or p1 == "Running" and (Script:GetAttribute("Movement") == "Proning" or Script:GetAttribute("Movement") == "Crouching")) then
					WeaponDataNew:SoundCue("Stand", true)
				end

				Script:SetAttribute("Movement", p1)
			end
		end

		local function GetLean() --[[ GetLean | Line: 50 | Upvalues: Script (copy) ]]
			return Script:GetAttribute("Lean") or 0
		end

		local function SetLean(p1) --[[ SetLean | Line: 54 | Upvalues: Script (copy), WeaponDataNew (copy) ]]
			if Script:GetAttribute("Movement") ~= "Running" and Script:GetAttribute("Movement") ~= "Proning" then
				Script:SetAttribute("Lean", p1)
			end

			if p1 ~= -1 and p1 ~= 1 then
				return
			end

			WeaponDataNew:SoundCue("Lean", true)
		end

		local function GetVestWalkSpeedModifier() --[[ GetVestWalkSpeedModifier | Line: 64 | Upvalues: Services (copy), Player (copy) ]]
			local v1 = Services.ReplicatedStorage.Items.Vest:FindFirstChild(Player.PlayerData.Loadout[Player.PlayerData.Settings:GetAttribute("LoadoutName")]:GetAttribute("Vest"))

			if v1 == nil then
				return 0
			end

			return (v1:GetAttribute("WalkSpeed") or 0) / 100
		end

		local function GetToolWalkSpeedModifier() --[[ GetToolWalkSpeedModifier | Line: 72 | Upvalues: Character (copy) ]]
			if not Character then
				return 0
			end

			local Tool = Character:FindFirstChildOfClass("Tool")

			if Tool == nil then
				return 0
			end

			local v1 = Tool:GetAttribute("Weight") or 0

			if v1 > 4.5 then
				return (v1 - 4.5) / 20 * -1
			end

			if v1 < 2.5 then
				return (2.5 - v1) / 20
			end

			return 0
		end

		local function IsADSWalkSpeedState(p1) --[[ IsADSWalkSpeedState | Line: 92 | Upvalues: WeaponDataNew (copy) ]]
			local CurrentTool = WeaponDataNew.CurrentTool

			return if CurrentTool == nil or CurrentTool.Aiming ~= true then false elseif p1 == "Walking" or p1 == "Standing" then true else p1 == "Creeping"
		end

		local function ResolveMovementSpeedState(p1) --[[ ResolveMovementSpeedState | Line: 99 | Upvalues: WeaponDataNew (copy) ]]
			local CurrentTool = WeaponDataNew.CurrentTool

			if (if CurrentTool == nil or CurrentTool.Aiming ~= true then false elseif p1 == "Walking" or p1 == "Standing" then true elseif p1 == "Creeping" then true else false) == true then
				return "Creeping"
			end

			return p1
		end

		local function GetMovementBaseSpeed(p1) --[[ GetMovementBaseSpeed | Line: 106 | Upvalues: WeaponDataNew (copy), Modules (copy) ]]
			local CurrentTool = WeaponDataNew.CurrentTool
			local v2 = if (if CurrentTool == nil or CurrentTool.Aiming ~= true then false elseif p1 == "Walking" or p1 == "Standing" then true elseif p1 == "Creeping" then true else false) == true then "Creeping" else p1

			if v2 == "Walking" then
				return Modules.Config.NormalWalkSpeed
			end

			if v2 == "Creeping" then
				return Modules.Config.SlowPaceWalkSpeed
			end

			if v2 == "Running" then
				return Modules.Config.RunWalkSpeed
			end

			if v2 == "Proning" then
				return Modules.Config.ProneWalksSpeed
			end

			if v2 == "Crouching" then
				return Modules.Config.CrouchWalkSpeed
			end

			if v2 == "Standing" then
				return Modules.Config.NormalWalkSpeed
			end

			return 0
		end

		local function CalculateTargetWalkSpeed(p1) --[[ CalculateTargetWalkSpeed | Line: 125 | Upvalues: WeaponDataNew (copy), GetMovementBaseSpeed (copy), GetVestWalkSpeedModifier (copy), Character (copy), Modules (copy), ServerFolder (copy), Player (copy) ]]
			local CurrentTool = WeaponDataNew.CurrentTool
			local v2 = if (if CurrentTool == nil or CurrentTool.Aiming ~= true then false elseif p1 == "Walking" or p1 == "Standing" then true elseif p1 == "Creeping" then true else false) == true then "Creeping" else p1
			local v3 = GetMovementBaseSpeed(p1)

			if v3 <= 0 then
				return 0
			end

			local v4 = GetVestWalkSpeedModifier()
			local v5

			if Character then
				local Tool = Character:FindFirstChildOfClass("Tool")

				if Tool == nil then
					v5 = 0
				else
					local v6 = Tool:GetAttribute("Weight") or 0

					v5 = if v6 > 4.5 then (v6 - 4.5) / 20 * -1 elseif v6 < 2.5 then (2.5 - v6) / 20 else 0
				end
			else
				v5 = 0
			end

			local v7 = v3 + v4 * v3 + v5 * v3

			if v2 == "Creeping" then
				local CurrentTool2 = WeaponDataNew.CurrentTool

				if (if CurrentTool2 == nil or CurrentTool2.Aiming ~= true then false elseif p1 == "Walking" or p1 == "Standing" then true else p1 == "Creeping") == true then
					local NormalWalkSpeed = Modules.Config.NormalWalkSpeed

					v7 = math.max(v7, (NormalWalkSpeed + v4 * NormalWalkSpeed + v5 * NormalWalkSpeed) * 0.9)
				end
			end

			if ServerFolder:GetAttribute("SpeedMode") == true and ServerFolder:GetAttribute("GameMode") == "Custom" then
				v7 = v7 * 2.5
			end

			if Character and (Character:GetAttribute("Frost") and Character:GetAttribute("Frost") > 0) then
				v7 = v7 * 0.3
			end

			if Player.Team and (Player.Team.Name == ServerFolder:GetAttribute("Attacker") and ServerFolder:GetAttribute("AttackerMovement") == false) then
				return 0
			end

			return v7
		end

		local function StopWalkSpeedTween() --[[ StopWalkSpeedTween | Line: 157 | Upvalues: Movement (copy) ]]
			if not Movement.ActiveWalkSpeedTween then
				return
			end

			Movement.ActiveWalkSpeedTween:Cancel()
			Movement.ActiveWalkSpeedTween = nil
		end

		local function TweenWalkSpeed(p1, p2) --[[ TweenWalkSpeed | Line: 164 | Upvalues: Movement (copy), Humanoid (copy), Modules (copy) ]]
			if Movement.ActiveWalkSpeedTween then
				Movement.ActiveWalkSpeedTween:Cancel()
				Movement.ActiveWalkSpeedTween = nil
			end

			if p1 <= 0 then
				Humanoid.WalkSpeed = 0

				return
			end

			if p2 == true then
				Humanoid.WalkSpeed = p1 * 0.75
			end

			local v1 = Modules.Components.Menu.TweenCreate(Humanoid, {
				WalkSpeed = p1
			}, Enum.EasingStyle.Sine, Movement.MovementStartTweenDuration, false)

			Movement.ActiveWalkSpeedTween = v1
			v1.Completed:Connect(function() --[[ Line: 177 | Upvalues: Movement (ref), v1 (copy) ]]
				if Movement.ActiveWalkSpeedTween ~= v1 then
					return
				end

				Movement.ActiveWalkSpeedTween = nil
			end)
		end

		local function UpdateWalkSpeedClient(p1, p2) --[[ UpdateWalkSpeedClient | Line: 184 | Upvalues: Humanoid (copy), ServerFolder (copy), Movement (copy), CalculateTargetWalkSpeed (copy), TweenWalkSpeed (copy) ]]
			if not (Humanoid.Health > 0 and ServerFolder:GetAttribute("Countdown") <= 0) then
				return
			end

			local v1 = if Movement.PendingSprintExitActive == true and (Movement.PendingSprintExitMovement ~= nil and (p1 == "Standing" or p1 == "Walking")) then Movement.PendingSprintExitMovement else p1
			local v2 = CalculateTargetWalkSpeed(v1)

			if v1 == "Proning" or (v1 == "Crouching" or v1 == "Freezing") then
				Humanoid.JumpPower = 0
			end

			TweenWalkSpeed(v2, if p2 == true then true else false)
			Movement.LastAppliedWalkState = v1
		end

		local function UpdateMovementStartWalkSpeed(p1) --[[ UpdateMovementStartWalkSpeed | Line: 201 | Upvalues: Humanoid (copy), Movement (copy), UpdateWalkSpeedClient (copy) ]]
			local v1 = if Humanoid.MoveDirection.Magnitude > 0.05 then true else false

			if Movement.PendingSprintExitActive == true then
				if v1 == true then
					UpdateWalkSpeedClient(Movement.PendingSprintExitMovement or "Proning", Movement.WasActivelyMoving == false)
				elseif Movement.ActiveWalkSpeedTween then
					Movement.ActiveWalkSpeedTween:Cancel()
					Movement.ActiveWalkSpeedTween = nil
				end

				Movement.WasActivelyMoving = v1
			else
				local v5 = (if p1 == "Standing" then false elseif p1 == "Freezing" then false else true) and v1

				if v5 == true and Movement.WasActivelyMoving == false then
					UpdateWalkSpeedClient(p1, true)
				elseif v5 == true and Movement.LastAppliedWalkState ~= p1 then
					UpdateWalkSpeedClient(p1, false)
				elseif v5 == false and (Movement.WasActivelyMoving == true and Movement.ActiveWalkSpeedTween) then
					Movement.ActiveWalkSpeedTween:Cancel()
					Movement.ActiveWalkSpeedTween = nil
				end

				Movement.WasActivelyMoving = v5
			end
		end

		local function RuntimeMovementStateAnim() --[[ RuntimeMovementStateAnim | Line: 227 | Upvalues: Character (copy), Movement (copy), Script (copy), WeaponDataNew (copy) ]]
			if not (Character and Character.PrimaryPart) then
				return
			end

			Movement.IsMoving = (Character.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude > 1

			local v3 = Script:GetAttribute("Movement")

			if Movement.PrevMovementState ~= v3 or Movement.PrevMoving ~= Movement.IsMoving then
				if Movement.PrevMovementState == "Crouching" and Movement.PrevMovementState ~= v3 then
					WeaponDataNew.Animations.Server.CrouchIdle:Stop(0.35)
					WeaponDataNew.Animations.Server.CrouchWalk:Stop(0.35)
				elseif Movement.PrevMovementState == "Proning" and Movement.PrevMovementState ~= v3 then
					WeaponDataNew.Animations.Server.ProneIdle:Stop(0.35)
					WeaponDataNew.Animations.Server.ProneWalk:Stop(0.35)
				end

				if v3 == "Crouching" then
					if Movement.PrevMoving == false and Movement.IsMoving == true then
						WeaponDataNew.Animations.Server.CrouchIdle:Stop(0.35)
					elseif Movement.PrevMoving == true and Movement.IsMoving == false then
						WeaponDataNew.Animations.Server.CrouchWalk:Stop(0.35)
					end
				elseif v3 == "Proning" and (Movement.PrevMoving == false and Movement.IsMoving == true) then
					WeaponDataNew.Animations.Server.ProneIdle:Stop(0.35)
				elseif v3 == "Proning" and (Movement.PrevMoving == true and Movement.IsMoving == false) then
					WeaponDataNew.Animations.Server.ProneWalk:Stop(0.35)
				end

				if v3 == "Crouching" and Movement.IsMoving == true then
					WeaponDataNew.Animations.Server.CrouchWalk:Play(0.35)
					WeaponDataNew.Animations.Server.CrouchWalk:AdjustSpeed(0.6)
				elseif v3 == "Crouching" and Movement.IsMoving == false then
					WeaponDataNew.Animations.Server.CrouchIdle:Play(0.35)
				elseif v3 == "Proning" and Movement.IsMoving == true then
					WeaponDataNew.Animations.Server.ProneWalk:Play(0.35)
				elseif v3 == "Proning" and Movement.IsMoving == false then
					WeaponDataNew.Animations.Server.ProneIdle:Play(0.35)
				end
			end

			Movement.PrevMovementState = v3
			Movement.PrevMoving = Movement.IsMoving
		end

		local function GetSprintExitRecoverySettings(p1) --[[ GetSprintExitRecoverySettings | Line: 273 ]]
			if p1 == "Proning" then
				return 0.35, -0.75
			end

			return 0.2, -0.25
		end

		local function ResetPendingSprintExitState() --[[ ResetPendingSprintExitState | Line: 280 | Upvalues: Movement (copy) ]]
			Movement.PendingSprintExitResumeAt = 0
			Movement.PendingSprintExitActive = false
			Movement.PendingSprintExitMovement = nil
		end

		local function UpdateSprinting(p1) --[[ UpdateSprinting | Line: 286 | Upvalues: Character (copy), WeaponDataNew (copy), Script (copy), Movement (copy), API (copy), SetMovement (copy), ClientData (copy), Humanoid (copy) ]]
			if not (Character and Character.PrimaryPart) then
				return
			end

			if WeaponDataNew.CurrentTool == nil then
				return
			end

			local v1 = if Script:GetAttribute("WeaponReady") == true then Script:GetAttribute("SwapInProgress") ~= true else false

			if v1 == true and Character:GetAttribute("Spawning") ~= true then
				if Character:GetAttribute("Barricading") == true == true then
					Movement.PendingSprintExitResumeAt = 0
					Movement.PendingSprintExitActive = false
					Movement.PendingSprintExitMovement = nil

					return
				end

				local v3 = API.WeaponAction and (API.WeaponAction.IsSprintBlockedByHardAction and API.WeaponAction.IsSprintBlockedByHardAction() == true)
				local v4 = API.WeaponAction and (API.WeaponAction.IsInspectBlockingSprint and API.WeaponAction.IsInspectBlockingSprint() == true)
				local v5 = if v3 == true then true elseif v4 == true then true else false
				local v6 = if (Character.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude > 1 then true else false
				local v7 = os.clock()
				local v8 = WeaponDataNew.GetStateFolder and WeaponDataNew:GetStateFolder() or nil
				local v9 = if Script:GetAttribute("ServerVaultOverride") == true then true else false

				if v9 ~= true and v8 then
					v9 = if v8:GetAttribute("VaultActive") == true then true else false
				end

				if v9 == true and Script:GetAttribute("ServerVaultOverride") ~= true then
					local v10 = WeaponDataNew.Animations and (WeaponDataNew.Animations.Server and WeaponDataNew.Animations.Server.Vault)
					local v11 = WeaponDataNew.Animations and (WeaponDataNew.Animations.Client and WeaponDataNew.Animations.Client.Vault)
					local v12 = if v10 then v10.IsPlaying == true else v10

					if v12 ~= true and (if v11 then v11.IsPlaying == true else v11) ~= true then
						v9 = false

						if v8 and v8:GetAttribute("VaultActive") == true then
							v8:SetAttribute("VaultActive", false)
						end
					end
				end

				if v9 == true then
					Movement.PendingSprintExitResumeAt = 0
					Movement.PendingSprintExitActive = false
					Movement.PendingSprintExitMovement = nil

					if p1 ~= "Running" then
						return
					end

					SetMovement(if v6 == true then "Walking" else "Standing")
				elseif p1 == "Proning" or p1 == "Crouching" then
					if ClientData.RunningHold == true and (v6 == true and (v3 ~= true and v4 == true)) then
						if API.WeaponAction and API.WeaponAction.TryCancelInspectForSprint then
							API.WeaponAction.TryCancelInspectForSprint()
						end

						Movement.PendingSprintExitResumeAt = 0
						Movement.PendingSprintExitActive = false
						Movement.PendingSprintExitMovement = nil
					else
						if ClientData.RunningHold == true and (v5 ~= true and v6 == true) then
							if Movement.PendingSprintExitActive == true then
								return
							end

							Movement.PendingSprintExitActive = true
							Movement.PendingSprintExitMovement = p1
							Movement.PendingSprintExitResumeAt = v7 + (if p1 == "Proning" then 0.35 else 0.2)
							Script:SetAttribute("Movement", "Standing")

							return
						end

						Movement.PendingSprintExitResumeAt = 0
						Movement.PendingSprintExitActive = false
						Movement.PendingSprintExitMovement = nil
					end
				else
					if Movement.PendingSprintExitActive == true then
						local PendingSprintExitMovement = Movement.PendingSprintExitMovement

						if PendingSprintExitMovement == nil then
							Movement.PendingSprintExitResumeAt = 0
							Movement.PendingSprintExitActive = false
							Movement.PendingSprintExitMovement = nil
						else
							if ClientData.RunningHold == true and v5 ~= true then
								if v6 == true then
									if v7 < Movement.PendingSprintExitResumeAt and Humanoid.CameraOffset.Y < (if PendingSprintExitMovement == "Proning" then -0.75 else -0.25) then
										if p1 == "Standing" then
											return
										end

										Script:SetAttribute("Movement", "Standing")
									else
										Movement.PendingSprintExitResumeAt = 0
										Movement.PendingSprintExitActive = false
										Movement.PendingSprintExitMovement = nil

										if Script:GetAttribute("Movement") ~= "Running" and Script:GetAttribute("Movement") ~= "Proning" then
											Script:SetAttribute("Lean", 0)
										end

										if p1 == "Running" then
											return
										end

										if Script:GetAttribute("Movement") == "Proning" or Script:GetAttribute("Movement") == "Crouching" then
											WeaponDataNew:SoundCue("Stand", true)
										end

										Script:SetAttribute("Movement", "Running")
									end
								else
									Movement.PendingSprintExitResumeAt = 0
									Movement.PendingSprintExitActive = false
									Movement.PendingSprintExitMovement = nil

									if p1 == "Standing" then
										return
									end

									Script:SetAttribute("Movement", "Standing")
								end

								return
							end

							Movement.PendingSprintExitResumeAt = 0
							Movement.PendingSprintExitActive = false
							Movement.PendingSprintExitMovement = nil
						end
					end

					if v6 == false then
						if p1 == "Standing" then
							return
						end

						Script:SetAttribute("Movement", "Standing")
					elseif ClientData.RunningHold == true and (v3 ~= true and v4 == true) then
						if not (API.WeaponAction and API.WeaponAction.TryCancelInspectForSprint) then
							return
						end

						API.WeaponAction.TryCancelInspectForSprint()
					else
						if (if ClientData.RunningHold == true then v5 ~= true else false) == true then
							if p1 == "Running" then
								return
							end

							if Script:GetAttribute("Movement") ~= "Running" and Script:GetAttribute("Movement") ~= "Proning" then
								Script:SetAttribute("Lean", 0)
							end

							if Script:GetAttribute("Movement") ~= "Proning" and Script:GetAttribute("Movement") ~= "Crouching" then
								Script:SetAttribute("Movement", "Running")

								return
							end

							WeaponDataNew:SoundCue("Stand", true)
							Script:SetAttribute("Movement", "Running")

							return
						end

						if p1 == "Walking" then
							return
						end

						Script:SetAttribute("Movement", "Walking")
					end
				end
			else
				Movement.PendingSprintExitResumeAt = 0
				Movement.PendingSprintExitActive = false
				Movement.PendingSprintExitMovement = nil

				if (if (if Script:GetAttribute("SwapInProgress") == true then true else false) == true then if p1 == "Proning" then true elseif p1 == "Crouching" then true else false else false) == true or p1 == "Standing" then
					return
				end

				Script:SetAttribute("Movement", "Standing")
			end
		end

		local function UpdateJumpLock(p1) --[[ UpdateJumpLock | Line: 417 | Upvalues: WeaponDataNew (copy), Humanoid (copy), Modules (copy) ]]
			if WeaponDataNew.Jumping == true or p1 == "Proning" then
				Humanoid.JumpPower = 0
			else
				Humanoid.JumpPower = Modules.Config.JumpPower
			end
		end

		local function UpdateMobileCrouch() --[[ UpdateMobileCrouch | Line: 425 | Upvalues: Player (copy), ClientData (copy), Script (copy), WeaponDataNew (copy) ]]
			if Player:GetAttribute("OnConsole") ~= true and Player:GetAttribute("OnMobile") ~= true then
				return
			end

			if ClientData.CrouchingHold ~= true then
				return
			end

			if os.clock() - ClientData.CrouchingHoldTimer <= 0.2 then
				return
			end

			if Script:GetAttribute("Movement") == "Proning" then
				return
			end

			ClientData.RunningHold = false

			if Script:GetAttribute("Movement") ~= "Running" and Script:GetAttribute("Movement") ~= "Proning" then
				Script:SetAttribute("Lean", 0)
			end

			if Player.ServerData:GetAttribute("Alive") ~= true then
				ClientData.CrouchingHold = false

				return
			end

			Script:SetAttribute("Movement", "Proning")
			WeaponDataNew:SoundCue("Prone", true)
			ClientData.CrouchingHold = false
		end

		local function StanceConfig() --[[ StanceConfig | Line: 437 | Upvalues: Script (copy), WeaponDataNew (copy), Refs (copy), GetMovement (copy), Movement (copy), ClientData (copy), Modules (copy), Humanoid (copy), API (copy), CalculateTargetWalkSpeed (copy), State (copy), UpdateWalkSpeedClient (copy) ]]
			Script:GetAttributeChangedSignal("Movement"):Connect(function() --[[ Line: 438 | Upvalues: WeaponDataNew (ref), Refs (ref), GetMovement (ref), Script (ref), Movement (ref), ClientData (ref), Modules (ref), Humanoid (ref), API (ref), CalculateTargetWalkSpeed (ref), State (ref), UpdateWalkSpeedClient (ref) ]]
				if WeaponDataNew.CurrentTool == nil then
					return nil
				end

				Refs.GameEvents.ChangeMovement:FireServer(GetMovement())
				Refs.GameEvents.Stance:FireServer(Script:GetAttribute("Movement"), Script:GetAttribute("Lean") or 0)

				if Script:GetAttribute("Movement") == "Standing" or Script:GetAttribute("Movement") == "Freezing" then
					Movement.WasActivelyMoving = false

					if Movement.ActiveWalkSpeedTween then
						Movement.ActiveWalkSpeedTween:Cancel()
						Movement.ActiveWalkSpeedTween = nil
					end
				end

				if Script:GetAttribute("Movement") == "Standing" then
					WeaponDataNew:PlayServerHold()
					ClientData.CameraY = 0

					if Movement.StanceCurrentTween then
						Movement.StanceCurrentTween:Cancel()
					end

					local t = {}

					t.CameraOffset = Vector3.new(Script:GetAttribute("Lean") or 0, ClientData.CameraY, 0)
					Movement.StanceCurrentTween = Modules.Components.Menu.TweenCreate(Humanoid, t, Enum.EasingStyle.Sine, 0.3)
				elseif Script:GetAttribute("Movement") == "Crouching" then
					WeaponDataNew:PlayServerHold()
					WeaponDataNew.Animations.Client.Run:Stop(0.12)
					WeaponDataNew:SoundCue("Run", false)
					ClientData.CameraY = -1.6

					if Movement.StanceCurrentTween then
						Movement.StanceCurrentTween:Cancel()
					end

					local t = {}

					t.CameraOffset = Vector3.new(Script:GetAttribute("Lean") or 0, ClientData.CameraY, 0)
					Movement.StanceCurrentTween = Modules.Components.Menu.TweenCreate(Humanoid, t, Enum.EasingStyle.Sine, 0.3)
				elseif Script:GetAttribute("Movement") == "Proning" then
					WeaponDataNew:PlayServerHold()
					WeaponDataNew.Animations.Client.Run:Stop(0.12)
					WeaponDataNew:SoundCue("Run", false)
					ClientData.CameraY = -3.25

					if Movement.StanceCurrentTween then
						Movement.StanceCurrentTween:Cancel()
					end

					local t = {}

					t.CameraOffset = Vector3.new(Script:GetAttribute("Lean") or 0, ClientData.CameraY, 0)
					Movement.StanceCurrentTween = Modules.Components.Menu.TweenCreate(Humanoid, t, Enum.EasingStyle.Quad, 0.5)
				elseif Script:GetAttribute("Movement") == "Running" and WeaponDataNew.Animations.Client.Run then
					if ClientData.ForwardMovement ~= 0 then
						local CurrentTool = WeaponDataNew.CurrentTool
						local v10 = Script:GetAttribute("ServerVaultOverride") == true

						if API.WeaponAction and API.WeaponAction.AimDownSightRelease then
							API.WeaponAction.AimDownSightRelease()
						end

						if v10 ~= true then
							WeaponDataNew:StopServerHold()
						end

						WeaponDataNew.Animations.Client.Run:Play(0.2)
						WeaponDataNew:SoundCue("Run", true)
						WeaponDataNew.Animations.Client.Run:AdjustSpeed(0.67 / Modules.Config.RunWalkSpeed * CalculateTargetWalkSpeed(GetMovement()))
						ClientData.CameraY = 0

						if Movement.StanceCurrentTween then
							Movement.StanceCurrentTween:Cancel()
						end

						if (not CurrentTool or CurrentTool.Aiming ~= true) and (API.Presentation and API.Presentation.TweenFOV) then
							API.Presentation.TweenFOV(State.PlayerSettings:GetAttribute("FieldOfView"), 0.15)
						end
					end
				elseif Script:GetAttribute("Movement") == "Walking" and WeaponDataNew.Animations.Client.Run then
					WeaponDataNew.Animations.Client.Run:Stop(0.12)
					WeaponDataNew:PlayServerHold()
					WeaponDataNew:SoundCue("Run", false)
					ClientData.CameraY = 0

					if Movement.StanceCurrentTween then
						Movement.StanceCurrentTween:Cancel()
					end

					local t = {}

					t.CameraOffset = Vector3.new(Script:GetAttribute("Lean") or 0, ClientData.CameraY, 0)
					Movement.StanceCurrentTween = Modules.Components.Menu.TweenCreate(Humanoid, t, Enum.EasingStyle.Sine, 0.3)
				end

				UpdateWalkSpeedClient(GetMovement())

				if not (API.Presentation and API.Presentation.PushSpectatePresentationState) then
					return
				end

				API.Presentation.PushSpectatePresentationState({
					Movement = Script:GetAttribute("Movement"),
					Lean = Script:GetAttribute("Lean") or 0
				})
			end)
			Script:GetAttributeChangedSignal("Lean"):Connect(function() --[[ Line: 503 | Upvalues: Refs (ref), GetMovement (ref), Script (ref), Movement (ref), Modules (ref), Humanoid (ref), ClientData (ref), API (ref) ]]
				Refs.GameEvents.ChangeMovement:FireServer(GetMovement())
				Refs.GameEvents.Stance:FireServer(Script:GetAttribute("Movement"), Script:GetAttribute("Lean") or 0)

				if Movement.StanceCurrentTween then
					Movement.StanceCurrentTween:Cancel()
				end

				local t = {}

				t.CameraOffset = Vector3.new(Script:GetAttribute("Lean") or 0, ClientData.CameraY, 0)
				Movement.StanceCurrentTween = Modules.Components.Menu.TweenCreate(Humanoid, t, Enum.EasingStyle.Sine, 0.4)

				if not (API.Presentation and API.Presentation.PushSpectatePresentationState) then
					return
				end

				API.Presentation.PushSpectatePresentationState({
					Movement = Script:GetAttribute("Movement"),
					Lean = Script:GetAttribute("Lean") or 0
				})
			end)
		end

		ClientData.CrouchingHoldTimer = os.clock()
		Script:SetAttribute("IsMoving", false)
		Services.ContentProvider:PreloadAsync({
			WeaponDataNew.Animations.Server.CrouchIdle,
			WeaponDataNew.Animations.Server.CrouchWalk,
			WeaponDataNew.Animations.Server.ProneWalk,
			WeaponDataNew.Animations.Server.ProneIdle
		})
		StanceConfig()
		task.spawn(function() --[[ Line: 518 | Upvalues: Script (copy) ]]
			Script:SetAttribute("Movement", "Standing")
		end)

		return {
			GetMovement = GetMovement,
			SetMovement = SetMovement,
			GetLean = GetLean,
			SetLean = SetLean,
			CalculateTargetWalkSpeed = CalculateTargetWalkSpeed,
			UpdateWalkSpeedClient = UpdateWalkSpeedClient,
			UpdateMovementStartWalkSpeed = UpdateMovementStartWalkSpeed,
			RuntimeMovementStateAnim = RuntimeMovementStateAnim,
			UpdateSprinting = UpdateSprinting,
			UpdateJumpLock = UpdateJumpLock,
			UpdateMobileCrouch = UpdateMobileCrouch,
			GetWalkSpeed = function() --[[ GetWalkSpeed | Line: 534 | Upvalues: CalculateTargetWalkSpeed (copy), Script (copy) ]]
				return CalculateTargetWalkSpeed(Script:GetAttribute("Movement"))
			end,
			ResetPendingSprintExitState = ResetPendingSprintExitState
		}
	end
}