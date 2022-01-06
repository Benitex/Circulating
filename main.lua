function love.load()
    love.window.setFullscreen(true)
    
    font = love.graphics.newFont('font/pixelart.ttf')
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    music = love.audio.newSource('audio/Circulating.mp3', 'stream')
    music:setLooping(true)

    tempo = 0
    gameMode = 'menu'
    
    coins = 0
    totalCoins = 0

    Ball = {}
    Ball.x = love.graphics.getWidth()/2
    Ball.y = love.graphics.getHeight()/2
    Ball.speed = 7*30
    Ball.size = 15
end

function love.draw()
    if gameMode == 'play' then
        love.graphics.print('Total coins   ' .. totalCoins, 10, 10, 0, 5, 5)
        love.graphics.print('Current coins   ' .. coins, 10, 80, 0, 5, 5)
        love.graphics.circle('fill', Ball.x, Ball.y, Ball.size)
    else
        love.graphics.print("Press space.", love.graphics.getWidth()/3 - 20, love.graphics.getHeight()/2 - 50, 0, 7, 7)
    end
end

function love.update(dt)
    if gameMode == 'play' then
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
            gameMode = 'menu'
            Ball.x = love.graphics.getWidth()/2
            Ball.y = love.graphics.getHeight()/2
        end

        tempo = tempo + dt
        if tempo >= 1 then
            coins = coins + 1
            totalCoins = totalCoins + 1
            tempo = 0
        end

        music:play()
    else
        music:stop()
    end
end

function love.keypressed(key)
    if key == 'space' then
        gameMode = 'play'
        coins = 0
    end
    if key == 'escape' then
        love.event.quit()
    end
end