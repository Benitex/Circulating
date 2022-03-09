-----------------
-- UI elements --
-----------------

local Button = require 'Button'
local Ball = require 'Ball'

local UI = {
    backgrounds = {
        shop = love.graphics.newImage('graphics/ui/ShopUI.png')
    }
}

function UI.load()
    -- Buttons and icons
    UI.buttons = {
        menu = {
            Button:new(function() gameState = 'shop' end, 'Shop_Icon', 20, 20, 3),
            Button:new(function()
                gameState = 'play'
                for tempo = 1, Shop.numberOfBalls, 1 do
                    table.insert(Shop.ballList, Ball:new(Shop.ballRandomInitialPosition))
                end
            end, 'Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5)
        },

        play = {
            Button:new(function() end, 'MaxCoin_Icon', 10, 10, 5),
            Button:new(function() end, 'Coin_Icon', 10, 100, 5),
            Button:new(function() gameState = 'pause' end, 'Pause_Icon', love.graphics.getWidth() - 32*3 - 20, 20, 3)
        },

        pause = {
            Button:new(function() end, 'MaxCoin_Icon', 10, 10, 5),
            Button:new(function() end, 'Coin_Icon', 10, 100, 5),
            Button:new(function() gameState = 'play' end, 'Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5),
            Button:new(function() gameState = 'play' end, 'Exit_Icon', love.graphics.getWidth() - 32*3 - 20, 20, 3)
        },

        gameOver = {
            Button:new(function() gameState = 'shop' end, 'Shop_Icon', 20, 20, 3),
            Button:new(function()
                gameState = 'play'
                for tempo = 1, Shop.numberOfBalls, 1 do
                    table.insert(Shop.ballList, Ball:new(Shop.ballRandomInitialPosition))
                end
            end, 'Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5)
        },

        shop = {
            Button:new(function() gameState = 'menu' end, 'Exit_Icon', love.graphics.getWidth() - 32*3 - 50, 30, 3),
        },

        settings = { }
    }

    -- Shop elements
    for elementNumber, shopElement in ipairs(Shop.elementsList) do
        table.insert(UI.buttons.shop, Button:new(shopElement:upgrade(), 'Plus_Icon', (127 + math.floor(1 + 1 * (elementNumber+1)/2)) * 12 , (9 + ((9 + 5) * elementNumber)) * 12, 12))
    end

    UI.backgrounds.shop:setFilter('nearest', 'nearest')
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
        list = UI.buttons.shop
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

function UI.showTexts()
    if gameState == 'play' then
        if math.ceil(countdown) > 0 then
            love.graphics.print(math.ceil(countdown), love.graphics.getWidth()/2 - 6*7, love.graphics.getHeight()/2 - 6*7, 0, 7, 7)
        end
        love.graphics.print(Shop.totalMoney, 110, 20, 0, 5, 5)
        love.graphics.print(Shop.money, 110, 110, 0, 5, 5)

    elseif gameState == 'game over' then
        love.graphics.print("Game Over", love.graphics.getWidth()/2 - 36*7, love.graphics.getHeight()/2 - 12*7 - 100, 0, 7, 7)

    elseif gameState == 'shop' then
        
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
        love.graphics.draw(UI.backgrounds.shop, 0, 0, 0, love.graphics.getWidth()/160, love.graphics.getHeight()/90)
    end
end

return UI