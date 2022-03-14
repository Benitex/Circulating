--------------
-- UI Class --
--------------

local Button = require 'src/ui/Button'
local Circle = require 'src/Circle'
local Window = require 'src/ui/Window'

local UI = {
    backgrounds = {
        shop = love.graphics.newImage('graphics/ui/ShopUI.png')
    }
}

function UI.load()
    Window.load()

    love.mouse.setVisible(false)

    UI.buttons = {
        menu = {
            Button:new(function()
                gameState = 'shop - cold'
                Shop.load()
            end, 'Shop_Icon', 20, 20, 3),
            Button:new(function()
                gameState = 'play'
                for tempo = 1, Shop.numberOfCircles, 1 do
                    table.insert(Shop.circleList, Circle:new(Shop.circleRandomInitialPosition))
                end
            end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5)
        },

        play = {
            Button:new(function() end, 'MaxCoin_Icon', 10, 10, 5),
            Button:new(function() end, 'Coin_Icon', 10, 100, 5),
            Button:new(function() gameState = 'pause' end, 'Pause_Icon', Window.width - 32*3*Window.screenWidthScale - 20, 20, 3)
        },

        pause = {
            Button:new(function() end, 'MaxCoin_Icon', 10, 10, 5),
            Button:new(function() end, 'Coin_Icon', 10, 100, 5),
            Button:new(function() gameState = 'play' end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5),
            Button:new(function() gameState = 'play' end, 'Exit_Icon', Window.width - 32*3*Window.screenWidthScale - 20, 20, 6)
        },

        gameOver = {
            Button:new(function()
                gameState = 'shop - cold'
                Shop.load()
            end, 'Shop_Icon', 20, 20, 3),
            Button:new(function()
                gameState = 'play'
                for tempo = 1, Shop.numberOfCircles, 1 do
                    table.insert(Shop.circleList, Circle:new(Shop.circleRandomInitialPosition))
                end
            end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5)
        },

        shop = {},

        settings = { }
    }

    UI.backgrounds.shop:setFilter('nearest', 'nearest')
end

function UI.loadShop()
    UI.buttons.shop = {}
    UI.loadShopFixedButtons()
    for itemNumber, item in ipairs(Shop.getItems()) do
        local x = (128 + math.floor((itemNumber+1)/2)) * 12*Window.screenWidthScale
        local y = (9 + ((9 + 5) * itemNumber)) * 12*Window.screenHeightScale
        table.insert(UI.buttons.shop, Button:new(item:upgrade(), 'Plus_Icon', x, y, 12))
    end
end

function UI.loadShopFixedButtons()
    table.insert(UI.buttons.shop, Button:new(function() gameState = 'menu' end, 'Exit_Icon', Window.width - 32*3*Window.screenWidthScale - 50, 30, 6))
    table.insert(UI.buttons.shop, Button:new(function()
        gameState = 'shop - cold'
        UI.loadShop()
    end, 'Shop_Cold_Icon', 0, 21 * 12*Window.screenHeightScale, 12))
    table.insert(UI.buttons.shop, Button:new(function()
        gameState = 'shop - hot'
        UI.loadShop()
    end, 'Shop_Hot_Icon', 0, 56 * 12*Window.screenHeightScale, 12))
end

function UI.getList()
    local list
    if gameState == 'menu' then
        list = UI.buttons.menu
    elseif gameState == 'play' then
        list = UI.buttons.play
    elseif gameState == 'pause' then
        list = UI.buttons.pause
    elseif gameState == 'game over' then
        list = UI.buttons.gameOver
    elseif gameState == 'settings' then
        list = UI.buttons.settings
    elseif gameState == 'shop - cold' or gameState == 'shop - hot' then
        list = UI.buttons.shop
    end
    return list
end

function UI.drawButtons()
    for tempo, button in ipairs( UI.getList() ) do
        love.graphics.draw(button.sprite, button.x, button.y, 0, button.scale, button.scale)
    end
end

function UI.drawTexts()
    if gameState == 'play' then
        if math.ceil(countdown) > 0 then
            love.graphics.print(math.ceil(countdown), Window.width/2 - 6*7*Window.screenWidthScale, Window.height/2 - 6*7*Window.screenHeightScale, 0, 7*Window.screenWidthScale, 7*Window.screenHeightScale)
        end
        love.graphics.print(Shop.totalMoney, 110, 20, 0, 5*Window.screenWidthScale, 5*Window.screenHeightScale)
        love.graphics.print(Shop.money, 110, 110, 0, 5*Window.screenWidthScale, 5*Window.screenHeightScale)

    elseif gameState == 'game over' then
        love.graphics.print("Game Over", Window.width/2 - 36*7*Window.screenWidthScale, Window.height/2 - 12*7*Window.screenHeightScale - 100, 0, 7*Window.screenWidthScale, 7*Window.screenHeightScale)

    elseif gameState == 'shop - cold' or gameState == 'shop - hot' then
        love.graphics.print(Shop.totalMoney, 105 * 12*Window.screenWidthScale, 3 * 12*Window.screenHeightScale, 0, 8*Window.screenWidthScale, 8*Window.screenHeightScale)

        for itemNumber, item in ipairs(Shop.getItems()) do
            local x, y
            x = 22 * 12*Window.screenWidthScale
            y = (9 + ((9 + 5) * itemNumber)) * 12*Window.screenHeightScale
            love.graphics.print(item.text, x, y, 0, 4*Window.screenWidthScale, 4*Window.screenHeightScale)

            if item.price < 100 then
                x = (106 + math.floor((itemNumber+1)/2)) * 12*Window.screenWidthScale
            else
                x = (103 + math.floor((itemNumber+1)/2)) * 12*Window.screenWidthScale
            end
            y = (10 + ((9 + 5) * itemNumber)) * 12*Window.screenHeightScale
            if item.level == item.maxLevel then
                love.graphics.print('-', x, y, 0, 8*Window.screenWidthScale, 8*Window.screenHeightScale)
            else
                love.graphics.print(item.price, x, y, 0, 8*Window.screenWidthScale, 8*Window.screenHeightScale)
            end
        end
    end
end

function UI.drawBackgrounds()
    -- Set color according to the temperature
    local red, green, blue
    red = 255
    green = 255
    blue = 255
    if Shop.temperature < 0 then
        red = red - (-Shop.temperature) * 25
        green = green - (-Shop.temperature) * 10
    elseif Shop.temperature > 0 then
        green = green - Shop.temperature * 20
        blue = green - 20
    end
    love.graphics.setColor(red/255, green/255, blue/255)

    love.graphics.setBackgroundColor(0/255, 11/255, 13/255)

    if gameState == 'shop - cold' or gameState == 'shop - hot' then
        love.graphics.draw(UI.backgrounds.shop, 0, 0, 0, Window.width/160, Window.height/90)
    end
end

return UI