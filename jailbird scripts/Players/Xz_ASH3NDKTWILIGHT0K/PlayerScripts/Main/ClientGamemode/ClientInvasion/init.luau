
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local StarterGui = game:GetService("StarterGui");
local Players = game:GetService("Players");
local Modules = ReplicatedStorage:WaitForChild("Modules");
require(Modules.TypeModules.InvasionTypes);
require(Modules:WaitForChild("Constants"));
require(Modules:WaitForChild("TypeModules"):WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local Invasion = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameModes"):WaitForChild("Invasion");
local RoundDisplay = script.RoundDisplay;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = `[{script.Name}]`;
local u7 = { {
        value = 1000,
        symbol = "M"
    }, {
        value = 900,
        symbol = "CM"
    }, {
        value = 500,
        symbol = "D"
    }, {
        value = 400,
        symbol = "CD"
    }, {
        value = 100,
        symbol = "C"
    }, {
        value = 90,
        symbol = "XC"
    }, {
        value = 50,
        symbol = "L"
    }, {
        value = 40,
        symbol = "XL"
    }, {
        value = 10,
        symbol = "X"
    }, {
        value = 9,
        symbol = "IX"
    }, {
        value = 5,
        symbol = "V"
    }, {
        value = 4,
        symbol = "IV"
    }, {
        value = 1,
        symbol = "I"
    } };
table.freeze(u7);

local function intToRoman(p8) -- Line: 58
    -- upvalues: u7 (copy)
    local v9;

    if p8 > 0 then
        v9 = p8 < 4000;
    else
        v9 = false;
    end;

    assert(v9, "Number must be between 1 and 3999");
    local v10 = {};

    for _, v in u7 do
        local value = v.value;
        local symbol = v.symbol;

        while value <= p8 do
            p8 = p8 - value;
            v10[#v10 + 1] = symbol;
        end;
    end;

    return table.concat(v10);
end;

local function updateRoundNumberUI(p11) -- Line: 76
    -- upvalues: TweenService (copy), RoundDisplay (copy), intToRoman (copy)
    local v12 = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
    local v13 = TweenService:Create(RoundDisplay, v12, {
        TextColor3 = Color3.fromRGB(193, 0, 0)
    });
    local v14 = TweenService:Create(RoundDisplay.UIStroke, v12, {
        Thickness = 1,
        Color = Color3.new(0, 0, 0)
    });
    RoundDisplay.UIStroke.Color = Color3.new(1, 1, 1);
    RoundDisplay.UIStroke.Thickness = 2;
    RoundDisplay.TextColor3 = Color3.fromRGB(255, 177, 121);
    RoundDisplay.Text = intToRoman(p11);
    v13:Play();
    v14:Play();
end;

local function onRoundStart(p15) -- Line: 91
    -- upvalues: updateRoundNumberUI (copy), u1 (ref)
    updateRoundNumberUI(p15);

    if u1 then
        u1:Play();

        return;
    end;

    warn("No round start sound set up");
end;

local function onRoundEnd() -- Line: 97
    -- upvalues: LocalPlayer (copy), u2 (ref)
    local CurrentCamera = workspace.CurrentCamera;
    local Character = LocalPlayer.Character;
    CurrentCamera:ClearAllChildren();

    if Character and Character:FindFirstChild("ClientWeaponSystem") then
        Character:FindFirstChild("ClientWeaponSystem"):Destroy();
    end;

    LocalPlayer.CameraMinZoomDistance = 0.5;
    LocalPlayer.CameraMaxZoomDistance = 0.5;
    CurrentCamera.CameraType = Enum.CameraType.Custom;

    if Character and Character:FindFirstChild("Humanoid") then
        CurrentCamera.CameraSubject = Character.Humanoid;
    end;

    LocalPlayer.PlayerGui.GameHUD.SpectatorUI.Visible = false;
    LocalPlayer.PlayerGui.GameHUD.SpectatorUI.Visible = false;

    if u2 then
        u2:Play();

        return;
    end;

    warn("No round end sound set up");
end;

local function createNewSoundFromConfig(p16, p17) -- Line: 121
    -- upvalues: SoundService (copy)
    local Sound = Instance.new("Sound");
    Sound.Name = p16;
    Sound.SoundId = p17.SoundId;
    Sound.Volume = p17.Volume;
    Sound.Parent = SoundService;

    return Sound;
end;

local function onGameEnded(p18) -- Line: 132
    -- upvalues: ReplicatedStorage (copy), u4 (ref), u5 (ref), u6 (copy), LocalPlayer (copy)
    ReplicatedStorage.Config.Audio.Round_End0:Destroy();
    ReplicatedStorage.Config.Audio.Round_End1:Destroy();
    ReplicatedStorage.Config.Audio.Round_End2:Destroy();
    ReplicatedStorage.Config.Audio.Round_End3:Destroy();
    ReplicatedStorage.Config.Audio.Round_End4:Destroy();
    ReplicatedStorage.Config.Audio.Round_End5:Destroy();

    if not (u4 and u5) then
        warn((`{u6} Game won/lost sound not initialised`));

        return;
    end;

    if p18 then
        u4:Play();
    else
        u5:Play();
    end;

    LocalPlayer.PlayerGui.GameHUD.Enabled = false;
    workspace.CurrentCamera:ClearAllChildren();
    LocalPlayer.Character:FindFirstChild("ClientWeaponSystem"):Destroy();
end;

Invasion:WaitForChild("RoundStart").OnClientEvent:Connect(onRoundStart);
Invasion:WaitForChild("RoundEnd").OnClientEvent:Connect(onRoundEnd);
Invasion:WaitForChild("GameEnd").OnClientEvent:Connect(onGameEnded);
Invasion:WaitForChild("RewardRecieved").OnClientEvent:Connect(function() -- Line: 153, Name: onRewardRecieved
    -- upvalues: StarterGui (copy)
    StarterGui:SetCore(
        "SendNotification",
        {
            Title = "+1 Spooky 2025",
            Text = "You received a Spooky 2025 crate",
            Icon = "rbxassetid://94770689864028"
        }
    );
end);

return function(p19) -- Line: 166
    -- upvalues: SoundService (copy), u3 (ref), u1 (ref), u2 (ref), u4 (ref), u5 (ref), RoundDisplay (copy), Players (copy)
    if p19 ~= "Spooky" and p19 ~= "Winter" then
        warn("Failed to start invasion becaause invasionType is invalid: " .. tostring(p19));

        return;
    end;

    local v20 = require(script:WaitForChild(p19));
    local AMBIENCE_SOUND = v20.AMBIENCE_SOUND;
    local Sound = Instance.new("Sound");
    Sound.Name = "InvasionAmbience";
    Sound.SoundId = AMBIENCE_SOUND.SoundId;
    Sound.Volume = AMBIENCE_SOUND.Volume;
    Sound.Parent = SoundService;
    Sound.Looped = true;
    Sound:Play();
    u3 = Sound;
    local ROUND_START_SOUND = v20.ROUND_START_SOUND;
    local Sound2 = Instance.new("Sound");
    Sound2.Name = "InvasionStartRound";
    Sound2.SoundId = ROUND_START_SOUND.SoundId;
    Sound2.Volume = ROUND_START_SOUND.Volume;
    Sound2.Parent = SoundService;
    u1 = Sound2;
    local ROUND_ENDED_SOUND = v20.ROUND_ENDED_SOUND;
    local Sound3 = Instance.new("Sound");
    Sound3.Name = "InvasionEndRound";
    Sound3.SoundId = ROUND_ENDED_SOUND.SoundId;
    Sound3.Volume = ROUND_ENDED_SOUND.Volume;
    Sound3.Parent = SoundService;
    u2 = Sound3;
    local GAME_WON_SOUND = v20.GAME_WON_SOUND;
    local Sound4 = Instance.new("Sound");
    Sound4.Name = "InvasionGameWon";
    Sound4.SoundId = GAME_WON_SOUND.SoundId;
    Sound4.Volume = GAME_WON_SOUND.Volume;
    Sound4.Parent = SoundService;
    u4 = Sound4;
    local GAME_LOST_SOUND = v20.GAME_LOST_SOUND;
    local Sound5 = Instance.new("Sound");
    Sound5.Name = "InvasionGameLost";
    Sound5.SoundId = GAME_LOST_SOUND.SoundId;
    Sound5.Volume = GAME_LOST_SOUND.Volume;
    Sound5.Parent = SoundService;
    u5 = Sound5;
    RoundDisplay.Text = "";
    RoundDisplay.Parent = Players.LocalPlayer.PlayerGui.GameHUD;
end;