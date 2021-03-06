----------------
-- Shop class --
----------------

local File = require 'src/File'
local UI = require 'src/ui/UI'
local ShopItem = require 'src/shop/ShopItem'
local Coin = require 'src/Coin'

local Shop = {
    temperature = 0,
    money = 0, totalMoney = 0, highestScore = 0,

    -- Lists
    circleList = {}, coinsList = {}, itemsList = {},

    -- Coins items
    coinsPickedOnHover = false, coinSpawnTime = 0, coinScale = 3, coinsValue = 5, coinsMovement = false,

    -- Circle items
    circleRandomInitialPosition = false, numberOfCircles = 1,

    -- other items
    mouseScale = 1, circleSpeed = 30, circleSize = 5
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
            Shop.addItem('coinsMovement', 1)
            Shop.addItem('coinScale', 1)
            if playingOnMobile then
                Shop.addItem('coinsPickedOnHover', 2)
            else
                Shop.addItem('coinsPickedOnHover', 1)
            end
        end
    end

    Shop.setTemperature()
    UI.loadShopButtons()

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
    Shop.temperature = 0
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

local moneyCooldown = 0
function Shop.receiveMoney(dt)
    moneyCooldown = moneyCooldown + dt + (Shop.temperature * 0.001)
    if moneyCooldown >= 1 then
        Shop.money = Shop.money + 1
        Shop.totalMoney = Shop.totalMoney + 1
        moneyCooldown = 0
    end
end

local coinsTempo = 0
function Shop.spawnCoins(dt)
    if Shop.coinSpawnTime > 0 then
        coinsTempo = coinsTempo + dt
        if coinsTempo >= Shop.coinSpawnTime then
            table.insert(Shop.coinsList, Coin:new(Shop.coinScale))
            coinsTempo = 0
        end
    end
end

return Shop