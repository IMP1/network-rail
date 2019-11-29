local clock = {}
clock.__index = clock

function clock.new(options)
    local self = {}
    setmetatable(self, clock)

    self.seconds = options.seconds or 0
    self.minutes = options.minutes or 0
    self.hours   = options.hours   or 0

    return self
end

function clock:update(dt)
    self.seconds = self.seconds + dt
    while self.seconds >= 60 do
        self.seconds = self.seconds - 60
        self.minutes = self.minutes + 1
    end
    while self.minutes >= 60 do
        self.minutes = self.minutes - 60
        self.hours = self.hours + 1
    end
    while self.hours >= 24 do
        self.hours = self.hours - 24
    end
end

function clock:__tostring(format)
    local str = format or "%H:%M:%S"
    str = str:gsub("%%S", tostring(math.floor(self.seconds)))
    str = str:gsub("%%M", tostring(math.floor(self.minutes)))
    str = str:gsub("%%H", tostring(math.floor(self.hours)))
    return str
                 
                 
end

return clock