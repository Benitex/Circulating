----------------
-- Ball class --
----------------

local Mouse = require 'Mouse'
local Shop = require 'Shop'
local Sounds = require 'Sounds'

local Ball = {
    x = love.graphics.getWidth()/2,
    y = love.graphics.getHeight()/2,
    speed = 7*30,
    size = 15
}
Ball.__index = Ball

function Ball:new()
    self = setmetatable({}, self)

    self.x = love.graphics.getWidth()/2
    self.y = love.graphics.getHeight()/2
    self.speed = 7*30
    self.size = 15

    return self
end

function Ball:move(dt)
    if love.mouse.getX() > self.x then
        self.x = self.x + self.speed * dt
    elseif love.mouse.getX() < self.x then
        self.x = self.x - self.speed * dt
    end
    if love.mouse.getY() > self.y then
        self.y = self.y + self.speed * dt
    elseif love.mouse.getY() < self.y then
        self.y = self.y - self.speed * dt
    end

    self.speed = self.speed + dt*30
    self.size = self.size + dt*5
    if areCirclesTouching(self.x, self.y, self.size, love.mouse.getX(), love.mouse.getY(), Mouse.size) then
        gameState = 'game over'
        countdown = 3
        Shop.money = 0
        Sounds.defeatSE:play()
    end
end

return Ball