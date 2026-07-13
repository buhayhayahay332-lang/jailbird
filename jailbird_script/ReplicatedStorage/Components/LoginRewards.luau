-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gamepasses = require(ReplicatedStorage.Components.Gamepasses)
local t = {
	Tables = {
		{
			{
				Type = "Cash",
				Name = "Cash",
				Amount = 100
			},
			{
				Type = "Crate",
				Name = "Elite",
				Amount = 1
			},
			{
				Type = "Credit",
				Name = "Credit",
				Amount = 50
			},
			{
				Type = "Crate",
				Name = "Regular",
				Amount = 4
			},
			{
				Type = "Cash",
				Name = "Cash",
				Amount = 2000
			},
			{
				Type = "Credit",
				Name = "Credit",
				Amount = 100
			},
			{
				Type = "Crate",
				Name = "Elite",
				Amount = 3
			}
		},
		{
			{
				Type = "Cash",
				Name = "Cash",
				Amount = 200
			},
			{
				Type = "Crate",
				Name = "Elite",
				Amount = 1
			},
			{
				Type = "Credit",
				Name = "Credit",
				Amount = 50
			},
			{
				Type = "Crate",
				Name = "Regular",
				Amount = 4
			},
			{
				Type = "Cash",
				Name = "Cash",
				Amount = 2000
			},
			{
				Type = "Credit",
				Name = "Credit",
				Amount = 150
			},
			{
				Type = "Crate",
				Name = "Elite",
				Amount = 3
			}
		},
		{
			{
				Type = "Cash",
				Name = "Cash",
				Amount = 200
			},
			{
				Type = "Crate",
				Name = "Rookie",
				Amount = 3
			},
			{
				Type = "Crate",
				Name = "Regular",
				Amount = 3
			},
			{
				Type = "Crate",
				Name = "Elite",
				Amount = 2
			},
			{
				Type = "Credit",
				Name = "Credit",
				Amount = 50
			},
			{
				Type = "Credit",
				Name = "Credit",
				Amount = 50
			},
			{
				Type = "Crate",
				Name = "Elite",
				Amount = 3
			}
		}
	},
	Attributes = {
		ClaimCount = "LoginRewardClaimCount",
		LastClaimAt = "LoginRewardLastClaimAt",
		CurrentDay = "LoginRewardCurrentDay",
		CurrentWeek = "LoginRewardCurrentWeek",
		ClaimSerial = "LoginRewardClaimSerial"
	}
}

local function cloneRewardData(p1) --[[ cloneRewardData | Line: 54 ]]
	return {
		Type = p1.Type,
		Name = p1.Name,
		Amount = p1.Amount
	}
end

local function getNumberAttribute(p1, p2) --[[ getNumberAttribute | Line: 62 ]]
	return tonumber(p1:GetAttribute(p2)) or 0
end

function t.GetRewardTableIndexFromClaims(p1) --[[ GetRewardTableIndexFromClaims | Line: 66 ]]
	local v2 = math.max(tonumber(p1) or 0, 0)

	if v2 < 7 then
		return 1
	end

	if v2 < 14 then
		return 2
	end

	return 3
end
function t.GetCurrentWeekFromClaims(p1) --[[ GetCurrentWeekFromClaims | Line: 77 | Upvalues: t (copy) ]]
	return t.GetRewardTableIndexFromClaims(p1)
end
function t.GetCurrentDayFromClaims(p1) --[[ GetCurrentDayFromClaims | Line: 81 ]]
	return math.max(tonumber(p1) or 0, 0) % 7 + 1
end
function t.GetRewardTableByClaims(p1) --[[ GetRewardTableByClaims | Line: 86 | Upvalues: t (copy) ]]
	return table.clone(t.Tables[t.GetRewardTableIndexFromClaims(p1)] or t.Tables[3])
end

local function syncProgressAttributes(p1) --[[ syncProgressAttributes | Line: 91 | Upvalues: t (copy) ]]
	local v1 = tonumber(p1:GetAttribute(t.Attributes.ClaimCount)) or 0

	p1:SetAttribute(t.Attributes.CurrentWeek, t.GetCurrentWeekFromClaims(v1))
	p1:SetAttribute(t.Attributes.CurrentDay, t.GetCurrentDayFromClaims(v1))
end

function t.RefreshStats(p1) --[[ RefreshStats | Line: 97 | Upvalues: t (copy), syncProgressAttributes (copy) ]]
	if not p1 then
		return false
	end

	local Attributes = t.Attributes
	local v1 = false

	for i, v in ipairs({
		Attributes.ClaimCount,
		Attributes.LastClaimAt,
		Attributes.CurrentDay,
		Attributes.CurrentWeek,
		Attributes.ClaimSerial
	}) do
		if p1:GetAttribute(v) == nil then
			p1:SetAttribute(v, 0)
			v1 = true
		end
	end

	syncProgressAttributes(p1)

	return v1
end
function t.GetTotalClaims(p1) --[[ GetTotalClaims | Line: 122 | Upvalues: t (copy) ]]
	if p1 then
		t.RefreshStats(p1)

		return tonumber(p1:GetAttribute(t.Attributes.ClaimCount)) or 0
	end

	return 0
end
function t.GetCurrentWeek(p1) --[[ GetCurrentWeek | Line: 131 | Upvalues: t (copy) ]]
	if p1 then
		t.RefreshStats(p1)

		return math.max(tonumber(p1:GetAttribute(t.Attributes.CurrentWeek)) or 0, 1)
	end

	return 1
end
function t.GetCurrentDay(p1) --[[ GetCurrentDay | Line: 140 | Upvalues: t (copy) ]]
	if p1 then
		t.RefreshStats(p1)

		return math.max(tonumber(p1:GetAttribute(t.Attributes.CurrentDay)) or 0, 1)
	end

	return 1
end
function t.GetLastClaimAt(p1) --[[ GetLastClaimAt | Line: 149 | Upvalues: t (copy) ]]
	if p1 then
		t.RefreshStats(p1)

		return tonumber(p1:GetAttribute(t.Attributes.LastClaimAt)) or 0
	end

	return 0
end
function t.GetNextClaimTime(p1) --[[ GetNextClaimTime | Line: 158 | Upvalues: t (copy) ]]
	local v1 = t.GetLastClaimAt(p1)

	if v1 <= 0 then
		return 0
	end

	return v1 + 86400
end
function t.CanClaim(p1, p2) --[[ CanClaim | Line: 167 | Upvalues: t (copy) ]]
	if not p1 then
		return false
	end

	t.RefreshStats(p1)

	local v1 = tonumber(p2) or os.time()
	local v2 = t.GetTotalClaims(p1)
	local v3 = t.GetLastClaimAt(p1)

	if v2 <= 0 or v3 <= 0 then
		return true
	end

	return v3 + 86400 <= v1
end
function t.GetCurrentRewardData(p1) --[[ GetCurrentRewardData | Line: 185 | Upvalues: t (copy) ]]
	if not p1 then
		return nil
	end

	t.RefreshStats(p1)

	local v1 = t.GetTotalClaims(p1)
	local v2 = t.GetCurrentDay(p1)
	local v3 = t.GetRewardTableByClaims(v1)[v2]

	if v3 then
		return {
			Type = v3.Type,
			Name = v3.Name,
			Amount = v3.Amount,
			ID = string.format("LoginReward_%d", v1 + 1)
		}
	end

	return nil
end
function t.GetClientState(p1, p2) --[[ GetClientState | Line: 205 | Upvalues: t (copy) ]]
	if not p1 then
		return {
			CanClaim = false,
			CurrentDay = 1,
			CurrentWeek = 1,
			NextClaimAt = 0,
			TotalClaims = 0,
			TableIndex = 1,
			Rewards = {}
		}
	end

	t.RefreshStats(p1)

	local v1 = t.GetTotalClaims(p1)
	local v2 = t.GetCurrentDay(p1)
	local v3 = t.GetCurrentWeek(p1)
	local v4 = t.GetRewardTableIndexFromClaims(v1)
	local v5 = t.GetRewardTableByClaims(v1)
	local v6 = t.CanClaim(p1, p2)
	local t2 = {}

	for i, v in ipairs(v5) do
		local v7 = "Future"

		if i < v2 then
			v7 = "Claimed"
		elseif i == v2 and v6 then
			v7 = "Claimable"
		end

		t2[i] = {
			Day = i,
			RewardType = v.Type,
			RewardName = v.Name,
			RewardAmount = v.Amount,
			State = v7,
			Week = v3,
			TableIndex = v4
		}
	end

	return {
		CanClaim = v6,
		CurrentDay = v2,
		CurrentWeek = v3,
		NextClaimAt = t.GetNextClaimTime(p1),
		TotalClaims = v1,
		TableIndex = v4,
		Rewards = t2
	}
end
function t.Claim(p1) --[[ Claim | Line: 258 | Upvalues: t (copy), Gamepasses (copy), syncProgressAttributes (copy) ]]
	local v1 = if p1 then p1:FindFirstChild("PlayerData") else p1
	local v2 = if v1 then v1:FindFirstChild("Stats") else v1

	if not (v1 and v2) then
		return false, nil, "Player data is not ready."
	end

	t.RefreshStats(v2)

	if not t.CanClaim(v2) then
		return false, nil, "Claim is not ready."
	end

	local v3 = t.GetCurrentRewardData(v2)

	if not v3 then
		return false, nil, "Reward is unavailable."
	end

	if Gamepasses.GiveItem(v3, v1) == true then
		v2:SetAttribute(t.Attributes.ClaimCount, t.GetTotalClaims(v2) + 1)
		v2:SetAttribute(t.Attributes.LastClaimAt, os.time())
		v2:SetAttribute(t.Attributes.ClaimSerial, (tonumber(v2:GetAttribute(t.Attributes.ClaimSerial)) or 0) + 1)
		syncProgressAttributes(v2)

		return true, v3
	end

	return false, nil, "Reward could not be granted."
end

return t