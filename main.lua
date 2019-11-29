--[[

world
    broken into 2x2 metre cells

track
    

train
    moves to next signal / station

switch
    changes track connections

signal
    makes trains wait
    can be manually triggered and automatically triggered

schedule
    assigns times to trigger events

event
    can be manually triggered and automatically triggered from schedule
    can have conditional logic stuff
    can set signals

route
    dictates where a train must be and when

station
    collection of platforms
    
--]]

local train = require 'train'
local world = require 'world'

local MOUSE_CLICK_THRESHOLD = 16

local trains = {
    train.new({
        position = {20, 20},
        carriages = 3,
    })
}

local w = world.load("world_1.lua")
local selection = nil
local selection_index = nil
local all_selectable_objects = w:allSelectableObjects()

local world_width = 1000 -- TODO: set actual world width
table.sort(all_selectable_objects, function(a, b)
    a.x + a.y * world_width < b.x + b.y * world_width
end)

for _, t in pairs(trains) do
    table.insert(all_selectable_objects, t)
end


local function objectNearestPoint(x, y, threshold)
    local nearest = nil
    local distance = nil
    for _, obj in pairs(all_selectable_objects) do
        local dist = (x - nearest.x)^2 +(y - nearest.y)^2
        if dist <= threshold and (nearest == nil or dist < distance) then
            nearest = obj
            distance = dist
        end
    end
    return nearest
end

local function getNextTabObject()
    local next_object_index = (selection_index or 0) + 1
    if next_object_index > #all_selectable_objects then
        next_object_index = 1
    end
    selection = all_selectable_objects[next_object_index]
    selection_index = next_object_index
end

local function getPreviousTabObject()
    local next_object_index = (selection_index or 0) - 1
    if next_object_index < 1 then
        next_object_index = #all_selectable_objects
    end
    selection = all_selectable_objects[next_object_index]
    selection_index = next_object_index
end

function love.load()
    love.graphics.setBackgroundColor(0.7,0.7,0.7)
    love.graphics.setLineStyle("rough")
end

function love.mousereleased(mx, my, key)
    local wx, wy = mx, my
    local obj = w:objectNearestPoint(wx, wy, MOUSE_CLICK_THRESHOLD)
    if obj then
        selection = obj
        selection_index = w:getTabObjectIndex(selection)
    end
end

function love.keypressed(key)
    if key == "tab" then
        if love.keyboard.isDown("lshift", "rshift") then
            selection, selection_index = w:getPreviousTabObject(selection_index)
        else
            selection, selection_index = w:getNextTabObject(selection_index)
        end
    end
    if key == "??" and love.keyboard.isDown("lctrl", "rctrl") then
        -- TODO: if ctrl + key, then assign control key for that selection
    elseif key == "??" then
        -- TODO: if key, then select that control group
    end
    if key == "space" and selection then
        -- TODO: if space, then activate/toggle selected object
    end
    if key == "escape" and selection then
        selection = nil
        selection_index = nil
    end
end

function love.update(dt)
    for _, t in pairs(trains) do
        t:update(dt)
    end
    for _, s in pairs(schedules) do
        s:update(dt)
    end
end

function love.draw()
    w:draw()
end