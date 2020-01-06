local route = {}
route.__index = route

-- list of where a train must be, and when it should be there

function route.new(stops)
    local self = {}
    setmetatable(self, route)

    self.stops = stops or {}
    self.current_position = 1
    self.finished = #self.stops == 0
    
    return self
end

function route:step()
    self.current_position = self.current_position + 1
    if self.current_position > #self.stops then
        self.finished = true
    end
end

function route:nextStation()
    if self.finished then 
        return nil
    end
    self.stops[self.current_position].station
end

function route:nextArrivalTime()
    if self.finished then 
        return nil
    end
    self.stops[self.current_position].time
end

return route