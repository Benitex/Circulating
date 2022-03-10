----------------
-- Ball class --
----------------

local Mouse = require 'Mouse'
local Window = require 'Window'

local Ball = {
    x = Window.width/2,
    y = Window.height/2,
    speed = 7*30,
    size = 15
}
Ball.__index = Ball

function Ball:new(randomPosition)
    self = setmetatable({}, self)

    if randomPosition then
        self.x = love.math.random(self.size, Window.width - self.size)
        self.y = love.math.random(self.size, Window.height - self.size)
    else
        self.x = Window.width/2
        self.y = Window.height/2
    end

    self.speed = 7*30
    self.size = 15

    return self
end

function Ball:move(dt)
    if Mouse.x > self.x then
        self.x = self.x + self.speed * dt
    elseif Mouse.x < self.x then
        self.x = self.x - self.speed * dt
    end
    if Mouse.y > self.y then
        self.y = self.y + self.speed * dt
    elseif Mouse.y < self.y then
        self.y = self.y - self.speed * dt
    end

    self.speed = self.speed + dt*30
    self.size = self.size + dt*5
end

function Ball:touchedByMouse()
    return areCirclesTouching(self.x, self.y, self.size, Mouse.x, Mouse.y, Mouse.size)
end

return Ball