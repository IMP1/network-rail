local event = {}
event.__index = event

function event.new()
    local self = {}
    setmetatable(self, event)

    -- can be manually triggered and automatically triggered from schedule
    -- can have conditional logic stuff
    -- can affect the world (toggle signals, switches, etc.)

    return self
end

return event