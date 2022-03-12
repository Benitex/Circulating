--------------
-- UI Class --
--------------

local Button = require 'src/ui/Button'
local Ball = require 'src/Ball'
local Window = require 'src/ui/Window'

local UI = {
    backgrounds = {
        shop = love.graphics.newImage('graphics/ui/ShopUI.png')
    }
}

function UI.load()
    Window.load()

    love.mouse.setVisible(false)
    -- Buttons and icons
    UI.buttons = {
        menu = {
            Button:new(function() Shop.load() end, 'Shop_Icon', 20, 20, 3),
            Button:new(function()
                gameState = 'play'
                for tempo = 1, Shop.numberOfBalls, 1 do
                    table.insert(Shop.ballList, Ball:new(Shop.ballRandomInitialPosition))
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
            Button:new(function() gameState = 'play' end, 'Exit_Icon', Window.width - 32*3*Window.screenWidthScale - 20, 20, 3)
        },

        gameOver = {
            Button:new(function() Shop.load() end, 'Shop_Icon', 20, 20, 3),
            Button:new(function()
                gameState = 'play'
                for tempo = 1, Shop.numberOfBalls, 1 do
                    table.insert(Shop.ballList, Ball:new(Shop.ballRandomInitialPosition))
                end
            end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5)
        },

        shop = {
            Button:new(function() gameState = 'menu' end, 'Exit_Icon', Window.width - 32*3*Window.screenWidthScale - 50, 30, 3),
        },

        settings = { }
    }

    UI.backgrounds.shop:setFilter('nearest', 'nearest')
end

function UI.loadShopButtons()
    for elementNumber, shopElement in ipairs(Shop.elementsList) do
        local x = (128 + math.floor((elementNumber+1)/2)) * 12*Window.screenWidthScale
        local y = (9 + ((9 + 5) * elementNumber)) * 12*Window.screenHeightScale
        table.insert(UI.buttons.shop, Button:new(shopElement:upgrade(), 'Plus_Icon', x, y, 12))
    end
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
    elseif gameState == 'shop' then
        list = UI.buttons.shop
    end
    return list
end

function UI.drawButtons()
    local list = UI.getList()
    for tempo, button in ipairs(list) do
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

    elseif gameState == 'shop' then
        for elementNumber, element in ipairs(Shop.elementsList) do
            local x, y
            x = 21 * 12*Window.screenHeightScale
            y = (9 + ((9 + 5) * elementNumber)) * 12*Window.screenHeightScale
            love.graphics.print(element.text, x, y, 0, 4*Window.screenWidthScale, 4*Window.screenHeightScale)

            if element.price < 100 then
                x = (106 + math.floor((elementNumber+1)/2)) * 12*Window.screenWidthScale
            else
                x = (103 + math.floor((elementNumber+1)/2)) * 12*Window.screenWidthScale
            end
            y = (10 + ((9 + 5) * elementNumber)) * 12*Window.screenHeightScale
            love.graphics.print(element.price, x, y, 0, 8*Window.screenWidthScale, 8*Window.screenHeightScale)
        end
    end
end

function UI.drawBackgrounds()
    if Shop.temperature > 0 then
        love.graphics.setColor(1, 1 - (0.3 * Shop.temperature), 0)
    elseif Shop.temperature < 0 then
        love.graphics.setColor(0, 1 - (0.1 * -Shop.temperature), 1)
    else
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.setBackgroundColor(0/255, 11/255, 13/255)

    if gameState == 'shop' then
        love.graphics.draw(UI.backgrounds.shop, 0, 0, 0, Window.width/160, Window.height/90)
    end
end

return UI