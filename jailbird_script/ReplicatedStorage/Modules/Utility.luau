
local u1 = {};

local function _getScriptNameFromSourcePath(p2) -- Line: 7
    local v3 = p2:gsub("^@", "");

    return v3:match("([^%.]+)$") or v3;
end;

function u1.formatWarnInstanceIsNil(p4, p5, p6) -- Line: 13
    local v7 = debug.info(2, "l") or "?";
    local v8 = (debug.info(2, "s") or "?"):gsub("^@", "");
    local v9 = v8:match("([^%.]+)$") or v8;
    local v10 = string.format("[%s]: \"%s\" is not a valid member of \"%s\"  -  Line %s", v9, p5, p4, v7);

    if p6 then
        v10 = v10 .. " | " .. p6;
    end;

    return v10;
end;

function u1.warnCustom(p11) -- Line: 33
    local v12 = debug.info(2, "l") or "?";
    local v13 = (debug.info(2, "s") or "?"):gsub("^@", "");
    local v14 = v13:match("([^%.]+)$") or v13;

    return string.format("[%s]: %s  -  Line %s", v14, p11 or "No message provided", v12);
end;

function u1.DeepFreeze(p15, p16) -- Line: 51
    -- upvalues: u1 (copy)
    table.freeze(p16);

    for _, v in pairs(p16) do
        if type(v) == "table" then
            u1:DeepFreeze(v);
        end;
    end;
end;

return table.freeze(u1);