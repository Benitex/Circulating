------------------
-- Sounds Class --
------------------

local Settings = require 'Settings'

local Sounds = {
    BGM = love.audio, defeatSE = love.audio.newSource('audio/Defeat.mp3', 'stream')
}

function Sounds.load()
    love.audio.setVolume(Settings.volume)
    Sounds.BGM:setLooping(true)
end

function Sounds.play()
    if Sounds.mute == false then
        if gameState == 'play' then
            if countdown < 0 then
                Sounds.BGM:play()
            end
        elseif gameState == 'menu' or gameState == 'shop' then
            Sounds.BGM:play()
        else
            Sounds.BGM:stop()
        end
    end
end

return Sounds