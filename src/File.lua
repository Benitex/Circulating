---------------------
-- Save File class --
---------------------

local File = {}

function File.save()
    if love.filesystem.getInfo('save.sav') ~= nil then
        local moneyBackup = love.filesystem.read("save.sav")
        love.filesystem.write("save_backup.sav", moneyBackup)
    end

    love.filesystem.write("save.sav", Shop.totalMoney)
end

function File.load()
    if love.filesystem.getInfo('save.sav') ~= nil then
        Shop.totalMoney = love.filesystem.read("save.sav")
    end
end

return File