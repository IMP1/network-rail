local train  = require 'train'
local world  = require 'world'
local clock  = require 'clock'
local camera = require 'camera'

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

function scene.new()
    local self = {}
    setmetatable(self, scene)

    self.world = world.load("world_1.lua")
    self.trains = {
        train.new({
            position = {20, 20},
            direction = 0,
            carriages = 3,
        })
    }

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
    self.clock = clock.new({})
    self.control_groups = {}
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
    if key == "??" then
        if love.keyboard.isDown("lctrl", "rctrl") and self.selection then
            -- TODO: if key, then assign that control group
        else
            -- TODO: if key, then select that control group
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
end

function scene:update(dt)
    if self.paused then return end
    local gdt = dt * self.game_speed
    self.clock:update(gdt)
    for _, t in pairs(self.trains) do
        t:update(gdt)
    end
    for _, s in pairs(self.schedules) do
        s:update(gdt)
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
    self.camera:set()
    self.world:draw(self.selection)
    self.camera:unset()
    love.graphics.print(tostring(self.clock), 0, 0)
end

return scene