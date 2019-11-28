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

local trains = { 
    train.new({
        position = {20, 20},
        carriages = 3,
    })
}

local world = world.load("world_1.lua")

function love.load()
end

function love.draw()
end