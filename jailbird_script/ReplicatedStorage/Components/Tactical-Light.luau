
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
u1.__index = u1;

local function setEnabled(p2, p3) -- Line: 9
    if not p2 then
        return;
    end;

    if p2:IsA("ParticleEmitter") or (p2:IsA("PointLight") or p2:IsA("SpotLight")) then
        p2.Enabled = p3;
    end;
end;

function u1.new(p4) -- Line: 19
    -- upvalues: u1 (copy)
    local v5 = setmetatable({}, u1);
    v5.Instance = p4;

    repeat
        task.wait();
    until p4.PrimaryPart ~= nil;

    v5.Visuals = {};

    for _, descendant in ipairs(v5.Instance:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("PointLight") or descendant:IsA("SpotLight")) then
            table.insert(v5.Visuals, descendant);
        end;
    end;

    return v5;
end;

function u1.IsOwnerLocal(p6) -- Line: 35
    -- upvalues: RunService (copy), LocalPlayer (copy)
    if RunService:IsClient() and LocalPlayer then
        return p6.Instance:GetAttribute("Owner") == LocalPlayer.Name;
    end;

    return false;
end;

function u1.IsFirstPersonInstance(p7) -- Line: 43
    -- upvalues: RunService (copy)
    local v8 = RunService:IsClient();

    if v8 then
        if workspace.CurrentCamera == nil then
            v8 = false;
        else
            v8 = p7.Instance:IsDescendantOf(workspace.CurrentCamera);
        end;
    end;

    return v8;
end;

function u1.ShouldRender(p9) -- Line: 47
    -- upvalues: RunService (copy)
    if p9.Instance:GetAttribute("Active") == true then
        return (not RunService:IsClient() or (p9.Instance:GetAttribute("HideForOwner") ~= true or (not p9:IsOwnerLocal() or p9:IsFirstPersonInstance()))) and true or false;
    end;

    return false;
end;

function u1.RefreshState(p10) -- Line: 59
    local v11 = p10:ShouldRender();

    for _, v in ipairs(p10.Visuals) do
        if v then
            if v:IsA("ParticleEmitter") or (v:IsA("PointLight") or v:IsA("SpotLight")) then
                v.Enabled = v11;
            end;
        end;
    end;
end;

function u1.Init(u12) -- Line: 67
    if u12.Instance:GetAttribute("Active") == nil then
        u12.Instance:SetAttribute("Active", false);
    end;

    if u12.Instance:GetAttribute("HideForOwner") == nil then
        u12.Instance:SetAttribute("HideForOwner", false);
    end;

    u12.Instance:GetAttributeChangedSignal("Active"):Connect(function() -- Line: 76
        -- upvalues: u12 (copy)
        u12:RefreshState();
    end);
    u12.Instance:GetAttributeChangedSignal("HideForOwner"):Connect(function() -- Line: 80
        -- upvalues: u12 (copy)
        u12:RefreshState();
    end);
    u12.Instance.AncestryChanged:Connect(function() -- Line: 84
        -- upvalues: u12 (copy)
        u12:RefreshState();
    end);
    u12:RefreshState();
end;

return u1;