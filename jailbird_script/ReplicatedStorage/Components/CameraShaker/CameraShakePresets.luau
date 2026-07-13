
local CameraShakeInstance = require(script.Parent.CameraShakeInstance);
local u15 = {
    Bump = function() -- Line: 26, Name: Bump
        -- upvalues: CameraShakeInstance (copy)
        local v1 = CameraShakeInstance.new(2.5, 4, 0.1, 0.75);
        v1.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v1.RotationInfluence = Vector3.new(1, 1, 1);

        return v1;
    end,

    Explosion = function() -- Line: 36, Name: Explosion
        -- upvalues: CameraShakeInstance (copy)
        local v2 = CameraShakeInstance.new(5, 10, 0, 1.5);
        v2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v2.RotationInfluence = Vector3.new(4, 1, 1);

        return v2;
    end,

    ExplosionChair = function() -- Line: 44, Name: ExplosionChair
        -- upvalues: CameraShakeInstance (copy)
        local v3 = CameraShakeInstance.new(0.8, 10, 0, 1.5);
        v3.PositionInfluence = Vector3.new(0.1, 0.1, 0.1);
        v3.RotationInfluence = Vector3.new(0.4, 0.4, 0.4);

        return v3;
    end,

    Earthquake = function() -- Line: 54, Name: Earthquake
        -- upvalues: CameraShakeInstance (copy)
        local v4 = CameraShakeInstance.new(0.6, 3.5, 2, 10);
        v4.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v4.RotationInfluence = Vector3.new(1, 1, 4);

        return v4;
    end,

    BadTrip = function() -- Line: 64, Name: BadTrip
        -- upvalues: CameraShakeInstance (copy)
        local v5 = CameraShakeInstance.new(10, 0.15, 5, 10);
        v5.PositionInfluence = Vector3.new(0, 0, 0.15);
        v5.RotationInfluence = Vector3.new(2, 1, 4);

        return v5;
    end,

    HandheldCamera = function() -- Line: 74, Name: HandheldCamera
        -- upvalues: CameraShakeInstance (copy)
        local v6 = CameraShakeInstance.new(1, 0.25, 5, 10);
        v6.PositionInfluence = Vector3.new(0, 0, 0);
        v6.RotationInfluence = Vector3.new(1, 0.5, 0.5);

        return v6;
    end,

    Bullet = function() -- Line: 84, Name: Bullet
        -- upvalues: CameraShakeInstance (copy)
        local v7 = CameraShakeInstance.new(1.5, 20, 0.05, 0.05);
        v7.PositionInfluence = Vector3.new(0, 0, 0.1);
        v7.RotationInfluence = Vector3.new(0, 0, 2.5);

        return v7;
    end,

    Vibration = function() -- Line: 93, Name: Vibration
        -- upvalues: CameraShakeInstance (copy)
        local v8 = CameraShakeInstance.new(0.4, 20, 2, 2);
        v8.PositionInfluence = Vector3.new(0, 0.15, 0);
        v8.RotationInfluence = Vector3.new(1.25, 0, 4);

        return v8;
    end,

    RoughDriving = function() -- Line: 103, Name: RoughDriving
        -- upvalues: CameraShakeInstance (copy)
        local v9 = CameraShakeInstance.new(1, 2, 1, 1);
        v9.PositionInfluence = Vector3.new(0, 0, 0);
        v9.RotationInfluence = Vector3.new(1, 1, 1);

        return v9;
    end,

    Reload = function() -- Line: 111, Name: Reload
        -- upvalues: CameraShakeInstance (copy)
        local v10 = CameraShakeInstance.new(3, 7, 0.1, 0.4);
        v10.PositionInfluence = Vector3.new(0, 0, 0);
        v10.RotationInfluence = Vector3.new(0.4, 0, 1.5);

        return v10;
    end,

    Unload = function() -- Line: 118, Name: Unload
        -- upvalues: CameraShakeInstance (copy)
        local v11 = CameraShakeInstance.new(5, 5, 0.2, 0.5);
        v11.PositionInfluence = Vector3.new(0, 0.1, 0.1);
        v11.RotationInfluence = Vector3.new(0.4, 0, 0.1);

        return v11;
    end,

    Pull = function() -- Line: 125, Name: Pull
        -- upvalues: CameraShakeInstance (copy)
        local v12 = CameraShakeInstance.new(1.2, 5, 0.05, 0.05);
        v12.PositionInfluence = Vector3.new(0, 0, 0);
        v12.RotationInfluence = Vector3.new(0, 0, 2);

        return v12;
    end,

    Smack = function() -- Line: 132, Name: Smack
        -- upvalues: CameraShakeInstance (copy)
        local v13 = CameraShakeInstance.new(3, 10, 0.05, 0.2);
        v13.PositionInfluence = Vector3.new(0, 0, 0);
        v13.RotationInfluence = Vector3.new(0, 0, 4);

        return v13;
    end,

    Tear = function() -- Line: 139, Name: Tear
        -- upvalues: CameraShakeInstance (copy)
        local v14 = CameraShakeInstance.new(1, 1, 1, 1);
        v14.PositionInfluence = Vector3.new(0, 0, 0);
        v14.RotationInfluence = Vector3.new(1, 1, 1);

        return v14;
    end
};

return setmetatable({}, {
    __index = function(p16, p17) -- Line: 150, Name: __index
        -- upvalues: u15 (copy)
        local v18 = u15[p17];

        if type(v18) == "function" then
            return v18();
        end;

        error("No preset found with index \"" .. p17 .. "\"");
    end
});