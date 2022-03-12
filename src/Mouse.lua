-----------------
-- Mouse Class --
-----------------

local Mouse = {
    x = 0, y = 0, size = 16, scale = 1,

    sprites = {
        player = love.graphics.newImage('graphics/mouse/Player.png'),
        menus = love.graphics.newImage('graphics/mouse/Mouse.png')
    }
}

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

    if gameState == 'play' then
        if Shop.coinsPickedOnHover then
            for coinNumber, coin in ipairs(Shop.coinsList) do
                if coin:clicked() then
                    table.remove(Shop.coinsList, coinNumber)
                end
            end
        end
    end
end

return Mouse