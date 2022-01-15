-----------------
-- UI elements --
-----------------

Button = require 'Button'

local UI = {}
UI.menu = {}
UI.play = {}
UI.pause = {}
UI.gameOver = {}
UI.settings = {}
UI.shop = {}

function UI.loadButtons()
    -- menu
    table.insert(UI.menu, Button:new(function() gameState = 'play' end, 'Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5))

    -- play
    table.insert(UI.play, Button:new(function() end, 'MaxCoin_Icon', 10, 10, 5))
    table.insert(UI.play, Button:new(function() end, 'Coin_Icon', 10, 100, 5))
    table.insert(UI.play, Button:new(function() gameState = 'pause' end, 'Pause_Icon', love.graphics.getWidth() - 32*5 - 20, 20, 3))

    -- pause
    table.insert(UI.pause, Button:new(function() gameState = 'play' end, 'Play_Icon', love.graphics.getWidth() - 32*5 - 20, 20, 3))

    -- game over
    table.insert(UI.gameOver, Button:new(function() end, 'Shop_Icon', 20, 20, 3))
    table.insert(UI.gameOver, Button:new(function() gameState = 'play' end, 'Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5))

    -- settings

    -- shop
    --[[
        Colder

        number of coins on screen at the same time
        coins size
        coins value
        coins spawn time

        Hotter

        cursor size
        random mouse position
        number of balls
    --]]
end

function UI.getList()
    local list
    if gameState == 'menu' then
        list = UI.menu
    elseif gameState == 'play' then
        list = UI.play
    elseif gameState == 'pause' then
        list = UI.pause
    elseif gameState == 'game over' then
        list = UI.gameOver
    elseif gameState == 'settings' then
        list = UI.shop
    elseif gameState == 'shop' then
        list = UI.shop
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
        love.graphics.print(Shop.totalCoins, 110, 20, 0, 5, 5)
        love.graphics.print(Shop.coins, 110, 110, 0, 5, 5)

    elseif gameState == 'game over' then
        love.graphics.print("Game Over", love.graphics.getWidth()/2 - 36*7, love.graphics.getHeight()/2 - 12*7 - 100, 0, 7, 7)

    end
end

return UI