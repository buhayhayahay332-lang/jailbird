
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local WeaponSlotResolver = require(ReplicatedStorage.Modules.WeaponSlotResolver);
local v1 = {};
local u2 = {};
u2.__index = u2;

function v1.new(p3, p4) -- Line: 17
    -- upvalues: u2 (copy)
    local v5 = setmetatable({}, u2);
    v5.GameEvents = p3;
    v5.StateFolder = p4;
    v5.NextRequestId = 0;
    v5.PendingEquipRequest = nil;
    v5.PresentationSequence = 0;

    return v5;
end;

function u2.SetStateFolder(p6, p7) -- Line: 27
    p6.StateFolder = p7;
end;

function u2.UpdateLocalState(p8, p9) -- Line: 31
    -- upvalues: WeaponSlotResolver (copy)
    WeaponSlotResolver.UpdateStateFolder(p8.StateFolder, p9);
end;

function u2.BuildEquipRequest(p10, p11, p12, p13) -- Line: 35
    p10.NextRequestId = p10.NextRequestId + 1;
    local v14 = tostring(p10.NextRequestId);
    local v15 = {
        Slot = p11,
        ToolSerial = p12,
        ToolName = p13,
        RequestId = v14
    };
    p10.PendingEquipRequest = v15;
    p10:UpdateLocalState({
        EquippedSlot = p11,
        EquippedToolSerial = p12,
        EquippedToolName = p13,
        PendingRequestId = v14
    });

    return v15;
end;

function u2.SendEquipRequest(p16, p17, p18, p19) -- Line: 54
    local v20 = p16:BuildEquipRequest(p17, p18, p19);
    p16.GameEvents.SwapWeapon:FireServer(v20);

    return v20;
end;

function u2.ConfirmEquip(p21, p22) -- Line: 60
    p21.PendingEquipRequest = nil;
    p21:UpdateLocalState({
        PendingRequestId = "",
        EquippedSlot = p22.Slot or "",
        EquippedToolSerial = p22.ToolSerial or "",
        EquippedToolName = p22.ToolName or ""
    });
end;

function u2.RejectPendingEquip(p23, p24) -- Line: 70
    p23.PendingEquipRequest = nil;
    p23:UpdateLocalState({
        PendingRequestId = "",
        EquippedSlot = p24 and p24.Slot or (p23.StateFolder and (p23.StateFolder:GetAttribute("EquippedSlot") or "") or ""),
        EquippedToolSerial = p24 and p24.ToolSerial or (p23.StateFolder and (p23.StateFolder:GetAttribute("EquippedToolSerial") or "") or ""),
        EquippedToolName = p24 and p24.ToolName or (p23.StateFolder and (p23.StateFolder:GetAttribute("EquippedToolName") or "") or "")
    });
end;

function u2.HasMeaningfulStateChange(p25, p26, p27) -- Line: 80
    if not p25.StateFolder then
        return true;
    end;

    if p25.StateFolder:GetAttribute("CurrentActionState") ~= p26 then
        return true;
    end;

    for i, v in pairs(p27) do
        if p25.StateFolder:GetAttribute(i) ~= v then
            return true;
        end;
    end;

    return false;
end;

function u2.SendActionState(p28, p29, p30) -- Line: 98
    local v31 = table.clone(p30 or {});
    v31.CurrentActionState = p29;

    if p28:HasMeaningfulStateChange(p29, v31) ~= true then
        return;
    end;

    p28:UpdateLocalState(v31);
    local WeaponState = p28.GameEvents:FindFirstChild("WeaponState");

    if WeaponState and WeaponState:IsA("RemoteEvent") then
        WeaponState:FireServer({
            Action = p29,
            Updates = v31
        });
    end;
end;

function u2.BuildPresentationEventPayload(p32, p33, p34) -- Line: 115
    p32.PresentationSequence = p32.PresentationSequence + 1;
    local v35 = table.clone(p34 or {});
    v35.Type = p33;
    v35.Sequence = p32.PresentationSequence;

    return v35;
end;

function u2.SendPresentationEvent(p36, p37, p38) -- Line: 123
    local SpectatePresentation = p36.GameEvents:FindFirstChild("SpectatePresentation");

    if not (SpectatePresentation and SpectatePresentation:IsA("RemoteEvent")) then
        return nil;
    end;

    local v39 = p36:BuildPresentationEventPayload(p37, p38);
    SpectatePresentation:FireServer(v39);

    return v39;
end;

return v1;