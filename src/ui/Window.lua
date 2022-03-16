------------------
-- Window Class --
------------------

local Settings = require 'src/Settings'

local Window = {
    width = 160, height = 90, screenWidthScale = 1, screenHeightScale = 1
}

function Window.load()
    love.window.setFullscreen(Settings.fullscreen)

    Window.width = love.graphics.getWidth()
    Window.height = love.graphics.getHeight()

    Window.screenWidthScale = Window.width/1920 -- This is used to scale UI items according to the device screen
    Window.screenHeightScale = Window.height/1080
end

return Window