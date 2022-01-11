function love.load()
    love.window.setFullscreen(true)

    font = love.graphics.newFont('font/pixelart.ttf')
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    music = love.audio.newSource('audio/Circulating.mp3', 'stream')
    music:setLooping(true)
    defeatSE = love.audio.newSource('audio/Defeat.mp3', 'stream')
    defeatSE:setLooping(false)

    tempo = 0
    gameState = 'menu'

    shopIcon = love.graphics.newImage('graphics/icons/Shop_Icon.png')
    pauseIcon = love.graphics.newImage('graphics/icons/Pause_Icon.png')
    playIcon = love.graphics.newImage('graphics/icons/Play_Icon.png')
    shopIcon:setFilter('nearest', 'nearest')
    pauseIcon:setFilter('nearest', 'nearest')
    playIcon:setFilter('nearest', 'nearest')

    accesibleShop = true

    coins = 0
    totalCoins = 0

    Ball = {}
    Ball.x = love.graphics.getWidth()/2
    Ball.y = love.graphics.getHeight()/2
    Ball.speed = 7*30
    Ball.size = 15
end

function love.draw()
    if gameState == 'menu' then
        love.graphics.draw(playIcon, love.graphics.getWidth()/2 - 16*5, love.graphics.getHeight()/2 - 16*5, 0, 5, 5)
    elseif gameState == 'play' then
        love.graphics.circle('fill', Ball.x, Ball.y, Ball.size)
        love.graphics.print('Total coins\t' .. totalCoins, 10, 10, 0, 5, 5)
        love.graphics.print('Current coins\t' .. coins, 10, 80, 0, 5, 5)
        love.graphics.draw(pauseIcon, love.graphics.getWidth() - 32*5 - 20, 20, 0, 3, 3)
    elseif gameState == 'pause' then
        love.graphics.print("Game Over", love.graphics.getWidth()/2 - 36*7, love.graphics.getHeight()/2 - 12*7, 0, 7, 7)
        love.graphics.draw(playIcon, love.graphics.getWidth() - 32*5 - 20, 20, 0, 3, 3)
        if accesibleShop then
            love.graphics.draw(shopIcon, 20, 20, 0, 3, 3)
        end
    end
end

function love.update(dt)
    if gameState == 'play' then
        if love.mouse.getX() > Ball.x then
            Ball.x = Ball.x + Ball.speed * dt
        elseif love.mouse.getX() < Ball.x then
            Ball.x = Ball.x - Ball.speed * dt
        end
        if love.mouse.getY() > Ball.y then
            Ball.y = Ball.y + Ball.speed * dt
        elseif love.mouse.getY() < Ball.y then
            Ball.y = Ball.y - Ball.speed * dt
        end

        Ball.speed = Ball.speed + dt*30
        Ball.size = Ball.size + dt*5

        if ( Ball.x < love.mouse.getX() and Ball.x + Ball.size > love.mouse.getX() ) and ( Ball.y < love.mouse.getY() and Ball.y + Ball.size > love.mouse.getY() ) then
            gameState = 'pause'
            defeatSE:play()
            Ball.x = love.graphics.getWidth()/2
            Ball.y = love.graphics.getHeight()/2
            Ball.speed = 7*30
            Ball.size = 15
            coins = 0
            accesibleShop = true
        end

        tempo = tempo + dt
        if tempo >= 1 then
            coins = coins + 1
            totalCoins = totalCoins + 1
            tempo = 0
        end

        music:play()
    elseif gameState == 'pause' then
        music:stop()
    elseif gameState == 'shop' then
        music:play()
    end
end

function love.keypressed(key)
    if key == 'space' then
        if gameState == 'play' then
            accesibleShop = false
            gameState = 'pause'
        else
            gameState = 'play'
        end
    end
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if gameState == 'menu' then
        if x >= love.graphics.getWidth()/2 - 16*5 and x <= love.graphics.getWidth()/2 + 16*5 and y >= love.graphics.getHeight()/2 - 16*5 and y <= love.graphics.getHeight() + 16*5 then
            accesibleShop = false
            gameState = 'play'
        end
    elseif gameState == 'pause' then
        if x >= love.graphics.getWidth() - 20  then
            
        end
    end
end