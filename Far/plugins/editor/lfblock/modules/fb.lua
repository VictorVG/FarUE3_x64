local F=far.Flags
local lib = require "lib"
local txt = require "txt"
local fb={}

-- @brief Проверка на необходимость вставки новой строки
-- @param t string строка
-- @param s array массив настроек
-- @return bool
--   - true - Новая строка нужна
--   - false - Новая строка не нужна
function fb.IsNewLine(t, s)
    if s.paragraph==2 then
        return true
    elseif s.paragraph==3 then
        if txt.trim(t) == "" then
            return true
        end
    elseif s.paragraph==4 then
        if t:match("^%s+") then
            return true
        end
    elseif s.paragraph==5 then
        if txt.trim(t) == "" or t:match("^%s+") then
            return true
        end
    end
    return false
end

-- @brief Получение информации о блоке текста
-- @details Если текст выделен, то возвращается информация
--   о выделенном блоке, в ином случае за блок берется
--   текущая строка.
-- @return StartLine, EndLine
--   - StartLine - номер первой строки блока
--   - EndLine - номер последней строки блока
function fb.GetSelPos()
    local Info = editor.GetInfo()
    local Sel  = editor.GetSelection(Info.EditorId)

    if Sel~=nil then
        if Sel.EndPos>0 then
            return Sel.StartLine, Sel.EndLine
        else
            return Sel.StartLine, Sel.EndLine-1
        end
    else
        return Info.CurLine, Info.CurLine
    end
end

-- @brief Получение ширины текста текущей строки за вычетом отступа.
-- @details Результат зависит от номера строки, т.к. у первой строки
--   и у последующих строк отступы разные.
-- @param n integer номер строки
-- @param s array массив настроек
-- @return integer - ширина текста текущей строки
function fb.getWidth(n,s)
    return s.right-fb.getMargin(n,s)
end

-- @brief Получение отступа текущей строки.
-- @details Результат зависит от номера строки, т.к. у первой строки
--   и у последующих строк отступы разные.
-- @param n integer номер строки
-- @param s array массив настроек
-- @return integer - отступ текущей строки
function fb.getMargin(n,s)
    if n==1 then
        return s.first-1
    end
    return s.left-1
end

-- @brief Получение текстового отступа строки.
-- @details Формируется из пробелов, количество которых равно
--   величине отступа текущей строки. Используется для создания
--   отступа строки согласно пользовательским настройкам
-- @param n integer номер строки
-- @param s array массив настроек
-- @return integer - пробелы для отступа
function fb.getSpaces(n,s)
    return string.rep(" ", fb.getMargin(n, s))
end

-- @brief Преобразование длинной строки в абзац
-- @details Одна длинная строка разбивается на массив 
--   подстрок шириной не превышающей указанной в 
--   настройках.
-- @param t string преобразуемая строка
-- @param s array массив настроек
-- @return array - массив строк, образующих абзац
function fb.FormatString(t,s)
    local rows={""}
    local w

    for w in t:gmatch("%S+") do
        if #rows==1 and rows[#rows]:len()==0 then
            rows[#rows]=w
        else
            if (rows[#rows]:len()+w:len()+1) <= fb.getWidth(#rows,s) then
                rows[#rows]=rows[#rows].." "..w
            else
                rows[#rows+1]=w
            end
        end
    end

    return rows
end

-- @brief Выравнивание текста в зависимости от аргументов
-- @param t string текст
-- @param w integer ширина текста
-- @param a integer код выравнивания
--   - 1 - по левому краю
--   - 2 - по правому краю
--   - 3 - по центру
--   - 4 - по ширине, последняя строка по левому краю
--   - 5 - по ширине, включая последнюю строку
-- @param l bool флаг последней строки
--   - true - текст в аргументе t является последней строкой
--   - false - текст в аргументе t не является последней строкой
--   используется при выравнивании по ширине, без выравнивания 
--   последней строки
-- @return string - выравненный текст
function fb.alignText(t, w, a, l)
    local row=""

    if     a==2 then
        row=row..txt.alignRight(t, w)
    elseif a==3 then
        row=row..txt.alignCenter(t, w)
    elseif a==4 and not l then
        row=row..txt.alignJustify(t, w)
    elseif a==5 then
        row=row..txt.alignJustify(t, w)
    else
        row=row..t
    end
    return row
end
-- @brief Вывод отформатированных строк
-- @param s array массив настроек
-- @param StringBuffer array массив строк
function fb.OutStrings(StringBuffer, s)
    for k,v in pairs(StringBuffer) do
        if v~="" then
            local rows=fb.FormatString(v,s)

            for i=1, #rows do
                local w=fb.getWidth(i,s)
                lib.write(fb.getSpaces(i,s))
                lib.writeln(fb.alignText(rows[i],w,s.align, i==#rows))
            end

            if s.insertline==1 then
                lib.writeln()
            end
        end
    end
end

-- @brief Получение строк из выделенного блока
-- @param b integer первая строка блока
-- @param e integer последняя строка блока
-- @param s array массив настроек
function fb.GetStrings(b, e, s)
    local row, r
    local rows={""}

    for i=b, e do
        row, _ = editor.GetString(nil, i, 3)

        if rows[#rows]~="" and fb.IsNewLine(row, s) then
            rows[#rows+1]=""
        end

        if rows[#rows]~="" then
            rows[#rows]=rows[#rows].." "
        end

        rows[#rows]=rows[#rows]..row

    end
    return rows, 0
end
-- @brief Форматирование выделенного блока текста
-- @param s array массив настроек
function fb.FormatedBlock(s)
    local Info = editor.GetInfo()
    local StartLine, EndLine = fb.GetSelPos()
    local StringBuffer=fb.GetStrings(StartLine, EndLine, s)
    -- Начало блочной операции
    editor.UndoRedo(nil, F.EUR_BEGIN)

    editor.Select(nil, "BTYPE_STREAM", StartLine, 1, -1, EndLine-StartLine+1)
    editor.DeleteBlock()
    editor.SetPosition(nil, StartLine, 1)

    if StringBuffer[#StringBuffer]=="" then
        StringBuffer[#StringBuffer]=nil
    end

    fb.OutStrings(StringBuffer, s)

    -- Конец блочной операции
    editor.UndoRedo(nil, F.EUR_END)
end

return fb