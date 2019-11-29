local track = require 'track'
local switch = require 'switch'
local signal = require 'signal'
local station = require 'station'

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
        local obj = switch.new({
            track = t,
            options = s.options,
        })
        table.insert(self.switches, obj)
    end

    self.signals = {}
    for _, s in pairs(signals) do
        local t = self.world_cells[s.y][s.x]
        local obj = signal.new({
            track = t,
            options = s.options,
        })
        table.insert(self.signals, obj)
    end

    self.stations = {}
    for _, s in pairs(stations) do
        local obj = station.new({
            options = s,
        })
        table.insert(self.stations, obj)
    end

    return self
end

function world:allSelectableObjects()
    return { unpack(self.switches), unpack(self.signals), unpack(self.stations) }
end

function world:draw()
    love.graphics.push()
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