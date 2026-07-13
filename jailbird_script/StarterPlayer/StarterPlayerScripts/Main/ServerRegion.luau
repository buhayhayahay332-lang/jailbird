
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"));
local CountryLabel = LocalPlayer.PlayerGui:WaitForChild("GameHUD"):WaitForChild("PlayersTab"):WaitForChild("ServerRegion"):WaitForChild("CountryLabel");
local v1 = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ServerRegion"):WaitForChild("GetServerRegion"):InvokeServer();
local v2 = `[{script.Name}] `;
local v3 = {};

if v1 then
    CountryLabel.Text = tostring(v1[1]);
else
    warn(v2 .. "Failed to fetch server region data: " .. tostring(v1));
end;

Utility:DeepFreeze(v3);

return v3;