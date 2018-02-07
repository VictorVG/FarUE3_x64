local txt={}
-- @brief Удаление пробелов в начале
-- @param s string строка
-- @return string - строка без пробелов в начале
function txt.ltrim(s)
    return s:gsub("^%s*","")
end

-- @brief Удаление пробелов в конце строки
-- @param s string строка
-- @return string - строка без пробелов в конце
function txt.rtrim(s)
    return s:gsub("%s*$","")
end

-- @brief Удаление пробелов в начале и конце строки
-- @param s string строка
-- @return string - строка без пробелов в начале и конце
function txt.trim(s)
    return txt.rtrim(txt.ltrim(s))
end

-- @brief Удаление дублирующих пробелов
-- @details В строге-аргументе ищутся несколько пробелов, идущих
--   подряд и заменяются на один пробел
-- @param s string строка
-- @return string - строка без дублирующих пробелов
function txt.cleanspaces(s)
    return s:gsub("%s+"," ")
end

-- @brief Подсчёт количества вохождений подстроки.
-- @details В качестве подстроки может использоваться шаблон 
--   регулярного выражения
-- @param s string строка, в которой ищется подстрока p
-- @param p string подстрока (шаблон), которая ищется в s
-- @return integer - количество вхождений
function txt.countSubStrs(s,p)
    local i=1
    local c=0

    while i do
        _, i = s:find(p, i)
        if i then
            c = c + 1
            i = i+1
        end
    end

    return c
end

-- @brief Выравнивание строки по ширине текста
-- @details Формируется строка в которой текст пробелами
--   дополняется до ширины текста равной установленной
--   пользователем. Таким образом строка становится выравненной по
--   левому и правому краю одновременно.
-- @param t string текст
-- @param w integer ширина текста
-- @return integer - выравненная по ширине строка
function txt.alignJustify(t, w)
    local spaces=txt.countSubStrs(t,"%s+")
    local row=""

    if spaces==0 then
        row=t
    else
        local delta=math.floor((w-t:len())/spaces)+1
        local mod=(w-t:len())%spaces
        local i=1
        local tw

        for tw in t:gmatch("%S+") do
            row=row..tw
            if (i<=spaces) then 
                row=row..string.rep(" ", delta)

                if (spaces-i)<mod then
                    row=row.." "
                end
            end

            i=i+1
        end
    end
    return row
end

-- @brief Выравнивание текста в строке по центру
-- @details Формируется строка в которой текст пробелами дополняется
--   слева, центрируя таким образом строку по ширине текста
-- @param t string текст
-- @param w integer ширина текста
-- @return integer - выравненная по центру строка
function txt.alignCenter(t, w)
    return string.rep(" ", math.floor((w-t:len())/2))..t
end

-- @brief Выравнивание текста в строке по правому краю
-- @details Формируется строка в которой текст пробелами дополняется
--   слева, выравнивая таким образом строку по правому краю
-- @param t string текст
-- @param w integer ширина текста
-- @return integer - выравненная по правому краю строка
function txt.alignRight(t, w)
    return string.rep(" ", w-t:len())..t
end

return txt