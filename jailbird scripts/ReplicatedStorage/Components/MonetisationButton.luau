
require(script.Parent.Parent.PlayerManager);
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local Config = require(game.ReplicatedStorage.Config);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 9
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3.Instance = p2;
    v3.Debounce = true;

    return v3;
end;

function u1.Init(u4) -- Line: 17
    -- upvalues: Config (copy)
    u4.Instance.Activated:Connect(function(...) -- Line: 18
        -- upvalues: Config (ref), u4 (copy)
        Config.AddSound("Click_1", 1, true, game.SoundService, false);
        u4:Press(...);
    end);
end;

function u1.Press(p5, p6) -- Line: 24
    -- upvalues: Players (copy), MarketplaceService (copy)
    p5.Instance:GetAttribute("Id");
    local v7 = Players:GetPlayerFromCharacter(p6.Parent);

    if v7 == p5.Tycoon.Owner then
        if p5.Instance:GetAttribute("Type") == "DevProduct" then
            MarketplaceService:PromptProductPurchase(v7, p5.Instance:GetAttribute("ID"));

            return;
        end;

        if p5.Instance:GetAttribute("Type") == "GamePass" then
            MarketplaceService:PromptGamePassPurchase(v7, p5.Instance:GetAttribute("ID"));
        end;
    end;
end;

return u1;