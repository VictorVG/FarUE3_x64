-- -----------------------------------------------------------------
-- Подключим вспомогательные модули
-- -----------------------------------------------------------------
local F = far.Flags
local M = far.GetMsg
-- -----------------------------------------------------------------
local function joinLists(a,b)
    for k,v in pairs(b) do
        a[k]=v
    end
    return a
end
-- -----------------------------------------------------------------
local main={}
function main.Open(OpenFrom, Guid, Item)
    package.loaded.lib=nil
    package.loaded.sf=nil
    package.loaded.dlg=nil
    package.loaded.rio=nil
    -- -----------------------------------------------------------------
    local lib = require "lib"
    local sf  = require "sf"
    local dlg = require "dlg"
    local rio = require "rio"
    -- -----------------------------------------------------------------
	local name, ext, drive, path, filename

    repeat
    	-- Вызываем диалог плагина
    	local ret = dlg.run()
    	-- Если пользователь не нажал кнопку "Создать" то валим от
    	-- сюда без продолжения каких либо действий
    	if ret ~= 1 then return end

    	local fh=rio.open(dlg.data)
    	if fh == nil then
    		far.Message(M(2).."\n"..dlg.data.filename, M(1), ";Ok", "w")
    	end
    until fh ~= nil

	local i=1
	local i, f, p
	local afiles = sf.get_selected_files(dlg.data)

    -- Получим ткущую дату
    local t=os.time()
    local currentDate=os.date("%Y-%m-%d", t)
    local currentTime=os.date("%H:%M:%S", t)
    local currdir=far.GetCurrentDirectory()

    -- Данный способ генерации строки из шаблона не самый удачный, но  он
    -- пока что самый работоспособный из всех, что  я  знаю.  Возможно  в
    -- будущем я найду менее уродливый алгоритм.

    -- Вычисления значения счётчика исходя из начального, текущего значений и
    -- шага
    local function getNum(n)
        return dlg.data.istart + (n-1)*dlg.data.istep
    end
    -- ------------------------------------------------------------------------
    -- --      Массив соответствий для шаблона первой и последней строк     ---
    -- ------------------------------------------------------------------------
    local function getPattern(n)
        return {
            ["%%%%"]  = "%",
            ["%%R"]   = "\n",
            ["%%C"]   = #afiles,
            ["%%L"]   = currdir,
            ["%%aL"]  = panel.GetPanelDirectory(nil, 1).Name,
            ["%%tT"]  = currentTime,
            ["%%tY"]  = currentDate,
            ["%%I"]   = getNum(n),
            ["%%oI"]  = getNum(n)+1,
            ["%%nI"]  = string.format("%0"..dlg.data.iwidth.."s", getNum(n)  ),
            ["%%sI"]  = string.format("%" ..dlg.data.iwidth.."s", getNum(n)  ),
            ["%%onI"] = string.format("%0"..dlg.data.iwidth.."s", getNum(n)+1),
            ["%%osI"] = string.format("%" ..dlg.data.iwidth.."s", getNum(n)+1),
            ["%%noI"] = string.format("%0"..dlg.data.iwidth.."s", getNum(n)+1),
            ["%%soI"] = string.format("%" ..dlg.data.iwidth.."s", getNum(n)+1),
        }
    end
    -- --------------------------------------------------------------------- --
    --    Экранирование магических символов поисковых шаблонов символом %    --
    -- --------------------------------------------------------------------- --
    local function screening(s)
        return s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])","%%%1")
    end
    -- --------------------------------------------------------------------- --
    --              Получение относительного пути файла/каталога             --
    -- --------------------------------------------------------------------- --
    local function getRelativePath(file,currdir)
        currdir=screening(currdir)
        local rep=""
        local res=file:gsub("^"..currdir.."\\?",rep)
        while currdir:match("\\[^\\]+$") do
            if file:match("^"..currdir.."\\?") then break end
            currdir=currdir:gsub("\\[^\\]+$","")
            rep=rep.."..\\"
        end
        res=file:gsub("^"..currdir.."\\?",rep)
        return res
    end
    -- ------------------------------------------------------------------------

	if dlg.data.unselected==1 then
		sf.unselected_files()
	end

    if dlg.data.first~="" then
    	rio.writeln(lib.repl(dlg.data.first, getPattern(1)))
    end

	for i=1, #afiles do
		drive,path, name, ext=lib.ParseFileName(afiles[i].FileName)
		f = name..(ext~="" and "."..ext or "")
		p = drive..path
        p=p..(p~="" and "\\" or "")..f
        
        p_D=drive..path
        p_sD=string.gsub((p_D~="" and p_D.."\\" or ""),"\\+$","\\")

        p_rD=getRelativePath(drive..path,currdir)
        p_rsD=string.gsub((p_rD~="" and p_rD.."\\" or ""),"\\+$","\\")

        p_mD=path
        p_msD=string.gsub((p_mD~="" and p_mD.."\\" or ""),"\\+$","\\")

        local pattern=getPattern(i)
        pattern=joinLists(pattern,{
            ["%%N"]   = name,
            ["%%fN"]   = (afiles[i].Attributes:match("D") and f or name),
            ["%%E"]   = ext,
            ["%%F"]   = f,

            ["%%D"]   = p_D,
            ["%%rD"]  = p_rD,
            ["%%mD"]  = p_mD,

            ["%%sD"]   = p_sD,
            ["%%rsD"]  = p_rsD,
            ["%%msD"]  = p_msD,

            ["%%V"]   = drive,
            ["%%P"]   = p,
            ["%%rP"]  = getRelativePath(p,currdir),
            ["%%S"]   = afiles[i].FileSize,
            ["%%aS"]  = afiles[i].AllocationSize,

            ["%%fT"]  = afiles[i].Time.Change,
            ["%%cT"]  = afiles[i].Time.Creation,
            ["%%lT"]  = afiles[i].Time.LastAccess,
            ["%%wT"]  = afiles[i].Time.LastWrite,

            ["%%fY"] = afiles[i].Date.Change,
            ["%%cY"] = afiles[i].Date.Creation,
            ["%%lY"] = afiles[i].Date.LastAccess,
            ["%%wY"] = afiles[i].Date.LastWrite,

            ["%%fgT"]  = afiles[i].GTime.Change,
            ["%%cgT"]  = afiles[i].GTime.Creation,
            ["%%lgT"]  = afiles[i].GTime.LastAccess,
            ["%%wgT"]  = afiles[i].GTime.LastWrite,

            ["%%fgY"] = afiles[i].GDate.Change,
            ["%%cgY"] = afiles[i].GDate.Creation,
            ["%%lgY"] = afiles[i].GDate.LastAccess,
            ["%%wgY"] = afiles[i].GDate.LastWrite,

            ["%%A"]  = afiles[i].Attributes,
        })

		rio.writeln(lib.repl(dlg.data.format, pattern))
	end

    if dlg.data.last~="" then
    	rio.writeln(lib.repl(dlg.data.last, getPattern(#afiles)))
    end

	rio.flush ()
	rio.close()
	-- Обновим панель
	panel.RedrawPanel(nil,1)
end
return main