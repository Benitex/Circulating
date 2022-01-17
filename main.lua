-----------
-- Daire --
-----------

-- Classes
local UI = require 'UI'
local Mouse = require "Mouse"
local Ball = require 'Ball'
Shop = require 'Shop'

function love.load()
    -- Font
    font = love.graphics.newFont('font/pixelart.ttf')
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    -- Music and Sound Effects
    music = love.audio.newSource('audio/Circulating.mp3', 'stream')
    music:setLooping(true)
    defeatSE = love.audio.newSource('audio/Defeat.mp3', 'stream')
    defeatSE:setLooping(false)

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
    if gameState == 'play' then
        countdown = countdown - dt
        if countdown < 0 then
            music:play()
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

    elseif gameState == 'pause' then
        music:stop()

    elseif gameState == 'shop' then
        music:play()
    end
end

function love.mousepressed(x, y)
    -- Buttons
    for buttonNumber, button in ipairs(UI.getList()) do
        button:clicked(x, y)
    end
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