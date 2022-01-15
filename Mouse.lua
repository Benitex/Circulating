local Mouse = {}
Mouse.sprite = love.graphics.newImage('graphics/Mouse.png')
Mouse.width = 32
Mouse.height = 32
Mouse.scale = 1

function Mouse.draw()
    love.graphics.draw(Mouse.sprite, love.mouse.getX() - Mouse.width*Mouse.scale/2, love.mouse.getY() - Mouse.height*Mouse.scale/2, 0, Mouse.scale, Mouse.scale)
end

return Mouse