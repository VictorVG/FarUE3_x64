local lib={}
-- @brief Вывод текста начиная с текущей позиции
-- @details Если в качестве аргумента передаётся nil
--   то ничего не делается.
-- @param s string выводимый текст
function lib.write(t)
    if t then
        editor.InsertText (nil, t)
    end
end

-- @brief Вывод строки начиная с текущей позиции
-- @details В текущую позицию выводится текст, после чего 
--   вставляется новая строка и курсор переходит на начало
--   новой строки. Если в качестве аргумента передаётся nil
--   то просто вставляется новая строка.
-- @param s string выводимая строка
function lib.writeln(s)
    lib.write(s)
    editor.InsertString()
end

return lib
