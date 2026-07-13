
local MarketplaceService = game:GetService("MarketplaceService");
game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
game:GetService("SocialService");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local RunService = game:GetService("RunService");
game:GetService("Lighting");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local TeleportService = game:GetService("TeleportService");
local AvatarEditorService = game:GetService("AvatarEditorService");
local Weapon = require(ReplicatedStorage.Components.Weapon);
local Config = require(ReplicatedStorage.Config);
local Leaderboard = require(ReplicatedStorage.Components.Leaderboard);
local Rank = require(ReplicatedStorage.Components.Rank);
require(ReplicatedStorage.Components.Player);
local Gamepasses = require(ReplicatedStorage.Components.Gamepasses);
require(ReplicatedStorage.Components["Daily Rewards"]);
local LoginRewards = require(ReplicatedStorage.Components.LoginRewards);
local UpdateLogs = require(ReplicatedStorage.Components.UpdateLogs);
require(ReplicatedStorage.Components.CampaignIndex);
local Crates = require(ReplicatedStorage.Components.Crates);
local Challenges = require(ReplicatedStorage.Components.Challenges);
local Keybinds = require(ReplicatedStorage.Components.Keybinds);
require(ReplicatedStorage.Modules.TypeModules.Types);
local Utility = require(ReplicatedStorage.Modules.Utility);
local LocalPlayer = Players.LocalPlayer;
local u1;

if RunService:IsClient() and LocalPlayer then
    u1 = LocalPlayer:GetMouse();
else
    u1 = nil;
end;

local u2 = {
    CurrentMain = nil,
    OpenPageEnabled = true
};
local u3 = 0;
local AttachmentSkinHandler = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("AttachmentSkinHandler"));
local u4 = {};
local u5 = {};
local u6 = false;
local u7 = nil;

if LocalPlayer and game.PlaceId == Config.LobbyID then
    u7 = LocalPlayer.PlayerGui:WaitForChild("Main");
elseif LocalPlayer and game.PlaceId == Config.InGameID then
    u7 = LocalPlayer.PlayerGui:WaitForChild("Menu");
end;

local u8 = {
    Cash = true,
    Credit = true,
    CampaignPoints = true
};

local function ApplyCurrencyGradient(p9, p10) -- Line: 72
    -- upvalues: u8 (copy)
    if not (p9 and p9:IsA("ImageLabel")) then
        return;
    end;

    for _, child in ipairs(p9:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;

    if u8[p10 or ""] ~= true then
        return;
    end;

    local Main2 = game:GetService("StarterGui"):FindFirstChild("Main");
    local v11 = Main2 and Main2:FindFirstChild("Top") and Main2.Top:FindFirstChild("Currency");

    if v11 then
        v11 = v11:FindFirstChild(p10);
    end;

    if v11 then
        v11 = v11:FindFirstChild("Icon");
    end;

    if v11 then
        v11 = v11:FindFirstChildOfClass("UIGradient");
    end;

    if v11 then
        v11:Clone().Parent = p9;
    end;
end;

local function ApplyCurrencyDisplayState(p12, p13, p14) -- Line: 97
    -- upvalues: u8 (copy)
    if not (p12 and p12:IsA("ImageLabel")) then
        return;
    end;

    local v15 = u8[p13 or ""] == true;
    local v16 = p12:GetAttribute("DefaultImageTransparency");

    if v16 == nil then
        v16 = p12.ImageTransparency;
        p12:SetAttribute("DefaultImageTransparency", v16);
    end;

    p12.ImageTransparency = v15 and 0 or v16;

    if p14 and p14:IsA("GuiObject") then
        local v17 = p14:GetAttribute("DefaultVisible");

        if v17 == nil then
            v17 = p14.Visible;
            p14:SetAttribute("DefaultVisible", v17);
        end;

        if v15 then
            p14.Visible = false;

            return;
        end;

        p14.Visible = v17;
    end;
end;

local function GetDisplayedLoadoutName(p18) -- Line: 124
    -- upvalues: Config (copy)
    local PlayerData = p18:FindFirstChild("PlayerData");

    if not PlayerData then
        return "Default";
    end;

    local Settings = PlayerData:FindFirstChild("Settings");
    local Loadout = PlayerData:FindFirstChild("Loadout");

    if not (Settings and Loadout) then
        return "Default";
    end;

    local v19 = Settings:GetAttribute("LoadoutName") or "Default";

    if game.PlaceId ~= Config.InGameID then
        return v19;
    end;

    local ServerData = p18:FindFirstChild("ServerData");

    if ServerData then
        ServerData = ServerData:GetAttribute("NextLoadout");
    end;

    if typeof(ServerData) == "string" and (ServerData ~= "" and Loadout:FindFirstChild(ServerData)) then
        return ServerData;
    end;

    return v19;
end;

local function GetDisplayedLoadoutFolder(p20) -- Line: 146
    -- upvalues: GetDisplayedLoadoutName (copy)
    local PlayerData = p20:FindFirstChild("PlayerData");

    if not PlayerData then
        return nil;
    end;

    local Loadout = PlayerData:FindFirstChild("Loadout");

    if Loadout then
        return Loadout:FindFirstChild((GetDisplayedLoadoutName(p20)));
    end;

    return nil;
end;

local function GetLoadoutScrollerItemKey(p21) -- Line: 156
    -- upvalues: Config (copy)
    local v22 = Config.GetItemIDFromItemData(p21);

    if v22 and v22 ~= "" then
        return v22;
    end;

    return string.format("%s:%s:%s", p21.Type or "", p21.Name or "", p21.Weapon or "");
end;

local function GetLoadoutScrollerCacheKey(p23, p24) -- Line: 165
    local v25 = p23:GetAttribute("LoadoutType") or "";
    local v26 = p23:GetAttribute("WeaponClass") or "";
    local v27 = p24 and v26 ~= "" and (p24:GetAttribute(v26 .. "Weapon") or "") or "";

    if v25 == "Weapon" then
        return string.format("%s:%s", v25, v26);
    end;

    if v25 == "Skin" or (v25 == "Sight" or (v25 == "Grip" or (v25 == "Muzzle" or v25 == "Extra"))) then
        return string.format("%s:%s:%s", v25, v26, v27 or "");
    end;

    return v25;
end;

local function GetViewportRenderedObject(p28) -- Line: 179
    for _, child in ipairs(p28:GetChildren()) do
        if child.Name ~= "Camera" then
            if child:IsA("WorldModel") then
                return child:FindFirstChildWhichIsA("Model") or child;
            end;

            return child;
        end;
    end;

    return nil;
end;

local function ApplyLoadoutAttachments(p29, p30, p31, p32) -- Line: 195
    -- upvalues: Weapon (copy)
    if not (p29 and p30) then
        return;
    end;

    for _, v in ipairs({ "Sight", "Muzzle", "Grip", "Extra", "Charm" }) do
        Weapon.SetAttachmentOnWep(p29, v, p30:GetAttribute(p31 .. v), p32);
    end;
end;

function u2.TweenCreate(p33, p34, p35, p36, p37) -- Line: 207
    -- upvalues: TweenService (copy)
    local v38 = TweenService:Create(p33, TweenInfo.new(p36, p35, Enum.EasingDirection.InOut), p34);
    v38:Play();

    if p37 then
        task.wait(p36);
    end;

    return v38;
end;

function u2.OpenPage(p39) -- Line: 216
    -- upvalues: Config (copy), u7 (ref), u2 (copy)
    local v40 = p39 == "Battlepass" and Config.CheckSeasonActive() ~= true and "Play" or p39;
    local v41 = u7:WaitForChild("Pages"):WaitForChild(v40);

    if not v41 then
        return;
    end;

    for _, child in pairs(u7:WaitForChild("Pages"):GetChildren()) do
        child.Visible = false;
    end;

    v41.Visible = true;
    local Top = u7:FindFirstChild("Top");

    if Top then
        Top = Top:FindFirstChild("Menu");
    end;

    if Top and Top:FindFirstChild(v40) then
        u2.SetTopMenuSelection(v40);
    end;
end;

function u2.SetAllTextColor(p42, p43) -- Line: 237
    for _, child in p42:GetChildren() do
        if child:IsA("TextLabel") and child.Name ~= "RarityName" then
            child.TextColor3 = p43;
        end;
    end;
end;

function u2.TweenAllTextColor(p44, p45, p46) -- Line: 245
    -- upvalues: Config (copy)
    for _, child in p44:GetChildren() do
        if child:IsA("TextLabel") and child.Name ~= "RarityName" then
            Config.TweenCreate(child, {
                TextColor3 = p45
            }, p46, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        end;
    end;
end;

function u2.GetSelectionVisual(p47) -- Line: 253
    local Button = p47:FindFirstChild("Button");

    if Button and Button:IsA("GuiObject") then
        return Button;
    end;

    if p47:IsA("GuiObject") then
        return p47;
    end;

    return nil;
end;

function u2.GetSelectionInput(p48) -- Line: 266
    local Button = p48:FindFirstChild("Button");

    if Button and Button:IsA("GuiButton") then
        return Button;
    end;

    if p48:IsA("GuiButton") then
        return p48;
    end;

    return nil;
end;

function u2.SetSelectionState(p49, p50, p51, p52) -- Line: 279
    -- upvalues: u2 (copy)
    local v53 = u2.GetSelectionVisual(p49);

    if not v53 then
        return;
    end;

    if p50 then
        p52 = p51 or p52;
    end;

    v53.BackgroundColor3 = p52;
    local v54 = p50 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255);
    local Title = v53:FindFirstChild("Title", true);

    if Title and Title:IsA("TextLabel") then
        Title.TextColor3 = v54;
    end;

    local Icon = v53:FindFirstChild("Icon", true);

    if Icon and Icon:IsA("ImageLabel") then
        Icon.ImageColor3 = v54;
    end;
end;

function u2.SetTopMenuSelection(p55) -- Line: 299
    -- upvalues: u7 (ref), u2 (copy)
    if not u7 then
        return;
    end;

    local Top = u7:FindFirstChild("Top");

    if Top then
        Top = Top:FindFirstChild("Menu");
    end;

    if not Top then
        return;
    end;

    for _, child in ipairs(Top:GetChildren()) do
        if child:IsA("ImageButton") then
            u2.SetSelectionState(child, child.Name == p55, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0));
        end;
    end;

    u2.CurrentMain = p55;
end;

function u2.ConfigureCamera(p56) -- Line: 319
    -- upvalues: Utility (copy), u1 (copy), RunService (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local CameraPort = workspace:WaitForChild("Lobby"):FindFirstChild("CameraPort");

    if not (CurrentCamera and CameraPort) then
        warn(Utility.formatWarnInstanceIsNil("Workspace.Lobby", "CameraPort"));

        return nil;
    end;

    local CFrame2 = CameraPort.CFrame;
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CurrentCamera.CameraSubject = nil;
    CurrentCamera.CFrame = CFrame2;
    local u57 = 0;
    local u58 = 0;
    local u59 = 0;
    local ServerData = p56:FindFirstChild("ServerData");

    if ServerData then
        RunService.RenderStepped:Connect(function(p60) -- Line: 342, Name: updateCamera
            -- upvalues: ServerData (copy), CurrentCamera (copy), u1 (ref), u57 (ref), u58 (ref), u59 (ref), CFrame2 (copy)
            if ServerData:GetAttribute("Lobby") ~= "Physical" then
                if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                    CurrentCamera.CameraSubject = nil;
                end;

                local v61 = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2);
                local v62 = (v61.X - u1.X) / 750;
                local v63 = (v61.Y - u1.Y) / 750;

                if u57 < 12.566370614359172 then
                    u57 = u57 + p60 * 0.7;
                elseif u57 >= 12.566370614359172 then
                    u57 = p60 * 0.7 + 0;
                end;

                u58 = math.sin(u57 / 2) * 0.3;
                u59 = math.sin(u57) * 0.3;
                local v64 = CFrame.new((Vector3.new(u58 / 2, u59 / 2, 0)));
                CurrentCamera.CFrame = CFrame2 * CFrame.Angles(math.rad(v63), math.rad(v62), 0) * v64;
            end;
        end);

        return CurrentCamera;
    end;

    warn(Utility.formatWarnInstanceIsNil("Player", "ServerData"));

    return CurrentCamera;
end;

function u2.ConfigTop() -- Line: 372
    -- upvalues: u7 (ref), LocalPlayer (copy), Config (copy), Rank (copy), u2 (copy), SoundService (copy)
    local Top = u7:WaitForChild("Top");
    local PlayerData = LocalPlayer:WaitForChild("PlayerData");
    local Stats = PlayerData:WaitForChild("Stats");
    local ServerData = LocalPlayer:WaitForChild("ServerData");
    Top.Profile.PlayerButton.Icon.Image = ServerData:GetAttribute("ProfilePicture") or "";
    ServerData:GetAttributeChangedSignal("ProfilePicture"):Connect(function() -- Line: 378, Name: UpdateProfilePicture
        -- upvalues: Top (copy), ServerData (copy)
        Top.Profile.PlayerButton.Icon.Image = ServerData:GetAttribute("ProfilePicture") or "";
    end);

    for _, child in pairs(Top.Currency:GetChildren()) do
        if child:IsA("TextLabel") then
            child.Text = Config.ReturnStringCurrency(Stats:GetAttribute(child.Name));
            Stats:GetAttributeChangedSignal(child.Name):Connect(function() -- Line: 389
                -- upvalues: child (copy), Config (ref), Stats (copy)
                child.Text = Config.ReturnStringCurrency(Stats:GetAttribute(child.Name));
            end);
        end;
    end;

    Top.Profile.PlayerLevel.Text = tostring(Stats:GetAttribute("Level"));
    Stats:GetAttributeChangedSignal("Level"):Connect(function() -- Line: 397
        -- upvalues: Top (copy), Stats (copy)
        Top.Profile.PlayerLevel.Text = tostring(Stats:GetAttribute("Level"));
    end);
    Top.Profile.Segment.Experience.Bar.Size = UDim2.new(1, 0, Stats:GetAttribute("Experience") / Config.GetExperienceToHit(LocalPlayer), 0);
    Stats:GetAttributeChangedSignal("Experience"):Connect(function() -- Line: 402
        -- upvalues: Top (copy), Stats (copy), Config (ref), LocalPlayer (ref)
        Top.Profile.Segment.Experience.Bar.Size = UDim2.new(1, 0, Stats:GetAttribute("Experience") / Config.GetExperienceToHit(LocalPlayer), 0);
    end);

    local function RefreshProfileRankButton() -- Line: 406
        -- upvalues: Top (copy), Rank (ref), Stats (copy)
        local Rank2 = Top.Profile:FindFirstChild("Rank");

        if Rank2 then
            Rank2 = Rank2:FindFirstChild("Icon");
        end;

        if not (Rank2 and Rank2:IsA("ImageLabel")) then
            return;
        end;

        Rank2.Image = `rbxassetid://{Rank.GetRankedImage(Stats:GetAttribute("RankedRating"))}`;
    end;

    RefreshProfileRankButton();
    Stats:GetAttributeChangedSignal("RankedRating"):Connect(RefreshProfileRankButton);
    local Play = u7:WaitForChild("Pages"):WaitForChild("Play");
    Top.Profile.PlayerButton.Activated:Connect(function() -- Line: 420
        -- upvalues: u2 (ref), Play (copy), LocalPlayer (ref)
        u2.OpenPage("Play");
        Play.ProfileFrame.Visible = true;
        u2.RefreshProfileFrame(LocalPlayer, Play.ProfileFrame);
    end);
    Play.ProfileFrame.Scroller.Cancel.Activated:Connect(function() -- Line: 425
        -- upvalues: Play (copy)
        Play.ProfileFrame.Visible = false;
    end);
    Top.Profile.GangButton.Activated:Connect(function() -- Line: 429
        -- upvalues: u2 (ref)
        u2.OpenPage("Gang");
    end);

    if Top.Profile:FindFirstChild("Rank") then
        Top.Profile.Rank.Activated:Connect(function() -- Line: 433
            -- upvalues: Config (ref), SoundService (ref), u2 (ref)
            Config.AddSound("Click_2", 1, true, SoundService, false);
            u2.OpenPage("Profile");
        end);
    end;

    local Gang = PlayerData:WaitForChild("Gang");

    local function RefreshGangIcon() -- Line: 439
        -- upvalues: Gang (copy), Top (copy)
        local v65 = Gang:GetAttribute("Icon") or "";

        if v65 == "" then
            Top.Profile.GangButton.Icon.Image = "rbxassetid://115336951637130";

            return;
        end;

        if string.sub(v65, 1, 13) == "rbxassetid://" then
            Top.Profile.GangButton.Icon.Image = v65;

            return;
        end;

        Top.Profile.GangButton.Icon.Image = "rbxassetid://" .. v65;
    end;

    local v66 = Gang:GetAttribute("Icon") or "";

    if v66 == "" then
        Top.Profile.GangButton.Icon.Image = "rbxassetid://115336951637130";
    elseif string.sub(v66, 1, 13) == "rbxassetid://" then
        Top.Profile.GangButton.Icon.Image = v66;
    else
        Top.Profile.GangButton.Icon.Image = "rbxassetid://" .. v66;
    end;

    Gang:GetAttributeChangedSignal("Icon"):Connect(RefreshGangIcon);

    for _, child in pairs(Top.Menu:GetChildren()) do
        if child:IsA("ImageButton") then
            local v67 = u2.GetSelectionInput(child);

            if v67 then
                v67.Activated:Connect(function() -- Line: 460
                    -- upvalues: Config (ref), SoundService (ref), u2 (ref), child (copy)
                    Config.AddSound("Click_2", 1, true, SoundService, false);
                    u2.OpenPage(child.Name);
                end);
            end;
        end;
    end;

    u2.SetTopMenuSelection("Play");
    Config.ConfigTopInset(Top);
end;

function u2.RefreshPlayBattlepassSummary() -- Line: 473
    -- upvalues: LocalPlayer (copy), u7 (ref)
    local PlayerData = LocalPlayer:FindFirstChild("PlayerData");

    if PlayerData then
        PlayerData = PlayerData:FindFirstChild("Stats");
    end;

    if not (PlayerData and u7) then
        return;
    end;

    local Pages = u7:FindFirstChild("Pages");

    if Pages then
        Pages = Pages:FindFirstChild("Play");
    end;

    if Pages then
        Pages = Pages:FindFirstChild("Battlepass");
    end;

    if Pages then
        Pages = Pages:FindFirstChild("Tier");
    end;

    if not (Pages and Pages:IsA("TextLabel")) then
        return;
    end;

    Pages.Text = "TIER " .. PlayerData:GetAttribute("BattlePassTier") .. "/380";
end;

function u2.ConfigPlayBattlepassSummary() -- Line: 491
    -- upvalues: u6 (ref), u2 (copy), LocalPlayer (copy)
    if u6 == true then
        u2.RefreshPlayBattlepassSummary();

        return;
    end;

    u6 = true;
    local Stats = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Stats");
    u2.RefreshPlayBattlepassSummary();
    Stats:GetAttributeChangedSignal("BattlePassTier"):Connect(function() -- Line: 500
        -- upvalues: u2 (ref)
        u2.RefreshPlayBattlepassSummary();
    end);
end;

local function RefreshPlayBattlepassButtonAvailability() -- Line: 505
    -- upvalues: u7 (ref), Config (copy)
    if not u7 then
        return;
    end;

    local Pages = u7:FindFirstChild("Pages");

    if Pages then
        Pages = Pages:FindFirstChild("Play");
    end;

    if Pages then
        Pages = Pages:FindFirstChild("Battlepass");
    end;

    if not (Pages and Pages:IsA("GuiObject")) then
        return;
    end;

    local v68 = Config.CheckSeasonActive() == true;
    Pages.Visible = v68;

    if Pages:IsA("GuiButton") then
        Pages.Active = v68;
        Pages.AutoButtonColor = v68;
    end;
end;

local function ApplyBattlepassSeasonEndedState(p69) -- Line: 526
    if not p69 then
        return;
    end;

    local SeasonInfo = p69:FindFirstChild("SeasonInfo");

    if SeasonInfo and SeasonInfo:IsA("TextLabel") then
        SeasonInfo.Text = "Countdown to next Season.";
    end;

    for _, v in ipairs({ "Buy", "Skip1", "Skip5" }) do
        local v70 = p69:FindFirstChild(v);

        if v70 and v70:IsA("GuiObject") then
            v70.Visible = false;

            if v70:IsA("GuiButton") then
                v70.Active = false;
                v70.AutoButtonColor = false;
            end;
        end;
    end;
end;

function u2.ConfigPlay() -- Line: 548
    -- upvalues: u7 (ref), LocalPlayer (copy), RefreshPlayBattlepassButtonAvailability (copy), Config (copy), SoundService (copy), u2 (copy), Leaderboard (copy), ReplicatedStorage (copy)
    local Play = u7:WaitForChild("Pages"):WaitForChild("Play");
    local ServerData = LocalPlayer:WaitForChild("ServerData");
    RefreshPlayBattlepassButtonAvailability();
    Play.Battlepass.Activated:Connect(function() -- Line: 554
        -- upvalues: Config (ref), SoundService (ref), RefreshPlayBattlepassButtonAvailability (ref), u2 (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);

        if Config.CheckSeasonActive() == true then
            u2.OpenPage("Battlepass");

            return;
        end;

        RefreshPlayBattlepassButtonAvailability();
        u2.AddNotification("Battle Pass unavailable", Color3.fromRGB(255, 150, 150));
    end);
    Play.Crate.Activated:Connect(function() -- Line: 564
        -- upvalues: Config (ref), SoundService (ref), u2 (ref)
        Config.AddSound("Crate_Unlock", 1, true, SoundService, false);
        u2.OpenPage("Crate");
    end);
    local Stats = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Stats");
    u2.ConfigLoginRewards(Play, Stats);
    u2.ConfigPlayBattlepassSummary();

    local function RefreshPlayLeaderboardButtonVisibility() -- Line: 573
        -- upvalues: Play (copy), Leaderboard (ref)
        Play.Leaderboard.Visible = Leaderboard.IsWeeklyLeaderboardActive();
    end;

    Play.Leaderboard.Activated:Connect(function() -- Line: 577
        -- upvalues: Config (ref), SoundService (ref), u2 (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        u2.OpenPage("Leaderboard");
    end);
    Play.Leaderboard.Visible = Leaderboard.IsWeeklyLeaderboardActive();
    Play.UpdateLog.Activated:Connect(function() -- Line: 583
        -- upvalues: Config (ref), SoundService (ref), Play (copy)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        Play.UpdateFrame.Visible = true;
    end);
    u2.UpdateHome();
    Play:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 589
        -- upvalues: Play (copy), u2 (ref), Leaderboard (ref), RefreshPlayBattlepassButtonAvailability (ref)
        if Play.Visible == true then
            u2.UpdateHome();
            Play.Leaderboard.Visible = Leaderboard.IsWeeklyLeaderboardActive();
            RefreshPlayBattlepassButtonAvailability();
        end;
    end);
    task.spawn(function() -- Line: 597
        -- upvalues: Play (copy), Leaderboard (ref)
        while task.wait(2) do
            Play.Leaderboard.Visible = Leaderboard.IsWeeklyLeaderboardActive();
        end;
    end);
    Play.Store.Activated:Connect(function() -- Line: 603
        -- upvalues: Config (ref), SoundService (ref), u2 (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        Config.AddSound("Premium_1", 1, true, SoundService, false);
        u2.OpenPage("Store");
    end);
    local u71 = Play.Hatchet:GetAttribute("ID");
    Play.Hatchet.Activated:Connect(function() -- Line: 610
        -- upvalues: Config (ref), LocalPlayer (ref), u71 (copy), u2 (ref), SoundService (ref), Play (copy)
        if (Config.CheckPlayerOwnGamepass(LocalPlayer, u71) and true or false) == true then
            u2.AddNotification("You own this pass", Color3.fromRGB(255, 100, 100));

            return;
        end;

        Config.AddSound("Click_3", 1, true, SoundService, false);
        u2.SetupMonetisationButton(Play.Hatchet);
    end);
    u2.ConfigChallenges();
    local SeasonTitle = Play.Battlepass:FindFirstChild("SeasonTitle");

    if SeasonTitle and SeasonTitle:IsA("TextLabel") then
        SeasonTitle.Text = "SEASON " .. Config.Season;
    end;

    local GamemodeList = Play:WaitForChild("GamemodeList");
    local Modes = GamemodeList:WaitForChild("Modes");
    local u72 = {
        Casual = true,
        Ranked = true
    };

    local function RefreshPlayGamemodeUI() -- Line: 639
        -- upvalues: Play (copy), u72 (copy), Modes (copy)
        local v73 = Play.Quickmatch:GetAttribute("Gamemode");

        if u72[v73] ~= true then
            Play.Quickmatch:SetAttribute("Gamemode", "Casual");

            return;
        end;

        Play.Quickmatch.GamemodeTitle.Text = string.upper(v73);

        for _, child in ipairs(Modes:GetChildren()) do
            if child:IsA("ImageButton") then
                local v74 = child:FindFirstChildOfClass("UIStroke");

                if v74 then
                    v74.Enabled = child.Name == v73;
                end;
            end;
        end;
    end;

    local function SetPlayGamemode(p75) -- Line: 658
        -- upvalues: u72 (copy), Config (ref), u2 (ref), Play (copy)
        if u72[p75] ~= true then
            return;
        end;

        if p75 == "Ranked" and Config.CheckSeasonActive() ~= true then
            u2.AddNotification("Ranked disabled", Color3.fromRGB(255, 150, 150));

            return;
        end;

        if Play.Quickmatch:GetAttribute("Gamemode") == p75 then
            return;
        end;

        Play.Quickmatch:SetAttribute("Gamemode", p75);
    end;

    Play.Servers.Activated:Connect(function() -- Line: 676
        -- upvalues: u2 (ref), Config (ref), SoundService (ref)
        u2.OpenPage("Servers");
        Config.AddSound("Click_2", 1, true, SoundService, false);
    end);
    Play.Gamemodes.Activated:Connect(function() -- Line: 681
        -- upvalues: Config (ref), SoundService (ref), GamemodeList (copy), RefreshPlayGamemodeUI (copy)
        Config.AddSound("Click_3", 1, true, SoundService, false);
        GamemodeList.Visible = true;
        RefreshPlayGamemodeUI();
    end);
    GamemodeList.Cancel.Activated:Connect(function() -- Line: 687
        -- upvalues: Config (ref), SoundService (ref), GamemodeList (copy)
        Config.AddSound("Click_3", 1, true, SoundService, false);
        GamemodeList.Visible = false;
    end);
    GamemodeList.ButtonBlocker.Activated:Connect(function() -- Line: 692
        -- upvalues: GamemodeList (copy)
        GamemodeList.Visible = false;
    end);

    for _, child in ipairs(Modes:GetChildren()) do
        if child:IsA("ImageButton") then
            child.Activated:Connect(function() -- Line: 698
                -- upvalues: u72 (copy), child (copy), Config (ref), SoundService (ref), Play (copy), SetPlayGamemode (copy), GamemodeList (copy)
                if u72[child.Name] ~= true then
                    return;
                end;

                Config.AddSound("Click_3", 1, true, SoundService, false);

                if Play.Quickmatch:GetAttribute("Gamemode") == child.Name then
                    return;
                end;

                SetPlayGamemode(child.Name);
                GamemodeList.Visible = false;
            end);
        end;
    end;

    Play.Quickmatch:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 713
        -- upvalues: RefreshPlayGamemodeUI (copy)
        RefreshPlayGamemodeUI();
    end);

    if Play.Quickmatch:GetAttribute("Gamemode") == nil then
        Play.Quickmatch:SetAttribute("Gamemode", "Casual");
    else
        RefreshPlayGamemodeUI();
    end;

    local u76 = false;
    local u77 = 0;
    local u78 = 0;
    local ServerList = ReplicatedStorage.Server:WaitForChild("ServerList");

    local function RefreshRankedQueuingUI() -- Line: 735
        -- upvalues: Play (copy), ServerData (copy), ServerList (copy)
        if not Play:FindFirstChild("Quickmatch") then
            return;
        end;

        if not Play.Quickmatch:FindFirstChild("RankedQueuing") then
            return;
        end;

        if not ServerData then
            return;
        end;

        local v79 = Play.Quickmatch:GetAttribute("Gamemode");
        local v80 = ServerList:GetAttribute("RankedQueuing") or 0;
        Play.Quickmatch.RankedQueuing.Text = v80 .. " Queuing";

        if v79 == "Ranked" and (ServerData:GetAttribute("Searching") or "") == "" then
            Play.Quickmatch.RankedQueuing.Visible = true;

            return;
        end;

        Play.Quickmatch.RankedQueuing.Visible = false;
    end;

    local function GetPendingDirectJoinGamemode() -- Line: 752
        -- upvalues: Play (copy)
        return Play:GetAttribute("PendingDirectJoinGamemode") or "";
    end;

    local function GetPendingCustomAction() -- Line: 756
        -- upvalues: Play (copy)
        return Play:GetAttribute("PendingCustomAction") or "";
    end;

    local function GetDirectJoinActiveGamemode() -- Line: 760
        -- upvalues: Play (copy)
        return Play:GetAttribute("DirectJoinActiveGamemode") or "";
    end;

    local function IsTeleportTransitionActive() -- Line: 764
        -- upvalues: Play (copy)
        return Play:GetAttribute("TeleportTransitionActive") == true;
    end;

    local function SetDirectJoinActiveGamemode(p81) -- Line: 768
        -- upvalues: Play (copy)
        Play:SetAttribute("DirectJoinActiveGamemode", p81);
    end;

    local function SetTeleportTransitionActive(p82) -- Line: 772
        -- upvalues: Play (copy)
        Play:SetAttribute("TeleportTransitionActive", p82 == true);
    end;

    local function ClearDirectJoinUIState() -- Line: 776
        -- upvalues: Play (copy)
        if (Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" then
            Play:SetAttribute("PendingDirectJoinGamemode", "");
        end;

        if (Play:GetAttribute("DirectJoinActiveGamemode") or "") ~= "" then
            Play:SetAttribute("DirectJoinActiveGamemode", "");
        end;
    end;

    local function ClearCustomPendingUIState() -- Line: 785
        -- upvalues: Play (copy)
        if (Play:GetAttribute("PendingCustomAction") or "") ~= "" then
            Play:SetAttribute("PendingCustomAction", "");
        end;
    end;

    local function SetQuickmatchSearchingUI(p83, p84) -- Line: 791
        -- upvalues: Play (copy), ServerList (copy), Config (ref), GamemodeList (copy), u78 (ref), RefreshRankedQueuingUI (copy)
        if p83 then
            local v85 = Play:GetAttribute("PendingCustomAction") or "";
            local v86 = Play:GetAttribute("PendingDirectJoinGamemode") or "";
            local v87 = Play:GetAttribute("DirectJoinActiveGamemode") or "";
            local v88 = Play.Quickmatch:GetAttribute("Gamemode");
            local v89 = ServerList:GetAttribute("RankedQueuing") or 0;

            if v85 == "" then
                if v86 == "" and v87 == "" then
                    Play.Quickmatch.Timer.Text = "Searching " .. v88 .. " [" .. Config.toMS(p84 or 0) .. "]";

                    if v88 == "Ranked" then
                        Play.Quickmatch.Timer.Text = v88 .. " [" .. Config.toMS(p84 or 0) .. "] " .. v89 .. " Queuing";
                    end;
                else
                    Play.Quickmatch.Timer.Text = "Joining Server [" .. Config.toMS(p84 or 0) .. "]";
                end;
            else
                Play.Quickmatch.Timer.Text = v85 .. " [" .. Config.toMS(p84 or 0) .. "]";
            end;

            Play.Quickmatch.Timer.Visible = true;
            Play.Quickmatch.GamemodeTitle.Visible = false;
            Play.Quickmatch.Title.Visible = false;
            Play.Quickmatch.RankedQueuing.Visible = false;
            Play.Gamemodes.Visible = false;
            Play.Servers.Visible = false;
            GamemodeList.Visible = false;

            if Play:FindFirstChild("QuickmatchCancel") then
                Play.QuickmatchCancel.Visible = Play:GetAttribute("TeleportTransitionActive") ~= true;
            end;

            if SelectedGangMember ~= nil and Play.ProfileFrame.Visible == true then
                showSelectedMemberProfile();
            end;
        else
            u78 = 0;
            Play.Quickmatch.Timer.Visible = false;
            Play.Quickmatch.GamemodeTitle.Visible = true;
            Play.Quickmatch.Title.Visible = true;
            Play.Gamemodes.Visible = true;
            Play.Servers.Visible = true;

            if Play:FindFirstChild("QuickmatchCancel") then
                Play.QuickmatchCancel.Visible = false;
            end;

            RefreshRankedQueuingUI();
        end;
    end;

    local function StartQuickmatchTimer() -- Line: 845
        -- upvalues: Play (copy), ServerData (copy), SetQuickmatchSearchingUI (copy), u78 (ref), u77 (ref), RefreshRankedQueuingUI (copy)
        if (Play:GetAttribute("DirectJoinActiveGamemode") or "") ~= "" and (ServerData and (ServerData:GetAttribute("Searching") or "") ~= "") then
            SetQuickmatchSearchingUI(true, u78);

            return;
        end;

        u77 = u77 + 1;
        local v90 = u77;
        local v91 = 0;
        u78 = v91;
        SetQuickmatchSearchingUI(true, v91);

        while v90 == u77 and ServerData do
            task.wait(1);

            if v90 ~= u77 or (not ServerData or (ServerData:GetAttribute("Searching") or "") == "" and (Play:GetAttribute("DirectJoinActiveGamemode") or "") == "") then
                break;
            end;

            v91 = v91 + 1;
            u78 = v91;
            SetQuickmatchSearchingUI(true, v91);
        end;

        if v90 == u77 and Play:GetAttribute("TeleportTransitionActive") ~= true then
            u78 = 0;
            Play.Quickmatch.Timer.Visible = false;
            Play.Quickmatch.GamemodeTitle.Visible = true;
            Play.Quickmatch.Title.Visible = true;
            Play.Gamemodes.Visible = true;
            Play.Servers.Visible = true;

            if Play:FindFirstChild("QuickmatchCancel") then
                Play.QuickmatchCancel.Visible = false;
            end;

            RefreshRankedQueuingUI();
        end;
    end;

    local function StartPendingDirectJoinSearch(p92) -- Line: 888
        -- upvalues: Play (copy), u77 (ref), u78 (ref), SetQuickmatchSearchingUI (copy), ServerData (copy), RefreshRankedQueuingUI (copy), u2 (ref)
        if p92 ~= "Casual" then
            return;
        end;

        Play.Quickmatch:SetAttribute("Gamemode", p92);
        Play:SetAttribute("DirectJoinActiveGamemode", p92);
        u77 = u77 + 1;
        local u93 = u77;
        local u94 = 0;
        u78 = u94;
        SetQuickmatchSearchingUI(true, u94);
        task.spawn(function() -- Line: 902
            -- upvalues: u93 (copy), u77 (ref), Play (ref), ServerData (ref), u94 (ref), u78 (ref), SetQuickmatchSearchingUI (ref), RefreshRankedQueuingUI (ref), u2 (ref)
            while u93 == u77 and ((Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" and (ServerData and ((ServerData:GetAttribute("Searching") or "") == "" and u94 < 8))) do
                task.wait(1);

                if u93 ~= u77 or ((Play:GetAttribute("PendingDirectJoinGamemode") or "") == "" or (not ServerData or (ServerData:GetAttribute("Searching") or "") ~= "")) then
                    break;
                end;

                u94 = u94 + 1;
                u78 = u94;
                SetQuickmatchSearchingUI(true, u94);
            end;

            if u93 == u77 and ((Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" and (ServerData and (ServerData:GetAttribute("Searching") or "") == "")) then
                if (Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" then
                    Play:SetAttribute("PendingDirectJoinGamemode", "");
                end;

                if (Play:GetAttribute("DirectJoinActiveGamemode") or "") ~= "" then
                    Play:SetAttribute("DirectJoinActiveGamemode", "");
                end;

                u78 = 0;
                Play.Quickmatch.Timer.Visible = false;
                Play.Quickmatch.GamemodeTitle.Visible = true;
                Play.Quickmatch.Title.Visible = true;
                Play.Gamemodes.Visible = true;
                Play.Servers.Visible = true;

                if Play:FindFirstChild("QuickmatchCancel") then
                    Play.QuickmatchCancel.Visible = false;
                end;

                RefreshRankedQueuingUI();
                u2.AddNotification("Unable to join server. Please try again.", Color3.fromRGB(255, 150, 150));
            end;
        end);
    end;

    local function StartPendingCustomAction(u95) -- Line: 940
        -- upvalues: Play (copy), u77 (ref), u78 (ref), SetQuickmatchSearchingUI (copy), ServerData (copy), RefreshRankedQueuingUI (copy), u2 (ref)
        if u95 == "" then
            return;
        end;

        Play.Quickmatch:SetAttribute("Gamemode", "Custom");
        u77 = u77 + 1;
        local u96 = u77;
        local u97 = 0;
        u78 = u97;
        SetQuickmatchSearchingUI(true, u97);
        task.spawn(function() -- Line: 953
            -- upvalues: u96 (copy), u77 (ref), Play (ref), u95 (copy), ServerData (ref), u97 (ref), u78 (ref), SetQuickmatchSearchingUI (ref), RefreshRankedQueuingUI (ref), u2 (ref)
            while u96 == u77 and ((Play:GetAttribute("PendingCustomAction") or "") == u95 and (ServerData and ((ServerData:GetAttribute("Searching") or "") == "" and u97 < 15))) do
                task.wait(1);

                if u96 ~= u77 or ((Play:GetAttribute("PendingCustomAction") or "") ~= u95 or (not ServerData or (ServerData:GetAttribute("Searching") or "") ~= "")) then
                    break;
                end;

                u97 = u97 + 1;
                u78 = u97;
                SetQuickmatchSearchingUI(true, u97);
            end;

            if u96 == u77 and ((Play:GetAttribute("PendingCustomAction") or "") == u95 and (ServerData and (ServerData:GetAttribute("Searching") or "") == "")) then
                if (Play:GetAttribute("PendingCustomAction") or "") ~= "" then
                    Play:SetAttribute("PendingCustomAction", "");
                end;

                u78 = 0;
                Play.Quickmatch.Timer.Visible = false;
                Play.Quickmatch.GamemodeTitle.Visible = true;
                Play.Quickmatch.Title.Visible = true;
                Play.Gamemodes.Visible = true;
                Play.Servers.Visible = true;

                if Play:FindFirstChild("QuickmatchCancel") then
                    Play.QuickmatchCancel.Visible = false;
                end;

                RefreshRankedQueuingUI();
                u2.AddNotification("Custom server request timed out. Please try again.", Color3.fromRGB(255, 150, 150));
            end;
        end);
    end;

    Play.Quickmatch.Activated:Connect(function() -- Line: 991
        -- upvalues: Config (ref), SoundService (ref), ServerData (copy), u2 (ref), Play (copy), u76 (ref), ReplicatedStorage (ref)
        Config.AddSound("Click_3", 1, true, SoundService, false);

        if not ServerData then
            u2.AddNotification("Server data missing", Color3.fromRGB(255, 150, 150));

            return;
        end;

        local v98 = Play.Quickmatch:GetAttribute("Gamemode");

        if v98 ~= "Casual" and v98 ~= "Ranked" then
            u2.AddNotification("Invalid queue mode", Color3.fromRGB(255, 150, 150));

            return;
        end;

        if u76 == true then
            u2.AddNotification("Queue cooldown, please wait", Color3.fromRGB(255, 150, 150));

            return;
        end;

        if (ServerData:GetAttribute("Searching") or "") ~= "" then
            u2.AddNotification("Already searching", Color3.fromRGB(255, 150, 150));

            return;
        end;

        u76 = true;
        task.delay(Config.QueueCooldown, function() -- Line: 1020
            -- upvalues: u76 (ref)
            u76 = false;
        end);
        ReplicatedStorage.Events.QueueGamemode:FireServer(v98);
    end);

    if Play:FindFirstChild("QuickmatchCancel") then
        Play.QuickmatchCancel.Visible = false;
        Play.QuickmatchCancel.Activated:Connect(function() -- Line: 1030
            -- upvalues: Config (ref), SoundService (ref), Play (copy), ServerData (copy), u76 (ref), u2 (ref), u77 (ref), u78 (ref), RefreshRankedQueuingUI (copy), ReplicatedStorage (ref)
            Config.AddSound("Click_3", 1, true, SoundService, false);

            if Play:GetAttribute("TeleportTransitionActive") == true then
                return;
            end;

            if not ServerData then
                return;
            end;

            if u76 == true then
                u2.AddNotification("Queue cooldown, please wait", Color3.fromRGB(255, 150, 150));

                return;
            end;

            if (ServerData:GetAttribute("Searching") or "") ~= "" then
                u76 = true;
                task.delay(Config.QueueCooldown, function() -- Line: 1063
                    -- upvalues: u76 (ref)
                    u76 = false;
                end);
                u77 = u77 + 1;
                u78 = 0;
                Play.Quickmatch.Timer.Visible = false;
                Play.Quickmatch.GamemodeTitle.Visible = true;
                Play.Quickmatch.Title.Visible = true;
                Play.Gamemodes.Visible = true;
                Play.Servers.Visible = true;

                if Play:FindFirstChild("QuickmatchCancel") then
                    Play.QuickmatchCancel.Visible = false;
                end;

                RefreshRankedQueuingUI();
                ReplicatedStorage.Events.QueueGamemode:FireServer("");

                return;
            end;

            if (Play:GetAttribute("PendingDirectJoinGamemode") or "") == "" and ((Play:GetAttribute("DirectJoinActiveGamemode") or "") == "" and (Play:GetAttribute("PendingCustomAction") or "") == "") then
                u78 = 0;
                Play.Quickmatch.Timer.Visible = false;
                Play.Quickmatch.GamemodeTitle.Visible = true;
                Play.Quickmatch.Title.Visible = true;
                Play.Gamemodes.Visible = true;
                Play.Servers.Visible = true;

                if Play:FindFirstChild("QuickmatchCancel") then
                    Play.QuickmatchCancel.Visible = false;
                end;

                RefreshRankedQueuingUI();

                return;
            end;

            if (Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" then
                Play:SetAttribute("PendingDirectJoinGamemode", "");
            end;

            if (Play:GetAttribute("DirectJoinActiveGamemode") or "") ~= "" then
                Play:SetAttribute("DirectJoinActiveGamemode", "");
            end;

            if (Play:GetAttribute("PendingCustomAction") or "") ~= "" then
                Play:SetAttribute("PendingCustomAction", "");
            end;

            u77 = u77 + 1;
            u78 = 0;
            Play.Quickmatch.Timer.Visible = false;
            Play.Quickmatch.GamemodeTitle.Visible = true;
            Play.Quickmatch.Title.Visible = true;
            Play.Gamemodes.Visible = true;
            Play.Servers.Visible = true;

            if Play:FindFirstChild("QuickmatchCancel") then
                Play.QuickmatchCancel.Visible = false;
            end;

            RefreshRankedQueuingUI();
            ReplicatedStorage.Events.QueueGamemode:FireServer("");
        end);
    end;

    ServerData:GetAttributeChangedSignal("Searching"):Connect(function() -- Line: 1074
        -- upvalues: ServerData (copy), Play (copy), u77 (ref), u78 (ref), RefreshRankedQueuingUI (copy), StartQuickmatchTimer (copy)
        if (ServerData:GetAttribute("Searching") or "") == "" then
            if Play:GetAttribute("TeleportTransitionActive") ~= true and ((Play:GetAttribute("DirectJoinActiveGamemode") or "") == "" and ((Play:GetAttribute("PendingDirectJoinGamemode") or "") == "" and (Play:GetAttribute("PendingCustomAction") or "") == "")) then
                u77 = u77 + 1;
                u78 = 0;
                Play.Quickmatch.Timer.Visible = false;
                Play.Quickmatch.GamemodeTitle.Visible = true;
                Play.Quickmatch.Title.Visible = true;
                Play.Gamemodes.Visible = true;
                Play.Servers.Visible = true;

                if Play:FindFirstChild("QuickmatchCancel") then
                    Play.QuickmatchCancel.Visible = false;
                end;

                RefreshRankedQueuingUI();
            end;
        else
            if (Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" then
                Play:SetAttribute("PendingDirectJoinGamemode", "");
            end;

            if (Play:GetAttribute("PendingCustomAction") or "") ~= "" and (Play:GetAttribute("PendingCustomAction") or "") ~= "" then
                Play:SetAttribute("PendingCustomAction", "");
            end;

            task.spawn(StartQuickmatchTimer);
        end;
    end);
    Play:GetAttributeChangedSignal("PendingDirectJoinGamemode"):Connect(function() -- Line: 1093
        -- upvalues: Play (copy), ServerData (copy), u77 (ref), u78 (ref), RefreshRankedQueuingUI (copy), StartPendingDirectJoinSearch (copy)
        local v99 = Play:GetAttribute("PendingDirectJoinGamemode") or "";

        if v99 == "" then
            if Play:GetAttribute("TeleportTransitionActive") ~= true and (ServerData and ((ServerData:GetAttribute("Searching") or "") == "" and ((Play:GetAttribute("DirectJoinActiveGamemode") or "") == "" and (Play:GetAttribute("PendingCustomAction") or "") == ""))) then
                u77 = u77 + 1;
                u78 = 0;
                Play.Quickmatch.Timer.Visible = false;
                Play.Quickmatch.GamemodeTitle.Visible = true;
                Play.Quickmatch.Title.Visible = true;
                Play.Gamemodes.Visible = true;
                Play.Servers.Visible = true;

                if Play:FindFirstChild("QuickmatchCancel") then
                    Play.QuickmatchCancel.Visible = false;
                end;

                RefreshRankedQueuingUI();
            end;
        else
            StartPendingDirectJoinSearch(v99);
        end;
    end);
    Play:GetAttributeChangedSignal("PendingCustomAction"):Connect(function() -- Line: 1105
        -- upvalues: Play (copy), ServerData (copy), u77 (ref), u78 (ref), RefreshRankedQueuingUI (copy), StartPendingCustomAction (copy)
        local v100 = Play:GetAttribute("PendingCustomAction") or "";

        if v100 == "" then
            if Play:GetAttribute("TeleportTransitionActive") ~= true and (ServerData and ((ServerData:GetAttribute("Searching") or "") == "" and ((Play:GetAttribute("DirectJoinActiveGamemode") or "") == "" and (Play:GetAttribute("PendingDirectJoinGamemode") or "") == ""))) then
                u77 = u77 + 1;
                u78 = 0;
                Play.Quickmatch.Timer.Visible = false;
                Play.Quickmatch.GamemodeTitle.Visible = true;
                Play.Quickmatch.Title.Visible = true;
                Play.Gamemodes.Visible = true;
                Play.Servers.Visible = true;

                if Play:FindFirstChild("QuickmatchCancel") then
                    Play.QuickmatchCancel.Visible = false;
                end;

                RefreshRankedQueuingUI();
            end;
        else
            StartPendingCustomAction(v100);
        end;
    end);
    Play:GetAttributeChangedSignal("DirectJoinActiveGamemode"):Connect(function() -- Line: 1117
        -- upvalues: Play (copy), SetQuickmatchSearchingUI (copy), u78 (ref), ServerData (copy), RefreshRankedQueuingUI (copy)
        if (Play:GetAttribute("DirectJoinActiveGamemode") or "") == "" then
            if Play:GetAttribute("TeleportTransitionActive") ~= true and (ServerData and ((ServerData:GetAttribute("Searching") or "") == "" and (Play:GetAttribute("PendingCustomAction") or "") == "")) then
                u78 = 0;
                Play.Quickmatch.Timer.Visible = false;
                Play.Quickmatch.GamemodeTitle.Visible = true;
                Play.Quickmatch.Title.Visible = true;
                Play.Gamemodes.Visible = true;
                Play.Servers.Visible = true;

                if Play:FindFirstChild("QuickmatchCancel") then
                    Play.QuickmatchCancel.Visible = false;
                end;

                RefreshRankedQueuingUI();
            end;

            return;
        end;

        SetQuickmatchSearchingUI(true, u78);
    end);
    Play.Quickmatch:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 1125
        -- upvalues: RefreshRankedQueuingUI (copy)
        RefreshRankedQueuingUI();
    end);
    ServerList:GetAttributeChangedSignal("RankedQueuing"):Connect(function() -- Line: 1129
        -- upvalues: RefreshRankedQueuingUI (copy), ServerData (copy), Play (copy), SetQuickmatchSearchingUI (copy), u78 (ref)
        RefreshRankedQueuingUI();

        if ServerData and ((ServerData:GetAttribute("Searching") or "") ~= "" or (Play:GetAttribute("DirectJoinActiveGamemode") or "") ~= "") then
            SetQuickmatchSearchingUI(true, u78);
        end;
    end);
    RefreshRankedQueuingUI();
    SetQuickmatchSearchingUI(((ServerData:GetAttribute("Searching") or "") ~= "" or ((Play:GetAttribute("DirectJoinActiveGamemode") or "") ~= "" or ((Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" or (Play:GetAttribute("PendingCustomAction") or "") ~= ""))) and true or Play:GetAttribute("TeleportTransitionActive") == true, u78);

    if (Play:GetAttribute("PendingDirectJoinGamemode") or "") == "" then
        if (Play:GetAttribute("PendingCustomAction") or "") ~= "" then
            StartPendingCustomAction(Play:GetAttribute("PendingCustomAction") or "");
        end;
    else
        StartPendingDirectJoinSearch(Play:GetAttribute("PendingDirectJoinGamemode") or "");
    end;

    u2.ConfigPartySystem();
    (function() -- Line: 1157, Name: ConfigBoosterScroller
        -- upvalues: Play (copy), Config (ref), SoundService (ref), u2 (ref), ReplicatedStorage (ref), Stats (copy)
        Play.Booster.Activated:Connect(function() -- Line: 1159
            -- upvalues: Play (ref)
            if Play.BoosterList.Visible == false then
                Play.BoosterList.Visible = true;

                return;
            end;

            Play.BoosterList.Visible = false;
        end);
        Play.BoosterList.Cancel.Activated:Connect(function() -- Line: 1167
            -- upvalues: Play (ref)
            Play.BoosterList.Visible = false;
        end);

        for _, child in pairs(Play.BoosterList:GetChildren()) do
            if child.Name == "BoosterCash" or child.Name == "BoosterExperience" then
                child.Purchase.Activated:Connect(function() -- Line: 1174
                    -- upvalues: Config (ref), SoundService (ref), u2 (ref), child (copy)
                    Config.AddSound("Click_3", 1, true, SoundService, false);
                    u2.SetupMonetisationButton(child.Purchase);
                end);
                child.Activate.Activated:Connect(function() -- Line: 1179
                    -- upvalues: ReplicatedStorage (ref), child (copy)
                    ReplicatedStorage.Events.ActivateBooster:FireServer(child.Name);
                end);
                child.Remaining.Text = Stats:GetAttribute(child.Name) .. "x";
                Stats:GetAttributeChangedSignal(child.Name):Connect(function() -- Line: 1184
                    -- upvalues: child (copy), Stats (ref)
                    child.Remaining.Text = Stats:GetAttribute(child.Name) .. "x";
                end);

                local function RefreshTime() -- Line: 1188
                    -- upvalues: Stats (ref), child (copy), Config (ref)
                    if Stats:GetAttribute(child.Name .. "Time") <= 0 then
                        child.Time.Text = "";

                        return;
                    end;

                    child.Time.Text = Config.toHMS(Stats:GetAttribute(child.Name .. "Time"));
                end;

                if Stats:GetAttribute(child.Name .. "Time") <= 0 then
                    child.Time.Text = "";
                else
                    child.Time.Text = Config.toHMS(Stats:GetAttribute(child.Name .. "Time"));
                end;

                Stats:GetAttributeChangedSignal(child.Name .. "Time"):Connect(function() -- Line: 1196
                    -- upvalues: Stats (ref), child (copy), Config (ref)
                    if Stats:GetAttribute(child.Name .. "Time") <= 0 then
                        child.Time.Text = "";

                        return;
                    end;

                    child.Time.Text = Config.toHMS(Stats:GetAttribute(child.Name .. "Time"));
                end);
            end;
        end;
    end)();
    (function() -- Line: 1203, Name: ConfigGraphicFirstSetting
        -- upvalues: LocalPlayer (ref), Play (copy), ReplicatedStorage (ref)
        if LocalPlayer:WaitForChild("PlayerData").Settings:GetAttribute("GraphicsSelected") == false then
            Play.Graphics.Options.Normal.Activated:Connect(function() -- Line: 1206
                -- upvalues: ReplicatedStorage (ref), Play (ref)
                ReplicatedStorage.Events.EditSettings:FireServer({
                    Name = "Graphics",
                    Value = "Normal",
                    Single = true
                });
                Play.Graphics.Visible = false;
            end);
            Play.Graphics.Options.Performance.MouseButton1Down:Connect(function() -- Line: 1211
                -- upvalues: ReplicatedStorage (ref), Play (ref)
                ReplicatedStorage.Events.EditSettings:FireServer({
                    Name = "Graphics",
                    Value = "Performance",
                    Single = true
                });
                Play.Graphics.Visible = false;
            end);
            Play.Graphics.Visible = true;
        end;
    end)();
end;

function u2.ConfigLoadout() -- Line: 1222
    -- upvalues: u7 (ref), u2 (copy)
    local Loadout = u7:WaitForChild("Pages"):WaitForChild("Loadout");
    Loadout:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1225
        -- upvalues: Loadout (copy)
        if Loadout.Visible == true then
            Loadout.LoadoutSelection.Visible = true;
            Loadout.LoadoutMain.Visible = true;
            Loadout.LoadoutWeapon.Visible = false;
            Loadout.LoadoutScroller.Visible = false;
        end;
    end);
    u2.ConfigLoadoutButtons();
    u2.ConfigLoadoutInputPrompt();
    u2.ConfigLoadoutPrompt();
end;

function u2.ConfigStore() -- Line: 1239
    -- upvalues: u2 (copy)
    u2.ConfigStorePage();
end;

function u2.ConfigSettings() -- Line: 1243
    -- upvalues: u2 (copy)
    u2.ConfigSettingButtons();
end;

local u101 = false;

function u2.ConfigKeybinds() -- Line: 1249
    -- upvalues: u101 (ref), Keybinds (copy), u7 (ref), Config (copy), SoundService (copy), u2 (copy)
    if u101 == true then
        return;
    end;

    u101 = true;
    Keybinds.Configure();
    local Settings = u7:WaitForChild("Pages"):WaitForChild("Settings");
    local Keybinds2 = u7:WaitForChild("Pages"):WaitForChild("Keybinds");
    local Toggle = Settings:WaitForChild("Scroller"):WaitForChild("Keybinds"):WaitForChild("Toggle");
    local Close = Keybinds2:WaitForChild("Close");
    Toggle.MouseButton1Up:Connect(function() -- Line: 1263
        -- upvalues: Config (ref), SoundService (ref), u2 (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        u2.OpenPage("Keybinds");
    end);
    Close.MouseButton1Down:Connect(function() -- Line: 1268
        -- upvalues: Config (ref), SoundService (ref), Keybinds (ref), u2 (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        Keybinds.CancelBinding();
        u2.OpenPage("Settings");
    end);
end;

function u2.ConfigProfile() -- Line: 1275
    -- upvalues: u2 (copy)
    u2.ConfigProfilePage();
end;

function u2.ConfigLeaderboard() -- Line: 1279
    -- upvalues: u2 (copy)
    u2.ConfigLeaderboardPage();
end;

function u2.ConfigCrate() -- Line: 1283
    -- upvalues: u2 (copy)
    u2.ConfigCratePage();
end;

function u2.ConfigBattlepass() -- Line: 1287
    -- upvalues: u2 (copy)
    u2.ConfigBattlepassButtons();
end;

function u2.ConfigGang() -- Line: 1291
    -- upvalues: u2 (copy)
    u2.ConfigGangPage();
end;

function u2.ConfigServers() -- Line: 1295
    -- upvalues: u2 (copy)
    u2.ConfigServersPage();
end;

function u2.SetNewViewPort(p102, p103, p104) -- Line: 1303
    -- upvalues: Config (copy)
    local Camera = p102:FindFirstChild("Camera");

    if Camera == nil then
        Camera = Instance.new("Camera", p102);
        Camera.CFrame = CFrame.new(p104, p103);
    elseif p102.Parent.Parent.Name == "Battlepass" then
        Camera.CFrame = CFrame.new(p104, p103);
        Camera.FieldOfView = 100;
        Config.TweenCreate(Camera, {
            FieldOfView = 80
        }, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
    elseif p102.Parent.Name == "ItemNotification" then
        Camera.CFrame = CFrame.new(p104, p103);
        Camera.FieldOfView = 100;
        Config.TweenCreate(Camera, {
            FieldOfView = 70
        }, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
    else
        Config.TweenCreate(Camera, {
            CFrame = CFrame.new(p104, p103)
        }, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
    end;

    p102.CurrentCamera = Camera;
end;

function u2.TransparentSelectedBody(p105, p106) -- Line: 1324
    if p106 == "Top" then
        p105.Head.Transparency = 1;
        p105["Left Leg"].Transparency = 1;
        p105["Right Leg"].Transparency = 1;

        return;
    end;

    if p106 ~= "Bottom" then
        if p106 == "Head" then
            for _, child in pairs(p105:GetChildren()) do
                if child:IsA("Part") then
                    child.Transparency = 1;
                end;
            end;

            p105.Head.Transparency = 0;
        end;

        return;
    end;

    p105.Head.Transparency = 1;
    p105.Torso.Transparency = 1;
    p105["Left Arm"].Transparency = 1;
    p105["Right Arm"].Transparency = 1;
end;

function u2.AddItemToViewport(p107, p108, p109) -- Line: 1344
    -- upvalues: Config (copy), GetViewportRenderedObject (copy), ReplicatedStorage (copy), u2 (copy), Weapon (copy), Utility (copy)
    local v110 = Config.GetItemIDFromItemData(p107);

    if not v110 or v110 == "" then
        v110 = string.format("%s:%s:%s", p107.Type or "", p107.Name or "", p107.Weapon or "");
    end;

    if p108:GetAttribute("ViewportCacheKey") == v110 then
        local v111 = GetViewportRenderedObject(p108);

        if v111 then
            return v111;
        end;

        p108:SetAttribute("ViewportCacheKey", nil);
    end;

    p108:SetAttribute("ViewportCacheKey", v110);
    local v112 = ReplicatedStorage.Items[p107.Type][p107.Name]:Clone();

    if v112:IsA("Model") and not v112.PrimaryPart then
        v112.PrimaryPart = v112:FindFirstChild("Base");
    end;

    local v113 = Vector3.new(0, 0, 0);
    local v114 = Vector3.new(0, 0, -2.5);

    for _, child in pairs(p108:GetChildren()) do
        if child.Name ~= "Camera" then
            child:Destroy();
        end;
    end;

    if p107.Type == "Top" or p107.Type == "Bottom" then
        local v115 = script.SampleBody:Clone();
        u2.TransparentSelectedBody(v115, p107.Type);
        v112.Parent = v115;
        v115.PrimaryPart = v115.HumanoidRootPart;
        v115.Parent = p108;
        v115:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)));

        if p107.Type == "Top" then
            v113 = Vector3.new(0, 0, 0);
            v114 = Vector3.new(0, 0, -3.5);
        elseif p107.Type == "Bottom" then
            v113 = Vector3.new(0, -2, 0);
            v114 = Vector3.new(0, -2, -3.5);
        end;
    elseif p107.Type == "Skin" then
        if p109 and ReplicatedStorage.Items.Skin[p107.Name]:GetAttribute("UV") ~= true then
            p108.Parent.ImageDisplay.ImageColor3 = ReplicatedStorage.Items.Skin[p107.Name].Color3;
            p108.Parent.ImageDisplay.Image = ReplicatedStorage.Items.Skin[p107.Name].Texture;
            p108.Parent.ImageDisplay.Size = UDim2.new(1, 0, 0.5, 0);
            p108.Parent.ImageDisplay.Position = UDim2.new(0.5, 0, 0.48, 0);
        else
            local v116 = ReplicatedStorage.Items.Weapon[p107.Weapon or "MP5"]:Clone();
            v112.Parent = p108;
            v116.PrimaryPart = v116.Nodes.Center;
            v116.Parent = p108;
            v116:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, -1.5707963267948966, 0));
            Weapon.SetSkinOnWep(v116, p107.Name);
        end;

        p108.Ambient = Color3.fromRGB(255, 255, 255);
        p108.LightDirection = Vector3.new(-1, 0, 0);
        v114 = Vector3.new(0, 0, -3);
    elseif p107.Type == "Banner" then
        p108.Parent.ImageDisplay.ScaleType = Enum.ScaleType.Fit;
        p108.Parent.ImageDisplay.ImageColor3 = ReplicatedStorage.Items.Banner[p107.Name].Color3;
        p108.Parent.ImageDisplay.Image = ReplicatedStorage.Items.Banner[p107.Name].Texture;
    elseif p107.Type == "Title" then
        p108.Parent.TextDisplay.TextColor3 = ReplicatedStorage.Items.Title[p107.Name].TextColor3;
        p108.Parent.TextDisplay.Text = ReplicatedStorage.Items.Title[p107.Name].Text;
        p108.Parent.TextDisplay.Font = ReplicatedStorage.Items.Title[p107.Name].Font;
        p108.Parent.TextDisplay.TextStrokeColor3 = ReplicatedStorage.Items.Title[p107.Name].TextStrokeColor3;
        p108.Parent.TextDisplay.TextStrokeTransparency = ReplicatedStorage.Items.Title[p107.Name].TextStrokeTransparency;
        p108.Parent.TextDisplay.UIGradient.Enabled = true;
        p108.Parent.TextDisplay.UIGradient.Color = ReplicatedStorage.Items.Title[p107.Name].UIGradient.Color;
        p108.Parent.TextDisplay.UIGradient.Rotation = ReplicatedStorage.Items.Title[p107.Name].UIGradient.Rotation;
    elseif p107.Type == "Head" then
        v112.PrimaryPart = v112.HumanoidRootPart;
        v112.Parent = p108;
        u2.TransparentSelectedBody(v112, p107.Type);
        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)));
        v113 = Vector3.new(0, 1.5, 0);
        v114 = Vector3.new(0, 1.5, -3);
    elseif p107.Type == "Weapon" then
        v112.PrimaryPart = v112.Nodes.Center;
        v112.Parent = p108;
        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, -1.5707963267948966, 0));
        p108.Ambient = Color3.fromRGB(255, 255, 255);
        p108.LightDirection = Vector3.new(-1, 0, 0);
        v113 = Vector3.new(0, -0.2, 0);
        v114 = Vector3.new(0, -0.2, -2.2);
    elseif p107.Type == "Sight" then
        v112.Parent = p108;
        v112.PrimaryPart = v112.Base;
        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, -1.9198621771937625, 0));
        v113 = Vector3.new(0, 0, 0);
        v114 = Vector3.new(0, 0, -0.65);
    elseif p107.Type == "Grip" then
        v113 = Vector3.new(0, -0.1, 0);
        v114 = Vector3.new(0, -0.1, -0.65);
        v112.Parent = p108;

        if not v112.PrimaryPart then
            v112.PrimaryPart = v112:FindFirstChild("Base") or v112.PrimaryPart;
        end;

        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, 0));

        if p107.Name == "Angled Grip" then
            v113 = Vector3.new(0, 0, 0);
            v114 = Vector3.new(-0.6, 0, 0);
        end;
    elseif p107.Type == "Muzzle" then
        v113 = Vector3.new(0, 0, 0);
        v114 = Vector3.new(0, 0, -0.85);
        v112.Parent = p108;

        if not v112.PrimaryPart then
            v112.PrimaryPart = v112:FindFirstChild("Base") or v112.PrimaryPart;
        end;

        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 1.5707963267948966, 0));
    elseif p107.Type == "Throwable" then
        v113 = Vector3.new(0, 0.24, 0);
        v114 = Vector3.new(0.4, 0.24, -1.5);
        v112.Parent = p108;

        if not v112.PrimaryPart then
            v112.PrimaryPart = v112:FindFirstChild("Base") or v112.PrimaryPart;
        end;

        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, 0));
    elseif p107.Type == "Deployable" then
        v112.PrimaryPart = v112.Base;
        v112.Parent = p108;
        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, 0));
        v113 = Vector3.new(0, 1.5, 0);
        v114 = Vector3.new(-1, 1.5, 4);
    elseif p107.Type == "Charm" then
        v113 = Vector3.new(0, -0.05, 0);
        v114 = Vector3.new(0, -0.05, -0.3);
        v112.Parent = p108;

        if not v112.PrimaryPart then
            v112.PrimaryPart = v112:FindFirstChild("Base") or v112.PrimaryPart;
        end;

        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 3.141592653589793, 0));
    elseif p107.Type == "Extra" then
        v113 = Vector3.new(0, 0.1, 0);
        v114 = Vector3.new(0, 0.1, -1);
        v112.Parent = p108;

        if not v112.PrimaryPart then
            v112.PrimaryPart = v112:FindFirstChild("Base") or v112.PrimaryPart;
        end;

        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 3.141592653589793, 0));
    elseif p107.Type == "Vest" then
        v112.PrimaryPart = v112.Core;
        v112.Parent = p108;
        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, 0));
        v113 = Vector3.new(0, 0.1, 0);
        v114 = Vector3.new(0.5, 0.1, -2.3);
    elseif p107.Type == "Emote" then
        local WorldModel = p108:FindFirstChild("WorldModel");

        if WorldModel == nil then
            WorldModel = Instance.new("WorldModel", p108);
        end;

        local v117 = script.SampleBody:Clone();
        u2.TransparentSelectedBody(v117, p107.Type);
        v117:FindFirstChild("Holster").Anchored = false;
        v112.Parent = v117;
        v117.PrimaryPart = v117.HumanoidRootPart;
        v117.Parent = WorldModel;
        v117:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)));
        v117.Humanoid:LoadAnimation(v112):Play();
        v113 = Vector3.new(0, -0.9, 0);
        v114 = Vector3.new(0, -0.9, -7);
    elseif p107.Type == "Crate" then
        v112.Parent = p108;

        if not v112.PrimaryPart then
            v112.PrimaryPart = v112:FindFirstChild("Base") or v112.PrimaryPart;
        end;

        v112:PivotTo(CFrame.new(0, 0, 0));
        v113 = Vector3.new(0, 0, 0);
        v114 = Vector3.new(0, 3.5, -11);
    elseif p107.Type == "Knife" then
        v112.PrimaryPart = v112:FindFirstChild("Base") or v112.Handle;
        v112.Parent = p108;
        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 3.141592653589793, 0));
        v113 = Vector3.new(0, 0, 0);
        v114 = Vector3.new(0, 0, -1.6);
    elseif p107.Type == "AttachmentSkin" then
        if v112 then
            v112:Destroy();
        end;

        local Slot = p107.Slot;
        local v118;

        if Slot == "Sight" then
            v112 = ReplicatedStorage.Items.Sight["M4 Scope"]:Clone();
            v118 = CFrame.new(Vector3.new(-0.1, -0.05, 0)) * CFrame.Angles(0, -1.5707963267948966, 0);
        elseif Slot == "Grip" then
            v112 = ReplicatedStorage.Items.Grip["Vertical Grip"]:Clone();
            v118 = CFrame.new(Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, -1.5707963267948966, 0);
        elseif Slot == "Muzzle" then
            v112 = ReplicatedStorage.Items.Muzzle.Silencer:Clone();
            v118 = CFrame.new(Vector3.new(0.275, 0, -0.1)) * CFrame.Angles(0, 1.5707963267948966, 0);
        else
            if Slot ~= "Extra" then
                warn(Utility.warnCustom((`Invalid weapon slot, got "{Slot}"`)));

                return;
            end;

            v112 = ReplicatedStorage.Items.Extra["Red Laser Sight"]:Clone();
            v118 = CFrame.new(Vector3.new(0.02, 0, -0.4)) * CFrame.Angles(0, 1.5707963267948966, -1.5707963267948966);
        end;

        for _, child in v112:GetChildren() do
            if child:IsA("MeshPart") then
                child.TextureID = ReplicatedStorage.Items.AttachmentSkin:FindFirstChild(p107.Name).Texture;
            end;
        end;

        v112.Parent = p108;
        v112.PrimaryPart = v112.Base;
        v112:SetPrimaryPartCFrame(v118);
        v113 = Vector3.new(0, 0, 0);
        v114 = Vector3.new(0, 0, -1);
    else
        v112.PrimaryPart = v112:FindFirstChild("Base");
        v112.Parent = p108;
        v112:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, 0));
    end;

    u2.SetNewViewPort(p108, v113, v114);

    return v112;
end;

function u2.ConfigLoginRewards(p119, u120) -- Line: 1614
    -- upvalues: ReplicatedStorage (copy), Config (copy), ApplyCurrencyGradient (copy), ApplyCurrencyDisplayState (copy), u2 (copy), LoginRewards (copy), SoundService (copy)
    local LoginFrame = p119:FindFirstChild("LoginFrame");
    local Login = p119:FindFirstChild("Login");

    if not (LoginFrame and (Login and u120)) then
        return;
    end;

    local Claim = LoginFrame:FindFirstChild("Claim");
    local ButtonBlocker = LoginFrame:FindFirstChild("ButtonBlocker");
    local Rewards = LoginFrame:FindFirstChild("Rewards");
    local ClaimLoginReward = ReplicatedStorage.Events:WaitForChild("ClaimLoginReward");

    if not (Claim and (ButtonBlocker and Rewards)) then
        return;
    end;

    local u121 = {};

    for i = 1, 7 do
        local v122 = Rewards:FindFirstChild((tostring(i)));
        local v123;

        if v122 then
            v123 = v122:FindFirstChild("ItemDisplay");
        else
            v123 = v122;
        end;

        local v124;

        if v123 then
            v124 = v123:FindFirstChild("Background");
        else
            v124 = v123;
        end;

        local v125;

        if v123 then
            v125 = v123:FindFirstChild("Day");
        else
            v125 = v123;
        end;

        if v122 and (v123 and v125) then
            u121[i] = {
                ItemBackgroundColor = v123.BackgroundColor3,
                BackgroundColor = v124 and v124.BackgroundColor3 or nil,
                DayTextColor = v125.TextColor3
            };
        end;
    end;

    local u126 = false;

    local function GetRewardRarityColor(p127) -- Line: 1646
        -- upvalues: ReplicatedStorage (ref), Config (ref)
        local v128 = p127.RewardType == "Crate" and ReplicatedStorage.Items.Crate:FindFirstChild(p127.RewardName);

        if v128 then
            local v129 = Config.GetItemDataFromObject(v128);

            if v129 then
                v129 = Config.Rarity[v129.Rarity or ""];
            end;

            if v129 then
                return v129.Color;
            end;
        end;

        return Config.Rarity.Legendary.Color;
    end;

    local function ApplySlotVisual(p130, p131, p132) -- Line: 1661
        -- upvalues: ReplicatedStorage (ref), Config (ref), ApplyCurrencyGradient (ref), ApplyCurrencyDisplayState (ref), u2 (ref)
        local ItemDisplay = p130:FindFirstChild("ItemDisplay");
        local v133;

        if ItemDisplay then
            v133 = ItemDisplay:FindFirstChild("ImageDisplay");
        else
            v133 = ItemDisplay;
        end;

        local v134;

        if ItemDisplay then
            v134 = ItemDisplay:FindFirstChild("Amount");
        else
            v134 = ItemDisplay;
        end;

        local v135;

        if ItemDisplay then
            v135 = ItemDisplay:FindFirstChild("Rarity");
        else
            v135 = ItemDisplay;
        end;

        local v136;

        if ItemDisplay then
            v136 = ItemDisplay:FindFirstChild("ItemPort");
        else
            v136 = ItemDisplay;
        end;

        local v137;

        if ItemDisplay then
            v137 = ItemDisplay:FindFirstChild("Day");
        else
            v137 = ItemDisplay;
        end;

        local v138;

        if ItemDisplay then
            v138 = ItemDisplay:FindFirstChild("Claimed");
        else
            v138 = ItemDisplay;
        end;

        local v139;

        if ItemDisplay then
            v139 = ItemDisplay:FindFirstChild("Background");
        else
            v139 = ItemDisplay;
        end;

        local v140;

        if ItemDisplay then
            v140 = ItemDisplay:FindFirstChildOfClass("UIStroke");
        else
            v140 = ItemDisplay;
        end;

        if not (ItemDisplay and (v133 and (v134 and (v135 and (v136 and (v137 and v138)))))) then
            return;
        end;

        v137.Text = "DAY " .. p131.Day;
        v134.Text = p131.RewardType == "Crate" and "x1" or "x" .. tostring(p131.RewardAmount or 0);
        local v141 = p131.RewardType == "Crate" and ReplicatedStorage.Items.Crate:FindFirstChild(p131.RewardName);
        local v142;

        if v141 then
            local v143 = Config.GetItemDataFromObject(v141);

            if v143 then
                v143 = Config.Rarity[v143.Rarity or ""];
            end;

            if v143 then
                v142 = v143.Color;
            else
                v142 = Config.Rarity.Legendary.Color;
            end;
        else
            v142 = Config.Rarity.Legendary.Color;
        end;

        v135.ImageColor3 = v142;

        if p131.RewardType == "Crate" then
            v133.Image = "";
            ApplyCurrencyGradient(v133);
            ApplyCurrencyDisplayState(v133, nil, v135);
            v133.Visible = false;
            v136.Visible = true;
            u2.AddItemToViewport({
                Type = "Crate",
                Name = p131.RewardName
            }, v136);
        else
            for _, child in ipairs(v136:GetChildren()) do
                if child.Name ~= "Camera" then
                    child:Destroy();
                end;
            end;

            v136.Visible = false;
            v133.Visible = true;
            v133.Image = Config.CurrencyImage[p131.RewardType] or "";
            v133.ImageColor3 = Color3.fromRGB(255, 255, 255);
            ApplyCurrencyGradient(v133, p131.RewardType);
            ApplyCurrencyDisplayState(v133, p131.RewardType, v135);
        end;

        if p131.State == "Claimed" then
            v138.Visible = true;
            ItemDisplay.Size = UDim2.fromScale(1, 1);

            if v140 then
                v140.Thickness = 0.015;
                v140.Color = Color3.fromRGB(100, 100, 100);
            end;

            ItemDisplay.BackgroundColor3 = p132 and p132.ItemBackgroundColor or ItemDisplay.BackgroundColor3;

            if v139 and (p132 and p132.BackgroundColor) then
                v139.BackgroundColor3 = p132.BackgroundColor;
            end;

            v137.TextColor3 = p132 and p132.DayTextColor or v137.TextColor3;

            return;
        end;

        if p131.State == "Claimable" then
            v138.Visible = false;
            ItemDisplay.Size = UDim2.fromScale(1.1, 1.1);

            if v140 then
                v140.Thickness = 0.02;
                v140.Color = Color3.fromRGB(255, 255, 255);
            end;

            ItemDisplay.BackgroundColor3 = p132 and p132.ItemBackgroundColor or ItemDisplay.BackgroundColor3;

            if v139 and (p132 and p132.BackgroundColor) then
                v139.BackgroundColor3 = p132.BackgroundColor;
            end;

            v137.TextColor3 = p132 and p132.DayTextColor or v137.TextColor3;

            return;
        end;

        v138.Visible = false;
        ItemDisplay.Size = UDim2.fromScale(1, 1);

        if v140 then
            v140.Thickness = 0.015;
            v140.Color = Color3.fromRGB(255, 170, 0);
        end;

        ItemDisplay.BackgroundColor3 = Color3.fromRGB(20, 12, 0);

        if v139 then
            v139.BackgroundColor3 = Color3.fromRGB(255, 170, 0);
        end;

        v137.TextColor3 = Color3.fromRGB(0, 0, 0);
    end;

    local function RefreshLoginRewards(p144) -- Line: 1739
        -- upvalues: LoginRewards (ref), u120 (copy), Rewards (copy), ApplySlotVisual (copy), u121 (copy), Claim (copy), u126 (ref), LoginFrame (copy)
        local v145 = LoginRewards.GetClientState(u120);

        for i, v in ipairs(v145.Rewards) do
            local v146 = Rewards:FindFirstChild((tostring(i)));

            if v146 then
                ApplySlotVisual(v146, v, u121[i]);
            end;
        end;

        Claim.Active = not u126;
        Claim.AutoButtonColor = v145.CanClaim and not u126;

        if p144 == true and v145.CanClaim == true then
            LoginFrame.Visible = true;
        end;
    end;

    LoginFrame.Visible = false;
    Login.Activated:Connect(function() -- Line: 1757
        -- upvalues: Config (ref), SoundService (ref), RefreshLoginRewards (copy), LoginFrame (copy)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        RefreshLoginRewards(false);
        LoginFrame.Visible = true;
    end);
    LoginFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1763
        -- upvalues: LoginFrame (copy), RefreshLoginRewards (copy)
        if LoginFrame.Visible == true then
            RefreshLoginRewards(false);
        end;
    end);
    ButtonBlocker.Activated:Connect(function() -- Line: 1769
        -- upvalues: RefreshLoginRewards (copy)
        RefreshLoginRewards(false);
    end);
    Claim.Activated:Connect(function() -- Line: 1773
        -- upvalues: LoginFrame (copy), u126 (ref), RefreshLoginRewards (copy), LoginRewards (ref), u120 (copy), Claim (copy), Config (ref), SoundService (ref), ClaimLoginReward (copy)
        LoginFrame.Visible = false;

        if u126 then
            return;
        end;

        RefreshLoginRewards(false);

        if LoginRewards.CanClaim(u120) ~= true then
            return;
        end;

        u126 = true;
        Claim.Active = false;
        Claim.AutoButtonColor = false;
        Config.AddSound("Click_2", 1, true, SoundService, false);
        ClaimLoginReward:FireServer();
        task.delay(0.5, function() -- Line: 1789
            -- upvalues: u126 (ref), RefreshLoginRewards (ref)
            u126 = false;
            RefreshLoginRewards(false);
        end);
    end);

    for _, v in ipairs({
        LoginRewards.Attributes.ClaimCount,
        LoginRewards.Attributes.LastClaimAt,
        LoginRewards.Attributes.CurrentDay,
        LoginRewards.Attributes.CurrentWeek,
        LoginRewards.Attributes.ClaimSerial
    }) do
        u120:GetAttributeChangedSignal(v):Connect(function() -- Line: 1802
            -- upvalues: u126 (ref), RefreshLoginRewards (copy)
            u126 = false;
            RefreshLoginRewards(false);
        end);
    end;

    task.defer(function() -- Line: 1808
        -- upvalues: RefreshLoginRewards (copy)
        RefreshLoginRewards(true);
    end);
end;

function u2.ConfigChallenges() -- Line: 1813
    -- upvalues: u7 (ref), LocalPlayer (copy), ReplicatedStorage (copy), Config (copy), ApplyCurrencyGradient (copy), ApplyCurrencyDisplayState (copy), u2 (copy), Challenges (copy), SoundService (copy)
    local Play = u7:WaitForChild("Pages"):WaitForChild("Play");
    local Challenges2 = Play:WaitForChild("Challenges");
    local ChallengesNext = Play:WaitForChild("ChallengesNext");
    local Scroller2 = Challenges2:WaitForChild("Scroller");
    local DailyChallenges = LocalPlayer.PlayerData:WaitForChild("DailyChallenges");
    local WeeklyChallenges = LocalPlayer.PlayerData:WaitForChild("WeeklyChallenges");
    local u147 = "Daily";
    local u148 = {};

    local function DisconnectChallengeConnections() -- Line: 1823
        -- upvalues: u148 (copy)
        for _, v in ipairs(u148) do
            v:Disconnect();
        end;

        table.clear(u148);
    end;

    local function GetRewardLabel(p149) -- Line: 1830
        local v150 = p149:GetAttribute("RewardType");
        local v151 = p149:GetAttribute("RewardAmount") or 0;
        local v152 = p149:GetAttribute("RewardName") or v150;

        if v150 == "Crate" then
            return v151 .. " " .. v152 .. " Crate";
        end;

        return v151 .. " " .. tostring(v150);
    end;

    local function u156(p153) -- Line: 1842
        -- upvalues: ReplicatedStorage (ref), Config (ref)
        local v154 = p153:GetAttribute("RewardType") == "Crate" and ReplicatedStorage.Items.Crate:FindFirstChild(p153:GetAttribute("RewardName"));

        if v154 then
            local v155 = Config.GetItemDataFromObject(v154);

            if v155 then
                v155 = Config.Rarity[v155.Rarity or ""];
            end;

            if v155 then
                return v155.Color;
            end;
        end;

        return Config.Rarity.Legendary.Color;
    end;

    local function ApplyRewardDisplay(p157, p158) -- Line: 1857
        -- upvalues: u156 (copy), ApplyCurrencyGradient (ref), ApplyCurrencyDisplayState (ref), ReplicatedStorage (ref), u2 (ref), Config (ref)
        if not p157 then
            return;
        end;

        local v159 = p158:GetAttribute("RewardType");
        local v160 = p158:GetAttribute("RewardAmount") or 0;
        local v161 = p158:GetAttribute("RewardName") or v159;
        local v162 = p157:FindFirstChild("ImageDisplay") or p157:FindFirstChild("CurrencyImage");
        local Rarity = p157:FindFirstChild("Rarity");
        local Amount = p157:FindFirstChild("Amount");
        local ItemPort = p157:FindFirstChild("ItemPort");

        if Amount and Amount:IsA("TextLabel") then
            Amount.Text = v159 == "Crate" and "x" .. v160 or tostring(v160);
        end;

        if Rarity and Rarity:IsA("ImageLabel") then
            Rarity.ImageColor3 = u156(p158);
        end;

        if v159 == "Crate" then
            if v162 and v162:IsA("ImageLabel") then
                v162.Image = "";
                ApplyCurrencyGradient(v162);
                ApplyCurrencyDisplayState(v162, nil, Rarity);
                v162.Visible = false;
            end;

            if ItemPort and ItemPort:IsA("ViewportFrame") then
                ItemPort.Visible = true;
                local v163 = ReplicatedStorage.Items.Crate:FindFirstChild(v161);

                if v163 then
                    u2.AddItemToViewport(Config.GetItemDataFromObject(v163), ItemPort);
                end;
            end;
        else
            if ItemPort and ItemPort:IsA("ViewportFrame") then
                for _, child in ipairs(ItemPort:GetChildren()) do
                    if child.Name ~= "Camera" then
                        child:Destroy();
                    end;
                end;

                ItemPort.Visible = false;
            end;

            if v162 and v162:IsA("ImageLabel") then
                v162.Visible = true;
                v162.Image = Config.CurrencyImage[v159] or "";
                v162.ImageColor3 = Color3.fromRGB(255, 255, 255);
                ApplyCurrencyGradient(v162, v159);
                ApplyCurrencyDisplayState(v162, v159, Rarity);
            end;
        end;
    end;

    local function ApplyChallengeCard(p164, p165, p166) -- Line: 1913
        -- upvalues: Challenges (ref), ApplyRewardDisplay (copy)
        local v167 = p165:GetAttribute("Progression") or 0;
        local v168 = p165:GetAttribute("Goal") or 1;
        local v169 = p165:GetAttribute("Status") or Challenges.Statuses.Incomplete;
        local v170 = p165:GetAttribute("Title") or p165.Name;
        local v171 = v168 > 0 and (math.clamp(v167 / v168, 0, 1) or 0) or 0;
        local v172 = v168 <= v167 and true or v169 ~= Challenges.Statuses.Incomplete;
        p164.Title.Text = v170;
        p164.Amount.Text = math.floor(v167) .. "/" .. v168;
        p164.Progress.Bar.Size = UDim2.new(v171, 0, 1, 0);
        p164.Completed.Visible = v172;

        if p166 and p164:FindFirstChild("Info") then
            local Info = p164.Info;
            local v173 = p165:GetAttribute("RewardType");
            local v174 = p165:GetAttribute("RewardAmount") or 0;
            local v175 = p165:GetAttribute("RewardName") or v173;
            local v176;

            if v173 == "Crate" then
                v176 = v174 .. " " .. v175 .. " Crate";
            else
                v176 = v174 .. " " .. tostring(v173);
            end;

            Info.Text = v176;
        end;

        ApplyRewardDisplay(p164:FindFirstChild("ImageDisplay") or p164:FindFirstChild("ItemDisplay"), p165);
    end;

    local function GetOrderedChallenges(p177) -- Line: 1933
        -- upvalues: WeeklyChallenges (copy), DailyChallenges (copy), Challenges (ref)
        local v178 = p177 == "Weekly" and WeeklyChallenges or DailyChallenges;
        local v179 = Challenges.GetDefinitions(p177);
        local v180 = {};

        for _, v in ipairs(v179) do
            local v181 = v178:FindFirstChild(v.Id);

            if v181 then
                table.insert(v180, v181);
            end;
        end;

        return v180;
    end;

    local function SetTrackButtonState(p182) -- Line: 1948
        -- upvalues: u2 (ref), Challenges2 (copy)
        u2.SetSelectionState(Challenges2.Daily, p182 == "Daily", Color3.fromRGB(255, 255, 255), Color3.fromRGB(30, 30, 30));
        u2.SetSelectionState(Challenges2.Weekly, p182 == "Weekly", Color3.fromRGB(255, 255, 255), Color3.fromRGB(30, 30, 30));
        Challenges2.Daily.BackgroundColor3 = p182 == "Daily" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 30);
        Challenges2.Weekly.BackgroundColor3 = p182 == "Weekly" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 30);
    end;

    local function RefreshScroller() -- Line: 1955
        -- upvalues: Scroller2 (copy), GetOrderedChallenges (copy), u147 (ref), ApplyChallengeCard (copy)
        for _, child in ipairs(Scroller2:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        for _, v in ipairs((GetOrderedChallenges(u147))) do
            local v183 = script.SampleChallenge:Clone();
            v183.Visible = true;
            v183.Parent = Scroller2;
            ApplyChallengeCard(v183, v, false);
        end;
    end;

    local function RefreshNextChallenge() -- Line: 1970
        -- upvalues: GetOrderedChallenges (copy), ChallengesNext (copy), ApplyChallengeCard (copy)
        local v184 = nil;

        for _, v in ipairs((GetOrderedChallenges("Daily"))) do
            if (v:GetAttribute("Progression") or 0) < (v:GetAttribute("Goal") or 0) then
                v184 = v;
                break;
            end;
        end;

        ChallengesNext.Visible = v184 ~= nil;

        if v184 then
            ApplyChallengeCard(ChallengesNext.Challenge, v184, true);
        end;
    end;

    local function RefreshAllChallenges() -- Line: 1985
        -- upvalues: SetTrackButtonState (copy), u147 (ref), RefreshScroller (copy), RefreshNextChallenge (copy)
        SetTrackButtonState(u147);
        RefreshScroller();
        RefreshNextChallenge();
    end;

    local function ReconnectChallengeSignals() -- Line: 1991
        -- upvalues: u148 (copy), DailyChallenges (copy), WeeklyChallenges (copy), SetTrackButtonState (copy), u147 (ref), RefreshScroller (copy), RefreshNextChallenge (copy), ReconnectChallengeSignals (copy), RefreshAllChallenges (copy)
        for _, v in ipairs(u148) do
            v:Disconnect();
        end;

        table.clear(u148);

        for _, v in ipairs({ DailyChallenges, WeeklyChallenges }) do
            table.insert(u148, v.ChildAdded:Connect(function() -- Line: 1995
                -- upvalues: SetTrackButtonState (ref), u147 (ref), RefreshScroller (ref), RefreshNextChallenge (ref), ReconnectChallengeSignals (ref)
                SetTrackButtonState(u147);
                RefreshScroller();
                RefreshNextChallenge();
                ReconnectChallengeSignals();
            end));
            table.insert(u148, v.ChildRemoved:Connect(function() -- Line: 1999
                -- upvalues: SetTrackButtonState (ref), u147 (ref), RefreshScroller (ref), RefreshNextChallenge (ref), ReconnectChallengeSignals (ref)
                SetTrackButtonState(u147);
                RefreshScroller();
                RefreshNextChallenge();
                ReconnectChallengeSignals();
            end));

            for _, child in ipairs(v:GetChildren()) do
                local v185 = child:GetAttributeChangedSignal("Progression");
                table.insert(u148, v185:Connect(RefreshAllChallenges));
                local v186 = child:GetAttributeChangedSignal("Status");
                table.insert(u148, v186:Connect(RefreshAllChallenges));
            end;
        end;
    end;

    Challenges2.Daily.Activated:Connect(function() -- Line: 2011
        -- upvalues: u147 (ref), SetTrackButtonState (copy), RefreshScroller (copy), RefreshNextChallenge (copy), Config (ref), SoundService (ref)
        u147 = "Daily";
        SetTrackButtonState(u147);
        RefreshScroller();
        RefreshNextChallenge();
        Config.AddSound("Click_2", 1, true, SoundService, false);
    end);
    Challenges2.Weekly.Activated:Connect(function() -- Line: 2017
        -- upvalues: u147 (ref), SetTrackButtonState (copy), RefreshScroller (copy), RefreshNextChallenge (copy), Config (ref), SoundService (ref)
        u147 = "Weekly";
        SetTrackButtonState(u147);
        RefreshScroller();
        RefreshNextChallenge();
        Config.AddSound("Click_2", 1, true, SoundService, false);
    end);
    SetTrackButtonState(u147);
    RefreshScroller();
    RefreshNextChallenge();
    ReconnectChallengeSignals();
end;

function u2.ConfigPartySystem() -- Line: 2027
    -- upvalues: u7 (ref), Config (copy), SoundService (copy), ReplicatedStorage (copy), LocalPlayer (copy), Players (copy), u2 (copy)
    local Play = u7:WaitForChild("Pages"):WaitForChild("Play");
    local Top = u7:WaitForChild("Top");
    Top.Notification.PartyRequest:SetAttribute("InviteType", "");
    Top.Notification.PartyRequest.Accept.Activated:Connect(function() -- Line: 2032
        -- upvalues: Config (ref), SoundService (ref), Top (copy), ReplicatedStorage (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);

        if Top.Notification.PartyRequest:GetAttribute("InviteType") == "Gang" then
            ReplicatedStorage.Events.GangUpdate:FireServer("Join", {
                GangName = Top.Notification.PartyRequest:GetAttribute("GangName"),
                InviterName = Top.Notification.PartyRequest:GetAttribute("Inviter"),
                InviterUserId = Top.Notification.PartyRequest:GetAttribute("InviterUserId")
            });
        else
            ReplicatedStorage.Events.PartyUpdate:FireServer("Join", Top.Notification.PartyRequest:GetAttribute("Inviter"));
        end;

        Top.Notification.PartyRequest.Visible = false;
        Top.Notification.PartyRequest:SetAttribute("InviteType", "");
    end);
    Top.Notification.PartyRequest.Decline.Activated:Connect(function() -- Line: 2048
        -- upvalues: Config (ref), SoundService (ref), Top (copy), ReplicatedStorage (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);

        if Top.Notification.PartyRequest:GetAttribute("InviteType") == "Gang" then
            ReplicatedStorage.Events.GangUpdate:FireServer("Decline", {
                GangName = Top.Notification.PartyRequest:GetAttribute("GangName")
            });
        else
            ReplicatedStorage.Events.PartyUpdate:FireServer("Decline", Top.Notification.PartyRequest:GetAttribute("Inviter"));
        end;

        Top.Notification.PartyRequest.Visible = false;
        Top.Notification.PartyRequest:SetAttribute("InviteType", "");
    end);
    ReplicatedStorage.Events.PartyInvite.OnClientEvent:Connect(function(p187) -- Line: 2062
        -- upvalues: Top (copy), Config (ref)
        Top.Notification.PartyRequest.Visible = true;
        Top.Notification.PartyRequest.Position = UDim2.new(1.3, 0, 0.264, 0);
        Top.Notification.PartyRequest:SetAttribute("InviteType", "Party");
        Top.Notification.PartyRequest:SetAttribute("Inviter", p187.Name);
        Top.Notification.PartyRequest:SetAttribute("GangName", "");
        Top.Notification.PartyRequest:SetAttribute("InviterUserId", 0);
        Config.TweenCreate(Top.Notification.PartyRequest, {
            Position = UDim2.new(0.88, 0, 0.264, 0)
        }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        Top.Notification.PartyRequest.Title.Text = p187.Name .. " Invited you to their party.";
    end);
    ReplicatedStorage.Events.GangInvite.OnClientEvent:Connect(function(p188, p189, p190) -- Line: 2074
        -- upvalues: Top (copy), Config (ref)
        Top.Notification.PartyRequest.Visible = true;
        Top.Notification.PartyRequest.Position = UDim2.new(1.3, 0, 0.264, 0);
        Top.Notification.PartyRequest:SetAttribute("InviteType", "Gang");
        Top.Notification.PartyRequest:SetAttribute("Inviter", p188.Name);
        Top.Notification.PartyRequest:SetAttribute("GangName", p189);
        Top.Notification.PartyRequest:SetAttribute("InviterUserId", p190 or 0);
        Config.TweenCreate(Top.Notification.PartyRequest, {
            Position = UDim2.new(0.88, 0, 0.264, 0)
        }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        Top.Notification.PartyRequest.Title.Text = p188.Name .. " invited you to join " .. p189 .. ".";
    end);
    Play.Party.LeaveButton.Button.Activated:Connect(function() -- Line: 2086
        -- upvalues: ReplicatedStorage (ref)
        ReplicatedStorage.Events.PartyUpdate:FireServer("Leave");
    end);
    ReplicatedStorage.Events.PartyUpdate.OnClientEvent:Connect(function() -- Line: 2090
        -- upvalues: LocalPlayer (ref), Play (copy), Players (ref), u2 (ref)
        local Settings = LocalPlayer.PlayerData.Settings;

        for _, child in pairs(Play.Party.Party:GetChildren()) do
            if child:IsA("ImageButton") then
                child:Destroy();
            end;
        end;

        if Settings:GetAttribute("Party") == "" then
            Play.Party.LeaveButton.Visible = false;
        else
            Play.Party.LeaveButton.Visible = true;

            for _, child in pairs(Players:GetChildren()) do
                if child:WaitForChild("PlayerData"):WaitForChild("Settings"):GetAttribute("Party") == Settings:GetAttribute("Party") then
                    local v191 = script.SampleParty:Clone();
                    v191.Parent = Play.Party.Party;
                    v191.Icon.Image = child:WaitForChild("ServerData"):GetAttribute("ProfilePicture") or "";

                    if child.Name == Settings:GetAttribute("Party") then
                        v191.Crown.Visible = true;
                    end;
                end;
            end;
        end;

        u2.UpdateHome();
    end);
    Play.Party.PartyButton.Activated:Connect(function() -- Line: 2118
        -- upvalues: Play (copy)
        if Play.PartyList.Visible == false then
            Play.PartyList.Visible = true;

            return;
        end;

        Play.PartyList.Visible = false;
    end);
    local u192 = false;
    Play.PartyList:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2128
        -- upvalues: Play (copy), Players (ref), LocalPlayer (ref), ReplicatedStorage (ref), Config (ref), SoundService (ref), u192 (ref)
        if Play.PartyList.Visible == true then
            for _, v in pairs(Players:GetPlayers()) do
                local v193 = v:IsFriendsWith(LocalPlayer.UserId);
                local PlayerData = v:WaitForChild("PlayerData");
                local ServerData = v:WaitForChild("ServerData");

                if not Play.PartyList.List:FindFirstChild(v.Name) then
                    local v194 = script.SamplePartyList:Clone();
                    v194.Name = v.Name;
                    v194.Title.Text = v.DisplayName;
                    v194.Display.Image = ServerData:GetAttribute("ProfilePicture") or "";
                    v194.Parent = Play.PartyList.List;
                    local v195 = ReplicatedStorage.Items.Banner:FindFirstChild(PlayerData.Loadout:FindFirstChild(PlayerData.Settings:GetAttribute("LoadoutName")):GetAttribute("Banner"));

                    if v195 == nil then
                        v194.Banner.Image = "";
                    else
                        v194.Banner.Image = v195.Texture;
                    end;

                    if v193 then
                        v194.LayoutOrder = 3;
                    else
                        v194.LayoutOrder = 1;
                    end;

                    v194.MouseButton1Down:Connect(function() -- Line: 2162
                        -- upvalues: Config (ref), SoundService (ref), u192 (ref), ReplicatedStorage (ref), v (copy)
                        Config.AddSound("Click_1", 1, true, SoundService, false);

                        if u192 == true then
                            return;
                        end;

                        u192 = true;
                        task.delay(3, function() -- Line: 2166
                            -- upvalues: u192 (ref)
                            u192 = false;
                        end);
                        ReplicatedStorage.Events.PartyInvite:FireServer(v);
                    end);
                end;
            end;

            for _, child in pairs(Play.PartyList.List:GetChildren()) do
                if child:IsA("ImageButton") and not Players:FindFirstChild(child.Name) then
                    child:Destroy();
                end;
            end;
        end;

        Scroller.CanvasPosition = Vector2.new(0, 0);
    end);
end;

function u2.ConfigLoadoutInputPrompt() -- Line: 2188
    -- upvalues: u7 (ref), ReplicatedStorage (copy), u2 (copy)
    local Loadout = u7:WaitForChild("Pages"):WaitForChild("Loadout");
    Loadout.InputPrompt.Cancel.Activated:Connect(function() -- Line: 2191
        -- upvalues: Loadout (copy)
        Loadout.InputPrompt.Visible = false;
    end);
    Loadout.InputPrompt.Accept.Activated:Connect(function() -- Line: 2195
        -- upvalues: Loadout (copy), ReplicatedStorage (ref), u2 (ref)
        local v196 = Loadout.InputPrompt:GetAttribute("Event");

        if not v196 then
            return;
        end;

        if v196 == "Rename" or v196 == "Create" then
            ReplicatedStorage.Events.EditLoadout:FireServer(v196, Loadout.InputPrompt.Input.Text);
        elseif v196 == "Delete" then
            if string.upper(Loadout.InputPrompt.Input.Text) ~= "YES" then
                u2.AddNotification("Input \'YES\' to proceed", Color3.fromRGB(255, 100, 100));

                return;
            end;

            ReplicatedStorage.Events.EditLoadout:FireServer(v196, Loadout.InputPrompt.Input.Text);
        end;

        Loadout.InputPrompt.Visible = false;
    end);
end;

function u2.ConfigLoadoutPrompt() -- Line: 2213
    -- upvalues: u7 (ref), u4 (ref), Config (copy), SoundService (copy), ReplicatedStorage (copy)
    local Loadout = u7:WaitForChild("Pages"):WaitForChild("Loadout");
    Loadout.Prompt.Cancel.Activated:Connect(function() -- Line: 2216
        -- upvalues: Loadout (copy)
        Loadout.Prompt.Visible = false;
    end);
    Loadout.Prompt.Accept.Activated:Connect(function() -- Line: 2220
        -- upvalues: u4 (ref), Config (ref), SoundService (ref), ReplicatedStorage (ref), Loadout (copy)
        if not u4 then
            return;
        end;

        Config.AddSound("Click_3", 1, true, SoundService, false);
        ReplicatedStorage.Events.PurchaseLoadout:FireServer(u4);
        Loadout.Prompt.Visible = false;
    end);
end;

function u2.RefreshLoadoutButton(u197, p198, p199, p200) -- Line: 2229
    -- upvalues: LocalPlayer (copy), GetDisplayedLoadoutName (copy), ReplicatedStorage (copy), Config (copy), u2 (copy), Weapon (copy), ApplyLoadoutAttachments (copy)
    local u201 = p198 or "";
    local v202 = p200 or "";
    local v203 = LocalPlayer;
    local PlayerData = v203:FindFirstChild("PlayerData");
    local v204;

    if PlayerData then
        local Loadout = PlayerData:FindFirstChild("Loadout");

        if Loadout then
            v204 = Loadout:FindFirstChild((GetDisplayedLoadoutName(v203)));
        else
            v204 = nil;
        end;
    else
        v204 = nil;
    end;

    if not v204 then
        return;
    end;

    local Empty = u197:FindFirstChild("Empty");
    local Type = u197:FindFirstChild("Type");
    local Title = u197:FindFirstChild("Title");
    local TextDisplay = u197:FindFirstChild("TextDisplay");
    local Rarity = u197:FindFirstChild("Rarity");
    local v205 = (u201 == "Sight" or (u201 == "Grip" or u201 == "Muzzle")) and true or u201 == "Extra";
    local v206;

    if v202 == "" then
        v206 = nil;
    else
        v206 = ReplicatedStorage.Items.Weapon:FindFirstChild(v202) or nil;
    end;

    local v207;

    if v205 then
        if v206 == nil or v206:FindFirstChild("Nodes") == nil then
            v207 = false;
        else
            v207 = v206.Nodes:FindFirstChild(u201) ~= nil;
        end;
    else
        v207 = true;
    end;

    (function() -- Line: 2252, Name: ResetSlotBase
        -- upvalues: u197 (copy), Empty (copy), Title (copy), TextDisplay (copy), u201 (ref), Type (copy), Rarity (copy)
        u197.Visible = true;
        u197.Active = true;
        u197.AutoButtonColor = true;
        u197.ItemPort:ClearAllChildren();
        u197.ImageDisplay.Image = "";

        if Empty then
            Empty.Visible = true;
        end;

        if Title then
            Title.Text = "";
        end;

        if TextDisplay then
            TextDisplay.Text = u201 == "Title" and "" or "TITLE";
            TextDisplay.TextColor3 = Color3.fromRGB(255, 255, 255);
            TextDisplay.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
            TextDisplay.TextStrokeTransparency = 1;
            local UIGradient = TextDisplay:FindFirstChild("UIGradient");

            if UIGradient then
                UIGradient.Enabled = false;
                UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255));
                UIGradient.Rotation = 0;
            end;
        end;

        if Type then
            Type.Text = u201;
            Type.TextTransparency = 0;
            Type.Visible = true;
        end;

        if Rarity then
            Rarity.Visible = false;
        end;
    end)();

    if v205 and not v207 then
        u197.Active = false;
        u197.AutoButtonColor = false;

        if Type then
            Type.Text = "";
        end;

        return;
    end;

    local v208 = v204:GetAttribute((p199 or "") .. u201) or "";
    local v209 = (u201 == "Primary" or u201 == "Secondary") and (v204:GetAttribute(u201 .. "Weapon") or "") or v208;

    if v209 == "" then
        return;
    end;

    local v210;

    if u201 == "Primary" or u201 == "Secondary" then
        local v211 = ReplicatedStorage.Items.Weapon:FindFirstChild(v209);
        v210 = v211 and Config.GetItemDataFromObject(v211) or {};
    else
        local v212 = ReplicatedStorage.Items[u201]:FindFirstChild(v209);
        v210 = v212 and Config.GetItemDataFromObject(v212) or {};
    end;

    v210.Weapon = v202;

    if Title then
        Title.Text = v209;

        if u201 == "Title" then
            Title.Text = "";
        end;
    end;

    if Type and u201 == "Title" then
        Type.Visible = v209 == "";
    end;

    if Empty then
        Empty.Visible = false;
    end;

    if Rarity and (v210.Rarity and Config.Rarity[v210.Rarity]) then
        Rarity.Visible = (u201 == "Head" or (u201 == "Top" or (u201 == "Bottom" or (u201 == "Banner" or (u201 == "Title" or (u201 == "Emote" or (u201 == "Knife" or u201 == "Skin"))))))) and true or u201 == "Charm";
        Rarity.ImageColor3 = Config.Rarity[v210.Rarity].Color;
        Rarity.ImageTransparency = 0.3;
    end;

    local v213;

    if u201 == "Skin" then
        v213 = u2.AddItemToViewport(v210, u197.ItemPort, true);
    else
        v213 = u2.AddItemToViewport(v210, u197.ItemPort);
    end;

    if u201 == "Primary" or u201 == "Secondary" then
        if not v213 then
            return;
        end;

        local v214 = v204:GetAttribute(u201 .. "Skin");
        Weapon.SetSkinOnWep(v213, v214);
        ApplyLoadoutAttachments(v213, v204, u201, LocalPlayer);
        Weapon.SetAttachmentSkins(v213, v204, u201);
    end;
end;

function u2.ConfigLoadoutButtons() -- Line: 2354
    -- upvalues: u7 (ref), LocalPlayer (copy), Config (copy), GetDisplayedLoadoutName (copy), SoundService (copy), ReplicatedStorage (copy), u2 (copy), u4 (ref), GetLoadoutScrollerCacheKey (copy), u5 (copy), AttachmentSkinHandler (copy)
    local Loadout = u7:WaitForChild("Pages"):WaitForChild("Loadout");
    local PlayerData = LocalPlayer:WaitForChild("PlayerData");

    local function GetNextLoadoutName() -- Line: 2358
        -- upvalues: LocalPlayer (ref)
        local Loadout2 = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Loadout");

        for i = 1, 30 do
            local v215 = "Loadout" .. i;

            if not Loadout2:FindFirstChild(v215) then
                return v215;
            end;
        end;

        return "Loadout" .. 30;
    end;

    if game.PlaceId == Config.LobbyID then
        Loadout.LoadoutSelection.Create.Activated:Connect(function() -- Line: 2373
            -- upvalues: Loadout (copy), GetNextLoadoutName (copy)
            Loadout.InputPrompt.Visible = true;
            Loadout.InputPrompt:SetAttribute("Event", "Create");
            Loadout.InputPrompt.Title.Text = "Input name to create new loadout";
            Loadout.InputPrompt.Input.Text = GetNextLoadoutName();
            Loadout.LoadoutSelection.LoadoutSelectScroller.Visible = false;
        end);
        Loadout.LoadoutSelection.Rename.Activated:Connect(function() -- Line: 2382
            -- upvalues: Loadout (copy)
            Loadout.InputPrompt.Visible = true;
            Loadout.InputPrompt:SetAttribute("Event", "Rename");
            Loadout.InputPrompt.Title.Text = "Input new name";
        end);
        Loadout.LoadoutSelection.Delete.Activated:Connect(function() -- Line: 2388
            -- upvalues: Loadout (copy)
            Loadout.InputPrompt.Visible = true;
            Loadout.InputPrompt:SetAttribute("Event", "Delete");
            Loadout.InputPrompt.Title.Text = "Input \'Yes\' to proceed";
        end);
    end;

    Loadout.LoadoutSelection.LoadoutSelect.Activated:Connect(function() -- Line: 2395
        -- upvalues: Loadout (copy)
        if Loadout.LoadoutSelection.LoadoutSelectScroller.Visible == false then
            Loadout.LoadoutSelection.LoadoutSelectScroller.Visible = true;

            return;
        end;

        Loadout.LoadoutSelection.LoadoutSelectScroller.Visible = false;
    end);

    local function RefreshLoadoutSelectorButtons() -- Line: 2405
        -- upvalues: GetDisplayedLoadoutName (ref), LocalPlayer (ref), Loadout (copy)
        local v216 = GetDisplayedLoadoutName(LocalPlayer);

        for _, child in pairs(Loadout.LoadoutSelection.LoadoutSelectScroller:GetChildren()) do
            if child:IsA("ImageButton") then
                local Title = child:FindFirstChild("Title");

                if Title and Title:IsA("TextLabel") then
                    local FontFace = Title.FontFace;
                    local Family = FontFace.Family;
                    local Style = FontFace.Style;

                    if child.Name == v216 then
                        child.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        Title.TextColor3 = Color3.fromRGB(0, 0, 0);
                        Title.FontFace = Font.new(Family, Enum.FontWeight.Bold, Style);
                    else
                        child.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
                        Title.TextColor3 = Color3.fromRGB(255, 255, 255);
                        Title.FontFace = Font.new(Family, Enum.FontWeight.Regular, Style);
                    end;
                end;
            end;
        end;
    end;

    Loadout.LoadoutSelection.LoadoutSelectScroller:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2429
        -- upvalues: Loadout (copy), LocalPlayer (ref), Config (ref), SoundService (ref), ReplicatedStorage (ref), RefreshLoadoutSelectorButtons (copy)
        if Loadout.LoadoutSelection.LoadoutSelectScroller.Visible == true then
            local Loadout2 = LocalPlayer.PlayerData.Loadout;
            local v217 = {};

            for _, child in pairs(Loadout2:GetChildren()) do
                v217[child.Name] = true;
            end;

            for _, child in pairs(Loadout.LoadoutSelection.LoadoutSelectScroller:GetChildren()) do
                if child:IsA("ImageButton") and not v217[child.Name] then
                    child:Destroy();
                end;
            end;

            for _, child in pairs(Loadout2:GetChildren()) do
                local u218 = Loadout.LoadoutSelection.LoadoutSelectScroller:FindFirstChild(child.Name);

                if not u218 then
                    u218 = script.SampleLoadoutButton:Clone();
                    u218.Parent = Loadout.LoadoutSelection.LoadoutSelectScroller;
                    u218.Activated:Connect(function() -- Line: 2451
                        -- upvalues: Config (ref), SoundService (ref), ReplicatedStorage (ref), child (copy), Loadout (ref)
                        Config.AddSound("Click_3", 1, true, SoundService, false);

                        if game.PlaceId == Config.InGameID then
                            ReplicatedStorage.GameEvents.ChangeLoadoutInGame:FireServer(child.Name);
                        else
                            ReplicatedStorage.Events.ChangeLoadout:FireServer(child.Name);
                        end;

                        Loadout.LoadoutSelection.LoadoutSelectScroller.Visible = false;
                    end);
                    child.Destroying:Once(function() -- Line: 2462
                        -- upvalues: u218 (ref)
                        if u218 and u218.Parent then
                            u218:Destroy();
                        end;
                    end);
                end;

                u218.Name = child.Name;
                u218.Title.Text = child.Name;

                if child.Name == "Default" then
                    u218.LayoutOrder = 1;
                else
                    u218.LayoutOrder = 1 + Config.StringToNumber(child.Name);
                end;
            end;

            RefreshLoadoutSelectorButtons();
        end;
    end);

    local function RefreshLoadoutMain() -- Line: 2484
        -- upvalues: Loadout (copy), u2 (ref)
        for _, child in pairs(Loadout.LoadoutMain:GetChildren()) do
            if child:IsA("ImageButton") then
                u2.RefreshLoadoutButton(child, child.Name, "", "");
            end;
        end;
    end;

    local function WaitForSelectedLoadout(p219) -- Line: 2491
        -- upvalues: LocalPlayer (ref), GetDisplayedLoadoutName (ref)
        local Loadout2 = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Loadout");
        local v220 = os.clock() + (p219 or 2);
        local v221 = GetDisplayedLoadoutName(LocalPlayer);
        local v222 = Loadout2:FindFirstChild(v221);

        while not v222 and os.clock() < v220 do
            task.wait();
            v221 = GetDisplayedLoadoutName(LocalPlayer);
            v222 = Loadout2:FindFirstChild(v221);
        end;

        return v221, v222;
    end;

    local function RefreshSelectedLoadoutUI() -- Line: 2506
        -- upvalues: WaitForSelectedLoadout (copy), u4 (ref), Loadout (copy), RefreshLoadoutMain (copy), RefreshLoadoutSelectorButtons (copy), u2 (ref), LocalPlayer (ref), u7 (ref)
        local v223, v224 = WaitForSelectedLoadout();

        if not v224 then
            return;
        end;

        u4 = nil;

        if Loadout.LoadoutMain.Visible == true then
            Loadout:SetAttribute("LoadoutType", "Character");
            Loadout:SetAttribute("WeaponClass", "");
        end;

        Loadout.LoadoutSelection.LoadoutSelect.Title.Text = v223 or "Select Loadout";
        RefreshLoadoutMain();
        RefreshLoadoutSelectorButtons();

        if Loadout.Visible == true then
            u2.UpdateMainDisplay(LocalPlayer, u7.Pages.Loadout.Details.ItemPort);
        end;
    end;

    LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Settings"):GetAttributeChangedSignal("LoadoutName"):Connect(function() -- Line: 2527
        -- upvalues: RefreshSelectedLoadoutUI (copy)
        RefreshSelectedLoadoutUI();
    end);
    LocalPlayer:WaitForChild("ServerData"):GetAttributeChangedSignal("NextLoadout"):Connect(function() -- Line: 2531
        -- upvalues: RefreshSelectedLoadoutUI (copy)
        RefreshSelectedLoadoutUI();
    end);
    Loadout:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2535
        -- upvalues: Loadout (copy), GetDisplayedLoadoutName (ref), LocalPlayer (ref), RefreshLoadoutMain (copy), u2 (ref), u7 (ref)
        if Loadout.Visible == true then
            Loadout.LoadoutSelection.LoadoutSelect.Title.Text = GetDisplayedLoadoutName(LocalPlayer) or "Select Loadout";
            Loadout.LoadoutMain.Visible = true;
            Loadout.LoadoutWeapon.Visible = false;
            Loadout.LoadoutScroller.Visible = false;
            RefreshLoadoutMain();
            u2.UpdateMainDisplay(LocalPlayer, u7.Pages.Loadout.Details.ItemPort);
        end;
    end);

    local function BuildLoadoutScrollerItemDatas(p225, p226, p227) -- Line: 2548
        -- upvalues: ReplicatedStorage (ref), Config (ref), Loadout (copy)
        local v228 = {};

        if p227 == "Weapon" then
            for _, child in pairs(ReplicatedStorage.Items.Weapon:GetChildren()) do
                if child:GetAttribute("Type") == "Weapon" then
                    local v229 = Config.GetItemDataFromObject(child);

                    if (Loadout:GetAttribute("WeaponClass") or "Primary") == v229.Class then
                        v228[#v228 + 1] = v229;
                    end;
                end;
            end;
        elseif p227 == "Throwable" or (p227 == "Vest" or p227 == "Deployable") then
            for _, child in pairs(ReplicatedStorage.Items[p227]:GetChildren()) do
                if child:GetAttribute("Type") == p227 then
                    v228[#v228 + 1] = Config.GetItemDataFromObject(child);
                end;
            end;
        elseif p227 == "Sight" or (p227 == "Grip" or (p227 == "Muzzle" or p227 == "Extra")) then
            local v230 = p226:GetAttribute((Loadout:GetAttribute("WeaponClass") or "Primary") .. "Weapon");

            for _, child in pairs(ReplicatedStorage.Items[p227]:GetChildren()) do
                local v231 = Config.GetItemDataFromObject(child);
                v231.Weapon = v230;
                v228[#v228 + 1] = v231;
            end;
        elseif p227 == "Skin" then
            local v232 = p226:GetAttribute((Loadout:GetAttribute("WeaponClass") or "Primary") .. "Weapon");

            for _, child in pairs(p225.Inventory:GetChildren()) do
                local v233 = Config.GetItemDataFromPlayerInventoryItem(child);

                if v233.Type == p227 and (child.Name == Config.GetItemIDFromItemData(v233) and v233.Weapon == v232) then
                    v228[#v228 + 1] = v233;
                end;
            end;
        else
            for _, child in pairs(p225.Inventory:GetChildren()) do
                if child:GetAttribute("Type") == p227 then
                    v228[#v228 + 1] = Config.GetItemDataFromPlayerInventoryItem(child);
                end;
            end;
        end;

        local u234 = {
            Cash = 0,
            Credit = 1,
            CampaignPoints = 2
        };
        table.sort(v228, function(p235, p236) -- Line: 2596
            -- upvalues: ReplicatedStorage (ref), Config (ref), u234 (copy)
            local v237 = ReplicatedStorage.Items[p235.Type][p235.Name];
            local v238 = ReplicatedStorage.Items[p236.Type][p236.Name];

            if v237:GetAttribute("CostType") ~= v238:GetAttribute("CostType") then
                return u234[v237:GetAttribute("CostType")] < u234[v238:GetAttribute("CostType")];
            end;

            if v237:GetAttribute("Cost") and v238:GetAttribute("Cost") then
                return v237:GetAttribute("Cost") < v238:GetAttribute("Cost");
            end;

            if v237:GetAttribute("Rarity") and v238:GetAttribute("Rarity") then
                return Config.Rarity[v237:GetAttribute("Rarity")].Credit > Config.Rarity[v238:GetAttribute("Rarity")].Credit;
            end;

            return false;
        end);

        return v228;
    end;

    local function EnsureLoadoutScrollerPadding(p239) -- Line: 2616
        for i = 1, 6 do
            local v240 = p239:FindFirstChild("Padding" .. i);

            if not v240 then
                v240 = script.SampleItem:Clone();
                v240.Name = "Padding" .. i;
                v240.Parent = p239;
                v240.LayoutOrder = i + 5000;
                v240.BackgroundTransparency = 1;
                v240:SetAttribute("IsLoadoutScrollerPadding", true);

                for _, child in pairs(v240:GetChildren()) do
                    if child:IsA("ImageLabel") or (child:IsA("Frame") or child:IsA("TextLabel")) then
                        child.Visible = false;
                    elseif child:IsA("UIStroke") then
                        child.Enabled = false;
                    end;
                end;
            end;

            v240.Visible = true;
        end;
    end;

    local function RefreshLoadoutScroller(p241) -- Line: 2638
        -- upvalues: LocalPlayer (ref), Loadout (copy), GetDisplayedLoadoutName (ref), GetLoadoutScrollerCacheKey (ref), u5 (ref), BuildLoadoutScrollerItemDatas (copy), Config (ref), u2 (ref), EnsureLoadoutScrollerPadding (copy)
        local PlayerData2 = LocalPlayer:WaitForChild("PlayerData");
        local v242 = Loadout:GetAttribute("LoadoutType");
        local v243 = LocalPlayer;
        local PlayerData3 = v243:FindFirstChild("PlayerData");
        local v244;

        if PlayerData3 then
            local Loadout2 = PlayerData3:FindFirstChild("Loadout");

            if Loadout2 then
                v244 = Loadout2:FindFirstChild((GetDisplayedLoadoutName(v243)));
            else
                v244 = nil;
            end;
        else
            v244 = nil;
        end;

        if not v244 then
            return;
        end;

        local Scroller2 = Loadout.LoadoutScroller.Scroller;
        local v245 = GetLoadoutScrollerCacheKey(Loadout, v244);
        local v246;

        if p241 then
            v246 = nil;
        else
            v246 = u5[v245] or nil;
        end;

        if v246 == nil then
            v246 = BuildLoadoutScrollerItemDatas(PlayerData2, v244, v242);
            u5[v245] = v246;
        end;

        local v247 = {};

        for _, v in ipairs(v246) do
            local v248 = Config.GetItemIDFromItemData(v);

            if not v248 or v248 == "" then
                v248 = string.format("%s:%s:%s", v.Type or "", v.Name or "", v.Weapon or "");
            end;

            v247[v248] = true;
        end;

        for _, child in ipairs(Scroller2:GetChildren()) do
            if child:IsA("ImageButton") and child:GetAttribute("IsLoadoutScrollerPadding") ~= true then
                child.Visible = v247[child:GetAttribute("ItemKey")] == true;
            end;
        end;

        u2.CreateItemDisplay(v246, Scroller2, Loadout.Details);
        EnsureLoadoutScrollerPadding(Scroller2);
        Scroller2.CanvasPosition = Vector2.new(0, 0);
    end;

    PlayerData.Inventory.ChildAdded:Connect(function() -- Line: 2668
        -- upvalues: u5 (ref), Loadout (copy), RefreshLoadoutScroller (copy)
        table.clear(u5);

        if Loadout.LoadoutScroller.Visible == true then
            RefreshLoadoutScroller(true);
        end;
    end);
    PlayerData.Inventory.ChildRemoved:Connect(function() -- Line: 2674
        -- upvalues: u5 (ref), Loadout (copy), RefreshLoadoutScroller (copy)
        table.clear(u5);

        if Loadout.LoadoutScroller.Visible == true then
            RefreshLoadoutScroller(true);
        end;
    end);
    ReplicatedStorage.Events.Action.OnClientEvent:Connect(function(p249, p250) -- Line: 2681
        -- upvalues: Loadout (copy), RefreshLoadoutScroller (copy), u2 (ref)
        if p249 ~= "RefreshLoadout" then
            if p249 == "RefreshGang" then
                u2.OpenPage("Gang");
            end;

            return;
        end;

        if Loadout.LoadoutScroller.Visible == false then
            return;
        end;

        RefreshLoadoutScroller(false);
    end);
    Loadout.LoadoutScroller:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2689
        -- upvalues: Loadout (copy), RefreshLoadoutScroller (copy)
        if Loadout.LoadoutScroller.Visible == true then
            RefreshLoadoutScroller(false);
        end;
    end);

    if game.PlaceId == Config.LobbyID then
        for _, child in pairs(Loadout.LoadoutMain:GetChildren()) do
            if child:IsA("ImageButton") and child.Name ~= "Back" then
                child.Activated:Connect(function() -- Line: 2701
                    -- upvalues: Loadout (copy), child (copy), u2 (ref), LocalPlayer (ref), u7 (ref)
                    Loadout:SetAttribute("LoadoutType", child.Name);

                    if child.Name ~= "Primary" and child.Name ~= "Secondary" then
                        Loadout:SetAttribute("WeaponClass", "");
                        Loadout.LoadoutMain.Visible = false;
                        Loadout.LoadoutScroller.Visible = true;
                        Loadout.LoadoutSelection.Visible = false;

                        return;
                    end;

                    Loadout:SetAttribute("WeaponClass", child.Name);
                    Loadout:SetAttribute("LoadoutType", "Weapon");
                    Loadout.LoadoutMain.Visible = false;
                    Loadout.LoadoutWeapon.Visible = true;
                    Loadout.LoadoutSelection.Visible = false;
                    u2.UpdateMainDisplay(LocalPlayer, u7.Pages.Loadout.Details.ItemPort);
                end);
            end;
        end;

        Loadout.LoadoutMain:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2723
            -- upvalues: Loadout (copy), u4 (ref), RefreshLoadoutMain (copy), u2 (ref), LocalPlayer (ref), u7 (ref)
            if Loadout.LoadoutMain.Visible == true then
                u4 = {};
                Loadout:SetAttribute("LoadoutType", "Character");
                RefreshLoadoutMain();
                u2.UpdateMainDisplay(LocalPlayer, u7.Pages.Loadout.Details.ItemPort);
            end;
        end);

        for _, child in pairs(Loadout.LoadoutWeapon:GetChildren()) do
            if child:IsA("ImageButton") and child.Name ~= "Back" then
                child.Activated:Connect(function() -- Line: 2737
                    -- upvalues: Loadout (copy), child (copy), AttachmentSkinHandler (ref)
                    local v251 = Loadout:GetAttribute("WeaponClass");
                    AttachmentSkinHandler.onWeaponAttachmentButtonPressed(child.Name, v251);
                    Loadout:SetAttribute("LoadoutType", child.Name);
                    Loadout.LoadoutMain.Visible = false;
                    Loadout.LoadoutWeapon.Visible = false;
                    Loadout.LoadoutSelection.Visible = false;
                    Loadout.LoadoutScroller.Visible = true;
                end);
            end;
        end;

        Loadout.LoadoutWeapon.Back.Activated:Connect(function() -- Line: 2750
            -- upvalues: Config (ref), SoundService (ref), AttachmentSkinHandler (ref), u2 (ref), Loadout (copy), u4 (ref)
            Config.AddSound("Click_2", 1, true, SoundService, false);
            AttachmentSkinHandler.onBackPressed();
            u2.ClearDescription(Loadout.Information.Scroller);
            u4 = {};
            Loadout.LoadoutWeapon.Visible = false;
            Loadout.LoadoutMain.Visible = true;
            Loadout.LoadoutSelection.Visible = true;
        end);

        local function RefreshLoadoutWeapon() -- Line: 2761
            -- upvalues: LocalPlayer (ref), GetDisplayedLoadoutName (ref), Loadout (copy), u2 (ref)
            LocalPlayer:WaitForChild("PlayerData");
            local v252 = LocalPlayer;
            local PlayerData2 = v252:FindFirstChild("PlayerData");
            local v253;

            if PlayerData2 then
                local Loadout2 = PlayerData2:FindFirstChild("Loadout");

                if Loadout2 then
                    v253 = Loadout2:FindFirstChild((GetDisplayedLoadoutName(v252)));
                else
                    v253 = nil;
                end;
            else
                v253 = nil;
            end;

            if not v253 then
                return;
            end;

            local v254 = Loadout:GetAttribute("WeaponClass") or "Primary";
            local v255 = v253:GetAttribute(v254 .. "Weapon");

            for _, child in pairs(Loadout.LoadoutWeapon:GetChildren()) do
                if child:IsA("ImageButton") and child.Name ~= "Back" then
                    child.Visible = true;
                    u2.RefreshLoadoutButton(child, child.Name, v254, v255);
                end;
            end;
        end;

        Loadout.LoadoutWeapon:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2776
            -- upvalues: Loadout (copy), RefreshLoadoutWeapon (copy)
            if Loadout.LoadoutWeapon.Visible == true then
                RefreshLoadoutWeapon();
            end;
        end);
        Loadout.LoadoutScroller.Back.Activated:Connect(function() -- Line: 2784
            -- upvalues: Config (ref), SoundService (ref), u4 (ref), Loadout (copy)
            Config.AddSound("Click_2", 1, true, SoundService, false);
            u4 = {};
            Loadout.LoadoutScroller.Visible = false;

            if Loadout:GetAttribute("WeaponClass") ~= "" then
                Loadout.LoadoutWeapon.Visible = true;

                return;
            end;

            Loadout.LoadoutMain.Visible = true;
            Loadout.LoadoutSelection.Visible = true;
        end);
        Loadout.LoadoutScroller:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2798
            -- upvalues: Loadout (copy), u2 (ref), LocalPlayer (ref), u7 (ref)
            if Loadout.Visible == true then
                u2.UpdateMainDisplay(LocalPlayer, u7.Pages.Loadout.Details.ItemPort);
            end;
        end);
        Loadout.LoadoutScroller.Buy.Activated:Connect(function() -- Line: 2804
            -- upvalues: u4 (ref), ReplicatedStorage (ref), Loadout (copy), Config (ref)
            if not u4 then
                return;
            end;

            local v256 = ReplicatedStorage.Items:FindFirstChild(u4.Type);

            if u4.Type == "Primary" or u4.Type == "Secondary" then
                v256 = ReplicatedStorage.Items:FindFirstChild("Weapon");
            end;

            if not v256 then
                return;
            end;

            local v257 = v256:FindFirstChild(u4.Name);

            if not v257 then
                return;
            end;

            Loadout.Prompt.Visible = true;
            Loadout.Prompt.Title.Text = "Confirm purchase " .. u4.Name .. "?";
            Loadout.Prompt.Cost.Text = v257:GetAttribute("Cost") or "";
            Loadout.Prompt.Cost.Icon.Image = Config.CurrencyImage[v257:GetAttribute("CostType") or "Cash"];
        end);
    end;
end;

function u2.ConfigSettingButtons() -- Line: 2825
    -- upvalues: u7 (ref), Config (copy), SoundService (copy), LocalPlayer (copy), u2 (copy), ReplicatedStorage (copy), UserInputService (copy)
    local Settings = u7:WaitForChild("Pages"):WaitForChild("Settings");
    local u258 = {};

    for _, child in pairs(Settings.Scroller:GetChildren()) do
        if child:IsA("Frame") then
            if child.Name == "ADS" or (child.Name == "Lean" or (child.Name == "BulletHoles" or (child.Name == "Bleed" or (child.Name == "ThreeDimensionEffect" or (child.Name == "MobileClawMode" or (child.Name == "MobileAutoADS" or (child.Name == "MobileAutoSprint" or child.Name == "ObjectiveUI"))))))) then
                child.Toggle.MouseButton1Down:Connect(function() -- Line: 2833
                    -- upvalues: Config (ref), SoundService (ref), child (copy)
                    Config.AddSound("Click_2", 1, true, SoundService, false);

                    if child:GetAttribute("Toggle") == true then
                        ToggleOnOff(child, false);

                        return;
                    end;

                    ToggleOnOff(child, true);
                end);
            elseif child.Name == "Graphics" then
                child.Toggle.MouseButton1Down:Connect(function() -- Line: 2843
                    -- upvalues: Config (ref), SoundService (ref), child (copy)
                    Config.AddSound("Click_2", 1, true, SoundService, false);

                    if child:GetAttribute("String") == "Normal" then
                        ToggleString(child, "Performance");

                        return;
                    end;

                    ToggleString(child, "Normal");
                end);
            elseif child.Name == "MobileSettings" then
                LocalPlayer:WaitForChild("PlayerData"):WaitForChild("MobileSettings");
                child.Toggle.MouseButton1Down:Connect(function() -- Line: 2855
                    -- upvalues: u7 (ref), u258 (copy), u2 (ref)
                    u7.MobileControlEdit.Visible = true;

                    for _, v in pairs(u258) do
                        v:Enable();
                    end;

                    u2.RefreshMobileControlEdit(u7.MobileControlEdit);
                end);
            elseif child.Name == "MasterVolume" or (child.Name == "BackgroundMusicVolume" or (child.Name == "Sensitivity" or child.Name == "ADSSensitivity")) then
                local Text = child.Value.Text;
                child.Value.Focused:Connect(function() -- Line: 2867
                    -- upvalues: Text (ref), child (copy)
                    Text = child.Value.Text;
                end);
                child.Value.FocusLost:Connect(function() -- Line: 2870
                    -- upvalues: child (copy), Text (ref)
                    if not tonumber(child.Value.Text) then
                        child.Value.Text = Text;

                        return;
                    end;

                    local Value = child.Value;
                    local v259 = tonumber(child.Value.Text);
                    Value.Text = math.clamp(v259, 0, 1);
                end);
            elseif child.Name == "ConsoleHSensitivity" or child.Name == "ConsoleVSensitivity" then
                local Text = child.Value.Text;
                child.Value.Focused:Connect(function() -- Line: 2880
                    -- upvalues: Text (ref), child (copy)
                    Text = child.Value.Text;
                end);
                child.Value.FocusLost:Connect(function() -- Line: 2883
                    -- upvalues: child (copy), Text (ref)
                    if not tonumber(child.Value.Text) then
                        child.Value.Text = Text;

                        return;
                    end;

                    local Value = child.Value;
                    local v260 = tonumber(child.Value.Text);
                    Value.Text = math.clamp(v260, 1, 5);
                end);
            elseif child.Name == "PlayerHighlight" then
                local Text = child.Value.Text;
                child.Value.Focused:Connect(function() -- Line: 2893
                    -- upvalues: Text (ref), child (copy)
                    Text = child.Value.Text;
                end);
                child.Value.FocusLost:Connect(function() -- Line: 2896
                    -- upvalues: child (copy), Text (ref)
                    if not tonumber(child.Value.Text) then
                        child.Value.Text = Text;

                        return;
                    end;

                    local Value = child.Value;
                    local v261 = tonumber(child.Value.Text);
                    Value.Text = math.clamp(v261, 0, 0.8);
                end);
            elseif child.Name == "FieldOfView" then
                local Text = child.Value.Text;
                child.Value.Focused:Connect(function() -- Line: 2906
                    -- upvalues: Text (ref), child (copy)
                    Text = child.Value.Text;
                end);
                child.Value.FocusLost:Connect(function() -- Line: 2909
                    -- upvalues: child (copy), Text (ref), Config (ref)
                    if not tonumber(child.Value.Text) then
                        child.Value.Text = Text;

                        return;
                    end;

                    local Value = child.Value;
                    local v262 = tonumber(child.Value.Text);
                    Value.Text = math.clamp(v262, Config.MinFieldOfView, Config.MaxFieldOfView);
                end);
            elseif child.Name == "Brightness" then
                local Text = child.Value.Text;
                child.Value.Focused:Connect(function() -- Line: 2919
                    -- upvalues: Text (ref), child (copy)
                    Text = child.Value.Text;
                end);
                child.Value.FocusLost:Connect(function() -- Line: 2922
                    -- upvalues: child (copy), Text (ref), Config (ref)
                    if not tonumber(child.Value.Text) then
                        child.Value.Text = Text;

                        return;
                    end;

                    local Value = child.Value;
                    local v263 = tonumber(child.Value.Text);
                    Value.Text = math.clamp(v263, Config.MinBrightness, Config.MaxBrightness);
                end);
            end;
        end;
    end;

    Settings.Save.MouseButton1Down:Connect(function() -- Line: 2933
        -- upvalues: Config (ref), SoundService (ref), Settings (copy), ReplicatedStorage (ref)
        Config.AddSound("Click_3", 1, true, SoundService, false);
        local v264 = {
            FieldOfView = tonumber(Settings.Scroller.FieldOfView.Value.Text),
            BackgroundMusicVolume = tonumber(Settings.Scroller.BackgroundMusicVolume.Value.Text),
            MasterVolume = tonumber(Settings.Scroller.MasterVolume.Value.Text),
            BulletHoles = Settings.Scroller.BulletHoles:GetAttribute("Toggle"),
            Bleed = Settings.Scroller.Bleed:GetAttribute("Toggle"),
            ThreeDimensionEffect = Settings.Scroller.ThreeDimensionEffect:GetAttribute("Toggle"),
            Brightness = tonumber(Settings.Scroller.Brightness.Value.Text),
            MobileClawMode = Settings.Scroller.MobileClawMode:GetAttribute("Toggle"),
            MobileAutoADS = Settings.Scroller.MobileAutoADS:GetAttribute("Toggle"),
            MobileAutoSprint = Settings.Scroller.MobileAutoSprint:GetAttribute("Toggle"),
            ObjectiveUI = Settings.Scroller.ObjectiveUI:GetAttribute("Toggle"),
            Graphics = Settings.Scroller.Graphics:GetAttribute("String")
        };
        ReplicatedStorage.Events.EditSettings:FireServer(v264);
    end);
    u2.RefreshSettingsPage();
    local DragUI = require(ReplicatedStorage.Components.DragUI);
    local MobileControlEdit = Settings.Parent.Parent.MobileControlEdit;
    MobileControlEdit.Cancel.MouseButton1Down:Connect(function() -- Line: 2968
        -- upvalues: MobileControlEdit (copy), u258 (copy)
        MobileControlEdit.Visible = false;

        for _, v in pairs(u258) do
            v:Disable();
        end;
    end);
    MobileControlEdit.Reset.MouseButton1Down:Connect(function() -- Line: 2976
        -- upvalues: MobileControlEdit (copy)
        for _, child in pairs(MobileControlEdit:GetChildren()) do
            if child:IsA("ImageButton") and (child.Name ~= "Save" and (child.Name ~= "ButtonBlocker" and (child.Name ~= "Reset" and child.Name ~= "Cancel"))) then
                local v265 = script.MobileControlEdit:FindFirstChild(child.Name);

                if v265 then
                    child.Position = v265.Position;
                    child.Size = v265.Size;
                end;
            end;
        end;
    end);
    MobileControlEdit.Save.MouseButton1Down:Connect(function() -- Line: 2990
        -- upvalues: MobileControlEdit (copy), u258 (copy), ReplicatedStorage (ref)
        MobileControlEdit.Visible = false;

        for _, v in pairs(u258) do
            v:Disable();
        end;

        local v266 = {};

        for _, child in pairs(MobileControlEdit:GetChildren()) do
            if child:IsA("ImageButton") and (child.Name ~= "Save" and (child.Name ~= "ButtonBlocker" and (child.Name ~= "Reset" and child.Name ~= "Cancel"))) then
                v266[child.Name .. "YSize"] = child.Size.Y.Scale;
                v266[child.Name .. "XSize"] = child.Size.X.Scale;
                v266[child.Name .. "YPosition"] = child.Position.Y.Offset;
                v266[child.Name .. "XPosition"] = child.Position.X.Offset;
            end;
        end;

        ReplicatedStorage.Events.EditMobileSettings:FireServer(v266);
    end);
    local u267 = nil;
    local u268 = 0;
    local u269 = 0;

    for _, child in MobileControlEdit:GetChildren() do
        if child:IsA("ImageButton") and (child.Name ~= "Save" and (child.Name ~= "ButtonBlocker" and (child.Name ~= "Reset" and child.Name ~= "Cancel"))) then
            local v270 = DragUI.new(child);
            table.insert(u258, v270);
            child.Active = true;
            child.MouseButton1Down:Connect(function() -- Line: 3017
                -- upvalues: u267 (ref), child (copy), u268 (ref), u269 (ref)
                u267 = child;
                u268 = u267.Size.X.Scale;
                u269 = u267.Size.Y.Scale;
            end);
        end;
    end;

    UserInputService.TouchPinch:Connect(function(p271, p272, p273, p274, p275) -- Line: 3025
        -- upvalues: MobileControlEdit (copy), u267 (ref), u268 (ref), u269 (ref)
        if MobileControlEdit.Visible == true then
            if p274 == Enum.UserInputState.Change and u267 then
                u267.Size = UDim2.new(math.clamp(u268 + p272 - 1, 0, 5), 0, math.clamp(u269 + p272 - 1, 0, 3), 0);

                return;
            end;

            if p274 == Enum.UserInputState.End and (u267 and u267 ~= nil) then
                u268 = u267.Size.X.Scale;
                u269 = u267.Size.Y.Scale;
            end;
        end;
    end);
end;

function u2.RefreshMobileControlsMenu(p276) -- Line: 3040
    -- upvalues: LocalPlayer (copy)
    local MobileSettings = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("MobileSettings");

    for _, child in pairs(p276:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "Save" and (child.Name ~= "ButtonBlocker" and (child.Name ~= "Reset" and child.Name ~= "Cancel"))) then
            local v277 = script.MobileControlEdit:FindFirstChild(child.Name);

            if v277 and (MobileSettings:GetAttribute(child.Name .. "XSize") and (MobileSettings:GetAttribute(child.Name .. "YSize") and (MobileSettings:GetAttribute(child.Name .. "XPosition") and MobileSettings:GetAttribute(child.Name .. "YPosition")))) then
                child.Size = UDim2.new(MobileSettings:GetAttribute(child.Name .. "XSize"), 0, MobileSettings:GetAttribute(child.Name .. "YSize"), 0);
                child.Position = UDim2.new(v277.Position.X.Scale, MobileSettings:GetAttribute(child.Name .. "XPosition"), v277.Position.Y.Scale, MobileSettings:GetAttribute(child.Name .. "YPosition"));
            end;
        end;
    end;
end;

function u2.RefreshMobileControlEdit() -- Line: 3060
    -- upvalues: LocalPlayer (copy), u7 (ref)
    local MobileSettings = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("MobileSettings");

    for _, child in pairs(u7.MobileControlEdit:GetChildren()) do
        if child:IsA("ImageButton") and (child.Name ~= "Save" and (child.Name ~= "ButtonBlocker" and (child.Name ~= "Reset" and child.Name ~= "Cancel"))) then
            local v278 = script.MobileControlEdit:FindFirstChild(child.Name);

            if v278 and (MobileSettings:GetAttribute(child.Name .. "XSize") and (MobileSettings:GetAttribute(child.Name .. "YSize") and (MobileSettings:GetAttribute(child.Name .. "XPosition") and MobileSettings:GetAttribute(child.Name .. "YPosition")))) then
                child.Size = UDim2.new(MobileSettings:GetAttribute(child.Name .. "XSize"), 0, MobileSettings:GetAttribute(child.Name .. "YSize"), 0);
                child.Position = UDim2.new(v278.Position.X.Scale, MobileSettings:GetAttribute(child.Name .. "XPosition"), v278.Position.Y.Scale, MobileSettings:GetAttribute(child.Name .. "YPosition"));
            end;
        end;
    end;
end;

function u2.RefreshSettingsPage() -- Line: 3080
    -- upvalues: u7 (ref), LocalPlayer (copy)
    local Settings = u7:WaitForChild("Pages"):WaitForChild("Settings");
    local Settings2 = LocalPlayer.PlayerData:WaitForChild("Settings");
    Settings.Scroller.ConsoleHSensitivity.Value.Text = Settings2:GetAttribute("ConsoleHSensitivity");
    Settings.Scroller.ConsoleVSensitivity.Value.Text = Settings2:GetAttribute("ConsoleVSensitivity");
    Settings.Scroller.PlayerHighlight.Value.Text = Settings2:GetAttribute("PlayerHighlight");
    Settings.Scroller.FieldOfView.Value.Text = Settings2:GetAttribute("FieldOfView");
    Settings.Scroller.MasterVolume.Value.Text = Settings2:GetAttribute("MasterVolume");
    Settings.Scroller.BackgroundMusicVolume.Value.Text = Settings2:GetAttribute("BackgroundMusicVolume");
    Settings.Scroller.BulletHoles:SetAttribute("Toggle", Settings2:GetAttribute("BulletHoles"));
    Settings.Scroller.Bleed:SetAttribute("Toggle", Settings2:GetAttribute("Bleed"));
    Settings.Scroller.ThreeDimensionEffect:SetAttribute("Toggle", Settings2:GetAttribute("ThreeDimensionEffect"));
    ToggleOnOff(Settings.Scroller.BulletHoles, Settings2:GetAttribute("BulletHoles"));
    ToggleOnOff(Settings.Scroller.Bleed, Settings2:GetAttribute("Bleed"));
    ToggleOnOff(Settings.Scroller.ThreeDimensionEffect, Settings2:GetAttribute("ThreeDimensionEffect"));
    ToggleOnOff(Settings.Scroller.MobileClawMode, Settings2:GetAttribute("MobileClawMode"));
    ToggleOnOff(Settings.Scroller.MobileAutoADS, Settings2:GetAttribute("MobileAutoADS"));
    ToggleOnOff(Settings.Scroller.MobileAutoSprint, Settings2:GetAttribute("MobileAutoSprint"));
    ToggleOnOff(Settings.Scroller.ObjectiveUI, Settings2:GetAttribute("ObjectiveUI"));
    ToggleString(Settings.Scroller.Graphics, Settings2:GetAttribute("Graphics"));
end;

function u2.ConfigProfilePage() -- Line: 3105
    -- upvalues: u7 (ref), LocalPlayer (copy), Rank (copy), Config (copy), ReplicatedStorage (copy), u2 (copy)
    local Profile = u7:WaitForChild("Pages"):WaitForChild("Profile");
    local v279 = LocalPlayer;
    local Stats = v279.PlayerData.Stats;
    local v280 = Stats:GetAttribute("RankedRating");
    local _, v281 = Rank.GetRankedImage(v280);
    local v282 = Rank.Ranks[math.clamp(v281, 1, #Rank.Ranks)];
    local v283 = Rank.Ranks[math.clamp(v281 + 1, 1, #Rank.Ranks)];
    local v284 = Rank.Ranks[math.clamp(v281 - 1, 1, #Rank.Ranks)];
    Profile.Overview.CurrentRank.Image = "rbxassetid://" .. v282.Image;
    Profile.Overview.CurrentRankName.Text = v282.Name;
    Profile.Overview.RatingBar.Bar.CurrentRankedRating.Text = Stats:GetAttribute("RankedRating");
    Profile.Overview.RatingBar.Min.Text = v282.MinRating;
    Profile.Overview.RatingBar.Max.Text = v282.MaxRating;
    Profile.Overview.RatingBar.Bar.Size = UDim2.new(v282.MinRating / v282.MaxRating, 0, 1, 0);

    if v283 == v282 then
        Profile.Overview.NextRankName.Text = "";
        Profile.Overview.NextRank.Image = "";
        Profile.Overview.CurrentRankName.Text = v282.Name .. " [MAXED]";
        Profile.Overview.RatingBar.Bar.CurrentRankedRating.Text = Stats:GetAttribute("RankedRating");
        Profile.Overview.RatingBar.Min.Text = v282.MinRating;
        Profile.Overview.RatingBar.Max.Text = "";
        Profile.Overview.RatingBar.Bar.Size = UDim2.new(1, 0, 1, 0);
    else
        Profile.Overview.NextRankName.Text = v283.Name;
        Profile.Overview.NextRank.Image = "rbxassetid://" .. v283.Image;
    end;

    if v284 == v282 then
        Profile.Overview.PreviousRank.Image = "";
        Profile.Overview.PreviousRankName.Text = "";
    else
        Profile.Overview.PreviousRank.Image = "rbxassetid://" .. v284.Image;
        Profile.Overview.PreviousRankName.Text = v284.Name;
    end;

    for _, child in pairs(v279.PlayerData.RankedMatches:GetChildren()) do
        if Profile.Matches.RankedMatches:FindFirstChild(child.Name) == nil then
            local v285 = script.SampleRankedHistory:Clone();
            v285.Parent = Profile.Matches.RankedMatches;
            v285.Name = child.Name;
            v285.BlueWins.Text = child:GetAttribute("BlueWins") or "NA";
            v285.BlueWins.TextColor3 = Config.TeamColors.Blue;
            v285.RedWins.Text = child:GetAttribute("RedWins") or "NA";
            v285.RedWins.TextColor3 = Config.TeamColors.Red;

            if child:GetAttribute("Result") == true then
                v285.Result.Text = "W";
            else
                v285.Result.Text = "L";
            end;

            v285.Result.TextColor3 = Config.TeamColors[child:GetAttribute("Team") or "Blue"] or Config.TeamColors.Blue;
            v285.TeamColor.BackgroundColor3 = Config.TeamColors[child:GetAttribute("Team") or "Blue"] or Config.TeamColors.Blue;
            v285.MapName.Text = child:GetAttribute("Map") or "NA";
            v285.Map.Image = ReplicatedStorage.MapImages[child:GetAttribute("Map")].Texture;
            local v286, _ = Rank.GetRankedImage(child:GetAttribute("RankedRating") or 0);
            v285.RankImage.Image = "rbxassetid://" .. v286;
            v285.Kills.Text = "K " .. (child:GetAttribute("Kills") or "NA");
            v285.Deaths.Text = "D " .. (child:GetAttribute("Deaths") or "NA");
            local Kdr = v285.Kdr;
            local v287 = (child:GetAttribute("Kills") or 1) / (child:GetAttribute("Deaths") or 1) * 100;
            Kdr.Text = "KDR " .. math.floor(v287) / 100;
            v285.Code.Text = "Ranked ID: " .. child:GetAttribute("Code");
            v285.Team.Text = child:GetAttribute("Team") or "NA";
            v285.BackgroundColor3 = Config.TeamColors[child:GetAttribute("Team") or "Blue"] or Config.TeamColors.Blue;
            v285.Date.Text = Config.GetDateFromOsTime(child.Name);

            if child:GetAttribute("Abandoned") == true then
                v285.Abandoned.Visible = true;
            end;

            v285.LayoutOrder = -child.Name;
        end;
    end;

    local v288 = Rank.RankedRewards["Season" .. Config.Season];

    if v288 and Config.CheckSeasonActive() == true then
        for i, v in pairs(Rank.Ranks) do
            local v289 = script.SampleRankReward:Clone();
            v289.Parent = Profile.Rewards.Scroller;
            v289.Card.RankImage.Image = "rbxassetid://" .. v.Image;
            v289.Card.RankName.Text = v.Name;

            if v288[i] then
                if Stats:GetAttribute("RankedRating") >= v.MinRating then
                    v289.Card.RewardsAmount.Text = #v288[i] .. "/" .. #v288[i];
                else
                    v289.Card.RewardsAmount.Text = "0/" .. #v288[i];
                end;

                for _, v2 in pairs(v288[i]) do
                    local v290 = script.SampleReward:Clone();
                    v290.Parent = v289.Rewards;
                    v290.Button.Title.Text = v2.Name;
                    v290.Button.SubTitle.Text = v2.Type;

                    if v2.Name == "Credit" or v2.Name == "Cash" then
                        v290.Button.SubTitle.Text = "Currency";
                        v290.Button.ImageDisplay.Image = Config.CurrencyImage[v2.Name];

                        if v2.Amount then
                            v290.Button.Title.Text = v2.Name .. " " .. v2.Amount .. "";
                        end;
                    else
                        u2.AddItemToViewport(v2, v290.Button.ItemPort);
                    end;
                end;
            else
                v289.Card.RewardsAmount.Text = "0/0";
            end;

            if Stats:GetAttribute("RankedRating") >= v.MinRating then
                v289.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v289.Cover.Visible = false;
                v289.Card.RankName.TextColor3 = Color3.fromRGB(255, 255, 255);
                v289.Card.RewardsAmount.TextColor3 = Color3.fromRGB(255, 255, 255);
            else
                v289.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            end;
        end;
    end;

    local Stats2 = LocalPlayer.PlayerData.Stats;
    local v291 = { "Level", "Kills", "Deaths", "Headshots", "Damage", "RankedRating" };

    for _, child in pairs(Profile.AllTime:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    for _, v in ipairs(v291) do
        if Stats2:GetAttribute(v) ~= nil then
            local v292 = script.SampleProfile:Clone();
            v292.Title.Text = v;
            local Amount = v292.Amount;
            local v293 = Stats2:GetAttribute(v);
            Amount.Text = math.floor(v293);
            v292.Parent = Profile.AllTime;
        end;
    end;
end;

function u2.ConfigLeaderboardPage() -- Line: 3282
    -- upvalues: u7 (ref), Config (copy), ReplicatedStorage (copy), u2 (copy), Leaderboard (copy), Rank (copy), LocalPlayer (copy), SoundService (copy)
    local Leaderboard2 = u7:WaitForChild("Pages"):WaitForChild("Leaderboard");
    local Leaderboard3 = Leaderboard2:WaitForChild("Leaderboard");
    local WeeklyLeaderboard = Leaderboard2:WaitForChild("WeeklyLeaderboard");
    local u294 = 1;
    local u295 = 1;
    local u296 = "Leaderboard";
    local u297 = "";
    local SelectedColor = Config.ColorCodes.SelectedColor;
    local SelectedTextColor = Config.ColorCodes.SelectedTextColor;
    local DeselectedColor = Config.ColorCodes.DeselectedColor;
    local DeselectedTextColor = Config.ColorCodes.DeselectedTextColor;

    local function GetOrCreateBar(p298, p299) -- Line: 3295
        local v300 = p298.Scroller:FindFirstChild((tostring(p299)));

        if v300 == nil then
            v300 = script.SampleLeaderboard:Clone();
            v300.Parent = p298.Scroller;

            if p299 == 1 then
                v300.BackgroundColor3 = Color3.fromRGB(250, 165, 0);
                v300.Size = UDim2.new(1, 0, 0.1, 0);
            elseif p299 == 2 then
                v300.BackgroundColor3 = Color3.fromRGB(193, 193, 193);
                v300.Size = UDim2.new(1, 0, 0.08, 0);
            elseif p299 == 3 then
                v300.BackgroundColor3 = Color3.fromRGB(168, 81, 47);
                v300.Size = UDim2.new(1, 0, 0.08, 0);
            elseif p299 > 3 and p299 <= 10 then
                v300.BackgroundColor3 = Color3.fromRGB(107, 129, 114);
                v300.Size = UDim2.new(1, 0, 0.06, 0);
            elseif p299 > 10 then
                v300.BackgroundColor3 = Color3.fromRGB(127, 129, 108);
                v300.Size = UDim2.new(1, 0, 0.06, 0);
            end;
        end;

        v300.Name = tostring(p299);
        v300.UserPos.Text = tostring(p299);

        return v300;
    end;

    local function FormatTimeRemaining(p301) -- Line: 3323
        if p301 >= 86400 then
            local v302 = math.ceil(p301 / 86400);

            return tostring(v302) .. " days left";
        end;

        local v303 = math.ceil(p301 / 3600);

        return tostring(v303) .. " h left";
    end;

    local function ConfigureCharmViewport(p304, p305) -- Line: 3331
        -- upvalues: ReplicatedStorage (ref), u2 (ref)
        local Charm = ReplicatedStorage.Items:FindFirstChild("Charm");

        if Charm then
            Charm = Charm:FindFirstChild(p305);
        end;

        if Charm == nil then
            for _, child in ipairs(p304:GetChildren()) do
                if child.Name ~= "Camera" then
                    child:Destroy();
                end;
            end;

            return;
        end;

        u2.AddItemToViewport({
            Type = "Charm",
            Name = p305
        }, p304);
    end;

    local function CreateCreditReward(p306, p307) -- Line: 3350
        -- upvalues: Config (ref)
        local v308 = script.SampleWeeklyReward:Clone();
        v308.Name = "Credits";
        v308.Icon.Image = Config.CurrencyImage.Credit;
        v308.IconShadow.Image = Config.CurrencyImage.Credit;
        v308.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255);
        v308.IconShadow.ImageColor3 = Color3.fromRGB(0, 0, 0);
        v308.Icon.Visible = true;
        v308.IconShadow.Visible = true;
        v308.Amount.Visible = true;
        v308.ItemPort.Visible = false;
        v308.Amount.Text = tostring(p307);
        v308.Parent = p306;

        return v308;
    end;

    local function CreateCharmReward(p309, p310) -- Line: 3366
        -- upvalues: ConfigureCharmViewport (copy)
        local v311 = script.SampleWeeklyReward:Clone();
        v311.Name = p310;
        v311.Icon.Visible = false;
        v311.IconShadow.Visible = false;
        v311.Amount.Visible = false;
        v311.ItemPort.Visible = true;
        ConfigureCharmViewport(v311.ItemPort, p310);
        v311.Parent = p309;

        return v311;
    end;

    local function RebuildWeeklyRewards() -- Line: 3378
        -- upvalues: WeeklyLeaderboard (copy), Leaderboard (ref), u297 (ref), CreateCreditReward (copy), ConfigureCharmViewport (copy)
        local v312 = {
            {
                CharmName = "Leaderboard Gold",
                Frame = WeeklyLeaderboard.Reward1,
                Reward = Leaderboard.GetRewardForPlace(1)
            },
            {
                CharmName = "Leaderboard Silver",
                Frame = WeeklyLeaderboard.Reward2,
                Reward = Leaderboard.GetRewardForPlace(2)
            },
            {
                CharmName = "Leaderboard Bronze",
                Frame = WeeklyLeaderboard.Reward3,
                Reward = Leaderboard.GetRewardForPlace(3)
            },
            {
                Frame = WeeklyLeaderboard.Reward4,
                Reward = Leaderboard.GetRewardForPlace(4)
            },
            {
                Frame = WeeklyLeaderboard.Reward5,
                Reward = Leaderboard.GetRewardForPlace(11)
            }
        };
        local v313 = {};
        local v314 = false;

        for _, v in ipairs(v312) do
            local Reward = v.Reward;
            local v315 = v.CharmName and 2 or 1;
            local v316 = 0;

            for _, child in ipairs(v.Frame:GetChildren()) do
                if child:IsA("GuiObject") then
                    v316 = v316 + 1;
                end;
            end;

            v314 = v316 ~= v315 and true or v314;
            local concat = table.concat;
            local v317 = { v.Frame.Name, tostring(Reward and Reward.CreditAmount or 0), v.CharmName or "" };
            table.insert(v313, concat(v317, ":"));
        end;

        local v318 = table.concat(v313, "|");

        if v314 ~= true and v318 == u297 then
            return;
        end;

        u297 = v318;

        for _, v in ipairs(v312) do
            for _, child in ipairs(v.Frame:GetChildren()) do
                if child:IsA("GuiObject") then
                    child:Destroy();
                end;
            end;

            local Reward = v.Reward;

            if Reward then
                CreateCreditReward(v.Frame, Reward.CreditAmount or 0);

                if v.CharmName and v.CharmName ~= "" then
                    local Frame = v.Frame;
                    local CharmName = v.CharmName;
                    local v319 = script.SampleWeeklyReward:Clone();
                    v319.Name = CharmName;
                    v319.Icon.Visible = false;
                    v319.IconShadow.Visible = false;
                    v319.Amount.Visible = false;
                    v319.ItemPort.Visible = true;
                    ConfigureCharmViewport(v319.ItemPort, CharmName);
                    v319.Parent = Frame;
                end;
            end;
        end;
    end;

    local function RefreshSelectionButtons() -- Line: 3432
        -- upvalues: Leaderboard2 (copy), u296 (ref), SelectedColor (copy), DeselectedColor (copy), SelectedTextColor (copy), DeselectedTextColor (copy)
        for _, child in pairs(Leaderboard2.Selection:GetChildren()) do
            if child:IsA("ImageButton") and child:FindFirstChild("Button") then
                local Button = child.Button;
                local v320 = child.Name == u296;
                Button.BackgroundColor3 = v320 and SelectedColor or DeselectedColor;

                if Button:FindFirstChild("Title") then
                    Button.Title.TextColor3 = v320 and SelectedTextColor or DeselectedTextColor;
                end;
            end;
        end;
    end;

    local function RefreshLeaderboardPane(p321, p322, p323, p324) -- Line: 3445
        -- upvalues: Leaderboard (ref), GetOrCreateBar (copy), Rank (ref), ReplicatedStorage (ref), LocalPlayer (ref)
        local v325 = p323:FindFirstChild(p322);

        for i = 1, Leaderboard.LeaderboardPageSize do
            local v326 = GetOrCreateBar(p321, i);
            local v327;

            if v325 then
                v327 = v325:FindFirstChild((tostring(i)));
            else
                v327 = v325;
            end;

            local v328 = v327 and (v327:GetAttribute("Score") or 0) or 0;
            local v329;

            if v327 then
                v329 = v327:GetAttribute("DisplayScore") or nil;
            else
                v329 = nil;
            end;

            v326.UserName.Text = v327 and (v327:GetAttribute("Name") or "") or "";
            v326.Scroller.Score.Text = v329 or tostring(v328);
            v326.Scroller.Rank.Visible = false;

            if p322 == "RankedRating" then
                local v330, v331 = Rank.GetRankedImage(v328);
                v326.Scroller.Rank.Image = "rbxassetid://" .. v330;
                v326.Scroller.Rank.Visible = true;
                v326.Scroller.Score.Text = string.upper(Rank.Ranks[v331].Name);
            end;
        end;

        if not p324 then
            p321.Title.Text = string.upper("Top " .. Leaderboard.GetDisplayNameForStat(p322) .. " Players");

            return;
        end;

        local v332 = ReplicatedStorage.WeeklyLeaderboard:GetAttribute("CurrentWeek") or Leaderboard.GetCurrentWeek();
        p321.Title.Text = string.upper("Week " .. tostring(v332) .. " Top " .. Leaderboard.GetDisplayNameForStat(p322) .. " Players");
        local v333 = LocalPlayer.PlayerData.WeeklyLeaderboard:FindFirstChild((tostring(v332)));
        p321.PersonalScore.Text = Leaderboard.GetDisplayScoreText(p322, v333 and v333:GetAttribute(p322) or 0);
        local TimeRemaining = p321.TimeRemaining;
        local v334 = Leaderboard.GetSecondsUntilNextReset();
        local v335;

        if v334 >= 86400 then
            local v336 = math.ceil(v334 / 86400);
            v335 = tostring(v336) .. " days left";
        else
            local v337 = math.ceil(v334 / 3600);
            v335 = tostring(v337) .. " h left";
        end;

        TimeRemaining.Text = v335;
    end;

    local function RefreshCurrentView() -- Line: 3475
        -- upvalues: RebuildWeeklyRewards (copy), RefreshLeaderboardPane (copy), Leaderboard3 (copy), Leaderboard (ref), u294 (ref), ReplicatedStorage (ref), WeeklyLeaderboard (copy), u295 (ref), u296 (ref), RefreshSelectionButtons (copy)
        RebuildWeeklyRewards();
        RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
        RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
        Leaderboard3.Visible = u296 == "Leaderboard";
        WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
        RefreshSelectionButtons();
    end;

    Leaderboard3.Next.MouseButton1Down:Connect(function() -- Line: 3484
        -- upvalues: Config (ref), SoundService (ref), u294 (ref), Leaderboard (ref), RebuildWeeklyRewards (copy), RefreshLeaderboardPane (copy), Leaderboard3 (copy), ReplicatedStorage (ref), WeeklyLeaderboard (copy), u295 (ref), u296 (ref), RefreshSelectionButtons (copy)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        u294 = u294 + 1;

        if u294 > #Leaderboard.AllTimeStats then
            u294 = 1;
        end;

        RebuildWeeklyRewards();
        RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
        RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
        Leaderboard3.Visible = u296 == "Leaderboard";
        WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
        RefreshSelectionButtons();
    end);
    Leaderboard3.Previous.MouseButton1Down:Connect(function() -- Line: 3493
        -- upvalues: Config (ref), SoundService (ref), u294 (ref), Leaderboard (ref), RebuildWeeklyRewards (copy), RefreshLeaderboardPane (copy), Leaderboard3 (copy), ReplicatedStorage (ref), WeeklyLeaderboard (copy), u295 (ref), u296 (ref), RefreshSelectionButtons (copy)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        u294 = u294 - 1;

        if u294 <= 0 then
            u294 = #Leaderboard.AllTimeStats;
        end;

        RebuildWeeklyRewards();
        RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
        RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
        Leaderboard3.Visible = u296 == "Leaderboard";
        WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
        RefreshSelectionButtons();
    end);
    WeeklyLeaderboard.Next.MouseButton1Down:Connect(function() -- Line: 3502
        -- upvalues: Config (ref), SoundService (ref), u295 (ref), Leaderboard (ref), RebuildWeeklyRewards (copy), RefreshLeaderboardPane (copy), Leaderboard3 (copy), u294 (ref), ReplicatedStorage (ref), WeeklyLeaderboard (copy), u296 (ref), RefreshSelectionButtons (copy)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        u295 = u295 + 1;

        if u295 > #Leaderboard.WeeklyStats then
            u295 = 1;
        end;

        RebuildWeeklyRewards();
        RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
        RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
        Leaderboard3.Visible = u296 == "Leaderboard";
        WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
        RefreshSelectionButtons();
    end);
    WeeklyLeaderboard.Previous.MouseButton1Down:Connect(function() -- Line: 3511
        -- upvalues: Config (ref), SoundService (ref), u295 (ref), Leaderboard (ref), RebuildWeeklyRewards (copy), RefreshLeaderboardPane (copy), Leaderboard3 (copy), u294 (ref), ReplicatedStorage (ref), WeeklyLeaderboard (copy), u296 (ref), RefreshSelectionButtons (copy)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        u295 = u295 - 1;

        if u295 <= 0 then
            u295 = #Leaderboard.WeeklyStats;
        end;

        RebuildWeeklyRewards();
        RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
        RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
        Leaderboard3.Visible = u296 == "Leaderboard";
        WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
        RefreshSelectionButtons();
    end);

    for _, child in pairs(Leaderboard2.Selection:GetChildren()) do
        if child:IsA("ImageButton") then
            child.Button.MouseButton1Down:Connect(function() -- Line: 3522
                -- upvalues: u296 (ref), child (copy), RebuildWeeklyRewards (copy), RefreshLeaderboardPane (copy), Leaderboard3 (copy), Leaderboard (ref), u294 (ref), ReplicatedStorage (ref), WeeklyLeaderboard (copy), u295 (ref), RefreshSelectionButtons (copy)
                u296 = child.Name;
                RebuildWeeklyRewards();
                RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
                RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
                Leaderboard3.Visible = u296 == "Leaderboard";
                WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
                RefreshSelectionButtons();
            end);
        end;
    end;

    RebuildWeeklyRewards();
    RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
    RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
    Leaderboard3.Visible = u296 == "Leaderboard";
    WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
    RefreshSelectionButtons();
    Leaderboard2:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3530
        -- upvalues: Leaderboard2 (copy), RebuildWeeklyRewards (copy), RefreshLeaderboardPane (copy), Leaderboard3 (copy), Leaderboard (ref), u294 (ref), ReplicatedStorage (ref), WeeklyLeaderboard (copy), u295 (ref), u296 (ref), RefreshSelectionButtons (copy)
        if Leaderboard2.Visible == true then
            RebuildWeeklyRewards();
            RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
            RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
            Leaderboard3.Visible = u296 == "Leaderboard";
            WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
            RefreshSelectionButtons();
        end;
    end);
    task.spawn(function() -- Line: 3536
        -- upvalues: Leaderboard2 (copy), RebuildWeeklyRewards (copy), RefreshLeaderboardPane (copy), Leaderboard3 (copy), Leaderboard (ref), u294 (ref), ReplicatedStorage (ref), WeeklyLeaderboard (copy), u295 (ref), u296 (ref), RefreshSelectionButtons (copy)
        while task.wait(2) do
            if Leaderboard2.Visible == true then
                RebuildWeeklyRewards();
                RefreshLeaderboardPane(Leaderboard3, Leaderboard.AllTimeStats[u294], ReplicatedStorage.Leaderboard, false);
                RefreshLeaderboardPane(WeeklyLeaderboard, Leaderboard.WeeklyStats[u295], ReplicatedStorage.WeeklyLeaderboard, true);
                Leaderboard3.Visible = u296 == "Leaderboard";
                WeeklyLeaderboard.Visible = u296 == "WeeklyLeaderboard";
                RefreshSelectionButtons();
            end;
        end;
    end);
end;

function u2.ConfigCratePage() -- Line: 3545
    -- upvalues: u7 (ref), Config (copy), LocalPlayer (copy), ReplicatedStorage (copy), u2 (copy), Crates (copy), SoundService (copy), Debris (copy), RunService (copy)
    local Crate = u7:WaitForChild("Pages"):WaitForChild("Crate");
    local GroupService = game:GetService("GroupService");
    Crate.Detail.Group.Activated:Connect(function() -- Line: 3549
        -- upvalues: Config (ref), LocalPlayer (ref), GroupService (copy), ReplicatedStorage (ref)
        Config.AddSound("Click_3", 1, true, game.SoundService, false);

        if LocalPlayer:IsInGroup(33054943) then
            ReplicatedStorage.Events.ClaimGroup:FireServer();

            return;
        end;

        GroupService:PromptJoinAsync(33054943);
    end);
    task.spawn(function() -- Line: 3557
        -- upvalues: LocalPlayer (ref), Config (ref), Crate (copy)
        while task.wait(1) do
            if LocalPlayer.PlayerData.Stats:GetAttribute("GroupRedeemDay") < Config.GetCurrentDay() then
                Crate.Detail.Group.Timer.Text = "CLAIM";
                Crate.Detail.Group.Timer.TextTransparency = 0;
            else
                local v338 = Config.toHMS(Config.GetTimeUntilTomorrow());
                Crate.Detail.Group.Timer.Text = "NEXT CLAIM " .. v338;
                Crate.Detail.Group.Timer.TextTransparency = 0.5;
            end;
        end;
    end);
    local RewardedAds = require(ReplicatedStorage:WaitForChild("Components"):WaitForChild("RewardedAds"));
    local u339 = false;
    Crate.Detail.Advertisement.Activated:Connect(function() -- Line: 3574
        -- upvalues: Config (ref), u339 (ref), u2 (ref), LocalPlayer (ref), ReplicatedStorage (ref), RewardedAds (copy)
        Config.AddSound("Click_3", 1, true, game.SoundService, false);

        if u339 == true then
            u2.AddNotification("Advertisement button cooldown", Color3.fromRGB(255, 100, 100));

            return;
        end;

        u339 = true;
        task.delay(5, function() -- Line: 3581
            -- upvalues: u339 (ref)
            u339 = false;
        end);

        if LocalPlayer.PlayerData.Stats:GetAttribute("DailyAdvertisementWatch") >= 3 then
            ReplicatedStorage.Events.Action:FireServer("DailyAdvertisementClaim");

            return;
        end;

        RewardedAds.CheckForAds();
    end);

    local function RefreshAdvertisementButton() -- Line: 3593
        -- upvalues: LocalPlayer (ref), Config (ref), Crate (copy)
        local v340 = LocalPlayer.PlayerData.Stats:GetAttribute("DailyAdvertisementWatch");

        if LocalPlayer.PlayerData.Stats:GetAttribute("DailyAdvertisementClaim") >= Config.DailyAdvertisementClaimMax then
            Crate.Detail.Advertisement.Progress.Bar.Size = UDim2.new(1, 0, 1, 0);
            Crate.Detail.Advertisement.Amount.Text = "COMPLETED";

            return;
        end;

        Crate.Detail.Advertisement.Progress.Bar.Size = UDim2.new(v340 / 3, 0, 1, 0);

        if v340 >= 3 then
            Crate.Detail.Advertisement.Amount.Text = "[CLAIM] " .. v340 .. "/" .. 3;

            return;
        end;

        Crate.Detail.Advertisement.Amount.Text = v340 .. "/" .. 3;
    end;

    RefreshAdvertisementButton();
    LocalPlayer.PlayerData.Stats:GetAttributeChangedSignal("DailyAdvertisementWatch"):Connect(RefreshAdvertisementButton);
    LocalPlayer.PlayerData.Stats:GetAttributeChangedSignal("DailyAdvertisementClaim"):Connect(RefreshAdvertisementButton);
    local Crates2 = LocalPlayer.PlayerData.Crates;
    local Content = Crate:WaitForChild("Content");
    local SampleCrateContent = ReplicatedStorage.Components.Menu:WaitForChild("SampleCrateContent");
    local Rarity = Crate:FindFirstChild("Rarity");
    local Arrow = Crate:FindFirstChild("Arrow");
    local BackgroundLayer = Crate:FindFirstChild("BackgroundLayer");

    if BackgroundLayer then
        BackgroundLayer = BackgroundLayer:FindFirstChild("Rarity");
    end;

    local u341 = Content:FindFirstChildOfClass("UIGridLayout");
    local u342 = Crates.GetSettings();
    local u343 = {};
    local u344 = 1;
    local u345 = false;
    local u346 = nil;
    local Position = Crate.ItemPort.Position;
    local Size = Crate.ItemPort.Size;
    local Position2 = Content.Position;
    local u347;

    if Rarity then
        u347 = Rarity.Position or nil;
    else
        u347 = nil;
    end;

    local u348;

    if Rarity then
        u348 = Rarity.Size or nil;
    else
        u348 = nil;
    end;

    local u349 = Arrow and Arrow.ImageTransparency or 1;
    local ScrollBarImageTransparency = Content.ScrollBarImageTransparency;
    local ScrollingEnabled = Content.ScrollingEnabled;
    local Active = Content.Active;
    local u350 = nil;

    local function EaseOutQuint(p351) -- Line: 3640
        return 1 - math.pow(1 - p351, 5);
    end;

    local function GetRarityImageTransparency(p352) -- Line: 3644
        return p352 == "Divine" and 0.3 or (p352 == "Legendary" and 0.4 or (p352 == "Epic" and 0.5 or 0.6));
    end;

    local function GetRarityRank(p353) -- Line: 3656
        return p353 == "Common" and 1 or (p353 == "Uncommon" and 2 or (p353 == "Rare" and 3 or (p353 == "Epic" and 4 or (p353 == "Legendary" and 5 or (p353 == "Divine" and 6 or (p353 == "Limited" and 7 or 999))))));
    end;

    local function GetCrateModel(p354) -- Line: 3676
        -- upvalues: ReplicatedStorage (ref)
        local Crate2 = ReplicatedStorage.Items:FindFirstChild("Crate");

        if Crate2 then
            Crate2 = Crate2:FindFirstChild(p354);
        end;

        return Crate2;
    end;

    local function GetCrateLayoutOrder(p355) -- Line: 3681
        -- upvalues: ReplicatedStorage (ref)
        local Crate2 = ReplicatedStorage.Items:FindFirstChild("Crate");

        if Crate2 then
            Crate2 = Crate2:FindFirstChild(p355);
        end;

        return Crate2 and Crate2:GetAttribute("LayoutOrder") or (1 / 0);
    end;

    local function GetScaledSize(p356, p357) -- Line: 3686
        return UDim2.new(p356.X.Scale * p357, math.round(p356.X.Offset * p357), p356.Y.Scale * p357, (math.round(p356.Y.Offset * p357)));
    end;

    local function ShuffleContents(p358) -- Line: 3690
        for i = #p358, 2, -1 do
            local v359 = math.random(1, i);
            local v360 = p358[i];
            p358[i] = p358[v359];
            p358[v359] = v360;
        end;
    end;

    local function SetContentInteractionEnabled(p361) -- Line: 3697
        -- upvalues: Content (copy), ScrollingEnabled (copy), Active (copy), ScrollBarImageTransparency (copy)
        Content.ScrollingEnabled = p361 and ScrollingEnabled or false;
        Content.Active = p361 and Active or false;
        Content.ScrollBarImageTransparency = p361 and ScrollBarImageTransparency or 1;
    end;

    local function PlayRarityRewardSound(p362) -- Line: 3703
        -- upvalues: Config (ref), SoundService (ref), Debris (ref)
        if p362 then
            p362 = Config.Rarity[p362];
        end;

        if p362 then
            p362 = p362.Sound;
        end;

        if not (p362 and p362:IsA("Sound")) then
            return;
        end;

        local v363 = p362:Clone();
        v363.Parent = SoundService;
        v363:Play();
        Debris:AddItem(v363, (v363.TimeLength > 0 and v363.TimeLength or 1) + 1);
    end;

    local function ShakeItemPort(p364, p365) -- Line: 3716
        -- upvalues: u342 (copy), u345 (ref), Config (ref), SoundService (ref), Crate (copy)
        if p365 <= 0 then
            return;
        end;

        local v366 = u342.ShakeInterval or 0.12;
        local v367 = math.round((u342.ShakeAngle or 6) * 1.5);
        local v368 = math.max(8, v367);
        local v369 = os.clock() + p365;
        local v370 = 1;

        while u345 and os.clock() < v369 do
            Config.AddSound("Crate_Shake1", 1, true, SoundService, false);
            local v371 = UDim2.new(p364.X.Scale, p364.X.Offset + v368 * v370, p364.Y.Scale, p364.Y.Offset + math.round(v368 * 0.35));
            Config.TweenCreate(Crate.ItemPort, {
                Position = v371
            }, v366 * 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
            task.wait(v366 * 0.5);

            if not u345 then
                break;
            end;

            Config.TweenCreate(Crate.ItemPort, {
                Position = UDim2.new(p364.X.Scale, p364.X.Offset - math.round(v368 * 0.55 * v370), p364.Y.Scale, p364.Y.Offset - math.round(v368 * 0.2))
            }, v366 * 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
            task.wait(v366 * 0.5);
            v370 = v370 * -1;
        end;

        Crate.ItemPort.Position = p364;
    end;

    local function ClearCrateContent() -- Line: 3741
        -- upvalues: Content (copy)
        for _, child in ipairs(Content:GetChildren()) do
            if not child:IsA("UIGridLayout") then
                child:Destroy();
            end;
        end;
    end;

    local function BuildCrateContentDisplay(p372, p373, p374) -- Line: 3749
        -- upvalues: SampleCrateContent (copy), Config (ref), u2 (ref)
        local v375 = SampleCrateContent:Clone();
        v375.Name = string.format("%s%03d_%s_%s", p374 or "", p373, p372.Type, p372.Name);
        v375.LayoutOrder = p373;
        v375.Visible = true;
        v375.ImageDisplay.Image = "";
        v375.TextDisplay.Text = "";
        v375.Chance.Text = p372.ChanceText or "";
        local v376 = Config.Rarity[p372.Rarity];
        local Rarity2 = p372.Rarity;
        local v377 = Rarity2 == "Divine" and 0.3 or (Rarity2 == "Legendary" and 0.4 or (Rarity2 == "Epic" and 0.5 or 0.6));

        if v376 then
            v375.Rarity.ImageColor3 = v376.Color;
            v375.Rarity.ImageTransparency = v377;
            local v378 = v375:FindFirstChildOfClass("UIStroke");

            if v378 then
                v378.Color = v376.Color;
                v378.Transparency = v377;
            end;
        end;

        u2.AddItemToViewport(p372, v375.ItemPort, true);

        return v375;
    end;

    local function ApplyCrateRarityColor(p379) -- Line: 3774
        -- upvalues: ReplicatedStorage (ref), Config (ref), Rarity (copy), BackgroundLayer (copy), Crate (copy)
        local Crate2 = ReplicatedStorage.Items:FindFirstChild("Crate");

        if Crate2 then
            Crate2 = Crate2:FindFirstChild(p379);
        end;

        if Crate2 then
            Crate2 = Crate2:GetAttribute("Rarity");
        end;

        local v380;

        if Crate2 then
            v380 = Config.Rarity[Crate2];
        else
            v380 = Crate2;
        end;

        if not v380 then
            return;
        end;

        if Rarity then
            Rarity.ImageColor3 = v380.Color;
        end;

        if BackgroundLayer then
            BackgroundLayer.ImageColor3 = v380.Color;
        end;

        if Crate.Detail:FindFirstChild("Type") then
            Crate.Detail.Type.Text = string.upper(Crate2);
            Crate.Detail.Type.TextColor3 = v380.Color;
        end;
    end;

    local function SetCratePreview(p381, p382) -- Line: 3794
        -- upvalues: Crate (copy), u346 (ref), ReplicatedStorage (ref), u2 (ref), Config (ref)
        Crate.ItemPort.WorldModel:ClearAllChildren();
        u346 = nil;
        local Crate2 = ReplicatedStorage.Items:FindFirstChild("Crate");

        if Crate2 then
            Crate2 = Crate2:FindFirstChild(p381);
        end;

        if Crate2 then
            local v383 = Crate2:Clone();
            v383.Parent = Crate.ItemPort.WorldModel;
            v383:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(p382), 0));
            u346 = v383;
        end;

        u2.SetNewViewPort(Crate.ItemPort, Vector3.new(0, 0, 0), Vector3.new(0, 4.5, -8));
        Crate.ItemPort.ImageTransparency = 1;
        Config.TweenCreate(Crate.ItemPort, {
            ImageTransparency = 0
        }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);

        return u346;
    end;

    local function TweenCrateYaw(p384, p385, p386, p387) -- Line: 3812
        -- upvalues: RunService (ref)
        if not p384 then
            return;
        end;

        local v388 = os.clock();

        while p384.Parent and os.clock() - v388 < p387 do
            local v389 = (os.clock() - v388) / p387;
            local v390 = 1 - math.clamp(v389, 0, 1);
            local v391 = 1 - math.pow(v390, 5);
            p384:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(p385 + (p386 - p385) * v391), 0));
            RunService.RenderStepped:Wait();
        end;

        if p384.Parent then
            p384:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(p386), 0));
        end;
    end;

    local function LoadCurrentCrateOpenAnimation() -- Line: 3831
        -- upvalues: u346 (ref)
        if not u346 then
            return nil;
        end;

        local v392 = u346:FindFirstChildOfClass("Humanoid");
        local v393;

        if v392 then
            v393 = v392:FindFirstChildOfClass("Animator");
        else
            v393 = v392;
        end;

        if v392 then
            v392 = v392:FindFirstChild("Open");
        end;

        if v393 and (v392 and v392:IsA("Animation")) then
            return v393:LoadAnimation(v392);
        end;

        return nil;
    end;

    local function RefreshCrateTable(p394) -- Line: 3846
        -- upvalues: u343 (ref), Crates2 (copy), Crates (ref), ReplicatedStorage (ref), u344 (ref)
        u343 = {};

        for i, v in pairs(Crates2:GetAttributes()) do
            if (v or 0) > 0 and Crates.GetCrate(i) then
                u343[#u343 + 1] = i;
            end;
        end;

        table.sort(u343, function(p395, p396) -- Line: 3854
            -- upvalues: ReplicatedStorage (ref)
            local Crate2 = ReplicatedStorage.Items:FindFirstChild("Crate");

            if Crate2 then
                Crate2 = Crate2:FindFirstChild(p395);
            end;

            local v397 = Crate2 and Crate2:GetAttribute("LayoutOrder") or (1 / 0);
            local Crate3 = ReplicatedStorage.Items:FindFirstChild("Crate");

            if Crate3 then
                Crate3 = Crate3:FindFirstChild(p396);
            end;

            local v398 = Crate3 and Crate3:GetAttribute("LayoutOrder") or (1 / 0);

            if v397 == v398 then
                return p395 < p396;
            end;

            return v397 < v398;
        end);

        if #u343 <= 0 then
            u344 = 0;

            return nil;
        end;

        if p394 then
            for i, v in ipairs(u343) do
                if v == p394 then
                    u344 = i;
                    break;
                end;
            end;
        end;

        if u344 < 1 then
            u344 = 1;
        elseif u344 > #u343 then
            u344 = #u343;
        end;

        return u343[u344];
    end;

    local function ChangeCrate(p399) -- Line: 3886
        -- upvalues: u343 (ref), Config (ref), u344 (ref)
        if #u343 <= 0 then
            return;
        end;

        Config.AddSound("Click_1", 1, true, game.SoundService, false);
        u344 = u344 + p399;

        if u344 > #u343 then
            u344 = 1;

            return;
        end;

        if u344 < 1 then
            u344 = #u343;
        end;
    end;

    local function RefreshCrateContent(p400, p401, p402) -- Line: 3900
        -- upvalues: ClearCrateContent (copy), Crates (ref), BuildCrateContentDisplay (copy), Content (copy)
        ClearCrateContent();

        if not p400 then
            return;
        end;

        local v403 = {};

        for _, v in ipairs(p401 or Crates.GetEntriesWithChance(p400)) do
            v403[#v403 + 1] = table.clone(v);
        end;

        if p402 ~= false then
            table.sort(v403, function(p404, p405) -- Line: 3913
                local Rarity2 = p404.Rarity;
                local v406 = Rarity2 == "Common" and 1 or (Rarity2 == "Uncommon" and 2 or (Rarity2 == "Rare" and 3 or (Rarity2 == "Epic" and 4 or (Rarity2 == "Legendary" and 5 or (Rarity2 == "Divine" and 6 or (Rarity2 == "Limited" and 7 or 999))))));
                local Rarity3 = p405.Rarity;
                local v407 = Rarity3 == "Common" and 1 or (Rarity3 == "Uncommon" and 2 or (Rarity3 == "Rare" and 3 or (Rarity3 == "Epic" and 4 or (Rarity3 == "Legendary" and 5 or (Rarity3 == "Divine" and 6 or (Rarity3 == "Limited" and 7 or 999))))));

                if v406 ~= v407 then
                    return v406 < v407;
                end;

                if (p404.Chance or 0) ~= (p405.Chance or 0) then
                    return (p404.Chance or 0) > (p405.Chance or 0);
                end;

                if p404.Type == p405.Type then
                    return p404.Name < p405.Name;
                end;

                return p404.Type < p405.Type;
            end);
        end;

        for i, v in ipairs(v403) do
            BuildCrateContentDisplay(v, i, p402 == false and "Reel_" or "").Parent = Content;
        end;

        Content.CanvasPosition = Vector2.new(0, 0);
    end;

    local function ResolveCratePageState() -- Line: 3939
        -- upvalues: u7 (ref)
        local v408 = u7 and u7:FindFirstChild("Pages");

        if v408 then
            v408 = v408:FindFirstChild("Crate");
        end;

        if not v408 then
            return nil;
        end;

        local Detail = v408:FindFirstChild("Detail");
        local Duplicate = v408:FindFirstChild("Duplicate");
        local ItemPort = v408:FindFirstChild("ItemPort");
        local Content2 = v408:FindFirstChild("Content");

        return Detail and (Duplicate and (ItemPort and Content2)) and {
            Frame = v408,
            Detail = Detail,
            DuplicateFrame = Duplicate,
            ItemPort = ItemPort,
            ContentFrame = Content2,
            PageRarity = v408:FindFirstChild("Rarity"),
            Arrow = v408:FindFirstChild("Arrow")
        } or nil;
    end;

    local function ResetCratePage() -- Line: 3963
        -- upvalues: ResolveCratePageState (copy), u345 (ref), u2 (ref), Position (copy), Size (copy), Position2 (copy), SetContentInteractionEnabled (copy), u347 (copy), u348 (copy), u349 (copy), u350 (ref)
        local v409 = ResolveCratePageState();
        u345 = false;
        u2.OpenPageEnabled = true;
        u2.CurrentCrateFailureHandler = nil;

        if not v409 then
            return;
        end;

        v409.Detail.Visible = true;
        v409.DuplicateFrame.Visible = false;
        pcall(ClearDuplicateSelectionState);
        v409.ItemPort.Position = Position;
        v409.ItemPort.Size = Size;
        v409.ContentFrame.Position = Position2;
        v409.ContentFrame.CanvasPosition = Vector2.new(0, 0);
        pcall(SetContentInteractionEnabled, true);

        if v409.PageRarity and (u347 and u348) then
            v409.PageRarity.Position = u347;
            v409.PageRarity.Size = u348;
        end;

        if v409.Arrow then
            v409.Arrow.Visible = false;
            v409.Arrow.ImageTransparency = u349;
        end;

        pcall(u350, true);
    end;

    local function PlayCrateRollAnimation(p410) -- Line: 3990
        -- upvalues: ResetCratePage (copy), u2 (ref), RefreshCrateTable (copy), ApplyCrateRarityColor (copy), SetCratePreview (copy), u342 (copy), PlayRarityRewardSound (copy), Crates (ref), ResolveCratePageState (copy), SetContentInteractionEnabled (copy), Position (copy), Position2 (copy), u347 (copy), Config (ref), Size (copy), u348 (copy), ShuffleContents (copy), RefreshCrateContent (copy), RunService (ref), u341 (copy), LoadCurrentCrateOpenAnimation (copy), u346 (ref), ShakeItemPort (copy), u345 (ref), SoundService (ref)
        if not (p410 and (p410.CrateName and p410.ItemData)) then
            ResetCratePage();
            u2.StartItemNotification(p410 and p410.ItemLogId or nil);

            return;
        end;

        local CrateName = p410.CrateName;
        RefreshCrateTable(CrateName);
        ApplyCrateRarityColor(CrateName);
        SetCratePreview(CrateName, u342.PreviewYaw or -20);
        local v411 = table.clone(p410.ItemData);
        v411.Rarity = v411.Rarity or "Common";

        if not u342.AnimationsEnabled then
            PlayRarityRewardSound(v411.Rarity);
            ResetCratePage();
            u2.StartItemNotification(p410.ItemLogId);

            return;
        end;

        local v412 = Crates.GetEntriesWithChance(CrateName);

        if #v412 <= 0 then
            ResetCratePage();
            u2.StartItemNotification(p410.ItemLogId);

            return;
        end;

        local v413 = nil;

        for _, v in ipairs(v412) do
            if v.Name == v411.Name and v.Type == v411.Type then
                v413 = table.clone(v);
                break;
            end;
        end;

        if v413 then
            for i, v in pairs(v411) do
                v413[i] = v;
            end;
        else
            v413 = v411;
        end;

        local v414 = ResolveCratePageState();

        if not v414 then
            ResetCratePage();
            u2.StartItemNotification(p410.ItemLogId);

            return;
        end;

        local ItemPort = v414.ItemPort;
        local ContentFrame = v414.ContentFrame;
        local PageRarity = v414.PageRarity;
        local Arrow2 = v414.Arrow;
        u2.OpenPageEnabled = false;
        v414.Detail.Visible = false;
        pcall(SetContentInteractionEnabled, false);
        local u415 = UDim2.new(Position.X.Scale, Position.X.Offset, 0.4, Position.Y.Offset);
        local v416 = UDim2.new(Position2.X.Scale, Position2.X.Offset, 0.75, Position2.Y.Offset);
        local v417 = PageRarity and (u347 and UDim2.new(u347.X.Scale, u347.X.Offset, 0.4, u347.Y.Offset)) or nil;
        local TweenCreate = Config.TweenCreate;
        local v418 = {
            Position = u415
        };
        local v419 = Size;
        local v420 = u342.ExpandedScale or 1.8;
        v418.Size = UDim2.new(v419.X.Scale * v420, math.round(v419.X.Offset * v420), v419.Y.Scale * v420, (math.round(v419.Y.Offset * v420)));
        TweenCreate(ItemPort, v418, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        Config.TweenCreate(ContentFrame, {
            Position = v416
        }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);

        if PageRarity and (u347 and (u348 and v417)) then
            local TweenCreate2 = Config.TweenCreate;
            local v421 = {
                Position = v417
            };
            local v422 = u348;
            local v423 = u342.ExpandedScale or 1.8;
            v421.Size = UDim2.new(v422.X.Scale * v423, math.round(v422.X.Offset * v423), v422.Y.Scale * v423, (math.round(v422.Y.Offset * v423)));
            TweenCreate2(PageRarity, v421, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        end;

        if Arrow2 then
            Arrow2.Visible = true;
            Arrow2.ImageTransparency = 1;
            Config.TweenCreate(Arrow2, {
                ImageTransparency = 0
            }, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        end;

        u2.SetNewViewPort(ItemPort, Vector3.new(0, 0, 0), (Vector3.new(0, u342.PreviewCameraY or 5.5, -8)));
        local v424 = {};

        for i = 1, 48 do
            v424[i] = table.clone(v412[math.random(1, #v412)]);
        end;

        ShuffleContents(v424);
        v424[30] = v413;
        RefreshCrateContent(CrateName, v424, false);
        RunService.RenderStepped:Wait();
        RunService.RenderStepped:Wait();
        local u425 = {};

        for _, child in ipairs(ContentFrame:GetChildren()) do
            if child:IsA("GuiObject") and not child:IsA("UIGridLayout") then
                u425[#u425 + 1] = child;
            end;
        end;

        table.sort(u425, function(p426, p427) -- Line: 4082
            return p426.LayoutOrder < p427.LayoutOrder;
        end);

        for _, v in ipairs(u425) do
            local v428 = v:FindFirstChildOfClass("UIStroke");

            if v428 then
                v428.Enabled = false;
            end;
        end;

        local v429 = u425[30];

        if not (v429 and u341) then
            ResetCratePage();
            u2.StartItemNotification(p410.ItemLogId);

            return;
        end;

        local u430 = LoadCurrentCrateOpenAnimation();
        local u431 = u342.OpenAnimationSpeed or 2;
        local u432;

        if u430 then
            u430:Play(0);
            u430:AdjustSpeed(0);

            for _ = 1, 20 do
                if u430.Length > 0 then
                    break;
                end;

                RunService.RenderStepped:Wait();
            end;

            u430.TimePosition = 0;
            u432 = u430.Length > 0 and (u430.Length / u431 or 0) or 0;
        else
            u432 = 0;
        end;

        local v433 = u342.AnimationDuration or 5;
        local u434 = math.min(1, v433);

        if u346 then
            u346:PivotTo(CFrame.new(0, 0, 0));
        end;

        task.spawn(function() -- Line: 4121
            -- upvalues: ShakeItemPort (ref), u415 (copy), u434 (copy)
            ShakeItemPort(u415, u434);
        end);
        local u435 = { "Crate_Open1", "Crate_Open2", "Crate_Open3" };
        task.delay(u434, function() -- Line: 4126
            -- upvalues: u345 (ref), ItemPort (copy), u415 (copy), u346 (ref), Config (ref), u435 (copy), SoundService (ref), u430 (copy), u431 (copy), u432 (ref)
            if u345 and ItemPort.Parent then
                ItemPort.Position = u415;
            end;

            if not u346 then
                return;
            end;

            Config.AddSound(u435[math.random(1, #u435)], 1, true, SoundService, false);

            if u430 then
                u430.TimePosition = 0;
                u430:AdjustSpeed(u431);
                task.delay(math.max(0, u432 * 0.85), function() -- Line: 4137
                    -- upvalues: u430 (ref)
                    if u430.Parent then
                        u430.TimePosition = u430.Length * 0.85;
                        u430:AdjustSpeed(0);
                    end;
                end);
            end;
        end);
        local v436 = math.max(0, u341.AbsoluteContentSize.X - ContentFrame.AbsoluteSize.X);
        local v437 = math.clamp(v429.AbsolutePosition.X - ContentFrame.AbsolutePosition.X - (ContentFrame.AbsoluteSize.X - v429.AbsoluteSize.X) / 2, 0, v436);
        local v438 = os.clock();

        local function GetCenteredDisplayIndex() -- Line: 4150
            -- upvalues: ContentFrame (copy), u425 (copy)
            local v439 = ContentFrame.AbsolutePosition.X + ContentFrame.AbsoluteSize.X / 2;
            local v440 = (1 / 0);
            local v441 = nil;

            for i, v in ipairs(u425) do
                if v.Parent == ContentFrame then
                    local v442 = math.abs(v.AbsolutePosition.X + v.AbsoluteSize.X / 2 - v439);

                    if v442 < v440 then
                        v441 = i;
                        v440 = v442;
                    end;
                end;
            end;

            return v441;
        end;

        local v443 = nil;

        while os.clock() - v438 < v433 do
            local v444 = (os.clock() - v438) / v433;
            local v445 = 1 - math.clamp(v444, 0, 1);
            local v446 = 1 - math.pow(v445, 5);
            ContentFrame.CanvasPosition = Vector2.new(v437 * v446, 0);
            local v447 = GetCenteredDisplayIndex();

            if v447 and v447 ~= v443 then
                local v448 = v443 and u425[v443] and u425[v443]:FindFirstChildOfClass("UIStroke");

                if v448 then
                    v448.Enabled = false;
                end;

                local v449 = u425[v447]:FindFirstChildOfClass("UIStroke");

                if v449 then
                    v449.Enabled = true;
                end;

                Config.AddSound("Click_2", 1, true, SoundService, false);
            else
                v447 = v443;
            end;

            RunService.RenderStepped:Wait();
            v443 = v447;
        end;

        ContentFrame.CanvasPosition = Vector2.new(v437, 0);
        local v450 = v443 and u425[v443] and u425[v443]:FindFirstChildOfClass("UIStroke");

        if v450 then
            v450.Enabled = true;
        end;

        Config.AddSound("Crate_Unlock", 1, true, SoundService, false);
        task.wait(u342.RewardHoldDuration or 0.5);

        for _, v in ipairs(u425) do
            local v451 = v:FindFirstChildOfClass("UIStroke");

            if v451 then
                v451.Enabled = false;
            end;
        end;

        PlayRarityRewardSound(v413.Rarity or v411.Rarity);
        ResetCratePage();
        u2.StartItemNotification(p410.ItemLogId);
    end;

    local Stats = LocalPlayer.PlayerData:WaitForChild("Stats");
    local Duplicate = Crate:WaitForChild("Duplicate");
    local Scroller2 = Duplicate:WaitForChild("Scroller");
    local Amount = Duplicate:WaitForChild("Amount");
    local Sell = Duplicate:WaitForChild("Sell");
    local Back = Duplicate:WaitForChild("Back");
    local Clear = Duplicate:WaitForChild("Clear");
    local Currency = Duplicate:WaitForChild("Currency");
    local CurrencyImage = Duplicate:WaitForChild("CurrencyImage");
    local Shop = Crate:WaitForChild("Shop");
    local Scroller3 = Shop:WaitForChild("Scroller");
    local Amount2 = Shop:WaitForChild("Amount");
    local Buy = Shop:WaitForChild("Buy");
    local Back2 = Shop:WaitForChild("Back");
    local Clear2 = Shop:WaitForChild("Clear");
    local Currency2 = Shop:WaitForChild("Currency");
    local CurrencyImage2 = Shop:WaitForChild("CurrencyImage");
    local SampleItem = script.SampleItem;
    local u452 = {};
    local u453 = {};
    local u454 = {};
    local u455 = {};
    local u456 = {};
    local u457 = {};
    local u458 = {};

    local function DisconnectDuplicateConnections() -- Line: 4240
        -- upvalues: u454 (copy)
        for _, v in ipairs(u454) do
            v:Disconnect();
        end;

        table.clear(u454);
    end;

    local function DisconnectShopConnections() -- Line: 4247
        -- upvalues: u458 (copy)
        for _, v in ipairs(u458) do
            v:Disconnect();
        end;

        table.clear(u458);
    end;

    local function FormatCrateTokenText(p459) -- Line: 4254
        return tostring(p459) .. " " .. (p459 == 1 and "Crate Token" or "Crate Tokens");
    end;

    local function FormatShopCostText(p460) -- Line: 4258
        return "Cost: " .. tostring(p460) .. " " .. (p460 == 1 and "Crate Token" or "Crate Tokens");
    end;

    local function UpdateCrateTokenDisplays() -- Line: 4262
        -- upvalues: Stats (copy), CurrencyImage (copy), Config (ref), Currency (copy), CurrencyImage2 (copy), Currency2 (copy)
        local v461 = tonumber(Stats:GetAttribute("CrateToken")) or 0;
        CurrencyImage.Image = Config.CurrencyImage.CrateToken;
        Currency.Text = tostring(v461);
        CurrencyImage2.Image = Config.CurrencyImage.CrateToken;
        Currency2.Text = tostring(v461);
    end;

    local function SetDuplicateSelectionVisual(p462, p463) -- Line: 4270
        local v464;

        if p462 then
            v464 = p462.Card;
        else
            v464 = p462;
        end;

        if not v464 then
            return;
        end;

        v464.Level.Text = p463 > 0 and ("x" .. tostring(p463) or "") or "";
        v464.DisplaySelect.Visible = p463 > 0;
        local v465 = v464.DisplaySelect:FindFirstChildOfClass("UIStroke");

        if v465 then
            v465.Color = Color3.fromRGB(255, 255, 255);
        end;

        v464.Quantity.Visible = true;
        v464.Quantity.Amount.Text = tostring(p462.ConvertibleQuantity);
    end;

    local function UpdateDuplicateTotalLabel() -- Line: 4286
        -- upvalues: u452 (copy), u453 (copy), Amount (copy), Stats (copy), CurrencyImage (copy), Config (ref), Currency (copy), CurrencyImage2 (copy), Currency2 (copy)
        local v466 = 0;

        for i, v in pairs(u452) do
            local v467 = u453[i];

            if v467 and v > 0 then
                v466 = v466 + v * v467.TokenValue;
            end;
        end;

        Amount.Text = tostring(v466) .. " " .. (v466 == 1 and "Crate Token" or "Crate Tokens");
        local v468 = tonumber(Stats:GetAttribute("CrateToken")) or 0;
        CurrencyImage.Image = Config.CurrencyImage.CrateToken;
        Currency.Text = tostring(v468);
        CurrencyImage2.Image = Config.CurrencyImage.CrateToken;
        Currency2.Text = tostring(v468);

        return v466;
    end;

    local function ClearDuplicateScroller() -- Line: 4307
        -- upvalues: u454 (copy), Scroller2 (copy), u453 (copy)
        for _, v in ipairs(u454) do
            v:Disconnect();
        end;

        table.clear(u454);

        for _, child in ipairs(Scroller2:GetChildren()) do
            if child:IsA("GuiObject") and not child:IsA("UIGridLayout") then
                child:Destroy();
            end;
        end;

        table.clear(u453);
    end;

    local function BuildDuplicateEntryDatas() -- Line: 4317
        -- upvalues: LocalPlayer (ref), Config (ref), Crates (ref)
        local v469 = {};

        for _, child in ipairs(LocalPlayer.PlayerData.Inventory:GetChildren()) do
            local v470 = Config.GetItemDataFromPlayerInventoryItem(child);

            if v470 and Crates.IsItemObtainable(v470) == true then
                local v471 = Crates.GetItemRarity(v470);
                local v472;

                if v471 then
                    v472 = Config.Rarity[v471];
                else
                    v472 = v471;
                end;

                local v473 = (tonumber(v470.Quantity) or 0) - 1;
                local v474 = math.max(0, v473);
                local v475 = v472 and tonumber(v472.CrateToken) or 0;

                if v474 > 0 and v475 > 0 then
                    v469[#v469 + 1] = {
                        ItemId = child.Name,
                        ItemData = v470,
                        Rarity = v471,
                        ConvertibleQuantity = v474,
                        TokenValue = v475
                    };
                end;
            end;
        end;

        table.sort(v469, function(p476, p477) -- Line: 4339
            local Rarity2 = p476.Rarity;
            local v478 = Rarity2 == "Common" and 1 or (Rarity2 == "Uncommon" and 2 or (Rarity2 == "Rare" and 3 or (Rarity2 == "Epic" and 4 or (Rarity2 == "Legendary" and 5 or (Rarity2 == "Divine" and 6 or (Rarity2 == "Limited" and 7 or 999))))));
            local Rarity3 = p477.Rarity;
            local v479 = Rarity3 == "Common" and 1 or (Rarity3 == "Uncommon" and 2 or (Rarity3 == "Rare" and 3 or (Rarity3 == "Epic" and 4 or (Rarity3 == "Legendary" and 5 or (Rarity3 == "Divine" and 6 or (Rarity3 == "Limited" and 7 or 999))))));

            if v478 ~= v479 then
                return v478 < v479;
            end;

            if p476.ItemData.Type ~= p477.ItemData.Type then
                return p476.ItemData.Type < p477.ItemData.Type;
            end;

            if p476.ItemData.Name == p477.ItemData.Name then
                return (p476.ItemData.Weapon or "") < (p477.ItemData.Weapon or "");
            end;

            return p476.ItemData.Name < p477.ItemData.Name;
        end);

        return v469;
    end;

    local function CreateDuplicateCard(u480, p481) -- Line: 4357
        -- upvalues: SampleItem (copy), Config (ref), u2 (ref), u453 (copy), u454 (copy), SoundService (ref), u452 (copy), SetDuplicateSelectionVisual (copy), UpdateDuplicateTotalLabel (copy), Scroller2 (copy)
        local v482 = SampleItem:Clone();
        v482.Name = u480.ItemId;
        v482.LayoutOrder = p481;
        v482.Visible = true;
        v482.Level.Text = "";
        v482.Cost.Text = "";
        v482.Cost.Visible = false;
        v482.Title.Text = u480.ItemData.Name or "";
        v482.SubTitle.Text = u480.ItemData.Weapon and string.upper(u480.ItemData.Weapon) or string.upper(u480.ItemData.Type or "");
        v482.TextDisplay.Text = "";
        v482.ImageDisplay.Image = "";
        v482.DisplaySelect.Visible = false;
        v482.Quantity.Visible = true;
        v482.Quantity.Amount.Text = tostring(u480.ConvertibleQuantity);
        local v483 = u480.Rarity and Config.Rarity[u480.Rarity];
        v482.Rarity.Visible = (u480.ItemData.Type == "Head" or (u480.ItemData.Type == "Top" or (u480.ItemData.Type == "Bottom" or (u480.ItemData.Type == "Banner" or (u480.ItemData.Type == "Title" or (u480.ItemData.Type == "Emote" or (u480.ItemData.Type == "Knife" or u480.ItemData.Type == "Skin"))))))) and true or u480.ItemData.Type == "Charm";

        if v483 then
            v482.Rarity.ImageColor3 = v483.Color;
            local Rarity2 = u480.Rarity;
            v482.Rarity.ImageTransparency = Rarity2 == "Divine" and 0.3 or (Rarity2 == "Legendary" and 0.4 or (Rarity2 == "Epic" and 0.5 or 0.6));
            v482.RarityName.Text = string.upper(u480.Rarity);
            v482.RarityName.TextColor3 = v483.Color;
        end;

        u2.AddItemToViewport(u480.ItemData, v482.ItemPort, (u480.ItemData.Type ~= "Skin" or not u480.ItemData.Weapon) and true or false);
        u480.Card = v482;
        u453[u480.ItemId] = u480;
        local v484;

        if u480 then
            v484 = u480.Card;
        else
            v484 = u480;
        end;

        if v484 then
            v484.Level.Text = "";
            v484.DisplaySelect.Visible = false;
            local v485 = v484.DisplaySelect:FindFirstChildOfClass("UIStroke");

            if v485 then
                v485.Color = Color3.fromRGB(255, 255, 255);
            end;

            v484.Quantity.Visible = true;
            v484.Quantity.Amount.Text = tostring(u480.ConvertibleQuantity);
        end;

        table.insert(u454, v482.Activated:Connect(function() -- Line: 4392
            -- upvalues: Config (ref), SoundService (ref), u452 (ref), u480 (copy), SetDuplicateSelectionVisual (ref), UpdateDuplicateTotalLabel (ref)
            Config.AddSound("Click_1", 1, true, SoundService, false);
            local v486 = (u452[u480.ItemId] or 0) + 1;
            local v487 = u480.ConvertibleQuantity < v486 and 0 or v486;
            u452[u480.ItemId] = v487;
            SetDuplicateSelectionVisual(u480, v487);
            UpdateDuplicateTotalLabel();
        end));
        v482.Parent = Scroller2;
    end;

    local function RefreshDuplicatePage(p488) -- Line: 4407
        -- upvalues: ClearDuplicateScroller (copy), u452 (copy), BuildDuplicateEntryDatas (copy), CreateDuplicateCard (copy), Scroller2 (copy), UpdateDuplicateTotalLabel (copy), Stats (copy), CurrencyImage (copy), Config (ref), Currency (copy), CurrencyImage2 (copy), Currency2 (copy)
        ClearDuplicateScroller();

        if p488 ~= false then
            table.clear(u452);
        end;

        local v489 = BuildDuplicateEntryDatas();

        for i, v in ipairs(v489) do
            CreateDuplicateCard(v, i);
        end;

        Scroller2.CanvasPosition = Vector2.new(0, 0);
        UpdateDuplicateTotalLabel();
        local v490 = tonumber(Stats:GetAttribute("CrateToken")) or 0;
        CurrencyImage.Image = Config.CurrencyImage.CrateToken;
        Currency.Text = tostring(v490);
        CurrencyImage2.Image = Config.CurrencyImage.CrateToken;
        Currency2.Text = tostring(v490);
    end;

    u2.RefreshDuplicatePage = RefreshDuplicatePage;

    local function SetShopSelectionVisual(p491, p492) -- Line: 4425
        if p491 then
            p491 = p491.Card;
        end;

        if not p491 then
            return;
        end;

        p491.Level.Text = p492 > 0 and ("x" .. tostring(p492) or "") or "";
        p491.DisplaySelect.Visible = p492 > 0;
        local v493 = p491.DisplaySelect:FindFirstChildOfClass("UIStroke");

        if v493 then
            v493.Color = Color3.fromRGB(255, 255, 255);
        end;

        p491.Quantity.Visible = false;
    end;

    local function UpdateShopTotalLabel() -- Line: 4440
        -- upvalues: u456 (copy), u457 (copy), Amount2 (copy), Stats (copy), CurrencyImage (copy), Config (ref), Currency (copy), CurrencyImage2 (copy), Currency2 (copy)
        local v494 = 0;

        for i, v in pairs(u456) do
            local v495 = u457[i];

            if v495 and v > 0 then
                v494 = v494 + v * v495.Price;
            end;
        end;

        Amount2.Text = "Cost: " .. tostring(v494) .. " " .. (v494 == 1 and "Crate Token" or "Crate Tokens");
        local v496 = tonumber(Stats:GetAttribute("CrateToken")) or 0;
        CurrencyImage.Image = Config.CurrencyImage.CrateToken;
        Currency.Text = tostring(v496);
        CurrencyImage2.Image = Config.CurrencyImage.CrateToken;
        Currency2.Text = tostring(v496);

        return v494;
    end;

    local function ClearShopScroller() -- Line: 4461
        -- upvalues: u458 (copy), Scroller3 (copy), u457 (copy)
        for _, v in ipairs(u458) do
            v:Disconnect();
        end;

        table.clear(u458);

        for _, child in ipairs(Scroller3:GetChildren()) do
            if child:IsA("GuiObject") and not child:IsA("UIGridLayout") then
                child:Destroy();
            end;
        end;

        table.clear(u457);
    end;

    local function ConfigureShopCardCost(p497, p498) -- Line: 4471
        -- upvalues: Config (ref)
        p497.Cost.Text = tostring(p498);

        for _, v in ipairs({ "Cash", "Credit", "CampaignPoints" }) do
            local v499 = p497.Cost:FindFirstChild(v);

            if v499 and v499:IsA("ImageLabel") then
                v499.Visible = false;
            end;
        end;

        local CampaignPoints = p497.Cost:FindFirstChild("CampaignPoints");

        if CampaignPoints and CampaignPoints:IsA("ImageLabel") then
            CampaignPoints.Visible = true;
            CampaignPoints.Image = Config.CurrencyImage.CrateToken;
            CampaignPoints.ImageColor3 = Color3.fromRGB(255, 255, 255);
            local v500 = CampaignPoints:FindFirstChildOfClass("UIGradient");

            if v500 then
                v500.Enabled = false;
            end;
        end;
    end;

    local function ConfigureShopCrateViewport(p501, p502) -- Line: 4492
        -- upvalues: ReplicatedStorage (ref), u342 (copy), Crate (copy), u2 (ref)
        for _, child in ipairs(p501:GetChildren()) do
            if child.Name ~= "Camera" then
                child:Destroy();
            end;
        end;

        local WorldModel = p501:FindFirstChild("WorldModel");

        if WorldModel == nil then
            WorldModel = Instance.new("WorldModel");
            WorldModel.Name = "WorldModel";
            WorldModel.Parent = p501;
        else
            WorldModel:ClearAllChildren();
        end;

        local Crate2 = ReplicatedStorage.Items:FindFirstChild("Crate");

        if Crate2 then
            Crate2 = Crate2:FindFirstChild(p502);
        end;

        if Crate2 then
            local v503 = Crate2:Clone();
            v503.Parent = WorldModel;
            v503:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(u342.PreviewYaw or -20), 0));
        end;

        p501.Ambient = Crate.ItemPort.Ambient;
        p501.LightColor = Crate.ItemPort.LightColor;
        p501.LightDirection = Crate.ItemPort.LightDirection;
        u2.SetNewViewPort(p501, Vector3.new(0, 0, 0), Vector3.new(0, 4.5, -8));
    end;

    local function BuildShopEntryDatas() -- Line: 4521
        -- upvalues: Crates (ref), ReplicatedStorage (ref)
        local v504 = {};

        for _, v in ipairs(Crates.GetDuplicateShopCrates()) do
            local v505 = tonumber(Crates.GetDuplicateShopPrice(v));

            if v505 and (v505 > 0 and Crates.HasContents(v) == true) then
                local v506 = ReplicatedStorage.Items.Crate:FindFirstChild(v);
                v504[#v504 + 1] = {
                    CrateName = v,
                    Price = v505,
                    Rarity = v506 and v506:GetAttribute("Rarity") or nil
                };
            end;
        end;

        return v504;
    end;

    local function CreateShopCard(u507, p508) -- Line: 4537
        -- upvalues: SampleItem (copy), ConfigureShopCardCost (copy), Config (ref), ConfigureShopCrateViewport (copy), u457 (copy), u458 (copy), SoundService (ref), u456 (copy), SetShopSelectionVisual (copy), UpdateShopTotalLabel (copy), Scroller3 (copy)
        local v509 = SampleItem:Clone();
        v509.Name = u507.CrateName;
        v509.LayoutOrder = p508;
        v509.Visible = true;
        v509.Level.Text = "";
        v509.Cost.Visible = true;
        v509.Title.Text = string.upper(u507.CrateName);
        v509.SubTitle.Text = "CRATE";
        v509.TextDisplay.Text = "";
        v509.ImageDisplay.Image = "";
        v509.DisplaySelect.Visible = false;
        v509.Quantity.Visible = false;
        ConfigureShopCardCost(v509, u507.Price);
        local v510 = u507.Rarity and Config.Rarity[u507.Rarity];
        v509.Rarity.Visible = v510 ~= nil;

        if v510 then
            v509.Rarity.ImageColor3 = v510.Color;
            local Rarity2 = u507.Rarity;
            v509.Rarity.ImageTransparency = Rarity2 == "Divine" and 0.3 or (Rarity2 == "Legendary" and 0.4 or (Rarity2 == "Epic" and 0.5 or 0.6));
            v509.RarityName.Text = string.upper(u507.Rarity);
            v509.RarityName.TextColor3 = v510.Color;
        end;

        ConfigureShopCrateViewport(v509.ItemPort, u507.CrateName);
        u507.Card = v509;
        u457[u507.CrateName] = u507;
        local v511;

        if u507 then
            v511 = u507.Card;
        else
            v511 = u507;
        end;

        if v511 then
            v511.Level.Text = "";
            v511.DisplaySelect.Visible = false;
            local v512 = v511.DisplaySelect:FindFirstChildOfClass("UIStroke");

            if v512 then
                v512.Color = Color3.fromRGB(255, 255, 255);
            end;

            v511.Quantity.Visible = false;
        end;

        table.insert(u458, v509.Activated:Connect(function() -- Line: 4566
            -- upvalues: Config (ref), SoundService (ref), u456 (ref), u507 (copy), SetShopSelectionVisual (ref), UpdateShopTotalLabel (ref)
            Config.AddSound("Click_1", 1, true, SoundService, false);
            local v513 = (u456[u507.CrateName] or 0) + 1;
            u456[u507.CrateName] = v513;
            SetShopSelectionVisual(u507, v513);
            UpdateShopTotalLabel();
        end));
        v509.Parent = Scroller3;
    end;

    local function RefreshCrateShopPage(p514) -- Line: 4577
        -- upvalues: ClearShopScroller (copy), u456 (copy), BuildShopEntryDatas (copy), CreateShopCard (copy), Scroller3 (copy), UpdateShopTotalLabel (copy), Stats (copy), CurrencyImage (copy), Config (ref), Currency (copy), CurrencyImage2 (copy), Currency2 (copy)
        ClearShopScroller();

        if p514 ~= false then
            table.clear(u456);
        end;

        local v515 = BuildShopEntryDatas();

        for i, v in ipairs(v515) do
            CreateShopCard(v, i);
        end;

        Scroller3.CanvasPosition = Vector2.new(0, 0);
        UpdateShopTotalLabel();
        local v516 = tonumber(Stats:GetAttribute("CrateToken")) or 0;
        CurrencyImage.Image = Config.CurrencyImage.CrateToken;
        Currency.Text = tostring(v516);
        CurrencyImage2.Image = Config.CurrencyImage.CrateToken;
        Currency2.Text = tostring(v516);
    end;

    u2.RefreshCrateShopPage = RefreshCrateShopPage;

    local function ConnectDuplicateInventoryItem(p517) -- Line: 4595
        -- upvalues: u455 (copy), Duplicate (copy), u2 (ref)
        if not (p517 and p517:IsA("StringValue")) then
            return;
        end;

        local v518 = p517:GetAttributeChangedSignal("Quantity");
        table.insert(u455, v518:Connect(function() -- Line: 4599
            -- upvalues: Duplicate (ref), u2 (ref)
            if Duplicate.Visible == true and u2.RefreshDuplicatePage then
                u2.RefreshDuplicatePage(true);
            end;
        end));
    end;

    local function ClearShopSelectionState() -- Line: 4453
        -- upvalues: u456 (copy), u457 (copy), UpdateShopTotalLabel (copy)
        table.clear(u456);

        for _, v in pairs(u457) do
            if v then
                local v = v.Card;
            end;

            if v then
                v.Level.Text = "";
                v.DisplaySelect.Visible = false;
                local v519 = v.DisplaySelect:FindFirstChildOfClass("UIStroke");

                if v519 then
                    v519.Color = Color3.fromRGB(255, 255, 255);
                end;

                v.Quantity.Visible = false;
            end;
        end;

        UpdateShopTotalLabel();
    end;

    local function u522() -- Line: 4299
        -- upvalues: u452 (copy), u453 (copy), UpdateDuplicateTotalLabel (copy)
        table.clear(u452);

        for _, v in pairs(u453) do
            local v520;

            if v then
                v520 = v.Card;
            else
                v520 = v;
            end;

            if v520 then
                v520.Level.Text = "";
                v520.DisplaySelect.Visible = false;
                local v521 = v520.DisplaySelect:FindFirstChildOfClass("UIStroke");

                if v521 then
                    v521.Color = Color3.fromRGB(255, 255, 255);
                end;

                v520.Quantity.Visible = true;
                v520.Quantity.Amount.Text = tostring(v.ConvertibleQuantity);
            end;
        end;

        UpdateDuplicateTotalLabel();
    end;

    local u523 = false;
    local u524 = false;

    for _, child in ipairs(LocalPlayer.PlayerData.Inventory:GetChildren()) do
        ConnectDuplicateInventoryItem(child);
    end;

    table.insert(u455, LocalPlayer.PlayerData.Inventory.ChildAdded:Connect(function(p525) -- Line: 4609
        -- upvalues: ConnectDuplicateInventoryItem (copy), Duplicate (copy), u2 (ref)
        ConnectDuplicateInventoryItem(p525);

        if Duplicate.Visible == true and u2.RefreshDuplicatePage then
            u2.RefreshDuplicatePage(true);
        end;
    end));
    table.insert(u455, LocalPlayer.PlayerData.Inventory.ChildRemoved:Connect(function() -- Line: 4615
        -- upvalues: Duplicate (copy), u2 (ref)
        if Duplicate.Visible == true and u2.RefreshDuplicatePage then
            u2.RefreshDuplicatePage(true);
        end;
    end));
    local v526 = Stats:GetAttributeChangedSignal("CrateToken");
    table.insert(u455, v526:Connect(function() -- Line: 4620
        -- upvalues: Stats (copy), CurrencyImage (copy), Config (ref), Currency (copy), CurrencyImage2 (copy), Currency2 (copy), Duplicate (copy), UpdateDuplicateTotalLabel (copy), Shop (copy), UpdateShopTotalLabel (copy)
        local v527 = tonumber(Stats:GetAttribute("CrateToken")) or 0;
        CurrencyImage.Image = Config.CurrencyImage.CrateToken;
        Currency.Text = tostring(v527);
        CurrencyImage2.Image = Config.CurrencyImage.CrateToken;
        Currency2.Text = tostring(v527);

        if Duplicate.Visible == true then
            UpdateDuplicateTotalLabel();
        end;

        if Shop.Visible == true then
            UpdateShopTotalLabel();
        end;
    end));
    Amount.Text = tostring(0) .. " Crate Tokens";
    Amount2.Text = "Cost: " .. tostring(0) .. " Crate Tokens";
    local v528 = tonumber(Stats:GetAttribute("CrateToken")) or 0;
    CurrencyImage.Image = Config.CurrencyImage.CrateToken;
    Currency.Text = tostring(v528);
    CurrencyImage2.Image = Config.CurrencyImage.CrateToken;
    Currency2.Text = tostring(v528);

    u350 = function(p529) -- Line: 4634
        -- upvalues: u345 (ref), u343 (ref), u344 (ref), RefreshCrateTable (copy), Crate (copy), ClearCrateContent (copy), Crates2 (copy), ApplyCrateRarityColor (copy), SetCratePreview (copy), u342 (copy), RefreshCrateContent (copy)
        if u345 and not p529 then
            return;
        end;

        local v530 = RefreshCrateTable(u343[u344]);

        if not v530 then
            Crate.Detail.ItemName.Text = "NO CRATES";
            Crate.Detail.Amount.Text = "0 left";
            Crate.ItemPort.WorldModel:ClearAllChildren();
            ClearCrateContent();

            return;
        end;

        Crate.Detail.ItemName.Text = string.upper(v530 .. " CRATE");
        Crate.Detail.Amount.Text = string.upper(Crates2:GetAttribute(v530) or 0) .. " left";
        ApplyCrateRarityColor(v530);
        SetCratePreview(v530, u342.PreviewYaw or -20);
        RefreshCrateContent(v530);
    end;

    Crates2.AttributeChanged:Connect(function() -- Line: 4656
        -- upvalues: u350 (ref)
        u350();
    end);
    u350(true);
    Crate.Detail.Next.Activated:Connect(function() -- Line: 4662
        -- upvalues: u345 (ref), u343 (ref), Config (ref), u344 (ref), u350 (ref)
        if u345 then
            return;
        end;

        if #u343 > 0 then
            Config.AddSound("Click_1", 1, true, game.SoundService, false);
            u344 = u344 + 1;

            if u344 > #u343 then
                u344 = 1;
            elseif u344 < 1 then
                u344 = #u343;
            end;
        end;

        u350(true);
    end);
    Crate.Detail.Previous.Activated:Connect(function() -- Line: 4670
        -- upvalues: u345 (ref), u343 (ref), Config (ref), u344 (ref), u350 (ref)
        if u345 then
            return;
        end;

        if #u343 > 0 then
            Config.AddSound("Click_1", 1, true, game.SoundService, false);
            u344 = u344 + -1;

            if u344 > #u343 then
                u344 = 1;
            elseif u344 < 1 then
                u344 = #u343;
            end;
        end;

        u350(true);
    end);
    Crate.Detail.Open.Activated:Connect(function() -- Line: 4678
        -- upvalues: u345 (ref), u343 (ref), u344 (ref), Config (ref), Crates2 (copy), u2 (ref), ResetCratePage (copy), ReplicatedStorage (ref)
        if u345 then
            return;
        end;

        local v531 = u343[u344];

        if not v531 then
            return;
        end;

        Config.AddSound("Click_2", 1, true, game.SoundService, false);

        if (Crates2:GetAttribute(v531) or 0) <= 0 then
            u2.AddNotification("No crates available", Color3.fromRGB(255, 150, 150));

            return;
        end;

        u345 = true;

        function u2.CurrentCrateFailureHandler() -- Line: 4694
            -- upvalues: ResetCratePage (ref)
            ResetCratePage();
        end;

        ReplicatedStorage.Events.OpenCrate:FireServer(v531);
    end);
    Crate.Detail.Duplicate.Activated:Connect(function() -- Line: 4700
        -- upvalues: u345 (ref), Config (ref), Crate (copy), Duplicate (copy), RefreshDuplicatePage (copy)
        if u345 then
            return;
        end;

        Config.AddSound("Click_2", 1, true, game.SoundService, false);
        Crate.Detail.Visible = false;
        Duplicate.Visible = true;
        RefreshDuplicatePage(true);
    end);
    Crate.Detail.Shop.Activated:Connect(function() -- Line: 4710
        -- upvalues: u345 (ref), Config (ref), Crate (copy), Shop (copy), RefreshCrateShopPage (copy)
        if u345 then
            return;
        end;

        Config.AddSound("Click_2", 1, true, game.SoundService, false);
        Crate.Detail.Visible = false;
        Shop.Visible = true;
        RefreshCrateShopPage(true);
    end);
    Back.Activated:Connect(function() -- Line: 4720
        -- upvalues: Config (ref), Duplicate (copy), Crate (copy), u522 (copy)
        Config.AddSound("Click_2", 1, true, game.SoundService, false);
        Duplicate.Visible = false;
        Crate.Detail.Visible = true;
        u522();
    end);
    Back2.Activated:Connect(function() -- Line: 4727
        -- upvalues: Config (ref), Shop (copy), Crate (copy), ClearShopSelectionState (copy)
        Config.AddSound("Click_2", 1, true, game.SoundService, false);
        Shop.Visible = false;
        Crate.Detail.Visible = true;
        ClearShopSelectionState();
    end);
    Clear.Activated:Connect(function() -- Line: 4734
        -- upvalues: Config (ref), u522 (copy)
        Config.AddSound("Click_2", 1, true, game.SoundService, false);
        u522();
    end);
    Clear2.Activated:Connect(function() -- Line: 4739
        -- upvalues: Config (ref), ClearShopSelectionState (copy)
        Config.AddSound("Click_2", 1, true, game.SoundService, false);
        ClearShopSelectionState();
    end);
    Sell.Activated:Connect(function() -- Line: 4744
        -- upvalues: u524 (ref), u452 (copy), u2 (ref), Config (ref), ReplicatedStorage (ref)
        if u524 == true then
            return;
        end;

        local v532 = {};

        for i, v in pairs(u452) do
            if v > 0 then
                v532[i] = v;
            end;
        end;

        if next(v532) == nil then
            u2.AddNotification("No duplicates selected", Color3.fromRGB(255, 150, 150));

            return;
        end;

        u524 = true;
        task.delay(0.5, function() -- Line: 4762
            -- upvalues: u524 (ref)
            u524 = false;
        end);
        Config.AddSound("Click_3", 1, true, game.SoundService, false);
        ReplicatedStorage.Events.Action:FireServer("ConvertDuplicates", v532);
    end);
    Buy.Activated:Connect(function() -- Line: 4770
        -- upvalues: u523 (ref), u456 (copy), u2 (ref), Config (ref), ReplicatedStorage (ref)
        if u523 == true then
            return;
        end;

        local v533 = {};

        for i, v in pairs(u456) do
            if v > 0 then
                v533[i] = v;
            end;
        end;

        if next(v533) == nil then
            u2.AddNotification("No crates selected", Color3.fromRGB(255, 150, 150));

            return;
        end;

        u523 = true;
        task.delay(0.5, function() -- Line: 4788
            -- upvalues: u523 (ref)
            u523 = false;
        end);
        Config.AddSound("Click_3", 1, true, game.SoundService, false);
        ReplicatedStorage.Events.Action:FireServer("PurchaseDuplicateShop", v533);
    end);
    Duplicate:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4796
        -- upvalues: Duplicate (copy), RefreshDuplicatePage (copy), u522 (copy)
        if Duplicate.Visible == true then
            RefreshDuplicatePage(true);

            return;
        end;

        u522();
    end);
    Shop:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4804
        -- upvalues: Shop (copy), RefreshCrateShopPage (copy), ClearShopSelectionState (copy)
        if Shop.Visible == true then
            RefreshCrateShopPage(true);

            return;
        end;

        ClearShopSelectionState();
    end);

    function u2.CrateResultHandler(u534) -- Line: 4812
        -- upvalues: PlayCrateRollAnimation (copy)
        task.spawn(function() -- Line: 4813
            -- upvalues: PlayCrateRollAnimation (ref), u534 (copy)
            PlayCrateRollAnimation(u534);
        end);
    end;
end;

function u2.ConfigAction() -- Line: 4820
    -- upvalues: ReplicatedStorage (copy), u2 (copy), Config (copy), LocalPlayer (copy), u7 (ref)
    ReplicatedStorage.Events.Action.OnClientEvent:Connect(function(p535, p536) -- Line: 4821
        -- upvalues: u2 (ref), Config (ref), LocalPlayer (ref), u7 (ref)
        if p535 == "CrateResult" then
            if u2.CrateResultHandler then
                u2.CrateResultHandler(p536);
            end;
        else
            if p535 == "ItemsLog" then
                u2.StartItemNotification();

                return;
            end;

            if p535 == "Notification" then
                if u2.CurrentCrateFailureHandler then
                    u2.CurrentCrateFailureHandler();
                end;

                u2.AddNotification(p536.Message, p536.Color, game.PlaceId == Config.InGameID and LocalPlayer.PlayerGui.GameHUD.GameNotification.Frame or nil);

                return;
            end;

            if p535 == "RefreshLoadout" then
                u2.UpdateMainDisplay(LocalPlayer, u7.Pages.Loadout.Details.ItemPort);

                return;
            end;

            if p535 == "RefreshDuplicates" then
                if u2.RefreshDuplicatePage then
                    u2.RefreshDuplicatePage(true);
                end;
            elseif p535 == "RefreshCrateShop" and u2.RefreshCrateShopPage then
                u2.RefreshCrateShopPage(true);
            end;
        end;
    end);
    u2.StartItemNotification();
end;

function u2.StartItemNotification(p537) -- Line: 4849
    -- upvalues: u7 (ref), LocalPlayer (copy), ApplyCurrencyGradient (copy), Config (copy), ReplicatedStorage (copy), u2 (copy)
    local SampleItemNotification = script.SampleItemNotification;
    local Overlay = u7:WaitForChild("Overlay");
    local ItemsLog = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("ItemsLog");
    local v538 = 0;

    for _, child in pairs(ItemsLog:GetChildren()) do
        if child:GetAttribute("Seen") ~= true then
            v538 = v538 + 1;
        end;
    end;

    local v539 = {};

    if p537 then
        local v540 = ItemsLog:FindFirstChild(p537);

        if v540 and (v540:GetAttribute("Seen") ~= true and not Overlay:FindFirstChild(v540.Name)) then
            v539[#v539 + 1] = v540;
        end;
    end;

    if #v539 <= 0 then
        for _, child in pairs(ItemsLog:GetChildren()) do
            if child:GetAttribute("Seen") ~= true and not Overlay:FindFirstChild(child.Name) then
                v539[#v539 + 1] = child;
            end;
        end;
    end;

    for _, v in ipairs(v539) do
        local v541 = v:GetAttribute("Name");
        local v542 = v:GetAttribute("Type");
        local v543 = v:GetAttribute("Weapon") or "";
        local v544 = v:GetAttribute("Amount") or 1;
        local v545 = v:GetAttribute("Slot");
        local v546 = "Common";
        local u547 = SampleItemNotification:Clone();
        u547:SetAttribute("Type", "ItemNotification");
        u547.Title.Text = v541;
        u547.Name = v.Name;
        ApplyCurrencyGradient(u547.ImageDisplay);

        if v541 == "Cash" then
            u547.ImageDisplay.Image = "rbxassetid://14831951512";
            ApplyCurrencyGradient(u547.ImageDisplay, v541);
            u547.Title.Text = tostring(v544) .. " " .. v541;
        elseif v541 == "Credit" then
            u547.ImageDisplay.Image = "rbxassetid://14832021061";
            ApplyCurrencyGradient(u547.ImageDisplay, v541);
            u547.Title.Text = tostring(v544) .. " " .. v541;
        elseif v541 == "Scrap" then
            u547.ImageDisplay.Image = "rbxassetid://14831988987";
            u547.Title.Text = tostring(v544) .. " " .. v541;
        elseif v541 == "CampaignPoints" then
            u547.ImageDisplay.Image = "rbxassetid://14915583580";
            ApplyCurrencyGradient(u547.ImageDisplay, v541);
            u547.Title.Text = tostring(v544) .. " " .. v541;
        elseif v541 == "Crate Token" then
            u547.ImageDisplay.Image = Config.CurrencyImage.CrateToken or "";
            u547.Title.Text = tostring(v544) .. " " .. v541 .. (v544 == 1 and "" or "s");
        else
            local v548 = ReplicatedStorage.Items:FindFirstChild(v542):FindFirstChild(v541);
            v546 = v548 and (v548:GetAttribute("Rarity") or "Common") or v546;
            u2.AddItemToViewport({
                Name = v541,
                Type = v542,
                Amount = v544,
                Rarity = v546,
                Weapon = v543,
                Slot = v545
            }, u547.ItemPort, false);

            if v542 == "Crate" and v544 > 1 then
                u547.Title.Text = string.format("%s [x%d]", v541, v544);
            end;
        end;

        u547.RarityName.Text = string.upper(v546);
        u547.RarityName.TextColor3 = Config.Rarity[v546].Color;
        u547.Rarity.ImageColor3 = Config.Rarity[v546].Color;
        u547.Yes.Activated:Connect(function() -- Line: 4931
            -- upvalues: Config (ref), ReplicatedStorage (ref), v (copy), u547 (copy)
            Config.AddSound("Click_2", 1, true, game.SoundService, false);
            ReplicatedStorage.Events.Action:FireServer("ItemsLog", {
                ID = v.Name
            });
            u547:Destroy();
        end);
        u547.All.Activated:Connect(function() -- Line: 4937
            -- upvalues: Config (ref), ReplicatedStorage (ref), Overlay (copy)
            Config.AddSound("Click_2", 1, true, game.SoundService, false);
            ReplicatedStorage.Events.Action:FireServer("ItemsLogSkip");

            for _, child in pairs(Overlay:GetChildren()) do
                if child:GetAttribute("Type") == "ItemNotification" then
                    child:Destroy();
                end;
            end;
        end);
        local v549 = 0;

        for _, child in pairs(Overlay:GetChildren()) do
            if child:GetAttribute("Type") == "ItemNotification" then
                v549 = v549 + 1;
            end;
        end;

        local v550 = v538 - v549 - 1;
        u547.Amount.Text = tostring(v550) .. " left";

        if v550 <= 0 then
            u547.Amount.Text = "";
        end;

        u547.ZIndex = v550;
        u547.Parent = Overlay;

        if v549 >= 5 then
            break;
        end;
    end;
end;

function u2.ConfigStorePage() -- Line: 4969
    -- upvalues: u7 (ref), Config (copy), SoundService (copy), ReplicatedStorage (copy), u2 (copy), Gamepasses (copy), LocalPlayer (copy)
    local Store = u7:WaitForChild("Pages"):WaitForChild("Store");
    local u551 = {};

    local function ConfigStorePrompt() -- Line: 4973
        -- upvalues: Store (copy), u551 (ref), Config (ref), SoundService (ref), ReplicatedStorage (ref)
        Store.Prompt.Cancel.Activated:Connect(function() -- Line: 4974
            -- upvalues: Store (ref)
            Store.Prompt.Visible = false;
        end);
        Store.Prompt.Accept.Activated:Connect(function() -- Line: 4978
            -- upvalues: u551 (ref), Config (ref), SoundService (ref), ReplicatedStorage (ref), Store (ref)
            if not u551 then
                return;
            end;

            Config.AddSound("Click_3", 1, true, SoundService, false);
            ReplicatedStorage.Events.PurchaseItem:FireServer(u551);
            Store.Prompt.Visible = false;
        end);
    end;

    local function ConfigCurrencyScroller() -- Line: 4991
        -- upvalues: Store (copy), u2 (ref)
        for _, child in pairs(Store.Store.Cash.Scroller:GetChildren()) do
            if child:IsA("ImageButton") then
                child.Button.Activated:Connect(function() -- Line: 4994
                    -- upvalues: u2 (ref), child (copy)
                    u2.SetupMonetisationButton(child);
                end);
            end;
        end;

        for _, child in pairs(Store.Store.Credit.Scroller:GetChildren()) do
            if child:IsA("ImageButton") then
                child.Button.Activated:Connect(function() -- Line: 5000
                    -- upvalues: u2 (ref), child (copy)
                    u2.SetupMonetisationButton(child);
                end);
            end;
        end;
    end;

    local function ConfigFeaturedScroller() -- Line: 5006
        -- upvalues: ReplicatedStorage (ref), Config (ref), Store (copy), u2 (ref), u551 (ref)
        local Shop = ReplicatedStorage.Components:WaitForChild("Shop");

        for _, child in pairs(Shop.Featured:GetChildren()) do
            local u552 = {};

            for i, v in pairs(child:GetAttributes()) do
                u552[i] = v;
            end;

            if Config.CheckSeasonActive() == true and Config.SeasonFeaturedItem ~= nil then
                Store.Store.Featured.Title.Text = "FEATURED SET";
                Store.Store.Featured.Title.TextColor3 = Config.SeasonColorTheme;
            end;

            if child.Name == "SetHead" or (child.Name == "SetTop" or (child.Name == "SetBottom" or child.Name == "FeaturedKnife")) then
                local u553 = Store.Store.Featured.Scroller:FindFirstChild(child.Name);
                u2.AddItemToViewport(u552, u553.Button.ItemPort);
                u553.Button.Rarity.ImageColor3 = Config.Rarity[child:GetAttribute("Rarity")].Color;
                u553.Button.Rarity.ImageTransparency = 1;
                u553.Button.SubTitle.Text = u552.Name;
                u553.Button.Title.Text = u552.Type;
                u553.Button.RarityName.Text = child:GetAttribute("Rarity");
                u553.Button.RarityName.TextColor3 = Config.Rarity[child:GetAttribute("Rarity")].Color;

                if u552.Weapon then
                    u553.Button.Title.Text = string.upper(u552.Weapon);
                end;

                local u554, u555 = Config.GetItemDataPrice(u552);
                u553.Button.Cost.Text = u555;
                u553.Button.Cost.Icon.Image = Config.CurrencyImage[u554];

                if not game.Players.LocalPlayer.PlayerData.Inventory:FindFirstChild(Config.GetItemIDFromItemData(u552)) then
                    u553.Button.StatusIcon.Visible = false;
                end;

                u553.Button.Activated:Connect(function() -- Line: 5046
                    -- upvalues: Config (ref), u551 (ref), u552 (copy), Store (ref), u553 (copy), u555 (copy), u554 (copy)
                    Config.AddSound("Click_1", 1, true, game.SoundService, false);
                    u551 = u552;
                    Store.Prompt.Visible = true;
                    Store.Prompt.Title.Text = "Confirm buy " .. u553.Button.SubTitle.Text .. " " .. u552.Type .. " ?";
                    Store.Prompt.Cost.Text = u555;
                    Store.Prompt.Cost.Icon.Image = Config.CurrencyImage[u554];
                end);
            end;
        end;

        Shop.Featured:GetAttributeChangedSignal("TimeLeft"):Connect(function() -- Line: 5059
            -- upvalues: Store (ref), Shop (copy)
            Store.Store.Featured.Timer.Text = "Daily refresh | " .. Shop.Featured:GetAttribute("TimeLeft");
            Store.Store.Premium.Timer.Text = "Daily refresh | " .. Shop.Featured:GetAttribute("TimeLeft");
            Store.Store.Workshop.Timer.Text = "Daily refresh | " .. Shop.Featured:GetAttribute("TimeLeft");
        end);
    end;

    local function ConfigPremiumScroller() -- Line: 5066
        -- upvalues: ReplicatedStorage (ref), Store (copy), u2 (ref), Config (ref), u551 (ref)
        local Shop = ReplicatedStorage.Components:WaitForChild("Shop");

        for _, child in pairs(Shop.Featured:GetChildren()) do
            if child.Name ~= "SetHead" and (child.Name ~= "SetTop" and (child.Name ~= "SetBottom" and child.Name ~= "FeaturedKnife")) then
                local u556 = {};

                for i, v in pairs(child:GetAttributes()) do
                    u556[i] = v;
                end;

                local u557 = script.SampleInventory:Clone();
                u557.Parent = Store.Store.Premium.Scroller;
                u557.Name = child.Name;
                u557.LayoutOrder = tonumber(child:GetAttribute("LayoutOrder")) or 1;
                u2.AddItemToViewport(u556, u557.Button.ItemPort);
                u557.Button.BackgroundTransparency = 0;
                u557.Button.SubTitle.Text = u556.Name;
                u557.Button.Title.Text = u556.Type;
                u557.Button.RarityName.Text = child:GetAttribute("Rarity");
                u557.Button.RarityName.TextColor3 = Config.Rarity[child:GetAttribute("Rarity")].Color;
                u2.SetAllTextColor(u557.Button, Color3.fromRGB(30, 30, 30));

                if u556.Weapon then
                    u557.Button.Title.Text = string.upper(u556.Weapon);
                end;

                local u558, u559 = Config.GetItemDataPrice(u556);
                u557.Button.Cost.Text = u559;
                u557.Button.Cost.Icon.Image = Config.CurrencyImage[u558];

                if not game.Players.LocalPlayer.PlayerData.Inventory:FindFirstChild(Config.GetItemIDFromItemData(u556)) then
                    u557.Button.StatusIcon.Visible = false;
                end;

                u557.Button.Activated:Connect(function() -- Line: 5106
                    -- upvalues: Config (ref), u551 (ref), u556 (copy), Store (ref), u557 (copy), u559 (copy), u558 (copy)
                    Config.AddSound("Click_1", 1, true, game.SoundService, false);
                    u551 = u556;
                    Store.Prompt.Visible = true;
                    Store.Prompt.Title.Text = "Confirm buy " .. u557.Button.SubTitle.Text .. " " .. u556.Type .. " ?";

                    if u556.Weapon then
                        Store.Prompt.Title.Text = "Confirm buy " .. u557.Button.SubTitle.Text .. " " .. u556.Weapon .. " ?";
                    end;

                    Store.Prompt.Cost.Text = u559;
                    Store.Prompt.Cost.Icon.Image = Config.CurrencyImage[u558];
                end);
            end;
        end;
    end;

    local function ConfigWorkshopScroller() -- Line: 5122
        -- upvalues: ReplicatedStorage (ref), Store (copy), u2 (ref), Config (ref), u551 (ref)
        local Shop = ReplicatedStorage.Components:WaitForChild("Shop");

        for _, child in pairs(Shop.Workshop:GetChildren()) do
            local u560 = {};

            for i, v in pairs(child:GetAttributes()) do
                u560[i] = v;
            end;

            local v561 = ReplicatedStorage.Items[u560.Type][u560.Name];

            if v561 ~= nil then
                local u562 = script.SampleInventory:Clone();
                u562.Parent = Store.Store.Workshop.Scroller;
                u562.LayoutOrder = tonumber(child:GetAttribute("LayoutOrder")) or 1;
                u2.AddItemToViewport(u560, u562.Button.ItemPort);
                u562.Button.Rarity.ImageColor3 = Config.Rarity[v561:GetAttribute("Rarity")].Color;
                u562.Button.Rarity.ImageTransparency = 1;
                u562.Button.SubTitle.Text = u560.Name;
                u562.Button.Title.Text = u560.Type;
                u562.Button.RarityName.Text = string.upper(v561:GetAttribute("Rarity"));
                u562.Button.RarityName.TextColor3 = Config.Rarity[v561:GetAttribute("Rarity")].Color;
                local u563, u564 = Config.GetItemDataPrice(u560);
                u562.Button.Cost.Text = u564;
                u562.Button.Cost.Icon.Image = Config.CurrencyImage[u563];
                u562.Button.Cost.Icon.ImageColor3 = Color3.fromRGB(0, 0, 0);

                if game.Players.LocalPlayer.PlayerData.Inventory:FindFirstChild(Config.GetItemIDFromItemData(u560)) == nil then
                    u562.Button.StatusIcon.Visible = false;
                end;

                u562.Button.MouseButton1Down:Connect(function() -- Line: 5161
                    -- upvalues: Config (ref), u551 (ref), u560 (copy), Store (ref), u562 (copy), u564 (copy), u563 (copy)
                    Config.AddSound("Click_1", 1, true, game.SoundService, false);
                    u551 = u560;
                    Store.Prompt.Visible = true;
                    Store.Prompt.Title.Text = "Confirm buy " .. u562.Button.SubTitle.Text .. " " .. u560.Type .. " ?";
                    Store.Prompt.Cost.Text = u564;
                    Store.Prompt.Cost.Icon.Image = Config.CurrencyImage[u563];
                end);
            end;
        end;
    end;

    local function ConfigBundleScroller() -- Line: 5176
        -- upvalues: ReplicatedStorage (ref), Store (copy), Gamepasses (ref), u7 (ref), Config (ref), LocalPlayer (ref), u2 (ref), SoundService (ref)
        local function SetGrandViewPort(p565, p566) -- Line: 5178
            local Camera = p566:FindFirstChild("Camera");

            if Camera == nil then
                Camera = Instance.new("Camera", p566);
            end;

            local WorldModel = Instance.new("WorldModel", p566);
            local v567 = script.CameraPositions:Clone();
            v567.Parent = WorldModel;
            v567:PivotTo(CFrame.new(Vector3.new(0, 0, 0)));

            if p565 then
                for _, descendant in pairs(p565:GetDescendants()) do
                    if (descendant:IsA("Weld") or descendant:IsA("WeldConstraint")) and (descendant.Parent.Name ~= "Head" and (descendant.Parent.Name ~= "Hat" and (descendant.Parent.Name ~= "Hair" and descendant.Parent.Name ~= "Handle"))) then
                        descendant:Destroy();
                    end;
                end;

                p565.PrimaryPart = p565.HumanoidRootPart;
                p565.Parent = WorldModel;
                p565:PivotTo(v567.PrimaryPart.CFrame);
            end;

            Camera.CFrame = (v567:FindFirstChild("Default") or v567.Default).CFrame;
            p566.CurrentCamera = Camera;
        end;

        local function AddItemToViewportFull(p568, p569) -- Line: 5202
            -- upvalues: ReplicatedStorage (ref), SetGrandViewPort (copy)
            local v570 = nil;

            for _, v in pairs(p568.Items) do
                if v.Type == "Head" then
                    v570 = ReplicatedStorage.Items[v.Type][v.Name]:Clone();
                end;
            end;

            for _, v in pairs(p568.Items) do
                if v.Type == "Bottom" or v.Type == "Top" then
                    ReplicatedStorage.Items[v.Type][v.Name]:Clone().Parent = v570;
                end;
            end;

            SetGrandViewPort(v570, p569);

            if v570 then
                v570.Humanoid:LoadAnimation(script.Animations.Gazing):Play();
            end;

            return v570;
        end;

        for _, child in pairs(Store.Store.Bundle.Scroller:GetChildren()) do
            if child:IsA("ImageButton") then
                local u571 = Gamepasses.GamePasses[child.Name];

                if u571 then
                    if u571.Items then
                        AddItemToViewportFull(u571, child.Button.ItemPort);
                        local Store2 = u7.Pages.Play.Store;

                        if child.Name == Store2:GetAttribute("FeaturedName") then
                            AddItemToViewportFull(u571, Store2.ItemPort);
                        end;
                    end;

                    local u572 = Config.CheckPlayerOwnGamepass(LocalPlayer, u571.ID) and true or false;

                    if u572 then
                        child.Button.StatusIcon.Visible = false;
                    end;

                    child.Button.Activated:Connect(function() -- Line: 5260
                        -- upvalues: Config (ref), LocalPlayer (ref), u571 (copy), u572 (ref), u2 (ref), SoundService (ref), child (copy)
                        if Config.CheckPlayerOwnGamepass(LocalPlayer, u571.ID) then
                            u572 = true;
                        end;

                        if u572 == true then
                            u2.AddNotification("You own this pass", Color3.fromRGB(255, 100, 100));

                            return;
                        end;

                        Config.AddSound("Click_3", 1, true, SoundService, false);
                        u2.SetupMonetisationButton(child);
                    end);
                    child:SetAttribute("Type", u571.Type);
                    child:SetAttribute("ID", u571.ID);
                end;
            end;
        end;
    end;

    Store.Store.Promocode.Yes.Activated:Connect(function() -- Line: 5279, Name: ClaimPromocode
        -- upvalues: ReplicatedStorage (ref), Store (copy)
        ReplicatedStorage.Events.ClaimPromocode:FireServer(string.upper(Store.Store.Promocode.Input.Text));
    end);
    ConfigStorePrompt();
    ConfigCurrencyScroller();
    ConfigFeaturedScroller();
    ConfigPremiumScroller();
    ConfigWorkshopScroller();
    ConfigBundleScroller();
end;

function u2.SetupMonetisationButton(p573) -- Line: 5294
    -- upvalues: LocalPlayer (copy), MarketplaceService (copy), u2 (copy)
    if LocalPlayer.ServerData:GetAttribute("Searching") == "" then
        local v574 = p573:GetAttribute("ID");
        local v575 = LocalPlayer;

        if p573:GetAttribute("Type") == "DevProduct" then
            MarketplaceService:PromptProductPurchase(v575, v574);

            return;
        end;

        if p573:GetAttribute("Type") == "GamePass" then
            MarketplaceService:PromptGamePassPurchase(v575, v574);

            return;
        end;

        if p573:GetAttribute("Type") == "Asset" then
            MarketplaceService:PromptPurchase(v575, v574);
        end;
    else
        u2.AddNotification("Unable to buy when matchmaking", Color3.fromRGB(255, 100, 100));
    end;
end;

function u2.ConfigBattlepassButtons() -- Line: 5312
    -- upvalues: u7 (ref), LocalPlayer (copy), Config (copy), ApplyCurrencyGradient (copy), u8 (copy), ReplicatedStorage (copy), u2 (copy), MarketplaceService (copy), Gamepasses (copy), ApplyBattlepassSeasonEndedState (copy)
    local Battlepass = u7:WaitForChild("Pages"):WaitForChild("Battlepass");
    local Stats = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Stats");
    local u576 = 1;
    local u577 = 5;

    local function UpdateIndexes(p578) -- Line: 5320
        -- upvalues: u576 (ref), u577 (ref)
        u576 = u576 + p578;
        u577 = u577 + p578;

        if u576 >= 1 then
            if u577 > 380 then
                u577 = 380;
                u576 = 376;
            end;

            return;
        end;

        u576 = 1;
        u577 = 5;
    end;

    local function RefreshScrollerTier() -- Line: 5333
        -- upvalues: u576 (ref), u577 (ref), Battlepass (copy), Stats (copy)
        local v579 = 1;

        for i = u576, u577 do
            local v580 = Battlepass.ScrollerTier:FindFirstChild(v579);

            if v580 then
                v580.Tier.Amount.Text = i;

                if i <= Stats:GetAttribute("BattlePassTier") then
                    v580.Tier.Lock.Visible = false;
                    v580.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
                else
                    v580.Tier.Lock.Visible = true;
                    v580.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
                end;

                v579 = v579 + 1;
            end;
        end;
    end;

    local function u589() -- Line: 5353
        -- upvalues: Stats (copy), Config (ref), u576 (ref), u577 (ref), Battlepass (copy), ApplyCurrencyGradient (ref), u8 (ref), ReplicatedStorage (ref), u2 (ref)
        Stats:GetAttribute("BattlePassTier");

        if Config.CheckSeasonActive() ~= true then
            return;
        end;

        local v581 = 1;

        for i = u576, u577 do
            local v582 = Battlepass.Scroller:FindFirstChild(v581);

            if v582 then
                for _, child in pairs(v582:GetChildren()) do
                    if child:IsA("ImageButton") then
                        local Name = child.Name;
                        v582[Name].TextDisplay.Text = "";
                        v582[Name].ImageDisplay.Image = "";
                        ApplyCurrencyGradient(v582[Name].ImageDisplay);
                        local ImageDisplay = v582[Name].ImageDisplay;

                        if ImageDisplay and ImageDisplay:IsA("ImageLabel") then
                            local v583 = u8[""] == true;
                            local v584 = ImageDisplay:GetAttribute("DefaultImageTransparency");

                            if v584 == nil then
                                v584 = ImageDisplay.ImageTransparency;
                                ImageDisplay:SetAttribute("DefaultImageTransparency", v584);
                            end;

                            ImageDisplay.ImageTransparency = v583 and 0 or v584;
                        end;

                        v582[Name].ItemPort:ClearAllChildren();
                        local v585 = Config.BattlepassRewards[Name][i];

                        if v585 then
                            if v585.Type == "Cash" or (v585.Type == "Credit" or v585.Type == "CampaignPoints") then
                                v582[Name].ImageDisplay.Image = Config.CurrencyImage[v585.Type];
                                v582[Name].ImageDisplay.Size = UDim2.new(0.6, 0, 0.6, 0);
                                ApplyCurrencyGradient(v582[Name].ImageDisplay, v585.Type);
                                local ImageDisplay2 = v582[Name].ImageDisplay;
                                local Type = v585.Type;

                                if ImageDisplay2 and ImageDisplay2:IsA("ImageLabel") then
                                    local v586 = u8[Type or ""] == true;
                                    local v587 = ImageDisplay2:GetAttribute("DefaultImageTransparency");

                                    if v587 == nil then
                                        v587 = ImageDisplay2.ImageTransparency;
                                        ImageDisplay2:SetAttribute("DefaultImageTransparency", v587);
                                    end;

                                    ImageDisplay2.ImageTransparency = v586 and 0 or v587;
                                end;
                            else
                                local v588 = Config.GetItemDataFromObject(ReplicatedStorage.Items[v585.Type][v585.Name]);

                                if v585.Weapon then
                                    v588.Weapon = v585.Weapon;
                                end;

                                u2.AddItemToViewport(v588, v582[Name].ItemPort);
                            end;

                            child:SetAttribute("Index", i);
                        end;
                    end;
                end;

                v581 = v581 + 1;
            end;
        end;
    end;

    local function ConfigInfo() -- Line: 5425
        -- upvalues: Battlepass (copy), Config (ref), u2 (ref), Stats (copy), RefreshScrollerTier (copy), ApplyBattlepassSeasonEndedState (ref)
        Battlepass.SeasonBackground.Image = Config.SeasonImage;

        local function RefreshTier() -- Line: 5428
            -- upvalues: u2 (ref), Battlepass (ref), Stats (ref), Config (ref)
            u2.RefreshPlayBattlepassSummary();
            Battlepass.Tier.Text = "TIER " .. Stats:GetAttribute("BattlePassTier") .. "/380";
            Battlepass.ExperienceBar.Bar.Size = UDim2.new(Stats:GetAttribute("BattlePassExperience") / Config.BattlepassExperienceToHit, 0, 1, 0);
            Battlepass.Experience.Text = Stats:GetAttribute("BattlePassExperience") .. "/" .. Config.BattlepassExperienceToHit;
        end;

        RefreshTier();
        Stats:GetAttributeChangedSignal("BattlePassExperience"):Connect(function() -- Line: 5436
            -- upvalues: RefreshTier (copy), RefreshScrollerTier (ref)
            RefreshTier();
            RefreshScrollerTier();
        end);
        Stats:GetAttributeChangedSignal("BattlePassTier"):Connect(function() -- Line: 5440
            -- upvalues: RefreshTier (copy), RefreshScrollerTier (ref)
            RefreshTier();
            RefreshScrollerTier();
        end);

        if Config.CheckSeasonActive() ~= true then
            ApplyBattlepassSeasonEndedState(Battlepass);

            return;
        end;

        local SeasonInfo = Battlepass.SeasonInfo;
        local v590 = Config.SeasonEndDate - Config.GetCurrentDay();
        SeasonInfo.Text = math.clamp(v590, 0, (1 / 0)) .. " Days left to end of Season " .. Config.Season;
    end;

    local function ConfigScrollerButtons() -- Line: 5452
        -- upvalues: Battlepass (copy), Config (ref), ApplyCurrencyGradient (ref), u8 (ref), ReplicatedStorage (ref), u2 (ref)
        for _, child in pairs(Battlepass.Scroller:GetChildren()) do
            if child:IsA("ImageButton") then
                for _, child2 in pairs(child:GetChildren()) do
                    if child2:IsA("ImageButton") then
                        child2.Activated:Connect(function() -- Line: 5459
                            -- upvalues: child2 (copy), Config (ref), Battlepass (ref), ApplyCurrencyGradient (ref), u8 (ref), ReplicatedStorage (ref), u2 (ref)
                            local v591 = child2:GetAttribute("Index");
                            local v592 = Config.BattlepassRewards[child2.Name][v591];
                            Battlepass.Details.TextDisplay.Text = "";
                            Battlepass.Details.Title.Text = "";
                            Battlepass.Details.RarityName.Text = "";
                            Battlepass.Details.ImageDisplay.Image = "";
                            ApplyCurrencyGradient(Battlepass.Details.ImageDisplay);
                            local ImageDisplay = Battlepass.Details.ImageDisplay;

                            if ImageDisplay and ImageDisplay:IsA("ImageLabel") then
                                local v593 = u8[""] == true;
                                local v594 = ImageDisplay:GetAttribute("DefaultImageTransparency");

                                if v594 == nil then
                                    v594 = ImageDisplay.ImageTransparency;
                                    ImageDisplay:SetAttribute("DefaultImageTransparency", v594);
                                end;

                                ImageDisplay.ImageTransparency = v593 and 0 or v594;
                            end;

                            Battlepass.Details.ItemPort:ClearAllChildren();

                            if not v592 then
                                return;
                            end;

                            if v592.Type == "Cash" or (v592.Type == "Credit" or v592.Type == "CampaignPoints") then
                                Battlepass.Details.ImageDisplay.Image = Config.CurrencyImage[v592.Type];
                                ApplyCurrencyGradient(Battlepass.Details.ImageDisplay, v592.Type);
                                local ImageDisplay2 = Battlepass.Details.ImageDisplay;
                                local Type = v592.Type;

                                if ImageDisplay2 and ImageDisplay2:IsA("ImageLabel") then
                                    local v595 = u8[Type or ""] == true;
                                    local v596 = ImageDisplay2:GetAttribute("DefaultImageTransparency");

                                    if v596 == nil then
                                        v596 = ImageDisplay2.ImageTransparency;
                                        ImageDisplay2:SetAttribute("DefaultImageTransparency", v596);
                                    end;

                                    ImageDisplay2.ImageTransparency = v595 and 0 or v596;
                                end;

                                Battlepass.Details.Title.Text = v592.Name .. " " .. v592.Amount;

                                return;
                            end;

                            Battlepass.Details.Title.Text = v592.Name;
                            local v597 = ReplicatedStorage.Items[v592.Type][v592.Name];

                            if not v597 then
                                return;
                            end;

                            Battlepass.Details.RarityName.Text = v597:GetAttribute("Rarity");
                            local v598 = Config.GetItemDataFromObject(v597);

                            if v592.Weapon then
                                v598.Weapon = v592.Weapon;
                            end;

                            u2.AddItemToViewport(v598, Battlepass.Details.ItemPort);
                        end);
                    end;
                end;
            end;
        end;
    end;

    (function() -- Line: 5395, Name: ConfigButtons
        -- upvalues: Battlepass (copy), MarketplaceService (ref), LocalPlayer (ref), Gamepasses (ref), u577 (ref), u576 (ref), RefreshScrollerTier (copy), u589 (copy)
        Battlepass.Buy.Activated:Connect(function() -- Line: 5396
            -- upvalues: MarketplaceService (ref), LocalPlayer (ref), Gamepasses (ref)
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, Gamepasses.GamePasses.BattlePass.ID);
        end);
        Battlepass.Skip1.Activated:Connect(function() -- Line: 5400
            -- upvalues: MarketplaceService (ref), LocalPlayer (ref), Gamepasses (ref)
            MarketplaceService:PromptProductPurchase(LocalPlayer, Gamepasses.GamePasses.Skip1.ID);
        end);
        Battlepass.Skip5.Activated:Connect(function() -- Line: 5404
            -- upvalues: MarketplaceService (ref), LocalPlayer (ref), Gamepasses (ref)
            MarketplaceService:PromptProductPurchase(LocalPlayer, Gamepasses.GamePasses.Skip5.ID);
        end);
        Battlepass.Next.Activated:Connect(function() -- Line: 5408
            -- upvalues: u577 (ref), u576 (ref), RefreshScrollerTier (ref), u589 (ref)
            if u577 < 380 then
                u576 = u576 + 5;
                u577 = u577 + 5;

                if u576 < 1 then
                    u576 = 1;
                    u577 = 5;
                elseif u577 > 380 then
                    u577 = 380;
                    u576 = 376;
                end;

                RefreshScrollerTier();
                u589();
            end;
        end);
        Battlepass.Previous.Activated:Connect(function() -- Line: 5416
            -- upvalues: u576 (ref), u577 (ref), RefreshScrollerTier (ref), u589 (ref)
            if u576 > 1 then
                u576 = u576 + -5;
                u577 = u577 + -5;

                if u576 < 1 then
                    u576 = 1;
                    u577 = 5;
                elseif u577 > 380 then
                    u577 = 380;
                    u576 = 376;
                end;

                RefreshScrollerTier();
                u589();
            end;
        end);
    end)();
    ConfigInfo();
    ConfigScrollerButtons();
    RefreshScrollerTier();
    u589();
end;

function u2.RefreshProfileFrame(p599, p600) -- Line: 5506
    -- upvalues: ReplicatedStorage (copy), Config (copy), Rank (copy)
    if not p599 then
        p600.Banner.Image = "";
        p600.PlayerImage.Image = "";
        p600.GangImag.Image = "";

        for _, child in pairs(p600:GetChildren()) do
            if not child:IsA("TextLabel") and child.Name ~= "InfoTitle" then
                child.Text = "";
            end;
        end;

        p600.DisplayName.Text = "Nil";
        p600.PlayerName.Text = "Player not in server";
        p600.Scroller.Visible = false;

        return;
    end;

    p600.Scroller.Visible = true;
    local PlayerData = p599:WaitForChild("PlayerData");
    local Stats = PlayerData:WaitForChild("Stats");
    local ServerData = p599:WaitForChild("ServerData");
    local Gang = PlayerData:WaitForChild("Gang");
    p600.DisplayName.Text = p599.DisplayName;
    p600.PlayerName.Text = p599.Name .. " l " .. Stats:GetAttribute("Level");
    local v601 = ReplicatedStorage.Items.Banner:FindFirstChild(PlayerData.Loadout:FindFirstChild(PlayerData.Settings:GetAttribute("LoadoutName")):GetAttribute("Banner"));

    if v601 then
        p600.Banner.Image = v601.Texture;
        p600.BannerBackground.Image = v601.Texture;
    else
        p600.Banner.Image = "";
    end;

    p600.PlayerImage.Image = ServerData:GetAttribute("ProfilePicture") or "";
    p600.GangName.Text = Gang:GetAttribute("Name") .. " [" .. Gang:GetAttribute("Tag") .. "]";
    p600.GangName.TextColor3 = Color3.fromRGB(Gang:GetAttribute("ColorR"), Gang:GetAttribute("ColorG"), Gang:GetAttribute("ColorB"));
    p600.GangRole.Text = Gang:GetAttribute("Role");
    local v602 = Gang:GetAttribute("Icon") or "";

    if string.sub(v602, 1, 13) == "rbxassetid://" then
        p600.GangImage.Image = v602;
    elseif v602 == "" then
        p600.GangImage.Image = "";
    else
        p600.GangImage.Image = "rbxassetid://" .. v602;
    end;

    p600.KDR.Text = Config.RoundTo(Stats:GetAttribute("KDR") or 0, 1);
    local Commends = p600.Commends;
    local v603 = #PlayerData.Commend:GetChildren();
    Commends.Text = tostring(v603);
    p600.Damage.Text = Config.toSuffixString(Stats:GetAttribute("Damage"));
    p600.Season.Text = "SEASON " .. Config.Season;
    p600.RankedKDR.Text = Config.RoundTo(Stats:GetAttribute("KDRRanked") or 0, 1);
    local v604, _ = Rank.GetRankedImage(Stats:GetAttribute("RankedRating"));
    p600.RankedImage.Image = "rbxassetid://" .. v604;
end;

function u2.ConfigGangPage() -- Line: 5565
    -- upvalues: u7 (ref), LocalPlayer (copy), Config (copy), Players (copy), u2 (copy), ReplicatedStorage (copy), SoundService (copy)
    local Gang = u7:WaitForChild("Pages"):WaitForChild("Gang");
    local PlayerData = LocalPlayer:WaitForChild("PlayerData");
    local Stats = PlayerData:WaitForChild("Stats");
    local u605 = nil;
    local u606 = nil;
    local u607 = false;

    local function canInvite(p608) -- Line: 5574
        return p608 == "Founder" and true or p608 == "Captain";
    end;

    local function canManage(p609, p610) -- Line: 5578
        if p609 == "Founder" then
            return p610 ~= "Founder";
        end;

        if p609 == "Captain" then
            return p610 == "Senior" and true or p610 == "Member";
        end;

        return false;
    end;

    local function normalizeGangImage(p611) -- Line: 5588
        if typeof(p611) ~= "string" or p611 == "" then
            return "";
        end;

        if string.sub(p611, 1, 13) == "rbxassetid://" then
            return p611;
        end;

        return "rbxassetid://" .. p611;
    end;

    local function formatRatio(p612, p613) -- Line: 5598
        -- upvalues: Config (ref)
        local v614 = tonumber(p613) or 0;
        local v615 = math.max(v614, 1);

        return Config.RoundTo((tonumber(p612) or 0) / v615, 1);
    end;

    local function setProfileActionButtonsVisible() -- Line: 5603
        -- upvalues: PlayerData (copy), u605 (ref), Gang (copy)
        local v616 = PlayerData.Gang:GetAttribute("Role");
        local v617 = u605 and u605.Role or "";
        local v618;

        if u605 == nil then
            v618 = false;
        elseif v616 == "Founder" then
            v618 = v617 ~= "Founder";
        elseif v616 == "Captain" then
            v618 = v617 == "Senior" and true or v617 == "Member";
        else
            v618 = false;
        end;

        Gang.ProfileFrame.Scroller.Invite.Visible = false;
        Gang.ProfileFrame.Scroller.Promote.Visible = false;
        Gang.ProfileFrame.Scroller.Demote.Visible = false;
        Gang.ProfileFrame.Scroller.Kick.Visible = false;

        if not v618 then
            return;
        end;

        if v616 ~= "Founder" then
            if v616 == "Captain" then
                if v617 == "Member" then
                    Gang.ProfileFrame.Scroller.Promote.Visible = true;
                    Gang.ProfileFrame.Scroller.Kick.Visible = true;

                    return;
                end;

                if v617 == "Senior" then
                    Gang.ProfileFrame.Scroller.Demote.Visible = true;
                    Gang.ProfileFrame.Scroller.Kick.Visible = true;
                end;
            end;

            return;
        end;

        if v617 == "Member" then
            Gang.ProfileFrame.Scroller.Promote.Visible = true;
        elseif v617 == "Senior" then
            Gang.ProfileFrame.Scroller.Promote.Visible = true;
            Gang.ProfileFrame.Scroller.Demote.Visible = true;
        elseif v617 == "Captain" then
            Gang.ProfileFrame.Scroller.Demote.Visible = true;
        end;

        Gang.ProfileFrame.Scroller.Kick.Visible = true;
    end;

    local function renderOfflineProfile(p619) -- Line: 5638
        -- upvalues: Gang (copy), u606 (ref), Config (ref), setProfileActionButtonsVisible (copy)
        Gang.ProfileFrame.Banner.Image = "";
        Gang.ProfileFrame.PlayerImage.Image = p619.ProfilePicture or "";
        local GangImage = Gang.ProfileFrame.GangImage;
        local Image = Gang.GangFrame.GangIcon.Image;

        if typeof(Image) == "string" and Image ~= "" then
            if string.sub(Image, 1, 13) ~= "rbxassetid://" then
                Image = "rbxassetid://" .. Image;
            end;
        else
            Image = "";
        end;

        GangImage.Image = Image;
        Gang.ProfileFrame.DisplayName.Text = p619.DisplayName ~= "" and p619.DisplayName or (p619.Name or "Unknown");
        Gang.ProfileFrame.PlayerName.Text = (p619.Name or "Unknown") .. " l Offline";
        Gang.ProfileFrame.GangName.Text = (u606 and u606.Name or "") .. " [" .. (u606 and u606.Tag or "") .. "]";
        Gang.ProfileFrame.GangName.TextColor3 = Color3.fromRGB(u606 and u606.ColorR or 200, u606 and u606.ColorG or 200, u606 and u606.ColorB or 200);
        Gang.ProfileFrame.GangRole.Text = p619.Role or "";
        Gang.ProfileFrame.KDR.Text = "";
        Gang.ProfileFrame.Commends.Text = "";
        Gang.ProfileFrame.Damage.Text = "";
        Gang.ProfileFrame.RankedKDR.Text = "";
        Gang.ProfileFrame.RankedImage.Image = "";
        Gang.ProfileFrame.Season.Text = "SEASON " .. Config.Season;
        Gang.ProfileFrame.Scroller.Visible = true;
        setProfileActionButtonsVisible();
    end;

    local function _() -- Line: 5657
        -- upvalues: u605 (ref), Players (ref), u2 (ref), Gang (copy), setProfileActionButtonsVisible (copy), renderOfflineProfile (copy)
        if u605 == nil then
            return;
        end;

        local v620 = Players:GetPlayerByUserId(tonumber(u605.UserId) or 0);

        if not v620 then
            renderOfflineProfile(u605);

            return;
        end;

        u2.RefreshProfileFrame(v620, Gang.ProfileFrame);
        setProfileActionButtonsVisible();
    end;

    local function populateInviteList() -- Line: 5671
        -- upvalues: Gang (copy), Players (ref), LocalPlayer (ref), ReplicatedStorage (ref), Config (ref), SoundService (ref), u607 (ref)
        for _, child in pairs(Gang.GangFrame.InviteList.List:GetChildren()) do
            if child:IsA("ImageButton") then
                child:Destroy();
            end;
        end;

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and (v:FindFirstChild("PlayerData") and (v:FindFirstChild("ServerData") and v.PlayerData.Gang:GetAttribute("Name") == "")) then
                local v621 = script.SamplePartyList:Clone();
                v621.Name = v.Name;
                v621.Title.Text = v.DisplayName;
                v621.Display.Image = v.ServerData:GetAttribute("ProfilePicture") or "";
                v621.Parent = Gang.GangFrame.InviteList.List;
                local v622 = ReplicatedStorage.Items.Banner:FindFirstChild(v.PlayerData.Loadout:FindFirstChild(v.PlayerData.Settings:GetAttribute("LoadoutName")):GetAttribute("Banner"));

                if v622 then
                    v621.Banner.Image = v622.Texture;
                else
                    v621.Banner.Image = "";
                end;

                if v:IsFriendsWith(LocalPlayer.UserId) then
                    v621.LayoutOrder = 3;
                else
                    v621.LayoutOrder = 1;
                end;

                v621.MouseButton1Down:Connect(function() -- Line: 5700
                    -- upvalues: Config (ref), SoundService (ref), u607 (ref), ReplicatedStorage (ref), v (copy)
                    Config.AddSound("Click_1", 1, true, SoundService, false);

                    if u607 == true then
                        return;
                    end;

                    u607 = true;
                    task.delay(3, function() -- Line: 5706
                        -- upvalues: u607 (ref)
                        u607 = false;
                    end);
                    ReplicatedStorage.Events.GangInvite:FireServer(v);
                end);
            end;
        end;
    end;

    local function RefreshGangPage() -- Line: 5716
        -- upvalues: ReplicatedStorage (ref), u606 (ref), LocalPlayer (ref), Gang (copy), Players (ref), u605 (ref), Config (ref), SoundService (ref), u2 (ref), setProfileActionButtonsVisible (copy), renderOfflineProfile (copy)
        local v623 = ReplicatedStorage.Events.GangDetails:InvokeServer();
        u606 = v623;

        if v623 == nil or v623 == false then
            Gang.GangFrame.Visible = false;
            Gang.CreateFrame.Visible = false;
            Gang.Create.Visible = true;
        else
            local v624;

            if v623.Members then
                v624 = v623.Members[tostring(LocalPlayer.UserId)] or nil;
            else
                v624 = nil;
            end;

            if not v624 then
                Gang.GangFrame.Visible = false;
                Gang.CreateFrame.Visible = false;
                Gang.Create.Visible = true;

                return;
            end;

            Gang.GangFrame.Visible = true;
            Gang.CreateFrame.Visible = false;
            Gang.Create.Visible = false;
            Gang.GangFrame.GangName.Text = v623.Name;
            Gang.GangFrame.GangName.TextColor3 = Color3.fromRGB(v623.ColorR, v623.ColorG, v623.ColorB);
            Gang.GangFrame.Role.Text = v624.Role;
            Gang.GangFrame.Description.Text = v623.Description;
            Gang.GangFrame.Tag.Text = v623.Tag;
            Gang.GangFrame.Reputation.Text = tostring(v623.Reputation or 0) .. " REP";
            Gang.GangFrame.GangColor.BackgroundColor3 = Color3.fromRGB(v623.ColorR, v623.ColorG, v623.ColorB);
            Gang:SetAttribute("CoverColor2", Color3.fromRGB(v623.ColorR, v623.ColorG, v623.ColorB));
            Gang.GangFrame.Edit.Visible = v624.Role == "Founder";
            local Role = v624.Role;
            Gang.GangFrame.InviteButton.Visible = Role == "Founder" and true or Role == "Captain";
            Gang.GangFrame.InviteList.Visible = false;
            local GangIcon = Gang.GangFrame.GangIcon;
            local Icon = v623.Icon;

            if typeof(Icon) == "string" and Icon ~= "" then
                if string.sub(Icon, 1, 13) ~= "rbxassetid://" then
                    Icon = "rbxassetid://" .. Icon;
                end;
            else
                Icon = "";
            end;

            GangIcon.Image = Icon;

            for _, child in pairs(Gang.GangFrame.Members:GetChildren()) do
                if child:IsA("ImageButton") then
                    child:Destroy();
                end;
            end;

            local v625 = {};

            for i, v in pairs(v623.Members or {}) do
                local v626 = v.LastKnownName or "Unknown";
                local v627 = Players:GetPlayerByUserId(tonumber(i) or 0);
                local v628 = {
                    UserId = tonumber(i) or 0,
                    Name = v626,
                    DisplayName = v.DisplayName or "",
                    Role = v.Role or "Member",
                    Reputation = v.Reputation or 0,
                    ProfilePicture = v.ProfilePicture or "",
                    Online = v627 ~= nil
                };
                table.insert(v625, v628);
            end;

            table.sort(v625, function(p629, p630) -- Line: 5768
                local v631 = {
                    Founder = 1,
                    Captain = 2,
                    Senior = 3,
                    Member = 4
                };
                local v632 = v631[p629.Role] or 9;
                local v633 = v631[p630.Role] or 9;

                if p629.Online == p630.Online then
                    if v632 == v633 then
                        return p629.Name < p630.Name;
                    end;

                    return v632 < v633;
                end;

                return p629.Online and not p630.Online;
            end);
            local v634 = nil;

            if u605 ~= nil then
                for _, v in ipairs(v625) do
                    if v.UserId == u605.UserId then
                        v634 = v;
                        break;
                    end;
                end;

                u605 = v634;

                if v634 == nil then
                    Gang.ProfileFrame.Visible = false;
                end;
            end;

            for _, v in ipairs(v625) do
                local v635 = script.SampleGangMember:Clone();
                v635.Parent = Gang.GangFrame.Members;
                v635.ProfilePicture.Image = v.ProfilePicture;
                v635.Role.Text = v.Role;
                v635.Reputation.Text = tostring(v.Reputation or 0) .. " REP ";
                v635.PlayerName.Text = v.Name;
                v635.StatusColor.Visible = v.Online;

                if v.Online then
                    v635.Status.Text = "In Lobby";
                    v635.Status.TextColor3 = Color3.fromRGB(100, 200, 20);
                    v635.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
                else
                    v635.Status.Text = "Offline";
                    v635.Status.TextColor3 = Color3.fromRGB(190, 190, 190);
                    v635.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
                end;

                if v.UserId == LocalPlayer.UserId then
                    v635.BackgroundColor3 = Color3.fromRGB(60, 60, 60);
                end;

                v635.Activated:Connect(function() -- Line: 5818
                    -- upvalues: Config (ref), SoundService (ref), u605 (ref), v (copy), Gang (ref), Players (ref), u2 (ref), setProfileActionButtonsVisible (ref), renderOfflineProfile (ref)
                    Config.AddSound("Click_2", 1, true, SoundService, false);
                    u605 = v;
                    Gang.ProfileFrame.Visible = true;

                    if u605 == nil then
                        return;
                    end;

                    local v636 = Players:GetPlayerByUserId(tonumber(u605.UserId) or 0);

                    if not v636 then
                        renderOfflineProfile(u605);

                        return;
                    end;

                    u2.RefreshProfileFrame(v636, Gang.ProfileFrame);
                    setProfileActionButtonsVisible();
                end);
            end;

            if u605 ~= nil and Gang.ProfileFrame.Visible == true then
                if u605 == nil then
                    return;
                end;

                local v637 = Players:GetPlayerByUserId(tonumber(u605.UserId) or 0);

                if not v637 then
                    renderOfflineProfile(u605);

                    return;
                end;

                u2.RefreshProfileFrame(v637, Gang.ProfileFrame);
                setProfileActionButtonsVisible();
            end;
        end;
    end;

    (function() -- Line: 5836, Name: ConfigGangButtons
        -- upvalues: Gang (copy), Config (ref), SoundService (ref), LocalPlayer (ref), populateInviteList (copy), u605 (ref), ReplicatedStorage (ref)
        Gang.Create.Activated:Connect(function() -- Line: 5837
            -- upvalues: Config (ref), SoundService (ref), Gang (ref)
            Config.AddSound("Click_1", 1, true, SoundService, false);
            Gang.Create.Visible = false;
            Gang.CreateFrame.Visible = true;
            Gang.CreateFrame.Create:SetAttribute("Action", "Create");
            Gang.CreateFrame.Create.Cost.Visible = true;
        end);
        Gang.CreateFrame.Back.Activated:Connect(function() -- Line: 5845
            -- upvalues: Config (ref), SoundService (ref), Gang (ref)
            Config.AddSound("Click_3", 1, true, SoundService, false);

            if Gang.CreateFrame.Create:GetAttribute("Action") ~= "Create" then
                if Gang.CreateFrame.Create:GetAttribute("Action") == "Edit" then
                    Gang.CreateFrame.Visible = false;
                    Gang.GangFrame.Visible = true;
                end;

                return;
            end;

            Gang.CreateFrame.Visible = false;
            Gang.Create.Visible = true;
        end);
        Gang.CreateFrame.IconOption.Activated:Connect(function() -- Line: 5856
            -- upvalues: Gang (ref)
            Gang.CreateFrame.IconScroller.Visible = not Gang.CreateFrame.IconScroller.Visible;
        end);

        for _, child in pairs(Gang.CreateFrame.IconScroller:GetChildren()) do
            if child:IsA("ImageButton") then
                child.Activated:Connect(function() -- Line: 5862
                    -- upvalues: Gang (ref), child (copy)
                    Gang.CreateFrame.GangIcon.Image = child.Image;
                    Gang.CreateFrame.Icon.Text = child.Image;
                end);
            end;
        end;

        Gang.CreateFrame.Create.Activated:Connect(function() -- Line: 5869
            -- upvalues: Gang (ref)
            if Gang.CreateFrame.Create:GetAttribute("Action") == "Edit" then
                Gang.Prompt:SetAttribute("Event", "Edit");
                Gang.Prompt.Title.Text = "Confirm edit?";
                Gang.Prompt.Visible = true;

                return;
            end;

            Gang.Prompt:SetAttribute("Event", "Create");
            Gang.Prompt.Title.Text = "Confirm create? Name & Tag cannot be changed. Inappropriate gang name can result in permanent ban!";
            Gang.Prompt.Visible = true;
        end);

        for _, v in pairs({ Gang.CreateFrame.Red, Gang.CreateFrame.Green, Gang.CreateFrame.Blue }) do
            v.FocusLost:Connect(function() -- Line: 5882
                -- upvalues: Gang (ref)
                local v638 = tonumber(Gang.CreateFrame.Red.Text) or 0;
                local v639 = tonumber(Gang.CreateFrame.Green.Text) or 0;
                local v640 = tonumber(Gang.CreateFrame.Blue.Text) or 0;
                Gang.CreateFrame.ColorDisplay.BackgroundColor3 = Color3.fromRGB(v638, v639, v640);
            end);
        end;

        Gang.GangFrame.Edit.Activated:Connect(function() -- Line: 5890
            -- upvalues: Gang (ref)
            Gang.CreateFrame.Visible = true;
            Gang.GangFrame.Visible = false;
            Gang.CreateFrame.Create:SetAttribute("Action", "Edit");
            Gang.CreateFrame.GangName.Text = Gang.GangFrame.GangName.Text;
            Gang.CreateFrame.Description.Text = Gang.GangFrame.Description.Text;
            Gang.CreateFrame.GangIcon.Image = Gang.GangFrame.GangIcon.Image;
            Gang.CreateFrame.Icon.Text = Gang.GangFrame.GangIcon.Image;
            Gang.CreateFrame.Tag.Text = Gang.GangFrame.Tag.Text;
            Gang.CreateFrame.GangName.TextEditable = false;
            Gang.CreateFrame.GangName.ClearTextOnFocus = false;
            Gang.CreateFrame.Tag.TextEditable = false;
            Gang.CreateFrame.Tag.ClearTextOnFocus = false;
            Gang.CreateFrame.GangName.BackgroundColor3 = Color3.fromRGB(60, 65, 65);
            Gang.CreateFrame.Tag.BackgroundColor3 = Color3.fromRGB(60, 65, 65);
            Gang.CreateFrame.Red.Text = math.floor(Gang.GangFrame.GangColor.BackgroundColor3.R * 255);
            Gang.CreateFrame.Green.Text = math.floor(Gang.GangFrame.GangColor.BackgroundColor3.G * 255);
            Gang.CreateFrame.Blue.Text = math.floor(Gang.GangFrame.GangColor.BackgroundColor3.B * 255);
            Gang.CreateFrame.ColorDisplay.BackgroundColor3 = Gang.GangFrame.GangColor.BackgroundColor3;
            Gang.CreateFrame.Create.Title.Text = "CONFIRM";
            Gang.CreateFrame.Create.Cost.Visible = false;
        end);
        Gang.GangFrame.Leave.Activated:Connect(function() -- Line: 5913
            -- upvalues: LocalPlayer (ref), Gang (ref)
            if LocalPlayer.PlayerData.Gang:GetAttribute("Role") == "Founder" then
                Gang.Prompt:SetAttribute("Event", "Delete");
                Gang.Prompt.Visible = true;
                Gang.Prompt.Title.Text = "Confirm delete gang " .. Gang.GangFrame.GangName.Text .. " [" .. Gang.GangFrame.Tag.Text .. "]? Action cannot be reversed";

                return;
            end;

            Gang.Prompt:SetAttribute("Event", "Leave");
            Gang.Prompt.Visible = true;
            Gang.Prompt.Title.Text = "Confirm leave gang " .. Gang.GangFrame.GangName.Text .. " [" .. Gang.GangFrame.Tag.Text .. "]?";
        end);
        Gang.GangFrame.InviteButton.Activated:Connect(function() -- Line: 5925
            -- upvalues: Gang (ref), populateInviteList (ref)
            if Gang.GangFrame.InviteButton.Visible ~= true then
                return;
            end;

            Gang.GangFrame.InviteList.Visible = not Gang.GangFrame.InviteList.Visible;

            if Gang.GangFrame.InviteList.Visible then
                populateInviteList();
            end;
        end);
        Gang.GangFrame.InviteList.ButtonBlocker.Activated:Connect(function() -- Line: 5935
            -- upvalues: Gang (ref)
            Gang.GangFrame.InviteList.Visible = false;
        end);
        Gang.ProfileFrame.Scroller.Cancel.Activated:Connect(function() -- Line: 5939
            -- upvalues: Gang (ref), u605 (ref)
            Gang.ProfileFrame.Visible = false;
            u605 = nil;
        end);
        Gang.ProfileFrame.Scroller.Promote.Activated:Connect(function() -- Line: 5944
            -- upvalues: Config (ref), SoundService (ref), u605 (ref), Gang (ref), ReplicatedStorage (ref)
            Config.AddSound("Click_2", 1, true, SoundService, false);

            if u605 == nil then
                return;
            end;

            Gang.ProfileFrame.Visible = false;
            ReplicatedStorage.Events.GangUpdate:FireServer("Promote", {
                UserId = u605.UserId,
                Name = u605.Name
            });
            u605 = nil;
        end);
        Gang.ProfileFrame.Scroller.Demote.Activated:Connect(function() -- Line: 5952
            -- upvalues: Config (ref), SoundService (ref), u605 (ref), Gang (ref), ReplicatedStorage (ref)
            Config.AddSound("Click_2", 1, true, SoundService, false);

            if u605 == nil then
                return;
            end;

            Gang.ProfileFrame.Visible = false;
            ReplicatedStorage.Events.GangUpdate:FireServer("Demote", {
                UserId = u605.UserId,
                Name = u605.Name
            });
            u605 = nil;
        end);
        Gang.ProfileFrame.Scroller.Kick.Activated:Connect(function() -- Line: 5960
            -- upvalues: Config (ref), SoundService (ref), u605 (ref), Gang (ref), ReplicatedStorage (ref)
            Config.AddSound("Click_2", 1, true, SoundService, false);

            if u605 == nil then
                return;
            end;

            Gang.ProfileFrame.Visible = false;
            ReplicatedStorage.Events.GangUpdate:FireServer("Kick", {
                UserId = u605.UserId,
                Name = u605.Name
            });
            u605 = nil;
        end);
        Gang.Prompt.Accept.Activated:Connect(function() -- Line: 5968
            -- upvalues: Gang (ref), ReplicatedStorage (ref)
            local v641 = Gang.Prompt:GetAttribute("Event");

            if v641 == "Delete" then
                ReplicatedStorage.Events.GangUpdate:FireServer("Delete");
            elseif v641 == "Leave" then
                ReplicatedStorage.Events.GangUpdate:FireServer("Leave");
            elseif v641 == "Edit" then
                ReplicatedStorage.Events.GangUpdate:FireServer("Edit", {
                    Description = Gang.CreateFrame.Description.Text,
                    ColorR = Gang.CreateFrame.Red.Text,
                    ColorG = Gang.CreateFrame.Green.Text,
                    ColorB = Gang.CreateFrame.Blue.Text,
                    Icon = Gang.CreateFrame.Icon.Text
                });
            elseif v641 == "Create" then
                ReplicatedStorage.Events.GangUpdate:FireServer("Create", {
                    Name = Gang.CreateFrame.GangName.Text,
                    Description = Gang.CreateFrame.Description.Text,
                    Tag = Gang.CreateFrame.Tag.Text,
                    ColorR = Gang.CreateFrame.Red.Text,
                    ColorG = Gang.CreateFrame.Green.Text,
                    ColorB = Gang.CreateFrame.Blue.Text,
                    Icon = Gang.CreateFrame.Icon.Text
                });
            end;

            Gang.Prompt:SetAttribute("Event", nil);
            Gang.Prompt.Visible = false;
        end);
        Gang.Prompt.Cancel.Activated:Connect(function() -- Line: 5997
            -- upvalues: Gang (ref)
            Gang.Prompt:SetAttribute("Event", nil);
            Gang.Prompt.Visible = false;
        end);
    end)();
    Gang:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 6005
        -- upvalues: Gang (copy), RefreshGangPage (copy), Stats (copy)
        if Gang.Visible == false then
            return;
        end;

        RefreshGangPage();

        if Stats:GetAttribute("GangTOS") == 0 then
            Gang.GangTOS.Visible = true;
        end;
    end);
    Gang.GangTOS.Accept.MouseButton1Down:Connect(function() -- Line: 6013
        -- upvalues: Config (ref), SoundService (ref), Stats (copy), ReplicatedStorage (ref), Gang (copy)
        Config.AddSound("Click_2", 1, true, SoundService, false);

        if Stats:GetAttribute("GangTOS") == 0 then
            ReplicatedStorage.Events.ShowGangTOS:FireServer();
            Gang.GangTOS.Visible = false;
        end;
    end);
    Gang.ProfileFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 6021
        -- upvalues: Gang (copy), u605 (ref), Players (ref), u2 (ref), setProfileActionButtonsVisible (copy), renderOfflineProfile (copy)
        if Gang.Visible == false or Gang.ProfileFrame.Visible == false then
            return;
        end;

        if u605 == nil then
            return;
        end;

        local v642 = Players:GetPlayerByUserId(tonumber(u605.UserId) or 0);

        if not v642 then
            renderOfflineProfile(u605);

            return;
        end;

        u2.RefreshProfileFrame(v642, Gang.ProfileFrame);
        setProfileActionButtonsVisible();
    end);
    ReplicatedStorage.Events.Action.OnClientEvent:Connect(function(p643) -- Line: 6026
        -- upvalues: Gang (copy), RefreshGangPage (copy)
        if p643 == "RefreshGang" and Gang.Visible == true then
            RefreshGangPage();
        end;
    end);
end;

function u2.ConfigServersPage() -- Line: 6033
    -- upvalues: u7 (ref), LocalPlayer (copy), ReplicatedStorage (copy), u2 (copy), Config (copy), SoundService (copy)
    local Servers = u7:WaitForChild("Pages"):WaitForChild("Servers");
    local PlayerData = LocalPlayer:WaitForChild("PlayerData");
    local ServerList = ReplicatedStorage.Server:WaitForChild("ServerList");
    local u644 = 0;

    local function buildServerEntriesFromCache(p645) -- Line: 6039
        -- upvalues: ServerList (copy)
        local v646 = ServerList:FindFirstChild(p645);

        if not v646 then
            return {};
        end;

        local v647 = {};

        for _, child in ipairs(v646:GetChildren()) do
            local v648 = child:GetAttributes();
            v648.Code = v648.Code or child.Name;
            v648.GameMode = v648.GameMode or p645;
            table.insert(v647, v648);
        end;

        table.sort(v647, function(p649, p650) -- Line: 6053
            local v651 = tonumber(p649.PlayerCount) or (tonumber(p649.BluePlayers) or 0) + (tonumber(p649.RedPlayers) or 0);
            local v652 = tonumber(p650.PlayerCount) or (tonumber(p650.BluePlayers) or 0) + (tonumber(p650.RedPlayers) or 0);

            if v651 == v652 then
                return tostring(p649.Code or "") < tostring(p650.Code or "");
            end;

            return v652 < v651;
        end);

        return v647;
    end;

    (function() -- Line: 6065, Name: ConfigServerPrompt
        -- upvalues: Servers (copy), ReplicatedStorage (ref), u7 (ref), u2 (ref)
        Servers.Prompt.Accept.Activated:Connect(function() -- Line: 6066
            -- upvalues: Servers (ref), ReplicatedStorage (ref), u7 (ref), u2 (ref)
            local v653 = Servers.Prompt:GetAttribute("Event");
            print("[CLIENT PROMPT ACCEPT]", v653);

            if v653 == "Join" then
                local v654 = ReplicatedStorage.Events.JoinServer:GetAttribute("Code");
                local v655 = ReplicatedStorage.Events.JoinServer:GetAttribute("GameMode");
                print("[CLIENT FIRE JOIN]", "GameMode:", v655, "Code:", v654, "Password:", Servers.Prompt.Input.Text);

                if v654 == nil or v654 == "" then
                    warn("[CLIENT FIRE JOIN FAILED] Code is empty/nil");
                else
                    local Play = u7.Pages:FindFirstChild("Play");

                    if Play then
                        if v655 == "Casual" then
                            local Quickmatch = Play:FindFirstChild("Quickmatch");

                            if Quickmatch then
                                Quickmatch:SetAttribute("Gamemode", "Casual");
                            end;

                            Play:SetAttribute("PendingDirectJoinGamemode", "Casual");
                        elseif v655 == "Custom" then
                            Play:SetAttribute("PendingCustomAction", "Joining Custom");
                        end;
                    end;

                    if v655 == "Casual" or v655 == "Custom" then
                        u2.OpenPage("Play");
                    end;

                    ReplicatedStorage.Events.JoinServer:FireServer(v655, v654, Servers.Prompt.Input.Text);
                end;
            end;

            Servers.Prompt:SetAttribute("Event", nil);
            Servers.Prompt.Visible = false;
        end);
        Servers.Prompt.Cancel.Activated:Connect(function() -- Line: 6103
            -- upvalues: Servers (ref)
            Servers.Prompt:SetAttribute("Event", nil);
            Servers.Prompt.Visible = false;
        end);
    end)();

    local function RefreshServerFrame() -- Line: 6111
        -- upvalues: Servers (copy), buildServerEntriesFromCache (copy), ReplicatedStorage (ref)
        local u656 = Servers:GetAttribute("GameMode") or "Casual";

        if u656 == "Ranked" then
            return;
        end;

        local v657 = buildServerEntriesFromCache(u656);

        for _, child in pairs(Servers.ServerFrame.Scroller:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        for i, v in ipairs(v657) do
            local v658 = script.SampleServer:Clone();
            local Code = v.Code;

            if not Code then
                local v659 = #Servers.ServerFrame.Scroller:GetChildren() + 1;
                Code = u656 .. tostring(v659);
            end;

            v658.Name = Code;
            v658.LayoutOrder = i;
            v658.Parent = Servers.ServerFrame.Scroller;
            v658.Map.Text = v.Map or "";
            local v660 = ReplicatedStorage.MapImages:FindFirstChild(v.Map or "");
            v658.Display.Image = v660 == nil and "" or (v660.Texture or "");
            v658.Rounds.Text = "Round  " .. tostring(v.Rounds or 0);
            local v661 = v.MaxPlayers or 0;
            local v662 = tonumber(v.PlayerCount) or (v.BluePlayers or 0) + (v.RedPlayers or 0);

            if v661 > 0 then
                v662 = math.min(v662, v661);
            end;

            local v663 = tostring(v.JoinBlockReason or "");

            if v663 == "full" then
                if v661 > 0 then
                    v662 = v661;
                end;
            end;

            v658.Players.Text = tostring(v662) .. "/" .. tostring(v661);

            if u656 == "Custom" then
                v658.ServerName.Text = v.ServerName or "";
                v658.Host.Text = "Custom";
                v658.Password.Visible = (v.Password or "") ~= "";
                v658.Join.Activated:Connect(function() -- Line: 6198
                    -- upvalues: Servers (ref), v (copy), ReplicatedStorage (ref), u656 (copy)
                    Servers.Prompt:SetAttribute("Event", "Join");
                    Servers.Prompt.Title.Text = "Join server by " .. (v.Host or "unknown") .. "?";
                    Servers.Prompt.Visible = true;
                    Servers.Prompt.Input.Visible = true;
                    ReplicatedStorage.Events.JoinServer:SetAttribute("Code", v.Code or "");
                    ReplicatedStorage.Events.JoinServer:SetAttribute("GameMode", v.GameMode or u656);
                end);
            else
                v658.Host.Text = v.GameMode or u656;

                if v.Status == "Loading" then
                    v658.ServerName.Text = "Loading match";
                elseif v.Status == "PlayersJoining" then
                    v658.ServerName.Text = "Waiting for players";
                elseif v.Status == "Choose Map" then
                    v658.ServerName.Text = "Choosing map";
                else
                    v658.ServerName.Text = v.Region or "";
                end;

                local v664;

                if v.Joinable == true and v663 == "" then
                    v664 = v662 < v661;
                else
                    v664 = false;
                end;

                v658.Join.Active = v664;
                v658.Join.AutoButtonColor = v664;
                v658.Join.Title.Text = v664 and "Join" or ((v663 == "full" or v661 <= v662) and "Full" or (v663 == "expired-heartbeat" and "Refresh" or (v663 == "loading" and "Loading" or (v663 == "reservation-cooldown" and "Busy" or (v663 == "version mismatch" and "Old" or "Locked")))));
                v658.Join.ImageTransparency = v664 and 0 or 0.35;

                if v664 then
                    v658.Join.Activated:Connect(function() -- Line: 6183
                        -- upvalues: Servers (ref), v (copy), ReplicatedStorage (ref), u656 (copy)
                        Servers.Prompt:SetAttribute("Event", "Join");
                        Servers.Prompt.Title.Text = "Join server? [" .. (v.Map or "") .. "] Round " .. tostring(v.Rounds or 0);
                        Servers.Prompt.Visible = true;
                        Servers.Prompt.Input.Visible = false;
                        ReplicatedStorage.Events.JoinServer:SetAttribute("Code", v.Code or "");
                        ReplicatedStorage.Events.JoinServer:SetAttribute("GameMode", v.GameMode or u656);
                    end);
                end;
            end;
        end;

        Servers.ServerFrame.NoServersFoundLabel.Visible = #v657 == 0;
    end;

    local function RefreshGamemodeButtons() -- Line: 6213
        -- upvalues: Servers (copy), u2 (ref)
        local v665 = Servers:GetAttribute("GameMode") or "Casual";

        for _, child in ipairs(Servers.GameModes:GetChildren()) do
            if child:IsA("ImageButton") then
                local v666 = child.Name == v665;
                u2.SetSelectionState(child, v666, Color3.fromRGB(255, 255, 255), Color3.fromRGB(30, 30, 30));
                child.BackgroundColor3 = v666 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 30);
                local Title = child:FindFirstChild("Title");

                if Title and Title:IsA("TextLabel") then
                    Title.TextColor3 = v666 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255);
                end;
            end;
        end;
    end;

    local function ConfigGamemodeButtons() -- Line: 6228
        -- upvalues: Servers (copy), Config (ref), SoundService (ref), RefreshGamemodeButtons (copy), RefreshServerFrame (copy)
        for _, child in ipairs(Servers.GameModes:GetChildren()) do
            if child:IsA("ImageButton") then
                child.Activated:Connect(function() -- Line: 6231
                    -- upvalues: Servers (ref), child (copy), Config (ref), SoundService (ref), RefreshGamemodeButtons (ref), RefreshServerFrame (ref)
                    if Servers:GetAttribute("GameMode") == child.Name then
                        return;
                    end;

                    Config.AddSound("Click_3", 1, true, SoundService, false);
                    Servers:SetAttribute("GameMode", child.Name);
                    RefreshGamemodeButtons();
                    RefreshServerFrame();
                end);
            end;
        end;
    end;

    if Servers:GetAttribute("GameMode") == nil then
        Servers:SetAttribute("GameMode", "Casual");
    end;

    RefreshGamemodeButtons();
    Servers:GetAttributeChangedSignal("GameMode"):Connect(RefreshGamemodeButtons);
    Servers.ServerFrame.Refresh.Activated:Connect(function() -- Line: 6250
        -- upvalues: Config (ref), SoundService (ref), RefreshServerFrame (copy), u2 (ref), Servers (copy)
        Config.AddSound("Click_3", 1, true, SoundService, false);
        RefreshServerFrame();
        u2.AddNotification("Server list refreshed");
        Servers.ServerFrame.Refresh.Visible = false;
        task.wait(2);
        Servers.ServerFrame.Refresh.Visible = true;
    end);

    local function RefreshFromObservedServerList(p667) -- Line: 6259
        -- upvalues: Servers (copy), u644 (ref), RefreshServerFrame (copy)
        if Servers.Visible ~= true then
            return;
        end;

        if (Servers:GetAttribute("GameMode") or "Casual") ~= p667 then
            return;
        end;

        if os.clock() - u644 < 0.5 then
            return;
        end;

        u644 = os.clock();
        RefreshServerFrame();
    end;

    for _, v in ipairs({ "Casual", "Custom" }) do
        local v668 = ServerList:WaitForChild(v);
        v668:GetAttributeChangedSignal("LastHydratedAt"):Connect(function() -- Line: 6275
            -- upvalues: v (copy), Servers (copy), u644 (ref), RefreshServerFrame (copy)
            if Servers.Visible ~= true then
                return;
            end;

            if (Servers:GetAttribute("GameMode") or "Casual") ~= v then
                return;
            end;

            if os.clock() - u644 < 0.5 then
                return;
            end;

            u644 = os.clock();
            RefreshServerFrame();
        end);
        v668.ChildAdded:Connect(function() -- Line: 6278
            -- upvalues: v (copy), Servers (copy), u644 (ref), RefreshServerFrame (copy)
            if Servers.Visible ~= true then
                return;
            end;

            if (Servers:GetAttribute("GameMode") or "Casual") ~= v then
                return;
            end;

            if os.clock() - u644 < 0.5 then
                return;
            end;

            u644 = os.clock();
            RefreshServerFrame();
        end);
        v668.ChildRemoved:Connect(function() -- Line: 6281
            -- upvalues: v (copy), Servers (copy), u644 (ref), RefreshServerFrame (copy)
            if Servers.Visible ~= true then
                return;
            end;

            if (Servers:GetAttribute("GameMode") or "Casual") ~= v then
                return;
            end;

            if os.clock() - u644 < 0.5 then
                return;
            end;

            u644 = os.clock();
            RefreshServerFrame();
        end);
    end;

    Servers:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 6286
        -- upvalues: Servers (copy), RefreshServerFrame (copy)
        if Servers.Visible == true then
            RefreshServerFrame();
        end;
    end);
    Servers.ServerFrame.Create.Activated:Connect(function() -- Line: 6292
        -- upvalues: Config (ref), SoundService (ref), Servers (copy), LocalPlayer (ref)
        Config.AddSound("Click_3", 1, true, SoundService, false);

        if Servers.CreateFrame.Visible == true then
            Servers.CreateFrame.Visible = false;

            return;
        end;

        local ServerName = Servers.CreateFrame:FindFirstChild("ServerName");

        if ServerName and (ServerName:IsA("TextBox") and ServerName.Text == "") then
            ServerName.Text = LocalPlayer.Name .. "\'s Server";
        end;

        Servers.CreateFrame.Visible = true;
    end);

    local function ConfigCreateButtons() -- Line: 6305
        -- upvalues: Servers (copy), LocalPlayer (ref), u7 (ref), u2 (ref), ReplicatedStorage (ref)
        local u669 = "Workspace";
        Servers.CreateFrame.Back.Activated:Connect(function() -- Line: 6309
            -- upvalues: Servers (ref)
            Servers.CreateFrame.Visible = false;
        end);
        Servers.CreateFrame.Confirm.Activated:Connect(function() -- Line: 6313
            -- upvalues: Servers (ref), LocalPlayer (ref), u669 (ref), u7 (ref), u2 (ref), ReplicatedStorage (ref)
            local ServerName = Servers.CreateFrame:FindFirstChild("ServerName");
            local v670 = not (ServerName and ServerName:IsA("TextBox")) and "" or ServerName.Text;

            if v670 == "" then
                v670 = LocalPlayer.Name .. "\'s Server";
            end;

            local v671 = {
                Name = v670,
                Password = Servers.CreateFrame.ServerPassword.Text,
                Map = u669
            };
            local Play = u7.Pages:FindFirstChild("Play");

            if Play then
                Play:SetAttribute("PendingCustomAction", "Creating Custom");
            end;

            u2.OpenPage("Play");
            ReplicatedStorage.Events.CreateCustom:FireServer(v671);
            Servers.CreateFrame.Visible = false;
        end);

        for _, child in pairs(ReplicatedStorage.MapImages:GetChildren()) do
            if child:IsA("Decal") then
                local u672 = script.SampleCustomMap:Clone();
                u672.Parent = Servers.CreateFrame.MapScroller;
                u672.Image = child.Texture;
                u672.Title.Text = child.Name;
                u672.Activated:Connect(function() -- Line: 6342
                    -- upvalues: Servers (ref), u669 (ref), child (copy), u672 (copy)
                    for _, child2 in pairs(Servers.CreateFrame.MapScroller:GetChildren()) do
                        if child2:IsA("ImageButton") then
                            child2.ImageColor3 = Color3.fromRGB(150, 150, 150);
                        end;
                    end;

                    u669 = child.Name;
                    u672.ImageColor3 = Color3.fromRGB(255, 255, 255);
                end);
            end;
        end;
    end;

    ConfigGamemodeButtons();
    ConfigCreateButtons();
    LocalPlayer.ServerData:GetAttributeChangedSignal("Searching"):Connect(function() -- Line: 6357
        -- upvalues: LocalPlayer (ref), PlayerData (copy), u2 (ref)
        local v673 = LocalPlayer.ServerData:GetAttribute("Searching");

        if PlayerData.Settings:GetAttribute("Party") ~= "" and PlayerData.Settings:GetAttribute("Party") ~= LocalPlayer.Name then
            if v673 == "" then
                u2.AddNotification("Party leader unqueued");

                return;
            end;

            u2.AddNotification("Party leader queued " .. v673);
        end;
    end);
    Servers:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 6368
        -- upvalues: Servers (copy), RefreshServerFrame (copy)
        if Servers.Visible == true then
            RefreshServerFrame();
        end;
    end);
end;

local function ResetTeleportScreen(p674, p675) -- Line: 6375
    -- upvalues: u3 (ref), LocalPlayer (copy), u7 (ref), u2 (copy), ReplicatedStorage (copy)
    u3 = u3 + 1;
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
    local v676 = PlayerGui and PlayerGui:FindFirstChild("FoundScreen");

    if v676 then
        v676:Destroy();
    end;

    local Play = u7.Pages:FindFirstChild("Play");

    if Play then
        if (Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" then
            Play:SetAttribute("PendingDirectJoinGamemode", "");
        end;

        if (Play:GetAttribute("DirectJoinActiveGamemode") or "") ~= "" then
            Play:SetAttribute("DirectJoinActiveGamemode", "");
        end;

        if (Play:GetAttribute("PendingCustomAction") or "") ~= "" then
            Play:SetAttribute("PendingCustomAction", "");
        end;

        if Play:GetAttribute("TeleportTransitionActive") == true then
            Play:SetAttribute("TeleportTransitionActive", false);
        end;
    end;

    if p674 and p674 ~= "" then
        u2.AddNotification(p674, Color3.fromRGB(255, 170, 170));
    end;

    if p675 == true then
        local ServerData = LocalPlayer:FindFirstChild("ServerData");

        if ServerData and (ServerData:GetAttribute("Searching") or "") ~= "" then
            ReplicatedStorage.Events.QueueGamemode:FireServer("");
        end;
    end;
end;

function u2.ShowTeleportScreen(p677) -- Line: 6414
    -- upvalues: u3 (ref), LocalPlayer (copy), TeleportService (copy), Config (copy), TweenService (copy), ResetTeleportScreen (copy)
    u3 = u3 + 1;
    local u678 = u3;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local FoundScreen = PlayerGui:FindFirstChild("FoundScreen");

    if FoundScreen then
        FoundScreen:Destroy();
    end;

    local u679 = script.TeleportGui:Clone();
    u679.Name = "FoundScreen";
    u679.Parent = PlayerGui;
    local Background = u679:WaitForChild("Background");
    local Frame = u679:WaitForChild("Frame");
    local Loading = Frame:WaitForChild("Loading");
    local Title = Frame:WaitForChild("Title");
    local TipsTitle = Frame:WaitForChild("TipsTitle");
    local TipsDescription = Frame:WaitForChild("TipsDescription");
    TeleportService:SetTeleportGui(u679);

    if game.PlaceId == Config.GameID then
        Title.Text = "Joining lobby";
    elseif game.PlaceId == Config.LobbyID then
        Title.Text = "Joining match [" .. (p677 or "") .. "]";
    else
        Title.Text = "Teleporting...";
    end;

    TipsDescription.Text = Config.GetSyncedTip();
    Background.BackgroundTransparency = 1;
    Title.TextTransparency = 1;
    TipsTitle.TextTransparency = 1;
    TipsDescription.TextTransparency = 1;
    Loading.ImageTransparency = 1;
    Loading.Rotation = 0;
    Config.TweenCreate(Background, {
        BackgroundTransparency = 0
    }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
    Config.TweenCreate(Title, {
        TextTransparency = 0
    }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
    Config.TweenCreate(TipsTitle, {
        TextTransparency = 0
    }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
    Config.TweenCreate(TipsDescription, {
        TextTransparency = 0
    }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
    Config.TweenCreate(Loading, {
        ImageTransparency = 0
    }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
    local u680 = TweenService:Create(Loading, TweenInfo.new(1.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false), {
        Rotation = 360
    });
    u680:Play();
    u679.Destroying:Connect(function() -- Line: 6488
        -- upvalues: u680 (copy), u3 (ref), u678 (copy)
        u680:Cancel();

        if u3 == u678 then
            u3 = u3 + 1;
        end;
    end);
    task.spawn(function() -- Line: 6496
        -- upvalues: u679 (copy), u3 (ref), u678 (copy), TipsDescription (copy), Config (ref)
        while u679.Parent and u3 == u678 do
            task.wait(4);

            if not u679.Parent or u3 ~= u678 then
                break;
            end;

            TipsDescription.TextTransparency = 1;
            TipsDescription.Text = Config.GetSyncedTip();
            Config.TweenCreate(TipsDescription, {
                TextTransparency = 0
            }, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        end;
    end);
    task.delay(15, function() -- Line: 6511
        -- upvalues: u3 (ref), u678 (copy), u679 (copy), ResetTeleportScreen (ref)
        if u3 ~= u678 then
            return;
        end;

        if not u679.Parent then
            return;
        end;

        ResetTeleportScreen("Match join timed out. Please queue again.", true);
    end);

    return u679;
end;

function u2.ConfigOtherEvents() -- Line: 6526
    -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy), ResetTeleportScreen (copy), u7 (ref), u2 (copy), Config (copy), TeleportService (copy), UpdateLogs (copy), AvatarEditorService (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    ReplicatedStorage.Events.FoundServer.OnClientEvent:Connect(function(p681, p682) -- Line: 6529
        -- upvalues: ResetTeleportScreen (ref), u7 (ref), u2 (ref)
        if p681 == "" then
            ResetTeleportScreen(p682);

            return;
        end;

        local Play = u7.Pages:FindFirstChild("Play");

        if Play then
            Play:SetAttribute("TeleportTransitionActive", true);
            local Quickmatch = Play:FindFirstChild("Quickmatch");

            if Quickmatch and Quickmatch:FindFirstChild("Timer") then
                Quickmatch.Timer.Visible = true;
            end;

            local QuickmatchCancel = Play:FindFirstChild("QuickmatchCancel");

            if QuickmatchCancel then
                QuickmatchCancel.Visible = false;
            end;

            local Gamemodes = Play:FindFirstChild("Gamemodes");

            if Gamemodes then
                Gamemodes.Visible = false;
            end;

            local Servers = Play:FindFirstChild("Servers");

            if Servers then
                Servers.Visible = false;
            end;

            local GamemodeList = Play:FindFirstChild("GamemodeList");

            if GamemodeList then
                GamemodeList.Visible = false;
            end;

            if (Play:GetAttribute("PendingDirectJoinGamemode") or "") ~= "" then
                Play:SetAttribute("PendingDirectJoinGamemode", "");
            end;

            if (Play:GetAttribute("DirectJoinActiveGamemode") or "") ~= "" then
                Play:SetAttribute("DirectJoinActiveGamemode", "");
            end;

            if (Play:GetAttribute("PendingCustomAction") or "") ~= "" then
                Play:SetAttribute("PendingCustomAction", "");
            end;
        end;

        u2.ShowTeleportScreen(p681);
    end);
    ReplicatedStorage.Events.SoftShutdown.OnClientEvent:Connect(function() -- Line: 6572
        -- upvalues: PlayerGui (copy), Config (ref)
        local v683 = script.TeleportGui:Clone();
        v683.Parent = PlayerGui;
        v683.Name = "FoundScreen";

        for _, child in pairs(v683.Frame:GetChildren()) do
            if child:IsA("TextLabel") then
                child.TextTransparency = 1;
                Config.TweenCreate(child, {
                    Rotation = 360
                }, 4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, false, true);
                Config.TweenCreate(child, {
                    ImageTransparency = 0
                }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
            elseif child:IsA("ImageLabel") then
                child.ImageTransparency = 1;
                Config.TweenCreate(child, {
                    TextTransparency = 0
                }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
            end;
        end;

        Config.TweenCreate(v683.Background, {
            BackgroundTransparency = 0
        }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        v683.Frame.Title.Text = "[UPDATE] Restarting Servers";
        v683.Frame.TipsDescription.Text = Config.GetSyncedTip();
    end);
    ReplicatedStorage.Events.ReturnLobby.OnClientEvent:Connect(function(p684, p685) -- Line: 6596
        -- upvalues: u2 (ref), TeleportService (ref), Config (ref), LocalPlayer (ref)
        u2.ShowTeleportScreen();
        TeleportService:Teleport(Config.LobbyID, LocalPlayer, nil, p685);
        u2.AddNotification(p684 or "Rejoining Lobby");
    end);
    TeleportService.TeleportInitFailed:Connect(function(p686, p687, p688) -- Line: 6602
        -- upvalues: LocalPlayer (ref), ResetTeleportScreen (ref)
        if p686 ~= LocalPlayer then
            return;
        end;

        local v689 = p687 and tostring(p687) or "Unknown";

        if not p688 or (p688 == "" or not p688) then
            p688 = "Teleport failed (" .. v689 .. "). Please queue again.";
        end;

        ResetTeleportScreen(p688, true);
    end);
    ReplicatedStorage.Events.QueueGamemode.OnClientEvent:Connect(function(p690, p691) -- Line: 6612
        -- upvalues: ResetTeleportScreen (ref)
        if p690 == "Failed" then
            ResetTeleportScreen(p691 or "Queue error, try again");
        end;
    end);
    (function() -- Line: 6618, Name: ConfigUpdateFrame
        -- upvalues: u7 (ref), UpdateLogs (ref)
        local UpdateFrame = u7.Pages.Play.UpdateFrame;
        local Scroller2 = UpdateFrame.Scroller;
        UpdateFrame.Version.Text = UpdateLogs.UpdateVerson;

        for _, child in ipairs(Scroller2:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy();
            end;
        end;

        local u692 = 1;

        local function AddUpdateLogRow(p693, p694) -- Line: 6634
            -- upvalues: u692 (ref), Scroller2 (copy)
            local v695 = script.SampleUpdateLog:Clone();
            v695.Name = "UpdateLog_" .. tostring(u692);
            v695.LayoutOrder = u692;
            v695.Title.Text = p693;
            v695.Size = UDim2.new(v695.Size.X.Scale, v695.Size.X.Offset, p694 and 0.1 or 0.083, v695.Size.Y.Offset);
            v695.Parent = Scroller2;
            u692 = u692 + 1;
        end;

        for _, v in ipairs(UpdateLogs.Logs) do
            AddUpdateLogRow(v.Title, true);

            for _, v2 in ipairs(v.Entries) do
                AddUpdateLogRow(v2, false);
            end;
        end;

        UpdateFrame.Cancel.Activated:Connect(function() -- Line: 6651
            -- upvalues: UpdateFrame (copy)
            UpdateFrame.Visible = false;
        end);
    end)();
    local StarterGui = game:GetService("StarterGui");
    ReplicatedStorage.Events.ShowUpdateLogs.OnClientEvent:Connect(function() -- Line: 6658
        -- upvalues: u2 (ref), u7 (ref)
        u2.OpenPage("Play");
        u7.Pages.Play.UpdateFrame.Visible = true;
    end);
    ReplicatedStorage.Events.ModNotification.OnClientEvent:Connect(function(p696) -- Line: 6663
        -- upvalues: StarterGui (copy)
        StarterGui:SetCore("SendNotification", {
            Title = "MODERATION",
            Text = p696
        });
    end);
    require(ReplicatedStorage.Components.Icon).new():setName("Favourite"):setLabel("⭐"):bindEvent("deselected", function() -- Line: 6676
        -- upvalues: AvatarEditorService (ref), Config (ref)
        AvatarEditorService:PromptSetFavorite(Config.LobbyID, Enum.AvatarItemType.Asset, true);
    end):oneClick():align("Right");
    task.defer(function() -- Line: 6683
        -- upvalues: Config (ref)
        Config.PromptUpcomingEvents();
    end);
end;

function u2.ConfigEvent() -- Line: 6688
    -- upvalues: u2 (copy)
    u2.ConfigEventPage();
end;

function u2.ConfigEventPage() -- Line: 6692
    -- upvalues: u7 (ref), ReplicatedStorage (copy), LocalPlayer (copy), Config (copy), u2 (copy)
    local Event = u7:WaitForChild("Pages"):WaitForChild("Event");
    local Event2 = u7:WaitForChild("Pages"):WaitForChild("Play"):WaitForChild("Event");
    local Event3 = require(ReplicatedStorage:WaitForChild("Components"):WaitForChild("Event"));
    local Event4 = LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Event");
    local Action = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Action");
    local u697 = nil;
    local u698 = {};
    local u699 = {};
    local u700 = {};

    local function GetSample(p701) -- Line: 6713
        local Sample = script:FindFirstChild("Sample");

        if Sample and Sample:FindFirstChild(p701) then
            return Sample:FindFirstChild(p701);
        end;

        if script:FindFirstChild(p701) then
            return script:FindFirstChild(p701);
        end;

        return nil;
    end;

    local u702 = GetSample("SampleEventClaim");
    local u703 = GetSample("SampleEventShop");

    local function SetVisible(p704, p705) -- Line: 6734
        if p704 then
            p704.Visible = p705;
        end;
    end;

    local function FormatMinutesSeconds(p706) -- Line: 6740
        local v707 = math.floor(p706 or 0);
        local v708 = math.max(0, v707);

        return math.floor(v708 / 60) .. "m " .. v708 % 60 .. "s";
    end;

    local function FormatHoursMinutesSeconds(p709) -- Line: 6749
        local v710 = math.floor(p709 or 0);
        local v711 = math.max(0, v710);

        return math.floor(v711 / 3600) .. "h " .. math.floor(v711 % 3600 / 60) .. "m " .. v711 % 60 .. "s";
    end;

    local function FormatNumber(p712) -- Line: 6759
        -- upvalues: Event3 (copy)
        if Event3.FormatNumber then
            return Event3.FormatNumber(p712);
        end;

        return tostring(p712 or 0);
    end;

    local function ClearClones(p713) -- Line: 6767
        if not p713 then
            return;
        end;

        for _, child in ipairs(p713:GetChildren()) do
            if child:GetAttribute("EventClone") == true then
                child:Destroy();
            end;
        end;
    end;

    local function DisconnectEventAttributeConnections() -- Line: 6779
        -- upvalues: u700 (copy)
        for _, v in ipairs(u700) do
            v:Disconnect();
        end;

        table.clear(u700);
    end;

    local function SetPageButtonVisual(p714, p715) -- Line: 6787
        if not p714 then
            return;
        end;

        local Title = p714:FindFirstChild("Title");

        if p715 then
            p714.BackgroundColor3 = Color3.fromRGB(255, 255, 255);

            if Title then
                Title.TextColor3 = Color3.fromRGB(0, 0, 0);
            end;
        else
            p714.BackgroundColor3 = Color3.fromRGB(30, 30, 30);

            if Title then
                Title.TextColor3 = Color3.fromRGB(255, 255, 255);
            end;
        end;
    end;

    local function SetSelectedPage(p716) -- Line: 6809
        -- upvalues: Event (copy), SetPageButtonVisual (copy)
        local v717 = p716 == "Claim";
        local Claim = Event:FindFirstChild("Claim");

        if Claim then
            Claim.Visible = v717;
        end;

        local Shop = Event:FindFirstChild("Shop");
        local v718 = not v717;

        if Shop then
            Shop.Visible = v718;
        end;

        SetPageButtonVisual(Event:FindFirstChild("ClaimPage"), v717);
        SetPageButtonVisual(Event:FindFirstChild("ShopPage"), not v717);
    end;

    local function SetInactivePage() -- Line: 6819
        -- upvalues: Event (copy)
        local Claim = Event:FindFirstChild("Claim");

        if Claim then
            Claim.Visible = false;
        end;

        local Shop = Event:FindFirstChild("Shop");

        if Shop then
            Shop.Visible = false;
        end;

        local ClaimPage = Event:FindFirstChild("ClaimPage");

        if ClaimPage then
            ClaimPage.Visible = false;
        end;

        local ShopPage = Event:FindFirstChild("ShopPage");

        if ShopPage then
            ShopPage.Visible = false;
        end;
    end;

    local function SetActivePageButtons() -- Line: 6826
        -- upvalues: Event (copy)
        local ClaimPage = Event:FindFirstChild("ClaimPage");

        if ClaimPage then
            ClaimPage.Visible = true;
        end;

        local ShopPage = Event:FindFirstChild("ShopPage");

        if ShopPage then
            ShopPage.Visible = true;
        end;
    end;

    local function RefreshPlayEventDisplay() -- Line: 6835
        -- upvalues: u697 (ref), Event2 (copy)
        if u697 then
            Event2.Visible = true;
            Event2.Title.Text = string.upper(u697.EventName);

            if u697.EventImage then
                Event2.Display.Image = u697.EventImage;
            end;
        else
            Event2.Visible = false;
        end;
    end;

    Event2.Activated:Connect(function() -- Line: 6848
        -- upvalues: u697 (ref), Config (ref), u2 (ref)
        if not u697 then
            return;
        end;

        Config.AddSound("Click_1", 1, true, game.SoundService, false);
        u2.OpenPage("Event");
    end);

    local function RefreshTopDisplay() -- Line: 6861
        -- upvalues: u697 (ref), Event3 (copy), LocalPlayer (ref), Event (copy)
        if not u697 then
            return;
        end;

        local v719 = Event3.GetCurrencyImage(u697);
        local v720 = Event3.GetPlayerCurrency(LocalPlayer, u697);

        if Event:FindFirstChild("CurrencyImage") then
            Event.CurrencyImage.Image = v719;
        end;

        if Event:FindFirstChild("Currency") then
            local Currency = Event.Currency;
            local v721;

            if Event3.FormatNumber then
                v721 = Event3.FormatNumber(v720);
            else
                v721 = tostring(v720 or 0);
            end;

            Currency.Text = v721;
        end;
    end;

    local function RefreshDaysLeft() -- Line: 6878
        -- upvalues: u697 (ref), Event (copy), Event3 (copy)
        if not u697 then
            return;
        end;

        local DaysLeft = Event:FindFirstChild("DaysLeft");

        if not DaysLeft then
            return;
        end;

        local v722 = Event3.GetUnixTimeFromDate(u697.EndDate) - os.time();
        local v723 = math.max(0, v722) / 86400;
        DaysLeft.Text = "Event ends in " .. math.ceil(v723) .. " days";
    end;

    if Event:FindFirstChild("ClaimPage") then
        Event.ClaimPage.Activated:Connect(function() -- Line: 6900
            -- upvalues: u697 (ref), Config (ref), SetSelectedPage (copy)
            if not u697 then
                return;
            end;

            Config.AddSound("Click_1", 1, true, game.SoundService, false);
            SetSelectedPage("Claim");
        end);
    end;

    if Event:FindFirstChild("ShopPage") then
        Event.ShopPage.Activated:Connect(function() -- Line: 6911
            -- upvalues: u697 (ref), Config (ref), SetSelectedPage (copy)
            if not u697 then
                return;
            end;

            Config.AddSound("Click_1", 1, true, game.SoundService, false);
            SetSelectedPage("Shop");
        end);
    end;

    local function GetClaimFrame() -- Line: 6925
        -- upvalues: Event (copy)
        return Event:FindFirstChild("Claim");
    end;

    local function GetClaimScroller() -- Line: 6929
        -- upvalues: Event (copy)
        local Claim = Event:FindFirstChild("Claim");

        if Claim then
            return Claim:FindFirstChild("Scroller");
        end;

        return nil;
    end;

    local function RefreshSkipButton() -- Line: 6938
        -- upvalues: Event (copy), u697 (ref), Event3 (copy), LocalPlayer (ref)
        local Claim = Event:FindFirstChild("Claim");

        if not Claim then
            return;
        end;

        local Skip = Claim:FindFirstChild("Skip");

        if not Skip then
            return;
        end;

        if not u697 then
            Skip.Visible = false;

            return;
        end;

        for i, _ in ipairs(u697.Claimables or {}) do
            if not Event3.HasClaimed(LocalPlayer, u697, i) then
                Skip.Visible = true;

                return;
            end;
        end;

        Skip.Visible = false;
    end;

    local function RefreshClaimRow(p724) -- Line: 6964
        -- upvalues: u697 (ref), u698 (copy), Event3 (copy), LocalPlayer (ref)
        if not u697 then
            return;
        end;

        local v725 = u698[p724];
        local v726 = Event3.GetClaimable(u697, p724);

        if not (v725 and v726) then
            return;
        end;

        local v727 = Event3.GetCurrencyImage(u697);
        local v728 = v726.Time or 0;
        local v729 = Event3.GetClaimState(LocalPlayer, u697, v726, p724);
        local CurrencyImage = v725:FindFirstChild("CurrencyImage", true);

        if CurrencyImage then
            CurrencyImage.Image = v727;
        end;

        local Amount = v725:FindFirstChild("Amount", true);

        if Amount then
            local v730 = v726.Amount or 0;
            local v731;

            if Event3.FormatNumber then
                v731 = Event3.FormatNumber(v730);
            else
                v731 = tostring(v730 or 0);
            end;

            Amount.Text = v731;
        end;

        local Timer = v725:FindFirstChild("Timer", true);

        if Timer then
            local v732 = math.floor(v728 / 60);
            Timer.Text = tostring(v732) .. "m";
        end;

        local Status = v725:FindFirstChild("Status", true);
        local Background = v725:FindFirstChild("Background", true);

        if Status then
            if v729 == "Claimed" then
                Status.Text = "CLAIMED";
                Status.TextColor3 = Color3.fromRGB(255, 255, 255);
            elseif v729 == "Ready" then
                Status.Text = "CLAIM";
                Status.TextColor3 = Color3.fromRGB(0, 0, 0);
            else
                Status.Text = "";
                Status.TextColor3 = Color3.fromRGB(255, 255, 255);
            end;
        end;

        if Background then
            if v729 == "Claimed" then
                Background.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
                v725.Timer.Visible = false;

                return;
            end;

            if v729 == "Ready" then
                Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v725.Timer.Visible = true;

                return;
            end;

            Background.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
            v725.Timer.Visible = true;
        end;
    end;

    local function RefreshClaimRows() -- Line: 7025
        -- upvalues: u697 (ref), RefreshClaimRow (copy)
        if not u697 then
            return;
        end;

        for i, _ in ipairs(u697.Claimables or {}) do
            RefreshClaimRow(i);
        end;
    end;

    local function BuildClaimPage() -- Line: 7035
        -- upvalues: u697 (ref), Event (copy), u702 (copy), ClearClones (copy), u698 (copy), Event3 (copy), LocalPlayer (ref), Config (ref), Action (copy), RefreshClaimRow (copy), RefreshSkipButton (copy)
        if not u697 then
            return;
        end;

        local Claim = Event:FindFirstChild("Claim");
        local v733;

        if Claim then
            v733 = Claim:FindFirstChild("Scroller");
        else
            v733 = nil;
        end;

        if not v733 then
            warn("[Event Menu] Missing Claim.Scroller");

            return;
        end;

        if not u702 then
            warn("[Event Menu] Missing SampleEventClaim");

            return;
        end;

        ClearClones(v733);
        table.clear(u698);
        u702.Visible = false;

        for i, v in ipairs(u697.Claimables or {}) do
            local v734 = u702:Clone();
            v734.Name = "EventClaim_" .. i;
            v734:SetAttribute("EventClone", true);
            v734.Visible = true;
            v734.Parent = v733;
            u698[i] = v734;
            v734.Activated:Connect(function() -- Line: 7065
                -- upvalues: Event3 (ref), LocalPlayer (ref), u697 (ref), v (copy), i (copy), Config (ref), Action (ref)
                local v735 = Event3.GetClaimState(LocalPlayer, u697, v, i);

                if v735 == "Claimed" then
                    return;
                end;

                if v735 ~= "Ready" then
                    return;
                end;

                Config.AddSound("Click_2", 1, true, game.SoundService, false);
                Action:FireServer("ClaimEventReward", {
                    EventId = u697.EventId,
                    Index = i
                });
            end);
            RefreshClaimRow(i);
        end;

        RefreshSkipButton();
    end;

    local Claim = Event:FindFirstChild("Claim");

    if Claim and Claim:FindFirstChild("Skip") then
        Claim.Skip.Activated:Connect(function() -- Line: 7092
            -- upvalues: u2 (ref), Claim (copy)
            u2.SetupMonetisationButton(Claim.Skip);
        end);
    end;

    local function GetShopFrame() -- Line: 7101
        -- upvalues: Event (copy)
        return Event:FindFirstChild("Shop");
    end;

    local function GetShopStore() -- Line: 7105
        -- upvalues: Event (copy)
        local Shop = Event:FindFirstChild("Shop");

        if Shop then
            return Shop:FindFirstChild("Store");
        end;

        return nil;
    end;

    local function RefreshShopRow(p736) -- Line: 7114
        -- upvalues: u697 (ref), u699 (copy), Event3 (copy), LocalPlayer (ref)
        if not u697 then
            return;
        end;

        local v737 = u699[p736];
        local v738 = u697.Shop and u697.Shop[p736];

        if not (v737 and v738) then
            return;
        end;

        local Buy = v737:FindFirstChild("Buy", true);

        if Buy then
            Buy.Visible = not Event3.PlayerOwnsShopItem(LocalPlayer, v738);
            v737.Own.Visible = not Buy.Visible;
        end;
    end;

    local function RefreshShopRows() -- Line: 7133
        -- upvalues: u697 (ref), RefreshShopRow (copy)
        if not u697 then
            return;
        end;

        for i, _ in ipairs(u697.Shop or {}) do
            RefreshShopRow(i);
        end;
    end;

    local function BuildShopPage() -- Line: 7143
        -- upvalues: u697 (ref), Event (copy), u703 (copy), ClearClones (copy), u699 (copy), Event3 (copy), u2 (ref), ReplicatedStorage (ref), Config (ref), LocalPlayer (ref), Action (copy), RefreshShopRow (copy)
        if not u697 then
            return;
        end;

        local Shop = Event:FindFirstChild("Shop");
        local v739;

        if Shop then
            v739 = Shop:FindFirstChild("Store");
        else
            v739 = nil;
        end;

        if not v739 then
            warn("[Event Menu] Missing Shop.Store");

            return;
        end;

        if not u703 then
            warn("[Event Menu] Missing SampleEventShop");

            return;
        end;

        ClearClones(v739);
        table.clear(u699);
        u703.Visible = false;

        for i, v in ipairs(u697.Shop or {}) do
            local v740 = u703:Clone();
            v740.Name = "EventShop_" .. i;
            v740:SetAttribute("EventClone", true);
            v740.Visible = true;
            v740.Parent = v739;
            u699[i] = v740;
            v740.Title.Text = tostring(v.Name or "Item");
            v740.SubTitle.Text = tostring(v.Type or "Type");
            v740.Cost.Icon.Image = Event3.GetCurrencyImage(u697);
            local Cost = v740.Cost;
            local v741 = v.Cost or 0;
            local v742;

            if Event3.FormatNumber then
                v742 = Event3.FormatNumber(v741);
            else
                v742 = tostring(v741 or 0);
            end;

            Cost.Text = v742;
            local ItemDisplay = v740:FindFirstChild("ItemDisplay", true);

            if ItemDisplay then
                u2.AddItemToViewport(v, v740.ItemDisplay.ItemPort);
                local Rarity = ItemDisplay:FindFirstChild("Rarity");
                local v743 = ReplicatedStorage.Items:FindFirstChild(v.Type);

                if v743 then
                    v743 = v743:FindFirstChild(v.Name);
                end;

                local v744;

                if v743 then
                    v744 = Config.GetItemDataFromObject(v743) or v;
                else
                    v744 = v;
                end;

                local v745 = v744.Rarity and Config.Rarity[v744.Rarity];

                if Rarity then
                    Rarity.Visible = false;

                    if v745 then
                        Rarity.Visible = (v744.Type == "Head" or (v744.Type == "Top" or (v744.Type == "Bottom" or (v744.Type == "Banner" or (v744.Type == "Title" or (v744.Type == "Emote" or (v744.Type == "Knife" or v744.Type == "Skin"))))))) and true or v744.Type == "Charm";
                        Rarity.ImageColor3 = v745.Color;
                        Rarity.ImageTransparency = 0.3;
                    end;
                end;
            end;

            local Buy = v740:FindFirstChild("Buy", true);

            if Buy then
                Buy.Activated:Connect(function() -- Line: 7199
                    -- upvalues: Event3 (ref), LocalPlayer (ref), v (copy), Config (ref), Action (ref), u697 (ref), i (copy)
                    if Event3.PlayerOwnsShopItem(LocalPlayer, v) then
                        return;
                    end;

                    Config.AddSound("Click_2", 1, true, game.SoundService, false);
                    Action:FireServer("BuyEventShopItem", {
                        EventId = u697.EventId,
                        Index = i
                    });
                end);
            end;

            RefreshShopRow(i);
        end;
    end;

    local function RefreshTimeTexts() -- Line: 7221
        -- upvalues: u697 (ref), Event (copy), Event4 (copy), Event3 (copy)
        if not u697 then
            return;
        end;

        local Claim2 = Event:FindFirstChild("Claim");

        if not Claim2 then
            return;
        end;

        local v746 = Event4:GetAttribute("OnlineTime") or 0;
        local OnlineTime = Claim2:FindFirstChild("OnlineTime");

        if OnlineTime then
            local v747 = math.floor(v746 or 0);
            local v748 = math.max(0, v747);
            OnlineTime.Text = math.floor(v748 / 60) .. "m " .. v748 % 60 .. "s";
        end;

        local RefreshTime = Claim2:FindFirstChild("RefreshTime");

        if RefreshTime then
            local v749 = Event3.GetTimeUntilTomorrow() or 0;
            local v750 = math.floor(v749);
            local v751 = math.max(0, v750);
            RefreshTime.Text = math.floor(v751 / 3600) .. "h " .. math.floor(v751 % 3600 / 60) .. "m " .. v751 % 60 .. "s";
        end;
    end;

    local function ConnectCurrentEventAttributes() -- Line: 7248
        -- upvalues: u700 (copy), u697 (ref), Event4 (copy), RefreshTopDisplay (copy), RefreshShopRows (copy), Event3 (copy), RefreshClaimRow (copy), RefreshSkipButton (copy)
        for _, v in ipairs(u700) do
            v:Disconnect();
        end;

        table.clear(u700);

        if not u697 then
            return;
        end;

        if u697.CurrencyAttribute then
            u700[#u700 + 1] = Event4:GetAttributeChangedSignal(u697.CurrencyAttribute):Connect(function() -- Line: 7256
                -- upvalues: RefreshTopDisplay (ref), RefreshShopRows (ref)
                RefreshTopDisplay();
                task.defer(RefreshShopRows);
            end);
        end;

        for i, _ in ipairs(u697.Claimables or {}) do
            local v752 = Event3.GetClaimAttribute(u697, i);

            if v752 then
                u700[#u700 + 1] = Event4:GetAttributeChangedSignal(v752):Connect(function() -- Line: 7267
                    -- upvalues: RefreshClaimRow (ref), i (copy), RefreshSkipButton (ref)
                    RefreshClaimRow(i);
                    RefreshSkipButton();
                end);
            end;
        end;
    end;

    Event4:GetAttributeChangedSignal("OnlineTime"):Connect(function() -- Line: 7275
        -- upvalues: u697 (ref), RefreshTimeTexts (copy), RefreshClaimRows (copy)
        if not u697 then
            return;
        end;

        RefreshTimeTexts();
        RefreshClaimRows();
    end);

    local function RefreshEvent(p753) -- Line: 7288
        -- upvalues: Event (copy), ClearClones (copy), u698 (copy), u699 (copy), u700 (copy), u697 (ref), Event2 (copy), SetInactivePage (copy), RefreshSkipButton (copy), SetSelectedPage (copy), RefreshTopDisplay (copy), BuildClaimPage (copy), BuildShopPage (copy), RefreshTimeTexts (copy), RefreshDaysLeft (copy), ConnectCurrentEventAttributes (copy)
        local Claim2 = Event:FindFirstChild("Claim");
        local v754;

        if Claim2 then
            v754 = Claim2:FindFirstChild("Scroller");
        else
            v754 = nil;
        end;

        local Shop = Event:FindFirstChild("Shop");
        local v755;

        if Shop then
            v755 = Shop:FindFirstChild("Store");
        else
            v755 = nil;
        end;

        if v754 then
            ClearClones(v754);
        end;

        if v755 then
            ClearClones(v755);
        end;

        table.clear(u698);
        table.clear(u699);

        for _, v in ipairs(u700) do
            v:Disconnect();
        end;

        table.clear(u700);
        u697 = p753;

        if u697 then
            Event2.Visible = true;
            Event2.Title.Text = string.upper(u697.EventName);

            if u697.EventImage then
                Event2.Display.Image = u697.EventImage;
            end;
        else
            Event2.Visible = false;
        end;

        if not u697 then
            SetInactivePage();
            RefreshSkipButton();

            return;
        end;

        local ClaimPage = Event:FindFirstChild("ClaimPage");

        if ClaimPage then
            ClaimPage.Visible = true;
        end;

        local ShopPage = Event:FindFirstChild("ShopPage");

        if ShopPage then
            ShopPage.Visible = true;
        end;

        SetSelectedPage("Claim");
        RefreshTopDisplay();
        BuildClaimPage();
        BuildShopPage();
        RefreshTimeTexts();
        RefreshDaysLeft();
        ConnectCurrentEventAttributes();
    end;

    RefreshEvent(Event3.GetCurrentEvent());
    task.spawn(function() -- Line: 7332
        -- upvalues: Event (copy), Event3 (copy), u697 (ref), RefreshEvent (copy), RefreshDaysLeft (copy)
        while Event and Event.Parent do
            local v756 = Event3.GetCurrentEvent();
            local v757;

            if v756 then
                v757 = v756.EventId;
            else
                v757 = v756;
            end;

            if (u697 and u697.EventId) == v757 then
                if u697 then
                    RefreshDaysLeft();
                end;
            else
                RefreshEvent(v756);
            end;

            task.wait(1);
        end;
    end);
end;

function u2.ConfigGangPageOld() -- Line: 7368
    -- upvalues: Config (copy), SoundService (copy), ReplicatedStorage (copy)
    Main.ProfilePrompt.Scroller.GangInvite.MouseButton1Down:Connect(function() -- Line: 7372
        -- upvalues: Config (ref), SoundService (ref), ReplicatedStorage (ref)
        if InviteCooldown == true and SocialPlayerSelected ~= nil then
            Main.ProfilePrompt.Visible = false;
            InviteCooldown = false;
            Config.AddSound("Click_2", 1, true, SoundService, false);
            ReplicatedStorage.Events.GangInvite:FireServer(SocialPlayerSelected);
            SocialPlayerSelected = nil;
            task.wait(2);
            InviteCooldown = true;
        end;
    end);
    Main.Notification.GangRequest.Accept.MouseButton1Down:Connect(function() -- Line: 7384
        -- upvalues: Config (ref), SoundService (ref), ReplicatedStorage (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        ReplicatedStorage.Events.GangUpdate:FireServer("Join", Main.Notification.GangRequest:GetAttribute("Inviter"));
        Main.Notification.GangRequest.Visible = false;
    end);
    Main.Notification.GangRequest.Decline.MouseButton1Down:Connect(function() -- Line: 7390
        -- upvalues: Config (ref), SoundService (ref)
        Config.AddSound("Click_2", 1, true, SoundService, false);
        Main.Notification.GangRequest.Visible = false;
    end);
    ReplicatedStorage.Events.GangInvite.OnClientEvent:Connect(function(p758, p759) -- Line: 7395
        -- upvalues: Config (ref)
        Main.Notification.GangRequest.Visible = true;
        Main.Notification.GangRequest.Position = UDim2.new(1.3, 0, 0.37, 0);
        Config.TweenCreate(Main.Notification.GangRequest, {
            Position = UDim2.new(0.88, 0, 0.37, 0)
        }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        Main.Notification.GangRequest.Title.Text = p758.Name .. " Invited you to their gang, " .. p759 .. ".";
        Main.Notification.GangRequest:SetAttribute("Inviter", p758.Name);
    end);
end;

function u2.ShowPrompt(p760, p761, p762) -- Line: 7414
    -- upvalues: Config (copy), SoundService (copy)
    Config.AddSound("Click_3", 1, true, SoundService, false);
    p760.Visible = true;
    p760.Title.Text = p761;
    p760:SetAttribute("Event", p762);
end;

function u2.ShowInputPrompt(p763, p764, p765) -- Line: 7422
    -- upvalues: Config (copy), SoundService (copy)
    Config.AddSound("Click_3", 1, true, SoundService, false);
    p763.Visible = true;
    p763.Title.Text = p764;
    p763.Input.Text = "INSERT INPUT HERE";
    p763:SetAttribute("Event", p765);

    if p765 == "Promocode" then
        p763.Accept.Title.Text = "CLAIM";

        return;
    end;

    if p765 == "Create" then
        p763.Accept.Title.Text = "CREATE";

        return;
    end;

    if p765 == "Delete" then
        p763.Accept.Title.Text = "DELETE";

        return;
    end;

    if p765 == "Rename" then
        p763.Accept.Title.Text = "RENAME";

        return;
    end;

    if p765 == "GangTag" then
        p763.Accept.Title.Text = "CONFIRM";

        return;
    end;

    if p765 == "QueueServer" then
        p763.Accept.Title.Text = "JOIN";
        p763.Input.Text = "";
    end;
end;

function u2.ShowLoading(p766, p767, p768) -- Line: 7446
    p766.Visible = true;
    local v769 = 1;

    for _ = 0, 8 do
        if v769 == 1 then
            p766.Title.Text = p767 .. " .";
        elseif v769 == 2 then
            p766.Title.Text = p767 .. " . .";
        elseif v769 == 3 then
            p766.Title.Text = p767 .. " . . .";
        elseif v769 == 4 then
            p766.Title.Text = p767;
            v769 = 1;
        end;

        v769 = v769 + 1;
        task.wait(p768 / 8);
    end;

    task.wait(p768 / 4);
    p766.Visible = false;
end;

function u2.ShowResult(p770, p771, p772, p773) -- Line: 7464
    p770.Visible = true;

    for i = 1, #p771 do
        p770.Title.Text = string.sub(p771, 1, i);
        task.wait(p772);
    end;

    task.wait(p773);
    p770.Visible = false;
end;

function u2.AddNotification(p774, p775, p776) -- Line: 7474
    -- upvalues: u7 (ref), Debris (copy), Config (copy)
    local v777 = p776 or u7.Top.Notification;
    local u778 = script.SampleNotification:Clone();
    u778.Title.Text = p774;
    u778.BackgroundColor3 = p775 or Color3.fromRGB(255, 255, 255);
    u778.Parent = v777;
    Debris:AddItem(u778, 3.5);
    task.spawn(function() -- Line: 7485
        -- upvalues: Config (ref), u778 (copy)
        Config.TweenCreate(u778.BarTimer, {
            Size = UDim2.new(1, 0, 1, 0)
        }, 3.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, true);
        Config.TweenCreate(u778, {
            Size = UDim2.new(0, 0, 1, 0)
        }, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, false);
    end);
end;

function u2.ShowDuplicate(p779) -- Line: 7491
    -- upvalues: Config (copy)
    p779.Duplicate.Size = UDim2.new(0, 0, 0, 0);
    task.wait(0.5);
    p779.Duplicate.Visible = true;
    Config.TweenCreate(p779.Duplicate, {
        Size = UDim2.new(0.08, 0, 0, 0)
    }, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, true);
    Config.TweenCreate(p779.Duplicate, {
        Size = UDim2.new(0.08, 0, 0.033, 0)
    }, 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
end;

function u2.FindMainFrame(p780, p781) -- Line: 7503
    local v782 = p780:FindFirstChild(p781);

    if not v782 then
        for _, child in pairs(p780:GetChildren()) do
            if child:FindFirstChild(p781) then
                v782 = child;
            end;
        end;
    end;

    return v782;
end;

function u2.CheckedEquipped(p783, p784, p785) -- Line: 7516
    if p785 == "" then
        return p783:GetAttribute(p784.Type) == p784.Name;
    end;

    return p783:GetAttribute(p785 .. p784.Type) == p784.Name;
end;

function u2.GetSelectedWeapon(p786) -- Line: 7532
    -- upvalues: LocalPlayer (copy), Utility (copy)
    local PlayerData = LocalPlayer:FindFirstChild("PlayerData");

    if PlayerData then
        local v787 = PlayerData.Settings:GetAttribute("LoadoutName");

        return PlayerData.Loadout[v787]:GetAttribute(p786 .. "Weapon");
    end;

    warn(Utility.formatWarnInstanceIsNil("Player", "PlayerData"));
end;

function u2.ClearDescription(p788) -- Line: 7543
    for _, child in pairs(p788:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("Frame") then
            child:Destroy();
        end;
    end;
end;

function u2.CreateDescription(p789, p790, p791) -- Line: 7551
    local TextLabel = Instance.new("TextLabel", p789);
    TextLabel.Size = UDim2.new(1, 0, 0.3, 0);
    TextLabel.Font = Enum.Font.SourceSansLight;
    TextLabel.TextTransparency = 0.2;
    TextLabel.TextStrokeTransparency = 1;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.Text = p790;

    if p791 then
        TextLabel.LayoutOrder = p791;
    end;
end;

function u2.CreateDisplayStats(p792, p793) -- Line: 7566
    -- upvalues: ReplicatedStorage (copy), Config (copy)
    local v794 = {};

    if p793.Type == "Weapon" then
        local v795 = ReplicatedStorage.Weapons:FindFirstChild(p793.Name);

        if v795 then
            local Settings = require(v795.Settings);
            v794 = {
                ["Head Damage"] = {
                    Amount = 200,
                    Max = 200,
                    Index = 1
                },
                ["Torso Damage"] = {
                    Max = 160,
                    Index = 2,
                    Amount = Settings.TorsoDamage
                },
                ["Limbs Damage"] = {
                    Max = 160,
                    Index = 3,
                    Amount = Settings.LimbsDamage
                },
                [" "] = {
                    Amount = "",
                    Max = 0,
                    Index = 4
                },
                ["Fire Mode"] = {
                    Max = 0,
                    Index = 5,
                    Amount = Settings.Mode
                },
                ["Fire Rate"] = {
                    Max = 1200,
                    Index = 6,
                    Amount = Settings.FireRate
                },
                ["Vertical Recoil"] = {
                    Max = 50,
                    Index = 7,
                    Amount = Settings.VRecoil
                },
                ["Horizontal Recoil"] = {
                    Max = 50,
                    Index = 8,
                    Amount = Settings.HRecoil
                },
                ["Hipfire Spread"] = {
                    Max = 15,
                    Index = 9,
                    Amount = Settings.MaxSpread
                },
                ["ADS Spread"] = {
                    Max = 15,
                    Index = 10,
                    Amount = Settings.MinSpread
                },
                ["  "] = {
                    Amount = "",
                    Max = 0,
                    Index = 11
                },
                ["Ammo Type"] = {
                    Max = 0,
                    Index = 12,
                    Amount = Settings.BulletType
                },
                ["Magazine Capacity"] = {
                    Max = 100,
                    Index = 13,
                    Amount = Settings.Ammo
                },
                Pellets = {
                    Max = 10,
                    Index = 14,
                    Amount = Settings.Bullets
                },
                Weight = {
                    Max = 8,
                    Index = 16,
                    Amount = Settings.Weight or 3
                },
                ["Effective Range"] = {
                    Max = 1000,
                    Index = 17,
                    Amount = Settings.EffectiveRange or 200
                },
                ["    "] = {
                    Amount = "",
                    Max = 0,
                    Index = 20
                },
                ["Plank Amount"] = {
                    Max = 6,
                    Index = 21,
                    Amount = Settings.PlankAmount or 1
                },
                ["Damage Per Plank"] = {
                    Max = 3,
                    Index = 22,
                    Amount = Settings.DamagePerPlank or 1
                }
            };
        end;
    elseif p793.Type == "Muzzle" or (p793.Type == "Sight" or (p793.Type == "Grip" or p793.Type == "Extra")) then
        local v796 = ReplicatedStorage.Items[p793.Type]:FindFirstChild(p793.Name);
        v794 = v796 and {
            ["Horizontal Recoil Reduction"] = {
                Max = 100,
                Index = 1,
                Amount = v796:GetAttribute("Horizontal")
            },
            ["Vertical Recoil Reduction"] = {
                Max = 100,
                Index = 2,
                Amount = v796:GetAttribute("Vertical")
            },
            ["Flash Suppressed"] = {
                Max = 100,
                Index = 3,
                Amount = v796:GetAttribute("SuppressFlash")
            },
            ["Sound Suppressed"] = {
                Max = 100,
                Index = 4,
                Amount = v796:GetAttribute("SuppressSound")
            },
            Zoom = {
                Max = 5,
                Index = 5,
                Amount = v796:GetAttribute("Zoom")
            },
            ["Hip Fire Reduction"] = {
                Max = 100,
                Index = 6,
                Amount = v796:GetAttribute("HipFireReduction")
            },
            Distance = {
                Max = 400,
                Index = 6,
                Amount = v796:GetAttribute("Distance")
            },
            [" "] = {
                Amount = "",
                Max = 0,
                Index = 9
            },
            Description = {
                Max = 0,
                Index = 10,
                Amount = v796:GetAttribute("Description")
            }
        } or v794;
    end;

    for i, v in pairs(v794) do
        if i ~= "Ammo Type" and (i ~= "Hipfire Spread" and (i ~= "ADS Spread" and (i ~= "Effective Range" and v.Amount ~= nil))) then
            local v797 = script.SampleInformation:Clone();
            v797.Parent = p792;
            v797.Description.Text = i;
            v797.Amount.Text = v.Amount;
            v797.LayoutOrder = v.Index;

            if i == "Fire Rate" then
                v797.Amount.Text = v.Amount .. "  rounds/min";
            elseif i == "Hipfire Spread" or (i == "ADS Spread" or (i == "Distance" or i == "Effective Range")) then
                v797.Amount.Text = v.Amount .. "  studs";
            elseif i == "Damage Per Plank" then
                v797.Amount.Text = v.Amount .. " / 3";
            elseif i == "Horizontal Recoil Reduction" or (i == "Vertical Recoil Reduction" or i == "Hip Fire Reduction") then
                v797.Amount.Text = v.Amount .. "%";
            elseif i == "Flash Suppressed" or i == "Sound Suppressed" then
                v797.Amount.Text = tostring(v.Amount * 100) .. "%";
            elseif i == "Zoom" then
                v797.Amount.Text = v.Amount .. "x";
            elseif i == "Description" then
                v797.Description.Text = "";
            elseif i == "Weight" then
                local Amount = v.Amount;
                local v798;

                if Amount > 4.5 then
                    v798 = (Amount - 4.5) / 20 * -1;
                else
                    v798 = Amount >= 2.5 and 0 or (2.5 - Amount) / 20;
                end;

                local v799 = math.floor(v798 * 1000) / 1000;
                v797.Amount.Text = v.Amount .. " kg  " .. " Wspeed " .. Config.RoundTo(v799 * 100, 1) .. "%";
                v797.Description.Text = "Weight";
            end;

            if v.Max == 0 then
                if v.Amount == "" then
                    v797.BackgroundTransparency = 1;
                end;

                v797.Bar.Visible = false;
            else
                v797.Bar.Amount.Size = UDim2.new(math.clamp(v.Amount / v.Max, 0, 1), 0, 1, 0);
                v797.Bar.Amount.BackgroundColor3 = Color3.fromHSV(v.Amount / v.Max * 0.28, 0.7, 0.9);
            end;
        end;
    end;
end;

function u2.SetReticleDisplay(p800, p801) -- Line: 7697
    for _, child in pairs(p801:GetChildren()) do
        if child.Name ~= "Guide" then
            child:Destroy();
        end;
    end;

    p800.Parent = p801;

    for _, child in pairs(p800:GetChildren()) do
        child.Parent = p801;
    end;

    p801.Visible = true;
end;

function u2.CreateItemDisplay(u802, u803, u804) -- Line: 7713
    -- upvalues: u7 (ref), LocalPlayer (copy), Utility (copy), Config (copy), GetLoadoutScrollerItemKey (copy), ReplicatedStorage (copy), u2 (copy), u4 (ref), SoundService (copy)
    local Loadout = u7:WaitForChild("Pages"):WaitForChild("Loadout");
    local PlayerData = LocalPlayer:FindFirstChild("PlayerData");

    if not PlayerData then
        warn(Utility.formatWarnInstanceIsNil("Player", "PlayerData"));

        return;
    end;

    local u805 = PlayerData.Settings:GetAttribute("LoadoutName");

    for _, child in pairs(u803:GetChildren()) do
        if child:IsA("ImageButton") and child:GetAttribute("Type") ~= (u802[1] and (u802[1].Type or "") or "") then
            child.Visible = false;
        end;
    end;

    for _, v in pairs(u802) do
        local v806 = PlayerData.Inventory:FindFirstChild(Config.GetItemIDFromItemData(v));
        local v807 = Config.FindNameAndType(v.Name, v.Type, u803);

        if v807 == nil then
            v807 = script.SampleItem:Clone();
            v807.Parent = u803;
            v807.Name = v.Name;
            v807:SetAttribute("Name", v.Name);
            v807:SetAttribute("Type", v.Type);
            v807:SetAttribute("Rarity", v.Rarity or "Common");
            v807:SetAttribute("ItemKey", GetLoadoutScrollerItemKey(v));
            v807.Title.Text = string.upper(v.Name);
            v807.Level.Text = v.Level and ("Lvl " .. v.Level or "") or "";
            v807.Cost.Text = v.Cost or "";

            if v.Cost then
                local v808 = ReplicatedStorage.Items:FindFirstChild(v.Type):FindFirstChild(v.Name):GetAttribute("CostType") or "Cash";
                local v809 = v807.Cost:FindFirstChild(v808);

                if v809 then
                    v809.Visible = true;
                    v809.Name = "Icon";
                end;
            end;

            v807.SubTitle.Text = "";
            v807.Rarity.ImageTransparency = 0.3;
            v807.Rarity.ImageColor3 = Config.Rarity[v.Rarity or "Common"].Color;
            v807.Rarity.Visible = (v.Type == "Head" or (v.Type == "Top" or (v.Type == "Bottom" or (v.Type == "Banner" or (v.Type == "Title" or (v.Type == "Emote" or (v.Type == "Knife" or v.Type == "Skin"))))))) and true or v.Type == "Charm";

            if PlayerData.Inventory:FindFirstChild(Config.GetItemIDFromItemData(v)) == nil then
                v807.LayoutOrder = v807.LayoutOrder + 1000;
            end;

            if v.Type == "Skin" then
                u2.AddItemToViewport(v, v807.ItemPort, true);
            else
                u2.AddItemToViewport(v, v807.ItemPort);
            end;

            v807.Activated:Connect(function() -- Line: 7777
                -- upvalues: v (copy), ReplicatedStorage (ref), u2 (ref), Loadout (copy), PlayerData (copy), u805 (copy), u4 (ref), Config (ref), SoundService (ref), u802 (copy), u803 (copy), u804 (copy), LocalPlayer (ref), u7 (ref)
                if v.Type == "Vest" then
                    local v810 = ReplicatedStorage.Items.Vest:FindFirstChild(v.Name);

                    if v810 then
                        u2.ClearDescription(Loadout.Information.Scroller);
                        u2.CreateDescription(Loadout.Information.Scroller, v810:GetAttribute("Description"), 1);
                    end;
                elseif v.Type == "Sight" then
                    local v811 = ReplicatedStorage.Items[v.Type]:FindFirstChild(v.Name);
                    local v812 = v811 and v811:FindFirstChild("SurfaceGui", true);

                    if v812 then
                        u2.SetReticleDisplay(v812:Clone(), Loadout.Information.Reticle);
                        u2.ClearDescription(Loadout.Information.Scroller);
                        u2.CreateDisplayStats(Loadout.Information.Scroller, v);
                    end;
                elseif v.Type == "Throwable" then
                    local v813 = ReplicatedStorage.Items.Throwable:FindFirstChild(v.Name);

                    if v813 then
                        u2.ClearDescription(Loadout.Information.Scroller);

                        for i, v2 in pairs(v813:GetAttributes()) do
                            if i == "Damage" then
                                if v813:GetAttribute("Rate") then
                                    u2.CreateDescription(Loadout.Information.Scroller, "Damage     " .. v2 / v813:GetAttribute("Rate") .. "/s", 0);
                                else
                                    u2.CreateDescription(Loadout.Information.Scroller, "Damage     " .. v2, 0);
                                end;
                            end;

                            if i == "Delay" then
                                u2.CreateDescription(Loadout.Information.Scroller, "Delay     " .. v2 .. "s", 3);
                            elseif i == "Range" then
                                u2.CreateDescription(Loadout.Information.Scroller, "Range     " .. v2 .. " studs", 1);
                            elseif i == "MaxBarricade" and v2 > 0 then
                                u2.CreateDescription(Loadout.Information.Scroller, "Barricade breaks     " .. v2, 5);
                            elseif i == "Lifetime" then
                                if v2 == 0 then
                                    u2.CreateDescription(Loadout.Information.Scroller, "Lifetime     Infinite", 4);
                                else
                                    u2.CreateDescription(Loadout.Information.Scroller, "Lifetime     " .. v2 .. "s", 4);
                                end;
                            elseif i == "EffectDuration" then
                                u2.CreateDescription(Loadout.Information.Scroller, "Effect duration     " .. v2 .. "s", 6);
                            elseif i == "ScaleWidth" then
                                u2.CreateDescription(Loadout.Information.Scroller, "Range effect     " .. v2 * v2 .. " studs area", 7);
                            elseif i == "Description" then
                                u2.CreateDescription(Loadout.Information.Scroller, v2, 8);
                            elseif i == "Proximity" then
                                u2.CreateDescription(Loadout.Information.Scroller, "Proximity     " .. v2 .. " studs", 2);
                            end;
                        end;
                    end;
                elseif v.Type == "Weapon" or (v.Type == "Muzzle" or (v.Type == "Grip" or v.Type == "Extra")) then
                    Loadout.Information.Reticle.Visible = false;
                    u2.ClearDescription(Loadout.Information.Scroller);
                    u2.CreateDisplayStats(Loadout.Information.Scroller, v);
                else
                    Loadout.Information.Reticle.Visible = false;
                    u2.ClearDescription(Loadout.Information.Scroller);
                end;

                v.Weapon = u2.GetSelectedWeapon(Loadout:GetAttribute("WeaponClass"));
                local v814 = PlayerData.Loadout:FindFirstChild(u805);
                local v815;

                if v.Type == "Vest" and v814 ~= nil then
                    v815 = v814:GetAttribute("Vest") == v.Name;
                else
                    v815 = false;
                end;

                if v815 then
                    u4 = {};
                else
                    u4 = v;
                end;

                if PlayerData.Inventory:FindFirstChild(Config.GetItemIDFromItemData(v)) then
                    Config.AddSound("Equip_1", 1, true, SoundService, false);

                    if v815 then
                        ReplicatedStorage.Events.Equip:FireServer("", "Vest");
                    else
                        ReplicatedStorage.Events.Equip:FireServer(v, Loadout:GetAttribute("WeaponClass"));
                    end;

                    Loadout.LoadoutScroller.Buy.Visible = false;
                else
                    Loadout.LoadoutScroller.Buy.Visible = true;
                end;

                u2.CreateItemDisplay(u802, u803, u804);
                u2.UpdateMainDisplay(LocalPlayer, u7.Pages.Loadout.Details.ItemPort);
            end);
        else
            v807.Visible = true;
        end;

        v807:SetAttribute("ItemKey", GetLoadoutScrollerItemKey(v));
        v807.Rarity.Visible = (v.Type == "Head" or (v.Type == "Top" or (v.Type == "Bottom" or (v.Type == "Banner" or (v.Type == "Title" or (v.Type == "Emote" or (v.Type == "Knife" or v.Type == "Skin"))))))) and true or v.Type == "Charm";

        if v806 then
            if u2.CheckedEquipped(PlayerData.Loadout[u805], v, Loadout:GetAttribute("WeaponClass")) then
                v807.DisplaySelect.Visible = true;
                v807.DisplaySelect.UIStroke.Color = Color3.fromRGB(0, 255, 0);
            else
                v807.DisplaySelect.Visible = false;
            end;

            v807.Level.Visible = false;
            v807.Cost.Visible = false;
            v807.ItemPort.ImageColor3 = Color3.fromRGB(255, 255, 255);
            v807.Title.TextTransparency = 0;
        else
            v807.DisplaySelect.Visible = false;
            v807.Level.Visible = true;
            v807.Cost.Visible = true;
            v807.ItemPort.ImageColor3 = Color3.fromRGB(100, 100, 100);

            if v.Level and v.Level > PlayerData.Stats:GetAttribute("Level") then
                v807.Level.TextColor3 = Color3.fromRGB(255, 65, 65);
            else
                v807.Level.TextColor3 = Color3.fromRGB(255, 255, 255);
            end;

            if v.Cost and v.Cost > PlayerData.Stats:GetAttribute("Cash") then
                v807.Cost.TextColor3 = Color3.fromRGB(255, 65, 65);
            else
                v807.Level.TextColor3 = Color3.fromRGB(255, 255, 255);
            end;
        end;

        if u4 == v and not v806 then
            v807.DisplaySelect.Visible = true;
            v807.DisplaySelect.UIStroke.Color = Color3.fromRGB(255, 255, 255);
        end;

        if v.Quantity and v.Quantity > 1 then
            v807.Quantity.Amount.Text = v.Quantity;
            v807.Quantity.Visible = true;
        else
            v807.Quantity.Visible = false;
        end;
    end;
end;

function SetNotice(u816, p817, u818)
    -- upvalues: Config (copy), ReplicatedStorage (copy), u2 (copy), UserInputService (copy)
    local u819;

    if u818:GetAttribute("Type") == "Ranked" then
        u819 = script.SampleNoticeRanked:Clone();
    else
        u819 = script.SampleNotice:Clone();
    end;

    u819.Parent = u816;
    u819.LayoutOrder = p817;

    if u818:GetAttribute("LayoutOrder") then
        u819.LayoutOrder = u818:GetAttribute("LayoutOrder");
    end;

    if u818:GetAttribute("Type") == "Ranked" then
        u819.LayoutOrder = u819.LayoutOrder + 50;
    end;

    u819.Title.Text = u818:GetAttribute("Title");
    u819.Message.Text = u818:GetAttribute("Message");
    u819.Background.Banner.Image = u818:GetAttribute("Image") or "";
    u819.Yes.Activated:Connect(function() -- Line: 7969
        -- upvalues: Config (ref), ReplicatedStorage (ref), u818 (copy), u819 (ref), u2 (ref), u816 (copy)
        Config.AddSound("Click_3", 1, true, game.SoundService, false);
        ReplicatedStorage.Events.NoticeRead:FireServer(u818.Name);
        u819.Yes.Visible = false;
        u2.TweenCreate(u819, {
            Position = UDim2.new(0.5, 0, -1, 0)
        }, Enum.EasingStyle.Sine, 1, true);
        u819:Destroy();

        if #u816:GetChildren() <= 2 then
            u816.Visible = false;
        end;
    end);

    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        u819.Message.UITextSizeConstraint.MaxTextSize = 15;
    end;
end;

function u2.ConfigNotice() -- Line: 7989
    -- upvalues: u7 (ref), LocalPlayer (copy), Config (copy)
    local NoticeFrame = u7:WaitForChild("Pages"):WaitForChild("Play"):WaitForChild("NoticeFrame");
    LocalPlayer:WaitForChild("PlayerData");
    local u820 = 1;

    if #LocalPlayer:WaitForChild("PlayerData").Notice:GetChildren() > 0 then
        NoticeFrame.Visible = true;
        Config.AddSound("Notification_Notice", 1, true, game.SoundService, false);

        for _, child in pairs(LocalPlayer:WaitForChild("PlayerData").Notice:GetChildren()) do
            SetNotice(NoticeFrame, u820, child);
            u820 = u820 + 1;
        end;
    end;

    LocalPlayer:WaitForChild("PlayerData").Notice.ChildAdded:Connect(function(p821) -- Line: 8008
        -- upvalues: NoticeFrame (copy), u820 (ref)
        NoticeFrame.Visible = true;
        SetNotice(NoticeFrame, u820, p821);
        u820 = u820 + 1;
    end);
end;

function ToggleOnOff(p822, p823)
    if p823 == true then
        p822:SetAttribute("Toggle", true);
        p822.Value.Text = "ON";
        p822.Background.Value.BackgroundColor3 = Color3.fromRGB(60, 95, 60);

        return;
    end;

    p822:SetAttribute("Toggle", false);
    p822.Value.Text = "OFF";
    p822.Background.Value.BackgroundColor3 = Color3.fromRGB(95, 60, 60);
end;

function ToggleString(p824, p825)
    if p825 ~= p824:GetAttribute("String") then
        p824:SetAttribute("String", p825);
        p824.Value.Text = p825;
    end;
end;

local u826 = nil;
local u827 = nil;

function u2.UpdateMainDisplay(p828, p829) -- Line: 8047
    -- upvalues: Utility (copy), GetDisplayedLoadoutName (copy), u7 (ref), u4 (ref), ReplicatedStorage (copy), u2 (copy), Config (copy), u827 (ref), u826 (ref), Weapon (copy), ApplyLoadoutAttachments (copy)
    local PlayerData = p828:FindFirstChild("PlayerData");

    if not PlayerData then
        warn(Utility.formatWarnInstanceIsNil("Player", "PlayerData"));

        return;
    end;

    local v830 = GetDisplayedLoadoutName(p828);
    local v831 = PlayerData.Loadout:FindFirstChild(v830);

    if not v831 then
        warn(Utility.formatWarnInstanceIsNil("Player.PlayerData.Loadout", (tostring(v830))));

        return;
    end;

    local Loadout = u7.Pages.Loadout;
    local v832 = Loadout:GetAttribute("WeaponClass");
    local v833 = Loadout:GetAttribute("LoadoutType") or "Character";
    local v834;

    if typeof(u4) == "table" or typeof(u4) == "Instance" then
        v834 = u4.Name;
    else
        v834 = nil;
    end;

    if (v833 == "Throwable" or (v833 == "Knife" or v833 == "Vest")) and (v834 == nil or v834 == "") then
        v834 = v831:GetAttribute(v833);
    end;

    if v833 == "Weapon" or v833 == "Skin" then
        if v833 == "Weapon" or v833 == "Skin" then
            p829.WorldModel:ClearAllChildren();
            local v835 = v832 ~= "Primary" and v832 ~= "Secondary" and "Primary" or v832;
            local v836;

            if v834 == nil or (v834 == "" or v833 ~= "Weapon") then
                v836 = ReplicatedStorage.Items.Weapon[v831:GetAttribute(v835 .. "Weapon")]:Clone();
            else
                v836 = ReplicatedStorage.Items.Weapon[v834]:Clone();
            end;

            v836.Parent = p829.WorldModel;
            v836.PrimaryPart = v836:FindFirstChild("Center", true) or v836.Handle;
            v836:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0), Vector3.new(1, 0, 0)));
            Weapon.SetSkinOnWep(v836, v831:GetAttribute(v835 .. "Skin"));
            ApplyLoadoutAttachments(v836, v831, v835, p828);
            Weapon.SetAttachmentSkins(v836, v831, v835);
            u2.SetNewViewPort(p829, Vector3.new(0, -0.2, 0), Vector3.new(0, 0, -7));
            Config.TweenCreate(p829.Camera, {
                FieldOfView = 40
            }, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        end;
    else
        if v833 ~= "Throwable" and (v833 ~= "Knife" and v833 ~= "Vest") then
            if v833 ~= "Sight" and (v833 ~= "Muzzle" and (v833 ~= "Grip" and (v833 ~= "Extra" and v833 ~= "Charm"))) then
                local v837 = ReplicatedStorage.Items.Banner:FindFirstChild(v831:GetAttribute("Banner"));

                if p829.Parent:FindFirstChild("ImageDisplay") then
                    if v837 then
                        p829.Parent.ImageDisplay.Image = v837.Texture;
                    else
                        p829.Parent.ImageDisplay.Image = "";
                    end;
                end;

                local v838 = v831:GetAttribute("Title");
                local TextDisplay = p829.Parent:FindFirstChild("TextDisplay");
                Config.SetTitle(TextDisplay, ReplicatedStorage.Items.Title:FindFirstChild(v838));
                p829.WorldModel:ClearAllChildren();
                local v839 = ReplicatedStorage.Items.Head[v831:GetAttribute("Head")]:Clone();
                v839.PrimaryPart = v839.HumanoidRootPart;
                v839.Parent = p829.WorldModel;
                v839:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, 0)));

                for _, descendant in pairs(v839:GetDescendants()) do
                    if descendant:IsA("Weld") and descendant.Parent.Name ~= "Head" then
                        descendant:Destroy();
                    end;
                end;

                if v833 == "Emote" and v831:GetAttribute("Emote") ~= "" then
                    v839.Humanoid:LoadAnimation(ReplicatedStorage.Items.Emote:WaitForChild(v831:GetAttribute("Emote"))):Play();
                else
                    local u840 = v839.Humanoid:LoadAnimation(script.Animations.Nod);
                    local u841 = v839.Humanoid:LoadAnimation(script.Animations.Gazing);
                    u840:Play();
                    coroutine.resume(coroutine.create(function() -- Line: 8226
                        -- upvalues: u840 (copy), u841 (copy)
                        u840.Stopped:Wait();
                        u841:Play();
                    end));
                end;

                ReplicatedStorage.Items.Top[v831:GetAttribute("Top")]:Clone().Parent = v839;
                ReplicatedStorage.Items.Bottom[v831:GetAttribute("Bottom")]:Clone().Parent = v839;
                local v842 = ReplicatedStorage.Items.Vest:FindFirstChild(v831:GetAttribute("Vest"));

                if v842 then
                    local v843 = v842:Clone();
                    v843.Parent = v839.Torso;
                    v843:PivotTo(v839.Torso.CFrame);

                    for _, child in pairs(v843:GetChildren()) do
                        if child ~= v843.PrimaryPart then
                            Config.WeldObject(child, v843.PrimaryPart, v843.PrimaryPart);
                        end;

                        child.Anchored = false;
                    end;

                    Config.WeldObject(v843.PrimaryPart, v839.Torso, v843.PrimaryPart);
                end;

                if v833 == "Character" then
                    local v844 = script.SampleBody.Holster.CFrame:ToObjectSpace(script.SampleBody["Right Arm"].CFrame);
                    local v845 = script.SampleBody.Holster:Clone();
                    v845.Parent = v839;
                    v845.CFrame = v844:ToObjectSpace(v839["Right Arm"].CFrame);
                    local WeldConstraint = Instance.new("WeldConstraint", v845);
                    WeldConstraint.Part0 = v845;
                    WeldConstraint.Part1 = v839["Right Arm"];
                    v845.Anchored = false;
                    local v846 = ReplicatedStorage.Items.Weapon[v831:GetAttribute("PrimaryWeapon")]:Clone();
                    v846.Parent = v839;
                    v846.PrimaryPart = v846.Handle;
                    v846:SetPrimaryPartCFrame(v839.Holster.CFrame);

                    for _, descendant in pairs(v846:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            if descendant.Name == "Handle" then
                                local WeldConstraint2 = Instance.new("WeldConstraint", v846.Handle);
                                WeldConstraint2.Part0 = descendant;
                                WeldConstraint2.Part1 = v839.Holster;
                            else
                                local WeldConstraint2 = Instance.new("WeldConstraint", v846.Handle);
                                WeldConstraint2.Part0 = descendant;
                                WeldConstraint2.Part1 = v846.Handle;
                            end;

                            descendant.Anchored = false;
                        end;
                    end;

                    Weapon.SetSkinOnWep(v846, v831:GetAttribute("PrimarySkin"));
                    ApplyLoadoutAttachments(v846, v831, "Primary", p828);
                    Weapon.SetAttachmentSkins(v846, v831, "Primary");
                end;

                local v847 = Vector3.new(0, -0.5, -7);
                local v848 = Vector3.new(0, -0.8, 0);

                if v833 == "Top" or v833 == "Vest" then
                    v848 = v839:FindFirstChild("HumanoidRootPart").Position;
                    v847 = Vector3.new(0, 0.2, -4);
                elseif v833 == "Bottom" then
                    v848 = v839:FindFirstChild("HumanoidRootPart").Position - Vector3.new(0, 2, 0);
                    v847 = Vector3.new(0, -1.8, -4);
                elseif v833 == "Head" then
                    v848 = v839:FindFirstChild("Head").Position;
                    v847 = Vector3.new(0, 1.5, -2.5);
                elseif v833 == "Emote" then
                    v848 = Vector3.new(0, -0.5, 0);
                    v847 = Vector3.new(0, 0, -8);
                elseif v833 == "Character" then
                    v848 = Vector3.new(0, 0.55, 0);
                    v847 = Vector3.new(0, 0.55, -4.5);
                end;

                u2.SetNewViewPort(p829, v848, v847);
                Config.TweenCreate(p829.Camera, {
                    FieldOfView = 70
                }, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);

                return;
            end;

            if v834 == "AttachmentSkin" then
                v834 = v831:GetAttribute(v832 .. v833);
            end;

            local v849 = v831:GetAttribute((v832 or "Primary") .. "Weapon");
            local v850;

            if v849 then
                v850 = p829.WorldModel:FindFirstChild(v849);
            else
                v850 = v849;
            end;

            if v850 and (u827 == v833 and v850:FindFirstChild("Center", true)) then
                u826 = v850:FindFirstChild("Center", true).CFrame;
            else
                u826 = nil;
            end;

            p829.WorldModel:ClearAllChildren();
            local v851 = v832 ~= "Primary" and v832 ~= "Secondary" and "Primary" or v832;

            if not v849 or v849 == "" then
                return;
            end;

            local v852 = ReplicatedStorage.Items.Weapon:FindFirstChild(v849);

            if not v852 then
                return;
            end;

            local v853 = v852:Clone();
            v853.Parent = p829.WorldModel;
            v853.PrimaryPart = v853:FindFirstChild("Center", true);

            if u826 == nil then
                v853:PivotTo(CFrame.new(Vector3.new(0, 0, 0), Vector3.new(1, 0, 0)));
            else
                v853:PivotTo(u826);
            end;

            Weapon.SetSkinOnWep(v853, v831:GetAttribute(v851 .. "Skin"));
            ApplyLoadoutAttachments(v853, v831, v851, p828);

            if v834 ~= nil and v834 ~= "" then
                Weapon.SetAttachmentOnWep(v853, v833, v834, p828);
            end;

            Weapon.SetAttachmentSkins(v853, v831, v851);
            local v854 = v853:FindFirstChild(v833, true);

            if not v854 then
                return;
            end;

            local Part = Instance.new("Part", v853);
            Part.Name = "RotationFocus";
            Part.Transparency = 1;
            Part.Size = Vector3.new(0.05, 0.05, 0.05);
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.Anchored = true;
            Part.CFrame = CFrame.new(v854.Position);
            v853.PrimaryPart = Part;
            local Position = v853.PrimaryPart.Position;
            local v855 = Vector3.new(0, 0.6, -5);
            local Position2 = v854.Position;
            local v856 = 25;

            if v833 == "Sight" then
                Position2 = v853:FindFirstChild(v833, true).Position + Vector3.new(0, -0.1, 0);
                v855 = Vector3.new(0, 0.6, -5);
                v856 = 15;
            elseif v833 == "Muzzle" then
                v855 = Vector3.new(0, 0, -5);
            elseif v833 == "Grip" then
                v855 = Vector3.new(0, -0.5, -5);
            end;

            u2.SetNewViewPort(p829, Position2, v855 + Position);
            Config.TweenCreate(p829.Camera, {
                FieldOfView = v856
            }, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
            u827 = v833;

            return;
        end;

        p829.WorldModel:ClearAllChildren();
        local v857 = nil;

        if v834 ~= nil and v834 ~= "" then
            local v858 = ReplicatedStorage.Items:FindFirstChild(v833);

            if v858 then
                v858 = v858:FindFirstChild(v834);
            end;

            if v858 then
                v857 = v858:Clone();
            end;
        end;

        if v857 then
            v857.Parent = p829.WorldModel;
            v857.PrimaryPart = v857:FindFirstChild("Base") or (v857:FindFirstChild("Core") or v857.PrimaryPart);
            v857:PivotTo(CFrame.new(0, 0, 0));
            u2.SetNewViewPort(p829, Vector3.new(0, 0, 0), v833 == "Knife" and Vector3.new(-1, 1, -4) or (v833 == "Vest" and Vector3.new(0, 1, -4.5) or Vector3.new(0, 0.5, -2.5)));
            Config.TweenCreate(p829.Camera, {
                FieldOfView = 50
            }, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        end;
    end;
end;

function u2.RefreshPlayerPorts(p859, p860, p861) -- Line: 8361
    -- upvalues: Config (copy), ReplicatedStorage (copy), Weapon (copy), Rank (copy)
    local v862 = game.PlaceId == Config.InGameID;

    local function PlayVictoryEmote(p863, p864) -- Line: 8408
        -- upvalues: ReplicatedStorage (ref)
        local v865 = p863:FindFirstChildOfClass("Humanoid");

        if v865 == nil then
            return false;
        end;

        local v866 = ReplicatedStorage.Items.Emote:FindFirstChild(p864:GetAttribute("Emote"));

        if v866 == nil then
            return false;
        end;

        local v867 = v865:LoadAnimation(v866);
        v867.Looped = true;
        v867:Play();

        return true;
    end;

    local function PlayDefaultAnimation(u868, u869) -- Line: 8365
        local v870 = u868:FindFirstChildOfClass("Humanoid");

        if v870 == nil then
            return;
        end;

        local u871 = v870:LoadAnimation(script.Animations.NodWeapon);
        local u872 = v870:LoadAnimation(script.Animations.GazingWeapon);
        local u873 = v870:LoadAnimation(script.Animations.GazingWeaponAim);
        u871:Play();
        task.spawn(function() -- Line: 8377
            -- upvalues: u871 (copy), u868 (copy), u872 (copy), u869 (copy), u873 (copy)
            u871.Stopped:Wait();

            if u868 == nil or u868.Parent == nil then
                return;
            end;

            u872:Play();

            if u869 == 1 then
                task.wait(u872.Length);

                if u868 == nil or u868.Parent == nil then
                    return;
                end;

                u872:Stop();
                u873:Play();
                task.wait(u873.Length);

                if u868 == nil or u868.Parent == nil then
                    return;
                end;

                u873:Stop();
                u872:Play();
            end;
        end);
    end;

    for i = 1, #p859:GetChildren() do
        local v874 = p859:FindFirstChild("Port" .. i);

        if v874 ~= nil then
            v874:ClearAllChildren();
            local v875 = p860[i];

            if v875 ~= nil then
                local v876 = v875.PlayerData.Loadout:FindFirstChild(v875.PlayerData.Settings:GetAttribute("LoadoutName"));

                if v876 ~= nil then
                    local v877 = ReplicatedStorage.Items.Head[v876:GetAttribute("Head")]:Clone();
                    v877.Parent = v874;
                    v877.PrimaryPart = v877.HumanoidRootPart;
                    local v878 = v874.Position + Vector3.new(0, 3, 0);
                    v877:SetPrimaryPartCFrame(CFrame.new(v878, v878 + v874.CFrame.LookVector));
                    v877.PrimaryPart.Anchored = true;

                    for _, descendant in pairs(v877:GetDescendants()) do
                        if descendant:IsA("Weld") and descendant.Parent.Name ~= "Head" then
                            descendant:Destroy();
                        end;
                    end;

                    local v879;

                    if v862 == true then
                        v879 = PlayVictoryEmote(v877, v876);
                    else
                        v879 = false;
                    end;

                    if v879 ~= true then
                        PlayDefaultAnimation(v877, i);
                    end;

                    ReplicatedStorage.Items.Top[v876:GetAttribute("Top")]:Clone().Parent = v877;
                    ReplicatedStorage.Items.Bottom[v876:GetAttribute("Bottom")]:Clone().Parent = v877;
                    local v880 = ReplicatedStorage.Items.Vest:FindFirstChild(v876:GetAttribute("Vest"));

                    if v880 then
                        local v881 = v880:Clone();
                        v881.Parent = v877.Torso;
                        v881:PivotTo(v877.Torso.CFrame);

                        for _, child in pairs(v881:GetChildren()) do
                            if child ~= v881.PrimaryPart then
                                Config.WeldObject(child, v881.PrimaryPart, v881.PrimaryPart);
                            end;

                            child.Anchored = false;
                        end;

                        Config.WeldObject(v881.PrimaryPart, v877.Torso, v881.PrimaryPart);
                    end;

                    local v882 = ReplicatedStorage.Items.Weapon[v876:GetAttribute("PrimaryWeapon")]:Clone();
                    v882.Parent = v877;
                    v882.PrimaryPart = v882.Handle;

                    for _, descendant in pairs(v882:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            descendant.CanCollide = false;

                            if descendant.Name ~= "Handle" then
                                local WeldConstraint = Instance.new("WeldConstraint", v882.Handle);
                                WeldConstraint.Part0 = descendant;
                                WeldConstraint.Part1 = v882.Handle;
                            end;

                            descendant.Anchored = false;
                        end;
                    end;

                    Weapon.SetSkinOnWep(v882, v876:GetAttribute("PrimarySkin"));
                    Weapon.SetFullAttachmentOnWeapon(v882, v875);
                    Weapon.SetAttachmentSkins(v882, v876, "Primary");
                    local Motor6D = Instance.new("Motor6D");
                    Motor6D.Name = "HandleW";
                    Motor6D.Parent = v882.Handle;
                    Motor6D.Part0 = v882.Handle;
                    Motor6D.Part1 = v877["Right Arm"];
                    Motor6D.C1 = CFrame.new(-0.3, -1, -0.4) * CFrame.Angles(-1.5707963267948966, 0, 0);
                    local v883 = script.SamplePartyHUD:Clone();
                    v883.Parent = v877.HumanoidRootPart;
                    local v884 = v875.PlayerData:WaitForChild("Stats"):GetAttribute("Level");
                    v883.PlayerName.Text = v875.Name .. "  [" .. v884 .. "]";
                    local v885, _ = Rank.GetRankedImage(v875.PlayerData:WaitForChild("Stats"):GetAttribute("RankedRating"));
                    v883.Info.Rank.Image = "rbxassetid://" .. v885;
                end;
            end;
        end;
    end;
end;

function u2.UpdateHome() -- Line: 8537
    -- upvalues: LocalPlayer (copy), Players (copy), u2 (copy)
    if not LocalPlayer then
        return;
    end;

    local v886 = LocalPlayer.PlayerData.Settings:GetAttribute("Party");
    local v887 = {};

    if v886 == "" then
        v887[#v887 + 1] = LocalPlayer;
    else
        local v888 = Players:FindFirstChild(v886);
        v887[#v887 + 1] = v888 or nil;

        for _, v in pairs(Players:GetPlayers()) do
            if v:WaitForChild("PlayerData"):WaitForChild("Settings"):GetAttribute("Party") == v886 and v.Name ~= v886 then
                v887[#v887 + 1] = v or nil;
            end;
        end;
    end;

    u2.RefreshPlayerPorts(workspace.Lobby.Players, v887, false);
end;

return u2;