-------------------------
-- Shop Items class --
-------------------------

local ShopItem = {
    type = '', price = 0, level = 1, maxLevel = 2, priceMultiplier = 1.5, temperature = 0, text = ''
}
ShopItem.__index = ShopItem

function ShopItem:new(type, level)
    self = setmetatable({}, self)

    self.type = type
    self.level = level
    self.priceMultiplier = 1.5

    -- Cold Items
    if self.type == 'coinsPickedOnHover' then
        self.text = 'Coins sucker:\nCoins can be picked without the need to click\non them.'
        self.price = 100
        self.maxLevel = 2
        self.temperature = -2

        if self.level == 2 then
            Shop.coinsPickedOnHover = true
        end
    elseif self.type == 'coinsSpawnTime' then
        if self.level == 1 then
            self.text = 'Courage Coins:\nClick on coins to increase your money.'
        else
            self.text = 'Coins sped up:\nCoins spawn in more frequently.'
        end
        self.price = 20
        self.maxLevel = 6
        self.temperature = -1

        if self.level > 1 then
            Shop.coinSpawnTime = 7 - self.level
        end

    -- coins size item
    -- TODO

    -- Hot Items
    elseif self.type == 'circleInitialPosition' then
        self.text = 'Circulating Circle Position:\nThe circle starts at a random position.'
        self.price = 30
        self.maxLevel = 2
        self.temperature = 1

        if self.level > 1 then
            Shop.circleRandomInitialPosition = true
        end
    elseif self.type == 'mouseSize' then
        self.text = 'The big boy mouse:\nMouse icon is bigger.'
        self.price = 50
        self.maxLevel = 4
        self.temperature = 2

        if self.level > 1 then
            Shop.mouseScale = self.level
        end
    elseif self.type == 'coinsMovement' then
        self.text = 'The walking coins:\nCoins are always going in a random direction.'
        self.price = 20
        self.maxLevel = 2
        self.temperature = 1

        if self.level > 1 then
            Shop.coinsMovement = true
        end
    end

    if self.level > 1 then
        self.price = math.floor( self.price * self.priceMultiplier ^ self.level )
    end

    return self
end

function ShopItem:upgrade()
    return function ()
        if self.level < self.maxLevel then
            if Shop.totalMoney >= self.price then
                self.level = self.level + 1
                Shop.totalMoney = Shop.totalMoney - self.price
                Shop.update()
            end
        end
    end
end

return ShopItem