local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {_filename or ...,
  name          = "CtrlAltMenuDisk";
  description   = "Переключение дисков по Ctrl/Alt/Shift+<-/->";
  version       = "4.1.1"; --http://semver.org/lang/ru/
  author        = "IgorZ";
  url           = "http://forum.farmanager.com/viewtopic.php?t=7471";
  id            = "097450AF-B186-425A-961A-4A884FC2B732";
  minfarversion = {3,0,0,4000,0};
  files         = "*Eng.hlf;*Rus.hlf;*Eng.lng;*Rus.lng";
  helptxt       = [[
По умолчанию при нажатии LeftCtrl/RightAlt меняется диск/плагин для левой панели,
при нажатии RightCtrl/LeftAlt - для правой, при нажатии Shift - для активной.
Меняется в настройках.
]];
history         = [[
2012/11/02 v1.0   - Первый релиз
2012/11/13 v1.1   - Добавлены опции: использовать/игнорировать Shift/стрелки; игнорировать/обрабатывать закрытые панели.
                    Не пытаемся обрабатывать нефайловые панели (всё равно смена диска не работает).
2012/12/19 v2.0   - Переделана логика. Теперь макрос вызывается и работает до конца, а не при каждом нажатии.
                    Больше нет конфликта с Bookmark (c) Max Rusov и другими макросами, назначенными на отпускание одиночного модификатора.
                    Мелкие правки. Сделана версия для чистого LuaMacro.
2013/02/04 v2.1   - Небольшая оптимизация алгоритма, переход с mf.* на стандартные средства Lua.
2013/02/05 v2.2   - Ещё чуть оптимизации. Включаем отключенную панель перед изменением диска для неё. Не меняем диск, если выбрали его же;
                    если на панели не локальный диск, запомним и выведем для него отдельный символ. Возможность исключать отдельные диски из списка.
                    Альтернативный режим управления (Ctrl меняет на активной панели, Alt на пассивной).
2013/02/06 v2.2.1 - Исправление ошибок. Добавлена настройка включения панели.
2013/02/07 v2.2.2 - Исправлена ошибка с перерисовкой панели, когда диск не сменился, и ситуация с погашенной панелью.
2013/04/04 v2.2.3 - Внесена правка в связи со сменой DisableOutput на EnableOutput. Работает как со старым, так и с новым вариантом.
2014/05/19 v2.2.4 - После очередного рефакторинга Far-а вылезла мелкая, но досадная ошибка с mmode. Исправлена.
2014/05/26 v2.2.5 - Правка скрипта (использование возможностей, появившихся после его написания), причёсывание.
                    Теперь работает и с плагиновыми панелями, а также в области поиска. Требует версию Far 3.0.3209+.
2014/05/27 v2.2.6 - Если рабочая панель Info/QView/Tree, то переключаем в другой. Небольшая полировка неровностей.
2014/05/28 v2.2.7 - Подсвечивается изначальный диск. Оптимизация.
2014/05/30 v2.2.7a- Экспериментально: изначальный диск не только подсвечивается, но и выводится строчной буквой.
                    Для возврата на него введена клавиатурная комбинация "Home" с текущим модификатором.
2014/10/13 v3.0.0 - Настройка скрипта (вызывается по выбору "?" в конце списка, быстрый переход по нажатию "End"), хранение настроек в БД.
                    Скрипт добавлен в меню плагинов. Кроме дисков, можно переходить на плагины. Список плагинов настраивается. Локализация.
                    Добавлена контекстная справка (вызывается везде, даже при переключении дисков). Рефакторинг, исправление ошибок.
2014/10/14 v3.0.1 - Добавлено сохранение порядка плагинов в строке. Исправление ошибок.
2014/10/16 v3.0.1a- Опечатка в хелпе: End - позиционирование курсора на символе окна конфигурации; необъявленные переменные: FarLang, L
2014/10/18 v3.0.2 - Исправлена ошибка со случаем, когда скрипт стартует с начальным диском, входящим в список исключаемых.
                    Настройка строки вывода мини-панели.
2014/10/20 v3.0.3 - Исправлены ошибки в конфигурации: не вызывалась настройка списка плагинов, поправлено окно диалога и русский языковой файл.
2014/10/31 v3.0.4 - В меню настройки плагинов: символ пометки "&" корректно отображается, Enter отрабатывает в любой позиции.
2014/11/14 v3.0.5 - Выбор символа плагина: при нажатии клавиш и комбинаций с длинными названиями (Ctrl, AltQ, etc) возникала ошибка. Исправлено.
2014/11/23 v3.0.6 - Esc - отмена выбора диска? Enter - переход на диск.
2015/12/10 v3.0.7 - Рефакторинг работы с плагинами. Мелкие правки
2015/12/18 v3.0.8 - Настройка вывода символов панели с разделением пробелами. Настройка выделения текущего диска нижним регистром. Рефакторинг.
                    Мелкие правки.
2016/03/24 v3.1.0 - Более гибкая настройка управления. Переработана справка.
2016/03/25 v3.1.1 - Мелкие правки.
2016/05/25 v3.2.0 - Максимально гибкая настройка управления. Смена места хранения данных. Мелкие правки.
2017/06/15 v3.3.0 - Диски и плагины можно назначать на разные комбинации. После смены клавиш скрипты перезагружаются. Убрана область Menu
                    из определения пункта меню плагинов. При выводе справки используется язык справки фара. Справка допилена. Nfo. Мелкие правки.
2017/12/05 v3.3.1 - Нажатие буквы диска/символа плагина перемещает курсор в панели. Изменён способ выделения начального диска в панели. Рефакторинг.
2017/12/18 v3.3.2 - Можно указывать несколько строк вывода, панель будет выводиться в каждой.
2017/12/21 v4.0.0 - Панели переключения могут быть постоянными и всплывающими при наведении мыши. Рефакторинг.
2018/01/05 v4.0.1 - Укрощение курсора в поле "Диски, исключаемые из списка" диалога настроек.
2018/02/09 v4.1.0 - Горизонтальная позиция мини-панели настраивается. Скрипт добавляется в меню дисков. Подсказки. Рефакторинг.
2018/11/06 v4.1.1 - Исправлена подсказка для конфигурации. Рефакторинг.
2018/12/15 v4.1.1.1 - Опечатка в хинте, выкинул пункт из меню дисков - скрипт там только мешает /VictorVG/
]];
}
if not nfo then return end
-- +
--[[константы]]
-- -
local F,C,A_Z,Author,ConfPart,PlugPart,KeyPart = far.Flags,far.Colors,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","IgorZ","CASArrowsDiskSwitch","Plugins","Keys"
local Period = 50
local Guids = {
  LuaMacro = win.Uuid("4EBBEFC8-2084-4B7F-94C0-692CE136894D"); -- guid LuaMacro
  Macro = "48994AA9-76FF-4DA1-9228-5189D02BD8C2",
  MouseEvent = "14459017-60F7-427C-9C4F-FD057E12FC27",
  ExitEvent = "C058961E-29B5-4621-B7B5-72821CE651A1",
  PlugMenu = "A4A5A5A7-AD64-4DD1-8C61-28CB90358817",
  ConfDialog = win.Uuid("D86EB908-8F29-4D8B-99D7-13DEB1FCA322"),
}
local PathName = (...):match("(.*)%.lua") -- путь и общая часть имени
local LMBuild = far.GetPluginInformation(far.FindPlugin(F.PFM_GUID,Guids.LuaMacro)).GInfo.Version[4] -- запомним версию LuaMacro
local Def = { -- настройки по умолчанию
  UseHidden = 1, -- отрабатывать для скрытой панели
  SwitchPanelsOn = 0, -- 0/1/2 - при выключенной панели оставлять выключенной/включать изменяемую/включать обе
  SpDelim = 0, -- разделять символы пробелами
  LowerCurDrive = 1, -- выводить букву текущего диска в нижнем регистре
  OutStr = "0", -- строка/и вывода мини-панели
  OutCol = 1, -- столбец вывода мини-панели
  ExcludeDrives = "", -- диски, исключаемые из списка перехода (в верхнем регистре!)
  PermPanel = 0, -- использовать постоянные панели
  FixedPerm = 0, -- показывать постоянные панели всегда
  KP = {L="Ctrl RAlt",R="Alt RCtrl",A="Shift",P="",Left="Left",Right="Right"}, -- что чем переключать
  Plugins = { -- плагины, добавляемые к списку дисков, их порядок
    ["5"]=win.Uuid("65642111-AA69-4B84-B4B8-9249579EC4FA"), -- ArcLite
    ["2"]=win.Uuid("42E4AEB1-A230-44F4-B33C-F195BB654931"), -- NetBox, bug
    ["3"]=win.Uuid("773B5051-7C5F-4920-A201-68051C4176A4"), -- network
    ["0"]=win.Uuid("1E26A927-5135-48C6-88B2-845FB8945484"), -- Proclist
    ["="]=win.Uuid("06771932-E01F-4259-A7A5-A899DEC06FC7"), -- SameFolder
    ["1"]=win.Uuid("B77C964B-E31E-4D4C-8FE5-D6B0C6853E7C"), -- TmpPanel
--  ["4"]=win.Uuid("148FE5E0-7129-4269-B30F-A1A866DD009A"), -- TrueBranch
} }
local DefProfile = F.PSL_ROAMING--[[F.PSL_LOCAL--]]-- место хранения настроек по умолчанию: глобальные--[[локальные--]]
-- +
--[[переменные]]
-- -
-- Таймер для постоянной мини-панели, признак выключения, признак "в работе", настройки, локализация, нажатые клавиша и модификатор, рабочая панель
local stop_timer,in_process,S,L,Key,KeyMod,WPanel,UsedProfile = false,false
-- +
--[[вспомогательные функции]]
-- -
local LoadLang,LoadSettings,SaveSettings,MakePanel,MakeOutPanel,GetDrive,CD,GetHints,Color,ShowHelp
-- +
--[==[Основные функции]==]
-- -
local Config,OnTimer,TestCond,ChangeDrive,MouseCond,MouseProc
--
function LoadLang() --[[загрузить настройки языка]]
local FL,dummy = Far.GetConfig("Language.Main"):sub(1,3),function() return {"Cannot find languages files"} end -- язык, пустая функция
if not L or L.Lang~=FL then L = (loadfile(PathName..FL..".lng") or loadfile(PathName.."Eng.lng") or dummy)(LMBuild) end -- обновим, если язык другой
end --LoadLang
--
function LoadSettings(ForceDef) --[[загрузить настройки из БД]]
local obj = far.CreateSettings(nil,DefProfile) -- откроем предпочтительные настройки
local key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,ConfPart) -- есть раздел?
UsedProfile = DefProfile -- запомним профиль
if not key then -- настроек нет?
  obj:Free() obj = far.CreateSettings(nil,DefProfile==F.PSL_LOCAL and F.PSL_ROAMING or F.PSL_LOCAL) -- откроем другие настройки
  key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,ConfPart) -- есть раздел? если нет, неважно, какой открыт, всё равно брать умолчания
  if key then UsedProfile = DefProfile==F.PSL_LOCAL and F.PSL_ROAMING or F.PSL_LOCAL end -- из другого профиля открылись? запомним профиль
end
local function L1(n) return not ForceDef and obj:Get(key or -1,n,type(Def[n])=="string" and F.FST_STRING or F.FST_QWORD) or Def[n] end
S = { KP = {},Plugins = {},PDescr = {}, -- считаем настройки
  UseHidden = L1("UseHidden")~=0,SwitchPanelsOn = L1("SwitchPanelsOn"),SpDelim = L1("SpDelim")~=0,LowerCurDrive = L1("LowerCurDrive")~=0,
  OutStr = L1("OutStr"),OutCol = L1("OutCol"),ExcludeDrives = L1("ExcludeDrives"),PermPanel = L1("PermPanel")~=0,FixedPerm = L1("FixedPerm")~=0}
key = obj:OpenSubkey(key or -1,KeyPart) -- подраздел со списком клавиш
for n,v in pairs(Def.KP) do S.KP[n] = not ForceDef and obj:Get(key or -1,n,F.FST_STRING) or v end -- загрузим значения из БД или умолчания
key = obj:OpenSubkey(obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,ConfPart) or -1,KeyPart) -- подраздел со списком плагинов
S.PlugStr = L1("PlugStr") -- список плагинов
if S.PlugStr then -- прочитан?
  for c in S.PlugStr:gmatch(".") do --для каждого обозначения плагина
    local u = L1(c) -- достанем GUID
    if u then S.Plugins[c] = win.Uuid(u) else S.PlugStr = S.PlugStr:gsub(c,"?") end -- достался - запомним, иначе заменим символ плагина на "?"
  end
  S.PlugStr = S.PlugStr:gsub("%?","") -- выкинем "?", для которых нет guidов плагинов в БД
else -- список не прочитан, берём умолчания
  S.PlugStr = "" -- инициализируем
  for n,v in pairs(Def.Plugins) do S.Plugins[n],S.PlugStr = v,S.PlugStr..n end -- возьмём значения по умолчанию
end
obj:Free() -- приберёмся
S.KP.Left1,S.KP.Right1 = S.KP.Left:gsub("\\[dDpP]",""),S.KP.Right:gsub("\\[dDpP]","") -- копии без признаков "только диски/плагины"
GetHints() LoadLang()
end --LoadSettings
--
function SaveSettings() --[[сохранить настройки в БД]]
if UsedProfile==F.PSL_LOCAL then win.CreateDir(win.GetEnv("FARLOCALPROFILE").."\\PluginsData") end -- создадим папку для локальных настроек, если надо
local obj = far.CreateSettings(nil,UsedProfile) -- откроем ранее прочитанные или предпочтительные настройки
local key = obj:CreateSubkey(obj:CreateSubkey(0,Author),ConfPart) -- откроем/создадим раздел
local function S1(n,v) v = (v==nil)and S[n]or v;v = v==true and 1 or v==false and 0 or v;local t = type(v)=="string" and F.FST_STRING or F.FST_QWORD
                       if obj:Get(key,n,t)~=v then obj:Set(key,n,t,v) end end
S1("UseHidden") S1("SwitchPanelsOn") S1("SpDelim") S1("LowerCurDrive") S1("OutStr") S1("OutCol") S1("ExcludeDrives") S1("PermPanel") S1("FixedPerm")
local mainkey = key -- основной раздел
key = obj:CreateSubkey(key,KeyPart) for n,v in pairs(S.KP) do S1(n,v) end -- сохраним список клавиш
key = obj:CreateSubkey(mainkey,PlugPart) S1("PlugStr") for n,v in pairs(S.Plugins) do S1(n,win.Uuid(v)) end -- сохраним список плагинов
obj:Free() -- приберёмся
end --SaveSettings
--
function MakePanel(full) --[[собрать панельку]]
local DP,p = full and "" or ((S.KP.Left.." "..S.KP.Right):match("\\([dDpP])"..Key)or ""):upper(),"" -- признак только дисков/плагинов, панель
for d in (DP~="P" and A_Z or ""):gmatch(".") do -- если диски выводить, заполним ими список
  if win.GetDriveType(d..":\\")~="no root directory" and not S.ExcludeDrives:cfind(d,1,true) then p = p..d end -- не отсутствует/исключён - добавим
end
return p..(DP~="D" and S.PlugStr or "").."?" -- полный список
end --MakePanel
--
function MakeOutPanel(p) return (p:gsub(".","%1"..(S.SpDelim and " " or "")):gsub(" $","")) end --[[собрать панельку для экрана]]
--
function GetDrive(P,DP) --[[определить букву диска на панели]]
if P.Path:sub(2,2)==":" and DP~="P" then -- на левой панели локальный диск? Выводим не только плагины?
  return P.Path:sub(1,1) -- его буква
elseif DP~="D" then -- не диск и выводим не только диски?
  local id = panel.GetPanelDirectory(nil,P==APanel and 1 or 0).PluginId -- guid плагина панели, если плагины выводятся
  for c,p in pairs(S.Plugins) do if p==id then return c end end -- переберём все обрабатываемые плагины. Нашли? Вернём
end
return " " -- неизвестно что, вернём пробел (запрещённый символ)
end --GetDrive
--
function CD(P,Drv) --[[установить новый диск/плагин]]
if Drv=="?" then Config() -- настройка? Вызовем
else -- для остальных
  panel.SetPanelDirectory(nil,P==APanel and 1 or 0,S.Plugins[Drv] and {PluginId=S.Plugins[Drv]} or Drv..":") -- установим панель плагина/диск
  if not P.Visible then -- панель скрыта?
    if S.SwitchPanelsOn==2 and APanel.Visible==PPanel.Visible then Keys("CtrlO") -- обе погашены и обе включить? Включим
    elseif S.SwitchPanelsOn~=0 then Keys("CtrlF"..(P.Left and 1 or 2)) end --включить одну? Включим изменяемую панель
  end
end
end --CD
--
function GetHints() --[[сформировать подсказки к плагинам]]
for n,v in pairs(S.Plugins) do -- для всех используемых плагинов
  local handle = far.FindPlugin(F.PFM_GUID,v) -- найдём
  if handle then -- есть?
    local PInfo = far.GetPluginInformation(handle) -- достанем информацию
    S.PDescr[n] = PInfo.GInfo.Title..", "..PInfo.GInfo.Description -- запомним подсказку
  end
end
end --GetHints
--
function Color(nColor) return far.AdvControl(F.ACTL_GETCOLOR,nColor) end --[[получить цвет по номеру]]
--
function ShowHelp(text) --[[Вывести справку]]
local HL = Far.GetConfig("Language.Help"):sub(1,3) -- язык (первые 3 буквы)
far.ShowHelp(PathName..(win.GetFileAttr(PathName..HL..".hlf") and HL or "Eng")..".hlf",text,F.FHELP_CUSTOMFILE) -- выведем
end --ShowHelp
--
if type(nfo)=="table" then nfo.help = function() ShowHelp() end end
-- +
--[[настройка]]
-- -
function Config()
--
LoadLang() if not L.Lang then return far.Message(L[1],nfo.name,";Ok","w") end -- нет языковой информации - скажем и выйдем
--
local AllPlugs,TmpPlugins,TmpStr,ShowHidden,ov = {},{} -- инициализируем
--
local function PluginList() -- выбор плагинов для обработки
local WorkPlugins,WorkStr = {} -- инициализируем
--
local function SwitchChar(item) -- переключить выбранность плагина и ввести символ для него
local rt,VK = {BackSlash="\\",Divide="/",Multiply="*",Subtract="-",Add="+"} -- таблица замены символов, вводимых названиями
if item.separator then return end -- сепаратор не обрабатываем
if item.checked then -- включён - выключим
  item.checked = nil
else -- выключен - включим
  local h = far.SaveScreen()
  repeat
    far.Message(L.PressKey,L.diConf.PlugCharHdr:format(item.text,WorkStr),"") far.Text() VK=mf.waitkey() -- введём клавишу
    if VK=="Esc" then far.RestoreScreen(h) return end -- Esc - выйдем
    if VK:len()>1 then VK = rt[VK] end-- исправим названия на сами символы (и отсечём остальные)
    if VK and (A_Z..".?"..WorkStr):cfind(VK:upper(),1,true) then VK = nil end -- отсечём возможные имена дисков, вопрос, точку, а также использованные
  until VK
  far.RestoreScreen(h)
  item.checked = VK:upper()
end
end --SwitchChar
-- начало PluginList
if #AllPlugs==0 then -- Заполним таблицу всех плагинов
  local ffi = require"ffi"
  ffi.cdef[[
BOOL FreeLibrary(HMODULE hModule); //https://msdn.microsoft.com/library/ms683152
HMODULE LoadLibraryExW(LPCTSTR lpFileName,HANDLE hFile,DWORD dwFlags); //https://msdn.microsoft.com/library/ms684179
int GetProcAddress(HMODULE hModule,LPCSTR lpProcName); //https://msdn.microsoft.com/library/ms683212
]]
  local fC,DONT_RESOLVE_DLL_REFERENCES = ffi.C,0x00000001
  for _,p in ipairs(far.GetPlugins()) do -- переберём все плагины
    local pinfo = far.GetPluginInformation(p) -- информация о плагине
    if pinfo and band(pinfo.PInfo.Flags,F.PF_DISABLEPANELS)==0 then -- плагин на месте и работает с панелями?
      local hmod,ProcAddress = fC.LoadLibraryExW(ffi.cast("void*",win.Utf8ToUtf16(pinfo.ModuleName.."\0")),nil,DONT_RESOLVE_DLL_REFERENCES) -- грузим
      if hmod~=nil then -- загрузился?
        ProcAddress = fC.GetProcAddress(hmod,"ProcessPanelInputW") -- попробуем достать адрес обработчика панелей
        fC.FreeLibrary(hmod) -- выгрузим плагин обратно
      end
      AllPlugs[pinfo.GInfo.Guid] = {text=pinfo.GInfo.Title,panel=ProcAddress~=0} -- запомним плагин
    end
  end
end
WorkStr = TmpStr -- скопируем строку отмеченных плагинов
for n,v in pairs(TmpPlugins) do WorkPlugins[n] = v end -- скопируем список плагинов для работы
local prop = {Flags = F.FMENU_SHOWAMPERSAND+F.FMENU_WRAPMODE,Bottom="Ins, Space, Num+, Num-, Num*, CtrlUp, CtrlDown, Enter, Esc, F1, CtrlH"}
local bkeys = {{BreakKey="INSERT"},{BreakKey="NUMPAD0"},{BreakKey="SPACE"},{BreakKey="ADD"},{BreakKey="SUBTRACT"},{BreakKey="MULTIPLY"}
  ,{BreakKey="C+UP"},{BreakKey="C+DOWN"},{BreakKey="C+NUMPAD8"},{BreakKey="C+NUMPAD2"},{BreakKey="F1"},{BreakKey="C+H"},{BreakKey="RETURN"}}
repeat -- рабочий цикл
  local items,RevPlugins = {},{} -- массив элементов меню, инвертированный массив отмеченных плагинов
  for c in WorkStr:gmatch(".") do -- все отмеченные плагины по порядку
    local uid = WorkPlugins[c] -- guid плагина
    local item = AllPlugs[uid] -- информация о плагине
    items[#items+1],RevPlugins[uid] = {text=item.text,id=uid,checked=c},c -- добавим элемент меню, запомним, что этот плагин отмеченный
  end
  items[#items+1] = {separator=true} -- добавим разделитель
  for uid,item in pairs(AllPlugs) do -- все плагины как попало
    if not RevPlugins[uid] and (item.panel or ShowHidden) then -- если неотмеченный и панельный или показывать все
      items[#items+1] = {text=item.text,id=uid,grayed=not item.panel} -- добавим элемент меню
    end
  end
  local res,pos = far.Menu(prop,items,bkeys) -- выведем список плагинов
  if not res then return end -- нажали Esc? Выйдем
  if res.BreakKey then
    prop.SelectIndex=pos -- запомним текущую позицию
    if res.BreakKey=="INSERT" or res.BreakKey=="NUMPAD0" or res.BreakKey=="SPACE" then -- Ins/Space
      SwitchChar(items[pos]) -- переключим
    elseif res.BreakKey=="ADD" then -- Num+
      for _,v in ipairs(items) do if not v.checked then SwitchChar(v) end end -- выделим всё
    elseif res.BreakKey=="SUBTRACT" then -- Num-
      for _,v in ipairs(items) do if v.checked then SwitchChar(v) end end -- снимем выделение со всех
    elseif res.BreakKey=="MULTIPLY" then -- Num*
      for _,v in ipairs(items) do SwitchChar(v) end -- инвертируем выделение
    elseif res.BreakKey=="C+UP" or res.BreakKey=="C+NUMPAD8" then -- CtrlUp
      if items[pos].checked and pos~=1 then -- отмеченный и не первый?
        items[pos],items[pos-1],prop.SelectIndex = items[pos-1],items[pos],pos-1 -- поменяем местами
      end
    elseif res.BreakKey=="C+DOWN" or res.BreakKey=="C+NUMPAD2" then -- CtrlDowd
      if items[pos].checked and not items[pos+1].separator then -- отмеченный и не последний из них?
        items[pos],items[pos+1],prop.SelectIndex = items[pos+1],items[pos],pos+1 -- поменяем местами
      end
    elseif res.BreakKey=="F1" then -- F1
      ShowHelp("Plugins")
    elseif res.BreakKey=="C+H" then -- CtrlH
      ShowHidden = not ShowHidden -- покажем/скроем непанельные плагины
    elseif res.BreakKey=="RETURN" then -- Enter
      TmpPlugins,TmpStr = WorkPlugins,WorkStr
      return -- выйдем с новыми значениями
    end
  end
  WorkStr,WorkPlugins = "",{} -- скорректируем информацию об отмеченных плагинах
  for _,v in ipairs(items) do -- переберём все элементы меню
    if v.checked then WorkStr,WorkPlugins[v.checked] = WorkStr..v.checked,v.id end-- допишем отмеченные
  end
until false
end
--
local function DlgProc(hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_BTNCLICK and Param1==2 then -- переключение работы со скрытыми панелями?
  hDlg:send(F.DM_SHOWITEM,3,Param2) -- установим видимость зависимого чекбокса
elseif Msg==F.DN_KILLFOCUS and (Param1==5 or Param1==7 or Param1==9 or Param1==11) then -- префикс?
  local nv = hDlg:send(F.DM_GETTEXT,Param1) -- новое значение
  for ss in nv:gmatch("%S+") do -- проверим каждый префикс из списка
    if not regex.match(ss,"^((?:R?Ctrl)?(?:R?Alt)?(?:Shift)?)$") then hDlg:send(F.DM_SETTEXT,Param1,ov) return end -- новое значение плохое? откатим
    for i = 5,11,2 do if Param1~=i and (" "..hDlg:send(F.DM_GETTEXT,i).." "):cfind(" "..ss.." ") then hDlg:send(F.DM_SETTEXT,Param1,ov) return end end
  end
  hDlg:send(F.DM_SETTEXT,Param1,nv:gsub("%s%s+"," "):gsub("^%s+",""):gsub("%s+$","")) -- почистим пробелы
elseif Msg==F.DN_KILLFOCUS and (Param1==13 or Param1==15) then -- стрелка?
  local nv = hDlg:send(F.DM_GETTEXT,Param1) -- новое значение
  for ss in nv:gmatch("%S+") do -- проверим каждую клавишу из списка на дублирование в другом
    if (" "..hDlg:send(F.DM_GETTEXT,13+15-Param1).." "):cfind(" "..ss.." ",1,true) then hDlg:send(F.DM_SETTEXT,Param1,ov) return end -- есть? откатим
  end
  hDlg:send(F.DM_SETTEXT,Param1,nv:gsub("%s%s+"," "):gsub("^%s+",""):gsub("%s+$","")) -- почистим пробелы
elseif Msg==F.DN_KILLFOCUS and Param1==19 then -- строка вывода?
  local rest,n = (hDlg:send(F.DM_GETTEXT,Param1)..";"):gsub("(%-?%d+)[;,]","")
  if n<1 or rest~="" then hDlg:send(F.DM_SETTEXT,Param1,ov) end -- новое значение плохое? откатим
elseif Msg==F.DN_EDITCHANGE and Param1==23 then -- сменилось значение поля ввода "исключаемые диски"?
  local CP = hDlg:send(F.DM_GETCURSORPOS,Param1) -- запомним координаты курсора
  hDlg:send(F.DM_SETTEXT,Param1,A_Z:gsub("[^"..hDlg:send(F.DM_GETTEXT,Param1):upper():gsub("[^"..A_Z.."]","").."]","")) -- поправим и запишем
  hDlg:send(F.DM_SETCURSORPOS,Param1,CP) -- восстановим позицию курсора
elseif Msg==F.DN_BTNCLICK and Param1==24 then -- выбор плагинов
  PluginList()
elseif Msg==F.DN_BTNCLICK and Param1==25 then -- переключение работы с постоянными панелями?
  hDlg:send(F.DM_SHOWITEM,Param1+1,Param2) -- установим видимость зависимого чекбокса
elseif (Msg==F.DN_CONTROLINPUT and (Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0))or(Msg==F.DN_BTNCLICK and Param1==30) then
  ShowHelp("Config") -- F1 или нажата кнопка справки
elseif Msg==F.DN_GOTFOCUS then -- зашли на поле
  ov = hDlg:send(F.DM_GETTEXT,Param1) -- запомним старое значение
elseif Msg==F.DN_CLOSE then
  hDlg:send(F.DM_SETFOCUS,2) -- переключимся на чекбокс
end
end
--
local form = { -- диалог настройки конфигурации
--[[01]] {F.DI_DOUBLEBOX, 3, 1,62,14,0,0,0,0,L.diConf.Hdr},
--[[02]] {F.DI_CHECKBOX,  5, 2, 0, 2,S.UseHidden and 1 or 0,0,0,0,L.diConf.UseHidden},
--[[03]] {F.DI_CHECKBOX, 37, 2, 0, 2,({[0]=0,2,1})[S.SwitchPanelsOn],0,0,F.DIF_3STATE+(S.UseHidden and 0 or F.DIF_HIDDEN),L.diConf.SwitchPanelsOn},
--[[04]] {F.DI_TEXT,      5, 3, 0, 3,0,0,0,0,L.diConf.L},
--[[05]] {F.DI_EDIT,     13, 3,30, 3,0,0,0,0,S.KP.L},
--[[06]] {F.DI_TEXT,      5, 4, 0, 4,0,0,0,0,L.diConf.R},
--[[07]] {F.DI_EDIT,     13, 4,30, 4,0,0,0,0,S.KP.R},
--[[08]] {F.DI_TEXT,     32, 3, 0, 3,0,0,0,0,L.diConf.A},
--[[09]] {F.DI_EDIT,     43, 3,60, 3,0,0,0,0,S.KP.A},
--[[10]] {F.DI_TEXT,     32, 4, 0, 4,0,0,0,0,L.diConf.P},
--[[11]] {F.DI_EDIT,     43, 4,60, 4,0,0,0,0,S.KP.P},
--[[12]] {F.DI_TEXT,      5, 5, 0, 5,0,0,0,0,L.diConf.Left},
--[[13]] {F.DI_EDIT,     13, 5,30, 5,0,0,0,0,S.KP.Left},
--[[14]] {F.DI_TEXT,     32, 5, 0, 5,0,0,0,0,L.diConf.Right},
--[[15]] {F.DI_EDIT,     43, 5,60, 5,0,0,0,0,S.KP.Right},
--[[16]] {F.DI_CHECKBOX,  5, 6, 0, 6,S.SpDelim and 1 or 0,0,0,0,L.diConf.SpDelim},
--[[17]] {F.DI_CHECKBOX,  5, 7, 0, 7,S.LowerCurDrive and 1 or 0,0,0,0,L.diConf.LowerCurDrive},
--[[18]] {F.DI_TEXT,      5, 8, 0, 8,0,0,0,0,L.diConf.OutStr},
--[[19]] {F.DI_EDIT,     32, 8,50, 8,0,0,0,0,S.OutStr},
--[[20]] {F.DI_TEXT,     51, 8, 0, 8,0,0,0,0,L.diConf.OutCol},
--[[21]] {F.DI_EDIT,     56, 8,59, 8,0,0,0,0,S.OutCol},
--[[22]] {F.DI_TEXT,      5, 9, 0, 9,0,0,0,0,L.diConf.ExcludeDrives},
--[[23]] {F.DI_EDIT,  34, 9,59, 9,0,0,0,0,S.ExcludeDrives},
--[[24]] {F.DI_BUTTON,    0,10, 0,10,0,0,0,F.DIF_CENTERGROUP+F.DIF_BTNNOCLOSE,L.diConf.Plugins},
--[[25]] {F.DI_CHECKBOX,  5,11, 0,11,S.PermPanel and 1 or 0,0,0,0,L.diConf.PermPanel},
--[[26]] {F.DI_CHECKBOX, 37,11, 0,11,S.FixedPerm and 1 or 0,0,0,S.PermPanel and 0 or F.DIF_HIDDEN,L.diConf.FixedPerm},
--[[27]] {F.DI_TEXT,     -1,12, 0,12,0,0,0,F.DIF_SEPARATOR,""},
--[[28]] {F.DI_BUTTON,    0,13, 0,13,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[29]] {F.DI_BUTTON,    0,13, 0,13,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
--[[30]] {F.DI_BUTTON,    0,13, 0,13,0,0,0,F.DIF_CENTERGROUP+F.DIF_BTNNOCLOSE,L.Help},
}
-- начало кода функции
TmpStr = S.PlugStr -- скопируем строку отмеченных плагинов
for n,v in pairs(S.Plugins) do TmpPlugins[n] = v end -- скопируем список отмеченных плагинов для работы
if far.Dialog(Guids.ConfDialog,-1,-1,66,15,nil,form,nil,DlgProc)~=28 then return false,L.er.Cancel end -- вызовем диалог, не "ОК" - уйдём
local NeedReload = S.KP.L..S.KP.R..S.KP.A..S.KP.P..S.KP.Left..S.KP.Right~=
                   form[5][10]..form[7][10]..form[9][10]..form[11][10]..form[13][10]..form[15][10]
S = { UseHidden = form[2][6]==1,SwitchPanelsOn = ({[0]=0,2,1})[form[3][6]],SpDelim = form[16][6]==1,LowerCurDrive = form[17][6]==1,
      OutStr = form[19][10],OutCol = tonumber(form[21][10]),ExcludeDrives = form[23][10],PermPanel = form[25][6]==1,FixedPerm = form[26][6]==1,
      PlugStr = TmpStr,Plugins = TmpPlugins,KP = {L=form[5][10],R=form[7][10],A=form[9][10],P=form[11][10],Left=form[13][10],Right=form[15][10],
                                                  Left1=form[13][10]:gsub("\\[dDpP]",""),Right1=form[15][10]:gsub("\\[dDpP]","")},PDescr = {} }
GetHints()
SaveSettings() if NeedReload then far.MacroLoadAll() end -- если клавиши изменились, надо перезагрузить макросы
end
--
if type(nfo)=="table" then nfo.config = Config end
-- +
--[[обработчик по таймеру]]
-- -
function OnTimer(tmr)
if not S.PermPanel then return end
if stop_timer then -- всё?
  tmr:Close() -- выключаемся
elseif not in_process and Area.Current and ("Shell Info QView Tree Search"):find(Area.Current) then -- свободны и в панели?
  LoadLang()
  local StdColor,SelColor,StartColor = Color(C.COL_PANELTEXT),Color(C.COL_PANELCURSOR),Color(C.COL_PANELSELECTEDTITLE) -- стандартный,курсор,начальный
  local LPanel,RPanel = APanel.Left and APanel or PPanel,APanel.Left and PPanel or APanel -- левая и правая панели
  local OutList = MakeOutPanel(MakePanel(true)) -- выводимый на экран список
  local DrvL,DrvR = (OutList:cfind(GetDrive(LPanel),1,true)),(OutList:cfind(GetDrive(RPanel),1,true)) -- диски/плагины по умолчанию слева и справа
  local x,y,l,lw,yOK = Mouse.X,Mouse.Y,OutList:len(),LPanel.Width -- координаты курсора мыши, длина панели, ширина левой панели
  panel.RedrawPanel(nil,0) panel.RedrawPanel(nil,1)
  in_process = true -- сообщим, что начали работу
  for nstr in (S.OutStr..";"):gmatch("(%-?%d+)[;,]") do nstr = tonumber(nstr) -- переберём все номера строк
    if LPanel.Visible or S.FixedPerm then -- левая панель не скрыта или панели постоянные?
      local nstr1 = nstr<0 and LPanel.Height+nstr or nstr -- Если № строки для вывода<0, то отсчитывать от нижней строки вверх
      if S.FixedPerm or (y==nstr1 and x>S.OutCol and x<=l+S.OutCol) then -- если выводить всегда, или курсор мыши в соответствующих координатах
        far.Text(S.OutCol,nstr1,StdColor,"["..OutList.."]") -- отрисуем список дисков
        if DrvL then far.Text(S.OutCol+DrvL,nstr1,StartColor,OutList:sub(DrvL,DrvL)) end -- и стартовый диск
        yOK = yOK or nstr1==y if not S.FixedPerm then break end -- запомним, если мышь в мини-панели; если панели не фиксированные, то других не будет
      end
    end
    if RPanel.Visible or S.FixedPerm then -- левая панель не скрыта или панели постоянные?
      local nstr1 = nstr<0 and RPanel.Height+nstr or nstr -- Если № строки для вывода<0, то отсчитывать от нижней строки вверх
      if S.FixedPerm or (y==nstr1 and x>lw+S.OutCol and x<=lw+l+S.OutCol) then -- если выводить всегда, или курсор мыши в соответствующих координатах
        far.Text(lw+S.OutCol,nstr1,StdColor,"["..OutList.."]") -- отрисуем список дисков
        if DrvR then far.Text(lw+S.OutCol+DrvR,nstr1,StartColor,OutList:sub(DrvR,DrvR)) end -- и стартовый диск
        yOK = yOK or nstr1==y if not S.FixedPerm then break end -- запомним, если мышь в мини-панели; если панели не фиксированные, то других не будет
      end
    end
  end
  local offset = (x>lw and x-lw or x)-S.OutCol -- смещение курсора мыши в мини-панели
  local char = OutList:sub(offset,offset) -- символ под мышью
  if offset>0 and offset<=l and yOK and char~=" " then -- если строка и столбец совпадают, и под курсором не промежуток между символами
    local WP = (x>lw) and RPanel or LPanel -- панель под мышью
    far.Text(x,y+1,SelColor,char=="?" and L.diConf.Hdr or char..":"==WP.Path:sub(1,2) and WP.Path or far.LIsAlpha(char) and far.ConvertPath(char..":")
                               or S.PDescr[char] or "") -- выведем подсказку
  end
  in_process = false -- сообщим, что закончили работу
end
end
-- +
--[[Macro condition - инициализация переменных и проверка условий]]
-- -
function TestCond(key)
WPanel,KeyMod,Key = nil,regex.match(key,"^((?:.?Ctrl)?(?:.?Alt)?(?:Shift)?(?<=.))(.*)$") -- обнулим рабочую панель, запомним клавишу и модификатор
local LRAP = {L=APanel.Left and APanel or PPanel,R=APanel.Left and PPanel or APanel,A=APanel,P=PPanel} -- возможные значения рабочей панели
for p,k in pairs(S.KP) do if (" "..k.." "):cfind(" "..KeyMod.." ",1,true) then WPanel = LRAP[p] end end -- найдём рабочую панель
if WPanel and WPanel.Type~=0 then WPanel = WPanel==APanel and PPanel or APanel end-- если рабочая панель не файловая, переключаем на другой
return WPanel and WPanel.Type==0 and (WPanel.Visible or S.UseHidden) and (CmdLine.Empty or not KeyMod:cfind("Ctrl"))
end
-- +
--[[Macro action]]
-- -
function ChangeDrive()
LoadLang()
local StdColor,SelColor,StartColor = Color(C.COL_PANELTEXT),Color(C.COL_PANELCURSOR),Color(C.COL_PANELSELECTEDTITLE) -- стандартный,курсор,начальный
local PanelPos = WPanel.Left and S.OutCol or S.OutCol+(APanel.Left and APanel.Width or PPanel.Width) -- позиция начала панели дисков
local DrvList,DrvNum = (MakePanel()) -- список дисков в системе, номер текущего диска в списке
DrvNum = DrvList:cfind(GetDrive(WPanel,((S.KP.Left.." "..S.KP.Right):match("\\([dDpP])"..Key)or ""):upper()),1,true)
if not DrvNum then DrvNum,DrvList = 1,"."..DrvList end -- не нашли? Добавим в первую позицию условное текущее содержимое панели
local StartDrv,StartOut = DrvNum,PanelPos+DrvNum+(S.SpDelim and DrvNum-1 or 0) -- начальные диск, позиция
if S.LowerCurDrive then DrvList = DrvList:sub(1,DrvNum-1)..DrvList:sub(DrvNum,DrvNum):lower()..DrvList:sub(DrvNum+1) end -- выделим его в панели
local OutList,h,s1 = MakeOutPanel(DrvList),far.SaveScreen() -- выводимый на экран список; сохраним весь экран, кто его (юзера) знает...
in_process = true
repeat -- Обработаем очередное нажатие стрелки
  if Key~="" then
    if Key=="Home" then DrvNum = StartDrv
    elseif Key=="End" then DrvNum = DrvList:len()
    elseif Key=="F1" then DrvNum = StartDrv ShowHelp("Main")
    elseif DrvList:cfind(Key:upper(),1,true) then DrvNum = DrvList:cfind(Key:upper(),1,true)
    elseif (" "..S.KP.Left1.." "):cfind(" "..Key.." ",1,true) then DrvNum = DrvNum-1
    elseif (" "..S.KP.Right1.." "):cfind(" "..Key.." ",1,true) then DrvNum = DrvNum+1 end
    DrvNum = ((DrvNum-1+DrvList:len())%DrvList:len())+1 -- корректировка выхода за начало/конец
    for nstr in (S.OutStr..";"):gmatch("(%-?%d+)[;,]") do -- переберём все номера строк
      nstr = tonumber(nstr) nstr = nstr<0 and WPanel.Height+nstr or nstr -- Если № строки для вывода<0, то отсчитывать от нижней строки вверх
      far.Text(PanelPos,nstr,StdColor,"["..OutList.."]") -- отрисуем список дисков
      far.Text(StartOut,nstr,StartColor,DrvList:sub(StartDrv,StartDrv)) -- и стартовый диск
      far.Text(PanelPos+DrvNum+(S.SpDelim and DrvNum-1 or 0),nstr,SelColor,DrvList:sub(DrvNum,DrvNum)) -- и курсор
    end
    local nstr,char = tonumber(S.OutStr:match("^%d+")),DrvList:sub(DrvNum,DrvNum) -- строка мини-панели для подсказки, символ для подсказки
    if s1 then far.RestoreScreen(s1) end s1 = far.SaveScreen(1,nstr+1,Far.Width,nstr+1) -- восстановим строку для подсказки и снова запомним
    far.Text(PanelPos+DrvNum+(S.SpDelim and DrvNum-1 or 0),nstr<0 and WPanel.Height+nstr+1 or nstr+1,SelColor,char=="?" and L.diConf.Hdr -- подсказка
      or char==DrvList:sub(StartDrv,StartDrv) and WPanel.Path or far.LIsAlpha(char) and far.ConvertPath(char..":") or S.PDescr[char] or "")
    far.Text()
  end
  Key = mf.waitkey(100):gsub(KeyMod,"") -- очередное нажатие (или пустая строка)
until (KeyMod~="" and band(Mouse.LastCtrlState,0x1f)==0)or Key=="Enter" or Key=="Esc" -- условие окончания с учётом вызова из меню
if Key=="Esc" then DrvNum = StartDrv end -- если вызвали из меню и нажали Esc, то отменим смену диска
far.RestoreScreen(h) -- восстановим испорченный участок экрана
if DrvNum~=StartDrv then CD(WPanel,DrvList:sub(DrvNum,DrvNum)) end -- выбрали другой диск/плагин? Сменим
in_process = false
end
--
if type(nfo)=="table" then nfo.execute = function() Key = "Home" KeyMod = "" WPanel = APanel ChangeDrive() end end
-- +
--[[Event mouse condition]]
-- -
function MouseCond(tInputRecord)
return S.PermPanel and tInputRecord.EventType==F.MOUSE_EVENT and tInputRecord.ButtonState==F.FROM_LEFT_1ST_BUTTON_PRESSED
   and band(tInputRecord.ControlKeyState,0x1f)==0 and tInputRecord.EventFlags==0
end
-- +
--[[Event mouse action]]
-- -
function MouseProc(tInputRecord)
local y,x = tInputRecord.MousePositionY,tInputRecord.MousePositionX -- координаты курсора мыши
local LWidth,OutList = APanel.Left and APanel.Width or PPanel.Width,MakeOutPanel(MakePanel(true)) -- ширина левой панели, выводимый на экран список
local WP = ((x<LWidth)==APanel.Left) and APanel or PPanel -- рабочая панель Far
local x1,l = (x<LWidth and x or x-LWidth)-S.OutCol,OutList:len() -- позиция в панели, длина панели
if x1<1 or x1>l or not (WP.Visible or S.FixedPerm) then return 0 end -- если позиция не в панели или скрытая панель, и скрытые игнорируем, не работаем
local NewDrive = OutList:sub(x1,x1) -- новый диск/плагин
for nstr in (S.OutStr..";"):gmatch("(%-?%d+)[;,]") do -- переберём все номера строк
  nstr = tonumber(nstr) nstr = nstr<0 and WP.Height+nstr or nstr -- Если № строки для вывода<0, то отсчитывать от нижней строки вверх
  if y==nstr and NewDrive~=" " then -- строка с панелью, попали в диск, а не между?
    if NewDrive~=GetDrive(WP) then CD(WP,NewDrive) end -- выбрали другой диск? Сменим
    return 1 -- Far ничего уже не делает
  end
end
return 0 -- сами так ничего и не сделали, пусть Far поработает
end
--
LoadSettings() --[[первичная загрузка настроек]]
-- +
--[[Запуск таймера отрисовки панелей]]
-- -
if Macro then far.Timer(Period,OnTimer) end
-- +
--[[Макрос вызова]]
-- -
Macro{
area = "Shell Info QView Tree Search"; key="/(.Ctrl)?(.Alt)?(Shift)?(?<=.)("..(S.KP.Left1.." "..S.KP.Right1):gsub(" ","|")..")/";
  [(LMBuild<579 and "u" or "").."id"] = Guids.Macro; description = L.Desc; condition = TestCond; action = ChangeDrive;
}
-- +
--[[Обработка нажатия мыши на панели]]
-- -
Event{
  [(LMBuild<579 and "u" or "").."id"] = Guids.MouseEvent; group = "ConsoleInput"; description = nfo.name..(L.MouseDesc or "");
  condition = MouseCond; action = MouseProc;
}
-- +
--[[Перед выходом выключим таймер]]
-- -
Event{
  [(LMBuild<579 and "u" or "").."id"] = Guids.ExitEvent; group = "ExitFAR"; description = nfo.name..(L.ExitDesc or "");
  condition = function() return S.PermPanel and not stop_timer end; action = function() stop_timer = true end;
}
-- +
--[[Пункт меню]]
-- -
MenuItem {
  description = L.Desc; menu = "Plugins Config"; area = "Shell"; guid = Guids.PlugMenu; text = function() return L.Desc end;
  action = function(OpenFrom)
if not OpenFrom then Config() return -- меню конфигурации?
elseif OpenFrom==F.OPEN_LEFTDISKMENU then WPanel = APanel.Left and APanel or PPanel -- левое меню дисков?
elseif OpenFrom==F.OPEN_RIGHTDISKMENU then WPanel = APanel.Left and PPanel or APanel -- правое меню дисков?
elseif OpenFrom==F.OPEN_PLUGINSMENU then WPanel = APanel end -- меню плагинов?
KeyMod,Key = "","Home" ChangeDrive()
  end;
}