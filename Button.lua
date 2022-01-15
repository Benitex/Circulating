------------------
-- Button class --
------------------

local Button = {
    x = 0, y = 0, height = 32, width = 32,
    sprite = love.image, scale = 3, code = nil
}
Button.__index = Button

function Button:new(code, type, x, y, scale)
    self = setmetatable({}, self)

    self.code = code
    self.x = x
    self.y = y
    self.type = type
    if scale ~= nil then
        self.scale = scale
    end
    if self.type == 'Coin_Icon' or self.type == 'MaxCoin_Icon' then
        self.width = 16
        self.height = 16
    end
    self.width = self.width * scale
    self.height = self.height * scale
    self.sprite = love.graphics.newImage('graphics/icons/'..type..'.png')
    self.sprite:setFilter('nearest', 'nearest')

    return self
end

function Button:clicked(x, y)
    if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height then
        self.code()
    end
end

return Button