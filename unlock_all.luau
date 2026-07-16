if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Settings = {
    Enabled             = false,
    WeaponSkin          = "Crystalline",
    AttachmentSkin        = "Gold",
    AttachmentsEnabled = false,
    Attachments = {
        Sight  = "Compact",          
        Grip   = "Vertical Grip",
        Muzzle = "Silencer",     
        Extra  = "",              
    },
}

if getgenv().SkinSettings then
    Settings.Enabled = getgenv().SkinSettings.Enabled
    Settings.WeaponSkin = getgenv().SkinSettings.WeaponSkin
    Settings.AttachmentSkin = getgenv().SkinSettings.AttachmentSkin
end

local Global = getgenv()
Global.SkinSettings = Settings
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
        if RuntimeState.OriginalSetSkinOnWep   then cw.SetSkinOnWep          = RuntimeState.OriginalSetSkinOnWep   end
        if RuntimeState.OriginalSetAttachSkins then cw.SetAttachmentSkins     = RuntimeState.OriginalSetAttachSkins end
        if RuntimeState.OriginalSetFullAttach  then cw.SetFullAttachmentOnWeapon = RuntimeState.OriginalSetFullAttach end
        if RuntimeState.OriginalSetAttachOnWep then cw.SetAttachmentOnWep     = RuntimeState.OriginalSetAttachOnWep end
    end

    RuntimeState.Hooked = false
end

local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer      = Players.LocalPlayer

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

local function applyAttachmentSkin(model)
    if not Settings.Enabled then return end
    local skinObj = ReplicatedStorage.Items.AttachmentSkin:FindFirstChild(Settings.AttachmentSkin)
    if not skinObj then return end
    pcall(function()
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA("Model") and child:GetAttribute("Type") then
                for _, part in ipairs(child:GetChildren()) do
                    if part:IsA("MeshPart") then
                        part.TextureID = skinObj.Texture
                    end
                end
            end
        end
    end)
end

local function applyToCharacter(character)
    if not character then return end
    local ok, cw = pcall(require, ReplicatedStorage.Components.Weapon)
    if not ok or not cw then return end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, child in ipairs(tool:GetChildren()) do
                if child:IsA("Model") then
                    -- Weapon body skin
                    if Settings.Enabled and RuntimeState.OriginalSetSkinOnWep then
                        pcall(RuntimeState.OriginalSetSkinOnWep, child, Settings.WeaponSkin)
                    end
                    -- Attachment skins
                    applyAttachmentSkin(child)
                    -- Physical attachments
                    if Settings.AttachmentsEnabled and cw.SetFullAttachmentOnWeapon then
                        pcall(cw.SetFullAttachmentOnWeapon, child, LocalPlayer)
                    end
                end
            end
        end
    end
end

Settings.ApplyToCharacter = function()
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
            -- Slot disabled in Settings (left as ""), keep original behaviour
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

local character = LocalPlayer.Character
if character then
    applyToCharacter(character)
end

table.insert(RuntimeState.Connections,
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        if Global.__unlock_state ~= RuntimeState then return end
        task.wait(2)
        applyToCharacter(newChar)
    end)
)

