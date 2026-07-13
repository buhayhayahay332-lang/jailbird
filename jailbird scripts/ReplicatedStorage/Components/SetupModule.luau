
return function(p1, p2, p3, p4, p5) -- Line: 1
    Instance.new("Humanoid").Parent = p1;

    if p2:FindFirstChild("Shirt") then
        local v6 = p1:FindFirstChild("Clothing") or Instance.new("Shirt");
        v6.Parent = p1;
        v6.ShirtTemplate = p2.Shirt.ShirtTemplate;
    end;

    local v7 = p2:WaitForChild("Right Arm"):clone();
    v7.Material = Enum.Material.Plastic;
    v7.FormFactor = "Custom";
    v7.Size = Vector3.new(0.6, 2, 0.6);
    local v8 = p2:WaitForChild("Left Arm"):clone();
    v8.Material = Enum.Material.Plastic;
    v8.FormFactor = "Custom";
    v8.Size = Vector3.new(0.6, 2, 0.6);

    for _, child in pairs(v7:GetChildren()) do
        if child then
            child:Destroy();
        end;
    end;

    for _, child in pairs(v8:GetChildren()) do
        if child then
            child:Destroy();
        end;
    end;

    v7.Parent = p1;
    local Motor6D = Instance.new("Motor6D");
    Motor6D.Name = "RAW";
    Motor6D.Parent = p3;
    Motor6D.Part0 = p3;
    Motor6D.Part1 = v7;
    Motor6D.C1 = p4.RightPos;
    v8.Parent = p1;
    local Motor6D2 = Instance.new("Motor6D");
    Motor6D2.Name = "LAW";
    Motor6D2.Parent = p3;
    Motor6D2.Part0 = p3;
    Motor6D2.Part1 = v8;
    Motor6D2.C1 = p4.LeftPos;
    local Handle = p5:WaitForChild("Handle");
    local Motor6D3 = Instance.new("Motor6D");
    Motor6D3.Name = "HandleW";
    Motor6D3.Parent = Handle;
    Motor6D3.Part0 = v7;
    Motor6D3.Part1 = Handle;
    Handle.Anchored = false;
    Motor6D3.C1 = p4.GunPos;

    return Motor6D, Motor6D2, v7, v8, Handle, Motor6D3;
end;