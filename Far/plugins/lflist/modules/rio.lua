-- ------------------------------------------------------------------ --
-- Модуль реализующий вывод результатов в завивисимости от настроек   --
-- указанных пользователем (в файл и/или буфер обмена в               --
-- соответствующей кодировке                                          --
-- ------------------------------------------------------------------ --
local rio = {}
local lib = require "lib"

-- Дискриптор открытого файла
rio.fh = nil
-- Флаг вывода в файл
rio.infile = false
-- Флаг добавления в файл
rio.appendinfile = false
rio.charset = 'OEM'
-- Флаг вывода в буфер обмена
rio.inclipboard=false
-- Содержимое буфера обмена
rio.clipboard_text=""
-- ------------------------------------------------------------------
-- @brief Открытие файла
-- @details В зависимости от настроек открывает файл (или не
--   открывает) создавая при этом новый файл или открывая
--   существующий файл для добавления строк результата (в зависимости
--   от настроек из диалога)
-- @param d dlg указатель на структуру данных диалога
-- @return
--   - filehandler - указатель на открытый файл, если в настройках
--     указано записывать в файл
--   - nil - при ошибке открытия файла, если в настройках указано
--     записывать в файл
--   - -1 - если в настройках указано не записывать в файл
-- ------------------------------------------------------------------
function rio.open(d)
	local drive,path, name, ext=lib.ParseFileName(d.filename)

    filename=d.filename
	if path=="" and drive=="" and not filename:match("^\\") then
		path=far.GetCurrentDirectory()
    elseif path:match("^%.") then
		path=far.GetCurrentDirectory().."\\"..path
	end

	filename=drive..path.."\\"..name..(ext ~= "" and "."..ext or "")

    if d.infile==1 then
        rio.charset = d.charset
        rio.infile  = true
        if d.appendinfile==1 then
            rio.appendinfile = true
        	rio.fh=io.open(filename,"a")
        else
            rio.appendinfile = false
        	rio.fh=io.open(filename,"w")
        end
    else
        rio.infile=false
        rio.fh = -1
    end

    if d.inclipboard==1 then
        rio.inclipboard=true
        rio.clipboard_text=""
    else
        rio.inclipboard=false
    end

	return rio.fh
end

-- Вывод/невывод текста в файл, в зависимости от настроек
function rio.write(s)
    if rio.infile then
        if rio.charset=="UTF-8" then
            rio.fh:write(s)
        else
            rio.fh:write(win.Utf8ToOem(s))
        end
    end
    if rio.inclipboard then
        rio.clipboard_text=rio.clipboard_text..s
    end
end

-- Вывод/невывод строк в файл, в зависимости от настроек
function rio.writeln(s)
    rio.write(s.."\n")
end

-- Сброс файлового кэша на диск
function rio.flush()
    if rio.infile then
        rio.fh:flush()
    end
    if rio.inclipboard then
        far.CopyToClipboard(rio.clipboard_text)
    end
end

-- Закрытие файла
function rio.close()
    if rio.infile then
        rio.fh:close()
    end
    if rio.inclipboard then
        rio.clipboard_text=""
    end
end

return rio
