
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local UserInputService = game:GetService("UserInputService");
local Weapon = require(ReplicatedStorage.Components.Weapon);
local ComponentsManager = require(ReplicatedStorage.ComponentsManager);
local DynamicCrosshair = require(ReplicatedStorage.Components.DynamicCrosshair);
local Throwable = require(ReplicatedStorage.Components.Throwable);
local Config = require(ReplicatedStorage:WaitForChild("Config"));
require(ReplicatedStorage.Modules.TypeModules.Types);
local Utility = require(ReplicatedStorage.Modules.Utility);
local WeaponSlotResolver = require(ReplicatedStorage.Modules.WeaponSlotResolver);
local Modules = script.Parent.Parent:WaitForChild("Modules");
local WeaponInventoryController = require(Modules:WaitForChild("WeaponInventoryController"));
local WeaponStateReplicator = require(Modules:WaitForChild("WeaponStateReplicator"));
local CameraModel = ReplicatedStorage:WaitForChild("Components"):WaitForChild("Player"):WaitForChild("CameraModel");
local ReplayAudioCue = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("ReplayAudioCue");
local u1 = {
    ADS = true,
    ADSRelease = true,
    Crouch = true,
    Lean = true,
    Prone = true,
    Run = true,
    Stand = true,
    Vault = true
};
local v2 = {};
local u3 = {};
local v4 = {};
u3.__index = v4;

function v2.new(p5) -- Line: 155
    -- upvalues: u3 (copy), WeaponStateReplicator (copy), ReplicatedStorage (copy), WeaponSlotResolver (copy)
    local v6 = setmetatable({}, u3);
    v6.Player = p5;
    v6.Camera = workspace.CurrentCamera;
    v6.CameraModel = v6:SetupCameraModel(p5);
    v6.Animations = v6:SetupAnimations(p5);
    v6.AimPart = v6.CameraModel.Base;
    v6.CurrentTool = nil;
    v6.CurrentToolID = 0;
    v6.CurrentState = "Hold";
    v6.Holster = true;
    v6.Jumping = false;
    v6.QuickAction = false;
    v6.ActionDebounce = false;
    v6.CurrentToolIndex = 0;
    v6.ADSZoom = 1;
    v6.SpawnEquipPresentationPending = true;
    v6.ThrowableSnapshot = nil;
    v6.StateFolder = nil;
    v6.StateReplicator = WeaponStateReplicator.new(ReplicatedStorage.GameEvents, nil);
    v6.InventoryDisconnect = nil;
    v6.ClientWeaponSystemScript = WeaponSlotResolver.ResolveClientWeaponSystem(p5.Character);
    v6:SetupTools(p5);
    v6:Died(p5);
    v6:SetupCrosshair();
    v6:SetFP(p5);
    v6:SetReadinessState(false, false, false, false);

    return v6;
end;

function v4.SetupAnimations(p7, p8) -- Line: 195
    local v9 = {
        Client = {},
        Server = {}
    };

    for _, child in script.Animations:GetChildren() do
        for _, child2 in child:GetChildren() do
            if child.Name == "Client" then
                v9[child.Name][child2.Name] = p7.CameraModel.Humanoid:LoadAnimation(child2);
            elseif child.Name == "Server" then
                local Character = p8.Character;
                assert(Character, "SetupAnimations failed because there is no player character");
                v9[child.Name][child2.Name] = Character.Humanoid:LoadAnimation(child2);
            end;
        end;
    end;

    return v9;
end;

local function ResolveSoundCueInstance(p10, p11, p12) -- Line: 215
    local Character = p10.Player.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v13;

    if HumanoidRootPart then
        v13 = HumanoidRootPart:FindFirstChild(p11);
    else
        v13 = nil;
    end;

    if not v13 and (typeof(p12) == "string" and p12 ~= "") then
        local v14 = Character:FindFirstChild(p12, true);

        if v14 then
            v14 = v14:FindFirstChild("Handle", true);
        end;

        if v14 then
            v13 = v14:FindFirstChild(p11) or nil;
        else
            v13 = nil;
        end;
    end;

    if not v13 and (p10.CurrentTool and p10.CurrentTool.Model) then
        local Handle = p10.CurrentTool.Model:FindFirstChild("Handle", true);

        if Handle then
            v13 = Handle:FindFirstChild(p11) or nil;
        else
            v13 = nil;
        end;
    end;

    if not v13 then
        for _, descendant in ipairs(Character:GetDescendants()) do
            if descendant:IsA("Sound") and descendant.Name == p11 then
                v13 = descendant;
                break;
            end;
        end;
    end;

    if v13 and v13:IsA("Sound") then
        return v13;
    end;

    return nil;
end;

local function EmitReplayAudioCue(p15, p16, p17, p18) -- Line: 254
    -- upvalues: u1 (copy), ResolveSoundCueInstance (copy), ReplayAudioCue (copy)
    if u1[p16] ~= true then
        return;
    end;

    local v19 = ResolveSoundCueInstance(p15, p16, p18);

    if not v19 then
        return;
    end;

    ReplayAudioCue:FireServer({
        CueType = p16,
        IsPlaying = p17,
        Looped = v19.Looped == true,
        SoundId = v19.SoundId,
        SoundName = v19.Name,
        Volume = v19.Volume,
        PlaybackSpeed = v19.PlaybackSpeed,
        RollOffMinDistance = v19.RollOffMinDistance,
        RollOffMaxDistance = v19.RollOffMaxDistance
    });
end;

function v4.SoundCue(p20, p21, p22, p23) -- Line: 277
    -- upvalues: EmitReplayAudioCue (copy)
    p20:ServerSoundCue(p21, p22, p23);
    EmitReplayAudioCue(p20, p21, p22, p23);
    p20:ClientSoundCue(p21, p22, p23);
end;

function v4.ServerSoundCue(p24, p25, p26, p27) -- Line: 283
    -- upvalues: ReplicatedStorage (copy)
    ReplicatedStorage.GameEvents.SoundCue:FireServer(p25, p26, p27);
end;

function v4.ClientSoundCue(p28, p29, p30, p31) -- Line: 287
    -- upvalues: ResolveSoundCueInstance (copy)
    local v32 = ResolveSoundCueInstance(p28, p29, p31);

    if not v32 then
        return;
    end;

    if p30 then
        v32:Play();

        return;
    end;

    v32:Stop();
end;

function v4.SetupCameraModel(p33, u34) -- Line: 300
    -- upvalues: CameraModel (copy), ReplicatedStorage (copy)
    p33.Camera:ClearAllChildren();
    local u35 = CameraModel:Clone();
    u35.Base.Transparency = 1;
    u35.Anim.Transparency = 1;
    u35.Tool.Transparency = 1;
    u35["Right Hand"].Transparency = 1;
    u35["Left Hand"].Transparency = 1;
    u35.TestWeapon:Destroy();
    pcall(function() -- Line: 321
        -- upvalues: u34 (copy), ReplicatedStorage (ref), u35 (copy)
        local PlayerData = u34:FindFirstChild("PlayerData");
        assert(PlayerData, "SetupCameraModel failed because PlayerData is nil");
        local v36 = u34:WaitForChild("PlayerData"):WaitForChild("Loadout"):FindFirstChild(PlayerData.Settings:GetAttribute("LoadoutName"));
        assert(v36, "SetupCameraModel failed because PlayerLoadout is nil");
        local v37 = v36:GetAttribute("Head");
        local v38 = ReplicatedStorage.Items.Head[v37]:WaitForChild("Body Colors");
        u35["Left Arm"].Color = v38.LeftArmColor3;
        u35["Right Arm"].Color = v38.RightArmColor3;
    end);
    u35.Parent = p33.Camera;
    p33.ClientHighlight = u35:FindFirstChild("Highlight");

    return u35;
end;

function v4.ValidateToolAnimations(p39, p40, p41, p42) -- Line: 348
    -- upvalues: Utility (copy)
    if not p40 then
        warn(Utility.warnCustom("ValidateToolAnimations failed because ToolData is nil"));

        return false;
    end;

    if not p40.Tool then
        warn(Utility.warnCustom("ValidateToolAnimations failed because ToolData.Tool is nil"));

        return false;
    end;

    if not p40.Animations then
        warn(Utility.warnCustom((`ValidateToolAnimations failed because {p40.Tool.Name} has no Animations table`)));

        return false;
    end;

    if not p40.Animations.Client then
        warn(Utility.warnCustom((`ValidateToolAnimations failed because {p40.Tool.Name} has no Client animations table`)));

        return false;
    end;

    if not p40.Animations.Server then
        warn(Utility.warnCustom((`ValidateToolAnimations failed because {p40.Tool.Name} has no Server animations table`)));

        return false;
    end;

    for _, v in ipairs(p41 or {}) do
        if not p40.Animations.Client[v] then
            warn(Utility.warnCustom((`Missing CLIENT animation "{v}" for {p40.Tool.Name}`)));

            return false;
        end;
    end;

    for _, v in ipairs(p42 or {}) do
        if not p40.Animations.Server[v] then
            warn(Utility.warnCustom((`Missing SERVER animation "{v}" for {p40.Tool.Name}`)));

            return false;
        end;
    end;

    return true;
end;

function v4.SetupToolAnimations(u43, p44, p45) -- Line: 397
    -- upvalues: Utility (copy), ReplicatedStorage (copy), Config (copy), Throwable (copy)
    local v46 = {
        Client = {},
        Server = {}
    };

    if not p45 then
        warn(Utility.warnCustom("SetupToolAnimations failed because toolAnimationFolder is nil"));

        return v46;
    end;

    local v47 = u43.CameraModel and u43.CameraModel:FindFirstChildOfClass("Humanoid");

    if not v47 then
        warn(Utility.warnCustom("SetupToolAnimations failed because CameraModel Humanoid is missing"));

        return v46;
    end;

    local Character = p44.Character;

    if not Character then
        warn(Utility.warnCustom("SetupToolAnimations failed because player character is missing"));

        return v46;
    end;

    local v48 = Character:FindFirstChildOfClass("Humanoid");

    if v48 then
        for _, child in ipairs(p45:GetChildren()) do
            if child.Name == "Client" or child.Name == "Server" then
                for _, child2 in ipairs(child:GetChildren()) do
                    if child2:IsA("Animation") then
                        local v49;

                        if child.Name == "Client" then
                            v49 = v47:LoadAnimation(child2);
                            v46.Client[child2.Name] = v49;
                        else
                            v49 = v48:LoadAnimation(child2);
                            v46.Server[child2.Name] = v49;
                        end;

                        if child.Name == "Client" then
                            if child2.Name == "Reload" then
                                v49:GetMarkerReachedSignal("MagOut"):Connect(function() -- Line: 450
                                    -- upvalues: u43 (copy)
                                    if not u43.CurrentTool then
                                        warn("Failed to MagOut because no CurrentTool exists");

                                        return;
                                    end;

                                    local v50 = u43.CurrentTool.Model and u43.CurrentTool.Model:FindFirstChild("Handle");

                                    if v50 then
                                        v50 = v50:FindFirstChild("MagOut");
                                    end;

                                    if v50 then
                                        v50:Play();
                                        u43:ServerSoundCue("MagOut", true, u43.CurrentTool.Model.Name);
                                    end;
                                end);
                                v49:GetMarkerReachedSignal("MagIn"):Connect(function() -- Line: 462
                                    -- upvalues: u43 (copy)
                                    if not u43.CurrentTool then
                                        warn("Failed to MagIn because no CurrentTool exists");

                                        return;
                                    end;

                                    local v51 = u43.CurrentTool.Model and u43.CurrentTool.Model:FindFirstChild("Handle");

                                    if v51 then
                                        v51 = v51:FindFirstChild("MagIn");
                                    end;

                                    if v51 then
                                        v51:Play();
                                        u43:ServerSoundCue("MagIn", true, u43.CurrentTool.Model.Name);
                                    end;
                                end);
                                v49:GetMarkerReachedSignal("Insert"):Connect(function() -- Line: 474
                                    -- upvalues: u43 (copy)
                                    if not u43.CurrentTool then
                                        warn("Failed to Insert because no CurrentTool exists");

                                        return;
                                    end;

                                    local v52 = u43.CurrentTool.Model and u43.CurrentTool.Model:FindFirstChild("Handle");

                                    if v52 then
                                        v52 = v52:FindFirstChild("Insert");
                                    end;

                                    if v52 then
                                        v52:Play();
                                        u43:ServerSoundCue("Insert", true, u43.CurrentTool.Model.Name);
                                    end;
                                end);
                                v49:GetMarkerReachedSignal("Reload"):Connect(function() -- Line: 486
                                    -- upvalues: u43 (copy), ReplicatedStorage (ref)
                                    if u43.CurrentTool then
                                        if u43.CurrentTool.ReloadCancel == false then
                                            ReplicatedStorage.GameEvents.Reload:FireServer(u43.CurrentTool.Model.Name);
                                        end;

                                        return;
                                    end;

                                    warn("Failed to Reload because no CurrentTool exists");
                                end);
                                v49:GetMarkerReachedSignal("ShellInsert"):Connect(function() -- Line: 494
                                    -- upvalues: u43 (copy)
                                    if not u43.CurrentTool then
                                        warn("Failed to ShellInsert because no CurrentTool exists");

                                        return;
                                    end;

                                    local v53 = u43.CurrentTool.Model and u43.CurrentTool.Model:FindFirstChild("Handle");

                                    if v53 then
                                        v53 = v53:FindFirstChild("ShellInsert");
                                    end;

                                    if v53 then
                                        v53:Play();
                                        u43:ServerSoundCue("ShellInsert", true, u43.CurrentTool.Model.Name);
                                    end;
                                end);
                            elseif child2.Name == "Action" then
                                v49:GetMarkerReachedSignal("Throw"):Connect(function() -- Line: 507
                                    -- upvalues: u43 (copy), Config (ref), Throwable (ref), ReplicatedStorage (ref)
                                    if not u43.CurrentTool then
                                        warn("Failed to Throw because no CurrentTool exists");

                                        return;
                                    end;

                                    Config.AddSound("Knife_Swing", nil, true, game.SoundService, false);
                                    u43:ToggleToolModelVisible(u43.CurrentTool.Model, false);
                                    local ThrowableSnapshot = u43.ThrowableSnapshot;

                                    if not ThrowableSnapshot then
                                        local Character2 = u43.Player.Character;

                                        if Character2 then
                                            Character2 = Throwable.BuildClientThrowData(Character2, u43.Camera, u43.Player.PlayerGui.Crosshair, u43.CurrentTool.Model, {
                                                Character2,
                                                u43.Camera,
                                                u43.CameraModel,
                                                u43.CurrentTool.Model
                                            });
                                        end;

                                        if Character2 then
                                            ThrowableSnapshot = {
                                                ToolName = u43.CurrentTool.Tool.Name,
                                                CameraPosition = Character2.CameraPosition,
                                                ViewDirection = Character2.ViewDirection or Character2.Direction,
                                                StartPosition = Character2.Origin,
                                                ThrowData = Character2
                                            };
                                            u43.ThrowableSnapshot = ThrowableSnapshot;
                                        end;
                                    end;

                                    if ThrowableSnapshot then
                                        ReplicatedStorage.GameEvents.Tactical:FireServer(ThrowableSnapshot.ToolName, ThrowableSnapshot.ViewDirection, ThrowableSnapshot.CameraPosition, ThrowableSnapshot.StartPosition, "Throwable");
                                    end;
                                end);
                            elseif child2.Name == "Bolt" then
                                v49:GetMarkerReachedSignal("Pull"):Connect(function() -- Line: 545
                                    -- upvalues: u43 (copy)
                                    if not u43.CurrentTool then
                                        warn("Failed to Pull because no CurrentTool exists");

                                        return;
                                    end;

                                    local v54 = u43.CurrentTool.Model and u43.CurrentTool.Model:FindFirstChild("Handle");

                                    if v54 then
                                        v54 = v54:FindFirstChild("Pull");
                                    end;

                                    if v54 then
                                        v54:Play();
                                        u43:ServerSoundCue("Pull", true, u43.CurrentTool.Model.Name);
                                    end;
                                end);
                                v49:GetMarkerReachedSignal("Push"):Connect(function() -- Line: 557
                                    -- upvalues: u43 (copy)
                                    if not u43.CurrentTool then
                                        warn("Failed to Push because no CurrentTool exists");

                                        return;
                                    end;

                                    local v55 = u43.CurrentTool.Model and u43.CurrentTool.Model:FindFirstChild("Handle");

                                    if v55 then
                                        v55 = v55:FindFirstChild("Push");
                                    end;

                                    if v55 then
                                        v55:Play();
                                        u43:ServerSoundCue("Push", true, u43.CurrentTool.Model.Name);
                                    end;
                                end);
                            elseif child2.Name == "Pump" then
                                v49:GetMarkerReachedSignal("Pull"):Connect(function() -- Line: 570
                                    -- upvalues: u43 (copy)
                                    if not u43.CurrentTool then
                                        warn("Failed to Pull-2 because no CurrentTool exists");

                                        return;
                                    end;

                                    local v56 = u43.CurrentTool.Model and u43.CurrentTool.Model:FindFirstChild("Handle");

                                    if v56 then
                                        v56 = v56:FindFirstChild("Pull");
                                    end;

                                    if v56 then
                                        v56:Play();
                                        u43:ServerSoundCue("Pull", true, u43.CurrentTool.Model.Name);
                                    end;
                                end);
                            end;
                        end;
                    else
                        warn(Utility.warnCustom((`Ignoring non-animation object inside animation folder: {child2:GetFullName()}`)));
                    end;
                end;
            else
                warn(Utility.warnCustom((`Ignoring unknown animation folder: {child:GetFullName()}`)));
            end;
        end;

        return v46;
    end;

    warn(Utility.warnCustom("SetupToolAnimations failed because character Humanoid is missing"));

    return v46;
end;

function v4.GetClassFromIndex(p57, p58) -- Line: 589
    return p58 == 1 and "Primary" or (p58 == 2 and "Secondary" or (p58 == 3 and "Knife" or (p58 == 4 and "Throwable" or nil)));
end;

function v4.GetStateFolder(p59) -- Line: 603
    -- upvalues: WeaponSlotResolver (copy)
    local Character = p59.Player.Character;
    p59.StateFolder = Character and WeaponSlotResolver.GetStateFolder(Character) or nil;

    if p59.StateReplicator then
        p59.StateReplicator:SetStateFolder(p59.StateFolder);
    end;

    return p59.StateFolder;
end;

function v4.GetClientWeaponSystemScript(p60) -- Line: 612
    -- upvalues: WeaponSlotResolver (copy)
    p60.ClientWeaponSystemScript = WeaponSlotResolver.ResolveClientWeaponSystem(p60.Player.Character);

    return p60.ClientWeaponSystemScript;
end;

function v4.SetReadinessState(p61, p62, p63, p64, p65) -- Line: 618
    -- upvalues: WeaponSlotResolver (copy)
    local v66 = p61:GetClientWeaponSystemScript();

    if v66 then
        v66:SetAttribute("SwapInProgress", p62);
        v66:SetAttribute("WeaponPresentationReady", p63);
        v66:SetAttribute("WeaponFullyReady", p64);
        v66:SetAttribute("WeaponReady", p64);

        if p65 ~= nil then
            v66:SetAttribute("InitialEquipReady", p65);
        end;
    end;

    WeaponSlotResolver.UpdateStateFolder(p61:GetStateFolder(), {
        SwapInProgress = p62,
        WeaponPresentationReady = p63,
        WeaponFullyReady = p64,
        WeaponReady = p64,
        InitialEquipReady = p65
    });
end;

function v4.IsWeaponPresentationReady(p67) -- Line: 639
    local v68 = p67:GetClientWeaponSystemScript();

    if v68 then
        return v68:GetAttribute("WeaponPresentationReady") == true;
    end;

    return false;
end;

function v4.IsWeaponReady(p69) -- Line: 647
    local v70 = p69:GetClientWeaponSystemScript();

    if not v70 then
        return false;
    end;

    local v71;

    if v70:GetAttribute("SwapInProgress") == true then
        v71 = false;
    else
        v71 = v70:GetAttribute("WeaponFullyReady") == true;
    end;

    return v71;
end;

function v4.ResetWeaponPresentationState(p72, p73) -- Line: 655
    if not p73 then
        return;
    end;

    p72.CurrentState = "Hold";

    if p73.Aiming ~= nil then
        p73.Aiming = false;
    end;

    if p73.ReloadCancel ~= nil then
        p73.ReloadCancel = false;
    end;

    if p73.Reloading ~= nil then
        p73.Reloading = false;
    end;

    if p73.Bolting ~= nil then
        p73.Bolting = false;
    end;

    if p73.Pumping ~= nil then
        p73.Pumping = false;
    end;

    if p73.SemiCooldown ~= nil then
        p73.SemiCooldown = false;
    end;

    if p73.Settings and p73.Settings.SightFront then
        p73.Settings.SightFront.Transparency = 0;
    end;

    if p72.Crosshair then
        p72.Crosshair:Enable();
    end;

    local PlayerGui = p72.Player:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("GameHUD");
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("ScopeUI");
    end;

    if PlayerGui and PlayerGui:IsA("ScreenGui") then
        PlayerGui.Visible = false;

        return;
    end;

    if PlayerGui and PlayerGui:IsA("GuiObject") then
        PlayerGui.Visible = false;
    end;
end;

function v4.GetCrosshairPresentationState(p74) -- Line: 696
    local v75 = 3;
    local v76 = 3;
    local v77 = 0;
    local v78;

    if p74.Crosshair then
        v75 = p74.Crosshair.SizeX or v75;
        v76 = p74.Crosshair.SizeY or v76;
        v77 = tonumber(p74.Crosshair.Spreading.MinSpread) or v77;

        if p74.Crosshair.FollowingMouse == true then
            v78 = true;
        else
            v78 = false;
        end;
    else
        v78 = false;
    end;

    return {
        CrosshairStyle = p74.CurrentTool and (p74.CurrentTool.Tool and p74.CurrentTool.Tool:GetAttribute("Class") == "Throwable") and "Throwable" or (p74.CurrentTool and p74.CurrentTool.CrosshairSpread and "Gun" or "Dot"),
        CrosshairSizeX = v75,
        CrosshairSizeY = v76,
        CrosshairMinSpread = v77,
        CrosshairFollowMouse = v78
    };
end;

function v4.PushRuntimeState(p79, p80, p81) -- Line: 725
    if not p79.StateReplicator then
        return;
    end;

    local v82 = p81 or {};

    for i, v in pairs(p79:GetCrosshairPresentationState()) do
        if v82[i] == nil then
            v82[i] = v;
        end;
    end;

    p79:GetStateFolder();
    p79.StateReplicator:SendActionState(p80, v82);
end;

function v4.SendEquipRequest(p83, p84, p85) -- Line: 741
    -- upvalues: ReplicatedStorage (copy), WeaponSlotResolver (copy)
    if not p83.StateReplicator then
        ReplicatedStorage.GameEvents.SwapWeapon:FireServer(p85.Name);

        return;
    end;

    p83:GetStateFolder();
    local v86 = WeaponSlotResolver.GetOrAssignToolSerial(p85);
    p83.StateReplicator:SendEquipRequest(p84, v86, p85.Name);
end;

function v4.ConfirmServerEquip(p87, p88) -- Line: 752
    if not p87.StateReplicator then
        return;
    end;

    p87:GetStateFolder();
    p87.StateReplicator:ConfirmEquip(p88);
end;

function v4.RejectPendingEquip(p89, p90) -- Line: 761
    if not p89.StateReplicator then
        return;
    end;

    p89:GetStateFolder();
    p89.StateReplicator:RejectPendingEquip(p90);
end;

function v4.BuildPresentationEventContext(p91, p92) -- Line: 770
    -- upvalues: WeaponSlotResolver (copy)
    local CurrentTool = p91.CurrentTool;
    local v93;

    if CurrentTool then
        v93 = CurrentTool.Tool or nil;
    else
        v93 = nil;
    end;

    local v94 = v93 and (WeaponSlotResolver.GetToolClass(v93) or "") or "";
    local v95 = v93 and (WeaponSlotResolver.GetOrAssignToolSerial(v93) or "") or "";
    local v96 = v93 and (v93.Name or "") or "";
    local v97 = v93 and (tonumber(v93:GetAttribute("Ammo")) or 0) or 0;
    local v98 = v93 and (tonumber(v93:GetAttribute("StoredAmmo")) or (tonumber(v93:GetAttribute("Amount")) or 0)) or 0;
    local v99 = {
        ScopeVisible = false,
        Slot = v94,
        ToolSerial = v95,
        ToolName = v96,
        CurrentState = p91.CurrentState,
        Aiming = CurrentTool and CurrentTool.Aiming == true and true or false,
        CrosshairVisible = p91.Crosshair and p91.Crosshair.Enabled == true and true or false,
        TargetFOV = p91.Camera and p91.Camera.FieldOfView or workspace.CurrentCamera.FieldOfView,
        CurrentAmmo = v97,
        StoredAmmo = v98
    };

    for i, v in pairs(p92 or {}) do
        v99[i] = v;
    end;

    return v99;
end;

function v4.SendPresentationEvent(p100, p101, p102) -- Line: 798
    if not p100.StateReplicator then
        return nil;
    end;

    p100:GetStateFolder();

    return p100.StateReplicator:SendPresentationEvent(p101, p100:BuildPresentationEventContext(p102));
end;

function v4.HasRegisteredTool(p103, p104) -- Line: 807
    if typeof(p104) == "number" then
        p104 = p103:GetClassFromIndex(p104);
    end;

    if not p104 then
        return false;
    end;

    local v105 = p103.Tools and p103.Tools[p104];
    local v106;

    if v105 == nil or v105.Tool == nil then
        v106 = false;
    else
        v106 = v105.Model ~= nil;
    end;

    return v106;
end;

function v4.GetFirstAvailableToolIndex(p107) -- Line: 821
    for _, v in ipairs({ 1, 2, 3, 4 }) do
        if p107:HasRegisteredTool(v) then
            return v;
        end;
    end;

    return nil;
end;

function v4.GetRegisteredToolModels(p108) -- Line: 831
    local v109 = {};

    for _, v in pairs(p108.Tools or {}) do
        if v and v.Model then
            table.insert(v109, v.Model);
        end;
    end;

    return v109;
end;

function v4.RefreshWeaponExtras(p110) -- Line: 843
    -- upvalues: Weapon (copy)
    local v111;

    if p110.CurrentTool and (p110.CurrentTool.Model and p110.Holster ~= false) then
        v111 = p110.CurrentTool.Model;
    else
        v111 = nil;
    end;

    Weapon.SetExclusiveExtraState(p110:GetRegisteredToolModels(), v111, false);
end;

function v4.IsToolModelAttachedToArm(p112, p113) -- Line: 852
    local v114;

    if p113 then
        v114 = p113:FindFirstChild("Handle") or p113:FindFirstChild("Base");
    else
        v114 = p113;
    end;

    if not p112.CameraModel or (not v114 or p113.Parent ~= p112.CameraModel) then
        return false;
    end;

    local Motor = v114:FindFirstChild("Motor");
    local v115;

    if Motor == nil then
        v115 = false;
    else
        v115 = Motor:IsA("Motor6D");

        if v115 then
            if Motor.Part0 == p112.CameraModel.Tool then
                v115 = Motor.Part1 == v114;
            else
                v115 = false;
            end;
        end;
    end;

    return v115;
end;

function v4.EnsureToolModelPresentation(p116, p117) -- Line: 862
    if not (p117 and p117.Model) then
        return;
    end;

    if p116.CurrentTool == p117 == true and p116.Holster ~= false then
        if p116:IsToolModelAttachedToArm(p117.Model) ~= true then
            p116:AttachToolModelToArm(p117.Model);
        end;
    elseif p117.Model.Parent ~= script.ReserveModels or p116:IsToolModelAttachedToArm(p117.Model) == true then
        p116:DetachToolModelFromArm(p117.Model);
    end;

    p116:RefreshWeaponExtras();
end;

function v4.EnsureCurrentToolPresentation(p118) -- Line: 881
    if not p118.CurrentTool then
        return;
    end;

    p118:EnsureToolModelPresentation(p118.CurrentTool);
end;

function v4.SetTools(p119, p120, p121) -- Line: 889
    -- upvalues: WeaponSlotResolver (copy), ReplicatedStorage (copy), ComponentsManager (copy), Weapon (copy)
    local v122 = p121:GetAttribute("Class");

    if not (p121:IsA("Tool") and v122) then
        return;
    end;

    if p119.Tools == nil then
        p119.Tools = {};
    end;

    local v123 = p119.Tools[v122];
    local v124 = nil;
    local v125;

    if v123 == nil then
        v125 = false;
    else
        local Tool = v123.Tool;
        local v126;

        if Tool then
            v126 = Tool.Name == p121.Name;
        else
            v126 = Tool;
        end;

        local v127;

        if Tool then
            v127 = Tool:GetAttribute("Skin") == p121:GetAttribute("Skin");
        else
            v127 = Tool;
        end;

        local v128;

        if Tool then
            v128 = Tool:GetAttribute("Class") == v122;
        else
            v128 = Tool;
        end;

        local v129;

        if v123.Model == nil then
            v129 = false;
        else
            v129 = v123.Model.Parent ~= nil;
        end;

        local v130 = Tool and (WeaponSlotResolver.GetOrAssignToolSerial(Tool) or "") or "";
        local v131 = WeaponSlotResolver.GetOrAssignToolSerial(p121);
        local v132;

        if Tool == p121 then
            v132 = true;
        elseif v130 == "" then
            v132 = false;
        else
            v132 = v130 == v131;
        end;

        if v126 == true and (v127 == true and v128 == true) then
            v125 = v129 == true;
        else
            v125 = false;
        end;

        v124 = v125 == true and (p119.CurrentTool == v123 and v132 == true) and {
            Aiming = v123.Aiming == true,
            ReloadCancel = v123.ReloadCancel == true,
            Reloading = v123.Reloading == true,
            Bolting = v123.Bolting == true,
            Pumping = v123.Pumping == true,
            SemiCooldown = v123.SemiCooldown == true
        } or v124;

        if v125 ~= true then
            if p119.CurrentTool == v123 then
                p119.CurrentTool = nil;
                p119.CurrentToolIndex = 0;
            end;

            if v123.Model then
                v123.Model:Destroy();
            end;

            p119.Tools[v122] = nil;
            v123 = nil;
        end;
    end;

    if v123 == nil then
        p119.Tools[v122] = {};
        v123 = p119.Tools[v122];

        if v122 == "Primary" or v122 == "Secondary" then
            v123.Model = ReplicatedStorage.Items.Weapon[p121.Name]:Clone();
            ComponentsManager.Weapon.WeldWeapon(v123.Model);
            v123.Model.Parent = script.ReserveModels;
            ComponentsManager.Weapon.SetFullAttachmentOnWeapon(v123.Model, p120);
            local PlayerData = p120:FindFirstChild("PlayerData");
            Weapon.SetAttachmentSkins(v123.Model, PlayerData.Loadout[PlayerData.Settings:GetAttribute("LoadoutName")], v122);
            ComponentsManager.Weapon.SetSkinOnWep(v123.Model, p121:GetAttribute("Skin"));
            ComponentsManager.Weapon.SetupWeaponEffects(v123.Model);
            ComponentsManager.Weapon.SetModelProperties(v123.Model, false, false);
            ComponentsManager.Weapon.SetPlayerArmSkin(p119.CameraModel, p120);
        else
            v123.Model = ReplicatedStorage.Items[v122][p121.Name]:Clone();
            ComponentsManager.Weapon.WeldWeapon(v123.Model);
            v123.Model.Parent = script.ReserveModels;
            ComponentsManager.Weapon.SetModelProperties(v123.Model, false, false);
        end;
    end;

    v123.Tool = p121;
    v123.Stats = v123.Stats or {};

    if v122 == "Primary" or v122 == "Secondary" then
        local Settings = require(p121:WaitForChild("Settings", 1));
        v123.Settings = table.clone(Settings);
        v123.Settings.HRecoil = v123.Settings.HRecoil * (100 - v123.Model:GetAttribute("Horizontal") * 0.01);
        v123.Settings.VRecoil = v123.Settings.VRecoil * (100 - v123.Model:GetAttribute("Vertical") * 0.01);
        v123.Settings.HipFireReduction = v123.Model:GetAttribute("HipFireReduction");
        local Settings2 = v123.Settings;
        local Settings3 = v123.Settings;
        local v133, v134 = p119:GetADSZoom(v123.Model);
        Settings2.ADSZoom = v133;
        Settings3.SightFront = v134;
        v123.CrosshairSpread = v123.Settings.MaxSpread * (1 - v123.Settings.HipFireReduction / 100);

        if v123.Animations == nil or v125 ~= true then
            v123.Animations = p119:SetupToolAnimations(p120, p121:WaitForChild("Settings"):WaitForChild("Animations"));
        end;
    elseif v123.Animations == nil or v125 ~= true then
        v123.Animations = p119:SetupToolAnimations(p120, (v123.Model:FindFirstChild("Handle") or v123.Model:FindFirstChild("Base")).Animations);
    end;

    if v124 then
        v123.Aiming = v124.Aiming;
        v123.ReloadCancel = v124.ReloadCancel;
        v123.Reloading = v124.Reloading;
        v123.Bolting = v124.Bolting;
        v123.Pumping = v124.Pumping;
        v123.SemiCooldown = v124.SemiCooldown;
    else
        v123.Aiming = false;
        v123.ReloadCancel = false;
        v123.Reloading = false;
        v123.Bolting = false;
        v123.Pumping = false;
        v123.SemiCooldown = false;
    end;

    Weapon.SetExtraState(v123.Model, false, false);
    p119:EnsureToolModelPresentation(v123);
end;

function v4.RemoveToolClass(p135, p136) -- Line: 1005
    -- upvalues: WeaponSlotResolver (copy)
    local v137 = p135.Tools and p135.Tools[p136];

    if not v137 then
        return;
    end;

    local v138 = p135.CurrentTool == v137;

    if v137.Model then
        v137.Model:Destroy();
    end;

    p135.Tools[p136] = nil;

    if v138 then
        p135.CurrentTool = nil;

        if p135.CurrentToolIndex == WeaponSlotResolver.GetIndexFromClass(p136) then
            p135.CurrentToolIndex = 0;
        end;
    end;

    p135:RefreshWeaponExtras();
end;

function v4.SyncToolsFromInventory(u139, p140, p141) -- Line: 1027
    -- upvalues: WeaponSlotResolver (copy)
    u139.Tools = u139.Tools or {};
    local CurrentToolIndex = u139.CurrentToolIndex;
    local v142;

    if CurrentToolIndex == 0 then
        v142 = nil;
    else
        v142 = u139:GetClassFromIndex(CurrentToolIndex) or nil;
    end;

    local v143 = false;

    for _, v in ipairs(WeaponSlotResolver.GetSupportedSlots()) do
        local v144 = p141[v];

        if v144 then
            local v145 = u139.Tools[v] and u139.Tools[v].Tool;
            u139:SetTools(p140, v144);

            if v142 == v and v145 ~= v144 then
                v143 = true;
            end;
        else
            u139:RemoveToolClass(v);
        end;
    end;

    if v142 and (v143 == true and u139:HasRegisteredTool(CurrentToolIndex)) then
        task.defer(function() -- Line: 1048
            -- upvalues: u139 (copy), CurrentToolIndex (copy)
            if u139:HasRegisteredTool(CurrentToolIndex) then
                u139:SwapTools(CurrentToolIndex, true);
            end;
        end);
    end;
end;

function v4.SetupTools(u146, u147) -- Line: 1056
    -- upvalues: WeaponInventoryController (copy)
    u146.Tools = {};
    u146:GetStateFolder();

    if u146.InventoryDisconnect then
        u146.InventoryDisconnect();
        u146.InventoryDisconnect = nil;
    end;

    u146.InventoryDisconnect = WeaponInventoryController.WatchPlayerInventory(u147, function(p148) -- Line: 1065
        -- upvalues: u146 (copy), u147 (copy)
        u146:SyncToolsFromInventory(u147, p148);
    end);
end;

function v4.Died(u149, p150) -- Line: 1070
    local Character = u149.Player.Character;
    assert(Character, "Died failed because there is no player character");
    Character:WaitForChild("Humanoid").Died:Connect(function() -- Line: 1074
        -- upvalues: u149 (copy)
        if u149.InventoryDisconnect then
            u149.InventoryDisconnect();
            u149.InventoryDisconnect = nil;
        end;

        u149.CameraModel:Destroy();
        u149.CurrentTool = nil;
        u149.Crosshair:Disable();
    end);
end;

function v4.SetupCrosshair(p151) -- Line: 1086
    -- upvalues: Config (copy), DynamicCrosshair (copy)
    if not Config.Crosshair then
        return;
    end;

    local Crosshair = p151.Player.PlayerGui.Crosshair;
    Crosshair:ClearAllChildren();
    p151.Crosshair = DynamicCrosshair.New(Crosshair, 0, 150, 200, 0, false);
    p151.Crosshair.EasingStyle = Enum.EasingStyle.Sine;
    p151.Crosshair.EasingDirection = Enum.EasingDirection.InOut;
    p151.Crosshair:Size(6, 2);
    p151.Crosshair:Display({
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Image = nil,
        ImageTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    });
end;

function v4.GetToolAnimationFolder(p152, p153, p154) -- Line: 1121
    if not p153 then
        return nil;
    end;

    local function IsValidAnimationFolder(p155) -- Line: 1126
        if not p155 then
            return false;
        end;

        if not p155:IsA("Folder") then
            return false;
        end;

        if p155.Name ~= "Animations" then
            return false;
        end;

        if p155:FindFirstChild("Client") then
            return p155:FindFirstChild("Server") and true or false;
        end;

        return false;
    end;

    local function FindAnimationsInside(p156) -- Line: 1150
        if not p156 then
            return nil;
        end;

        local Animations = p156:FindFirstChild("Animations");
        local v157;

        if Animations and (Animations:IsA("Folder") and (Animations.Name == "Animations" and Animations:FindFirstChild("Client"))) then
            v157 = Animations:FindFirstChild("Server") and true or false;
        else
            v157 = false;
        end;

        if v157 then
            return Animations;
        end;

        local Settings = p156:FindFirstChild("Settings");

        if Settings then
            local Animations2 = Settings:FindFirstChild("Animations");
            local v158;

            if Animations2 and (Animations2:IsA("Folder") and (Animations2.Name == "Animations" and Animations2:FindFirstChild("Client"))) then
                v158 = Animations2:FindFirstChild("Server") and true or false;
            else
                v158 = false;
            end;

            if v158 then
                return Animations2;
            end;
        end;

        for _, descendant in ipairs(p156:GetDescendants()) do
            local v159;

            if descendant and (descendant:IsA("Folder") and (descendant.Name == "Animations" and descendant:FindFirstChild("Client"))) then
                v159 = descendant:FindFirstChild("Server") and true or false;
            else
                v159 = false;
            end;

            if v159 then
                return descendant;
            end;
        end;

        return nil;
    end;

    return FindAnimationsInside(p153.Tool) or (FindAnimationsInside(p153.Model) or nil);
end;

function v4.SwapTools(u160, p161, p162) -- Line: 1195
    -- upvalues: Utility (copy), WeaponSlotResolver (copy)
    if not u160.CameraModel then
        warn(Utility.warnCustom("Failed to swap tools because CameraModel is nil"));

        return false;
    end;

    if not u160.CameraModel:FindFirstChild("Tool") then
        warn(Utility.warnCustom("Failed to swap tools because CameraModel.Tool is missing"));

        return false;
    end;

    u160:SetFP(u160.Player);
    local v163;

    if p161 == 1 then
        v163 = "Primary";
    elseif p161 == 2 then
        v163 = "Secondary";
    elseif p161 == 3 then
        v163 = "Knife";
    else
        if p161 ~= 4 then
            warn(Utility.warnCustom((`Failed to swap tools because weapon index {p161} is invalid`)));

            return false;
        end;

        v163 = "Throwable";
    end;

    local v164 = u160.Tools and u160.Tools[v163];

    if not v164 then
        if v163 ~= "Throwable" then
            warn(Utility.warnCustom((`Failed to swap tools because ToolData for {v163} is nil on index {p161} for {u160.Player.Name}`)));
        end;

        return false;
    end;

    if not v164.Tool then
        warn(Utility.warnCustom((`Failed to swap tools because ToolData.Tool for {v163} is nil on index {p161} for {u160.Player.Name}`)));

        return false;
    end;

    if not v164.Model then
        warn(Utility.warnCustom((`Failed to swap tools because ToolData.Model for {v164.Tool.Name} is nil on index {p161} for {u160.Player.Name}`)));

        return false;
    end;

    local v165 = u160:GetToolAnimationFolder(v164, v163);

    if not v165 then
        warn(Utility.warnCustom((`Failed to swap tools because {v164.Tool.Name} has no valid Animations folder with Client and Server folders. Checked Tool and Model.`)));

        if v164.Tool then
            warn(Utility.warnCustom((`Tool path: {v164.Tool:GetFullName()}`)));
        end;

        if v164.Model then
            warn(Utility.warnCustom((`Model path: {v164.Model:GetFullName()}`)));
        end;

        return false;
    end;

    if not u160:ValidateToolAnimations(v164, { "Equip", "Hold" }, { "Equip", "Hold" }) then
        v164.Animations = u160:SetupToolAnimations(u160.Player, v165);
        warn(Utility.warnCustom((`Weapon animation repatch activated for {v164.Tool.Name}`)));
    end;

    if not u160:ValidateToolAnimations(v164, { "Equip", "Hold" }, { "Equip", "Hold" }) then
        warn(Utility.warnCustom((`Failed to swap to {v164.Tool.Name} because required Equip/Hold animations are missing for {u160.Player.Name} on index {p161}`)));

        return false;
    end;

    for _, v in pairs(u160.Tools or {}) do
        if v and v.Model then
            u160:DetachToolModelFromArm(v.Model);
        end;
    end;

    local u166 = u160.SpawnEquipPresentationPending == true;
    local v167;

    if u166 == true then
        v167 = false;
    else
        v167 = nil;
    end;

    u160:SetReadinessState(true, false, false, v167);
    u160:AttachToolModelToArm(v164.Model);
    u160.CurrentTool = v164;
    u160.CurrentToolID = math.random(-100, 100);
    u160.CurrentToolIndex = p161;
    u160:ResetWeaponPresentationState(v164);
    u160:EnsureCurrentToolPresentation();
    local v168;

    if u166 == true then
        v168 = false;
    else
        v168 = nil;
    end;

    u160:SetReadinessState(true, true, false, v168);
    local v169 = WeaponSlotResolver.GetOrAssignToolSerial(v164.Tool);

    if p162 == true then
        u160:ConfirmServerEquip({
            Slot = v163,
            ToolSerial = v169,
            ToolName = v164.Tool.Name
        });
    else
        u160:SendEquipRequest(v163, v164.Tool);
    end;

    u160:MagazineActivation();
    u160:StopOtherToolsAnimations();
    u160.SpawnEquipPresentationPending = false;
    u160.CurrentTool.Animations.Client.Equip:Play();
    u160.CurrentTool.Animations.Server.Equip:Play();
    u160:SendPresentationEvent("ToolSwapPresented", {
        CurrentState = "Hold",
        Aiming = false,
        Reloading = false,
        Slot = v163,
        ToolSerial = v169,
        ToolName = v164.Tool.Name,
        Holstered = u160.Holster,
        IsInitialSpawnPresentation = u166
    });
    local CurrentTool = u160.CurrentTool;
    local CurrentToolID = u160.CurrentToolID;
    task.spawn(function() -- Line: 1317
        -- upvalues: CurrentTool (copy), u160 (copy), CurrentToolID (copy), WeaponSlotResolver (ref), u166 (copy)
        if CurrentTool and (CurrentTool.Animations and (CurrentTool.Animations.Client and CurrentTool.Animations.Client.Equip)) then
            CurrentTool.Animations.Client.Equip.Stopped:Wait();
        end;

        if u160.CurrentTool ~= CurrentTool or u160.CurrentToolID ~= CurrentToolID then
            return;
        end;

        local v170 = CurrentTool.Aiming == true and true or u160.CurrentState == "ADS";

        if v170 ~= true then
            local v171 = u160:GetClientWeaponSystemScript();

            if v171 then
                local v172 = v171:GetAttribute("BufferedADSIntent") == true;
                local v173 = tonumber(v171:GetAttribute("BufferedADSSwapGeneration")) or 0;
                local v174 = tonumber(v171:GetAttribute("SwapGeneration")) or 0;
                local v175 = v171:GetAttribute("BufferedADSToolSerial") or "";
                local v176 = tostring(v175);
                local v177 = CurrentTool.Tool and WeaponSlotResolver.GetOrAssignToolSerial(CurrentTool.Tool) or "";

                if v172 == true and (v173 ~= 0 and (v173 == v174 and v176 ~= "")) then
                    v170 = v176 == v177;
                else
                    v170 = false;
                end;
            end;
        end;

        if v170 == true then
            CurrentTool.Aiming = true;
            u160:PrepareEquipTransitionForADS(CurrentTool);
            u160.CurrentState = "ADS";
            u160:PushRuntimeState("ADS", {
                Aiming = true,
                Inspecting = false,
                Reloading = false,
                Holstered = u160.Holster
            });

            if u160.Crosshair then
                u160.Crosshair:Disable();
            end;

            if CurrentTool.Settings and CurrentTool.Settings.SightFront then
                CurrentTool.Settings.SightFront.Transparency = 0;
            end;
        else
            u160:ResumeHoldPresentation(CurrentTool);
        end;

        u160:SetReadinessState(false, true, true, u166 == true and true or nil);
    end);
    u160.CurrentState = u160.CurrentTool.Aiming == true and "ADS" or "Hold";
    u160:PushRuntimeState(u160.CurrentState, {
        Inspecting = false,
        Reloading = false,
        Aiming = u160.CurrentTool.Aiming == true,
        Holstered = u160.Holster
    });

    if u160.CurrentTool.Bolting == true then
        u160:Bolt();
    elseif u160.CurrentTool.Pumping == true then
        u160:Pump();
    end;

    if u160.Crosshair then
        if v164.CrosshairSpread then
            u160.Crosshair:Enable();
            u160.Crosshair:FollowMouse(false);
            u160.Crosshair:Size(6, 2);
            local v178 = v164.CrosshairSpread * 10;

            if v178 < u160.Crosshair.Spreading.MinSpread then
                u160.Crosshair.Spreading.MinSpread = v178;
                u160.Crosshair:SmoothSet(v178, 0.06);
            else
                u160.Crosshair:SmoothSet(v178, 0.06);
                u160.Crosshair.Spreading.MinSpread = v178;
            end;
        elseif v163 == "Throwable" then
            u160.Crosshair:Enable();
            u160.Crosshair:FollowMouse(false);
            u160.Crosshair:Size(2, 16);
            u160.Crosshair.Spreading.MinSpread = 50;
            u160.Crosshair:Set(50);
        else
            u160.Crosshair:Size(3, 3);
            u160.Crosshair.Spreading.MinSpread = 0;
            u160.Crosshair:SmoothSet(0, 0.06);
        end;
    end;

    u160:SoundCue("Equip", true);

    return true;
end;

function v4.SetToolSurfaceGuiEnabled(p179, p180, p181, p182) -- Line: 1412
    if not p180 then
        return;
    end;

    local v183 = p182 == nil and true or p182;

    for _, descendant in ipairs(p180:GetDescendants()) do
        if descendant:IsA("SurfaceGui") then
            if v183 == true or (descendant.Parent and descendant.Parent.Name == "Reticle") ~= true then
                descendant.Enabled = p181;
            end;
        end;
    end;
end;

function v4.AttachToolModelToArm(p184, p185) -- Line: 1432
    -- upvalues: Weapon (copy)
    local v186 = p185:FindFirstChild("Handle") or p185:FindFirstChild("Base");

    if p184.CameraModel and v186 then
        p185.Parent = p184.CameraModel;
        local Motor = v186:FindFirstChild("Motor");

        if Motor == nil then
            Motor = Instance.new("Motor6D", v186);
            Motor.Name = "Motor";
        end;

        Motor.Part1 = v186;
        Motor.Part0 = p184.CameraModel.Tool;
        v186.Anchored = false;
        Motor.C1 = CFrame.new(0, 0, 0);
        local v187 = Weapon.GetWeaponExtra(p185);

        if v187 then
            Weapon.InitializeExtraAttachment(v187);
        end;

        p184:SetToolSurfaceGuiEnabled(p185, true, false);
        p184.AimPart = p185:FindFirstChild("Aim");
    end;
end;

function v4.DetachToolModelFromArm(p188, p189) -- Line: 1460
    -- upvalues: Utility (copy), Weapon (copy)
    local v190 = p189:FindFirstChild("Handle") or p189:FindFirstChild("Base");

    if p188.CameraModel and v190 then
        local Motor = v190:FindFirstChild("Motor");

        if Motor == nil then
            Motor = Instance.new("Motor6D", v190);
            Motor.Name = "Motor";
        end;

        Motor.Part1 = v190;

        if p188.CameraModel and p188.CameraModel:FindFirstChild("Base") then
            Motor.Part0 = p188.CameraModel.Base;
        else
            warn(Utility.formatWarnInstanceIsNil("self.CameraModel", "Base"));
        end;

        v190.Anchored = false;
        Motor.C1 = CFrame.new(0, 0, -10);
        p188:SetToolSurfaceGuiEnabled(p189, false);
        Weapon.SetExtraState(p189, false, false);
        p189.Parent = script.ReserveModels;
    end;
end;

function v4.MagazineActivation(p191) -- Line: 1488
    for _, v in pairs(p191.Tools) do
        local Magazine = v.Model:FindFirstChild("Magazine", true);

        if Magazine then
            Magazine.Name = "MagazineDisabled";
        end;
    end;

    local MagazineDisabled = p191.CurrentTool.Model:FindFirstChild("MagazineDisabled");

    if MagazineDisabled then
        MagazineDisabled.Name = "Magazine";
    end;
end;

function v4.StopOtherToolsAnimations(p192) -- Line: 1502
    for _, v in pairs(p192.Tools or {}) do
        for _, v3 in pairs(v.Animations or {}) do
            for _, v5 in pairs(v3) do
                if v5 and (typeof(v5) == "Instance" and v5:IsA("AnimationTrack")) then
                    v5:Stop();
                end;
            end;
        end;
    end;
end;

function v4.ToggleToolModelVisible(p193, p194, p195) -- Line: 1514
    p193:SetToolSurfaceGuiEnabled(p194, p195);

    if p195 == true then
        for _, child in pairs(p194:GetChildren()) do
            if child:IsA("BasePart") and (child.Name ~= "Base" and child.Name ~= "Handle") then
                child.Transparency = 0;
            end;
        end;

        return;
    end;

    for _, child in pairs(p194:GetChildren()) do
        if child:IsA("BasePart") and (child.Name ~= "Base" and child.Name ~= "Handle") then
            child.Transparency = 1;
        end;
    end;
end;

function v4.Vault(u196) -- Line: 1531
    u196:SoundCue("Vault", true);
    local CurrentTool = u196.CurrentTool;
    assert(CurrentTool, "Failed to Vault because no CurrentTool exists");
    local u197 = u196:GetClientWeaponSystemScript();
    local u198 = u196:GetStateFolder();

    local function pushVaultRuntimeState(p199, p200) -- Line: 1538
        -- upvalues: u196 (copy), CurrentTool (copy)
        u196:PushRuntimeState(p199, {
            Inspecting = false,
            Reloading = false,
            Aiming = CurrentTool.Aiming == true,
            Holstered = u196.Holster,
            VaultActive = p200
        });
    end;

    local function clearVaultRuntimeState() -- Line: 1548
        -- upvalues: u196 (copy)
        u196:PushRuntimeState(u196.CurrentState, {
            VaultActive = false
        });
    end;

    if u197 then
        u197:SetAttribute("ServerVaultOverride", true);
    end;

    u196:PushRuntimeState(CurrentTool.Aiming == true and "ADS" or "Hold", {
        Inspecting = false,
        Reloading = false,
        VaultActive = true,
        Aiming = CurrentTool.Aiming == true,
        Holstered = u196.Holster
    });

    if u196.Animations.Server.Run then
        u196.Animations.Server.Run:Stop(0.05);
    end;

    if CurrentTool.Aiming == false then
        u196.CurrentState = "Hold";
        u196:SendPresentationEvent("VaultStart", {
            CurrentState = "Hold",
            Aiming = false,
            Inspecting = false,
            Reloading = false,
            Holstered = u196.Holster
        });
        u196.Animations.Client.Vault:Play();
        u196.Animations.Client.Vault:AdjustSpeed(1);
    end;

    local Vault = u196.Animations.Server.Vault;
    Vault:Play();
    task.spawn(function() -- Line: 1578
        -- upvalues: Vault (copy), u197 (copy), u196 (copy), CurrentTool (copy), u198 (copy)
        Vault.Stopped:Wait();

        if u197 then
            u197:SetAttribute("ServerVaultOverride", false);
        end;

        u196:PushRuntimeState(u196.CurrentState, {
            VaultActive = false
        });

        if u196.CurrentTool ~= CurrentTool or u196.Animations.Server.Vault ~= Vault then
            return;
        end;

        task.defer(function() -- Line: 1588
            -- upvalues: u196 (ref), CurrentTool (ref), Vault (ref), u198 (ref)
            if u196.CurrentTool ~= CurrentTool or u196.Animations.Server.Vault ~= Vault then
                return;
            end;

            if (u198 and u198:GetAttribute("Movement") or nil) == "Running" then
                u196:StopServerHold();

                if u196.Animations.Server.Run and u196.Animations.Server.Run.IsPlaying ~= true then
                    u196.Animations.Server.Run:Play(0.05);
                end;
            else
                u196:PlayServerHold();
            end;
        end);
    end);
end;

function v4.PrepareEquipTransitionForHold(p201, p202, p203) -- Line: 1606
    if not (p202 and p202.Animations) then
        return;
    end;

    local v204 = p203 or 0.08;
    local Client = p202.Animations.Client;
    local Server = p202.Animations.Server;
    local v205;

    if Client then
        v205 = Client.Equip;
    else
        v205 = Client;
    end;

    local v206;

    if Server then
        v206 = Server.Equip;
    else
        v206 = Server;
    end;

    if Client then
        Client = Client.Hold;
    end;

    if Server then
        Server = Server.Hold;
    end;

    local v207;

    if v205 and v205.IsPlaying == true then
        v207 = true;
    elseif v206 then
        v207 = v206.IsPlaying == true;
    else
        v207 = v206;
    end;

    if v207 ~= true then
        return;
    end;

    if Client and Client.IsPlaying ~= true then
        Client:Play(v204);
    end;

    if Server and Server.IsPlaying ~= true then
        Server:Play(v204);
    end;

    if v205 and v205.IsPlaying == true then
        v205:Stop(v204);
    end;

    if v206 and v206.IsPlaying == true then
        v206:Stop(v204);
    end;
end;

function v4.PrepareEquipTransitionForADS(p208, p209) -- Line: 1637
    if not p209 or (p208.CurrentTool ~= p209 or not p209.Animations) then
        return;
    end;

    local Client = p209.Animations.Client;
    local Server = p209.Animations.Server;
    local v210;

    if Client then
        v210 = Client.Hold;
    else
        v210 = Client;
    end;

    local v211;

    if Server then
        v211 = Server.Hold;
    else
        v211 = Server;
    end;

    local v212 = p208.Animations and p208.Animations.Client;
    local v213 = p208.Animations and p208.Animations.Server;

    local function StopTrack(p214) -- Line: 1649
        if p214 and p214.IsPlaying == true then
            p214:Stop(0);
        end;
    end;

    local v215;

    if Client then
        v215 = Client.Equip;
    else
        v215 = Client;
    end;

    if v215 and v215.IsPlaying == true then
        v215:Stop(0);
    end;

    local v216;

    if Server then
        v216 = Server.Equip;
    else
        v216 = Server;
    end;

    if v216 and v216.IsPlaying == true then
        v216:Stop(0);
    end;

    local v217;

    if Client then
        v217 = Client.Inspect;
    else
        v217 = Client;
    end;

    if v217 and v217.IsPlaying == true then
        v217:Stop(0);
    end;

    local v218;

    if Server then
        v218 = Server.Inspect;
    else
        v218 = Server;
    end;

    if v218 and v218.IsPlaying == true then
        v218:Stop(0);
    end;

    local v219;

    if Client then
        v219 = Client.Action;
    else
        v219 = Client;
    end;

    if v219 and v219.IsPlaying == true then
        v219:Stop(0);
    end;

    local v220;

    if Server then
        v220 = Server.Action;
    else
        v220 = Server;
    end;

    if v220 and v220.IsPlaying == true then
        v220:Stop(0);
    end;

    local v221;

    if Client then
        v221 = Client.Reload;
    else
        v221 = Client;
    end;

    if v221 and v221.IsPlaying == true then
        v221:Stop(0);
    end;

    local v222;

    if Server then
        v222 = Server.Reload;
    else
        v222 = Server;
    end;

    if v222 and v222.IsPlaying == true then
        v222:Stop(0);
    end;

    if Client then
        Client = Client.Vault;
    end;

    if Client and Client.IsPlaying == true then
        Client:Stop(0);
    end;

    if Server then
        Server = Server.Vault;
    end;

    if Server and Server.IsPlaying == true then
        Server:Stop(0);
    end;

    if v212 then
        v212 = v212.Vault;
    end;

    if v212 and v212.IsPlaying == true then
        v212:Stop(0);
    end;

    if v213 then
        v213 = v213.Vault;
    end;

    if v213 and v213.IsPlaying == true then
        v213:Stop(0);
    end;

    if v210 then
        if v210 and v210.IsPlaying == true then
            v210:Stop(0);
        end;

        v210:Play(0);
    end;

    if v211 then
        if v211 and v211.IsPlaying == true then
            v211:Stop(0);
        end;

        v211:Play(0);
    end;
end;

function v4.ResumeHoldPresentation(p223, p224) -- Line: 1678
    if not p224 or (p223.CurrentTool ~= p224 or p223.CurrentState ~= "Hold") then
        return false;
    end;

    local Character = p223.Player.Character;

    if p224.Aiming == true or (p224.Reloading == true or (p224.Bolting == true or (p224.Pumping == true or (p223.Holster ~= true or Character and Character:GetAttribute("Barricading") == true)))) then
        return false;
    end;

    p223:PrepareEquipTransitionForHold(p224, 0.08);
    local v225 = p224.Animations and p224.Animations.Client;
    local v226 = p224.Animations and p224.Animations.Server;
    local v227;

    if v225 then
        v227 = v225.Hold;
    else
        v227 = v225;
    end;

    local v228;

    if v226 then
        v228 = v226.Hold;
    else
        v228 = v226;
    end;

    local v229;

    if v225 then
        v229 = v225.Inspect;
    else
        v229 = v225;
    end;

    local v230;

    if v226 then
        v230 = v226.Inspect;
    else
        v230 = v226;
    end;

    local v231;

    if v225 then
        v231 = v225.Action;
    else
        v231 = v225;
    end;

    local v232;

    if v226 then
        v232 = v226.Action;
    else
        v232 = v226;
    end;

    local v233;

    if v225 then
        v233 = v225.Reload;
    else
        v233 = v225;
    end;

    local v234;

    if v226 then
        v234 = v226.Reload;
    else
        v234 = v226;
    end;

    if v225 then
        v225 = v225.Vault;
    end;

    if v226 then
        v226 = v226.Vault;
    end;

    local function _(p235, p236) -- Line: 1708
        if p235 and p235.IsPlaying == true then
            p235:Stop(p236 or 0.08);
        end;
    end;

    if v229 and v229.IsPlaying == true then
        v229:Stop(0.05);
    end;

    if v230 and v230.IsPlaying == true then
        v230:Stop(0.05);
    end;

    if v231 and v231.IsPlaying == true then
        v231:Stop(0.05);
    end;

    if v232 and v232.IsPlaying == true then
        v232:Stop(0.05);
    end;

    if v233 and v233.IsPlaying == true then
        v233:Stop(0.05);
    end;

    if v234 and v234.IsPlaying == true then
        v234:Stop(0.05);
    end;

    if v225 and v225.IsPlaying == true then
        v225:Stop(0.05);
    end;

    if v226 and v226.IsPlaying == true then
        v226:Stop(0.05);
    end;

    if v227 then
        if v227 and v227.IsPlaying == true then
            v227:Stop(0.05);
        end;

        v227:Play(0.12);
    end;

    if v228 then
        if v228 and v228.IsPlaying == true then
            v228:Stop(0.05);
        end;

        v228:Play(0.12);
    end;

    return v227 ~= nil and true or v228 ~= nil;
end;

function v4.ADS(p237) -- Line: 1735
    local CurrentTool = p237.CurrentTool;
    assert(CurrentTool, "Failed to ADS because no CurrentTool exists");
    p237:PrepareEquipTransitionForADS(CurrentTool);
    p237.CurrentState = "ADS";
    CurrentTool.Aiming = true;
    p237:PushRuntimeState("ADS", {
        Aiming = true,
        Inspecting = false,
        Reloading = false,
        Holstered = p237.Holster
    });
    p237:SoundCue("ADS", true);

    if p237.Crosshair then
        p237.Crosshair:Disable();
    end;

    if CurrentTool.Settings.SightFront then
        CurrentTool.Settings.SightFront.Transparency = 0;
    end;
end;

function v4.ReleaseADS(p238) -- Line: 1757
    local CurrentTool = p238.CurrentTool;
    assert(CurrentTool, "Failed to ReleaseADS because no CurrentTool exists");
    p238.CurrentState = "Hold";
    CurrentTool.Aiming = false;
    p238:ResumeHoldPresentation(CurrentTool);
    p238:PushRuntimeState("Hold", {
        Aiming = false,
        Inspecting = false,
        Reloading = CurrentTool.Reloading == true,
        Holstered = p238.Holster
    });
    p238:SoundCue("ADSRelease", true);

    if p238.Crosshair then
        p238.Crosshair:Enable();
    end;

    if CurrentTool.Settings.SightFront then
        CurrentTool.Settings.SightFront.Transparency = 0;
    end;
end;

function v4.Inspect(u239) -- Line: 1779
    local CurrentTool = u239.CurrentTool;

    if not CurrentTool then
        return;
    end;

    u239.CurrentState = "Inspect";
    u239:PushRuntimeState("Inspect", {
        Aiming = false,
        Inspecting = true,
        Reloading = false,
        Holstered = u239.Holster
    });
    u239:SendPresentationEvent("InspectStart", {
        CurrentState = "Inspect",
        Aiming = false,
        Inspecting = true,
        Reloading = false,
        Holstered = u239.Holster
    });
    CurrentTool.Animations.Client.Inspect:Play();

    if CurrentTool.Animations.Client.Reload then
        CurrentTool.ReloadCancel = true;
        CurrentTool.Animations.Client.Reload:Stop();
        CurrentTool.Animations.Server.Reload:Stop();
    end;

    task.spawn(function() -- Line: 1808
        -- upvalues: CurrentTool (copy), u239 (copy)
        CurrentTool.Animations.Client.Inspect.Stopped:Wait();

        if u239.CurrentTool == CurrentTool and u239.CurrentState == "Inspect" then
            u239.CurrentState = "Hold";
            u239:ResumeHoldPresentation(CurrentTool);
            u239:PushRuntimeState("Hold", {
                Inspecting = false,
                Aiming = CurrentTool.Aiming == true,
                Reloading = CurrentTool.Reloading == true,
                Holstered = u239.Holster
            });
        end;
    end);
end;

function v4.CancelInspect(p240) -- Line: 1823
    local CurrentTool = p240.CurrentTool;

    if not CurrentTool then
        return false;
    end;

    local v241 = CurrentTool.Animations and CurrentTool.Animations.Client;
    local v242 = CurrentTool.Animations and CurrentTool.Animations.Server;

    if v241 then
        v241 = v241.Inspect;
    end;

    if v242 then
        v242 = v242.Inspect;
    end;

    local v243;

    if p240.CurrentState == "Inspect" or v241 and v241.IsPlaying == true then
        v243 = true;
    elseif v242 then
        v243 = v242.IsPlaying == true;
    else
        v243 = v242;
    end;

    if v243 ~= true then
        return false;
    end;

    if v242 and v242.IsPlaying == true then
        v242:Stop(0.05);
    end;

    if v241 and v241.IsPlaying == true then
        v241:Stop(0.05);
    end;

    p240.CurrentState = "Hold";
    p240:ResumeHoldPresentation(CurrentTool);
    p240:PushRuntimeState("Hold", {
        Inspecting = false,
        Aiming = CurrentTool.Aiming == true,
        Reloading = CurrentTool.Reloading == true,
        Holstered = p240.Holster
    });

    return true;
end;

function v4.Bolt(p244) -- Line: 1859
    local CurrentTool = p244.CurrentTool;
    assert(CurrentTool, "Failed to Bolt because no CurrentTool exists");
    CurrentTool.Bolting = true;
    p244.CurrentState = "Action";
    p244:PushRuntimeState("Action", {
        Inspecting = false,
        Reloading = false,
        Aiming = CurrentTool.Aiming == true,
        Holstered = p244.Holster
    });
    p244:SendPresentationEvent("BoltStart", {
        CurrentState = "Action",
        Inspecting = false,
        Reloading = false,
        Aiming = CurrentTool.Aiming == true,
        Holstered = p244.Holster
    });

    if CurrentTool.Animations.Client.Bolt and CurrentTool.Animations.Server.Bolt then
        CurrentTool.Animations.Client.Bolt:Play();
        CurrentTool.Animations.Server.Bolt:Play();
    end;

    if CurrentTool.Animations.Client.Bolt then
        CurrentTool.Animations.Client.Bolt.Stopped:Wait();
    end;

    if CurrentTool == CurrentTool then
        CurrentTool.Bolting = false;
        p244.CurrentState = CurrentTool.Aiming == true and "ADS" or "Hold";

        if p244.CurrentState == "Hold" then
            p244:ResumeHoldPresentation(CurrentTool);
        end;

        p244:PushRuntimeState(p244.CurrentState, {
            Inspecting = false,
            Aiming = CurrentTool.Aiming == true,
            Reloading = CurrentTool.Reloading == true,
            Holstered = p244.Holster
        });
    end;
end;

function v4.Pump(p245) -- Line: 1905
    local CurrentTool = p245.CurrentTool;
    assert(CurrentTool, "Failed to Pump-1 because no CurrentTool exists");
    CurrentTool.Pumping = true;
    local CurrentTool2 = p245.CurrentTool;
    p245.CurrentState = "Action";
    p245:PushRuntimeState("Action", {
        Inspecting = false,
        Reloading = false,
        Aiming = CurrentTool.Aiming == true,
        Holstered = p245.Holster
    });
    p245:SendPresentationEvent("PumpStart", {
        CurrentState = "Action",
        Inspecting = false,
        Reloading = false,
        Aiming = CurrentTool.Aiming == true,
        Holstered = p245.Holster
    });

    if CurrentTool.Animations.Client.Pump and CurrentTool.Animations.Server.Pump then
        CurrentTool.Animations.Client.Pump:Play();
        CurrentTool.Animations.Server.Pump:Play();
    end;

    if CurrentTool.Animations.Client.Pump then
        CurrentTool.Animations.Client.Pump.Stopped:Wait();
    end;

    if CurrentTool == CurrentTool2 then
        CurrentTool.Pumping = false;
        p245.CurrentState = CurrentTool.Aiming == true and "ADS" or "Hold";

        if p245.CurrentState == "Hold" then
            p245:ResumeHoldPresentation(CurrentTool);
        end;

        p245:PushRuntimeState(p245.CurrentState, {
            Inspecting = false,
            Aiming = CurrentTool.Aiming == true,
            Reloading = CurrentTool.Reloading == true,
            Holstered = p245.Holster
        });
    end;
end;

function v4.HolsterWeapon(p246, p247) -- Line: 1950
    local CurrentTool = p246.CurrentTool;
    assert(CurrentTool, "Failed to HolsterWeapon because no CurrentTool exists");

    if p247 == false then
        p246.Holster = false;
        p246:DetachToolModelFromArm(CurrentTool.Model);
    elseif p247 == true then
        p246.Holster = true;
        p246:AttachToolModelToArm(CurrentTool.Model);
    end;

    p246:RefreshWeaponExtras();
    p246:PushRuntimeState(p246.CurrentState, {
        Holstered = p246.Holster,
        Aiming = CurrentTool.Aiming == true,
        Inspecting = p246.CurrentState == "Inspect",
        Reloading = CurrentTool.Reloading == true
    });
end;

function v4.EnterBarricadePresentation(p248) -- Line: 1971
    local CurrentTool = p248.CurrentTool;
    assert(CurrentTool, "Failed to EnterBarricadePresentation because no CurrentTool exists");

    if CurrentTool.Aiming == true then
        p248:ReleaseADS();
    end;

    if CurrentTool.Reloading == true then
        CurrentTool.ReloadCancel = true;
    end;

    p248:StopCurrentToolAnimation(false);

    if p248.Animations.Client.Run and p248.Animations.Client.Run.IsPlaying == true then
        p248.Animations.Client.Run:Stop();
    end;

    if p248.Animations.Server.Run and p248.Animations.Server.Run.IsPlaying == true then
        p248.Animations.Server.Run:Stop();
    end;

    p248.CurrentState = "Hold";
    p248:PushRuntimeState("Hold", {
        Aiming = false,
        Inspecting = false,
        Reloading = CurrentTool.Reloading == true,
        Holstered = p248.Holster
    });
end;

function v4.ExitBarricadePresentation(p249) -- Line: 2001
    local CurrentTool = p249.CurrentTool;

    if not CurrentTool then
        return;
    end;

    if CurrentTool.Aiming == true or (CurrentTool.Reloading == true or (CurrentTool.Bolting == true or (CurrentTool.Pumping == true or p249.ActionDebounce == true))) then
        p249:PushRuntimeState(p249.CurrentState, {
            Aiming = CurrentTool.Aiming == true,
            Inspecting = p249.CurrentState == "Inspect",
            Reloading = CurrentTool.Reloading == true,
            Holstered = p249.Holster
        });

        return;
    end;

    p249.CurrentState = "Hold";
    p249:ResumeHoldPresentation(CurrentTool);
    p249:PushRuntimeState("Hold", {
        Aiming = false,
        Inspecting = false,
        Reloading = false,
        Holstered = p249.Holster
    });
end;

function v4.Shoot(p250) -- Line: 2027
    -- upvalues: Config (copy)
    if p250.CurrentTool and p250.CurrentTool.Animations.Client.Shoot then
        p250.CurrentTool.Animations.Client.Shoot:Play();
    end;

    if Config.Crosshair == true and (p250.Crosshair and (p250.CurrentTool and p250.CurrentTool.CrosshairSpread)) then
        p250.Crosshair:SmoothSet(p250.CurrentTool.CrosshairSpread * 10 + 20, 0.05);
    end;
end;

function v4.Reload(p251) -- Line: 2038
    local CurrentTool = p251.CurrentTool;
    assert(CurrentTool, "Failed to Reload-0 because no CurrentTool exists");
    p251.CurrentState = "Reload";
    CurrentTool.Animations.Client.Inspect:Stop();
    CurrentTool.ReloadCancel = false;
    CurrentTool.Reloading = true;
    p251:PushRuntimeState("Reload", {
        Aiming = false,
        Inspecting = false,
        Reloading = true,
        Holstered = p251.Holster
    });
    p251:SendPresentationEvent("ReloadStart", {
        CurrentState = "Reload",
        Aiming = false,
        Inspecting = false,
        Reloading = true,
        Holstered = p251.Holster
    });
    CurrentTool.Animations.Client.Reload:Play();

    if CurrentTool.Animations.Server.Hold and CurrentTool.Animations.Server.Hold.IsPlaying == true then
        CurrentTool.Animations.Server.Hold:Stop();
    end;

    CurrentTool.Animations.Server.Reload:Play();
    CurrentTool.Animations.Client.Reload.Stopped:Wait();
    CurrentTool.Animations.Server.Reload:Stop();
    CurrentTool.Reloading = false;
    local v252;

    if p251.CurrentTool == CurrentTool then
        v252 = CurrentTool.ReloadCancel == false;
    else
        v252 = false;
    end;

    if v252 == true then
        p251.CurrentState = "Hold";
        p251:ResumeHoldPresentation(CurrentTool);
    end;

    p251:PushRuntimeState(p251.CurrentState, {
        Inspecting = false,
        Reloading = false,
        Aiming = CurrentTool.Aiming == true,
        Holstered = p251.Holster
    });
end;

function v4.Action(u253, p254) -- Line: 2086
    local CurrentTool = u253.CurrentTool;
    assert(CurrentTool, "Failed to Action-2 because no CurrentTool exists");

    if CurrentTool.Animations.Client.Action then
        u253.CurrentState = "Action";
        u253:PushRuntimeState("Action", {
            Inspecting = false,
            Reloading = false,
            Aiming = CurrentTool.Aiming == true,
            Holstered = u253.Holster
        });
        u253:SendPresentationEvent("ActionStart", {
            CurrentState = "Action",
            Inspecting = false,
            Reloading = false,
            Aiming = CurrentTool.Aiming == true,
            Holstered = u253.Holster,
            ActionClass = p254
        });

        if p254 == "Knife" then
            u253:StopCurrentToolAnimation(true);
            CurrentTool.Animations.Client.Action:Play();
            CurrentTool.Animations.Server.Action:Play();

            if CurrentTool.Model.Handle:FindFirstChild("Action") then
                CurrentTool.Model.Handle:FindFirstChild("Action"):Play();
                u253:ServerSoundCue("Action", true, CurrentTool.Model.Name);
            end;

            task.spawn(function() -- Line: 2120
                -- upvalues: CurrentTool (copy), u253 (copy)
                CurrentTool.Animations.Client.Action.Stopped:Wait();

                if u253.CurrentTool == CurrentTool and u253.CurrentState == "Action" then
                    u253.CurrentState = CurrentTool.Aiming == true and "ADS" or "Hold";

                    if u253.CurrentState == "Hold" then
                        u253:ResumeHoldPresentation(CurrentTool);
                    end;

                    u253:PushRuntimeState(u253.CurrentState, {
                        Inspecting = false,
                        Aiming = CurrentTool.Aiming == true,
                        Reloading = CurrentTool.Reloading == true,
                        Holstered = u253.Holster
                    });
                end;
            end);

            return;
        end;

        if p254 == "Throwable" and u253.ActionDebounce == false then
            u253.ActionDebounce = true;
            local CurrentTool2 = u253.CurrentTool;
            assert(CurrentTool2, "Failed to Action because no CurrentTool exists");
            u253:ToggleToolModelVisible(CurrentTool2.Model, true);
            u253:StopCurrentToolAnimation(true);
            CurrentTool2.Animations.Client.Action:Play();
            CurrentTool2.Animations.Server.Action:Play();

            if CurrentTool2.Model.Handle:FindFirstChild("Action") then
                CurrentTool2.Model.Handle:FindFirstChild("Action"):Play();
                u253:ServerSoundCue("Action", true, CurrentTool2.Model.Name);
            end;

            CurrentTool2.Animations.Client.Action.Stopped:Wait();
            local v255 = tonumber(CurrentTool2.Tool:GetAttribute("Amount")) or 0;
            u253:ToggleToolModelVisible(CurrentTool2.Model, v255 > 0);
            u253.ActionDebounce = false;

            if u253.CurrentTool == CurrentTool2 and u253.CurrentState == "Action" then
                u253.CurrentState = CurrentTool2.Aiming == true and "ADS" or "Hold";

                if u253.CurrentState == "Hold" then
                    u253:ResumeHoldPresentation(CurrentTool2);
                end;

                u253:PushRuntimeState(u253.CurrentState, {
                    Inspecting = false,
                    Aiming = CurrentTool2.Aiming == true,
                    Reloading = CurrentTool2.Reloading == true,
                    Holstered = u253.Holster
                });
            end;
        end;
    end;
end;

function v4.StopServerHold(p256) -- Line: 2180
    local CurrentTool = p256.CurrentTool;

    if not (CurrentTool and (CurrentTool.Animations and CurrentTool.Animations.Server)) then
        return;
    end;

    local Hold = CurrentTool.Animations.Server.Hold;

    if Hold and Hold.IsPlaying then
        Hold:Stop(0.12);
    end;
end;

function v4.PlayServerHold(p257) -- Line: 2192
    local CurrentTool = p257.CurrentTool;

    if not (CurrentTool and (CurrentTool.Animations and CurrentTool.Animations.Server)) then
        return;
    end;

    local Hold = CurrentTool.Animations.Server.Hold;

    if Hold and Hold.IsPlaying ~= true then
        Hold:Play(0.12);
    end;
end;

function v4.StopCurrentToolAnimation(p258, p259) -- Line: 2204
    local CurrentTool = p258.CurrentTool;
    assert(CurrentTool, "Failed to StopCurrentToolAnimation because no CurrentTool exists");

    for i, v in pairs(CurrentTool.Animations.Client) do
        if p259 == true and i ~= "Hold" or p259 ~= true then
            v:Stop();
        end;
    end;

    for i, v in pairs(CurrentTool.Animations.Server) do
        if p259 == true and i ~= "Hold" or p259 ~= true then
            v:Stop();
        end;
    end;

    for i, v in pairs(p258.Animations.Client) do
        if i ~= "Run" then
            v:Stop();
        end;
    end;
end;

function v4.GetADSZoom(p260, p261) -- Line: 2231
    -- upvalues: CollectionService (copy)
    local v262 = 1;
    local v263 = nil;

    for _, child in pairs(p261:GetChildren()) do
        if CollectionService:HasTag(child, "Sight") then
            v262 = child:GetAttribute("Zoom");
            v263 = child:FindFirstChild("Front");
        end;
    end;

    return v262, v263;
end;

function v4.SetFP(p264, p265) -- Line: 2244
    -- upvalues: UserInputService (copy)
    local ServerData = p265:FindFirstChild("ServerData");
    assert(ServerData, "Failed to SetFP because no ServerData folder exists");
    local Character = p265.Character;
    assert(Character, "Failed to SetFP because no character exists");

    if ServerData:GetAttribute("Alive") == true and (UserInputService.MouseIconEnabled ~= false or (p264.Camera.CameraType ~= Enum.CameraType.Custom or (p264.Camera.CameraSubject ~= Character.Humanoid or (p265.CameraMinZoomDistance ~= 0.5 or p265.CameraMaxZoomDistance ~= 0.5)))) then
        UserInputService.MouseIconEnabled = false;
        p264.Camera.CameraType = Enum.CameraType.Custom;
        p264.Camera.CameraSubject = Character.Humanoid;
        p265.CameraMinZoomDistance = 0.5;
        p265.CameraMaxZoomDistance = 0.5;
    end;
end;

function v4.WeaponRuntime(p266, p267) -- Line: 2271
    p266.CameraModel.Base.CFrame = p266.Camera.CFrame * CFrame.new(0, 0, -0.5);
end;

return v2;