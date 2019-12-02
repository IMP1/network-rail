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

return switch