if not game:IsLoaded() then
    game.Loaded:Wait()
end

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ResolutionSettings = getgenv().ResolutionSettings or {
    Enabled            = false,
    HorizontalStretch = 100,
    VerticalStretch   = 100,
}
getgenv().ResolutionSettings = ResolutionSettings

local Global = getgenv()
if Global.__resolution_cleanup then
    pcall(Global.__resolution_cleanup)
end

local RuntimeState = {
    Connections = {},
}

Global.__resolution_state = RuntimeState
Global.__resolution_cleanup = function()
    for _, Connection in ipairs(RuntimeState.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end
end

local prevCFrame = nil

table.insert(RuntimeState.Connections,
    RunService.RenderStepped:Connect(function()
        if not ResolutionSettings.Enabled then
            prevCFrame = nil
            return
        end

        local cam = Workspace.CurrentCamera
        if not cam then return end

        local cf = cam.CFrame
        if prevCFrame and cf == prevCFrame then return end

        local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cf:GetComponents()
        local h = ResolutionSettings.HorizontalStretch / 100
        local v = ResolutionSettings.VerticalStretch   / 100

        prevCFrame = CFrame.new(X, Y, Z, R00*h, R01*v, R02, R10, R11*v, R12, R20*h, R21*v, R22)
        cam.CFrame = prevCFrame
    end)
)