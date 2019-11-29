local station = {}
station.__index = station

function station.new(options)
    local self = {}
    setmetatable(self, station)



    return self
end

return station