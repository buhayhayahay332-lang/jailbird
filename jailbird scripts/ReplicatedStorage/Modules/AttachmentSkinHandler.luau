-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AttachmentChallenges = require(ReplicatedStorage.Modules:WaitForChild("AttachmentChallenges"))

require(ReplicatedStorage.Modules.TypeModules.Types)

local v1 = ("[%*]"):format(script.Name)
local t = {}

if RunService:IsServer() then
	local t2 = {
		Extra = true,
		Grip = true,
		Muzzle = true,
		Sight = true
	}
	local Weapon = ReplicatedStorage.Items.Weapon

	local function registerWeaponStatsForWeapon(p1, p2) --[[ registerWeaponStatsForWeapon | Line: 40 ]]
		local v1 = if typeof(p1) == "string" then true else false

		assert(v1, "Cannot register weapon stats with an invalid weapon name \"" .. tostring(p1) .. "\"")

		local v3 = if typeof(p2) == "Instance" then p2:IsA("Folder") else false

		assert(v3, "Cannot register weapon stats because weaponStatsFolder is invalid: " .. tostring(p2))

		local v5 = Instance.new("StringValue")

		v5.Name = p1
		v5.Value = p1
		v5:SetAttribute("kills", 0)
		v5:SetAttribute("headshots", 0)
		v5:SetAttribute("wins", 0)
		v5:SetAttribute("damage", 0)
		v5.Parent = p2
	end

	function t.rewardAttachmentSkin(p1, p2, p3, p4, p5) --[[ rewardAttachmentSkin | Line: 58 ]]
		local v1 = Instance.new("StringValue")

		v1.Name = p1
		v1.Value = p1
		v1:SetAttribute("Name", p2.skinName)
		v1:SetAttribute("Type", "AttachmentSkin")
		v1:SetAttribute("Weapon", p4)
		v1:SetAttribute("ChallengeType", p2.challengeType)
		v1:SetAttribute("Requirement", p2.requirement)
		v1:SetAttribute("Slot", p5)

		if p3.ItemsLog:FindFirstChild(p1) == nil then
			local v2 = Instance.new("StringValue")

			v2.Name = p1
			v2:SetAttribute("Name", p2.skinName)
			v2:SetAttribute("Type", "AttachmentSkin")
			v2:SetAttribute("Slot", p5)
			v2:SetAttribute("Seen", false)
			v2:SetAttribute("AttachmentType", p5)
			v2:SetAttribute("Weapon", p4)
			v2.Parent = p3.ItemsLog
		end

		v1.Parent = p3.Inventory
	end
	function t.test(p1, p2, p3) --[[ test | Line: 90 | Upvalues: Weapon (copy), t2 (copy), AttachmentChallenges (copy), t (copy) ]]
		local v1 = Weapon:FindFirstChild(p2)

		assert(if v1 == nil then false else true, "Could not find a weapon model for model \"" .. tostring(p1) .. "\"")

		local t3 = {}
		local v4 = false

		for v5, v6 in v1.Nodes:GetChildren() do
			local v7 = v6.Name

			if t2[v6.Name] then
				local v8 = p1:GetAttribute(AttachmentChallenges[v7][1].challengeType)

				for v9, v10 in AttachmentChallenges[v6.Name] do
					if v10.requirement <= v8 then
						local skinName = v10.skinName
						local v11 = skinName .. v7 .. p2

						if not (if p3.Inventory:FindFirstChild(v11) == nil then false else true) then
							table.insert(t3, {
								weaponName = p2,
								skinName = skinName,
								attachmentSlotName = v7
							})
							t.rewardAttachmentSkin(v11, v10, p3, p2, v7)
							v4 = true
						end
					end
				end
			end
		end

		return v4, t3
	end
	function t.rewardCompletedChallenges(p1, p2) --[[ rewardCompletedChallenges | Line: 129 | Upvalues: t (copy), ReplicatedStorage (copy) ]]
		local v1 = false

		for v2, v3 in p1.WeaponStats:GetChildren() do
			v1 = t.test(v3, tostring(v3), p1) or v1
		end

		if not v1 then
			return
		end

		ReplicatedStorage.Events.ReceivedItems:FireClient(p2)
	end
	function t.createWeaponStatsForUnregisteredWeapons(p1) --[[ createWeaponStatsForUnregisteredWeapons | Line: 142 | Upvalues: ReplicatedStorage (copy), v1 (copy), registerWeaponStatsForWeapon (copy) ]]
		for v12, v2 in ReplicatedStorage.Items.Weapon:GetChildren() do
			if v2:IsA("Model") then
				local v3 = v2.Name

				if not (p1.WeaponStats:FindFirstChild(v3) ~= nil) then
					registerWeaponStatsForWeapon(v3, p1.WeaponStats)
				end

				continue
			end

			warn((("%* There is a weapon model inside ReplicatedStorage.Items.Weapon that is not a model: %*"):format(v1, (tostring(v2)))))
		end
	end

	return t
end

local LocalPlayer = Players.LocalPlayer
local Config = require(ReplicatedStorage.Config)
local isLobbyID = game.PlaceId == Config.LobbyID
local LocalPlayer2 = Players.LocalPlayer
local v2 = isLobbyID and LocalPlayer2.PlayerGui:WaitForChild("Main", 30):WaitForChild("Pages"):WaitForChild("Loadout"):WaitForChild("SkinAttachmentFrame")
local Inventory = Players.LocalPlayer:WaitForChild("PlayerData", 60):WaitForChild("Inventory")
local AttachmentSkin = ReplicatedStorage:WaitForChild("Items"):WaitForChild("AttachmentSkin")
local Cache = script:WaitForChild("Cache")
local AttachmentSkinUITemplate = script:WaitForChild("AttachmentSkinUITemplate")
local t2 = {
	Grip = true,
	Sight = true,
	Muzzle = true,
	Extra = true
}

local function getWeaponName(p1) --[[ getWeaponName | Line: 190 | Upvalues: LocalPlayer2 (copy) ]]
	return LocalPlayer2.PlayerData.Loadout:FindFirstChild(LocalPlayer2.PlayerData.Settings:GetAttribute("LoadoutName")):GetAttribute(p1 .. "Weapon")
end

local function clearUI() --[[ clearUI | Line: 195 | Upvalues: v2 (copy), Cache (copy) ]]
	for v1, v22 in v2.AttachmentSkinScroller:GetChildren() do
		if v22:IsA("Frame") then
			v22.Parent = Cache
		end
	end
end

local function upper(p1) --[[ upper | Line: 203 ]]
	return string.upper(p1)
end

local function formatNumber(p1) --[[ formatNumber | Line: 207 ]]
	local v2 = tostring((math.floor(p1)))
	local v3

	if v2:sub(1, 1) == "-" then
		v2, v3 = v2:sub(2), "-"
	else
		v3 = ""
	end

	return v3 .. v2:reverse():gsub("(%d%d%d)", "%1 "):reverse():gsub("^ ", "")
end

local function updateProgressLabel(p1, p2) --[[ updateProgressLabel | Line: 220 | Upvalues: v1 (copy), v2 (copy), upper (copy), formatNumber (copy) ]]
	local WeaponStats = game:GetService("Players").LocalPlayer.PlayerData.WeaponStats

	assert(if WeaponStats == nil then false else true, "WeaponStats folder is missing")

	local v22 = WeaponStats:FindFirstChild(p2)

	assert(v22, (("%* tried to retreieve gun stats for weapon \"%*\" but it does not exist"):format(v1, (tostring(p2)))))

	local v4 = v22:GetAttribute(p1.challengeType)

	assert(typeof(v4) == "number", (("%* the \"%*\" stat is invalid: %*"):format(v1, tostring(p1.challengeType), (tostring(v4)))))

	local requirement = p1.requirement

	assert(typeof(requirement) == "number", (("%* the \"goal\" variable is invalid: %*"):format(v1, (tostring(requirement)))))
	v2.ProgressLabel.Text = ("%*  \226\128\148  %* / %*"):format(string.gsub(p1.challengeType, "^%l", upper), formatNumber(v4), (formatNumber(requirement)))
end

local function createButton(p1, p2, p3, p4, p5, p6, p7) --[[ createButton | Line: 238 | Upvalues: AttachmentSkinUITemplate (copy), AttachmentSkin (copy), v2 (copy), ReplicatedStorage (copy), updateProgressLabel (copy) ]]
	local v1 = AttachmentSkinUITemplate:Clone()

	v1.Name = p2
	v1.Frame.UIStroke.Thickness = 0

	local v22 = AttachmentSkin:FindFirstChild(p3)

	assert(v22, (("Attachment skin with the name \"%*\" does not exist"):format(p3)))
	v1.Frame.ImageLabel.Image = v22.Texture
	v1.LayoutOrder = p5

	if p4 then
		v1.LockedOverlay.Visible = false

		local function onAttachmentSkinButtonPressed() --[[ onAttachmentSkinButtonPressed | Line: 253 | Upvalues: p3 (copy), p7 (copy), p1 (copy), v2 (ref), ReplicatedStorage (ref), updateProgressLabel (ref), p6 (copy) ]]
			v2.Parent:SetAttribute("RecentItemName", "AttachmentSkin")
			ReplicatedStorage.Events.Equip:FireServer({
				Type = "AttachmentSkin",
				Name = p3,
				Slot = p7,
				Weapon = p1
			})
			updateProgressLabel(p6, p1)
		end

		v1.Button.MouseButton1Down:Connect(onAttachmentSkinButtonPressed)
	else
		local function onAttachmentSkinLockedButtonPressed() --[[ onAttachmentSkinLockedButtonPressed | Line: 269 | Upvalues: updateProgressLabel (ref), p6 (copy), p1 (copy) ]]
			updateProgressLabel(p6, p1)
		end

		v1.LockedOverlay.MouseButton1Down:Connect(onAttachmentSkinLockedButtonPressed)
	end

	v1.Parent = v2.AttachmentSkinScroller
end

local function loadOwnedAttachmentSkins(p1, p2) --[[ loadOwnedAttachmentSkins | Line: 278 | Upvalues: Inventory (copy), Cache (copy), v2 (copy), createButton (copy) ]]
	for v1, v22 in Inventory:GetChildren() do
		if v22:GetAttribute("Type") == "AttachmentSkin" then
			local v3 = if p2 == v22:GetAttribute("Slot") then true else false

			if v3 and p1 == v22:GetAttribute("Weapon") then
				local v5 = v22:GetAttribute("Name")
				local v6 = v22:GetAttribute("ChallengeType")
				local v7 = v22:GetAttribute("Requirement")
				local v8 = v5 .. p2 .. p1
				local v9 = Cache:FindFirstChild(v8)

				if v9 then
					v9.Parent = v2.AttachmentSkinScroller

					continue
				end

				local t = {
					challengeType = v6,
					requirement = v7,
					skinName = v5
				}

				createButton(p1, v8, v5, true, t.requirement, t, p2)
			end
		end
	end
end

local function loadUnownedAttachmentSkins(p1, p2) --[[ loadUnownedAttachmentSkins | Line: 312 | Upvalues: AttachmentChallenges (copy), LocalPlayer (copy), Cache (copy), v2 (copy), createButton (copy) ]]
	local v1 = AttachmentChallenges[p1]

	assert(v1, (("Challenges for attachment \"%*\" does not exist"):format(p1)))

	for v3, v4 in v1 do
		local skinName = v4.skinName

		if not (LocalPlayer.PlayerData.Inventory:FindFirstChild(skinName .. p1 .. p2) ~= nil) then
			local v6 = skinName .. p1 .. p2
			local v7 = Cache:FindFirstChild(v6)

			if v7 then
				v7.Parent = v2.AttachmentSkinScroller

				continue
			end

			createButton(p2, v6, skinName, false, v4.requirement, v4, p1)
		end
	end
end

local function displayNextUnlockableSkin(p1, p2) --[[ displayNextUnlockableSkin | Line: 336 | Upvalues: AttachmentChallenges (copy), LocalPlayer (copy), upper (copy), formatNumber (copy), v2 (copy) ]]
	local v1 = AttachmentChallenges[p2]
	local challengeType = v1[1].challengeType
	local v22 = LocalPlayer.PlayerData.WeaponStats:FindFirstChild(p1):GetAttribute(challengeType)
	local v3 = "Failed to load"

	for v4, v5 in v1 do
		local requirement = v5.requirement

		if if requirement <= v22 then true else false then
			if if v4 == #v1 then true else false then
				v3 = ("%*  \226\128\148  %* / %*"):format(string.gsub(challengeType, "^%l", upper), formatNumber(v22), (formatNumber(requirement)))
			end
		else
			v3 = ("%*  \226\128\148  %* / %*"):format(string.gsub(challengeType, "^%l", upper), formatNumber(v22), (formatNumber(requirement)))

			break
		end
	end

	v2.ProgressLabel.Text = v3
end

function t.onWeaponAttachmentButtonPressed(p1, p2) --[[ onWeaponAttachmentButtonPressed | Line: 364 | Upvalues: LocalPlayer2 (copy), t2 (copy), clearUI (copy), loadOwnedAttachmentSkins (copy), loadUnownedAttachmentSkins (copy), displayNextUnlockableSkin (copy), v2 (copy) ]]
	local v1 = LocalPlayer2.PlayerData.Loadout:FindFirstChild(LocalPlayer2.PlayerData.Settings:GetAttribute("LoadoutName")):GetAttribute(p2 .. "Weapon")

	if not t2[p1] then
		return
	end

	clearUI()
	loadOwnedAttachmentSkins(v1, p1)
	loadUnownedAttachmentSkins(p1, v1)
	displayNextUnlockableSkin(v1, p1)
	v2.Visible = true
end
function t.onBackPressed() --[[ onBackPressed | Line: 382 | Upvalues: v2 (copy) ]]
	v2.Visible = false
end

if not isLobbyID then
	return t
end

clearUI()

return t