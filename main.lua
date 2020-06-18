love.graphics.style_states = {}

function love.graphics.pushState(state_name, ...)
    local old_value = { love.graphics["get" .. state_name]() }
    if love.graphics.style_states[state_name] == nil then
        love.graphics.style_states[state_name] = {}
    end
    table.insert(love.graphics.style_states[state_name], old_value)
    love.graphics["set" .. state_name](...)
end

function love.graphics.popState(state_name)
    local previous_values = table.remove(love.graphics.style_states[state_name])
    love.graphics["set" .. state_name](unpack(previous_values))
end

function table.zip(table1, table2)
    local outcome = {}
    for i, obj in ipairs(table1) do
        table.insert(outcome, obj)
        table.insert(outcome, table2[i])
    end
    return outcome
end

local scene_manager = require 'scene_manager'

local INITIAL_SCENE = require 'scene_game'


function love.load()
    love.graphics.setBackgroundColor(0.7,0.7,0.7)
    love.graphics.setLineStyle("rough")
    scene_manager.hook()
    local level_data = love.filesystem.load("level_1.lua")()
    scene_manager.setScene(INITIAL_SCENE.new(level_data))
end

function love.update(dt)
    scene_manager.update(dt)
end

function love.draw()
    scene_manager.draw()
end