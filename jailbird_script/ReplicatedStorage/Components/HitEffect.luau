
local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local ContentProvider = game:GetService("ContentProvider");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Map_Cache = game.Workspace.Map_Cache;
local Config = require(game.ReplicatedStorage.Config);
local Server = ReplicatedStorage:WaitForChild("Server");
local Effects = script.Effects;
local BulletHoles = script.BulletHoles;
local LocalPlayer = Players.LocalPlayer;
local u1 = { "Concrete", "Metal", "Sand", "Wood", "Glass", "Water", "ForceField" };
local u2 = {
    Concrete = "Concrete",
    Default = "Concrete",
    Dirt = "Sand",
    Explosion = "Explosion",
    Fabric = "Sand",
    ForceField = "ForceField",
    Glass = "Glass",
    Hits = "Damage",
    Metal = "Metal",
    Sand = "Sand",
    Water = "Water",
    Whizz = "Whizz",
    Wood = "Wood"
};
local u3 = {};
local HitSound = script:WaitForChild("HitSound");
local u4 = {};
local u5 = nil;

local function CollectSoundTemplates(p6) -- Line: 42
    local v7 = {};

    for _, child in ipairs(p6:GetChildren()) do
        if child:IsA("Sound") then
            table.insert(v7, child);
        end;
    end;

    return v7;
end;

local u9 = (function() -- Line: 52, Name: BuildImpactSoundTemplateRegistry
    -- upvalues: HitSound (copy), CollectSoundTemplates (copy)
    local v8 = {};

    for _, child in ipairs(HitSound:GetChildren()) do
        if child:IsA("Folder") then
            v8[child.Name] = CollectSoundTemplates(child);
        end;
    end;

    return v8;
end)();
local u10 = false;
local u11 = 1;
local u12 = {};

local function IsBarricadeDamageAllowed() -- Line: 67
    -- upvalues: Server (copy)
    if Server:GetAttribute("Phase") ~= "Round Started" then
        return false;
    end;

    local v13 = Server:GetAttribute("RoundStartedAt");

    return typeof(v13) ~= "number" and true or workspace:GetServerTimeNow() - v13 >= 3;
end;

local function GetNormalizedAudioFolder(p14) -- Line: 80
    -- upvalues: u2 (copy)
    local v15 = p14 or "Default";

    return u2[v15] or v15;
end;

local function GetTemplateFallback() -- Line: 85
    -- upvalues: u1 (copy), u9 (copy)
    for _, v in ipairs(u1) do
        local v16 = u9[v];

        if v16 and #v16 > 0 then
            return v16[1];
        end;
    end;

    for _, v in pairs(u9) do
        if #v > 0 then
            return v[1];
        end;
    end;

    return nil;
end;

local function GetSoundTemplatesForCategory(p17) -- Line: 102
    -- upvalues: u2 (copy), u9 (copy), GetTemplateFallback (copy)
    local v18 = p17 or "Default";
    local v19 = u9[u2[v18] or v18];

    if v19 and #v19 > 0 then
        return v19;
    end;

    local v20 = GetTemplateFallback();

    return v20 and { v20 } or {};
end;

local u23 = (function() -- Line: 117, Name: CollectAllImpactSoundTemplates
    -- upvalues: u9 (copy)
    local v21 = {};
    local v22 = {};

    for _, v in ipairs({ "Concrete", "Metal", "Sand", "Wood", "Glass", "Water", "ForceField", "Damage", "Explosion", "Whizz" }) do
        for _, v2 in ipairs(u9[v] or {}) do
            if not v21[v2] then
                v21[v2] = true;
                table.insert(v22, v2);
            end;
        end;
    end;

    for _, v in pairs(u9) do
        for _, v2 in ipairs(v) do
            if not v21[v2] then
                v21[v2] = true;
                table.insert(v22, v2);
            end;
        end;
    end;

    return v22;
end)();

local function GetNextStandbyImpactTemplate() -- Line: 145
    -- upvalues: u1 (copy), GetTemplateFallback (copy), u11 (ref), u9 (copy), u12 (copy)
    local v24 = #u1;

    if v24 <= 0 then
        return GetTemplateFallback();
    end;

    for _ = 1, v24 do
        local v25 = u1[u11];
        u11 = u11 % v24 + 1;
        local v26 = u9[v25];

        if v26 and #v26 > 0 then
            local v27 = (u12[v25] or 0) % #v26 + 1;
            u12[v25] = v27;

            return v26[v27];
        end;
    end;

    return GetTemplateFallback();
end;

local function GetImpactPlaybackSpeed() -- Line: 166
    -- upvalues: Config (copy)
    local v28 = Config.ImpactSoundPlaybackSpeedMin or 0.95;
    local v29 = Config.ImpactSoundPlaybackSpeedMax or 1.05;

    if v29 < v28 then
        local v30 = v28;
        v28 = v29;
        v29 = v30;
    end;

    return v28 + (v29 - v28) * math.random();
end;

local function CheckForHumanoid(p31) -- Line: 177
    return p31 and (p31.Parent and p31.Parent:FindFirstChild("Humanoid")) or nil;
end;

local function ShouldUseFakeBlood() -- Line: 181
    -- upvalues: Config (copy)
    return Config.DamageFeedbackMode == "FakeBlood";
end;

local function FindTaggedAncestor(p32, p33) -- Line: 185
    -- upvalues: CollectionService (copy)
    while p32 and p32 ~= workspace do
        if CollectionService:HasTag(p32, p33) then
            return p32;
        end;

        p32 = p32.Parent;
    end;

    return nil;
end;

local function GetMasterVolume() -- Line: 196
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer and (LocalPlayer:FindFirstChild("PlayerData") and LocalPlayer.PlayerData:FindFirstChild("Settings")) and (LocalPlayer.PlayerData.Settings:GetAttribute("MasterVolume") or 1) or 1;
end;

local function GetShooterBucketId(p34) -- Line: 204
    if typeof(p34) ~= "Instance" then
        return "Shared";
    end;

    if p34:IsA("Player") then
        return "Player_" .. tostring(p34.UserId);
    end;

    return p34:GetFullName();
end;

local function GetShooterPool(p35) -- Line: 216
    -- upvalues: u3 (copy), u5 (ref)
    local v36;

    if typeof(p35) == "Instance" then
        if p35:IsA("Player") then
            v36 = "Player_" .. tostring(p35.UserId);
        else
            v36 = p35:GetFullName();
        end;
    else
        v36 = "Shared";
    end;

    if u3[v36] == nil then
        u3[v36] = {
            BulletHoleCursor = 1,
            EffectHolderCursor = 1,
            SoundAnchorCursor = 1,
            SoundAnchorsReady = false,
            BulletHoles = {},
            EffectHolders = {},
            SoundAnchors = {}
        };
    end;

    local v37 = u3[v36];

    if u5 ~= nil then
        u5(v37);
    end;

    return v37;
end;

local function BindPooledSound(u38) -- Line: 238
    if u38:GetAttribute("__ImpactSoundBound") == true then
        return;
    end;

    u38:SetAttribute("__ImpactSoundBound", true);
    u38.Ended:Connect(function() -- Line: 244
        -- upvalues: u38 (copy)
        if u38.Parent then
            u38:SetAttribute("Playing", false);
            u38.TimePosition = 0;
        end;
    end);
end;

local u39 = 0;

local function ApplyScriptedImpactSoundSettings(p40) -- Line: 254
    p40.Name = "Impact";
    p40.RollOffMaxDistance = 80;
    p40.RollOffMinDistance = 8;
    p40.RollOffMode = Enum.RollOffMode.InverseTapered;
    p40.EmitterSize = 3;
    p40:SetAttribute("__ImpactSound", true);
end;

local function ApplyImpactTemplateToSound(p41, p42) -- Line: 263
    p41:Stop();
    p41.TimePosition = 0;
    p41.SoundId = p42.SoundId;
    p41.Volume = p42.Volume;
    p41.Looped = false;
    p41.Name = "Impact";
    p41.RollOffMaxDistance = 80;
    p41.RollOffMinDistance = 8;
    p41.RollOffMode = Enum.RollOffMode.InverseTapered;
    p41.EmitterSize = 3;
    p41:SetAttribute("__ImpactSound", true);
    p41:SetAttribute("__ImpactBaseVolume", p42.Volume);
    p41:SetAttribute("__ImpactTemplateId", p42.SoundId);
end;

local function CreateConfiguredImpactSound(p43) -- Line: 274
    local v44 = p43:Clone();
    v44:Stop();
    v44.TimePosition = 0;
    v44.SoundId = p43.SoundId;
    v44.Volume = p43.Volume;
    v44.Looped = false;
    v44.Name = "Impact";
    v44.RollOffMaxDistance = 80;
    v44.RollOffMinDistance = 8;
    v44.RollOffMode = Enum.RollOffMode.InverseTapered;
    v44.EmitterSize = 3;
    v44:SetAttribute("__ImpactSound", true);
    v44:SetAttribute("__ImpactBaseVolume", p43.Volume);
    v44:SetAttribute("__ImpactTemplateId", p43.SoundId);

    return v44;
end;

local function CreateSoundAnchorEntry(p45) -- Line: 280
    -- upvalues: Map_Cache (copy), BindPooledSound (copy)
    local Part = Instance.new("Part");
    Part.Name = "ImpactSoundAnchor";
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.Parent = Map_Cache;
    local v46 = {
        Sound = nil,
        Part = Part
    };

    if p45 ~= nil then
        local v47 = p45:Clone();
        v47:Stop();
        v47.TimePosition = 0;
        v47.SoundId = p45.SoundId;
        v47.Volume = p45.Volume;
        v47.Looped = false;
        v47.Name = "Impact";
        v47.RollOffMaxDistance = 80;
        v47.RollOffMinDistance = 8;
        v47.RollOffMode = Enum.RollOffMode.InverseTapered;
        v47.EmitterSize = 3;
        v47:SetAttribute("__ImpactSound", true);
        v47:SetAttribute("__ImpactBaseVolume", p45.Volume);
        v47:SetAttribute("__ImpactTemplateId", p45.SoundId);
        v47.Parent = Part;
        BindPooledSound(v47);
        v46.Sound = v47;
    end;

    return v46;
end;

local function EnsureImpactSoundInstance(p48, p49) -- Line: 307
    -- upvalues: BindPooledSound (copy)
    local Sound = p48.Sound;

    if Sound == nil or Sound.Parent ~= p48.Part then
        Sound = p48.Part:FindFirstChild("Impact");

        if Sound and Sound:IsA("Sound") then
            BindPooledSound(Sound);
        else
            Sound = p49:Clone();
            Sound:Stop();
            Sound.TimePosition = 0;
            Sound.SoundId = p49.SoundId;
            Sound.Volume = p49.Volume;
            Sound.Looped = false;
            Sound.Name = "Impact";
            Sound.RollOffMaxDistance = 80;
            Sound.RollOffMinDistance = 8;
            Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
            Sound.EmitterSize = 3;
            Sound:SetAttribute("__ImpactSound", true);
            Sound:SetAttribute("__ImpactBaseVolume", p49.Volume);
            Sound:SetAttribute("__ImpactTemplateId", p49.SoundId);
            Sound.Parent = p48.Part;
            BindPooledSound(Sound);
        end;

        p48.Sound = Sound;
    end;

    Sound:Stop();
    Sound.TimePosition = 0;
    Sound.SoundId = p49.SoundId;
    Sound.Volume = p49.Volume;
    Sound.Looped = false;
    Sound.Name = "Impact";
    Sound.RollOffMaxDistance = 80;
    Sound.RollOffMinDistance = 8;
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
    Sound.EmitterSize = 3;
    Sound:SetAttribute("__ImpactSound", true);
    Sound:SetAttribute("__ImpactBaseVolume", p49.Volume);
    Sound:SetAttribute("__ImpactTemplateId", p49.SoundId);

    return Sound;
end;

local function u50() -- Line: 326
    -- upvalues: RunService (copy), u10 (ref), Config (copy), u23 (copy), ContentProvider (copy)
    if not RunService:IsClient() then
        return;
    end;

    if u10 == true or Config.ImpactSoundPreloadEnabled == false then
        u10 = true;

        return;
    end;

    u10 = true;

    if #u23 <= 0 then
        return;
    end;

    task.spawn(function() -- Line: 341
        -- upvalues: ContentProvider (ref), u23 (ref)
        pcall(function() -- Line: 342
            -- upvalues: ContentProvider (ref), u23 (ref)
            ContentProvider:PreloadAsync(u23);
        end);
    end);
end;

u5 = function(p51) -- Line: 348
    -- upvalues: RunService (copy), u50 (ref), Config (copy), GetNextStandbyImpactTemplate (copy), CreateSoundAnchorEntry (copy), ContentProvider (copy)
    if not RunService:IsClient() or p51.SoundAnchorsReady == true then
        return;
    end;

    u50();
    local v52 = Config.ImpactSoundPoolSize or 4;
    local v53 = math.min(Config.ImpactSoundStandbyPoolSize or v52, v52);
    local u54 = {};

    while #p51.SoundAnchors < v53 do
        local v55 = GetNextStandbyImpactTemplate();

        if v55 == nil then
            break;
        end;

        local v56 = CreateSoundAnchorEntry(v55);
        table.insert(p51.SoundAnchors, v56);

        if v56.Sound then
            table.insert(u54, v56.Sound);
        end;
    end;

    p51.SoundAnchorsReady = true;

    if #u54 > 0 and Config.ImpactSoundPreloadEnabled ~= false then
        task.spawn(function() -- Line: 375
            -- upvalues: ContentProvider (ref), u54 (copy)
            pcall(function() -- Line: 376
                -- upvalues: ContentProvider (ref), u54 (ref)
                ContentProvider:PreloadAsync(u54);
            end);
        end);
    end;
end;

local function AcquireImpactSoundAnchor(p57, p58) -- Line: 383
    -- upvalues: GetShooterPool (copy), Config (copy), CreateSoundAnchorEntry (copy)
    local v59 = GetShooterPool(p57);
    local v60 = Config.ImpactSoundPoolSize or 4;
    local SoundId = p58.SoundId;
    local v61 = nil;
    local v62 = nil;
    local v63 = nil;
    local v64 = (1 / 0);

    for _, v in ipairs(v59.SoundAnchors) do
        local Sound = v.Sound;

        if Sound == nil or Sound.Parent ~= v.Part then
            if v61 == nil then
                v61 = v;
            end;
        elseif Sound:GetAttribute("Playing") == true then
            local v65 = Sound:GetAttribute("__LastPlaySerial") or 0;

            if v63 == nil or v65 < v64 then
                v64 = v65;
                v63 = v;
            end;
        else
            local v66 = Sound:GetAttribute("__ImpactTemplateId") or Sound.SoundId;

            if v62 == nil then
                if v66 == SoundId then
                    v62 = v;
                end;
            end;

            if v61 == nil then
                v61 = v;
            end;
        end;
    end;

    if v62 then
        return v62;
    end;

    if v61 then
        return v61;
    end;

    if #v59.SoundAnchors >= v60 then
        return v63;
    end;

    local v67 = CreateSoundAnchorEntry(p58);
    table.insert(v59.SoundAnchors, v67);

    return v67;
end;

local function PlayImpactSound(p68, p69, p70) -- Line: 432
    -- upvalues: u50 (ref), AcquireImpactSoundAnchor (copy), EnsureImpactSoundInstance (copy), Config (copy), LocalPlayer (copy), u39 (ref)
    if p68 == nil or p69 == nil then
        return;
    end;

    u50();
    local v71 = AcquireImpactSoundAnchor(p70, p69);

    if v71 == nil then
        return;
    end;

    local Part = v71.Part;

    if p68:IsA("BasePart") then
        Part.CFrame = p68.CFrame;
    elseif p68:IsA("Attachment") and (p68.Parent and p68.Parent:IsA("BasePart")) then
        Part.CFrame = p68.Parent.CFrame;
    end;

    local u72 = EnsureImpactSoundInstance(v71, p69);
    u72.Volume = (u72:GetAttribute("__ImpactBaseVolume") or (p69.Volume or 1)) * (Config.ImpactSoundVolumeMultiplier or 1) * (LocalPlayer and (LocalPlayer:FindFirstChild("PlayerData") and LocalPlayer.PlayerData:FindFirstChild("Settings")) and (LocalPlayer.PlayerData.Settings:GetAttribute("MasterVolume") or 1) or 1);
    local v73 = Config.ImpactSoundPlaybackSpeedMin or 0.95;
    local v74 = Config.ImpactSoundPlaybackSpeedMax or 1.05;

    if v74 >= v73 then
        local v75 = v74;
        v74 = v73;
        v73 = v75;
    end;

    u72.PlaybackSpeed = v74 + (v73 - v74) * math.random();
    u39 = u39 + 1;
    u72:SetAttribute("__LastPlaySerial", u39);
    u72:SetAttribute("Playing", true);
    u72:Play();
    local delay = task.delay;
    local v76 = u72.TimeLength / math.max(u72.PlaybackSpeed, 0.05);
    delay(math.max(v76, 0.05), function() -- Line: 459
        -- upvalues: u72 (copy)
        if u72.Parent and u72.IsPlaying ~= true then
            u72:SetAttribute("Playing", false);
            u72.TimePosition = 0;
        end;
    end);
end;

local function CleanupWelds(p77) -- Line: 467
    for _, child in p77:GetChildren() do
        if child:IsA("WeldConstraint") then
            child:Destroy();
        end;
    end;
end;

local function PlayDeployableBreakSound(p78) -- Line: 475
    -- upvalues: Config (copy)
    local v79 = Config.AddSound("DeployableBreak", nil, false, p78, false);

    if v79 then
        v79.RollOffMinDistance = 8;
        v79.RollOffMaxDistance = 80;
        v79.RollOffMode = Enum.RollOffMode.InverseTapered;
        v79.EmitterSize = 3;
    end;

    return v79;
end;

local function ClearEffectHolderChildren(p80) -- Line: 486
    for _, child in p80:GetChildren() do
        if child:IsA("Sound") and child:GetAttribute("__ImpactSound") == true then
            child:Stop();
            child.TimePosition = 0;
            child:SetAttribute("Playing", false);
        else
            child:Destroy();
        end;
    end;
end;

local function CreateEffectHolderEntry() -- Line: 499
    -- upvalues: Map_Cache (copy)
    local Part = Instance.new("Part");
    Part.Name = "ImpactEffect";
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Parent = Map_Cache;

    return {
        Part = Part
    };
end;

local function AcquireEffectHolder(p81) -- Line: 512
    -- upvalues: GetShooterPool (copy), Config (copy), Map_Cache (copy)
    local v82 = GetShooterPool(p81);
    local v83 = Config.ImpactEffectPerShooterCap or 12;

    if #v82.EffectHolders >= v83 then
        local v84 = v82.EffectHolders[v82.EffectHolderCursor];
        v82.EffectHolderCursor = v82.EffectHolderCursor % v83 + 1;

        return v84;
    end;

    local Part = Instance.new("Part");
    Part.Name = "ImpactEffect";
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Parent = Map_Cache;
    local v85 = {
        Part = Part
    };
    table.insert(v82.EffectHolders, v85);

    return v85;
end;

local function GetRandomBulletHoleTemplate() -- Line: 527
    -- upvalues: BulletHoles (copy)
    local v86 = BulletHoles:GetChildren();

    return v86[math.random(1, #v86)];
end;

local function CreateBulletHoleEntry() -- Line: 532
    -- upvalues: Map_Cache (copy), BulletHoles (copy)
    local Part = Instance.new("Part");
    Part.Name = "BulletHole";
    Part.Size = Vector3.new(0.15, 0.15, 0.03);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.Anchored = false;
    Part.Parent = Map_Cache;
    local v87 = BulletHoles:GetChildren();
    local v88 = v87[math.random(1, #v87)]:Clone();
    v88.Face = Enum.NormalId.Front;
    v88.Parent = Part;

    return {
        Part = Part,
        Decal = v88
    };
end;

local function AcquireBulletHoleEntry(p89) -- Line: 551
    -- upvalues: GetShooterPool (copy), Config (copy), CreateBulletHoleEntry (copy)
    local v90 = GetShooterPool(p89);
    local v91 = Config.BulletHolePerShooterCap or 16;

    if #v90.BulletHoles < v91 then
        local v92 = CreateBulletHoleEntry();
        table.insert(v90.BulletHoles, v92);

        return v92;
    end;

    local v93 = v90.BulletHoles[v90.BulletHoleCursor];
    v90.BulletHoleCursor = v90.BulletHoleCursor % v91 + 1;

    return v93;
end;

local function ShouldHideBulletHole(p94, p95) -- Line: 566
    -- upvalues: CollectionService (copy)
    return (p95 == Enum.Material.Water or p95 == Enum.Material.ForceField) and true or ((p94.Name == "BarricadePlank" or p94.Name == "Glass_Breakable") and true or ((CollectionService:HasTag(p94.Parent, "Barbwire") or CollectionService:HasTag(p94.Parent, "Trip Wire")) and true or p94.Size.Z <= 0.16 and (p94.Size.Y <= 0.16 and p94.Size.X <= 0.16)));
end;

function u4.Hit(p96, p97, p98, p99, p100, p101) -- Line: 586
    -- upvalues: Config (copy), LocalPlayer (copy), u4 (copy)
    if p96 == nil then
        return nil;
    end;

    local v102;

    if p96 and p96.Parent then
        v102 = p96.Parent:FindFirstChild("Humanoid") or nil;
    else
        v102 = nil;
    end;

    if v102 then
        Config.AddSound("HitMarker", nil, true, p96, false);

        if Config.DamageFeedbackMode == "FakeBlood" ~= true and LocalPlayer.PlayerData.Settings:GetAttribute("Bleed") == true then
            u4.CreateEffect("Blood", p97, p96, p98, p100, p101);
        end;
    else
        local v103 = u4.FindEffect(p99);
        local v104 = u4.CreateEffect(v103, p97, p96, p98, p100, p101);

        if LocalPlayer.PlayerData.Settings:GetAttribute("BulletHoles") == true and not p100 then
            local v105 = u4.AddBulletHole(p96, p97, p98, p99, p101);
            u4.CreateSfx(v103, v105 or v104, p100, p101);
        else
            u4.CreateSfx(v103, v104, p100, p101);
        end;

        u4.MapInteraction(p96);
    end;
end;

function u4.SHit(u106, p107, p108, p109) -- Line: 615
    -- upvalues: Server (copy), FindTaggedAncestor (copy), Config (copy), Debris (copy)
    if u106 == nil then
        return nil;
    end;

    if u106.Parent == nil then
        return nil;
    end;

    local Parent = u106.Parent;

    if u106.Name == "BarricadePlank" and u106:GetAttribute("Health") then
        local v110;

        if Server:GetAttribute("Phase") == "Round Started" then
            local v111 = Server:GetAttribute("RoundStartedAt");
            v110 = typeof(v111) ~= "number" and true or workspace:GetServerTimeNow() - v111 >= 3;
        else
            v110 = false;
        end;

        if v110 ~= true then
            return nil;
        end;

        local v112 = u106:GetAttribute("Health");

        if v112 <= 0 then
            return nil;
        end;

        if p107 then
            u106:SetAttribute("Health", 0);
        else
            local v113;

            if p109 then
                v113 = p109:GetAttribute("PlankAmount");
            else
                v113 = p109;
            end;

            local v114;

            if p109 then
                v114 = p109:GetAttribute("DamagePerPlank");
            else
                v114 = p109;
            end;

            if p109 and (typeof(v113) ~= "number" or typeof(v114) ~= "number") then
                local Settings = p109:FindFirstChild("Settings");

                if Settings and Settings:IsA("ModuleScript") then
                    local success, result = pcall(require, Settings);

                    if success and typeof(result) == "table" then
                        if typeof(v113) ~= "number" then
                            v113 = result.PlankAmount;
                        end;

                        if typeof(v114) ~= "number" then
                            v114 = result.DamagePerPlank;
                        end;
                    end;
                end;
            end;

            local v115 = typeof(v113) == "number" and v113 and v113 or 1;
            local v116 = math.max(v115, 1);
            local v117 = typeof(v114) == "number" and v114 and v114 or 2;
            local v118 = math.max(v117, 1);
            u106:SetAttribute("Health", (math.clamp(v112 - v118, 0, 3)));

            if v116 > 1 then
                local v119 = v116 - 1;
                local v120 = {};

                for _, child in pairs(Parent:GetChildren()) do
                    if child ~= u106 and (child.Name == "BarricadePlank" and (child:GetAttribute("Health") or 0) > 0) then
                        table.insert(v120, child);
                    end;
                end;

                table.sort(v120, function(p121, p122) -- Line: 666
                    -- upvalues: u106 (copy)
                    return (p121.Position - u106.Position).Magnitude < (p122.Position - u106.Position).Magnitude;
                end);

                for i, v in ipairs(v120) do
                    if i <= v119 then
                        local v123 = v:GetAttribute("Health") or 0;

                        if v123 > 0 then
                            v:SetAttribute("Health", (math.clamp(v123 - v118, 0, 3)));
                        end;
                    end;
                end;
            end;
        end;
    elseif u106.Name == "Glass_Breakable" then
        if u106:GetAttribute("Broken") == true then
            return nil;
        end;

        u106:SetAttribute("Broken", true);
        u106.Transparency = 1;
        u106.CanCollide = false;

        for _, child in u106:GetChildren() do
            if child:IsA("Decal") then
                child.Transparency = 1;
            end;
        end;
    else
        local v124 = FindTaggedAncestor(u106, "Deployable");

        if v124 then
            local v125 = v124:GetAttribute("Health");

            if v125 == nil then
                return nil;
            end;

            if v125 <= 0 then
                return nil;
            end;

            local v126 = math.max(v125 - 1, 0);
            v124:SetAttribute("Health", v126);
            local v127;

            if v126 <= 0 then
                v127 = v124.PrimaryPart or v124:FindFirstChildWhichIsA("BasePart");

                if v127 then
                    v127.Parent = game.Workspace.Map_Cache;
                    local v128 = Config.AddSound("DeployableBreak", nil, false, v127, false);

                    if v128 then
                        v128.RollOffMinDistance = 8;
                        v128.RollOffMaxDistance = 80;
                        v128.RollOffMode = Enum.RollOffMode.InverseTapered;
                        v128.EmitterSize = 3;
                    end;

                    Debris:AddItem(v127, 2);
                else
                    v127 = v124;
                end;

                v124:Destroy();
            else
                v127 = v124;
            end;

            return {
                Kind = "Deployable",
                ForceFeedback = false,
                Target = v127,
                Destroyed = v126 <= 0
            };
        end;

        local v129 = FindTaggedAncestor(u106, "Proximity Alarm");

        if v129 then
            local v130 = v129:GetAttribute("Health");

            if v130 == nil then
                return nil;
            end;

            if v130 <= 0 then
                return nil;
            end;

            local v131 = math.max(v130 - 1, 0);
            v129:SetAttribute("Health", v131);
            local v132;

            if v131 <= 0 then
                local Base = v129:FindFirstChild("Base");

                if not Base then
                    v129:Destroy();

                    return nil;
                end;

                Base.Parent = game.Workspace.Map_Cache;
                local v133 = Config.AddSound("DeployableBreak", nil, false, Base, false);

                if v133 then
                    v133.RollOffMinDistance = 8;
                    v133.RollOffMaxDistance = 80;
                    v133.RollOffMode = Enum.RollOffMode.InverseTapered;
                    v133.EmitterSize = 3;
                end;

                if Base:FindFirstChild("Break") then
                    Base.Break:Play();
                end;

                v132 = Base;

                for _, child in pairs(Base:GetChildren()) do
                    if child.Name == "Explosion" then
                        child:Emit(5);
                    end;
                end;

                v129:Destroy();
                Debris:AddItem(Base, 2);
            else
                v132 = v129;
            end;

            return {
                Kind = "Proximity Alarm",
                ForceFeedback = true,
                Target = v132,
                Destroyed = v131 <= 0
            };
        end;
    end;

    return nil;
end;

function u4.AddEffectOnly(p134, p135) -- Line: 772
    -- upvalues: Debris (copy)
    local v136 = p134:Clone();
    v136.Parent = p135;
    v136:Emit(v136.Rate / 10);
    Debris:AddItem(v136, v136.Lifetime.Max);
end;

function u4.AddEffectPack(p137, p138) -- Line: 782
    if p137.Name == "Light_Explode" then
        local u139 = p137:Clone();
        u139.Parent = p138;
        u139.CFrame = p138.CFrame;
        u139.Smoke.Enabled = true;
        u139.Explode:Play();

        for _, child in pairs(u139:GetChildren()) do
            if child.Name == "Metal" then
                child:Emit(child.Rate / 10);
            end;
        end;

        coroutine.resume(coroutine.create(function() -- Line: 799
            -- upvalues: u139 (copy)
            while true do
                wait(math.random(1, 15));
                u139.Spark.PlaybackSpeed = math.random(20, 40) / 10;
                u139.Spark:Play();

                for _, child in pairs(u139:GetChildren()) do
                    if child.Name == "Metal" then
                        child:Emit(child.Rate / 10);
                    end;
                end;
            end;
        end));
    end;
end;

function u4.MapInteraction(p140) -- Line: 816
    -- upvalues: CollectionService (copy), u4 (copy)
    if p140 ~= nil then
        if CollectionService:HasTag(p140.Parent, "TargetBoard") then
            if p140.Parent:GetAttribute("Hit") == false then
                p140.Parent:SetAttribute("Hit", true);
            end;
        else
            if p140.Name == "Glass_Breakable" then
                p140.Transparency = 1;
                p140.Name = "Glass_Broke";
                p140.CanCollide = false;
                u4.AddEffectOnly(script.MapInteraction.Glass_1, p140);

                return;
            end;

            if p140.Name == "Light_Breakable" then
                p140.Name = "Light_Broke";
                p140.Color = Color3.fromRGB(0, 0, 0);

                for _, child in pairs(p140:GetChildren()) do
                    if child:IsA("SpotLight") or (child:IsA("SurfaceLight") or child:IsA("PointLight")) then
                        child.Enabled = false;
                    end;
                end;

                u4.AddEffectPack(script.MapInteraction.Light_Explode, p140);
            end;
        end;
    end;
end;

function u4.CreateEffect(p141, p142, p143, p144, p145, p146) -- Line: 849
    -- upvalues: GetShooterPool (copy), Config (copy), Map_Cache (copy), ClearEffectHolderChildren (copy), Effects (copy)
    local Settings = game.Players.LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Settings");
    local v147 = GetShooterPool(p146);
    local v148 = Config.ImpactEffectPerShooterCap or 12;
    local v149;

    if #v147.EffectHolders < v148 then
        local Part = Instance.new("Part");
        Part.Name = "ImpactEffect";
        Part.Size = Vector3.new(0.1, 0.1, 0.1);
        Part.Transparency = 1;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Parent = Map_Cache;
        v149 = {
            Part = Part
        };
        table.insert(v147.EffectHolders, v149);
    else
        v149 = v147.EffectHolders[v147.EffectHolderCursor];
        v147.EffectHolderCursor = v147.EffectHolderCursor % v148 + 1;
    end;

    local Part = v149.Part;
    local u150 = (Part:GetAttribute("__PoolToken") or 0) + 1;
    ClearEffectHolderChildren(Part);
    Part:SetAttribute("__PoolToken", u150);
    Part.CFrame = CFrame.new(p142, p142 + p144);
    local v151 = p141 == "Blood" and (p143.Name == "Head" and "BloodHead" or "BloodDefault") or p141;
    local v152 = {};

    for _, child in pairs(Effects:GetChildren()) do
        if child.Name == v151 then
            table.insert(v152, child);
        end;
    end;

    if #v152 <= 0 then
        table.insert(v152, Effects.Default);
    end;

    if v151 ~= "BloodHead" and v151 ~= "BloodDefault" then
        if not p145 then
            table.insert(v152, Effects.Spark);
        end;

        table.insert(v152, Effects.Smoke);
    end;

    local v153 = 0;

    for _, v in pairs(v152) do
        local v154 = v:Clone();

        if v151 ~= "Metal" and (v151 ~= "Default" and (v.Name ~= "Spark" and (v.Name ~= "Blood" and (v.Name ~= "BloodDefault" and v.Name ~= "BloodHead")))) then
            v154.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, p143.Color), ColorSequenceKeypoint.new(1, p143.Color) });
        end;

        v154.Parent = Part;
        local v155 = math.floor(v154.Rate / 10);
        v154:Emit(Settings:GetAttribute("Graphics") == "Performance" and 2 or v155);

        if v153 < v154.Lifetime.Max then
            v153 = v154.Lifetime.Max;
        end;
    end;

    task.delay(v153 + 0.5, function() -- Line: 907
        -- upvalues: Part (copy), u150 (copy), ClearEffectHolderChildren (ref)
        if Part.Parent and Part:GetAttribute("__PoolToken") == u150 then
            ClearEffectHolderChildren(Part);
        end;
    end);

    return Part;
end;

function u4.CreateSfx(p156, p157, p158, p159) -- Line: 917
    -- upvalues: GetSoundTemplatesForCategory (copy), PlayImpactSound (copy)
    if not p157 then
        return;
    end;

    if not p158 or p158 and p156 == "Glass" then
        local v160 = GetSoundTemplatesForCategory(p156);

        if #v160 <= 0 then
            return;
        end;

        PlayImpactSound(p157, v160[math.random(1, #v160)], p159);
    end;
end;

function u4.AddBulletHole(p161, p162, p163, p164, p165) -- Line: 933
    -- upvalues: CollectionService (copy), GetShooterPool (copy), Config (copy), CreateBulletHoleEntry (copy), CleanupWelds (copy), BulletHoles (copy), ShouldHideBulletHole (copy)
    local Settings = game.Players.LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Settings");
    local u166;

    if CollectionService:HasTag(p161.Parent, "Event Prop") or (p164 == Enum.Material.Water or (p164 == Enum.Material.ForceField or Settings:GetAttribute("Graphics") == "Performance")) then
        u166 = nil;
    else
        local v167 = GetShooterPool(p165);
        local v168 = Config.BulletHolePerShooterCap or 16;
        local v169;

        if #v167.BulletHoles < v168 then
            v169 = CreateBulletHoleEntry();
            table.insert(v167.BulletHoles, v169);
        else
            v169 = v167.BulletHoles[v167.BulletHoleCursor];
            v167.BulletHoleCursor = v167.BulletHoleCursor % v168 + 1;
        end;

        u166 = v169.Part;
        local Decal = v169.Decal;
        local u170 = (u166:GetAttribute("__PoolToken") or 0) + 1;
        CleanupWelds(u166);
        u166.CFrame = CFrame.new(p162, p162 + p163);
        u166.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u166.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        Config.WeldObject(u166, p161, u166);
        local v171 = BulletHoles:GetChildren();
        Decal.Texture = v171[math.random(1, #v171)].Texture;
        Decal.Transparency = ShouldHideBulletHole(p161, p164) and 1 or 0;
        Decal.Face = Enum.NormalId.Front;
        u166:SetAttribute("__PoolToken", u170);
        task.delay(Config.BulletHoleDespawnTime, function() -- Line: 956
            -- upvalues: u166 (ref), u170 (copy), Config (ref), Decal (copy)
            if u166.Parent and u166:GetAttribute("__PoolToken") == u170 then
                Config.TweenOnce(Decal, {
                    Transparency = 1
                }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
            end;
        end);
    end;

    return u166;
end;

function u4.ThreeDimensionEffect(p172, p173, p174) -- Line: 966
    return nil;
end;

function u4.FindEffect(p175) -- Line: 970
    return (p175 == Enum.Material.Mud or (p175 == Enum.Material.Grass or (p175 == Enum.Material.Ground or p175 == Enum.Material.LeafyGrass))) and "Dirt" or ((p175 == Enum.Material.Metal or (p175 == Enum.Material.CorrodedMetal or (p175 == Enum.Material.DiamondPlate or p175 == Enum.Material.SmoothPlastic))) and "Metal" or (p175 == Enum.Material.Fabric and "Fabric" or ((p175 == Enum.Material.Sand or (p175 == Enum.Material.Sandstone or (p175 == Enum.Material.Snow or p175 == Enum.Material.Salt))) and "Sand" or ((p175 == Enum.Material.Wood or p175 == Enum.Material.WoodPlanks) and "Wood" or ((p175 == Enum.Material.Concrete or (p175 == Enum.Material.Slate or (p175 == Enum.Material.Basalt or (p175 == Enum.Material.Asphalt or (p175 == Enum.Material.Rock or (p175 == Enum.Material.Cobblestone or p175 == Enum.Material.Marble)))))) and "Concrete" or ((p175 == Enum.Material.Glass or (p175 == Enum.Material.Glacier or (p175 == Enum.Material.Ice or p175 == Enum.Material.Foil))) and "Glass" or (p175 == Enum.Material.Water and "Water" or (p175 == Enum.Material.ForceField and "ForceField" or "Default"))))))));
end;

if RunService:IsClient() then
    u50();
    task.defer(function() -- Line: 997
        -- upvalues: LocalPlayer (copy), GetShooterPool (copy)
        if LocalPlayer ~= nil then
            GetShooterPool(LocalPlayer);
        end;

        GetShooterPool(nil);
    end);
end;

return u4;