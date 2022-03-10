-------------------------
-- Shop Elements class --
-------------------------

local ShopElement = {
    type = '', price = 0, level = 1, maxLevel = 2, priceMultiplier = 1.5, temperature = 0
}
ShopElement.__index = ShopElement

--[[
    Colder

    max number of coins on screen
    coins size
    coins value
    coins spawn time

    Hotter

    mouse size
    random ball initial position
    number of balls

--]]

function ShopElement:new(type)
    self = setmetatable({}, self)

    self.type = type
    self.level = 1
    self.priceMultiplier = 1.5

    if self.type == 'coinsPickedOnHover' then
        self.price = 100
        self.maxLevel = 2
        self.temperature = -1
    elseif self.type == 'coinsSpawnTime' then
        self.price = 20
        self.maxLevel = 6
        self.temperature = -1
    elseif self.type == 'ballInitialPosition' then
        self.price = 100
        self.maxLevel = 2
        self.temperature = 1
    end

    return self
end

function ShopElement:upgrade()
    return function ()
        if self.level <= self.maxLevel then
            if Shop.totalMoney >= self.price then

                if self.type == 'coinsPickedOnHover' then
                    Shop.coinsPickedOnHover = true
                elseif self.type == 'coinsSpawnTime' then
                    if Shop.coinSpawnTime == 0 then
                        Shop.coinSpawnTime = 5
                    else
                        Shop.coinSpawnTime = Shop.coinSpawnTime - 1
                    end
                elseif self.type == 'ballInitialPosition' then
                    Shop.ballRandomInitialPosition = true
                end

                self.level = self.level + 1
                self.price = self.price * self.priceMultiplier
                Shop.totalMoney = Shop.totalMoney - self.price
                Shop.temperature = Shop.temperature + self.temperature
            end
        end
    end
end

return ShopElement