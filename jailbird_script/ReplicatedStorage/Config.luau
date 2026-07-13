
local MarketplaceService = game:GetService("MarketplaceService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local Chat = game:GetService("Chat");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local BattlePass = require(ReplicatedStorage:WaitForChild("Components"):WaitForChild("BattlePass"));
local u1 = `[{script.Name}]`;
local PlaceId = game.PlaceId;

local function getComponentInitAttributeName(p2) -- Line: 17
    return "__ComponentInit_" .. string.gsub(p2, "[^%w_]", "_");
end;

local u3 = {
    LobbyID = 14772802900,
    InGameID = 14939963714,
    Season = BattlePass.Season,
    SeasonActive = true,
    SeasonEndDate = 1019,
    SeasonFeaturedItem = "Combat",
    SeasonFont = Enum.Font.Oswald,
    SeasonColorTheme = Color3.fromRGB(255, 128, 0),
    SeasonImage = "rbxassetid://131745180336846",
    SeasonFeaturedKnife = "Geometric",
    BattlepassRewards = BattlePass.GetBattlePassIndex(),
    Vaulting = true,
    HitMarker = true,
    Crosshair = true,
    JumpCooldown = 0.8,
    JumpPower = 25,
    ProneCooldown = 0.5,
    RunWalkSpeed = 13.5,
    NormalWalkSpeed = 10,
    SlowPaceWalkSpeed = 6,
    CrouchWalkSpeed = 5,
    ProneWalksSpeed = 2.5,
    DefaultEffectiveRange = 250,
    HeadDamage = 200,
    VaultPromptDistance = 4,
    DefaultVaultDistance = 4.5,
    KnifeDistance = 5,
    KnifeCooldown = 0.8,
    LeanAngle = 10,
    BulletHoleDespawnTime = 10,
    BulletHoleTreshold = 200,
    BulletHolePerShooterCap = 16,
    ImpactEffectPerShooterCap = 12,
    ImpactSoundPoolSize = 4,
    ImpactSoundStandbyPoolSize = 4,
    ImpactSoundPreloadEnabled = true,
    ImpactSoundVolumeMultiplier = 1,
    ImpactSoundPlaybackSpeedMin = 0.95,
    ImpactSoundPlaybackSpeedMax = 1.05,
    MaxSimultaneousImpactVoices = 2,
    WeaponSoundPoolSize = 6,
    MaxSimultaneousGunfireVoices = 3,
    LocalGunfireMaxVoices = 4,
    RemoteGunfireMaxVoices = 3,
    GunClickMaxVoices = 1,
    GunfireVoiceSteal = true,
    RaycastRetryLimit = 12,
    ThreeDimensionDespawnTime = 3,
    ThreeDimensionTreshold = 200,
    BloodCooldown = 0.5,
    EffectCooldown = 3,
    DamageFeedbackMode = "FakeBlood",
    FakeBloodHighlightColor = Color3.fromRGB(255, 60, 60),
    FakeBloodHighlightFlashTime = 0.12,
    FakeBloodHighlightFadeTime = 0.24,
    FakeBloodHighlightStartTransparency = 0.5,
    FakeBloodHighlightOutlineStartTransparency = 0.5,
    FakeBloodHighlightOutlineEndTransparency = 1,
    FakeBloodHighlightPoolSize = 12,
    RagdollGravityScale = 0.6,
    RagdollCorpseLifetime = 5,
    RagdollFadeDuration = 0.75,
    AllowWeaponKnockback = true,
    AllowExplosionKnockback = true,
    RagdollHeadKnockback = 30,
    RagdollTorsoKnockback = 30,
    RagdollExplosionKnockback = 90,
    RagdollExplosionKnockbackY = 30,
    RagdollOwnershipMode = "KillerLifetime",
    RagdollSettleLinearThreshold = 1.5,
    RagdollSettleAngularThreshold = 3,
    RagdollSettleTime = 0.5,
    MaxPartySize = 5,
    RankedLevelRequirement = 15,
    RankedAbandonPenalty = 20,
    StarterRankedRatingBase = 65,
    StarterRankedMaxMatches = 10,
    RankedRatingBase = 40,
    RankedMaxRating = 100000,
    RankedPlayers = 10,
    MininmumPlayersForServerHost = 1,
    TeamColors = {
        Blue = Color3.fromRGB(55, 130, 185),
        Red = Color3.fromRGB(160, 65, 65)
    },
    BrightTeamColors = {
        Blue = Color3.fromRGB(85, 175, 235),
        Red = Color3.fromRGB(255, 135, 135)
    },
    VoteKickTimer = 20,
    FriendlyFire = false,
    GangTagCharacterLimit = 5,
    GangTagCooldown = 20,
    GangPrice = 700,
    MinimumQueueAmount = 2,
    QueueCooldown = 2,
    Matchmaking = {
        AdmissionLeaseSeconds = 60,
        RequeuePrioritySeconds = 20,
        TeleportDispatchRetryBaseSeconds = 3,
        TeleportDispatchRetryMaxSeconds = 20,
        TeleportDispatchSuccessTtlSeconds = 15,
        HostLoopIntervalSeconds = 10,
        ObserverLoopIntervalSeconds = 10,
        LobbyHostCheckIntervalSeconds = 5,
        LobbyQueueHeartbeatIntervalSeconds = 5,
        LobbyMatchmakingIntervalSeconds = 5,
        VisibleServerDirectHydrateIntervalSeconds = 10,
        CasualDirectHydrateIntervalSeconds = 10,
        ServerStatePublishInterval = 10,
        HostHeartbeatStaleSeconds = 12,
        ReleaseVersion = 14,
        QueuedWithoutHostThreshold = 1,
        CasualBrowserFreshnessSeconds = 12,
        QueueScanSizePerShard = 60,
        ServerScanWindow = 40,
        CasualFillAttemptsPerPartyPerCycle = 3,
        RankedCandidatePartyLimit = 50,
        QueueTeleportLeaseSeconds = 20,
        SafeTeleportPayloadBytes = 900,
        CasualJoinableTargetCount = 30,
        CasualRawServerScanCapPerRegion = 60,
        CasualImmediateGlobalScoringEnabled = true,
        TeleportPublishWindowSeconds = 10,
        MaxTeleportPublishesPerWindow = 60,
        ServerWarningPublishWindowSeconds = 10,
        MaxServerWarningPublishesPerWindow = 10,
        EnableServerUpdateTopic = false,
        Casual = {
            Cat1Max = 1,
            Cat2Max = 1.5,
            InitialRegionCount = 1,
            RegionFallbackSeconds = 10,
            RegionExpansionStepSeconds = 10,
            Regions = { "NA", "EU", "Asia", "Oceania", "SouthAmerica" },
            RegionFallbackOrder = {
                NA = { "SouthAmerica", "EU", "Asia", "Oceania" },
                EU = { "NA", "Asia", "SouthAmerica", "Oceania" },
                Asia = { "Oceania", "EU", "NA", "SouthAmerica" },
                Oceania = { "Asia", "NA", "EU", "SouthAmerica" },
                SouthAmerica = { "NA", "EU", "Asia", "Oceania" }
            },
            CountryRegionOverrides = {}
        },
        Ranked = {
            TeamKDRGapDefault = 1.5,
            TeamKDRGapFallback = 2,
            TeamKDRGapFallbackSeconds = 60
        }
    },
    DailyAdvertisementClaimMax = 2,
    LeaderboardList = { "Level", "Kills", "RankedRating", "SupportValue", "GameTime" },
    WeeklyLeaderboardList = { "WeeklyKills", "WeeklySupportValue", "WeeklyGameTime" },
    NumberSuffixes = { "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg", "Uvg", "Dvg", "Tvg" },
    BirthTime = 1696248000,
    LatestAnnouncement = 0,
    LatestAnnouncementTitle = "",
    LatestAnnouncementMessage = "",
    LatestAnnouncementPicture = "",
    BodyColors = {
        Brown = Color3.fromRGB(124, 92, 70),
        ["Light Orange"] = Color3.fromRGB(234, 184, 146),
        ["Pastel Brown"] = Color3.fromRGB(255, 204, 153),
        ["Medium Orange"] = Color3.fromRGB(222, 161, 111),
        ["Reddish Brown"] = Color3.fromRGB(105, 64, 40),
        ["Fawn Brown"] = Color3.fromRGB(147, 123, 82),
        ["Warm Yellowish Orange"] = Color3.fromRGB(255, 189, 134),
        Burlap = Color3.fromRGB(189, 177, 133),
        ["Medium Brown"] = Color3.fromRGB(80, 59, 44)
    },
    PremiumBodyColors = {
        ["Black Metallic"] = Color3.fromRGB(12, 35, 72),
        Cocoa = Color3.fromRGB(86, 36, 36),
        ["Flame Reddish Orange"] = Color3.fromRGB(210, 115, 35),
        ["Tr. Brown"] = Color3.fromRGB(189, 181, 142),
        ["Lemon Metalic"] = Color3.fromRGB(130, 124, 91)
    },
    RewardPoints = {
        Headshot = 50,
        Kill = 100,
        Capture = 150,
        Barricade = 10,
        Throwable = 10,
        Deployable = 10
    },
    RewardCash = {
        Headshot = 5,
        Kill = 10,
        EndMatch = 50
    },
    RewardExperience = {
        Headshot = 10,
        Kill = 30,
        EndMatch = 400
    },
    RewardEvent = {
        Headshot = 2,
        Kill = 5,
        EndMatch = 50
    },
    BattlepassExperienceToHit = 3500,
    BattlepassExperienceEndMatchReward = 1000,
    RecoilMultiplier = 0.7,
    FireRateMultiplier = 0.9,
    PingLocationCooldown = 2.5,
    PingLocationMax = 3,
    BulletDistance = 500,
    HeadRotationDecimal = 0.01,
    PlayerDataStore = "PlayerData_01",
    GangDataStore = "GangData_01",
    LeaderboardStore = "Leaderboard_01",
    WeeklyLeaderboardStore = "WeeklyLeaderboard_01",
    ModStore = "ModStore_01",
    ReportStore = "ReportStore_01",
    ServerHostStore = "ServerHost_01",
    ServerUpdateTopic = "ServerUpdate_03",
    ServerTeleportTopic = "ServerTeleport_03",
    RankedTeleportTopic = "RankedTeleport_03",
    ServerMessageTopic = "ServerMessage_03",
    DailyRewardGameTimeGoal = 14400,
    DailyRewardItem = "Regular Crate",
    WeeklyLeaderboardRewards = { {
            Name = "Credit",
            Type = "Credit",
            Amount = 500
        }, {
            Name = "Credit",
            Type = "Credit",
            Amount = 300
        }, {
            Name = "Credit",
            Type = "Credit",
            Amount = 150
        } },
    MaxFieldOfView = 90,
    MinFieldOfView = 70,
    MaxBrightness = 10,
    MinBrightness = -10,
    RoleSettings = {
        Founder = {
            TagText = "Owner",
            TagColor = Color3.fromRGB(255, 105, 150)
        },
        ["Head Admin"] = {
            TagText = "Head Admin",
            TagColor = Color3.fromRGB(255, 130, 45)
        },
        Admin = {
            TagText = "Admin",
            TagColor = Color3.fromRGB(220, 162, 69)
        },
        Moderator = {
            TagText = "Moderator",
            TagColor = Color3.fromRGB(90, 205, 163)
        },
        ["Content Creator"] = {
            TagText = "Content Creator",
            TagColor = Color3.fromRGB(66, 149, 205)
        },
        ["Server Booster"] = {
            TagText = "Nitro",
            TagColor = Color3.fromRGB(143, 105, 255)
        },
        ["Game Tester"] = {
            TagText = "Tester",
            TagColor = Color3.fromRGB(160, 220, 40)
        }
    },
    CustomGrenade = false,
    CustomWalkspeed = false,
    CustomJump = false,
    Tips = {
        [1] = "Snipers can break 3 planks with one shot.",
        [2] = "Each Plank has 3 health. A bullet has 1 - 3 damage depending on the weapon.",
        [3] = "Smart Barricades. Barricade doorways strategically to control access and slow down the attackers.",
        [5] = "Prioritize defending the objective or coordinate with teammates to make sure objective is protected at all times.",
        [6] = "Monitor your ammo. It\'s important to decide whether to reload when necessary. Timing is key.",
        [7] = "Map Mastery. Learn the map layout and callouts. You can access them in Jailbird Official discord server.",
        [8] = "Stay alert. Be vigilant and watch for flanks. Situational awareness should never be neglected.",
        [9] = "Optimize loadout to suit your playstyle. Aggressive playstyle require weapons with high plank damage.",
        [10] = "Stealth play can be highly intimidating. Use cover and sneak strategies to eliminate your opponents.",
        [11] = "Ping feature can be used 3 times instantly with no cooldown. Use them wisely.",
        [12] = "A frag grenade can destroy up to 3 nearby planks.",
        [13] = "Minimal noise is essential when committing a sneak attack. Crouch for softer steps.",
        [14] = "Cover Utilization. Master the use of cover. It\'s crucial for survival.",
        [15] = "Custom gamemode allows you to Master map layouts and practice your aim in training ground.",
        [16] = "Gang Alliances. Form or join a gang and conquer Jailbird.",
        [17] = "Our store refreshes daily. Do check on them so you don\'t miss any stocks.",
        [18] = "Frag Grenade deals full damage within core range and partial damage within proximity."
    },
    EndGameRewardsAmount = 3,
    EndGameRewards = { {
            Name = "Cash",
            Type = "Cash",
            Amount = 100,
            Rarity = "Common",
            Chance = 900
        }, {
            Name = "Rookie",
            Type = "Crate",
            Amount = 1,
            Rarity = "Common",
            Chance = 700
        }, {
            Name = "Cash",
            Type = "Cash",
            Amount = 250,
            Rarity = "Uncommon",
            Chance = 400
        }, {
            Name = "Regular",
            Type = "Crate",
            Amount = 1,
            Rarity = "Rare",
            Chance = 200
        }, {
            Name = "Credit",
            Type = "Credit",
            Amount = 20,
            Rarity = "Rare",
            Chance = 100
        }, {
            Name = "Group",
            Type = "Crate",
            Amount = 1,
            Rarity = "Rare",
            Chance = 200
        } },
    Rarity = {
        Common = {
            Percentage = 200,
            Credit = 200,
            Cash = 1500,
            CrateToken = 1,
            Color = Color3.fromRGB(135, 145, 125),
            Sound = script:WaitForChild("Audio"):WaitForChild("RewardSoundlist"):WaitForChild("RewardLevel1")
        },
        Uncommon = {
            Percentage = 120,
            Credit = 290,
            Cash = 3000,
            CrateToken = 2,
            Color = Color3.fromRGB(90, 145, 200),
            Sound = script:WaitForChild("Audio"):WaitForChild("RewardSoundlist"):WaitForChild("RewardLevel1")
        },
        Rare = {
            Percentage = 50,
            Credit = 640,
            Cash = 7500,
            CrateToken = 4,
            Color = Color3.fromRGB(190, 85, 85),
            Sound = script:WaitForChild("Audio"):WaitForChild("RewardSoundlist"):WaitForChild("RewardLevel2")
        },
        Epic = {
            Percentage = 10,
            Credit = 2800,
            Cash = 25000,
            CrateToken = 7,
            Color = Color3.fromRGB(165, 75, 255),
            Sound = script:WaitForChild("Audio"):WaitForChild("RewardSoundlist"):WaitForChild("RewardLevel2")
        },
        Legendary = {
            Percentage = 4,
            Credit = 6000,
            Cash = 80000,
            CrateToken = 15,
            Color = Color3.fromRGB(255, 150, 0),
            Sound = script:WaitForChild("Audio"):WaitForChild("RewardSoundlist"):WaitForChild("RewardLevel3")
        },
        Divine = {
            Percentage = 1,
            Credit = 20000,
            Cash = 250000,
            CrateToken = 40,
            Color = Color3.fromRGB(255, 40, 115),
            Sound = script:WaitForChild("Audio"):WaitForChild("RewardSoundlist"):WaitForChild("RewardLevel3")
        },
        Limited = {
            Percentage = 20,
            Credit = 0,
            Cash = 0,
            CrateToken = 5,
            Color = Color3.fromRGB(45, 205, 155)
        },
        Grand = {
            Percentage = 0,
            Credit = 0,
            Cash = 0,
            Color = Color3.fromRGB(255, 210, 0)
        },
        Battlepass = {
            Percentage = 0,
            Credit = 0,
            Cash = 0,
            Color = Color3.fromRGB(0, 200, 255)
        },
        Contraband = {
            Percentage = 0,
            Credit = 0,
            Cash = 0,
            Color = Color3.fromRGB(255, 0, 50)
        }
    },
    ColorCodes = {
        Regular = Color3.fromRGB(30, 30, 30),
        Warn = Color3.fromRGB(205, 120, 70),
        Personal = Color3.fromRGB(55, 145, 45),
        PersonalWarn = Color3.fromRGB(205, 120, 70),
        Announcement = Color3.fromRGB(185, 150, 55),
        Ban = Color3.fromRGB(170, 65, 65),
        SelectedColor = Color3.fromRGB(80, 190, 210),
        SelectedTextColor = Color3.fromRGB(255, 255, 255),
        DeselectedColor = Color3.fromRGB(240, 240, 240),
        DeselectedTextColor = Color3.fromRGB(20, 20, 20)
    },
    PriceMultiplier = {
        Top = 0.6,
        Bottom = 0.6,
        Head = 1,
        Skin = 0.5,
        Title = 0.4,
        Banner = 0.4,
        Charm = 1,
        Knife = 1
    },
    CurrencyImage = {
        Cash = "rbxassetid://14831951512",
        Credit = "rbxassetid://14832021061",
        Scrap = "rbxassetid://14831988987",
        CampaignPoints = "rbxassetid://14915583580",
        CrateToken = "rbxassetid://14915583580"
    },
    Audio = script:WaitForChild("Audio"),
    LeaderboardPageSize = 25
};

if PlaceId == 85947802478535 or PlaceId == 116897522239921 then
    print((`{u1} Game is running in test server. Applying correct place IDs`));
    u3.LobbyID = 85947802478535;
    u3.InGameID = 116897522239921;
end;

if PlaceId == 111502595339836 or PlaceId == 85333342663673 then
    print((`{u1} Game is running in test server. Applying correct place IDs`));
    u3.LobbyID = 111502595339836;
    u3.InGameID = 85333342663673;
end;

function u3.CalculateRankedRatingReward(p4, p5, p6) -- Line: 518
    -- upvalues: u3 (copy)
    local RankedRatingBase = u3.RankedRatingBase;

    if p4 <= u3.StarterRankedMaxMatches then
        RankedRatingBase = u3.StarterRankedRatingBase;
    end;

    if p5 == true then
        return (13 - p6) * 5 + RankedRatingBase;
    end;

    return -(p6 * 5) - RankedRatingBase;
end;

function u3.CheckPlayerOwnGamepass(p7, p8) -- Line: 540
    -- upvalues: MarketplaceService (copy)
    return MarketplaceService:UserOwnsGamePassAsync(p7.UserId, p8);
end;

function u3.CheckPlayerOwnShirt(p9, p10) -- Line: 544
    return nil;
end;

function u3.CheckPlayerBoostActive(p11, p12) -- Line: 548
    return p11:WaitForChild("PlayerData"):WaitForChild("Stats"):GetAttribute("Booster" .. p12 .. "Time") > 0;
end;

function u3.CheckLowLevelBonusExperience(p13) -- Line: 559
    local v14 = p13:WaitForChild("PlayerData"):WaitForChild("Stats"):GetAttribute("Level");
    local v15 = typeof(v14) == "number";
    local v16 = "CheckLowLevelBonusExperience failed because GetAttribute \"level\" is invalid: " .. tostring(v14);
    assert(v15, v16);

    return v14 <= 2 and 900 or (v14 <= 5 and 700 or (v14 <= 10 and 400 or (v14 <= 15 and 300 or (v14 <= 25 and 200 or (v14 <= 35 and 100 or 0)))));
end;

function u3.GetCurrentEvent() -- Line: 583
    return nil;
end;

function u3.CheckSeasonActive() -- Line: 588
    -- upvalues: u3 (copy)
    local v17;

    if u3.SeasonActive == true then
        v17 = u3.GetCurrentDay() <= u3.SeasonEndDate;
    else
        v17 = false;
    end;

    return v17;
end;

function u3.RoundTo(p18, p19) -- Line: 592
    local v20 = 10 ^ p19;

    return math.round((p18 + 1e-10) * v20) / v20;
end;

function u3.RoundToNearest(p21, p22) -- Line: 597
    return math.round(p21 / p22) * p22;
end;

function u3.GetTimeUntilTomorrow() -- Line: 601
    local v23 = os.date("!*t", os.time() + 86400);

    return os.time({
        hour = 0,
        min = 0,
        sec = 0,
        year = v23.year,
        month = v23.month,
        day = v23.day
    }) - os.time();
end;

function u3.GetDateFromOsTime(p24) -- Line: 610
    local v25 = os.date("!*t", p24);

    return ("%02i"):format(v25.day) .. "/" .. ("%02i"):format(v25.month) .. "/" .. v25.year;
end;

function u3.GetCurrentWeek() -- Line: 617
    -- upvalues: u3 (copy)
    local v26 = (os.time() - u3.BirthTime) / 604800;

    return math.floor(v26);
end;

function u3.GetCurrentDay() -- Line: 621
    -- upvalues: u3 (copy)
    local v27 = (os.time() - u3.BirthTime) / 86400;

    return math.floor(v27);
end;

function u3.GetDayFromFormat(p28) -- Line: 625
    -- upvalues: u3 (copy)
    local v29 = (os.time(p28) - u3.BirthTime) / 86400;

    return math.floor(v29);
end;

function u3.GetItemDataFromPlayerInventoryItem(p30) -- Line: 629
    -- upvalues: ReplicatedStorage (copy), u3 (copy)
    if p30:GetAttribute("Type") == nil or p30:GetAttribute("Name") == nil then
        p30:Destroy();

        return nil;
    end;

    local v31 = ReplicatedStorage.Items[p30:GetAttribute("Type")][p30:GetAttribute("Name")];
    local v32 = u3.GetItemDataFromObject(v31);

    if u3.CheckIfItemIsWeaponExclusive(v32) then
        v32.Weapon = p30:GetAttribute("Weapon");
    end;

    v32.Quantity = p30:GetAttribute("Quantity") or 1;

    return v32;
end;

function u3.GetItemDataFromObject(p33) -- Line: 643
    local v34 = {
        Name = p33.Name
    };
    local v35 = p33:GetAttributes();

    for i, v in pairs(v35) do
        v34[i] = v;
    end;

    return v34;
end;

function u3.GetItemDataPrice(p36) -- Line: 656
    -- upvalues: u3 (copy)
    local v37 = p36.Crate == "Featured" and "Credit" or "Cash";
    local v38 = u3.PriceMultiplier[p36.Type];

    return v37, math.ceil(u3.Rarity[p36.Rarity][v37] * (v38 == nil and 1 or v38) / 10) * 10;
end;

function u3.GetObjectFromItemData(p39) -- Line: 672
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage.Items[p39.Type][p39.Name];
end;

function u3.CheckIfItemIsWeaponExclusive(p40) -- Line: 676
    return p40.Type == "Skin" or (p40.Type == "Muzzle" or (p40.Type == "Grip" or (p40.Type == "Sight" or p40.Type == "Extra")));
end;

function u3.GetItemIDFromItemData(p41) -- Line: 684
    -- upvalues: u3 (copy)
    local v42 = p41.Name .. p41.Type;

    if u3.CheckIfItemIsWeaponExclusive(p41) then
        if p41.Weapon == nil or p41.Weapon == "" then
            return nil;
        end;

        return p41.Name .. p41.Type .. p41.Weapon;
    end;

    if p41.Type == "AttachmentSkin" then
        v42 = p41.Name .. p41.Slot .. p41.Weapon;
    end;

    return v42;
end;

function u3.RayCast(p43, p44, p45, p46) -- Line: 699
    local v47 = RaycastParams.new();
    v47.FilterType = Enum.RaycastFilterType.Exclude;
    v47.FilterDescendantsInstances = p46;
    v47.IgnoreWater = false;
    local v48 = workspace:Raycast(p43, p44 * p45, v47);

    if v48 and v48.Instance then
        local v49 = nil;

        while not v49 do
            if v48 and (v48.Instance and v48.Instance.Transparency >= 1) then
                table.insert(p46, v48.Instance);
                v47.FilterDescendantsInstances = p46;
                v49 = true;
            end;

            if not v49 then
                break;
            end;

            v48 = workspace:Raycast(p43, p44 * p45, v47);
            v49 = false;
        end;
    end;

    return v48;
end;

function u3.RegularRayCast(p50, p51, p52, p53) -- Line: 729
    local v54 = RaycastParams.new();
    v54.FilterType = Enum.RaycastFilterType.Exclude;
    v54.FilterDescendantsInstances = p53;
    v54.IgnoreWater = false;

    return workspace:Raycast(p50, p51 * p52, v54);
end;

function u3.GivePlayerNotice(p55, p56, p57, p58) -- Line: 740
    local Notice = p55:WaitForChild("PlayerData"):WaitForChild("Notice");
    local StringValue = Instance.new("StringValue", Notice);
    StringValue.Name = p56;
    StringValue.Value = p56;

    for i, v in {
        Title = p56,
        Message = p57,
        Image = p58
    } do
        StringValue:SetAttribute(i, v);
    end;
end;

function u3.GetEarnings(p59, p60) -- Line: 755
    -- upvalues: u3 (copy)
    local ServerData = p59:WaitForChild("ServerData", 5);
    local v61 = 1;

    if p60 == "Cash" or p60 == "Experience" then
        v61 = u3.CheckPlayerBoostActive(p59, p60) and 2 or v61;
    end;

    return (ServerData:GetAttribute("Kills") * u3["Reward" .. p60].Kill + ServerData:GetAttribute("Headshots") * u3["Reward" .. p60].Headshot) * v61;
end;

function u3.GetExperienceToHit(p62) -- Line: 767
    return 1000 + p62:WaitForChild("PlayerData", 5).Stats:GetAttribute("Level") * 500;
end;

function u3.TweenOnce(p63, p64, p65, p66, p67, p68) -- Line: 775
    -- upvalues: TweenService (copy)
    TweenService:Create(p63, TweenInfo.new(p65, p66, p67), p64):Play();

    if p68 then
        task.wait(p65);
    end;
end;

function u3.CloseSound(p69, p70) -- Line: 781
    -- upvalues: SoundService (copy), u3 (copy)
    for _, child in SoundService:GetChildren() do
        if child.Name == p69 then
            u3.TweenOnce(child, {
                Volume = 0
            }, p70, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, false);
        end;
    end;
end;

function u3.AddSound(p71, p72, p73, p74, p75) -- Line: 789
    -- upvalues: u3 (copy), SoundService (copy), Players (copy)
    if u3.Audio:FindFirstChild(p71) == nil then
        return nil;
    end;

    local u76 = u3.Audio[p71]:Clone();

    if p74 == nil then
        u76.Parent = SoundService;
    else
        u76.Parent = p74;
    end;

    if p73 then
        u76.PlaybackSpeed = u76.PlaybackSpeed + math.random(-100, 100) / 1000;
    end;

    if Players.LocalPlayer then
        u76.Volume = u76.Volume * Players.LocalPlayer.PlayerData.Settings:GetAttribute("MasterVolume");
    end;

    u76:Play();

    if not p75 then
        u76.Ended:Connect(function() -- Line: 810
            -- upvalues: u76 (copy)
            u76:Destroy();
        end);
    end;

    return u76;
end;

function u3.WeldObject(p77, p78, p79) -- Line: 818
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p77;
    WeldConstraint.Part1 = p78;
    WeldConstraint.Parent = p79;
end;

function u3.GetFilteredText(u80, u81) -- Line: 825
    -- upvalues: Chat (copy), u1 (copy)
    local u82 = u81;
    local success, result = pcall(function() -- Line: 828
        -- upvalues: u82 (ref), Chat (ref), u81 (copy), u80 (copy)
        u82 = Chat:FilterStringForBroadcast(u81, u80);
    end);

    if not success then
        print(u1 .. "Failed to filter text");
        print(u1 .. "Error:", (tostring(result)));
        print(u1 .. "Filtered text:", (tostring(u82)));
    end;

    if success then
        return u82, nil;
    end;

    u82 = "";

    return u82, true;
end;

function u3.GetFilteredTextOrNil(p83, p84, p85) -- Line: 846
    -- upvalues: u3 (copy)
    local v86, v87 = u3.GetFilteredText(p83, p84);
    string.gsub(v86, "%w", "");

    if v87 or v86 ~= "" and v86:sub(1, 1) ~= "#" then
        return v86, v87;
    end;

    return nil, false;
end;

function u3.toHMS(p88) -- Line: 858
    return string.format("%02i:%02i:%02i", p88 / 3600, p88 / 60 % 60, p88 % 60);
end;

function u3.toMS(p89) -- Line: 862
    return string.format("%1i:%02i", p89 / 60 % 60, p89 % 60);
end;

function u3.AddComponents(u90) -- Line: 866
    -- upvalues: CollectionService (copy), ReplicatedStorage (copy), u1 (copy)
    for _, v in ipairs(CollectionService:GetTags(u90)) do
        local u91 = ReplicatedStorage.Components:FindFirstChild(v);

        if u91 then
            local v92 = "__ComponentInit_" .. string.gsub(v, "[^%w_]", "_");
            local v93 = u90:GetAttribute(v92);

            if v93 ~= true and v93 ~= "Loading" then
                u90:SetAttribute(v92, "Loading");
                local success, result = pcall(function() -- Line: 878
                    -- upvalues: u91 (copy), u90 (copy)
                    require(u91).new(u90):Init();
                end);

                if success then
                    u90:SetAttribute(v92, true);
                else
                    u90:SetAttribute(v92, nil);
                    warn((`{u1} Failed to add component "{v}" to "{u90:GetFullName()}": {tostring(result)}`));
                end;
            end;
        end;
    end;
end;

function u3.Lerp(p94, p95, p96) -- Line: 894
    return p94 + (p95 - p94) * p96;
end;

function u3.ReturnStringCurrency(p97) -- Line: 898
    local v98 = tostring(p97);
    local v99;

    repeat
        v98, v99 = v98:gsub("^(-?%d+)(%d%d%d)", "%1,%2");
    until v99 == 0;

    return v98;
end;

function u3.ConfigTopInset(u100) -- Line: 910
    -- upvalues: GuiService (copy)
    if not u100 then
        return;
    end;

    local function Refresh() -- Line: 913
        -- upvalues: GuiService (ref), u100 (copy)
        u100.Position = UDim2.new(0.5, 0, 0, -GuiService.TopbarInset.Max.Y);
    end;

    local v101 = 50;

    while GuiService.TopbarInset.Max.Y <= 0 and v101 > 0 do
        task.wait(0.1);
        v101 = v101 - 1;
    end;

    u100.Position = UDim2.new(0.5, 0, 0, -GuiService.TopbarInset.Max.Y);
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(Refresh);
end;

function u3.TweenCreate(p102, p103, p104, p105, p106, p107, p108, p109) -- Line: 929
    -- upvalues: TweenService (copy)
    local v110 = TweenService:Create(p102, TweenInfo.new(p104, p105 or Enum.EasingStyle.Sine, p106 or Enum.EasingDirection.InOut, p108 and -1 or 0, p109 or false), p103);
    v110:Play();

    if p107 then
        wait(p104 * (p109 and 2 or 1));
    end;

    return v110;
end;

function u3.AddItemsLog(p111, p112, p113) -- Line: 939
    -- upvalues: u3 (copy)
    local v114 = p112.ID or u3.GetItemIDFromItemData(p112);

    if not v114 then
        return nil;
    end;

    local v115 = p111.PlayerData.ItemsLog:FindFirstChild(v114);
    local StringValue = Instance.new("StringValue");
    StringValue.Name = v114;
    StringValue:SetAttribute("Name", p112.Name);
    StringValue:SetAttribute("Type", p112.Type);
    StringValue:SetAttribute("Weapon", p112.Weapon);
    StringValue:SetAttribute("Amount", p112.Amount);
    StringValue:SetAttribute("Seen", false);
    StringValue.Parent = p111.PlayerData.ItemsLog;

    if v115 then
        StringValue:SetAttribute("Delete", true);
    end;

    if p113 == true then
        StringValue:SetAttribute("Delete", true);
    end;

    return StringValue;
end;

function u3.StringToNumber(p116) -- Line: 968
    local v117, v118 = string.match(string.lower(p116), "^(%D*)(%d*)$");
    local v119 = v117 or "";
    local v120 = tonumber(v118) or 0;
    local v121 = 0;

    for i = 1, #v119 do
        v121 = v121 + string.byte(v119, i);
    end;

    return v121 * 1000 + v120;
end;

function u3.FindNameAndType(p122, p123, p124) -- Line: 984
    for _, child in pairs(p124:GetChildren()) do
        if child:GetAttribute("Name") == p122 and child:GetAttribute("Type") == p123 then
            return child;
        end;
    end;
end;

function u3.toSuffixString(p125) -- Line: 992
    -- upvalues: u3 (copy)
    if p125 < 1 then
        return tostring(p125);
    end;

    local v126 = math.log(p125, 1000);
    local v127 = math.floor(v126);
    local v128 = ("%.2f"):format(p125 / math.pow(10, v127 * 3)):gsub("%.?0+$", "") .. (u3.NumberSuffixes[v127] or "");

    return p125 == 0 and "0" or v128;
end;

function u3.GetSyncedTip() -- Line: 1001
    -- upvalues: u3 (copy)
    local v129 = os.time() / 300;
    local v130 = math.floor(v129);
    local v131 = Random.new(v130);
    local v132 = 0;

    for _ in pairs(u3.Tips) do
        v132 = v132 + 1;
    end;

    if v132 == 0 then
        return "";
    end;

    local v133 = v131:NextInteger(1, v132);
    local v134 = 0;

    for _, v in pairs(u3.Tips) do
        v134 = v134 + 1;

        if v134 == v133 then
            return v;
        end;
    end;

    return "";
end;

function u3.CreateRandomSerialID() -- Line: 1027
    -- upvalues: u3 (copy)
    local u135 = Random.new();

    local function GetRandomLetter() -- Line: 1030
        -- upvalues: u3 (ref), u135 (copy)
        return u3.NumberSuffixes[u135:NextInteger(1, #u3.NumberSuffixes)];
    end;

    local function GetRandomNumber() -- Line: 1034
        -- upvalues: u135 (copy)
        local v136 = u135:NextNumber(1, 999);

        return math.floor(v136);
    end;

    local function GetRandomString(p137, p138) -- Line: 1038
        -- upvalues: u3 (ref), u135 (copy)
        local v139 = "";

        for _ = 1, p137 or 10 do
            local v140 = u3.NumberSuffixes[u135:NextInteger(1, #u3.NumberSuffixes)];

            if p138 and u135:NextNumber() > 0.5 then
                v140 = string.upper(v140);
            end;

            v139 = v139 .. v140;
        end;

        return v139;
    end;

    local v141 = u3.NumberSuffixes[u135:NextInteger(1, #u3.NumberSuffixes)];
    local v142 = u135:NextNumber(1, 999);
    local v143 = math.floor(v142);
    local v144 = u3.NumberSuffixes[u135:NextInteger(1, #u3.NumberSuffixes)];
    local v145 = u135:NextNumber(1, 999);
    local v146 = math.floor(v145);
    local v147 = u135:NextNumber(1, 999);

    return v141 .. v143 .. v144 .. v146 .. math.floor(v147) .. u3.NumberSuffixes[u135:NextInteger(1, #u3.NumberSuffixes)];
end;

function u3.SetTitle(p148, p149) -- Line: 1055
    if not p148 then
        return;
    end;

    if not p149 then
        p148.Text = "";

        return;
    end;

    p148.TextColor3 = p149.TextColor3;
    p148.Text = p149.Text;
    p148.Font = p149.Font;
    p148.TextStrokeColor3 = p149.TextStrokeColor3;
    p148.TextStrokeTransparency = p149.TextStrokeTransparency;
    p148.UIGradient.Color = p149.UIGradient.Color;
    p148.UIGradient.Rotation = p149.UIGradient.Rotation;
end;

function u3.GetEndGameRewardTotalChance() -- Line: 1076
    -- upvalues: u3 (copy)
    local v150 = 0;

    for _, v in ipairs(u3.EndGameRewards) do
        v150 = v150 + (v.Chance or 0);
    end;

    return v150;
end;

function u3.GetEndGameRewardChancePercentage(p151) -- Line: 1086
    -- upvalues: u3 (copy)
    if not p151 then
        return 0;
    end;

    local v152 = u3.GetEndGameRewardTotalChance();

    return v152 <= 0 and 0 or (p151.Chance or 0) / v152 * 100;
end;

function u3.RollEndGameRewardIndex(p153) -- Line: 1095
    -- upvalues: u3 (copy)
    local v154 = 0;

    for i, v in ipairs(u3.EndGameRewards) do
        if not p153[i] then
            v154 = v154 + (v.Chance or 0);
        end;
    end;

    if v154 <= 0 then
        return nil;
    end;

    local v155 = math.random(1, v154);
    local v156 = 0;

    for i, v in ipairs(u3.EndGameRewards) do
        if not p153[i] then
            v156 = v156 + (v.Chance or 0);

            if v155 <= v156 then
                return i;
            end;
        end;
    end;

    return nil;
end;

function u3.RollUniqueEndGameRewardIndexes(p157) -- Line: 1122
    -- upvalues: u3 (copy)
    local v158 = {};
    local v159 = {};

    for _ = 1, math.min(p157 or (u3.EndGameRewardsAmount or 3), #u3.EndGameRewards) do
        local v160 = u3.RollEndGameRewardIndex(v158);

        if v160 then
            v158[v160] = true;
            table.insert(v159, v160);
        end;
    end;

    return v159;
end;

local u161 = false;

function u3.PromptUpcomingEvents() -- Line: 1143
    -- upvalues: u161 (ref)
    local SocialService = game:GetService("SocialService");

    if u161 == true then
        return;
    end;

    u161 = true;
    local v162 = 0;
    local success, result = pcall(function() -- Line: 1158
        -- upvalues: SocialService (copy)
        return SocialService:GetUpcomingExperienceEventsAsync();
    end);

    if success ~= true or type(result) ~= "table" then
        u161 = false;

        return;
    end;

    for _, v in ipairs(result) do
        if v162 >= 3 then
            break;
        end;

        if type(v) == "table" then
            local u163 = v.Id or v.id;

            if type(u163) == "string" and u163 ~= "" then
                local success2, result2 = pcall(function() -- Line: 1183
                    -- upvalues: SocialService (copy), u163 (copy)
                    return SocialService:GetEventRsvpStatusAsync(u163);
                end);

                if success2 == true and (result2 ~= Enum.RsvpStatus.Going and pcall(function() -- Line: 1195
                    -- upvalues: SocialService (copy), u163 (copy)
                    SocialService:PromptRsvpToEventAsync(u163);
                end) == true) then
                    v162 = v162 + 1;
                    task.wait(0.25);
                end;
            end;
        end;
    end;

    u161 = false;
end;

return u3;