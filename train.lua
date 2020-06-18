local scene_manager = require 'scene_manager'
local pallete       = require 'pallete_default'
local carriage      = require 'carriage'
local direction     = require 'direction'
local route         = require 'route'

local train = {}
train.__index = train

function train.new(options, world)
    local self = {}
    setmetatable(self, train)

    local carriage_count  = options.carriages       or 2
    local carriage_length = options.carriage_length or 20 -- metres
    local carriage_width  = options.carriage_width  or 3  -- metres
    local carriage_shape  = options.carriage_shape  or carriage.shapes.SQUARE
    local engine_length   = options.engine_length   or 20 -- metres
    local engine_width    = options.engine_width    or 3  -- metres
    local engine_shape    = options.engine_shape    or carriage.shapes.BULLET

    self.route            = route.new(options.route or {})
    self.track_position   = options.position        or {0, 0} -- coordinates
    self.position         = self.track_position
    self.direction        = options.direction       or 0  -- radians
    self.speed            = options.speed           or 2  -- cells per second

    self.sections = {}
    table.insert(self.sections, carriage.new({
        position  = self.position,
        direction = self.direction,
        length    = self.engine_length,
        shape     = self.engine_shape,
    }))

    local track = world:trackAt(unpack(self.track_position))
    local backwards = track:next(direction.inverse(self.direction))
    local movement = { direction.to_offset(backwards) }
    local pos = { self.track_position[1] + movement[1], self.track_position[2] + movement[2] }

    for i = 1, carriage_count do
        table.insert(self.sections, carriage.new({
            position  = { unpack(pos) },
            direction = direction.inverse(backwards),
            length    = self.carriage_length,
            shape     = self.carriage_shape,
        }))
        -- Work out position backwards along track
        track = world:trackAt(unpack(pos))
        backwards = track:next(backwards)
        movement = { direction.to_offset(backwards) }
        pos = { pos[1] + movement[1], pos[2] + movement[2] }
    end
    self.head = self.sections[1]
    self.waiting = false
    self.moving = false
    self.track_progress = 0

    local next_track = self:next_track(world)
    for _, signal in pairs(world.signals) do
        if signal.track == next_track then
            signal:wait(self)
            self.waiting = true
        end
    end

    return self
end

function train:next_track(world)
    local track = world:trackAt(unpack(self.track_position))
    local forwards = track:next(self.direction)
    if forwards == nil then
        scene_manager.scene():crashTrain(self)
        self.crashed = true
        return
    end
    local movement = { direction.to_offset(forwards) }
    local pos = { self.track_position[1] + movement[1], self.track_position[2] + movement[2] }
    return world:trackAt(pos[1], pos[2])
end

function train:notify(signal)
    local world = scene_manager.scene().world
    local next_track = self:next_track(world)
    if signal.track == next_track and signal.allow_passage then
        self.moving = true
    end
end

function train:move_to_next_track(world)
    -- Update sections' position and direction
    for _, section in pairs(self.sections) do
        local x, y = unpack(section.position)
        local i, j = unpack(section.track_position)
        local track = world:trackAt(i, j)
        local forwards = track:next(section.direction)
        local dx, dy = direction.to_offset(forwards)
        section.track_position = {i + dx, j + dy}
        section.position = section.track_position
        section.direction = forwards
    end
    -- Update train's position and direction
    local x, y = unpack(self.track_position)
    local track = world:trackAt(x, y)
    local forwards = track:next(self.direction)
    local dx, dy = direction.to_offset(forwards)
    self.track_position = { x + dx, y + dy }
    self.position = self.track_position
    self.direction = forwards
    -- Wait if there's a signal ahead
    local next_track = self:next_track(world)
    for _, signal in pairs(world.signals) do
        if signal.track == next_track and not signal.allow_passage then
            signal:wait(self)
            self.waiting = true
            self.moving = false
            local station = world:stationFromSignal(signal)
            if station then
                self.route:arriveAt(station, world.current_time)
            end
        end
    end
end

function train:update(dt, world)
    if not self.moving then return end
    self.track_progress = self.track_progress + dt * self.speed
    if self.track_progress >= 1 then
        self.track_progress = self.track_progress - 1
        self:move_to_next_track(world)
    end
    if self.crashed then
        return
    end
    -- Update partial position along track for each section
    for section_index, section in ipairs(self.sections) do
        local x, y = unpack(section.position)
        local i, j = unpack(section.track_position)
        local track = world:trackAt(i, j)
        if track == nil then 
            local error_message = "attempt to index local 'track' (a nil value)\n"
            error_message = error_message .. "  for section #" .. section_index .. "\n"
            error_message = error_message .. "  at " .. i .. ", " .. j .. "\n"
            error_message = error_message .. "  at " .. x .. ", " .. y .. "\n"
            error_message = error_message .. "  in direction: " .. section.direction
            error(error_message)
        end
        local forwards = track:next(section.direction)
        local dx, dy = direction.to_offset(forwards)
        section.position = { i + dx * self.track_progress, j + dy * self.track_progress }
    end
end

function train:drawTrain(tile_size)
    love.graphics.setColor(0, 0, 0)
    for _, section in pairs(self.sections) do
        section:draw(tile_size)
    end
    self.sections[1]:draw(tile_size, 4)
end

function train:draw(tile_size)
    self:drawTrain(tile_size)
end

function train:drawSelected(tile_size)
    self:drawTrain(tile_size)
    do
        local angle = direction.to_radians(self.sections[1].direction)
        local x, y = unpack(self.sections[1].position)
        local r1, r2 = angle - math.pi / 2, angle + math.pi / 2
        love.graphics.arc("line", "open", x * tile_size, y * tile_size, tile_size / 2, r1, r2)
    end
    do
        local angle = direction.to_radians(direction.inverse(self.sections[#self.sections].direction))
        local x, y = unpack(self.sections[#self.sections].position)
        local r1, r2 = angle - math.pi / 2, angle + math.pi / 2
        love.graphics.arc("line", "open", x * tile_size, y * tile_size, tile_size / 2, r1, r2)
    end
end

function train:drawInfo()
    love.graphics.setColor(pallete.BLACK)
    love.graphics.print("Train", 0, 0)
    --[[ --DEBUG INFO
    do
        local head = self.sections[1]
        local x, y = unpack(head.position)
        local i, j = unpack(head.track_position)
        love.graphics.print(i .. ", " .. j, 0, 16)
        local next_track = self:next_track(scene_manager.scene().world)
        i, j = unpack(next_track.position)
        love.graphics.print("->" .. i .. ", " .. j, 0, 32)
    end
    --]]
    love.graphics.print("Route: ", 0, 16)
    for j, stop in ipairs(self.route.stops) do
        local x, y = 8, j * 16 + 16
        love.graphics.setColor(pallete.BLACK)
        if j <= self.route.current_position then
            if stop.arrival_time == nil then
                if j < self.route.current_position then
                    love.graphics.setColor(pallete.MISSED)
                end
            elseif stop.arrival_time > stop.time then
                love.graphics.setColor(pallete.LATE)
            else
                love.graphics.setColor(pallete.ON_TIME)
            end
        end
        love.graphics.print(stop.station.name, x, y )
        love.graphics.print(tostring(stop.time), x + 96, y)
        if stop.arrival_time then
            love.graphics.print(tostring(stop.arrival_time), x + 128, y)
        end
    end
end

return train