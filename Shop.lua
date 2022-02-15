----------------
-- Shop class --
----------------

local ShopElement = require 'ShopElement'
local Coin = require 'Coin'
local Ball = require 'Ball'

local Shop = {}

Shop.temperature = 0

Shop.money = 0
Shop.totalMoney = 0
Shop.moneyCooldown = 0

Shop.ballList = {}
Shop.coinsList = {}
Shop.elementsList = {}

-- Coins properties

Shop.coinsPickedOnHover = false
Shop.coinSpawnTime = 0
Shop.coinScale = 3
Shop.coinsValue = 5

function Shop.load()
    table.insert(Shop.ballList, Ball:new())

    table.insert(Shop.elementsList, ShopElement:new('coinsPickedOnHover'))
end

function Shop.receiveCoins(dt)
    Shop.moneyCooldown = Shop.moneyCooldown + dt
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