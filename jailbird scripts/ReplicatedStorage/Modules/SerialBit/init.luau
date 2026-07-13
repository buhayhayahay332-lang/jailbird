
local BuffDatatypes = require(script:WaitForChild("BuffDatatypes"));
local Dump = require(script:WaitForChild("Dump"));
local Base91 = require(script:WaitForChild("Base91"));
local LibDeflate = require(script:WaitForChild("LibDeflate"));
local v1 = {};
local u2 = {
    CompressionLevel = 9,
    Encode = true
};

function v1.serialize(p3, p4) -- Line: 13
    -- upvalues: u2 (copy), Dump (copy), BuffDatatypes (copy), LibDeflate (copy), Base91 (copy)
    local v5 = p4 or u2;

    for i, v in u2 do
        if v5[i] == nil then
            v5[i] = v;
        end;
    end;

    local v6 = p3:GetDescendants();
    table.insert(v6, p3);
    local v7 = {};

    for i, v in ipairs(v6) do
        v7[v] = i;
    end;

    local v8 = {};
    local v9 = 0;
    local v10 = {};
    local v11 = 0;

    for i, v in ipairs(v6) do
        local v12 = #v.ClassName + 2;
        local v13 = {};

        for _, v2 in Dump:propertiesFromInstance(v) do
            local success, result = pcall(function() -- Line: 40
                -- upvalues: v (copy), v2 (copy)
                return v[v2];
            end);

            if success then
                local v14 = BuffDatatypes.types.toTypeValue((typeof(result)));
                local v15, v16;

                if typeof(result) == "Instance" then
                    if v7[result] then
                        result = v7[result];
                        v14 = 255;

                        if v14 then
                            v15 = table.find(v8, v2);

                            if not v15 then
                                table.insert(v8, v2);
                                v15 = #v8;
                            end;

                            v16 = BuffDatatypes.serialize(result);
                            v13[v15] = { v16, v14 };
                            v12 = v12 + (buffer.len(v16) + 3);
                        end;
                    end;
                elseif v14 then
                    v15 = table.find(v8, v2);

                    if not v15 then
                        table.insert(v8, v2);
                        v15 = #v8;
                    end;

                    v16 = BuffDatatypes.serialize(result);
                    v13[v15] = { v16, v14 };
                    v12 = v12 + (buffer.len(v16) + 3);
                end;
            end;
        end;

        v9 = v9 + v12;
        table.insert(v10, v13);
        v11 = v11 + 1;

        if i % 600 == 0 then
            task.wait(0.01);
        end;
    end;

    local v17 = buffer.create(v9);
    local v18 = 0;

    for i, v in ipairs(v10) do
        local v19 = v6[i];
        local v20 = #v19.ClassName;
        buffer.writeu8(v17, v18 + 1, v20);
        buffer.writestring(v17, v18 + 2, v19.ClassName);
        local v21 = v18 + (v20 + 2);
        local v22 = 0;

        for i2, v2 in v do
            v22 = v22 + 1;
            local v23 = buffer.len(v2[1]);
            buffer.writeu8(v17, v21, v23);
            buffer.writeu8(v17, v21 + 1, i2);
            buffer.writeu8(v17, v21 + 2, v2[2]);
            buffer.copy(v17, v21 + 3, v2[1]);
            v21 = v21 + (v23 + 3);
        end;

        buffer.writeu8(v17, v18, v22);

        if i % 700 == 0 then
            task.wait(0.01);
            v18 = v21;
        else
            v18 = v21;
        end;
    end;

    local v24 = 1;

    for _, v in v8 do
        v24 = v24 + (#v + 1);
    end;

    local v25 = buffer.create(v24);
    local v26 = 1;

    for _, v in ipairs(v8) do
        buffer.writeu8(v25, v26, #v);
        buffer.writestring(v25, v26 + 1, v);
        v26 = v26 + (#v + 1);
    end;

    buffer.writeu8(v25, 0, #v8);
    local v27 = buffer.tostring(v25) .. string.pack("I4", v11) .. buffer.tostring(v17);

    if v5.CompressionLevel > 0 then
        v27 = LibDeflate.Zlib.Compress(v27, {
            level = v5.CompressionLevel
        });
    end;

    if v5.Encode then
        v27 = Base91.encode(v27);
    end;

    return v27;
end;

function v1.reconstruct(u28) -- Line: 123
    -- upvalues: Base91 (copy), LibDeflate (copy), BuffDatatypes (copy)
    local v29 = true;

    for i = 1, #u28 do
        if not ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~\""):find(u28:sub(i, i), 1, true) then
            v29 = false;
        end;
    end;

    if v29 then
        pcall(function() -- Line: 132
            -- upvalues: u28 (ref), Base91 (ref)
            u28 = Base91.decode(u28);
        end);
    end;

    if #u28 > 1 and (u28:byte(1) == 120 and u28:byte(2) == 156) then
        pcall(function() -- Line: 137
            -- upvalues: u28 (ref), LibDeflate (ref)
            u28 = LibDeflate.Zlib.Decompress(u28);
        end);
    end;

    local v30 = buffer.fromstring(u28);
    local v31 = 1;
    local v32 = {};

    for i = 1, buffer.readu8(v30, 0) do
        local v33 = buffer.readu8(v30, v31);
        v32[i] = buffer.readstring(v30, v31 + 1, v33);
        v31 = v31 + (v33 + 1);
    end;

    local v34 = buffer.readu32(v30, v31);
    local v35 = v31 + 4;
    local v36 = {};
    local v37 = {};

    for i = 1, v34 do
        local v38 = buffer.readu8(v30, v35);
        local v39 = buffer.readu8(v30, v35 + 1);
        local v40 = buffer.readstring(v30, v35 + 2, v39);
        v35 = v35 + (v39 + 2);
        local v41 = {};

        for _ = 1, v38 do
            local v42 = buffer.readu8(v30, v35);
            local v43 = buffer.readu8(v30, v35 + 1);
            local v44 = buffer.readu8(v30, v35 + 2);
            local v45 = buffer.create(v42);
            buffer.copy(v45, 0, v30, v35 + 3, v42);
            v35 = v35 + (v42 + 3);
            local v46;

            if v44 == 255 then
                v46 = "INST_" .. BuffDatatypes.deserialize("number", v45);
            else
                v46 = BuffDatatypes.deserialize(v44, v45);
            end;

            v41[v32[v43]] = v46;
        end;

        local v47 = { Instance.new(v40), v41 };
        table.insert(v36, v47);

        if i % 450 == 0 then
            task.wait();
        end;
    end;

    for i, v in v36 do
        local u48 = v[1];

        for i2, v2 in v[2] do
            if typeof(v2) == "string" and v2:sub(1, 5) == "INST_" then
                local v49 = v2:sub(6);
                local v2 = v36[tonumber(v49)][1];
            end;

            pcall(function() -- Line: 205
                -- upvalues: u48 (copy), i2 (copy), v2 (ref)
                u48[i2] = v2;
            end);
        end;

        if not u48.Parent then
            table.insert(v37, u48);
        end;

        if i % 450 == 0 then
            task.wait();
        end;
    end;

    return v37;
end;

return v1;