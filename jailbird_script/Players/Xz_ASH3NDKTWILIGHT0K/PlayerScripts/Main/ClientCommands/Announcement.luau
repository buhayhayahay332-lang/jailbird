-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RBXSystem = game:GetService("TextChatService"):WaitForChild("TextChannels"):WaitForChild("RBXSystem")

local function formatString(p1, p2, p3) --[[ formatString | Line: 7 ]]
	if p3 == "" then
		return ("<font color=\"#%*\">%*</font>"):format(p2, p1)
	end

	return ("<font color=\"#%*\" size=\"%*\">%*</font>"):format(p2, p3, p1)
end

local function onChatAnnouncement(p1, p2, p3) --[[ onChatAnnouncement | Line: 15 | Upvalues: RBXSystem (copy) ]]
	RBXSystem:DisplaySystemMessage(if p3 == "" then ("<font color=\"#%*\">%*</font>"):format(p2, p1) else ("<font color=\"#%*\" size=\"%*\">%*</font>"):format(p2, p3, p1))
end

ReplicatedStorage.Events:WaitForChild("ChatAnnouncement").OnClientEvent:Connect(onChatAnnouncement)

return true