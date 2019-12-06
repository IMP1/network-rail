local carriage = {}
carriage.__index = carriage

carriage.shapes = {
    SQUARE  = 1,
    ROUNDED = 2,
    BULLET  = 3,
}

function carriage.new(options)
    local self = {}
    setmetatable(self, carriage)

    self.colour    = options.colour    or {0.1, 0.1, 0.1}
    self.position  = options.position  or {0, 0} -- pixels
    self.direction = options.direction or 0  -- radians
    self.length    = options.length    or 20 -- pixels
    self.width     = options.width     or 3  -- pixels
    self.shape     = options.shape     or carriage.shapes.SQUARE

    return self
end

function carriage:move(distance, direction, world)
    
end

function carriage:draw(tile_size)
    local x, y = unpack(self.position)
    local w, h = self.length, self.width
    local r = self.direction
    love.graphics.circle("fill", x * tile_size, y * tile_size, 3)
end

return carriage