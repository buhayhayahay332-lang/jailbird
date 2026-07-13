
local HttpService = game:GetService("HttpService");
local Backup = require(script:WaitForChild("Backup"));
local PropertyEdgeCases = require(script:WaitForChild("PropertyEdgeCases"));

return {
    fetchCache = nil,
    ignoredTags = {
        ReadOnly = true,
        Hidden = true,
        Deprecated = true
    },
    fromClassCache = {},
    subclassesFromCache = {},
    membersFromCache = {},
    propertiesFromCache = {},
    instanceCache = {},

    fetch = function(p1, p2) -- Line: 25, Name: fetch
        -- upvalues: HttpService (copy), Backup (copy)
        if not p2 and p1.fetchCache then
            return p1.fetchCache;
        end;

        local success, result = pcall(function() -- Line: 31
            -- upvalues: HttpService (ref)
            return HttpService:JSONDecode(HttpService:GetAsync("https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/API-Dump.json"));
        end);

        if not success then
            result = Backup;
            p1.usingBackup = true;
        end;

        p1.fetchCache = result;
        table.clear(p1.fromClassCache);
        table.clear(p1.subclassesFromCache);
        table.clear(p1.membersFromCache);
        table.clear(p1.propertiesFromCache);
        table.clear(p1.instanceCache);

        return result;
    end,

    fromClass = function(p3, p4) -- Line: 53, Name: fromClass
        local v5 = p3.fromClassCache[p4];

        if v5 then
            return v5;
        end;

        for _, v in p3:fetch().Classes do
            if v.Name == p4 then
                p3.fromClassCache[p4] = v;

                return v;
            end;
        end;
    end,

    subclassesFromClass = function(p6, p7) -- Line: 70, Name: subclassesFromClass
        local v8 = p6.subclassesFromCache[p7];

        if v8 then
            return v8;
        end;

        local v9 = {};

        for _, v in p6:fetch().Classes do
            if v.Superclass == p7 then
                table.insert(v9, v);
            end;
        end;

        p6.subclassesFromCache[p7] = v9;

        return v9;
    end,

    membersFromClass = function(p10, p11) -- Line: 91, Name: membersFromClass
        local v12 = p10.membersFromCache[p11];

        if v12 then
            return v12;
        end;

        local v13 = p10:fromClass(p11);
        local v14 = {};
        local v15 = {};

        while v13 and v13.Superclass ~= "<<<ROOT>>>" do
            table.insert(v14, 1, v13);
            v13 = p10:fromClass(v13.Superclass);
        end;

        table.insert(v14, 1, v13);

        if not v13 then
            error(`{p11} doesn't exist`, 2);
        end;

        for i = 1, #v14 do
            local Members = v14[i].Members;

            for i2 = 1, #Members do
                table.insert(v15, Members[i2]);
            end;
        end;

        p10.membersFromCache[p11] = v15;

        return v15;
    end,

    propertiesFromClass = function(p16, p17) -- Line: 119, Name: propertiesFromClass
        local v18 = p16.propertiesFromCache[p17];

        if v18 then
            return v18;
        end;

        local v19 = p16:membersFromClass(p17);
        local v20 = {};

        for i = 1, #v19 do
            local v21 = v19[i];

            if v21.MemberType == "Property" then
                local v22 = true;

                if v21.Tags then
                    local Tags = v21.Tags;

                    for i2 = 1, #Tags do
                        if p16.ignoredTags[Tags[i2]] then
                            v22 = false;
                            break;
                        end;
                    end;
                end;

                if v22 then
                    table.insert(v20, v21.Name);
                end;
            end;
        end;

        p16.propertiesFromCache[p17] = v20;

        return v20;
    end,

    propertiesFromInstance = function(p23, u24, p25) -- Line: 156, Name: propertiesFromInstance
        -- upvalues: PropertyEdgeCases (copy)
        local ClassName = u24.ClassName;
        local v26 = p23:propertiesFromClass(ClassName);
        local v27 = {};

        if not (p25 or p23.instanceCache[ClassName]) then
            local success, result = pcall(function() -- Line: 163
                -- upvalues: ClassName (copy)
                return Instance.new(ClassName);
            end);

            if success then
                p23.instanceCache[ClassName] = result;
            end;
        end;

        local u28 = p25 or p23.instanceCache[ClassName];

        for i = 1, #v26 do
            local u29 = v26[i];
            local v30 = PropertyEdgeCases[u29];
            local v31, v32;

            if v30 then
                local v33 = 0;

                for i2 = 1, #v30 do
                    if table.find(v26, v30[i2]) then
                        v33 = v33 + 1;
                    end;
                end;

                if v33 ~= #v30 then
                    v31, v32 = pcall(function() -- Line: 190
                        -- upvalues: u28 (ref), u29 (copy), u24 (copy)
                        return u28[u29] == u24[u29];
                    end);

                    if v31 and not v32 then
                        table.insert(v27, u29);
                    end;
                end;
            else
                v31, v32 = pcall(function() -- Line: 190
                    -- upvalues: u28 (ref), u29 (copy), u24 (copy)
                    return u28[u29] == u24[u29];
                end);

                if v31 and not v32 then
                    table.insert(v27, u29);
                end;
            end;
        end;

        return v27, v26;
    end
};