local Mouse = {}
Mouse.sprites = {}
Mouse.sprites.player = love.graphics.newImage('graphics/mouse/Player.png')
Mouse.sprites.menus = love.graphics.newImage('graphics/mouse/Mouse.png')
Mouse.width = 32
Mouse.height = 32
Mouse.scale = 1

function Mouse.draw()
    if gameState == 'play' then
        love.graphics.draw(Mouse.sprites.player, love.mouse.getX() - Mouse.width*Mouse.scale/2, love.mouse.getY() - Mouse.height*Mouse.scale/2, 0, Mouse.scale, Mouse.scale)
    else
        love.graphics.draw(Mouse.sprites.menus, love.mouse.getX() - Mouse.width*Mouse.scale/2, love.mouse.getY() - Mouse.height*Mouse.scale/2, 0, Mouse.scale, Mouse.scale)
    end
end

return Mouse