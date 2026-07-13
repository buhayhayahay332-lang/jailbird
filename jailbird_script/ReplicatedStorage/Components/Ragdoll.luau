-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Config)
local Map_Cache = workspace:WaitForChild("Map_Cache")
local v1 = setmetatable({}, {
	__mode = "k"
})
local v2 = setmetatable({}, {
	__mode = "k"
})
local v3 = setmetatable({}, {
	__mode = "k"
})
local v4 = setmetatable({}, {
	__mode = "k"
})
local t = {}
local t2 = {
	{
		name = "HeadConstraint",
		parentPart = "Head",
		attachment0Part = "Head",
		attachment0Name = "HeadA",
		attachment1Part = "Torso",
		attachment1Name = "TorsoA4"
	},
	{
		name = "LeftArmConstraint",
		parentPart = "Left Arm",
		attachment0Part = "Left Arm",
		attachment0Name = "LeftArmA",
		attachment1Part = "Torso",
		attachment1Name = "TorsoA2"
	},
	{
		name = "RightArmConstraint",
		parentPart = "Right Arm",
		attachment0Part = "Right Arm",
		attachment0Name = "RightArmA",
		attachment1Part = "Torso",
		attachment1Name = "TorsoA3"
	},
	{
		name = "LeftLegConstraint",
		parentPart = "Torso",
		attachment0Part = "Torso",
		attachment0Name = "TorsoA1",
		attachment1Part = "Left Leg",
		attachment1Name = "LeftLegA"
	},
	{
		name = "RightLegConstraint",
		parentPart = "Torso",
		attachment0Part = "Torso",
		attachment0Name = "TorsoA",
		attachment1Part = "Right Leg",
		attachment1Name = "RightLegA"
	}
}

local function normalizeCosmeticPart(p1) --[[ normalizeCosmeticPart | Line: 65 ]]
	p1.CanCollide = false
	p1.CanTouch = false
	p1.CanQuery = false
	p1.AudioCanCollide = false
	p1.CastShadow = false
	p1.Massless = true
end

local function getR6RigParts(p1) --[[ getR6RigParts | Line: 74 ]]
	local Head = p1:FindFirstChild("Head")
	local Torso = p1:FindFirstChild("Torso")
	local v1 = p1:FindFirstChild("Left Arm")
	local v2 = p1:FindFirstChild("Right Arm")
	local v3 = p1:FindFirstChild("Left Leg")
	local v4 = p1:FindFirstChild("Right Leg")
	local Humanoid = p1:FindFirstChildOfClass("Humanoid")

	if Head and (Torso and (v1 and (v2 and (v3 and (v4 and Humanoid))))) then
		return {
			head = Head,
			torso = Torso,
			leftArm = v1,
			rightArm = v2,
			leftLeg = v3,
			rightLeg = v4,
			humanoid = Humanoid,
			humanoidRootPart = p1:FindFirstChild("HumanoidRootPart"),
			parts = { Torso, Head, v1, v2, v3, v4 }
		}
	end

	return nil
end

local function getPreparedRig(p1) --[[ getPreparedRig | Line: 100 | Upvalues: v2 (copy), getR6RigParts (copy) ]]
	local v1 = v2[p1]

	if v1 and (v1.torso and (v1.torso.Parent == p1 and (v1.humanoid and v1.humanoid.Parent == p1))) then
		v1.humanoidRootPart = p1:FindFirstChild("HumanoidRootPart")

		return v1
	end

	local v22 = getR6RigParts(p1)

	if v22 then
		v2[p1] = v22
	end

	return v22
end

local function cacheCosmetics(p1) --[[ cacheCosmetics | Line: 115 | Upvalues: v3 (copy) ]]
	local t = {}

	for i, v in ipairs(p1:GetChildren()) do
		if v:IsA("Accessory") or (if v.Name == "Hat" then true elseif v.Name == "Hair" then true else false) then
			local Handle = v:FindFirstChild("Handle")

			if Handle and Handle:IsA("BasePart") then
				table.insert(t, {
					handle = Handle,
					accessory = v
				})
			end
		end
	end

	v3[p1] = t
end

local function preserveCosmetics(p1, p2) --[[ preserveCosmetics | Line: 136 | Upvalues: v3 (copy) ]]
	local v1 = ipairs

	for v32, v4 in v1(v3[p1] or {}) do
		local accessory = v4.accessory
		local handle = v4.handle

		if accessory and (accessory.Parent and (handle and handle.Parent)) then
			handle.CanCollide = false
			handle.CanTouch = false
			handle.CanQuery = false
			handle.AudioCanCollide = false
			handle.CastShadow = false
			handle.Massless = true

			local v5 = CFrame.new()

			pcall(function() --[[ Line: 147 | Upvalues: v5 (ref), accessory (copy) ]]
				v5 = accessory.AttachmentPoint
			end)

			local AccessoryWeld = handle:FindFirstChild("AccessoryWeld")

			if not AccessoryWeld then
				local AccessoryWeld2 = Instance.new("Weld")

				AccessoryWeld2.Name = "AccessoryWeld"
				AccessoryWeld2.Parent = p2
				AccessoryWeld = AccessoryWeld2
			end

			AccessoryWeld.Part0 = handle
			AccessoryWeld.Part1 = p2
			AccessoryWeld.C0 = v5
			AccessoryWeld.C1 = CFrame.new(0, 0.5, 0)
			AccessoryWeld.Enabled = true
		end
	end
end

local function ensureAttachment(p1, p2, p3, p4, p5, p6) --[[ ensureAttachment | Line: 166 ]]
	local v1 = p1:FindFirstChild(p2)

	if not (v1 and v1:IsA("Attachment")) then
		local Attachment = Instance.new("Attachment")

		Attachment.Name = p2
		Attachment.Parent = p1
		v1 = Attachment
	end

	v1.Position = p3
	v1.Rotation = p4
	v1.Axis = p5
	v1.SecondaryAxis = p6

	return v1
end

local function ensureConstraint(p1, p2, p3, p4) --[[ ensureConstraint | Line: 182 ]]
	local v1 = p1:FindFirstChild(p2)

	if not (v1 and v1:IsA("BallSocketConstraint")) then
		local BallSocketConstraint = Instance.new("BallSocketConstraint")

		BallSocketConstraint.Name = p2
		BallSocketConstraint.Parent = p1
		v1 = BallSocketConstraint
	end

	v1.Attachment0 = p3
	v1.Attachment1 = p4
	v1.Enabled = false
	v1.LimitsEnabled = true
	v1.Restitution = 0

	if p2 == "HeadConstraint" then
		v1.UpperAngle = 35
		v1.TwistLimitsEnabled = true
		v1.TwistLowerAngle = -20
		v1.TwistUpperAngle = 20

		return v1
	end

	if p2 == "LeftArmConstraint" or p2 == "RightArmConstraint" then
		v1.UpperAngle = 55
		v1.TwistLimitsEnabled = true
		v1.TwistLowerAngle = -35
		v1.TwistUpperAngle = 35

		return v1
	end

	if p2 == "LeftLegConstraint" or p2 == "RightLegConstraint" then
		v1.UpperAngle = 30
		v1.TwistLimitsEnabled = true
		v1.TwistLowerAngle = -15
		v1.TwistUpperAngle = 15
	end

	return v1
end

local function getRagdollConstraints(p1) --[[ getRagdollConstraints | Line: 216 | Upvalues: t2 (copy) ]]
	local t = {}

	for i, v in ipairs(t2) do
		local v1 = p1:FindFirstChild(v.parentPart)

		if v1 then
			local v2 = v1:FindFirstChild(v.name)

			if v2 and v2:IsA("BallSocketConstraint") then
				table.insert(t, v2)
			end
		end
	end

	return t
end

local function setNetworkOwnerToServer(p1) --[[ setNetworkOwnerToServer | Line: 232 ]]
	if not p1.Anchored then
		pcall(function() --[[ Line: 237 | Upvalues: p1 (copy) ]]
			p1:SetNetworkOwner(nil)
		end)
	end
end

local function setNetworkOwnerToPlayer(p1, p2) --[[ setNetworkOwnerToPlayer | Line: 242 | Upvalues: Players (copy) ]]
	if not p1.Anchored and (p2 and p2.Parent == Players) then
		pcall(function() --[[ Line: 247 | Upvalues: p1 (copy), p2 (copy) ]]
			p1:SetNetworkOwner(p2)
		end)
	end
end

local function getCarryVelocity(p1) --[[ getCarryVelocity | Line: 252 ]]
	if p1.humanoidRootPart and p1.humanoidRootPart.Parent then
		return p1.humanoidRootPart.AssemblyLinearVelocity
	end

	return p1.torso.AssemblyLinearVelocity
end

local function getRagdollNumber(p1, p2) --[[ getRagdollNumber | Line: 260 | Upvalues: Config (copy) ]]
	local v1 = Config[p1]

	if typeof(v1) == "number" then
		return v1
	end

	return p2
end

local function getRagdollBoolean(p1, p2) --[[ getRagdollBoolean | Line: 269 | Upvalues: Config (copy) ]]
	local v1 = Config[p1]

	if typeof(v1) == "boolean" then
		return v1
	end

	return p2
end

local function getRagdollString(p1, p2) --[[ getRagdollString | Line: 278 | Upvalues: Config (copy) ]]
	local v1 = Config[p1]

	if typeof(v1) == "string" and v1 ~= "" then
		return v1
	end

	return p2
end

local function clampCarryVelocity(p1) --[[ clampCarryVelocity | Line: 287 ]]
	local v1 = p1 * Vector3.new(1, 0, 1)

	if v1.Magnitude > 52 then
		v1 = v1.Unit * 52
	end

	return v1
end

local function getKnockbackPart(p1, p2) --[[ getKnockbackPart | Line: 297 ]]
	if p2 == "Head" then
		return p1.head
	end

	if p2 == "Left Arm" then
		return p1.leftArm
	end

	if p2 == "Right Arm" then
		return p1.rightArm
	end

	if p2 == "Left Leg" then
		return p1.leftLeg
	end

	if p2 == "Right Leg" then
		return p1.rightLeg
	end

	return p1.torso
end

local function getMotionProfile(p1) --[[ getMotionProfile | Line: 313 ]]
	local v1 = if p1 then p1.motionProfile else p1

	if v1 then
		return v1
	end

	local v2 = if p1 then p1.impulseProfile else p1

	if v2 == "explosion" then
		return "explosion"
	end

	if v2 == "lingering_area" then
		return "lingering_area"
	end

	if p1 and p1.hitPartName == "Head" then
		return "projectile_head"
	end

	return "projectile_body"
end

local function resolvePushDirection(p1, p2) --[[ resolvePushDirection | Line: 333 ]]
	local v1 = if p2 then p2.motionProfile else p2
	local v2

	if v1 then
		v2 = v1
	else
		local v3 = if p2 then p2.impulseProfile else p2

		v2 = if v3 == "explosion" then "explosion" elseif v3 == "lingering_area" then "lingering_area" elseif p2 and p2.hitPartName == "Head" then "projectile_head" else "projectile_body"
	end

	local v4 = v2 == "projectile_head" and p1.head or p1.torso
	local v5 = if p2 then p2.pushDirection else p2

	if v2 == "explosion" and typeof(if p2 then p2.sourcePosition else p2) == "Vector3" then
		local v7 = v4.Position - p2.sourcePosition

		if v7.Magnitude > 0 then
			return v7.Unit
		end

		return nil
	end

	if typeof(v5) == "Vector3" and v5.Magnitude > 0 then
		return v5.Unit
	end

	return nil
end

local function applyDeathImpulse(p1, p2, p3) --[[ applyDeathImpulse | Line: 350 | Upvalues: resolvePushDirection (copy), Config (copy) ]]
	local v1 = (p2 or Vector3.new(0, 0, 0)) * Vector3.new(1, 0, 1)

	if v1.Magnitude > 52 then
		v1 = v1.Unit * 52
	end

	local v2 = v1

	for i, v in ipairs(p1.parts) do
		if v and v.Parent then
			v.AssemblyLinearVelocity = v2
		end
	end

	local v3 = if p3 then p3.motionProfile else p3
	local v4

	if v3 then
		v4 = v3
	else
		local v5 = if p3 then p3.impulseProfile else p3

		v4 = if v5 == "explosion" then "explosion" elseif v5 == "lingering_area" then "lingering_area" elseif p3 and p3.hitPartName == "Head" then "projectile_head" else "projectile_body"
	end

	local v6 = resolvePushDirection(p1, p3)

	if not v6 then
		return
	end

	if v4 == "projectile_head" then
		local AllowWeaponKnockback = Config.AllowWeaponKnockback

		if (if typeof(AllowWeaponKnockback) == "boolean" then AllowWeaponKnockback else false) ~= true then
			return
		end

		local head = p1.head
		local RagdollHeadKnockback = Config.RagdollHeadKnockback

		head.AssemblyLinearVelocity = head.AssemblyLinearVelocity + v6 * (if typeof(RagdollHeadKnockback) == "number" then RagdollHeadKnockback else 32)
	elseif v4 == "projectile_body" then
		local AllowWeaponKnockback = Config.AllowWeaponKnockback

		if (if typeof(AllowWeaponKnockback) == "boolean" then AllowWeaponKnockback else false) ~= true then
			return
		end

		local RagdollTorsoKnockback = Config.RagdollTorsoKnockback
		local v10 = if typeof(RagdollTorsoKnockback) == "number" then RagdollTorsoKnockback else 22
		local torso = p1.torso

		torso.AssemblyLinearVelocity = torso.AssemblyLinearVelocity + v6 * v10

		local v11 = v10 * 0.18

		for i, v in ipairs({
			p1.leftArm,
			p1.rightArm,
			p1.leftLeg,
			p1.rightLeg
		}) do
			if v and v.Parent then
				v.AssemblyLinearVelocity = v.AssemblyLinearVelocity + v6 * v11
			end
		end
	else
		if v4 ~= "explosion" then
			return
		end

		local AllowExplosionKnockback = Config.AllowExplosionKnockback

		if (if typeof(AllowExplosionKnockback) == "boolean" then AllowExplosionKnockback else true) ~= true then
			return
		end

		local RagdollExplosionKnockback = Config.RagdollExplosionKnockback
		local v14 = v6 * (if typeof(RagdollExplosionKnockback) == "number" then RagdollExplosionKnockback else 90)
		local RagdollExplosionKnockbackY = Config.RagdollExplosionKnockbackY
		local v17 = Vector3.new(0, if typeof(RagdollExplosionKnockbackY) == "number" then RagdollExplosionKnockbackY else 30, 0)
		local torso = p1.torso

		torso.AssemblyLinearVelocity = torso.AssemblyLinearVelocity + (v14 + v17)
	end
end

local function setCorpseCollisionGroup(p1) --[[ setCorpseCollisionGroup | Line: 391 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CollisionGroup = "DeadPlayers"
		end
	end
end

local function applyCorpseGravity(p1) --[[ applyCorpseGravity | Line: 399 | Upvalues: Config (copy) ]]
	local RagdollGravityScale = Config.RagdollGravityScale
	local v2 = math.clamp(if typeof(RagdollGravityScale) == "number" then RagdollGravityScale else 0.6, 0, 1)

	for i, v in ipairs(p1.parts) do
		local v3 = if v then v:FindFirstChild("RagdollGravityAssist") else v

		if v3 then
			v3:Destroy()
		end
	end

	if v2 >= 0.999 or not (p1.torso and p1.torso.Parent) then
		return
	end

	local sum = 0

	for i, v in ipairs(p1.parts) do
		if v and v.Parent then
			sum = sum + v:GetMass()
		end
	end

	if not (sum <= 0) then
		local RagdollGravityAssist = Instance.new("BodyForce")

		RagdollGravityAssist.Name = "RagdollGravityAssist"
		RagdollGravityAssist.Force = Vector3.new(0, workspace.Gravity * sum * (1 - v2), 0)
		RagdollGravityAssist.Parent = p1.torso
	end
end

local function getCorpseFadeTargets(p1) --[[ getCorpseFadeTargets | Line: 429 ]]
	local t = {}

	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			table.insert(t, {
				instance = v,
				transparency = v.Transparency
			})
		end
	end

	return t
end

local function getKillerPlayer(p1) --[[ getKillerPlayer | Line: 443 | Upvalues: Players (copy) ]]
	if p1 and (p1.isPlayerKill == true and (p1.killerPlayer and p1.killerPlayer.Parent == Players)) then
		return p1.killerPlayer
	end

	return nil
end

local function setCorpseOwnership(p1, p2) --[[ setCorpseOwnership | Line: 451 | Upvalues: Players (copy) ]]
	for i, v in ipairs(p1.parts) do
		if p2 then
			if not v.Anchored and p2 and p2.Parent == Players then
				pcall(function() --[[ Line: 247 | Upvalues: v (copy), p2 (copy) ]]
					v:SetNetworkOwner(p2)
				end)
			end

			continue
		end

		if not v.Anchored then
			pcall(function() --[[ Line: 237 | Upvalues: v (copy) ]]
				v:SetNetworkOwner(nil)
			end)
		end
	end
end

local function releaseCorpseOwnership(p1) --[[ releaseCorpseOwnership | Line: 461 | Upvalues: v2 (copy), getR6RigParts (copy), v4 (copy) ]]
	local v1 = v2[p1]
	local v22

	if v1 and (v1.torso and (v1.torso.Parent == p1 and (v1.humanoid and v1.humanoid.Parent == p1))) then
		v1.humanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
		v22 = v1
	else
		local v3 = getR6RigParts(p1)

		if v3 then
			v2[p1] = v3
		end

		v22 = v3
	end

	if v22 then
		for i, v in ipairs(v22.parts) do
			if not v.Anchored then
				pcall(function() --[[ Line: 237 | Upvalues: v (copy) ]]
					v:SetNetworkOwner(nil)
				end)
			end
		end
	end

	v4[p1] = nil
end

local function startCorpseCleanup(p1) --[[ startCorpseCleanup | Line: 469 | Upvalues: Config (copy), getCorpseFadeTargets (copy), v2 (copy), getR6RigParts (copy), v4 (copy) ]]
	if p1:GetAttribute("RagdollCleanupStarted") == true then
		return
	end

	p1:SetAttribute("RagdollCleanupStarted", true)

	local RagdollCorpseLifetime = Config.RagdollCorpseLifetime
	local v22 = math.max(if typeof(RagdollCorpseLifetime) == "number" then RagdollCorpseLifetime else 5, 0)
	local RagdollFadeDuration = Config.RagdollFadeDuration
	local v42 = math.max(if typeof(RagdollFadeDuration) == "number" then RagdollFadeDuration else 0.75, 0.05)
	local v5 = getCorpseFadeTargets(p1)

	task.spawn(function() --[[ Line: 479 | Upvalues: v22 (copy), p1 (copy), v2 (ref), getR6RigParts (ref), v4 (ref), v42 (copy), v5 (copy) ]]
		task.wait(v22)

		if not p1.Parent then
			return
		end

		local v1 = p1
		local v23 = v2[v1]
		local v3

		if v23 and (v23.torso and (v23.torso.Parent == v1 and (v23.humanoid and v23.humanoid.Parent == v1))) then
			v23.humanoidRootPart = v1:FindFirstChild("HumanoidRootPart")
			v3 = v23
		else
			local v43 = getR6RigParts(v1)

			if v43 then
				v2[v1] = v43
			end

			v3 = v43
		end

		if v3 then
			for i, v in ipairs(v3.parts) do
				if not v.Anchored then
					pcall(function() --[[ Line: 237 | Upvalues: v (copy) ]]
						v:SetNetworkOwner(nil)
					end)
				end
			end
		end

		v4[v1] = nil

		local sum = 0

		while sum < v42 and p1.Parent do
			local v7 = math.clamp(sum / v42, 0, 1)

			for i, v in ipairs(v5) do
				local instance = v.instance

				if instance and instance.Parent then
					instance.Transparency = v.transparency + (1 - v.transparency) * v7
				end
			end

			sum = sum + task.wait()
		end

		if not p1.Parent then
			return
		end

		p1:Destroy()
	end)
end

local function isCorpseSettled(p1) --[[ isCorpseSettled | Line: 505 | Upvalues: Config (copy) ]]
	local RagdollSettleLinearThreshold = Config.RagdollSettleLinearThreshold
	local v2 = math.max(if typeof(RagdollSettleLinearThreshold) == "number" then RagdollSettleLinearThreshold else 1.5, 0)
	local RagdollSettleAngularThreshold = Config.RagdollSettleAngularThreshold
	local v4 = math.max(if typeof(RagdollSettleAngularThreshold) == "number" then RagdollSettleAngularThreshold else 3, 0)

	for i, v in ipairs(p1.parts) do
		if v and v.Parent then
			if v2 < v.AssemblyLinearVelocity.Magnitude then
				return false
			end

			if v4 < v.AssemblyAngularVelocity.Magnitude then
				return false
			end
		end
	end

	return true
end

local function startCorpseOwnership(p1, p2, p3) --[[ startCorpseOwnership | Line: 523 | Upvalues: Config (copy), v4 (copy), setCorpseOwnership (copy), Players (copy), v2 (copy), getR6RigParts (copy), isCorpseSettled (copy) ]]
	local RagdollOwnershipMode = Config.RagdollOwnershipMode
	local v1 = if typeof(RagdollOwnershipMode) == "string" and RagdollOwnershipMode ~= "" then RagdollOwnershipMode else "KillerLifetime"

	if v1 ~= "ServerOnly" and p3 then
		local t = {
			ownerPlayer = p3,
			mode = v1
		}

		v4[p1] = t
		setCorpseOwnership(p2, p3)
		task.spawn(function() --[[ Line: 538 | Upvalues: v4 (ref), p1 (copy), t (copy), Players (ref), v2 (ref), getR6RigParts (ref), isCorpseSettled (ref), Config (ref) ]]
			local sum = 0

			while v4[p1] == t and (p1.Parent and p1:GetAttribute("RagdollActivated") == true) do
				local v1

				if not (t.ownerPlayer and t.ownerPlayer.Parent == Players) then
					break
				end

				local v3 = task.wait(0.1)

				if t.mode == "AdaptiveSettle" then
					local v42 = p1
					local v5 = v2[v42]

					if v5 and (v5.torso and (v5.torso.Parent == v42 and (v5.humanoid and v5.humanoid.Parent == v42))) then
						v5.humanoidRootPart = v42:FindFirstChild("HumanoidRootPart")
						v1 = v5
					else
						local v6 = getR6RigParts(v42)

						if v6 then
							v2[v42] = v6
						end

						v1 = v6
					end

					if not v1 then
						break
					end

					if isCorpseSettled(v1) then
						sum = sum + v3

						local RagdollSettleTime = Config.RagdollSettleTime

						if math.max(if typeof(RagdollSettleTime) == "number" then RagdollSettleTime else 0.5, 0.1) <= sum then
							break
						end
					else
						sum = 0
					end
				end
			end

			if v4[p1] ~= t then
				return
			end

			local v9 = p1
			local v10 = v2[v9]
			local v11

			if v10 and (v10.torso and (v10.torso.Parent == v9 and (v10.humanoid and v10.humanoid.Parent == v9))) then
				v10.humanoidRootPart = v9:FindFirstChild("HumanoidRootPart")
				v11 = v10
			else
				local v12 = getR6RigParts(v9)

				if v12 then
					v2[v9] = v12
				end

				v11 = v12
			end

			if v11 then
				for i, v in ipairs(v11.parts) do
					if not v.Anchored then
						pcall(function() --[[ Line: 237 | Upvalues: v (copy) ]]
							v:SetNetworkOwner(nil)
						end)
					end
				end
			end

			v4[v9] = nil
		end)

		return
	end

	for i, v in ipairs(p2.parts) do
		if not v.Anchored then
			pcall(function() --[[ Line: 237 | Upvalues: v (copy) ]]
				v:SetNetworkOwner(nil)
			end)
		end
	end

	v4[p1] = nil
end

local function buildDeathContext(p1, p2) --[[ buildDeathContext | Line: 570 | Upvalues: v1 (copy) ]]
	local v12 = v1[p1] or {}
	local t = {}

	t.killerPlayer = p2 and p2.killerPlayer or v12.killerPlayer
	t.hitPartName = p2 and p2.hitPartName or (v12.hitPartName or "Torso")
	t.pushDirection = p2 and p2.pushDirection or v12.pushDirection
	t.sourcePosition = p2 and p2.sourcePosition or v12.sourcePosition
	t.impulseProfile = p2 and p2.impulseProfile or (v12.impulseProfile or "projectile")
	t.motionProfile = p2 and p2.motionProfile or v12.motionProfile

	local v8 = true

	if (if p2 then p2.isPlayerKill else p2) ~= true then
		v8 = if v12.isPlayerKill == true then true else false
	end

	t.isPlayerKill = v8
	t.carryVelocity = p2 and p2.carryVelocity or v12.carryVelocity
	v1[p1] = t

	return t
end

function t.StoreDeathContext(p1, p2) --[[ StoreDeathContext | Line: 586 | Upvalues: v1 (copy), buildDeathContext (copy) ]]
	if not p1 then
		return
	end

	if type(p2) == "table" then
		buildDeathContext(p1, p2)
	else
		v1[p1] = nil
	end
end
function t.ConsumeDeathContext(p1) --[[ ConsumeDeathContext | Line: 599 | Upvalues: v1 (copy) ]]
	if p1 then
		local v12 = v1[p1]

		v1[p1] = nil

		return v12
	end

	return nil
end
function t.Prepare(p1) --[[ Prepare | Line: 609 | Upvalues: v2 (copy), getR6RigParts (copy), cacheCosmetics (copy), v1 (copy) ]]
	if not p1 then
		return false
	end

	if p1:GetAttribute("RagdollPrepared") == true then
		return true
	end

	local v12 = v2[p1]
	local v22

	if v12 and (v12.torso and (v12.torso.Parent == p1 and (v12.humanoid and v12.humanoid.Parent == p1))) then
		v12.humanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
		v22 = v12
	else
		local v3 = getR6RigParts(p1)

		if v3 then
			v2[p1] = v3
		end

		v22 = v3
	end

	if not v22 then
		return false
	end

	v22.humanoid.BreakJointsOnDeath = false

	local t = {}
	local head = v22.head
	local HeadA = head:FindFirstChild("HeadA")

	if not (HeadA and HeadA:IsA("Attachment")) then
		local HeadA2 = Instance.new("Attachment")

		HeadA2.Name = "HeadA"
		HeadA2.Parent = head
		HeadA = HeadA2
	end

	HeadA.Position = Vector3.new(0, -0.5, 0)
	HeadA.Rotation = Vector3.new(0, 0, -90)
	HeadA.Axis = Vector3.new(0, -1, 0)
	HeadA.SecondaryAxis = Vector3.new(1, 0, 0)
	t.HeadA = HeadA

	local leftArm = v22.leftArm
	local LeftArmA = leftArm:FindFirstChild("LeftArmA")

	if not (LeftArmA and LeftArmA:IsA("Attachment")) then
		local LeftArmA2 = Instance.new("Attachment")

		LeftArmA2.Name = "LeftArmA"
		LeftArmA2.Parent = leftArm
		LeftArmA = LeftArmA2
	end

	LeftArmA.Position = Vector3.new(0.5, 0.6, 0)
	LeftArmA.Rotation = Vector3.new(0, 0, 0)
	LeftArmA.Axis = Vector3.new(1, 0, 0)
	LeftArmA.SecondaryAxis = Vector3.new(0, 1, 0)
	t.LeftArmA = LeftArmA

	local leftLeg = v22.leftLeg
	local LeftLegA = leftLeg:FindFirstChild("LeftLegA")

	if not (LeftLegA and LeftLegA:IsA("Attachment")) then
		local LeftLegA2 = Instance.new("Attachment")

		LeftLegA2.Name = "LeftLegA"
		LeftLegA2.Parent = leftLeg
		LeftLegA = LeftLegA2
	end

	LeftLegA.Position = Vector3.new(0.1, 1, 0)
	LeftLegA.Rotation = Vector3.new(0, 0, -90)
	LeftLegA.Axis = Vector3.new(0, -1, 0)
	LeftLegA.SecondaryAxis = Vector3.new(1, 0, 0)
	t.LeftLegA = LeftLegA

	local rightArm = v22.rightArm
	local RightArmA = rightArm:FindFirstChild("RightArmA")

	if not (RightArmA and RightArmA:IsA("Attachment")) then
		local RightArmA2 = Instance.new("Attachment")

		RightArmA2.Name = "RightArmA"
		RightArmA2.Parent = rightArm
		RightArmA = RightArmA2
	end

	RightArmA.Position = Vector3.new(-0.5, 0.6, 0)
	RightArmA.Rotation = Vector3.new(-180, 0, -180)
	RightArmA.Axis = Vector3.new(-1, 0, 0)
	RightArmA.SecondaryAxis = Vector3.new(0, 1, 0)
	t.RightArmA = RightArmA

	local rightLeg = v22.rightLeg
	local RightLegA = rightLeg:FindFirstChild("RightLegA")

	if not (RightLegA and RightLegA:IsA("Attachment")) then
		local RightLegA2 = Instance.new("Attachment")

		RightLegA2.Name = "RightLegA"
		RightLegA2.Parent = rightLeg
		RightLegA = RightLegA2
	end

	RightLegA.Position = Vector3.new(-0.1, 1, 0)
	RightLegA.Rotation = Vector3.new(0, 0, -90)
	RightLegA.Axis = Vector3.new(0, -1, 0)
	RightLegA.SecondaryAxis = Vector3.new(1, 0, 0)
	t.RightLegA = RightLegA

	local torso = v22.torso
	local TorsoA = torso:FindFirstChild("TorsoA")

	if not (TorsoA and TorsoA:IsA("Attachment")) then
		local TorsoA2 = Instance.new("Attachment")

		TorsoA2.Name = "TorsoA"
		TorsoA2.Parent = torso
		TorsoA = TorsoA2
	end

	TorsoA.Position = Vector3.new(0.4, -1, 0)
	TorsoA.Rotation = Vector3.new(0, 0, -90)
	TorsoA.Axis = Vector3.new(0, -1, 0)
	TorsoA.SecondaryAxis = Vector3.new(1, 0, 0)
	t.TorsoA = TorsoA

	local torso2 = v22.torso
	local TorsoA1 = torso2:FindFirstChild("TorsoA1")

	if not (TorsoA1 and TorsoA1:IsA("Attachment")) then
		local TorsoA12 = Instance.new("Attachment")

		TorsoA12.Name = "TorsoA1"
		TorsoA12.Parent = torso2
		TorsoA1 = TorsoA12
	end

	TorsoA1.Position = Vector3.new(-0.4, -1, 0)
	TorsoA1.Rotation = Vector3.new(0, 0, -90)
	TorsoA1.Axis = Vector3.new(0, -1, 0)
	TorsoA1.SecondaryAxis = Vector3.new(1, 0, 0)
	t.TorsoA1 = TorsoA1

	local torso3 = v22.torso
	local TorsoA2 = torso3:FindFirstChild("TorsoA2")

	if not (TorsoA2 and TorsoA2:IsA("Attachment")) then
		local TorsoA22 = Instance.new("Attachment")

		TorsoA22.Name = "TorsoA2"
		TorsoA22.Parent = torso3
		TorsoA2 = TorsoA22
	end

	TorsoA2.Position = Vector3.new(-1, 0.8, 0)
	TorsoA2.Rotation = Vector3.new(0, 0, 0)
	TorsoA2.Axis = Vector3.new(1, 0, 0)
	TorsoA2.SecondaryAxis = Vector3.new(0, 1, 0)
	t.TorsoA2 = TorsoA2

	local torso4 = v22.torso
	local TorsoA3 = torso4:FindFirstChild("TorsoA3")

	if not (TorsoA3 and TorsoA3:IsA("Attachment")) then
		local TorsoA32 = Instance.new("Attachment")

		TorsoA32.Name = "TorsoA3"
		TorsoA32.Parent = torso4
		TorsoA3 = TorsoA32
	end

	TorsoA3.Position = Vector3.new(1, 0.8, 0)
	TorsoA3.Rotation = Vector3.new(180, 0, 180)
	TorsoA3.Axis = Vector3.new(-1, 0, 0)
	TorsoA3.SecondaryAxis = Vector3.new(0, 1, 0)
	t.TorsoA3 = TorsoA3

	local torso5 = v22.torso
	local TorsoA4 = torso5:FindFirstChild("TorsoA4")

	if not (TorsoA4 and TorsoA4:IsA("Attachment")) then
		local TorsoA42 = Instance.new("Attachment")

		TorsoA42.Name = "TorsoA4"
		TorsoA42.Parent = torso5
		TorsoA4 = TorsoA42
	end

	TorsoA4.Position = Vector3.new(0, 1, 0)
	TorsoA4.Rotation = Vector3.new(0, 0, -90)
	TorsoA4.Axis = Vector3.new(0, -1, 0)
	TorsoA4.SecondaryAxis = Vector3.new(1, 0, 0)
	t.TorsoA4 = TorsoA4

	local head2 = v22.head
	local HeadConstraint = head2:FindFirstChild("HeadConstraint")

	if not (HeadConstraint and HeadConstraint:IsA("BallSocketConstraint")) then
		local HeadConstraint2 = Instance.new("BallSocketConstraint")

		HeadConstraint2.Name = "HeadConstraint"
		HeadConstraint2.Parent = head2
		HeadConstraint = HeadConstraint2
	end

	HeadConstraint.Attachment0 = t.HeadA
	HeadConstraint.Attachment1 = t.TorsoA4
	HeadConstraint.Enabled = false
	HeadConstraint.LimitsEnabled = true
	HeadConstraint.Restitution = 0
	HeadConstraint.UpperAngle = 35
	HeadConstraint.TwistLimitsEnabled = true
	HeadConstraint.TwistLowerAngle = -20
	HeadConstraint.TwistUpperAngle = 20

	local leftArm2 = v22.leftArm
	local LeftArmConstraint = leftArm2:FindFirstChild("LeftArmConstraint")

	if not (LeftArmConstraint and LeftArmConstraint:IsA("BallSocketConstraint")) then
		local LeftArmConstraint2 = Instance.new("BallSocketConstraint")

		LeftArmConstraint2.Name = "LeftArmConstraint"
		LeftArmConstraint2.Parent = leftArm2
		LeftArmConstraint = LeftArmConstraint2
	end

	LeftArmConstraint.Attachment0 = t.LeftArmA
	LeftArmConstraint.Attachment1 = t.TorsoA2
	LeftArmConstraint.Enabled = false
	LeftArmConstraint.LimitsEnabled = true
	LeftArmConstraint.Restitution = 0
	LeftArmConstraint.UpperAngle = 55
	LeftArmConstraint.TwistLimitsEnabled = true
	LeftArmConstraint.TwistLowerAngle = -35
	LeftArmConstraint.TwistUpperAngle = 35

	local rightArm2 = v22.rightArm
	local RightArmConstraint = rightArm2:FindFirstChild("RightArmConstraint")

	if not (RightArmConstraint and RightArmConstraint:IsA("BallSocketConstraint")) then
		local RightArmConstraint2 = Instance.new("BallSocketConstraint")

		RightArmConstraint2.Name = "RightArmConstraint"
		RightArmConstraint2.Parent = rightArm2
		RightArmConstraint = RightArmConstraint2
	end

	RightArmConstraint.Attachment0 = t.RightArmA
	RightArmConstraint.Attachment1 = t.TorsoA3
	RightArmConstraint.Enabled = false
	RightArmConstraint.LimitsEnabled = true
	RightArmConstraint.Restitution = 0
	RightArmConstraint.UpperAngle = 55
	RightArmConstraint.TwistLimitsEnabled = true
	RightArmConstraint.TwistLowerAngle = -35
	RightArmConstraint.TwistUpperAngle = 35

	local torso6 = v22.torso
	local LeftLegConstraint = torso6:FindFirstChild("LeftLegConstraint")

	if not (LeftLegConstraint and LeftLegConstraint:IsA("BallSocketConstraint")) then
		local LeftLegConstraint2 = Instance.new("BallSocketConstraint")

		LeftLegConstraint2.Name = "LeftLegConstraint"
		LeftLegConstraint2.Parent = torso6
		LeftLegConstraint = LeftLegConstraint2
	end

	LeftLegConstraint.Attachment0 = t.TorsoA1
	LeftLegConstraint.Attachment1 = t.LeftLegA
	LeftLegConstraint.Enabled = false
	LeftLegConstraint.LimitsEnabled = true
	LeftLegConstraint.Restitution = 0
	LeftLegConstraint.UpperAngle = 30
	LeftLegConstraint.TwistLimitsEnabled = true
	LeftLegConstraint.TwistLowerAngle = -15
	LeftLegConstraint.TwistUpperAngle = 15

	local torso7 = v22.torso
	local RightLegConstraint = torso7:FindFirstChild("RightLegConstraint")

	if not (RightLegConstraint and RightLegConstraint:IsA("BallSocketConstraint")) then
		local RightLegConstraint2 = Instance.new("BallSocketConstraint")

		RightLegConstraint2.Name = "RightLegConstraint"
		RightLegConstraint2.Parent = torso7
		RightLegConstraint = RightLegConstraint2
	end

	RightLegConstraint.Attachment0 = t.TorsoA
	RightLegConstraint.Attachment1 = t.RightLegA
	RightLegConstraint.Enabled = false
	RightLegConstraint.LimitsEnabled = true
	RightLegConstraint.Restitution = 0
	RightLegConstraint.UpperAngle = 30
	RightLegConstraint.TwistLimitsEnabled = true
	RightLegConstraint.TwistLowerAngle = -15
	RightLegConstraint.TwistUpperAngle = 15
	cacheCosmetics(p1)
	p1:SetAttribute("RagdollPrepared", true)
	p1:SetAttribute("RagdollTransitionStarted", false)
	p1:SetAttribute("RagdollActivated", false)
	p1:SetAttribute("RagdollCleanupStarted", false)
	v1[p1] = nil

	return true
end
function t.BeginLethalTransition(p1, p2) --[[ BeginLethalTransition | Line: 655 | Upvalues: t (copy), v2 (copy), getR6RigParts (copy), buildDeathContext (copy) ]]
	if not p1 then
		return false
	end

	if t.Prepare(p1) ~= true then
		return false
	end

	local v1 = v2[p1]
	local v22

	if v1 and (v1.torso and (v1.torso.Parent == p1 and (v1.humanoid and v1.humanoid.Parent == p1))) then
		v1.humanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
		v22 = v1
	else
		local v3 = getR6RigParts(p1)

		if v3 then
			v2[p1] = v3
		end

		v22 = v3
	end

	if not v22 then
		return false
	end

	local v5 = buildDeathContext(p1, p2)
	local carryVelocity = v5.carryVelocity

	if not carryVelocity then
		carryVelocity = if v22.humanoidRootPart and v22.humanoidRootPart.Parent then v22.humanoidRootPart.AssemblyLinearVelocity else v22.torso.AssemblyLinearVelocity
	end

	v5.carryVelocity = carryVelocity

	if p1:GetAttribute("RagdollTransitionStarted") == true then
		return false
	end

	p1:SetAttribute("RagdollTransitionStarted", true)
	v22.humanoid.AutoRotate = false
	v22.humanoid.PlatformStand = true
	pcall(function() --[[ Line: 680 | Upvalues: v22 (copy) ]]
		v22.humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	end)

	return true
end
function t.FinishActivation(p1, p2) --[[ FinishActivation | Line: 687 | Upvalues: t (copy), v2 (copy), getR6RigParts (copy), buildDeathContext (copy), v1 (copy), preserveCosmetics (copy), getRagdollConstraints (copy), Map_Cache (copy), setCorpseCollisionGroup (copy), applyCorpseGravity (copy), Players (copy), startCorpseOwnership (copy), applyDeathImpulse (copy), startCorpseCleanup (copy) ]]
	if not p1 then
		return false
	end

	if t.Prepare(p1) ~= true then
		return false
	end

	local v12 = v2[p1]
	local v22

	if v12 and (v12.torso and (v12.torso.Parent == p1 and (v12.humanoid and v12.humanoid.Parent == p1))) then
		v12.humanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
		v22 = v12
	else
		local v3 = getR6RigParts(p1)

		if v3 then
			v2[p1] = v3
		end

		v22 = v3
	end

	if not v22 then
		return false
	end

	local v5 = buildDeathContext(p1, p2)

	if p1:GetAttribute("RagdollTransitionStarted") ~= true then
		t.BeginLethalTransition(p1, v5)
		v5 = v1[p1] or v5

		local carryVelocity = v5.carryVelocity

		if not carryVelocity then
			carryVelocity = if v22.humanoidRootPart and v22.humanoidRootPart.Parent then v22.humanoidRootPart.AssemblyLinearVelocity else v22.torso.AssemblyLinearVelocity
		end

		v5.carryVelocity = carryVelocity
	end

	if p1:GetAttribute("RagdollActivated") == true then
		return false
	end

	p1:SetAttribute("RagdollActivated", true)
	preserveCosmetics(p1, v22.head)

	for i, v in ipairs((getRagdollConstraints(p1))) do
		v.Enabled = true
	end

	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("Motor6D") then
			v:Destroy()
		end
	end

	if v22.humanoidRootPart and v22.humanoidRootPart.Parent then
		v22.humanoidRootPart:Destroy()
		v22.humanoidRootPart = nil
	end

	p1.Parent = Map_Cache
	setCorpseCollisionGroup(p1)
	applyCorpseGravity(v22)
	startCorpseOwnership(p1, v22, if v5 and (v5.isPlayerKill == true and (v5.killerPlayer and v5.killerPlayer.Parent == Players)) then v5.killerPlayer else nil)
	applyDeathImpulse(v22, v5.carryVelocity or Vector3.new(0, 0, 0), v5)
	startCorpseCleanup(p1)
	v1[p1] = nil

	return true
end
function t.Activate(p1, p2) --[[ Activate | Line: 745 | Upvalues: t (copy) ]]
	if p1 then
		t.BeginLethalTransition(p1, p2)

		return t.FinishActivation(p1, p2)
	end

	return false
end

return setmetatable(t, {
	__call = function(p1, p2, p3) --[[ __call | Line: 755 | Upvalues: t (copy) ]]
		return t.Activate(p2, p3)
	end
})