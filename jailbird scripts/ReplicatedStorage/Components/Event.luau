
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Shop = require(ReplicatedStorage.Components.Shop);
local Config = require(ReplicatedStorage.Config);
local u1 = {
    General = {
        EventActive = true,
        DefaultCurrencyImage = "rbxassetid://131122717935621",
        OnlineTimeTick = 1,
        EventTimeZoneOffsetHours = 8,
        UseUTCReset = true
    },
    Events = {
        CrimsonEvent = {
            EventId = "CrimsonEvent",
            EventName = "Crimson Event",
            EventImage = "rbxassetid://18930990669",
            CurrencyName = "Crimson Token",
            CurrencyAttribute = "CrimsonToken",
            CurrencyImage = "rbxassetid://131122717935621",
            EndGameCurrencyBonus = 100,
            StartDate = {
                Year = 2026,
                Month = 5,
                Day = 22,
                Hour = 23,
                Minute = 0,
                Second = 0
            },
            EndDate = {
                Year = 2026,
                Month = 6,
                Day = 5,
                Hour = 10,
                Minute = 0,
                Second = 0
            },
            CurrencyColor = Color3.fromRGB(240, 20, 30),
            EndGameRewardEvent = { {
                    Name = "Crimson",
                    Type = "Crate",
                    Amount = 1,
                    Rarity = "Epic",
                    Chance = 400
                }, {
                    Name = "CrimsonToken",
                    Type = "EventCurrency",
                    Amount = 150,
                    Rarity = "Epic",
                    Chance = 500
                } },
            Shop = { {
                    Name = "Crimsoned",
                    Type = "Title",
                    Amount = 1,
                    Cost = 2000
                }, {
                    Name = "Moon Wolf",
                    Type = "Charm",
                    Amount = 1,
                    Cost = 4000
                }, {
                    Name = "Crimson Operator",
                    Type = "Bottom",
                    Amount = 1,
                    Cost = 5000
                }, {
                    Name = "Crimson Operator",
                    Type = "Top",
                    Amount = 1,
                    Cost = 5000
                }, {
                    Name = "Crimson Operator",
                    Type = "Head",
                    Amount = 1,
                    Cost = 20000
                }, {
                    Name = "Crimson Eyeball",
                    Type = "Charm",
                    Amount = 1,
                    Cost = 18000
                }, {
                    Name = "Crow Bayonet",
                    Type = "Knife",
                    Amount = 1,
                    Cost = 35000
                }, {
                    Name = "Moon Raven",
                    Type = "Banner",
                    Amount = 1,
                    Cost = 25000
                }, {
                    Name = "Qrimson",
                    Type = "Bottom",
                    Amount = 1,
                    Cost = 10000
                }, {
                    Name = "Qrimson",
                    Type = "Top",
                    Amount = 1,
                    Cost = 10000
                }, {
                    Name = "Qrimson",
                    Type = "Head",
                    Amount = 1,
                    Cost = 40000
                }, {
                    Name = "Qrimson Karambit",
                    Type = "Knife",
                    Amount = 1,
                    Cost = 85000
                } },
            Claimables = { {
                    Time = 900,
                    Name = "Crimson Token",
                    Type = "EventCurrency",
                    Amount = 1000
                }, {
                    Time = 1800,
                    Name = "Crimson Token",
                    Type = "EventCurrency",
                    Amount = 1500
                }, {
                    Time = 3600,
                    Name = "Crimson Token",
                    Type = "EventCurrency",
                    Amount = 2000
                }, {
                    Time = 5400,
                    Name = "Crimson Token",
                    Type = "EventCurrency",
                    Amount = 2500
                }, {
                    Time = 7200,
                    Name = "Crimson Token",
                    Type = "EventCurrency",
                    Amount = 3500
                } }
        },
        BlackCellEvent = {
            EventId = "BlackCellEvent",
            EventName = "Black Cell Event",
            EventImage = "rbxassetid://80508951213641",
            CurrencyName = "Black Cell",
            CurrencyAttribute = "BlackCell",
            CurrencyImage = "rbxassetid://70434241866780",
            EndGameCurrencyBonus = 100,
            StartDate = {
                Year = 2026,
                Month = 6,
                Day = 26,
                Hour = 23,
                Minute = 0,
                Second = 0
            },
            EndDate = {
                Year = 2026,
                Month = 7,
                Day = 17,
                Hour = 10,
                Minute = 0,
                Second = 0
            },
            CurrencyColor = Color3.fromRGB(0, 160, 240),
            EndGameRewardEvent = { {
                    Name = "Cell-X",
                    Type = "Crate",
                    Amount = 1,
                    Rarity = "Epic",
                    Chance = 400
                }, {
                    Name = "BlackCell",
                    Type = "EventCurrency",
                    Amount = 150,
                    Rarity = "Epic",
                    Chance = 500
                } },
            Shop = { {
                    Name = "Cell-X Certified",
                    Type = "Title",
                    Amount = 1,
                    Cost = 2000
                }, {
                    Name = "Flying Fish",
                    Type = "Charm",
                    Amount = 1,
                    Cost = 5000
                }, {
                    Name = "Cell-X Defender",
                    Type = "Bottom",
                    Amount = 1,
                    Cost = 5000
                }, {
                    Name = "Cell-X Defender",
                    Type = "Top",
                    Amount = 1,
                    Cost = 5000
                }, {
                    Name = "Cell-X Defender",
                    Type = "Head",
                    Amount = 1,
                    Cost = 20000
                }, {
                    Name = "Egg Cell",
                    Type = "Charm",
                    Amount = 1,
                    Cost = 10000
                }, {
                    Name = "Tasty Cell",
                    Type = "Charm",
                    Amount = 1,
                    Cost = 15000
                }, {
                    Name = "Cell Domain",
                    Type = "Banner",
                    Amount = 1,
                    Cost = 25000
                }, {
                    Name = "Black Cell",
                    Type = "Bottom",
                    Amount = 1,
                    Cost = 10000
                }, {
                    Name = "Black Cell",
                    Type = "Top",
                    Amount = 1,
                    Cost = 10000
                }, {
                    Name = "Black Cell",
                    Type = "Head",
                    Amount = 1,
                    Cost = 40000
                }, {
                    Name = "DNATech",
                    Type = "Skin",
                    Weapon = "M4A1",
                    Amount = 1,
                    Cost = 40000
                }, {
                    Name = "Black Cell Bayonet",
                    Type = "Knife",
                    Amount = 1,
                    Cost = 90000
                } },
            Claimables = { {
                    Time = 900,
                    Name = "Black Cell",
                    Type = "EventCurrency",
                    Amount = 1000
                }, {
                    Time = 1800,
                    Name = "Black Cell",
                    Type = "EventCurrency",
                    Amount = 1500
                }, {
                    Time = 3600,
                    Name = "Black Cell",
                    Type = "EventCurrency",
                    Amount = 2000
                }, {
                    Time = 5400,
                    Name = "Black Cell",
                    Type = "EventCurrency",
                    Amount = 2500
                }, {
                    Time = 7200,
                    Name = "Black Cell",
                    Type = "EventCurrency",
                    Amount = 4000
                } }
        }
    }
};

function u1.GetUnixTimeFromDate(p2) -- Line: 344
    -- upvalues: u1 (copy)
    if not p2 then
        return 0;
    end;

    local v3 = (u1.General.EventTimeZoneOffsetHours or 0) * 3600;

    return os.time({
        year = p2.Year or 1970,
        month = p2.Month or 1,
        day = p2.Day or 1,
        hour = p2.Hour or 0,
        min = p2.Minute or 0,
        sec = p2.Second or 0
    }) - v3;
end;

function u1.GetCurrentDay() -- Line: 361
    local v4 = os.time() / 86400;

    return math.floor(v4);
end;

function u1.GetTimeUntilTomorrow() -- Line: 365
    -- upvalues: u1 (copy)
    local v5 = os.time();
    local v6 = (u1.GetCurrentDay() + 1) * 86400 - v5;

    return math.max(0, v6);
end;

function u1.FormatHMS(p7) -- Line: 371
    local v8 = math.floor(p7 or 0);
    local v9 = math.max(0, v8);
    local v10 = math.floor(v9 / 3600);
    local v11 = math.floor(v9 % 3600 / 60);

    return string.format("%02d:%02d:%02d", v10, v11, v9 % 60);
end;

function u1.FormatNumber(p12) -- Line: 381
    local v13 = tonumber(p12) or 0;
    local match = string.match;
    local v14 = math.floor(v13);
    local v15, v16, v17 = match(tostring(v14), "^([^%d]*%d)(%d*)(.-)$");

    return v15 .. v16:reverse():gsub("(%d%d%d)", "%1,"):reverse() .. v17;
end;

function u1.GetEventById(p18) -- Line: 392
    -- upvalues: u1 (copy)
    if p18 then
        return u1.Events[p18];
    end;

    return nil;
end;

function u1.IsEventActive(p19) -- Line: 400
    -- upvalues: u1 (copy)
    if not u1.General.EventActive then
        return false;
    end;

    if not p19 then
        return false;
    end;

    local v20 = os.time();
    local v21 = u1.GetUnixTimeFromDate(p19.StartDate);
    local v22 = u1.GetUnixTimeFromDate(p19.EndDate);
    local v23;

    if v21 <= v20 then
        v23 = v20 <= v22;
    else
        v23 = false;
    end;

    return v23;
end;

function u1.GetCurrentEvent() -- Line: 416
    -- upvalues: u1 (copy)
    if not u1.General.EventActive then
        return nil;
    end;

    for _, v in pairs(u1.Events) do
        if u1.IsEventActive(v) then
            return v;
        end;
    end;

    return nil;
end;

function u1.IsCurrentEvent(p24) -- Line: 430
    -- upvalues: u1 (copy)
    local v25 = u1.GetCurrentEvent();

    if v25 then
        return v25.EventId == p24;
    end;

    return false;
end;

function u1.GetCurrencyImage(p26) -- Line: 439
    -- upvalues: u1 (copy)
    if p26 and p26.CurrencyImage then
        return p26.CurrencyImage;
    end;

    return u1.General.DefaultCurrencyImage;
end;

function u1.GetShopItem(p27, p28) -- Line: 447
    if not p27 then
        return nil;
    end;

    local v29 = tonumber(p28);

    if not v29 then
        return nil;
    end;

    if p27.Shop then
        return p27.Shop[v29];
    end;

    return nil;
end;

function u1.GetClaimable(p30, p31) -- Line: 464
    if not p30 then
        return nil;
    end;

    local v32 = tonumber(p31);

    if not v32 then
        return nil;
    end;

    if p30.Claimables then
        return p30.Claimables[v32];
    end;

    return nil;
end;

function u1.GetEventFolder(p33) -- Line: 485
    if not p33 then
        return nil;
    end;

    local PlayerData = p33:FindFirstChild("PlayerData");

    if not PlayerData then
        return nil;
    end;

    local Event = PlayerData:FindFirstChild("Event");

    if not Event then
        Event = Instance.new("Folder");
        Event.Name = "Event";
        Event.Parent = PlayerData;
    end;

    return Event;
end;

function u1.GetClaimAttribute(p34, p35) -- Line: 505
    if p34 then
        return tostring(p34.EventId) .. "_Claim_" .. tostring(p35);
    end;

    return nil;
end;

function u1.SetupEventFolder(p36, p37) -- Line: 513
    -- upvalues: u1 (copy)
    local v38 = u1.GetEventFolder(p36);

    if not v38 then
        return;
    end;

    if v38:GetAttribute("EventDay") == nil then
        v38:SetAttribute("EventDay", u1.GetCurrentDay());
    end;

    if v38:GetAttribute("OnlineTime") == nil then
        v38:SetAttribute("OnlineTime", 0);
    end;

    if p37 then
        local CurrencyAttribute = p37.CurrencyAttribute;

        if CurrencyAttribute and v38:GetAttribute(CurrencyAttribute) == nil then
            v38:SetAttribute(CurrencyAttribute, 0);
        end;

        for i, _ in ipairs(p37.Claimables or {}) do
            local v39 = u1.GetClaimAttribute(p37, i);

            if v39 and v38:GetAttribute(v39) == nil then
                v38:SetAttribute(v39, false);
            end;
        end;
    end;
end;

function u1.ResetDailyEventData(p40, p41) -- Line: 543
    -- upvalues: u1 (copy)
    local v42 = u1.GetEventFolder(p40);

    if not v42 then
        return;
    end;

    v42:SetAttribute("EventDay", u1.GetCurrentDay());
    v42:SetAttribute("OnlineTime", 0);

    if p41 then
        for i, _ in ipairs(p41.Claimables or {}) do
            local v43 = u1.GetClaimAttribute(p41, i);

            if v43 then
                v42:SetAttribute(v43, false);
            end;
        end;
    end;
end;

function u1.CheckDailyReset(p44, p45) -- Line: 563
    -- upvalues: u1 (copy)
    local v46 = u1.GetEventFolder(p44);

    if not v46 then
        return;
    end;

    if u1.GetCurrentDay() ~= v46:GetAttribute("EventDay") then
        u1.ResetDailyEventData(p44, p45);
    end;
end;

function u1.GetPlayerCurrency(p47, p48) -- Line: 581
    -- upvalues: u1 (copy)
    local v49 = u1.GetEventFolder(p47);

    if not v49 then
        return 0;
    end;

    if not p48 then
        return 0;
    end;

    local CurrencyAttribute = p48.CurrencyAttribute;

    return CurrencyAttribute and (v49:GetAttribute(CurrencyAttribute) or 0) or 0;
end;

function u1.SetPlayerCurrency(p50, p51, p52) -- Line: 599
    -- upvalues: u1 (copy)
    local v53 = u1.GetEventFolder(p50);

    if not v53 then
        return;
    end;

    if not p52 then
        return;
    end;

    local CurrencyAttribute = p52.CurrencyAttribute;

    if not CurrencyAttribute then
        return;
    end;

    local v54 = math.floor(p51 or 0);
    v53:SetAttribute(CurrencyAttribute, (math.max(0, v54)));
end;

function u1.RewardEventCurrency(p55, p56, p57) -- Line: 617
    -- upvalues: u1 (copy)
    local v58 = p57 or u1.GetCurrentEvent();

    if not v58 then
        return false;
    end;

    local v59 = u1.GetPlayerCurrency(p55, v58);
    u1.SetPlayerCurrency(p55, v59 + math.floor(p56 or 0), v58);

    return true;
end;

function u1.TakeEventCurrency(p60, p61, p62) -- Line: 629
    -- upvalues: u1 (copy)
    local v63 = p62 or u1.GetCurrentEvent();

    if not v63 then
        return false;
    end;

    local v64 = math.floor(p61 or 0);
    local v65 = u1.GetPlayerCurrency(p60, v63);

    if v65 < v64 then
        return false;
    end;

    u1.SetPlayerCurrency(p60, v65 - v64, v63);

    return true;
end;

function u1.CanAfford(p66, p67, p68) -- Line: 647
    -- upvalues: u1 (copy)
    return math.floor(p68 or 0) <= u1.GetPlayerCurrency(p66, p67);
end;

function u1.HasClaimed(p69, p70, p71) -- Line: 657
    -- upvalues: u1 (copy)
    local v72 = u1.GetEventFolder(p69);

    if not v72 then
        return false;
    end;

    local v73 = u1.GetClaimAttribute(p70, p71);

    if v73 then
        return v72:GetAttribute(v73) == true;
    end;

    return false;
end;

function u1.MarkClaimed(p74, p75, p76) -- Line: 671
    -- upvalues: u1 (copy)
    local v77 = u1.GetEventFolder(p74);

    if not v77 then
        return;
    end;

    local v78 = u1.GetClaimAttribute(p75, p76);

    if not v78 then
        return;
    end;

    v77:SetAttribute(v78, true);
end;

function u1.CanClaim(p79, p80, p81, p82) -- Line: 685
    -- upvalues: u1 (copy)
    local v83 = u1.GetEventFolder(p79);

    if not v83 then
        return false, "Missing event folder";
    end;

    if not (p80 and p81) then
        return false, "Invalid event reward";
    end;

    if not u1.IsCurrentEvent(p80.EventId) then
        return false, "Event is not active";
    end;

    if u1.HasClaimed(p79, p80, p82) then
        return false, "Already claimed";
    end;

    if (v83:GetAttribute("OnlineTime") or 0) < (p81.Time or 0) then
        return false, "Not enough online time";
    end;

    return true;
end;

function u1.GetClaimState(p84, p85, p86, p87) -- Line: 711
    -- upvalues: u1 (copy)
    if u1.HasClaimed(p84, p85, p87) then
        return "Claimed";
    end;

    local v88 = u1.GetEventFolder(p84);

    return v88 and ((v88:GetAttribute("OnlineTime") or 0) >= (p86.Time or 0) and "Ready" or "NotReady") or "Locked";
end;

function u1.Notify(p89, p90) -- Line: 734
    -- upvalues: ReplicatedStorage (copy)
    local Events = ReplicatedStorage:FindFirstChild("Events");

    if not Events then
        return;
    end;

    local Action = Events:FindFirstChild("Action");

    if not Action then
        return;
    end;

    Action:FireClient(p89, "Notification", {
        Message = p90
    });
end;

function u1.HandleClaimEventReward(p91, p92) -- Line: 754
    -- upvalues: u1 (copy)
    if typeof(p92) ~= "table" then
        return;
    end;

    local EventId = p92.EventId;
    local v93 = tonumber(p92.Index);

    if not (EventId and v93) then
        return;
    end;

    if not u1.IsCurrentEvent(EventId) then
        u1.Notify(p91, "Event is not active");

        return;
    end;

    local v94 = u1.GetEventById(EventId);
    local v95 = u1.GetClaimable(v94, v93);

    if not (v94 and v95) then
        u1.Notify(p91, "Invalid event reward");

        return;
    end;

    u1.SetupEventFolder(p91, v94);
    u1.CheckDailyReset(p91, v94);
    local v96, v97 = u1.CanClaim(p91, v94, v95, v93);

    if not v96 then
        u1.Notify(p91, v97 or "Cannot claim");

        return;
    end;

    if v95.Type == "EventCurrency" then
        u1.RewardEventCurrency(p91, v95.Amount, v94);
    end;

    u1.MarkClaimed(p91, v94, v93);
    u1.Notify(p91, "Claimed " .. u1.FormatNumber(v95.Amount or 0) .. " " .. (v94.CurrencyName or "Currency"));
end;

function u1.PlayerOwnsShopItem(p98, p99) -- Line: 797
    -- upvalues: Config (copy)
    local v100 = Config.GetItemIDFromItemData(p99);
    local v101 = p98.PlayerData.Inventory:FindFirstChild(v100);

    return v101 and (v101:GetAttribute("Name") == p99.Name and v101:GetAttribute("Type") == p99.Type) and true or false;
end;

function u1.HandleBuyEventShopItem(p102, p103) -- Line: 807
    -- upvalues: u1 (copy), Shop (copy), Config (copy), ReplicatedStorage (copy)
    if typeof(p103) ~= "table" then
        return;
    end;

    local EventId = p103.EventId;
    local v104 = tonumber(p103.Index);

    if not (EventId and v104) then
        return;
    end;

    if not u1.IsCurrentEvent(EventId) then
        u1.Notify(p102, "Event is not active");

        return;
    end;

    local v105 = u1.GetEventById(EventId);
    local v106 = u1.GetShopItem(v105, v104);

    if not (v105 and v106) then
        u1.Notify(p102, "Invalid event item");

        return;
    end;

    u1.SetupEventFolder(p102, v105);
    u1.CheckDailyReset(p102, v105);

    if not u1.CanAfford(p102, v105, v106.Cost) then
        u1.Notify(p102, "Not enough " .. (v105.CurrencyName or "currency"));

        return;
    end;

    if u1.PlayerOwnsShopItem(p102, v106) then
        u1.Notify(p102, "You own this item");

        return;
    end;

    u1.TakeEventCurrency(p102, v106.Cost, v105);
    Shop.GiveItem(p102, v106);
    Config.AddItemsLog(p102, v106, true);
    ReplicatedStorage.Events.Action:FireClient(p102, "ItemsLog");
end;

function u1.StartOnlineTimeLoop(u107) -- Line: 859
    -- upvalues: u1 (copy)
    task.spawn(function() -- Line: 860
        -- upvalues: u107 (copy), u1 (ref)
        while u107 and u107.Parent do
            local v108 = u1.GetCurrentEvent();

            if v108 then
                u1.SetupEventFolder(u107, v108);
                u1.CheckDailyReset(u107, v108);
                local v109 = u1.GetEventFolder(u107);

                if v109 then
                    v109:SetAttribute("OnlineTime", (v109:GetAttribute("OnlineTime") or 0) + u1.General.OnlineTimeTick);
                end;
            end;

            task.wait(u1.General.OnlineTimeTick);
        end;
    end);
end;

local u110 = false;

function u1.ConfigServer() -- Line: 887
    -- upvalues: u110 (ref), RunService (copy), ReplicatedStorage (copy), u1 (copy), Players (copy)
    if u110 then
        warn("[Event] ConfigServer already ran.");

        return;
    end;

    if not RunService:IsServer() then
        warn("[Event] ConfigServer can only run on server.");

        return;
    end;

    u110 = true;
    local Action = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Action");

    local function SetupPlayer(p111) -- Line: 903
        -- upvalues: u1 (ref)
        local PlayerData = p111:WaitForChild("PlayerData", 30);

        if not PlayerData then
            return;
        end;

        if not PlayerData:FindFirstChild("Event") then
            local Folder = Instance.new("Folder");
            Folder.Name = "Event";
            Folder.Parent = PlayerData;
        end;

        local v112 = u1.GetCurrentEvent();

        if v112 then
            u1.SetupEventFolder(p111, v112);
            u1.CheckDailyReset(p111, v112);
        end;

        u1.StartOnlineTimeLoop(p111);
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        task.spawn(SetupPlayer, v);
    end;

    Players.PlayerAdded:Connect(function(p113) -- Line: 929
        -- upvalues: SetupPlayer (copy)
        task.spawn(SetupPlayer, p113);
    end);
    Action.OnServerEvent:Connect(function(p114, p115, p116) -- Line: 933
        -- upvalues: u1 (ref)
        if p115 == "ClaimEventReward" then
            u1.HandleClaimEventReward(p114, p116);

            return;
        end;

        if p115 ~= "BuyEventShopItem" then
            return;
        end;

        u1.HandleBuyEventShopItem(p114, p116);
    end);
    print("[Event] Server configured.");
end;

return u1;