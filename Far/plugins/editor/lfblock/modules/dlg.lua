local settings=require "settings"
local dlg={}
local F = far.Flags
local M = far.GetMsg
--local function M(i)
--    local a = {}
--    a[01]="LUA Format Block"
--
--    a[02]="Форматирование блока"
--    a[03]="&Левая граница"
--    a[04]="Пе&рвая строка"
--    a[05]="&Правая граница"
--
--    a[06]="&Выравнивание"
--    a[07]="По левой"
--    a[08]="По правой"
--    a[09]="По центру"
--    a[10]="По ширине"
--    a[11]="Полностью"
--
--    a[12]="&Обнаружение абзацев"
--    a[13]="Выкл"
--    a[14]="Каждая строка"
--    a[15]="По пустой строке"
--    a[16]="По отступу"
--
--    a[17]="Пу&стая строка после параграфа"
--
--    a[18]="Ok"
--    a[19]="&Отмена"
--    a[20]="Отступ и строка"
--    return a[i]
--end
-- Ширина и высота диалога
local w, h= 55, 18
-- Элементы диалога
dlg.items = {
--[[01]]{F.DI_BUTTON   ,  0, h-3,   0,  0, 0, 0, 0, F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP, M(18)},
--[[02]]{F.DI_BUTTON   ,  0, h-3,   0,  0, 0, 0, 0, F.DIF_CENTERGROUP, M(19)},
--[[03]]{F.DI_DOUBLEBOX,  3,   1, w-4,h-2, 0, 0, 0, 0, M(2)},
--[[04]]{F.DI_TEXT     ,  3, h-4,   0,  0, 0, 0, 0, F.DIF_SEPARATOR,""},
--[[05]]{F.DI_TEXT     ,  5,   2,   0,  0, 0, 0, 0, 0, M(3)},
--[[06]]{F.DI_EDIT     , 20,   2,  23,  0, 0, 0, 0, F.DIF_FOCUS, ""},
--[[07]]{F.DI_TEXT     ,  5,   3,   0,  0, 0, 0, 0, 0, M(4)},
--[[08]]{F.DI_EDIT     , 20,   3,  23,  0, 0, 0, 0, F.DIF_FOCUS, ""},
--[[09]]{F.DI_TEXT     ,  5,   4,   0,  0, 0, 0, 0, 0, M(5)},
--[[10]]{F.DI_EDIT     , 20,   4,  23,  0, 0, 0, 0, F.DIF_FOCUS, ""},
--[[11]]{F.DI_TEXT     ,  3,   5,   0,  0, 0, 0, 0, F.DIF_SEPARATOR,""},
--[[12]]{F.DI_TEXT     ,  5, h-12,   0,  0, 0, 0, 0, 0, M(6)},
--[[13]]{F.DI_RADIOBUTTON, 7,h-11,   0,  0, 0, 0, 0, F.DIF_GROUP, M(7)},
--[[14]]{F.DI_RADIOBUTTON, 7,h-10,   0,  0, 0, 0, 0, 0, M(8)},
--[[15]]{F.DI_RADIOBUTTON, 7,h-09,   0,  0, 0, 0, 0, 0, M(9)},
--[[16]]{F.DI_RADIOBUTTON, 7,h-08,   0,  0, 0, 0, 0, 0, M(10)},
--[[17]]{F.DI_RADIOBUTTON, 7,h-07,   0,  0, 0, 0, 0, 0, M(11)},
--[[18]]{F.DI_TEXT     ,  26,h-12,   0,  0, 0, 0, 0, 0, M(12)},
--[[19]]{F.DI_RADIOBUTTON,29,h-11,   0,  0, 0, 0, 0, F.DIF_GROUP, M(13)},
--[[20]]{F.DI_RADIOBUTTON,29,h-10,   0,  0, 0, 0, 0, 0, M(14)},
--[[21]]{F.DI_RADIOBUTTON,29,h-09,   0,  0, 0, 0, 0, 0, M(15)},
--[[22]]{F.DI_RADIOBUTTON,29,h-08,   0,  0, 0, 0, 0, 0, M(16)},
--[[23]]{F.DI_RADIOBUTTON,29,h-07,   0,  0, 0, 0, 0, 0, M(20)},
--[[24]]{F.DI_TEXT     ,   3,h-06,   0,  0, 0, 0, 0, F.DIF_SEPARATOR,""},
--[[25]]{F.DI_CHECKBOX ,   5,h-05,   0,  0, 0, 0, 0, F.DIF_CENTERGROUP, M(17)},
}
-- Данные диалога
dlg.data={
    first=4,            -- Первая строка
    left=1,             -- Левая граница
    right=70,           -- Правая граница
    align=1,            -- Выравнивание (01 - По левой, 02 - По правой, 03 - По центру, 04 - По ширине, 05 - Полностью)
    paragraph=1,        -- Обнаружение абзацев (01 - Выкл, 02 - Каждая строка, 03 - По пустой строке, 04 - По отступу, 05 - По отступу и пустой строке)
    insertline=0,       -- Пустая строка после параграфа
}

-- Инициализация данных диалога
function dlg.init()
    dlg.data=settings.initValues("lfblock.data", dlg.data)
    -- Загрузим заголовки элементов диалога
    dlg.items[01][10]                   = M(18)
    dlg.items[02][10]                   = M(19)
    dlg.items[03][10]                   = M(2)
    dlg.items[05][10]                   = M(3)
    dlg.items[07][10]                   = M(4)
    dlg.items[09][10]                   = M(5)
    dlg.items[12][10]                   = M(6)
    dlg.items[13][10]                   = M(7)
    dlg.items[14][10]                   = M(8)
    dlg.items[15][10]                   = M(9)
    dlg.items[16][10]                   = M(10)
    dlg.items[17][10]                   = M(11)
    dlg.items[18][10]                   = M(12)
    dlg.items[19][10]                   = M(13)
    dlg.items[20][10]                   = M(14)
    dlg.items[21][10]                   = M(15)
    dlg.items[22][10]                   = M(16)
    dlg.items[23][10]                   = M(20)
    dlg.items[25][10]                   = M(17)
    -- Инициализируем данные
    dlg.items[06][10]                   = dlg.data.left
    dlg.items[08][10]                   = dlg.data.first
    dlg.items[10][10]                   = dlg.data.right
    dlg.items[25][06]                   = dlg.data.insertline
    -- Выделим соответствующие radiobuttons
    dlg.items[12+dlg.data.align    ][06]=1
    dlg.items[18+dlg.data.paragraph][06]=1
end

-- Сохранение данных диалога,. Если диалог возвращает данные,
-- то настройки сохранятся в базе
local function save(r)
    local i
    for i=1, 5 do
        if dlg.items[12+i][06]==1 then
            dlg.data.align = i
            break
        end
    end

    for i=1, 5 do
        if dlg.items[18+i][06]==1 then
            dlg.data.paragraph = i
            break
        end
    end

    dlg.data.left       = tonumber(dlg.items[06][10])
    dlg.data.first      = tonumber(dlg.items[08][10])
    dlg.data.right      = tonumber(dlg.items[10][10])
    dlg.data.insertline = tonumber(dlg.items[25][06])

    if r==1 then
        settings.store(nil, "lfblock.data", dlg.data)
    end
end


local function DlgProc(hDlg,Msg,Param1,Param2)
    if Msg==F.DN_CLOSE then
        -- Считаем данные диалога в массив
        for i=1, #dlg.items do
            dlg.items[i]=hDlg:send(F.DM_GETDLGITEM, i)
        end

        -- Проверим числовые данные полей ввода, в случае их
        -- некорректности, заново инициализируем их

        -- Левая граница
        dlg.items[06][10]=tonumber(dlg.items[06][10])
        if dlg.items[06][10]==nil or dlg.items[06][10]<1 then
            dlg.items[06][10]=1
            hDlg:send(F.DM_SETDLGITEM, 06, dlg.items[06])
        end

        -- Первая строка
        dlg.items[08][10]=tonumber(dlg.items[08][10])
        if dlg.items[08][10]==nil or dlg.items[08][10]<1 then
            dlg.items[08][10]=4
            hDlg:send(F.DM_SETDLGITEM, 08, dlg.items[08])
        end

        -- Правая граница
        dlg.items[10][10]=tonumber(dlg.items[10][10])
        if dlg.items[10][10]==nil or dlg.items[10][10]<1 then
            dlg.items[10][10]=70
            hDlg:send(F.DM_SETDLGITEM, 10, dlg.items[10])
        end

        -- Сохраним данные диалога
        save(Param1)
    end   
end

function dlg.run()
    dlg.init()
    return far.Dialog("",-1,-1,w,h,"Contents",dlg.items,nil,DlgProc)
end
return dlg
