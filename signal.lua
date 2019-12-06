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
            t.notify()
        end
        self.waiting_trains = {}
    end
end

function signal:drawInfo()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Signal", 0, 0)
    local state = "red"
    if self.allow_passage then state = "green" end
    love.graphics.print("Current state is " .. state, 0, 16)
end

return signal