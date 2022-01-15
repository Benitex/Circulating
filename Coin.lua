----------------
-- Coin Class --
----------------

local Coin = {
    x = 0, y = 0, width = 16, height = 16,
    sprite = love.graphics.newImage('graphics/icons/Coin_Icon.png'), scale = 3
}
Coin.__index = Coin

function Coin:new(scale)
    self = setmetatable({}, self)

    self.scale = scale
    self.width = 16 * scale
    self.height = 16 * scale
    self.x = love.math.random(love.graphics.getWidth() - self.width * self.scale)
    self.y = love.math.random(love.graphics.getHeight() - self.height * self.scale)

    return self
end

function Coin:clicked(x, y, width, height)
    if x + width >= self.x and x <= self.x + self.width and y + height >= self.y and y <= self.y + self.height then
        Shop.coins = Shop.coins + Shop.coinsValue
        Shop.totalCoins = Shop.totalCoins + Shop.coinsValue
        return true
    else
        return false
    end
end

function Coin:hovered(x, y, width, height)
    if x + width >= self.x and x <= self.x + self.width and y + height >= self.y and y <= self.y + self.height then
        Shop.coins = Shop.coins + Shop.coinsValue
        Shop.totalCoins = Shop.totalCoins + Shop.coinsValue
        return true
    else
        return false
    end
end

return Coin