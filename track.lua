local pallete = require 'pallete_default'

local direction = require 'direction'
local track_directions = require 'track_directions'

local track = {}
track.__index = track

function track.new(options)
    local self = {}
    setmetatable(self, track)

    self.position    = options.position    or error("no position given for track")
    self.orientation = options.orientation or error("no orientation given for track")

    return self
end

function track:next(dir)
    print("track:")
    print(self.orientation)
    print(dir)
    print(track_directions[self.orientation][dir])
    return track_directions[self.orientation][dir]
end

function track:draw(tile_size, colour)
    local x, y = unpack(self.position)
    local points = {}
    for _, v in pairs(track_directions[self.orientation]) do
        local x, y = direction.to_offset(v)
        table.insert(points, x * tile_size / 2)
        table.insert(points, y * tile_size / 2)
    end
    table.insert(points, 3, 0)
    table.insert(points, 4, 0)
    love.graphics.setColor(colour or pallete.BLACK)
    love.graphics.push()
    love.graphics.translate(x * tile_size, y * tile_size)
    love.graphics.line(points)
    -- love.graphics.translate(0, -16)
    -- love.graphics.print(self.orientation)
    love.graphics.pop()
end

return track