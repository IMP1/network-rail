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

function route:arriveAt(station, time)
    print("Arriving at " .. station.name .. " at " .. tostring(time))
    if self:nextStation() == station then
        self:nextStop().arrival_time = time
    else
        local skipped_index = 0
        for i = self.current_position, #self.stops do
            if self.stops[i].station == station then
                skipped_index = i
                break
            end
        end
        if skipped_index > 0 then
            for i = self.current_position, skipped_index - 1 do
                self.stops[i].arrival_time = nil
            end
            self.stops[skipped_index].arrival_time = time
        else
            -- TODO: train was not due at this station. Just ignore it?
        end
    end
end

function route:nextStop()
    if self.finished then 
        return nil
    end
    return self.stops[self.current_position]
end

function route:nextStation()
    if self.finished then 
        return nil
    end
    return self:nextStop().station
end

function route:nextArrivalTime()
    if self.finished then 
        return nil
    end
    return self:nextStop().time
end

return route