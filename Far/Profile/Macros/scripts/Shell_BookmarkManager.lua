local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {_filename or ...,
  name          = "Bookmark manager";
  description   = "Менеджер закладок на папки для Fara";
  version       = "2.5.4"; --http://semver.org/lang/ru/
  author        = "IgorZ";
  url           = "http://forum.farmanager.com/viewtopic.php?t=8465";
  id            = "F93842EB-FFD3-481A-8AA8-2E7DCEBDF2B1";
  minfarversion = {3,0,0,4000,0};
  files         = "*Eng.hlf;*Rus.hlf;*Eng.lng;*Rus.lng";
  helptxt       = [[
Управление:
 RCtrl+Shift+последовательность клавиш - запомнить закладку на текущую папку
 RCtrl+Alt+последовательность клавиш   - запомнить закладку на обе папки
 RCtrl+последовательность клавиш       - перейти на закладку/переменную окружения
 RCtrl+/                               - меню закладок

Префиксы командной строки:
 bm            - перейти по закладке/переменной окружения
 bma/bmal/bmag - добавить закладку/локальную закладку/глобальную закладку
 bme/bmel/bmeg - редактировать в диалоге закладку/локальную закладку/глобальную закладку
 bmr/bmrl/bmrg - удалить закладку/локальную закладку/глобальную закладку
 bmhelp        - вызов справки
Поскольку имена закладок переводятся в символы, набираемые при нажатом Ctrl, то, к примеру, bm:Фильмы равнозначна bm:ABKMVS. Пользуйтесь.
При переходе после имени закладки можно указать подкаталог, к примеру, "bm:фильмы\Мульфильмы\Фиксики".
]];
history         = [[
2014/01/21 v1.0   - Первый релиз
2014/01/27 v1.0.1 - Исправлена ошибка, когда скрипт не запускался, пока не вызовешь меню закладок, мелкие правки
2014/01/27 v1.0.2 - Локализация работы с настройками, более корректная обработка ситуации, когда локальный и глобальный
                    профили совпадают и когда не совпадают, мелкие правки
2014/01/28 v1.0.3 - Сообщение при сохранении новой закладки, мелкие правки
2014/01/29 v1.0.4 - Небольшая оптимизация формирования меню, поддержка плагиновых панелей, мелкие правки
2014/02/04 v1.1   - Поддержка установки одновременно активной и пассивной панели, мелкие правки.
                    Экспериментально: изменён принцип хранания и загрузки языковых данных. Просьба отписаться в теме,
                    который вариант лучше
2014/02/04 v1.1.1 - Корректная обработка пустой строки в языковом файле
2014/02/05 v1.1.2 - Исправлена ошибка с обращением к старым языковым файлам, мелкие правки
2014/06/30 v1.2.0 - Расширение формата каталога. Теперь можно указывать панели: активную, пассивную, левую, правую. Изгнание io.lines.
                    Если языка нет, подгружается английский, при загрузке настроек язык не подгружается, если не менялся. Мелкие правки.
2014/11/14 v1.2.1 - Срабатывание быстрых клавиш в меню RCtrl+/, рефакторинг, добавим uid-ы в макросы и пункт в меню плагинов
2015/01/26 v1.2.2 - "&" в меню отрабатывался как акселератор, а не символ. Запрет вводить символы, которые нельзя ввести в сочетании с Ctrl.
2015/02/06 v1.2.3 - В версии 1.2.1 была поломана загрузка части параметров, в результате чего при некоторых комбинациях настроек скрипт падал
                    при попытке создать новую закладку.
2015/06/01 v1.2.4 - Скрипт зачем-то вызывался из любых меню. В целях унификации с другими скриптами автора изменен механизм языковой настройки.
                    Исправлена ошибка с разной шириной столбца закладок для локальных и глобальных закладок. Теперь в менеджере закладок по F4
                    закладка не копируется при её изменении. Для копирования жать F5.
2015/12/09 v2.0.0 - Помимо закладок поддерживаются переменные окружения (только переход на папки). Если закладка или переменная набрана частично,
                    выводится список всех, содержащих набранный фрагмент. Мелкие правки.
2015/12/15 v2.0.1 - Мелкие правки.
2016/01/24 v2.1.0 - Добавлена работа из командной строки через префиксы. Можно переходить по закладкам и переменным окружения,
                    добавлять/редактировать в диалоге/удалять закладки. Рефакторинг. Исправление кучи внезапно обнаруженных ошибок.
2016/02/08 v2.1.1 - Сокращённые меню позволяют все те же действия, что и полное. Комбинации RCtrlЦифра передаются Far-у, если такой закладки
                    или переменной нет. Не совпадающие даже частично ни с одной закладкой или переменной окружения, содержащей путь, тоже.
2016/02/11 v2.1.2 - При вызове через префикс несуществующая комбинация не возвращается в виде нажатий клавиатуры.
2016/02/26 v2.2.0 - Настройка вынесена в отдельный диалог. Улучшены диалоги для совпадающих локального и глобального профилей. Переработана справка.
                    Добавлен префикс для вызова справки. Мелкие правки.
2016/02/29 v2.2.1 - Исправлена ошибка, из-за которой не показывалась справка.
2016/10/26 v2.3.0 - Теперь можно использовать в командной строке конструкции вида "bm:<метка><подкаталог>", к примеру, "bm:фильмы\Мульфильмы\Фиксики".
                    Nfo. Смена места хранения данных. Разделение префиксов. При выводе справки используется язык справки фара. Улучшение
                    быстрого позиционирования в главном меню. Мелкие правки.
2016/10/26 v2.3.1 - В прошлой версии забыл сменить uid на id в зависимости от версии LuaMacro. Изменено определение Info.
2017/05/11 v2.4.0 - Скрипт можно вызывать из меню дисков; показываются только актуальные пункты. Исправлены замеченные ошибки. Мелкие правки.
2017/05/15 v2.4.1 - Исправлены свежевыявленные ошибки.
2017/08/01 v2.4.2 - Исправлена ошибка с вызовом меню при пустом списке закладок. Исправлены свежевыявленные ошибки в справке.
2017/08/03 v2.4.3 - Исправлена работа с закладками на плагины.
2017/08/08 v2.5.0 - Изменён формат хранения закладок в БД. Старый формат пока поддерживается. Рефакторинг.
2017/08/11 v2.5.1 - Исправлены некоторые недоделки и упущения предыдущей версии.
2017/08/12 v2.5.2 - Исправлен вызов из меню дисков, там же изменена логика работы.
2017/10/24 v2.5.3 - Теперь можно указать с помощью модификатора "C" необходимость смены панели. Подробности в справке.
2018/01/05 v2.5.4 - Работа над ошибками.
]];
}
if not nfo then return end
--
-- константы
local F,Author,KeysPart,ConfPart = far.Flags,"IgorZ","BookmarkManagerData","BookmarkManagerConfig"
local ToCtrl = { -- таблица замены символов на те, которые вводятся с Ctrl
["~"]="`",["!"]="1",["@"]="2",["#"]="3",["№"]="3",["$"]="4",["%"]="5",["^"]="6",["&"]="7",["*"]="8",["("]="9",
[")"]="0",["_"]="-",["+"]="=",["{"]="[",["}"]="]",[":"]=";",['"']="'",["<"]=",",[">"]=".",["?"]="/",
["Ё"]="`",["Й"]="Q",["Ц"]="W",["У"]="E",["К"]="R",["Е"]="T",["Н"]="Y",["Г"]="U",["Ш"]="I",["Щ"]="O",["З"]="P",
["Х"]="[",["Ъ"]="]",["Ф"]="A",["Ы"]="S",["В"]="D",["А"]="F",["П"]="G",["Р"]="H",["О"]="J",["Л"]="K",["Д"]="L",
["Ж"]=";",["Э"]="'",["Я"]="Z",["Ч"]="X",["С"]="C",["М"]="V",["И"]="B",["Т"]="N",["Ь"]="M",["Б"]=",",["Ю"]=".",
[" "]="",["|"]="",["\\"]="",
}
local Guids = {
  LuaMacro = win.Uuid("4EBBEFC8-2084-4B7F-94C0-692CE136894D"); -- guid LuaMacro
  SaveMacro   = "2F17BA22-2438-4D7C-AF5C-A838CD023608",
  GoToMacro   = "97ADF907-40BC-4FF5-945F-ABF69687C848",
  MenuMacro   = "33668CB0-4F8F-4F85-98E4-B47B949E1D4B",
  QSMenuMacro = "FF47C3A8-42B5-4817-9AB5-051155BD0716",
  PlugMenu    = "7CD7B065-FC92-4859-AFB1-F042485542B5",
  Menu        = win.Uuid("0E0B4A2B-BC1F-44D4-A986-C24E48142955"),
  diEdit      = win.Uuid("6BDD26FF-1D69-492C-A023-94B9AFF58F0F"),
  Config      = win.Uuid("CF79A927-A0B9-4B13-9DEB-A39E2DAA7CC6"),
}
local LMBuild = far.GetPluginInformation(far.FindPlugin(F.PFM_GUID,Guids.LuaMacro)).GInfo.Version[4] -- запомним версию LuaMacro
-- настройки
local DefUseLocal,UseLocal = 1 -- использовать локальные закладки
local DefUseGlobal,UseGlobal = 1 -- использовать глобальные закладки
local DefUseEnv,UseEnv = 1 -- использовать переменные окружения
local DefGoToMessDelay,GoToMessDelay = 1000 -- длительность показа сообщения о смене папки
local DefSaveMessDelay,SaveMessDelay = 500 -- длительность показа сообщения о сохранении закладки
--local DefaultProfile = F.PSL_LOCAL -- место хранения настроек по умолчанию: локальные
local DefaultProfile = F.PSL_ROAMING -- место хранения настроек по умолчанию: глобальные
local DefaultBMProfile = F.PSL_LOCAL -- место хранения закладок по умолчанию: локальные
--local DefaultBMProfile = F.PSL_ROAMING -- место хранения закладок по умолчанию: глобальные
local OneProfile = win.GetEnv("FARLOCALPROFILE")==win.GetEnv("FARPROFILE") -- локальные и глобальные настройки в одном профиле
-- Языковые настройки
local PathName,FarLang,HlpLang,L = (...):match("(.*)%.lua")
-- переменные
local InProcess -- признак обработки нажатой клавиатурной комбинации
local UsedProfile = DefaultProfile -- откуда загрузили настройки
-- +
--[=[вспомогательные функции]=]
-- -
local LoadSettings,SaveSettings,GoToFolder,GiveBack,ShowHelp,BM2str,BM2tbl,NiceFolder,ReadBM,WriteBM,DelBM
--
function LoadSettings(defaults) --[[загрузить настройки из БД]]
--
local obj = far.CreateSettings(nil,DefaultProfile) -- откроем предпочтительные настройки
local key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,ConfPart) -- есть раздел?
local function Load1(n,d) return not defaults and obj:Get(key or -1,n,({string=F.FST_STRING,number=F.FST_QWORD})[type(d)]) or d end
UsedProfile = DefaultProfile -- запомним профиль
if not key then -- настроек нет?
  obj:Free() obj = far.CreateSettings(nil,DefaultProfile==F.PSL_LOCAL and F.PSL_ROAMING or F.PSL_LOCAL) -- откроем другие настройки
  key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,ConfPart) -- есть раздел?
  if key then -- из другого профиля открылись?
    UsedProfile = DefaultProfile==F.PSL_LOCAL and F.PSL_ROAMING or F.PSL_LOCAL -- запомним профиль
  end
end
UseLocal,UseGlobal = Load1("UseLocal",DefUseLocal)~=0 and F.PSL_LOCAL,Load1("UseGlobal",DefUseGlobal)~=0 and F.PSL_ROAMING -- считаем настройки
UseEnv = Load1("UseEnv",DefUseEnv)~=0 GoToMessDelay,SaveMessDelay = Load1("GoToMessDelay",DefGoToMessDelay),Load1("SaveMessDelay",DefSaveMessDelay)
obj:Free() -- приберёмся
if UseLocal and UseGlobal and OneProfile then UseLocal = nil end
if UseLocal then win.CreateDir(win.GetEnv("FARLOCALPROFILE").."\\PluginsData") end -- создадим папку для локальных настроек
local FL,HL = win.GetEnv("FARLANG"):sub(1,3),Far.GetConfig("Language.Help"):sub(1,3) -- язык (первые 3 буквы)
FL = win.GetFileAttr(PathName..FL..".lng") and FL or "Eng" -- скорректируем: если такого файла нет, берём английский
HlpLang = win.GetFileAttr(PathName..HL..".hlf") and HL or "Eng" -- язык для файла справки
if FarLang~=FL then FarLang,L = FL,dofile(PathName..FL..".lng") end -- если не совпадает с текущим, обновим язык
end
--
function SaveSettings() --[[сохранить настройки в БД]]
--
if UsedProfile==F.PSL_LOCAL then win.CreateDir(win.GetEnv("FARLOCALPROFILE").."\\PluginsData") end -- создадим папку для локальных настроек, если надо
local obj = far.CreateSettings(nil,UsedProfile) -- откроем ранее прочитанные или предпочтительные настройки
local key = obj:CreateSubkey(obj:CreateSubkey(0,Author),ConfPart) -- откроем/создадим раздел
local function Save1(n,v) -- сохранить одну настройку
if type(v)=="boolean" then v = v and 1 or 0 end -- заменим true/false на 1/0
local t = ({string=F.FST_STRING,number=F.FST_QWORD})[type(v)] -- тип параметра в БД
if obj:Get(key,n,t)~=v then obj:Set(key,n,t,v) end -- изменился (или не было)? запишем
end
Save1("UseLocal",not not UseLocal) Save1("UseGlobal",not not UseGlobal) Save1("UseEnv",UseEnv)
Save1("GoToMessDelay",GoToMessDelay) Save1("SaveMessDelay",SaveMessDelay)
obj:Free() -- приберёмся
end
--
function GoToFolder(folder,delay,trail) --[[перейти в указанную папку]]
local A,P
for _,v in ipairs(folder) do
  if v.Panel=="<A>" or v.Panel=="" then if (Drv.ShowPos==0)or((Drv.ShowPos==1)==APanel.Left) then A = v else P = v end -- активная панель
  elseif v.Panel=="<P>" or v.Panel=="<>" then P = v -- пассивная панель
  elseif v.Panel=="<L>" then if APanel.Left then A = v else P = v end -- левая панель
  elseif v.Panel=="<R>" then if APanel.Left then P = v else A = v end end -- правая панель
end
for _,p in ipairs(far.GetPlugins()) do -- получим id плагина по названию
  local pinfo = far.GetPluginInformation(p)
  if A and pinfo and pinfo.GInfo.Title==A.Plugin then A.id = pinfo.GInfo.Guid end
  if P and pinfo and pinfo.GInfo.Title==P.Plugin then P.id = pinfo.GInfo.Guid end
end
-- сменим папки активной и пассивной панели
if A then panel.SetPanelDirectory(nil,1,{PluginId=A.id,File=A.File,Name=A.Folder:gsub("%%(.-)%%",win.GetEnv)..(trail or ""),Param=A.Param}) end
if P then
  panel.SetPanelDirectory(nil,0,{PluginId=P.id,File=P.File,Name=P.Folder:gsub("%%(.-)%%",win.GetEnv)..(trail or ""),Param=P.Param})
  if P.CD then panel.SetActivePanel(nil,0) end -- если данную пассивную надо сделать активной, сделаем
end
if delay>=0 then
  local h = far.SaveScreen() -- сохраним экран
  far.Message(NiceFolder({A,P}),"","") local key = mf.waitkey(delay) -- выведем сообщение и подождём
  far.RestoreScreen(h) -- восстановим экран
  if key~="" then GiveBack("","",key) end -- задержка прервана нажатием клавиши? вернём клавишу обратно
end
end
--
function GiveBack(mod,seq,x) --[[Вернуть клавиши в Far]]
InProcess = true -- запретим повторный вызов
for c in seq:gmatch(".") do -- для каждой ранее нажатой клавиши
  if eval(mod..c,2)<0 then Keys(mod..c) end -- симулируем нажатие RCtrl+эта клавиша
end
if x then if eval(mod..x,2)<0 then Keys(mod..x) end end -- симулируем нажатие RCtrl+эта клавиша для последней (прервавшей скрипт)
InProcess = false -- разрешим вызов снова
end
--
function BM2str(folder) --[[Преобразовать значение закладки в строку]]
if type(folder)=="string" then return folder end -- если уже, то и вернём сразу
local s = "" for _,f in ipairs(folder) do
  s = s..(f.CD and (f.Panel:match("(<.*)>").."C>") or f.Panel)..f.Plugin.."|"..f.File.."|"..f.Folder.."|"..f.Param
end return s
end
--
function BM2tbl(folder,bm,lg) --[[Преобразовать значение закладки в таблицу]]
if type(folder)=="table" then return folder end -- если уже, то и вернём сразу
local t,e = {},folder=="" and {f="",e="Z"} or {}
for pf,nf in (folder:gsub("^[^<]","<1>%1"):gsub("<([Cc]?)>","<2%1>")):gmatch("(%b<>)([^<]*)") do
  local tt,n = {Panel=pf:gsub("[Cc]?",""):gsub("<1>",""):gsub("<2>","<>"):upper()},nf:gsub("[^|]+",""):len() -- очередная часть, количество "|"
  tt.CD = not not pf:upper():match("<[APLR2]?C>") -- признак перехода на эту панель
  if n==0 then tt.Plugin,tt.File,tt.Folder,tt.Param = "","",nf,"" -- если строка не содержит "|", считаем, что это путь
  elseif n==1 then tt.File,tt.Param,tt.Plugin,tt.Folder = "","",nf:match("^([^|]*)|([^|]*)$") -- если "|" один, это плагин и путь
  elseif n==2 then -- если "|" два, нет файла или параметра, или обоих, в середине имя папки или файл, или "||"
    local a = win.GetFileAttr(nf:match("|(.*)|")) -- предположим, что в середине файл и получим его аттрибуты
    if a and not a:find("d") or nf:find("||") then -- нет параметра
      tt.Param,tt.Plugin,tt.File,tt.Folder = "",nf:match("^([^|]*)|([^|]*)|([^|]*)$")
    else -- нет файла
      tt.File,tt.Plugin,tt.Folder,tt.Param = "",nf:match("^([^|]*)|([^|]*)|([^|]*)$")
    end
  else tt.Plugin,tt.File,tt.Folder,tt.Param = nf:match("^([^|]*)|([^|]*)|([^|]*)|(.*)$") end -- если "|" больше двух, всё разбирается
  if not pf:upper():find("<[12APLR]C?>") then e[#e+1] = {f=pf..nf,e="P"} elseif tt.Folder=="" then e[#e+1] = {f=pf..nf,e="F"} else t[#t+1] = tt end
end
if #e>0 then
  local s,sp = (L.BadBM1:format(lg==F.PSL_LOCAL and L.BMLocal or L.BMGlobal,bm)) sp = (" "):rep(s:len())
  for i,v in ipairs(e) do s = s..(i>1 and sp or "")..L["BadBM"..v.e.."Fmt"]:format(v.f:gsub("<1>",""):gsub("<2>","<>"))..(i<#e and "\n" or "") end
  far.Message(s,L.Hdr,";Ok","wl")
end
return t,#e>0 and e or nil
end
--
function NiceFolder(folder) --[[Красивая строка папки]]
return BM2str(BM2tbl(folder)):gsub("([^|<>]*|[^|<>]*|[^|<>]*)|[^|<>]*","%1"):gsub("|*(%b<>)|*","%1"):gsub("^|+",""):gsub("|+$",""):gsub("|+",":")
end
--
function ReadBM(bm,lg)
local folder,err = {}
local obj = far.CreateSettings(nil,lg) -- откроем нужный профиль
local key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,KeysPart) -- раздел
if key then -- есть раздел?
  local f = obj:Get(key,bm,F.FST_STRING) -- старый формат?
  if f then folder,err = BM2tbl(f,bm,lg) else
    key = obj:OpenSubkey(key,bm) -- закладка
    local t = key and obj:Enum(key) or {} -- если есть - прочитаем содержимое, иначе сделаем пустой список
    for i,v in ipairs(t) do
      local subkey = obj:OpenSubkey(key,v.Name)
      folder[i] = {CD = obj:Get(subkey,"CD",F.FST_QWORD)==1, Panel = obj:Get(subkey,"Panel",F.FST_STRING), -- загрузим закладку
                   Plugin = obj:Get(subkey,"Plugin",F.FST_STRING), File = obj:Get(subkey,"File",F.FST_STRING),
                   Folder = obj:Get(subkey,"Folder",F.FST_STRING),Param = obj:Get(subkey,"Param",F.FST_STRING)}
    end
  end
end
obj:Free() return #folder>0 and folder or nil,err
end
--
function WriteBM(bm,folder,dest)
DelBM(bm,dest) -- удалим старое значение, чтобы не наложилось одно на другое
local obj = far.CreateSettings(nil,dest) -- откроем профиль
local key = obj:CreateSubkey(obj:CreateSubkey(0,Author),KeysPart) -- откроем/создадим раздел
key = obj:CreateSubkey(key,bm) -- сохраним закладку
for i,v in ipairs(folder) do -- сохраним закладку
  local subkey = obj:CreateSubkey(key,tostring(i))
  obj:Set(subkey,"CD",F.FST_QWORD,v.CD and 1 or 0) obj:Set(subkey,"Panel",F.FST_STRING,v.Panel)
  obj:Set(subkey,"Plugin",F.FST_STRING,v.Plugin) obj:Set(subkey,"File",F.FST_STRING,v.File )
  obj:Set(subkey,"Folder",F.FST_STRING,v.Folder) obj:Set(subkey,"Param",F.FST_STRING,v.Param)
end
obj:Free()
end
--
function DelBM(bm,dest,confirm)--[=[Удалить закладку]=]
if confirm and far.Message(L.DeleteBM:format(dest==F.PSL_LOCAL and L.BMLocal or L.BMGlobal,bm,NiceFolder(ReadBM(bm,dest))),L.Hdr,";OkCancel")~=1 then
  return -- если нужно подтверждение, и отказались, ничего не делаем
end
local obj = far.CreateSettings(nil,dest) -- считаем из локального профиля
local key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,KeysPart) -- раздел
if key then -- есть раздел?
  if obj:Get(key,bm,F.FST_STRING) then obj:Delete(key,bm) -- удалим, если старый формат
  else  key = obj:OpenSubkey(key,bm) if key then obj:Delete(key) end end -- удалим закладку нового типа
end
obj:Free()
end
--
function ShowHelp(text) far.ShowHelp(PathName..HlpLang..".hlf",text,F.FHELP_CUSTOMFILE) end --[[Вывести справку]]
--
if type(nfo)=="table" then nfo.help = function() ShowHelp() end end
-- +
--[==[Основные функции]==]
-- -
local BMSaveFolder,BMGoToFolder,BMEdit,Config,BMMenu,QSMenu,CLProc
-- +
--[=[Сохранить текущую папку в указанной закладке]=]
-- -
function BMSaveFolder(sq,fld,dst)
local folder,seq,mod,key = {} -- папка, последовательность символов для закладки, нажатые модификаторы, очередная клавиша
if sq then -- имя задано?
  seq = sq -- будем использовать его
else -- если не задано...
  mod,seq = akey(1,1):match("^(.*)(.)$") -- первый из символов
  repeat -- Обработаем очередное нажатие
    key = mf.waitkey(10):sub(mod:len()+1) -- введём клавишу
    if key:len()<2 then -- нормальная клавиша?
      seq = seq..key -- добавим к последовательности
    else -- нет - считаем, что эту последовательность надо отдать Far-у
      return GiveBack(mod,seq,key) -- вернём клавиши обратно и выйдем
    end
  until band(Mouse.LastCtrlState,0x15)==0 -- повторяем, пока нажаты RCtrl+Shift/RAlt
end
if fld then -- папка задана?
  folder = fld -- будем использовать её
else -- если не задана...
  local function PluginByID(id) return id~=("\000"):rep(16) and far.GetPluginInformation(far.FindPlugin(F.PFM_GUID,id)).GInfo.Title or "" end
  local t = panel.GetPanelDirectory(nil,1) -- папка на активной панели
  folder[1] = {Panel="<A>",Plugin=PluginByID(t.PluginId),File=t.File,Folder=t.Name,Param=t.Param}
  if akey(1,1):len()==10 then -- RCtrlRAlt?
    t = panel.GetPanelDirectory(nil,0) -- папка на пассивной панели
    folder[2] = {Panel="<P>",Plugin=PluginByID(t.PluginId),File=t.File,Folder=t.Name,Param=t.Param}
  end
end
local dest = dst or (UseLocal and UseGlobal and DefaultBMProfile or UseLocal or UseGlobal) -- профиль
local of = ReadBM(seq,dest) -- старое значение для закладки, если есть
if of then -- такая закладка уже есть, менять?
  if far.Message(L.ReplaceBM:format(dest==F.PSL_LOCAL and L.BMLocal or L.BMGlobal,seq,NiceFolder(of),NiceFolder(folder)),L.SaveHdr,";YesNo")==1 then
    of = nil -- запомним, что старой нет
  end
end
if not of then -- старой нет, сохраняем
  WriteBM(seq,folder,dest) -- сохраним закладку
  if SaveMessDelay>=0 then
    local h = far.SaveScreen() -- сохраним экран
    far.Message(L.SaveMess:format(seq,NiceFolder(folder)),"","") mf.waitkey(SaveMessDelay) -- выведем сообщение и подождём
    far.RestoreScreen(h) -- восстановим экран
  end
end
end
-- +
--[=[Перейти на закладку]=]
-- -
function BMGoToFolder(sq,pref,trail)
local seq,key,folder,fl,fg,fe,err -- последовательность символов для закладки, очередная клавиша, папка, папки, ошибка
if sq then seq = sq -- имя задано? - будем использовать его
else -- если не задано...
  seq = akey(1,1):sub(6) -- первый из символов
  repeat -- Обработаем очередное нажатие
    key = mf.waitkey(10):sub(6) -- введём клавишу, отрежем "RCtrl"
    if key:len()<2 then -- нормальная клавиша?
      seq = seq..key -- добавим к последовательности
    else -- нет - считаем, что эту последовательность надо отдать Far-у
      return GiveBack("RCtrl",seq,key) -- вернём клавиши обратно и выйдем
    end
  until band(Mouse.LastCtrlState,0x4)==0 -- повторяем, пока нажат RCtrl
end
if UseLocal then fl,err = ReadBM(seq,F.PSL_LOCAL) end
if UseGlobal then fg,err = ReadBM(seq,F.PSL_ROAMING) end
if UseEnv then
  fe = win.GetEnv(seq) -- получим значение переменной с набранным именем
  fe = fe and tostring(win.GetFileAttr(fe)):find("d") and {{Panel="<A>",Plugin="",File="",Folder=fe,Param=""}} -- если это каталог, то запомним
end
folder = fl and fg and DefaultBMProfile==UseLocal and fl or fg or fl -- выберем правильный каталог
folder = folder or fe -- если нет закладки, используем переменную окружения
if folder then GoToFolder(folder,GoToMessDelay,trail) -- есть такая закладка? - перейдём
elseif seq:match("^%d$") or (not err and not BMMenu(seq)) then -- нет такой закладки и нет подходящих по шаблону
  if pref then -- вызов по префиксу?
    far.Message(L.BadBM:format("",sq),L.Hdr,";Ok","w") -- выведем сообщение об ошибке
  else -- вызов комбинацией клавиш
    GiveBack("RCtrl",seq)-- вернём клавиши обратно
  end
end
end
-- +
--[=[Редактировать закладку в диалоге]=]
-- -
function BMEdit(bm,folder,lg,move)
--
local Hdr = not bm and L.diEdit.HdrNew or move and L.diEdit.Hdr or L.diEdit.HdrCopy -- выберем заголовок
local w = math.max(math.min((BM2str(folder) or ""):len(),Far.Width-17),34) -- отрегулируем ширину окна
--
local function DlgProc (hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_EDITCHANGE and Param1==3 then -- изменение поля bookmark
  Param2[10] = Param2[10]:upper():gsub(".",ToCtrl) -- поднимем регистр, исправим символы на допустимые
  far.SetDlgItem(hDlg,Param1,Param2) -- скорректируем
elseif Msg==F.DN_CONTROLINPUT and (Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0) then -- F1
  return true,ShowHelp("Edit")
end
end
--
local form = { -- диалог редактирования
--[[01]] {F.DI_DOUBLEBOX,   3, 1,w+17, 7,0,0,0,0,Hdr},
--[[02]] {F.DI_TEXT,        5, 2,   0, 2,0,0,0,0,L.diEdit.BM},
--[[03]] {F.DI_EDIT,       15, 2,w+15, 2,0,0,0,0,bm},
--[[04]] {F.DI_TEXT,        5, 3,   0, 3,0,0,0,0,L.diEdit.Folder},
--[[05]] {F.DI_EDIT,       15, 3,w+15, 3,0,0,0,0,BM2str(folder)},
--[[06]] {F.DI_RADIOBUTTON, 5, 4,   0, 4,lg==F.PSL_LOCAL and 1 or 0,0,0,
                           (UseLocal and F.DIF_GROUP or F.DIF_DISABLE)+F.DIF_CENTERGROUP,L.diEdit.LocalBM},
--[[07]] {F.DI_RADIOBUTTON,27, 4,   0, 4,lg==F.PSL_LOCAL and 0 or 1,0,0,
                           (not OneProfile and UseGlobal and 0 or F.DIF_DISABLE)+F.DIF_CENTERGROUP,L.diEdit.GlobalBM},
--[[08]] {F.DI_TEXT,       -1, 5,   0, 5,0,0,0,F.DIF_SEPARATOR,""},
--[[09]] {F.DI_BUTTON,      0, 6,   0, 6,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[10]] {F.DI_BUTTON,      0, 6,   0, 6,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
-- начало тела функции BMEdit
if type(lg)~="number" or far.Dialog(Guids.diEdit,-1,-1,w+21,9,nil,form,nil,DlgProc)~=9 then return end -- вызовем диалог, не "ОК" - уйдём
local newbm,newfolder,newlg,err = form[3][10],form[5][10],form[6][6]==1 and F.PSL_LOCAL or F.PSL_ROAMING
newfolder,err = BM2tbl(newfolder,newbm,newlg) -- преобразуем в таблицу и получим список некорректных элементов
if newbm~="" then -- если имя закладки не пустое - работаем
  local of = ReadBM(newbm,newlg)
  if #newfolder==0 then -- папка пустая?
    if of and not err then DelBM(newbm,newlg,true) end -- если закладка с новым именем уже была и не было ошибок в новой - удалим
  else -- папка непустая
    if (lg~=newlg or bm~=newbm) and of and far.Message(L.ReplaceBM:format(newlg==F.PSL_LOCAL and L.BMLocal or L.BMGlobal,newbm,
      NiceFolder(of),NiceFolder(newfolder)),Hdr,";YesNo")~=1 then return
    end -- сменили имя или размещение закладки (или новая), такая закладка есть, и мы не хотим её заменять? ничего не делаем, уйдём
    if move then DelBM(bm,lg) end -- удалим старую, если перенос, а не копирование
    WriteBM(newbm,newfolder,newlg) -- сохраним закладку
  end
end
end
-- +
--[==[Настройка конфигурации]==]
-- -
function Config()
--
local ov
--
local function cDlgProc (hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_GOTFOCUS and (Param1==6 or Param1==8) then -- вошли в di_edit?
  ov = far.SendDlgMessage(hDlg,"DM_GETTEXT",Param1) -- запомним старое значение
elseif Msg==F.DN_KILLFOCUS and (Param1==6 or Param1==8) then -- покидаем di_edit?
  local nv = tonumber(far.SendDlgMessage(hDlg,"DM_GETTEXT",Param1)) -- новое значение
  if not nv then far.SendDlgMessage(hDlg,"DM_SETTEXT",Param1,ov) end -- не число - откатим
elseif Msg==F.DN_CONTROLINPUT and (Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0) then -- F1
  ShowHelp("Config")
elseif Msg==F.DN_CONTROLINPUT and (Param2.VirtualKeyCode==0x0d and band(Param2.ControlKeyState,0x1f)==0x10) then -- ShiftEnter
  far.SendDlgMessage(hDlg,"DM_CLOSE",11) -- закроем диалог
elseif Msg==F.DN_CLOSE then
  far.SendDlgMessage(hDlg,"DM_SETFOCUS",2) -- переключимся на чекбокс
end
end
--
local Items = { -- диалог настройки конфигурации
--[[01]] {F.DI_DOUBLEBOX,   3, 1,59,9,0,0,0,0,L.Hdr},
--[[02]] OneProfile and
         {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,""} or
         {F.DI_CHECKBOX,    5, 2, 0, 2,UseLocal and 1 or 0,0,0,0,L.diConf.LocalBM},
--[[03]] {F.DI_CHECKBOX,    5, 3, 0, 3,UseGlobal and 1 or 0,0,0,0,OneProfile and L.diConf.AllBM or L.diConf.GlobalBM},
--[[04]] {F.DI_CHECKBOX,    5, 4, 0, 4,UseEnv and 1 or 0,0,0,0,L.diConf.EnvBM},
--[[05]] {F.DI_TEXT,        5, 5, 0, 5,0,0,0,0,L.diConf.GoToDelay},
--[[06]] {F.DI_EDIT,       52, 5,57, 5,0,0,0,0,GoToMessDelay},
--[[07]] {F.DI_TEXT,        5, 6, 0, 6,0,0,0,0,L.diConf.SaveDelay},
--[[08]] {F.DI_EDIT,       52, 6,57, 6,0,0,0,0,SaveMessDelay},
--[[09]] {F.DI_TEXT,       -1, 7, 0, 7,0,0,0,F.DIF_SEPARATOR,""},
--[[10]] {F.DI_BUTTON,      0, 8, 0, 8,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.Save},
--[[11]] {F.DI_BUTTON,      0, 8, 0, 8,0,0,0,F.DIF_CENTERGROUP,L.NoSave},
--[[12]] {F.DI_BUTTON,      0, 8, 0, 8,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
-- начало кода функции
local res = far.Dialog(Guids.Config,-1,-1,63,11,nil,Items,nil,cDlgProc) -- вызовем диалог
if res~=10 and res~=11 then return end -- не "ОК" - уйдём
GoToMessDelay,SaveMessDelay = tonumber(Items[6][10]),tonumber(Items[8][10])
UseLocal,UseGlobal,UseEnv = Items[2][6]~=0 and F.PSL_LOCAL,Items[3][6]~=0 and F.PSL_ROAMING,Items[4][6]~=0 -- новые значения
if res==10 then SaveSettings() end -- сохраним в БД, если надо
end
--
if type(nfo)=="table" then nfo.config = Config end
-- +
--[=[Меню закладок]=]
-- -
function BMMenu(mask)
--
local function prep_menu(lg) -- подготовить заполнение меню закладками
local maxlen,l = 0,{} -- наибольшая длина имени, данные для заполнения, профиль, раздел, список имён
if lg then -- для закладок
  local obj = far.CreateSettings(nil,lg) -- откроем нужные настройки
  local key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,KeysPart) -- есть раздел?
  l = key and obj:Enum(key) or {} -- если есть - прочитаем содержимое, иначе сделаем пустой список
  obj:Free()
  for i=1,#l do l[i].Value = ReadBM(l[i].Name,lg) or {} end -- дополним значениями
else -- дёргаем переменные окружения
  local ffi = require "ffi"
  local C = ffi.C
  ffi.cdef [[
    wchar_t* GetEnvironmentStringsW();
    void FreeEnvironmentStringsW(wchar_t*);
    size_t wcslen(const wchar_t*);]]
  local env = C.GetEnvironmentStringsW() -- выдернем все переменные окружения в виде последовательности 0-терминированных строк
  local p = env -- указатель на очередную
  while true do -- разберём
    local len = C.wcslen(p) -- длина очередной строки
    if len == 0 then break end -- нулевая - закончим
    local s = win.Utf16ToUtf8(ffi.string(ffi.cast("char*", p), 2*(len+1))) -- получим очередную строку
    if s:sub(1,1)~="=" then -- закинем каталог в таблицу (кроме "=<диск>=<путь>")
      local n,v = s:match("^(.-)=(.*)$") -- выдернем имя и значение; если существующий каталог - добавим
      if tostring(win.GetFileAttr(v)):find("d") then l[#l+1] = {Name=n,Value={{Panel="",Plugin="",File="",Folder=v,Param=""}}} end
    end
    p = p+len+1 -- указатель на следующую строку
  end
  C.FreeEnvironmentStringsW(env) -- освободим память
end
if l and #l>0 then -- если есть что разбирать
  if lg and Drv.ShowPos~=0 then -- меню дисков, закладки?
    for i=#l,1,-1 do local v = l[i].Value for j=#v,1,-1 do local w = v[j] -- переберём все закладки
      if w.Panel~="" and w.Panel:sub(2,2)~="A" and w.Panel:sub(2,2)~=({"L","R"})[Drv.ShowPos] then table.remove(v,j) end
    end end -- отбросим все, не подходящие по префиксу для данного меню
  end
  if mask then -- если указана маска
    for i=#l,1,-1 do -- переберём все закладки
      if not l[i].Name:upper():find(mask,1,true) then table.remove(l,i) end -- отбросим все, не начинающиеся с маски
    end
  end
  table.sort(l,function(a,b) return(a.Name<b.Name) end) -- отсортируем закладки
  for i,v in ipairs(l) do -- сформируем меню
    maxlen,l[i].lg = math.max(maxlen,v.Name:len()),lg -- вычислим максимальную длину имени закладки и запомним профиль
  end
end
return maxlen,l
end
--
local function fill_menu(tbl,title,blen,itms) -- заполнить меню закладками
itms[#itms+1] = {text=title,separator=true} -- подзаголовок
for _,v in ipairs(tbl) do -- сформируем меню
  itms[#itms+1] = {text=v.Name..(" "):rep(blen-v.Name:len()).." │ "..NiceFolder(v.Value),grayed=#v.Value==0,bm=v.Name,folder=v.Value,lg=v.lg}
end
end
-- начало тела функции BMMenu
local Title,Bottom,HotKeys,pos,res = L.Hdr..L.HdrA[Drv.ShowPos],"Enter,Esc,F1,F4,F5,F9,Ins,Del", -- заголовок, подсказка, горячие клавиши...
  {{BreakKey="F1"},{BreakKey="F4"},{BreakKey="F5"},{BreakKey="F9"},{BreakKey="INSERT"},{BreakKey="NUMPAD0"},{BreakKey="DELETE"},{BreakKey="DECIMAL"}}
--
LoadSettings() -- прочитаем настройки
repeat -- начало главного цикла
  local listl,listg,liste,maxl,maxg,maxe,items = {},{},{},0,0,0,{} -- чем заполнять меню, результаты разборки закладок, элементы меню
  if UseLocal then maxl,listl = prep_menu(F.PSL_LOCAL) end -- достанем локальные закладки
  if UseGlobal then maxg,listg = prep_menu(F.PSL_ROAMING) end -- достанем глобальные закладки
  if UseEnv then maxe,liste = prep_menu() end -- достанем переменные окружения
  if #listl>0 then fill_menu(listl,L.LocalBM,math.max(maxl,maxg,maxe),items) end-- заполним меню закладками
  if #listg>0 then fill_menu(listg,OneProfile and L.AllBM or L.GlobalBM,math.max(maxl,maxg,maxe),items) end
  if #liste>0 then fill_menu(liste,L.EnvBM,math.max(maxl,maxg,maxe),items) end
  if mask and #items==0 then return false end -- если меню перехода по неполному имени и выводить совсем нечего, закончим и сообщим
  res,pos = far.Menu({Title=Title,Bottom=Bottom,SelectIndex=pos,Id=Guids.Menu,Flags=F.FMENU_SHOWAMPERSAND+F.FMENU_WRAPMODE},items,HotKeys) -- меню
  if not res then break end -- Esc. "работаем, пока не надоест"? Надоело...
  if res.BreakKey then -- не Enter или Esc?
    if res.BreakKey=="F1" then -- F1 - выведем справку
      ShowHelp("Main")
    elseif res.BreakKey=="F4" or res.BreakKey=="F5" then -- редактировать в диалоге?
      BMEdit(items[pos].bm,items[pos].folder,items[pos].lg,res.BreakKey=="F4") -- отредактируем
    elseif res.BreakKey=="INSERT" or res.BreakKey=="NUMPAD0" then -- добавить новый?
      if UseLocal or UseGlobal then -- есть куда?
        BMEdit(nil,{},UseLocal==DefaultBMProfile and UseLocal or UseGlobal or UseLocal) -- добавим
      else
        far.Message(L.NoLG,L.Hdr,";Ok","w") -- всё выключено!
      end
    elseif res.BreakKey=="DELETE" or res.BreakKey=="DECIMAL" then -- удалить текущий?
      DelBM(items[pos].bm,items[pos].lg,true) -- удалим
    elseif res.BreakKey=="F9" then -- конфигурация?
      Config() -- отредактируем
    end
  else -- Enter
    GoToFolder(res.folder,-1) -- перейдём без задержки на показ новой папки
    break -- закончим на этом
  end
until false -- конец главного цикла
return true -- сработали и закончили
end
--
if type(nfo)=="table" then nfo.execute = function() BMMenu() end end
-- +
--[=[Быстрый поиск в меню закладок]=]
-- -
function QSMenu()
local seq,key = "",(akey(1,1):gsub("^RCtrl","")) -- последовательность символов для закладки,нажатая клавиша
local bkeys = {Enter=1,F1=1,F4=1,F5=1,F9=1,Ins=1,Num0=1,Del=1,NumDel=1,Esc=0} -- эти клавиши принимает главное меню (кроме Esc)
repeat -- Обработаем очередное нажатие
  if key=="Home" then
    Menu.Select(seq,1,0) -- перейдём на первый подходящий пункт меню
  elseif key=="End" then
    Keys(key) Menu.Select(seq,1,1) -- перейдём на последний подходящий пункт меню
  elseif key=="Up" then
    Keys(key) if Menu.Select(seq,1,1)==0 then Keys("End") Menu.Select(seq,1,1) end -- перейдём на следующий подходящий пункт меню
  elseif key=="Down" then
    Keys(key) if Menu.Select(seq,1,2)==0 then Keys("Home") Menu.Select(seq,1,2) end -- перейдём на предыдущий подходящий пункт меню
  elseif key:len()==1 then
    seq = seq..key:upper():gsub(".",ToCtrl) -- преобразуем, добавим
    if Menu.Select(seq,1,0)==0 then seq = seq:sub(1,-2) end -- перейдём на подходящий пункт меню
  end
  far.Text((Far.Width-Object.Width)/2+3,(Far.Height-Object.Height)/2,far.AdvControl(F.ACTL_GETCOLOR,far.Colors.COL_MENUTITLE),"["..seq.."]")
  far.Text() -- перерисуем экран
  key = mf.waitkey(10):gsub("^RCtrl","") -- введём клавишу,отрежем "RCtrl", если есть
until bkeys[key] -- повторяем, пока не Esc
if bkeys[key]==1 then Keys(key) end
end
-- +
--[=[Обработка командной строки]=]
-- -
function CLProc(pref,line)
LoadSettings()
local p13,p4,bm,folder,trail = pref:sub(1,3),pref:sub(4),line:match("^(%S*)%s*(.*)$") -- функция, профиль, закладка, папка/и
if pref=="bm" then bm,trail = line:match("^([^\\]*)(.-)$") end -- для перехода формат и содержание строки другие
local lg = p4=="l" and F.PSL_LOCAL or p4=="g" and F.PSL_ROAMING or UseLocal and UseGlobal and DefaultBMProfile or UseLocal or UseGlobal -- назначение
if not lg and p13~="bm" then return end -- если профиль не задан явно, все закладки отключены, и это не переход, выйдем
bm = bm:upper():gsub(".",ToCtrl) -- преобразуем закладку к виду, вводимому с Ctrl
if p13=="bm" then -- переход?
  BMGoToFolder(bm,pref,trail) -- перейдём
elseif p13=="bma" then -- добавление?
  if folder=="" then -- папка не указана?
    far.Message((L.BadBM1..L.BadBMValue):format(lg==F.PSL_LOCAL and L.BMLocal or L.BMGlobal,bm),L.Hdr,";Ok","w") -- выведем сообщение об ошибке
  else
    local tfolder = BM2tbl(folder,bm,lg) -- преобразуем в таблицу и получим список некорректных элементов
    if #tfolder>0 then BMSaveFolder(bm,tfolder,lg) -- добавим (если есть что)
    else far.Message((L.BadBM1..L.BadBMZFmt):format(lg==F.PSL_LOCAL and L.BMLocal or L.BMGlobal,bm),L.Hdr,";Ok","w") end
  end
elseif p13=="bme" then -- изменение?
  BMEdit(bm,folder=="" and ReadBM(bm,lg) or BM2tbl(folder,bm,lg),lg,true) -- поредактируем
elseif p13=="bmr" then -- удаление?
  DelBM(bm,lg,true) -- удалим
end
end
--
LoadSettings() --[[первичная загрузка настроек]]
-- +
--[=[Макросы]=]
-- -
Macro{
  area="Shell"; key="/RCtrl(Shift|RAlt)[^\\/]/"; description=L.SaveDesc; [(LMBuild<579 and "u" or "").."id"]=Guids.SaveMacro;
  condition = function() LoadSettings() return not InProcess and (UseLocal or UseGlobal) and 55 end; action=BMSaveFolder;
}
--
Macro{
  area="Shell"; key="/RCtrl[^\\/]/"; description=L.GoToDesc; [(LMBuild<579 and "u" or "").."id"]=Guids.GoToMacro;
  condition = function() LoadSettings() return not InProcess and (UseLocal or UseGlobal or UseEnv) and 55 end; action=BMGoToFolder;
}
--
Macro{
  area="Shell"; key="RCtrl/"; description=L.MenuDesc; [(LMBuild<579 and "u" or "").."id"]=Guids.MenuMacro;
  condition = function() return not InProcess end; action=BMMenu;
}
Macro{
  area="Menu"; key="/(RCtrl)?[^\\/]/"; description=L.QSMenuDesc; [(LMBuild<579 and "u" or "").."id"]=Guids.QSMenuMacro;
  condition = function() return not InProcess and win.Uuid(Menu.Id)==Guids.Menu end; action=QSMenu;
}
-- +
--[=[Пункт меню]=]
-- -
MenuItem {
  description = L.Desc; menu = "Plugins Disks Config"; area = "Shell"; guid = Guids.PlugMenu;
  text = function(menu) return menu=="Config" and L.ConfigDesc or L.MenuDesc end;
  action = function(OpenFrom) if OpenFrom then BMMenu() else Config() end end;
}
-- +
--[=[Префиксы]=]
-- -
CommandLine { description = L.Desc; prefixes = "bm"; action = CLProc; }
CommandLine { description = L.Desc..L.Add; prefixes = "bma:bmal:bmag"; action = CLProc; }
CommandLine { description = L.Desc..L.Edit; prefixes = "bme:bmel:bmeg"; action = CLProc; }
CommandLine { description = L.Desc..L.Rem; prefixes = "bmr:bmrl:bmrg"; action = CLProc; }
CommandLine { description = L.Desc..L.Help; prefixes = "bmhelp"; action = function() ShowHelp("prefix") end; }
