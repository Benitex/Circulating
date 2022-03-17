----------------
-- Coin Class --
----------------

local Window = require 'src/ui/Window'
local Mouse = require 'src/Mouse'

local Coin = {
    x = 0, y = 0, width = 16, height = 16,
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

function areCirclesTouching(x1, y1, size1, x2, y2, size2)
    local distance = math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
    return distance < size1 + size2
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