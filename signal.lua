local signal = {}
signal.__index = signal

function signal.new(options)
    local self = {}
    setmetatable(self, signal)

    self.direction     = options.direction
    self.allow_passage = options.start_green

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

return signal