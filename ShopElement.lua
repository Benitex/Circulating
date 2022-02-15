-------------------------
-- Shop Elements class --
-------------------------

local ShopElement = {
    type = '', price = 0, level = 1, maxLevel = 2, priceMultiplier = 1.5
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
    end

    return self
end

function ShopElement:upgrade()
    return function ()
        if self.level <= self.maxLevel then
            if Shop.totalMoney >= self.price then
                if self.type == 'coinsPickedOnHover' then
                    Shop.coinsPickedOnHover = true
                end
    
                self.level = self.level + 1
                Shop.totalMoney = Shop.totalMoney - self.price
            end
        end
    end
end

return ShopElement