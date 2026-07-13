
return {
    Weld = function(p1, p2, p3, p4) -- Line: 3
        local Motor6D = Instance.new("Motor6D", p1);
        Motor6D.Part0 = p1;
        Motor6D.Part1 = p2;
        Motor6D.Name = p1.Name;
        Motor6D.C0 = p3 or p1.CFrame:inverse() * p2.CFrame;
        Motor6D.C1 = p4 or CFrame.new();

        return Motor6D;
    end,

    WeldComplex = function(p5, p6, p7) -- Line: 13
        local Motor6D = Instance.new("Motor6D");
        Motor6D.Name = p7;
        Motor6D.Part0 = p5;
        Motor6D.Part1 = p6;
        local v8 = CFrame.new(p5.Position);
        local v9 = p5.CFrame:inverse() * v8;
        local v10 = p6.CFrame:inverse() * v8;
        Motor6D.C0 = v9;
        Motor6D.C1 = v10;
        Motor6D.Parent = p5;

        return Motor6D;
    end,

    CheckForHumanoid = function(p11) -- Line: 27
        local v12;

        if p11 and (p11.Parent:FindFirstChild("Humanoid") or p11.Parent.Parent:FindFirstChild("Humanoid")) then
            v12 = true;

            if p11.Parent:FindFirstChild("Humanoid") then
                return v12, p11.Parent.Humanoid;
            end;

            if p11.Parent.Parent:FindFirstChild("Humanoid") then
                return v12, p11.Parent.Parent.Humanoid;
            end;
        else
            v12 = false;
        end;

        return v12, nil;
    end
};