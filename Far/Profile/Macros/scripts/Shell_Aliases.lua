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
    C:\>{набираем}дир>< /b{нажимаем ShiftSpace}
    C:\>dir /p /b
]]
--[[
  Полезные примеры:
    far<>start %farhome%\far - запуск ещё одной копии FARа в отдельной консоли;
    temp<>cd %temp% - переход активной панели в директорию TEMP.
]]

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_Aliases.cfg
return{
  Key="ShiftSpace"; --Prior=50;
  KeyExec="Enter NumEnter"; PriorExec=51;
}
-- Конец файла Profile\SimSU\Shell_Aliases.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
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

local SimSU=SimSU or {}
SimSU.Shell_Aliases={}
-------------------------------------------------------------------------------

local Aliases=Aliases or mf.mload("SimSU","Aliases") or {}

function SimSU.Shell_Aliases.Work()
--  Aliases= Aliases or mf.mload("SimSU","Aliases") or {}
  if Area.Shell and not CmdLine.Empty then
    local cmd=mf.trim(CmdLine.Value)
    local key, val, prm
    if cmd:find("<>") then -- Работа с таблицей псевдонимов.
      key,val=cmd:match("^(.+)<>(.*)$"); val= val~="" and val or nil
      if key then -- Добавляем, удаляем, заменяем псевдонимы.
        Aliases[key]=val
        mf.msave("SimSU","Aliases",Aliases)
        Keys("CtrlY")
      elseif not val then -- Строим лист псевдонимов.
        local Items={}
        for k,v in pairs(Aliases) do
          Items[#Items+1]=k.."<>"..v
        end
        Items=Menu.Show(table.concat(Items,"\n"),M.Title,0x20+0x100)
        Keys("CtrlY")
        if Items~="" then
          print(Items); exit()
        end
      end
    else -- Заменяем псевдоним его значением, если есть и подставляем параметры.
      key,prm=cmd:match("^(.+)><(.*)$"); key= key or cmd; prm= prm or ""
      val=Aliases[key]
      if val then Keys("CtrlY"); print(val); print(prm) end
    end
  end
end;

function SimSU.Shell_Aliases.Run()
-- Автоматизация исполнения команды, про ShiftSpace можно не вспоминать, а выполнять всё по Enter.
-- Работа аналогична предыдущему макросу, только команда получившаяся из псевдонима выполняется сразу.
-- Если созданы "Полезные примеры" из главного описния, то просто набираем far и жмём Enter - получаем ещё одну копию FARа :)
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
  SimSU.Shell_Aliases.Work()
  if not CmdLine.Empty then
    mmode(1,mmode(1,0),Keys("Enter"))
--1    while not Area.Shell do mmode(1,mmode(1,0),Keys(mf.waitkey(100))) end -- Вопросы...
  end
  far.Timer(100, function(h) if Area.Shell then h:Close(); _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel) end end)
--1  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel)
end;
-------------------------------------------------------------------------------
if not Macro then return {Shell_Aliases=SimSU.Shell_Aliases} end

local ok, mod = pcall(require,"SimSU.Shell_Aliases"); if ok then SimSU=mod else _G.SimSU=SimSU end
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end
-------------------------------------------------------------------------------

Macro {area="Shell"; key=S.Key; priority=S.Prior; description=M.Descr; flags="NotEmptyCommandLine";
  action=SimSU.Shell_Aliases.Work;
}

Macro {area="Shell"; key=S.KeyExec; priority=S.PriorExec; description=M.DescrExec; flags="NotEmptyCommandLine";
  action=SimSU.Shell_Aliases.Run;
}
