return {
	["init"] = function(p1) -- name: init
		local v_u_2 = p1.Services
		local v3 = p1.Refs
		local v_u_4 = p1.Modules
		local v5 = p1.State
		local v_u_6 = p1.API
		local v_u_7 = v3.Player
		local v_u_8 = v3.PlayerGui
		local v_u_9 = v3.Character
		local v_u_10 = v3.Humanoid
		local v_u_11 = v3.Camera
		local v_u_12 = v3.Script
		local v_u_13 = v3.ServerFolder
		local v_u_14 = v3.GameEvents
		local v_u_15 = v5.ClientData
		local v_u_16 = v5.WeaponDataNew
		local v_u_17 = v5.WeaponAction
		local v_u_18 = v5.Runtime
		local _ = v5.Presentation
		local v_u_19 = v5.Ping
		local v_u_20 = v5.Keybinds
		local v_u_21 = v5.PlayerSettings
		local v_u_22 = v5.Helpers
		local function v_u_23(...)
			-- upvalues: (copy) v_u_6
			if v_u_6.Presentation and v_u_6.Presentation.SelectHUDEquipment then
				return v_u_6.Presentation.SelectHUDEquipment(...)
			end
		end
		local function v_u_24(...)
			-- upvalues: (copy) v_u_6
			if v_u_6.Presentation and v_u_6.Presentation.PushSpectatePresentationState then
				return v_u_6.Presentation.PushSpectatePresentationState(...)
			end
		end
		local function v29(p25, p26) -- name: resolveEquippedCharacterWeaponModel
			-- upvalues: (copy) v_u_4
			if p25 then
				local v27 = typeof(p26) == "string" and p26 ~= "" and v_u_4.WeaponSlotResolver.ResolveVisibleModel(p25, p26)
				if v27 then
					return v27
				else
					local v28 = v_u_4.WeaponSlotResolver.GetStateFolder(p25)
					if v28 then
						v28 = v28:GetAttribute("EquippedToolName")
					end
					if typeof(v28) == "string" and v28 ~= "" then
						return v_u_4.WeaponSlotResolver.ResolveVisibleModel(p25, v28)
					else
						return nil
					end
				end
			else
				return nil
			end
		end
		function v_u_22.getCurrentStateFolder() -- name: getCurrentStateFolder
			-- upvalues: (copy) v_u_7, (copy) v_u_4
			local v30 = v_u_7.Character
			return v30 and v_u_4.WeaponSlotResolver.GetStateFolder(v30) or nil
		end
		v_u_22.resolveEquippedCharacterWeaponModel = v29
		local function v_u_36(p31, p32) -- name: SetThrowablePreviewBridgeState
			-- upvalues: (copy) v_u_12, (copy) v_u_4, (copy) v_u_7, (copy) v_u_24
			local v33 = p31 == true and (p32 or "") or ""
			if v_u_12:GetAttribute("ThrowablePreviewActive") ~= p31 then
				v_u_12:SetAttribute("ThrowablePreviewActive", p31)
			end
			if v_u_12:GetAttribute("ThrowablePreviewToolName") ~= v33 then
				v_u_12:SetAttribute("ThrowablePreviewToolName", v33)
			end
			local v34 = v_u_4.WeaponSlotResolver.UpdateStateFolder
			local v35 = v_u_7.Character
			v34(v35 and v_u_4.WeaponSlotResolver.GetStateFolder(v35) or nil, {
				["ThrowablePreviewActive"] = p31,
				["ThrowablePreviewToolName"] = v33
			})
			v_u_24({
				["ThrowablePreviewActive"] = p31,
				["ThrowablePreviewToolName"] = v33
			})
		end
		local function v_u_40() -- name: SyncThrowablePreviewState
			-- upvalues: (copy) v_u_16, (copy) v_u_17, (copy) v_u_36
			local v37 = v_u_16.CurrentTool
			local v38
			if v_u_17.ThrowableRecoveryActive == true or (v37 == nil or (v37.Tool == nil or v37.Tool:GetAttribute("Class") ~= "Throwable")) then
				v38 = false
			else
				if v37 and v37.Tool and v37.Tool:GetAttribute("Class") == "Throwable" then
					local v39 = v37.Tool
					v38 = (tonumber(v39:GetAttribute("Amount")) or 0) > 0
				else
					v38 = false
				end
				if v38 then
					v38 = v_u_16.CurrentToolIndex == 4 and true or v_u_17.QuickThrowHoldActive == true
				end
			end
			if v38 == true then
				v_u_36(true, v37.Tool.Name)
			else
				v_u_36(false)
			end
		end
		local function v_u_52() -- name: CaptureThrowableThrowSnapshot
			-- upvalues: (copy) v_u_16, (copy) v_u_4, (copy) v_u_9, (copy) v_u_11, (copy) v_u_8
			local v41 = v_u_16.CurrentTool
			if not v41 or (not v41.Tool or v41.Tool:GetAttribute("Class") ~= "Throwable") then
				v_u_16.ThrowableSnapshot = nil
				return nil
			end
			local v42 = v_u_4.Throwable.BuildClientThrowData
			local v43 = v_u_9
			local v44 = v_u_11
			local v45 = v_u_8.Crosshair
			local v46 = v41.Model
			local v47 = v41.Model
			local v48 = { v_u_9, v_u_11 }
			if v_u_16.CameraModel then
				local v49 = v_u_16.CameraModel
				table.insert(v48, v49)
			end
			if v47 then
				table.insert(v48, v47)
			end
			local v50 = v42(v43, v44, v45, v46, v48)
			if not v50 then
				v_u_16.ThrowableSnapshot = nil
				return nil
			end
			local v51 = {
				["ToolName"] = v41.Tool.Name,
				["CameraPosition"] = v50.CameraPosition,
				["ViewDirection"] = v50.ViewDirection or v50.Direction,
				["StartPosition"] = v50.Origin,
				["ThrowData"] = v50
			}
			v_u_16.ThrowableSnapshot = v51
			return v51
		end
		local v_u_53 = nil
		local v_u_54 = nil
		local v_u_55 = nil
		local v_u_56 = nil
		local v_u_57 = nil
		local v_u_58 = nil
		local function v_u_61(p59) -- name: ScheduleBufferedADSRetry
			-- upvalues: (copy) v_u_17, (ref) v_u_58
			if not p59 then
				local v60 = (v_u_17.ADSUnlockAt or 0) - os.clock()
				p59 = math.max(v60, 0)
			end
			if p59 <= 0 then
				task.defer(v_u_58)
			else
				task.delay(p59, function()
					-- upvalues: (ref) v_u_17, (ref) v_u_58
					if v_u_17.BufferedADSIntent == true then
						v_u_58()
					end
				end)
			end
		end
		local function v_u_65(p62) -- name: ApplyHoldPresentationState
			-- upvalues: (copy) v_u_16, (ref) v_u_57, (copy) v_u_4, (copy) v_u_20, (copy) v_u_6, (copy) v_u_21, (copy) v_u_15, (copy) v_u_24
			local v63 = v_u_16
			if v63 then
				v63 = v_u_16.CurrentTool
			end
			if v63 and v63.Aiming == true then
				v_u_57(v63, p62)
			else
				local v64 = p62 or 0.12
				v_u_4.CameraSens:AdjustSensitivity(v_u_20.CameraSensitivity)
				if v_u_6.Presentation and v_u_6.Presentation.TweenFOV then
					v_u_6.Presentation.TweenFOV(v_u_21:GetAttribute("FieldOfView"), v64)
				end
				if v_u_15.GameHUD and v_u_15.GameHUD.ScopeUI then
					v_u_15.GameHUD.ScopeUI.Visible = false
				end
				v_u_24({
					["TargetFOV"] = nil,
					["ScopeVisible"] = false,
					["CrosshairVisible"] = nil,
					["Aiming"] = false,
					["TargetFOV"] = v_u_21:GetAttribute("FieldOfView"),
					["CrosshairVisible"] = v_u_16.Crosshair and v_u_16.Crosshair.Enabled == true and true or false
				})
			end
		end
		v_u_57 = function(p66, p67)
			-- upvalues: (copy) v_u_4, (copy) v_u_20, (copy) v_u_6, (copy) v_u_15, (copy) v_u_24, (copy) v_u_21
			if p66 and (p66.Tool and p66.Settings) then
				local v68 = p67 or 0.12
				if p66.Tool:GetAttribute("ADSType") == "Scope" then
					v_u_4.CameraSens:AdjustSensitivity(v_u_20.ADSSensitivity * 0.5)
					if v_u_6.Presentation and v_u_6.Presentation.TweenFOV then
						v_u_6.Presentation.TweenFOV(25, v68)
					end
					if v_u_15.GameHUD and v_u_15.GameHUD.ScopeUI then
						v_u_15.GameHUD.ScopeUI.Visible = true
					end
					v_u_24({
						["TargetFOV"] = 25,
						["ScopeVisible"] = true,
						["CrosshairVisible"] = false,
						["Aiming"] = true
					})
				else
					local v69 = v_u_21:GetAttribute("FieldOfView") - 5 * p66.Settings.ADSZoom
					v_u_4.CameraSens:AdjustSensitivity(v_u_20.ADSSensitivity)
					if v_u_6.Presentation and v_u_6.Presentation.TweenFOV then
						v_u_6.Presentation.TweenFOV(v69, v68)
					end
					if v_u_15.GameHUD and v_u_15.GameHUD.ScopeUI then
						v_u_15.GameHUD.ScopeUI.Visible = false
					end
					v_u_24({
						["TargetFOV"] = nil,
						["ScopeVisible"] = false,
						["CrosshairVisible"] = false,
						["Aiming"] = true,
						["TargetFOV"] = v69
					})
				end
			else
				return
			end
		end
		v_u_58 = function()
			-- upvalues: (copy) v_u_17, (copy) v_u_21, (copy) v_u_15, (copy) v_u_12, (copy) v_u_16, (copy) v_u_4, (copy) v_u_61, (ref) v_u_53
			if v_u_17.BufferedADSIntent == true then
				local v70
				if v_u_17.BufferedADSIntent == true then
					v70 = v_u_21:GetAttribute("ADSToggle") == true and true or v_u_15.ADSInputHeld == true
				else
					v70 = false
				end
				if v70 == true then
					local v71
					if v_u_16 == nil or v_u_16.IsWeaponPresentationReady == nil then
						v71 = false
					else
						v71 = v_u_16:IsWeaponPresentationReady() == true
					end
					if v71 == true then
						if (v_u_17.BufferedADSSwapGeneration or 0) == (v_u_17.SwapGeneration or 0) then
							local v72 = v_u_16.CurrentTool
							local v73 = v_u_17.BufferedADSToolSerial or ""
							local v74 = v72 and v72.Tool and (v_u_4.WeaponSlotResolver.GetOrAssignToolSerial(v72.Tool) or "") or ""
							if v73 == "" or v73 ~= v74 then
								v_u_17.BufferedADSIntent = false
								v_u_17.BufferedADSSwapGeneration = 0
								v_u_17.BufferedADSToolSerial = ""
								v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
								v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
								v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
								return
							elseif v72 and v72.Tool then
								if v72.Tool:GetAttribute("Class") == "Primary" or v72.Tool:GetAttribute("Class") == "Secondary" then
									if v72.Aiming == true then
										local v75
										if v_u_16 == nil or v_u_16.IsWeaponReady == nil then
											v75 = false
										else
											v75 = v_u_16:IsWeaponReady() == true
										end
										if v75 == true then
											v_u_17.BufferedADSIntent = false
											v_u_17.BufferedADSSwapGeneration = 0
											v_u_17.BufferedADSToolSerial = ""
											v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
											v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
											v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
										end
										return
									else
										local v76 = (v_u_17.ADSUnlockAt or 0) - os.clock()
										if v76 > 0 then
											v_u_61(v76)
										else
											if v_u_53 then
												v_u_53()
											end
											local v77 = v_u_16.CurrentTool
											if v77 and v77.Aiming == true then
												local v78
												if v_u_16 == nil or v_u_16.IsWeaponReady == nil then
													v78 = false
												else
													v78 = v_u_16:IsWeaponReady() == true
												end
												if v78 == true then
													v_u_17.BufferedADSIntent = false
													v_u_17.BufferedADSSwapGeneration = 0
													v_u_17.BufferedADSToolSerial = ""
													v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
													v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
													v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
												end
											end
										end
									end
								else
									v_u_17.BufferedADSIntent = false
									v_u_17.BufferedADSSwapGeneration = 0
									v_u_17.BufferedADSToolSerial = ""
									v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
									v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
									v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
									return
								end
							else
								v_u_17.BufferedADSIntent = false
								v_u_17.BufferedADSSwapGeneration = 0
								v_u_17.BufferedADSToolSerial = ""
								v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
								v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
								v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
								return
							end
						else
							v_u_17.BufferedADSIntent = false
							v_u_17.BufferedADSSwapGeneration = 0
							v_u_17.BufferedADSToolSerial = ""
							v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
							v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
							v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
							return
						end
					else
						return
					end
				else
					v_u_17.BufferedADSIntent = false
					v_u_17.BufferedADSSwapGeneration = 0
					v_u_17.BufferedADSToolSerial = ""
					v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
					v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
					v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
					return
				end
			else
				return
			end
		end
		v_u_12:GetAttributeChangedSignal("WeaponPresentationReady"):Connect(function()
			-- upvalues: (copy) v_u_12, (ref) v_u_58
			if v_u_12:GetAttribute("WeaponPresentationReady") == true then
				task.defer(v_u_58)
			end
		end)
		v_u_12:GetAttributeChangedSignal("WeaponFullyReady"):Connect(function()
			-- upvalues: (copy) v_u_12, (ref) v_u_58
			if v_u_12:GetAttribute("WeaponFullyReady") == true then
				task.defer(v_u_58)
			end
		end)
		local function v_u_84(p79) -- name: ReturnToPreviousWeaponIfNeeded
			-- upvalues: (copy) v_u_16, (copy) v_u_17, (ref) v_u_55
			local v80 = v_u_16.CurrentTool
			if v80 and (v80.Tool and v80.Tool:GetAttribute("Class") == "Throwable") then
				local v81 = v80.Tool
				local v82 = tonumber(v81:GetAttribute("Amount")) or 0
				local v83 = p79 or v_u_17.LastNonThrowableWeaponIndex
				if v82 <= 0 and (type(v83) == "number" and (v83 >= 1 and v83 ~= 4)) then
					v_u_55(v83)
				end
			end
		end
		local function v_u_87(p85) -- name: FindBarricadeModelFromHitInstance
			while p85 do
				if p85:IsA("Model") and p85.Name == "Barricade" then
					return p85
				end
				local v86 = p85:FindFirstChild("Barricade")
				if v86 and v86:IsA("Model") then
					return v86
				end
				p85 = p85.Parent
			end
			return nil
		end
		local function v_u_105(p88, p89) -- name: GetClosestPointOnPart
			local v90 = p88.CFrame:PointToObjectSpace(p89)
			local v91 = p88.Size * 0.5
			local v92 = p88.CFrame
			local v93 = v90.X
			local v94 = -v91.X
			local v95 = v91.X
			local v96 = math.clamp(v93, v94, v95)
			local v97 = v90.Y
			local v98 = -v91.Y
			local v99 = v91.Y
			local v100 = math.clamp(v97, v98, v99)
			local v101 = v90.Z
			local v102 = -v91.Z
			local v103 = v91.Z
			local v104 = math.clamp(v101, v102, v103)
			return v92:PointToWorldSpace((Vector3.new(v96, v100, v104)))
		end
		local function v_u_117(p106) -- name: ResolveKnifeBarricadeHit
			-- upvalues: (copy) v_u_87, (copy) v_u_105, (copy) v_u_4
			if not p106 or (not p106.Instance or p106.Instance.Name == "BarricadePlank") then
				return p106
			end
			local v107 = p106.Instance
			local v108
			if v107 and v107:IsA("BasePart") and (v107.Name == "BarricadePort" or v107:GetAttribute("BlockSetup") == true) then
				v108 = v107.CanCollide == true
			else
				v108 = false
			end
			if v108 == true then
				return p106
			end
			local v109 = v_u_87(p106.Instance)
			if not v109 then
				return p106
			end
			local v110 = (1 / 0)
			local v111 = nil
			local v112 = nil
			for _, v113 in ipairs(v109:GetChildren()) do
				if v113:IsA("BasePart") and (v113.Name == "BarricadePlank" and (v113:GetAttribute("Health") or 0) > 0) then
					local v114 = v_u_105(v113, p106.Position)
					local v115 = (v114 - p106.Position).Magnitude
					if v115 < v110 then
						v112 = v114
						v111 = v113
						v110 = v115
					end
				end
			end
			if v111 then
				local v116 = v_u_4.Config.KnifeDistance * 0.5
				if math.max(1.5, v116) >= v110 then
					return {
						["Instance"] = v111,
						["Position"] = v112 or p106.Position,
						["Normal"] = p106.Normal,
						["Material"] = v111.Material,
						["Distance"] = p106.Distance
					}
				end
			end
			return p106
		end
		local function v_u_144(p118) -- name: CastBulletRay
			-- upvalues: (copy) v_u_15, (copy) v_u_9, (copy) v_u_11, (copy) v_u_16, (copy) v_u_4, (copy) v_u_117, (copy) v_u_7, (copy) v_u_14, (copy) v_u_2
			v_u_15.Ray_Ignore = { v_u_9, v_u_11 }
			local v119 = Vector3.new()
			if v_u_16.CurrentTool and v_u_16.CurrentTool.Tool:GetAttribute("Class") ~= "Knife" then
				local v120 = math.random(-v_u_16.CurrentTool.Settings.MinSpread * 10, v_u_16.CurrentTool.Settings.MinSpread * 10) / 10
				local v121 = math.rad(v120)
				local v122 = math.random(-v_u_16.CurrentTool.Settings.MinSpread * 10, v_u_16.CurrentTool.Settings.MinSpread * 10) / 10
				local v123 = math.rad(v122)
				local v124 = math.random(-v_u_16.CurrentTool.Settings.MinSpread * 10, v_u_16.CurrentTool.Settings.MinSpread * 10) / 10
				local v125 = math.rad(v124)
				v119 = Vector3.new(v121, v123, v125)
				if v_u_16.CurrentTool.Aiming == false then
					local v126 = math.random(-v_u_16.CurrentTool.Settings.MaxSpread * 10, v_u_16.CurrentTool.Settings.MaxSpread * 10) / 10
					local v127 = math.rad(v126)
					local v128 = math.random(-v_u_16.CurrentTool.Settings.MaxSpread * 10, v_u_16.CurrentTool.Settings.MaxSpread * 10) / 10
					local v129 = math.rad(v128)
					local v130 = math.random(-v_u_16.CurrentTool.Settings.MaxSpread * 10, v_u_16.CurrentTool.Settings.MaxSpread * 10) / 10
					local v131 = math.rad(v130)
					v119 = Vector3.new(v127, v129, v131) * (1 - v_u_16.CurrentTool.Settings.HipFireReduction / 100 or 1)
				end
			end
			local v132 = v_u_11.CFrame.Position
			local v133 = v_u_11.CFrame.LookVector + v119
			local v134 = v_u_4.Components.Player.BulletRayCast
			if v_u_16.CurrentTool and v_u_16.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
				v134 = v_u_4.Components.Player.KnifeRayCast
			end
			local v135, v136 = v134(v132, v133, p118 or 500, { v_u_9, v_u_11 })
			if v_u_16.CurrentTool and v_u_16.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
				v135 = v_u_117(v135)
			end
			local v137 = v135 and {
				["StartPosition"] = v132,
				["Direction"] = v133,
				["EndPosition"] = v135.Position,
				["Instance"] = v135.Instance,
				["Normal"] = v135.Normal,
				["Material"] = v135.Material
			} or nil
			local v138 = typeof(v136) ~= "table" and {} or v136
			for _, v139 in pairs(v138) do
				v_u_4.Components.HitEffect.Hit(v139.Instance, v139.Position, v139.Normal, v139.Material, v_u_16.CurrentTool.Settings, v_u_7)
				local v140 = {
					["StartPosition"] = v132,
					["Direction"] = v133,
					["EndPosition"] = v139.Position,
					["Instance"] = v139.Instance,
					["Normal"] = v139.Normal,
					["Material"] = v139.Material
				}
				v_u_14.Hit:FireServer(v139, v140)
			end
			local v141 = nil
			local v142 = nil
			if v135 and v_u_16.CurrentTool then
				if v_u_2.CollectionService:HasTag(v135.Instance, "PlayerHitRegistration") then
					local v143 = v_u_4.Components.Player.FindHumanoidFromBulletHit(v135.Instance)
					if v143 and v143.Health > 0 then
						v141 = v_u_2.Players:FindFirstChild(v143.Parent.Name) or v143.Parent
						if v_u_16.CurrentTool and v_u_16.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
							v142 = v_u_4.Config.HeadDamage
						elseif v_u_2.CollectionService:HasTag(v135.Instance, "PlayerHead") then
							v142 = v_u_4.Config.HeadDamage
						elseif v_u_2.CollectionService:HasTag(v135.Instance, "PlayerTorso") then
							v142 = v_u_16.CurrentTool.Settings.TorsoDamage
						elseif v_u_2.CollectionService:HasTag(v135.Instance, "PlayerLimb") then
							v142 = v_u_16.CurrentTool.Settings.LimbsDamage
						else
							v142 = v_u_16.CurrentTool.Settings.LimbsDamage
							warn("Missing tags")
						end
					end
				elseif v_u_16.CurrentTool then
					if v_u_16.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
						v_u_4.Components.HitEffect.Hit(v135.Instance, v135.Position, v135.Normal, v135.Material, true, v_u_7)
					else
						v_u_4.Components.HitEffect.Hit(v135.Instance, v135.Position, v135.Normal, v135.Material, nil, v_u_7)
					end
					v_u_14.Hit:FireServer(v135, v137)
				end
				if v_u_16.CurrentTool and v_u_16.CurrentTool.Tool:GetAttribute("Class") == "Knife" then
					v_u_16.CurrentTool.Model.Handle:FindFirstChild("Hit"):Play()
					v_u_16:ServerSoundCue("Hit", true, v_u_16.CurrentTool.Model.Name)
				end
			end
			if v_u_16.CurrentTool then
				v_u_14.Damage:FireServer(v141, v142, v_u_16.CurrentTool.Model.Name, v137)
			end
		end
		local function v_u_148() -- name: Recoil
			-- upvalues: (copy) v_u_16, (copy) v_u_18, (copy) v_u_4, (copy) v_u_22, (copy) v_u_11, (copy) v_u_15
			task.spawn(function()
				-- upvalues: (ref) v_u_16, (ref) v_u_18, (ref) v_u_4, (ref) v_u_22, (ref) v_u_11, (ref) v_u_15
				if v_u_16.CurrentTool and v_u_16.CurrentTool.Settings then
					v_u_18.CameraShake:Shake(v_u_4.CShakeModule.Presets.Bullet)
					local v145 = v_u_16.CurrentTool.Settings.VRecoil * v_u_4.Config.RecoilMultiplier
					local v146 = v_u_16.CurrentTool.Settings.HRecoil * math.random(-1, 1)
					local v147 = CFrame.Angles(v145 * 0.00001, v146 * 0.00001, 0)
					if v_u_22.IsFirstPersonSpectateCameraActive() ~= true then
						v_u_11.CFrame = v_u_11.CFrame * v147
					end
					if v_u_16.CurrentTool.Aiming == true then
						v_u_15.Recoil = CFrame.Angles(0, v146 * 0.00001, 0) * CFrame.new(0, 0, -0.15)
					else
						v_u_15.Recoil = CFrame.Angles(0, v146 * 0.00001, 0) * CFrame.new(0, 0, -0.8)
					end
				end
				v_u_16:Shoot()
			end)
			if v_u_16.CurrentTool and v_u_16.CurrentTool.Model then
				v_u_4.Components.Weapon.MuzzleShootEffect(v_u_16.CurrentTool.Model)
			end
		end
		local function v_u_151() -- name: IsSprintBlockedByHardAction
			-- upvalues: (copy) v_u_16
			local v149 = v_u_16.CurrentTool
			if not (v149 and v149.Tool) then
				return false
			end
			if v_u_16.QuickAction == true or v_u_16.ActionDebounce == true then
				return true
			end
			if v149.Reloading == true or (v149.Bolting == true or (v149.Pumping == true or v149.SemiCooldown == true)) then
				return true
			end
			local v150 = v149.Animations
			if v150 then
				v150 = v149.Animations.Client
			end
			if v150 then
				if v150.Action and v150.Action.IsPlaying == true then
					return true
				end
				if v150.Equip and v150.Equip.IsPlaying == true then
					return true
				end
			end
			return false
		end
		local function v_u_152() -- name: Knife
			-- upvalues: (copy) v_u_16, (ref) v_u_54, (copy) v_u_144, (copy) v_u_4
			if v_u_16.CurrentTool then
				if v_u_16.ActionDebounce == false and v_u_16.CurrentTool.Animations.Client.Action then
					v_u_16.ActionDebounce = true
					v_u_54()
					if not v_u_16.CurrentTool.Animations.Client.Action.IsPlaying then
						v_u_16:Action("Knife")
						v_u_144(v_u_4.Config.KnifeDistance)
					end
					task.wait(v_u_4.Config.KnifeCooldown / 1.5)
					v_u_16.ActionDebounce = false
				end
			end
		end
		local function v154() -- name: QuickKnife
			-- upvalues: (copy) v_u_16, (ref) v_u_55, (copy) v_u_152
			local v153 = v_u_16.CurrentToolIndex
			v_u_55(3)
			v_u_16.QuickAction = true
			v_u_152()
			v_u_16.QuickAction = false
			v_u_55(v153)
		end
		local function v168() -- name: Shoot
			-- upvalues: (copy) v_u_16, (copy) v_u_10, (copy) v_u_6, (copy) v_u_14, (copy) v_u_144, (copy) v_u_148, (copy) v_u_4, (ref) v_u_54, (copy) v_u_15, (copy) v_u_2, (copy) v_u_152, (ref) v_u_56
			local v155
			if v_u_16 == nil or v_u_16.IsWeaponReady == nil then
				v155 = false
			else
				v155 = v_u_16:IsWeaponReady() == true
			end
			if v155 == true then
				if v_u_16.CurrentTool then
					if v_u_16.Holster == true and v_u_10.Health > 0 then
						local v156 = v_u_16.CurrentTool
						local v157 = v156.Tool:GetAttribute("Class")
						if v157 == "Primary" or v157 == "Secondary" then
							local v158 = v156.Tool:GetAttribute("Ammo")
							if math.floor(v158) <= 0 then
								local v159 = v156.Model:FindFirstChild("Handle")
								if v159 then
									local v160 = v159:FindFirstChild("FirePoint")
									v_u_4.Components.Weapon.AddSFX(v_u_2.ReplicatedStorage.Config.Audio.GunClick, v160, 0.5, true)
								end
							end
							if v_u_16.QuickAction == false and (v156.Bolting ~= true and (v156.Pumping ~= true and v156.SemiCooldown ~= true)) then
								v_u_16.Animations.Client.Run:Play()
								v_u_16.Animations.Client.Run:Stop(0.02)
								v_u_16:SoundCue("Run", false)
								if v156.Animations.Client.Inspect then
									v156.Animations.Client.Inspect:Stop()
								end
								if v156.Reloading == true then
									v156.ReloadCancel = true
									v156.Animations.Client.Reload:Stop()
									v156.Animations.Server.Reload:Stop()
								end
								if v_u_6.Movement.GetMovement() == "Running" then
									v_u_6.Movement.SetMovement("Walking")
								end
								if v156.Settings.Mode == "Semi" or v156.Settings.Mode == "Pump-Action" then
									local v161 = v156.Tool:GetAttribute("Ammo")
									if math.floor(v161) > 0 then
										v156.SemiCooldown = true
										v_u_14.Shoot:FireServer()
										for _ = 1, v156.Settings.Bullets do
											v_u_144()
										end
										v_u_148()
										local v162 = 1 / (v156.Settings.FireRate * v_u_4.Config.FireRateMultiplier / 60)
										if v156.Settings.Mode == "Pump-Action" then
											v_u_16:Pump()
										else
											task.wait(v162)
										end
										v156.SemiCooldown = false
										return
									end
								end
								if v156.Settings.Mode == "Bolt-Action" then
									local v163 = v156.Tool:GetAttribute("Ammo")
									if math.floor(v163) > 0 then
										v156.SemiCooldown = true
										v_u_14.Shoot:FireServer()
										for _ = 1, v156.Settings.Bullets do
											v_u_144()
										end
										v_u_148()
										local v164 = v156.Aiming
										local v165 = v156.Tool.Name
										v_u_54()
										v_u_16:Bolt()
										if v165 == v156.Tool.Name and v164 == true then
											v_u_15.RunningHold = false
											if v_u_6.WeaponAction and v_u_6.WeaponAction.AimDownSight then
												v_u_6.WeaponAction.AimDownSight()
											end
										end
										v156.SemiCooldown = false
										return
									end
								end
								if v156.Settings.Mode == "Auto" then
									while v_u_15.MouseHeld and (v156 and (v156.Model ~= nil and (v156.Tool:GetAttribute("Ammo") > 0 and v_u_16.QuickAction == false))) do
										v156.SemiCooldown = true
										local v166 = v_u_16.CurrentToolID
										v_u_14.Shoot:FireServer()
										for _ = 1, v156.Settings.Bullets do
											v_u_144()
										end
										v_u_148()
										local v167 = 1 / (v156.Settings.FireRate * v_u_4.Config.FireRateMultiplier / 60)
										task.wait(v167)
										if v_u_16.CurrentToolID ~= v166 then
											v_u_15.MouseHeld = false
										end
										v156.SemiCooldown = false
									end
								end
							end
						else
							if v157 == "Knife" then
								v_u_152()
								return
							end
							if v157 == "Throwable" then
								v_u_56()
							end
						end
					end
				end
			else
				return
			end
		end
		local function v_u_175() -- name: StartQuickThrowHold
			-- upvalues: (copy) v_u_17, (copy) v_u_7, (copy) v_u_16, (ref) v_u_55, (copy) v_u_36, (copy) v_u_40
			if v_u_17.QuickThrowHoldActive == true or v_u_7.ServerData:GetAttribute("Alive") ~= true then
				return
			else
				local v169 = v_u_16.Tools
				if v169 then
					v169 = v_u_16.Tools.Throwable
				end
				local v170
				if v169 and v169.Tool and v169.Tool:GetAttribute("Class") == "Throwable" then
					local v171 = v169.Tool
					v170 = (tonumber(v171:GetAttribute("Amount")) or 0) > 0
				else
					v170 = false
				end
				if v170 == true then
					v_u_17.QuickThrowPreviousWeaponIndex = v_u_16.CurrentToolIndex ~= 4 and v_u_16.CurrentToolIndex or v_u_17.LastNonThrowableWeaponIndex
					if v_u_16.CurrentToolIndex ~= 4 then
						v_u_55(4)
					end
					local v172 = v_u_16.CurrentTool
					local v173
					if v172 and v172.Tool and v172.Tool:GetAttribute("Class") == "Throwable" then
						local v174 = v172.Tool
						v173 = (tonumber(v174:GetAttribute("Amount")) or 0) > 0
					else
						v173 = false
					end
					if v173 == true then
						v_u_16.ThrowableSnapshot = nil
						v_u_16.QuickAction = true
						v_u_17.QuickThrowHoldActive = true
						v_u_17.ThrowableRecoveryActive = false
						v_u_40()
						v_u_40()
					else
						v_u_17.QuickThrowPreviousWeaponIndex = 0
						v_u_36(false)
						v_u_16.ThrowableSnapshot = nil
					end
				else
					return
				end
			end
		end
		local function v178(p176) -- name: ReleaseQuickThrowHold
			-- upvalues: (copy) v_u_17, (copy) v_u_36, (ref) v_u_56, (copy) v_u_16, (ref) v_u_55
			if v_u_17.QuickThrowHoldActive == true then
				v_u_17.QuickThrowHoldActive = false
				v_u_36(false)
				local v177 = v_u_17.QuickThrowPreviousWeaponIndex
				v_u_17.QuickThrowPreviousWeaponIndex = 0
				if p176 == true then
					v_u_56()
				else
					v_u_16.ThrowableSnapshot = nil
					v_u_16.QuickAction = false
				end
				if v_u_16.QuickAction == true then
					v_u_16.QuickAction = false
				end
				if type(v177) == "number" and (v177 >= 1 and v177 ~= 4) then
					v_u_55(v177)
				end
			end
		end
		v_u_56 = function()
			-- upvalues: (copy) v_u_16, (ref) v_u_54, (copy) v_u_36, (copy) v_u_52, (copy) v_u_17, (copy) v_u_40, (copy) v_u_84
			if v_u_16.CurrentTool then
				if v_u_16.CurrentTool.Tool:GetAttribute("Amount") then
					v_u_54()
					local v179 = v_u_16.CurrentTool.Tool
					if tonumber(v179:GetAttribute("Amount")) > 0 then
						v_u_36(false)
						if not v_u_52() then
							v_u_16.ThrowableSnapshot = nil
							return
						end
						v_u_17.ThrowableRecoveryActive = true
						v_u_40()
						v_u_16:Action("Throwable")
						v_u_84()
						v_u_17.ThrowableRecoveryActive = false
						v_u_40()
						v_u_36(false)
						v_u_16.ThrowableSnapshot = nil
					end
				end
			end
		end
		local function v188() -- name: Reload
			-- upvalues: (copy) v_u_16, (copy) v_u_4, (ref) v_u_54, (copy) v_u_6
			local v180
			if v_u_16 == nil or v_u_16.IsWeaponReady == nil then
				v180 = false
			else
				v180 = v_u_16:IsWeaponReady() == true
			end
			if v180 == true then
				if v_u_16.CurrentTool then
					if v_u_16.CurrentTool.Animations then
						if v_u_16.CurrentTool.Animations.Client.Reload ~= nil and v_u_16.CurrentTool.Tool:GetAttribute("StoredAmmo") > 0 then
							local v181 = v_u_16.CurrentTool.Tool:GetAttribute("Ammo")
							if math.floor(v181) < v_u_16.CurrentTool.Settings.Ammo and (v_u_16.CurrentTool.Reloading ~= true and (v_u_16.QuickAction == false and (v_u_16.CurrentTool.Bolting ~= true and v_u_16.CurrentTool.Pumping ~= true))) then
								v_u_54()
								if v_u_16.CurrentTool.Settings.ReloadType == 1 then
									if v_u_6.Movement.GetMovement() == "Running" then
										v_u_6.Movement.SetMovement("Walking")
									end
									v_u_16:Reload()
									return
								end
								if v_u_16.CurrentTool.Settings.ReloadType == 2 then
									local v182 = v_u_16.CurrentTool.Settings.Ammo
									local v183 = v_u_16.CurrentTool.Tool:GetAttribute("Ammo")
									local v184 = v182 - math.floor(v183)
									local v185 = v_u_16.CurrentTool.Tool:GetAttribute("StoredAmmo")
									local v186 = math.floor(v185)
									for _ = 1, math.clamp(v184, 0, v186) do
										if v_u_16.CurrentTool.Tool:GetAttribute("StoredAmmo") and v_u_16.CurrentTool.Tool:GetAttribute("StoredAmmo") > 0 then
											local v187 = v_u_16.CurrentTool.Tool:GetAttribute("Ammo")
											if math.floor(v187) < v_u_16.CurrentTool.Settings.Ammo and (v_u_16.CurrentTool.Reloading ~= true and (v_u_16.QuickAction == false and (v_u_16.CurrentTool.Bolting ~= true and v_u_16.CurrentTool.Pumping ~= true))) then
												v_u_16:Reload()
											end
										end
										if v_u_16.CurrentTool.ReloadCancel == true then
											break
										end
									end
								end
							end
						end
					else
						warn(v_u_4.Utility.formatWarnInstanceIsNil("WeaponDataNew.CurrentTool (type: table)", "Animations", "Failed to reload because Animations is nil"))
					end
				else
					warn(v_u_4.Utility.formatWarnInstanceIsNil("WeaponDataNew (type: table)", "CurrentTool", "Failed to reload because CurrentTool is nil"))
					return
				end
			else
				return
			end
		end
		v_u_53 = function()
			-- upvalues: (copy) v_u_17, (copy) v_u_16, (copy) v_u_4, (copy) v_u_12, (copy) v_u_61, (copy) v_u_13, (copy) v_u_7, (copy) v_u_6, (copy) v_u_14, (ref) v_u_57, (copy) v_u_2, (copy) v_u_21
			if (v_u_17.ADSUnlockAt or 0) > os.clock() == true then
				v_u_17.BufferedADSIntent = true
				v_u_17.BufferedADSSwapGeneration = v_u_17.SwapGeneration or 0
				local v189 = v_u_17
				local v190 = v_u_16.CurrentTool
				v189.BufferedADSToolSerial = not (v190 and v190.Tool) and "" or v_u_4.WeaponSlotResolver.GetOrAssignToolSerial(v190.Tool)
				v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
				v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
				v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
				v_u_61()
				return
			end
			local v191
			if v_u_16 == nil or v_u_16.IsWeaponPresentationReady == nil then
				v191 = false
			else
				v191 = v_u_16:IsWeaponPresentationReady() == true
			end
			if v191 ~= true then
				v_u_17.BufferedADSIntent = true
				v_u_17.BufferedADSSwapGeneration = v_u_17.SwapGeneration or 0
				local v192 = v_u_17
				local v193 = v_u_16.CurrentTool
				v192.BufferedADSToolSerial = not (v193 and v193.Tool) and "" or v_u_4.WeaponSlotResolver.GetOrAssignToolSerial(v193.Tool)
				v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
				v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
				v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
				return
			end
			local v194 = v_u_16.CurrentTool
			if not v194 or (not v194.Tool or v194.Tool:GetAttribute("Class") ~= "Primary" and v194.Tool:GetAttribute("Class") ~= "Secondary") or (v_u_13:GetAttribute("Phase") ~= "Round Started" and (v_u_13:GetAttribute("Phase") ~= "Preparation" and v_u_13:GetAttribute("Phase") ~= "Round Ended") or (v194.Bolting == true or v_u_7.ServerData:GetAttribute("Alive") ~= true)) then
				::l28::
				return
			end
			if (v_u_17.SwapGeneration or 0) > 0 then
				if v_u_12:GetAttribute("SwapInProgress") ~= true then
					local v195
					if v_u_16 == nil or v_u_16.IsWeaponReady == nil then
						v195 = false
					else
						v195 = v_u_16:IsWeaponReady() == true
					end
					if v195 == true then
						goto l38
					end
				end
				v_u_17.BufferedADSIntent = true
				v_u_17.BufferedADSSwapGeneration = v_u_17.SwapGeneration or 0
				local v196 = v_u_17
				local v197 = v_u_16.CurrentTool
				v196.BufferedADSToolSerial = not (v197 and v197.Tool) and "" or v_u_4.WeaponSlotResolver.GetOrAssignToolSerial(v197.Tool)
				v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
				v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
				v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
				goto l38
			else
				::l38::
				v_u_16:ADS()
				v_u_16.Animations.Client.Run:Play()
				v_u_16.Animations.Client.Run:Stop(0.02)
				v_u_16:SoundCue("Run", false)
				if v_u_6.Movement.GetMovement() == "Running" then
					v_u_6.Movement.SetMovement("Walking")
				end
				v_u_6.Movement.UpdateWalkSpeedClient(v_u_6.Movement.GetMovement())
				v_u_14.ChangeMovement:FireServer(v_u_6.Movement.GetMovement())
				if v194.Tool:GetAttribute("ADSType") == "Scope" then
					local v198 = {
						["CurrentState"] = "ADS",
						["Aiming"] = true,
						["ScopeVisible"] = true,
						["CrosshairVisible"] = false,
						["TargetFOV"] = 25,
						["FOVDuration"] = 0.2
					}
					if v_u_16 and v_u_16.SendPresentationEvent then
						v_u_16:SendPresentationEvent("ADSBegin", v198)
					end
					v_u_57(v194, 0.2)
					v_u_4.Config.AddSound("Scope_In", nil, false, v_u_2.SoundService, false)
				else
					local v199 = {
						["CurrentState"] = "ADS",
						["Aiming"] = true,
						["ScopeVisible"] = false,
						["CrosshairVisible"] = false,
						["TargetFOV"] = nil,
						["FOVDuration"] = 0.2,
						["TargetFOV"] = v_u_21:GetAttribute("FieldOfView") - 5 * v194.Settings.ADSZoom
					}
					if v_u_16 and v_u_16.SendPresentationEvent then
						v_u_16:SendPresentationEvent("ADSBegin", v199)
					end
					v_u_57(v194, 0.2)
				end
				local v200
				if v_u_16 == nil or v_u_16.IsWeaponReady == nil then
					v200 = false
				else
					v200 = v_u_16:IsWeaponReady() == true
				end
				if v200 == true then
					v_u_17.BufferedADSIntent = false
					v_u_17.BufferedADSSwapGeneration = 0
					v_u_17.BufferedADSToolSerial = ""
					v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
					v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
					v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
				end
				goto l28
			end
		end
		v_u_54 = function()
			-- upvalues: (copy) v_u_17, (copy) v_u_12, (copy) v_u_16, (copy) v_u_13, (copy) v_u_7, (copy) v_u_6, (copy) v_u_14, (copy) v_u_21, (copy) v_u_65, (copy) v_u_4, (copy) v_u_2
			v_u_17.BufferedADSIntent = false
			v_u_17.BufferedADSSwapGeneration = 0
			v_u_17.BufferedADSToolSerial = ""
			v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
			v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
			v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
			local v201 = v_u_16.CurrentTool
			if v201 and (v201.Tool and (v201.Tool:GetAttribute("Class") == "Primary" or v201.Tool:GetAttribute("Class") == "Secondary")) and ((v_u_13:GetAttribute("Phase") == "Round Started" or (v_u_13:GetAttribute("Phase") == "Preparation" or v_u_13:GetAttribute("Phase") == "Round Ended")) and (v201.Aiming == true and (v201.Bolting ~= true and v_u_7.ServerData:GetAttribute("Alive") == true))) then
				v_u_16:ReleaseADS()
				v_u_6.Movement.UpdateWalkSpeedClient(v_u_6.Movement.GetMovement())
				v_u_14.ChangeMovement:FireServer(v_u_6.Movement.GetMovement())
				local v202 = {
					["CurrentState"] = "Hold",
					["Aiming"] = false,
					["ScopeVisible"] = false,
					["CrosshairVisible"] = nil,
					["TargetFOV"] = nil,
					["FOVDuration"] = 0.2,
					["CrosshairVisible"] = v_u_16.Crosshair and v_u_16.Crosshair.Enabled == true and true or false,
					["TargetFOV"] = v_u_21:GetAttribute("FieldOfView")
				}
				if v_u_16 and v_u_16.SendPresentationEvent then
					v_u_16:SendPresentationEvent("ADSEnd", v202)
				end
				v_u_65(0.2)
				if v201.Tool:GetAttribute("ADSType") == "Scope" then
					v_u_4.Config.AddSound("Scope_Out", nil, false, v_u_2.SoundService, false)
				end
			end
		end
		v_u_55 = function(p203)
			-- upvalues: (copy) v_u_7, (copy) v_u_16, (copy) v_u_17, (copy) v_u_12, (ref) v_u_54, (copy) v_u_65, (copy) v_u_23, (copy) v_u_24
			if v_u_7.ServerData:GetAttribute("Alive") == true and (v_u_16.CurrentToolIndex ~= p203 and (v_u_16.QuickAction == false and (v_u_16.Holster == true and v_u_16.CurrentTool))) then
				v_u_17.SwapGeneration = (v_u_17.SwapGeneration or 0) + 1
				v_u_12:SetAttribute("SwapGeneration", v_u_17.SwapGeneration)
				v_u_17.BufferedADSToolSerial = ""
				v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
				v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
				v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
				v_u_17.ADSUnlockAt = os.clock() + 0.01
				v_u_54()
				v_u_17.BufferedADSIntent = false
				v_u_17.BufferedADSSwapGeneration = 0
				v_u_17.BufferedADSToolSerial = ""
				v_u_12:SetAttribute("BufferedADSIntent", v_u_17.BufferedADSIntent == true)
				v_u_12:SetAttribute("BufferedADSSwapGeneration", v_u_17.BufferedADSSwapGeneration or 0)
				v_u_12:SetAttribute("BufferedADSToolSerial", v_u_17.BufferedADSToolSerial or "")
				local v204 = ({
					"Primary",
					"Secondary",
					"Knife",
					"Throwable"
				})[p203]
				if not v204 then
					return
				end
				if not v_u_16.Tools[v204] then
					return
				end
				if v204 == "Throwable" then
					local v205 = v_u_16.Tools[v204]
					local v206
					if v205 and v205.Tool and v205.Tool:GetAttribute("Class") == "Throwable" then
						local v207 = v205.Tool
						v206 = (tonumber(v207:GetAttribute("Amount")) or 0) > 0
					else
						v206 = false
					end
					if v206 ~= true then
						return
					end
				end
				if v_u_16.SetReadinessState then
					v_u_16:SetReadinessState(true, false, false)
				end
				v_u_17.SwapFinalizing = true
				if v_u_16:SwapTools(p203) ~= true then
					v_u_17.SwapFinalizing = false
					if v_u_16.SetReadinessState then
						local v208 = v_u_16.CurrentTool ~= nil
						v_u_16:SetReadinessState(false, v208, v208)
					end
					return
				end
				v_u_65(0.05)
				v_u_17.SwapFinalizing = false
				if p203 ~= 4 then
					v_u_17.LastNonThrowableWeaponIndex = p203
				end
				v_u_23(v_u_16.CurrentTool.Tool.Name)
				v_u_24({
					["CrosshairVisible"] = v_u_16.Crosshair and v_u_16.Crosshair.Enabled == true and true or false
				})
			end
		end
		return {
			["CastBulletRay"] = v_u_144,
			["ShootEffect"] = function(p209, p210) -- name: ShootEffect
				-- upvalues: (copy) v_u_7, (copy) v_u_4
				if p209:IsA("Model") then
					local v211 = p209:FindFirstChild(p209:GetAttribute(p209:GetAttribute("CurrentWeapon")))
					if v211 then
						v_u_4.Components.Weapon.MuzzleShootEffect(v211)
					end
				elseif p209 ~= v_u_7 then
					local v212 = p209.Character
					local v213
					if v212 then
						local v214 = v_u_4.WeaponSlotResolver.GetStateFolder(v212)
						if v214 then
							v214 = v214:GetAttribute("EquippedToolName")
						end
						if typeof(v214) == "string" and v214 ~= "" then
							v213 = v_u_4.WeaponSlotResolver.ResolveVisibleModel(v212, v214)
						else
							v213 = nil
						end
					else
						v213 = nil
					end
					if v213 ~= nil then
						v_u_4.Components.Weapon.MuzzleShootEffect(v213)
					end
					local v215 = p209.Character:FindFirstChild("AnimBase")
					if v215 and v215:FindFirstChild("Shoulder") then
						v215.Shoulder.C1 = CFrame.new(0, 0, 0.15)
						task.wait(p210 / 2)
						if v215:FindFirstChild("Shoulder") then
							v215.Shoulder.C1 = CFrame.new()
							return
						end
					end
				end
			end,
			["Recoil"] = v_u_148,
			["Shoot"] = v168,
			["Ping"] = function() -- name: Ping
				-- upvalues: (copy) v_u_19, (copy) v_u_4, (copy) v_u_11, (copy) v_u_15, (copy) v_u_14
				if v_u_19.CanPing == true then
					v_u_19.CanPing = false
					local v216 = v_u_4.Config.RayCast(v_u_11.CFrame.Position, v_u_11.CFrame.LookVector, v_u_19.MaxDistance, v_u_15.Ray_Ignore)
					local v217
					if v216 then
						v217 = v216.Instance or nil
					else
						v217 = nil
					end
					local v218
					if v216 then
						v218 = v216.Position or nil
					else
						v218 = nil
					end
					local v219 = v216 and v216.Normal or nil
					if v217 ~= nil then
						v_u_14.PingLocation:FireServer(v218, v217.Name, v219)
					end
					task.wait(v_u_19.Cooldown)
					v_u_19.CanPing = true
				end
			end,
			["IsInspectBlockingSprint"] = function() -- name: IsInspectBlockingSprint
				-- upvalues: (copy) v_u_16
				local v220 = v_u_16.CurrentTool
				if not v220 then
					return false
				end
				local v221 = v220.Animations
				if v221 then
					v221 = v220.Animations.Client
				end
				if v221 then
					v221 = v221.Inspect
				end
				local v222
				if v221 == nil then
					v222 = false
				else
					v222 = v221.IsPlaying == true
				end
				return v222
			end,
			["TryCancelInspectForSprint"] = function() -- name: TryCancelInspectForSprint
				-- upvalues: (copy) v_u_16
				if v_u_16 and v_u_16.CancelInspect then
					return v_u_16:CancelInspect()
				end
				local v223 = v_u_16.CurrentTool
				if not v223 then
					return false
				end
				local v224 = v223.Animations
				if v224 then
					v224 = v223.Animations.Client
				end
				if v224 then
					v224 = v224.Inspect
				end
				if not v224 or v224.IsPlaying ~= true then
					return false
				end
				v224:Stop()
				return true
			end,
			["IsSprintBlockedByHardAction"] = v_u_151,
			["IsSprintBlockedByCurrentAction"] = function() -- name: IsSprintBlockedByCurrentAction
				-- upvalues: (copy) v_u_151, (copy) v_u_16
				local v225
				if v_u_151() == true then
					v225 = true
				else
					local v226 = v_u_16.CurrentTool
					local v227
					if v226 then
						local v228 = v226.Animations
						if v228 then
							v228 = v226.Animations.Client
						end
						if v228 then
							v228 = v228.Inspect
						end
						if v228 == nil then
							v227 = false
						else
							v227 = v228.IsPlaying == true
						end
					else
						v227 = false
					end
					v225 = v227 == true
				end
				return v225
			end,
			["Knife"] = v_u_152,
			["QuickKnife"] = v154,
			["StartQuickThrowHold"] = v_u_175,
			["ReleaseQuickThrowHold"] = v178,
			["TacticalThrow"] = v_u_56,
			["QuickThrow"] = function() -- name: QuickThrow
				-- upvalues: (copy) v_u_175
				v_u_175()
			end,
			["Reload"] = v188,
			["AimDownSight"] = v_u_53,
			["AimDownSightRelease"] = v_u_54,
			["SwapWeapon"] = v_u_55,
			["ApplyConfirmedWeaponSlot"] = function(p229) -- name: ApplyConfirmedWeaponSlot
				-- upvalues: (copy) v_u_4, (copy) v_u_16, (copy) v_u_23
				if typeof(p229) == "table" then
					local v230 = p229.Slot
					if typeof(v230) == "string" then
						local v231 = v_u_4.WeaponSlotResolver.GetIndexFromClass(v230)
						if v231 then
							local v232 = v_u_16.Tools
							if v232 then
								v232 = v_u_16.Tools[v230]
							end
							if v232 and (v232.Tool and v232.Model) then
								local v233 = p229.ToolName
								if typeof(v233) ~= "string" or (p229.ToolName == "" or v232.Tool.Name == p229.ToolName) then
									local v234 = v_u_16.CurrentTool and v_u_16.CurrentTool.Tool
									if v234 then
										v234 = v_u_4.WeaponSlotResolver.GetToolSerial(v_u_16.CurrentTool.Tool)
									end
									local v235 = v_u_4.WeaponSlotResolver.GetOrAssignToolSerial(v232.Tool)
									local v236 = p229.ToolSerial
									if typeof(v236) == "string" and p229.ToolSerial ~= "" then
										v235 = p229.ToolSerial
									end
									if v_u_16.CurrentToolIndex == v231 and v234 == v235 then
										if v_u_16.EnsureCurrentToolPresentation then
											v_u_16:EnsureCurrentToolPresentation()
										end
									else
										v_u_16:SwapTools(v231, true)
									end
									if v232.Tool then
										v_u_23(v232.Tool.Name)
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
				else
					return
				end
			end,
			["SetThrowablePreviewBridgeState"] = v_u_36,
			["SyncThrowablePreviewState"] = v_u_40,
			["IsThrowableAvailable"] = function(p237) -- name: IsThrowableAvailable
				if not (p237 and p237.Tool) then
					return false
				end
				if p237.Tool:GetAttribute("Class") ~= "Throwable" then
					return false
				end
				local v238 = p237.Tool
				return (tonumber(v238:GetAttribute("Amount")) or 0) > 0
			end,
			["resolveEquippedCharacterWeaponModel"] = v29
		}
	end
}