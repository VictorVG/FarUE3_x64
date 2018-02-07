local lib = {}
-- "Hello World" - FAR plugin in Lua --
-- Поиск в массиве значения, в случае нахождения
-- возвращает индекс первого найденного значения
-- иначе nil
lib.array_find = function  (a, v)
	local key
	local val
	for key, val in pairs(a) do
		if val == v then
			return key
		end
	end
	return nil
end

-- Парсинг имени файла, на входе имя_файла
-- на выходе {диск, путь, имя, расширение}
lib.ParseFileName = function(str)
	local drive, path, name, ext
	if str == nil then str="" end

	drive = string.match(str, "^%s*([^:]+:)")
	str=str:gsub("^%s*([^:]+:)","")

	path=string.match(str, "^(.*)[\\/]")
	str=str:gsub("^(.*)[\\/]","")

	ext=string.match(str, "%.([^%.]+)$")
	name=str:gsub("%.([^%.]+)$","")

	if name == nil then name="" end
	if ext == nil then ext="" end
	if path == nil then path="" end
	if drive == nil then drive="" end
	
	return drive, path, name, ext
end

-- Пример вывода в консоль Far Manager
-- содрано с форума
function lib.printToFARConsole(txt)
    local hScr;
    panel.GetUserScreen();
    -- Т.к. консоль выводит текст в формате OEM (866), 
    -- то конвертируем его сначала
    io.write(win.Utf8ToOem (txt));
    panel.SetUserScreen();
end
lib.coalesce = {}

-- @brief Генератор строки по шаблону
-- @details Генерирует строку из пользовательского шаблона (str),
--   исходя из пользовательских сопоставлений (patterns). Т.е.
--   заменяет во входной строке все подстроки, совпадающие с каким либо
--   индексом из массива во втором аргументе, на значение элемента массива
--   с индексом совпавшим с найденной подстрокой
-- @param str string шаблон строки
-- @param patterns array массив вида {"маска поиска"="замена"} сопоставлений, 
--   т.е. что на что менять. При этом нужно учесть, что <маска поиска> является
--   регулярным выражением и должна задаваться в соответствующем формате (т.е.
--   знака '%' в маске должен указываться как '%%'.
-- @return string - собранная из шаблона и сопоставлений строка
function lib.repl(s, patterns)
    local res = ""
    local p = patterns or {}

    local matched

    while s:len() > 0 do
        m=false

        for k,v in pairs(p) do
            m = s:match("^"..k)
            if m then
                res = res .. v
                s = s:gsub("^"..k,"")
                break
            end
        end

        if not m then
            res = res .. s:sub(1,1)
            s = s:gsub("^.","")
        end
    end
    return res
end

-- Возвращает пустую строку, если аргумент не определен (a == nil)
function lib.coalesce.str(a)
    return a or ""
end
-- Функции для работы с датой/временем в формате FileTime
lib.FileTime = {}

-- Преобразовывает дату в формате FileTime в строку вида "ГГГГ.ММ.ДД"
function lib.FileTime.date(d)
    local ft=win.FileTimeToSystemTime(win.FileTimeToLocalFileTime(d))
    return string.format("%04d-%02d-%02d", ft.wYear, ft.wMonth, ft.wDay)
end

-- Преобразовывает GMT дату в формате FileTime в строку вида "ГГГГ.ММ.ДД"
function lib.FileTime.gdate(d)
    local ft=win.FileTimeToSystemTime(d)
    return string.format("%04d-%02d-%02d", ft.wYear, ft.wMonth, ft.wDay)
end

-- Преобразовывает время в формате FileTime в строку вида "чч.мм.сс"
function lib.FileTime.time(d)
    local ft=win.FileTimeToSystemTime(win.FileTimeToLocalFileTime(d))
    return string.format("%02d:%02d:%02d", ft.wHour, ft.wMinute, ft.wSecond)
end

-- Преобразовывает GMT время в формате FileTime в строку вида "чч.мм.сс"
function lib.FileTime.gtime(d)
    local ft=win.FileTimeToSystemTime(d)
    return string.format("%02d:%02d:%02d", ft.wHour, ft.wMinute, ft.wSecond)
end

return lib
