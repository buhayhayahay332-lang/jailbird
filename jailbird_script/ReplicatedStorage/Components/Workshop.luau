
game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Config);
game:GetService("Players");

return {
    Store = { {
            Name = "Boon",
            Type = "Head"
        }, {
            Name = "Boon",
            Type = "Top"
        }, {
            Name = "Boon",
            Type = "Bottom"
        } }
};