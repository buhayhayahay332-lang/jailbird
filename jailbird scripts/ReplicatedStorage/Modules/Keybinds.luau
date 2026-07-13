
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.Modules.Utility);
local Keybinds = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Keybinds");
local u1 = {};
local v2 = {};
local DefaultKeybinds = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DefaultKeybinds"));
local _ = Enum.KeyCode;
local _ = Enum.UserInputType;
("[%*]: "):format(script.Name);

local function deepCopy(p3) -- Line: 39
    -- upvalues: deepCopy (copy)
    local v4 = {};

    for i, v in p3 do
        if type(v) == "table" then
            local v = deepCopy(v) or v;
        end;

        v4[i] = v;
    end;

    return v4;
end;

function v2.updateKeybinds() -- Line: 50
    -- upvalues: Keybinds (copy), u1 (ref), Utility (copy), deepCopy (copy), DefaultKeybinds (copy)
    local v5, v6 = Keybinds:WaitForChild("GetKeybinds"):InvokeServer();

    if v5 then
        u1 = v6;
    else
        warn(Utility.warnCustom("Failed to load keybinds for the reason: " .. tostring(v6) .. " Default keybinds loaded instead"));
        u1 = deepCopy(DefaultKeybinds);
    end;

    local v7 = u1;

    for i, v in pairs({
        PC = u1.PC,
        Controller = u1.Controller
    }) do
        for i2, v3 in pairs(v) do
            v7[i][i2] = Enum[v3[2]][v3[1]];
        end;
    end;

    u1 = v7;

    function u1.GetReloadKeys() -- Line: 81
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.Reload, u1.Controller.Reload });
    end;

    function u1.GetJumpKeys() -- Line: 89
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.Jump, u1.Controller.Jump });
    end;

    function u1.GetSwapKeys() -- Line: 97
        -- upvalues: u1 (ref)
        return unpack({
            u1.PC.SwapTool1,
            u1.PC.SwapTool2,
            u1.PC.SwapTool3,
            u1.PC.SwapTool4,
            u1.Controller.SwapTool
        });
    end;

    function u1.GetQuickKnifeKeys() -- Line: 109
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.QuickKnife, u1.Controller.QuickKnife });
    end;

    function u1.GetPingKeys() -- Line: 117
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.Ping, u1.Controller.Ping });
    end;

    function u1.GetQuickThrowKeys() -- Line: 125
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.QuickThrow, u1.Controller.QuickThrow });
    end;

    function u1.GetCrouchKeys() -- Line: 133
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.Crouch, u1.Controller.Crouch });
    end;

    function u1.GetRunKeys() -- Line: 141
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.Run, u1.Controller.Run });
    end;

    function u1.GetLeanKeys() -- Line: 149
        -- upvalues: u1 (ref)
        return unpack({
            u1.PC.LeanLeft,
            u1.PC.LeanRight,
            u1.Controller.LeanLeft,
            u1.Controller.LeanRight
        });
    end;

    function u1.GetProneKeys() -- Line: 160
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.Prone, u1.Controller.Prone });
    end;

    function u1.GetShootKeys() -- Line: 168
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.Shoot, u1.Controller.Shoot });
    end;

    function u1.GetAimKeys() -- Line: 176
        -- upvalues: u1 (ref)
        return unpack({ u1.PC.Aim, u1.Controller.Aim });
    end;

    return u1;
end;

return v2;