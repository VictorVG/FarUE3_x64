-------------------------------------------------------------------------------
-- Работа с псевдонимами (синонимами) © SimSU
-------------------------------------------------------------------------------
-- Создание псевдонима: в командной строке набираем псевдоним<>команда, нажимаем ShiftSpace - псевдоним задан.
-- Удаление псевдонима: в командной строке набираем псевдоним<>, нажимаем ShiftSpace - псевдоним удалён.
-- Замена команды псевдонима идентична созданию.
-- Просмотр псевдонимов с командами: в командной строке набираем <> , нажимаем ShiftSpace - окно со всеми заданными псевдонимами.
-- Замена псевдонима соответствующей ему командой: в командной строке набираем псевдоним, нажимаем ShiftSpace - псевдоним будет заменён соответствующей командой.
-- Если нужно указать команде дополнительные параметры, то в командной строке набираем псевдоним><параметры, нажимаем ShiftSpace - псевдоним будет заменён соответствующей командой с указанными параметрами.
--[[
  Пример:
    C:\>{набираем}дир<>dir /p{нажимаем ShiftSpace}
    C:\>
      Создали псевдоним, т.е. теперь введённое нами в ком строке слово дир преобразуется в команду dir c параметром /p, при нажатии ShiftSpace.
    C:\>{набираем}дир{нажимаем ShiftSpace}
    C:\>dir /p
      Если нам потребуется выводить только имена файлов (команда dir /p /b), а новый псевдоним делать не нужно, то
    C:\>{набираем}дир /b{нажимаем ShiftSpace}
    C:\>dir /p /b
]]
-- Для удобства клавиша Enter преобразует псевдоним в команду и запускает её на выполнение.
--[[
  Полезные примеры:
    far<>start %farhome%\far - запуск ещё одной копии FARа в отдельной консоли;
    temp<>cd %temp% - переход активной панели в директорию TEMP.
]]

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_Aliases.cfg
return{
  Key="ShiftSpace";         --Prior    =50; --Sort    =50;
  KeyExec="Enter NumEnter";   PriorExec=51; --SortExec=50;
}
-- Конец файла Profile\SimSU\Shell_Aliases.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_AliasesRussian.lng
return{
  Descr="Работа с псевдонимами (синонимами) © SimSU";
  Title="Псевдонимы (синонимы)";
  DescrExec="Исполнение псевдонима (синонима) © SimSU";
}
-- Конец файла Profile\SimSU\Shell_AliasesRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_AliasesEnglish.lng
return{
  Descr="Working with aliases. © SimSU";
  Title="Aliases";
  DescrExec="Alias Execution. © SimSU";
}
-- End of file Profile\SimSU\Shell_AliasesEnglish.lng
end end

-------------------------------------------------------------------------------
local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_Aliases"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_Aliases.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_Aliases.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local Aliases= mf.mload("SimSU","Aliases") or {}
local _
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end

local function Set(key,val) -- Добавляем, удаляем, заменяем псевдонимы.
  if key then
    Aliases[key]= val~="" and val or nil
    mf.msave("SimSU","Aliases",Aliases)
  end
  return true
end

local function SetStr(str) -- Добавляем, удаляем, заменяем псевдонимы с разбором строки.
  local key,val = str:match("^(.+)<>(.*)$")
  if not key then return end
  return Set(key,val)
end

local function Get(key) -- Получаем значение псевдонима.
  return Aliases[key]
end

local function List() -- Лист псевдонимов.
  local Items={}
  for key,val in pairs(Aliases) do
    Items[#Items+1]=key.."<>"..val
  end
  return Menu.Show(table.concat(Items,"\n"),M.Title,0x20+0x100)
end

local function Expand(str) -- Получаем значение псевдонима дополненное параметрами если были.
  local key,prm = str:match("^(.+)><(.*)$") --or str:match("^(.-)%s+(.*)$")
  if not key then key,prm = str:match("^(.+)%s+(.*)") end
  if not prm then key = str:match("^(.+)$") end
  local val = Get(key)
  return val and val.." "..(prm or "")
end

local function Work() -- Работаем с командной строкой.
  if Area.Shell and not CmdLine.Empty then
    local cmd=mf.trim(CmdLine.Value)
    if cmd=="<>" then
      Keys("CtrlY"); print(List()); return true
    elseif cmd:find("<>") then
      SetStr(cmd); Keys("CtrlY"); return true
    else
      cmd=Expand(cmd)
      if cmd then
        Keys("CtrlY"); print(cmd)
      end
    end
  end
end

local function Run() -- Автоматическая работа с комстрокой.
-- Автоматизация исполнения команды, про ShiftSpace можно не вспоминать, а выполнять всё по Enter.
-- Работа аналогична предыдущему макросу, только команда получившаяся из псевдонима выполняется сразу.
-- Если созданы "Полезные примеры" из главного описния, то просто набираем far и жмём Enter - получаем ещё одну копию FARа :)
  if Area.Shell then
    _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
    if not Work() then mmode(1,mmode(1,0),Keys("Enter")) end  --Keys("Enter") end --
    _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.RestoreLater and SimSU.Shell_RememberSelected.RestoreLater(APanel)
  end
end

-------------------------------------------------------------------------------
local Shell_Aliases={
  Set    = Set   ;
  SetStr = SetStr;
  Get    = Get   ;
  List   = List  ;
  Expand = Expand;
  Work   = Work  ;
  Run    = Run   ;
}
local function filename() return List() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Shell_Aliases=SimSU.Shell_Aliases} end
SimSU.Shell_Aliases=Shell_Aliases; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="99384d9b-90f6-4927-9e90-a08df6cf9ff6";
  area="Shell"; key=S.Key;     priority=S.Prior;     sortpriority=S.Sort;     description=M.Descr;     flags="NotEmptyCommandLine";
  action=function() return Work() end;
}

Macro {id="b0d31b24-8d7c-4b9f-933b-9e0fbb55e64a";
  area="Shell"; key=S.KeyExec; priority=S.PriorExec; sortpriority=S.SortExec; description=M.DescrExec; flags="NotEmptyCommandLine";
  action=function() return Run() end;
}
