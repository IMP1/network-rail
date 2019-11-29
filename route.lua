local route = {}
route.__index = route

function route.new(options)
    local self = {}
    setmetatable(self, route)

    -- list of where a train must be, and when it should be there
    
    return self
end

return route