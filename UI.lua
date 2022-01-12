-----------------
-- UI elements --
-----------------

Button = require 'Button'

local UI = {}
UI.menu = {}
UI.play = {}
UI.pause = {}
UI.gameOver = {}
UI.shop = {}

function UI.loadButtons()
    -- menu
    table.insert(UI.menu, Button:new('Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5))

    -- play
    table.insert(UI.play, Button:new('MaxCoin_Icon', 10, 10, 5))
    table.insert(UI.play, Button:new('Coin_Icon', 10, 100, 5))
    table.insert(UI.play, Button:new('MaxCoin_Icon', 10, 10, 5))
    table.insert(UI.play, Button:new('Pause_Icon', love.graphics.getWidth() - 32*5 - 20, 20, 3))

    -- pause
    table.insert(UI.pause, Button:new('Play_Icon', love.graphics.getWidth() - 32*5 - 20, 20, 3))
    table.insert(UI.pause, Button:new('Play_Icon', love.graphics.getWidth() - 32*5 - 20, 20, 3))

    -- game over
    table.insert(UI.gameOver, Button:new('Shop_Icon', 20, 20, 3))
    table.insert(UI.gameOver, Button:new('Play_Icon', love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 5))

    -- shop

end

function UI.drawButtons()
    local list
    if gameState == 'menu' then
        list = UI.menu
    elseif gameState == 'play' then
        list = UI.play
    elseif gameState == 'pause' then
        list = UI.pause
    elseif gameState == 'game over' then
        list = UI.gameOver
    elseif gameState == 'shop' then
        list = UI.shop
    end
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