----------------
-- Shop class --
----------------

local ShopElement = require 'src/shop/ShopElement'
local Coin = require 'src/Coin'

local Shop = {
    temperature = 0,
    money = 0, totalMoney = 0, moneyCooldown = 0,

    -- Lists
    ballList = {}, coinsList = {},

    elementsList = {
        ShopElement:new('coinsSpawnTime'),
        ShopElement:new('ballInitialPosition')
    },

    -- Coins elements
    coinsPickedOnHover = false, coinSpawnTime = 0, coinScale = 3, coinsValue = 5,

    -- Ball elements
    ballRandomInitialPosition = false, numberOfBalls = 1
}

function Shop.load()
    if playingOnMobile then
        Shop.coinsPickedOnHover = true
    else
        table.insert(Shop.elementsList, ShopElement:new('coinsPickedOnHover'))
    end
end

function Shop.receiveCoins(dt)
    Shop.moneyCooldown = Shop.moneyCooldown + dt + (-Shop.temperature * 0.1)
    if Shop.moneyCooldown >= 1 then
        Shop.money = Shop.money + 1
        Shop.totalMoney = Shop.totalMoney + 1
        Shop.moneyCooldown = 0
    end
end

Shop.coinsTempo = 0
function Shop.spawnCoins(dt)
    if Shop.coinSpawnTime > 0 then
        Shop.coinsTempo = Shop.coinsTempo + dt
        if Shop.coinsTempo >= Shop.coinSpawnTime then
            table.insert(Shop.coinsList, Coin:new(Shop.coinScale))
            Shop.coinsTempo = 0
        end
    end
end

return Shop