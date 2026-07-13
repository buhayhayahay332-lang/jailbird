
local v1 = {};
local u2 = {};
v1.Deflate = {};
v1.Zlib = {};
v1.Library = u2;

function v1.Deflate.Compress(p3, p4) -- Line: 198
    -- upvalues: u2 (ref)
    return u2:CompressDeflate(p3, p4);
end;

function v1.Deflate.Decompress(p5) -- Line: 219
    -- upvalues: u2 (ref)
    return u2:DecompressDeflate(p5);
end;

function v1.Zlib.Compress(p6, p7) -- Line: 243
    -- upvalues: u2 (ref)
    return u2:CompressZlib(p6, p7);
end;

function v1.Zlib.Decompress(p8) -- Line: 264
    -- upvalues: u2 (ref)
    return u2:DecompressZlib(p8);
end;

u2 = {
    _VERSION = "1.0.2-release",
    _MAJOR = "LibDeflate",
    _MINOR = 3,
    _COPYRIGHT = "LibDeflate 1.0.2-release Copyright (C) 2018-2020 Haoqian He. Licensed under the zlib License"
};
local u9 = assert;
local u10 = error;
local u11 = pairs;
local byte = string.byte;
local char = string.char;
local find = string.find;
local gsub = string.gsub;
local sub = string.sub;
local concat = table.concat;
local sort = table.sort;
local u12 = tostring;
local u13 = type;
local u14 = {};
local u15 = {};
local u16 = {};
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = {};
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0 };
local u27 = nil;
local u28 = { 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258 };
local u29 = { 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577 };
local u30 = nil;
local u31 = nil;
local u32 = { 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 };
local u33 = nil;
local u34 = { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13 };

for i = 0, 255 do
    u14[i] = char(i);
end;

local v35 = 1;

for i = 0, 32 do
    u15[i] = v35;
    v35 = v35 * 2;
end;

for i = 1, 9 do
    u16[i] = {};

    for i2 = 0, u15[i + 1] - 1 do
        local v36 = i2;
        local v37 = 0;

        for _ = 1, i do
            local v38 = v37 - v37 % 2 + ((v37 % 2 == 1 or i2 % 2 == 1) and 1 or 0);
            local i2 = (i2 - i2 % 2) / 2;
            v37 = v38 * 2;
        end;

        u16[i][v36] = (v37 - v37 % 2) / 2;
    end;
end;

local v39 = 1;
local v40 = 18;
local v41 = 16;
local v42 = 265;

for i = 3, 258 do
    if i <= 10 then
        u18[i] = i + 254;
        u19[i] = 0;
    elseif i == 258 then
        u18[i] = 285;
        u19[i] = 0;
    else
        if v40 < i then
            v40 = v40 + v41;
            v41 = v41 * 2;
            v42 = v42 + 4;
            v39 = v39 + 1;
        end;

        local v43 = i - v40 - 1 + v41 / 2;
        u18[i] = (v43 - v43 % (v41 / 8)) / (v41 / 8) + v42;
        u19[i] = v39;
        u17[i] = v43 % (v41 / 8);
    end;
end;

u20[1] = 0;
u20[2] = 1;
u21[1] = 0;
u21[2] = 0;
local v44 = 4;
local v45 = 3;
local v46 = 2;
local v47 = 0;

for i = 3, 256 do
    if v44 < i then
        v45 = v45 * 2;
        v44 = v44 * 2;
        v46 = v46 + 2;
        v47 = v47 + 1;
    end;

    u20[i] = i <= v45 and v46 and v46 or v46 + 1;
    u21[i] = v47 < 0 and 0 or v47;

    if v44 >= 8 then
        u22[i] = (i - v44 / 2 - 1) % (v44 / 4);
    end;
end;

function u2.Adler32(p48, p49) -- Line: 529
    -- upvalues: u13 (copy), u10 (copy), byte (copy)
    if u13(p49) ~= "string" then
        u10(("Usage: LibDeflate:Adler32(str): \'str\' - string expected got \'%s\'."):format((u13(p49))), 2);
    end;

    local v50 = #p49;
    local v51 = 1;
    local v52 = 1;
    local v53 = 0;

    while v51 <= v50 - 15 do
        local v54, v55, v56, v57, v58, v59, v60, v61, v62, v63, v64, v65, v66, v67, v68, v69 = byte(p49, v51, v51 + 15);
        v53 = (v53 + v52 * 16 + v54 * 16 + 15 * v55 + 14 * v56 + 13 * v57 + 12 * v58 + 11 * v59 + 10 * v60 + 9 * v61 + 8 * v62 + 7 * v63 + 6 * v64 + 5 * v65 + 4 * v66 + 3 * v67 + 2 * v68 + v69) % 65521;
        v52 = (v52 + v54 + v55 + v56 + v57 + v58 + v59 + v60 + v61 + v62 + v63 + v64 + v65 + v66 + v67 + v68 + v69) % 65521;
        v51 = v51 + 16;
    end;

    while v51 <= v50 do
        v52 = (v52 + byte(p49, v51, v51)) % 65521;
        v53 = (v53 + v52) % 65521;
        v51 = v51 + 1;
    end;

    return (v53 * 65536 + v52) % 4294967296;
end;

local function IsEqualAdler32(p70, p71) -- Line: 571
    return p70 % 4294967296 == p71 % 4294967296;
end;

function u2.CreateDictionary(p72, p73, p74, p75) -- Line: 617
    -- upvalues: u13 (copy), u10 (copy), byte (copy)
    if u13(p73) ~= "string" then
        u10(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - string expected got \'%s\'."):format((u13(p73))), 2);
    end;

    if u13(p74) ~= "number" then
        u10(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'strlen\' - number expected got \'%s\'."):format((u13(p74))), 2);
    end;

    if u13(p75) ~= "number" then
        u10(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'adler32\' - number expected got \'%s\'."):format((u13(p75))), 2);
    end;

    if p74 ~= #p73 then
        u10(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'strlen\' does not match the actual length of \'str\'. \'strlen\': %u, \'#str\': %u . Please check if \'str\' is modified unintentionally."):format(p74, #p73));
    end;

    if p74 == 0 then
        u10(
            "Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - Empty string is not allowed.",
            2
        );
    end;

    if p74 > 32768 then
        u10(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - string longer than 32768 bytes is not allowed. Got %d bytes."):format(p74), 2);
    end;

    local v76 = p72:Adler32(p73);

    if p75 % 4294967296 ~= v76 % 4294967296 then
        u10(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'adler32\' does not match the actual adler32 of \'str\'. \'adler32\': %u, \'Adler32(str)\': %u . Please check if \'str\' is modified unintentionally."):format(p75, v76));
    end;

    local v77 = {
        adler32 = p75,
        hash_tables = {},
        string_table = {},
        strlen = p74
    };
    local string_table = v77.string_table;
    local hash_tables = v77.hash_tables;
    string_table[1] = byte(p73, 1, 1);
    string_table[2] = byte(p73, 2, 2);

    if p74 >= 3 then
        local v78 = string_table[1] * 256 + string_table[2];
        local v79 = 1;

        while v79 <= p74 - 2 - 3 do
            local v80, v81, v82, v83 = byte(p73, v79 + 2, v79 + 5);
            string_table[v79 + 2] = v80;
            string_table[v79 + 3] = v81;
            string_table[v79 + 4] = v82;
            string_table[v79 + 5] = v83;
            local v84 = (v78 * 256 + v80) % 16777216;
            local v85 = hash_tables[v84];

            if not v85 then
                v85 = {};
                hash_tables[v84] = v85;
            end;

            v85[#v85 + 1] = v79 - p74;
            local v86 = v79 + 1;
            local v87 = (v84 * 256 + v81) % 16777216;
            local v88 = hash_tables[v87];

            if not v88 then
                v88 = {};
                hash_tables[v87] = v88;
            end;

            v88[#v88 + 1] = v86 - p74;
            local v89 = v86 + 1;
            local v90 = (v87 * 256 + v82) % 16777216;
            local v91 = hash_tables[v90];

            if not v91 then
                v91 = {};
                hash_tables[v90] = v91;
            end;

            v91[#v91 + 1] = v89 - p74;
            local v92 = v89 + 1;
            v78 = (v90 * 256 + v83) % 16777216;
            local v93 = hash_tables[v78];

            if not v93 then
                v93 = {};
                hash_tables[v78] = v93;
            end;

            v93[#v93 + 1] = v92 - p74;
            v79 = v92 + 1;
        end;

        while v79 <= p74 - 2 do
            local v94 = byte(p73, v79 + 2);
            string_table[v79 + 2] = v94;
            v78 = (v78 * 256 + v94) % 16777216;
            local v95 = hash_tables[v78];

            if not v95 then
                v95 = {};
                hash_tables[v78] = v95;
            end;

            v95[#v95 + 1] = v79 - p74;
            v79 = v79 + 1;
        end;
    end;

    return v77;
end;

local function IsValidDictionary(p96) -- Line: 713
    -- upvalues: u13 (copy)
    if u13(p96) ~= "table" then
        return false, ("\'dictionary\' - table expected got \'%s\'."):format((u13(p96)));
    end;

    if u13(p96.adler32) == "number" and (u13(p96.string_table) == "table" and (u13(p96.strlen) == "number" and (p96.strlen > 0 and (p96.strlen <= 32768 and (p96.strlen == #p96.string_table and u13(p96.hash_tables) == "table"))))) then
        return true, "";
    end;

    return false, ("\'dictionary\' - corrupted dictionary."):format((u13(p96)));
end;

local u97 = {
    [0] = { false, nil, 0, 0, 0 },
    [1] = { false, nil, 4, 8, 4 },
    [2] = { false, nil, 5, 18, 8 },
    [3] = { false, nil, 6, 32, 32 },
    [4] = { true, 4, 4, 16, 16 },
    [5] = { true, 8, 16, 32, 32 },
    [6] = { true, 8, 16, 128, 128 },
    [7] = { true, 8, 32, 128, 256 },
    [8] = { true, 32, 128, 258, 1024 },
    [9] = { true, 32, 258, 258, 4096 }
};

local function IsValidArguments(p98, p99, p100, p101, p102) -- Line: 790
    -- upvalues: u13 (copy), IsValidDictionary (copy), u11 (copy), u97 (copy), u12 (copy)
    if u13(p98) ~= "string" then
        return false, ("\'str\' - string expected got \'%s\'."):format((u13(p98)));
    end;

    if p99 then
        local v103, v104 = IsValidDictionary(p100);

        if not v103 then
            return false, v104;
        end;
    end;

    if p101 then
        local v105 = u13(p102);

        if v105 ~= "nil" and v105 ~= "table" then
            return false, ("\'configs\' - nil or table expected got \'%s\'."):format((u13(p102)));
        end;

        if v105 == "table" then
            for i, v in u11(p102) do
                if i ~= "level" and i ~= "strategy" then
                    return false, ("\'configs\' - unsupported table key in the configs: \'%s\'."):format(i);
                end;

                if i == "level" and not u97[v] then
                    return false, ("\'configs\' - unsupported \'level\': %s."):format((u12(v)));
                end;

                if i == "strategy" and (v ~= "fixed" and (v ~= "huffman_only" and v ~= "dynamic")) then
                    return false, ("\'configs\' - unsupported \'strategy\': \'%s\'."):format((u12(v)));
                end;
            end;
        end;
    end;

    return true, "";
end;

local u106 = 0;

local function CreateWriter() -- Line: 857
    -- upvalues: u106 (ref), u15 (copy), u14 (copy), char (copy), concat (copy)
    local u107 = 0;
    local u108 = 0;
    local u109 = 0;
    local u110 = 0;
    local u111 = {};
    local u112 = {};

    return function(p113, p114) -- Line: 870, Name: WriteBits
        -- upvalues: u106 (ref), u108 (ref), u15 (ref), u109 (ref), u110 (ref), u107 (ref), u111 (ref), u14 (ref)
        u106 = u106 + 1;
        u108 = u108 + p113 * u15[u109];
        u109 = u109 + p114;
        u110 = u110 + p114;

        if u106 % 800 == 0 then
            task.wait();
        end;

        if u109 >= 32 then
            u107 = u107 + 1;
            u111[u107] = u14[u108 % 256] .. u14[(u108 - u108 % 256) / 256 % 256] .. u14[(u108 - u108 % 65536) / 65536 % 256] .. u14[(u108 - u108 % 16777216) / 16777216 % 256];
            local v115 = u15[32 - u109 + p114];
            u108 = (p113 - p113 % v115) / v115;
            u109 = u109 - 32;
        end;
    end, function(p116) -- Line: 896, Name: WriteString
        -- upvalues: u109 (ref), u107 (ref), u111 (ref), u108 (ref), char (ref), u110 (ref)
        for _ = 1, u109, 8 do
            u107 = u107 + 1;
            u111[u107] = char(u108 % 256);
            u108 = (u108 - u108 % 256) / 256;
        end;

        u109 = 0;
        u107 = u107 + 1;
        u111[u107] = p116;
        u110 = u110 + #p116 * 8;
    end, function(p117) -- Line: 915, Name: FlushWriter
        -- upvalues: u110 (ref), u109 (ref), u108 (ref), u15 (ref), u107 (ref), u111 (ref), u14 (ref), concat (ref), u112 (copy)
        if p117 == 3 then
            return u110;
        end;

        if p117 == 1 or p117 == 2 then
            local v118 = (8 - u109 % 8) % 8;

            if u109 > 0 then
                u108 = u108 - u15[u109] + u15[u109 + v118];

                for _ = 1, u109, 8 do
                    u107 = u107 + 1;
                    u111[u107] = u14[u108 % 256];
                    u108 = (u108 - u108 % 256) / 256;
                end;

                u108 = 0;
                u109 = 0;
            end;

            if p117 == 2 then
                u110 = u110 + v118;

                return u110;
            end;
        end;

        local v119 = concat(u111);
        u111 = {};
        u107 = 0;
        u112[#u112 + 1] = v119;

        if p117 == 0 then
            return u110;
        end;

        return u110, concat(u112);
    end;
end;

local function MinHeapPush(p120, p121, p122) -- Line: 970
    local v123 = p122 + 1;
    p120[v123] = p121;
    local v124 = (v123 - v123 % 2) / 2;

    while v124 >= 1 and p121[1] < p120[v124][1] do
        local v125 = p120[v124];
        p120[v124] = p121;
        p120[v123] = v125;
        v123 = v124;
        v124 = (v124 - v124 % 2) / 2;
    end;
end;

local function MinHeapPop(p126, p127) -- Line: 991
    local v128 = p126[1];
    local v129 = p126[p127];
    local v130 = v129[1];
    p126[1] = v129;
    p126[p127] = v128;
    local v131 = p127 - 1;
    local v132 = 1;
    local v133 = v132 * 2;
    local v134 = v133 + 1;

    while v133 <= v131 do
        local v135 = p126[v133];
        local v136;

        if v134 <= v131 and p126[v134][1] < v135[1] then
            local v137 = p126[v134];

            if v137[1] >= v130 then
                break;
            end;

            p126[v134] = v129;
            p126[v132] = v137;
            v136 = v134 * 2;
            v133 = v134;
            v134 = v136 + 1;
        else
            if v135[1] >= v130 then
                break;
            end;

            p126[v133] = v129;
            p126[v132] = v135;
            v136 = v133 * 2;
            v134 = v136 + 1;
        end;

        v132 = v133;
        v133 = v136;
    end;

    return v128;
end;

local function GetHuffmanCodeFromBitlen(p138, p139, p140, p141) -- Line: 1041
    -- upvalues: u16 (copy)
    local v142 = 0;
    local v143 = {};
    local v144 = {};

    for i = 1, p141 do
        v142 = (v142 + (p138[i - 1] or 0)) * 2;
        v143[i] = v142;
    end;

    for i = 0, p140 do
        local v145 = p139[i];

        if v145 then
            local v146 = v143[v145];
            v143[v145] = v146 + 1;

            if v145 <= 9 then
                v144[i] = u16[v145][v146];
            else
                local v147 = 0;

                for _ = 1, v145 do
                    local v148 = v147 - v147 % 2 + ((v147 % 2 == 1 or v146 % 2 == 1) and 1 or 0);
                    v146 = (v146 - v146 % 2) / 2;
                    v147 = v148 * 2;
                end;

                v144[i] = (v147 - v147 % 2) / 2;
            end;
        end;
    end;

    return v144;
end;

local function SortByFirstThenSecond(p149, p150) -- Line: 1082
    local v151;

    if p149[1] < p150[1] then
        v151 = true;
    elseif p149[1] == p150[1] then
        v151 = p149[2] < p150[2];
    else
        v151 = false;
    end;

    return v151;
end;

local function GetHuffmanBitlenAndCode(p152, p153, p154) -- Line: 1098
    -- upvalues: u11 (copy), sort (copy), SortByFirstThenSecond (copy), MinHeapPop (copy), MinHeapPush (copy), GetHuffmanCodeFromBitlen (copy)
    local v155 = 0;
    local v156 = {};
    local v157 = {};
    local v158 = {};
    local v159 = -1;
    local v160 = {};
    local v161 = {};

    for i, v in u11(p152) do
        v155 = v155 + 1;
        v156[v155] = { v, i };
    end;

    if v155 == 0 then
        return {}, {}, -1;
    end;

    if v155 == 1 then
        local v162 = v156[1][2];
        v158[v162] = 1;
        v161[v162] = 0;

        return v158, v161, v162;
    end;

    sort(v156, SortByFirstThenSecond);

    for i = 1, v155 do
        v157[i] = v156[i];
    end;

    while v155 > 1 do
        local v163 = MinHeapPop(v157, v155);
        local v164 = v155 - 1;
        local v165 = MinHeapPop(v157, v164);
        local v166 = v164 - 1;
        MinHeapPush(v157, {
            v163[1] + v165[1],
            -1,
            v163,
            v165
        }, v166);
        v155 = v166 + 1;
    end;

    local v167 = {
        v157[1],
        0,
        0,
        0
    };
    v157[1][1] = 0;
    local v168 = 1;
    local v169 = 1;
    local v170 = 0;

    while v168 <= v169 do
        local v171 = v167[v168];
        local v172 = v171[1];
        local v173 = v171[2];
        local v174 = v171[3];
        local v175 = v171[4];

        if v174 then
            v169 = v169 + 1;
            v167[v169] = v174;
            v174[1] = v172 + 1;
        end;

        if v175 then
            v169 = v169 + 1;
            v167[v169] = v175;
            v175[1] = v172 + 1;
        end;

        v168 = v168 + 1;

        if p153 < v172 then
            v170 = v170 + 1;
            v172 = p153;
        end;

        if v173 >= 0 then
            v158[v173] = v172;

            if v159 < v173 then
                v159 = v173 or v159;
            end;

            v160[v172] = (v160[v172] or 0) + 1;
        end;
    end;

    if v170 > 0 then
        repeat
            local v176 = p153 - 1;

            while (v160[v176] or 0) == 0 do
                v176 = v176 - 1;
            end;

            v160[v176] = v160[v176] - 1;
            v160[v176 + 1] = (v160[v176 + 1] or 0) + 2;
            v160[p153] = v160[p153] - 1;
            v170 = v170 - 2;
        until v170 <= 0;

        local v177 = 1;

        for i = p153, 1, -1 do
            local v178 = v160[i] or 0;

            while v178 > 0 do
                v158[v156[v177][2]] = i;
                v178 = v178 - 1;
                v177 = v177 + 1;
            end;
        end;
    end;

    return v158, GetHuffmanCodeFromBitlen(v160, v158, p154, p153), v159;
end;

local function RunLengthEncodeHuffmanBitlen(p179, p180, p181, p182) -- Line: 1235
    local v183 = p180 + (p182 < 0 and 0 or p182) + 1;
    local v184 = nil;
    local v185 = 0;
    local v186 = {};
    local v187 = 0;
    local v188 = {};
    local v189 = 0;
    local v190 = {};

    for i = 0, v183 + 1 do
        local v191;

        if i <= p180 then
            v191 = p179[i] or 0;
        else
            v191 = i <= v183 and (p181[i - p180 - 1] or 0) or nil;
        end;

        if v191 == v184 then
            v189 = v189 + 1;

            if v191 == 0 or v189 ~= 6 then
                if v191 == 0 and v189 == 138 then
                    v185 = v185 + 1;
                    v186[v185] = 18;
                    v187 = v187 + 1;
                    v188[v187] = 127;
                    v190[18] = (v190[18] or 0) + 1;
                    v189 = 0;
                end;
            else
                v185 = v185 + 1;
                v186[v185] = 16;
                v187 = v187 + 1;
                v188[v187] = 3;
                v190[16] = (v190[16] or 0) + 1;
                v189 = 0;
            end;
        else
            if v189 == 1 then
                v185 = v185 + 1;
                v186[v185] = v184;
                v190[v184] = (v190[v184] or 0) + 1;
            elseif v189 == 2 then
                local v192 = v185 + 1;
                v186[v192] = v184;
                v185 = v192 + 1;
                v186[v185] = v184;
                v190[v184] = (v190[v184] or 0) + 2;
            elseif v189 >= 3 then
                v185 = v185 + 1;
                local v193 = v184 == 0 and (v189 <= 10 and 17 or 18) or 16;
                v186[v185] = v193;
                v190[v193] = (v190[v193] or 0) + 1;
                v187 = v187 + 1;
                v188[v187] = v189 <= 10 and v189 - 3 or v189 - 11;
            end;

            if v191 and v191 ~= 0 then
                v185 = v185 + 1;
                v186[v185] = v191;
                v190[v191] = (v190[v191] or 0) + 1;
                v184 = v191;
                v189 = 0;
            else
                v184 = v191;
                v189 = 1;
            end;
        end;
    end;

    return v186, v188, v190;
end;

local function LoadStringToTable(p194, p195, p196, p197, p198) -- Line: 1321
    -- upvalues: byte (copy)
    local v199 = p196 - p198;

    while v199 <= p197 - 15 - p198 do
        local v200, v201, v202, v203, v204, v205, v206, v207, v208, v209, v210, v211, v212, v213, v214, v215 = byte(p194, v199 + p198, v199 + 15 + p198);
        p195[v199] = v200;
        p195[v199 + 1] = v201;
        p195[v199 + 2] = v202;
        p195[v199 + 3] = v203;
        p195[v199 + 4] = v204;
        p195[v199 + 5] = v205;
        p195[v199 + 6] = v206;
        p195[v199 + 7] = v207;
        p195[v199 + 8] = v208;
        p195[v199 + 9] = v209;
        p195[v199 + 10] = v210;
        p195[v199 + 11] = v211;
        p195[v199 + 12] = v212;
        p195[v199 + 13] = v213;
        p195[v199 + 14] = v214;
        p195[v199 + 15] = v215;
        v199 = v199 + 16;
    end;

    while v199 <= p197 - p198 do
        p195[v199] = byte(p194, v199 + p198, v199 + p198);
        v199 = v199 + 1;
    end;

    return p195;
end;

local function GetBlockLZ77Result(p216, p217, p218, p219, p220, p221, p222) -- Line: 1378
    -- upvalues: u97 (copy), u9 (copy), u18 (copy), u19 (copy), u20 (copy), u22 (copy), u21 (copy), u17 (copy)
    local v223 = u97[p216];
    local v224 = v223[1];
    local v225 = v223[2];
    local v226 = v223[3];
    local v227 = v223[4];
    local v228 = v223[5];
    local v229 = (v224 or not v226) and 2147483646 or v226;
    local v230 = v228 - v228 % 4 / 4;
    local v231, v232, v233;

    if p222 then
        v231 = p222.hash_tables;
        v232 = p222.string_table;
        v233 = p222.strlen;
        u9(p219 == 1);

        if p219 <= p220 and v233 >= 2 then
            local v234 = v232[v233 - 1] * 65536 + v232[v233] * 256 + p217[1];
            local v235 = p218[v234];

            if not v235 then
                v235 = {};
                p218[v234] = v235;
            end;

            v235[#v235 + 1] = -1;
        end;

        if p219 + 1 <= p220 and v233 >= 1 then
            local v236 = v232[v233] * 65536 + p217[1] * 256 + p217[2];
            local v237 = p218[v236];

            if not v237 then
                v237 = {};
                p218[v236] = v237;
            end;

            v237[#v237 + 1] = 0;
        end;
    else
        v233 = 0;
        v231 = nil;
        v232 = nil;
    end;

    local v238 = v233 + 3;
    local v239 = (p217[p219 - p221] or 0) * 256 + (p217[p219 + 1 - p221] or 0);
    local v240 = p220 + (v224 and 1 or 0);
    local v241 = 0;
    local v242 = 0;
    local v243 = {};
    local v244 = 0;
    local v245 = 0;
    local v246 = {};
    local v247 = false;
    local v248 = {};
    local v249 = 0;
    local v250 = 0;
    local v251 = {};
    local v252 = {};
    local v253 = {};

    while true do
        if p219 > v240 then
            v252[v244 + 1] = 256;
            v253[256] = (v253[256] or 0) + 1;

            return v252, v248, v253, v246, v251, v243;
        end;

        local v254 = p219 - p221;
        local v255 = p221 - 3;
        local v256 = 0;
        v239 = (v239 * 256 + (p217[v254 + 2] or 0)) % 16777216;
        local v257 = nil;
        local v258 = p218[v239];
        local v259, v260;

        if v258 then
            v259 = #v258;
            v257 = v258;
            v260 = v259;
        else
            v259 = 0;
            v258 = {};
            p218[v239] = v258;

            if v231 then
                v257 = v231[v239];
                v260 = v257 and (#v257 or 0) or 0;
            else
                v260 = 0;
            end;
        end;

        if p219 <= p220 then
            v258[v259 + 1] = p219;
        end;

        local v261, v262;

        if v260 > 0 and (p219 + 2 <= p220 and (not v224 or v241 < v226)) then
            local v263;

            if v224 and (v225 <= v241 and v230) then
                v263 = v230;
            else
                v263 = v228;
            end;

            local v264 = p220 - p219;
            local v265 = (v264 >= 257 and 257 or v264) + v254;
            local v266 = v254 + 3;
            v261 = v242;

            while true do
                if v260 < 1 or v263 <= 0 then
                    v262 = v256;
                    break;
                end;

                local v267 = v257[v260];

                if p219 - v267 > 32768 then
                    v262 = v256;
                    break;
                end;

                local v268;

                if v267 < p219 then
                    if v267 >= -257 then
                        local v269 = v267 - v255;
                        v268 = v266;

                        while v266 <= v265 and p217[v269] == p217[v266] do
                            v266 = v266 + 1;
                            v269 = v269 + 1;
                        end;
                    else
                        local v270 = v238 + v267;
                        local v271 = v266;

                        while v271 <= v265 and v232[v270] == p217[v271] do
                            v271 = v271 + 1;
                            v270 = v270 + 1;
                        end;

                        v268 = v266;
                        v266 = v271;
                    end;

                    v262 = v266 - v254;

                    if v256 < v262 then
                        v261 = p219 - v267;
                    else
                        v262 = v256;
                    end;

                    if v227 <= v262 then
                        break;
                    end;
                else
                    v262 = v256;
                    v268 = v266;
                end;

                v260 = v260 - 1;
                v263 = v263 - 1;

                if v260 == 0 and (v267 > 0 and v231) then
                    v257 = v231[v239];
                    v260 = v257 and (#v257 or 0) or 0;
                end;

                v256 = v262;
                v266 = v268;
            end;
        else
            v262 = v256;
            v261 = v242;
        end;

        if not v224 then
            v242 = v261;
            v241 = v262;
        end;

        if v224 and not v247 or (v241 <= 3 and (v241 ~= 3 or v242 >= 4096) or v262 > v241) then
            if v224 and not v247 then
                p219 = p219 + 1;
                v247 = true;
            else
                if v224 then
                    v254 = v254 - 1 or v254;
                end;

                local v272 = p217[v254];
                v244 = v244 + 1;
                v252[v244] = v272;
                v253[v272] = (v253[v272] or 0) + 1;
                p219 = p219 + 1;
            end;
        else
            local v273 = u18[v241];
            local v274 = u19[v241];
            local v275, v276, v277;

            if v242 <= 256 then
                v275 = u20[v242];
                v276 = u22[v242];
                v277 = u21[v242];
            else
                v275 = 16;
                local v278 = 512;
                v277 = 7;
                local v279 = 384;

                while true do
                    if v242 <= v279 then
                        v276 = (v242 - v278 / 2 - 1) % (v278 / 4);
                    end;

                    if v242 <= v278 then
                        v276 = (v242 - v278 / 2 - 1) % (v278 / 4);
                        v275 = v275 + 1;
                    end;

                    v275 = v275 + 2;
                    v277 = v277 + 1;
                    v279 = v279 * 2;
                    v278 = v278 * 2;
                end;
            end;

            v244 = v244 + 1;
            v252[v244] = v273;
            v253[v273] = (v253[v273] or 0) + 1;
            v245 = v245 + 1;
            v246[v245] = v275;
            v243[v275] = (v243[v275] or 0) + 1;

            if v274 > 0 then
                v250 = v250 + 1;
                v248[v250] = u17[v241];
            end;

            if v277 > 0 then
                v249 = v249 + 1;
                v251[v249] = v276;
            end;

            for i = p219 + 1, p219 + v241 - (v224 and 2 or 1) do
                v239 = (v239 * 256 + (p217[i - p221 + 2] or 0)) % 16777216;

                if v241 <= v229 then
                    local v280 = p218[v239];

                    if not v280 then
                        v280 = {};
                        p218[v239] = v280;
                    end;

                    v280[#v280 + 1] = i;
                end;
            end;

            p219 = p219 + v241 - (v224 and 1 or 0);
            v247 = false;
        end;

        v242 = v261;
        v241 = v262;
    end;
end;

local function GetBlockDynamicHuffmanHeader(p281, p282) -- Line: 1635
    -- upvalues: GetHuffmanBitlenAndCode (copy), RunLengthEncodeHuffmanBitlen (copy), u32 (copy)
    local v283, v284, v285 = GetHuffmanBitlenAndCode(p281, 15, 285);
    local v286, v287, v288 = GetHuffmanBitlenAndCode(p282, 15, 29);
    local v289, v290, v291 = RunLengthEncodeHuffmanBitlen(v283, v285, v286, v288);
    local v292, v293 = GetHuffmanBitlenAndCode(v291, 7, 18);
    local v294 = 0;

    for i = 1, 19 do
        if (v292[u32[i]] or 0) ~= 0 then
            v294 = i;
        end;
    end;

    local v295 = v288 + 1 - 1;

    return v285 + 1 - 257, v295 < 0 and 0 or v295, v294 - 4, v292, v293, v289, v290, v283, v284, v286, v287;
end;

local function GetDynamicHuffmanBlockSize(p296, p297, p298, p299, p300, p301, p302) -- Line: 1674
    -- upvalues: u26 (copy)
    local v303 = 17 + (p298 + 4) * 3;

    for i = 1, #p300 do
        local v304 = p300[i];
        v303 = v303 + p299[v304];

        if v304 >= 16 then
            v303 = v303 + (v304 == 16 and 2 or (v304 == 17 and 3 or 7));
        end;
    end;

    local v305 = 0;

    for i = 1, #p296 do
        local v306 = p296[i];
        v303 = v303 + p301[v306];

        if v306 > 256 then
            v305 = v305 + 1;

            if v306 > 264 and v306 < 285 then
                v303 = v303 + u26[v306 - 256];
            end;

            local v307 = p297[v305];
            v303 = v303 + p302[v307];

            if v307 > 3 then
                v303 = v303 + ((v307 - v307 % 2) / 2 - 1);
            end;
        end;
    end;

    return v303;
end;

local function CompressDynamicHuffmanBlock(p308, p309, p310, p311, p312, p313, p314, p315, p316, p317, p318, p319, p320, p321, p322, p323, p324) -- Line: 1717
    -- upvalues: u32 (copy), u26 (copy)
    p308(p309 and 1 or 0, 1);
    p308(2, 2);
    p308(p314, 5);
    p308(p315, 5);
    p308(p316, 4);

    for i = 1, p316 + 4 do
        p308(p317[u32[i]] or 0, 3);
    end;

    local v325 = 1;

    for i = 1, #p319 do
        local v326 = p319[i];
        p308(p318[v326], p317[v326]);

        if v326 >= 16 then
            p308(p320[v325], v326 == 16 and 2 or (v326 == 17 and 3 or 7));
            v325 = v325 + 1;
        end;
    end;

    local v327 = 0;
    local v328 = 0;
    local v329 = 0;

    for i = 1, #p310 do
        local v330 = p310[i];
        p308(p322[v330], p321[v330]);

        if v330 > 256 then
            v328 = v328 + 1;

            if v330 > 264 and v330 < 285 then
                v327 = v327 + 1;
                p308(p311[v327], u26[v330 - 256]);
            end;

            local v331 = p312[v328];
            p308(p324[v331], p323[v331]);

            if v331 > 3 then
                v329 = v329 + 1;
                p308(p313[v329], (v331 - v331 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetFixedHuffmanBlockSize(p332, p333) -- Line: 1790
    -- upvalues: u33 (ref), u26 (copy)
    local v334 = 3;
    local v335 = 0;

    for i = 1, #p332 do
        local v336 = p332[i];
        v334 = v334 + u33[v336];

        if v336 > 256 then
            v335 = v335 + 1;

            if v336 > 264 and v336 < 285 then
                v334 = v334 + u26[v336 - 256];
            end;

            local v337 = p333[v335];
            v334 = v334 + 5;

            if v337 > 3 then
                v334 = v334 + ((v337 - v337 % 2) / 2 - 1);
            end;
        end;
    end;

    return v334;
end;

local function CompressFixedHuffmanBlock(p338, p339, p340, p341, p342, p343) -- Line: 1820
    -- upvalues: u25 (ref), u33 (ref), u26 (copy), u27 (ref)
    p338(p339 and 1 or 0, 1);
    p338(1, 2);
    local v344 = 0;
    local v345 = 0;
    local v346 = 0;

    for i = 1, #p340 do
        local v347 = p340[i];
        p338(u25[v347], u33[v347]);

        if v347 > 256 then
            v344 = v344 + 1;

            if v347 > 264 and v347 < 285 then
                v345 = v345 + 1;
                p338(p341[v345], u26[v347 - 256]);
            end;

            local v348 = p342[v344];
            p338(u27[v348], 5);

            if v348 > 3 then
                v346 = v346 + 1;
                p338(p343[v346], (v348 - v348 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetStoreBlockSize(p349, p350, p351) -- Line: 1863
    -- upvalues: u9 (copy)
    u9(p350 - p349 + 1 <= 65535);

    return 3 + (8 - (p351 + 3) % 8) % 8 + 32 + (p350 - p349 + 1) * 8;
end;

local function CompressStoreBlock(p352, p353, p354, p355, p356, p357, p358) -- Line: 1877
    -- upvalues: u9 (copy), u15 (copy)
    u9(p357 - p356 + 1 <= 65535);
    p352(p354 and 1 or 0, 1);
    p352(0, 2);
    local v359 = (8 - (p358 + 3) % 8) % 8;

    if v359 > 0 then
        p352(u15[v359] - 1, v359);
    end;

    local v360 = p357 - p356 + 1;
    p352(v360, 16);
    p352(255 - v360 % 256 + (255 - (v360 - v360 % 256) / 256) * 256, 16);
    p353(p355:sub(p356, p357));
end;

local function Deflate(p361, p362, p363, p364, p365, p366) -- Line: 1908
    -- upvalues: LoadStringToTable (copy), GetBlockLZ77Result (copy), GetBlockDynamicHuffmanHeader (copy), GetDynamicHuffmanBlockSize (copy), GetFixedHuffmanBlockSize (copy), u9 (copy), CompressStoreBlock (copy), CompressFixedHuffmanBlock (copy), CompressDynamicHuffmanBlock (copy), u11 (copy)
    local v367 = {};
    local v368 = {};
    local v369 = nil;
    local v370 = nil;
    local v371 = nil;
    local v372 = p364(3);
    local v373 = #p365;
    local v374 = nil;
    local v375 = nil;

    if p361 then
        if p361.level then
            v374 = p361.level;
        end;

        if p361.strategy then
            v375 = p361.strategy;
        end;
    end;

    if not v374 then
        if v373 < 2048 then
            v374 = 7;
        elseif v373 > 65536 then
            v374 = 3;
        else
            v374 = 5;
        end;
    end;

    while not v369 do
        local v376;

        if v370 then
            v370 = v371 + 1;
            v371 = v371 + 32768;
            v376 = v370 - 32768 - 1;
        else
            v370 = 1;
            v376 = 0;
            v371 = 65535;
        end;

        if v373 <= v371 then
            v371 = v373;
            v369 = true;
        else
            v369 = false;
        end;

        local v377, v378, v379, v380, v381, v382, v383, v384, v385, v386, v387, v388, v389, v390, v391, v392, v393;

        if v374 == 0 then
            v377 = nil;
            v378 = nil;
            v379 = nil;
            v380 = nil;
            v381 = nil;
            v382 = nil;
            v383 = nil;
            v384 = nil;
            v385 = nil;
            v386 = nil;
            v387 = nil;
            v388 = nil;
            v389 = nil;
            v390 = nil;
            v391 = nil;
            v392 = nil;
            v393 = nil;
        else
            LoadStringToTable(p365, v367, v370, v371 + 3, v376);

            if v370 == 1 and p366 then
                local string_table = p366.string_table;
                local strlen = p366.strlen;

                for i = 0, -strlen + 1 < -257 and -257 or -strlen + 1, -1 do
                    v367[i] = string_table[strlen + i];
                end;
            end;

            local v394, v395;

            if v375 == "huffman_only" then
                v384 = {};
                LoadStringToTable(p365, v384, v370, v371, v370 - 1);
                v384[v371 - v370 + 2] = 256;
                v394 = {};
                v389 = {};

                for i = 1, v371 - v370 + 2 do
                    local v396 = v384[i];
                    v394[v396] = (v394[v396] or 0) + 1;
                end;

                v391 = {};
                v381 = {};
                v395 = {};
            else
                v384, v389, v394, v381, v391, v395 = GetBlockLZ77Result(v374, v367, v368, v370, v371, v376, p366);
            end;

            v390, v392, v386, v387, v393, v377, v382, v378, v379, v385, v380 = GetBlockDynamicHuffmanHeader(v394, v395);
            v388 = GetDynamicHuffmanBlockSize(v384, v381, v386, v387, v377, v378, v385);
            v383 = GetFixedHuffmanBlockSize(v384, v381);
        end;

        u9(v371 - v370 + 1 <= 65535);
        local v397 = 3 + (8 - (v372 + 3) % 8) % 8 + 32 + (v371 - v370 + 1) * 8;
        local v398;

        if v383 and (v383 < v397 and v383) then
            v398 = v383;
        else
            v398 = v397;
        end;

        if v388 and (v388 < v398 and v388) then
            v398 = v388;
        end;

        if v374 == 0 or v375 ~= "fixed" and (v375 ~= "dynamic" and v397 == v398) then
            CompressStoreBlock(p362, p363, v369, p365, v370, v371, v372);
            v372 = v372 + v397;
        elseif v375 == "dynamic" or v375 ~= "fixed" and v383 ~= v398 then
            if v375 == "dynamic" or v388 == v398 then
                CompressDynamicHuffmanBlock(p362, v369, v384, v389, v381, v391, v390, v392, v386, v387, v393, v377, v382, v378, v379, v385, v380);
                v372 = v372 + v388;
            end;
        else
            CompressFixedHuffmanBlock(p362, v369, v384, v389, v381, v391);
            v372 = v372 + v383;
        end;

        local v399;

        if v369 then
            v399 = p364(3);
        else
            v399 = p364(0);
        end;

        u9(v399 == v372);

        if not v369 then
            if p366 and v370 == 1 then
                local v400 = 0;

                while v367[v400] do
                    v367[v400] = nil;
                    v400 = v400 - 1;
                end;
            end;

            local v401 = 1;
            p366 = nil;

            for i = v371 - 32767, v371 do
                v367[v401] = v367[i - v376];
                v401 = v401 + 1;
            end;

            for i, v in u11(v368) do
                local v402 = #v;

                if v402 > 0 and v371 + 1 - v[1] > 32768 then
                    if v402 == 1 then
                        v368[i] = nil;
                    else
                        local v403 = 0;
                        local v404 = {};

                        for i2 = 2, v402 do
                            local v405 = v[i2];

                            if v371 + 1 - v405 <= 32768 then
                                v403 = v403 + 1;
                                v404[v403] = v405;
                            end;
                        end;

                        v368[i] = v404;
                    end;
                end;
            end;
        end;
    end;
end;

local function CompressDeflateInternal(p406, p407, p408) -- Line: 2113
    -- upvalues: CreateWriter (copy), Deflate (copy)
    local v409, v410, v411 = CreateWriter();
    Deflate(p408, v409, v410, v411, p406, p407);
    local v412, v413 = v411(1);

    return v413, (8 - v412 % 8) % 8;
end;

local function CompressZlibInternal(p414, p415, p416) -- Line: 2123
    -- upvalues: CreateWriter (copy), Deflate (copy), u2 (ref)
    local v417, v418, v419 = CreateWriter();
    v417(120, 8);
    local v420 = p415 and 1 or 0;
    local v421 = 128 + v420 * 32;
    v417(v421 + (31 - (30720 + v421) % 31), 8);

    if v420 == 1 then
        local adler32 = p415.adler32;
        local v422 = adler32 % 256;
        local v423 = (adler32 - v422) / 256;
        local v424 = v423 % 256;
        local v425 = (v423 - v424) / 256;
        local v426 = v425 % 256;
        v417((v425 - v426) / 256 % 256, 8);
        v417(v426, 8);
        v417(v424, 8);
        v417(v422, 8);
    end;

    Deflate(p416, v417, v418, v419, p414, p415);
    v419(2);
    local v427 = u2:Adler32(p414);
    local v428 = v427 % 256;
    local v429 = (v427 - v428) / 256;
    local v430 = v429 % 256;
    local v431 = (v429 - v430) / 256;
    local v432 = v431 % 256;
    v417((v431 - v432) / 256 % 256, 8);
    v417(v432, 8);
    v417(v430, 8);
    v417(v428, 8);
    local v433, v434 = v419(1);

    return v434, (8 - v433 % 8) % 8;
end;

function u2.CompressDeflate(p435, p436, p437) -- Line: 2192
    -- upvalues: IsValidArguments (copy), u10 (copy), CompressDeflateInternal (copy)
    local v438, v439 = IsValidArguments(p436, false, nil, true, p437);

    if not v438 then
        u10("Usage: LibDeflate:CompressDeflate(str, configs): " .. v439, 2);
    end;

    return CompressDeflateInternal(p436, nil, p437);
end;

function u2.CompressDeflateWithDict(p440, p441, p442, p443) -- Line: 2217
    -- upvalues: IsValidArguments (copy), u10 (copy), CompressDeflateInternal (copy)
    local v444, v445 = IsValidArguments(p441, true, p442, true, p443);

    if not v444 then
        u10("Usage: LibDeflate:CompressDeflateWithDict" .. "(str, dictionary, configs): " .. v445, 2);
    end;

    return CompressDeflateInternal(p441, p442, p443);
end;

function u2.CompressZlib(p446, p447, p448) -- Line: 2238
    -- upvalues: IsValidArguments (copy), u10 (copy), CompressZlibInternal (copy)
    local v449, v450 = IsValidArguments(p447, false, nil, true, p448);

    if not v449 then
        u10("Usage: LibDeflate:CompressZlib(str, configs): " .. v450, 2);
    end;

    return CompressZlibInternal(p447, nil, p448);
end;

function u2.CompressZlibWithDict(p451, p452, p453, p454) -- Line: 2260
    -- upvalues: IsValidArguments (copy), u10 (copy), CompressZlibInternal (copy)
    local v455, v456 = IsValidArguments(p452, true, p453, true, p454);

    if not v455 then
        u10("Usage: LibDeflate:CompressZlibWithDict" .. "(str, dictionary, configs): " .. v456, 2);
    end;

    return CompressZlibInternal(p452, p453, p454);
end;

local function CreateReader(u457) -- Line: 2284
    -- upvalues: u15 (copy), byte (copy), u9 (copy), char (copy), sub (copy), u16 (copy)
    local u458 = #u457;
    local u459 = 1;
    local u460 = 0;
    local u461 = 0;

    return function(p462) -- Line: 2297, Name: ReadBits
        -- upvalues: u15 (ref), u460 (ref), u461 (ref), u457 (copy), u459 (ref), byte (ref)
        local v463 = u15[p462];

        if p462 <= u460 then
            local v464 = u461 % v463;
            u461 = (u461 - v464) / v463;
            u460 = u460 - p462;

            return v464;
        end;

        local v465 = u15[u460];
        local v466, v467, v468, v469 = byte(u457, u459, u459 + 3);
        u461 = u461 + ((v466 or 0) + (v467 or 0) * 256 + (v468 or 0) * 65536 + (v469 or 0) * 16777216) * v465;
        u459 = u459 + 4;
        u460 = u460 + 32 - p462;
        local v470 = u461 % v463;
        u461 = (u461 - v470) / v463;

        return v470;
    end, function(p471, p472, p473) -- Line: 2326, Name: ReadBytes
        -- upvalues: u460 (ref), u9 (ref), u461 (ref), char (ref), u458 (copy), u459 (ref), u457 (copy), sub (ref)
        u9(u460 % 8 == 0);
        local v474;

        if u460 / 8 < p471 then
            v474 = u460 / 8 or p471;
        else
            v474 = p471;
        end;

        for _ = 1, v474 do
            local v475 = u461 % 256;
            p473 = p473 + 1;
            p472[p473] = char(v475);
            u461 = (u461 - v475) / 256;
        end;

        u460 = u460 - v474 * 8;
        local v476 = p471 - v474;

        if (u458 - u459 - v476 + 1) * 8 + u460 < 0 then
            return -1;
        end;

        for i = u459, u459 + v476 - 1 do
            p473 = p473 + 1;
            p472[p473] = sub(u457, i, i);
        end;

        u459 = u459 + v476;

        return p473;
    end, function(p477, p478, p479) -- Line: 2363, Name: Decode
        -- upvalues: u460 (ref), u457 (copy), u15 (ref), u459 (ref), byte (ref), u461 (ref), u16 (ref)
        local v480, v481, v482;

        if p479 > 0 then
            if u460 < 15 and u457 then
                local v483 = u15[u460];
                local v484, v485, v486, v487 = byte(u457, u459, u459 + 3);
                u461 = u461 + ((v484 or 0) + (v485 or 0) * 256 + (v486 or 0) * 65536 + (v487 or 0) * 16777216) * v483;
                u459 = u459 + 4;
                u460 = u460 + 32;
            end;

            local v488 = u15[p479];
            u460 = u460 - p479;
            local v489 = u461 % v488;
            u461 = (u461 - v489) / v488;
            local v490 = u16[p479][v489];
            v480 = p477[p479];

            if v490 < v480 then
                return p478[v490];
            end;

            v481 = v480 * 2;
            v482 = v490 * 2;
        else
            v482 = 0;
            v481 = 0;
            v480 = 0;
        end;

        for i = p479 + 1, 15 do
            local v491 = u461 % 2;
            u461 = (u461 - v491) / 2;
            u460 = u460 - 1;

            if v491 == 1 then
                v482 = v482 + 1 - v482 % 2 or v482;
            end;

            local v492 = p477[i] or 0;
            local v493 = v482 - v481;

            if v493 < v492 then
                return p478[v480 + v493];
            end;

            v480 = v480 + v492;
            v481 = (v481 + v492) * 2;
            v482 = v482 * 2;
        end;

        return -10;
    end, function() -- Line: 2419, Name: ReaderBitlenLeft
        -- upvalues: u458 (copy), u459 (ref), u460 (ref)
        return (u458 - u459 + 1) * 8 + u460;
    end, function() -- Line: 2423, Name: SkipToByteBoundary
        -- upvalues: u460 (ref), u15 (ref), u461 (ref)
        local v494 = u460 % 8;
        local v495 = u15[v494];
        u460 = u460 - v494;
        u461 = (u461 - u461 % v495) / v495;
    end;
end;

local function CreateDecompressState(p496, p497) -- Line: 2438
    -- upvalues: CreateReader (copy)
    local v498, v499, v500, v501, v502 = CreateReader(p496);

    return {
        buffer_size = 0,
        ReadBits = v498,
        ReadBytes = v499,
        Decode = v500,
        ReaderBitlenLeft = v501,
        SkipToByteBoundary = v502,
        buffer = {},
        result_buffer = {},
        dictionary = p497
    };
end;

local function GetHuffmanForDecode(p503, p504, p505) -- Line: 2465
    local v506 = p505;
    local v507 = {};

    for i = 0, p504 do
        local v508 = p503[i] or 0;

        if v508 > 0 and (v508 < p505 and v508) then
            p505 = v508;
        end;

        v507[v508] = (v507[v508] or 0) + 1;
    end;

    if v507[0] == p504 + 1 then
        return 0, v507, {}, 0;
    end;

    local v509 = 1;

    for i = 1, v506 do
        v509 = v509 * 2 - (v507[i] or 0);

        if v509 < 0 then
            return v509;
        end;
    end;

    local v510 = { 0 };

    for i = 1, v506 - 1 do
        v510[i + 1] = v510[i] + (v507[i] or 0);
    end;

    local v511 = {};

    for i = 0, p504 do
        local v512 = p503[i] or 0;

        if v512 ~= 0 then
            v511[v510[v512]] = i;
            v510[v512] = v510[v512] + 1;
        end;
    end;

    return v509, v507, v511, p505;
end;

local function DecodeUntilEndOfBlock(p513, p514, p515, p516, p517, p518, p519) -- Line: 2516
    -- upvalues: u14 (copy), u28 (copy), u26 (copy), u29 (copy), u34 (copy), concat (copy)
    local buffer = p513.buffer;
    local buffer_size = p513.buffer_size;
    local ReadBits = p513.ReadBits;
    local Decode = p513.Decode;
    local ReaderBitlenLeft = p513.ReaderBitlenLeft;
    local result_buffer = p513.result_buffer;
    local dictionary = p513.dictionary;
    local v520, v521, v522;

    if dictionary and not buffer[0] then
        v520 = dictionary.string_table;
        v521 = dictionary.strlen;
        v522 = -v521 + 1;

        for i = 0, -v521 + 1 < -257 and -257 or -v521 + 1, -1 do
            buffer[i] = u14[v520[v521 + i]];
        end;
    else
        v522 = 1;
        v520 = nil;
        v521 = nil;
    end;

    while true do
        local v523 = Decode(p514, p515, p516);

        if v523 < 0 or v523 > 285 then
            break;
        end;

        if v523 < 256 then
            buffer_size = buffer_size + 1;
            buffer[buffer_size] = u14[v523];
        elseif v523 > 256 then
            local v524 = v523 - 256;
            local v525 = u28[v524];

            if v524 >= 8 then
                v525 = v525 + ReadBits(u26[v524]) or v525;
            end;

            v523 = Decode(p517, p518, p519);

            if v523 < 0 or v523 > 29 then
                return -10;
            end;

            local v526 = u29[v523];

            if v526 > 4 then
                v526 = v526 + ReadBits(u34[v523]) or v526;
            end;

            local v527 = buffer_size - v526 + 1;

            if v527 < v522 then
                return -11;
            end;

            if v527 >= -257 then
                for _ = 1, v525 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = buffer[v527];
                    v527 = v527 + 1;
                end;
            else
                local v528 = v521 + v527;

                for _ = 1, v525 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = u14[v520[v528]];
                    v528 = v528 + 1;
                end;
            end;
        end;

        if ReaderBitlenLeft() < 0 then
            return 2;
        end;

        if buffer_size >= 65536 then
            result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768);

            for i = 32769, buffer_size do
                buffer[i - 32768] = buffer[i];
            end;

            buffer_size = buffer_size - 32768;
            buffer[buffer_size + 1] = nil;
        end;

        if v523 == 256 then
            p513.buffer_size = buffer_size;

            return 0;
        end;
    end;

    return -10;
end;

local function DecompressStoreBlock(p529) -- Line: 2614
    -- upvalues: concat (copy)
    local buffer = p529.buffer;
    local buffer_size = p529.buffer_size;
    local ReadBits = p529.ReadBits;
    local ReadBytes = p529.ReadBytes;
    local ReaderBitlenLeft = p529.ReaderBitlenLeft;
    local result_buffer = p529.result_buffer;
    p529.SkipToByteBoundary();
    local v530 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    local v531 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    if v530 % 256 + v531 % 256 ~= 255 then
        return -2;
    end;

    if (v530 - v530 % 256) / 256 + (v531 - v531 % 256) / 256 ~= 255 then
        return -2;
    end;

    local v532 = ReadBytes(v530, buffer, buffer_size);

    if v532 < 0 then
        return 2;
    end;

    if v532 >= 65536 then
        result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768);

        for i = 32769, v532 do
            buffer[i - 32768] = buffer[i];
        end;

        v532 = v532 - 32768;
        buffer[v532 + 1] = nil;
    end;

    p529.buffer_size = v532;

    return 0;
end;

local function DecompressFixBlock(p533) -- Line: 2660
    -- upvalues: DecodeUntilEndOfBlock (copy), u23 (ref), u24 (ref), u31 (ref), u30 (ref)
    return DecodeUntilEndOfBlock(p533, u23, u24, 7, u31, u30, 5);
end;

local function DecompressDynamicBlock(p534) -- Line: 2671
    -- upvalues: u32 (copy), GetHuffmanForDecode (copy), DecodeUntilEndOfBlock (copy)
    local ReadBits = p534.ReadBits;
    local Decode = p534.Decode;
    local v535 = ReadBits(5) + 257;
    local v536 = ReadBits(5) + 1;
    local v537 = ReadBits(4) + 4;

    if v535 > 286 or v536 > 30 then
        return -3;
    end;

    local v538 = {};

    for i = 1, v537 do
        v538[u32[i]] = ReadBits(3);
    end;

    local v539, v540, v541, v542 = GetHuffmanForDecode(v538, 18, 7);

    if v539 ~= 0 then
        return -4;
    end;

    local v543 = 0;
    local v544 = {};
    local v545 = {};

    while v543 < v535 + v536 do
        local v546 = Decode(v540, v541, v542);

        if v546 < 0 then
            return v546;
        end;

        if v546 < 16 then
            if v543 < v535 then
                v544[v543] = v546;
            else
                v545[v543 - v535] = v546;
            end;

            v543 = v543 + 1;
        else
            local v547 = 0;
            local v548;

            if v546 == 16 then
                if v543 == 0 then
                    return -5;
                end;

                if v543 - 1 < v535 then
                    v547 = v544[v543 - 1];
                else
                    v547 = v545[v543 - v535 - 1];
                end;

                v548 = 3 + ReadBits(2);
            elseif v546 == 17 then
                v548 = 3 + ReadBits(3);
            else
                v548 = 11 + ReadBits(7);
            end;

            if v543 + v548 > v535 + v536 then
                return -6;
            end;

            while v548 > 0 do
                v548 = v548 - 1;

                if v543 < v535 then
                    v544[v543] = v547;
                else
                    v545[v543 - v535] = v547;
                end;

                v543 = v543 + 1;
            end;
        end;
    end;

    if (v544[256] or 0) == 0 then
        return -9;
    end;

    local v549, v550, v551, v552 = GetHuffmanForDecode(v544, v535 - 1, 15);

    if v549 ~= 0 and (v549 < 0 or v535 ~= (v550[0] or 0) + (v550[1] or 0)) then
        return -7;
    end;

    local v553, v554, v555, v556 = GetHuffmanForDecode(v545, v536 - 1, 15);

    return v553 ~= 0 and (v553 < 0 or v536 ~= (v554[0] or 0) + (v554[1] or 0)) and -8 or DecodeUntilEndOfBlock(p534, v550, v551, v552, v554, v555, v556);
end;

local function Inflate(p557) -- Line: 2789
    -- upvalues: DecompressStoreBlock (copy), DecodeUntilEndOfBlock (copy), u23 (ref), u24 (ref), u31 (ref), u30 (ref), DecompressDynamicBlock (copy), concat (copy)
    local ReadBits = p557.ReadBits;
    local v558 = nil;

    while not v558 do
        v558 = ReadBits(1) == 1;
        local v559 = ReadBits(2);
        local v560;

        if v559 == 0 then
            v560 = DecompressStoreBlock(p557);
        elseif v559 == 1 then
            v560 = DecodeUntilEndOfBlock(p557, u23, u24, 7, u31, u30, 5);
        else
            if v559 ~= 2 then
                return nil, -1;
            end;

            v560 = DecompressDynamicBlock(p557);
        end;

        if v560 ~= 0 then
            return nil, v560;
        end;
    end;

    p557.result_buffer[#p557.result_buffer + 1] = concat(p557.buffer, "", 1, p557.buffer_size);

    return concat(p557.result_buffer);
end;

local function DecompressDeflateInternal(p561, p562) -- Line: 2819
    -- upvalues: CreateDecompressState (copy), Inflate (copy)
    local v563 = CreateDecompressState(p561, p562);
    local v564, v565 = Inflate(v563);

    if not v564 then
        return nil, v565;
    end;

    local v566 = v563.ReaderBitlenLeft();

    return v564, (v566 - v566 % 8) / 8;
end;

local function DecompressZlibInternal(p567, p568) -- Line: 2833
    -- upvalues: CreateDecompressState (copy), Inflate (copy), u2 (ref)
    local v569 = CreateDecompressState(p567, p568);
    local ReadBits = v569.ReadBits;
    local v570 = ReadBits(8);

    if v569.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v571 = v570 % 16;

    if v571 ~= 8 then
        return nil, -12;
    end;

    if (v570 - v571) / 16 > 7 then
        return nil, -13;
    end;

    local v572 = ReadBits(8);

    if v569.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    if (v570 * 256 + v572) % 31 ~= 0 then
        return nil, -14;
    end;

    local _ = (v572 - v572 % 64) / 64 % 4;

    if (v572 - v572 % 32) / 32 % 2 == 1 then
        if not p568 then
            return nil, -16;
        end;

        local v573 = ReadBits(8);
        local v574 = ReadBits(8);
        local v575 = ReadBits(8);
        local v576 = ReadBits(8);

        if v569.ReaderBitlenLeft() < 0 then
            return nil, 2;
        end;

        if (v573 * 16777216 + v574 * 65536 + v575 * 256 + v576) % 4294967296 ~= p568.adler32 % 4294967296 then
            return nil, -17;
        end;
    end;

    local v577, v578 = Inflate(v569);

    if not v577 then
        return nil, v578;
    end;

    v569.SkipToByteBoundary();
    local v579 = ReadBits(8);
    local v580 = ReadBits(8);
    local v581 = ReadBits(8);
    local v582 = ReadBits(8);

    if v569.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v583 = u2:Adler32(v577);

    if (v579 * 16777216 + v580 * 65536 + v581 * 256 + v582) % 4294967296 ~= v583 % 4294967296 then
        return nil, -15;
    end;

    local v584 = v569.ReaderBitlenLeft();

    return v577, (v584 - v584 % 8) / 8;
end;

function u2.DecompressDeflate(p585, p586) -- Line: 2916
    -- upvalues: u13 (copy), u10 (copy), DecompressDeflateInternal (copy)
    local v587, v588;

    if u13(p586) == "string" then
        v587 = true;
        v588 = "";
    else
        v588 = ("\'str\' - string expected got \'%s\'."):format((u13(p586)));
        v587 = false;
    end;

    if not v587 then
        u10("Usage: LibDeflate:DecompressDeflate(str): " .. v588, 2);
    end;

    return DecompressDeflateInternal(p586);
end;

function u2.DecompressDeflateWithDict(p589, p590, p591) -- Line: 2943
    -- upvalues: u13 (copy), IsValidDictionary (copy), u10 (copy), DecompressDeflateInternal (copy)
    local v592, v593;

    if u13(p590) == "string" then
        local v594;
        v594, v592 = IsValidDictionary(p591);

        if v594 then
            v593 = true;
            v592 = "";
        else
            v593 = false;
        end;
    else
        v592 = ("\'str\' - string expected got \'%s\'."):format((u13(p590)));
        v593 = false;
    end;

    if not v593 then
        u10("Usage: LibDeflate:DecompressDeflateWithDict(str, dictionary): " .. v592, 2);
    end;

    return DecompressDeflateInternal(p590, p591);
end;

function u2.DecompressZlib(p595, p596) -- Line: 2965
    -- upvalues: u13 (copy), u10 (copy), DecompressZlibInternal (copy)
    local v597, v598;

    if u13(p596) == "string" then
        v597 = true;
        v598 = "";
    else
        v598 = ("\'str\' - string expected got \'%s\'."):format((u13(p596)));
        v597 = false;
    end;

    if not v597 then
        u10("Usage: LibDeflate:DecompressZlib(str): " .. v598, 2);
    end;

    return DecompressZlibInternal(p596);
end;

function u2.DecompressZlibWithDict(p599, p600, p601) -- Line: 2992
    -- upvalues: u13 (copy), IsValidDictionary (copy), u10 (copy), DecompressZlibInternal (copy)
    local v602, v603;

    if u13(p600) == "string" then
        local v604;
        v604, v602 = IsValidDictionary(p601);

        if v604 then
            v603 = true;
            v602 = "";
        else
            v603 = false;
        end;
    else
        v602 = ("\'str\' - string expected got \'%s\'."):format((u13(p600)));
        v603 = false;
    end;

    if not v603 then
        u10("Usage: LibDeflate:DecompressZlibWithDict(str, dictionary): " .. v602, 2);
    end;

    return DecompressZlibInternal(p600, p601);
end;

u33 = {};

for i = 0, 143 do
    u33[i] = 8;
end;

for i = 144, 255 do
    u33[i] = 9;
end;

u33[256] = 7;
u33[257] = 7;
u33[258] = 7;
u33[259] = 7;
u33[260] = 7;
u33[261] = 7;
u33[262] = 7;
u33[263] = 7;
u33[264] = 7;
u33[265] = 7;
u33[266] = 7;
u33[267] = 7;
u33[268] = 7;
u33[269] = 7;
u33[270] = 7;
u33[271] = 7;
u33[272] = 7;
u33[273] = 7;
u33[274] = 7;
u33[275] = 7;
u33[276] = 7;
u33[277] = 7;
u33[278] = 7;
u33[279] = 7;
u33[280] = 8;
u33[281] = 8;
u33[282] = 8;
u33[283] = 8;
u33[284] = 8;
u33[285] = 8;
u33[286] = 8;
u33[287] = 8;
local v605 = {};

for i = 0, 31 do
    v605[i] = 5;
end;

local v606, v607, v608 = GetHuffmanForDecode(u33, 287, 9);
u23 = v607;
u24 = v608;
u9(v606 == 0);
local v609, v610, v611 = GetHuffmanForDecode(v605, 31, 5);
u31 = v610;
u30 = v611;
u9(v609 == 0);
u25 = GetHuffmanCodeFromBitlen(u23, u33, 287, 9);
u27 = GetHuffmanCodeFromBitlen(u31, v605, 31, 5);
local u612 = {
    ["\0"] = "%z",
    ["("] = "%(",
    [")"] = "%)",
    ["."] = "%.",
    ["%"] = "%%",
    ["+"] = "%+",
    ["-"] = "%-",
    ["*"] = "%*",
    ["?"] = "%?",
    ["["] = "%[",
    ["]"] = "%]",
    ["^"] = "%^",
    ["$"] = "%$"
};

local function escape_for_gsub(p613) -- Line: 3056
    -- upvalues: u612 (copy)
    return p613:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u612);
end;

function u2.CreateCodec(p614, p615, p616, p617) -- Line: 3100
    -- upvalues: u13 (copy), u10 (copy), byte (copy), sub (copy), concat (copy), u612 (copy), u14 (copy), gsub (copy), find (copy)
    if u13(p615) ~= "string" or (u13(p616) ~= "string" or u13(p617) ~= "string") then
        u10(
            "Usage: LibDeflate:CreateCodec(reserved_chars, escape_chars, map_chars): All arguments must be string.",
            2
        );
    end;

    if p616 == "" then
        return nil, "No escape characters supplied.";
    end;

    if #p615 < #p617 then
        return nil, "The number of reserved characters must be at least as many as the number of mapped chars.";
    end;

    if p615 == "" then
        return nil, "No characters to encode.";
    end;

    local v618 = p615 .. p616 .. p617;
    local v619 = {};

    for i = 1, #v618 do
        local v620 = byte(v618, i, i);

        if v619[v620] then
            return nil, "There must be no duplicate characters in the concatenation of reserved_chars, escape_chars and map_chars.";
        end;

        v619[v620] = true;
    end;

    local u621 = {};
    local u622 = {};
    local v623 = {};
    local u624 = {};

    if #p617 > 0 then
        local v625 = {};
        local v626 = {};

        for i = 1, #p617 do
            local v627 = sub(p615, i, i);
            local v628 = sub(p617, i, i);
            u624[v627] = v628;
            v623[#v623 + 1] = v627;
            v625[v628] = v627;
            v626[#v626 + 1] = v628;
        end;

        u621[#u621 + 1] = "([" .. concat(v626):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u612) .. "])";
        u622[#u622 + 1] = v625;
    end;

    local v629 = 1;
    local v630 = sub(p616, v629, v629);
    local v631 = 0;
    local v632 = {};
    local v633 = {};

    for i = 1, #v618 do
        local v634 = sub(v618, i, i);

        if not u624[v634] then
            while v631 >= 256 or v619[v631] do
                v631 = v631 + 1;

                if v631 > 255 then
                    u621[#u621 + 1] = v630:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u612) .. "([" .. concat(v632):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u612) .. "])";
                    u622[#u622 + 1] = v633;
                    v629 = v629 + 1;
                    v630 = sub(p616, v629, v629);

                    if not v630 or v630 == "" then
                        return nil, "Out of escape characters.";
                    end;

                    v631 = 0;
                    v632 = {};
                    v633 = {};
                end;
            end;

            local v635 = u14[v631];
            u624[v634] = v630 .. v635;
            v623[#v623 + 1] = v634;
            v633[v635] = v634;
            v632[#v632 + 1] = v635;
            v631 = v631 + 1;
        end;

        if i == #v618 then
            u621[#u621 + 1] = v630:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u612) .. "([" .. concat(v632):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u612) .. "])";
            u622[#u622 + 1] = v633;
        end;
    end;

    local v636 = {};
    local u637 = "([" .. concat(v623):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u612) .. "])";

    function v636.Encode(p638, p639) -- Line: 3218
        -- upvalues: u13 (ref), u10 (ref), gsub (ref), u637 (copy), u624 (copy)
        if u13(p639) ~= "string" then
            u10(("Usage: codec:Encode(str): \'str\' - string expected got \'%s\'."):format((u13(p639))), 2);
        end;

        return gsub(p639, u637, u624);
    end;

    local u640 = #u621;
    local u641 = "([" .. p615:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u612) .. "])";

    function v636.Decode(p642, p643) -- Line: 3230
        -- upvalues: u13 (ref), u10 (ref), find (ref), u641 (copy), u640 (copy), gsub (ref), u621 (copy), u622 (copy)
        if u13(p643) ~= "string" then
            u10(("Usage: codec:Decode(str): \'str\' - string expected got \'%s\'."):format((u13(p643))), 2);
        end;

        if find(p643, u641) then
            return nil;
        end;

        for i = 1, u640 do
            p643 = gsub(p643, u621[i], u622[i]);
        end;

        return p643;
    end;

    return v636;
end;

local u644 = nil;
local u645 = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "(", ")" };
local u646 = {
    [97] = 0,
    [98] = 1,
    [99] = 2,
    [100] = 3,
    [101] = 4,
    [102] = 5,
    [103] = 6,
    [104] = 7,
    [105] = 8,
    [106] = 9,
    [107] = 10,
    [108] = 11,
    [109] = 12,
    [110] = 13,
    [111] = 14,
    [112] = 15,
    [113] = 16,
    [114] = 17,
    [115] = 18,
    [116] = 19,
    [117] = 20,
    [118] = 21,
    [119] = 22,
    [120] = 23,
    [121] = 24,
    [122] = 25,
    [65] = 26,
    [66] = 27,
    [67] = 28,
    [68] = 29,
    [69] = 30,
    [70] = 31,
    [71] = 32,
    [72] = 33,
    [73] = 34,
    [74] = 35,
    [75] = 36,
    [76] = 37,
    [77] = 38,
    [78] = 39,
    [79] = 40,
    [80] = 41,
    [81] = 42,
    [82] = 43,
    [83] = 44,
    [84] = 45,
    [85] = 46,
    [86] = 47,
    [87] = 48,
    [88] = 49,
    [89] = 50,
    [90] = 51,
    [48] = 52,
    [49] = 53,
    [50] = 54,
    [51] = 55,
    [52] = 56,
    [53] = 57,
    [54] = 58,
    [55] = 59,
    [56] = 60,
    [57] = 61,
    [40] = 62,
    [41] = 63
};

function u2.EncodeForPrint(p647, p648) -- Line: 3289
    -- upvalues: u13 (copy), u10 (copy), byte (copy), u645 (copy), u15 (copy), concat (copy)
    if u13(p648) ~= "string" then
        u10(("Usage: LibDeflate:EncodeForPrint(str): \'str\' - string expected got \'%s\'."):format((u13(p648))), 2);
    end;

    local v649 = #p648;
    local v650 = 1;
    local v651 = 0;
    local v652 = {};

    while v650 <= v649 - 2 do
        local v653, v654, v655 = byte(p648, v650, v650 + 2);
        v650 = v650 + 3;
        local v656 = v653 + v654 * 256 + v655 * 65536;
        local v657 = v656 % 64;
        local v658 = (v656 - v657) / 64;
        local v659 = v658 % 64;
        local v660 = (v658 - v659) / 64;
        local v661 = v660 % 64;
        v651 = v651 + 1;
        v652[v651] = u645[v657] .. u645[v659] .. u645[v661] .. u645[(v660 - v661) / 64];
    end;

    local v662 = 0;
    local v663 = 0;

    while v650 <= v649 do
        v663 = v663 + byte(p648, v650, v650) * u15[v662];
        v662 = v662 + 8;
        v650 = v650 + 1;
    end;

    while v662 > 0 do
        local v664 = v663 % 64;
        v651 = v651 + 1;
        v652[v651] = u645[v664];
        v663 = (v663 - v664) / 64;
        v662 = v662 - 6;
    end;

    return concat(v652);
end;

function u2.DecodeForPrint(p665, p666) -- Line: 3344
    -- upvalues: u13 (copy), u10 (copy), byte (copy), u646 (copy), u14 (copy), u15 (copy), concat (copy)
    if u13(p666) ~= "string" then
        u10(("Usage: LibDeflate:DecodeForPrint(str): \'str\' - string expected got \'%s\'."):format((u13(p666))), 2);
    end;

    local v667 = p666:gsub("^[%c ]+", ""):gsub("[%c ]+$", "");
    local v668 = #v667;

    if v668 == 1 then
        return nil;
    end;

    local v669 = 1;
    local v670 = 0;
    local v671 = {};

    while v669 <= v668 - 3 do
        local v672, v673, v674, v675 = byte(v667, v669, v669 + 3);
        local v676 = u646[v672];
        local v677 = u646[v673];
        local v678 = u646[v674];
        local v679 = u646[v675];

        if not (v676 and (v677 and (v678 and v679))) then
            return nil;
        end;

        v669 = v669 + 4;
        local v680 = v676 + v677 * 64 + v678 * 4096 + v679 * 262144;
        local v681 = v680 % 256;
        local v682 = (v680 - v681) / 256;
        local v683 = v682 % 256;
        v670 = v670 + 1;
        v671[v670] = u14[v681] .. u14[v683] .. u14[(v682 - v683) / 256];
    end;

    local v684 = 0;
    local v685 = 0;

    while v669 <= v668 do
        local v686 = u646[byte(v667, v669, v669)];

        if not v686 then
            return nil;
        end;

        v685 = v685 + v686 * u15[v684];
        v684 = v684 + 6;
        v669 = v669 + 1;
    end;

    while v684 >= 8 do
        local v687 = v685 % 256;
        v670 = v670 + 1;
        v671[v670] = u14[v687];
        v685 = (v685 - v687) / 256;
        v684 = v684 - 8;
    end;

    return concat(v671);
end;

u2.internals = {
    LoadStringToTable = LoadStringToTable,
    IsValidDictionary = IsValidDictionary,
    IsEqualAdler32 = IsEqualAdler32,
    _byte_to_6bit_char = u645,
    _6bit_to_byte = u646,

    InternalClearCache = function() -- Line: 3404, Name: InternalClearCache
        -- upvalues: u644 (ref)
        u644 = nil;
    end
};

return v1;