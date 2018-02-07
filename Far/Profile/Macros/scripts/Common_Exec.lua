-------------------------------------------------------------------------------
-- Выполнение команды через меню пользователя. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Common_Exec.cfg
return{
  Key="Enter NumEnter"; Prior=52;

  CmdLinePrefix="Exec:"; -- Префикс командной строки который заставит выполняться коммандную строку через меню пользователя.
}
-- Конец файла Profile\SimSU\Common_Exec.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Common_ExecRussian.lng
return{
  Descr="Выполнение команды через меню пользователя или Windows. © SimSU";
}
-- Конец файла Profile\SimSU\Common_ExecRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Common_ExecEnglish.lng
return{
  Descr="Выполнение команды через меню пользователя или Windows. © SimSU";
}
-- End of file Profile\SimSU\Common_ExecEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Common_Exec"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Common_Exec.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Common_Exec.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Common_Exec={}
-------------------------------------------------------------------------------
local CmdLinePrefix=S.CmdLinePrefix or "Exec:"

function SimSU.Common_Exec.Prompt(VAL)
  if not Area.Shell then Keys("F12"); Keys("0") end-- Выходим в панели.
  if Area.Shell then
    Keys("F2 ShiftF2")
    if Menu.Select("SimSU Exec",2)>0 then
      Keys("Enter") -- Запускаем пункт меню пользователя.
    else
      Keys("End Ins Enter Tab"); print("SimSU Exec"); Keys("Tab"); print("!?Command?!"); Keys("Tab Enter CtrlDown Enter") -- Создаём и запускаем пункт меню.
    end
    if VAL then Keys("CtrlY") print(VAL) end
  end
end

function SimSU.Common_Exec.Exec(CMD)
  if not CMD then return false end
  local CurentScr
  if not Area.Shell then
    Keys("F12"); CurentScr=Menu.GetValue(0); Keys("0") -- Выходим в панели.
  end
  if Area.Shell then
    _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
    SimSU.Common_Exec.Prompt()
    Keys("CtrlY"); print(CMD); Keys("Enter") -- Запускаем команду.
    while not Area.Shell do mmode(1,mmode(1,0),Keys(mf.waitkey(100))) end -- Вопросы...
    _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel)
    if CurentScr then
      Keys("F12"); Menu.Select(CurentScr,0); Keys("Enter")
    end -- Возвращаемся.
    return true
  else
    return false
  end
end

function SimSU.Common_Exec.CmdLine()
  _ = SimSU.Shell_Aliases and SimSU.Shell_Aliases.Work and SimSU.Shell_Aliases.Work()
  if not CmdLine.Empty then
    local cmd=mf.trim(CmdLine.Value)
    if cmd:find(CmdLinePrefix,1,true)==1 then
      cmd=cmd:sub(CmdLinePrefix:len()+1)
      _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
      Keys("CtrlY")
      SimSU.Common_Exec.Exec(cmd)
      _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel)
    else
      _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
      mmode(1,mmode(1,0),Keys("Enter"))
      far.Timer(100, function(h) if Area.Shell then h:Close(); _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel) end end)
--      while not Area.Shell do mmode(1,mmode(1,0),Keys(mf.waitkey(100))) end -- Вопросы...
--      _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel)
    end
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Common_Exec=SimSU.Common_Exec} end

local ok, mod = pcall(require,"SimSU.Common_Exec"); if ok then SimSU=mod else _G.SimSU=SimSU end
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end
local ok, mod = pcall(require,"SimSU.Shell_Aliases"); if ok then SimSU.Shell_Aliases=mod.Shell_Aliases end
-------------------------------------------------------------------------------

Macro {area="Shell"; key=S.Key; priority=S.Prior; description=M.Descr; flags="NotEmptyCommandLine";
  action=SimSU.Common_Exec.CmdLine;
}
