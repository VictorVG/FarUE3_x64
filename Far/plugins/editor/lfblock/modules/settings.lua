local F=far.Flags
local settings={}
-- @brief Проверка строки на число.
-- @details Проверяется, является ли аргумент строкой, содержащей число.
--   Число может быть целым, дробным, положительным, отрицательным.
-- @param t string - проверяемая строка
-- @return 
--   - integer - число, если строка является числом.
--   - nil - если строка не является числом.
local function isnumeric(t)
    if type(t)=="number" then return t end
    if type(t)~="string" then return nil end
    local res=t:match("^%s*-?%s*%d+%.?%d-%s*$")
    return tonumber(res and res:gsub("%s*", ""))
end
-- @brief Дамп переменных
-- @details Возвращает значение переменной в виде строки, в  читабельном
--   виде. Обрабатывает так же таблицы(массивы). Значение функции  можно
--   использовать при сериализации значений, например строка:
--
--     assert(loadstring("return "..settings.dump({"a","b","c"})))()
--
--   вернёт массив со значением: {"a","b","c"}.
-- @param val any - переменная string, number, boolean или table типа
-- @return string - дамп переменной в виде текстовой строки.
function settings.dump(val)
    local tv=type(val)

    if bit64.type(val) then
        return "bit64.new(\"" .. tostring(val) .. "\")"
    end

    if tv=="boolean" then
        return tostring(val)
    elseif tv=="number" then
        if val == math.modf(val) then
            return tostring(val)
        else
            return string.format("(%.17f * 2^%d)", math.frexp(val))
        end
    elseif tv=="table" then
        local res="{\n"
        for k,v in pairs(val) do
            res=res..string.format("[%s] = %s,\n",settings.dump(k),settings.dump(v))
        end
        res=res.." }"
        return res
    end
    return string.format("%q", tostring(val))
end
-- @brief Проверка соотвтествия типа аргумента заданному типу.
-- @details Внутренняя функция, используемая для  проверки  соответствия
--   типа  аргумента,  переданного  функции  заданному.  Если   тип   не
--   соответствует, то  выдаёт  матюки.  Предназначена  для  недопущения
--   передачи в качестве аргумента функции строки там где  нужно  число,
--   таблицы там где нужна строка, и т.д.
-- @param val any - проверяемая переменная.
-- @param num integer - порядковый номер  аргумента  в  пользовательской
--   функции, используется только  для  того,что  бы  проинформировавать
--   пользователя какой номер по счёту имеет неверный тип переменной.
-- @param valtype string - тип переменной который должен быть,  значения
--   в виде строки, например: "string", "number", "boolean", "table".
local function checktype (val, num, valtype)
    if type(val) ~= valtype then
        error(string.format('Argument. #%d: %s is not "%s" type', num, type(val), valtype), 3)
    end
end
-- @brief Получение типа строки в базе настроек.
-- @param name string - имя строки.
-- @param o userdata - Струкутура созданная функцией far.CreateSettings.
-- @param s number - Номер подгруппы, созданный функцией obj:OpenSubkey.
-- @return 
--   - Если запись найдена, то тип записи  в  виде  значений:
--     - F.FST_UNKNOWN - не определен 
--     - F.FST_SUBKEY  - подключ 
--     - F.FST_QWORD   - число 
--     - F.FST_STRING  - строка 
--     - F.FST_DATA    - данные 
--   - Если запись не найдена то nil.
local function getType (name, o, s)
    checktype(name, 1, "string")
    checktype(o, 2, "userdata") 
    checktype(s, 3, "number") 
    local enum=o:Enum (s)
    for i = 1,enum.Count do 
        if enum[i].Name==name then
            return enum[i].Type
        end
    end
    return nil
end
-- @brief Сохранение строки в базе настроек плагина.
-- @details Внутренняя функция, используется  для  сохранения  строки  в
--   базе настроек из других функций.
-- @param group string - имя группы настроек. Если имя группы не указано
--   (group==nil) или пусто (group=="") и  в  то  же  время  не  указаны
--   аргументы o и s, то строка создаёся в корне.
-- @param name string - имя сохраняемой  в  группе  настроек  переменной
-- @param val any - сохраняемая переменная.
-- @param valtype number - тип сохраняемой переменной вида  F.FST_QWORD,
--   F.FST_STRING или F.FST_DATA
-- @param o userdata - Струкутура созданная функцией far.CreateSettings,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины, или в секцию данных другого плагина. Если пусто  (o==nil),
--   то группа открывается в корне настроек текущего плагина.
--
--   Внимение, если этот аргумент не пуст, то пользователю  нужно  будет
--   самому выполнить o:Free() после вызова данной функции.
-- @param s number - Номер подгруппы, созданный функцией obj:OpenSubkey,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины.  Если  данный  аргумент  не  пуст  (s~=nil),  то  значение
--   аргумента group игнорируется.  Если  аргумент  o  пуст,  то  данное
--   значение не используется. Если s==0, то строка создаётся в корне.
-- @return bool - результат выполнения функции:
--   - true - выполнено успешно
--   - false - выполнить не удалось
local function storestring(group, name, val, valtype, o, s)
    if group then checktype(group , 1, "string") end
    checktype(name, 2, "string")
    if o then checktype(o, 4, "userdata") end
    if s then checktype(s, 5, "number") end
    local subkey=nil
    local res=false

    local obj = o or far.CreateSettings()

    if o and s then
        subkey = s
    elseif group~=nil and group~="" then
        subkey = obj:CreateSubkey(0, group)
    else
        subkey = 0
    end

    res=obj:Set(subkey, name, valtype, val)
    if not o then obj:Free() end
    return res
end
-- @brief Удаление переменной или группы из базы настроек плагина.
-- @details Можно удалять переменные из корня, как по одной так  и  все:
--
--     settings.delete()
--     settings.delete("mygroup")
--     settings.delete("mygroup", "mystring")
--     settings.delete(nil, "mystring")
--     settings.delete(nil, "mygroup")
--
--   При чём удаляются как строки  с  данными,  так  и  группы,  если  в
--   параметре name указано имя группы.
-- @param group string - имя группы настроек, если имя группы не указано
--   (group==nil), или равно пустой строке, и в то же время  не  указаны
--   аргументы o и s, то удаление происходит из корня.
-- @param name string - имя переменной, если вместо имени пустая  строка
--   или nil, то удаляются все записи в группе.
-- @param o userdata - Струкутура созданная функцией far.CreateSettings,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины, или в секцию данных другого плагина. Если пусто  (o==nil),
--   то группа открывается в корне настроек текущего плагина.
--
--   Внимение, если этот аргумент не пуст, то пользователю  нужно  будет
--   самому выполнить o:Free() после вызова данной функции.
-- @param s number - Номер подгруппы, созданный функцией obj:OpenSubkey,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины.  Если  данный  аргумент  не  пуст  (s~=nil),  то  значение
--   аргумента group игнорируется.  Если  аргумент  o  пуст,  то  данное
--   значение не используется. Если s==0, то строка создаётся в корне.
-- @return bool - результат выполнения функции:
--   - true - выполнено успешно
--   - false - выполнить не удалось
function settings.delete (group, name, o, s)
    if group then checktype(group, 1, "string") end
    if name  then checktype(name, 2, "string")  end
    if o     then checktype(o, 3, "userdata")   end
    if s     then checktype(s, 4, "number")     end
    local res=false
    local subkey=nil

    local obj = o or far.CreateSettings()

    if o and s then
        subkey = s
    elseif group~=nil and group~="" then
        subkey = obj:OpenSubkey(0, group)
    else
        subkey = 0
    end

    if subkey~=nil then
        if name~=nil and name~="" then
            if getType(name, obj, subkey)==F.FST_SUBKEY then
                local subsubkey = obj:OpenSubkey(subkey, name)
                res=subsubkey and obj:Delete(subsubkey)
            else
                res=obj:Delete(subkey, name)
            end
        else
            res=obj:Delete(subkey)
        end
    end
    if not o then obj:Free() end

    return res
end
-- @brief Сохранение переменной в базе настроек плагина.
-- @details Сохраняет в базе настроек  строки,  числа,  в  том  числа  с
--   запятой, логические переменные и таблицы.
--
--   Функцию так же  можно  использовать  для  оперирования  настройками
--   других  плагинов,  например  изменение  и  извлечение  имени  файла
--   плагина LUA File List:
--
--     local val  = "filelist.bat"
--     local Guid = win.Uuid("0785F214-65B9-47B6-B9D8-F24FADC60AA0")
--     local obj  = far.CreateSettings(Guid)
--     local subkey = nil
--
--     if obj then
--         subkey = obj:OpenSubkey(0, "data")
--     end
--
--     settings.store("data", "filename", val, obj, subkey)
--
--     local b=settings.restore("data", "filename", obj, subkey)
--     obj:Free()
--
--     far.Message(settings.dump(b))
--
--   При желании переменную можно записать прямо в корень, и из корня её
--   так же прочесть. Причем переменная может  быть  любого  типа,  даже
--   таблицы. Например:
--
--     settings.store(nil, "RootVal", 1234)
--     local b = settings.restore(nil, "RootVal")
--     far.Message(settings.dump(b))
--
-- @param group string - имя группы настроек. Если имя группы не указано
--   (group==nil), или равно пустой строке, и в то же время  не  указаны
--   аргументы o и s, то запись происходит в корень.
-- @param name string - имя сохраняемой в  группе  настроек  переменной.
--   Если имя переменной не указано (name=nil) или пусто (name==""),  то
--   все строки записываются в корень текущей группы, аргумент  val  при
--   этом должен являться таблицей (массивом).
-- @param val any - сохраняемая переменная.
-- @param o userdata - Струкутура созданная функцией far.CreateSettings,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины, или в секцию данных другого плагина. Если пусто  (o==nil),
--   то группа открывается в корне настроек текущего плагина.
--
--   Внимение, если этот аргумент не пуст, то пользователю  нужно  будет
--   самому выполнить o:Free() после вызова данной функции.
-- @param s number - Номер подгруппы, созданный функцией obj:OpenSubkey,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины.  Если  данный  аргумент  не  пуст  (s~=nil),  то  значение
--   аргумента group игнорируется.  Если  аргумент  o  пуст,  то  данное
--   значение не используется. Если s==0, то строка создаётся в корне.
-- @return bool - результат выполнения функции:
--   - true - выполнено успешно
--   - false - выполнить не удалось
function settings.store(group, name, val, o, s)
    if group then checktype(group , 1, "string") end
    if name then checktype(name, 2, "string") end
    if o then checktype(o, 4, "userdata") end
    if s then checktype(s, 5, "number") end
    local res=false

    local tv = type(val)
    if name==nil or name=="" then
        if tv=="table" then
            for k,v in pairs(val) do
                res=settings.store(group, tostring(k), v, o, s)
                if res==false then break end
            end
        end
    elseif tv == "boolean" then
        -- Сохранённое в таком виде логическое значение выглядит некрасиво,
        -- но к сожалению API на данный момент таково, что это самый надёжный
        -- способ. Все остальные способы (например хранения в виде строки или 
        -- числа) приводят к путанице и ошибкам.
        res=storestring(group, name, string.format("return %s", tostring(val)), F.FST_DATA, o, s)
    elseif tv == "number" then
        if val == math.modf(val) then
            res=storestring(group, name, val, F.FST_QWORD, o, s)
        else
            res=storestring(group, name, string.format("return (%.17f * 2^%d)", math.frexp(val)), F.FST_DATA, o, s)
        end
    elseif tv == "string" then
        res=storestring(group, name, val, F.FST_STRING, o, s)
    elseif tv == "table" then
        local obj = o or far.CreateSettings()
        local subkey=nil

        if o and s then
            subkey = s
        elseif group~=nil and group~="" then
            subkey = obj:OpenSubkey(0, group)
        else
            subkey = 0
        end

        local subsubkey = obj:CreateSubkey(subkey, name)
        for k,v in pairs(val) do
            res=settings.store(name, tostring(k), v, obj, subsubkey)
            if res==false then break end
        end
        if not o then obj:Free() end
    end
    return res
end
-- @brief Сохранение переменной классическим способом.
-- @details При сохранении переменной в базе настроек она  сереализуется
--   и сохраняется как данные (hex). Восстанавливается так же  как  и  в
--   случае мтруктуированного сохранения функцией settings.restore().
--
--   Данная функция хоть и сохраняет переменные в неудобном  для  чтения
--   виде, зато  она  позволяет  хранить  массивы  с  индексами  в  виде
--   логических значений,  с  индексами  в  виде  таблиц  (это  когда  в
--   качестве индекса элемента выступает массив). Ну и врагам, если что,
--   непонятно, что там за данные.
--
--   Пример использования:
--
--    local options={
--        ["x"] = 25,
--        ["y"] = 15,
--        ["strings"] = {
--            "String1",
--            "String2",
--            "String3",
--        },
--        ["numbers"] = {1,2,4,8},
--        ["booleans"] = {true, false},
--        [true] = "boolean index (true)",
--        [false] = "boolean index (false)",
--        [{1,2,3}] = "table index",
--    }
--
--    settings.storeDump(nil, "myopts", options)
--    far.Message(settings.dump(settings.restore()))
--
-- @param group string - имя группы настроек. Если имя группы не указано
--   (group==nil), или равно пустой строке, и в то же время  не  указаны
--   аргументы o и s, то запись происходит в корен.
-- @param  name  string  -  имя  сохраняемой  переменной. 
-- @param o userdata - Струкутура созданная функцией far.CreateSettings,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины, или в секцию данных другого плагина. Если пусто  (o==nil),
--   то группа открывается в корне настроек текущего плагина.
--
--   Внимение, если этот аргумент не пуст, то пользователю  нужно  будет
--   самому выполнить o:Free() после вызова данной функции.
-- @param s number - Номер подгруппы, созданный функцией obj:OpenSubkey,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины.  Если  данный  аргумент  не  пуст  (s~=nil),  то  значение
--   аргумента group игнорируется.  Если  аргумент  o  пуст,  то  данное
--   значение не используется. Если s==0, то строка создаётся в корне.
-- @return any - восстановленные данные.
function settings.storeDump(group, name, val, o, s)
    if group then checktype(group , 1, "string") end
    checktype(name, 2, "string")
    if o then checktype(o, 4, "userdata") end
    if s then checktype(s, 5, "number") end
    return storestring(group, name, --
        string.format("return %s", settings.dump(val)), --
        F.FST_DATA, o, s)
end
-- @brief Восстановление переменной из базы настроек плагина.
-- @details Восстанавливает из базы настроек строки, числа, в том  числа
--   с запятой, логические переменные и таблицы.
-- @param group string - имя группы настроек. Если имя группы не указано
--   (group==nil), или равно пустой строке, и в то же время  не  указаны
--   аргументы o и s, то чтение происходит из корня.
-- @param  name  string  -  имя  востаннавливаемой  из  группы  настроек
--   переменной. Если имя переменной не  указано  (name=nil)  или  пусто
--   (name==""), то возвращаются все строки из текущей группы.
--
--   Функцию так же  можно  использовать  для  оперирования  настройками
--   других  плагинов,  например  изменение  и  извлечение  имени  файла
--   плагина LUA File List:
--
--     local val  = "filelist.bat"
--     local Guid = win.Uuid("0785F214-65B9-47B6-B9D8-F24FADC60AA0")
--     local obj  = far.CreateSettings(Guid)
--     local subkey = nil
--
--     if obj then
--         subkey = obj:OpenSubkey(0, "data")
--     end
--
--     settings.store("data", "filename", val, obj, subkey)
--
--     local b=settings.restore("data", "filename", obj, subkey)
--     obj:Free()
--
--     far.Message(settings.dump(b))
--
--   При желании переменную можно записать прямо в корень, и из корня её
--   так же прочесть. Причем переменная может  быть  любого  типа,  даже
--   таблицы. Например:
--
--     settings.store(nil, "RootVal", 1234)
--     local b = settings.restore(nil, "RootVal")
--     far.Message(settings.dump(b))
--
--   Так же можно разом сохранить все настройки одним массивом и извлечь
--   все настройки в массив разом:
--
--     local b={
--         block={
--             StartLine=2,
--             StartPos=1,
--             EndLine=5,
--             EndPos=0,
--         },
--         x=20,
--         y=30
--     }
--     set.store(nil, nil, b)
--     local res=set.restore()
--     far.Message(set.dump(res))
--
-- @param o userdata - Струкутура созданная функцией far.CreateSettings,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины, или в секцию данных другого плагина. Если пусто  (o==nil),
--   то группа открывается в корне настроек текущего плагина.
--
--   Внимение, если этот аргумент не пуст, то пользователю  нужно  будет
--   самому выполнить o:Free() после вызова данной функции.
-- @param s number - Номер подгруппы, созданный функцией obj:OpenSubkey,
--   по умолчанию nil, используется при записи значений в подгруппы иной
--   глубины.  Если  данный  аргумент  не  пуст  (s~=nil),  то  значение
--   аргумента group игнорируется.  Если  аргумент  o  пуст,  то  данное
--   значение не используется. Если s==0, то строка создаётся в корне.
-- @return any - восстановленные данные.
function settings.restore(group, name, o, s)
    if group then checktype(group , 1, "string") end
    if name then checktype(name, 2, "string") end
    if o then checktype(o, 3, "userdata") end
    if s then checktype(s, 4, "number") end

    local res=nil
    local subkey=nil
    local obj = o or far.CreateSettings()

    if o and s then
        subkey = s
    elseif group~=nil and group~="" then
        subkey = obj:OpenSubkey(0, group)
    else
        subkey = 0
    end

    if subkey then
        if name==nil or name=="" then
            res={}
            local enum=obj:Enum(subkey)
            for i = 1,enum.Count do 
                local idx=isnumeric(enum[i].Name)
                if not idx then 
                    idx=enum[i].Name
                end
                res[idx]=settings.restore(nil, enum[i].Name, obj, subkey)
            end
        else
            local tv=getType(name, obj, subkey)

            if tv==F.FST_QWORD then
                res=obj:Get(subkey, name, F.FST_QWORD)
            elseif tv==F.FST_STRING then
                res=obj:Get(subkey, name, F.FST_STRING)
            elseif tv==F.FST_DATA then
                local chunk = obj:Get(subkey, name, F.FST_DATA)
                if chunk then
                    res=assert(loadstring(chunk))()
                end
            elseif tv==F.FST_SUBKEY then
                local subsubkey = obj:OpenSubkey(subkey, name)
                res={}

                local enum=obj:Enum(subsubkey)

                for i = 1,enum.Count do
                    -- Если индекс содержит число, то преобразуем его в число
                    local idx=isnumeric(enum[i].Name)
                    if not idx then 
                        idx=enum[i].Name
                    end
                    res[idx]=settings.restore(name, enum[i].Name, obj, subsubkey)
                end
            end
        end
    end

    if not o then obj:Free() end
    return res
end
-- @brief Инициализация массива из базы настроек плагина.
-- @details Допустим у вас есть массив настроек  по  умолчанию,  в  базе
--   хранятся какие то настройки, часть из них из другой оперы, часть из
--   присутствующих настроек в массиве по умолчанию отсутствует, а часть
--   вообще другого типа. Особенно часто такое бывает,  после  изменения
--   кода макроса/плагина.  
--
--   Данная функция берет массив настроек по умолчанию, заменяет  в  нем
--   значения на найденные в базе настроек, и возвращает  как  результат
--   полный массив текущих настроек.  При  этом  если  тип  значений  не
--   совпадает, то значение остаётся по умолчанию. Например:
--
--    -- Допустим это ваш массив настроек по умолчанию после изменения кода
--      local defaults={
--          ["x"]=20,
--          ["y"]=10,
--          ["w"]=30,
--          ["h"]=20,
--          ["title"]={
--              ["dialog"]="Dialog title",
--              ["btnOk"]="&Ok",
--              ["btnCancel"]="&Cancel",
--          },
--      }
--      -- В базе настроек в реальности ещё с древних времен хранится вот это:
--      local real_settings={
--          ["x"] = 25,
--          ["y"] = "Надо же, я раньше числа в виде текста сохранял",
--          ["width"] = 300,
--          ["high"] = 200,
--          ["title"] = {
--              ["dialog"] = "Real Dialog title",
--          },
--          ["А это"] = "вообще что то из другой оперы",
--          ["Старьё"] = "я уж и забыл когда юзал эту опцию",
--      }
--
--      settings.storeInRoot("myopts", real_settings)
--
--      -- Инициализируем наш массив
--      local res=settings.initValues("myopts", defaults)
--      far.Message(settings.dump(res))
--
--      -- Получаем в итоге то что приемлимо
--      -- res == {
--      --     ["x"] = "25",
--      --     ["y"] = "10",
--      --     ["w"] = "30",
--      --     ["h"] = "20",
--      --     ["title"] = {
--      --         ["dialog"] = "Real Dialog title",
--      --         ["btnOk"] = "&Ok",
--      --         ["btnCancel"] = "&Cancel",
--      --     },
--      -- }
--
-- @param group string - имя группы в базе настроек плагина.
-- @param val table - массив (таблица) значений по умолчанию.
-- @param data table - массив (таблица)  действительных  значений,  если
--   data==nil, то  значения  берутся  из  группы  group  базы  настроек
--   плагина.
-- @return table - Инициализированный массив данных.
function settings.initValues(group, val, data)
    checktype(group, 1, "string")
    checktype(val, 2, "table")
    if data then checktype(data, 3, "table") end
    local res={}

    if data==nil then
        data = settings.restore(group)
        if type(data)~="table" then data={} end
    end

    for k,v in pairs(val) do
        --Т.к. у настроек  в  базе  все  индексы  -  строковые,  то  приходится
        --конвертировать индекс базового массива в строку.
        if data[k]~=nil and type(v)==type(data[k]) then
            if type(v)=="table" then
                res[k]=settings.initValues(group, v, data[k])
            else
                res[k]=data[k]
            end
        else
            res[k]=v
        end
    end

    return res
end

return settings
