local Sounds = {}
Sounds.mute = false
Sounds.BGM = love.audio.newSource('audio/Circulating.mp3', 'stream')
Sounds.defeatSE = love.audio.newSource('audio/Defeat.mp3', 'stream')

function Sounds.load()
    Sounds.BGM:setLooping(false)
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