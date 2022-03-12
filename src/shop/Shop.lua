----------------
-- Shop class --
----------------

ShopElement = require 'src/shop/ShopElement'
local Coin = require 'src/Coin'

local Shop = {
    temperature = 0,
    money = 0, totalMoney = 0, moneyCooldown = 0,

    -- Lists
    ballList = {}, coinsList = {}, elementsList = {},

    -- Coins elements
    coinsPickedOnHover = false, coinSpawnTime = 0, coinScale = 3, coinsValue = 5,

    -- Ball elements
    ballRandomInitialPosition = false, numberOfBalls = 1
}

function Shop.load()
    if playingOnMobile then
        Shop.coinsPickedOnHover = true
    else
        if #Shop.elementsList == 0 then
            table.insert(Shop.elementsList, ShopElement:new('coinsSpawnTime', 1))
            table.insert(Shop.elementsList, ShopElement:new('ballInitialPosition', 1))
        end
    end
    UI.loadShopButtons()
    gameState = 'shop'
end

function Shop.update()
    local newShop = {}

    -- Insert elements upgrades
    for tempo, element in ipairs(Shop.elementsList) do
        table.insert(newShop, ShopElement:new(element.type, element.level))
    end
    Shop.elementsList = newShop

    -- Insert unlockable elements
    for tempo, element in ipairs(newShop) do
        if element.type == 'coinsSpawnTime' and element.level > 1 then
            Shop.addElement('coinsPickedOnHover')
        end
    end

    File.save()
end

function Shop.addElement(type)
    local alreadyExists = false
    for tempo, element in ipairs(Shop.elementsList) do
        if element.type == type then
            alreadyExists = true
        end
    end
    if not alreadyExists then
        table.insert(Shop.elementsList, ShopElement:new(type, 1))
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