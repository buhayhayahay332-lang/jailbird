
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Constants"));
local Server = ReplicatedStorage:WaitForChild("Server");
require(ReplicatedStorage.Modules.TypeModules.InvasionTypes);
local v1 = Server:GetAttribute("GameMode");
local ClientInvasion = require(script:WaitForChild("ClientInvasion"));

if v1 == Constants.INVASION then
    ClientInvasion("Spooky");

    return true;
end;

print("Current game mode is not invasion");

return false;