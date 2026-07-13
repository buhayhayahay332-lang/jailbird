local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.WeaponSlotResolver)
local v3 = {}
local v_u_4 = {}
v_u_4.__index = v_u_4
function v3.new(p5, p6) -- name: new
	-- upvalues: (copy) v_u_4
	local v7 = v_u_4
	local v8 = setmetatable({}, v7)
	v8.GameEvents = p5
	v8.StateFolder = p6
	v8.NextRequestId = 0
	v8.PendingEquipRequest = nil
	v8.PresentationSequence = 0
	return v8
end
function v_u_4.SetStateFolder(p9, p10) -- name: SetStateFolder
	p9.StateFolder = p10
end
function v_u_4.UpdateLocalState(p11, p12) -- name: UpdateLocalState
	-- upvalues: (copy) v_u_2
	v_u_2.UpdateStateFolder(p11.StateFolder, p12)
end
function v_u_4.BuildEquipRequest(p13, p14, p15, p16) -- name: BuildEquipRequest
	p13.NextRequestId = p13.NextRequestId + 1
	local v17 = p13.NextRequestId
	local v18 = tostring(v17)
	local v19 = {
		["Slot"] = p14,
		["ToolSerial"] = p15,
		["ToolName"] = p16,
		["RequestId"] = v18
	}
	p13.PendingEquipRequest = v19
	p13:UpdateLocalState({
		["EquippedSlot"] = p14,
		["EquippedToolSerial"] = p15,
		["EquippedToolName"] = p16,
		["PendingRequestId"] = v18
	})
	return v19
end
function v_u_4.SendEquipRequest(p20, p21, p22, p23) -- name: SendEquipRequest
	local v24 = p20:BuildEquipRequest(p21, p22, p23)
	p20.GameEvents.SwapWeapon:FireServer(v24)
	return v24
end
function v_u_4.ConfirmEquip(p25, p26) -- name: ConfirmEquip
	p25.PendingEquipRequest = nil
	p25:UpdateLocalState({
		["EquippedSlot"] = nil,
		["EquippedToolSerial"] = nil,
		["EquippedToolName"] = nil,
		["PendingRequestId"] = "",
		["EquippedSlot"] = p26.Slot or "",
		["EquippedToolSerial"] = p26.ToolSerial or "",
		["EquippedToolName"] = p26.ToolName or ""
	})
end
function v_u_4.RejectPendingEquip(p27, p28) -- name: RejectPendingEquip
	p27.PendingEquipRequest = nil
	p27:UpdateLocalState({
		["PendingRequestId"] = "",
		["EquippedSlot"] = nil,
		["EquippedToolSerial"] = nil,
		["EquippedToolName"] = nil,
		["EquippedSlot"] = p28 and p28.Slot or (p27.StateFolder and (p27.StateFolder:GetAttribute("EquippedSlot") or "") or ""),
		["EquippedToolSerial"] = p28 and p28.ToolSerial or (p27.StateFolder and (p27.StateFolder:GetAttribute("EquippedToolSerial") or "") or ""),
		["EquippedToolName"] = p28 and p28.ToolName or (p27.StateFolder and (p27.StateFolder:GetAttribute("EquippedToolName") or "") or "")
	})
end
function v_u_4.HasMeaningfulStateChange(p29, p30, p31) -- name: HasMeaningfulStateChange
	if not p29.StateFolder then
		return true
	end
	if p29.StateFolder:GetAttribute("CurrentActionState") ~= p30 then
		return true
	end
	for v32, v33 in pairs(p31) do
		if p29.StateFolder:GetAttribute(v32) ~= v33 then
			return true
		end
	end
	return false
end
function v_u_4.SendActionState(p34, p35, p36) -- name: SendActionState
	local v37 = table.clone(p36 or {})
	v37.CurrentActionState = p35
	if p34:HasMeaningfulStateChange(p35, v37) == true then
		p34:UpdateLocalState(v37)
		local v38 = p34.GameEvents:FindFirstChild("WeaponState")
		if v38 and v38:IsA("RemoteEvent") then
			v38:FireServer({
				["Action"] = p35,
				["Updates"] = v37
			})
		end
	end
end
function v_u_4.BuildPresentationEventPayload(p39, p40, p41) -- name: BuildPresentationEventPayload
	p39.PresentationSequence = p39.PresentationSequence + 1
	local v42 = table.clone(p41 or {})
	v42.Type = p40
	v42.Sequence = p39.PresentationSequence
	return v42
end
function v_u_4.SendPresentationEvent(p43, p44, p45) -- name: SendPresentationEvent
	local v46 = p43.GameEvents:FindFirstChild("SpectatePresentation")
	if not (v46 and v46:IsA("RemoteEvent")) then
		return nil
	end
	local v47 = p43:BuildPresentationEventPayload(p44, p45)
	v46:FireServer(v47)
	return v47
end
return v3