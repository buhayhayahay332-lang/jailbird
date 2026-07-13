
local CollectionService = game:GetService("CollectionService");
game:GetService("Players");

return table.freeze({
    setProximityPrompts = function(p1) -- Line: 13, Name: setProximityPrompts
        -- upvalues: CollectionService (copy)
        local v2 = CollectionService:GetTagged("BarricadeFrame");

        if #v2 > 0 then
            for _, v in pairs(v2) do
                local ProximityPrompt = v:FindFirstChild("ProximityPrompt", true);

                if ProximityPrompt then
                    ProximityPrompt.Enabled = p1;
                end;
            end;
        end;
    end
});