-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local AttachmentSkinUnlockedEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("AttachmentSkinUnlockedEvent")
local AttachmentUnlocked = Players.LocalPlayer.PlayerGui:WaitForChild("GameMenu"):WaitForChild("AttachmentUnlocked")
local AttachmentNotificationSFX = SoundService:WaitForChild("UI"):WaitForChild("AttachmentNotificationSFX")
local t = {}
local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
local v2 = nil
local v3 = nil
local v4 = false

local function notificationFlyIn() --[[ notificationFlyIn | Line: 41 | Upvalues: v2 (ref) ]]
	v2:Play()
	v2.Completed:Wait()
end

local function notificationFlyOut() --[[ notificationFlyOut | Line: 46 | Upvalues: v3 (ref) ]]
	v3:Play()
	v3.Completed:Wait()
end

local function setSkinImage(p1) --[[ setSkinImage | Line: 51 | Upvalues: ReplicatedStorage (copy), AttachmentUnlocked (copy), ContentProvider (copy) ]]
	local v1 = ReplicatedStorage.Items.AttachmentSkin:FindFirstChild(p1)

	if v1 then
		AttachmentUnlocked.ImageContainer.Frame.ImageLabel.Image = v1.Texture
		ContentProvider:PreloadAsync({ AttachmentUnlocked.ImageContainer.Frame.ImageLabel })
	else
		AttachmentUnlocked.ImageContainer.Frame.ImageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		warn((("[%*] Player unlocked an attachment skin but failed to display the texture because could not find a skin with the name \"%*\""):format(script.Name, p1)))
	end
end

local function onAttachmentSkinUnlockedEvent(p1, p2, p3) --[[ onAttachmentSkinUnlockedEvent | Line: 63 | Upvalues: t (copy), v4 (ref), setSkinImage (copy), AttachmentUnlocked (copy), AttachmentNotificationSFX (copy), v2 (ref), v3 (ref) ]]
	table.insert(t, {
		weaponName = p1,
		skinName = p2
	})

	if v4 then
		return
	end

	v4 = true

	while #t > 0 do
		local _ = t[1]

		table.remove(t, 1)
		setSkinImage(p2)
		AttachmentUnlocked.TextLabelContainer.TextLabel1.Text = ("%* Unlocked"):format(p2)
		AttachmentUnlocked.TextLabelContainer.TextLabel2.Text = ("%* %*"):format(p1, p3)
		AttachmentNotificationSFX:Play()
		v2:Play()
		v2.Completed:Wait()
		task.wait(4)
		v3:Play()
		v3.Completed:Wait()
		task.wait(0.25)
	end

	v4 = false
end

ContentProvider:PreloadAsync({ AttachmentNotificationSFX })
v2 = TweenService:Create(AttachmentUnlocked, v1, {
	Position = UDim2.new(1, -20, 0.225, 0)
})
v3 = TweenService:Create(AttachmentUnlocked, v1, {
	Position = UDim2.new(1.5, -20, 0.225, 0)
})
task.spawn(notificationFlyOut)
AttachmentSkinUnlockedEvent.OnClientEvent:Connect(onAttachmentSkinUnlockedEvent)

return true