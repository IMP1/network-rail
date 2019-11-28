local carriage = require 'carriage'
local route = require 'route'

local train = {}
train.__index = train

function train.new(options)
    local self = {}
    setmetatable(self, train)

    local carriage_count = options.carriages or 2

    self.route           = options.route           or route.new()
    self.position        = options.position        or {0, 0}
    self.direction       = options.direction       or 0  -- radians
    self.carriage_length = options.carriage_length or 20 -- metres
    self.carriage_width  = options.carriage_width  or 3  -- metres
    self.carriage_shape  = options.carriage_shape  or carriage.shapes.SQUARE
    self.engine_length   = options.engine_length   or 20 -- metres
    self.engine_width    = options.engine_width    or 3  -- metres
    self.engine_shape    = options.engine_shape    or carriage.shapes.BULLET

    self.sections = {}
    table.insert(self.sections, carriage.new({
        position  = self.position,
        direction = self.direction,
        length    = self.engine_length,
        shape     = self.engine_shape,
    }))
    for i = 1, carriage_count do
        local x, y = unpack(self.position)
        -- TODO: work out position backwards along track
        table.insert(self.sections, carriage.new({
            position  = {x, y},
            direction = self.direction,
            length    = self.carriage_length,
            shape     = self.carriage_shape,
        }))
    end
    self.head = self.sections[1]

    return self
end

function train:update(dt)

end

function train:draw()
    for _, section in pairs(self.sections) do
        section:draw()
    end
end

return train