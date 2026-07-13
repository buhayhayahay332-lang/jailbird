
local RunService = game:GetService("RunService");
local u1 = {
    IsEnabled = function() -- Line: 5, Name: IsEnabled
        -- upvalues: RunService (copy)
        return RunService:IsStudio();
    end
};

function u1.Warn(...) -- Line: 9
    -- upvalues: u1 (copy)
    if u1.IsEnabled() ~= true then
        return;
    end;

    warn(...);
end;

return u1;