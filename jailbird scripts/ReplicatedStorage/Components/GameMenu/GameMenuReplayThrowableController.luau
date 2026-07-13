
local Workspace = game:GetService("Workspace");

return {
    new = function(p1) -- Line: 5, Name: new
        -- upvalues: Workspace (copy)
        local ReplicatedStorage = p1.ReplicatedStorage;
        local Debris = p1.Debris;
        local ROUND_CACHE_FOLDER_NAME = p1.ROUND_CACHE_FOLDER_NAME;
        local ResolveReplayActorRecord = p1.ResolveReplayActorRecord;
        local u2 = {};
        local u3 = nil;
        local u4 = {};
        local u5 = 0;

        local function resolveReplayRelativeInstance(p6, p7) -- Line: 16
            if not p6 or (typeof(p7) ~= "string" or p7 == "") then
                return nil;
            end;

            for i in string.gmatch(p7, "[^/]+") do
                if p6 then
                    p6 = p6:FindFirstChild(i);
                end;

                if not p6 then
                    return nil;
                end;
            end;

            return p6;
        end;

        local function getReplayThrowableTemplate(p8) -- Line: 30
            -- upvalues: ReplicatedStorage (copy)
            local Throwable = ReplicatedStorage.Items:FindFirstChild("Throwable");

            if Throwable then
                Throwable = Throwable:FindFirstChild(p8);
            end;

            if Throwable and Throwable:IsA("Model") then
                return Throwable;
            end;

            return nil;
        end;

        local function getReplayThrowableCorePart(p9) -- Line: 39
            if not (p9 and p9:IsA("Model")) then
                return nil;
            end;

            local Base = p9:FindFirstChild("Base");

            if Base and Base:IsA("BasePart") then
                return Base;
            end;

            local Handle = p9:FindFirstChild("Handle");

            if Handle and Handle:IsA("BasePart") then
                return Handle;
            end;

            local PrimaryPart = p9.PrimaryPart;

            if PrimaryPart and PrimaryPart:IsA("BasePart") then
                return PrimaryPart;
            end;

            return p9:FindFirstChildWhichIsA("BasePart", true);
        end;

        local function sanitizeReplayThrowableClone(p10) -- Line: 58
            -- upvalues: getReplayThrowableCorePart (copy)
            for _, descendant in ipairs(p10:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true;
                    descendant.CanCollide = false;
                    descendant.CanTouch = false;
                    descendant.CanQuery = false;
                    descendant.Massless = true;
                elseif descendant:IsA("BaseScript") or (descendant:IsA("Script") or descendant:IsA("LocalScript")) then
                    descendant:Destroy();
                elseif descendant:IsA("ProximityPrompt") then
                    descendant.Enabled = false;
                elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
                    descendant.Enabled = false;
                elseif descendant:IsA("PointLight") or (descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight")) then
                    descendant.Enabled = false;
                elseif descendant:IsA("Sound") then
                    descendant:Stop();
                end;
            end;

            local v11 = getReplayThrowableCorePart(p10);

            if v11 then
                p10.PrimaryPart = v11;
            end;
        end;

        local function buildReplayThrowableVisibilityMap(p12) -- Line: 84
            local v13 = {};

            for _, descendant in ipairs(p12:GetDescendants()) do
                if descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
                    v13[descendant] = descendant.Transparency;
                end;
            end;

            return v13;
        end;

        local function setReplayThrowableVisible(p14, p15) -- Line: 94
            p14.Hidden = p15 ~= true;

            if p14.Clone then
                p14.Clone:SetAttribute("ReplayHidden", p14.Hidden);
            end;

            for i, v in pairs(p14.VisibilityMap or {}) do
                if i and i.Parent then
                    i.Transparency = p15 == true and v and v or 1;
                end;
            end;
        end;

        local function applyReplayThrowableCFrame(p16, p17) -- Line: 106
            if not p16.Clone or (p16.Clone.Parent == nil or typeof(p17) ~= "CFrame") then
                return;
            end;

            p16.WorldCFrame = p17;
            p16.Clone:PivotTo(p17);
        end;

        local function resolveReplayThrowableAttachmentTarget(p18) -- Line: 114
            -- upvalues: ResolveReplayActorRecord (copy), resolveReplayRelativeInstance (copy), Workspace (ref), ROUND_CACHE_FOLDER_NAME (copy)
            if typeof(p18) ~= "table" then
                return nil;
            end;

            if p18.Kind ~= "Actor" then
                if p18.Kind == "Map" then
                    return resolveReplayRelativeInstance(Workspace:FindFirstChild("Map"), p18.Path);
                end;

                if p18.Kind == "RoundCache" then
                    return resolveReplayRelativeInstance(Workspace:FindFirstChild(ROUND_CACHE_FOLDER_NAME), p18.Path);
                end;

                if p18.Kind == "World" and (typeof(p18.Name) == "string" and p18.Name ~= "") then
                    return Workspace:FindFirstChild(p18.Name, true);
                end;

                return nil;
            end;

            local v19 = ResolveReplayActorRecord and ResolveReplayActorRecord(p18.UserId);

            if not v19 or (not v19.Model or v19.Model.Parent == nil) then
                return nil;
            end;

            if typeof(p18.RelativePath) ~= "string" or p18.RelativePath == "" then
                return v19.Model:FindFirstChild("HumanoidRootPart") or v19.Model.PrimaryPart;
            end;

            local v20 = v19.PartMap and v19.PartMap[p18.RelativePath];

            if v20 and v20.Parent then
                return v20;
            end;

            return resolveReplayRelativeInstance(v19.Model, p18.RelativePath);
        end;

        local function applyReplayThrowableAttachmentState(p21, p22, p23) -- Line: 141
            -- upvalues: resolveReplayThrowableAttachmentTarget (copy)
            p21.Attachment = typeof(p22) == "table" and p22 and p22 or nil;
            p21.AttachedTarget = nil;
            p21.AttachmentOffset = nil;
            p21.StaticCFrame = typeof(p23) == "CFrame" and p23 and p23 or p21.WorldCFrame;
            local v24 = resolveReplayThrowableAttachmentTarget(p21.Attachment);

            if v24 and v24:IsA("BasePart") then
                p21.AttachedTarget = v24;

                if typeof(p21.StaticCFrame) == "CFrame" then
                    p21.AttachmentOffset = v24.CFrame:ToObjectSpace(p21.StaticCFrame);
                else
                    p21.AttachmentOffset = CFrame.identity;
                end;
            end;

            if typeof(p23) == "CFrame" and (p21.Clone and p21.Clone.Parent ~= nil) then
                if typeof(p23) ~= "CFrame" then
                    return;
                end;

                p21.WorldCFrame = p23;
                p21.Clone:PivotTo(p23);
            end;
        end;

        local function updateReplayThrowableAttachment(p25) -- Line: 160
            -- upvalues: resolveReplayThrowableAttachmentTarget (copy)
            if typeof(p25.Attachment) ~= "table" then
                return false;
            end;

            local AttachedTarget = p25.AttachedTarget;

            if not AttachedTarget or AttachedTarget.Parent == nil then
                AttachedTarget = resolveReplayThrowableAttachmentTarget(p25.Attachment);
                p25.AttachedTarget = AttachedTarget;
            end;

            if AttachedTarget and (AttachedTarget:IsA("BasePart") and typeof(p25.AttachmentOffset) == "CFrame") then
                local v26 = AttachedTarget.CFrame * p25.AttachmentOffset;

                if p25.Clone and (p25.Clone.Parent ~= nil and typeof(v26) == "CFrame") then
                    p25.WorldCFrame = v26;
                    p25.Clone:PivotTo(v26);
                end;

                return true;
            end;

            if typeof(p25.StaticCFrame) ~= "CFrame" then
                return false;
            end;

            local StaticCFrame = p25.StaticCFrame;

            if p25.Clone and (p25.Clone.Parent ~= nil and typeof(StaticCFrame) == "CFrame") then
                p25.WorldCFrame = StaticCFrame;
                p25.Clone:PivotTo(StaticCFrame);
            end;

            return true;
        end;

        local function findReplayThrowableSound(p27, p28) -- Line: 180
            if not p27 or (typeof(p28) ~= "string" or p28 == "") then
                return nil;
            end;

            for _, descendant in ipairs(p27:GetDescendants()) do
                if descendant:IsA("Sound") and descendant.Name == p28 then
                    return descendant;
                end;
            end;

            return nil;
        end;

        local function playReplayThrowableSound(p29, p30, p31) -- Line: 192
            -- upvalues: findReplayThrowableSound (copy), Debris (copy)
            local v32 = findReplayThrowableSound(p29, p30);

            if not v32 then
                return;
            end;

            local u33 = v32:Clone();

            for i, v in pairs(p31 or {}) do
                pcall(function() -- Line: 199
                    -- upvalues: u33 (copy), i (copy), v (copy)
                    u33[i] = v;
                end);
            end;

            u33.Looped = false;
            u33.Parent = v32.Parent;
            u33:Play();
            Debris:AddItem(u33, (math.max(u33.TimeLength + 1, 3)));
        end;

        local function playReplayThrowableSounds(p34, p35) -- Line: 209
            -- upvalues: playReplayThrowableSound (copy)
            if typeof(p35) ~= "table" then
                return;
            end;

            for _, v in ipairs(p35) do
                playReplayThrowableSound(p34, v);
            end;
        end;

        local function pulseReplayThrowableEffects(p36, p37, p38, u39, u40) -- Line: 218
            if not p36 then
                return;
            end;

            local u41 = {};

            for _, descendant in ipairs(p36:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    if typeof(p38) == "number" and p38 > 0 then
                        local v42 = math.floor(p38);
                        descendant:Emit((math.max(v42, 1)));
                    end;

                    descendant.Enabled = true;
                    table.insert(u41, descendant);
                elseif descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = true;
                    table.insert(u41, descendant);
                elseif descendant:IsA("PointLight") or (descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight")) then
                    descendant.Enabled = true;
                    table.insert(u41, descendant);
                end;
            end;

            local v43 = tonumber(p37) or 0;
            local v44 = math.max(v43, 0);

            if v44 <= 0 then
                return;
            end;

            task.delay(v44, function() -- Line: 242
                -- upvalues: u39 (copy), u40 (copy), u41 (copy)
                if u39.SessionToken ~= u40 then
                    return;
                end;

                for _, v in ipairs(u41) do
                    if v and v.Parent then
                        v.Enabled = false;
                    end;
                end;
            end);
        end;

        local function setReplayThrowableNeonColor(p45, p46) -- Line: 254
            local v47 = p45.Clone and p45.Clone:FindFirstChild("Neon");

            if v47 and (v47:IsA("BasePart") and typeof(p46) == "Color3") then
                v47.Color = p46;
            end;
        end;

        local u48 = nil;

        local function startReplayThrowableLingeringArea(u49, p50, u51, p52) -- Line: 263
            -- upvalues: u48 (ref)
            local u53 = {
                Kind = u51,
                SessionToken = u49.SessionToken
            };
            local Part = Instance.new("Part");
            Part.Name = u51;
            Part.Anchored = true;
            Part.CanCollide = false;
            Part.CanTouch = false;
            Part.CanQuery = false;
            Part.Transparency = 1;
            Part.Size = typeof(p50.Size) == "Vector3" and (p50.Size or Vector3.new(1, 1, 1)) or Vector3.new(1, 1, 1);
            Part.CFrame = typeof(p50.CFrame) == "CFrame" and p50.CFrame or (u49.WorldCFrame or CFrame.new());
            Part.Parent = u49.RuntimeFolder;
            u53.Root = Part;
            local v54 = u49.Template and u49.Template:FindFirstChild("Object");

            if v54 then
                v54 = v54:FindFirstChild("Effects");
            end;

            if v54 then
                for _, child in ipairs(v54:GetChildren()) do
                    child:Clone().Parent = Part;
                end;
            end;

            for _, descendant in ipairs(Part:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or descendant:IsA("Beam")) then
                    descendant.Enabled = true;
                elseif descendant:IsA("PointLight") or (descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight")) then
                    descendant.Enabled = true;
                elseif descendant:IsA("Sound") and (p52 ~= true or descendant.Looped == true) then
                    descendant:Play();
                end;
            end;

            local v55 = tonumber(p50.Duration);

            if v55 and (v55 > 0 and p52 ~= true) then
                task.delay(v55, function() -- Line: 303
                    -- upvalues: u49 (copy), u53 (copy), u51 (copy), u48 (ref)
                    if u49.SessionToken ~= u53.SessionToken then
                        return;
                    end;

                    if u49.ActiveEffects[u51] == u53 then
                        u48(u49, u51);
                    end;
                end);
            end;

            return u53;
        end;

        local function startReplaySmokeCloud(u56, p57, u58, p59) -- Line: 315
            -- upvalues: playReplayThrowableSound (copy)
            local u60 = {
                Kind = u58,
                SessionToken = u56.SessionToken
            };
            local v61 = u56.Clone and u56.Clone:FindFirstChild("Base");

            if not v61 then
                return u60;
            end;

            local u62 = {};

            for _, descendant in ipairs(v61:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local v63 = tonumber(p57.ParticleLifetime);

                    if v63 then
                        descendant.Lifetime = NumberRange.new(v63, v63);
                    end;

                    table.insert(u62, descendant);
                end;
            end;

            if p59 ~= true then
                local Clone = u56.Clone;
                local SoundNames = p57.SoundNames;

                if typeof(SoundNames) == "table" then
                    for _, v in ipairs(SoundNames) do
                        playReplayThrowableSound(Clone, v);
                    end;
                end;
            end;

            local v64 = tonumber(p57.BurstCount) or 1;
            local v65 = math.max(v64, 1);
            local v66 = tonumber(p57.BurstInterval) or 0.75;
            local u67 = math.max(v66, 0);
            local v68 = tonumber(p57.EmitCount) or 5;
            local u69 = math.max(v68, 1);
            local u70 = p59 == true and 1 or v65;
            task.spawn(function() -- Line: 343
                -- upvalues: u70 (ref), u56 (copy), u60 (copy), u58 (copy), u62 (copy), u69 (copy), u67 (copy)
                for i = 1, u70 do
                    if u56.SessionToken ~= u60.SessionToken then
                        return;
                    end;

                    if u56.ActiveEffects[u58] ~= u60 then
                        return;
                    end;

                    for _, v in ipairs(u62) do
                        if v and v.Parent then
                            v:Emit(u69);
                        end;
                    end;

                    if i < u70 then
                        task.wait(u67);
                    end;
                end;
            end);

            return u60;
        end;

        local function startReplayThrowableEffect(p71, p72, p73) -- Line: 364
            -- upvalues: u48 (ref), startReplayThrowableLingeringArea (copy), startReplaySmokeCloud (copy), playReplayThrowableSound (copy)
            if typeof(p72) ~= "table" then
                return;
            end;

            local v74;

            if typeof(p72.EffectName) == "string" then
                v74 = p72.EffectName or nil;
            else
                v74 = nil;
            end;

            if not v74 or v74 == "" then
                return;
            end;

            u48(p71, v74);
            local v75;

            if v74 == "LingeringArea" then
                v75 = startReplayThrowableLingeringArea(p71, p72, v74, p73);
            elseif v74 == "SmokeCloud" then
                v75 = startReplaySmokeCloud(p71, p72, v74, p73);
            elseif v74 == "AlarmArmed" then
                local v76 = Color3.fromRGB(0, 90, 110);
                local v77 = p71.Clone and p71.Clone:FindFirstChild("Neon");

                if v77 and (v77:IsA("BasePart") and typeof(v76) == "Color3") then
                    v77.Color = v76;
                end;

                if p73 ~= true and p71.Clone then
                    playReplayThrowableSound(p71.Clone, "Tick", {
                        Volume = 0.15
                    });
                end;

                v75 = {
                    Kind = v74,
                    SessionToken = p71.SessionToken
                };
            else
                v75 = {
                    Kind = v74,
                    SessionToken = p71.SessionToken
                };
            end;

            p71.ActiveEffects[v74] = v75;
        end;

        u48 = function(p78, p79) -- Line: 398
            local v80 = p78.ActiveEffects[p79];

            if not v80 then
                return;
            end;

            p78.ActiveEffects[p79] = nil;

            if v80.Root and v80.Root.Parent then
                v80.Root:Destroy();
            end;

            if p79 == "AlarmArmed" then
                local v81 = Color3.fromRGB(0, 90, 110);
                local v82 = p78.Clone and p78.Clone:FindFirstChild("Neon");

                if v82 and (v82:IsA("BasePart") and typeof(v81) == "Color3") then
                    v82.Color = v81;
                end;
            end;
        end;

        local function handleReplayThrowableDetonation(p83, p84) -- Line: 412
            -- upvalues: playReplayThrowableSound (copy), pulseReplayThrowableEffects (copy), setReplayThrowableVisible (copy)
            if p83.Clone then
                local Clone = p83.Clone;
                local SoundNames = p84.SoundNames;

                if typeof(SoundNames) == "table" then
                    for _, v in ipairs(SoundNames) do
                        playReplayThrowableSound(Clone, v);
                    end;
                end;

                pulseReplayThrowableEffects(p83.Clone:FindFirstChild("Base") or p83.Clone, p84.ParticleDuration, nil, p83, p83.SessionToken);

                if p84.HideModel == true then
                    setReplayThrowableVisible(p83, false);
                end;
            end;
        end;

        local function handleReplayThrowableDecoyPulse(u85, p86) -- Line: 423
            -- upvalues: playReplayThrowableSound (copy), u5 (ref)
            if not u85.Clone then
                return;
            end;

            playReplayThrowableSound(u85.Clone, "DecoySound", {
                PlaybackSpeed = tonumber(p86.PlaybackSpeed) or 1
            });
            local v87 = tonumber(p86.PulseDuration) or 0.1;
            local v88 = math.max(v87, 0);
            local Base = u85.Clone:FindFirstChild("Base");

            if not Base then
                return;
            end;

            local u89 = {};

            for _, child in ipairs(Base:GetChildren()) do
                if child:IsA("ParticleEmitter") and child.Name == "Decoy" then
                    child.Enabled = true;
                    table.insert(u89, child);
                end;
            end;

            task.delay(v88, function() -- Line: 442
                -- upvalues: u85 (copy), u5 (ref), u89 (copy)
                if u85.SessionToken ~= u5 then
                    return;
                end;

                for _, v in ipairs(u89) do
                    if v and v.Parent then
                        v.Enabled = false;
                    end;
                end;
            end);
        end;

        local function handleReplayThrowableAlarmPulse(u90, p91) -- Line: 454
            -- upvalues: playReplayThrowableSound (copy), u5 (ref)
            if not u90.Clone then
                return;
            end;

            local v92 = Color3.fromRGB(0, 220, 255);
            local v93 = u90.Clone and u90.Clone:FindFirstChild("Neon");

            if v93 and (v93:IsA("BasePart") and typeof(v92) == "Color3") then
                v93.Color = v92;
            end;

            playReplayThrowableSound(u90.Clone, "Tick", {
                Volume = tonumber(p91.Volume) or 1
            });
            local v94 = tonumber(p91.AlertDuration) or 0.2;
            local v95 = math.max(v94, 0);
            task.delay(v95, function() -- Line: 463
                -- upvalues: u90 (copy), u5 (ref)
                if u90.SessionToken ~= u5 then
                    return;
                end;

                local v96 = u90;
                local v97 = Color3.fromRGB(0, 90, 110);
                local v98 = v96.Clone and v96.Clone:FindFirstChild("Neon");

                if v98 and (v98:IsA("BasePart") and typeof(v97) == "Color3") then
                    v98.Color = v97;
                end;
            end);
        end;

        local function applyReplayThrowableEvent(p99, p100) -- Line: 471
            -- upvalues: setReplayThrowableVisible (copy), applyReplayThrowableAttachmentState (copy), updateReplayThrowableAttachment (copy), handleReplayThrowableDetonation (copy), startReplayThrowableEffect (copy), u48 (ref), handleReplayThrowableDecoyPulse (copy), handleReplayThrowableAlarmPulse (copy)
            local v101;

            if p100 then
                v101 = p100.EventType;
            else
                v101 = p100;
            end;

            if v101 == "Spawn" then
                p99.Exists = true;
                p99.Destroyed = false;
                p99.Attachment = nil;
                p99.AttachedTarget = nil;
                p99.AttachmentOffset = nil;
                p99.StaticCFrame = nil;

                if typeof(p100.CFrame) == "CFrame" then
                    local CFrame2 = p100.CFrame;

                    if p99.Clone and (p99.Clone.Parent ~= nil and typeof(CFrame2) == "CFrame") then
                        p99.WorldCFrame = CFrame2;
                        p99.Clone:PivotTo(CFrame2);
                    end;
                end;

                if p99.Clone then
                    setReplayThrowableVisible(p99, true);
                end;
            else
                if v101 == "StickyResolved" then
                    p99.Exists = true;
                    p99.Destroyed = false;
                    applyReplayThrowableAttachmentState(p99, p100.Attachment, p100.CFrame);

                    if p99.Clone then
                        setReplayThrowableVisible(p99, true);
                    end;

                    updateReplayThrowableAttachment(p99);

                    return;
                end;

                if v101 == "ImpactResolved" then
                    p99.Exists = true;
                    p99.Destroyed = false;
                    p99.Attachment = nil;
                    p99.AttachedTarget = nil;
                    p99.AttachmentOffset = nil;
                    p99.StaticCFrame = typeof(p100.CFrame) == "CFrame" and p100.CFrame or p99.StaticCFrame;

                    if typeof(p100.CFrame) == "CFrame" then
                        local CFrame2 = p100.CFrame;

                        if p99.Clone and (p99.Clone.Parent ~= nil and typeof(CFrame2) == "CFrame") then
                            p99.WorldCFrame = CFrame2;
                            p99.Clone:PivotTo(CFrame2);
                        end;
                    end;

                    if p99.Clone then
                        setReplayThrowableVisible(p99, true);
                    end;
                else
                    if v101 == "Detonate" then
                        handleReplayThrowableDetonation(p99, p100);

                        return;
                    end;

                    if v101 == "EffectStart" then
                        startReplayThrowableEffect(p99, p100, false);

                        return;
                    end;

                    if v101 == "EffectStop" then
                        local EffectName = p100.EffectName;

                        if typeof(EffectName) == "string" and EffectName ~= "" then
                            u48(p99, EffectName);
                        end;
                    else
                        if v101 == "DecoyPulse" then
                            handleReplayThrowableDecoyPulse(p99, p100);

                            return;
                        end;

                        if v101 == "AlarmPulse" then
                            handleReplayThrowableAlarmPulse(p99, p100);

                            return;
                        end;

                        if v101 == "Destroy" then
                            p99.Exists = false;
                            p99.Destroyed = true;
                            p99.Attachment = nil;
                            p99.AttachedTarget = nil;
                            p99.AttachmentOffset = nil;
                            p99.StaticCFrame = nil;

                            if p99.Clone and p99.Clone.Parent then
                                p99.Clone:Destroy();
                            end;

                            p99.Clone = nil;
                            p99.VisibilityMap = {};
                        end;
                    end;
                end;
            end;
        end;

        local function lerpReplayThrowableCFrame(p102, p103, p104) -- Line: 535
            if typeof(p102) ~= "CFrame" then
                return p103;
            end;

            if typeof(p103) == "CFrame" then
                return p102:Lerp(p103, (math.clamp(p104 or 0, 0, 1)));
            end;

            return p102;
        end;

        local function resolveReplayThrowableSampleWindow(p105, p106) -- Line: 545
            if typeof(p105) ~= "table" or #p105 == 0 then
                return nil, nil, 0;
            end;

            local v107 = nil;
            local v108 = nil;

            for i, v in ipairs(p105) do
                if (v.Time or 0) > p106 then
                    v108 = v;
                    break;
                end;

                v108 = p105[i + 1] or v;
                v107 = v;
            end;

            if v107 == nil then
                return nil, v108, 0;
            end;

            local v109 = 0;

            if v107 and (v108 and v107 ~= v108) then
                local v110 = v107.Time or 0;
                local v111 = v108.Time or v110;

                if v110 < v111 then
                    v109 = math.clamp((p106 - v110) / (v111 - v110), 0, 1);
                end;
            end;

            return v107, v108 or v107, v109;
        end;

        local function createReplayThrowableEntry(p112, p113) -- Line: 574
            -- upvalues: ReplicatedStorage (copy), u3 (ref), sanitizeReplayThrowableClone (copy), buildReplayThrowableVisibilityMap (copy), u5 (ref), u4 (copy), applyReplayThrowableAttachmentState (copy), setReplayThrowableVisible (copy), startReplayThrowableEffect (copy)
            if typeof(p113) ~= "table" then
                return nil;
            end;

            local v114;

            if typeof(p113.ModelName) == "string" then
                v114 = p113.ModelName or nil;
            else
                v114 = nil;
            end;

            if not v114 or v114 == "" then
                return nil;
            end;

            local Throwable = ReplicatedStorage.Items:FindFirstChild("Throwable");

            if Throwable then
                Throwable = Throwable:FindFirstChild(v114);
            end;

            if not (Throwable and Throwable:IsA("Model")) then
                Throwable = nil;
            end;

            if not Throwable then
                return nil;
            end;

            if not u3 then
                u3 = Instance.new("Folder");
                u3.Name = "ReplayThrowables";
                u3.Parent = p112;
            end;

            local v115 = Throwable:Clone();
            v115.Name = v114 .. "_Replay";
            sanitizeReplayThrowableClone(v115);
            v115.Parent = u3;
            local Folder = Instance.new("Folder");
            Folder.Name = v115.Name .. "_Runtime";
            Folder.Parent = u3;
            local v116 = {
                EventCursor = 1,
                Exists = false,
                Destroyed = false,
                Hidden = false,
                WorldCFrame = nil,
                StaticCFrame = nil,
                Attachment = nil,
                AttachedTarget = nil,
                AttachmentOffset = nil,
                ReplayId = p113.ReplayId,
                ModelName = v114,
                OwnerUserId = tonumber(p113.OwnerUserId) or 0,
                OwnerName = p113.OwnerName,
                Template = Throwable,
                Clone = v115,
                RuntimeFolder = Folder,
                VisibilityMap = buildReplayThrowableVisibilityMap(v115),
                Samples = typeof(p113.Samples) == "table" and (p113.Samples or {}) or {},
                Events = typeof(p113.Events) == "table" and (p113.Events or {}) or {},
                ActiveEffects = {},
                SessionToken = u5
            };
            u4[p113.ReplayId or v114] = v116;
            local v117;

            if typeof(p113.InitialState) == "table" then
                v117 = p113.InitialState or nil;
            else
                v117 = nil;
            end;

            if v117 then
                v116.Exists = v117.Exists == true;
                v116.Hidden = v117.Hidden == true;

                if typeof(v117.CFrame) == "CFrame" then
                    local CFrame2 = v117.CFrame;

                    if v116.Clone and (v116.Clone.Parent ~= nil and typeof(CFrame2) == "CFrame") then
                        v116.WorldCFrame = CFrame2;
                        v116.Clone:PivotTo(CFrame2);
                    end;
                end;

                if typeof(v117.Attachment) == "table" then
                    applyReplayThrowableAttachmentState(v116, v117.Attachment, v117.CFrame);
                end;

                if v116.Clone then
                    local v118;

                    if v116.Exists == true then
                        v118 = v116.Hidden ~= true;
                    else
                        v118 = false;
                    end;

                    setReplayThrowableVisible(v116, v118);
                end;

                local v119;

                if typeof(v117.ActiveEffects) == "table" then
                    v119 = v117.ActiveEffects or nil;
                else
                    v119 = nil;
                end;

                if v119 then
                    for _, v in pairs(v119) do
                        startReplayThrowableEffect(v116, v, true);
                    end;

                    return v116;
                end;
            else
                setReplayThrowableVisible(v116, false);
            end;

            return v116;
        end;

        function u2.Clear() -- Line: 647
            -- upvalues: u5 (ref), u4 (copy), u48 (ref), u3 (ref)
            u5 = u5 + 1;

            for _, v in pairs(u4) do
                for i, _ in pairs(v.ActiveEffects or {}) do
                    u48(v, i);
                end;

                if v.RuntimeFolder and v.RuntimeFolder.Parent then
                    v.RuntimeFolder:Destroy();
                end;

                if v.Clone and v.Clone.Parent then
                    v.Clone:Destroy();
                end;

                v.Clone = nil;
            end;

            if u3 then
                u3:Destroy();
                u3 = nil;
            end;

            table.clear(u4);
        end;

        function u2.Build(p120, p121) -- Line: 668
            -- upvalues: u2 (copy), createReplayThrowableEntry (copy)
            u2.Clear();

            if p121 then
                p121 = p121.Throwables;
            end;

            if typeof(p121) ~= "table" then
                return;
            end;

            for _, v in ipairs(p121) do
                createReplayThrowableEntry(p120, v);
            end;
        end;

        function u2.Update(p122) -- Line: 679
            -- upvalues: u4 (copy), applyReplayThrowableEvent (copy), updateReplayThrowableAttachment (copy), resolveReplayThrowableSampleWindow (copy), setReplayThrowableVisible (copy)
            for _, v in pairs(u4) do
                local Events = v.Events;

                while v.EventCursor <= #Events do
                    local v123;

                    if v.EventCursor <= #Events then
                        v123 = Events[v.EventCursor] or nil;
                    else
                        v123 = nil;
                    end;

                    if not v123 or p122 < (v123.Time or 0) then
                        break;
                    end;

                    applyReplayThrowableEvent(v, v123);
                    v.EventCursor = v.EventCursor + 1;
                end;

                if v.Clone and (v.Clone.Parent and (v.Exists == true and (v.Destroyed ~= true and updateReplayThrowableAttachment(v) ~= true))) then
                    local v124, v125, v126 = resolveReplayThrowableSampleWindow(v.Samples, p122);

                    if v124 and typeof(v124.CFrame) == "CFrame" then
                        v.Exists = true;
                        local v127 = v125 and v125.CFrame or v124.CFrame;
                        local CFrame2 = v124.CFrame;

                        if typeof(CFrame2) == "CFrame" then
                            if typeof(v127) == "CFrame" then
                                CFrame2 = CFrame2:Lerp(v127, (math.clamp(v126 or 0, 0, 1)));
                            end;
                        else
                            CFrame2 = v127;
                        end;

                        if v.Clone and (v.Clone.Parent ~= nil and typeof(CFrame2) == "CFrame") then
                            v.WorldCFrame = CFrame2;
                            v.Clone:PivotTo(CFrame2);
                        end;

                        setReplayThrowableVisible(v, v.Hidden ~= true);
                    end;
                end;
            end;
        end;

        return u2;
    end
};