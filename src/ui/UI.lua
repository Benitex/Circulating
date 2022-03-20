--------------
-- UI Class --
--------------

local File = require 'src/File'
local Window = require 'src/ui/Window'
local Button = require 'src/ui/Button'
local Mouse = require 'src/Mouse'

local UI = {
    backgrounds = {
        shop = love.graphics.newImage('graphics/ui/ShopUI.png')
    },

    font = {
        sprites = love.graphics.newFont('graphics/font/circulating-font.ttf'),
        width = 4, height = 6
    }
}

function UI.load()
    Window.load()

    -- Set font
    local font = UI.font.sprites
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    love.mouse.setVisible(false)
    Mouse.sprites.menus:setFilter('nearest', 'nearest')
    Mouse.sprites.player:setFilter('nearest', 'nearest')
    UI.backgrounds.shop:setFilter('nearest', 'nearest')

    UI.buttons = {
        menu = {
            Button:new(function() startGame() end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5),
            Button:new(function()
                gameState = 'shop - cold'
                UI.loadShopButtons()
            end, 'Shop_Icon', 20, 20, 3)
        },

        play = {
            Button:new(function() end, 'MaxCoin_Icon', 10 * Window.screenWidthScale, 10 * Window.screenHeightScale, 5),
            Button:new(function() end, 'Coin_Icon', 10 * Window.screenWidthScale, 100 * Window.screenHeightScale, 5),
            Button:new(function() togglePause() end, 'Pause_Icon', Window.width - 32*3*Window.screenWidthScale - 20, 20, 3)
        },

        pause = {
            Button:new(function() end, 'MaxCoin_Icon', 10 * Window.screenWidthScale, 10 * Window.screenHeightScale, 5),
            Button:new(function() end, 'Coin_Icon', 10 * Window.screenWidthScale, 100 * Window.screenHeightScale, 5),
            Button:new(function() togglePause() end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5),
            Button:new(function() togglePause() end, 'Exit_Icon', Window.width - 32*3*Window.screenWidthScale - 20, 20, 6)
        },

        gameOver = {
            Button:new(function() startGame() end, 'Play_Icon', Window.width/2 - 16*5*Window.screenWidthScale, Window.height/2 - 16*5*Window.screenHeightScale, 5),
            Button:new(function()
                gameState = 'shop - cold'
                UI.loadShopButtons()
            end, 'Shop_Icon', 20 * Window.screenWidthScale, 20 * Window.screenHeightScale, 3)
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

function UI.print(text, x, y, scale)
    x = x * 12 * Window.screenWidthScale
    y = y * 12 * Window.screenHeightScale

    local widthScale = scale * Window.screenWidthScale
    local heightScale = scale * Window.screenHeightScale

    love.graphics.print(text, x, y, 0, widthScale, heightScale)
end

function UI.drawTexts()
    if gameState == 'menu' then
        UI.print("Highest Score: " .. Shop.highestScore, 80 - (UI.font.width * 15)/2, 1, 4)

    elseif gameState == 'play' or gameState == 'pause' then
        if math.ceil(countdown) > 0 then
            UI.print( math.ceil(countdown) , 80 - UI.font.width/2, 45 - UI.font.height, 5)
        end
        UI.print(Shop.totalMoney, 10, 1, 3)
        UI.print(Shop.money, 10, 8, 3)

    elseif gameState == 'game over' then
        UI.print("Game Over", 80 - (UI.font.width * 11)/2, 45 - 5 * UI.font.height, 5)
        UI.print("Highest Score: " .. Shop.highestScore, 80 - (UI.font.width * 15)/2, 45 - 3 * UI.font.height, 4)

    elseif gameState == 'shop - cold' or gameState == 'shop - hot' then
        if gameState == 'shop - cold' then
            UI.print("Cold Shop", 1, 1, 5)
        elseif gameState == 'shop - hot' then
            UI.print("Hot Shop", 1, 1, 5)
        end
        UI.print(Shop.totalMoney, 94, 1, 5)

        for itemNumber, item in ipairs(Shop.getItems()) do
            -- Item texts
            local y = 8 + ((9 + 5) * itemNumber)
            UI.print(item.text, 22, y, 2)

            -- Item prices
            local price, x
            if item.level == item.maxLevel then
                price = "-"
                x = 110
            else
                price = item.price
                if price < 100 then
                    x = 108 + math.floor((itemNumber+1)/2)
                else
                    x = 104 + math.floor((itemNumber+1)/2)
                end
            end
            UI.print(price, x, y, 5)
        end
    end
end

function UI.drawButtons()
    for tempo, button in ipairs( UI.getList() ) do
        love.graphics.draw(button.sprite, button.x, button.y, 0, button.scale, button.scale)
    end
end

function UI.loadShopButtons()
    -- First shop load
    Shop.addItem('coinsSpawnTime', 1)
    Shop.addItem('circleInitialPosition', 1)
    Shop.addItem('mouseSize', 1)
    Shop.addItem('circleSize', 1)
    Shop.addItem('circleSpeed', 1)

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

function UI.drawBackgrounds()
    -- Set color according to the temperature
    local red, green, blue = 255, 255, 255
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