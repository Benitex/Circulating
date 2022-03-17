-----------------
-- Circulating --
-----------------

-- Classes
local File = require 'src/File'
local Sounds = require 'src/Sounds'
local UI = require 'src/ui/UI'
local Mouse = require 'src/Mouse'
local Circle = require 'src/Circle'
Shop = require 'src/shop/Shop'

function love.load()
    gameState = 'menu'
    countdown = 3

    -- Get the OS
    playingOnMobile = false
    if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
        playingOnMobile = true
    end

    File.load()
    Shop.setTemperature()
    UI.load()
end

function love.draw()
    UI.drawBackgrounds()
    if gameState == 'play' then
        if countdown < 0 then
            for tempo, coin in ipairs(Shop.coinsList) do
                love.graphics.draw(coin.sprite, coin.x, coin.y, 0, coin.scale, coin.scale)
            end
            for tempo, circle in ipairs(Shop.circleList) do
                love.graphics.circle('fill', circle.x, circle.y, circle.size)
            end
        end
    end
    UI.drawButtons()
    UI.drawTexts()
    Mouse.draw()
end

function love.update(dt)
    Mouse.update()
    Sounds.play()
    if gameState == 'play' then
        countdown = countdown - dt
        if countdown < 0 then
            Shop.receiveMoney(dt)
            Shop.spawnCoins(dt)
            for tempo, circle in ipairs(Shop.circleList) do
                circle:move(dt)
                if circle:touchedByMouse() then
                    Shop.circleList = {}
                    Shop.coinsList = {}
                    Sounds.defeatSE:play()
                    gameState = 'game over'
                    Mouse.load()
                    Shop.money = 0
                    countdown = 3
                    File.save()
                end
            end
        end
    end
end

function startGame()
    gameState = 'play'
    for tempo = 1, Shop.numberOfCircles, 1 do
        table.insert(Shop.circleList, Circle:new(Shop.circleRandomInitialPosition))
    end
    Mouse.load()
end

function togglePause()
    if gameState == 'play' then
        gameState = 'pause'
    elseif gameState == 'pause' then
        gameState = 'play'
    end
    Mouse.load()
end

-- Desktop controls

function love.mousepressed(x, y)
    -- Buttons
    for tempo, button in ipairs(UI.getList()) do
        button:clicked(x, y)
    end

    -- Coins
    if not Shop.coinsPickedOnHover then
        for coinNumber, coin in ipairs(Shop.coinsList) do
            if coin:clicked() then
                table.remove(Shop.coinsList, coinNumber)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' or key == 'space' then
        if gameState == 'play' or gameState == 'pause' then
            togglePause()
        else
            File.save()
            love.event.quit()
        end
    end
end

-- Touchscreen controls

function love.touchpressed(id, x, y)
    -- Buttons
    for tempo, button in ipairs(UI.getList()) do
        button:clicked(x, y)
    end
end

function love.touchmoved(id, x, y)
    if playingOnMobile then
        Mouse.x = x
        Mouse.y = y
    end
end

function love.touchreleased()
    if playingOnMobile then
        if countdown < 0 then
            if gameState == 'play' or gameState == 'pause' then
                togglePause()
            end
        end
    end
end