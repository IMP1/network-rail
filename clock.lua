local time = require 'time'

local clock = {}
clock.__index = clock

function clock.new(options)
    local self = {}
    setmetatable(self, clock)

    self.time = options.time or time.new()

    return self
end

function clock:update(dt)
    local days_on
    self.time, days_on = self.time:advance("second", dt)
    if days_on > 0 then
        -- TODO: new day!
    end
end

function clock:currentTime()
    return self.time
end

function clock:__tostring(format)
    return tostring(self.time, format)
end

return clock