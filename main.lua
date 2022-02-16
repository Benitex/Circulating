-----------
-- Daire --
-----------

-- Classes
local UI = require 'UI'
local Sounds = require 'Sounds'
local Mouse = require "Mouse"
Shop = require 'Shop'

function love.load()
    -- Font
    font = love.graphics.newFont('font/pixelart.ttf')
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    gameState = 'menu'
    countdown = 3
    love.mouse.setVisible(false)
    love.window.setFullscreen(true) -- Will be moved to the settings screen

    Shop.load()
    UI.load()
end

function love.draw()
    UI.drawBackgrounds()
    if gameState == 'play' then
        if countdown < 0 then
            for coinNumber, coin in ipairs(Shop.coinsList) do
                love.graphics.draw(coin.sprite, coin.x, coin.y, 0, coin.scale, coin.scale)
            end
            for ballNumber, ball in ipairs(Shop.ballList) do
                love.graphics.circle('fill', ball.x, ball.y, ball.size)
            end
        end
    end
    UI.drawButtons()
    UI.showTexts()
    Mouse.draw()
end

function love.update(dt)
    Sounds.play()
    if gameState == 'play' then
        countdown = countdown - dt
        if countdown < 0 then
            Shop.receiveCoins(dt)
            for tempo, ball in ipairs(Shop.ballList) do
                Shop.spawnCoins(dt)
                if Shop.coinsPickedOnHover then
                    for coinNumber, coin in ipairs(Shop.coinsList) do
                        if coin:clicked() then
                            table.remove(Shop.coinsList, coinNumber)
                        end
                    end
                end
                ball:move(dt)
                if ball:touchedByMouse() then
                    for ballNumber, ball in ipairs(Shop.ballList) do
                        table.remove(Shop.ballList, ballNumber)
                    end
                    Sounds.defeatSE:play()
                    Shop.money = 0
                    gameState = 'game over'
                    countdown = 3
                end
            end
        end
    end
end

function love.mousepressed(x, y)
    -- Buttons
    for buttonNumber, button in ipairs(UI.getList()) do
        button:clicked(x, y)
    end

    -- Coins
    if Shop.coinsPickedOnHover == false then
        for coinNumber, coin in ipairs(Shop.coinsList) do
            if coin:clicked() then
                table.remove(Shop.coinsList, coinNumber)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' or key == 'space' then
        if gameState == 'play' then
            gameState = 'pause'
        elseif gameState == 'pause' then
            gameState = 'pause'
        else
            love.event.quit()
        end
    end
end

function areCirclesTouching(x1, y1, size1, x2, y2, size2)
    local distance = math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
    return distance < size1 + size2
end