local pallete = require 'pallete_default'
local scene_manager = require 'scene_manager'

local station = {}
station.__index = station

function station.new(options)
    local self = {}
    setmetatable(self, station)

    self.name      = options.name
    self.code      = options.code
    self.platforms = options.platforms or {}

    self.position = { nil, nil }
    self.size     = { 0, 0 }

    local min_x = 1000
    local max_x = 0
    local min_y = 1000
    local max_y = 0
    for _, platform in pairs(self.platforms) do
        local average_x = 0
        local width = 0
        for _, cell in pairs(platform.tracks) do
            average_x = average_x + cell[1]

            min_x = math.min(min_x, cell[1])
            max_x = math.max(max_x, cell[1])
            
            min_y = math.min(min_y, cell[2])
            max_y = math.max(max_y, cell[2])
        end
        average_x = average_x / #platform.tracks
        if self.position[2] == nil or min_y < self.position[2] then
            self.position = { average_x, min_y - 1 }
        end
    end
    self.size = { max_x - min_x + 2, max_y - min_y + 2}

    print(self.name)
    print(unpack(self.size))

    return self
end

function station:platformFromSignal(signal)
    for i, platform in pairs(self.platforms) do
        if platform.signal == signal then
            return i
        end
    end
    return nil
end

function station:drawBounds(width, colour)
    love.graphics.pushState("LineWidth", width or 1)
    love.graphics.pushState("Color", colour or {0, 0, 0, 0.2})
    local x, y = unpack(self.position)
    local w, h = unpack(self.size)
    -- love.graphics.rectangle("line", (x - w/2) * 24, y * 24, w * 24, h * 24)
    love.graphics.line((x - w/2) * 24, y * 24, (x - w/2) * 24, (y + h) * 24, (x + w/2) * 24, (y + h) * 24, (x + w/2) * 24, y * 24)
    local width = love.graphics.getFont():getWidth(self.name)
    love.graphics.printf(self.name, (x - w/2) * 24, y * 24 - 8, w * 24, "center")
    love.graphics.line((x - w/2) * 24, y * 24, (x * 24) - width/2 - 4, y * 24)
    love.graphics.line((x * 24) + width/2 + 4, y * 24, (x + w/2) * 24, y * 24)
    love.graphics.popState("Color")
    love.graphics.popState("LineWidth")
end

function station:drawSelected()
    self:drawBounds(2, {0, 0, 0})
    local world = scene_manager.scene().world
    love.graphics.pushState("LineWidth", 3)
    for i, platform in pairs(self.platforms) do
        for _, cell in pairs(platform.tracks) do
            local track = world:trackAt(cell[1], cell[2])
            track:draw(world.TILE_SIZE, pallete.PLATFORMS[i])
        end
    end
    love.graphics.popState("LineWidth")
end

function station:draw()
    self:drawBounds()
end

function station:drawInfo()
    love.graphics.setColor(pallete.BLACK)
    love.graphics.print("Station: " .. self.name, 0, 0)
end

return station