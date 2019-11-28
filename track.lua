local direction = require 'direction'
local track_directions = require 'track_directions'

local TRACK_SIZE = 10 -- pixels

local track = {}
track.__index = track

function track.new(options)
    local self = {}
    setmetatable(self, track)

    self.orientation = options.orientation or error("no orientation given for track")
    self:refresh()

    return self
end

function track:refresh()
    self.points = {}
    for _, v in pairs(track_directions[self.orientation]) do
        local x, y = direction.to_offset(v)
        table.insert(self.points, x * TRACK_SIZE / 2)
        table.insert(self.points, y * TRACK_SIZE / 2)
    end
    table.insert(self.points, 3, 0)
    table.insert(self.points, 4, 0)
end

function track:next(dir)
    return track_directions[self.orientation][dir]
end

function track:draw(ox, oy)
    -- love.graphics.setColor(1, 0, 0, 0.5)
    -- love.graphics.rectangle("line", (ox-0.5) * TRACK_SIZE, (oy-0.5) * TRACK_SIZE, TRACK_SIZE, TRACK_SIZE)
    love.graphics.setColor(0, 0, 0)
    love.graphics.push()
    love.graphics.translate(ox * TRACK_SIZE, oy * TRACK_SIZE)
    love.graphics.line(self.points)
    love.graphics.pop()
end

return track