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

MOUSE_CLICK_THRESHOLD = 16

local trains = { 
    train.new({
        position = {20, 20},
        carriages = 3,
    })
}

local w = world.load("world_1.lua")
local selection = nil
local selection_index = nil

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
    -- TODO: if tab then cycle through selectable static objects in world
    if key == "tab" then
        selection, selection_index = w:getNextTabObject(selection_index)
    end
    -- TODO: if <??> then cycle through selectable moveable objects (trains) in world
    if key == "??" and love.keyboard.isDown("lctrl", "rctrl") then
        -- TODO: if ctrl + key, then assign control key for that selection
    elseif key == "" then
        -- TODO: if key, then select that control group
    end

    -- TODO: if space, then activate/toggle selected object
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