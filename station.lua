local pallete = require 'pallete_default'

local station = {}
station.__index = station

function station.new(options)
    local self = {}
    setmetatable(self, station)

    self.name      = options.name
    self.platforms = options.platforms or {}

    self.position = { nil, nil }
    for _, platform in pairs(self.platforms) do
        local x = 0
        local y = 0
        for _, cell in pairs(platform.tracks) do
            x = x + cell[1]
            y = math.min(y, cell[2])
        end
        x = x / #platform.tracks
        if self.position[2] == nil or y < self.position[2] then
            self.position = { x, y }
        end
    end

    return self
end

function station:drawInfo()
    love.graphics.setColor(pallete.BLACK)
    love.graphics.print("Station: " .. self.name, 0, 0)
end

return station