
return {
    buffer_concat = function(p1, p2) -- Line: 3, Name: buffer_concat
        local v3 = buffer.len(p1);
        local v4 = buffer.create(v3 + buffer.len(p2));
        buffer.copy(v4, 0, p1);
        buffer.copy(v4, v3, p2);

        return v4;
    end,

    buffer_sizeinc = function(p5, p6) -- Line: 12, Name: buffer_sizeinc
        local v7 = buffer.create(buffer.len(p5) + p6);
        buffer.copy(v7, 0, p5);

        return v7;
    end,

    buffer_resize = function(p8, p9) -- Line: 19, Name: buffer_resize
        if p9 >= buffer.len(p8) then
            return error(`buffer size smaller than given size ({p9})`, 2);
        end;

        local v10 = buffer.create(p9);
        buffer.copy(v10, 0, p8);

        return v10;
    end
};