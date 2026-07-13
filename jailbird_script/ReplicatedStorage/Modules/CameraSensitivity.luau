
local v1 = {};
local u2 = `[{script.Name}]: `;
local u3 = 1;
local LocalPlayer = game:GetService("Players").LocalPlayer;
local CameraInput = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("CameraInput"));
local getRotation = CameraInput.getRotation;

function CameraInput.getRotation(...) -- Line: 20
    -- upvalues: getRotation (copy), u3 (ref)
    getRotation(...);

    return getRotation(...) * u3;
end;

function v1.AdjustSensitivity(p4, p5) -- Line: 50
    -- upvalues: u2 (copy), u3 (ref)
    if not p5 then
        warn(u2 .. "Failed to change sens because number is nil or false");
    end;

    if typeof(p5) ~= "number" then
        warn(u2 .. "Failed to change sens because number is not a number: " .. tostring(p5));
    end;

    u3 = p5;
end;

return v1;