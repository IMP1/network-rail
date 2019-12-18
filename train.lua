local scene_manager = require 'scene_manager'
local pallete = require 'pallete_default'
local carriage = require 'carriage'
local direction = require 'direction'
local route = require 'route'

local train = {}
train.__index = train

local function floor(x, y, forwards)
    local ox, oy = direction.to_offset(forwards)
    local new_x, new_y
    if ox < 0 then
        new_x = math.ceil(x)
    elseif ox > 0 then
        new_x = math.floor(x)
    else
        new_x = x
    end
    if oy < 0 then
        new_y = math.ceil(y)
    elseif oy > 0 then
        new_y = math.floor(y)
    else
        new_y = y
    end
    return new_x, new_y
end

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

    self.route            = options.route           or route.new()
    self.position         = options.position        or {0, 0} -- metres
    self.direction        = options.direction       or 0  -- radians
    self.speed            = options.speed           or 2  -- cells per second

    self.sections = {}
    table.insert(self.sections, carriage.new({
        position  = self.position,
        direction = self.direction,
        length    = self.engine_length,
        shape     = self.engine_shape,
    }))

    local track = world:trackAt(unpack(self.position))
    local backwards = track:next(direction.inverse(self.direction))
    local movement = { direction.to_offset(backwards) }
    local pos = { self.position[1] + movement[1], self.position[2] + movement[2] }

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

    do
        local next_track = self:next_track(world)
        for _, signal in pairs(world.signals) do
            if signal.track == next_track then
                signal:wait(self)
                self.waiting = true
            end
        end
    end

    return self
end

function train:next_track(world)
    local track = world:trackAt(unpack(self.position))
    local forwards = track:next(self.direction)
    local movement = { direction.to_offset(forwards) }
    local pos = { self.position[1] + movement[1], self.position[2] + movement[2] }
    return world:trackAt(pos[1], pos[2])
end

function train:notify(signal)
    local world = scene_manager.scene().world
    local next_track = self:next_track(world)
    if signal.track == next_track and signal.allow_passage then
        self.moving = true
    end
end

function train:update(dt, world)
    if not self.moving then return end
    self.track_progress = self.track_progress + dt * self.speed
    -- Update to next track
    if self.track_progress >= 1 then
        self.track_progress = self.track_progress - 1
        -- Update sections' position and direction
        for _, section in pairs(self.sections) do
            local x, y = unpack(section.position)
            local i, j = floor(x, y, section.direction)
            local track = world:trackAt(i, j)
            local forwards = track:next(section.direction)
            local dx, dy = direction.to_offset(forwards)
            section.position = {i + dx, j + dy}
            section.direction = forwards
        end
        -- Update train's position and direction
        local track = world:trackAt(unpack(self.position))
        local forwards = track:next(self.direction)
        local movement = { direction.to_offset(forwards) }
        self.position = { self.position[1] + movement[1], self.position[2] + movement[2] }
        self.direction = forwards
        -- Wait if there's a signal ahead
        local next_track = self:next_track(world)
        for _, signal in pairs(world.signals) do
            if signal.track == next_track and not signal.allow_passage then
                signal:wait(self)
                self.waiting = true
                self.moving = false
            end
        end
    end
    -- Update partial position along track for each section
    for _, section in pairs(self.sections) do
        local x, y = unpack(section.position)
        local i, j = floor(x, y, section.direction)
        local track = world:trackAt(i, j)
        local forwards = track:next(section.direction)
        local dx, dy = direction.to_offset(forwards)
        section.position = {i + dx * self.track_progress, j + dy * self.track_progress}
    end
end

function train:draw(tile_size)
    love.graphics.setColor(0, 0, 0)
    for _, section in pairs(self.sections) do
        section:draw(tile_size)
    end
    do -- debug
        local head = self.sections[1]
        local x, y = unpack(head.position)
        local i, j = floor(x, y, head.direction)
        love.graphics.setColor(pallete.BLACK)
        love.graphics.circle("line", i * tile_size, j * tile_size, 4)
        local next_track = self:next_track(scene_manager.scene().world)
        local i, j = unpack(next_track.position)
        love.graphics.setColor(pallete.GO)
        love.graphics.circle("line", i * tile_size, j * tile_size, 12)
    end
end

function train:drawInfo()
    love.graphics.setColor(pallete.BLACK)
    love.graphics.print("Train", 0, 0)
end

return train