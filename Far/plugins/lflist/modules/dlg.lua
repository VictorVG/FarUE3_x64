-- ----------------------------------------------------------------- --
--                       Блок локальных данных                       --
-- ----------------------------------------------------------------- --
-- Разные вспомогательные переменные
local settings=require "settings"
local F = far.Flags
local M = far.GetMsg
--local function M(i)
--    local a = {}
--    a[01]=""
--    a[02]=""
--    a[03]="Отмена"
--    a[04]="Создать"
--    a[05]="Создание списка файлов"
--    a[06]="Имя файла:"
--    a[07]="Формат строки:"
--    a[08]="Первая строка:"
--    a[09]="Конечная строка:"
--    a[10]="Обрабатывать вложенные папки"
--    a[11]="Снять выделение с выделенных файлов"
--    a[12]="Результаты в файл"
--    a[13]="Добавлять в конец файла"
--    a[14]="Кодировка символов:"
--    a[15]="Результаты в Буфер Обмена"
--    a[16]="Счётчик"
--    a[17]="Ширина:"
--    a[18]="Начало:"
--    a[19]="Шаг:"
--    a[20]="Не включать в список каталоги с файлами"
--    a[21]="Не включать в список пустые каталоги"
--    a[23]="Сорт"
--    a[24]="Имя(возр.)" 
--    a[25]="Имя(уб.)"
--    a[26]="Размер(возр.)"
--    a[27]="Размер(уб.)"
--    a[28]="Дата созд.(возр.)"
--    a[29]="Дата созд.(уб.)"
--    a[30]="Дата мод.(возр.)"
--    a[31]="Дата мод.(уб.)"
--    a[32]="Не включать в список файлы"
--    a[33]="Не включать в список каталоги"
--    a[34]="Исключить промежуточные каталоги"
--    return a[i]
--end
local cbxValues1 = {{Text="OEM"}, {Text="UTF-8"}}
local cbxValues2 = {{Text="---"}, 
    {Text=M(24)}, 
    {Text=M(25)}, 
    {Text=M(26)}, 
    {Text=M(27)}, 
    {Text=M(28)}, 
    {Text=M(29)}, 
    {Text=M(30)}, 
    {Text=M(31)}
}
-- ----------------------------------------------------------------- --

-- ----------------------------------------------------------------- --
--                       Определение структуры                       --
-- ----------------------------------------------------------------- --
local dlg = {}
-- Ширина диалога
dlg.width = 76
-- Высота диалога
dlg.height = 23
-- Данные диалога
dlg.data = {
	filename = "filename.bat",
	format = "%P",
	first = "",
	last = "",
	recurse = 0,
	unselected = 1,
	infile = 1,
	appendinfile = 0,
    charset = "OEM",
    inclipboard  = 0,
    appendinclipboard  = 0,
    iwidth = 1,
    istart = 0,
    istep = 1,
    skipdir = 1,
    skipempty = 0,
    sortres = "---",
    skipfiles=0,
    skipidirs=0,
}

dlg.items = {}
function dlg.init()
    dlg.data=settings.initValues("data", dlg.data)
	local h,w = dlg.height, dlg.width
	dlg.items = {
--[[01]]{F.DI_BUTTON   ,  0, h-3,   0,  0, 0, 0, 0, F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP, M(4)},
--[[02]]{F.DI_BUTTON   ,  0, h-3,   0,  0, 0, 0, 0, F.DIF_CENTERGROUP, M(3)},
--[[03]]{F.DI_DOUBLEBOX,  3,   1, w-4,h-2, 0, 0, 0, 0, M(5)},
--[[04]]{F.DI_TEXT     ,  3, h-4,   0,  0, 0, 0, 0, F.DIF_SEPARATOR2,""},
--[[05]]{F.DI_TEXT     ,  5,   2,   0,  0, 0, 0, 0, 0, M(6)},
--[[06]]{F.DI_EDIT     , 22,   2, w-6,  0, 0, "flist.filename", 0, F.DIF_HISTORY+F.DIF_EDITPATH, dlg.data.filename},
--[[07]]{F.DI_TEXT     ,  5,   3,   0,  0, 0, 0, 0, 0, M(7)},
--[[08]]{F.DI_EDIT     , 22,   3, w-6,  0, 0, "flist.format", 0, F.DIF_HISTORY+F.DIF_FOCUS, dlg.data.format},
--[[09]]{F.DI_TEXT     ,  5,   4,   0,  0, 0, 0, 0, 0, M(8)},
--[[10]]{F.DI_EDIT     , 22,   4, w-6,  0, 0, "flist.first", 0, F.DIF_HISTORY, dlg.data.first},
--[[11]]{F.DI_TEXT     ,  5,   5,   0,  0, 0, 0, 0, 0, M(9)},
--[[12]]{F.DI_EDIT     , 22,   5, w-6,  0, 0, "flist.last", 0, F.DIF_HISTORY, dlg.data.last},
--[[13]]{F.DI_TEXT     ,  3,   6,   0,  0, 0, 0, 0, F.DIF_SEPARATOR2,""},
--[[14]]{F.DI_CHECKBOX ,  5,   7,   0,  0, dlg.data.recurse,0,0,0, M(10)},
--[[15]]{F.DI_CHECKBOX ,  5,   8,   0,  0, dlg.data.unselected,0,0,0, M(11)},
--[[16]]{F.DI_TEXT     ,  3,   9,   0,  0, 0, 0, 0, F.DIF_SEPARATOR,""},
--[[17]]{F.DI_CHECKBOX ,  5,  10,   5, 20, dlg.data.infile,0,0,0, M(12)},
--[[18]]{F.DI_CHECKBOX ,  9,  11,   0,  0, dlg.data.appendinfile,0,0,0, M(13)},
--[[19]]{F.DI_TEXT     ,  9,  12,   0, 12, 0, 0, 0, 0, M(14)},
--[[20]]{F.DI_COMBOBOX ,  9 + M(14):len()+1, 12, 9 + M(14):len() + 7 + 1 , 0, cbxValues1, 0, 0, F.DIF_DROPDOWNLIST, dlg.data.charset},
--[[21]]{F.DI_CHECKBOX ,  5,  13,   0, 13, dlg.data.inclipboard,0,0,0, M(15)},
--[[22]]{F.DI_TEXT     ,w-(20+M(16):len())/2-5,  10, 0,   0, 0, 0, 0, 0, M(16)},
--[[23]]{F.DI_TEXT     ,w-25, 11,   0,  0, 0, 0, 0, 0, M(17)},
--[[24]]{F.DI_EDIT     ,w-13, 11,w-12,  0, 0, "flist.iwidth", 0, F.DIF_HISTORY, tostring(dlg.data.iwidth)},
--[[25]]{F.DI_TEXT     ,w-25, 12,   0,  0, 0, 0, 0, 0, M(18)},
--[[26]]{F.DI_EDIT     ,w-13, 12, w-6,  0, 0, "flist.istart", 0, F.DIF_HISTORY, tostring(dlg.data.istart)},
--[[27]]{F.DI_TEXT     ,w-25, 13,   0,  0, 0, 0, 0, 0, M(19)},
--[[28]]{F.DI_EDIT     ,w-13, 13, w-6,  0, 0, "flist.istep", 0, F.DIF_HISTORY, tostring(dlg.data.istep)},
--[[29]]{F.DI_TEXT     ,  3,  14,   0,  0, 0, 0, 0, F.DIF_SEPARATOR2,""},
--[[30]]{F.DI_VTEXT    ,w-27, 09,   0,  0, 0, 0, 0, 0, "┬││││╪││││╧"},
--[[31]]{F.DI_CHECKBOX ,  5,  15,   0, 13, dlg.data.skipdir,0,0,0, M(20)},
--[[32]]{F.DI_CHECKBOX ,  5,  16,   0, 13, dlg.data.skipempty,0,0,0, M(21)},
--[[33]]{F.DI_TEXT     ,w-25, 15,   0, 12, 0, 0, 0, 0, M(23)},
--[[34]]{F.DI_COMBOBOX ,w-18, 15,w-6, 0, cbxValues2, 0, 0, F.DIF_DROPDOWNLIST, dlg.data.sortres},
--[[35]]{F.DI_CHECKBOX ,  5,  17,   0, 13, dlg.data.skipfiles,0,0,0, M(32)},
--[[36]]{F.DI_CHECKBOX ,  5,  18,   0, 13, dlg.data.skipidirs,0,0,0, M(33)},
    }
end                                                           
                                                             
local function DlgProc(hDlg,Msg,Param1,Param2)                
    if Msg==F.DN_INITDIALOG then
        hDlg:send(F.DM_ENABLE, 05, dlg.data.infile)
        hDlg:send(F.DM_ENABLE, 06, dlg.data.infile)
        hDlg:send(F.DM_ENABLE, 18, dlg.data.infile)
        hDlg:send(F.DM_ENABLE, 19, dlg.data.infile)
        hDlg:send(F.DM_ENABLE, 20, dlg.data.infile)
    end
    if Msg==F.DN_BTNCLICK then
        if Param1==17 then
            hDlg:send(F.DM_ENABLE, 05, Param2)
            hDlg:send(F.DM_ENABLE, 06, Param2)
            hDlg:send(F.DM_ENABLE, 18, Param2)
            hDlg:send(F.DM_ENABLE, 19, Param2)
            hDlg:send(F.DM_ENABLE, 20, Param2)
        end
    end
end

function dlg.run()
	local hdlg = dlg.init()
	local ret = far.Dialog("",-1,-1,dlg.width,dlg.height,"Contents",dlg.items,nil,DlgProc)

	dlg.data = {
		filename           =          dlg.items[06][10] ,
		format             =          dlg.items[08][10] ,
		first              =          dlg.items[10][10] ,
		last               =          dlg.items[12][10] ,
		recurse            = tonumber(dlg.items[14][06]),
		unselected         = tonumber(dlg.items[15][06]),
		infile             = tonumber(dlg.items[17][06]),
		appendinfile       = tonumber(dlg.items[18][06]),
		charset            =          dlg.items[20][10] ,
		inclipboard        = tonumber(dlg.items[21][06]),
		iwidth             = tonumber(dlg.items[24][10]),
		istart             = tonumber(dlg.items[26][10]),
		istep              = tonumber(dlg.items[28][10]),
		skipdir            = tonumber(dlg.items[31][06]),
		skipempty          = tonumber(dlg.items[32][06]),
		sortres            =          dlg.items[34][10] ,
		skipfiles          = tonumber(dlg.items[35][06]),
		skipidirs          = tonumber(dlg.items[36][06]),
	}

    if dlg.data.iwidth < 1 then dlg.data.iwidth=1 end
    if dlg.data.iwidth > 9 then dlg.data.iwidth=9 end
    if dlg.data.istep  < 1 then dlg.data.istep=1 end

	if ret == 1 then
        settings.store(nil, "data", dlg.data)
	end
	return ret
end

return dlg
