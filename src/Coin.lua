----------------
-- Coin Class --
----------------

local Window = require 'src/ui/Window'
local Mouse = require 'src/Mouse'

local Coin = {
    x = 0, y = 0, width = 16, height = 16,
    direction = 0, directionTempo = 1,
    sprite = love.graphics.newImage('graphics/icons/Coin_Icon.png'), scale = 3
}
Coin.__index = Coin

function Coin:new(scale)
    self = setmetatable({}, self)

    self.scale = scale*Window.screenWidthScale
    self.width = 16 * self.scale
    self.height = 16 * self.scale
    self.x = love.math.random(Window.width - self.width*2)
    self.y = love.math.random(Window.height - self.height*2)

    return self
end

function Coin:move(dt)
    self.directionTempo = self.directionTempo - dt

    if self.directionTempo <= 0 then
        self.direction = love.math.random(1, 4)
        self.directionTempo = 2
    end

    if self.direction == 1 then
        self.x = self.x + 3*30*dt*Window.screenWidthScale
    elseif self.direction == 2 then
        self.x = self.x - 3*30*dt*Window.screenWidthScale
    elseif self.direction == 3 then
        self.y = self.y + 3*30*dt*Window.screenHeightScale
    elseif self.direction == 4 then
        self.y = self.y - 3*30*dt*Window.screenHeightScale
    end

    if self.x >= Window.width - self.width then
        self.x = Window.width - self.width
    elseif self.x <= 0 then
        self.x = 0
    end
    if self.y >= Window.height - self.height then
        self.y = Window.height - self.height
    elseif self.y <= 0 then
        self.y = 0
    end
end

function Coin:clicked()
    if self.x < Mouse.x + Mouse.size and self.x + self.width > Mouse.x - Mouse.size
    and self.y < Mouse.y + Mouse.size and self.y + self.height > Mouse.y - Mouse.size then
        Shop.money = Shop.money + Shop.coinsValue
        Shop.totalMoney = Shop.totalMoney + Shop.coinsValue
        return true
    else
        return false
    end
end

return Coin