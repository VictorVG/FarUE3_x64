local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {... or _filename,
  name          = "DBEdit";
  description   = "Импорт/экспорт/редактирование данных плагинов";
  version       = "2.1.7"; --в формате semver: http://semver.org/lang/ru/
  author        = "IgorZ";
  url           = "http://forum.farmanager.com/viewtopic.php?t=10120";
  id            = "51465236-592A-4C28-A047-929FCBFD8672";
  minfarversion = {3,0,0,4000,0}; --при несоответствии скрипт завершится
  files         = [[*Eng.hlf;*Rus.hlf;*Eng.lng;*Rus.lng]]; --вспомогательные файлы скрипта
  helptxt       = [=[
Управление:
  Alt+Shift+F2 - вызов главного меню
  Alt+Shift+F3 - вызов диалога импорта

Префиксы командной строки:
  dbshow:[<плагин>][корень]            - показ данных из БД умолчательного или указанного плагина ("<" и ">" обязательны)
  dbexp:[<плагин>][шаблон] [имя файла] - экспорт ключа/переменной из указанного плагина ("<" и ">" обязательны) по указанному шаблону или всей БД
  dbimp:[<плагин>][имя файла]          - импорт из указанного файла в указанный плагин ("<" и ">" обязательны) или вызов диалога импорта

Вызов, как модуля:
  require"DBEdit"([<таблица параметров>]) или require"DBEdit".Main([<таблица параметров>]). Поля таблицы:
    FileName - имя файла для импорта или экспорта; если не указано, при экспорте формируется по умолчанию, при импорте запрашивается;
    plugin   - имя плагина, данные которого обрабатываем;
    export   - шаблон имени экспортируемой переменной (переменных);
    import   - если истина, импортируем данные из файла;
    show     - если истина, показать всю БД, если таблица вида {"GLOBAL","IgorZ","'/' sample"} или строка вида "GLOBAL/IgorZ/'//' sample",
               показать дерево
  require"DBEdit".Show([<подключ>[,<плагин>]]). Показ данных из БД.
    Подключ - Строка или таблица, задаваемая аналогично show в первом варианте. Если не задан, выводится корень.
    Плагин  - Строка, имя плагина, базу которого следует показать. Если плагин не указан, берётся БД текущего
              (или LuaMacro, если плагин ещё не выбирался).
  require"DBEdit".Import([<файл>[,<плагин>]]). Импорт из файла в БД.
    Файл    - строка, имя файла для импорта. Если не указано, запрашивается.
    Плагин  - Строка, имя плагина, в базу которого следует импортировать содержимое файла. Если плагин не указан, берётся БД текущего
              (или LuaMacro, если плагин ещё не выбирался).
  require"DBEdit".Export([<образец>][,<файл>[,<плагин>]]]). Экспорт из БД в файл по шаблону.
    Образец - строка. Имена переменных и ключей, совпадающие с образцом, будут экспортироваться. Если не задан, экспортируется всё.
    Файл    - строка, имя файла для экспорта. Если не указано, составляется автоматически из текущего пути, имени плагина, шаблона
              и расширения .dbedit.
    Плагин  - строка, имя плагина, из базы которого следует экспортировать содержимое в файл. Если плагин не указан, берётся БД текущего
              (или LuaMacro, если плагин ещё не выбирался).
]=];
history         = [[
2016/03/03 v1.0.0 - Первый релиз.
2016/03/04 v1.0.1 - Добавлен выбор действия, если импортируемая переменная существует. Убрано сообщение об ошибке в случае отказа пользователя.
2016/03/15 v2.0.0 - Скрипт поменял название, префиксы командной строки тоже изменились. Добавлена возможность создавать, редактировать и удалять
                    переменные в базе. Добавлена возможность выбора плагина. При экспорте из командной строки можно указать шаблон
                    экспортируемого ключа или переменной, и всё, подходящее под шаблон, будет экспортировано. Рефакторинг, мелкие правки.
2016/05/11 v2.0.1 - Если локальная или глобальная БД плагина пуста, отрывается сразу корень другой. Переход на выбор LOCAL/GLOBAL - CtrlPgUp.
                    Вывод в заголовке текущего местоположения. Для типа данных F.FST_DATA выводится также значение. Различные правки.
2016/05/12 v2.0.2 - Исправлена ошибка со значением переменннй типа FST_DATA, не приводящимся к функции. Экспериментально: при вызове
                    из меню плагинов выводится меню выбора БД. Рефакторинг, исправление мелких ошибок, вылезших в последней версии.
2016/05/18 v2.0.3 - Расширенное меню выбора плагина.
2016/10/12 v2.1.0 - Скрипт можно использовать как модуль. Исправлена область действия в MenuItem. Разделение префиксов. Переделана справка.
                    Добавлено nfo. Мелкие правки.
2016/10/31 v2.1.1 - При вызове модуля можно, указав неверное имя, вызвать меню выбора плагина. CtrlPgUp из меню выбора профиля вызывает
                    меню выбора плагина. Модуль теперь возвращает таблицу функций (старый вариант вызова сохранён). Изменён способ регистрации модуля.
                    Если при вызове модуля в режиме показа не указан явно тип БД (LOCAL/GLOBAL), то скрипт сам выбирает наилучший вариант.
                    CtrlC/CtrlG/CtrlL переходят в тот  же ключ в другой/глобальной/локальной базе. Рефакторинг. Мелкие правки.
2016/11/16 v2.1.2 - Enter на значении открывает редактирование элемента. Backspace работает как Esc. Рефакторинг. Мелкие правки.
2018/11/06 v2.1.3 - Добавлен префикс dbshow:. Для dbexp: можно задавать имя файла. Исправлены ошибки в справке. Рефакторинг.
2019/12/10 v2.1.4 - Доработан вызов action-функций с учётом введённых в build 717 параметров для condition/action. Рефакторинг.
2020/04/21 v2.1.5 - Исправлена ошибка с обработкой действий в пустом подключе. Переделана обработка FST_DATA. Рефакторинг.
2020/04/22 v2.1.6 - Исправлена ошибка с неюникодной строкой значения типа FST_DATA.
2021/06/04 v2.1.7 - Исправлена ошибка с переключением БД между локальной и глобальной, когда переключать нечего. Добавлен перехват CtrlBreak.
]];
  options       = {
    tbl_format = "internal", -- чем форматировать таблицы по умолчанию
    PName      = "LuaMacro", -- открываемый плагин по умолчанию
  }
}
if not nfo then return nfo end
-- +
--[==[Константы]==]
-- -
local F = far.Flags
local Guids = {
  LuaMacro = win.Uuid("4EBBEFC8-2084-4B7F-94C0-692CE136894D"); -- guid LuaMacro
  ExpMacro = "846AE8E5-5A00-4A62-B7A7-0846B1D40946",
  ImpMacro = "C62CC94A-89F1-4C3F-8F0E-64A998D387AB",
  PlugMenu = "31495183-8AD8-4CFE-B228-9C24CDF2C630",
  diEdit   = win.Uuid("B1C95DD2-636F-4D63-8D75-1E1905FDAD4C"),
  Menu     = win.Uuid("85F3972E-0C71-4A45-A91D-E44DD52B91A2"),
  ExpFN    = win.Uuid("896AA787-16D2-41B8-9678-73EF33AE18EE"),
  ImpFN    = win.Uuid("1CC55C37-3642-4E44-8943-B16F51A0367A"),
--  ImpOW    = win.Uuid("0251977A-AA09-4D07-B6E5-2F367CD8EBEE"),
  SelPlug  = win.Uuid("234AEF34-B8FF-4995-97FE-E527271712A9"),
}
local LMBuild = far.GetPluginInformation(far.FindPlugin(F.PFM_GUID,Guids.LuaMacro)).GInfo.Version[4] -- запомним версию LuaMacro
local PathName = debug.getinfo(function()end).source:match("^@?([^@].*)%.[^%.\\]+$") -- путь и имя без расширения
-- +
--[==[переменные]==]
-- -
local O,UID,overwrite,L = nfo.options -- линк на опции, GUID открываемого плагина,перезапись переменных,локализация
-- +
--[=[вспомогательные функции]=]
-- -
local LoadLang,GetTree,PutElem,SaveToFile,ReadFromFile,Edit,Remove,ReadDB,SelPlugin,DATAToStrings,ElemToStr,ShowHelp
--
function LoadLang() --[[загрузить настройки языка]]
local FL,dummy = Far.GetConfig("Language.Main"):sub(1,3),function() return {"Cannot find language files"} end -- язык, пустая функция
L = L and L.Lang==FL and L or (loadfile(PathName..FL..".lng") or loadfile(PathName.."Eng.lng") or dummy)(LMBuild) -- обновим, если язык другой
end --LoadLang
--
function GetTree(obj,id,parent) --[[прочитаем поддерево]]
local list,res = obj:Enum(id),{} -- список элементов поддерева, результат
for _,v in ipairs(list) do -- переберём все
  local item = v.Type==F.FST_SUBKEY and GetTree(obj,obj:OpenSubkey(id,v.Name),parent.."\n"..v.Name) or obj:Get(id,v.Name,v.Type) -- очередной элемент
  res[v.Name] = {name=v.Name,type=v.Type,value=item,parent=parent} -- запишем в таблицу
end
return res,#list -- вернём результат и количество элементов в корне дерева
end
--
function PutElem(obj,key,elem) --[[запишем элемент или поддерево]]
if elem.type==F.FST_SUBKEY then -- таблица?
  key = obj:CreateSubkey(key,elem.name) -- откроем/создадим раздел
  for _,v in pairs(elem.value) do if PutElem(obj,key,v) then return true end end -- вызовем себя с каждым элементом, если была отмена, то выйти выше
else -- переменная
  local oldval,WR = obj:Get(key,elem.name,elem.type),true -- старое значение, признак записи
  if oldval then -- если есть
    if overwrite==nil then -- если действие по умолчанию не определено
      local res = far.Message(L.diImpOW:format(elem.name,elem.parent,oldval,elem.value),L.diImp,L.diImpOWBtns,"l") -- запросим вариант
      if res==1 then WR = true -- перезаписать
      elseif res==2 then WR = true overwrite = WR -- перезаписать все
      elseif res==3 then WR = false -- пропустить
      elseif res==4 then WR = false overwrite = WR -- пропустить все
      else return true end -- отмена
    else -- есть действие по умолчанию, примем
      WR = overwrite
    end
  end
  if WR then obj:Set(key,elem.name,elem.type,elem.value) end -- запишем её, если не было иного мнения
end
end
--
function SaveToFile(tbl,fname,key) --[[сохраним поддерево в файл]]
--
local function SaveOne(file,elem,i0) --сохраним очередной элемент
local indent = (" "):rep(elem.parent:len()+2) -- отступ для него
i0 = i0 or ""
local s1 = i0..("[%s]\n%sName = %s\n%sType = %d\n%sValue = "):format(elem.parent,indent,elem.name,indent,elem.type,indent):gsub("\n","\n"..i0)
if elem.type==F.FST_SUBKEY then -- таблица?
  file:write(s1.."\n") -- запишем шапку
  for _,v in pairs(elem.value) do SaveOne(file,v,indent..i0) end -- вызовем себя с каждым элементом таблицы
else
  file:write(s1..tostring(elem.value):gsub("\n","\\n").."\n") -- добавим значение к шапке и запишем
end
end -- SaveOne
--
local function ScanTbl(elem,file) -- поищем заданный подключ/значение
if elem.name:upper():find(key,1,true) then -- нашли?
  SaveOne(file,elem) -- сохраним в файл
else -- не тот
  if elem.type==F.FST_SUBKEY then -- таблица?
    for _,v in pairs(elem.value) do ScanTbl(v,file) end -- поищем в каждом элементе таблицы
  end
end
end -- ScanElem
-- начало SaveToFile
if not fname then return nil,L.Err.NoFN end -- не указано имя файла? уйдём
local mode,attr = "w",win.GetFileAttr(fname)
if attr then -- файл существует?
  if attr:match("d") then return nil,L.Err.IsDir..fname..'"' end
  local res = far.Message(L.Err.Exist..fname..'"',L.diExp,L.diExpBtns)
  if not res or res>2 then return nil,L.Err.Cancel end
  if res==1 then mode = "a" end
end
local file = io.open(fname,mode) -- создадим файл
if not file then return nil,L.Err.NoOpen..fname..'"' end -- не создался? уйдём
if key then -- сохранить указанный ключ?
  key = key:upper() -- приведём искомое к верхнему регистру
  ScanTbl(tbl.GLOBAL,file) -- сохраним из глобального профиля
  ScanTbl(tbl.LOCAL,file) -- сохраним из локального профиля
else
  SaveOne(file,tbl) -- сохраним поддерево, начиная с заданного элемента
end
file:close() -- закроем файл
return true -- благополучное завершение
end -- SaveToFile
--
function ReadFromFile(fname) --[[прочитаем файл в таблицу]]
if fname then -- делаем?
  local file,err = io.open(fname,"r") -- откроем файл
  if file then -- создался? работаем
    local text = file:read("*a")
    file:close() -- закроем файл
    local res = {} -- возвращаемая таблица
    for s1 in text:gmatch(" *%[.-%]\n%s*Name = [^\n]+\n%s*Type = %d+\n%s*Value = [^\n]*") do -- очередная запись
      local ind,par,name,type,value = s1:match("( *)%[(.-)%]\n%s*Name = ([^\n]+)\n%s*Type = (%d+)\n%s*Value = ([^\n]*)") -- разберём
      type,par = tonumber(type),par:gsub("\n"..ind,"\n") -- тип преобразуем в число, выкинем отступы
      local ptr = res -- установим указатель на корень таблицы
      for ss in (par.."\n"):gmatch("([^\n]+)\n") do -- переберём все составляющие полного имени родительской папки
        if not ptr[ss] then ptr[ss] = {name=ss,type=F.FST_SUBKEY,value={}} end -- такой подтаблицы ещё нет? вставим её
        ptr = ptr[ss].value -- спозиционируемся на подтаблицу
      end
      ptr[name] = {name=name,type=type,parent = par} -- запишем имя, тип элемента и родительский ключ
      if type==F.FST_SUBKEY then -- подключ?
        if value~="" then -- для подключа указано значение?
          local _,n1 = text:sub(1,text:cfind(s1,1,true)-1):gsub("\n","") -- посчитаем количество строк до
          local _,n2 = s1:gsub("\n","") -- и количество строк в нём
          return nil,L.Err.EF1..(n1+1)..L.Err.EF2..(n1+n2+1)..L.Err.EF3..s1.."\n\n"..L.Err.SubVal -- вернём сообщение об ошибке
        end
        ptr[name].value = {} -- подтаблица для содержимого подключа
      else -- переменная
        ptr[name].value = type==F.FST_QWORD and tonumber(value) or value:gsub("\\n","\n") -- запишем с восстановлением изначального вида
      end
    end
    return res
  else
    return nil,L.Err.NoOpen..fname..'". '..err
  end
else
  return nil,L.Err.NoFN
end
end -- readFromFile
--
function Edit(elem,action) --[[изменить/скопировать/создать переменную]]
--
local CurrVal,CurrElem,ov = elem.value
local Hdr = L.diEdit.Hdr[action]:format(L.diEdit[elem.parent:match("^[^\n]*")]) -- выберем заголовок
local h = elem.type==F.FST_DATA and 20 or elem.type==F.FST_SUBKEY and 9 or 10 -- отрегулируем высоту окна
local screen = far.SaveScreen()
--
local form = { -- диалог редактирования
--[[01]] {F.DI_DOUBLEBOX,   3, 1  ,62, h-2,0,0,0,0,Hdr},
--[[02]] {F.DI_TEXT,        5, 2  , 0, 2  ,0,0,0,0,L.diEdit.Parent},
--[[03]] {F.DI_EDIT,       19, 2  ,60, 2  ,0,0,0,action~="Copy" and F.DIF_READONLY+F.DIF_NOFOCUS or 0,(elem.parent:gsub("\n","/"))},
--[[04]] {F.DI_TEXT,        5, 3  , 0, 3  ,0,0,0,0,L.diEdit.Name},
--[[05]] {F.DI_EDIT,       19, 3  ,60, 3  ,0,0,0,action=="Edit" and F.DIF_READONLY+F.DIF_NOFOCUS or 0,elem.name},
--[[06]] {F.DI_TEXT,        5, 4  , 0, 4  ,0,0,0,0,L.diEdit.Type},
--[[07]] {F.DI_COMBOBOX,   19, 4  ,59, 4  ,L.diEdit.Types,0,0,action=="New" and F.DIF_DROPDOWNLIST or F.DIF_READONLY+F.DIF_NOFOCUS,
                                           L.diEdit.Types[elem.type].Text},
--[[08]] {F.DI_TEXT,        5, 5  , 0, 5  ,0,0,0,0,L.diEdit.Value},
--[[09]] {F.DI_EDIT,       19, 5  ,60, 5  ,0,0,0,(elem.type==F.FST_DATA or elem.type==F.FST_SUBKEY) and F.DIF_HIDDEN or
                                                  action=="Copy" and F.DIF_READONLY+F.DIF_NOFOCUS or 0,CurrVal},
--[[10]] {F.DI_TEXT,       19, 5  ,60, 5  ,0,0,0,elem.type~=F.FST_DATA and F.DIF_HIDDEN or 0,L.diEdit.F4},
--[[11]] {F.DI_USERCONTROL, 5, 6  ,60,15  ,0,0,0,elem.type~=F.FST_DATA and F.DIF_HIDDEN or 0},
--[[12]] {F.DI_TEXT,       -1, h-4, 0, h-4,0,0,0,F.DIF_SEPARATOR,""},
--[[13]] {F.DI_BUTTON,      0, h-3, 0, h-3,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[14]] {F.DI_BUTTON,      0, h-3, 0, h-3,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
--
local function DlgProc (hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_KILLFOCUS and Param1==3 then -- уход с родителя?
  local lg,path = hDlg:send(F.DM_GETTEXT,Param1):match("^([^/]*)(.-)$") -- разделим на указание профиля и остаток
  hDlg:send(F.DM_SETTEXT,Param1,(lg:upper()=="LOCAL" or lg:upper()=="GLOBAL") and lg:upper()..path or ov) -- переведём в заглавные или откатим
elseif Msg==F.DN_EDITCHANGE and Param1==7 then -- изменение типа
  local nv = Param2[6].SelectIndex
  if nv~=ov then
    h = nv==F.FST_DATA and 20 or nv==F.FST_SUBKEY and 9 or 10 -- отрегулируем высоту окна
    CurrVal = ""
    hDlg:send(F.DM_SETTEXT,9,CurrVal)
    hDlg:send(F.DM_SHOWITEM,9,(nv==F.FST_DATA or nv==F.FST_SUBKEY) and 0 or 1)
    hDlg:send(F.DM_SHOWITEM,10,nv==F.FST_DATA and 1 or 0)
    hDlg:send(F.DM_SHOWITEM,11,nv==F.FST_DATA and 1 or 0)
    hDlg:send(F.DM_RESIZEDIALOG,0,{X=66,Y=h})
    hDlg:send(F.DM_SETITEMPOSITION,1,{Left=3,Top=1,Right=62,Bottom=h-2})
    hDlg:send(F.DM_SETITEMPOSITION,12,{Left=-1,Top=h-4,Right=0,Bottom=h-4})
    local rect = hDlg:send(F.DM_GETITEMPOSITION,13)
    hDlg:send(F.DM_SETITEMPOSITION,13,{Left=rect.Left,Top=h-3,Right=rect.Right,Bottom=h-3})
    rect = hDlg:send(F.DM_GETITEMPOSITION,14)
    hDlg:send(F.DM_SETITEMPOSITION,14,{Left=rect.Left,Top=h-3,Right=rect.Right,Bottom=h-3})
    far.RestoreScreen(screen)
    screen = far.SaveScreen()
  end
elseif Msg==F.DN_KILLFOCUS and Param1==9 and far.GetDlgItem(hDlg,7)[6].SelectIndex==F.FST_QWORD then -- уход с численного значения?
  if not tonumber(hDlg:send(F.DM_GETTEXT,Param1)) then hDlg:send(F.DM_SETTEXT,Param1,ov) end -- не число - откатим
elseif Msg==F.DN_DRAWDLGITEM and Param1==11 then -- рисуем вручную FST_DATA
  local strings,rect,vt = {},hDlg:send(F.DM_GETDLGRECT,0),DATAToStrings({value=CurrVal,name=""}) -- текст по строкам, окно диалога, значение
  local C = far.AdvControl(F.ACTL_GETCOLOR,CurrElem==Param1 and far.Colors.COL_DIALOGEDITUNCHANGED or far.Colors.COL_DIALOGEDIT) -- цвет текста
  local Left,Top,Height,Width = rect.Left+Param2[2],rect.Top+Param2[3]-1,Param2[5]-Param2[3]+1,Param2[4]-Param2[2]+1 -- координаты области вывода
  for s in ((vt.str or vt.dump).."\n"):gmatch("(.-)\n") do -- разберём по строкам
    strings[#strings+1] = s:gsub("(.-)(\t)",function(p1) return p1..(" "):rep(8-p1:len()%8) end)
  end
  for i = 1,Height do -- выведем, что влезет, дополнив пробелами
    far.Text(Left,Top+i,C,((strings[i] or "")..(" "):rep(Width)):sub(1,Width))
  end
elseif Msg==F.DN_CONTROLINPUT and Param1==11 and (Param2.VirtualKeyCode==0x73 and band(Param2.ControlKeyState,0x1f)==0) then -- F4
  local tmpname = far.MkTemp()..".lua" -- временный файл
  local hfile = io.open(tmpname,"w") hfile:write(CurrVal) hfile:close() -- заполним файл
  local dr = hDlg:send(F.DM_GETDLGRECT,0) -- окно диалога
  editor.Editor(tmpname,"["..hDlg:send(F.DM_GETTEXT,3).."]"..hDlg:send(F.DM_GETTEXT,5), -- отредактируем через дырочку
    dr.Left+4,dr.Top+2,dr.Right-4,dr.Bottom-2,F.EF_DISABLEHISTORY+F.EF_DISABLESAVEPOS)
  hfile = io.open(tmpname,"r") CurrVal = hfile:read("*a") hfile:close() -- новое значение
  win.DeleteFile(tmpname) -- больше не нужен
  hDlg:send(F.DM_REDRAW) -- обновим экран
elseif Msg==F.DN_GOTFOCUS then -- переход на элемент?
  CurrElem,ov = Param1,hDlg:send(F.DM_GETTEXT,Param1) -- запомним текущий элемент и старое значение
elseif Msg==F.DN_CONTROLINPUT and (Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0) then -- F1
  return true,ShowHelp("Edit")
elseif Msg==F.DN_CLOSE then -- закрываем диалог?
  far.SendDlgMessage(hDlg,"DM_SETFOCUS",13) -- переключимся на кнопку
end
end
-- начало тела функции Edit
form[7][6].SelectIndex = elem.type -- поправим - надо
if far.Dialog(Guids.diEdit,-1,-1,66,h,nil,form,nil,DlgProc)~=13 then return end -- вызовем диалог, не "ОК" - уйдём
local pr,nm,tp,tbl = form[3][10]:gsub("/","\n"),form[5][10],form[7][6].SelectIndex,{} -- родитель, имя, тип, временная таблица
local ptr = tbl -- установим указатель на корень таблицы
for sk in (pr.."\n"):gmatch("([^\n]+)\n") do -- переберём все составляющие полного имени родительской папки
  ptr[sk] = {name=sk,type=F.FST_SUBKEY,value={}} -- такой подтаблицы ещё нет, вставим её
  ptr = ptr[sk].value -- спозиционируемся на подтаблицу
end
local val = ({[F.FST_DATA]=CurrVal,[F.FST_SUBKEY]={},[F.FST_QWORD]=tonumber(form[9][10]),[F.FST_STRING]=form[9][10]})[tp] -- значение
ptr[nm] = {name=nm,type=tp,parent=pr,value=val} -- запишем данные в таблицу
for n,v in pairs(tbl) do
  local obj,oldow = far.CreateSettings(UID,n=="LOCAL" and F.PSL_LOCAL or F.PSL_ROAMING),overwrite -- откроем данные
  overwrite = true -- установим признак перезаписи
  for _,value in pairs(v.value) do PutElem(obj,0,value) end -- запишем
  overwrite = oldow -- восстановим признак перезаписи
  obj:Free() -- закроем
end
end -- Edit
--
function Remove(elem) --[[удалить переменную или подключ со всем содержимым]]
if far.Message(L.DelVar:format(elem.name,(elem.parent:gsub("\n","/")),ElemToStr(elem,0)),L.Hdr:format(O.PName),";OkCancel","l")~=1 then return end
local obj,key = far.CreateSettings(UID,elem.parent:match("^[^\n]*")=="LOCAL" and F.PSL_LOCAL or F.PSL_ROAMING),0 -- откроем нужный профиль
for sk in elem.parent:gmatch("\n([^\n]*)") do key = obj:OpenSubkey(key,sk) end -- спозиционируем key на подраздел, содержащий удаляемое
if elem.type==F.FST_SUBKEY then -- это подключ?
  obj:Delete(obj:OpenSubkey(key,elem.name)) -- удалим его
else
  obj:Delete(key,elem.name) -- удалим данный элемент
end
obj:Free() -- закроем профиль
end -- Remove
--
function ReadDB() --[[прочитать данные из БД]]
local tbl = {LOCAL={name="LOCAL",type=F.FST_SUBKEY,parent=""},GLOBAL={name="GLOBAL",type=F.FST_SUBKEY,parent=""}} -- таблица с данными
local obj = far.CreateSettings(UID,F.PSL_ROAMING) -- откроем глобальные данные
tbl.GLOBAL.value,tbl.GLOBAL.n = GetTree(obj,0,tbl.GLOBAL.name) -- выдернем в таблицу
obj:Free() -- закроем
obj = far.CreateSettings(UID,F.PSL_LOCAL) -- откроем локальные данные
tbl.LOCAL.value,tbl.LOCAL.n = GetTree(obj,0,tbl.LOCAL.name) -- выдернем в таблицу
obj:Free() -- закроем
return tbl -- вернём данные
end -- ReadDB
--
function SelPlugin(name) --[[выбрать БД]]
local n,list,ext,res = 1 -- № текущего плагина в списке, список плагинов, расширенный режим работы, результат
repeat
  list = {}
  for _,p in ipairs(far.GetPlugins()) do -- переберём все плагины
    local pinfo = far.GetPluginInformation(p) -- информация об очередном
    if pinfo then -- а вдруг сбой был? плагин в списке остался, а так его нет...
      local pt,pu = pinfo.GInfo.Title,pinfo.GInfo.Guid
      if name and name:upper()==pt:upper() then O.PName,UID = pt,pu return true end -- ищем этот плагин? Уже
      if ext then -- расширенный список?
        local objg,objl = far.CreateSettings(pu,F.PSL_ROAMING),far.CreateSettings(pu,F.PSL_LOCAL) -- откроем БД
        local lg = (#objl:Enum(0)>0 and"L " or "  ")..(#objg:Enum(0)>0 and"G  " or "   ") -- признак наличия данных
        objg:Free() objl:Free() -- закроем БД
        if lg:match(ext) then list[#list+1] = {name=pt,uid=pu,text=lg..pt} end -- добавим в список
      else
        list[#list+1] = {name=pt,uid=pu,text=pt} -- добавим в список
      end
    end
  end
  table.sort(list,function(a,b) return a.name:upper()<b.name:upper() end) -- отсортируем по имени
  for i,v in ipairs(list) do if v.name==O.PName then n = i end end -- найдём текущий
  res = far.Menu({Title=L.PlugMenu,Bottom="Enter,Esc,F1,CtrlA/L/G/F/S",SelectIndex=n,Id=Guids.SelPlug,Flags=F.FMENU_SHOWAMPERSAND+F.FMENU_WRAPMODE},
    list,{{BreakKey="F1"},{BreakKey="C+A"},{BreakKey="C+G"},{BreakKey="C+L"},{BreakKey="C+F"},{BreakKey="C+S"}}) -- меню
  if not res then return false end -- Esc
  if not res.BreakKey then O.PName,UID = res.name,res.uid return true end -- Enter
  if res.BreakKey=="F1" then ShowHelp("PSel") -- F1 - help
  else ext = ({A="",L="L",G="G",F="%w"})[res.BreakKey:sub(3,3)] end
until false
end -- SelPlugin
--
function DATAToStrings(elem) --[[Раскрыть FST_DATA в строки]]
--
local function AddOne(array,val,name,level,slist,parent) -- добавим значение, раскрутим, если таблица
local indent,links = "    ",{[_G]="_G",[_G.far.Flags]="far.Flags",[_G.far.Colors]="far.Colors"}
if type(parent)=="table" and type(name)~="string" then name = "["..tostring(name).."]" end
local s0 = ("%s<%-9s %s = "):format(indent:rep(level),type(val)..">",name) -- начало строки
for a,s in pairs(links) do if val==a then array[#array+1] = s0.."-> "..s links = nil break end end
if links then
  local q = type(val)=="string" and '"' or ''
  array[#array+1] = s0..q..tostring(val)..q -- добавим строку
  if type(val)=="table" then -- вызовем себя с каждым элементом, если таблица. Или нарисуем ссылку, если она уже была
    local tname -- имя таблицы-предка
    for a,n in pairs(slist) do if val==a then tname = n break end end -- если таблица ссылается на одну из уже развёрнутых, запомним
    if tname then -- такая таблица уже есть в списке?
      array[#array] = s0:sub(1,-3)..(slist[parent]:match("^"..tname) and "-^ " or "-> ")..tname -- исправим текст
    else -- не предок
      slist[val] = (slist[parent] and slist[parent]..(name:sub(-1)=="]" and "" or ".") or "")..name -- запомним в списке развёрнутых таблиц
      array[#array+1] = indent:rep(level+1).."{"
      for n,v in pairs(val) do AddOne(array,v,n,level+1,slist,val) end -- вызовем себя с каждым элементом таблицы
      array[#array+1] = indent:rep(level+1).."}"
    end
  end
end
end
-- начало DATAToStrings
local res,fun,ok,ext_fun = {},(loadstring(elem.value)) -- массив строк (результат), функция, результат получения и сама функция форматирования
res.str,res.dump = _G.unicode.utf8.utf8valid(elem.value) and elem.value:gsub("\n","\\n"),"["..table.concat({string.byte(elem.value,1,-1)},",").."]"
if O.tbl_format=="inspect" then ok,ext_fun = pcall(require,"inspect") ext_fun = ok and ext_fun end
if O.tbl_format=="dump" then ok,ext_fun = pcall(require,"moon") ext_fun = ok and ext_fun.dump end
if ext_fun then
  if fun then for s1 in ext_fun(fun(),{indent="    "}):gmatch("[^\n]+") do res[#res+1] = s1 end end -- прокрутим
else
  if fun then AddOne(res,fun(),elem.name,0,{}) end -- прокрутим
end
return res -- вернём результат
end -- DATAToStrings
--
function ElemToStr(elem,indent) --[[раскроем элемент в (мульти)строку, раскрутим, если таблица]]
local q,t = elem.type~=F.FST_QWORD and '"' or "",{[F.FST_DATA]="data",[F.FST_QWORD]="number",[F.FST_STRING]="string",[F.FST_SUBKEY]="subkey"}
local s = ("    "):rep(indent).."<"..t[elem.type].."> "..elem.name.." = " -- шапка - строка без значения
if elem.type==F.FST_SUBKEY then -- таблица?
  s = s.."\n"..("    "):rep(indent+1).."{".."\n" -- шапка и открытие таблицы
  for _,v in pairs(elem.value) do s = s..ElemToStr(v,indent+1).."\n" end -- вызовем себя с каждым элементом таблицы
  s = s..("    "):rep(indent+1).."}" -- закроем таблицу
else
  s = s..q..tostring(elem.value)..q -- шапка и значение
end
return s
end
--
function ShowHelp(text) --[[Вывести справку]]
local HL = Far.GetConfig("Language.Help"):sub(1,3) -- язык (первые 3 буквы)
far.ShowHelp(PathName..(win.GetFileAttr(PathName..HL..".hlf") and HL or "Eng")..".hlf",text,F.FHELP_CUSTOMFILE) -- выведем
end --ShowHelp
--
if type(nfo)=="table" then nfo.help = function() ShowHelp() end end
-- +
--[==[Основные функции]==]
-- -
local ShowMenu,Save,Restore,CLProc,ModProc
-- +
--[==[Показать меню]==]
-- -
function ShowMenu(root)
--
local History,Bottom,pos,res = {},"Enter,Esc,F1,F2,F3,F4,F5,F10,Ins,Del,CtrlPgUp,CtrlS,CtrlC/G/L",1 -- история, подсказка, позиция, результат
local HotKeys = {{BreakKey="F1"},{BreakKey="F2"},{BreakKey="F3"},{BreakKey="F4"},{BreakKey="F5"},{BreakKey="F10"},{BreakKey="INSERT"}, -- hotkeys
  {BreakKey="NUMPAD0"},{BreakKey="DELETE"},{BreakKey="DECIMAL"},{BreakKey="C+PRIOR"},{BreakKey="C+NUMPAD9"},{BreakKey="C+S"},{BreakKey="C+C"},
  {BreakKey="C+L"},{BreakKey="C+G"},{BreakKey="C+1"},{BreakKey="C+2"},{BreakKey="C+3"},{BreakKey="BACK"},{BreakKey="ESCAPE"},{BreakKey="RETURN"}}
--
LoadLang() -- обновим язык
repeat
  local tbl,r2 = ReadDB(),"" -- прочитаем БД
  if tbl.GLOBAL.n>0 and tbl.LOCAL.n==0 then root = root or "GLOBAL" -- если одного раздела нет, переведём корень сразу в другой
  elseif tbl.LOCAL.n>0 and tbl.GLOBAL.n==0 then root = root or "LOCAL" end
  if root and root~="" and not tbl[root:match("^[^\n]+")] then -- корень начинается не с LOCAL/GLOBAL?
    local rtbl,lr,gr = tbl,"",""
    for sk in ("LOCAL\n"..root):gmatch("([^\n]+)") do if tbl[sk] then tbl,lr = tbl[sk].value,lr..sk.."\n" else break end end -- корень в локальной БД
    tbl = rtbl
    for sk in ("GLOBAL\n"..root):gmatch("([^\n]+)") do if tbl[sk] then tbl,gr = tbl[sk].value,gr..sk.."\n" else break end end -- корень в локальной БД
    tbl = rtbl
    if root==lr:gsub("^LOCAL\n","") and root~=gr:gsub("^GLOBAL\n","") then root = lr
    elseif root~=lr:gsub("^LOCAL\n","") and root==gr:gsub("^GLOBAL\n","") then root = gr
    else root = "GLOBAL\n"..root end
  end
  if root then for sk in root:gmatch("([^\n]+)") do if tbl[sk] then tbl,r2 = tbl[sk].value,r2..sk.." / " else break end end end -- найдём корень
  local items,NL = {},0
  for _,v in pairs(tbl) do items[#items+1] = {text=v.name,elem=v} NL = math.max(NL,v.name:len()) end -- сформируем заготовку меню
  table.sort(items,function(a,b) return a.elem.type..a.text<b.elem.type..b.text end) -- отсортируем по типу и по имени
  for i,v in ipairs(items) do -- добавим в пункты меню значения переменных (или "" для подключей)
    local et,ev,vv = v.elem.type,v.elem.value -- тип значения, само значение, значение в виде строки
    vv = et==F.FST_STRING and ev:gsub("\n","\\n") or et==F.FST_QWORD and tostring(ev) or et==F.FST_SUBKEY and "" or "" -- вычислим
    if not v.add then v.text = ("%-"..NL.."s│".."%s"):format(v.text,vv) end -- если это не дополнительная строка, впишем строку для меню
    if not v.add and et==F.FST_DATA then -- если это не дополнительная строка, для FST_DATA добавим расшифровку
      vv = DATAToStrings(v.elem) v.text = v.text..(vv.str or "") -- получим расшифровку и добавим саму строку, если корректна, к строке для меню
      table.insert(items,i+1,{text=(" "):rep(NL).."│"..vv.dump,add=true,elem=v.elem}) -- добавим дамп строки
      for j,w in ipairs(vv) do table.insert(items,i+j+1,{text=(" "):rep(NL).."│"..w,add=true,elem=v.elem}) end -- добавим собственно расшифровку
    end
  end
  res,pos = far.Menu({Title=L.Hdr:format(O.PName)..": "..(root and r2 or ""),Bottom=Bottom,SelectIndex=pos,Id=Guids.Menu,
    Flags=F.FMENU_SHOWAMPERSAND+F.FMENU_WRAPMODE},items,HotKeys) -- меню
    local BK,item = res and res.BreakKey or "",items[pos] and items[pos].elem or {name="",type=F.FST_UNKNOWN,value="",parent=root} -- клавиша, элемент
  if BK=="RETURN" and item.type~=F.FST_SUBKEY then BK = "F4" end -- Enter на значении подменим на F4
  if BK=="ESCAPE" or BK=="BACK" then-- Esc/BS
    local n = #History if n>0 then root,pos,History[n] = History[n].r,History[n].p,nil else break end -- предыдущая позиция/выход.
  elseif BK=="RETURN" then -- Enter на подкюче
    root,pos,History[#History+1] = (item.parent.."\n"..item.name):gsub("^\n",""),1,{r=root,p=pos} -- зайти в подключ, запомнить текущий
  elseif BK=="F1" then -- F1 - выведем справку
    ShowHelp("Main")
  elseif items[pos] and BK=="F2" then -- сохранить то, что под курсором?
    local name = APanel.Path.."\\"..O.PName.."."..item.name..".dbedit" -- имя файла по умолчанию
    name = far.InputBox(Guids.ExpFN,L.diExp,L.diGetFN,"ImpExpFileHistory",name,nil,nil,F.FIB_BUTTONS+F.FIB_EDITPATH+F.FIB_EXPANDENV) -- и настоящее
    local sres,err = SaveToFile(item,name) -- сохраним
    if not sres then if err~=L.Err.NoFN then far.Message(err,L.Hdr:format(O.PName),";Ok","w") end end -- если ошибка и не отказ, то скажем
  elseif BK=="F3" then -- загрузить из файла?
    Restore()
  elseif BK=="F4" or BK=="F5" or BK=="INSERT" or BK=="NUMPAD0" then -- редактировать/копировать/новый?
    if root and (BK:len()>2 or items[pos]) then Edit(item,BK=="F4" and "Edit" or BK=="F5" and "Copy" or "New") end
  elseif BK=="DELETE" or BK=="DECIMAL" then -- удалить переменную под курсором?
    if root and items[pos] then Remove(item) end
  elseif BK=="C+PRIOR" or BK=="C+NUMPAD9" then -- перейти в корень или на выбор плагина?
    if (not root or root=="") then -- выбрать плагин?
      if SelPlugin() then root,History = nil,{} end -- выберем, если выбрали, то старый указатель некорректен, история тоже
    else
      root,History = "",{} -- перейдём в корень, сбросим историю
    end
  elseif BK=="C+S" then -- Выбрать БД?
      if SelPlugin() then root,History = nil,{} end -- выберем, если выбрали, то старый указатель некорректен, история тоже
  elseif BK:match("^C%+[CGL]$") then -- Переключить БД?
    if BK:sub(3)~="G" and root and root:match("^[^\n]+")=="GLOBAL" then
      History[#History+1],root,pos = {r=root,p=pos},root:gsub("^GLOBAL","LOCAL"),1
    elseif BK:sub(3)~="L" and root and root:match("^[^\n]+")=="LOCAL" then
      History[#History+1],root,pos = {r=root,p=pos},root:gsub("^LOCAL","GLOBAL"),1
    end
  elseif BK:match("^C%+[123]$") then -- Переключить БД?
    O.tbl_format = ({"inspect","dump","internal"})[tonumber(BK:sub(3))]
  elseif BK=="F10" then -- немедленно выйти?
    break -- выйдем
  end
until false
end -- ShowMenu
--
if type(nfo)=="table" then nfo.execute = ShowMenu end
-- +
--[==[Экспорт]==]
-- -
function Save(key,file)
SaveToFile(ReadDB(),type(file)=="string"and file or APanel.Path.."\\"..O.PName.."."..(key or"All")..".dbedit",key or "") -- сразу сохраним по шаблону
end
-- +
--[==[Импорт]==]
-- -
function Restore(fname)
LoadLang()
if type(fname)~="string" then -- имя файла не указано или не строка? введём
  fname = APanel.Path.."\\?.dbedit" -- имя файла по умолчанию
  fname = far.InputBox(Guids.ImpFN,L.diImp,L.diGetFN,"DBEditFileHistory",fname,nil,nil,F.FIB_BUTTONS+F.FIB_EDITPATH+F.FIB_EXPANDENV) -- и настоящее
end
local tbl,err = ReadFromFile(fname) -- прочитаем
if not tbl then if err~=L.Err.NoFN then far.Message(err,L.Hdr:format(O.PName),";Ok","w") end return end -- если ошибка и не отказ, то скажем
for n,v in pairs(tbl) do
  local obj = far.CreateSettings(UID,n=="LOCAL" and F.PSL_LOCAL or F.PSL_ROAMING) -- откроем данные
  overwrite = nil -- сбросим признак перезаписи
  for _,value in pairs(v.value) do PutElem(obj,0,value) end -- запишем
  obj:Free() -- закроем
end
end
-- +
--[==[Обработка командной строки]==]
-- -
function CLProc(pref,line)
LoadLang() -- обновим язык
local p,plug,file = O.PName,line:match("^%b<>") -- выдернем имя плагина, если есть
if plug then plug,line = plug:sub(2,-2),line:match("^%b<>%s*(.*)$") SelPlugin(plug) end -- есть? обрежем скобки и выберем его; скорректируем строку
if pref=="dbshow" then -- просмотр?
  ShowMenu(line:gsub("([^/])/([^/])","%1\n%2"):gsub("//","/")) -- преобразуем к нужному формату и покажем
elseif pref=="dbexp" then -- экспорт?
  if line:find('^".+"$') then line = line:sub(2,-2) -- если вся строка в кавычках, просто раскавычим её
  elseif line:find('"$') then line,file = line:match('^(.-)%s+(%b"")$') -- если в кавычках конец строки, это имя файла, разделим параметр и файл
  elseif line:find("%s") then line,file = line:match("^(.-)%s+([^%s]*)$") end -- если есть пробел(ы), после последнего - имя файла, разделим
  Save(line~="" and line or nil,file~="" and file or nil) SelPlugin(p) -- экспортируем, вернём старый плагин
elseif pref=="dbimp" then -- импорт?
  Restore(line~="" and line or nil) SelPlugin(p) -- импортируем, вернём старый плагин
end
end
-- +
--[==[Обработка вызова модуля]==]
-- -
function ModProc(params)
LoadLang() -- обновим язык
if type(params)~="table" then params = {} end -- если параметры отсутствуют или заданы неправильно, считаем, что их нет
if type(params.plugin)=="string" then if not SelPlugin(params.plugin) then return end end -- указан плагин? выберем его
if type(params.export)=="string" then Save(params.export,params.FileName) end -- экспорт? экспортируем
if params.import then Restore(params.FileName) end -- импорт? импортируем
if type(params.show)=="table" then -- адрес просмотра задан таблицей?
  local root = "" -- заготовка
  for _,v in ipairs(params.show) do root = root..tostring(v).."\n" end -- заполним
  ShowMenu(root:sub(1,-2)) -- покажем
elseif type(params.show)=="string" then -- адрес задан строкой?
  ShowMenu(params.show:gsub("([^/])/([^/])","%1\n%2"):gsub("//","/")) -- преобразуем к нужному формату и покажем
elseif params.show==true or not(params.import or params.export or params.show) then -- адрес не задан или вообще команда не задана?
  ShowMenu() -- просмотрим всё
end
end
--
local function idx(self,key)
return function(...) local fun = rawget(self,key) if fun then fun(...) else far.Message("DBEdit: bad function name") end end
end
local Result = setmetatable({ -- что возвращает модуль
  Main = ModProc;
  Show = function(root,plug) local p = O.PName ModProc({plugin=plug,show=root}) SelPlugin(p) end;
  Import = function(file,plug) local p = O.PName if plug and SelPlugin(plug) or not plug then Restore(file) SelPlugin(p) end end;
  Export = function(patt,file,plug) local p = O.PName if plug and SelPlugin(plug) or not plug then Save(patt or "",file) SelPlugin(p) end end;
},{__index=idx;__call=function(self,...) return self.Main(...) end;})
if not Macro then return Result end -- не первоначальная загрузка? сделаем модулем
LoadLang() --[[первичная загрузка языка]]
local ok,mod = pcall(require,"DBEdit") -- Заглушка есть?
if ok then -- да - впишемся в неё
  for n,v in pairs(Result) do mod[n] = v end
else -- нет - добавим загрузчик правильного модуля
  package.preload[PathName:match("[^\\]*$")] = function(name) package.loaded[name] = Result end-- добавим загрузчик правильного модуля
end
-- +
--[=[Макросы]=]
-- -
Macro{
  area="Common"; key="AltShiftF2"; description=L.EMDesc; [(LMBuild<579 and "u" or "").."id"]=Guids.ExpMacro; action=function() ShowMenu() end;
}
Macro{
  area="Common"; key="AltShiftF3"; description=L.IMDesc; [(LMBuild<579 and "u" or "").."id"]=Guids.ImpMacro; action=function() Restore() end;
}
-- +
--[=[Пункт меню]=]
-- -
MenuItem{
  description = L.PlugDesc; menu = "Plugins"; area = "Common"; guid = Guids.PlugMenu;
  text = function() return L.Hdr:sub(1,-6) end; action = function() if SelPlugin() then ShowMenu() end end;
}
-- +
--[=[Префикс]=]
-- -
CommandLine { description = L.CLDescShow; prefixes = "dbshow"; action = CLProc; }
CommandLine { description = L.CLDescExp; prefixes = "dbexp"; action = CLProc; }
CommandLine { description = L.CLDescImp; prefixes = "dbimp"; action = CLProc; }
