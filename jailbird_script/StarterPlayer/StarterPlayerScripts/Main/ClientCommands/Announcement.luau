
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RBXSystem = game:GetService("TextChatService"):WaitForChild("TextChannels"):WaitForChild("RBXSystem");

local function formatString(p1, p2, p3) -- Line: 7
    if p3 == "" then
        return `<font color="#{p2}">{p1}</font>`;
    end;

    return `<font color="#{p2}" size="{p3}">{p1}</font>`;
end;

ReplicatedStorage.Events:WaitForChild("ChatAnnouncement").OnClientEvent:Connect(function(p4, p5, p6) -- Line: 15, Name: onChatAnnouncement
    -- upvalues: RBXSystem (copy)
    local v7;

    if p6 == "" then
        v7 = `<font color="#{p5}">{p4}</font>`;
    else
        v7 = `<font color="#{p5}" size="{p6}">{p4}</font>`;
    end;

    RBXSystem:DisplaySystemMessage(v7);
end);

return true;