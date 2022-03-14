----------------
-- Shop class --
----------------

ShopItem = require 'src/shop/ShopItem'
local Coin = require 'src/Coin'

local Shop = {
    temperature = 0,
    money = 0, totalMoney = 0, moneyCooldown = 0,

    -- Lists
    circleList = {}, coinsList = {}, itemsList = {},

    -- Coins items
    coinsPickedOnHover = false, coinSpawnTime = 0, coinScale = 3, coinsValue = 5,

    -- Circle items
    circleRandomInitialPosition = false, numberOfCircles = 1
}

function Shop.update()
    local newShop = {}

    -- Insert items upgrades
    for tempo, item in ipairs(Shop.itemsList) do
        table.insert(newShop, ShopItem:new(item.type, item.level))
    end
    Shop.itemsList = newShop

    -- Insert unlockable items
    for tempo, item in ipairs(newShop) do
        if item.type == 'coinsSpawnTime' and item.level > 1 then
            if playingOnMobile then
                Shop.addItem('coinsPickedOnHover', 2)
            else
                Shop.addItem('coinsPickedOnHover', 1)
            end
        end
    end

    Shop.setTemperature()

    File.save()
end

function Shop.addItem(type, level)
    local alreadyExists = false
    for tempo, item in ipairs(Shop.itemsList) do
        if item.type == type then
            alreadyExists = true
        end
    end
    if not alreadyExists then
        table.insert(Shop.itemsList, ShopItem:new(type, level))
    end
end

function Shop.setTemperature()
    for tempo, item in ipairs(Shop.itemsList) do
        if item.level > 1 then
            Shop.temperature = Shop.temperature + item.temperature * (item.level-1)
        end
    end
end

function Shop.getItems()
    local filteredItems = {}

    for tempo, item in ipairs(Shop.itemsList) do
        if gameState == 'shop - cold' and item.temperature < 0
        or gameState == 'shop - hot' and item.temperature > 0 then
            table.insert(filteredItems, item)
        end
    end

    return filteredItems
end

function Shop.receiveMoney(dt)
    Shop.moneyCooldown = Shop.moneyCooldown + dt + (Shop.temperature * 0.001)
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