if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Settings = {
    Enabled             = false,
    WeaponSkin          = "Crystalline",
    AttachmentSkin      = "Gold",
    AttachmentsEnabled  = false,
    Attachments = {
        Sight  = "Compact",
        Grip   = "Vertical Grip",
        Muzzle = "Silencer",
        Charm  = "",
        Extra  = "",
    },
    KnifeEnabled = false,
    Knife        = "Bayonet",
}

if getgenv().SkinSettings then
    local prev = getgenv().SkinSettings
    Settings.Enabled            = prev.Enabled
    Settings.WeaponSkin         = prev.WeaponSkin
    Settings.AttachmentSkin     = prev.AttachmentSkin
    Settings.AttachmentsEnabled = prev.AttachmentsEnabled
    Settings.KnifeEnabled       = prev.KnifeEnabled
    Settings.Knife              = prev.Knife
    if prev.Attachments then
        Settings.Attachments.Sight  = prev.Attachments.Sight
        Settings.Attachments.Grip   = prev.Attachments.Grip
        Settings.Attachments.Muzzle = prev.Attachments.Muzzle
        Settings.Attachments.Charm  = prev.Attachments.Charm or ""
        Settings.Attachments.Extra  = prev.Attachments.Extra
    end
end

local Global = getgenv()
Global.SkinSettings   = Settings
Global.UnlockSettings = Settings

if Global.__unlock_cleanup then
    pcall(Global.__unlock_cleanup)
end

local RuntimeState = {
    Connections             = {},
    OriginalSetSkinOnWep    = nil,
    OriginalSetAttachSkins  = nil,
    OriginalSetFullAttach   = nil,
    OriginalSetAttachOnWep  = nil,
    Hooked                  = false,
}
Global.__unlock_state = RuntimeState

Global.__unlock_cleanup = function()
    for _, c in ipairs(RuntimeState.Connections) do
        pcall(function() c:Disconnect() end)
    end
    RuntimeState.Connections = {}

    local RS = game:GetService("ReplicatedStorage")
    local ok, cw = pcall(require, RS.Components.Weapon)
    if ok and cw then
        if RuntimeState.OriginalSetSkinOnWep   then cw.SetSkinOnWep             = RuntimeState.OriginalSetSkinOnWep   end
        if RuntimeState.OriginalSetAttachSkins then cw.SetAttachmentSkins        = RuntimeState.OriginalSetAttachSkins end
        if RuntimeState.OriginalSetFullAttach  then cw.SetFullAttachmentOnWeapon = RuntimeState.OriginalSetFullAttach  end
        if RuntimeState.OriginalSetAttachOnWep then cw.SetAttachmentOnWep        = RuntimeState.OriginalSetAttachOnWep end
    end

    RuntimeState.Hooked = false
end

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer       = Players.LocalPlayer

local function safeRawGet(t, k)
    if type(t) ~= "table" then return nil end
    local ok, v = pcall(rawget, t, k)
    return ok and v or nil
end

local function resolveAttachment(slot)
    local name = Settings.Attachments[slot]
    if not name or name == "" then return "" end
    local folder = ReplicatedStorage.Items:FindFirstChild(slot)
    if folder and folder:FindFirstChild(name) then
        return name
    end
    if folder then
        local first = folder:GetChildren()[1]
        if first then return first.Name end
    end
    return ""
end

-- FIXED: removed GetAttribute("Type") check, apply to all MeshPart descendants
local function applyAttachmentSkin(model)
    if not Settings.Enabled then return end
    local skinObj = ReplicatedStorage.Items.AttachmentSkin:FindFirstChild(Settings.AttachmentSkin)
    if not skinObj then return end
    pcall(function()
        for _, descendant in ipairs(model:GetDescendants()) do
            if descendant:IsA("MeshPart") then
                descendant.TextureID = skinObj.Texture
            end
        end
    end)
end

local function getWeaponDataControllers()
    local results = {}
    if type(getgc) ~= "function" then return results end

    local ok, objects = pcall(getgc, true)
    if not ok or type(objects) ~= "table" then return results end

    for _, obj in ipairs(objects) do
        if type(obj) == "table" then
            local tools = safeRawGet(obj, "Tools")
            if type(tools) == "table" then
                if safeRawGet(tools, "Primary") or safeRawGet(tools, "Secondary") or safeRawGet(tools, "Knife") then
                    table.insert(results, obj)
                end
            end
        end
    end

    return results
end

local function applyToWeaponModel(model)
    if not model or not model.Parent then return end
    local ok, cw = pcall(require, ReplicatedStorage.Components.Weapon)
    if not ok or not cw then return end

    if Settings.Enabled then
        if RuntimeState.OriginalSetSkinOnWep then
            pcall(RuntimeState.OriginalSetSkinOnWep, model, Settings.WeaponSkin)
        end
        applyAttachmentSkin(model)
    end

    if Settings.AttachmentsEnabled then
        if cw.SetFullAttachmentOnWeapon then
            pcall(cw.SetFullAttachmentOnWeapon, model, LocalPlayer)
        end
    end
end

-- FIXED: never destroy/replace the model, just swap TextureID + MeshId visually
local function applyKnifeToController(controller)
    if not Settings.KnifeEnabled then return end

    local knifeName   = Settings.Knife
    local knifeFolder = ReplicatedStorage.Items:FindFirstChild("Knife")
    if not knifeFolder then return end

    local sourceKnife = knifeFolder:FindFirstChild(knifeName)
    if not sourceKnife then return end

    local tools = safeRawGet(controller, "Tools")
    if not tools then return end

    local knifeTool = safeRawGet(tools, "Knife")
    if not knifeTool then return end

    local currentModel = safeRawGet(knifeTool, "Model")
    if not currentModel or not currentModel.Parent then return end

    pcall(function()
        -- build lookup of source parts by name
        local sourceParts = {}
        for _, desc in ipairs(sourceKnife:GetDescendants()) do
            if desc:IsA("MeshPart") then
                sourceParts[desc.Name] = desc
            end
        end

        -- swap visuals only on existing model, animation system stays untouched
        for _, desc in ipairs(currentModel:GetDescendants()) do
            if desc:IsA("MeshPart") then
                local src = sourceParts[desc.Name]
                if src then
                    desc.TextureID = src.TextureID
                    desc.MeshId    = src.MeshId
                end
            end
        end
    end)
end

local function applyLive()
    local ok, cw = pcall(require, ReplicatedStorage.Components.Weapon)
    if not ok or not cw then return end

    local controllers = getWeaponDataControllers()

    for _, controller in ipairs(controllers) do
        local tools = safeRawGet(controller, "Tools")
        if not tools then continue end

        for _, slot in ipairs({"Primary", "Secondary"}) do
            local toolData = safeRawGet(tools, slot)
            if toolData then
                local model = safeRawGet(toolData, "Model")
                if model and model.Parent then
                    applyToWeaponModel(model)
                end
            end
        end

        applyKnifeToController(controller)
    end
end

local function applyToCharacter(character)
    if not character then return end
    local ok, cw = pcall(require, ReplicatedStorage.Components.Weapon)
    if not ok or not cw then return end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, child in ipairs(tool:GetChildren()) do
                if child:IsA("Model") then
                    if Settings.Enabled and RuntimeState.OriginalSetSkinOnWep then
                        pcall(RuntimeState.OriginalSetSkinOnWep, child, Settings.WeaponSkin)
                    end
                    applyAttachmentSkin(child)
                    if Settings.AttachmentsEnabled and cw.SetFullAttachmentOnWeapon then
                        pcall(cw.SetFullAttachmentOnWeapon, child, LocalPlayer)
                    end
                end
            end
        end
    end
end

Settings.ApplyToCharacter = function()
    applyLive()
    applyToCharacter(LocalPlayer.Character)
end

local function hookModules()
    if RuntimeState.Hooked then return end

    local ok, cw = pcall(require, ReplicatedStorage.Components.Weapon)
    if not ok or not cw then
        warn("[UnlockAll] Failed to require Components.Weapon")
        return
    end

    RuntimeState.OriginalSetSkinOnWep   = cw.SetSkinOnWep
    RuntimeState.OriginalSetAttachSkins = cw.SetAttachmentSkins
    RuntimeState.OriginalSetFullAttach  = cw.SetFullAttachmentOnWeapon
    RuntimeState.OriginalSetAttachOnWep = cw.SetAttachmentOnWep

    cw.SetSkinOnWep = function(model, skin)
        if Global.__unlock_state ~= RuntimeState then
            return RuntimeState.OriginalSetSkinOnWep(model, skin)
        end
        if not Settings.Enabled then
            return RuntimeState.OriginalSetSkinOnWep(model, skin)
        end
        return RuntimeState.OriginalSetSkinOnWep(model, Settings.WeaponSkin)
    end

    cw.SetAttachmentSkins = function(model, loadout, class)
        if Global.__unlock_state ~= RuntimeState then
            return RuntimeState.OriginalSetAttachSkins(model, loadout, class)
        end
        if not Settings.Enabled then
            return RuntimeState.OriginalSetAttachSkins(model, loadout, class)
        end
        applyAttachmentSkin(model)
    end

    cw.SetAttachmentOnWep = function(weaponModel, slotName, attachmentName, player)
        if Global.__unlock_state ~= RuntimeState then
            return RuntimeState.OriginalSetAttachOnWep(weaponModel, slotName, attachmentName, player)
        end
        if not Settings.AttachmentsEnabled then
            return RuntimeState.OriginalSetAttachOnWep(weaponModel, slotName, attachmentName, player)
        end
        local override = resolveAttachment(slotName)
        if override ~= "" then
            return RuntimeState.OriginalSetAttachOnWep(weaponModel, slotName, override, player)
        else
            return RuntimeState.OriginalSetAttachOnWep(weaponModel, slotName, attachmentName, player)
        end
    end

    cw.SetFullAttachmentOnWeapon = function(weaponModel, player)
        if Global.__unlock_state ~= RuntimeState then
            return RuntimeState.OriginalSetFullAttach(weaponModel, player)
        end
        return RuntimeState.OriginalSetFullAttach(weaponModel, player)
    end

    RuntimeState.Hooked = true
end

hookModules()

applyLive()

if LocalPlayer.Character then
    applyToCharacter(LocalPlayer.Character)
end

table.insert(RuntimeState.Connections,
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        if Global.__unlock_state ~= RuntimeState then return end
        task.wait(2)
        applyToCharacter(newChar)
        applyLive()
    end)
)