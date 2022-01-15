----------------
-- Shop class --
----------------

local Coin = require 'Coin'

local Shop = {}

Shop.coins = 0
Shop.totalCoins = 0
Shop.coinsCooldown = 0

-- Coins
Shop.coinsList = {}
Shop.coinsPickedOnHover = true
Shop.coinsTempo = 0
Shop.coinSpawnTime = 0
Shop.coinScale = 3
Shop.coinsValue = 5

function Shop.receiveCoins(dt)
    Shop.coinsCooldown = Shop.coinsCooldown + dt
    if Shop.coinsCooldown >= 1 then
        Shop.coins = Shop.coins + 1
        Shop.totalCoins = Shop.totalCoins + 1
        Shop.coinsCooldown = 0
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