local signal = {}
signal.__index = signal

function signal.new(options)
    local self = {}
    setmetatable(self, signal)

    self.allow_passage = options.allow_passage
    if self.allow_passage == nil then self.allow_passage = true end

    return self
end

return signal