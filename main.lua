-----------
-- Daire --
-----------

-- Classes
local UI = require 'UI'
local Sounds = require 'Sounds'
local Mouse = require "Mouse"
local Ball = require 'Ball'
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

    UI.loadButtons()
    ballList = {}
    table.insert(ballList, Ball:new())
end

function love.draw()
    love.graphics.setBackgroundColor(0/255, 11/255, 13/255)
    if gameState == 'play' then
        if countdown < 0 then
            for index, coin in ipairs(Shop.coinsList) do
                love.graphics.draw(coin.sprite, coin.x, coin.y, 0, coin.scale, coin.scale)
            end
            for tempo, ball in ipairs(ballList) do
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
            for tempo, ball in ipairs(ballList) do
                Shop.spawnCoins(dt)
                if Shop.coinsPickedOnHover == true then
                    for coinNumber, coin in ipairs(Shop.coinsList) do
                        if coin:hovered(love.mouse.getX(), love.mouse.getY(), Mouse.width, Mouse.height) then
                            table.remove(Shop.coinsList, coinNumber)
                        end
                    end
                end
                ball:move(dt)
            end
        end

    elseif gameState == 'game over' then
        for tempo, ball in ipairs(ballList) do
            ball.x = love.graphics.getWidth()/2
            ball.y = love.graphics.getHeight()/2
            ball.speed = 7*30
            ball.size = 15
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
            if coin:clicked(x, y, Mouse.width, Mouse.height) then
                table.remove(Shop.coinsList, coinNumber)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end