-------------------------
-- Shop Elements class --
-------------------------

local ShopElement = {
    type = '', price = 0, level = 1, maxLevel = 2, priceMultiplier = 1.5, temperature = 0, text = ''
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

function ShopElement:new(type, level)
    self = setmetatable({}, self)

    self.type = type
    self.level = level
    self.priceMultiplier = 1.5

    if self.type == 'coinsPickedOnHover' then
        self.text = 'Coins picked on hover\nCoins can be picked without\nthe need to click on them.'
        self.price = 100
        self.maxLevel = 2
        self.temperature = -1

        if self.level == 2 then
            Shop.coinsPickedOnHover = true
        end
    elseif self.type == 'coinsSpawnTime' then
        if self.level == 1 then
            self.text = 'Coins\nClick on coins to increase\nyour money.'
        else
            self.text = 'Coins Time\nCoins spawn in less time'
        end
        self.price = 20
        self.maxLevel = 6
        self.temperature = -1

        if self.level > 1 then
            Shop.coinSpawnTime = 7 - self.level
        end
    elseif self.type == 'ballInitialPosition' then
        self.text = 'Random Circle Position\nThe circle starts at a random\nposition.'
        self.price = 100
        self.maxLevel = 2
        self.temperature = 1

        if self.level > 1 then
            Shop.ballRandomInitialPosition = true
        end
    end

    if self.level > 1 then
        self.price = math.floor( self.price * self.priceMultiplier ^ self.level )
    end

    return self
end

function ShopElement:upgrade()
    return function ()
        if self.level < self.maxLevel then
            if Shop.totalMoney >= self.price then
                self.level = self.level + 1
                Shop.totalMoney = Shop.totalMoney - self.price
                --Shop.temperature = Shop.temperature + self.temperature TODO
                Shop.update()
            end
        end
    end
end

return ShopElement