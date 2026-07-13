
game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local CollectionService = game:GetService("CollectionService");
local Config = require(ReplicatedStorage.Config);
local Menu = require(ReplicatedStorage.Components.Menu);
local Weapon = require(ReplicatedStorage.Components.Weapon);
local HitEffect = require(ReplicatedStorage.Components.HitEffect);
local WeaponSlotResolver = require(ReplicatedStorage.Modules.WeaponSlotResolver);
local DynamicCrosshair = require(ReplicatedStorage.Components.DynamicCrosshair);
local ReplayDebugLogger = require(ReplicatedStorage.Components.ReplayDebugLogger);
local CameraModel = ReplicatedStorage:WaitForChild("Components"):WaitForChild("Player"):WaitForChild("CameraModel");
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents");
local Server = ReplicatedStorage:WaitForChild("Server");
local SpectateStateRequest = GameEvents:WaitForChild("SpectateStateRequest");
local SpectateState = GameEvents:WaitForChild("SpectateState");
local SpectatePresentation = GameEvents:WaitForChild("SpectatePresentation");
local Run = game.StarterPlayer.StarterCharacterScripts.ClientWeaponSystem.Components.Weapon.Animations.Client:FindFirstChild("Run");
local SampleLoadoutHUD = game.StarterPlayer.StarterCharacterScripts.ClientWeaponSystem:WaitForChild("Prefabs"):WaitForChild("SampleLoadoutHUD");
local v1 = {};
local u2 = {};
u2.__index = u2;
local u3 = CFrame.new(0, 0, -0.5);
local u4 = {
    ["Round Started"] = true,
    ["Round Ended"] = true,
    Preparation = true
};

local function setFirstPersonSpectateCameraActive(p5, p6) -- Line: 44
    p5:SetAttribute("FirstPersonSpectateActive", p6);
end;

local function disconnectAll(p7) -- Line: 48
    for _, v in ipairs(p7) do
        if v then
            v:Disconnect();
        end;
    end;

    table.clear(p7);
end;

local function stopAnimationTracks(p8) -- Line: 57
    if not p8 then
        return;
    end;

    for _, v in pairs(p8) do
        if v and v:IsA("AnimationTrack") then
            v:Stop(0.05);
        end;
    end;
end;

local function buildAnimationCacheKey(p9) -- Line: 69
    local AnimationId = p9.AnimationId;

    if typeof(AnimationId) == "string" and AnimationId ~= "" then
        return AnimationId;
    end;

    return p9:GetFullName();
end;

local function buildDefaultTargetState() -- Line: 78
    return {
        Aiming = false,
        Inspecting = false,
        Reloading = false,
        Holstered = true,
        CurrentActionState = "Hold",
        EquippedToolName = "",
        EquippedSlot = "",
        EquippedToolSerial = "",
        Movement = "Standing",
        Lean = 0,
        TargetFOV = 90,
        ScopeVisible = false,
        CrosshairVisible = false,
        CrosshairStyle = "Dot",
        CrosshairSizeX = 3,
        CrosshairSizeY = 3,
        CrosshairMinSpread = 0,
        CrosshairFollowMouse = false,
        CurrentAmmo = 0,
        StoredAmmo = 0,
        ThrowablePreviewActive = false,
        ThrowablePreviewToolName = ""
    };
end;

local function resolveToolVisualTemplate(p10, p11) -- Line: 105
    -- upvalues: ReplicatedStorage (copy)
    if typeof(p11) ~= "string" or p11 == "" then
        return nil;
    end;

    if p10 == "Primary" or p10 == "Secondary" then
        return ReplicatedStorage.Items.Weapon:FindFirstChild(p11);
    end;

    local v12 = ReplicatedStorage.Items:FindFirstChild(p10 or "");

    if v12 then
        return v12:FindFirstChild(p11);
    end;

    return nil;
end;

local function isValidAnimationFolder(p13) -- Line: 122
    if not p13 then
        return false;
    end;

    if not p13:IsA("Folder") then
        return false;
    end;

    if p13.Name ~= "Animations" then
        return false;
    end;

    if p13:FindFirstChild("Client") then
        return p13:FindFirstChild("Server") and true or false;
    end;

    return false;
end;

local function findAnimationsInside(p14) -- Line: 141
    if not p14 then
        return nil;
    end;

    local Animations = p14:FindFirstChild("Animations");
    local v15;

    if Animations and (Animations:IsA("Folder") and (Animations.Name == "Animations" and Animations:FindFirstChild("Client"))) then
        v15 = Animations:FindFirstChild("Server") and true or false;
    else
        v15 = false;
    end;

    if v15 then
        return Animations;
    end;

    local Settings = p14:FindFirstChild("Settings");

    if Settings then
        local Animations2 = Settings:FindFirstChild("Animations");
        local v16;

        if Animations2 and (Animations2:IsA("Folder") and (Animations2.Name == "Animations" and Animations2:FindFirstChild("Client"))) then
            v16 = Animations2:FindFirstChild("Server") and true or false;
        else
            v16 = false;
        end;

        if v16 then
            return Animations2;
        end;
    end;

    for _, descendant in ipairs(p14:GetDescendants()) do
        local v17;

        if descendant and (descendant:IsA("Folder") and (descendant.Name == "Animations" and descendant:FindFirstChild("Client"))) then
            v17 = descendant:FindFirstChild("Server") and true or false;
        else
            v17 = false;
        end;

        if v17 then
            return descendant;
        end;
    end;

    return nil;
end;

local function resolveToolAnimationFolder(p18, p19, p20, p21) -- Line: 168
    -- upvalues: findAnimationsInside (copy), ReplicatedStorage (copy)
    local v22 = findAnimationsInside(p18);

    if v22 then
        return v22;
    end;

    local v23 = findAnimationsInside(p19);

    if v23 then
        return v23;
    end;

    if typeof(p21) ~= "string" or p21 == "" then
        return nil;
    end;

    if p20 == "Primary" or p20 == "Secondary" then
        local v24 = ReplicatedStorage.Weapons:FindFirstChild(p21);

        if v24 then
            v24 = v24:FindFirstChild("Settings");
        end;

        if v24 then
            v24 = v24:FindFirstChild("Animations");
        end;

        return v24;
    end;

    local v25 = ReplicatedStorage.Items:FindFirstChild(p20 or "") or ReplicatedStorage.Items:FindFirstChild("Throwable");

    if not v25 then
        return nil;
    end;

    local v26 = v25:FindFirstChild(p21);

    if v26 then
        v26 = v26:FindFirstChild("Handle") or v26:FindFirstChild("Base");
    end;

    if v26 then
        v26 = v26:FindFirstChild("Animations");
    end;

    return v26;
end;

local function resolveToolSettings(p27, p28) -- Line: 199
    -- upvalues: ReplicatedStorage (copy)
    local v29 = p27 and p27:FindFirstChild("Settings") or nil;

    if v29 and v29:IsA("ModuleScript") then
        local success, result = pcall(require, v29);

        if success and type(result) == "table" then
            return table.clone(result);
        end;
    end;

    local v30 = ReplicatedStorage.Weapons:FindFirstChild(p28);

    if v30 then
        v30 = v30:FindFirstChild("Settings");
    end;

    if v30 and v30:IsA("ModuleScript") then
        local success, result = pcall(require, v30);

        if success and type(result) == "table" then
            return table.clone(result);
        end;
    end;

    return nil;
end;

local function resolvePlayerLoadout(p31) -- Line: 220
    if not p31 then
        return nil;
    end;

    local v32 = p31:FindFirstChild("PlayerData") or p31:WaitForChild("PlayerData", 1);

    if not v32 then
        return nil;
    end;

    local v33 = v32:FindFirstChild("Settings") or v32:WaitForChild("Settings", 1);
    local v34 = v32:FindFirstChild("Loadout") or v32:WaitForChild("Loadout", 1);

    if not (v33 and v34) then
        return nil;
    end;

    local v35 = v33:GetAttribute("LoadoutName");
    local v36;

    if typeof(v35) == "string" then
        v36 = v34:FindFirstChild(v35) or nil;
    else
        v36 = nil;
    end;

    return v36 or v34:FindFirstChild("Default");
end;

local function applyCameraModelAppearance(p37, p38) -- Line: 241
    -- upvalues: resolvePlayerLoadout (copy), ReplicatedStorage (copy)
    if not (p37 and p38) then
        return;
    end;

    local v39 = resolvePlayerLoadout(p38);

    if not v39 then
        return;
    end;

    local v40 = v39:GetAttribute("Head");
    local v41;

    if typeof(v40) == "string" then
        v41 = ReplicatedStorage.Items.Head:FindFirstChild(v40) or nil;
    else
        v41 = nil;
    end;

    if v41 then
        v41 = v41:FindFirstChild("Body Colors");
    end;

    if v41 and v41:IsA("BodyColors") then
        p37["Left Arm"].Color = v41.LeftArmColor3;
        p37["Right Arm"].Color = v41.RightArmColor3;
    end;

    local Top = p37:FindFirstChild("Top");

    if Top then
        Top:Destroy();
    end;

    local v42 = v39:GetAttribute("Top");
    local v43;

    if typeof(v42) == "string" then
        v43 = ReplicatedStorage.Items.Top:FindFirstChild(v42) or nil;
    else
        v43 = nil;
    end;

    if v43 then
        local v44 = v43:Clone();
        v44.Name = "Top";
        v44.Parent = p37;
    end;
end;

local function resolveAuthoritativeTool(p45, p46, p47, p48) -- Line: 273
    -- upvalues: WeaponSlotResolver (copy)
    if p45 then
        return WeaponSlotResolver.FindToolBySerial(p45, p48) or (WeaponSlotResolver.ResolveToolByClass(p45, p46) or WeaponSlotResolver.FindToolByName(p45, p47));
    end;

    return nil;
end;

local function getToolVisualSignature(p49, p50, p51, p52, p53) -- Line: 291
    -- upvalues: resolvePlayerLoadout (copy)
    local v54 = resolvePlayerLoadout(p49);
    local v55 = v54 and v54.Name or "";
    local v56 = p53 and p53:GetAttribute("Skin") or "";

    return table.concat({
        tostring(p50 or ""),
        tostring(p51 or ""),
        tostring(p52 or ""),
        tostring(v55),
        (tostring(v56))
    }, "|");
end;

local function buildSpectatedToolModel(p57, p58, p59, p60, p61) -- Line: 304
    -- upvalues: resolveToolVisualTemplate (copy), Weapon (copy), resolvePlayerLoadout (copy), WeaponSlotResolver (copy)
    local v62 = resolveToolVisualTemplate(p59, p60);

    if v62 then
        v62 = v62:Clone();
    end;

    if not v62 then
        if not p58 then
            return nil;
        end;

        local v63 = WeaponSlotResolver.ResolveVisibleModel(p58, p60);

        return v63 and v63:Clone() or nil;
    end;

    Weapon.WeldWeapon(v62);
    Weapon.SetModelProperties(v62, false, false);

    if p59 == "Primary" or p59 == "Secondary" then
        Weapon.SetFullAttachmentOnWeapon(v62, p57);
        local v64 = resolvePlayerLoadout(p57);

        if v64 then
            Weapon.SetAttachmentSkins(v62, v64, p59);
        end;

        local v65 = p61 and p61:GetAttribute("Skin") or nil;

        if typeof(v65) == "string" and v65 ~= "" then
            Weapon.SetSkinOnWep(v62, v65);
        end;

        Weapon.SetupWeaponEffects(v62);
    end;

    return v62;
end;

local function resolveObservedWeaponName(p66) -- Line: 333
    -- upvalues: WeaponSlotResolver (copy)
    if p66 then
        p66 = p66.Character;
    end;

    if not p66 then
        return nil;
    end;

    local v67 = WeaponSlotResolver.GetStateFolder(p66);

    if not v67 then
        return nil;
    end;

    local v68 = v67:GetAttribute("EquippedToolName");

    if typeof(v68) == "string" and v68 ~= "" then
        return v68;
    end;

    return nil;
end;

local function resolveObservedWeaponModel(p69, p70) -- Line: 352
    -- upvalues: WeaponSlotResolver (copy)
    local v71;

    if p69 then
        v71 = p69.Character;
    else
        v71 = p69;
    end;

    if not v71 then
        return nil;
    end;

    if typeof(p70) ~= "string" or p70 == "" then
        if p69 then
            p69 = p69.Character;
        end;

        if p69 then
            local v72 = WeaponSlotResolver.GetStateFolder(p69);

            if v72 then
                p70 = v72:GetAttribute("EquippedToolName");

                if typeof(p70) ~= "string" or p70 == "" then
                    p70 = nil;
                end;
            else
                p70 = nil;
            end;
        else
            p70 = nil;
        end;
    end;

    if typeof(p70) ~= "string" or p70 == "" then
        return nil;
    end;

    local v73 = WeaponSlotResolver.ResolveVisibleModel(v71, p70);

    if v73 and v73:IsA("Model") then
        return v73;
    end;

    local v74 = v71:FindFirstChild(p70, true);

    if v74 and v74:IsA("Model") then
        return v74;
    end;

    return nil;
end;

local function resolveObservedSoundTemplate(p75, p76, p77) -- Line: 379
    -- upvalues: resolveObservedWeaponModel (copy)
    if typeof(p76) ~= "string" or p76 == "" then
        return nil, nil;
    end;

    local v78;

    if p75 then
        v78 = p75.Character;
    else
        v78 = p75;
    end;

    if not v78 then
        return nil, nil;
    end;

    local v79 = resolveObservedWeaponModel(p75, p77);

    if v79 then
        local Handle = v79:FindFirstChild("Handle", true);
        local v80;

        if Handle then
            v80 = Handle:FindFirstChild(p76);
        else
            v80 = Handle;
        end;

        if v80 and v80:IsA("Sound") then
            return v80, Handle;
        end;

        local v81 = v79:FindFirstChild(p76, true);

        if v81 and v81:IsA("Sound") then
            return v81, Handle or v79;
        end;
    end;

    local v82 = v78:FindFirstChild("HumanoidRootPart") or v78:FindFirstChild("Torso");

    if v82 and v82:IsA("BasePart") then
        local v83 = v82:FindFirstChild(p76);

        if v83 and v83:IsA("Sound") then
            return v83, v82;
        end;
    end;

    for _, descendant in ipairs(v78:GetDescendants()) do
        if descendant:IsA("Sound") and descendant.Name == p76 then
            local Parent = descendant.Parent;

            if Parent and Parent:IsA("BasePart") then
                return descendant, Parent;
            end;
        end;
    end;

    return nil, nil;
end;

local function resolveAimPresentation(p84) -- Line: 423
    -- upvalues: CollectionService (copy)
    local v85 = 1;
    local v86 = nil;

    if not p84 then
        return v85, v86;
    end;

    for _, child in ipairs(p84:GetChildren()) do
        if CollectionService:HasTag(child, "Sight") then
            return child:GetAttribute("Zoom") or v85, child:FindFirstChild("Front");
        end;
    end;

    return v85, v86;
end;

local function setSightPresentation(p87, p88, p89) -- Line: 441
    -- upvalues: CollectionService (copy)
    if not p87 then
        return;
    end;

    local v90 = tonumber(p88) or 0;
    local v91 = math.clamp(v90, 0, 1);
    local v92 = false;

    for _, child in ipairs(p87:GetChildren()) do
        if CollectionService:HasTag(child, "Sight") then
            v92 = true;
            local Front = child:FindFirstChild("Front");

            if Front and Front:IsA("BasePart") then
                Front.Transparency = v91;
                Front.LocalTransparencyModifier = 0;

                for _, descendant in ipairs(Front:GetDescendants()) do
                    if descendant:IsA("SurfaceGui") and (descendant.Parent and descendant.Parent.Name == "Reticle") then
                        descendant.Enabled = p89;
                    end;
                end;
            end;
        end;
    end;

    if v92 ~= true then
        local SightFront = p87:FindFirstChild("SightFront", true);

        if SightFront and SightFront:IsA("BasePart") then
            SightFront.Transparency = v91;
            SightFront.LocalTransparencyModifier = 0;

            for _, descendant in ipairs(SightFront:GetDescendants()) do
                if descendant:IsA("SurfaceGui") and (descendant.Parent and descendant.Parent.Name == "Reticle") then
                    descendant.Enabled = p89;
                end;
            end;
        end;
    end;
end;

local function normalizeItemPort(p93) -- Line: 478
    if not p93 then
        return;
    end;

    for _, descendant in ipairs(p93:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Color = Color3.new(1, 1, 1);
            descendant.Material = Enum.Material.SmoothPlastic;

            if descendant:IsA("MeshPart") then
                descendant.TextureID = "";
            end;
        end;
    end;
end;

local function cloneCameraModelForPlayer(p94) -- Line: 494
    -- upvalues: CameraModel (copy), applyCameraModelAppearance (copy)
    local v95 = CameraModel:Clone();
    v95.Base.Transparency = 1;
    v95.Anim.Transparency = 1;
    v95.Tool.Transparency = 1;
    v95["Right Hand"].Transparency = 1;
    v95["Left Hand"].Transparency = 1;
    local Highlight = v95:FindFirstChild("Highlight");

    if Highlight then
        Highlight:Destroy();
    end;

    local TestWeapon = v95:FindFirstChild("TestWeapon");

    if TestWeapon then
        TestWeapon:Destroy();
    end;

    applyCameraModelAppearance(v95, p94);
    v95.Parent = workspace.CurrentCamera;

    return v95;
end;

local function attachToolModel(p96, p97) -- Line: 518
    -- upvalues: Weapon (copy)
    local v98 = p97:FindFirstChild("Handle") or p97:FindFirstChild("Base");

    if not v98 then
        return nil;
    end;

    p97.Parent = p96;
    local Motor = v98:FindFirstChild("Motor");

    if not Motor then
        Motor = Instance.new("Motor6D");
        Motor.Name = "Motor";
        Motor.Parent = v98;
    end;

    Motor.Part1 = v98;
    Motor.Part0 = p96.Tool;
    v98.Anchored = false;
    Motor.C1 = CFrame.new();
    local v99 = Weapon.GetWeaponExtra(p97);

    if v99 then
        Weapon.InitializeExtraAttachment(v99);
    end;

    return p97:FindFirstChild("Aim");
end;

local function detachToolModel(p100, p101) -- Line: 545
    if p101 then
        p101 = p101:FindFirstChild("Handle") or p101:FindFirstChild("Base");
    end;

    if not (p100 and p101) then
        return;
    end;

    local Motor = p101:FindFirstChild("Motor");

    if not Motor then
        Motor = Instance.new("Motor6D");
        Motor.Name = "Motor";
        Motor.Parent = p101;
    end;

    Motor.Part1 = p101;
    Motor.Part0 = p100.Base;
    p101.Anchored = false;
    Motor.C1 = CFrame.new(0, 0, -10);
end;

function v1.new(p102, p103) -- Line: 564
    -- upvalues: u2 (copy), buildDefaultTargetState (copy)
    local v104 = setmetatable({}, u2);
    v104.LocalPlayer = p102;
    v104.Camera = p103;
    v104.TargetPlayer = nil;
    v104.TargetCharacter = nil;
    v104.ReplayTargetCharacter = nil;
    v104.ReplayCameraOnly = false;
    v104.ReplaySessionSerial = 0;
    v104.TargetStateFolder = nil;
    v104.TargetSnapshot = buildDefaultTargetState();
    v104.CameraModel = nil;
    v104.CurrentToolModel = nil;
    v104.CurrentToolName = "";
    v104.CurrentSlot = "";
    v104.CurrentToolSerial = "";
    v104.CurrentVisualSignature = "";
    v104.CurrentSettings = nil;
    v104.CurrentAnimations = nil;
    v104.CommonAnimations = nil;
    v104.AimPart = nil;
    v104.RenderConnection = nil;
    v104.StateConnections = {};
    v104.TargetConnections = {};
    v104.EventConnections = {};
    v104.CameraBasisByPlayer = {};
    v104.TargetCameraCFrame = nil;
    v104.LastStateRefreshAttempt = 0;
    v104.CurrentActionState = "Hold";
    v104.TargetState = buildDefaultTargetState();
    v104.Recoil = CFrame.new();
    v104.ArmLerp = 0;
    v104.ArmSin = 0;
    v104.ArmSin2 = 0;
    v104.NextLeanAngle = 0;
    v104.NextLeanDirection = 0;
    v104.SessionId = 0;
    v104.Crosshair = nil;
    v104.LastHighlightedEquipment = "";
    v104.SnapshotHeadCFrame = nil;
    v104.CurrentCameraCFrame = nil;
    v104.LastHudSourcePlayer = nil;
    v104.SuppressCombatPresentation = false;
    v104.DelayHoldForNextBuild = true;
    v104.SuppressBaseAnimationPlayback = false;
    v104.EquipPresentationSerial = 0;
    v104.PresentationVisible = true;
    v104.ReplaySoundInstances = {};
    v104.ReplaySampledFieldOfView = nil;
    v104.ReplayFieldOfViewTransitionEndsAt = 0;
    v104.ReplayPlaybackTime = 0;
    v104:ClearReplayAudioInstances();
    v104.ReplayClip = nil;
    v104.ReplayStartedAt = 0;
    v104.ReplayNextSampleIndex = 1;
    v104.ReplayNextEventIndex = 1;
    v104.ReplayFinished = false;
    v104.ReplayFinishedCallback = nil;
    v104.ReplayStartValidated = false;
    v104.ReplayFirstSampleApplied = false;
    v104.ReplayRenderActive = false;
    v104.ReplayLastFailureReason = "";
    v104.ReplayLastLifecycleSource = "";
    v104.ReplayLastBlockedLifecycleSource = "";
    v104.ReplayStatusState = nil;
    v104.AnimationTrackCache = {};
    v104.CurrentFieldOfView = p103 and p103.FieldOfView or 90;
    v104.ActiveFieldOfViewTween = nil;
    v104.FieldOfViewTweenDuration = 0.12;
    v104.HoldPrimed = false;
    v104.LastPresentationSequence = 0;
    v104.PendingSwapPresentationMode = nil;
    v104.PendingEventState = nil;
    v104.ADSTransitionActive = false;
    v104.ADSTransitionStartedAt = 0;
    v104.ADSTransitionFromC0 = nil;
    v104.ADSTransitionFromC1 = nil;
    v104.LastADSTransitionAiming = false;
    v104.LastADSTransitionTool = nil;
    v104.ReplayPovDead = false;
    v104.ReplayDeathScreenVisible = false;
    v104.LastReplaySampleHealth = nil;
    v104.ReplayPovDeathTime = nil;

    return v104;
end;

function u2.GetTargetPlayer(p105) -- Line: 650
    return p105.TargetPlayer;
end;

function u2.IsSpectatingPlayer(p106, p107) -- Line: 654
    return p106.TargetPlayer == p107;
end;

function u2.GetPlayerGui(p108) -- Line: 658
    return p108.LocalPlayer:FindFirstChild("PlayerGui");
end;

function u2.GetReplayDebugState(p109) -- Line: 662
    return {
        ReplayClipActive = p109.ReplayClip ~= nil,
        ReplayStartValidated = p109.ReplayStartValidated == true,
        ReplayFirstSampleApplied = p109.ReplayFirstSampleApplied == true,
        ReplayRenderActive = p109.ReplayRenderActive == true,
        ReplayLastFailureReason = p109.ReplayLastFailureReason,
        ReplayStartedAt = p109.ReplayStartedAt,
        ReplayLastLifecycleSource = p109.ReplayLastLifecycleSource,
        ReplayLastBlockedLifecycleSource = p109.ReplayLastBlockedLifecycleSource
    };
end;

function u2.GetReplayStatusState(p110) -- Line: 675
    if typeof(p110.ReplayStatusState) ~= "table" then
        return nil;
    end;

    local Statuses = p110.ReplayStatusState.Statuses;
    local v111 = {
        Flash = tonumber(p110.ReplayStatusState.Flash) or 0
    };
    local v112 = {};
    local v113;

    if Statuses then
        v113 = Statuses.Fire;
    else
        v113 = Statuses;
    end;

    v112.Fire = tonumber(v113) or 0;
    local v114;

    if Statuses then
        v114 = Statuses.Tear;
    else
        v114 = Statuses;
    end;

    v112.Tear = tonumber(v114) or 0;
    local v115;

    if Statuses then
        v115 = Statuses.Frost;
    else
        v115 = Statuses;
    end;

    v112.Frost = tonumber(v115) or 0;

    if Statuses then
        Statuses = Statuses.Poison;
    end;

    v112.Poison = tonumber(Statuses) or 0;
    v111.Statuses = v112;

    return v111;
end;

function u2.GetGameHUD(p116) -- Line: 691
    local v117 = p116:GetPlayerGui();

    return v117 and v117:FindFirstChild("GameHUD") or nil;
end;

function u2.GetPlayerHUD(p118) -- Line: 696
    local v119 = p118:GetGameHUD();

    return v119 and v119:FindFirstChild("PlayerHUD") or nil;
end;

function u2.GetDeathScreen(p120) -- Line: 701
    local v121 = p120:GetGameHUD();

    return v121 and v121:FindFirstChild("DeathScreen") or nil;
end;

function u2.SetReplayDeathScreenVisible(p122, p123) -- Line: 706
    p122.ReplayDeathScreenVisible = p123 == true;
    local v124 = p122:GetDeathScreen();

    if v124 and v124:IsA("GuiObject") then
        v124.Visible = p122.ReplayDeathScreenVisible;
    end;
end;

function u2.ClearReplayDeathPresentation(p125) -- Line: 714
    p125.ReplayPovDead = false;
    p125.LastReplaySampleHealth = nil;
    p125.ReplayPovDeathTime = nil;

    if p125.ReplayDeathScreenVisible == true then
        p125:SetReplayDeathScreenVisible(false);
    end;
end;

function u2.ResolveReplayPovDeathTime(p126, p127) -- Line: 723
    if typeof(p127) ~= "table" or not p126.TargetPlayer then
        return nil;
    end;

    local v128 = tonumber(p127.Duration) or 0;
    local v129 = math.max(v128, 0);

    if v129 > 0.05 then
        v129 = v129 - 0.05;
    end;

    local v130 = nil;

    for _, v in ipairs(p127.Events or {}) do
        if v.Type == "ReplayDeath" and tonumber(v.TargetUserId) == p126.TargetPlayer.UserId then
            local v131 = tonumber(v.Time) or 0;
            local v132 = math.max(v131, 0);
            local v133 = math.clamp(v132, 0, v129);

            if v130 == nil or v133 < v130 then
                v130 = v133;
            end;
        end;
    end;

    return v130;
end;

function u2.UpdateReplayPovDeathTrigger(p134, p135) -- Line: 748
    if p134.ReplayPovDead == true then
        return;
    end;

    local v136 = tonumber(p134.ReplayPovDeathTime);

    if v136 == nil then
        return;
    end;

    local v137 = tonumber(p135) or 0;

    if v136 <= math.max(v137, 0) then
        p134:ApplyReplayPovDeathPresentation();
    end;
end;

function u2.ApplyReplayPovDeathPresentation(p138) -- Line: 761
    -- upvalues: ReplayDebugLogger (copy)
    if p138.ReplayPovDead == true then
        return;
    end;

    p138.ReplayPovDead = true;
    p138.SuppressCombatPresentation = true;
    p138:SetReplayDeathScreenVisible(true);
    p138:ClearPresentation();
    p138:DestroyCrosshair();
    p138:UpdateHudPresentation();
    local v139 = p138:GetGameHUD();

    if v139 and v139:FindFirstChild("ScopeUI") then
        v139.ScopeUI.Visible = false;
    end;

    ReplayDebugLogger.Warn("[FirstPersonSpectateObserver] Replay POV death presentation", p138.TargetPlayer and (p138.TargetPlayer.Name or "Unknown") or "Unknown", p138.ReplayPlaybackTime);
end;

function u2.UpdateReplayPovDeathState(p140, p141) -- Line: 779
    local v142 = tonumber(p141);

    if v142 == nil then
        return;
    end;

    local v143 = tonumber(p140.LastReplaySampleHealth);
    p140.LastReplaySampleHealth = v142;

    if v142 > 0 then
        return;
    end;

    if p140.ReplayPovDead == true then
        return;
    end;

    if v143 == nil or v143 > 0 then
        p140:ApplyReplayPovDeathPresentation();
    end;
end;

function u2.GetEquipmentScroller(p144) -- Line: 798
    local v145 = p144:GetPlayerHUD();

    if v145 then
        v145 = v145:FindFirstChild("Equipment");
    end;

    return v145 and v145:FindFirstChild("Scroller") or nil;
end;

function u2.ResolveEquipmentButtonContainer(p146, p147) -- Line: 804
    if typeof(p147) ~= "string" or p147 == "" then
        return nil, nil;
    end;

    local v148 = p146:GetEquipmentScroller();

    if not v148 then
        return nil, nil;
    end;

    local v149 = v148:FindFirstChild(p147);

    if not (v149 and v149:IsA("ImageButton")) then
        return nil, nil;
    end;

    local Button = v149:FindFirstChild("Button");

    if Button and Button:IsA("GuiObject") then
        return v149, Button;
    end;

    return v149, nil;
end;

function u2.GetExpectedEquipmentCount(p150, p151) -- Line: 823
    -- upvalues: WeaponSlotResolver (copy)
    if not p151 then
        return 0;
    end;

    local v152 = 0;

    for _, v in pairs(WeaponSlotResolver.CollectAuthoritativeTools(p151)) do
        if v then
            v152 = v152 + 1;
        end;
    end;

    return v152;
end;

function u2.GetEquipmentButtonCount(p153) -- Line: 837
    local v154 = p153:GetEquipmentScroller();

    if not v154 then
        return 0;
    end;

    local v155 = 0;

    for _, child in ipairs(v154:GetChildren()) do
        if child:IsA("ImageButton") then
            v155 = v155 + 1;
        end;
    end;

    return v155;
end;

function u2.PopulateEquipmentScroller(p156, p157) -- Line: 852
    -- upvalues: WeaponSlotResolver (copy), SampleLoadoutHUD (copy), Menu (copy), normalizeItemPort (copy)
    local v158 = p156:GetEquipmentScroller();

    if not (v158 and p157) then
        return;
    end;

    for _, child in ipairs(v158:GetChildren()) do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    local v159 = WeaponSlotResolver.CollectAuthoritativeTools(p157);
    local v160 = 0;

    for _, v in ipairs(WeaponSlotResolver.GetSupportedSlots()) do
        local v161 = v159[v];

        if v161 then
            local v162 = SampleLoadoutHUD:Clone();
            v162.Parent = v158;
            v162.Name = v161.Name;
            v162.LayoutOrder = WeaponSlotResolver.GetIndexFromClass(v) or 99;
            local Button = v162:FindFirstChild("Button");

            if Button and Button:IsA("GuiObject") then
                local ItemPort = Button:FindFirstChild("ItemPort");

                if ItemPort and ItemPort:IsA("ViewportFrame") then
                    Menu.AddItemToViewport({
                        Name = v161.Name,
                        Type = (v == "Primary" or v == "Secondary") and "Weapon" or v
                    }, ItemPort);
                    normalizeItemPort(ItemPort);
                end;

                v160 = v160 + 1;
            else
                v162:Destroy();
            end;
        end;
    end;

    if v160 > 0 then
        p156.LastHudSourcePlayer = p157;

        return;
    end;

    p156.LastHudSourcePlayer = nil;
end;

function u2.RefreshEquipmentHudValues(p163, p164) -- Line: 897
    -- upvalues: WeaponSlotResolver (copy)
    if not (p163:GetEquipmentScroller() and p164) then
        return;
    end;

    local v165 = WeaponSlotResolver.CollectAuthoritativeTools(p164);

    for _, v in ipairs(WeaponSlotResolver.GetSupportedSlots()) do
        local v166 = v165[v];

        if v166 then
            local _, v167 = p163:ResolveEquipmentButtonContainer(v166.Name);

            if v167 and v167:IsA("GuiObject") then
                local AmmoCount = v167:FindFirstChild("AmmoCount");
                local Infinie = v167:FindFirstChild("Infinie");

                if v == "Primary" or v == "Secondary" then
                    if AmmoCount then
                        AmmoCount.Visible = true;

                        if Infinie then
                            Infinie.Visible = false;
                        end;

                        local Ammo = AmmoCount:FindFirstChild("Ammo");
                        local MaxAmmo = AmmoCount:FindFirstChild("MaxAmmo");

                        if Ammo and Ammo:IsA("TextLabel") then
                            local v168 = p163.TargetState.EquippedToolName == v166.Name and p163.TargetState.CurrentAmmo or (tonumber(v166:GetAttribute("Ammo")) or 0);
                            local v169 = math.floor(v168);
                            Ammo.Text = tostring(v169);
                            Ammo.TextColor3 = math.floor(v168) <= 0 and Color3.fromRGB(160, 50, 50) or Color3.fromRGB(0, 0, 0);
                        end;

                        if MaxAmmo then
                            MaxAmmo = MaxAmmo:FindFirstChild("Ammo");
                        end;

                        if MaxAmmo and MaxAmmo:IsA("TextLabel") then
                            local v170 = p163.TargetState.EquippedToolName == v166.Name and p163.TargetState.StoredAmmo or (tonumber(v166:GetAttribute("StoredAmmo")) or 0);
                            local v171 = math.floor(v170);
                            MaxAmmo.Text = tostring(v171);
                        end;
                    end;
                elseif v == "Knife" then
                    if AmmoCount then
                        AmmoCount.Visible = false;
                    end;

                    if Infinie then
                        Infinie.Visible = true;
                    end;
                elseif v == "Throwable" and AmmoCount then
                    AmmoCount.Visible = true;

                    if Infinie then
                        Infinie.Visible = false;
                    end;

                    local Ammo = AmmoCount:FindFirstChild("Ammo");
                    local MaxAmmo = AmmoCount:FindFirstChild("MaxAmmo");

                    if Ammo and Ammo:IsA("TextLabel") then
                        local v172 = tonumber(v166:GetAttribute("Amount")) or 0;
                        local v173 = math.floor(v172);
                        Ammo.Text = tostring(v173);
                        Ammo.TextColor3 = math.floor(v172) <= 0 and Color3.fromRGB(160, 50, 50) or Color3.fromRGB(0, 0, 0);
                    end;

                    if MaxAmmo then
                        MaxAmmo = MaxAmmo:FindFirstChild("Ammo");
                    end;

                    if MaxAmmo and MaxAmmo:IsA("TextLabel") then
                        MaxAmmo.Text = "";
                    end;
                end;
            end;
        end;
    end;
end;

function u2.RestoreLocalHud(p174) -- Line: 961
    p174:PopulateEquipmentScroller(p174.LocalPlayer);
    p174:RefreshEquipmentHudValues(p174.LocalPlayer);
    local v175 = p174:GetPlayerHUD();

    if v175 and v175:IsA("GuiObject") then
        local ServerData = p174.LocalPlayer:FindFirstChild("ServerData");
        local v176;

        if ServerData == nil then
            v176 = false;
        else
            v176 = ServerData:GetAttribute("Alive") == true;
        end;

        v175.Visible = v176;
    end;
end;

function u2.RefreshPhaseState(p177, p178) -- Line: 971
    -- upvalues: u4 (copy), Server (copy)
    local v179 = u4[Server:GetAttribute("Phase") or ""] ~= true;

    if p178 ~= true and p177.SuppressCombatPresentation == v179 then
        return;
    end;

    p177.SuppressCombatPresentation = v179;

    if v179 == true then
        p177:ClearPresentation();
        p177:DestroyCrosshair();
        p177:UpdateHudPresentation();

        return;
    end;

    if p177.ReplayClip ~= nil and p177.ReplayStartValidated ~= true then
        return;
    end;

    p177:BuildToolPresentation();
    p177:ApplyRuntimeState(true);
end;

function u2.GetStateValue(p180, p181) -- Line: 993
    if p180.PendingEventState and p180.PendingEventState[p181] ~= nil then
        return p180.PendingEventState[p181];
    end;

    if p180.TargetStateFolder and p180.TargetStateFolder.Parent then
        local v182 = p180.TargetStateFolder:GetAttribute(p181);

        if v182 ~= nil then
            return v182;
        end;
    end;

    return p180.TargetSnapshot[p181];
end;

function u2.GetConfiguredSpectatorFieldOfView(p183) -- Line: 1008
    local v184 = p183.LocalPlayer and p183.LocalPlayer:FindFirstChild("PlayerData");

    if v184 then
        v184 = v184:FindFirstChild("Settings");
    end;

    return v184 and tonumber(v184:GetAttribute("FieldOfView")) or nil;
end;

function u2.IsReplayFieldOfViewActive(p185) -- Line: 1014
    if p185.ReplayClip == nil then
        return false;
    end;

    if tonumber(p185.ReplaySampledFieldOfView) == nil then
        return false;
    end;

    return (p185.TargetState.ScopeVisible == true or p185.TargetState.Aiming == true) and true or (p185.ReplayPlaybackTime or 0) < (p185.ReplayFieldOfViewTransitionEndsAt or 0);
end;

function u2.ShouldUseReplaySampledFieldOfView(p186, p187) -- Line: 1027
    if p186.ReplayClip == nil then
        return false;
    end;

    return typeof(p187) == "table" and (p187.ScopeVisible == true or p187.Aiming == true) and true or (p186.ReplayPlaybackTime or 0) < (p186.ReplayFieldOfViewTransitionEndsAt or 0);
end;

function u2.ApplyReplaySampledFieldOfView(p188, p189, p190) -- Line: 1037
    local v191 = tonumber(p189);

    if v191 == nil then
        return;
    end;

    p188.ReplaySampledFieldOfView = v191;

    if p188:ShouldUseReplaySampledFieldOfView(p190) ~= true then
        return;
    end;

    p188:ResetSpectatorFieldOfViewTween(v191);
end;

function u2.ResolveSpectatorFieldOfView(p192) -- Line: 1049
    local v193 = tonumber(p192.TargetState.TargetFOV) or 90;
    local v194 = p192:GetConfiguredSpectatorFieldOfView();

    if p192.ReplayClip then
        return p192:IsReplayFieldOfViewActive() ~= true and (v194 or (v193 or p192.Camera.FieldOfView or 90)) or (tonumber(p192.ReplaySampledFieldOfView) or v193);
    end;

    if p192.TargetState.ScopeVisible == true then
        return v193;
    end;

    if p192.TargetState.Aiming ~= true then
        return v194 or (v193 or p192.Camera.FieldOfView or 90);
    end;

    local v195 = p192.CurrentSettings and tonumber(p192.CurrentSettings.ADSZoom);

    if v194 and v195 then
        return math.max(1, v194 - 5 * v195);
    end;

    return v193;
end;

function u2.GetOrLoadCameraAnimationTrack(p196, p197) -- Line: 1082
    if not p196.CameraModel then
        return nil;
    end;

    local AnimationTrackCache = p196.AnimationTrackCache;
    local AnimationId = p197.AnimationId;

    if typeof(AnimationId) ~= "string" or AnimationId == "" then
        AnimationId = p197:GetFullName();
    end;

    local v198 = AnimationTrackCache[AnimationId];

    if v198 then
        return v198;
    end;

    local v199 = p196.CameraModel:FindFirstChildOfClass("Humanoid");

    if not v199 then
        return nil;
    end;

    local v200 = v199:LoadAnimation(p197);
    local AnimationTrackCache2 = p196.AnimationTrackCache;
    local AnimationId2 = p197.AnimationId;

    if typeof(AnimationId2) ~= "string" or AnimationId2 == "" then
        AnimationId2 = p197:GetFullName();
    end;

    AnimationTrackCache2[AnimationId2] = v200;

    return v200;
end;

function u2.CancelSpectatorFieldOfViewTween(p201) -- Line: 1102
    local ActiveFieldOfViewTween = p201.ActiveFieldOfViewTween;

    if ActiveFieldOfViewTween then
        p201.ActiveFieldOfViewTween = nil;
        ActiveFieldOfViewTween:Cancel();
    end;
end;

function u2.ResetSpectatorFieldOfViewTween(p202, p203) -- Line: 1110
    local v204 = tonumber(p203) or 90;
    p202:CancelSpectatorFieldOfViewTween();
    p202.CurrentFieldOfView = v204;

    if p202.Camera then
        p202.Camera.FieldOfView = v204;
    end;
end;

function u2.SetSpectatorFieldOfViewTarget(u205, p206, p207) -- Line: 1119
    -- upvalues: TweenService (copy)
    local u208 = tonumber(p206) or u205:ResolveSpectatorFieldOfView();

    if u205.CurrentFieldOfView == nil then
        local v209;

        if u205.Camera then
            v209 = u205.Camera.FieldOfView or u208;
        else
            v209 = u208;
        end;

        u205.CurrentFieldOfView = v209;
    end;

    u205.FieldOfViewTweenDuration = tonumber(p207) or 0.12;

    if not u205.Camera then
        u205.CurrentFieldOfView = u208;

        return;
    end;

    u205:CancelSpectatorFieldOfViewTween();
    u205.CurrentFieldOfView = u205.Camera.FieldOfView;

    if math.abs(u205.CurrentFieldOfView - u208) <= 0.001 then
        u205.CurrentFieldOfView = u208;
        u205.Camera.FieldOfView = u208;

        return;
    end;

    local u210 = TweenService:Create(u205.Camera, TweenInfo.new(u205.FieldOfViewTweenDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
        FieldOfView = u208
    });
    u205.ActiveFieldOfViewTween = u210;
    u210.Completed:Connect(function() -- Line: 1143
        -- upvalues: u205 (copy), u210 (copy), u208 (copy)
        if u205.ActiveFieldOfViewTween == u210 then
            u205.ActiveFieldOfViewTween = nil;
            u205.CurrentFieldOfView = u208;
        end;
    end);
    u210:Play();
end;

function u2.ApplyPresentationStateOverrides(p211, p212) -- Line: 1152
    if typeof(p212) ~= "table" then
        return;
    end;

    local v213 = {};

    for _, v in ipairs({ "Aiming", "Inspecting", "Reloading", "Holstered", "EquippedToolName", "EquippedSlot", "EquippedToolSerial", "Movement", "Lean", "TargetFOV", "ScopeVisible", "CrosshairVisible", "CrosshairStyle", "CrosshairSizeX", "CrosshairSizeY", "CrosshairMinSpread", "CrosshairFollowMouse", "CurrentAmmo", "StoredAmmo", "ThrowablePreviewActive", "ThrowablePreviewToolName" }) do
        local v214 = p212[v];

        if v214 ~= nil then
            v213[v] = v214;
            p211.TargetState[v] = v214;
            p211.TargetSnapshot[v] = v214;
        end;
    end;

    if p212.CurrentState == nil then
        if p212.CurrentActionState ~= nil then
            v213.CurrentActionState = p212.CurrentActionState;
            p211.TargetState.CurrentActionState = p212.CurrentActionState;
            p211.TargetSnapshot.CurrentActionState = p212.CurrentActionState;
        end;
    else
        v213.CurrentActionState = p212.CurrentState;
        p211.TargetState.CurrentActionState = p212.CurrentState;
        p211.TargetSnapshot.CurrentActionState = p212.CurrentState;
    end;

    p211.PendingEventState = v213;
end;

function u2.HandlePresentationEvent(p215, p216, p217) -- Line: 1200
    if p215.TargetPlayer ~= p216 then
        return;
    end;

    if typeof(p217) ~= "table" then
        return;
    end;

    local v218 = tonumber(p217.Sequence);

    if v218 == nil or v218 <= p215.LastPresentationSequence then
        return;
    end;

    p215.LastPresentationSequence = v218;
    local Type = p217.Type;

    if typeof(Type) ~= "string" or Type == "" then
        return;
    end;

    p215:ApplyPresentationStateOverrides(p217);

    if Type == "ToolSwapPresented" then
        p215.PendingSwapPresentationMode = p217.IsInitialSpawnPresentation == true and "Initial" or "Immediate";
        p215.DelayHoldForNextBuild = false;
        p215:BuildToolPresentation();
        p215:ApplyRuntimeState(true);
        p215.PendingEventState = nil;

        return;
    end;

    if Type == "ADSBegin" or Type == "ADSEnd" then
        p215.FieldOfViewTweenDuration = tonumber(p217.FOVDuration) or 0.12;

        if p215.ReplayClip then
            p215.ReplayFieldOfViewTransitionEndsAt = math.max(p215.ReplayPlaybackTime or 0, 0) + p215.FieldOfViewTweenDuration;
        end;

        p215:ApplyRuntimeState(true);
        p215.PendingEventState = nil;

        return;
    end;

    if Type == "VaultStart" then
        if p215.SuppressCombatPresentation == true or not p215.CurrentToolModel then
            p215:UpdateHudPresentation();
            p215.PendingEventState = nil;

            return;
        end;

        if p215.TargetState.Aiming ~= true then
            p215:StopActionAnimations();
            p215:PlayTrack("Vault");
            p215:UpdateBaseAnimations();
        end;

        p215:UpdateHudPresentation();
        p215.PendingEventState = nil;

        return;
    end;

    if p215.SuppressCombatPresentation == true or not p215.CurrentToolModel then
        p215:UpdateHudPresentation();
        p215.PendingEventState = nil;

        return;
    end;

    p215.CurrentActionState = p217.CurrentState or (p215.TargetState.CurrentActionState or p215.CurrentActionState);
    p215:StopActionAnimations();

    if Type == "ReloadStart" then
        p215:PlayTrack("Reload");
    elseif Type == "InspectStart" then
        p215:PlayTrack("Inspect");
    elseif Type == "ActionStart" then
        p215:PlayTrack("Action");
    elseif Type == "BoltStart" then
        p215:PlayTrack("Bolt");
    elseif Type == "PumpStart" then
        p215:PlayTrack("Pump");
    end;

    p215:UpdateBaseAnimations();
    p215:UpdateHudPresentation();
    p215.PendingEventState = nil;
end;

function u2.ResolveSpectatedSound(p219, p220, p221) -- Line: 1280
    if typeof(p220) ~= "string" or p220 == "" then
        return nil;
    end;

    local v222 = {};

    if typeof(p221) == "string" and p221 ~= "" then
        if p219.CurrentToolModel then
            table.insert(v222, p219.CurrentToolModel);
        end;

        local v223 = p219.TargetCharacter and p219.TargetCharacter:FindFirstChild(p221, true);

        if v223 then
            table.insert(v222, v223);
        end;

        local v224 = p219.TargetPlayer and (p219.TargetPlayer.Character and p219.ReplayClip == nil) and p219.TargetPlayer.Character:FindFirstChild(p221, true);

        if v224 then
            table.insert(v222, v224);
        end;

        for _, v in ipairs(v222) do
            local v;

            if v then
                v = v:FindFirstChild("Handle", true);
            end;

            if v then
                v = v:FindFirstChild(p220);
            end;

            if v and v:IsA("Sound") then
                return v;
            end;
        end;
    end;

    local v225 = {};
    v225[1], v225[2], v225[3] = p219.TargetCharacter, p219.TargetPlayer and p219.TargetPlayer.Character, p219.CameraModel;

    for _, v in ipairs(v225) do
        if v then
            local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart then
                HumanoidRootPart = HumanoidRootPart:FindFirstChild(p220);
            end;

            if HumanoidRootPart and HumanoidRootPart:IsA("Sound") then
                return HumanoidRootPart;
            end;

            for _, descendant in ipairs(v:GetDescendants()) do
                if descendant:IsA("Sound") and descendant.Name == p220 then
                    return descendant;
                end;
            end;
        end;
    end;

    return nil;
end;

function u2.ResolveReplaySoundParent(p226) -- Line: 1329
    local TargetCharacter = p226.TargetCharacter;

    if TargetCharacter then
        TargetCharacter = TargetCharacter:FindFirstChild("HumanoidRootPart");
    end;

    if TargetCharacter and TargetCharacter:IsA("BasePart") then
        return TargetCharacter;
    end;

    local CameraModel2 = p226.CameraModel;

    if CameraModel2 then
        CameraModel2 = CameraModel2:FindFirstChild("Base");
    end;

    if CameraModel2 and CameraModel2:IsA("BasePart") then
        return CameraModel2;
    end;

    return p226.Camera;
end;

function u2.ClearReplayAudioInstances(p227) -- Line: 1345
    local ReplaySoundInstances = p227.ReplaySoundInstances;

    if not ReplaySoundInstances then
        return;
    end;

    for _, v in pairs(ReplaySoundInstances) do
        if v then
            pcall(function() -- Line: 1353
                -- upvalues: v (copy)
                v:Stop();
                v:Destroy();
            end);
        end;
    end;

    table.clear(ReplaySoundInstances);
end;

function u2.HandleReplayAudioCue(p228, p229) -- Line: 1362
    if typeof(p229) ~= "table" then
        return;
    end;

    local u230 = typeof(p229.SoundName) == "string" and p229.SoundName ~= "" and (p229.SoundName or "ReplayAudioCue") or "ReplayAudioCue";
    local ReplaySoundInstances = p228.ReplaySoundInstances;
    local u231;

    if ReplaySoundInstances then
        u231 = ReplaySoundInstances[u230] or nil;
    else
        u231 = nil;
    end;

    if p229.IsPlaying == false then
        if u231 then
            pcall(function() -- Line: 1372
                -- upvalues: u231 (copy)
                u231:Stop();
                u231:Destroy();
            end);

            if ReplaySoundInstances then
                ReplaySoundInstances[u230] = nil;
            end;
        end;

        return;
    end;

    local SoundId = p229.SoundId;

    if typeof(SoundId) ~= "string" or SoundId == "" then
        return;
    end;

    local v232 = p228:ResolveReplaySoundParent();

    if not v232 then
        return;
    end;

    if u231 then
        pcall(function() -- Line: 1394
            -- upvalues: u231 (copy)
            u231:Stop();
            u231:Destroy();
        end);

        if ReplaySoundInstances then
            ReplaySoundInstances[u230] = nil;
        end;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = u230;
    Sound.SoundId = SoundId;
    local v233 = tonumber(p229.Volume) or 0.65;
    Sound.Volume = math.max(v233, 0);
    local v234 = tonumber(p229.PlaybackSpeed) or 1;
    Sound.PlaybackSpeed = math.max(v234, 0.05);
    local v235 = tonumber(p229.RollOffMinDistance) or 5;
    Sound.RollOffMinDistance = math.max(v235, 0);
    local v236 = tonumber(p229.RollOffMaxDistance) or 45;
    Sound.RollOffMaxDistance = math.max(v236, Sound.RollOffMinDistance);
    Sound.RollOffMode = Enum.RollOffMode.Inverse;
    Sound.Looped = p229.Looped == true;
    Sound.Parent = v232;

    if ReplaySoundInstances then
        ReplaySoundInstances[u230] = Sound;
    end;

    local function cleanupSound() -- Line: 1417
        -- upvalues: ReplaySoundInstances (copy), u230 (copy), Sound (copy)
        if ReplaySoundInstances and ReplaySoundInstances[u230] == Sound then
            ReplaySoundInstances[u230] = nil;
        end;

        if Sound.Parent then
            Sound:Destroy();
        end;
    end;

    if Sound.Looped ~= true then
        Sound.Ended:Connect(cleanupSound);
        task.delay(8, function() -- Line: 1428
            -- upvalues: Sound (copy), ReplaySoundInstances (copy), u230 (copy)
            if Sound.Parent then
                if ReplaySoundInstances and ReplaySoundInstances[u230] == Sound then
                    ReplaySoundInstances[u230] = nil;
                end;

                if Sound.Parent then
                    Sound:Destroy();
                end;
            end;
        end);
    end;

    if pcall(function() -- Line: 1435
        -- upvalues: Sound (copy)
        Sound:Play();
    end) ~= true then
        if ReplaySoundInstances and ReplaySoundInstances[u230] == Sound then
            ReplaySoundInstances[u230] = nil;
        end;

        if Sound.Parent then
            Sound:Destroy();
        end;
    end;
end;

function u2.DestroyCrosshair(p237) -- Line: 1443
    if p237.Crosshair then
        p237.Crosshair:Destroy();
        p237.Crosshair = nil;
    end;

    local v238 = p237:GetPlayerGui();

    if v238 then
        v238 = v238:FindFirstChild("Crosshair");
    end;

    if v238 and v238:IsA("ScreenGui") then
        v238:ClearAllChildren();
    end;
end;

function u2.EnsureCrosshair(p239) -- Line: 1456
    -- upvalues: DynamicCrosshair (copy)
    if p239.Crosshair then
        return p239.Crosshair;
    end;

    local v240 = p239:GetPlayerGui();

    if v240 then
        v240 = v240:FindFirstChild("Crosshair");
    end;

    if not (v240 and v240:IsA("ScreenGui")) then
        return nil;
    end;

    v240:ClearAllChildren();
    p239.Crosshair = DynamicCrosshair.New(v240, 0, 150, 200, 0, false);
    p239.Crosshair.ControlsMouseIcon = false;
    p239.Crosshair.EasingStyle = Enum.EasingStyle.Sine;
    p239.Crosshair.EasingDirection = Enum.EasingDirection.InOut;
    p239.Crosshair:Size(6, 2);
    p239.Crosshair:Display({
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Image = nil,
        ImageTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    });

    return p239.Crosshair;
end;

function u2.ApplyEquipmentHighlight(p241, p242) -- Line: 1483
    if typeof(p242) ~= "string" or p242 == "" then
        return;
    end;

    if p241.LastHighlightedEquipment == p242 then
        return;
    end;

    local v243 = p241:GetPlayerGui();

    if v243 then
        v243 = v243:FindFirstChild("GameHUD");
    end;

    if v243 then
        v243 = v243:FindFirstChild("PlayerHUD");
    end;

    if v243 then
        v243 = v243:FindFirstChild("Equipment");
    end;

    if v243 then
        v243 = v243:FindFirstChild("Scroller");
    end;

    if not v243 then
        return;
    end;

    for _, child in ipairs(v243:GetChildren()) do
        local v244;

        if child:IsA("ImageButton") then
            v244 = child:FindFirstChild("Button") or nil;
        else
            v244 = nil;
        end;

        if child:IsA("ImageButton") and (v244 and v244:IsA("GuiObject")) then
            child.Size = UDim2.new(1, 0, 0.15, 0);
            v244.Size = UDim2.new(1, 0, 1, 0);
            v244.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            local AmmoCount = v244:FindFirstChild("AmmoCount");
            local v245;

            if AmmoCount then
                v245 = AmmoCount:FindFirstChild("Ammo") or nil;
            else
                v245 = nil;
            end;

            local v246 = AmmoCount and AmmoCount:FindFirstChild("MaxAmmo") or nil;
            local v247 = v246 and v246:FindFirstChild("Ammo") or nil;

            if v245 and v245:IsA("TextLabel") then
                v245.TextColor3 = Color3.new(1, 1, 1);
            end;

            if v247 and v247:IsA("TextLabel") then
                v247.TextColor3 = Color3.new(1, 1, 1);
            end;

            local ItemPort = v244:FindFirstChild("ItemPort");

            if ItemPort then
                ItemPort.Size = UDim2.new(0.363, 0, 1, 0);
                ItemPort.Ambient = Color3.new(1, 1, 1);
            end;
        end;
    end;

    local v248, v249 = p241:ResolveEquipmentButtonContainer(p242);

    if v248 and v249 then
        v248.Size = UDim2.new(1, 0, 0.2, 0);
        v249.Size = UDim2.new(1.05, 0, 1, 0);
        v249.BackgroundColor3 = Color3.new(1, 1, 1);
        local AmmoCount = v249:FindFirstChild("AmmoCount");
        local v250;

        if AmmoCount then
            v250 = AmmoCount:FindFirstChild("Ammo") or nil;
        else
            v250 = nil;
        end;

        local v251 = AmmoCount and AmmoCount:FindFirstChild("MaxAmmo") or nil;
        local v252 = v251 and v251:FindFirstChild("Ammo") or nil;

        if v250 and v250:IsA("TextLabel") then
            v250.TextColor3 = Color3.fromRGB(0, 0, 0);
        end;

        if v252 and v252:IsA("TextLabel") then
            v252.TextColor3 = Color3.fromRGB(0, 0, 0);
        end;

        local ItemPort = v249:FindFirstChild("ItemPort");

        if ItemPort then
            ItemPort.Size = UDim2.new(0.363, 0, 0.6, 0);
            ItemPort.Ambient = Color3.fromRGB(0, 0, 0);
        end;
    end;

    p241.LastHighlightedEquipment = p242;
end;

function u2.UpdateHudPresentation(p253) -- Line: 1549
    local v254 = p253:GetPlayerGui();

    if not v254 then
        return;
    end;

    local GameHUD = v254:FindFirstChild("GameHUD");

    if GameHUD and GameHUD:FindFirstChild("ScopeUI") then
        local v255;

        if p253.SuppressCombatPresentation == true then
            v255 = false;
        else
            v255 = p253.TargetState.ScopeVisible == true;
        end;

        GameHUD.ScopeUI.Visible = v255;

        if GameHUD.ScopeUI:FindFirstChild("Scope") then
            GameHUD.ScopeUI.Scope.Position = UDim2.new(0.5, 0, 0.5, 0);
        end;
    end;

    if GameHUD then
        GameHUD = GameHUD:FindFirstChild("PlayerHUD");
    end;

    if p253.SuppressCombatPresentation == true then
        if GameHUD and GameHUD:IsA("GuiObject") then
            GameHUD.Visible = false;
        end;

        local v256 = p253:EnsureCrosshair();

        if v256 then
            v256:Disable();
        end;

        return;
    end;

    if GameHUD and GameHUD:IsA("GuiObject") then
        GameHUD.Visible = true;
        local v257 = p253:GetEquipmentScroller();
        local v258 = p253:GetExpectedEquipmentCount(p253.TargetPlayer);
        local v259 = p253:GetEquipmentButtonCount();
        local v260;

        if p253.TargetState.EquippedToolName == "" then
            v260 = false;
        else
            v260 = v257 == nil and true or v257:FindFirstChild(p253.TargetState.EquippedToolName) == nil;
        end;

        if p253.LastHudSourcePlayer ~= p253.TargetPlayer or (v259 ~= v258 or v260 == true) then
            p253:PopulateEquipmentScroller(p253.TargetPlayer);
        end;

        p253:RefreshEquipmentHudValues(p253.TargetPlayer);
        local Health = GameHUD:FindFirstChild("Health");
        local v261 = p253.TargetCharacter and p253.TargetCharacter:FindFirstChildOfClass("Humanoid");

        if Health and v261 then
            local HealthAmount = Health:FindFirstChild("HealthAmount");

            if HealthAmount then
                local Health2 = HealthAmount:FindFirstChild("Health");
                local MaxHealth = HealthAmount:FindFirstChild("MaxHealth");

                if Health2 and Health2:IsA("TextLabel") then
                    local v262 = math.floor(v261.Health);
                    Health2.Text = tostring(v262);
                end;

                if MaxHealth then
                    MaxHealth = MaxHealth:FindFirstChild("Health");
                end;

                if MaxHealth and MaxHealth:IsA("TextLabel") then
                    local v263 = math.floor(v261.MaxHealth);
                    MaxHealth.Text = "/" .. tostring(v263);
                end;
            end;

            local HealthBar = Health:FindFirstChild("HealthBar");

            if HealthBar then
                local v264 = {};

                for _, child in ipairs(HealthBar:GetChildren()) do
                    if child:IsA("Frame") and child:FindFirstChild("Bar") then
                        table.insert(v264, child);
                    end;
                end;

                table.sort(v264, function(p265, p266) -- Line: 1610
                    return (p265.LayoutOrder or 0) < (p266.LayoutOrder or 0);
                end);
                local v267 = v261.MaxHealth / math.max(#v264, 1);

                for i, v in ipairs(v264) do
                    local v268 = math.clamp(v261.Health - v267 * (i - 1), 0, v267);
                    v.Bar.Size = UDim2.new(v268 / math.max(v267, 1), 0, 1, 0);
                end;
            end;
        end;

        local Equipment = GameHUD:FindFirstChild("Equipment");

        if Equipment then
            Equipment = Equipment:FindFirstChild("Scroller");
        end;

        if Equipment and p253.TargetState.EquippedToolName ~= "" then
            local v269 = Equipment:FindFirstChild(p253.TargetState.EquippedToolName);

            if v269 and (v269:IsA("ImageButton") and v269:FindFirstChild("Button")) then
                local AmmoCount = v269.Button:FindFirstChild("AmmoCount");

                if AmmoCount then
                    local Ammo = AmmoCount:FindFirstChild("Ammo");
                    local MaxAmmo = AmmoCount:FindFirstChild("MaxAmmo");

                    if Ammo and Ammo:IsA("TextLabel") then
                        Ammo.Text = tostring(p253.TargetState.CurrentAmmo or 0);
                    end;

                    if MaxAmmo and (MaxAmmo:FindFirstChild("Ammo") and MaxAmmo.Ammo:IsA("TextLabel")) then
                        MaxAmmo.Ammo.Text = tostring(p253.TargetState.StoredAmmo or 0);
                    end;
                end;
            end;
        end;
    end;

    if p253.TargetState.EquippedToolName ~= "" then
        p253:ApplyEquipmentHighlight(p253.TargetState.EquippedToolName);
    end;

    local v270 = p253:EnsureCrosshair();

    if v270 then
        if p253.TargetState.CrosshairVisible == true then
            v270:Enable();
            local CrosshairStyle = p253.TargetState.CrosshairStyle;
            local v271 = tonumber(p253.TargetState.CrosshairSizeX);
            local v272 = tonumber(p253.TargetState.CrosshairSizeY);
            local v273 = tonumber(p253.TargetState.CrosshairMinSpread);
            local v274;

            if typeof(CrosshairStyle) == "string" then
                v274 = CrosshairStyle ~= "";
            else
                v274 = false;
            end;

            if v274 == true then
                v270:FollowMouse(p253.TargetState.CrosshairFollowMouse == true);
                v270:Size(v271 or 3, v272 or 3);
                v270.Spreading.MinSpread = v273 or 0;
                v270:Set(v273 or 0);

                return;
            end;

            v270:FollowMouse(false);

            if p253.CurrentSlot == "Primary" or p253.CurrentSlot == "Secondary" then
                v270:Size(6, 2);
                local v275 = p253.CurrentSettings and (p253.CurrentSettings.CrosshairSpread and p253.CurrentSettings.CrosshairSpread * 10) or 0;
                v270.Spreading.MinSpread = v275;
                v270:Set(v275);

                return;
            end;

            if p253.CurrentSlot == "Throwable" then
                v270:Size(2, 16);
                v270.Spreading.MinSpread = 50;
                v270:Set(50);

                return;
            end;

            v270:Size(3, 3);
            v270.Spreading.MinSpread = 0;
            v270:Set(0);

            return;
        end;

        v270:Disable();
    end;
end;

function u2.DestroyCameraModel(p276) -- Line: 1684
    if p276.CameraModel then
        p276.CameraModel:Destroy();
        p276.CameraModel = nil;
    end;

    p276.CurrentToolModel = nil;
    p276.CurrentAnimations = nil;
    p276.CommonAnimations = nil;
    p276.CurrentSettings = nil;
    p276.AimPart = nil;
    p276.CurrentToolName = "";
    p276.CurrentSlot = "";
    p276.CurrentToolSerial = "";
    p276.CurrentVisualSignature = "";
    p276.Recoil = CFrame.new();
    p276.SuppressBaseAnimationPlayback = false;
    p276.EquipPresentationSerial = p276.EquipPresentationSerial + 1;
    p276.ArmLerp = 0;
    p276.ArmSin = 0;
    p276.ArmSin2 = 0;
    p276.HoldPrimed = false;
    p276.ADSTransitionActive = false;
    p276.ADSTransitionStartedAt = 0;
    p276.ADSTransitionFromC0 = nil;
    p276.ADSTransitionFromC1 = nil;
    p276.LastADSTransitionAiming = false;
    p276.LastADSTransitionTool = nil;
    table.clear(p276.AnimationTrackCache);
end;

function u2.ClearToolPresentation(p277) -- Line: 1714
    -- upvalues: stopAnimationTracks (copy)
    if p277.CurrentAnimations then
        stopAnimationTracks(p277.CurrentAnimations);
    end;

    if p277.CurrentToolModel then
        p277.CurrentToolModel:Destroy();
        p277.CurrentToolModel = nil;
    end;

    p277.CurrentAnimations = nil;
    p277.CurrentSettings = nil;
    p277.AimPart = nil;
    p277.CurrentToolName = "";
    p277.CurrentSlot = "";
    p277.CurrentToolSerial = "";
    p277.CurrentVisualSignature = "";
    p277.Recoil = CFrame.new();
    p277.SuppressBaseAnimationPlayback = false;
    p277.AwaitingSwapEquipCue = false;
    p277.PendingEquipTrack = nil;
    p277.PendingEquipSerial = 0;
    p277.EquipPresentationSerial = p277.EquipPresentationSerial + 1;
    p277.ADSTransitionActive = false;
    p277.ADSTransitionStartedAt = 0;
    p277.ADSTransitionFromC0 = nil;
    p277.ADSTransitionFromC1 = nil;
    p277.LastADSTransitionAiming = false;
    p277.LastADSTransitionTool = nil;
end;

function u2.EnsureCameraModel(p278) -- Line: 1743
    -- upvalues: cloneCameraModelForPlayer (copy)
    if p278.CameraModel and p278.CameraModel.Parent then
        return p278.CameraModel;
    end;

    if not p278.TargetPlayer then
        return nil;
    end;

    p278:DestroyCameraModel();
    p278.CameraModel = cloneCameraModelForPlayer(p278.TargetPlayer);
    p278.CommonAnimations = p278:LoadCommonAnimations();

    return p278.CameraModel;
end;

function u2.ClearPresentation(p279) -- Line: 1757
    -- upvalues: stopAnimationTracks (copy)
    if p279.CommonAnimations then
        stopAnimationTracks(p279.CommonAnimations);
    end;

    p279:ClearToolPresentation();
    p279:DestroyCameraModel();
end;

function u2.SetPresentationVisible(p280, p281) -- Line: 1765
    p280.PresentationVisible = p281 ~= false;

    if not p280.CameraModel then
        return;
    end;

    local v282 = {
        Base = 1,
        Anim = 1,
        Tool = 1,
        ["Right Hand"] = 1,
        ["Left Hand"] = 1
    };

    for _, descendant in ipairs(p280.CameraModel:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local v283 = v282[descendant.Name];

            if v283 == nil then
                descendant.LocalTransparencyModifier = p280.PresentationVisible and 0 or 1;
            else
                descendant.LocalTransparencyModifier = v283;
            end;
        elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
            descendant.Enabled = p280.PresentationVisible;
        elseif descendant:IsA("Highlight") then
            descendant.Enabled = p280.PresentationVisible;
        end;
    end;
end;

function u2.DisconnectStateConnections(p284) -- Line: 1795
    -- upvalues: disconnectAll (copy)
    disconnectAll(p284.StateConnections);
end;

function u2.DisconnectTargetConnections(p285) -- Line: 1799
    -- upvalues: disconnectAll (copy)
    disconnectAll(p285.TargetConnections);
end;

function u2.DisconnectEventConnections(p286) -- Line: 1803
    -- upvalues: disconnectAll (copy)
    disconnectAll(p286.EventConnections);
end;

function u2.IsReplayOwnedLifecycleSource(p287, p288) -- Line: 1807
    local v289;

    if typeof(p288) == "string" then
        v289 = string.sub(p288, 1, 6) == "Replay";
    else
        v289 = false;
    end;

    return v289;
end;

function u2.ShouldAllowReplayLifecycleMutation(p290, p291, p292) -- Line: 1811
    -- upvalues: ReplayDebugLogger (copy)
    if p290.ReplayClip == nil then
        return true;
    end;

    if p290:IsReplayOwnedLifecycleSource(p291) == true then
        return true;
    end;

    p290.ReplayLastBlockedLifecycleSource = tostring(p291 or "UnknownExternal");
    ReplayDebugLogger.Warn("[FirstPersonSpectateObserver] Block replay " .. tostring(p292), p290.TargetPlayer and (p290.TargetPlayer.Name or "Unknown") or "Unknown", p290.ReplayLastBlockedLifecycleSource, p290.ReplaySessionSerial);

    return false;
end;

function u2.PrepareReplayTakeover(p293, p294) -- Line: 1823
    local v295 = typeof(p294) == "string" and p294 and p294 or "ReplayTakeover";
    p293.SessionId = p293.SessionId + 1;
    p293.ReplayLastLifecycleSource = v295;
    p293.ReplayLastBlockedLifecycleSource = "";
end;

function u2.Stop(p296, p297) -- Line: 1830
    -- upvalues: ReplayDebugLogger (copy), buildDefaultTargetState (copy)
    local v298 = typeof(p297) == "string" and p297 and p297 or "UnknownExternal";

    if p296:ShouldAllowReplayLifecycleMutation(v298, "stop") ~= true then
        return false;
    end;

    p296.SessionId = p296.SessionId + 1;
    p296.ReplayLastLifecycleSource = v298;

    if p296.ReplayClip then
        ReplayDebugLogger.Warn("[FirstPersonSpectateObserver] Stop replay observer", p296.TargetPlayer and (p296.TargetPlayer.Name or "Unknown") or "Unknown", v298, p296.ReplayLastFailureReason);
    end;

    if p296.RenderConnection then
        p296.RenderConnection:Disconnect();
        p296.RenderConnection = nil;
    end;

    p296:DisconnectStateConnections();
    p296:DisconnectTargetConnections();
    p296:DisconnectEventConnections();
    p296:ClearPresentation();
    p296:DestroyCrosshair();
    p296:ClearReplayDeathPresentation();
    p296.Camera:SetAttribute("FirstPersonSpectateActive", false);
    p296.CurrentCameraCFrame = nil;
    p296.LastHudSourcePlayer = nil;
    p296.SuppressCombatPresentation = false;
    p296.DelayHoldForNextBuild = true;
    p296.SuppressBaseAnimationPlayback = false;
    p296.PresentationVisible = true;
    p296.LastPresentationSequence = 0;
    p296.PendingSwapPresentationMode = nil;
    p296.PendingEventState = nil;
    p296.EquipPresentationSerial = p296.EquipPresentationSerial + 1;
    p296:RestoreLocalHud();
    local v299 = p296:GetPlayerGui();

    if v299 then
        v299 = v299:FindFirstChild("GameHUD");
    end;

    if v299 and v299:FindFirstChild("ScopeUI") then
        v299.ScopeUI.Visible = false;
    end;

    if p296.TargetPlayer then
        p296.CameraBasisByPlayer[p296.TargetPlayer] = nil;
    end;

    p296.TargetCameraCFrame = nil;
    p296.LastStateRefreshAttempt = 0;
    p296.TargetPlayer = nil;
    p296.TargetCharacter = nil;
    p296.ReplayTargetCharacter = nil;
    p296.ReplayCameraOnly = false;
    p296.TargetStateFolder = nil;
    p296.TargetSnapshot = buildDefaultTargetState();
    p296.CurrentActionState = "Hold";
    p296.TargetState = buildDefaultTargetState();
    p296.LastHighlightedEquipment = "";
    p296.SnapshotHeadCFrame = nil;
    p296.NextLeanAngle = 0;
    p296.NextLeanDirection = 0;
    p296.CurrentCameraCFrame = nil;
    p296:ClearReplayAudioInstances();
    p296.ReplayClip = nil;
    p296.ReplayStartedAt = 0;
    p296.ReplayNextSampleIndex = 1;
    p296.ReplayNextEventIndex = 1;
    p296.ReplaySampledFieldOfView = nil;
    p296.ReplayFieldOfViewTransitionEndsAt = 0;
    p296.ReplayPlaybackTime = 0;
    p296.ReplayFinished = false;
    p296.ReplayFinishedCallback = nil;
    p296.ReplayStartValidated = false;
    p296.ReplayFirstSampleApplied = false;
    p296.ReplayRenderActive = false;
    p296.ReplayLastFailureReason = "";
    p296.ReplayStatusState = nil;
    p296.ReplayPovDeathTime = nil;
    p296.ReplayLastLifecycleSource = v298;
    p296.HoldPrimed = false;
    p296:ResetSpectatorFieldOfViewTween(p296.Camera and (p296.Camera.FieldOfView or 90) or 90);

    return true;
end;

function u2.LoadAnimations(p300, p301, p302, p303, p304) -- Line: 1910
    -- upvalues: resolveToolAnimationFolder (copy)
    local v305 = resolveToolAnimationFolder(p301, p302, p303, p304);

    if not (v305 and p300.CameraModel) then
        return nil;
    end;

    local v306 = {};
    local Client = v305:FindFirstChild("Client");

    if not Client then
        return v306;
    end;

    for _, child in ipairs(Client:GetChildren()) do
        if child:IsA("Animation") then
            v306[child.Name] = p300:GetOrLoadCameraAnimationTrack(child);
        end;
    end;

    return v306;
end;

function u2.LoadCommonAnimations(p307) -- Line: 1931
    -- upvalues: Run (copy)
    return p307.CameraModel and (Run and Run:IsA("Animation")) and {
        Run = p307:GetOrLoadCameraAnimationTrack(Run)
    } or nil;
end;

function u2.StopBaseAnimationTracks(p308, p309) -- Line: 1941
    local v310;

    if p308.CurrentAnimations then
        v310 = p308.CurrentAnimations.Hold or nil;
    else
        v310 = nil;
    end;

    local v311 = p308.CommonAnimations and p308.CommonAnimations.Run or nil;
    local v312 = p309 or 0;

    if v310 and v310.IsPlaying then
        v310:Stop(v312);
    end;

    if v311 and v311.IsPlaying then
        v311:Stop(v312);
    end;
end;

function u2.PrimeHoldState(p313) -- Line: 1954
    local v314;

    if p313.CurrentAnimations then
        v314 = p313.CurrentAnimations.Hold or nil;
    else
        v314 = nil;
    end;

    local v315;

    if p313.CommonAnimations then
        v315 = p313.CommonAnimations.Run or nil;
    else
        v315 = nil;
    end;

    p313.DelayHoldForNextBuild = false;
    p313.SuppressBaseAnimationPlayback = false;
    p313.CurrentActionState = "Hold";
    p313.TargetState.CurrentActionState = p313.TargetState.CurrentActionState or (p313:GetStateValue("CurrentActionState") or "Hold");
    p313.TargetState.Movement = p313.TargetState.Movement or (p313:GetStateValue("Movement") or "Standing");
    p313:StopBaseAnimationTracks(0);
    p313:StopActionAnimations();

    if v314 then
        v314:Play(0);
        p313.HoldPrimed = true;
    else
        p313.HoldPrimed = false;
    end;

    if v315 and v315.IsPlaying then
        v315:Stop(0);
    end;
end;

function u2.SeedBaseAnimationState(p316) -- Line: 1979
    p316:PrimeHoldState();
    p316:ApplyRuntimeState(true);
end;

function u2.StartHoldTrack(p317, p318) -- Line: 1984
    local v319 = p317.CurrentAnimations and p317.CurrentAnimations.Hold or nil;

    if v319 and v319.IsPlaying ~= true then
        v319:Play(p318 or 0);
    end;
end;

function u2.BuildToolPresentation(p320, p321) -- Line: 1991
    -- upvalues: WeaponSlotResolver (copy), getToolVisualSignature (copy), applyCameraModelAppearance (copy), buildSpectatedToolModel (copy), setSightPresentation (copy), resolveToolSettings (copy), resolveAimPresentation (copy), attachToolModel (copy), Weapon (copy)
    if p320.SuppressCombatPresentation == true then
        return;
    end;

    if not p320.TargetCharacter and p320.ReplayCameraOnly ~= true then
        return;
    end;

    local v322 = p320:GetStateValue("EquippedToolName");
    local v323 = p320:GetStateValue("EquippedSlot");
    local v324 = p320:GetStateValue("EquippedToolSerial") or "";

    if typeof(v322) ~= "string" or v322 == "" then
        p320:ClearToolPresentation();

        return;
    end;

    if typeof(v323) ~= "string" or v323 == "" then
        p320:ClearToolPresentation();

        return;
    end;

    local TargetPlayer = p320.TargetPlayer;
    local v325;

    if TargetPlayer then
        v325 = WeaponSlotResolver.FindToolBySerial(TargetPlayer, v324) or (WeaponSlotResolver.ResolveToolByClass(TargetPlayer, v323) or WeaponSlotResolver.FindToolByName(TargetPlayer, v322));
    else
        v325 = nil;
    end;

    local v326 = getToolVisualSignature(p320.TargetPlayer, v323, v322, v324, v325);
    local PendingSwapPresentationMode = p320.PendingSwapPresentationMode;

    if p320.CurrentVisualSignature == v326 and (p320.CurrentToolModel and p320.CurrentToolModel.Parent) then
        if PendingSwapPresentationMode == "Immediate" and p320.PresentationVisible == true then
            p320:PlaySwapEquipPresentation(false);
        end;

        p320.PendingSwapPresentationMode = nil;

        return;
    end;

    local v327;

    if PendingSwapPresentationMode == "Immediate" and p320.CurrentToolModel ~= nil then
        v327 = p320.CurrentVisualSignature ~= "";
    else
        v327 = false;
    end;

    if not p320:EnsureCameraModel() then
        return;
    end;

    applyCameraModelAppearance(p320.CameraModel, p320.TargetPlayer);
    p320:ClearToolPresentation();

    if v325 then
        v322 = v325.Name or v322;
    end;

    if v325 then
        v324 = WeaponSlotResolver.GetOrAssignToolSerial(v325) or v324;
    end;

    local v328 = buildSpectatedToolModel(p320.TargetPlayer, p320.TargetCharacter, v323, v322, v325);

    if not v328 then
        return;
    end;

    p320.CurrentToolName = v322;
    p320.CurrentSlot = v323;
    p320.CurrentToolSerial = v324;
    p320.CurrentVisualSignature = v326;
    p320.CurrentToolModel = v328;
    setSightPresentation(v328, 0, false);
    p320.CurrentSettings = resolveToolSettings(v325, v322);

    if p320.CurrentSettings and (v323 == "Primary" or v323 == "Secondary") then
        local CurrentSettings = p320.CurrentSettings;
        local CurrentSettings2 = p320.CurrentSettings;
        local v329, v330 = resolveAimPresentation(v328);
        CurrentSettings.ADSZoom = v329;
        CurrentSettings2.SightFront = v330;
    end;

    p320.CurrentAnimations = p320:LoadAnimations(v325, v328, v323, v322);
    p320.AimPart = attachToolModel(p320.CameraModel, v328);
    Weapon.SetExclusiveExtraState({ v328 }, v328, false);

    if v327 == true then
        p320.DelayHoldForNextBuild = false;
        p320.HoldPrimed = p320.CurrentAnimations and p320.CurrentAnimations.Hold ~= nil and true or false;
        p320.CurrentActionState = "Hold";
        p320.TargetState.CurrentActionState = "Hold";
        p320.TargetSnapshot.CurrentActionState = "Hold";
    else
        p320:PrimeHoldState();
    end;

    if p320.PresentationVisible == true then
        if v327 == true then
            p320:PlaySwapEquipPresentation(PendingSwapPresentationMode == "Initial");
        elseif p321 ~= true then
            p320:ApplyRuntimeState(true);
        end;
    end;

    p320.PendingSwapPresentationMode = nil;
    p320:SetPresentationVisible(p320.PresentationVisible);
end;

function u2.StopActionAnimations(p331) -- Line: 2073
    if not p331.CurrentAnimations then
        return;
    end;

    for _, v in ipairs({ "Reload", "Inspect", "Action", "Bolt", "Pump", "Vault" }) do
        local v332 = p331.CurrentAnimations[v];

        if v332 and v332:IsA("AnimationTrack") then
            v332:Stop(0.05);
        end;
    end;
end;

function u2.PrepareADSBasePresentation(p333) -- Line: 2086
    if not p333.CurrentAnimations then
        return;
    end;

    p333:StopActionAnimations();
    local Equip = p333.CurrentAnimations.Equip;

    if Equip and Equip:IsA("AnimationTrack") then
        Equip:Stop(0);
    end;

    p333.SuppressBaseAnimationPlayback = false;
    p333:StopBaseAnimationTracks(0);
    p333:StartHoldTrack(0);
    p333.HoldPrimed = p333.CurrentAnimations.Hold ~= nil;
end;

function u2.PrimeADSTransition(p334, p335) -- Line: 2103
    if p334.LastADSTransitionTool ~= p334.CurrentToolModel then
        p334.LastADSTransitionTool = p334.CurrentToolModel;
        p334.LastADSTransitionAiming = p335;
        p334.ADSTransitionActive = false;
    end;

    if p334.LastADSTransitionAiming ~= p335 then
        if p335 == true then
            p334:PrepareADSBasePresentation();
        end;

        p334.LastADSTransitionAiming = p335;
        p334.ADSTransitionActive = true;
        p334.ADSTransitionStartedAt = os.clock();

        if p334.CameraModel and (p334.CameraModel:FindFirstChild("Anim") and p334.CameraModel.Anim:FindFirstChild("Base")) then
            p334.ADSTransitionFromC0 = p334.CameraModel.Anim.Base.C0;
            p334.ADSTransitionFromC1 = p334.CameraModel.Anim.Base.C1;
        end;
    end;
end;

function u2.PlayTrack(p336, p337) -- Line: 2124
    if not p336.CurrentAnimations then
        return;
    end;

    local v338 = p336.CurrentAnimations[p337];

    if v338 and (v338:IsA("AnimationTrack") and v338.IsPlaying ~= true) then
        v338:Play(0.05);
    end;
end;

function u2.PlaySwapEquipPresentation(u339, p340) -- Line: 2135
    local u341;

    if u339.CurrentAnimations then
        u341 = u339.CurrentAnimations.Equip or nil;
    else
        u341 = nil;
    end;

    if not (u341 and u341:IsA("AnimationTrack")) then
        u339.SuppressBaseAnimationPlayback = false;
        u339:StartHoldTrack(0);
        u339:ApplyRuntimeState(true);

        return;
    end;

    u339:StopActionAnimations();
    u341:Stop(0);
    u341:Play(0.02);

    if p340 == true then
        local EquipPresentationSerial = u339.EquipPresentationSerial;
        u339.SuppressBaseAnimationPlayback = true;
        task.spawn(function() -- Line: 2157
            -- upvalues: u341 (copy), u339 (copy), EquipPresentationSerial (copy)
            u341.Stopped:Wait();

            if u339.EquipPresentationSerial ~= EquipPresentationSerial then
                return;
            end;

            if u339.CurrentAnimations == nil or u339.CurrentAnimations.Equip ~= u341 then
                return;
            end;

            u339.SuppressBaseAnimationPlayback = false;
            u339:StartHoldTrack(0);
            u339:ApplyRuntimeState(true);
        end);

        return;
    end;

    u339.SuppressBaseAnimationPlayback = false;
    u339:StartHoldTrack(0);
    u339:ApplyRuntimeState(true);
end;

function u2.UpdateBaseAnimations(p342) -- Line: 2172
    local v343;

    if p342.CurrentAnimations then
        v343 = p342.CurrentAnimations.Hold or nil;
    else
        v343 = nil;
    end;

    local v344;

    if p342.CommonAnimations then
        v344 = p342.CommonAnimations.Run or nil;
    else
        v344 = nil;
    end;

    local v345 = p342.TargetState.Movement == "Running";

    if p342.SuppressBaseAnimationPlayback == true then
        return;
    end;

    if v343 and v343.IsPlaying ~= true then
        v343:Play(0.08);
    end;

    if v345 then
        if v344 and v344.IsPlaying ~= true then
            v344:Play(0.08);
        end;
    elseif v344 and v344.IsPlaying then
        v344:Stop(0.08);
    end;
end;

function u2.ApplySnapshot(p346, p347, p348) -- Line: 2194
    -- upvalues: buildDefaultTargetState (copy)
    if typeof(p347) ~= "table" then
        return;
    end;

    local State = p347.State;

    if typeof(State) == "table" then
        local v349 = buildDefaultTargetState();

        for i, v in pairs(State) do
            v349[i] = v;
        end;

        p346.TargetSnapshot = v349;
    else
        p346.TargetSnapshot = buildDefaultTargetState();
    end;

    local v350;

    if typeof(p347.HeadCFrame) == "CFrame" then
        v350 = p347.HeadCFrame or nil;
    else
        v350 = nil;
    end;

    p346.SnapshotHeadCFrame = v350;

    if typeof(p347.SpectateCameraCFrame) == "CFrame" and p346.TargetPlayer then
        p346.CameraBasisByPlayer[p346.TargetPlayer] = p347.SpectateCameraCFrame;
        p346.TargetCameraCFrame = p347.SpectateCameraCFrame;

        if p346.CurrentCameraCFrame == nil or (p346.CurrentCameraCFrame.Position - p347.SpectateCameraCFrame.Position).Magnitude > 20 then
            p346.CurrentCameraCFrame = p347.SpectateCameraCFrame;
        end;
    end;

    local v351;

    if typeof(p348) == "table" then
        v351 = p348.SkipBuildToolPresentation == true;
    else
        v351 = false;
    end;

    local v352;

    if typeof(p348) == "table" then
        v352 = p348.SkipToolRuntimeState == true;
    else
        v352 = false;
    end;

    local v353;

    if typeof(p348) == "table" then
        v353 = p348.ForceRuntimeState == false;
    else
        v353 = false;
    end;

    if not v351 then
        p346:BuildToolPresentation(v352);
    end;

    p346:ApplyRuntimeState(not v353);
end;

function u2.ApplyRuntimeState(p354, p355) -- Line: 2230
    -- upvalues: attachToolModel (copy), detachToolModel (copy), setSightPresentation (copy)
    local v356 = p354:ResolveSpectatorFieldOfView();
    p354.TargetState.Aiming = p354:GetStateValue("Aiming") == true;
    p354.TargetState.Inspecting = p354:GetStateValue("Inspecting") == true;
    p354.TargetState.Reloading = p354:GetStateValue("Reloading") == true;
    p354.TargetState.Holstered = p354:GetStateValue("Holstered") == true;
    p354.TargetState.CurrentActionState = p354:GetStateValue("CurrentActionState") or "Hold";
    p354.TargetState.EquippedToolName = p354:GetStateValue("EquippedToolName") or "";
    p354.TargetState.EquippedSlot = p354:GetStateValue("EquippedSlot") or "";
    p354.TargetState.EquippedToolSerial = p354:GetStateValue("EquippedToolSerial") or "";
    p354.TargetState.Movement = p354:GetStateValue("Movement") or "Standing";
    p354.TargetState.Lean = tonumber(p354:GetStateValue("Lean")) or 0;
    p354.TargetState.TargetFOV = tonumber(p354:GetStateValue("TargetFOV")) or 90;
    p354.TargetState.ScopeVisible = p354:GetStateValue("ScopeVisible") == true;
    p354.TargetState.CrosshairVisible = p354:GetStateValue("CrosshairVisible") == true;
    p354.TargetState.CrosshairStyle = p354:GetStateValue("CrosshairStyle");
    p354.TargetState.CrosshairSizeX = tonumber(p354:GetStateValue("CrosshairSizeX"));
    p354.TargetState.CrosshairSizeY = tonumber(p354:GetStateValue("CrosshairSizeY"));
    p354.TargetState.CrosshairMinSpread = tonumber(p354:GetStateValue("CrosshairMinSpread"));
    p354.TargetState.CrosshairFollowMouse = p354:GetStateValue("CrosshairFollowMouse") == true;
    p354.TargetState.CurrentAmmo = tonumber(p354:GetStateValue("CurrentAmmo")) or 0;
    p354.TargetState.StoredAmmo = tonumber(p354:GetStateValue("StoredAmmo")) or 0;
    p354.TargetState.ThrowablePreviewActive = p354:GetStateValue("ThrowablePreviewActive") == true;
    p354.TargetState.ThrowablePreviewToolName = p354:GetStateValue("ThrowablePreviewToolName") or "";
    local v357 = p354:ResolveSpectatorFieldOfView();

    if v357 == v356 then
        if p354.Camera then
            p354.CurrentFieldOfView = p354.Camera.FieldOfView;
        end;
    else
        p354:SetSpectatorFieldOfViewTarget(v357, p354.FieldOfViewTweenDuration or 0.12);
    end;

    if p354.SuppressCombatPresentation == true or not (p354.CameraModel and p354.CurrentToolModel) then
        p354:UpdateHudPresentation();

        return;
    end;

    if p354.TargetState.Holstered == true then
        attachToolModel(p354.CameraModel, p354.CurrentToolModel);
    else
        detachToolModel(p354.CameraModel, p354.CurrentToolModel);
    end;

    p354:PrimeADSTransition(p354.TargetState.Aiming == true);
    local v358;

    if p354.TargetState.Aiming == true then
        v358 = p354.ADSTransitionActive ~= true;
    else
        v358 = false;
    end;

    setSightPresentation(p354.CurrentToolModel, v358 and 1 or 0, v358);
    local CurrentActionState = p354.TargetState.CurrentActionState;

    if p355 == true or p354.CurrentActionState ~= CurrentActionState then
        p354.CurrentActionState = CurrentActionState;
        p354:StopActionAnimations();

        if CurrentActionState == "Reload" then
            p354:PlayTrack("Reload");
        elseif CurrentActionState == "Inspect" then
            p354:PlayTrack("Inspect");
        elseif CurrentActionState == "Action" and (p354.CurrentSlot == "Knife" or p354.CurrentSlot == "Throwable") then
            p354:PlayTrack("Action");
        end;
    else
        p354.CurrentActionState = CurrentActionState;
    end;

    p354:UpdateBaseAnimations();
    p354:UpdateHudPresentation();
end;

function u2.RefreshTargetState(u359) -- Line: 2300
    -- upvalues: WeaponSlotResolver (copy)
    u359.LastStateRefreshAttempt = os.clock();

    if not u359.TargetPlayer then
        return;
    end;

    if u359.ReplayClip then
        if u359.ReplayTargetCharacter and u359.ReplayTargetCharacter.Parent then
            u359.TargetCharacter = u359.ReplayTargetCharacter;
        elseif u359.ReplayCameraOnly == true then
            u359.TargetCharacter = nil;
        else
            if not u359.TargetPlayer.Character then
                return;
            end;

            u359.TargetCharacter = u359.TargetPlayer.Character;
        end;

        u359.TargetStateFolder = nil;
        u359:BuildToolPresentation();
        u359:ApplyRuntimeState(true);

        return;
    end;

    if not u359.TargetPlayer.Character then
        return;
    end;

    u359.TargetCharacter = u359.TargetPlayer.Character;
    u359.TargetStateFolder = WeaponSlotResolver.GetStateFolder(u359.TargetCharacter);

    if not u359.TargetStateFolder then
        u359:BuildToolPresentation();
        u359:ApplyRuntimeState(true);

        return;
    end;

    u359:DisconnectStateConnections();

    for _, v in ipairs({ "EquippedSlot", "EquippedToolName", "EquippedToolSerial", "CurrentActionState", "Aiming", "Inspecting", "Reloading", "Holstered", "Movement", "Lean", "TargetFOV", "ScopeVisible", "CrosshairVisible", "CrosshairStyle", "CrosshairSizeX", "CrosshairSizeY", "CrosshairMinSpread", "CrosshairFollowMouse", "CurrentAmmo", "StoredAmmo", "ThrowablePreviewActive", "ThrowablePreviewToolName" }) do
        local StateConnections = u359.StateConnections;
        local v360 = u359.TargetStateFolder:GetAttributeChangedSignal(v);
        table.insert(StateConnections, v360:Connect(function() -- Line: 2359
            -- upvalues: v (copy), u359 (copy)
            if v == "EquippedSlot" or (v == "EquippedToolName" or v == "EquippedToolSerial") then
                u359:BuildToolPresentation();

                return;
            end;

            u359:ApplyRuntimeState(false);
        end));
    end;

    u359:BuildToolPresentation();
    u359:ApplyRuntimeState(true);
end;

function u2.ComputeFigure8(p361, p362) -- Line: 2372
    local TargetCharacter = p361.TargetCharacter;

    if TargetCharacter then
        TargetCharacter = TargetCharacter:FindFirstChild("HumanoidRootPart");
    end;

    if not TargetCharacter then
        p361.ArmLerp = 0;
        p361.ArmSin = p361.ArmSin + (0 - p361.ArmSin) * 0.3;
        p361.ArmSin2 = p361.ArmSin2 + (0 - p361.ArmSin2) * 0.3;

        return CFrame.new();
    end;

    local Magnitude = (TargetCharacter.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude;

    if math.floor(Magnitude) <= 0 then
        p361.ArmLerp = 0;
        p361.ArmSin = p361.ArmSin + (0 - p361.ArmSin) * 0.3;
        p361.ArmSin2 = p361.ArmSin2 + (0 - p361.ArmSin2) * 0.3;

        return CFrame.Angles(math.rad(p361.ArmSin2), math.rad(p361.ArmSin), 0);
    end;

    p361.ArmLerp = p361.ArmLerp + p362 * Magnitude * 1.1;
    local v363, v364;

    if p361.TargetState.Movement == "Running" then
        v363 = 0.4;
        v364 = 0;
    else
        v363 = 0.1;
        v364 = 1;
    end;

    p361.ArmSin = p361.ArmSin + (math.sin(p361.ArmLerp / 2) * Magnitude * v363 - p361.ArmSin) * 0.4;
    p361.ArmSin2 = p361.ArmSin2 + (math.sin(p361.ArmLerp) * Magnitude * v363 - p361.ArmSin2) * 0.4;

    return CFrame.Angles(math.rad(p361.ArmSin2), math.rad(p361.ArmSin), (math.rad(v364 * p361.ArmSin2)));
end;

function u2.GetFallbackCameraCFrame(p365) -- Line: 2402
    local TargetCharacter = p365.TargetCharacter;

    if TargetCharacter then
        TargetCharacter = TargetCharacter:FindFirstChild("Head");
    end;

    if TargetCharacter and TargetCharacter:IsA("BasePart") then
        return TargetCharacter.CFrame - TargetCharacter.CFrame.LookVector * 0.6;
    end;

    local SnapshotHeadCFrame = p365.SnapshotHeadCFrame;

    if typeof(SnapshotHeadCFrame) == "CFrame" then
        return SnapshotHeadCFrame - SnapshotHeadCFrame.LookVector * 0.6;
    end;

    return nil;
end;

function u2.Render(u366, p367) -- Line: 2417
    -- upvalues: Config (copy), u3 (copy), setSightPresentation (copy)
    if not u366.TargetPlayer then
        return;
    end;

    if not u366.Camera then
        return;
    end;

    if u366.ReplayClip then
        local v368 = os.clock() - u366.ReplayStartedAt;
        local v369 = math.max(v368, 0);
        u366.ReplayPlaybackTime = v369;
        local v370 = u366.ReplayClip.CameraSamples or {};

        while u366.ReplayNextSampleIndex <= #v370 and (v370[u366.ReplayNextSampleIndex].Time or 0) <= v369 do
            u366:ApplyReplaySample(v370[u366.ReplayNextSampleIndex]);
            u366.ReplayNextSampleIndex = u366.ReplayNextSampleIndex + 1;
        end;

        local v371 = u366.ReplayClip.Events or {};

        while u366.ReplayNextEventIndex <= #v371 and (v371[u366.ReplayNextEventIndex].Time or 0) <= v369 do
            local u372 = v371[u366.ReplayNextEventIndex];
            local success, result = pcall(function() -- Line: 2437
                -- upvalues: u366 (copy), u372 (copy)
                u366:DispatchReplayEvent(u372);
            end);

            if success ~= true then
                if u372 then
                    u372 = u372.Type;
                end;

                warn("[FirstPersonSpectateObserver] Replay event failed", u372, result);
            end;

            u366.ReplayNextEventIndex = u366.ReplayNextEventIndex + 1;
        end;

        u366:UpdateReplayPovDeathTrigger(v369);

        if (u366.ReplayClip.Duration or 0) <= v369 and u366.ReplayFinished ~= true then
            u366.ReplayFinished = true;
            local ReplayFinishedCallback = u366.ReplayFinishedCallback;

            if typeof(ReplayFinishedCallback) == "function" then
                task.defer(ReplayFinishedCallback);
            end;
        end;
    end;

    local Character = u366.TargetPlayer.Character;

    if u366.ReplayClip == nil and (Character ~= u366.TargetCharacter or (u366.TargetStateFolder == nil or u366.TargetStateFolder.Parent == nil)) and os.clock() - u366.LastStateRefreshAttempt >= 0.25 then
        u366:RefreshTargetState();
    end;

    if u366.ReplayClip == nil then
        u366.TargetCharacter = Character;
    elseif u366.ReplayTargetCharacter and u366.ReplayTargetCharacter.Parent then
        u366.TargetCharacter = u366.ReplayTargetCharacter;
    elseif u366.ReplayCameraOnly ~= true and u366.TargetCharacter == nil then
        u366.TargetCharacter = Character;
    end;

    if u366.TargetCameraCFrame == nil then
        u366.TargetCameraCFrame = u366.CameraBasisByPlayer[u366.TargetPlayer];

        if u366.ReplayClip and (u366.ReplayClip.CameraSamples and u366.ReplayClip.CameraSamples[1]) then
            u366.TargetCameraCFrame = u366.ReplayClip.CameraSamples[1].CameraCFrame or u366.TargetCameraCFrame;
        end;
    end;

    local TargetCameraCFrame = u366.TargetCameraCFrame;

    if not TargetCameraCFrame then
        if u366.ReplayClip ~= nil then
            u366.ReplayLastFailureReason = "Replay camera target lost during render";

            if u366.ReplayFinished ~= true then
                u366.ReplayFinished = true;
                local ReplayFinishedCallback = u366.ReplayFinishedCallback;

                if typeof(ReplayFinishedCallback) == "function" then
                    task.defer(ReplayFinishedCallback);
                end;
            end;

            return;
        end;

        TargetCameraCFrame = u366:GetFallbackCameraCFrame();

        if not TargetCameraCFrame then
            return;
        end;
    end;

    if u366.CurrentCameraCFrame == nil or (u366.CurrentCameraCFrame.Position - TargetCameraCFrame.Position).Magnitude > 20 then
        u366.CurrentCameraCFrame = TargetCameraCFrame;
    else
        local v373 = math.clamp(p367 * 24, 0, 1);
        u366.CurrentCameraCFrame = u366.CurrentCameraCFrame:Lerp(TargetCameraCFrame, v373);
    end;

    u366.Camera.CFrame = u366.CurrentCameraCFrame;

    if u366.ReplayPovDead == true then
        return;
    end;

    if u366.SuppressCombatPresentation == true or (not u366.CameraModel or u366.CameraModel.Parent == nil) then
        if os.clock() - u366.LastStateRefreshAttempt >= 0.25 then
            u366:RefreshTargetState();
        end;

        return;
    end;

    local CameraModel2 = u366.CameraModel;
    local v374;

    if CameraModel2 then
        v374 = CameraModel2:FindFirstChild("Base");
    else
        v374 = CameraModel2;
    end;

    if not (v374 and v374:IsA("BasePart")) then
        return;
    end;

    local v375 = p367 * 60;
    local v376 = u366.TargetState.Lean or 0;
    local v377 = math.clamp(0.13 * v375, 0, 1);

    if v376 == 0 then
        u366.NextLeanDirection = u366.NextLeanDirection + (-v376 - u366.NextLeanDirection) * v377;
    else
        u366.NextLeanDirection = math.clamp(u366.NextLeanDirection + -v376 * v377, -1, 1);
    end;

    if u366.CurrentToolModel then
        u366.NextLeanAngle = u366.NextLeanAngle + ((Config.LeanAngle or 0) * u366.NextLeanDirection - u366.NextLeanAngle) * math.clamp(v377 * 2, 0, 1);
    else
        u366.NextLeanAngle = u366.NextLeanAngle + (0 - u366.NextLeanAngle) * 1;
    end;

    local v378 = CFrame.fromAxisAngle(Vector3.new(0, 0, 1), (math.rad(u366.NextLeanAngle)));
    v374.CFrame = u366.Camera.CFrame * u3 * v378;

    if not u366.CurrentToolModel then
        return;
    end;

    local CurrentSettings = u366.CurrentSettings;
    local v379 = CurrentSettings and (CurrentSettings.PunchRecover or 0.12) or 0.12;

    if u366.TargetState.Aiming ~= true then
        v379 = v379 * 0.7;
    end;

    u366.Recoil = u366.Recoil:Lerp(CFrame.new(), (math.clamp(v379 * v375, 0, 1)));
    local v380 = u366:ComputeFigure8(p367);
    local v381 = u366.CurrentSlot == "Primary" and true or u366.CurrentSlot == "Secondary";
    local AimPart = u366.AimPart;
    local Anim = CameraModel2:FindFirstChild("Anim");

    if not Anim then
        return;
    end;

    local Base = Anim:FindFirstChild("Base");

    if not (Base and Base:IsA("Motor6D")) then
        return;
    end;

    local v382 = math.clamp(0.4 * v375, 0, 1);

    if v381 and AimPart then
        local v383 = Anim.CFrame:ToObjectSpace(AimPart.CFrame);
        local v384 = u366.TargetState.Aiming == true;
        local v385;

        if v384 then
            v385 = CFrame.new(0, 0, AimPart:GetAttribute("AimZ") or 0.2);
        else
            v385 = CFrame.new();
        end;

        local v386;

        if v384 then
            v386 = u366.Recoil * v383;
        else
            v386 = v385:Inverse() * u366.Recoil * v380;
        end;

        if u366.ADSTransitionActive ~= true then
            Base.C1 = Base.C1:Lerp(v386, v382);
            Base.C0 = v385;
            setSightPresentation(u366.CurrentToolModel, v384 and 1 or 0, v384);

            return;
        end;

        local v387 = (os.clock() - (u366.ADSTransitionStartedAt or 0)) / 0.12;
        local v388 = math.clamp(v387, 0, 1);
        local v389 = u366.ADSTransitionFromC0 or Base.C0;
        local v390 = u366.ADSTransitionFromC1 or Base.C1;
        local v391, v392;

        if v384 then
            v391 = math.clamp((v388 - 0.5) / 0.5, 0, 1);

            if v388 >= 0.5 then
                v392 = true;
            else
                v392 = false;
            end;
        else
            v391 = 0;
            v392 = false;
        end;

        Base.C0 = v389:Lerp(v385, v388);
        Base.C1 = v390:Lerp(v386, v388);
        setSightPresentation(u366.CurrentToolModel, v391, v392);

        if v388 >= 1 then
            u366.ADSTransitionActive = false;
        end;
    else
        u366.ADSTransitionActive = false;
        u366.LastADSTransitionTool = u366.CurrentToolModel;
        u366.LastADSTransitionAiming = false;
        Base.C1 = Base.C1:Lerp(Base.C0:Inverse() * v380, v382);
        Base.C0 = CFrame.new();
        setSightPresentation(u366.CurrentToolModel, 0, false);
    end;
end;

function u2.HandleObservedShoot(p393, p394) -- Line: 2599
    -- upvalues: resolveObservedWeaponModel (copy), Weapon (copy)
    if p393.ReplayClip ~= nil then
        return;
    end;

    if p393.TargetPlayer == nil or p393.TargetPlayer == p394 then
        return;
    end;

    local u395 = resolveObservedWeaponModel(p394, nil);

    if u395 then
        pcall(function() -- Line: 2609
            -- upvalues: Weapon (ref), u395 (copy)
            Weapon.MuzzleShootEffect(u395);
        end);
    end;
end;

function u2.HandleShoot(u396, p397) -- Line: 2615
    -- upvalues: Weapon (copy)
    if u396.TargetPlayer ~= p397 then
        u396:HandleObservedShoot(p397);

        return;
    end;

    if u396.CurrentAnimations and u396.CurrentAnimations.Shoot then
        u396.CurrentAnimations.Shoot:Play(0.02);
    end;

    if u396.CurrentSettings then
        local v398 = (u396.CurrentSettings.HRecoil or 0) * math.random(-1, 1);

        if u396.TargetState.Aiming == true then
            u396.Recoil = CFrame.Angles(0, v398 * 0.00001, 0) * CFrame.new(0, 0, -0.15);
        else
            u396.Recoil = CFrame.Angles(0, v398 * 0.00001, 0) * CFrame.new(0, 0, -0.8);
        end;
    end;

    local Crosshair = u396.Crosshair;

    if Crosshair and (Crosshair.Spreading and u396.TargetState.CrosshairVisible == true) then
        local u399 = tonumber(u396.TargetState.CrosshairMinSpread);

        if u399 == nil and (u396.CurrentSettings and u396.CurrentSettings.CrosshairSpread) then
            u399 = u396.CurrentSettings.CrosshairSpread * 10;
        end;

        if u399 ~= nil then
            pcall(function() -- Line: 2641
                -- upvalues: u396 (copy), Crosshair (copy), u399 (ref)
                if u396.Crosshair ~= Crosshair or Crosshair.Spreading == nil then
                    return;
                end;

                Crosshair:SmoothSet(u399 + 20, 0.05);
            end);
        end;
    end;

    if u396.CurrentToolModel then
        pcall(function() -- Line: 2651
            -- upvalues: Weapon (ref), u396 (copy)
            Weapon.MuzzleShootEffect(u396.CurrentToolModel);
        end);
    end;
end;

function u2.HandleObservedSoundCue(p400, p401, p402, p403, p404) -- Line: 2657
    -- upvalues: resolveObservedSoundTemplate (copy), Weapon (copy)
    if p400.ReplayClip ~= nil then
        return;
    end;

    if p400.TargetPlayer == nil or p400.TargetPlayer == p401 then
        return;
    end;

    if p403 ~= true then
        return;
    end;

    local v405, v406 = resolveObservedSoundTemplate(p401, p402, p404);

    if v405 and v406 then
        Weapon.AddSFX(v405, v406, 1, true);
    end;
end;

function u2.HandleSoundCue(p407, p408, p409, p410, p411) -- Line: 2674
    if p407.TargetPlayer ~= p408 then
        p407:HandleObservedSoundCue(p408, p409, p410, p411);

        return;
    end;

    if typeof(p409) ~= "string" or p409 == "" then
        return;
    end;

    local v412 = p407:ResolveSpectatedSound(p409, p411);

    if v412 then
        if p410 == true then
            v412:Play();
        else
            v412:Stop();
        end;
    end;

    if p410 ~= true then
        return;
    end;

    if p407.ReplayClip then
        return;
    end;

    if p409 == "Pull" then
        if p407.CurrentAnimations and p407.CurrentAnimations.Bolt then
            p407.CurrentAnimations.Bolt:Play(0.02);

            return;
        end;

        if p407.CurrentAnimations and p407.CurrentAnimations.Pump then
            p407.CurrentAnimations.Pump:Play(0.02);
        end;
    elseif p409 == "Action" and (p407.CurrentSlot == "Knife" or p407.CurrentSlot == "Throwable") then
        p407:PlayTrack("Action");
    end;
end;

function u2.HandleObservedImpact(p413, p414, p415, p416, p417, p418, p419) -- Line: 2712
    -- upvalues: HitEffect (copy)
    if p413.ReplayClip ~= nil then
        return;
    end;

    if p413.TargetPlayer == nil or p413.TargetPlayer == p414 then
        return;
    end;

    if typeof(p415) ~= "Instance" or not p415:IsA("BasePart") then
        return;
    end;

    if typeof(p416) ~= "Vector3" or typeof(p417) ~= "Vector3" then
        return;
    end;

    HitEffect.Hit(p415, p416, p417, p418, p419, p414);
end;

function u2.HandleImpact(p420, p421, p422, p423, p424, p425, p426) -- Line: 2729
    -- upvalues: HitEffect (copy)
    if p420.TargetPlayer ~= p421 then
        p420:HandleObservedImpact(p421, p422, p423, p424, p425, p426);

        return;
    end;

    if p420.SuppressCombatPresentation == true then
        return;
    end;

    if typeof(p422) ~= "Instance" or not p422:IsA("BasePart") then
        return;
    end;

    if typeof(p423) ~= "Vector3" or typeof(p424) ~= "Vector3" then
        return;
    end;

    HitEffect.Hit(p422, p423, p424, p425, p426, p421);
end;

function u2.HandleLookRotation(p427, p428, p429, p430) -- Line: 2747
    if typeof(p428) ~= "Instance" or not p428:IsA("Player") then
        return;
    end;

    if typeof(p430) ~= "CFrame" then
        return;
    end;

    p427.CameraBasisByPlayer[p428] = p430;

    if p427.TargetPlayer == p428 then
        p427.TargetCameraCFrame = p430;
    end;
end;

function u2.HandleSpectateSnapshot(p431, p432, p433, p434) -- Line: 2761
    if p431.TargetPlayer ~= p432 then
        return;
    end;

    if p433 ~= p431.SessionId then
        return;
    end;

    p431:ApplySnapshot(p434);
end;

function u2.ApplyReplaySample(p435, p436) -- Line: 2772
    -- upvalues: ReplayDebugLogger (copy), buildDefaultTargetState (copy)
    if typeof(p436) ~= "table" then
        return;
    end;

    if typeof(p436.CameraCFrame) == "CFrame" then
        if p435.ReplayFirstSampleApplied ~= true then
            ReplayDebugLogger.Warn("[FirstPersonSpectateObserver] Replay first sample applied", p435.TargetPlayer and (p435.TargetPlayer.Name or "Unknown") or "Unknown");
        end;

        p435.ReplayFirstSampleApplied = true;
    end;

    local v437 = p435.TargetSnapshot or buildDefaultTargetState();
    local v438 = v437.EquippedToolName or "";
    local v439 = v437.EquippedSlot or "";
    local v440 = v437.EquippedToolSerial or "";
    local v441 = typeof(p436.State) == "table" and (p436.State or {}) or {};
    local v442;

    if typeof(v441.StatusEffects) == "table" then
        v442 = v441.StatusEffects or nil;
    else
        v442 = nil;
    end;

    local v443 = {
        Flash = tonumber(v441.Flash) or 0
    };
    local v444 = {};
    local v445;

    if v442 then
        v445 = v442.Fire;
    else
        v445 = v442;
    end;

    v444.Fire = tonumber(v445) or 0;
    local v446;

    if v442 then
        v446 = v442.Tear;
    else
        v446 = v442;
    end;

    v444.Tear = tonumber(v446) or 0;
    local v447;

    if v442 then
        v447 = v442.Frost;
    else
        v447 = v442;
    end;

    v444.Frost = tonumber(v447) or 0;

    if v442 then
        v442 = v442.Poison;
    end;

    v444.Poison = tonumber(v442) or 0;
    v443.Statuses = v444;
    p435.ReplayStatusState = v443;
    local v448 = tonumber(p436.FieldOfView);

    if v448 == nil then
        v448 = tonumber(v441.TargetFOV);
    end;

    p435:ApplyReplaySampledFieldOfView(v448, v441);
    p435:ApplySnapshot({
        State = v441,
        HeadCFrame = p436.HeadCFrame,
        SpectateCameraCFrame = p436.CameraCFrame
    }, {
        ForceRuntimeState = false,
        SkipToolRuntimeState = true,
        SkipBuildToolPresentation = not ((v438 ~= (v441.EquippedToolName or "") or v439 ~= (v441.EquippedSlot or "")) and true or v440 ~= (v441.EquippedToolSerial or ""))
    });
    p435:UpdateReplayPovDeathState(p436.Health);
end;

function u2.DispatchBootstrapReplayEvent(p449, p450) -- Line: 2823
    if typeof(p450) ~= "table" or not p449.TargetPlayer then
        return;
    end;

    if p450.Type == "ReplayDeath" and tonumber(p450.TargetUserId) == p449.TargetPlayer.UserId then
        p449:ApplyReplayPovDeathPresentation();
    end;
end;

function u2.ApplyBootstrapReplayAudioState(p451, p452, p453) -- Line: 2833
    if typeof(p452) == "table" then
        for _, v in ipairs(p452) do
            if typeof(v) == "table" then
                p451:HandleReplayAudioCue(v);
            end;
        end;
    end;

    if typeof(p453) == "table" then
        for _, v in ipairs(p453) do
            if typeof(v) == "table" then
                p451:HandleReplayAudioCue(v);
            end;
        end;
    end;
end;

function u2.DispatchReplayEvent(p454, p455) -- Line: 2851
    if typeof(p455) ~= "table" or not p454.TargetPlayer then
        return;
    end;

    if p455.Type == "Shoot" then
        p454:HandleShoot(p454.TargetPlayer);

        return;
    end;

    if p455.Type == "SoundCue" then
        p454:HandleSoundCue(p454.TargetPlayer, p455.SoundName, true, p455.WeaponName);

        return;
    end;

    if p455.Type == "ReplayAudioCue" then
        p454:HandleReplayAudioCue(p455);

        return;
    end;

    if p455.Type == "PresentationEvent" and typeof(p455.Payload) == "table" then
        p454:HandlePresentationEvent(p454.TargetPlayer, p455.Payload);

        return;
    end;

    if p455.Type == "ReplayDeath" and tonumber(p455.TargetUserId) == p454.TargetPlayer.UserId then
        p454:ApplyReplayPovDeathPresentation();
    end;
end;

function u2.BindLiveEventMirrors(u456) -- Line: 2869
    -- upvalues: GameEvents (copy), SpectateState (copy), SpectatePresentation (copy), Server (copy)
    u456:DisconnectEventConnections();
    table.insert(u456.EventConnections, GameEvents.LookRotation.OnClientEvent:Connect(function(p457, p458, p459) -- Line: 2872
        -- upvalues: u456 (copy)
        u456:HandleLookRotation(p457, p458, p459);
    end));
    table.insert(u456.EventConnections, SpectateState.OnClientEvent:Connect(function(p460, p461, p462) -- Line: 2876
        -- upvalues: u456 (copy)
        u456:HandleSpectateSnapshot(p460, p461, p462);
    end));
    table.insert(u456.EventConnections, SpectatePresentation.OnClientEvent:Connect(function(p463, p464) -- Line: 2880
        -- upvalues: u456 (copy)
        u456:HandlePresentationEvent(p463, p464);
    end));
    local EventConnections = u456.EventConnections;
    local v465 = Server:GetAttributeChangedSignal("Phase");
    table.insert(EventConnections, v465:Connect(function() -- Line: 2884
        -- upvalues: u456 (copy)
        u456:RefreshPhaseState(false);
    end));
    table.insert(u456.EventConnections, GameEvents.Shoot.OnClientEvent:Connect(function(p466) -- Line: 2888
        -- upvalues: u456 (copy)
        u456:HandleShoot(p466);
    end));
    table.insert(u456.EventConnections, GameEvents.SoundCue.OnClientEvent:Connect(function(p467, p468, p469, p470) -- Line: 2892
        -- upvalues: u456 (copy)
        if typeof(p467) == "Instance" and p467:IsA("Player") then
            u456:HandleSoundCue(p467, p468, p469, p470);
        end;
    end));
    table.insert(u456.EventConnections, GameEvents.Hit.OnClientEvent:Connect(function(p471, p472, p473, p474, p475, p476) -- Line: 2898
        -- upvalues: u456 (copy)
        if typeof(p471) == "Instance" and p471:IsA("Player") then
            u456:HandleImpact(p471, p472, p473, p474, p475, p476);
        end;
    end));
    table.insert(u456.EventConnections, GameEvents.HitFromServer.OnClientEvent:Connect(function(p477, p478, p479, p480, p481, p482) -- Line: 2904
        -- upvalues: u456 (copy)
        if typeof(p477) == "Instance" and p477:IsA("Player") then
            u456:HandleImpact(p477, p478, p479, p480, p481, p482);
        end;
    end));
end;

function u2.RequestSnapshot(p483) -- Line: 2911
    -- upvalues: SpectateStateRequest (copy)
    if not p483.TargetPlayer then
        return;
    end;

    SpectateStateRequest:FireServer(p483.TargetPlayer, p483.SessionId);
end;

function u2.BeginTargetSession(u484, u485) -- Line: 2918
    -- upvalues: buildDefaultTargetState (copy)
    u484.SessionId = u484.SessionId + 1;
    local SessionId = u484.SessionId;
    u484.TargetPlayer = u485;
    u484.TargetCameraCFrame = u484.CameraBasisByPlayer[u485];
    u484.CurrentCameraCFrame = u484.TargetCameraCFrame;
    u484.TargetCharacter = u485.Character;
    u484.TargetStateFolder = nil;
    u484.TargetSnapshot = buildDefaultTargetState();
    u484.SnapshotHeadCFrame = nil;
    u484.LastStateRefreshAttempt = 0;
    u484.LastHudSourcePlayer = nil;
    u484.DelayHoldForNextBuild = true;
    u484.SuppressBaseAnimationPlayback = false;
    u484.HoldPrimed = false;
    u484.LastPresentationSequence = 0;
    u484.PendingSwapPresentationMode = nil;
    u484.PendingEventState = nil;
    u484.EquipPresentationSerial = u484.EquipPresentationSerial + 1;
    u484:ResetSpectatorFieldOfViewTween(u484.Camera and (u484.Camera.FieldOfView or 90) or 90);
    u484:BindLiveEventMirrors();
    u484:RefreshTargetState();
    u484:RefreshPhaseState(true);
    u484:RequestSnapshot();
    table.insert(u484.TargetConnections, u485.CharacterAdded:Connect(function(p486) -- Line: 2944
        -- upvalues: u484 (copy), SessionId (copy), u485 (copy), buildDefaultTargetState (ref)
        if u484.SessionId ~= SessionId or (u484.TargetPlayer ~= u485 or u484.ReplayClip ~= nil) then
            return;
        end;

        u484:ClearPresentation();
        u484.TargetCharacter = p486;
        u484.TargetCameraCFrame = nil;
        u484.CurrentCameraCFrame = nil;
        u484.TargetStateFolder = nil;
        u484.TargetSnapshot = buildDefaultTargetState();
        u484.SnapshotHeadCFrame = nil;
        u484.LastStateRefreshAttempt = 0;
        u484.LastHudSourcePlayer = nil;
        u484.DelayHoldForNextBuild = true;
        u484.SuppressBaseAnimationPlayback = false;
        u484.HoldPrimed = false;
        u484.LastPresentationSequence = 0;
        u484.PendingSwapPresentationMode = nil;
        u484.PendingEventState = nil;
        local v487 = u484;
        v487.EquipPresentationSerial = v487.EquipPresentationSerial + 1;
        u484:ResetSpectatorFieldOfViewTween(u484.Camera and u484.Camera.FieldOfView or 90);
        task.defer(function() -- Line: 2965
            -- upvalues: u484 (ref), SessionId (ref), u485 (ref)
            if u484.SessionId == SessionId and (u484.TargetPlayer == u485 and u484.ReplayClip == nil) then
                u484:RefreshTargetState();
                u484:RequestSnapshot();
                u484:SetPresentationVisible(u484.PresentationVisible);
            end;
        end);
    end));
end;

function u2.Prewarm(p488, p489, p490) -- Line: 2975
    local v491 = typeof(p490) == "string" and p490 and p490 or "LiveSpectateStart";

    if p488:ShouldAllowReplayLifecycleMutation(v491, "prewarm") ~= true then
        return false;
    end;

    if p488:Stop(v491) == false then
        return false;
    end;

    if not p489 then
        return false;
    end;

    p488.ReplayLastLifecycleSource = v491;
    p488.PresentationVisible = false;
    p488:BeginTargetSession(p489);
    p488:SetPresentationVisible(false);

    if p488.HoldPrimed ~= true then
        p488:RefreshTargetState();
    end;

    return true;
end;

function u2.FinalizePreparedStart(u492, p493, p494) -- Line: 2997
    -- upvalues: RunService (copy)
    local v495 = typeof(p494) == "string" and p494 and p494 or "LiveSpectateStart";

    if not p493 then
        return false;
    end;

    if u492:ShouldAllowReplayLifecycleMutation(v495, "start") ~= true then
        return false;
    end;

    if u492.TargetPlayer ~= p493 and u492:Prewarm(p493, v495) ~= true then
        return false;
    end;

    if u492.TargetPlayer ~= p493 then
        return false;
    end;

    if u492.HoldPrimed ~= true then
        u492:RefreshTargetState();
    end;

    u492.Camera:SetAttribute("FirstPersonSpectateActive", true);
    u492:SetPresentationVisible(true);
    u492:ApplyRuntimeState(true);

    if not u492.RenderConnection then
        u492.RenderConnection = RunService.PreRender:Connect(function(p496) -- Line: 3021
            -- upvalues: u492 (copy)
            u492:Render(p496);
        end);
    end;

    u492.ReplayLastLifecycleSource = v495;

    return true;
end;

function u2.Start(p497, p498, p499) -- Line: 3029
    local v500 = typeof(p499) == "string" and p499 and p499 or "LiveSpectateStart";

    if p497:Prewarm(p498, v500) == true then
        return p497:FinalizePreparedStart(p498, v500);
    end;

    return false;
end;

function u2.ResetReplayBootstrapState(p501, p502, p503, p504, p505, p506, p507) -- Line: 3037
    -- upvalues: buildDefaultTargetState (copy)
    p501.SessionId = p501.SessionId + 1;
    p501.Camera:SetAttribute("FirstPersonSpectateActive", true);
    p501.TargetPlayer = p502;
    p501.ReplayTargetCharacter = p505;
    p501.ReplayCameraOnly = p506;

    if p505 and p505.Parent then
        p501.TargetCharacter = p505;
    elseif p506 == true then
        p501.TargetCharacter = nil;
    else
        p501.TargetCharacter = p502.Character;
    end;

    p501.TargetStateFolder = nil;
    p501.TargetSnapshot = buildDefaultTargetState();
    p501.TargetState = buildDefaultTargetState();
    p501.SnapshotHeadCFrame = nil;
    p501.LastStateRefreshAttempt = 0;
    p501.LastHudSourcePlayer = nil;
    p501.DelayHoldForNextBuild = true;
    p501.SuppressBaseAnimationPlayback = false;
    p501.HoldPrimed = false;
    p501.LastPresentationSequence = 0;
    p501.PendingSwapPresentationMode = nil;
    p501.PendingEventState = nil;
    p501.EquipPresentationSerial = p501.EquipPresentationSerial + 1;
    p501.CameraBasisByPlayer[p502] = nil;
    p501.TargetCameraCFrame = nil;
    p501.CurrentCameraCFrame = nil;
    p501.ReplayClip = p503;
    p501.ReplayStartedAt = os.clock() - p507;
    p501.ReplayPlaybackTime = p507;
    p501.ReplayNextSampleIndex = 1;
    p501.ReplayNextEventIndex = 1;
    p501.ReplayFinished = false;
    p501.ReplayFinishedCallback = p504;
    p501.ReplayStartValidated = false;
    p501.ReplayFirstSampleApplied = false;
    p501.ReplayRenderActive = false;
    p501.ReplayLastFailureReason = "";
    p501.ReplayStatusState = nil;
    p501.ReplaySampledFieldOfView = nil;
    p501.ReplayFieldOfViewTransitionEndsAt = 0;
    p501.ReplayPovDeathTime = nil;
    p501:ClearReplayDeathPresentation();
    p501:ClearPresentation();
    p501:DestroyCrosshair();
    p501:ResetSpectatorFieldOfViewTween(p501.Camera and (p501.Camera.FieldOfView or 90) or 90);
    local v508 = p501:GetPlayerGui();

    if v508 then
        v508 = v508:FindFirstChild("GameHUD");
    end;

    if v508 and v508:FindFirstChild("ScopeUI") then
        v508.ScopeUI.Visible = false;
    end;

    p501:RefreshPhaseState(true);
end;

function u2.BootstrapReplayStart(p509, p510, p511, p512, p513, p514, p515) -- Line: 3095
    p509:ApplyReplaySample(p510);

    if typeof(p513) == "table" then
        for _, v in ipairs(p513) do
            p509:DispatchBootstrapReplayEvent(v);
        end;
    end;

    p509:ApplyBootstrapReplayAudioState(p514, p515);
    p509:UpdateReplayPovDeathTrigger(p509.ReplayPlaybackTime);
    p509.ReplayNextSampleIndex = p511;
    p509.ReplayNextEventIndex = p512;
    p509.TargetCameraCFrame = typeof(p510.CameraCFrame) == "CFrame" and p510.CameraCFrame or p509.TargetCameraCFrame;
    p509.CurrentCameraCFrame = p509.TargetCameraCFrame;

    if p509.ReplayPovDead ~= true then
        p509:SetPresentationVisible(true);
        p509:ApplyRuntimeState(true);
    end;

    local v516;

    if p509.ReplayFirstSampleApplied == true then
        v516 = p509.TargetCameraCFrame ~= nil;
    else
        v516 = false;
    end;

    p509.ReplayStartValidated = v516;

    return p509.ReplayStartValidated == true;
end;

function u2.StartReplay(u517, p518, u519, p520, p521) -- Line: 3116
    -- upvalues: ReplayDebugLogger (copy), RunService (copy)
    u517.ReplaySessionSerial = u517.ReplaySessionSerial + 1;
    u517:Stop("ReplayStartReplacement");

    if not p518 or typeof(u519) ~= "table" then
        u517.ReplayLastFailureReason = "Invalid replay target or clip";
        warn("[FirstPersonSpectateObserver] Replay start failed", u517.ReplayLastFailureReason);

        return false;
    end;

    local v522 = nil;
    local v523;

    if typeof(p521) == "table" then
        if p521.TargetCharacter and p521.TargetCharacter:IsA("Model") then
            v522 = p521.TargetCharacter;
        end;

        if p521.ReplayCameraOnly == true then
            v523 = true;
        else
            v523 = false;
        end;
    else
        v523 = false;
    end;

    local v524;

    if typeof(p521) == "table" then
        local v525 = tonumber(p521.InitialPlaybackTime) or 0;
        v524 = math.max(v525, 0);
    else
        v524 = 0;
    end;

    u517:ResetReplayBootstrapState(p518, u519, p520, v522, v523, v524);
    u517.ReplayPovDeathTime = u517:ResolveReplayPovDeathTime(u519);
    ReplayDebugLogger.Warn("[FirstPersonSpectateObserver] Replay bootstrap reset", p518.Name, v524);
    local v526 = u519.CameraSamples or {};
    local v527 = v526[1] or nil;
    local v528 = 1;
    local v529 = 1;

    for i, v in ipairs(v526) do
        if (v.Time or 0) > v524 then
            break;
        end;

        v529 = i + 1;
        v527 = v;
    end;

    local v530 = u519.Events or {};

    while v528 <= #v530 and (v530[v528].Time or 0) <= v524 do
        v528 = v528 + 1;
    end;

    local v531 = {};
    local v532 = {};
    local v533 = {};

    for i = 1, v528 - 1 do
        local v534 = v530[i];
        table.insert(v531, v534);

        if typeof(v534) == "table" and v534.Type == "ReplayAudioCue" then
            local v535;

            if typeof(v534.SoundName) == "string" and v534.SoundName ~= "" then
                v535 = v534.SoundName or nil;
            else
                v535 = nil;
            end;

            local v536 = tonumber(v534.Time) or 0;

            if v534.Looped == true and v535 then
                if v534.IsPlaying == false then
                    v533[v535] = nil;
                else
                    v533[v535] = v534;
                end;
            elseif v534.IsPlaying ~= false and v524 - v536 <= 0.2 then
                table.insert(v532, v534);
            end;
        end;
    end;

    local v537 = {};

    for _, v in pairs(v533) do
        table.insert(v537, v);
    end;

    if not v527 or typeof(v527.CameraCFrame) ~= "CFrame" then
        u517.ReplayLastFailureReason = "Missing initial replay camera sample";
        warn("[FirstPersonSpectateObserver] Replay start failed", p518.Name, u517.ReplayLastFailureReason);
        u517:Stop("ReplayStartFailure");

        return false;
    end;

    if u517:BootstrapReplayStart(v527, v529, v528, v531, v537, v532) ~= true then
        u517.ReplayLastFailureReason = "Replay camera did not validate";
        warn("[FirstPersonSpectateObserver] Replay start failed", p518.Name, u517.ReplayLastFailureReason);
        u517:Stop("ReplayStartFailure");

        return false;
    end;

    table.insert(u517.TargetConnections, p518.CharacterAdded:Connect(function(p538) -- Line: 3196
        -- upvalues: u517 (copy), u519 (copy)
        if u517.ReplayClip == u519 then
            if u517.ReplayTargetCharacter and u517.ReplayTargetCharacter.Parent then
                u517.TargetCharacter = u517.ReplayTargetCharacter;

                return;
            end;

            u517.TargetCharacter = p538;

            return;
        end;

        u517.TargetCharacter = p538;
        u517:ClearPresentation();
        u517:RefreshTargetState();
    end));
    ReplayDebugLogger.Warn("[FirstPersonSpectateObserver] Replay first sample bootstrap", p518.Name, u517.TargetSnapshot.EquippedToolName or "");
    u517.RenderConnection = RunService.PreRender:Connect(function(p539) -- Line: 3211
        -- upvalues: u517 (copy)
        u517:Render(p539);
    end);
    u517.ReplayRenderActive = u517.RenderConnection ~= nil;
    ReplayDebugLogger.Warn("[FirstPersonSpectateObserver] Replay render bound", p518.Name, u517.ReplayRenderActive);
    ReplayDebugLogger.Warn("[FirstPersonSpectateObserver] Replay start success", p518.Name, u517.ReplayStartValidated, u517.ReplayRenderActive);
    local v540;

    if u517.ReplayStartValidated == true then
        v540 = u517.ReplayRenderActive == true;
    else
        v540 = false;
    end;

    return v540;
end;

return v1;