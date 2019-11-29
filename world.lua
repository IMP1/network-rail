local track = require 'track'
local switch = require 'switch'

local world = {}
world.__index = world

local function string_lines(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
end

function world.load(filename)
    local data = love.filesystem.load(filename)()
    return world.new(data)
end

function world.new(options)
    local self = {}
    setmetatable(self, world)

    local world_string = options.world_string or ""
    local switches     = options.switches     or {}
    local signals      = options.signals      or {}
    local stations     = options.stations     or {}
    local char_map     = options.char_map     or {}

    self.scale = 10
    self.tracks = {}
    self.world_cells = {}
    local y = 1
    for line in string_lines(world_string) do
        self.world_cells[y] = {}
        local x = 1
        for c in line:gmatch(".") do
            if c == " " or c == "\n" then
                -- ignore
            elseif char_map[c] then
                local t = track.new({
                    position = {x, y},
                    orientation = char_map[c],
                })
                self.world_cells[y][x] = t
                table.insert(self.tracks, t)
            else
                print("Unrecognised character '" .. c .. '".')
            end
            x = x + 1
        end
        y = y + 1
    end

    self.switches = {}
    for _, s in pairs(switches) do
        local t = self.world_cells[s.y][s.x]
        local s = switch.new({
            track = t,
            options = s.options,
        })
        table.insert(self.switches, s)
    end

    self.signals = {}
    for _, s in pairs(signals) do
        -- TODO: add signals
    end

    self.stations = {}
    for _, s in pairs(stations) do
        -- TODO: add stations
    end

    self.all_objects = { unpack(self.switches), unpack(self.signals), unpack(self.stations) }
    local world_width = 1000 -- TODO: set actual world width
    table.sort(self.all_objects, function(a, b)
        a.x + a.y * world_width < b.x + b.y * world_width
    end)

    return self
end

function world:getNextTabObject(current_object_index)
    local next_object_index = (current_object_index or 0) + 1
    if next_object_index > #self.all_objects then
        next_object_index = 1
    end
    return self.all_objects[next_object_index], next_object_index
end

function world:getTabObjectIndex(object)
    for i, obj in ipairs(self.all_objects) do
        if obj == object then
            return i
        end
    end
    return nil
end

function world:objectNearestPoint(x, y, threshold)
    local nearest = nil
    local distance = nil
    for _, obj in pairs(self.all_objects) do
        local dist = (x - nearest.x)^2 +(y - nearest.y)^2
        if dist <= threshold and (nearest == nil or dist < distance) then
            nearest = obj
            distance = dist
        end
    end
    return nearest
end

function world:draw()
    love.graphics.push()
    -- love.graphics.scale(10)
    for y, row in pairs(self.world_cells) do
        for x, track in pairs(row) do
            if track then
                track:draw(self.scale)
            end     
        end
    end
    local size = self.scale * track.SIZE
    for _, s in pairs(self.switches) do
        love.graphics.setColor(0, 0, 1, 0.5)
        love.graphics.circle("line", s.track.position[1] * size, s.track.position[2] * size, size)
    end
    love.graphics.pop()
end

return world