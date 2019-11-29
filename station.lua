local station = {}
station.__index = station

function station.new(options)
    local self = {}
    setmetatable(self, station)

    self.name      = options.name
    self.position  = options.position
    self.platforms = options.platforms

    return self
end

return station