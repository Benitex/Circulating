------------------
-- Button class --
------------------

local Button = {
    x = 0, y = 0, height = 32, width = 32,
    sprite = love.image, scale = 3
}
Button.__index = Button

function Button:new(type, x, y, scale)
    self = setmetatable({}, self)

    self.x = x
    self.y = y
    if scale ~= nil then
        self.scale = scale
    end
    self.width = self.width * scale
    self.height = self.height * scale
    self.type = type
    if self.type == 'Coin_Icon' or self.type == 'MaxCoin_Icon' then
        self.width = 16
        self.height = 16
    end
    self.sprite = love.graphics.newImage('graphics/icons/'..type..'.png')
    self.sprite:setFilter('nearest', 'nearest')

    return self
end

return Button