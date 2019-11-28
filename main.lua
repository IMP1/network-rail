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