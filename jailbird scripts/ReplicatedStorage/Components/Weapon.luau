
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Players = game:GetService("Players");
local Config = require(ReplicatedStorage.Config);
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"));
require(ReplicatedStorage.Modules.TypeModules.Types);
ReplicatedStorage:WaitForChild("Server");
local u1 = { "Sight", "Muzzle", "Grip", "Charm", "Extra" };
local u2 = { "Laser", "Tactical Light" };
table.freeze({ "Front", "Back", "Right", "Left", "Top", "Bottom" });
table.freeze(u1);
local u3 = {};

local function applyRuntimePartProperties(p4, p5, p6) -- Line: 34
    p4.Anchored = p5;
    p4.CanCollide = p6;
    p4.CanTouch = false;
    p4.CanQuery = false;
    p4.CastShadow = false;
    p4.Massless = true;
    p4.AudioCanCollide = false;
end;

local function getTaggedExtra(p7) -- Line: 44
    -- upvalues: u2 (copy), CollectionService (copy)
    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("Model") then
            for _, v in u2 do
                if CollectionService:HasTag(descendant, v) then
                    return descendant, v;
                end;
            end;
        end;
    end;

    return nil, nil;
end;

local function initializeExtraAttachment(p8) -- Line: 58
    -- upvalues: u2 (copy), CollectionService (copy), RunService (copy), Config (copy)
    local v9 = false;

    for _, v in u2 do
        if CollectionService:HasTag(p8, v) then
            v9 = true;
            break;
        end;
    end;

    if v9 ~= true then
        return;
    end;

    p8:SetAttribute("Active", false);
    p8:SetAttribute("HideForOwner", false);
    p8:SetAttribute("LaserHitPosition", nil);
    p8:SetAttribute("TargetPosition", nil);

    if RunService:IsClient() and (workspace.CurrentCamera and (p8:IsDescendantOf(workspace.CurrentCamera) and p8:GetAttribute("__WeaponExtraComponentInitialized") ~= true)) then
        p8:SetAttribute("__WeaponExtraComponentInitialized", true);
        Config.AddComponents(p8);
    end;
end;

function u3.InitializeExtraAttachment(p10) -- Line: 85
    -- upvalues: initializeExtraAttachment (copy)
    initializeExtraAttachment(p10);
end;

function u3.GetWeaponExtra(p11) -- Line: 89
    -- upvalues: getTaggedExtra (copy)
    return getTaggedExtra(p11);
end;

function u3.HasLaser(p12) -- Line: 93
    -- upvalues: getTaggedExtra (copy)
    local _, v13 = getTaggedExtra(p12);

    return v13 == "Laser";
end;

function u3.SetExtraTarget(p14, p15) -- Line: 98
    -- upvalues: getTaggedExtra (copy)
    local v16, v17 = getTaggedExtra(p14);

    if not v16 or v17 ~= "Laser" then
        return false;
    end;

    if v16:GetAttribute("LaserHitPosition") ~= p15 then
        v16:SetAttribute("LaserHitPosition", p15);
    end;

    if v16:GetAttribute("TargetPosition") ~= nil then
        v16:SetAttribute("TargetPosition", nil);
    end;

    return true;
end;

function u3.SetExtraState(p18, p19, p20) -- Line: 115
    -- upvalues: getTaggedExtra (copy), u3 (copy)
    local v21 = getTaggedExtra(p18);

    if not v21 then
        return false;
    end;

    if v21:GetAttribute("Active") ~= p19 then
        v21:SetAttribute("Active", p19);
    end;

    if p20 ~= nil and v21:GetAttribute("HideForOwner") ~= p20 then
        v21:SetAttribute("HideForOwner", p20);
    end;

    if p19 ~= true then
        u3.SetExtraTarget(p18, nil);
    end;

    return true;
end;

function u3.SetExclusiveExtraState(p22, p23, p24) -- Line: 136
    -- upvalues: u3 (copy)
    for _, v in pairs(p22) do
        if v and v.Parent ~= nil then
            local v25 = v == p23;
            u3.SetExtraState(v, v25, v25 and p24 and p24 or false);
        end;
    end;
end;

function u3.SetAttachmentSkins(p26, p27, p28) -- Line: 145
    -- upvalues: Utility (copy), ReplicatedStorage (copy)
    for _, child in p26:GetChildren() do
        if child:IsA("Model") then
            local v29 = child:GetAttribute("Type");

            if v29 then
                if p28 == "Primary" and true or p28 == "Secondary" then
                    local v30 = p27:GetAttribute(p28 .. v29 .. "Skin");

                    if v30 and v30 ~= "" then
                        local v31 = ReplicatedStorage.Items.AttachmentSkin:FindFirstChild(v30);

                        if not v31 then
                            warn(Utility.formatWarnInstanceIsNil("ReplicatedStorage.Items.AttachmentSkin", (tostring(v30))));

                            return;
                        end;

                        local Texture = v31.Texture;

                        for _, child2 in child:GetChildren() do
                            if child2:IsA("MeshPart") then
                                child2.TextureID = Texture;
                            end;
                        end;
                    end;
                else
                    Utility.warnCustom("WeaponClass is not valid: " .. tostring(p28));
                end;
            end;
        end;
    end;
end;

function u3.SetSkinOnWep(p32, p33) -- Line: 172
    -- upvalues: Utility (copy), ReplicatedStorage (copy)
    if not p32 then
        warn(Utility.warnCustom("Argument weaponModel is nil"));

        return;
    end;

    if not p33 then
        warn(Utility.warnCustom("Argument skin is nil"));

        return;
    end;

    if p33 == "" then
        return;
    end;

    local v34 = ReplicatedStorage.Items.Skin:FindFirstChild(p33);

    if v34 then
        for _, child in p32:GetChildren() do
            if not child:IsA("Script") and (not child:IsA("Model") and child ~= p32.Handle) then
                local Name = child.Name;

                if child.Color == p32.Handle.Color or ((Name == "Body" or Name == "TopCover") and true or Name == "Iron Sight") then
                    for _, child2 in child:GetChildren() do
                        if child2:IsA("Texture") then
                            child2:Destroy();
                        end;
                    end;

                    if child:IsA("MeshPart") then
                        child.TextureID = v34.Texture;
                        child.Color = Color3.new(1, 1, 1);
                    end;
                end;
            end;
        end;

        return;
    end;

    warn(Utility.formatWarnInstanceIsNil("ReplicatedStorage.Items.Skin", p33, "Could not find a weapon skin with given name"));
end;

function u3.WeldToSomething(p35, p36) -- Line: 228
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p35;
    WeldConstraint.Part1 = p36;
    WeldConstraint.Parent = p36;
end;

function u3.WeldWeapon(p37) -- Line: 235
    -- upvalues: u3 (copy)
    if not p37.PrimaryPart then
        p37.PrimaryPart = p37.Handle;
    end;

    for _, descendant in p37:GetDescendants() do
        if descendant:IsA("BasePart") then
            local Name = descendant.Name;

            if Name == "Magazine" or Name == "TopCover" then
                local Motor6D = Instance.new("Motor6D");
                Motor6D.Name = descendant.Name .. "Motor";
                Motor6D.Part0 = p37.PrimaryPart;
                Motor6D.Part1 = descendant;
                Motor6D.C0 = p37.PrimaryPart.CFrame:ToObjectSpace(descendant.CFrame);
                Motor6D.Parent = p37.PrimaryPart;
            else
                u3.WeldToSomething(descendant, p37.PrimaryPart);
                descendant.Massless = true;
            end;

            descendant.Anchored = false;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.CastShadow = false;
            descendant.Massless = true;
            descendant.AudioCanCollide = false;
        end;
    end;
end;

function u3.GetWeaponsOfClass(p38) -- Line: 259
    -- upvalues: ReplicatedStorage (copy)
    local v39 = {};

    for _, child in ReplicatedStorage.Items.Weapon:GetChildren() do
        if child:GetAttribute("Class") == p38 then
            table.insert(v39, child);
        end;
    end;

    return v39;
end;

function u3.GetSightsOfClass(p40) -- Line: 271
    -- upvalues: ReplicatedStorage (copy)
    local v41 = {};

    for _, child in ReplicatedStorage.Items.Sight:GetChildren() do
        if child:GetAttribute("Class") == p40 then
            table.insert(v41, child);
        end;
    end;

    return v41;
end;

function u3.GetSkinOfRarity(p42) -- Line: 283
    -- upvalues: ReplicatedStorage (copy)
    local v43 = {};

    for _, child in ReplicatedStorage.Items.Skin:GetChildren() do
        if child:GetAttribute("Rarity") == p42 then
            table.insert(v43, child);
        end;
    end;

    return v43;
end;

function u3.SetModelProperties(p44, p45, p46) -- Line: 295
    for _, descendant in p44:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = p45;
            descendant.CanCollide = p46;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.CastShadow = false;
            descendant.Massless = true;
            descendant.AudioCanCollide = false;
        end;
    end;
end;

function u3.WeldModel(p47, p48, p49) -- Line: 302
    -- upvalues: u3 (copy)
    p47.PrimaryPart = p48;

    for _, descendant in p47:GetDescendants() do
        if descendant:IsA("BasePart") then
            u3.WeldToSomething(descendant, p48);
            descendant.Massless = true;
            descendant.AudioCanCollide = false;
        end;
    end;

    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p47.PrimaryPart;
    WeldConstraint.Part1 = p48;
    WeldConstraint.Parent = p48;

    if not p49 then
        for _, descendant in p47:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = false;
                descendant.CanCollide = false;
                descendant.CanTouch = false;
                descendant.CanQuery = false;
                descendant.CastShadow = false;
                descendant.Massless = true;
                descendant.AudioCanCollide = false;
            end;
        end;
    end;
end;

function u3.WeldToHandle(p50, p51, p52) -- Line: 325
    -- upvalues: u3 (copy)
    p50.PrimaryPart = p50.Base;

    for _, descendant in p50:GetDescendants() do
        if descendant:IsA("BasePart") then
            u3.WeldToSomething(descendant, p50.PrimaryPart);
            descendant.Massless = true;
            descendant.AudioCanCollide = false;
            descendant.Anchored = p52 == true;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.CastShadow = false;
            descendant.Massless = true;
            descendant.AudioCanCollide = false;
        end;
    end;

    local WeldConstraint = Instance.new("WeldConstraint", p51);
    WeldConstraint.Part0 = p50.PrimaryPart;
    WeldConstraint.Part1 = p51;

    if p52 == false then
        for _, descendant in p50:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = false;
                descendant.CanCollide = false;
                descendant.CanTouch = false;
                descendant.CanQuery = false;
                descendant.CastShadow = false;
                descendant.Massless = true;
                descendant.AudioCanCollide = false;
            end;
        end;
    end;
end;

function u3.SetAttachmentOnWep(p53, p54, p55, u56) -- Line: 348
    -- upvalues: Utility (copy), ReplicatedStorage (copy), u3 (copy), initializeExtraAttachment (copy)
    if not p55 then
        warn(Utility.warnCustom("arg attachment is nil"));

        return;
    end;

    for _, child in p53:GetChildren() do
        if ReplicatedStorage.Items[p54]:FindFirstChild(child.Name) ~= nil then
            child:Destroy();
        end;
    end;

    if p55 == "" then
        return;
    end;

    local v57 = ReplicatedStorage.Items[p54]:FindFirstChild(p55);

    if v57 then
        local v58 = p53.Nodes:FindFirstChild(p54);
        local v59 = nil;

        if v58 ~= nil then
            local u60 = v57:Clone();
            u60.Parent = p53;

            if p54 == "Charm" then
                task.delay(1, function() -- Line: 373
                    -- upvalues: u60 (copy), u56 (copy)
                    local Glow = u60:FindFirstChild("Glow", true);

                    if Glow then
                        Glow.Parent = u56.Character or u56.CharacterAdded:Wait();
                    end;
                end);
            end;

            if u60.PrimaryPart == nil then
                u60.PrimaryPart = u60.Base;
            end;

            u60:SetPrimaryPartCFrame(v58.CFrame);

            if p54 == "Sight" and p53:FindFirstChild("TopCover") then
                u3.WeldToHandle(u60, p53:FindFirstChild("TopCover"), false);
            else
                u3.WeldToHandle(u60, p53.PrimaryPart, false);
            end;

            if p54 == "Sight" then
                for _, child in p53:GetChildren() do
                    if child.Name == "Iron Sight" then
                        child:Destroy();
                    elseif child.Name == "Aim" then
                        child:Destroy();
                        u60.Aim:SetAttribute("AimZ", u60:GetAttribute("AimZ"));
                        u60.Aim.Parent = p53;
                    end;
                end;

                if u60:FindFirstChild("Front") ~= nil then
                    v59 = u60:FindFirstChild("Front");
                end;
            end;

            if p54 == "Extra" and u56 then
                u60:SetAttribute("Owner", u56.Name);
            elseif u60:GetAttribute("Owner") and u56 then
                u60:SetAttribute("Owner", u56.Name);
            end;

            if p54 == "Extra" then
                initializeExtraAttachment(u60);
            end;
        end;

        return v59;
    end;

    warn(Utility.formatWarnInstanceIsNil("ReplicatedStorage.Items." .. tostring(p54), (tostring(p55))));
end;

function u3.SetPlayerArmSkin(p61, p62) -- Line: 425
    -- upvalues: Utility (copy), ReplicatedStorage (copy)
    local Top = p61:FindFirstChild("Top");

    if Top then
        Top:Destroy();
    end;

    local PlayerData = p62:FindFirstChild("PlayerData");

    if not PlayerData then
        warn(Utility.formatWarnInstanceIsNil("Player", "PlayerData"));

        return;
    end;

    local v63 = PlayerData.Loadout[PlayerData.Settings:GetAttribute("LoadoutName") or "Default"]:GetAttribute("Top");
    local v64 = ReplicatedStorage.Items.Top:FindFirstChild(v63):Clone();
    v64.Parent = p61;
    v64.Name = "Top";
end;

function u3.SetFullAttachmentOnWeapon(p65, p66) -- Line: 439
    -- upvalues: Utility (copy), ReplicatedStorage (copy), u1 (copy), u3 (copy)
    local PlayerData = p66:FindFirstChild("PlayerData");

    if not PlayerData then
        warn(Utility.formatWarnInstanceIsNil("Player", "PlayerData"));

        return;
    end;

    if p66:FindFirstChild("ServerData") then
        local v67 = PlayerData.Loadout[PlayerData.Settings:GetAttribute("LoadoutName")] or PlayerData.Loadout.Default;
        local v68 = ReplicatedStorage.Items.Weapon[p65.Name]:GetAttribute("Class");
        local v69 = 0;
        local v70 = 0;
        local v71 = 0;
        local v72 = 0;
        local v73 = 0;
        local v74 = nil;

        for _, v in u1 do
            if v == "Sight" then
                v74 = u3.SetAttachmentOnWep(p65, v, v67:GetAttribute(v68 .. v), p66);
            else
                u3.SetAttachmentOnWep(p65, v, v67:GetAttribute(v68 .. v), p66);
            end;

            if v67:GetAttribute(v68 .. v) then
                local v75 = ReplicatedStorage.Items[v]:FindFirstChild(v67:GetAttribute(v68 .. v));

                if v75 then
                    v69 = v69 + (v75:GetAttribute("Horizontal") or 0);
                    v70 = v70 + (v75:GetAttribute("Vertical") or 0);
                    v71 = v71 + (v75:GetAttribute("SuppressFlash") or 0);
                    v72 = v72 + (v75:GetAttribute("SuppressSound") or 0);
                    v73 = v73 + (v75:GetAttribute("HipFireReduction") or 0);
                end;
            end;
        end;

        p65:SetAttribute("Horizontal", v69);
        p65:SetAttribute("Vertical", v70);
        p65:SetAttribute("SuppressFlash", v71);
        p65:SetAttribute("SuppressSound", v72);
        p65:SetAttribute("HipFireReduction", v73);

        return v74, v69, v70, v71, v72, v73;
    end;

    warn(Utility.formatWarnInstanceIsNil("Player", "ServerData"));
end;

function u3.RemoveSurfaceGui(p76) -- Line: 497
    for _, descendant in p76:GetDescendants() do
        if descendant:IsA("SurfaceGui") then
            descendant.Enabled = false;
        end;
    end;
end;

function u3.SetupWeaponEffects(p77) -- Line: 505
    local v78 = script.Aim:Clone();
    v78.Name = "AimUp";
    v78.Parent = p77.Handle;
    local v79 = script.Aim:Clone();
    v79.Name = "AimDown";
    v79.Parent = p77.Handle;
    script.Suppressor:Clone().Parent = p77.Handle;

    for _, child in script.Muzzle:GetChildren() do
        child:Clone().Parent = p77.Handle.FirePoint;
    end;
end;

local function bindPooledSound(u80) -- Line: 523
    if u80:GetAttribute("__PooledSoundBound") == true then
        return;
    end;

    u80:SetAttribute("__PooledSoundBound", true);
    u80.Ended:Connect(function() -- Line: 529
        -- upvalues: u80 (copy)
        if u80.Parent then
            u80:SetAttribute("Playing", false);
            u80.TimePosition = 0;
        end;
    end);
end;

local u81 = 0;

local function getSoundPolicy(p82, p83) -- Line: 539
    -- upvalues: Config (copy)
    local v84 = Config.WeaponSoundPoolSize or 6;
    local v85 = Config.MaxSimultaneousGunfireVoices or 3;
    local v86 = false;
    local CurrentCamera = workspace.CurrentCamera;
    local v87;

    if CurrentCamera == nil then
        v87 = false;
    else
        v87 = p83:IsDescendantOf(CurrentCamera);
    end;

    local v88 = p82.Name == "GunClick";

    if not (p82.Name == "Fire" and true or p82.Name == "Suppressor") then
        return v84, v88 and (Config.GunClickMaxVoices or 1) or v85, v86;
    end;

    local v89;

    if v87 then
        v89 = Config.LocalGunfireMaxVoices or v85;
    else
        v89 = Config.RemoteGunfireMaxVoices or v85;
    end;

    return v84, v89, Config.GunfireVoiceSteal == true;
end;

local function acquirePooledSound(p90, p91, p92, p93, p94) -- Line: 563
    -- upvalues: bindPooledSound (copy)
    local v95 = 0;
    local v96 = nil;
    local v97 = 0;
    local v98 = nil;
    local v99 = (1 / 0);

    for _, child in p91:GetChildren() do
        if child:IsA("Sound") and child.Name == p90.Name then
            v95 = v95 + 1;
            bindPooledSound(child);

            if child:GetAttribute("Playing") == true then
                v97 = v97 + 1;
                local v100 = child:GetAttribute("__LastPlaySerial") or 0;

                if v98 == nil or v100 < v99 then
                    v99 = v100;
                    v98 = child;
                end;
            elseif v96 == nil then
                v96 = child;
            end;
        end;
    end;

    if v96 then
        return v96;
    end;

    if v95 >= p92 or v97 >= p93 then
        if p94 == true and v98 ~= nil then
            return v98;
        end;

        return nil;
    end;

    local v101 = p90:Clone();
    v101.Parent = p91;
    bindPooledSound(v101);

    return v101;
end;

function u3.AddSFX(p102, p103, p104, p105) -- Line: 607
    -- upvalues: getSoundPolicy (copy), acquirePooledSound (copy), Players (copy), u81 (ref), SoundService (copy)
    if not (p102 and p103) then
        return;
    end;

    local v106, v107, v108 = getSoundPolicy(p102, p103);
    local u109 = acquirePooledSound(p102, p103, v106, v107, v108);

    if u109 == nil then
        return;
    end;

    u109:Stop();
    u109.TimePosition = 0;
    u109.SoundId = p102.SoundId;
    u109.RollOffMaxDistance = p102.RollOffMaxDistance;
    u109.RollOffMinDistance = p102.RollOffMinDistance;
    u109.RollOffMode = p102.RollOffMode;
    u109.EmitterSize = p102.EmitterSize;
    local v110 = 1;

    if Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerData") then
        v110 = Players.LocalPlayer.PlayerData:FindFirstChild("Settings") and (Players.LocalPlayer.PlayerData.Settings:GetAttribute("MasterVolume") or 1) or v110;
    end;

    local PlaybackSpeed = p102.PlaybackSpeed;

    if p105 then
        PlaybackSpeed = PlaybackSpeed + math.random(-100, 100) / 1000;
    end;

    u81 = u81 + 1;
    u109:SetAttribute("__LastPlaySerial", u81);
    u109.PlaybackSpeed = PlaybackSpeed;
    u109.Volume = p102.Volume * (p104 or 1) * v110;
    u109:SetAttribute("Playing", true);
    SoundService:PlayLocalSound(u109);
    local delay2 = task.delay;
    local v111 = u109.TimeLength / math.max(u109.PlaybackSpeed, 0.05);
    delay2(math.max(v111, 0.05), function() -- Line: 643
        -- upvalues: u109 (copy)
        if u109.Parent and u109.IsPlaying ~= true then
            u109:SetAttribute("Playing", false);
            u109.TimePosition = 0;
        end;
    end);
end;

function u3.MuzzleShootEffect(p112) -- Line: 652
    -- upvalues: u3 (copy)
    local Handle = p112:FindFirstChild("Handle");

    if Handle == nil then
        return nil;
    end;

    local v113 = p112:GetAttribute("SuppressFlash") or 0;
    local u114 = p112:GetAttribute("SuppressSound") or 0;
    local FirePoint = Handle:FindFirstChild("FirePoint");
    local u115;

    if FirePoint then
        u115 = FirePoint:FindFirstChild("Light");
    else
        u115 = FirePoint;
    end;

    local v116;

    if FirePoint then
        v116 = FirePoint:FindFirstChild("Flash");
    else
        v116 = FirePoint;
    end;

    local v117;

    if FirePoint then
        v117 = FirePoint:FindFirstChild("Flash2");
    else
        v117 = FirePoint;
    end;

    local u118;

    if FirePoint then
        u118 = FirePoint:FindFirstChild("Smoke");
    else
        u118 = FirePoint;
    end;

    local u119 = FirePoint or Handle;

    if u115 and u115:IsA("Light") then
        u115.Brightness = math.clamp(1 - v113, 0, 1);
        u115.Enabled = true;
    end;

    if v113 < 0.5 then
        if v116 and v116:IsA("ParticleEmitter") then
            v116:Emit(1);
        end;

        if v117 and v117:IsA("ParticleEmitter") then
            v117:Emit(1);
        end;
    end;

    if u118 and u118:IsA("ParticleEmitter") then
        u118.Enabled = true;
    end;

    delay(0.05, function() -- Line: 684
        -- upvalues: u115 (copy), u118 (copy), Handle (copy), u3 (ref), u119 (copy), u114 (copy)
        if u115 and u115.Parent then
            u115.Enabled = false;
        end;

        if u118 and u118.Parent then
            u118.Enabled = false;
        end;

        if Handle:FindFirstChild("Fire") then
            u3.AddSFX(Handle.Fire, u119, math.clamp((1 - u114) / 2, 0, 1), true);

            if u114 >= 0.5 and Handle:FindFirstChild("Suppressor") then
                u3.AddSFX(Handle.Suppressor, u119, math.clamp(1 - u114, 0, 1), true);
            end;
        end;
    end);
end;

return u3;