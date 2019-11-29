local schedule = {}
schedule.__index = schedule

function schedule.new()
    local self = {}
    setmetatable(self, schedule)

    -- time keys -> events to trigger

    return self
end

return schedule