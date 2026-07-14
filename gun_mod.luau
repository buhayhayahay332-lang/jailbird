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
local hookedTools = setmetatable({}, { __mode = "k" })

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

local function safeRawGet(value, key)
    if type(value) ~= "table" then
        return nil
    end

    local ok, result = pcall(rawget, value, key)
    if ok then
        return result
    end

    return nil
end

local function processRuntimeToolData(toolData)
    if type(toolData) ~= "table" then
        return false
    end

    local settings = safeRawGet(toolData, "Settings")
    if looksLikeWeaponSettings(settings) then
        applySettings(settings)
        return true
    end

    return false
end

local function processWeaponController(controller)
    local patched = false
    local currentTool = safeRawGet(controller, "CurrentTool")
    local tools = safeRawGet(controller, "Tools")

    if processRuntimeToolData(currentTool) then
        patched = true
    end

    if type(tools) == "table" then
        for _, toolData in pairs(tools) do
            if processRuntimeToolData(toolData) then
                patched = true
            end
        end
    end

    return patched
end

local function scanRuntimeWeaponData()
    if type(getgc) ~= "function" then
        return false
    end

    local ok, objects = pcall(getgc, true)
    if not ok or type(objects) ~= "table" then
        return false
    end

    local patched = false

    for _, object in ipairs(objects) do
        if type(object) == "table" then
            local currentTool = safeRawGet(object, "CurrentTool")
            local tools = safeRawGet(object, "Tools")

            if type(currentTool) == "table" or type(tools) == "table" then
                if processWeaponController(object) then
                    patched = true
                end
            end
        end
    end

    return patched
end

local function scanRuntimeWeaponDataDelayed()
    task.defer(scanRuntimeWeaponData)

    for i = 1, 8 do
        task.delay(i * 0.15, scanRuntimeWeaponData)
    end
end

local function installCloneHook()
    if type(hookfunction) ~= "function" or type(table.clone) ~= "function" then
        return false
    end

    local originalClone
    local ok, hookedClone = pcall(hookfunction, table.clone, function(value)
        local clone = originalClone(value)

        if GunModSettings.Enabled == true and looksLikeWeaponSettings(value) then
            applySettings(clone)
        end

        return clone
    end)

    if not ok then
        return false
    end

    originalClone = hookedClone
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
    if GunModSettings.Enabled ~= true then
        return
    end

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

local function hookTool(tool)
    if not tool or not tool:IsA("Tool") or hookedTools[tool] == true then
        return
    end

    hookedTools[tool] = true

    tool.Equipped:Connect(function()
        scanRuntimeWeaponDataDelayed()
    end)

    tool.ChildAdded:Connect(function(child)
        if child.Name == "Settings" then
            scanRuntimeWeaponDataDelayed()
        end
    end)
end

local function scanContainer(container)
    if not container then
        return
    end

    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Tool") then
            hookTool(child)
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
            hookTool(child)
            scanRuntimeWeaponDataDelayed()
            task.defer(processTool, child)
        end
    end)
end

task.defer(function()
    local wasEnabled = GunModSettings.Enabled == true
    local lastRuntimeScan = 0

    while true do
        local enabled = GunModSettings.Enabled == true

        if enabled then
            scanPlayer()

            if os.clock() - lastRuntimeScan >= 1 then
                lastRuntimeScan = os.clock()
                scanRuntimeWeaponData()
            end
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
