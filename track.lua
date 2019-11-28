local track_directions = require 'track_directions'

local track = {}
track.__idex = track

function track.new(options)
    local self = {}
    setmetatable(self, track)

    self.orientation = options.orientation or error("no orientation given for track")

    return self
end

function track:next(direction)
    return track_directions[self.orientation][direction]
end

return track