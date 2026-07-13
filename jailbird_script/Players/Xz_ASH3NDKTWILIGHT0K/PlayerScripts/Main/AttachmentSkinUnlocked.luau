
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local Players = game:GetService("Players");
local AttachmentSkinUnlockedEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("AttachmentSkinUnlockedEvent");
local AttachmentUnlocked = Players.LocalPlayer.PlayerGui:WaitForChild("GameMenu"):WaitForChild("AttachmentUnlocked");
local AttachmentNotificationSFX = SoundService:WaitForChild("UI"):WaitForChild("AttachmentNotificationSFX");
local u1 = {};
local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Linear);
local u3 = nil;
local u4 = nil;
local u5 = false;

local function notificationFlyIn() -- Line: 41
    -- upvalues: u3 (ref)
    u3:Play();
    u3.Completed:Wait();
end;

local function notificationFlyOut() -- Line: 46
    -- upvalues: u4 (ref)
    u4:Play();
    u4.Completed:Wait();
end;

local function setSkinImage(p6) -- Line: 51
    -- upvalues: ReplicatedStorage (copy), AttachmentUnlocked (copy), ContentProvider (copy)
    local v7 = ReplicatedStorage.Items.AttachmentSkin:FindFirstChild(p6);

    if v7 then
        AttachmentUnlocked.ImageContainer.Frame.ImageLabel.Image = v7.Texture;
        ContentProvider:PreloadAsync({ AttachmentUnlocked.ImageContainer.Frame.ImageLabel });

        return;
    end;

    AttachmentUnlocked.ImageContainer.Frame.ImageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
    warn((`[{script.Name}] Player unlocked an attachment skin but failed to display the texture because could not find a skin with the name "{p6}"`));
end;

local function onAttachmentSkinUnlockedEvent(p8, p9, p10) -- Line: 63
    -- upvalues: u1 (copy), u5 (ref), setSkinImage (copy), AttachmentUnlocked (copy), AttachmentNotificationSFX (copy), u3 (ref), u4 (ref)
    table.insert(u1, {
        weaponName = p8,
        skinName = p9
    });

    if u5 then
        return;
    end;

    u5 = true;

    while #u1 > 0 do
        local _ = u1[1];
        table.remove(u1, 1);
        setSkinImage(p9);
        AttachmentUnlocked.TextLabelContainer.TextLabel1.Text = `{p9} Unlocked`;
        AttachmentUnlocked.TextLabelContainer.TextLabel2.Text = `{p8} {p10}`;
        AttachmentNotificationSFX:Play();
        u3:Play();
        u3.Completed:Wait();
        task.wait(4);
        u4:Play();
        u4.Completed:Wait();
        task.wait(0.25);
    end;

    u5 = false;
end;

ContentProvider:PreloadAsync({ AttachmentNotificationSFX });
u3 = TweenService:Create(AttachmentUnlocked, v2, {
    Position = UDim2.new(1, -20, 0.225, 0)
});
u4 = TweenService:Create(AttachmentUnlocked, v2, {
    Position = UDim2.new(1.5, -20, 0.225, 0)
});
task.spawn(notificationFlyOut);
AttachmentSkinUnlockedEvent.OnClientEvent:Connect(onAttachmentSkinUnlockedEvent);

return true;