
local Converter = require(script.Converter);
local serializers = Converter.serializers;
local deserializers = Converter.deserializers;
local TypeEnums = require(script.TypeEnums);

return {
    types = TypeEnums,

    serialize = function(p1) -- Line: 15, Name: serialize
        -- upvalues: serializers (copy)
        local v2 = serializers[typeof(p1)];

        if v2 then
            return v2(p1);
        end;
    end,

    deserialize = function(p3, p4) -- Line: 22, Name: deserialize
        -- upvalues: TypeEnums (copy), deserializers (copy)
        if typeof(p3) == "number" then
            p3 = TypeEnums.toTypeName(p3);
        end;

        local v5 = deserializers[p3];

        if v5 then
            return v5(p4);
        end;
    end
};