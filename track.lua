local direction = require 'direction'
local track_directions = require 'track_directions'

local TRACK_SIZE = 1 -- pixels

local track = {}
track.__index = track

function track.new(options)
    local self = {}
    setmetatable(self, track)

    self.orientation = options.orientation or error("no orientation given for track")

    return self
end

function track:next(dir)
    return track_directions[self.orientation][dir]
end

function track:draw()
    local points = {}
    for _, v in pairs(track_directions[self.orientation]) do
        local x, y = direction.to_offset(v)
        local p = { x * TRACK_SIZE, y * TRACK_SIZE }
        table.insert(points, p)
    end
    table.insert(points, 2, {0, 0})
    love.graphics.setColor(0, 0, 0)
    love.graphics.line(points)
end

return track