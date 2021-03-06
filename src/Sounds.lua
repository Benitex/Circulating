------------------
-- Sounds Class --
------------------

local Settings = require 'src/Settings'

local Sounds = {
    BGM = love.audio, defeatSE = love.audio.newSource('audio/Defeat.mp3', 'stream')
}

function Sounds.load()
    love.audio.setVolume(Settings.volume)
    --Sounds.BGM:setLooping(true) -- no BGM yet
end

function Sounds.play()
    if Sounds.mute == false then
        if gameState == 'play' then
            if countdown < 0 then
                Sounds.BGM:play()
            end
        elseif gameState == 'menu' or gameState == 'shop - cold' or gameState == 'shop - hot' then
            Sounds.BGM:play()
        else
            Sounds.BGM:stop()
        end
    end
end

return Sounds