local pallete = require 'pallete_default'

local signal = {}
signal.__index = signal

function signal.new(options)
    local self = {}
    setmetatable(self, signal)

    self.direction     = options.direction 
    self.track         = options.track       or error("no position supplied")
    self.allow_passage = options.start_green

    self.position = self.track.position
    self.waiting_trains = {}

    -- makes trains wait
    -- can be manually triggered and automatically triggered

    return self
end

function signal:wait(train)
    table.insert(self.waiting_trains, train)
end

function signal:toggle()
    self.allow_passage = not self.allow_passage
    if self.allow_passage then
        for _, t in pairs(self.waiting_trains) do
            t:notify(self)
        end
        self.waiting_trains = {}
    end
end

function signal:drawInfo()
    love.graphics.setColor(pallete.BLACK)
    love.graphics.print("Signal", 0, 0)
    local state = "red"
    if self.allow_passage then state = "green" end
    love.graphics.print("Current state is " .. state, 0, 16)
end

function signal:drawSignal(tile_size)
    local x, y = unpack(self.track.position)
    love.graphics.setColor(pallete.BLACK)
    love.graphics.circle("line", x * tile_size, y * tile_size + 4, 4)
    love.graphics.circle("line", x * tile_size, y * tile_size - 4, 4)
    if self.allow_passage then
        love.graphics.setColor(pallete.GO)
        love.graphics.circle("fill", x * tile_size, y * tile_size - 4, 4)
    else
        love.graphics.setColor(pallete.STOP)
        love.graphics.circle("fill", x * tile_size, y * tile_size + 4, 4)
    end
end

function signal:draw(tile_size)
    self:drawSignal(tile_size)
end

function signal:drawSelected(tile_size)
    self:drawSignal(tile_size)
    love.graphics.setColor(pallete.BLACK)
    love.graphics.circle("line", self.position[1] * tile_size, self.position[2] * tile_size, tile_size)
end

return signal