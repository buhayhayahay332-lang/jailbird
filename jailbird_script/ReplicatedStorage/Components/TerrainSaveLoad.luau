
local v1 = {};

local function SaveTerrainProperty(p2, p3, p4) -- Line: 22
    local v5 = Instance.new(p3);
    v5.Name = p2;
    v5.Value = workspace.Terrain[p2];
    v5.Parent = p4;
end;

local function LoadTerrainProperty(p6, p7) -- Line: 29
    local v8 = p6:FindFirstChild(p7);

    if v8 then
        workspace.Terrain[p7] = v8.Value;
    end;
end;

local function AttemptGetMaterialColor(u9) -- Line: 36
    return pcall(function() -- Line: 37
        -- upvalues: u9 (copy)
        return workspace.Terrain:GetMaterialColor(u9);
    end);
end;

local function AttemptSetMaterialColor(u10, u11) -- Line: 42
    return pcall(function() -- Line: 43
        -- upvalues: u10 (copy), u11 (copy)
        workspace.Terrain:SetMaterialColor(u10, u11);
    end);
end;

function v1.Save() -- Line: 48
    local v12 = workspace.Terrain:CopyRegion(workspace.Terrain.MaxExtents);
    v12.Name = "SavedTerrain";
    local Folder = Instance.new("Folder");
    Folder.Name = "WaterProperties";
    local Color3Value = Instance.new("Color3Value");
    Color3Value.Name = "WaterColor";
    Color3Value.Value = workspace.Terrain.WaterColor;
    Color3Value.Parent = Folder;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = "WaterReflectance";
    NumberValue.Value = workspace.Terrain.WaterReflectance;
    NumberValue.Parent = Folder;
    local NumberValue2 = Instance.new("NumberValue");
    NumberValue2.Name = "WaterTransparency";
    NumberValue2.Value = workspace.Terrain.WaterTransparency;
    NumberValue2.Parent = Folder;
    local NumberValue3 = Instance.new("NumberValue");
    NumberValue3.Name = "WaterWaveSize";
    NumberValue3.Value = workspace.Terrain.WaterWaveSize;
    NumberValue3.Parent = Folder;
    local NumberValue4 = Instance.new("NumberValue");
    NumberValue4.Name = "WaterWaveSpeed";
    NumberValue4.Value = workspace.Terrain.WaterWaveSpeed;
    NumberValue4.Parent = Folder;
    Folder.Parent = v12;
    local Folder2 = Instance.new("Folder");
    Folder2.Name = "MaterialColors";

    for _, v in Enum.Material:GetEnumItems() do
        local success, result = pcall(function() -- Line: 37
            -- upvalues: v (copy)
            return workspace.Terrain:GetMaterialColor(v);
        end);

        if success then
            local Color3Value2 = Instance.new("Color3Value");
            Color3Value2.Name = v.Name;
            Color3Value2.Value = result;
            Color3Value2.Parent = Folder2;
        end;
    end;

    Folder2.Parent = v12;

    return v12;
end;

function v1.Load(p13) -- Line: 78
    if typeof(p13) ~= "Instance" or not p13:IsA("TerrainRegion") then
        error("Expected TerrainRegion object as argument to Load", 2);
    end;

    local v14 = Vector3int16.new(-math.floor(p13.SizeInCells.X / 2), -math.floor(p13.SizeInCells.Y / 2), -math.floor(p13.SizeInCells.Z / 2));
    workspace.Terrain:PasteRegion(p13, v14, true);
    local WaterProperties = p13:FindFirstChild("WaterProperties");

    if WaterProperties then
        local WaterColor = WaterProperties:FindFirstChild("WaterColor");

        if WaterColor then
            workspace.Terrain.WaterColor = WaterColor.Value;
        end;

        local WaterReflectance = WaterProperties:FindFirstChild("WaterReflectance");

        if WaterReflectance then
            workspace.Terrain.WaterReflectance = WaterReflectance.Value;
        end;

        local WaterTransparency = WaterProperties:FindFirstChild("WaterTransparency");

        if WaterTransparency then
            workspace.Terrain.WaterTransparency = WaterTransparency.Value;
        end;

        local WaterWaveSize = WaterProperties:FindFirstChild("WaterWaveSize");

        if WaterWaveSize then
            workspace.Terrain.WaterWaveSize = WaterWaveSize.Value;
        end;

        local WaterWaveSpeed = WaterProperties:FindFirstChild("WaterWaveSpeed");

        if WaterWaveSpeed then
            workspace.Terrain.WaterWaveSpeed = WaterWaveSpeed.Value;
        end;
    end;

    local MaterialColors = p13:FindFirstChild("MaterialColors");

    if MaterialColors then
        for _, v in Enum.Material:GetEnumItems() do
            local v15 = MaterialColors:FindFirstChild(v.Name);

            if v15 then
                local Value = v15.Value;
                pcall(function() -- Line: 43
                    -- upvalues: v (copy), Value (copy)
                    workspace.Terrain:SetMaterialColor(v, Value);
                end);
            end;
        end;
    end;
end;

return v1;