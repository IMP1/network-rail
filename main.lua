
local scene_manager = require 'scene_manager'

local INITIAL_SCENE = require 'scene_game'

function love.load()
    love.graphics.setBackgroundColor(0.7,0.7,0.7)
    love.graphics.setLineStyle("rough")
    scene_manager.hook()
    scene_manager.setScene(INITIAL_SCENE.new())
end

function love.mousereleased(mx, my, key)
    scene_manager.mouseReleased(mx, my, key)
end

function love.keypressed(key)
    scene_manager.keyPressed(key)
end

function love.update(dt)
    scene_manager.update(dt)
end

function love.draw()
    scene_manager.draw()
end