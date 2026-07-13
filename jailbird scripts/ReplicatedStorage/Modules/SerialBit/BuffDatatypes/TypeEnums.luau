
local u1 = {
    ["nil"] = 0,
    boolean = 1,
    number = 2,
    string = 3,
    Vector2 = 4,
    Vector3 = 5,
    Vector2int16 = 6,
    Vector3int16 = 7,
    CFrame = 8,
    EnumItem = 9,
    Color3 = 10,
    ColorSequenceKeypoint = 11,
    ColorSequence = 12,
    NumberSequenceKeypoint = 13,
    NumberSequence = 14,
    Rect = 15,
    Ray = 16,
    PhysicalProperties = 17,
    NumberRange = 18,
    UDim = 19,
    UDim2 = 20,
    BrickColor = 21,
    Faces = 22,
    Font = 23
};

return {
    toTypeValue = function(p2) -- Line: 31, Name: toTypeValue
        -- upvalues: u1 (copy)
        return u1[p2];
    end,

    toTypeName = function(p3) -- Line: 35, Name: toTypeName
        -- upvalues: u1 (copy)
        for i, v in u1 do
            if v == p3 then
                return i;
            end;
        end;

        return nil;
    end
};