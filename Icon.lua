----------------
-- Icon class --
----------------

Icon = {}

function Icon.new(type)
    local sprite = love.graphics.newImage('graphics/icons/'..type..'.png')
    sprite:setFilter('nearest', 'nearest')
    return sprite
end

return Icon