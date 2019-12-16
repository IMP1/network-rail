local carriage = require 'carriage'
local direction = require 'direction'
local route = require 'route'

local train = {}
train.__index = train

function train.new(options, world)
    local self = {}
    setmetatable(self, train)

    local carriage_count  = options.carriages       or 2
    local carriage_length = options.carriage_length or 20 -- metres
    local carriage_width  = options.carriage_width  or 3  -- metres
    local carriage_shape  = options.carriage_shape  or carriage.shapes.SQUARE
    local engine_length   = options.engine_length   or 20 -- metres
    local engine_width    = options.engine_width    or 3  -- metres
    local engine_shape    = options.engine_shape    or carriage.shapes.BULLET

    self.route           = options.route           or route.new()
    self.position        = options.position        or {0, 0} -- metres
    self.direction       = options.direction       or 0  -- radians
    self.top_speed       = options.top_speed       or 50 -- metres / second
    self.acceleration    = options.acceleration    or 0.4 -- metres / second / second
    self.deceleration    = options.deceleration    or 0.4 -- metres / second / second

    self.sections = {}
    table.insert(self.sections, carriage.new({
        position  = self.position,
        direction = self.direction,
        length    = self.engine_length,
        shape     = self.engine_shape,
    }))

    local track = world:trackAt(unpack(self.position))
    local backwards = track:next(direction.inverse(self.direction))
    local movement = { direction.to_offset(backwards) }
    local pos = { self.position[1] + movement[1], self.position[2] + movement[2] }

    for i = 1, carriage_count do
        table.insert(self.sections, carriage.new({
            position  = { unpack(pos) },
            direction = direction.inverse(backwards),
            length    = self.carriage_length,
            shape     = self.carriage_shape,
        }))
        -- Work out position backwards along track
        track = world:trackAt(unpack(pos))
        backwards = track:next(backwards)
        movement = { direction.to_offset(backwards) }
        pos = { pos[1] + movement[1], pos[2] + movement[2] }
    end
    self.head = self.sections[1]
    self.waiting = false
    self.moving = false

    return self
end

function train:notify()
    -- signal this train was waiting on has turned green
    -- TODO: check signal, and attempt to move

end

function train:update(dt)

end

function train:draw(tile_size)
    love.graphics.setColor(0, 0, 0)
    for _, section in pairs(self.sections) do
        section:draw(tile_size)
    end
end

function train:drawInfo()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Train", 0, 0)
end

return train