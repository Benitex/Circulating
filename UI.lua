-----------------
-- UI elements --
-----------------

Button = require 'Button'

local UI = {}

UI.buttons = {}
UI.buttons.menu = {}
UI.buttons.play = {}
UI.buttons.pause = {}
UI.buttons.gameOver = {}
UI.buttons.settings = {}
UI.buttons.shop = {}

UI.backgrounds = {}
UI.backgrounds.shop = love.graphics.newImage('graphics/ui/ShopUI.png')

function UI.load()
    UI.backgrounds.shop:setFilter('nearest', 'nearest')

    -- menu
    table.insert(UI.buttons.menu, Button:new(function() gameState = 'shop' end, 'Shop_Icon', 20, 20, 3))
    table.insert(UI.buttons.menu, Button:new(function() gameState = 'play' end, 'Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5))

    -- play
    table.insert(UI.buttons.play, Button:new(function() end, 'MaxCoin_Icon', 10, 10, 5))
    table.insert(UI.buttons.play, Button:new(function() end, 'Coin_Icon', 10, 100, 5))
    table.insert(UI.buttons.play, Button:new(function() gameState = 'pause' end, 'Pause_Icon', love.graphics.getWidth() - 32*3 - 20, 20, 3))

    -- pause
    table.insert(UI.buttons.play, Button:new(function() end, 'MaxCoin_Icon', 10, 10, 5))
    table.insert(UI.buttons.play, Button:new(function() end, 'Coin_Icon', 10, 100, 5))
    table.insert(UI.buttons.pause, Button:new(function() gameState = 'play' end, 'Play_Icon', love.graphics.getWidth() - 32*3 - 20, 20, 3))

    -- game over
    table.insert(UI.buttons.gameOver, Button:new(function() gameState = 'shop' end, 'Shop_Icon', 20, 20, 3))
    table.insert(UI.buttons.gameOver, Button:new(function() gameState = 'play' end, 'Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5))

    -- settings

    -- shop
    table.insert(UI.buttons.shop, Button:new(function() gameState = 'game over' end, 'Exit_Icon', love.graphics.getWidth() - 32*3 - 50, 30, 3))
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