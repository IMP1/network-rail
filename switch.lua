local pallete = require 'pallete_default'

local switch = {}
switch.__index = switch

function switch.new(options)
    local self = {}
    setmetatable(self, switch)

    self.track    = options.track   or error("No track given")
    self.position = self.track.position
    self.options  = options.options or { self.track.orientation }
    self.current  = options.start   or 1

    return self
end

function switch:toggle()
    self.current = self.current + 1
    if self.current > #self.options then
        self.current = 1
    end

    self.track.orientation = self.options[self.current]
end

function switch:drawAlternatives(tile_size)
    local OPACITY = 0.2
    local r, g, b = unpack(pallete.BLACK)
    local colour = {r, g, b, OPACITY}
    for _, option in pairs(self.options) do
        self.track.orientation = option
        self.track:draw(tile_size, colour)
    end
    self.track.orientation = self.options[self.current]
end

function switch:drawSwitch(tile_size)
    love.graphics.setColor(pallete.BLACK)   
    love.graphics.circle("line", self.position[1] * tile_size, self.position[2] * tile_size, tile_size / 8)
end

function switch:draw(tile_size)
    self:drawAlternatives(tile_size)
    self:drawSwitch(tile_size)
end


function switch:drawSelected(tile_size)
    self:drawAlternatives(tile_size)
    self:drawSwitch(tile_size)
    love.graphics.setColor(pallete.BLACK)
    love.graphics.rectangle("line", (self.position[1] - 0.5) * tile_size, (self.position[2] - 0.5) * tile_size, tile_size, tile_size)
end

function switch:drawInfo()
    love.graphics.setColor(pallete.BLACK)
    love.graphics.print("Switch", 0, 0)
    local state = "State " .. self.current .. " of " .. #self.options
    love.graphics.print(state, 0, 16)
    local current = self.options[self.current]
    love.graphics.print(current, 0, 32)
end

return switch