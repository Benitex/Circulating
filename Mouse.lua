local Mouse = {}
Mouse.sprites = {}
Mouse.sprites.player = love.graphics.newImage('graphics/mouse/Player.png')
Mouse.sprites.menus = love.graphics.newImage('graphics/mouse/Mouse.png')
Mouse.x = 0
Mouse.y = 0
Mouse.size = 16
Mouse.scale = 1

function Mouse.draw()
    if gameState == 'play' then
        love.graphics.draw(Mouse.sprites.player, Mouse.x - Mouse.size*Mouse.scale/2, Mouse.y - Mouse.size*Mouse.scale/2, 0, Mouse.scale, Mouse.scale)
    else
        if not playingOnMobile then
            love.graphics.draw(Mouse.sprites.menus, Mouse.x, Mouse.y, 0, Mouse.scale, Mouse.scale)
        end
    end
end

function Mouse.update()
    if not playingOnMobile then
        Mouse.x = love.mouse.getX()
        Mouse.y = love.mouse.getY()
    end
end

return Mouse