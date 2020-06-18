local direction = {}

--[[

5 6 7
4 * 0
3 2 1

--]]

function direction.to_offset(dir)
    if dir == 0 then
        return 1, 0
    elseif dir == 1 then
        return 1, 1
    elseif dir == 2 then
        return 0, 1
    elseif dir == 3 then
        return -1, 1
    elseif dir == 4 then
        return -1, 0
    elseif dir == 5 then
        return -1, -1
    elseif dir == 6 then
        return 0, -1
    elseif dir == 7 then
        return 1, -1
    else
        error("invalid direction '" .. dir .. "'")
    end
end

function direction.to_radians(dir)
    return math.pi * dir / 4
end

function direction.inverse(dir)
    return (dir + 4) % 8
end

return direction