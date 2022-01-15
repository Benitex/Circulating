function love.load()
    -- Classes
    UI = require 'UI'
    Ball = require 'Ball'
    Shop = require 'Shop'

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
    love.window.setFullscreen(true) -- Will be moved to the settings screen

    UI.loadButtons()
    ball = Ball:new()
end

function love.draw()
    love.graphics.setBackgroundColor(0/255, 11/255, 13/255)
    if gameState == 'play' then
        love.graphics.circle('fill', ball.x, ball.y, ball.size)
    end
    UI.drawButtons()
    UI.showTexts()
end

function love.update(dt)
    if gameState == 'play' then
        music:play()
        Shop.receiveCoins(dt)
        ball:move(dt)

        if ( ball.x < love.mouse.getX() and ball.x + ball.size > love.mouse.getX() ) and ( ball.y < love.mouse.getY() and ball.y + ball.size > love.mouse.getY() ) then
            gameState = 'game over'
            music:stop()
            defeatSE:play()
            ball.x = love.graphics.getWidth()/2
            ball.y = love.graphics.getHeight()/2
            ball.speed = 7*30
            ball.size = 15
            Shop.coins = 0
        end

    elseif gameState == 'pause' then
        music:stop()

    elseif gameState == 'shop' then
        music:play()

    end
end

function love.keypressed(key)
    if key == 'space' then
        if gameState == 'play' then
            gameState = 'pause'
        else
            gameState = 'play'
        end
    end

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y)
    -- Button inputs
    for buttonNumber, button in ipairs(UI.getList()) do
        button:clicked(x, y)
    end
end