--------------
-- UI Class --
--------------

local Button = require 'src/ui/Button'
local Circle = require 'src/Circle'

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
                UI.loadShopButtons()
            end, 'Shop_Icon', 20, 20, 3),
            Button:new(function()
                gameState = 'play'
                for tempo = 1, Shop.numberOfCircles, 1 do
                    table.insert(Shop.circleList, Circle:new(Shop.circleRandomInitialPosition))
                end
            end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5)
        },

        play = {
            Button:new(function() end, 'MaxCoin_Icon', 10 * Window.screenWidthScale, 10 * Window.screenHeightScale, 5),
            Button:new(function() end, 'Coin_Icon', 10 * Window.screenWidthScale, 100 * Window.screenHeightScale, 5),
            Button:new(function() gameState = 'pause' end, 'Pause_Icon', Window.width - 32*3*Window.screenWidthScale - 20, 20, 3)
        },

        pause = {
            Button:new(function() end, 'MaxCoin_Icon', 10 * Window.screenWidthScale, 10 * Window.screenHeightScale, 5),
            Button:new(function() end, 'Coin_Icon', 10 * Window.screenWidthScale, 100 * Window.screenHeightScale, 5),
            Button:new(function() gameState = 'play' end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5),
            Button:new(function() gameState = 'play' end, 'Exit_Icon', Window.width - 32*3*Window.screenWidthScale - 20, 20, 6)
        },

        gameOver = {
            Button:new(function()
                gameState = 'shop - cold'
                UI.loadShopButtons()
            end, 'Shop_Icon', 20 * Window.screenWidthScale, 20 * Window.screenHeightScale, 3),
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

    if playingOnMobile then
        Shop.coinsPickedOnHover = true
    else
        table.insert(UI.buttons.menu, Button:new(function()
            File.save()
            love.event.quit()
        end, 'Exit_Icon', Window.width - 32*Window.screenHeightScale * 3*Window.screenWidthScale - 50, 30*Window.screenHeightScale, 6))
    end

    UI.backgrounds.shop:setFilter('nearest', 'nearest')
end

function UI.loadShopButtons()
    -- First shop load
    if #Shop.itemsList == 0 then
        table.insert(Shop.itemsList, ShopItem:new('coinsSpawnTime', 1))
        table.insert(Shop.itemsList, ShopItem:new('circleInitialPosition', 1))
    end

    -- Fixed buttons
    UI.buttons.shop = {
        Button:new(function() gameState = 'menu' end, 'Exit_Icon', Window.width - 32*Window.screenHeightScale * 3*Window.screenWidthScale - 50, 30*Window.screenHeightScale, 6),
        Button:new(function()
            gameState = 'shop - cold'
            UI.loadShopButtons()
        end, 'Shop_Cold_Icon', 0, 21 * 12*Window.screenHeightScale, 12),
        Button:new(function()
            gameState = 'shop - hot'
            UI.loadShopButtons()
        end, 'Shop_Hot_Icon', 0, 56 * 12*Window.screenHeightScale, 12)
    }

    -- Shop dependent buttons
    for itemNumber, item in ipairs(Shop.getItems()) do
        local x = (128 + math.floor((itemNumber+1)/2)) * 12*Window.screenWidthScale
        local y = (9 + ((9 + 5) * itemNumber)) * 12*Window.screenHeightScale
        table.insert(UI.buttons.shop, Button:new(item:upgrade(), 'Plus_Icon', x, y, 12))
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
    local wc = Window.screenWidthScale
    local hc = Window.screenHeightScale

    if gameState == 'play' then
        if math.ceil(countdown) > 0 then
            love.graphics.print(math.ceil(countdown), Window.width/2 - 6*7*wc, Window.height/2 - 6*7*hc, 0, 7*wc, 7*hc)
        end
        love.graphics.print(Shop.totalMoney, 110*wc, 20*hc, 0, 5*wc, 5*hc)
        love.graphics.print(Shop.money, 110*wc, 110*hc, 0, 5*wc, 5*hc)

    elseif gameState == 'game over' then
        love.graphics.print("Game Over", Window.width/2 - 36*7*wc, Window.height/2 - 12*7*hc - 100*hc, 0, 7*wc, 7*hc)

    elseif gameState == 'shop - cold' or gameState == 'shop - hot' then
        if gameState == 'shop - cold' then
            love.graphics.print("Cold Shop", 3 * 12*wc, 3 * 12*hc, 0, 8*wc, 8*hc)
        elseif gameState == 'shop - hot' then
            love.graphics.print("Hot Shop", 3 * 12*wc, 3 * 12*hc, 0, 8*wc, 8*hc)
        end
        love.graphics.print(Shop.totalMoney, 94 * 12*wc, 3 * 12*hc, 0, 8*wc, 8*hc)

        for itemNumber, item in ipairs(Shop.getItems()) do
            local x, y
            x = 22 * 12*wc
            y = (9 + ((9 + 5) * itemNumber)) * 12*hc
            love.graphics.print(item.text, x, y, 0, 4*wc, 4*hc)

            if item.price < 100 then
                x = (106 + math.floor((itemNumber+1)/2)) * 12*wc
            else
                x = (103 + math.floor((itemNumber+1)/2)) * 12*wc
            end
            y = (10 + ((9 + 5) * itemNumber)) * 12*hc
            if item.level == item.maxLevel then
                love.graphics.print('-', x, y, 0, 8*wc, 8*hc)
            else
                love.graphics.print(item.price, x, y, 0, 8*wc, 8*hc)
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