local direction = require 'direction'
local track_directions = require 'track_directions'

local track = {}
track.__index = track
track.SIZE = 2

function track.new(options)
    local self = {}
    setmetatable(self, track)

    self.position    = options.position    or error("no position given for track")
    self.orientation = options.orientation or error("no orientation given for track")

    return self
end

function track:next(dir)
    return track_directions[self.orientation][dir]
end

function track:draw(scale)
    local size = track.SIZE * (scale or 1)
    local x, y = unpack(self.position)
    local points = {}
    for _, v in pairs(track_directions[self.orientation]) do
        local x, y = direction.to_offset(v)
        table.insert(points, x * size / 2)
        table.insert(points, y * size / 2)
    end
    table.insert(points, 3, 0)
    table.insert(points, 4, 0)
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle("line", (x-0.5) * size, (y-0.5) * size, size, size)
    love.graphics.setColor(0, 0, 0)
    love.graphics.push()
    love.graphics.translate(x * size, y * size)
    love.graphics.line(points)
    love.graphics.pop()
end

return track