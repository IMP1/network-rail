local train = require 'train'
local world = require 'world'

local scene_base = require 'scn.base'
local scene = {}
setmetatable(scene, scene_base)
scene.__index = scene

local MOUSE_CLICK_THRESHOLD = 16

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
        trains.new({
            position = {20, 20},
            carriages = 3,
        })
    }

    self.selection = nil
    self.selection_index = nil
    self.all_selectable_objects = self.world:allSelectableObjects()

    local world_width = 1000 -- TODO: set actual world width
    table.sort(self.all_selectable_objects, function(a, b)
        a.x + a.y * world_width < b.x + b.y * world_width
    end)

    for _, t in pairs(self.trains) do
        table.insert(self.all_selectable_objects, t)
    end

    return self
end

function scene:objectNearestPoint(x, y, threshold)
    local nearest = nil
    local distance = nil
    for _, obj in pairs(self.all_selectable_objects) do
        local dist = (x - nearest.x)^2 +(y - nearest.y)^2
        if dist <= threshold and (nearest == nil or dist < distance) then
            nearest = obj
            distance = dist
        end
    end
    return nearest
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
    local wx, wy = mx, my
    local obj = self:objectNearestPoint(wx, wy, MOUSE_CLICK_THRESHOLD)
    if obj then
        self.selection = obj
        self.selection_index = table.index(self.all_selectable_objects, self.selection)
    end
end

function scene:keyPressed(key)
    if key == "tab" then
        if love.keyboard.isDown("lshift", "rshift") then
            self.selection, self.selection_index = self:getPreviousTabObject(self.selection_index)
        else
            self.selection, self.selection_index = self:getNextTabObject(self.selection_index)
        end
    end
    if key == "??" and love.keyboard.isDown("lctrl", "rctrl") then
        -- TODO: if ctrl + key, then assign control key for that self.selection
    elseif key == "??" then
        -- TODO: if key, then select that control group
    end
    if key == "space" and self.selection then
        -- TODO: if space, then activate/toggle selected object
    end
    if key == "escape" and self.selection then
        self.selection = nil
        self.selection_index = nil
    end
end

function scene:update(dt)
    self.clock:update(dt)
    for _, t in pairs(self.trains) do
        t:update(dt)
    end
    for _, s in pairs(self.schedules) do
        s:update(dt)
    end
end

function scene:draw()
    self.world:draw()
end

return scene