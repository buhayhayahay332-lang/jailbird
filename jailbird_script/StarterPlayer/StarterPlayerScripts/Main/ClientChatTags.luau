
local TextChatService = game:GetService("TextChatService");
local Players = game:GetService("Players");
local ChatTags = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ChatTags");
local Utility = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Utility"));
local v1 = {};

function TextChatService.OnIncomingMessage(p2) -- Line: 16
    -- upvalues: Players (copy), ChatTags (copy)
    local TextChatMessageProperties = Instance.new("TextChatMessageProperties");

    if p2.TextSource then
        local v3 = Players:GetPlayerByUserId(p2.TextSource.UserId);
        local v4 = ChatTags.GetPlayerTag:InvokeServer(v3);

        if v4 then
            TextChatMessageProperties.PrefixText = "<font color=\'#" .. tostring(v4.TagColor:ToHex()) .. "\'>[" .. tostring(v4.TagText) .. "]</font> " .. p2.PrefixText;
        end;
    end;

    return TextChatMessageProperties;
end;

Utility:DeepFreeze(v1);

return v1;