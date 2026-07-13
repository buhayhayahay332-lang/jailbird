local v_u_1 = game:GetService("ReplicatedStorage")
require(v_u_1.Components.Menu)
local v_u_2 = require(v_u_1.Config)
local v_u_3 = require(v_u_1.Components.Challenges)
game:GetService("CollectionService")
local v_u_4 = require(v_u_1.Components.Workshop)
local v_u_5 = require(v_u_1.Components.FunnelService)
local v_u_6 = require(v_u_1.Components.Crates)
local v_u_7 = {
	["FeaturedDataId"] = "FeaturedItems",
	["Collectibles"] = {
		"Skin",
		"Emote",
		"Head",
		"Top",
		"Bottom",
		"Banner",
		"Title",
		"Charm",
		"Knife"
	}
}
local v_u_8 = ("[%*]: "):format(script.Name)
v_u_7.FeaturedItems = {
	[1] = "Head",
	[2] = "Head",
	[11] = "Top",
	[12] = "Top",
	[21] = "Bottom",
	[22] = "Bottom",
	[25] = "Knife",
	[26] = "Knife",
	[31] = "Skin",
	[32] = "Skin",
	[33] = "Skin",
	[34] = "Skin",
	[41] = "Title",
	[42] = "Title",
	[51] = "Banner",
	[52] = "Banner",
	[61] = "Emote",
	[62] = "Emote",
	[71] = "Charm",
	[72] = "Charm"
}
v_u_7.WorkshopItems = {
	[1] = "Head",
	[2] = "Head",
	[10] = "Top",
	[11] = "Top",
	[20] = "Bottom",
	[21] = "Bottom",
	[22] = "Bottom",
	[23] = "Bottom",
	[30] = "Skin",
	[31] = "Skin",
	[32] = "Skin",
	[33] = "Skin",
	[34] = "Skin",
	[35] = "Skin",
	[36] = "Skin",
	[37] = "Skin"
}
function v_u_7.GetCrateItems(_, p9) -- name: GetCrateItems
	-- upvalues: (copy) v_u_6
	return v_u_6.GetCrateContents(p9)
end
function v_u_7.GetRandomItemFromCrate(p10) -- name: GetRandomItemFromCrate
	-- upvalues: (copy) v_u_6, (copy) v_u_1, (copy) v_u_8, (copy) v_u_2, (copy) v_u_7
	local v11
	if type(p10) == "string" then
		v11 = v_u_6.RollItem(p10)
	else
		v11 = nil
	end
	if not v11 then
		return nil
	end
	local v12 = v_u_1.Items:FindFirstChild(v11.Type)
	if v12 then
		v12 = v12:FindFirstChild(v11.Name)
	end
	if v12 then
		local v13 = v_u_2.GetItemDataFromObject(v12)
		if v_u_2.CheckIfItemIsWeaponExclusive(v13) then
			v13.Weapon = v_u_7.GetRandomWeapon()
		end
		return v13, v11
	end
	local v14 = warn
	local v15 = v_u_8
	local v16 = v11.Name
	local v17 = tostring(v16)
	local v18 = v11.Type
	v14(v15 .. "Missing crate item object for " .. v17 .. " [" .. tostring(v18) .. "]")
	return nil
end
function v_u_7.GetRandomWeapon(p19) -- name: GetRandomWeapon
	local v20 = {}
	for _, v21 in pairs(game.ReplicatedStorage.Items.Weapon:GetChildren()) do
		v20[#v20 + 1] = v21.Name
	end
	local v22 = v20[math.random(1, #v20)]
	if p19 then
		v22 = v20[Random.new(p19):NextInteger(1, #v20)]
	end
	return v22
end
function FindExistingInventory(p23, p24) -- name: FindExistingInventory
	local v25 = p23.PlayerData.Inventory
	local v26 = nil
	for _, v27 in pairs(v25:GetChildren()) do
		if v27:GetAttribute("Name") == p24.Name and (v27:GetAttribute("Type") == p24.Type and v27:GetAttribute("Weapon") == p24.Weapon) then
			v26 = v27
		end
	end
	return v26
end
function v_u_7.GiveItem(p28, p29) -- name: GiveItem
	-- upvalues: (copy) v_u_2
	local v30 = p28.PlayerData.Inventory
	if v_u_2.CheckIfItemIsWeaponExclusive(p29) == false then
		p29.Weapon = nil
	end
	local v31 = FindExistingInventory(p28, p29)
	if v31 == nil then
		local v32 = Instance.new("StringValue", v30)
		v32.Name = v_u_2.GetItemIDFromItemData(p29)
		v32.Value = v_u_2.GetItemIDFromItemData(p29)
		v32:SetAttribute("Name", p29.Name)
		v32:SetAttribute("Type", p29.Type)
		if v_u_2.CheckIfItemIsWeaponExclusive(p29) then
			v32:SetAttribute("Weapon", p29.Weapon)
		end
		v32:SetAttribute("Quantity", 1)
	elseif v31 and p29.Type ~= "Weapon" then
		v31:SetAttribute("Quantity", (v31:GetAttribute("Quantity") or 1) + 1)
	end
end
function v_u_7.PurchaseItem(p33, p34) -- name: PurchaseItem
	-- upvalues: (copy) v_u_1, (copy) v_u_2, (copy) v_u_7
	local v35 = p33.PlayerData:FindFirstChild("Stats")
	if v35 == nil then
		return false
	else
		local v36 = v_u_1.Items:FindFirstChild(p34.Type):FindFirstChild(p34.Name)
		if v36 and (v36:GetAttribute("Crate") == "Featured" or v36:GetAttribute("Crate") == "Workshop") then
			local v37 = v_u_2.GetItemDataFromObject(v36)
			if p34.Weapon then
				v37.Weapon = p34.Weapon
			end
			v_u_7.CheckPlayerOwnItem(p33, v37)
			local v38, v39 = v_u_2.GetItemDataPrice(v37)
			if v39 > v35:GetAttribute(v38) then
				v_u_1.Events.Action:FireClient(p33, {
					["Message"] = "Not enough " .. v38,
					Color3.fromRGB(255, 100, 100)
				})
				return false
			end
			v35:SetAttribute(v38, v35:GetAttribute(v38) - v39)
			v_u_7.GiveItem(p33, v37)
			v_u_2.AddItemsLog(p33, v37, true)
			v_u_1.Events.Action:FireClient(p33, "ItemsLog")
		end
	end
end
function v_u_7.CheckPlayerOwnItem(p40, p41) -- name: CheckPlayerOwnItem
	-- upvalues: (copy) v_u_2
	local v42 = v_u_2.GetItemIDFromItemData(p41)
	return p40.PlayerData.Inventory:FindFirstChild(v42) ~= nil
end
function v_u_7.PurchaseLoadout(p43, p44) -- name: PurchaseLoadout
	-- upvalues: (copy) v_u_1, (copy) v_u_2, (copy) v_u_7
	local v45 = p43.PlayerData:FindFirstChild("Stats")
	if v45 ~= nil then
		local v46 = v_u_1.Items[p44.Type][p44.Name]
		local v47 = v_u_2.GetItemDataFromObject(v46)
		if v_u_2.CheckIfItemIsWeaponExclusive(p44) then
			if p44.Weapon == "" or p44 == nil then
				v_u_1.Events.Notification:FireClient(p43, "Result", "Item error.", 1, 0.03)
			else
				v47.Weapon = p44.Weapon
			end
		end
		if v47 and (v46 and (not v_u_7.CheckPlayerOwnItem(p43, v47) and v47.Cost)) then
			local v48 = v47.Cost
			local v49 = v47.CostType == nil and "Cash" or v47.CostType
			if v48 <= v45:GetAttribute(v49) and (v47.Level and v45:GetAttribute("Level") >= v47.Level or v47.Level == nil) then
				v_u_7.GiveItem(p43, v47)
				v45:SetAttribute(v49, v45:GetAttribute(v49) - v48)
				v_u_2.AddItemsLog(p43, v47, true)
				v_u_1.Events.Action:FireClient(p43, "ItemsLog")
			elseif v47.Level and v45:GetAttribute("Level") < v47.Level then
				v_u_1.Events.Action:FireClient(p43, {
					["Message"] = "Reach level " .. v47.Level,
					Color3.fromRGB(255, 100, 100)
				})
			else
				v_u_1.Events.Action:FireClient(p43, {
					["Message"] = "Not enough " .. v49,
					Color3.fromRGB(255, 100, 100)
				})
			end
		else
			v_u_1.Events.Notification:FireClient(p43, "Result", "You already own this item.", 1, 0.03)
		end
	end
	task.wait(1)
	v_u_1.Events.PurchaseLoadout:FireClient(p43)
end
function v_u_7.GetArrayCrateItems(p50) -- name: GetArrayCrateItems
	-- upvalues: (copy) v_u_7, (copy) v_u_2
	local v51 = {}
	for _, v52 in ipairs(v_u_7.Collectibles) do
		for _, v53 in pairs(game.ReplicatedStorage.Items[v52]:GetChildren()) do
			if v53:GetAttribute("Crate") == p50 then
				local v54 = v_u_2.GetItemDataFromObject(v53)
				if v_u_2.CheckIfItemIsWeaponExclusive(v54) then
					v54.Weapon = v_u_7.GetRandomWeapon()
				end
				table.insert(v51, v54)
			end
		end
	end
	return v51
end
function v_u_7.GetSingleRandomItem(p55, p56, p57) -- name: GetSingleRandomItem
	-- upvalues: (copy) v_u_2, (copy) v_u_1, (copy) v_u_7
	local v58 = Random.new(p56)
	local v59 = {}
	for _, v60 in ipairs(p55) do
		if v60.Type == p57 then
			for _ = 1, v_u_2.Rarity[v_u_1.Items[v60.Type][v60.Name]:GetAttribute("Rarity")].Percentage do
				v59[#v59 + 1] = v60
			end
		end
	end
	local v61 = v59[v58:NextInteger(1, #v59)]
	if v61.Type == "Skin" then
		v61.Weapon = v_u_7.GetRandomWeapon(p56)
	end
	return v61
end
function v_u_7.GetRandomItems(p62, p63, p64, p65) -- name: GetRandomItems
	-- upvalues: (copy) v_u_2, (copy) v_u_1, (copy) v_u_7
	local v66 = Random.new(p63)
	local v67 = {}
	for v68, v69 in pairs(p64) do
		local v70 = {}
		for _, v71 in ipairs(p62) do
			if v71.Type == v69 then
				local v72 = false
				for _, v73 in pairs(v67) do
					if v73.Name == v71.Name and v73.Type == v71.Type then
						v72 = true
					end
				end
				if v72 == false then
					if p65 == true then
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
						v70[#v70 + 1] = v71
					else
						for _ = 1, v_u_2.Rarity[v_u_1.Items[v71.Type][v71.Name]:GetAttribute("Rarity")].Percentage do
							v70[#v70 + 1] = v71
						end
					end
				end
			end
		end
		local v74 = v70[v66:NextInteger(1, #v70)]
		if v74 and v74.Type == "Skin" then
			v74.Weapon = v_u_7.GetRandomWeapon(v66:NextInteger(1, #v70))
		end
		v67[v68] = v74
	end
	return v67
end
function v_u_7.RenewFeatured(p75) -- name: RenewFeatured
	-- upvalues: (copy) v_u_7, (copy) v_u_2, (copy) v_u_1
	game.ReplicatedStorage.Components.Shop.Featured:ClearAllChildren()
	local v76 = v_u_7.GetArrayCrateItems("Featured")
	local v77 = v_u_7.GetRandomItems(v76, p75, v_u_7.FeaturedItems, true)
	v77.SetHead = v_u_7.GetSingleRandomItem(v76, p75 * 5, "Head")
	v77.SetTop = v_u_2.GetItemDataFromObject(game.ReplicatedStorage.Items.Top[v77.SetHead.Name])
	v77.SetBottom = v_u_2.GetItemDataFromObject(game.ReplicatedStorage.Items.Bottom[v77.SetHead.Name])
	if v_u_2.CheckSeasonActive() == true and v_u_2.SeasonFeaturedItem ~= nil then
		v77.SetHead = v_u_2.GetItemDataFromObject(game.ReplicatedStorage.Items.Head[v_u_2.SeasonFeaturedItem])
		v77.SetTop = v_u_2.GetItemDataFromObject(game.ReplicatedStorage.Items.Top[v_u_2.SeasonFeaturedItem])
		v77.SetBottom = v_u_2.GetItemDataFromObject(game.ReplicatedStorage.Items.Bottom[v_u_2.SeasonFeaturedItem])
	end
	if v_u_2.SeasonFeaturedKnife ~= nil then
		v77.FeaturedKnife = {}
		local v78 = v_u_1.Items.Knife:FindFirstChild(v_u_2.SeasonFeaturedKnife)
		for v79, v80 in pairs(v78:GetAttributes()) do
			v77.FeaturedKnife[v79] = v80
		end
		v77.FeaturedKnife.Name = v_u_2.SeasonFeaturedKnife
	end
	for v81, v82 in pairs(v77) do
		local v83 = Instance.new("StringValue", game.ReplicatedStorage.Components.Shop.Featured)
		v83.Name = v81
		v83.Value = v_u_2.GetItemIDFromItemData(v82)
		v83:SetAttribute("LayoutOrder", v81)
		for v84, v85 in pairs(v82) do
			v83:SetAttribute(v84, v85)
		end
	end
	return v77
end
function v_u_7.RenewWorkshop(p86) -- name: RenewWorkshop
	-- upvalues: (copy) v_u_7, (copy) v_u_2
	game.ReplicatedStorage.Components.Shop.Workshop:ClearAllChildren()
	local v87 = v_u_7.GetArrayCrateItems("Workshop")
	local v88 = v_u_7.GetRandomItems(v87, p86, v_u_7.WorkshopItems, true)
	for v89, v90 in pairs(v88) do
		local v91 = Instance.new("StringValue", game.ReplicatedStorage.Components.Shop.Workshop)
		v91.Name = v_u_2.GetItemIDFromItemData(v90)
		v91.Value = v_u_2.GetItemIDFromItemData(v90)
		v91:SetAttribute("LayoutOrder", v89)
		for v92, v93 in pairs(v90) do
			v91:SetAttribute(v92, v93)
		end
	end
	return v88
end
function v_u_7.FindWorkshopItem(p94) -- name: FindWorkshopItem
	-- upvalues: (copy) v_u_4
	for _, v95 in pairs(v_u_4.Store) do
		if v95.Name == p94.Name and v95.Type == p94.Type then
			return v95
		end
	end
	return nil
end
function v_u_7.OpenCrateServer(p96, p97) -- name: OpenCrateServer
	-- upvalues: (copy) v_u_1, (copy) v_u_6, (copy) v_u_7, (copy) v_u_3, (copy) v_u_2, (copy) v_u_5
	local v98 = p96.PlayerData:FindFirstChild("Crates")
	if type(p97) == "string" and (v98 ~= nil and p97 ~= "") then
		local v99 = v98:GetAttribute(p97) or 0
		if v99 <= 0 then
			v_u_1.Events.Action:FireClient(p96, "Notification", {
				["Message"] = "Crate failed",
				["Color"] = nil,
				["Color"] = Color3.fromRGB(255, 100, 100)
			})
			return
		elseif v_u_6.GetCrate(p97) then
			if v_u_6.HasContents(p97) then
				local v100, v101 = v_u_7.GetRandomItemFromCrate(p97)
				if not (v100 and v101) then
					v_u_1.Events.Action:FireClient(p96, "Notification", {
						["Message"] = "Crate failed",
						["Color"] = nil,
						["Color"] = Color3.fromRGB(255, 100, 100)
					})
					return nil
				end
				v98:SetAttribute(p97, v99 - 1)
				v_u_3.UpdateMetric(p96, "CratesOpened", 1)
				v_u_7.GiveItem(p96, v100)
				local v102 = v_u_2.AddItemsLog(p96, v100, true)
				local v103 = v_u_6.GetChanceText(p97, v101)
				v_u_5.LogOnboardingStep(p96, "OpenedCrate", nil)
				local v104 = v_u_1.Events.Action
				local v105 = "CrateResult"
				local v106 = {
					["CrateName"] = p97,
					["ItemData"] = v100
				}
				local v107
				if v102 then
					v107 = v102.Name or nil
				else
					v107 = nil
				end
				v106.ItemLogId = v107
				v104:FireClient(p96, v105, v106)
				return {
					["CrateName"] = p97,
					["ItemData"] = v100,
					["RolledEntry"] = v101,
					["ChanceText"] = v103,
					["ItemLogId"] = v102 and v102.Name or nil
				}
			end
			v_u_1.Events.Action:FireClient(p96, "Notification", {
				["Message"] = "Crate does not have contents",
				["Color"] = nil,
				["Color"] = Color3.fromRGB(255, 100, 100)
			})
		else
			v_u_1.Events.Action:FireClient(p96, "Notification", {
				["Message"] = "Crate failed",
				["Color"] = nil,
				["Color"] = Color3.fromRGB(255, 100, 100)
			})
		end
	else
		v_u_1.Events.Action:FireClient(p96, "Notification", {
			["Message"] = "Crate failed",
			["Color"] = nil,
			["Color"] = Color3.fromRGB(255, 100, 100)
		})
		return nil
	end
end
function v_u_7.ConfigureShopPage() -- name: ConfigureShopPage end
return v_u_7