local v1 = game:GetService("ReplicatedStorage")
local v2 = require(v1:WaitForChild("Modules"):WaitForChild("Constants"))
local v3 = v1:WaitForChild("Server")
require(v1.Modules.TypeModules.InvasionTypes)
local v4 = v3:GetAttribute("GameMode")
local v5 = require(script:WaitForChild("ClientInvasion"))
if v4 == v2.INVASION then
	v5("Spooky")
	return true
else
	print("Current game mode is not invasion")
	return false
end