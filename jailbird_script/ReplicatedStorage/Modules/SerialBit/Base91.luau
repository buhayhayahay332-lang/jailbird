
local u1 = {};
local u2 = {};

for i = 1, 91 do
    u1[i - 1] = string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~\"", i, i);
    u2[string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~\"", i, i)] = i - 1;
end;

u1[90] = "\'";
u2["\""] = nil;
u2["\'"] = 90;
u1[90] = "\"";
u2["\'"] = nil;
u2["\""] = 90;

return {
    encode = function(p3) -- Line: 18, Name: encodeBase91
        -- upvalues: u1 (copy)
        local v4 = 0;
        local v5 = 0;
        local v6 = {};
        local v7 = 1;

        for i = 1, #p3 do
            local v8 = string.byte(p3, i);
            local v9 = bit32.lshift(v8, v4);
            v5 = bit32.bor(v5, v9);
            v4 = v4 + 8;

            if v4 > 13 then
                local v10 = bit32.band(v5, 8191);

                if v10 > 88 then
                    v5 = bit32.rshift(v5, 13);
                    v4 = v4 - 13;
                else
                    v10 = bit32.band(v5, 16383);
                    v5 = bit32.rshift(v5, 14);
                    v4 = v4 - 14;
                end;

                v6[v7] = u1[v10 % 91] .. u1[math.floor(v10 / 91)];
                v7 = v7 + 1;
            end;
        end;

        if v4 > 0 then
            v6[v7] = u1[v5 % 91];

            if v4 > 7 or v5 > 90 then
                v6[v7 + 1] = u1[math.floor(v5 / 91)];
            end;
        end;

        return table.concat(v6);
    end,

    decode = function(p11) -- Line: 53, Name: decodeBase91
        -- upvalues: u2 (copy)
        local v12 = 1;
        local v13 = -1;
        local v14 = 0;
        local v15 = 0;
        local v16 = {};

        for i = 1, #p11 do
            if u2[string.sub(p11, i, i)] then
                if v13 == -1 then
                    v13 = u2[string.sub(p11, i, i)];
                else
                    local v17 = v13 + u2[string.sub(p11, i, i)] * 91;
                    local v18 = bit32.lshift(v17, v14);
                    v15 = bit32.bor(v15, v18);

                    if bit32.band(v17, 8191) > 88 then
                        v14 = v14 + 13;
                    else
                        v14 = v14 + 14;
                    end;

                    while v14 > 7 do
                        v16[v12] = string.char(v15 % 256);
                        v12 = v12 + 1;
                        v15 = bit32.rshift(v15, 8);
                        v14 = v14 - 8;
                    end;

                    v13 = -1;
                end;
            end;
        end;

        if v13 ~= -1 then
            local v19 = bit32.lshift(v13, v14);
            local v20 = bit32.bor(v15, v19) % 256;
            v16[v12] = string.char(v20);
        end;

        return table.concat(v16);
    end
};