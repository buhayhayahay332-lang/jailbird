if not game:IsLoaded() then
    game.Loaded:Wait()
end

local SkinSettings = {
    Enabled = true,
    WeaponSkin = "Crystalline",
    AttachmentSkin = "Gold"
}

local Global = getgenv()
Global.SkinSettings = SkinSettings

if Global.__skin_cleanup then
    pcall(Global.__skin_cleanup)
end

local RuntimeState = {
    Connections = {},
    OriginalSetSkinOnWep = nil,
    OriginalSetAttachmentSkins = nil,
    Hooked = false
}

Global.__skin_state = RuntimeState

Global.__skin_cleanup = function()
    for _, Connection in ipairs(RuntimeState.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    local replicatedStorage = game:GetService("ReplicatedStorage")
    local ok, componentsWeapon = pcall(require, replicatedStorage.Components.Weapon)
    if ok and componentsWeapon then
        if RuntimeState.OriginalSetSkinOnWep then
            componentsWeapon.SetSkinOnWep = RuntimeState.OriginalSetSkinOnWep
        end
        if RuntimeState.OriginalSetAttachmentSkins then
            componentsWeapon.SetAttachmentSkins = RuntimeState.OriginalSetAttachmentSkins
        end
    end

    RuntimeState.Hooked = false
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function applyWeaponSkin(model, componentsWeapon)
    if not model or not SkinSettings.Enabled then return end
    pcall(function()
        RuntimeState.OriginalSetSkinOnWep(model, SkinSettings.WeaponSkin)
    end)
end

local function applyAttachmentSkin(model, componentsWeapon)
    if not model or not SkinSettings.Enabled then return end
    local skinObj = ReplicatedStorage.Items.AttachmentSkin:FindFirstChild(SkinSettings.AttachmentSkin)
    if not skinObj then return end

    pcall(function()
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA("Model") and child:GetAttribute("Type") then
                for _, child2 in ipairs(child:GetChildren()) do
                    if child2:IsA("MeshPart") then
                        child2.TextureID = skinObj.Texture
                    end
                end
            end
        end
    end)
end

local function applyToCharacter(character)
    if not character then return end
    local ok, componentsWeapon = pcall(require, ReplicatedStorage.Components.Weapon)
    if not ok or not componentsWeapon then return end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, child in ipairs(tool:GetChildren()) do
                if child:IsA("Model") then
                    applyWeaponSkin(child, componentsWeapon)
                    applyAttachmentSkin(child, componentsWeapon)
                end
            end
        end
    end
end

local function hookModules()
    if RuntimeState.Hooked then return end

    local ok, componentsWeapon = pcall(require, ReplicatedStorage.Components.Weapon)
    if not ok or not componentsWeapon then
        warn("[SkinChanger] Failed to require Components.Weapon")
        return
    end

    RuntimeState.OriginalSetSkinOnWep = componentsWeapon.SetSkinOnWep
    RuntimeState.OriginalSetAttachmentSkins = componentsWeapon.SetAttachmentSkins

    componentsWeapon.SetSkinOnWep = function(model, skin)
        if Global.__skin_state ~= RuntimeState then
            return RuntimeState.OriginalSetSkinOnWep(model, skin)
        end
        if not SkinSettings.Enabled then
            return RuntimeState.OriginalSetSkinOnWep(model, skin)
        end
        return RuntimeState.OriginalSetSkinOnWep(model, SkinSettings.WeaponSkin)
    end

    componentsWeapon.SetAttachmentSkins = function(model, loadout, class)
        if Global.__skin_state ~= RuntimeState then
            return RuntimeState.OriginalSetAttachmentSkins(model, loadout, class)
        end
        if not SkinSettings.Enabled then
            return RuntimeState.OriginalSetAttachmentSkins(model, loadout, class)
        end
        applyAttachmentSkin(model, componentsWeapon)
    end

    RuntimeState.Hooked = true
    print("[SkinChanger] Hooked — Weapon: " .. SkinSettings.WeaponSkin .. " | Attachment: " .. SkinSettings.AttachmentSkin)
end

hookModules()

local character = LocalPlayer.Character
if character then
    applyToCharacter(character)
end

table.insert(RuntimeState.Connections, LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    if Global.__skin_state ~= RuntimeState then return end
    task.wait(2)
    applyToCharacter(newCharacter)
end))
