---------------------
-- Save File class --
---------------------

local ShopItem = require 'src/shop/ShopItem'

local File = {}

function File.save()
    if love.filesystem.getInfo('save.sav') ~= nil then
        local moneyBackup, highestScoreBackup, type, level
        local itemsBackup = {}

        local lineNumber = 1
        for line in love.filesystem.lines('save.sav') do
            if lineNumber == 1 then
                moneyBackup = tonumber(line)
            elseif lineNumber == 2 then
                highestScoreBackup = tonumber(line)
            else
                if lineNumber%2 ~= 0 then
                    type = line
                else
                    level = tonumber(line)
                    table.insert(itemsBackup, ShopItem:new(type, level))
                end
            end
            lineNumber = lineNumber + 1
        end

        love.filesystem.write("save_backup.sav", moneyBackup..'\n')
        love.filesystem.append("save_backup.sav", highestScoreBackup..'\n')
        for tempo, item in ipairs(itemsBackup) do
            love.filesystem.append("save_backup.sav", item.type..'\n'..item.level..'\n')
        end
    end

    love.filesystem.write("save.sav", Shop.totalMoney..'\n')
    love.filesystem.append("save.sav", Shop.highestScore..'\n')
    for tempo, item in ipairs(Shop.itemsList) do
        love.filesystem.append('save.sav', item.type..'\n'..item.level..'\n')
    end
end

function File.load()
    if love.filesystem.getInfo('save.sav') ~= nil then
        local lineNumber = 1
        local type, level
        for line in love.filesystem.lines('save.sav') do
            if lineNumber == 1 then
                Shop.totalMoney = tonumber(line)
            elseif lineNumber == 2 then
                Shop.highestScore = tonumber(line)
            else
                if lineNumber%2 ~= 0 then
                    type = line
                else
                    level = tonumber(line)
                    table.insert(Shop.itemsList, ShopItem:new(type, level))
                end
            end
            lineNumber = lineNumber + 1
        end
    end
end

return File