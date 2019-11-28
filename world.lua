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
                local t = track.new({orientation=char_map[c]})
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
        -- local t = self.world_cells[s.y][s.x]
        -- local s = switch.new({
            -- track = t,
            -- options = s.options,
        -- })
        -- table.insert(self.switches, s)
    end

    self.signals = {}
    for _, s in pairs(signals) do
        -- TODO: add signals
    end

    self.stations = {}
    for _, s in pairs(stations) do
        -- TODO: add stations
    end

    return self
end

function world:draw()
    for y, row in pairs(self.world_cells) do
        for x, track in pairs(row) do
            if track then
                track:draw(x, y)
            end     
        end
    end
end

return world