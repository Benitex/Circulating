function love.load()
    -- Classes
    Ball = require 'Ball'
    Shop = require 'Shop'
    Icon = require 'Icon'

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

    ball = Ball:new()
end

function love.draw()
    if gameState == 'menu' then
        love.graphics.draw(Icon.new('Play_Icon'), love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 0, 5, 5)

    elseif gameState == 'play' then
        love.graphics.circle('fill', ball.x, ball.y, ball.size)
        love.graphics.print('Total coins\t' .. Shop.totalCoins, 10, 10, 0, 5, 5)
        love.graphics.print('Current coins\t' .. Shop.coins, 10, 80, 0, 5, 5)
        love.graphics.draw(Icon.new('Pause_Icon'), love.graphics.getWidth() - 32*5 - 20, 20, 0, 3, 3)

    elseif gameState == 'pause' then
        love.graphics.print("Game Over", love.graphics.getWidth()/2 - 36*7, love.graphics.getHeight()/2 - 12*7, 0, 7, 7)
        love.graphics.draw(Icon.new('Play_Icon'), love.graphics.getWidth() - 32*5 - 20, 20, 0, 3, 3)
        if Shop.accessible then
            love.graphics.draw(Icon.new('Shop_Icon'), 20, 20, 0, 3, 3)
        end

    end
end

function love.update(dt)
    if gameState == 'play' then
        music:play()
        Shop.receiveCoins(dt)
        ball:move(dt)

        if ( ball.x < love.mouse.getX() and ball.x + ball.size > love.mouse.getX() ) and ( ball.y < love.mouse.getY() and ball.y + ball.size > love.mouse.getY() ) then
            gameState = 'pause'
            defeatSE:play()
            ball.x = love.graphics.getWidth()/2
            ball.y = love.graphics.getHeight()/2
            ball.speed = 7*30
            ball.size = 15
            Shop.coins = 0
            Shop.accessible = true
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
            Shop.accessible = false
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
    if gameState == 'menu' then
        if x >= love.graphics.getWidth()/2 - 16*5 and x <= love.graphics.getWidth()/2 + 16*5 and y >= love.graphics.getHeight()/2 - 16*5 and y <= love.graphics.getHeight() + 16*5 then
            Shop.accessible = false
            gameState = 'play'
        end

    --elseif gameState == 'pause' then
        --if x >= love.graphics.getWidth() - 20  then
            
        --end

    end
end