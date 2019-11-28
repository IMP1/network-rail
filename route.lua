local route = {}
route.__index = route

function route.new(options)
    local self = {}
    setmetatable(self, route)

    
    
    return self
end

return route