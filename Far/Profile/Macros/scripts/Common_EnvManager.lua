local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {_filename or ...,
  name          = "Environment manager";
  description   = "Менеджер переменных окружения";
  version       = "1.4.0"; --http://semver.org/lang/ru/
  author        = "IgorZ";
  url           = "http://forum.farmanager.com/viewtopic.php?t=9975";
  id            = "76BC77D8-38EF-4196-8D53-F12230CBA885";
  minfarversion = {3,0,0,4000,0};
  files         = "*Eng.lng;*Rus.lng";
  helptxt       = [[
Позволяет манипулировать переменными окружения.
Управление: Alt+Shift+E - вызов меню
]];
history         = [[
2015/12/15 v1.0.0 - Первый релиз.
2015/12/16 v1.0.1 - Значение переменной окружения можно редактировать во встроенном редакторе Far-а. При этом составные значения, наподобие Path,
                    разбиваются на строки. Мелкие правки.
2015/12/16 v1.0.2 - Добавлен guid для диалога редактирования.
2015/12/17 v1.0.3 - Рефакторинг. Небольшие правки.
2015/12/18 v1.0.4 - Мелкая правка.
2015/12/22 v1.0.5 - Более корректный разбор композитного значения переменной.
2015/12/24 v1.1.0 - Добавлена обработка переменных окружения в реестре. Мелкие правки.
2015/12/28 v1.2.0 - Переделка интерфейса. Рефакторинг.
2016/05/05 v1.2.1 - AltF4 сразу открывает переменную в редакторе Far. Белый и чёрный списки переменных. Разные правки.
2017/03/24 v1.3.0 - Добавлена возможность сохранять переменные в файл и считывать их оттуда. Nfo. Убран \0, попадавший в конец значения
                    переменной из памяти. Исправлена область действия в MenuItem. Мелкие правки.
2017/05/16 v1.3.1 - Функции, добавленные в предыдущей версии не были описаны в подсказке и справке главного окна.
2017/06/21 v1.3.2 - Исправлена ошибка с сохранением переменных окружения при непустом белом списке.
2017/08/08 v1.3.3 - Исправлена ошибка с удалением всех переменных из чёрного списка, внесённая в версии 1.3.2.
2017/09/20 v1.4.0 - Добавлена возможность временно отключать переменные. Добавлена возможность загружать переменные из файла с командной строки.
                    Переделана справка. Рефакторинг.
]];
}
if not nfo then return end
--
-- Константы
local F,Author,EMData,Offvars = far.Flags,"IgorZ","EnvManager","Offlist"
local Guids = {
  LuaMacro  = win.Uuid("4EBBEFC8-2084-4B7F-94C0-692CE136894D"); -- guid LuaMacro
  MenuMacro = "FBD4ED31-F4F1-45A0-AB7E-227C9DF31DDA",
  PlugMenu  = "3E51A05B-A71A-4AFE-9A40-40A0E780062D",
  Menu      = win.Uuid("F6603244-BFBC-4F06-8ED0-E72CE231F0F9"),
  diEdit    = win.Uuid("20089D97-090F-4897-8AA0-09189746FF0D"),
  SaveMenu  = "D33E9BF1-5401-44A3-BC2E-AB8BE7E852D2",
  LoadMenu  = "1F9796B9-B411-4735-A9CA-DEF79E8AE5DB",
  SaveFN    = win.Uuid("8308FA8D-CF17-4A33-B248-D62FB2E31053"),
  LoadFN    = win.Uuid("2BB7FC18-AD85-48A6-8ADE-99D6E8430CE8"),
}
local aMe,aCU,aLM = " Mem","HKCU","HKLM"
local LMBuild = far.GetPluginInformation(far.FindPlugin(F.PFM_GUID,Guids.LuaMacro)).GInfo.Version[4] -- запомним версию LuaMacro
local RegAdr = {[aCU]="Environment",[aLM]=[[SYSTEM\CurrentControlSet\Control\Session Manager\Environment]]} -- где в реестре окружение
local ffi = require "ffi"
local C = ffi.C
ffi.cdef [[
  wchar_t* GetEnvironmentStringsW();
  void FreeEnvironmentStringsW(wchar_t*);
  size_t wcslen(const wchar_t*);
  int SendMessageTimeoutA(HWND, UINT, WPARAM, LPARAM, UINT, UINT, DWORD_PTR*);
]]
-- Настройки
local BList,WList,WNum,Offlist -- чёрный список, белый список, количество в белом списке, отключённые переменные
--local DefaultProfile = F.PSL_LOCAL -- место хранения настроек по умолчанию: локальные
local DefaultProfile = F.PSL_ROAMING -- место хранения настроек по умолчанию: глобальные
-- Языковые настройки
local PathName,FarLang,L = (...):match("(.*)%.lua")
-- переменные
local UsedProfile = DefaultProfile -- откуда загрузили настройки
-- +
--[=[вспомогательные функции]=]
-- -
local LoadSettings,SaveSettings,Get,Set,GetAllEnv,Change,DelVar,SaveEnv,LoadEnv,ShowHelp
--
function LoadSettings(defaults) --[[загрузить настройки из БД]]
local obj,key
local function Load1(n,d) return not defaults and obj:Get(key or -1,n,({string=F.FST_STRING,number=F.FST_QWORD})[type(d)]) or d end
--
obj = far.CreateSettings(nil,DefaultProfile) -- откроем предпочтительные настройки
key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,EMData) -- есть раздел?
UsedProfile = DefaultProfile -- запомним профиль
if not key then -- настроек нет?
  obj:Free() obj = far.CreateSettings(nil,DefaultProfile==F.PSL_LOCAL and F.PSL_ROAMING or F.PSL_LOCAL) -- откроем другие настройки
  key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,EMData) -- есть раздел?
  if key then -- из другого профиля открылись?
    UsedProfile = DefaultProfile==F.PSL_LOCAL and F.PSL_ROAMING or F.PSL_LOCAL -- запомним профиль
  end
end
BList,WList,WNum,Offlist = {},{},0,{} -- считаем настройки
for s in (Load1("WList","").."="):gmatch("([^=]+)=") do WNum = WNum+1 WList[s] = WNum end -- заполним белый список
for s in (Load1("BList","").."="):gmatch("([^=]+)=") do BList[s] = true end -- заполним чёрный список
key = obj:OpenSubkey(key or -1,Offvars) -- подраздел отключённых переменных
local t = key and obj:Enum(key) or {} -- список имён переменных
for _,v in ipairs(t) do Offlist[v.Name] = obj:Get(key,v.Name,F.FST_STRING) end -- заполним список отключённых переменных
obj:Free() -- приберёмся
local FL,dummy = win.GetEnv("FARLANG"):sub(1,3),function() far.Message("Cannot find languages files",nfo.name,";Ok","w") return {} end -- язык
if FarLang~=FL then FarLang,L = FL,(loadfile(PathName..FL..".lng") or loadfile(PathName.."Eng.lng") or dummy)() end -- текущий другой - обновим
end
--
function SaveSettings() --[[сохранить настройки в БД]]
local obj,key
local function Save1(n,v) -- сохранить одну настройку
if type(v)=="boolean" then v = v and 1 or 0 end -- заменим true/false на 1/0
local t = ({string=F.FST_STRING,number=F.FST_QWORD})[type(v)] -- тип параметра в БД
if obj:Get(key,n,t)~=v then obj:Set(key,n,t,v) end -- изменился (или не было)? запишем
end
--
if UsedProfile==F.PSL_LOCAL then win.CreateDir(win.GetEnv("FARLOCALPROFILE").."\\PluginsData") end -- локальные настрйки? создадим папку
obj = far.CreateSettings(nil,UsedProfile) -- откроем ранее прочитанные или предпочтительные настройки
key = obj:CreateSubkey(obj:CreateSubkey(0,Author),EMData) -- откроем/создадим раздел
local s,tmp = "",{}
for n,_ in pairs(BList) do s = s.."="..n end Save1("BList",s)
for n,v in pairs(WList) do tmp[v] = n end    Save1("WList",table.concat(tmp,"="))
obj:Delete(obj:CreateSubkey(key,Offvars)) -- удалим раздел отключённых переменных со всем содержимым
key = obj:CreateSubkey(key,Offvars) -- создадим раздел отключённых переменных
for n,v in pairs(Offlist) do obj:Set(key,n,F.FST_STRING,v) end -- сохраним их
obj:Free() -- приберёмся
end
--
function Get(name,src) --[[загрузить значение переменной]]
if src==aMe then return win.GetEnv(name) else return win.GetRegKey(src,RegAdr[src],name) end -- достанем из памяти или реестра
end
--
function Set(name,dst,value) --[[записать/удалить значение переменной]]
if dst==aMe then -- в память?
  win.SetEnv(name,value and value:gsub("%%(.-)%%",win.GetEnv)) -- раскроем переменные окружения и запишем
else -- в реестр
  if value then -- значение есть?
    win.SetRegKey(dst,RegAdr[dst],name,"expandstring",value) -- запишем
  else -- значения нет
    win.DeleteRegValue(dst,RegAdr[dst],name) -- удалим
  end
  C.SendMessageTimeoutA(ffi.cast("HWND",-1),0x1A,0,ffi.cast("LPARAM","Environment"),2,1000,ffi.cast("DWORD_PTR*",0)) -- обновить
  mf.waitkey(100) -- подождём, а то не успевает обновиться
end
end
--
function GetAllEnv() --[[получить все переменные окружения]]
local t,env = {},C.GetEnvironmentStringsW() -- таблица с переменными, переменные окружения в виде последовательности 0-терминированных строк
local p = env -- указатель на очередную
while true do -- разберём
  local len = C.wcslen(p) -- длина очередной строки
  if len == 0 then break end -- нулевая - закончим
  local s = win.Utf16ToUtf8(ffi.string(ffi.cast("char*", p), 2*(len+1))) -- получим очередную строку
  if s:sub(1,1)~="=" then -- закинем каталог в таблицу (кроме "=<диск>=<путь>")
    local n,v = s:match("^(.-)=(.*)%z$") -- выдернем имя и значение
    if not BList[n] then -- добавим, если нет в чёрном списке
      t[#t+1] = {Name=n,Value=v,Num=WList[n] or math.huge,src=aMe}
      if Offlist[aMe.."_"..n]==v then Offlist[aMe.."_"..n] = nil end -- если есть в списке отключённых с тем же значением, выкинем
    end
  end
  p = p+len+1 -- указатель на следующую строку
end
C.FreeEnvironmentStringsW(env) -- освободим память
for r,pt in pairs(RegAdr) do -- переберём реестр
  local i = 0 -- все переменные в разделе
  while true do
    local n = win.EnumRegValue(r,pt,i) -- прочитаем очередную
    if not n then break end -- нет - закончим с этим реестром
    if not BList[n] then -- добавим, если нет в чёрном списке
      local v = win.GetRegKey(r,pt,n) -- значение в реестре
      t[#t+1] = {Name=n,Value=v,Num=WList[n] or math.huge,src=r}
      if Offlist[r.."_"..n]==v then Offlist[r.."_"..n] = nil end -- если есть в списке отключённых с тем же значением, выкинем
    end
    i = i+1 -- следующая переменная
  end
end
for n,v in pairs(Offlist) do -- добавим отключённые
    t[#t+1] = not BList[n:sub(6)] and {Name=n:sub(6),Value=v,Num=WList[n:sub(6)] or math.huge,src=n:sub(1,4),off=true} or nil
end
local maxlen = 0
if #t>0  then -- если есть что разбирать
  for _,v in ipairs(t) do maxlen = math.max(maxlen,v.Name:len()) end -- вычислим максимальную длину имени
  table.sort(t,function(a,b) local f = "%9d%-"..maxlen.."s%s" return f:format(a.Num,a.Name:upper(),a.src)<f:format(b.Num,b.Name:upper(),b.src) end)
end
return maxlen,t
end
--
function Change(item,cmd) --[[создать/изменить/скопировать/переименовать переменную в диалоге]]
local Hdr = not item.Name and L.diEdit.Hdr.New or L.diEdit.Hdr[cmd] or "" -- выберем заголовок
local w = math.max(math.min((item.Value or ""):len(),Far.Width-10),(L.diEdit.Value[item.src]..L.diEdit.Hint):len()+1,Hdr:len()) -- найдём ширину окна
local form = { -- диалог редактирования
--[[01]] {F.DI_DOUBLEBOX,   3, 1,w+6, 7,0,0,0,0,Hdr},
--[[02]] {F.DI_TEXT,        5, 2,  0, 2,0,0,0,0,L.diEdit.Name},
--[[03]] {F.DI_EDIT,       21, 2,w+4, 2,0,0,0,cmd=="F4" and F.DIF_READONLY or 0,item.Name},
--[[04]] {F.DI_TEXT,        5, 3,  0, 3,0,0,0,0,L.diEdit.Value[item.src]..L.diEdit.Hint..":"},
--[[05]] {F.DI_EDIT,        5, 4,w+4, 4,0,0,0,cmd and cmd~="F4" and F.DIF_READONLY or 0,item.Value},
--[[06]] {F.DI_TEXT,       -1, 5,  0, 5,0,0,0,F.DIF_SEPARATOR,""},
--[[07]] {F.DI_BUTTON,      0, 6,  0, 6,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[08]] {F.DI_BUTTON,      0, 6,  0, 6,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
local function DlgProc (hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_EDITCHANGE and Param1==3 then -- изменение поля имя переменной
  Param2[10] = Param2[10]:gsub("=","") -- поправим имя
  far.SetDlgItem(hDlg,Param1,Param2) -- скорректируем
elseif (Msg==F.DN_INITDIALOG and cmd=="A+F4") --открытие с помощью AltF4
    or (Msg==F.DN_CONTROLINPUT and(Param2.VirtualKeyCode==0x73 and band(Param2.ControlKeyState,0x1c)==0)) then -- (Alt)?F4 в диалоге
  local fname,text = far.MkTemp()..".txt",hDlg:send(F.DM_GETTEXT,5):gsub(";","\n"):gsub('%b""',function(s)return s:gsub("\n",";")end) -- файл, текст
  local hfile = io.open(fname,"w") hfile:write(text) hfile:close() -- заполним файл
  local screen = far.SaveScreen()
  editor.Editor(fname,"  "..(item.src==aMe and "" or item.src..":")..hDlg:send(F.DM_GETTEXT,3),nil,nil,nil,nil,
    F.EF_DISABLEHISTORY+F.EF_DISABLESAVEPOS+(cmd and cmd:sub(-2,-1)~="F4" and F.EF_LOCKED or 0)) -- отредактируем
  far.RestoreScreen(screen)
  hfile = io.open(fname,"r") text = hfile:read("*a"):gsub("\n+$",""):gsub("\n+",";") hfile:close() -- новое значение
  hDlg:send(F.DM_SETTEXT,5,text) -- запишем новое значение
  hDlg:send(F.DM_REDRAW) -- перерисуем окно, а то курсор не видно.
  if Msg==F.DN_INITDIALOG then hDlg:send(F.DM_CLOSE,text~=item.Value and 7 or 8) end -- в меню было нажато AltF4? закроем диалог
elseif Msg==F.DN_CONTROLINPUT and (Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0) then -- F1
  return true,ShowHelp("Edit")
end
end
-- начало тела функции Change
if far.Dialog(Guids.diEdit,-1,-1,w+10,9,nil,form,nil,DlgProc)~=7 then return end -- вызовем диалог, не "ОК" - уйдём
local newname,newvalue = form[3][10],form[5][10] -- новые имя и значение
if newname=="" then return end -- если имя переменной пустое - не работаем
if newvalue=="" then -- значение пустое?
  if item.Name then DelVar(item) end -- если такая переменная была - удалим
else -- значение непустое
  local oldvalue = (item.Name~=newname) and Get(newname,item.src) -- получим старое значение переменной, если имя поменяли
  if not oldvalue or far.Message(L.diEdit.Replace:format(newname,L.diEdit.In[item.src],oldvalue,newvalue),Hdr,";YesNo")==1 then -- новая? или менять?
    if cmd=="F6" then Set(item.Name,item.src) end -- удалим старую, если перенос
    Set(newname,item.src,newvalue) -- сохраним переменную
  end
end
end
--
function DelVar(item) --[[удалить переменную с запросом]]
if far.Message(L.Del.Var[item.src]:format(item.Value),L.Del.Hdr:format(item.Name),";OkCancel")==1 then Set(item.Name,item.src) end
end
--
function SaveEnv(source,nlen) --[[сохранить выбранные переменные]]
local list,pos,res = {},1
local Hotkeys = {{BreakKey="F1"},{BreakKey="INSERT"},{BreakKey="NUMPAD0"},{BreakKey="SPACE"},
                 {BreakKey="ADD"},{BreakKey="SUBTRACT"},{BreakKey="MULTIPLY"},
                 {BreakKey="S+ADD"},{BreakKey="S+SUBTRACT"},{BreakKey="S+MULTIPLY"},
                 {BreakKey="C+ADD"},{BreakKey="C+SUBTRACT"},{BreakKey="C+MULTIPLY"},
                 {BreakKey="A+ADD"},{BreakKey="A+SUBTRACT"},{BreakKey="A+MULTIPLY"},}
for i,v in ipairs(source) do -- переберём список, убирая отключённые и копии в памяти для переменых из реестра
  if not v.separator and not v.grayed and (v.src~=aMe or not source[i+1] or source[i+1].Name~=v.Name or source[i+1].grayed)
                                      and (v.src~=aMe or not source[i+2] or source[i+2].Name~=v.Name or source[i+2].grayed) then
    list[#list+1] = {text=v.src..": "..v.Name..(" "):rep(nlen-v.Name:len())..(" = ")..v.Value,Name=v.Name,Value=v.Value,src=v.src,checked=true}
  end
end
table.sort(list,function(a,b) return a.Name:upper()==b.Name:upper() and a.src<b.src or a.Name:upper()<b.Name:upper() end) -- отсортируем
repeat
  res,pos = far.Menu({Title=L.SaveEnv,Bottom="Enter,Esc,F1,Ins,Space,(Shift/Ctrl/Alt)Num+/-/*",SelectIndex=pos,Id=Guids.SaveMenu},list,Hotkeys)
  if not res then return -- Esc? ничего не делаем
  elseif not res.BreakKey then break -- Enter? Работаем дальше
  elseif res.BreakKey=="F1" then ShowHelp("SaveEnv")
  elseif res.BreakKey=="ADD" then -- Num+
    for i=1,#list do list[i].checked = true end -- выделим все
  elseif res.BreakKey=="SUBTRACT" then -- Num-
    for i=1,#list do list[i].checked = false end -- снимем выделение со всех
  elseif res.BreakKey=="MULTIPLY" then -- Num*
    for i=1,#list do list[i].checked = not list[i].checked end -- инвертируем выделение на всех
  elseif res.BreakKey=="S+ADD" then -- ShiftNum+
    for i=1,#list do if list[i].src==aMe then list[i].checked = true end end -- выделим все из памяти
  elseif res.BreakKey=="S+SUBTRACT" then -- ShiftNum-
    for i=1,#list do if list[i].src==aMe then list[i].checked = false end end -- снимем выделение со всех из памяти
  elseif res.BreakKey=="S+MULTIPLY" then -- ShiftNum*
    for i=1,#list do if list[i].src==aMe then list[i].checked = not list[i].checked end end -- инвертируем выделение на всех из памяти
  elseif res.BreakKey=="C+ADD" then -- CtrlNum+
    for i=1,#list do if list[i].src==aCU then list[i].checked = true end end -- выделим все пользователя
  elseif res.BreakKey=="C+SUBTRACT" then -- CtrlNum-
    for i=1,#list do if list[i].src==aCU then list[i].checked = false end end -- снимем выделение со всех пользователя
  elseif res.BreakKey=="C+MULTIPLY" then -- CtrlNum*
    for i=1,#list do if list[i].src==aCU then list[i].checked = not list[i].checked end end -- инвертируем выделение на всех пользователя
  elseif res.BreakKey=="A+ADD" then -- AltNum+
    for i=1,#list do if list[i].src==aLM then list[i].checked = true end end -- выделим все системные
  elseif res.BreakKey=="A+SUBTRACT" then -- AltNum-
    for i=1,#list do if list[i].src==aLM then list[i].checked = false end end -- снимем выделение со всех системных
  elseif res.BreakKey=="A+MULTIPLY" then -- AltNum*
    for i=1,#list do if list[i].src==aLM then list[i].checked = not list[i].checked end end -- инвертируем выделение на всех системных
  else -- Ins/Space
    list[pos].checked = not list[pos].checked -- инвертируем выделение
    if pos<#list then pos = pos+1 else pos = 1 end -- перейдём на следующий элемент
  end
until false
local save -- признак того, что сохранять есть что
for _,v in ipairs(list) do if v.checked then save = true break end end -- проверим
if not save then return end -- нечего сохранять - уйдём
local name = APanel.Path.."\\SaveEnv.bat" -- имя файла по умолчанию
name = far.InputBox(Guids.SaveFN,L.SaveEnv,L.GetFN,"EMFileHistory",name,nil,nil,F.FIB_BUTTONS+F.FIB_EDITPATH+F.FIB_EXPANDENV) -- и настоящее
if not name then return nil,L.Err.NoFN end -- не указано имя файла? уйдём
local attr = win.GetFileAttr(name)
if attr then -- файл существует?
  if attr:match("d") then far.Message(L.Err.IsDir..name..'"',L.SaveEnv,";Ok","w") return end
  if far.Message(L.Err.Exist..name..'"?',L.SaveEnv,";OkCancel")~=1 then return nil,L.Err.Cancel end
end
local file = io.open(name,"w") -- создадим файл
if not file then far.Message(L.Err.NoOpen..name..'"',L.SaveEnv,";Ok","w") return end -- не создался? уйдём
for _,v in ipairs(list) do -- запишем помеченные
  if v.checked then file:write("@REM "..v.src.."\n@SET "..v.Name.."="..v.Value.."\n") end
end
file:close() -- закроем файл
end
--
function LoadEnv(fname)
local Hotkeys = {{BreakKey="F1"},{BreakKey="F3"},{BreakKey="INSERT"},{BreakKey="NUMPAD0"},{BreakKey="SPACE"},
                 {BreakKey="ADD"},{BreakKey="SUBTRACT"},{BreakKey="MULTIPLY"},
                 {BreakKey="S+ADD"},{BreakKey="S+SUBTRACT"},{BreakKey="S+MULTIPLY"},
                 {BreakKey="C+ADD"},{BreakKey="C+SUBTRACT"},{BreakKey="C+MULTIPLY"},
                 {BreakKey="A+ADD"},{BreakKey="A+SUBTRACT"},{BreakKey="A+MULTIPLY"},}
local name = APanel.Path.."\\*.bat" -- имя файла по умолчанию
if fname and fname~="" then name = fname -- если передано имя файла, работаем с ним
else -- иначе введём в диалоге
  name = far.InputBox(Guids.LoadFN,L.LoadEnv,L.GetFN,"EMFileHistory",name,nil,nil,F.FIB_BUTTONS+F.FIB_EDITPATH+F.FIB_EXPANDENV)
  if not name then return nil,L.Err.NoFN end -- не указано имя файла? уйдём
end
local attr = win.GetFileAttr(name) -- проверим имя
if not attr then far.Message(L.Err.NotExist..name..'"',L.LoadEnv,";Ok","w") return end -- файл не существует? уйдём
if attr:match("d") then far.Message(L.Err.IsDir..name..'"',L.LoadEnv,";Ok","w") return end -- это каталог? уйдём
local file = io.open(name,"r") -- откроем файл
if not file then far.Message(L.Err.NoOpen..name..'"',L.LoadEnv,";Ok","w") return end -- не открылся? уйдём
local list,text = {},"\n"..file:read("*a").."\n"; -- прочитаем всё содержимое
file:close() -- закроем файл
for s,n,v in text:gmatch("\n@REM (....)\n@SET ([^=\n]+)=([^\n]*)") do
  if s==aMe or s==aLM or s==aCU then list[#list+1] = {dst=s,Name=n,Value=v,checked=true} end
end
if #list==0 then far.Message(L.Err.NoData..name..'"',L.LoadEnv,";Ok","w") return end
table.sort(list,function(a,b) return a.Name:upper()==b.Name:upper() and a.dst<b.dst or a.Name:upper()<b.Name:upper() end) -- отсортируем
local l = 0
for _,v in ipairs(list) do l = math.max(l,v.Name:len()) end
for _,v in ipairs(list) do v.text = v.dst..": "..v.Name..(" "):rep(l-v.Name:len())..(" = ")..v.Value end
local pos,res = 1
repeat
  res,pos = far.Menu({Title=L.LoadEnv,Bottom="Enter,Esc,F1,F3,Ins,Space,(Shift/Ctrl/Alt)Num+/-/*",SelectIndex=pos,Id=Guids.LoadMenu},list,Hotkeys)
  if not res then return -- Esc? ничего не делаем
  elseif not res.BreakKey then break -- Enter? Работаем дальше
  elseif res.BreakKey=="F1" then ShowHelp("LoadEnv")
  elseif res.BreakKey=="F3" then far.Message(list[pos].text,L.LoadEnv,";Ok","l")
  elseif res.BreakKey=="ADD" then -- Num+
    for i=1,#list do list[i].checked = true end -- выделим все
  elseif res.BreakKey=="SUBTRACT" then -- Num-
    for i=1,#list do list[i].checked = false end -- снимем выделение со всех
  elseif res.BreakKey=="MULTIPLY" then -- Num*
    for i=1,#list do list[i].checked = not list[i].checked end -- инвертируем выделение на всех
  elseif res.BreakKey=="S+ADD" then -- ShiftNum+
    for i=1,#list do if list[i].dst==aMe then list[i].checked = true end end -- выделим все из памяти
  elseif res.BreakKey=="S+SUBTRACT" then -- ShiftNum-
    for i=1,#list do if list[i].dst==aMe then list[i].checked = false end end -- снимем выделение со всех из памяти
  elseif res.BreakKey=="S+MULTIPLY" then -- ShiftNum*
    for i=1,#list do if list[i].dst==aMe then list[i].checked = not list[i].checked end end -- инвертируем выделение на всех из памяти
  elseif res.BreakKey=="C+ADD" then -- CtrlNum+
    for i=1,#list do if list[i].dst==aCU then list[i].checked = true end end -- выделим все пользователя
  elseif res.BreakKey=="C+SUBTRACT" then -- CtrlNum-
    for i=1,#list do if list[i].dst==aCU then list[i].checked = false end end -- снимем выделение со всех пользователя
  elseif res.BreakKey=="C+MULTIPLY" then -- CtrlNum*
    for i=1,#list do if list[i].dst==aCU then list[i].checked = not list[i].checked end end -- инвертируем выделение на всех пользователя
  elseif res.BreakKey=="A+ADD" then -- AltNum+
    for i=1,#list do if list[i].dst==aLM then list[i].checked = true end end -- выделим все системные
  elseif res.BreakKey=="A+SUBTRACT" then -- AltNum-
    for i=1,#list do if list[i].dst==aLM then list[i].checked = false end end -- снимем выделение со всех системных
  elseif res.BreakKey=="A+MULTIPLY" then -- AltNum*
    for i=1,#list do if list[i].dst==aLM then list[i].checked = not list[i].checked end end -- инвертируем выделение на всех системных
  else -- Ins/Space
    list[pos].checked = not list[pos].checked -- инвертируем выделение
    if pos<#list then pos = pos+1 else pos = 1 end -- перейдём на следующий элемент
  end
until false
for _,v in ipairs(list) do if v.checked then Set(v.Name,v.dst,v.Value) end end -- проверим
end
--
function ShowHelp(text) --[[Вывести справку]]
local HL = Far.GetConfig("Language.Help"):sub(1,3) -- язык (первые 3 буквы)
far.ShowHelp(PathName..(win.GetFileAttr(PathName..HL..".hlf") and HL or "Eng")..".hlf",text,F.FHELP_CUSTOMFILE)
end
--
if type(nfo)=="table" then nfo.help = function() ShowHelp("Main") end end
-- +
--[==[Основные функции]==]
-- -
local VarMenu
-- +
--[=[Меню переменных окружения]=]
-- -
function VarMenu()
local Bottom,var,res,pos,HotKeys,nm,pn = "Enter,Esc,F1,F2,F3,F4,AltF4,F5,F6,Ins,Del,AltW,AltUp/Down,Alt/CtrlB,CtrlD",{}
HotKeys = {{BreakKey="F1"},{BreakKey="F4"},{BreakKey="A+F4"},{BreakKey="F5"},{BreakKey="F6"},{BreakKey="INSERT"},{BreakKey="NUMPAD0"},
  {BreakKey="DELETE"},{BreakKey="DECIMAL"},{BreakKey="A+W"},{BreakKey="A+UP"},{BreakKey="A+DOWN"},{BreakKey="C+B"},{BreakKey="A+B"},
  {BreakKey="F2"},{BreakKey="F3"},{BreakKey="C+D"}} -- подсказка, позиция в меню, результат обработки меню, горячие клавиши
--
LoadSettings() -- прочитаем настройки языка
repeat -- начало главного цикла
  local items,max,tmp = {},GetAllEnv() -- будущий список, максимальная длина имени, элементы меню
  max = math.max(max,L.CU:len(),L.LM:len())+1 -- скорректируем максимальную длину имени
  for i,v in ipairs(tmp) do -- сформируем меню
    nm = (v.Name~=pn and v.Name or "")
    items[#items+1] = {text=nm..(" "):rep(max-nm:len())..v.src.." │ "..v.Value,grayed=v.off,Name=v.Name,Value=v.Value,src=v.src} -- элемент меню
    pn = v.Name
    if v.Name==var.n and v.src==var.s then pos = #items end -- новая позиция последней переменной
    if v.Num~=math.huge and tmp[i+1] and tmp[i+1].Num==math.huge then items[#items+1] = {separator=true} end -- разделитель после белого списка
  end
  res,pos = far.Menu({Title=L.Hdr,Bottom=Bottom,SelectIndex=pos,Id=Guids.Menu,Flags=F.FMENU_SHOWAMPERSAND+F.FMENU_WRAPMODE},items,HotKeys) -- меню
  if not res then break end -- Esc. "работаем, пока не надоест"? Надоело...
  var = {n=items[pos].Name,s=items[pos].src} -- запомним текущую переменную
  if not res.BreakKey then res.BreakKey = "F4" end -- по Enter будем редактировать
  if res.BreakKey=="F1" then -- F1 - выведем справку
    ShowHelp("Main")
  elseif not res.BreakKey or res.BreakKey:match("F[456]$") then -- F4/AltF4/F5/F6 - редактировать в диалоге?
    if items[pos].src==aMe or LMBuild>=552 then Change(items[pos],res.BreakKey) end -- отредактируем
  elseif res.BreakKey=="INSERT" or res.BreakKey=="NUMPAD0" then -- добавить новый?
    if items[pos].src==aMe or LMBuild>=552 then Change({src=items[pos].src}) end -- добавим
  elseif res.BreakKey=="DELETE" or res.BreakKey=="DECIMAL" then -- удалить текущий?
    if items[pos].src==aMe or LMBuild>=552 then DelVar(items[pos]) end -- удалим
  elseif res.BreakKey=="A+W" then -- в/из белый список?
    if WList[var.n] then -- есть в белом списке?
      local i = WList[var.n] -- позиция
      WList[var.n],WNum = nil,WNum-1 -- выкинем
      for n,v in pairs(WList) do if v>i then WList[n] = v-1 end end -- скорректруем номера всех ниже
    else -- нет в белом списке
      WList[var.n],WNum = WNum+1,WNum+1 -- добавим
    end
    SaveSettings() -- сохраним изменённый белый список
  elseif res.BreakKey=="A+UP" then -- вверх на позицию?
    local i = WList[var.n] -- позиция
    if i and i~=1 then -- есть в белом списке и не первый?
      for n,v in pairs(WList) do if v==i then WList[n] = i-1 elseif v==i-1 then WList[n] = i end end -- поменяем местами
    end
    SaveSettings() -- сохраним изменённый белый список
  elseif res.BreakKey=="A+DOWN" then -- вверх на позицию?
    local i = WList[var.n] -- позиция
    if i and i~=WNum then -- есть в белом списке и не последний?
      for n,v in pairs(WList) do if v==i then WList[n] = i+1 elseif v==i+1 then WList[n] = i end end -- поменяем местами
    end
    SaveSettings() -- сохраним изменённый белый список
  elseif res.BreakKey=="A+B" then -- в чёрный список?
    BList[var.n] = true -- внесём
    SaveSettings() -- сохраним изменённый чёрный список
  elseif res.BreakKey=="C+B" then -- из чёрного списка?
    local itms,el,itm = {},1
    for n,_ in pairs(BList) do itms[#itms+1] = {text = n} end -- сформируем список элементов
    repeat -- рабочий цикл
      itm,el = far.Menu({Title=L.BLHdr,Bottom="Del,Enter,Esc",SelectIndex=el},itms,{{BreakKey="DELETE"},{BreakKey="DECIMAL"},{BreakKey="RETURN"}})
      if not itm then break end -- Esc - уйдём, ничего не делаем
      if itm.BreakKey=="RETURN" then -- Enter
        BList = {}
        for _,v in ipairs(itms) do BList[v.text] = true end -- заполним выделенными элементами
        SaveSettings() -- сохраним изменённый чёрный список
        break -- выйдем из цикла
      else--if itm.BreakKey=="DELETE" or itm.BreakKey=="DECIMAL" then -- удалим элемент из чёрного списка
        table.remove(itms,el)
      end
    until false
  elseif res.BreakKey=="F2" then -- сохранить?
    SaveEnv(items,max)
  elseif res.BreakKey=="F3" then -- загрузить?
    LoadEnv()
  elseif res.BreakKey=="C+D" then -- включить/отключить?
    if items[pos].grayed then -- отключена?
      Set(items[pos].Name,items[pos].src,items[pos].Value) -- восстановим переменную
      Offlist[items[pos].src.."_"..items[pos].Name] = nil -- уберём из списка отключённых
      SaveSettings() -- сохраним измения
    else
      Offlist[items[pos].src.."_"..items[pos].Name] = items[pos].Value -- запомним в списке отключённых
      Set(items[pos].Name,items[pos].src) -- и удалим
      SaveSettings() -- сохраним измения
    end
  end
until false -- конец главного цикла
end
--
if type(nfo)=="table" then nfo.execute = VarMenu end
--
LoadSettings() --[[первичная загрузка языка]]
-- +
--[=[Макрос]=]
-- -
Macro{area="Common"; key="AltShiftE"; description=L.MenuDesc; uid=Guids.MenuMacro; action=VarMenu;}
-- +
--[=[Пункт меню]=]
-- -
MenuItem{
  description = L.Desc; menu = "Plugins"; area = "Common";
  guid = Guids.PlugMenu; text = function() return L.MenuDesc end; action = VarMenu;
}
-- +
--[=[Префикс]=]
-- -
CommandLine { description = L.Desc; prefixes = "EMLoad"; action = function(_,name) LoadEnv(name) end; }