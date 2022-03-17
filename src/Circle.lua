----------------
-- Circle class --
----------------

local Window = require 'src/ui/Window'
local Mouse = require 'src/Mouse'

local Circle = {
    x = love.graphics.getWidth()/2,
    y = love.graphics.getHeight()/2,
    speed = 7*30,
    size = 15
}
Circle.__index = Circle

function Circle:new(randomPosition)
    self = setmetatable({}, self)

    if randomPosition then
        self.x = love.math.random(self.size, Window.width - self.size)
        self.y = love.math.random(self.size, Window.height - self.size)
    else
        self.x = Window.width/2
        self.y = Window.height/2
    end

    self.speed = 7*30*Window.screenWidthScale
    self.size = 15 * Window.screenWidthScale

    return self
end

function Circle:move(dt)
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

    self.speed = self.speed + 30*dt*Window.screenWidthScale
    self.size = self.size + 5*dt*Window.screenWidthScale
end

function Circle:touchedByMouse()
    local distance = math.sqrt( (self.x - Mouse.x)^2 + (self.y - Mouse.y)^2 )
    return distance < self.size + Mouse.size
end

return Circle