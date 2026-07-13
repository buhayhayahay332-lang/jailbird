-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Config = require(ReplicatedStorage.Config)
local GameModes = require(ReplicatedStorage.Modules.GameModes)
local Server = ReplicatedStorage:WaitForChild("Server")

Server:WaitForChild("Tournament")

local Map = game.Workspace:WaitForChild("Map")
local t = {}
local t2 = {}
local t3 = {
	__index = function(p1, p2) --[[ __index | Line: 16 | Upvalues: t2 (copy), t (copy) ]]
		local v1 = t2[p2]

		if v1 == nil then
			return t[p2]
		end

		return v1
	end
}

t.__index = t
t.Settings = {
	FixedCameraStartOffset = Vector3.new(0.8, -0.4, 2),
	LaunchSpeed = 60,
	GravityStrength = 0.7,
	SimulationStepRate = 60,
	MaxPreviewBounces = 2,
	MaxLiveBounces = 5,
	CharacterBounceEnergyMultiplier = 0.45,
	WorldBounceEnergyMultiplier = 0.6,
	VerticalBounceDampening = 0.75,
	StickyStickOffset = 0.1,
	PreviewMaxDuration = 1.8,
	ArcHeight = 10,
	MaxArcHeightInfluence = 10,
	ArcDistance = 50,
	PredictionTime = 1,
	MaxSegments = 20,
	EndpointCenterStrength = 1
}

local t4 = {
	MinInitialGravityScale = 0.2,
	MaxInitialGravityScale = 0.3,
	GravityBlendExponent = 1.01,
	FinalGravityScale = 0.5,
	MinBlendDuration = 10,
	NearAimDistanceRatio = 0.25,
	FarArcCenterLockStrength = 0.9,
	SpawnOffset = 1.5,
	CoreForwardClearance = 0.35,
	CoreVerticalClearance = 0.05,
	MaxClientCameraDistanceFromHead = 6,
	MaxClientCameraDistanceFromCharacter = 8,
	MaxClientCoreDistanceFromCamera = 6,
	MaxClientCoreDistanceFromHead = 8,
	CollisionGroupResetDelay = 0.6,
	InitialCollisionGroup = "Throwables",
	DefaultCollisionGroup = "Default",
	CollisionSoundCooldown = 0.1,
	ImpactRaycastLookAheadTime = 0.12,
	ImpactMinRaycastDistance = 1.5,
	ImpactMaxRaycastDistance = 8,
	BarricadeDamageGracePeriod = 3,
	FloorImpactNormalDotThreshold = 0.8191520442889918,
	StickyRaycastLookAheadTime = 0.12,
	StickyMinRaycastDistance = 2,
	StickyMaxRaycastDistance = 8,
	StickyClientClaimMaxDistance = 10,
	StickyValidationPadding = 0.75,
	StickyValidationPositionTolerance = 2,
	StickyValidationNormalDotThreshold = 0.2,
	StickySurfaceOffsetDefault = 0.1,
	StickyGrenadeSurfaceOffset = 0.3,
	SpawnSafetyPadding = 0.05
}
local v1 = nil
local v2 = nil

local function resolveSpectateModeForCurrentGame() --[[ resolveSpectateModeForCurrentGame | Line: 85 | Upvalues: Server (copy), GameModes (copy) ]]
	local v1 = Server:GetAttribute("GameMode")

	return GameModes.ResolveSpectateMode(v1, if v1 == "Custom" then Server:GetAttribute("SpectateFirstPerson") == true else false)
end

local function fireKillCamIfEnabled(p1, p2) --[[ fireKillCamIfEnabled | Line: 92 | Upvalues: Players (copy), Server (copy), GameModes (copy), ReplicatedStorage (copy) ]]
	if not p1 or p1.Parent ~= Players then
		return
	end

	local v1 = Server:GetAttribute("GameMode")

	if GameModes.ResolveSpectateMode(v1, if v1 == "Custom" then Server:GetAttribute("SpectateFirstPerson") == true else false) ~= GameModes.SpectateModes.ThirdPerson then
		return
	end

	local KillCam = ReplicatedStorage.GameEvents:FindFirstChild("KillCam")

	if not (KillCam and KillCam:IsA("RemoteEvent")) then
		return
	end

	KillCam:FireClient(p1, p2)
end

local function queueReplayClipForKillIfAvailable(p1, p2) --[[ queueReplayClipForKillIfAvailable | Line: 106 ]]
	local ReplayKillCamService = shared.ReplayKillCamService

	if typeof(ReplayKillCamService) ~= "table" then
		return
	end

	local QueueReplayClipForKill = ReplayKillCamService.QueueReplayClipForKill

	if typeof(QueueReplayClipForKill) ~= "function" then
		return
	end

	QueueReplayClipForKill(p1, p2, "Throwable")
end

local function appendReplayEventIfAvailable(p1, p2, p3) --[[ appendReplayEventIfAvailable | Line: 118 ]]
	local ReplayKillCamService = shared.ReplayKillCamService

	if typeof(ReplayKillCamService) ~= "table" then
		return
	end

	local AppendReplayEvent = ReplayKillCamService.AppendReplayEvent

	if typeof(AppendReplayEvent) ~= "function" then
		return
	end

	AppendReplayEvent(p1, p2, p3)
end

local function appendReplayDeathEventIfAvailable(p1, p2, p3) --[[ appendReplayDeathEventIfAvailable | Line: 130 | Upvalues: Players (copy) ]]
	if not p1 or p1.Parent ~= Players then
		return
	end

	if not p2 or p2.Parent ~= Players then
		return
	end

	if typeof(p3) ~= "table" then
		return
	end

	local ReplayKillCamService = shared.ReplayKillCamService

	if typeof(ReplayKillCamService) ~= "table" then
		return
	end

	local AppendReplayEvent = ReplayKillCamService.AppendReplayEvent

	if typeof(AppendReplayEvent) ~= "function" then
		return
	end

	AppendReplayEvent(p1, "ReplayDeath", {
		TargetUserId = p2.UserId,
		KillerUserId = p1.UserId,
		HitPartName = p3.hitPartName or "Torso",
		CarryVelocity = p3.carryVelocity,
		PushDirection = p3.pushDirection,
		SourcePosition = p3.sourcePosition,
		ImpulseProfile = p3.impulseProfile,
		MotionProfile = p3.motionProfile
	})
end

local function fireVerifiedDamageFeedbackForSpectators(p1, p2, p3) --[[ fireVerifiedDamageFeedbackForSpectators | Line: 153 | Upvalues: ReplicatedStorage (copy) ]]
	ReplicatedStorage.GameEvents.VerifiedDamageFeedback:FireClient(p1, p2, p3 == true)
end

local t5 = {
	["Proximity Alarm"] = true,
	["Sticky Grenade"] = true
}
local t6 = {
	AttackerObjective = true,
	AttackerSpawn = true,
	DefenderObjective = true,
	DefenderSpawn = true,
	DefenderZone = true,
	SpawnArea = true
}
local t7 = {
	["Proximity Alarm"] = Vector3.new(0, 0, 0)
}
local t8 = {
	["Proximity Alarm"] = {
		MountNormalAxis = "Up"
	}
}
local v3 = setmetatable({}, {
	__mode = "k"
})
local v4 = setmetatable({}, {
	__mode = "k"
})
local v5 = setmetatable({}, {
	__mode = "k"
})
local v6 = setmetatable({}, {
	__mode = "k"
})
local t9 = {}
local t10 = {}
local t11 = {}
local v7 = nil
local v8 = 0
local v9 = setmetatable({}, {
	__mode = "k"
})

local function getComponents() --[[ getComponents | Line: 190 | Upvalues: v1 (ref), ReplicatedStorage (copy) ]]
	if v1 ~= nil then
		return v1
	end

	v1 = require(ReplicatedStorage.ComponentsManager)

	return v1
end

local function getChallenges() --[[ getChallenges | Line: 198 | Upvalues: v2 (ref), ReplicatedStorage (copy) ]]
	if v2 ~= nil then
		return v2
	end

	v2 = require(ReplicatedStorage.Components.Challenges)

	return v2
end

local function copyIgnoreList(p1) --[[ copyIgnoreList | Line: 206 ]]
	local t = {}

	for v3, v4 in ipairs(if p1 then p1 else {}) do
		table.insert(t, v4)
	end

	return t
end

local function createRaycastParams(p1) --[[ createRaycastParams | Line: 214 ]]
	local v1 = RaycastParams.new()

	v1.FilterType = Enum.RaycastFilterType.Blacklist
	v1.IgnoreWater = true
	v1.FilterDescendantsInstances = if p1 then p1 else {}

	return v1
end

local function getCenterRay(p1, p2) --[[ getCenterRay | Line: 222 ]]
	local v1 = p1 and p1.ViewportSize or Vector2.zero

	if v1.X <= 0 or v1.Y <= 0 then
		local v2 = p2 and p2.AbsoluteSize or Vector2.zero

		v1 = Vector2.new(v2.X, v2.Y)
	end

	return p1:ViewportPointToRay(v1.X * 0.5, v1.Y * 0.5, 0)
end

function t.GetSettings() --[[ GetSettings | Line: 231 | Upvalues: t (copy) ]]
	return t.Settings
end
function t.GetGravityBlendDuration() --[[ GetGravityBlendDuration | Line: 235 | Upvalues: t (copy) ]]
	return math.max(t.Settings.ArcDistance / math.max(t.Settings.LaunchSpeed, 1), 10)
end
function t.GetGravityScaleAtTime(p1) --[[ GetGravityScaleAtTime | Line: 239 | Upvalues: t (copy) ]]
	local v2 = math.clamp(p1 / t.GetGravityBlendDuration(), 0, 1) ^ 1.01
	local v4 = math.clamp(1 - t.Settings.ArcHeight * t.Settings.MaxArcHeightInfluence, 0.2, 0.3)

	return v4 + (0.5 - v4) * v2
end
function t.GetCompensationForceScale(p1) --[[ GetCompensationForceScale | Line: 248 | Upvalues: t (copy) ]]
	return 1 - t.GetGravityScaleAtTime(p1 or 0)
end
function t.GetLaunchVelocity(p1, p2) --[[ GetLaunchVelocity | Line: 252 | Upvalues: t (copy) ]]
	return (p1.Magnitude > 0 and p1.Unit or Vector3.new(0, 0, 1)) * (if p2 then p2 else t.Settings.LaunchSpeed)
end
function t.IsKnownNonBlockingTrajectoryPart(p1) --[[ IsKnownNonBlockingTrajectoryPart | Line: 257 | Upvalues: t6 (copy) ]]
	return if p1 == nil then false else p1:IsA("BasePart") and t6[p1.Name] == true
end
function t.IsTrajectoryBlockingPart(p1) --[[ IsTrajectoryBlockingPart | Line: 261 | Upvalues: Players (copy), t (copy) ]]
	if not (p1 and p1:IsA("BasePart")) then
		return false
	end

	local v1 = p1:FindFirstAncestorOfClass("Model")

	if v1 and (Players:GetPlayerFromCharacter(v1) or v1:FindFirstChildOfClass("Humanoid")) then
		return true
	end

	if t.IsKnownNonBlockingTrajectoryPart(p1) then
		return false
	end

	return p1.CanCollide == true
end
function t.RaycastTrajectory(p1, p2, p3) --[[ RaycastTrajectory | Line: 278 | Upvalues: copyIgnoreList (copy), t (copy) ]]
	local Magnitude = p2.Magnitude

	if Magnitude <= 0 then
		return nil
	end

	local Unit = p2.Unit
	local v1 = copyIgnoreList(p3)
	local v2 = RaycastParams.new()

	v2.FilterType = Enum.RaycastFilterType.Blacklist
	v2.IgnoreWater = true
	v2.FilterDescendantsInstances = if v1 then v1 else {}

	local sum, v4, sum2 = Magnitude, v2, p1

	while sum > 0.001 do
		v4.FilterDescendantsInstances = v1

		local v5 = workspace:Raycast(sum2, Unit * sum, v4)

		if not v5 then
			break
		end

		if t.IsTrajectoryBlockingPart(v5.Instance) then
			return v5
		end

		table.insert(v1, v5.Instance)

		local Magnitude2 = (v5.Position - sum2).Magnitude
		local v10 = math.min(math.max(Magnitude2 - math.min(0.001, (math.max(Magnitude2 * 0.5, 0))), 0.0001), sum)

		sum = sum - v10
		sum2 = sum2 + Unit * v10
	end

	return nil
end
function t.GetGravityVectorAtTime(p1, p2) --[[ GetGravityVectorAtTime | Line: 313 | Upvalues: t (copy) ]]
	return Vector3.new(0, -(p1 * t.GetGravityScaleAtTime(p2)), 0)
end
function t.AdvanceTrajectoryState(p1, p2, p3, p4, p5) --[[ AdvanceTrajectoryState | Line: 317 | Upvalues: t (copy) ]]
	local v1 = t.GetGravityVectorAtTime(p3, p5 + p4 * 0.5)

	return p1 + p2 * p4 + 0.5 * v1 * p4 * p4, p2 + v1 * p4
end
function t.GetPositionAtTime(p1, p2, p3, p4) --[[ GetPositionAtTime | Line: 325 | Upvalues: t (copy) ]]
	local sum, v1, v2 = 0, p1, p2

	while sum < p4 do
		local v3 = math.min(1 / 60, p4 - sum)
		local v4, v5 = t.AdvanceTrajectoryState(v1, v2, p3, v3, sum)

		sum, v1, v2 = sum + v3, v4, v5
	end

	return v1
end
function t.GetCrosshairThrowData(p1, p2) --[[ GetCrosshairThrowData | Line: 340 | Upvalues: getCenterRay (copy) ]]
	local v1 = getCenterRay(p1, p2)

	return v1.Origin, v1.Direction.Unit
end
function t.GetThrowableCorePart(p1) --[[ GetThrowableCorePart | Line: 345 ]]
	if not (p1 and p1:IsA("Model")) then
		return nil
	end

	local Base = p1:FindFirstChild("Base")

	if Base and Base:IsA("BasePart") then
		return Base
	end

	local Handle = p1:FindFirstChild("Handle")

	if Handle and Handle:IsA("BasePart") then
		return Handle
	end

	local PrimaryPart = p1.PrimaryPart

	if PrimaryPart and PrimaryPart:IsA("BasePart") then
		return PrimaryPart
	end

	return nil
end
function t.IsStickyThrowable(p1) --[[ IsStickyThrowable | Line: 368 | Upvalues: t5 (copy), CollectionService (copy) ]]
	if not (p1 and p1:IsA("Model")) then
		return false
	end

	for k in pairs(t5) do
		if CollectionService:HasTag(p1, k) then
			return true
		end
	end

	return t5[p1.Name] == true
end

local function isStickyCharacterTarget(p1) --[[ isStickyCharacterTarget | Line: 382 | Upvalues: Players (copy) ]]
	if not p1 then
		return false
	end

	local v1 = p1:FindFirstAncestorOfClass("Model")

	if not v1 then
		return false
	end

	if Players:GetPlayerFromCharacter(v1) then
		return true
	end

	return v1:FindFirstChildOfClass("Humanoid") ~= nil
end

local function buildStickyIgnoreList(p1, p2, p3) --[[ buildStickyIgnoreList | Line: 399 | Upvalues: Players (copy) ]]
	local t = { p1, game.Workspace.Map_Cache }

	for i, v in ipairs(Players:GetPlayers()) do
		local Character = v.Character

		if Character then
			table.insert(t, Character)
		end
	end

	if p2 then
		table.insert(t, p2)
	end

	for v3, v4 in ipairs(if p3 then p3 else {}) do
		table.insert(t, v4)
	end

	return t
end

local function clearStickyFallbackConnection(p1) --[[ clearStickyFallbackConnection | Line: 416 | Upvalues: v3 (copy) ]]
	local v1 = v3[p1]

	if not v1 then
		return
	end

	v1:Disconnect()
	v3[p1] = nil
end

local function clearImpactFallbackConnection(p1) --[[ clearImpactFallbackConnection | Line: 424 | Upvalues: v4 (copy) ]]
	local v1 = v4[p1]

	if not v1 then
		return
	end

	v1:Disconnect()
	v4[p1] = nil
end

local function clearThrowableCollisionConnection(p1) --[[ clearThrowableCollisionConnection | Line: 432 | Upvalues: v5 (copy), v6 (copy) ]]
	local v1 = v5[p1]

	if v1 then
		v1:Disconnect()
		v5[p1] = nil
	end

	v6[p1] = nil
end

local function buildImpactIgnoreList(p1, p2, p3) --[[ buildImpactIgnoreList | Line: 441 | Upvalues: Workspace (copy) ]]
	local t = { p1, Workspace.Map_Cache }

	if p2 then
		table.insert(t, p2)
	end

	for v3, v4 in ipairs(if p3 then p3 else {}) do
		table.insert(t, v4)
	end

	return t
end

local function getSimulationStepTime() --[[ getSimulationStepTime | Line: 452 | Upvalues: t (copy) ]]
	return 1 / math.max(t.Settings.SimulationStepRate or 60, 1)
end

local function getSimulationGravity(p1) --[[ getSimulationGravity | Line: 456 | Upvalues: t (copy) ]]
	return p1 * (t.Settings.GravityStrength or 1)
end

local function getCharacterFromInstance(p1) --[[ getCharacterFromInstance | Line: 460 | Upvalues: Players (copy) ]]
	if not p1 then
		return nil
	end

	local v1 = p1:FindFirstAncestorOfClass("Model")

	if not v1 then
		return nil
	end

	if not (Players:GetPlayerFromCharacter(v1) or v1:FindFirstChildOfClass("Humanoid")) then
		return nil
	end

	return v1
end

local function getReplayRelativePath(p1, p2) --[[ getReplayRelativePath | Line: 477 ]]
	local v1, v2 = p2, {}

	while v1 and v1 ~= p1 do
		table.insert(v2, 1, v1.Name)
		v1 = v1.Parent
	end

	if v1 == p1 then
		return table.concat(v2, "/")
	end

	return nil
end

local function getReplayRoundCacheFolder() --[[ getReplayRoundCacheFolder | Line: 490 | Upvalues: Workspace (copy) ]]
	local Round_Cache = Workspace:FindFirstChild("Round_Cache")

	if Round_Cache and Round_Cache:IsA("Folder") then
		return Round_Cache
	end

	return nil
end

local function ensureReplayThrowableId(p1, p2) --[[ ensureReplayThrowableId | Line: 498 | Upvalues: Config (copy), Players (copy) ]]
	if not p1 then
		return nil
	end

	local v1 = p1:GetAttribute("ReplayThrowableId")

	if typeof(v1) == "string" and v1 ~= "" then
		return v1
	end

	local v2 = Config.CreateRandomSerialID()

	p1:SetAttribute("ReplayThrowableId", v2)

	if not p2 or p2.Parent ~= Players then
		return v2
	end

	p1:SetAttribute("ReplayOwnerUserId", p2.UserId)

	return v2
end

local function appendReplayThrowableEventIfAvailable(p1) --[[ appendReplayThrowableEventIfAvailable | Line: 516 ]]
	local ReplayKillCamService = shared.ReplayKillCamService

	if typeof(ReplayKillCamService) ~= "table" then
		return
	end

	local AppendThrowableEvent = ReplayKillCamService.AppendThrowableEvent

	if typeof(AppendThrowableEvent) ~= "function" then
		return
	end

	AppendThrowableEvent(p1)
end

local function buildReplayAttachmentPayload(p1) --[[ buildReplayAttachmentPayload | Line: 528 | Upvalues: Players (copy), getReplayRelativePath (copy), Workspace (copy) ]]
	if typeof(p1) ~= "Instance" then
		return nil
	end

	local v1

	if p1 then
		local v2 = p1:FindFirstAncestorOfClass("Model")

		v1 = if v2 and (Players:GetPlayerFromCharacter(v2) or v2:FindFirstChildOfClass("Humanoid")) then v2 else nil
	else
		v1 = nil
	end

	local v3 = if v1 then Players:GetPlayerFromCharacter(v1) else v1

	if v3 then
		return {
			Kind = "Actor",
			UserId = v3.UserId,
			RelativePath = getReplayRelativePath(v1, p1)
		}
	end

	local Map = Workspace:FindFirstChild("Map")
	local v4 = if Map then getReplayRelativePath(Map, p1) else Map

	if typeof(v4) == "string" and v4 ~= "" then
		return {
			Kind = "Map",
			Path = v4
		}
	end

	local Round_Cache = Workspace:FindFirstChild("Round_Cache")
	local v5 = if Round_Cache and Round_Cache:IsA("Folder") then Round_Cache else nil
	local v6 = if v5 then getReplayRelativePath(v5, p1) else v5

	if typeof(v6) == "string" and v6 ~= "" then
		return {
			Kind = "RoundCache",
			Path = v6
		}
	end

	return {
		Kind = "World",
		Name = p1.Name
	}
end

local function appendReplayThrowableEventForModel(p1, p2, p3, p4) --[[ appendReplayThrowableEventForModel | Line: 567 | Upvalues: ensureReplayThrowableId (copy), Players (copy) ]]
	if not p1 or (typeof(p3) ~= "string" or p3 == "") then
		return
	end

	local v1 = ensureReplayThrowableId(p1, p2)

	if typeof(v1) ~= "string" or v1 == "" then
		return
	end

	local t = {
		ReplayId = v1,
		EventType = p3,
		ModelName = p1.Name
	}

	t.OwnerUserId = p2 and p2.Parent == Players and p2.UserId or (tonumber(p1:GetAttribute("ReplayOwnerUserId")) or 0)
	t.OwnerName = p2 and p2.Parent == Players and p2.Name or (p1:GetAttribute("Owner") or "")

	for v6, v7 in pairs(if p4 then p4 else {}) do
		t[v6] = v7
	end

	local ReplayKillCamService = shared.ReplayKillCamService

	if typeof(ReplayKillCamService) ~= "table" then
		return
	end

	local AppendThrowableEvent = ReplayKillCamService.AppendThrowableEvent

	if typeof(AppendThrowableEvent) ~= "function" then
		return
	end

	AppendThrowableEvent(t)
end

local function resolveImpactMode(p1) --[[ resolveImpactMode | Line: 590 ]]
	if not (p1 and p1:IsA("Model")) then
		return "None"
	end

	if p1.Name == "Impact Grenade" then
		return "Any"
	end

	if p1.Name == "Molotov" then
		return "Floor"
	end

	return "None"
end

local function ensureSimulationManager() --[[ ensureSimulationManager | Line: 603 | Upvalues: RunService (copy), v7 (ref), v8 (ref), t (copy), t10 (ref), t11 (ref), t9 (copy) ]]
	if RunService:IsServer() == true and not v7 then
		v7 = RunService.Heartbeat:Connect(function(p13) --[[ Line: 608 | Upvalues: v8 (ref), t (ref), t10 (ref), t11 (ref), t9 (ref) ]]
			v8 = v8 + p13

			local v2 = 1 / math.max(t.Settings.SimulationStepRate or 60, 1)
			local count2 = 0

			while v2 <= v8 and count2 < 4 do
				v8 = v8 - v2
				count2 = count2 + 1

				local v3 = t10

				t10 = t11
				t11 = {}

				for k2, v in pairs(t9) do
					if k2 and (k2.Parent and v) then
						if v.Advance then
							v:Advance(v2)
						end

						continue
					end

					t9[k2] = nil
				end

				for i2, v in ipairs(v3) do
					local Model = v.Model

					if Model and (Model.Parent and Model:GetAttribute("StickResolved") ~= true) then
						t.ApplyStickyImpact(Model, v.HitResult, v.OwnerPlayer, false)
					end
				end
			end

			if not (v2 * 4 < v8) then
				return
			end

			v8 = v2
		end)
	end
end

local function unregisterSimulatedThrowable(p1) --[[ unregisterSimulatedThrowable | Line: 640 | Upvalues: t9 (copy) ]]
	if not t9[p1] then
		return
	end

	t9[p1] = nil

	if not (p1 and p1.Parent) then
		return
	end

	p1:SetAttribute("SimulatedThrowableActive", false)
end

local function playSimulatedCollisionAudio(p1) --[[ playSimulatedCollisionAudio | Line: 651 ]]
	local v1 = if p1 then p1:FindFirstChild("Base") else p1
	local v2 = if v1 then v1:FindFirstChild("Collide") else v1

	if v1 and (v1:IsA("BasePart") and (v2 and v2:IsA("Sound"))) then
		local v3 = v2:Clone()

		v3.Looped = false
		v3.PlayOnRemove = false
		v3.TimePosition = 0
		v3.Parent = v1
		v3:Play()
		task.delay(math.max(v3.TimeLength / math.max(v3.PlaybackSpeed, 0.05), 0.5) + 0.25, function() --[[ Line: 666 | Upvalues: v3 (copy) ]]
			if not (v3 and v3.Parent) then
				return
			end

			v3:Destroy()
		end)
	end
end

local function getRoundStartedAt() --[[ getRoundStartedAt | Line: 673 | Upvalues: Server (copy) ]]
	local v1 = Server:GetAttribute("RoundStartedAt")

	if typeof(v1) == "number" then
		return v1
	end

	return nil
end

local function isBarricadeDamageAllowed() --[[ isBarricadeDamageAllowed | Line: 681 | Upvalues: Server (copy), Workspace (copy) ]]
	if Server:GetAttribute("Phase") ~= "Round Started" then
		return false
	end

	local v1 = Server:GetAttribute("RoundStartedAt")
	local v2 = if typeof(v1) == "number" then v1 else nil

	if v2 == nil then
		return true
	end

	return Workspace:GetServerTimeNow() - v2 >= 3
end

function t.GetStickySurfaceOffset(p1) --[[ GetStickySurfaceOffset | Line: 694 | Upvalues: CollectionService (copy), t (copy) ]]
	if p1 and (CollectionService:HasTag(p1, "Sticky Grenade") or p1.Name == "Sticky Grenade") then
		return 0.3
	end

	return t.Settings.StickyStickOffset or 0.1
end

local function ensureStickyRuntimeAttributes(p1) --[[ ensureStickyRuntimeAttributes | Line: 702 | Upvalues: t7 (copy) ]]
	if not p1 then
		return
	end

	if p1:GetAttribute("StickRotationOffset") ~= nil then
		return
	end

	local v1 = t7[p1.Name]

	if typeof(v1) ~= "Vector3" then
		return
	end

	p1:SetAttribute("StickRotationOffset", v1)
end

local function getStickyRotationOffset(p1) --[[ getStickyRotationOffset | Line: 715 | Upvalues: t7 (copy) ]]
	if p1 and p1:GetAttribute("StickRotationOffset") == nil then
		local v1 = t7[p1.Name]

		if typeof(v1) == "Vector3" then
			p1:SetAttribute("StickRotationOffset", v1)
		end
	end

	local v2 = if p1 then p1:GetAttribute("StickRotationOffset") else p1

	if typeof(v2) == "Vector3" then
		return CFrame.Angles(math.rad(v2.X), math.rad(v2.Y), (math.rad(v2.Z)))
	end

	return CFrame.identity
end

local function getStickyBasisRule(p1) --[[ getStickyBasisRule | Line: 729 ]]
	return {
		NormalAxis = "Up",
		ReferenceAxis = "Look"
	}
end

local function getStickyAuthoredBasisRule(p1) --[[ getStickyAuthoredBasisRule | Line: 736 | Upvalues: t8 (copy) ]]
	local v1 = if p1 then t8[p1.Name] else p1

	if typeof(v1) == "table" then
		return v1
	end

	return nil
end

local function getStickyReferenceVector(p1, p2) --[[ getStickyReferenceVector | Line: 744 ]]
	local v1 = if p1 == "Right" then Vector3.new(1, 0, 0) elseif p1 == "Up" then Vector3.new(0, 1, 0) else Vector3.new(0, 0, 1)

	if math.abs((v1:Dot(p2))) >= 0.98 then
		v1 = if math.abs(((Vector3.new(0, 1, 0)):Dot(p2))) < 0.98 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)
	end

	return v1
end

local function getRotationOnlyCFrame(p1) --[[ getRotationOnlyCFrame | Line: 752 ]]
	return CFrame.fromMatrix(Vector3.new(0, 0, 0), p1.RightVector, p1.UpVector, -p1.LookVector)
end

local function getVectorAlignmentRotation(p1, p2, p3) --[[ getVectorAlignmentRotation | Line: 756 ]]
	local v1 = p1.Magnitude > 0 and p1.Unit or Vector3.new(0, 1, 0)
	local v2 = p2.Magnitude > 0 and p2.Unit or Vector3.new(0, 1, 0)
	local v4 = math.clamp(v1:Dot(v2), -1, 1)
	local v5 = v1:Cross(v2)

	if not (v5.Magnitude <= 0.0001) then
		return CFrame.fromAxisAngle(v5.Unit, (math.acos(v4)))
	end

	if v4 >= 0.9999 then
		return CFrame.identity
	end

	local v6 = if typeof(p3) == "Vector3" and p3 then p3 else Vector3.new(1, 0, 0)

	if v6.Magnitude <= 0.0001 or math.abs((v6.Unit:Dot(v1))) >= 0.98 then
		local v7, v8

		v7 = (Vector3.new(0, 1, 0)):Dot(v1)
		v8 = if math.abs(v7) < 0.98 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)
		v6 = v8
	end

	local v10 = v1:Cross(v6)

	return CFrame.fromAxisAngle((if v10.Magnitude <= 0.0001 then v1:Cross(Vector3.new(0, 0, 1)) else v10).Unit, math.pi)
end

local function getStickyTemplateModel(p1) --[[ getStickyTemplateModel | Line: 778 | Upvalues: ReplicatedStorage (copy) ]]
	local Items = ReplicatedStorage:FindFirstChild("Items")
	local v1 = (if Items then Items:FindFirstChild("Throwable") else Items) and (if p1 then v1:FindFirstChild(p1.Name) else p1)

	if v1 and v1:IsA("Model") then
		return v1
	end

	return nil
end

local function buildAuthoredStickyImpactCFrame(p1, p2, p3) --[[ buildAuthoredStickyImpactCFrame | Line: 788 | Upvalues: t8 (copy), ReplicatedStorage (copy), getVectorAlignmentRotation (copy) ]]
	local v1 = if p1 then t8[p1.Name] else p1
	local v2 = if typeof(v1) == "table" then v1 else nil

	if not v2 then
		return nil
	end

	local Items = ReplicatedStorage:FindFirstChild("Items")
	local v3 = (if Items then Items:FindFirstChild("Throwable") else Items) and (if p1 then v3:FindFirstChild(p1.Name) else p1)
	local v4 = if v3 and v3:IsA("Model") then v3 else nil

	if not v4 then
		return nil
	end

	local v5 = v4:GetPivot()
	local v6 = CFrame.fromMatrix(Vector3.new(0, 0, 0), v5.RightVector, v5.UpVector, -v5.LookVector)
	local v7 = v2.MountNormalAxis == "NegativeUp" and -v5.UpVector or v5.UpVector
	local RightVector = v5.RightVector

	if math.abs((RightVector:Dot(v7))) >= 0.98 then
		RightVector = v5.LookVector
	end

	local v9 = getVectorAlignmentRotation(v7, p3, RightVector)

	return CFrame.new(p2) * (v9 * v6)
end

local function buildStickyBaseImpactCFrame(p1, p2, p3) --[[ buildStickyBaseImpactCFrame | Line: 810 | Upvalues: buildAuthoredStickyImpactCFrame (copy) ]]
	local v1 = buildAuthoredStickyImpactCFrame(p1, p2, p3)

	if v1 then
		return v1
	end

	local t = {
		NormalAxis = "Up",
		ReferenceAxis = "Look"
	}
	local v2 = t.NormalAxis == "NegativeUp" and -p3 or p3
	local ReferenceAxis = t.ReferenceAxis
	local v3 = if ReferenceAxis == "Right" then Vector3.new(1, 0, 0) elseif ReferenceAxis == "Up" then Vector3.new(0, 1, 0) else Vector3.new(0, 0, 1)

	if math.abs((v3:Dot(v2))) >= 0.98 then
		v3 = if math.abs(((Vector3.new(0, 1, 0)):Dot(v2))) < 0.98 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)
	end

	local v7 = v3:Cross(v2)

	if v7.Magnitude <= 0.001 then
		local v8 = Vector3.new(1, 0, 0)

		if math.abs((v8:Dot(v2))) >= 0.98 then
			v8 = if math.abs(((Vector3.new(0, 1, 0)):Dot(v2))) < 0.98 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)
		end

		v7 = v8:Cross(v2)
	end

	local v13 = if v7.Magnitude <= 0.001 then Vector3.new(1, 0, 0) else v7.Unit
	local v14 = v2:Cross(v13)

	return CFrame.fromMatrix(p2, v13, v2, -(if v14.Magnitude <= 0.001 then Vector3.new(0, 0, 1) else v14.Unit))
end

function t.GetStickyImpactCFrame(p1, p2, p3) --[[ GetStickyImpactCFrame | Line: 840 | Upvalues: t (copy), buildStickyBaseImpactCFrame (copy), getStickyRotationOffset (copy) ]]
	local v1 = typeof(p3) == "Vector3" and p3.Magnitude > 0 and p3.Unit or Vector3.new(0, 1, 0)

	return buildStickyBaseImpactCFrame(p1, p2 + v1 * t.GetStickySurfaceOffset(p1), v1) * getStickyRotationOffset(p1)
end
function t.GetStickyImpactResult(p1, p2, p3, p4) --[[ GetStickyImpactResult | Line: 847 | Upvalues: t (copy), buildStickyIgnoreList (copy) ]]
	if t.IsStickyThrowable(p1) ~= true then
		return nil
	end

	local v1 = t.GetThrowableCorePart(p1)

	if not v1 then
		return nil
	end

	local AssemblyLinearVelocity = v1.AssemblyLinearVelocity

	if p1:GetAttribute("SimulatedThrowableActive") == true then
		AssemblyLinearVelocity = Vector3.new(p1:GetAttribute("SimulatedThrowableVelocityX") or AssemblyLinearVelocity.X, p1:GetAttribute("SimulatedThrowableVelocityY") or AssemblyLinearVelocity.Y, p1:GetAttribute("SimulatedThrowableVelocityZ") or AssemblyLinearVelocity.Z)
	end

	local Magnitude = AssemblyLinearVelocity.Magnitude

	if Magnitude <= 0.05 then
		return nil
	end

	return t.RaycastTrajectory(v1.Position, AssemblyLinearVelocity.Unit * math.min(if p4 then p4 else math.max(Magnitude * 0.12, 2), 8), (buildStickyIgnoreList(p1, p2, p3)))
end
function t.GetImpactResult(p1, p2, p3, p4) --[[ GetImpactResult | Line: 877 | Upvalues: t (copy), buildImpactIgnoreList (copy) ]]
	local v1 = t.GetThrowableCorePart(p1)

	if not v1 then
		return nil
	end

	local AssemblyLinearVelocity = v1.AssemblyLinearVelocity

	if p1:GetAttribute("SimulatedThrowableActive") == true then
		AssemblyLinearVelocity = Vector3.new(p1:GetAttribute("SimulatedThrowableVelocityX") or AssemblyLinearVelocity.X, p1:GetAttribute("SimulatedThrowableVelocityY") or AssemblyLinearVelocity.Y, p1:GetAttribute("SimulatedThrowableVelocityZ") or AssemblyLinearVelocity.Z)
	end

	local Magnitude = AssemblyLinearVelocity.Magnitude

	if Magnitude <= 0.05 then
		return nil
	end

	local v6 = math.max(Magnitude * 0.12, 1.5)

	if typeof(p4) == "table" and typeof(p4.OverrideDistance) == "number" then
		v6 = p4.OverrideDistance
	end

	local v8 = t.RaycastTrajectory(v1.Position, AssemblyLinearVelocity.Unit * math.min(v6, 8), (buildImpactIgnoreList(p1, p2, p3)))

	if not v8 then
		return nil
	end

	if typeof(p4) == "table" and p4.RequireUpwardNormal == true then
		local v9 = if typeof(p4.UpwardNormalDotThreshold) == "number" then p4.UpwardNormalDotThreshold or 0.8191520442889918 else 0.8191520442889918

		if v8.Normal:Dot(Vector3.new(0, 1, 0)) < v9 then
			return nil
		end
	end

	return v8
end
function t.ValidateClientStickyImpact(p1, p2, p3, p4, p5) --[[ ValidateClientStickyImpact | Line: 917 | Upvalues: t (copy), buildStickyIgnoreList (copy) ]]
	if t.IsStickyThrowable(p1) ~= true then
		return nil
	end

	if typeof(p3) ~= "Vector3" or (typeof(p4) ~= "Vector3" or p4.Magnitude <= 0) then
		return nil
	end

	local v1 = t.GetThrowableCorePart(p1)

	if not v1 then
		return nil
	end

	local v2 = p3 - v1.Position
	local Magnitude = v2.Magnitude

	if Magnitude <= 0.01 or Magnitude > 10 then
		return nil
	end

	local v3 = t.RaycastTrajectory(v1.Position, v2.Unit * math.min(Magnitude + 0.75, 10), (buildStickyIgnoreList(p1, p2, p5)))

	if not v3 then
		return nil
	end

	if (v3.Position - p3).Magnitude > 2 then
		return nil
	end

	if v3.Normal:Dot(p4.Unit) < 0.2 then
		return nil
	end

	return v3
end
function t.ApplyStickyImpact(p1, p2, p3, p4) --[[ ApplyStickyImpact | Line: 957 | Upvalues: t (copy), Players (copy), v3 (copy) ]]
	if not (p1 and (p2 and p2.Instance)) then
		return false
	end

	local v1 = t.GetThrowableCorePart(p1)
	local Handle = p1:FindFirstChild("Handle")

	if not (Handle and Handle:IsA("BasePart")) then
		Handle = v1
	end

	if not (v1 and Handle) then
		return false
	end

	if p4 ~= true and p1:GetAttribute("StickResolved") == true then
		return true
	end

	p1.PrimaryPart = p1.PrimaryPart or v1

	local v2 = CFrame.new(p2.Position, p2.Position + p2.Normal)

	p1:PivotTo(v2)

	local v32 = p2.Instance
	local v4

	if v32 then
		local v5 = v32:FindFirstAncestorOfClass("Model")

		v4 = if v5 and (Players:GetPlayerFromCharacter(v5) or v5:FindFirstChildOfClass("Humanoid")) then v5 else nil
	else
		v4 = nil
	end

	local v6 = if v4 == nil then if p2.Instance.Anchored == true then false else true else true

	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BodyForce") and v.Name == "ThrowableGravityAssist" then
			v:Destroy()

			continue
		end

		if v:IsA("BasePart") then
			v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = p4 == true and v.CanQuery or true
			v.Massless = true
			v.Anchored = if v6 == true then false else true

			if p4 ~= true then
				v.CollisionGroup = "Default"
				pcall(function() --[[ Line: 996 | Upvalues: v (copy) ]]
					v:SetNetworkOwner(nil)
				end)
			end
		end
	end

	p1:PivotTo(v2)

	local StickyImpactWeld = Handle:FindFirstChild("StickyImpactWeld")

	if v6 == true then
		if not StickyImpactWeld then
			local StickyImpactWeld2 = Instance.new("WeldConstraint")

			StickyImpactWeld2.Name = "StickyImpactWeld"
			StickyImpactWeld2.Parent = Handle
			StickyImpactWeld = StickyImpactWeld2
		end

		StickyImpactWeld.Part0 = Handle
		StickyImpactWeld.Part1 = p2.Instance
	elseif StickyImpactWeld then
		StickyImpactWeld:Destroy()
	end

	p1:PivotTo(v2)

	if p4 == true then
		return true
	end

	p1:SetAttribute("SimulatedThrowableActive", false)
	p1:SetAttribute("SimulatedThrowableVelocityX", 0)
	p1:SetAttribute("SimulatedThrowableVelocityY", 0)
	p1:SetAttribute("SimulatedThrowableVelocityZ", 0)
	p1:SetAttribute("SimulatedThrowableSpeed", 0)
	p1:SetAttribute("StickyFinalizationPending", false)
	p1:SetAttribute("StickResolved", true)

	local v9 = v3[p1]

	if v9 then
		v9:Disconnect()
		v3[p1] = nil
	end

	t.RecordReplayStickyResolved(p1, p3, p2)

	return true
end
function t.StartStickyServerFallback(p1, p2) --[[ StartStickyServerFallback | Line: 1035 | Upvalues: RunService (copy), t (copy), t9 (copy), v3 (copy) ]]
	if RunService:IsServer() ~= true or t.IsStickyThrowable(p1) ~= true then
		return
	end

	if t9[p1] then
		return
	end

	if not v3[p1] then
		v3[p1] = RunService.Heartbeat:Connect(function() --[[ Line: 1048 | Upvalues: p1 (copy), v3 (ref), p2 (copy), t (ref) ]]
			if p1 and p1.Parent then
				if p1:GetAttribute("StickResolved") == true or p1:GetAttribute("StickyFinalizationPending") == true then
					local v1 = p1
					local v2 = v3[v1]

					if not v2 then
						return
					end

					v2:Disconnect()
					v3[v1] = nil
				else
					local v4 = t.GetStickyImpactResult(p1, p2 and p2.Character)

					if not v4 then
						return
					end

					t.ApplyStickyImpact(p1, v4, p2, false)
				end
			else
				local v5 = p1
				local v6 = v3[v5]

				if not v6 then
					return
				end

				v6:Disconnect()
				v3[v5] = nil
			end
		end)
	end
end
function t.StartImpactServerFallback(p1, p2, p3, p4) --[[ StartImpactServerFallback | Line: 1067 | Upvalues: RunService (copy), t9 (copy), v4 (copy), t (copy) ]]
	if RunService:IsServer() ~= true or typeof(p3) ~= "function" then
		return
	end

	local v1 = t9[p1]

	if v1 then
		v1.ImpactCallback = p3

		if typeof(p4) ~= "table" or p4.RequireUpwardNormal ~= true then
			return
		end

		v1.ImpactMode = "Floor"
	elseif not v4[p1] then
		v4[p1] = RunService.Heartbeat:Connect(function() --[[ Line: 1085 | Upvalues: p1 (copy), v4 (ref), p2 (copy), t (ref), p4 (copy), p3 (copy) ]]
			if p1 and p1.Parent then
				if p1:GetAttribute("ImpactResolved") == true then
					local v1 = p1
					local v2 = v4[v1]

					if not v2 then
						return
					end

					v2:Disconnect()
					v4[v1] = nil
				else
					local v42 = t.GetImpactResult(p1, p2 and p2.Character, nil, p4)

					if not v42 then
						return
					end

					p1:SetAttribute("ImpactResolved", true)

					local v5 = p1
					local v6 = v4[v5]

					if v6 then
						v6:Disconnect()
						v4[v5] = nil
					end

					p3(v42)
				end
			else
				local v7 = p1
				local v8 = v4[v7]

				if not v8 then
					return
				end

				v8:Disconnect()
				v4[v7] = nil
			end
		end)
	end
end
function t.SetupThrowableCollisionAudio(p1, p2) --[[ SetupThrowableCollisionAudio | Line: 1106 | Upvalues: RunService (copy), v5 (copy), t9 (copy), t (copy), v6 (copy) ]]
	if RunService:IsServer() ~= true or (not p1 or v5[p1]) then
		return
	end

	if t9[p1] then
		return
	end

	local Base = p1:FindFirstChild("Base")
	local v1 = Base and Base:FindFirstChild("Collide")
	local Object = p1:FindFirstChild("Object")

	if not (Object and Object:IsA("BasePart")) then
		Object = t.GetThrowableCorePart(p1)
	end

	if not (Base and (Base:IsA("BasePart") and (v1 and (v1:IsA("Sound") and (Object and Object:IsA("BasePart")))))) then
		return
	end

	Object.CanTouch = true

	local v3 = v6
	local t2 = {
		NextPlayAt = 0
	}

	t2.OwnerCharacter = if p2 then p2.Character else p2
	v3[p1] = t2
	v5[p1] = Object.Touched:Connect(function(p12) --[[ Line: 1133 | Upvalues: p1 (copy), v5 (ref), v6 (ref), v1 (copy), Base (copy) ]]
		if p1 and p1.Parent then
			if not p12 or p12:IsDescendantOf(p1) then
				return
			end

			local v12 = v6[p1]

			if v12 and (v12.OwnerCharacter and p12:IsDescendantOf(v12.OwnerCharacter)) then
				return
			end

			local v2 = os.clock()

			if v12 and v2 < (v12.NextPlayAt or 0) then
				return
			end

			local v3, v4, v52, v62, v7

			if v12 then
				v12.NextPlayAt = v2 + 0.1
			end

			v3 = v1:Clone()
			v3.Looped = false
			v3.PlayOnRemove = false
			v3.TimePosition = 0
			v3.Parent = Base
			v3:Play()
			v4 = v3.TimeLength
			v52 = v3.PlaybackSpeed
			v62 = v4 / math.max(v52, 0.05)
			v7 = math.max(v62, 0.5) + 0.25
			task.delay(v7, function() --[[ Line: 1163 | Upvalues: v3 (copy) ]]
				if not (v3 and v3.Parent) then
					return
				end

				v3:Destroy()
			end)
		else
			local v8 = p1
			local v9 = v5[v8]

			if v9 then
				v9:Disconnect()
				v5[v8] = nil
			end

			v6[v8] = nil
		end
	end)
end
function t.IsValidClientCamera(p1, p2) --[[ IsValidClientCamera | Line: 1171 ]]
	if typeof(p2) ~= "Vector3" then
		return false
	end

	local v1 = if p1 then p1:FindFirstChild("Head") else p1
	local v2 = if p1 then p1:FindFirstChild("HumanoidRootPart") else p1

	if not (v1 and v2) then
		return false
	end

	return if (p2 - v1.Position).Magnitude <= 6 then (p2 - v2.Position).Magnitude <= 8 else false
end
function t.IsValidThrowDirection(p1, p2) --[[ IsValidThrowDirection | Line: 1187 ]]
	if typeof(p2) ~= "Vector3" or p2.Magnitude <= 0 then
		return false
	end

	local v1 = if p1 then p1:FindFirstChild("Head") else p1

	if not v1 then
		return false
	end

	return v1.CFrame.LookVector:Dot(p2.Unit) > -0.25
end
function t.GetCenterRayTargetPosition(p1, p2, p3) --[[ GetCenterRayTargetPosition | Line: 1200 | Upvalues: t (copy) ]]
	if typeof(p1) ~= "Vector3" or (typeof(p2) ~= "Vector3" or p2.Magnitude <= 0) then
		return nil
	end

	local Unit = p2.Unit
	local v2 = math.max(t.Settings.ArcDistance, t.Settings.LaunchSpeed * t.Settings.PredictionTime)
	local v3 = t.RaycastTrajectory(p1, Unit * v2, p3)

	if v3 then
		return v3.Position
	end

	return p1 + Unit * v2
end
function t.BuildAimTargetPosition(p1, p2, p3) --[[ BuildAimTargetPosition | Line: 1215 | Upvalues: t (copy) ]]
	if typeof(p1) == "Vector3" and (typeof(p2) == "Vector3" and not (p2.Magnitude <= 0)) then
		local Unit = p2.Unit
		local v2 = math.max(t.Settings.ArcDistance * 0.25, 8)
		local v3 = p1 + Unit * v2 + Vector3.new(0, t.Settings.ArcHeight, 0)
		local v4 = p1 + Unit * math.max(t.Settings.ArcDistance, v2)
		local v5 = v3:Lerp(v4, 0.9)
		local v6 = t.GetCenterRayTargetPosition(p1, p2, p3) or v4

		return v5:Lerp(v6 + Vector3.new(0, t.Settings.ArcHeight * 0.25 * math.clamp((v6 - p1).Magnitude / math.max(t.Settings.ArcDistance, 1), 0, 1), 0), (math.clamp(t.Settings.EndpointCenterStrength or 1, 0, 1)))
	end

	return nil
end
function t.ResolveAimDirectionFromRay(p1, p2, p3, p4) --[[ ResolveAimDirectionFromRay | Line: 1237 | Upvalues: t (copy) ]]
	if typeof(p1) ~= "Vector3" or (typeof(p2) ~= "Vector3" or (typeof(p3) ~= "Vector3" or p3.Magnitude <= 0)) then
		return nil
	end

	local v1 = t.BuildAimTargetPosition(p2, p3, p4)

	if typeof(v1) ~= "Vector3" then
		return nil
	end

	local v2 = v1 - p1

	if v2.Magnitude <= 0 then
		return nil
	end

	return v2.Unit
end
function t.IsValidClientThrowableCore(p1, p2, p3) --[[ IsValidClientThrowableCore | Line: 1255 ]]
	if typeof(p3) ~= "Vector3" or typeof(p2) ~= "Vector3" then
		return false
	end

	local v1 = if p1 then p1:FindFirstChild("Head") else p1

	if not v1 then
		return false
	end

	return if (p3 - p2).Magnitude <= 6 then (p3 - v1.Position).Magnitude <= 8 else false
end
function t.GetFixedCameraStartPosition(p1, p2) --[[ GetFixedCameraStartPosition | Line: 1269 | Upvalues: t (copy) ]]
	if typeof(p1) ~= "Vector3" or (typeof(p2) ~= "Vector3" or p2.Magnitude <= 0) then
		return nil
	end

	local Unit = p2.Unit
	local v1 = Unit:Cross(Vector3.new(0, 1, 0))
	local v2 = if v1.Magnitude <= 0.001 then Vector3.new(1, 0, 0) else v1.Unit
	local v3 = v2:Cross(Unit)
	local v4 = if v3.Magnitude <= 0.001 then Vector3.new(0, 1, 0) else v3.Unit
	local FixedCameraStartOffset = t.Settings.FixedCameraStartOffset

	return p1 + v2 * FixedCameraStartOffset.X + v4 * FixedCameraStartOffset.Y + Unit * FixedCameraStartOffset.Z
end
function t.GetFallbackServerThrowableOrigin(p1, p2, p3, p4, p5) --[[ GetFallbackServerThrowableOrigin | Line: 1293 | Upvalues: t (copy) ]]
	local v1 = t.GetFixedCameraStartPosition(p2, p3)

	if v1 then
		return v1
	end

	local v2 = if p1 then p1:FindFirstChild("Head") else p1
	local v3 = if t.IsValidClientCamera(p1, p2) and p2 then p2 else v2 and v2.Position or p2

	if typeof(v3) == "Vector3" then
		return v3 + p3.Unit * 1.5
	end

	return nil
end
function t.GetSpawnOriginFromCore(p1, p2, p3) --[[ GetSpawnOriginFromCore | Line: 1308 | Upvalues: t (copy) ]]
	if typeof(p1) ~= "Vector3" or (typeof(p2) ~= "Vector3" or p2.Magnitude <= 0) then
		return nil
	end

	local Unit = p2.Unit
	local v1 = p1 + (Unit * 0.35 + Vector3.new(0, 0.05, 0))
	local v2 = v1 - p1
	local v3 = t.RaycastTrajectory(p1, v2, p3)

	if not v3 then
		return v1
	end

	local v4 = if v2.Magnitude > 0 then v2.Unit or Unit else Unit
	local v5 = v3.Position - v4 * 0.05

	if (v5 - p1):Dot(v4) <= 0 then
		v5 = p1
	end

	return v5
end
function t.BuildThrowDataFromOrigin(p1, p2, p3, p4, p5, p6) --[[ BuildThrowDataFromOrigin | Line: 1329 | Upvalues: t (copy), Players (copy) ]]
	if typeof(p1) ~= "Vector3" or (typeof(p2) ~= "Vector3" or p2.Magnitude <= 0) then
		return nil
	end

	local Unit = p2.Unit
	local v1, v2

	if typeof(p5) == "Vector3" then
		local v3 = p1 - p5

		if v3.Magnitude > 0 then
			local v4 = t.RaycastTrajectory(p5, v3, p4)

			v1 = if v4 then v4.Position - v3.Unit * 0.05 else p1
		else
			v1 = p1
		end

		v2 = t.ResolveAimDirectionFromRay(v1, p5, Unit, p4) or Unit
	else
		v1 = p1
		v2 = Unit
	end

	local v5 = t.GetSpawnOriginFromCore(v1, v2, p4)

	if not v5 then
		return nil
	end

	local v6 = t.GetLaunchVelocity(v2)
	local t2 = { v5 }
	local v7 = 0
	local v8 = p3 * (t.Settings.GravityStrength or 1)
	local v10 = 1 / math.max(t.Settings.SimulationStepRate or 60, 1)
	local v11 = t.Settings.PreviewMaxDuration or t.Settings.PredictionTime
	local v12 = t.Settings.MaxPreviewBounces or 3
	local count = 0
	local v13 = t.IsStickyThrowable(p6)
	local v14, v15, v16

	if p6 and p6:IsA("Model") then
		if p6.Name == "Impact Grenade" then
			v14 = v5
			v15 = v6
			v16 = "Any"
		elseif p6.Name == "Molotov" then
			v14 = v5
			v15 = v6
			v16 = "Floor"
		else
			v14 = v5
			v15 = v6
			v16 = "None"
		end
	else
		v14 = v5
		v15 = v6
		v16 = "None"
	end

	local v17 = nil

	while v7 < v11 do
		local v18

		if not (#t2 < math.max(t.Settings.MaxSegments * (v12 + 1), 8)) then
			break
		end

		local v20, v21 = t.AdvanceTrajectoryState(v14, v15, v8, v10, v7)
		local v22 = t.RaycastTrajectory(v14, v20 - v14, p4)

		if v22 then
			table.insert(t2, v22.Position)

			local v23 = v22.Instance

			if v23 then
				local v24 = v23:FindFirstAncestorOfClass("Model")

				if v24 and (Players:GetPlayerFromCharacter(v24) or v24:FindFirstChildOfClass("Humanoid")) then
					v18 = v24
					v17 = v22
				else
					v18 = nil
					v17 = v22
				end
			else
				v18 = nil
				v17 = v22
			end

			local v25 = false

			if v13 or v16 == "Any" and v18 == nil or v16 == "Floor" and (v18 == nil and v22.Normal:Dot(Vector3.new(0, 1, 0)) >= 0.8191520442889918) then
				v25 = true
			end

			if v25 == true then
				break
			end

			count = count + 1

			if v12 < count then
				break
			end

			local v26 = if v18 then t.Settings.CharacterBounceEnergyMultiplier or 0.45 else t.Settings.WorldBounceEnergyMultiplier or 0.6
			local v27 = v21 - 2 * v21:Dot(v22.Normal) * v22.Normal

			if v27.Magnitude <= 0.001 then
				v27 = v22.Normal * math.max(v21.Magnitude * 0.25, 2)
			end

			local v29 = v27 * v26
			local v31 = Vector3.new(v29.X, v29.Y * (t.Settings.VerticalBounceDampening or 0.75), v29.Z)

			if v31.Magnitude <= 2 then
				break
			end

			v14 = v22.Position + v22.Normal * 0.05
			v15, v7 = v31, v7 + v10
		else
			table.insert(t2, v20)
			v14, v15, v7 = v20, v21, v7 + v10
		end
	end

	return {
		CameraPosition = p5,
		ViewDirection = Unit,
		Direction = v2,
		Origin = v5,
		Velocity = v6,
		Points = t2,
		HitResult = v17
	}
end
function t.BuildThrowDataFromInputs(p1, p2, p3, p4, p5, p6) --[[ BuildThrowDataFromInputs | Line: 1426 | Upvalues: t (copy) ]]
	if typeof(p2) ~= "Vector3" or (typeof(p3) ~= "Vector3" or p3.Magnitude <= 0) then
		return nil
	end

	local v1 = t.GetFixedCameraStartPosition(p2, p3)

	if v1 == nil then
		local v2 = if p1 then p1:FindFirstChild("Head") else p1

		v1 = (if t.IsValidClientCamera(p1, p2) and p2 then p2 else v2 and v2.Position or p2) + p3.Unit * 1.5
	end

	return t.BuildThrowDataFromOrigin(v1, p3, p4, p5, p2, p6)
end
function t.BuildClientThrowData(p1, p2, p3, p4, p5) --[[ BuildClientThrowData | Line: 1441 | Upvalues: t (copy) ]]
	if p2 and p3 then
		local v1, v2 = t.GetCrosshairThrowData(p2, p3)

		return t.BuildThrowDataFromInputs(p1, v1, v2, workspace.Gravity, p5, p4)
	end

	return nil
end
function t.PrepareThrowableModelForThrow(p1) --[[ PrepareThrowableModelForThrow | Line: 1450 | Upvalues: t7 (copy) ]]
	if p1 and p1:GetAttribute("StickRotationOffset") == nil then
		local v1 = t7[p1.Name]

		if typeof(v1) == "Vector3" then
			p1:SetAttribute("StickRotationOffset", v1)
		end
	end

	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.CanTouch = false
			v.Massless = true
			v.Anchored = true
			v.CollisionGroup = "Default"
			v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end
end
function t.ApplyReleaseState(p1, p2) --[[ ApplyReleaseState | Line: 1465 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanTouch = false
			v.CanCollide = false
			v.Anchored = true
			v.CollisionGroup = "Default"
			v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			pcall(function() --[[ Line: 1474 | Upvalues: v (copy) ]]
				v:SetNetworkOwner(nil)
			end)
		end
	end
end
function t.RegisterSimulatedThrowable(p1, p2, p3) --[[ RegisterSimulatedThrowable | Line: 1481 | Upvalues: RunService (copy), t (copy), buildImpactIgnoreList (copy), t9 (copy), v3 (copy), t11 (ref), Players (copy), playSimulatedCollisionAudio (copy), v7 (ref), v8 (ref), t10 (ref) ]]
	if RunService:IsServer() ~= true or not (p1 and p3) then
		return nil
	end

	local v1 = p2 and p2.Character or nil
	local t2 = {
		ElapsedTime = 0,
		BounceCount = 0,
		ImpactCallback = nil,
		ResolvingSticky = false,
		SimulationComplete = false,
		Model = p1,
		OwnerPlayer = p2,
		OwnerCharacter = v1,
		Position = p3.Origin,
		Velocity = p3.Velocity,
		Gravity = workspace.Gravity * (t.Settings.GravityStrength or 1),
		MaxBounces = t.Settings.MaxLiveBounces or 6,
		Sticky = t.IsStickyThrowable(p1)
	}

	t2.ImpactMode = if p1 and p1:IsA("Model") then if p1.Name == "Impact Grenade" then "Any" elseif p1.Name == "Molotov" then "Floor" else "None" else "None"
	t2.IgnoreList = buildImpactIgnoreList(p1, v1)
	t2.LastLookDirection = p3.Direction or p3.ViewDirection or (if p3.Velocity.Magnitude > 0 then p3.Velocity.Unit or Vector3.new(0, 0, 1) else Vector3.new(0, 0, 1))

	local v4 = os.clock()
	local v5 = t.Settings.SimulationStepRate or 60

	t2.StartAt = v4 + 1 / math.max(v5, 1)
	function t2.ApplyTransform(p1) --[[ ApplyTransform | Line: 1507 | Upvalues: t (ref) ]]
		if p1.ResolvingSticky == true or p1.SimulationComplete == true then
			return
		end

		if not (p1.Model and p1.Model.Parent) then
			return
		end

		if p1.Model:GetAttribute("StickyFinalizationPending") == true then
			return
		end

		local v1 = p1.Velocity.Magnitude > 0.05 and p1.Velocity.Unit or (p1.LastLookDirection or Vector3.new(0, 0, 1))

		p1.LastLookDirection = v1

		if p1.Model:GetAttribute("StickResolved") ~= true then
			p1.Model:PivotTo(CFrame.lookAt(p1.Position, p1.Position + v1))
		end

		p1.Model:SetAttribute("SimulatedThrowableActive", true)
		p1.Model:SetAttribute("SimulatedThrowableX", p1.Position.X)
		p1.Model:SetAttribute("SimulatedThrowableY", p1.Position.Y)
		p1.Model:SetAttribute("SimulatedThrowableZ", p1.Position.Z)
		p1.Model:SetAttribute("SimulatedThrowableVelocityX", p1.Velocity.X)
		p1.Model:SetAttribute("SimulatedThrowableVelocityY", p1.Velocity.Y)
		p1.Model:SetAttribute("SimulatedThrowableVelocityZ", p1.Velocity.Z)
		p1.Model:SetAttribute("SimulatedThrowableSpeed", p1.Velocity.Magnitude)
		p1.Model:SetAttribute("ImpactResolved", false)

		if p1.Sticky == true then
			p1.Model:SetAttribute("StickResolved", p1.Model:GetAttribute("StickResolved") == true)
		end

		t.RecordReplayTransform(p1.Model, p1.OwnerPlayer, p1.Position, p1.Velocity, v1, false)
	end
	function t2.Finish(p1, p2, p3) --[[ Finish | Line: 1538 | Upvalues: t (ref), t9 (ref) ]]
		if typeof(p2) == "Vector3" then
			p1.Position = p2 + (if typeof(p3) == "Vector3" then p3.Unit or Vector3.new(0, 0, 0) else Vector3.new(0, 0, 0)) * 0.03
			p1.Velocity = Vector3.new(0, 0, 0)
			p1:ApplyTransform()
			t.RecordReplayTransform(p1.Model, p1.OwnerPlayer, p1.Position, p1.Velocity, p1.LastLookDirection, true)
		end

		p1.SimulationComplete = true

		local Model = p1.Model

		if not t9[Model] then
			return
		end

		t9[Model] = nil

		if not (Model and Model.Parent) then
			return
		end

		Model:SetAttribute("SimulatedThrowableActive", false)
	end
	function t2.ResolveSticky(p1, p2) --[[ ResolveSticky | Line: 1550 | Upvalues: v3 (ref), t9 (ref), t11 (ref) ]]
		if p1.ResolvingSticky == true or p1.SimulationComplete == true then
			return
		end

		p1.ResolvingSticky = true
		p1.SimulationComplete = true

		if p1.Model and p1.Model.Parent then
			p1.Model:SetAttribute("StickyFinalizationPending", true)
		end

		local Model = p1.Model
		local v1 = v3[Model]

		if v1 then
			v1:Disconnect()
			v3[Model] = nil
		end

		local Model2 = p1.Model

		if t9[Model2] then
			t9[Model2] = nil

			if Model2 and Model2.Parent then
				Model2:SetAttribute("SimulatedThrowableActive", false)
			end
		end

		table.insert(t11, {
			Model = p1.Model,
			OwnerPlayer = p1.OwnerPlayer,
			HitResult = p2
		})
	end
	function t2.ResolveImpact(p1, p2) --[[ ResolveImpact | Line: 1568 | Upvalues: t (ref), t9 (ref) ]]
		p1.Model:SetAttribute("ImpactResolved", true)
		t.RecordReplayImpactResolved(p1.Model, p1.OwnerPlayer, p2)

		local Model = p1.Model

		if t9[Model] then
			t9[Model] = nil

			if Model and Model.Parent then
				Model:SetAttribute("SimulatedThrowableActive", false)
			end
		end

		if not p1.ImpactCallback then
			return
		end

		p1.ImpactCallback(p2)
	end
	function t2.Advance(p1, p2) --[[ Advance | Line: 1577 | Upvalues: t (ref), Players (ref), playSimulatedCollisionAudio (ref) ]]
		if p1.ResolvingSticky == true or p1.SimulationComplete == true then
			return
		end

		if p1.Model and p1.Model:GetAttribute("StickyFinalizationPending") == true then
			return
		end

		if p1.StartAt and os.clock() < p1.StartAt then
			p1:ApplyTransform()

			return
		end

		local v1, v2 = t.AdvanceTrajectoryState(p1.Position, p1.Velocity, p1.Gravity, p2, p1.ElapsedTime)
		local v3 = t.RaycastTrajectory(p1.Position, v1 - p1.Position, p1.IgnoreList)

		if not v3 then
			p1.Position = v1
			p1.Velocity = v2
			p1.ElapsedTime = p1.ElapsedTime + p2
			p1:ApplyTransform()

			return
		end

		local v4 = v3.Instance
		local v5

		if v4 then
			local v6 = v4:FindFirstAncestorOfClass("Model")

			v5 = if v6 and (Players:GetPlayerFromCharacter(v6) or v6:FindFirstChildOfClass("Humanoid")) then v6 else nil
		else
			v5 = nil
		end

		if p1.Sticky == true then
			p1:ResolveSticky(v3)

			return
		end

		if p1.ImpactMode == "Any" and v5 == nil then
			p1:ResolveImpact(v3)

			return
		end

		if p1.ImpactMode == "Floor" and (v5 == nil and v3.Normal:Dot(Vector3.new(0, 1, 0)) >= 0.8191520442889918) then
			p1:ResolveImpact(v3)

			return
		end

		p1.BounceCount = p1.BounceCount + 1

		local v7 = if v5 then t.Settings.CharacterBounceEnergyMultiplier or 0.45 else t.Settings.WorldBounceEnergyMultiplier or 0.6
		local v8 = v2 - 2 * v2:Dot(v3.Normal) * v3.Normal

		if v8.Magnitude <= 0.001 then
			v8 = v3.Normal * math.max(v2.Magnitude * 0.25, 2)
		end

		local v10 = v8 * v7
		local v12 = Vector3.new(v10.X, v10.Y * (t.Settings.VerticalBounceDampening or 0.75), v10.Z)

		playSimulatedCollisionAudio(p1.Model)

		if p1.BounceCount > p1.MaxBounces or v12.Magnitude <= 2 then
			p1:Finish(v3.Position, v3.Normal)
		else
			p1.Position = v3.Position + v3.Normal * 0.05
			p1.Velocity = v12
			p1.ElapsedTime = p1.ElapsedTime + p2
			p1:ApplyTransform()
		end
	end
	t9[p1] = t2
	t2:ApplyTransform()

	if RunService:IsServer() ~= true then
		return t2
	end

	if v7 then
		return t2
	end

	v7 = RunService.Heartbeat:Connect(function(p13) --[[ Line: 608 | Upvalues: v8 (ref), t (ref), t10 (ref), t11 (ref), t9 (ref) ]]
		v8 = v8 + p13

		local v2 = 1 / math.max(t.Settings.SimulationStepRate or 60, 1)
		local count2 = 0

		while v2 <= v8 and count2 < 4 do
			v8 = v8 - v2
			count2 = count2 + 1

			local v3 = t10

			t10 = t11
			t11 = {}

			for k2, v in pairs(t9) do
				if k2 and (k2.Parent and v) then
					if v.Advance then
						v:Advance(v2)
					end

					continue
				end

				t9[k2] = nil
			end

			for i2, v in ipairs(v3) do
				local Model = v.Model

				if Model and (Model.Parent and Model:GetAttribute("StickResolved") ~= true) then
					t.ApplyStickyImpact(Model, v.HitResult, v.OwnerPlayer, false)
				end
			end
		end

		if not (v2 * 4 < v8) then
			return
		end

		v8 = v2
	end)

	return t2
end
function t.ApplyLaunchPhysics(p1, p2, p3) --[[ ApplyLaunchPhysics | Line: 1639 ]] end
function t.EnsureReplayIdentity(p1, p2) --[[ EnsureReplayIdentity | Line: 1643 | Upvalues: ensureReplayThrowableId (copy) ]]
	return ensureReplayThrowableId(p1, p2)
end
function t.RecordReplaySpawn(p1, p2, p3) --[[ RecordReplaySpawn | Line: 1647 | Upvalues: appendReplayThrowableEventForModel (copy), v9 (copy) ]]
	if typeof(p3) ~= "table" then
		return
	end

	local t = {
		CFrame = typeof(p3.Origin) == "Vector3" and CFrame.new(p3.Origin, p3.Origin + (p3.Direction or p3.ViewDirection or Vector3.new(0, 0, 1))) or nil,
		Velocity = p3.Velocity
	}

	t.LookDirection = p3.Direction or p3.ViewDirection
	appendReplayThrowableEventForModel(p1, p2, "Spawn", t)
	v9[p1] = {
		LastTransformAt = os.clock()
	}
end
function t.RecordReplayTransform(p1, p2, p3, p4, p5, p6) --[[ RecordReplayTransform | Line: 1663 | Upvalues: v9 (copy), appendReplayThrowableEventForModel (copy) ]]
	if not p1 or typeof(p3) ~= "Vector3" then
		return
	end

	local v1 = os.clock()
	local v2 = v9[p1]

	if not v2 then
		v2 = {}
		v9[p1] = v2
	end

	if p6 ~= true and (typeof(v2.LastTransformAt) == "number" and v1 - v2.LastTransformAt < 0.03333333333333333) then
		return
	end

	v2.LastTransformAt = v1
	appendReplayThrowableEventForModel(p1, p2, "Sample", {
		CFrame = CFrame.new(p3, p3 + (p5 or Vector3.new(0, 0, 1))),
		Velocity = p4,
		LookDirection = p5
	})
end
function t.RecordReplayStickyResolved(p1, p2, p3) --[[ RecordReplayStickyResolved | Line: 1685 | Upvalues: appendReplayThrowableEventForModel (copy), buildReplayAttachmentPayload (copy) ]]
	if not p1 or typeof(p3) ~= "table" then
		return
	end

	if typeof(p3.Position) ~= "Vector3" then
		return
	end

	if typeof(p3.Normal) == "Vector3" then
		appendReplayThrowableEventForModel(p1, p2, "StickyResolved", {
			CFrame = CFrame.new(p3.Position, p3.Position + p3.Normal),
			Attachment = buildReplayAttachmentPayload(p3.Instance)
		})
	end
end
function t.RecordReplayImpactResolved(p1, p2, p3) --[[ RecordReplayImpactResolved | Line: 1695 | Upvalues: appendReplayThrowableEventForModel (copy) ]]
	if not p1 or typeof(p3) ~= "table" then
		return
	end

	if typeof(p3.Position) ~= "Vector3" then
		return
	end

	if typeof(p3.Normal) ~= "Vector3" then
		return
	end

	appendReplayThrowableEventForModel(p1, p2, "ImpactResolved", {
		CFrame = CFrame.new(p3.Position + p3.Normal * (if p1.Name == "Molotov" then 0.15 else 0.3), p3.Position),
		Normal = p3.Normal
	})
end
function t.RecordReplayMilestone(p1, p2, p3, p4) --[[ RecordReplayMilestone | Line: 1706 | Upvalues: appendReplayThrowableEventForModel (copy) ]]
	appendReplayThrowableEventForModel(p1, p2, p3, p4)
end
function t.RecordReplayDestroy(p1, p2) --[[ RecordReplayDestroy | Line: 1710 | Upvalues: appendReplayThrowableEventForModel (copy), v9 (copy) ]]
	appendReplayThrowableEventForModel(p1, p2, "Destroy", nil)
	v9[p1] = nil
end
function t.new(p1) --[[ new | Line: 1715 | Upvalues: t3 (copy) ]]
	local v2 = setmetatable({}, t3)

	v2.Instance = p1

	return v2
end
function t.EnableCollisionAudio(p1, p2) --[[ EnableCollisionAudio | Line: 1721 | Upvalues: t (copy) ]]
	t.SetupThrowableCollisionAudio(p1.Instance, p2)
end
function t2.EnsureReplayIdentity(p1, p2) --[[ EnsureReplayIdentity | Line: 1725 | Upvalues: t (copy) ]]
	return t.EnsureReplayIdentity(p1.Instance, p2)
end
function t2.RecordReplaySpawn(p1, p2, p3) --[[ RecordReplaySpawn | Line: 1729 | Upvalues: t (copy) ]]
	return t.RecordReplaySpawn(p1.Instance, p2, p3)
end
function t2.RecordReplayTransform(p1, p2, p3, p4, p5, p6) --[[ RecordReplayTransform | Line: 1733 | Upvalues: t (copy) ]]
	return t.RecordReplayTransform(p1.Instance, p2, p3, p4, p5, p6)
end
function t2.RecordReplayStickyResolved(p1, p2, p3) --[[ RecordReplayStickyResolved | Line: 1737 | Upvalues: t (copy) ]]
	return t.RecordReplayStickyResolved(p1.Instance, p2, p3)
end
function t2.RecordReplayImpactResolved(p1, p2, p3) --[[ RecordReplayImpactResolved | Line: 1741 | Upvalues: t (copy) ]]
	return t.RecordReplayImpactResolved(p1.Instance, p2, p3)
end
function t2.RecordReplayMilestone(p1, p2, p3, p4) --[[ RecordReplayMilestone | Line: 1745 | Upvalues: t (copy) ]]
	return t.RecordReplayMilestone(p1.Instance, p2, p3, p4)
end
function t2.RecordReplayDestroy(p1, p2) --[[ RecordReplayDestroy | Line: 1749 | Upvalues: t (copy) ]]
	return t.RecordReplayDestroy(p1.Instance, p2)
end
function t.EnsureReplayIdentityForOwner(p1, p2) --[[ EnsureReplayIdentityForOwner | Line: 1753 ]]
	return p1:EnsureReplayIdentity(p2)
end
function t.RecordReplaySpawnForOwner(p1, p2, p3) --[[ RecordReplaySpawnForOwner | Line: 1757 ]]
	return p1:RecordReplaySpawn(p2, p3)
end
function t.RecordReplayTransformForOwner(p1, p2, p3, p4, p5, p6) --[[ RecordReplayTransformForOwner | Line: 1761 ]]
	return p1:RecordReplayTransform(p2, p3, p4, p5, p6)
end
function t.RecordReplayStickyResolvedForOwner(p1, p2, p3) --[[ RecordReplayStickyResolvedForOwner | Line: 1765 ]]
	return p1:RecordReplayStickyResolved(p2, p3)
end
function t.RecordReplayImpactResolvedForOwner(p1, p2, p3) --[[ RecordReplayImpactResolvedForOwner | Line: 1769 ]]
	return p1:RecordReplayImpactResolved(p2, p3)
end
function t.RecordReplayMilestoneForOwner(p1, p2, p3, p4) --[[ RecordReplayMilestoneForOwner | Line: 1773 ]]
	return p1:RecordReplayMilestone(p2, p3, p4)
end
function t.RecordReplayDestroyForOwner(p1, p2) --[[ RecordReplayDestroyForOwner | Line: 1777 ]]
	return p1:RecordReplayDestroy(p2)
end
function t.IsBarricadeDamageAllowed() --[[ IsBarricadeDamageAllowed | Line: 1781 | Upvalues: Server (copy), Workspace (copy), t4 (copy) ]]
	if Server:GetAttribute("Phase") ~= "Round Started" then
		return false
	end

	local v1 = Server:GetAttribute("RoundStartedAt")
	local v2 = if typeof(v1) == "number" then v1 else nil

	if v2 == nil then
		return true
	end

	return Workspace:GetServerTimeNow() - v2 >= t4.BarricadeDamageGracePeriod
end
function t.Init(p1) --[[ Init | Line: 1785 ]] end
function t.DamageSurround(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10) --[[ DamageSurround | Line: 1789 | Upvalues: Players (copy), Server (copy), Workspace (copy), t4 (copy), CollectionService (copy), Map (copy) ]]
	local v1 = p3 or 10
	local v2 = p4 or 10
	local v3 = p5 or 1
	local v4 = p9 or p1.Instance.Base.Position
	local v5 = Players:GetChildren()
	local InvasionAIFolder = workspace:FindFirstChild("InvasionAIFolder")

	if Server:GetAttribute("GameMode") == "Invasion" and InvasionAIFolder then
		for i, v in ipairs(InvasionAIFolder:GetChildren()) do
			table.insert(v5, v)
		end
	end

	for k, v in pairs(v5) do
		task.spawn(function() --[[ Line: 1804 | Upvalues: v (copy), Players (ref), v4 (copy), p6 (copy), v2 (copy), InvasionAIFolder (copy), p2 (copy), p1 (copy), v1 (copy), p10 (copy), p7 (copy), p8 (copy) ]]
			if v.Parent == Players and (v.Character and v.Character:FindFirstChild("HumanoidRootPart") == nil) then
				return nil
			end

			local v12 = v.Parent == Players and v.Character or v
			local Magnitude = (v12.HumanoidRootPart.Position - v4).Magnitude
			local v22 = p6 or v2

			if not (if v.Parent == InvasionAIFolder then true else false) and (v ~= p2 and v.Team == p2.Team or not (Magnitude < v22)) then
				return
			end

			local t = { p1.Instance }
			local Unit = (v12.HumanoidRootPart.Position - v4).Unit
			local v42

			repeat
				local v5 = workspace:FindPartOnRayWithIgnoreList(Ray.new(v4, Unit * v22), t, false, true)
				local v6

				if v5 and (v5.Transparency == 1 and v5.Name ~= "HumanoidRootPart") then
					table.insert(t, v5)
					v6 = true
					v42 = v5

					continue
				end

				v42 = v5
				v6 = false
			until not v6

			if not (v42 and v42:IsDescendantOf(v12)) then
				return
			end

			local v7 = v1

			if v2 < Magnitude then
				v7 = math.floor(v7 * math.clamp(1 - (Magnitude - v2) / (v22 - v2) - 0.1, 0, 1))
			end

			if v.Parent == Players then
				p1:DamageFunction(p2, v, v7, p1.Instance.Name, v4, p10)
			else
				p1:DamageBots(p2, v12, v7, p1.Instance.Name)
			end

			if p7 ~= "Flash" or v.Parent ~= Players then
				return
			end

			local v11 = 0

			if v12:GetAttribute(p7) == nil then
				v12:SetAttribute(p7, 0)
			end

			local Magnitude2 = (v12.Head.Position + v12.Head.CFrame.LookVector * Magnitude - p1.Instance.Base.Position).Magnitude

			if Magnitude < v2 / 1.4 then
				v11 = if Magnitude + Magnitude * 0.1 < Magnitude2 then 1 else 2
				v12:SetAttribute(p7, v12:GetAttribute(p7) + v11)
			elseif Magnitude2 < Magnitude + Magnitude * 0.1 then
				v11 = 2
				v12:SetAttribute(p7, v12:GetAttribute(p7) + v11)
			end

			delay(p8 or 1, function() --[[ Line: 1866 | Upvalues: v12 (copy), p7 (ref), v11 (ref) ]]
				if not v12 then
					return
				end

				v12:SetAttribute(p7, v12:GetAttribute(p7) - v11)
			end)
		end)
	end

	local v6

	if Server:GetAttribute("Phase") == "Round Started" then
		local v7 = Server:GetAttribute("RoundStartedAt")
		local v8 = if typeof(v7) == "number" then v7 else nil

		v6 = if v8 == nil then true elseif Workspace:GetServerTimeNow() - v8 >= t4.BarricadeDamageGracePeriod then true else false
	else
		v6 = false
	end

	if v6 ~= true then
		return
	end

	local list = {}

	for k, v in pairs(CollectionService:GetTagged("BarricadeFrame")) do
		if v:IsDescendantOf(Map) then
			for k2, v7 in pairs(v:GetDescendants()) do
				if v7.Name == "BarricadePlank" and (v7:GetAttribute("Health") and (v7:GetAttribute("Health") > 0 and (v7.Position - p1.Instance.Base.Position).Magnitude < v2)) then
					table.insert(list, v7)
				end
			end
		end
	end

	table.sort(list, function(p12, p2) --[[ Line: 1889 | Upvalues: p1 (copy) ]]
		return (p12.Position - p1.Instance.Base.Position).Magnitude < (p2.Position - p1.Instance.Base.Position).Magnitude
	end)

	for i, v in ipairs(list) do
		if i <= v3 then
			v:SetAttribute("Health", 0)
		end
	end
end
function t.DamageBots(p1, p2, p3, p4, p5) --[[ DamageBots | Line: 1901 | Upvalues: ReplicatedStorage (copy), Config (copy), v1 (ref), Players (copy) ]]
	local Humanoid = p3:FindFirstChild("Humanoid")
	local v2 = math.clamp(p4, 0, Humanoid.Health + 0.1)

	Humanoid:TakeDamage(v2)

	local v3 = nil
	local v4 = if Humanoid.Health <= 0 then true else nil

	if p4 >= 100 then
		v3 = true
	end

	if v4 == true then
		ReplicatedStorage.GameEvents.KillFeed:FireAllClients(p2, p3, p5, v3)
		ReplicatedStorage.GameEvents.HitMarker:FireClient(p2)
		p3.Parent = game.Workspace.Map_Cache
		delay(2, function() --[[ Line: 1916 | Upvalues: p3 (copy) ]]
			p3:Destroy()
		end)
	end

	local t = {
		Kills = 0,
		Deaths = 0,
		Damage = 0,
		Experience = 0,
		Cash = 0,
		Headshots = 0,
		Points = 0,
		EventPoints = 0,
		SourcePlayer = p2
	}

	if v4 then
		t.Kills = t.Kills + 1
		t.Cash = t.Cash + Config.RewardCash.Kill
		t.Experience = t.Experience + Config.RewardExperience.Kill
		t.Points = t.Points + Config.RewardPoints.Kill
	end

	if v3 then
		t.Headshots = t.Headshots + 1
		t.Cash = t.Cash + Config.RewardCash.Headshot
		t.Experience = t.Experience + Config.RewardExperience.Headshot
		t.Points = t.Points + Config.RewardPoints.Headshot
	end

	t.Damage = v2

	if v1 == nil then
		v1 = require(ReplicatedStorage.ComponentsManager)
	end

	v1.Player.UpdatePlayerStats(p2, t, if p3.Parent == Players then nil else true)
	t.KilledName = "Bot"
	ReplicatedStorage.GameEvents.PointsFeed:FireClient(p2, t)
	ReplicatedStorage.GameEvents.RefreshTopBorder:FireAllClients()
end
function t.DamageFunction(p1, p2, p3, p4, p5, p6, p7) --[[ DamageFunction | Line: 1945 | Upvalues: Server (copy), ReplicatedStorage (copy), v1 (ref), appendReplayDeathEventIfAvailable (copy), Config (copy), Players (copy), fireKillCamIfEnabled (copy), v2 (ref) ]]
	local Humanoid = p3.Character:FindFirstChild("Humanoid")

	if not (Humanoid.Health > 0) or Server:GetAttribute("AntiPlayerDamage") ~= false then
		return
	end

	local v22 = math.clamp(p4, 0, Humanoid.Health + 0.1)
	local Character = p3.Character
	local v3 = if Humanoid.Health <= v22 then true else false

	if v3 and (p2 and Character) then
		local Character2 = p2.Character
		local v4 = if Character2 then Character2:FindFirstChild("HumanoidRootPart") else Character2
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			local v5 = nil

			if typeof(p6) == "Vector3" then
				local v6 = HumanoidRootPart.Position - p6

				if v6.Magnitude > 0 then
					v5 = v6.Unit
				end
			elseif v4 then
				local v7 = HumanoidRootPart.Position - v4.Position

				if v7.Magnitude > 0 then
					v5 = v7.Unit
				end
			end

			if v5 then
				ReplicatedStorage.GameEvents.VerifiedDamageFeedback:FireClient(p2, Character, true)

				local t = {
					hitPartName = "Torso",
					isPlayerKill = true,
					killerPlayer = p2,
					pushDirection = v5,
					sourcePosition = p6,
					impulseProfile = p7 or "projectile"
				}

				t.motionProfile = if p7 == "explosion" then "explosion" elseif p7 == "lingering_area" then "lingering_area" else "projectile_body"
				t.carryVelocity = Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.AssemblyLinearVelocity or (Character:FindFirstChild("Torso") and Character.Torso.AssemblyLinearVelocity or Vector3.new(0, 0, 0))

				if v1 == nil then
					v1 = require(ReplicatedStorage.ComponentsManager)
				end

				v1.Ragdoll.StoreDeathContext(Character, t)
				appendReplayDeathEventIfAvailable(p2, p3, t)
			end
		end
	end

	Humanoid:TakeDamage(v22)

	if v3 and (p2 and Character) then
		if v1 == nil then
			v1 = require(ReplicatedStorage.ComponentsManager)
		end

		v1.Ragdoll.BeginLethalTransition(Character)

		if Humanoid.Health <= 0 then
			if v1 == nil then
				v1 = require(ReplicatedStorage.ComponentsManager)
			end

			v1.Ragdoll.FinishActivation(Character)
		end
	end

	if Config.DamageFeedbackMode == "FakeBlood" and v22 > 0 then
		ReplicatedStorage.GameEvents.VerifiedDamageFeedback:FireClient(p2, p3.Character, false)
	end

	if v22 > 0 and (p2 and p2.Parent == Players) then
		local t = {
			HitPartName = "Torso",
			TargetUserId = p3.UserId,
			Damage = v22
		}

		t.ForceFeedback = v3 == true

		local ReplayKillCamService = shared.ReplayKillCamService

		if typeof(ReplayKillCamService) == "table" then
			local AppendReplayEvent = ReplayKillCamService.AppendReplayEvent

			if typeof(AppendReplayEvent) == "function" then
				AppendReplayEvent(p2, "VerifiedHit", t)
			end
		end

		local t2 = {
			HitPartName = "Torso",
			SourceUserId = p2.UserId,
			Damage = v22
		}
		local ReplayKillCamService2 = shared.ReplayKillCamService

		if typeof(ReplayKillCamService2) == "table" then
			local AppendReplayEvent = ReplayKillCamService2.AppendReplayEvent

			if typeof(AppendReplayEvent) == "function" then
				AppendReplayEvent(p3, "DamageTaken", t2)
			end
		end
	end

	local v11 = nil
	local v122 = if Humanoid.Health <= 0 then true else nil

	if p4 >= 100 then
		v11 = true
	end

	if v122 == true then
		fireKillCamIfEnabled(p3, p2)

		local ReplayKillCamService = shared.ReplayKillCamService

		if typeof(ReplayKillCamService) == "table" then
			local QueueReplayClipForKill = ReplayKillCamService.QueueReplayClipForKill

			if typeof(QueueReplayClipForKill) == "function" then
				QueueReplayClipForKill(p2, p3, "Throwable")
			end
		end

		ReplicatedStorage.GameEvents.KillFeed:FireAllClients(p2, p3, p5, v11)
		ReplicatedStorage.GameEvents.HitMarker:FireClient(p2)

		if v2 == nil then
			v2 = require(ReplicatedStorage.Components.Challenges)
		end

		v2.UpdateChallenge(p2, "Grenade Kill", 1)

		if p5 == "Molotov" then
			if v2 == nil then
				v2 = require(ReplicatedStorage.Components.Challenges)
			end

			v2.UpdateChallenge(p2, "Molotov Kill", 1)
		end
	end

	local t = {
		Kills = 0,
		Deaths = 0,
		Damage = 0,
		Experience = 0,
		Cash = 0,
		Headshots = 0,
		Points = 0,
		EventPoints = 0,
		SourcePlayer = p2
	}

	if v122 then
		t.Kills = t.Kills + 1
		t.Cash = t.Cash + Config.RewardCash.Kill
		t.Experience = t.Experience + Config.RewardExperience.Kill
		t.Points = t.Points + Config.RewardPoints.Kill
	end

	if v11 then
		t.Headshots = t.Headshots + 1
		t.Cash = t.Cash + Config.RewardCash.Headshot
		t.Experience = t.Experience + Config.RewardExperience.Headshot
		t.Points = t.Points + Config.RewardPoints.Headshot
	end

	t.Damage = v22

	if v1 == nil then
		v1 = require(ReplicatedStorage.ComponentsManager)
	end

	v1.Player.UpdatePlayerStats(p2, t)
	t.KilledName = p3.Name
	ReplicatedStorage.GameEvents.PointsFeed:FireClient(p2, t)

	local t2 = {
		Kills = 0,
		Deaths = 1,
		Damage = 0,
		Experience = 0,
		Cash = 0,
		Headshots = 0,
		Points = 0
	}

	if v122 == true then
		if v1 == nil then
			v1 = require(ReplicatedStorage.ComponentsManager)
		end

		v1.Player.UpdatePlayerStats(p3, t2)
	end

	ReplicatedStorage.GameEvents.RefreshTopBorder:FireAllClients()
end

return t