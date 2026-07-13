local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local GunModSettings = getgenv().GunModSettings or {
    Enabled = false,
    NoRecoil = false,
    NoSpread = false,
    FasterFire = false,
    FireRateMultiplier = 1.35,
    Verbose = false,
}

getgenv().GunModSettings = GunModSettings

local originalSettings = setmetatable({}, { __mode = "k" })
local seenTools = setmetatable({}, { __mode = "k" })

local function log(...)
    if GunModSettings.Verbose then
        warn("[gun_mod]", ...)
    end
end

local function looksLikeWeaponSettings(settings)
    if type(settings) ~= "table" then
        return false
    end

    local score = 0

    if type(settings.FireRate) == "number" then
        score = score + 1
    end

    if type(settings.MinSpread) == "number" then
        score = score + 1
    end

    if type(settings.MaxSpread) == "number" then
        score = score + 1
    end

    if type(settings.VRecoil) == "number" then
        score = score + 1
    end

    if type(settings.HRecoil) == "number" then
        score = score + 1
    end

    return score >= 3
end

local function getToolSettingsModule(tool)
    if not tool or not tool:IsA("Tool") then
        return nil
    end

    local settingsModule = tool:FindFirstChild("Settings")
    if settingsModule and settingsModule:IsA("ModuleScript") then
        return settingsModule
    end

    return nil
end

local function captureOriginals(settings)
    local cached = originalSettings[settings]
    if cached then
        return cached
    end

    cached = {
        FireRate = settings.FireRate,
        MinSpread = settings.MinSpread,
        MaxSpread = settings.MaxSpread,
        VRecoil = settings.VRecoil,
        HRecoil = settings.HRecoil,
    }

    originalSettings[settings] = cached
    return cached
end

local function applySettings(settings)
    if not looksLikeWeaponSettings(settings) then
        return
    end

    local original = captureOriginals(settings)

    if GunModSettings.NoRecoil == true then
        settings.VRecoil = 0
        settings.HRecoil = 0
    else
        settings.VRecoil = original.VRecoil
        settings.HRecoil = original.HRecoil
    end

    if GunModSettings.NoSpread == true then
        settings.MinSpread = 0
        settings.MaxSpread = 0
    else
        settings.MinSpread = original.MinSpread
        settings.MaxSpread = original.MaxSpread
    end

    if GunModSettings.FasterFire == true then
        local multiplier = tonumber(GunModSettings.FireRateMultiplier) or 1
        if multiplier < 1 then
            multiplier = 1
        end

        local fireRate = tonumber(original.FireRate) or tonumber(settings.FireRate) or 0
        if fireRate > 0 then
            settings.FireRate = math.max(1, math.floor(fireRate * multiplier))
        end
    else
        settings.FireRate = original.FireRate
    end
end

local function installCloneHook()
    if type(hookfunction) ~= "function" or type(table.clone) ~= "function" then
        return false
    end

    local originalClone
    originalClone = hookfunction(table.clone, function(value)
        local clone = originalClone(value)

        if GunModSettings.Enabled == true and looksLikeWeaponSettings(value) then
            applySettings(clone)
        end

        return clone
    end)

    return true
end

installCloneHook()

local function restoreAllSettings()
    for settings, original in pairs(originalSettings) do
        if type(settings) == "table" and type(original) == "table" then
            settings.FireRate = original.FireRate
            settings.MinSpread = original.MinSpread
            settings.MaxSpread = original.MaxSpread
            settings.VRecoil = original.VRecoil
            settings.HRecoil = original.HRecoil
        end
    end
end

local function processTool(tool)
    local settingsModule = getToolSettingsModule(tool)
    if not settingsModule then
        return
    end

    local ok, settings = pcall(require, settingsModule)
    if not ok or type(settings) ~= "table" then
        return
    end

    if seenTools[tool] ~= true then
        seenTools[tool] = true
        log("found weapon settings", tool:GetFullName(), settingsModule:GetFullName())
    end

    applySettings(settings)
end

local function scanContainer(container)
    if not container then
        return
    end

    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Tool") then
            processTool(child)
        end
    end
end

local function scanPlayer()
    if not LocalPlayer then
        return
    end

    scanContainer(LocalPlayer.Character)
    scanContainer(LocalPlayer:FindFirstChildOfClass("Backpack"))
end

local function hookContainer(container)
    if not container then
        return
    end

    container.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.defer(processTool, child)
        end
    end)
end

task.defer(function()
    local wasEnabled = GunModSettings.Enabled == true

    while true do
        local enabled = GunModSettings.Enabled == true

        if enabled then
            scanPlayer()
        elseif wasEnabled then
            restoreAllSettings()
        end

        wasEnabled = enabled
        task.wait(0.25)
    end
end)

hookContainer(LocalPlayer.Character)
hookContainer(LocalPlayer:FindFirstChildOfClass("Backpack"))

LocalPlayer.CharacterAdded:Connect(function(character)
    hookContainer(character)
    task.defer(scanPlayer)
end)
