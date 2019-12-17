local pallete = require 'pallete_default'
local track = require 'track'
local switch = require 'switch'
local signal = require 'signal'
local station = require 'station'

local world = {}
world.__index = world

world.TILE_SIZE = 24

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
        t.orientation = obj.options[obj.current]
        table.insert(self.switches, obj)
    end

    self.signals = {}
    for _, s in pairs(signals) do
        local t = self.world_cells[s.y][s.x]
        local obj = signal.new({
            track = t,
        })
        table.insert(self.signals, obj)
    end

    self.stations = {}
    for _, s in pairs(stations) do
        local obj = station.new(s)
        table.insert(self.stations, obj)
    end

    return self
end

function world:trackAt(x, y)
    return self.world_cells[y][x]
end

function world:allSelectableObjects()
    local objects = {}
    for _, switch in pairs(self.switches) do
        table.insert(objects, switch)
    end
    for _, signal in pairs(self.signals) do
        table.insert(objects, signal)
    end
    for _, station in pairs(self.stations) do
        table.insert(objects, station)
    end
    return objects
end

function world:draw(selected_object)
    love.graphics.push()
    for y, row in pairs(self.world_cells) do
        for x, track in pairs(row) do
            if track then
                track:draw(world.TILE_SIZE)
            end     
        end
    end
    local all_objects = self:allSelectableObjects()
    for _, obj in pairs(all_objects) do
        if obj == selected_object then
            love.graphics.setColor(pallete.SELECTION)
        else
            love.graphics.setColor(pallete.SELECTABLE)
        end
        love.graphics.circle("line", obj.position[1] * world.TILE_SIZE, obj.position[2] * world.TILE_SIZE, world.TILE_SIZE)
        if obj.draw then
            obj:draw(world.TILE_SIZE)
        end
    end
    love.graphics.pop()
end

return world