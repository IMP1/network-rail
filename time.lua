local time = {}
time.__index = time

function time.parse(text)
    local hour, minute, second 
    hour, minute, second = text:match("(%d%d):(%d%d):(%d%d)")
    if hour == nil then
        hour, minute = text:match("(%d%d):(%d%d)")
        second = 0
    end
    return time.new(tonumber(hour), tonumber(minute), tonumber(second))
end

function time.new(hour, minute, second)
    local self = {}
    setmetatable(self, time)

    self.hour   = hour   or 0
    self.minute = minute or 0
    self.second = second or 0

    return self
end

function time:advance(unit, amount)
    local hour, minute, second = self.hour, self.minute, self.second
    if unit == "hour" or unit == "H" then
        local hour_change = math.floor(amount)
        hour = hour + hour_change        
        amount = amount - hour_change
        if amount > 0 then
            local minute_change = math.floor(60 * amount)
            minute = minute + minute_change
        end
    elseif unit == "minute" or unit == "M" then
        local minute_change = math.floor(amount)
        minute = minute + minute_change
        amount = amount - minute_change
        if amount > 0 then
            local second_change = math.floor(60 * amount)
            second = second + second_change
        end
    elseif unit == "second" or unit == "S" then
        second = second + amount
    else
        error("Unrecognised unit '" .. unit .. "'. Should be hour, minute, or second")
    end
    local days_changed = 0
    while second >= 60 do
        second = second - 60
        minute = minute + 1
    end
    while minute >= 60 do
        minute = minute - 60
        hour = hour + 1
    end
    while hour >= 24 do
        hour = hour - 24
        days_changed = days_changed + 1
    end
    return time.new(hour, minute, second), days_changed
end

function time:__tostring(format)
    local str = format or "%H:%M:%S"
    str = str:gsub("%%H", string.format("%02d", math.floor(self.hour)))
    str = str:gsub("%%M", string.format("%02d", math.floor(self.minute)))
    str = str:gsub("%%S", string.format("%02d", math.floor(self.second)))
    return str
end

return time