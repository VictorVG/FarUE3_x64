-- -------------------------------------------------------------------
-- Подключим вспомогательные модули
-- -------------------------------------------------------------------
local fb  = require "fb"
local dlg  = require "dlg"
-- -------------------------------------------------------------------
local F = far.Flags
local M = far.GetMsg
-- -------------------------------------------------------------------
local main={}
function main.Open(OpenFrom, Guid, Item)
    -- Если мы не в редакторе, то уходим отсюда нафиг
    if OpenFrom ~= F.OPEN_EDITOR and OpenFrom~=F.OPEN_FROMMACRO then
        return
    end

    -- Если плагину переданы аргументы, то обрабатываем их
    if type(Item)=="table" then
        if Item["n"] > 0 then
            -- Форматируем блок без вызова диалога,  согласно  сохраненным
            -- настройкам или настройкам по умолчанию, если  настройки  не
            -- были ещё сохранены.
            if Item[1] == 1 then
                dlg.init()
                fb.FormatedBlock(dlg.data)
                return
            end
        end
    end

    if dlg.run()==1 then
        fb.FormatedBlock(dlg.data)
    end
end
return main
