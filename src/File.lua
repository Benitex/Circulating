---------------------
-- Save File class --
---------------------

local File = {}

function File.save()
    if love.filesystem.getInfo('save.sav') ~= nil then
        local moneyBackup, type, level
        local elementsBackup = {}

        local lineNumber = 1
        for line in love.filesystem.lines('save.sav') do
            if lineNumber == 1 then
                moneyBackup = line
            else
                if lineNumber%2 == 0 then
                    type = line
                else
                    level = tonumber(line)
                    table.insert(elementsBackup, ShopElement:new(type, level))
                end
            end
            lineNumber = lineNumber + 1
        end

        love.filesystem.write("save_backup.sav", moneyBackup..'\n')
        for tempo, element in ipairs(elementsBackup) do
            love.filesystem.append("save_backup.sav", element.type..'\n'..element.level..'\n')
        end
    end

    love.filesystem.write("save.sav", Shop.totalMoney..'\n')
    for tempo, element in ipairs(Shop.elementsList) do
        love.filesystem.append('save.sav', element.type..'\n'..element.level..'\n')
    end
end

function File.load()
    if love.filesystem.getInfo('save.sav') ~= nil then
        local lineNumber = 1
        local type, level
        for line in love.filesystem.lines('save.sav') do
            if lineNumber == 1 then
                Shop.totalMoney = line
            else
                if lineNumber%2 == 0 then
                    type = line
                else
                    level = tonumber(line)
                    table.insert(Shop.elementsList, ShopElement:new(type, level))
                end
            end
            lineNumber = lineNumber + 1
        end
    end
end

return File