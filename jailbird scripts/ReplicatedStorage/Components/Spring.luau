
return {
    new = function(p1) -- Line: 3, Name: new
        local u2 = tick();
        local u3 = p1 or 0;
        local u4 = p1 and (0 * p1 or 0) or 0;
        local u5 = p1 or 0;
        local u6 = 1;
        local u7 = 1;

        local function positionVelocity(p8) -- Line: 11
            -- upvalues: u2 (ref), u3 (ref), u5 (ref), u7 (ref), u6 (ref), u4 (ref)
            local v9 = p8 - u2;
            local v10 = u3 - u5;

            if u7 == 0 then
                return u3, 0;
            end;

            if u6 >= 1 then
                local v11 = u4 / u7 + v10;
                local v12 = math.exp(u7 * v9);

                return u5 + (v10 + v11 * u7 * v9) / v12, u7 * (v11 - v10 - v11 * u7 * v9) / v12;
            end;

            local v13 = math.sqrt(1 - u6 ^ 2);
            local v14 = (u4 / u7 + u6 * v10) / v13;
            local v15 = math.cos(v13 * u7 * v9);
            local v16 = math.sin(v13 * u7 * v9);
            local v17 = math.exp(u6 * u7 * v9);

            return u5 + (v10 * v15 + v14 * v16) / v17, u7 * ((v13 * v14 - u6 * v10) * v15 - (v13 * v10 + u6 * v14) * v16) / v17;
        end;

        return setmetatable({
            accelerate = function(p18, p19) -- Line: 34, Name: accelerate
                -- upvalues: positionVelocity (copy), u3 (ref), u4 (ref), u2 (ref)
                local v20 = tick();
                local v21, v22 = positionVelocity(v20);
                u3 = v21;
                u4 = v22 + p19;
                u2 = v20;
            end
        }, {
            __index = function(p23, p24) -- Line: 43, Name: __index
                -- upvalues: positionVelocity (copy), u2 (ref), u3 (ref), u5 (ref), u7 (ref), u6 (ref), u4 (ref)
                if p24 == "value" or (p24 == "position" or p24 == "p") then
                    local v25, _ = positionVelocity(tick());

                    return v25;
                end;

                if p24 == "velocity" or p24 == "v" then
                    local _, v26 = positionVelocity(tick());

                    return v26;
                end;

                if p24 == "acceleration" or p24 == "a" then
                    local v27 = tick() - u2;
                    local v28 = u3 - u5;

                    if u7 == 0 then
                        return 0;
                    end;

                    if u6 >= 1 then
                        local v29 = u4 / u7 + v28;

                        return u7 ^ 2 * (v28 - 2 * v29 + v29 * u7 * v27) / math.exp(u7 * v27);
                    end;

                    local v30 = math.sqrt(1 - u6 ^ 2);
                    local v31 = (u4 / u7 + u6 * v28) / v30;
                    local v32 = (v28 * u6 ^ 2 - v30 * 2 * u6 * v31 - v28 * v30 ^ 2) * math.cos(v30 * u7 * v27);
                    local v33 = (v31 * u6 ^ 2 + v30 * 2 * u6 * v28 - v31 * v30 ^ 2) * math.sin(v30 * u7 * v27);

                    return u7 ^ 2 * (v32 + v33) / math.exp(u6 * u7 * v27);
                end;

                if p24 == "target" or p24 == "t" then
                    return u5;
                end;

                if p24 == "damper" or p24 == "d" then
                    return u6;
                end;

                if p24 == "speed" or p24 == "s" then
                    return u7;
                end;

                if p24 == "magnitude" or p24 == "m" then
                    local v34, _ = positionVelocity(tick());

                    return v34.magnitude;
                end;

                error(p24 .. " is not a valid member of spring", 0);
            end,

            __newindex = function(p35, p36, p37) -- Line: 79, Name: __newindex
                -- upvalues: positionVelocity (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u2 (ref)
                local v38 = tick();

                if p36 == "value" or (p36 == "position" or p36 == "p") then
                    local _, v39 = positionVelocity(v38);
                    u3 = p37;
                    u4 = v39;
                elseif p36 == "velocity" or p36 == "v" then
                    local v40, _ = positionVelocity(v38);
                    u3 = v40;
                    u4 = p37;
                elseif p36 == "acceleration" or p36 == "a" then
                    local v41, v42 = positionVelocity(v38);
                    u3 = v41;
                    u4 = v42 + p37;
                elseif p36 == "target" or p36 == "t" then
                    local v43, v44 = positionVelocity(v38);
                    u3 = v43;
                    u4 = v44;
                    u5 = p37;
                elseif p36 == "damper" or p36 == "d" then
                    local v45, v46 = positionVelocity(v38);
                    u3 = v45;
                    u4 = v46;
                    u6 = p37 < 0 and 0 or (p37 < 1 and p37 and p37 or 1);
                elseif p36 == "speed" or p36 == "s" then
                    local v47, v48 = positionVelocity(v38);
                    u3 = v47;
                    u4 = v48;
                    u7 = p37 < 0 and 0 or p37;
                else
                    error(p36 .. " is not a valid member of spring", 0);
                end;

                u2 = v38;
            end
        });
    end
};