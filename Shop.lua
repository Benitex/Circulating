----------------
-- Shop class --
----------------

local Coin = require 'Coin'

local Shop = {}

Shop.temperature = 0

Shop.money = 0
Shop.totalMoney = 0
Shop.moneyCooldown = 0

-- Coins properties
Shop.coinsList = {}
Shop.coinsPickedOnHover = true
Shop.coinsTempo = 0
Shop.coinSpawnTime = 0
Shop.coinScale = 3
Shop.coinsValue = 5

function Shop.receiveCoins(dt)
    Shop.moneyCooldown = Shop.moneyCooldown + dt
    if Shop.moneyCooldown >= 1 then
        Shop.money = Shop.money + 1
        Shop.totalMoney = Shop.totalMoney + 1
        Shop.moneyCooldown = 0
    end
end

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