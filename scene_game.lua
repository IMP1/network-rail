local pallete = require 'pallete_default'
local train   = require 'train'
local world   = require 'world'
local clock   = require 'clock'
local camera  = require 'camera'
local time    = require 'time'

local scene_base = require 'scene_base'
local scene = {}
setmetatable(scene, scene_base)
scene.__index = scene

local MOUSE_CLICK_THRESHOLD = 2 -- tiles
local CAMERA_SPEED = 320 -- pixels per second

function table.index(tbl, obj)
    for i, o in ipairs(tbl) do
        if o == obj then return i end
    end
    return nil
end

function scene.new(level)
    local self = {}
    setmetatable(self, scene)

    self.world = world.load(level.world)
    
    self.trains = {}
    for _, t in pairs(level.trains) do
        for _, stop in pairs(t.route) do
            local station = self.world:stationWithCode(stop.station)
            if station == nil then
                error("Could not find station with the code '" .. stop.station .. "'")
            end
            stop.station = station
        end
        table.insert(self.trains, train.new(t, self.world))
    end

    self.triggers = {}
    for _, t in pairs(level.triggers) do
        table.insert(self.triggers, t)
    end

    self.selection = nil
    self.selection_index = nil
    self.all_selectable_objects = self.world:allSelectableObjects()

    local world_width = 1000 -- TODO: set actual world width
    table.sort(self.all_selectable_objects, function(a, b)
        local ax, ay = unpack(a.position)
        local bx, by = unpack(b.position)
        return ax + ay * world_width < bx + by * world_width
    end)

    for _, t in pairs(self.trains) do
        table.insert(self.all_selectable_objects, t)
    end

    self.game_speed = 1
    self.paused = false
    self.clock = clock.new({ time = time.parse(level.start_time) })
    self.control_groups = {}
    self.control_group_keys = { "1", "2", "3", "4", "5" --[[, ... ]] }
    self.schedules = {}
    self.camera = camera.new()

    return self
end

function scene:objectNearestPoint(x, y, threshold)
    local nearest_object = nil
    local nearest_distance = nil
    for _, obj in pairs(self.all_selectable_objects) do
        local dist = (x - obj.position[1])^2 + (y - obj.position[2])^2
        if dist <= threshold and (nearest_object == nil or dist < nearest_distance) then
            nearest_object = obj
            nearest_distance = dist
        end
    end
    return nearest_object
end

function scene:getNextTabObject()
    local next_object_index = (self.selection_index or 0) + 1
    if next_object_index > #self.all_selectable_objects then
        next_object_index = 1
    end
    self.selection = self.all_selectable_objects[next_object_index]
    self.selection_index = next_object_index
end

function scene:getPreviousTabObject()
    local next_object_index = (self.selection_index or 0) - 1
    if next_object_index < 1 then
        next_object_index = #self.all_selectable_objects
    end
    self.selection = self.all_selectable_objects[next_object_index]
    self.selection_index = next_object_index
end


function scene:mouseReleased(mx, my, key)
    local wx, wy = self.camera:toWorldPosition(mx, my)
    wx = wx / self.world.TILE_SIZE
    wy = wy / self.world.TILE_SIZE
    local obj = self:objectNearestPoint(wx, wy, MOUSE_CLICK_THRESHOLD)
    if obj then
        self.selection = obj
        self.selection_index = table.index(self.all_selectable_objects, self.selection)
    end
end

function scene:keyPressed(key)
    if key == "tab" then
        if love.keyboard.isDown("lshift", "rshift") then
            self:getPreviousTabObject(self.selection_index)
        else
            self:getNextTabObject(self.selection_index)
        end
    end
    local control_index = table.index(self.control_group_keys, key)
    if control_index then
        if love.keyboard.isDown("lctrl", "rctrl") then
            if self.selection then
                self.control_groups[control_index] = self.selection
            end
        elseif self.control_groups[control_index] then
            self.selection = self.control_groups[control_index]
            self.selection_index = table.index(self.all_selectable_objects, self.selection)
        end
    end
    if key == "space" and self.selection then
        if self.selection.toggle then
            self.selection:toggle()
        end
    end
    if key == "escape" and self.selection then
        self.selection = nil
        self.selection_index = nil
    end
    if key == "p" then
        self.paused = not self.paused
    end
    if key == "`" then
        self.game_speed = 0.3
    end
end

function scene:update(dt)
    if self.paused then return end
    local gdt = dt * self.game_speed
    self.clock:update(gdt)
    self.world.current_time = self.clock:currentTime()
    for _, t in pairs(self.trains) do
        t:update(gdt, self.world)
    end
    for _, s in pairs(self.schedules) do
        s:update(gdt, self.world)
    end

    -- camera movement
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") then
        dy = dy - dt * CAMERA_SPEED
    end
    if love.keyboard.isDown("a") then
        dx = dx - dt * CAMERA_SPEED
    end
    if love.keyboard.isDown("s") then
        dy = dy + dt * CAMERA_SPEED
    end
    if love.keyboard.isDown("d") then
        dx = dx + dt * CAMERA_SPEED
    end
    self.camera:move(dx, dy)
end

function scene:draw()
    local mx, my = love.mouse.getPosition()
    local wx, wy = self.camera:toWorldPosition(mx, my)
    wx, wy = math.ceil(wx / world.TILE_SIZE), math.ceil(wy / world.TILE_SIZE)

    love.graphics.setColor(1, 1, 1)
    self.camera:set()
    self.world:draw(self.selection)
    for _, train in pairs(self.trains) do
        train:draw(world.TILE_SIZE)
    end
    love.graphics.setColor(pallete.SELECTION)
    love.graphics.rectangle("line", (wx - 0.5) * world.TILE_SIZE, (wy - 0.5) * world.TILE_SIZE, world.TILE_SIZE, world.TILE_SIZE)
    self.camera:unset()

    love.graphics.setColor(pallete.BLACK)
    love.graphics.print(tostring(self.clock), 0, 0)
    if self.selection and self.selection.drawInfo then
        love.graphics.push()
        love.graphics.translate(0, 64)
        self.selection:drawInfo()
        love.graphics.pop()
    end
    love.graphics.print(wx .. ", " .. wy, 0, 16)
    
    for i, key in ipairs(control_group_keys) do
        local obj = control_groups[i]
        love.graphics.setColor(pallete.WHITE)
        love.graphics.rectangle("fill", i * 32, 32, 24, 24)
        if obj then
            love.graphics.setColor(pallete.BLACK)
        else
            love.graphics.setColor(pallete.DISABLED)
        end
        love.graphics.rectangle("line", i * 32, 32, 24, 24)
        love.graphics.printf(key, i * 32, 32, 32, "center")
    end
    -- TODO: draw control groups


end

return scene