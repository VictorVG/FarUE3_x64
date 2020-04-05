-------------------------------------------------------------------------------
-- Выполнение команды через меню пользователя. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Common_Exec.cfg
return{
  Key="Enter NumEnter"; Prior=52; --Sort=50;

  CmdLinePrefix="Exec:"; -- Префикс командной строки который заставит выполняться коммандную строку через меню пользователя.
}
-- Конец файла Profile\SimSU\Common_Exec.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
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

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local F=far.Flags
S.CmdLinePrefix = S.CmdLinePrefix==nil and Settings().CmdLinePrefix or S.CmdLinePrefix

local _
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end
      ok, mod = pcall(require,"SimSU.Shell_Aliases")         ; if ok then SimSU.Shell_Aliases         =mod.Shell_Aliases          end

local function Prompt(CMD)
  if not Area.Shell then Keys("F12"); Keys("1") end-- Выходим в панели.
  if Area.Shell then
    Keys("F2 ShiftF2")
    if Menu.Select("SimSU Exec",2)>0 then
      Keys("Enter") -- Запускаем пункт меню пользователя.
    else
      Keys("End Ins Enter Tab"); print("SimSU Exec"); Keys("Tab"); print("!?Command?!"); Keys("Tab Enter CtrlDown Enter") -- Создаём и запускаем пункт меню.
    end
    if Area.Dialog then Keys("CtrlY") print(CMD or "") end
  end
end

local function ReturnLater(Inf)
  far.Timer(100,
    function(h)
      h:Close()
      local Ind
      for i=1,far.AdvControl(F.ACTL_GETWINDOWCOUNT) do
        local CInf=far.AdvControl(F.ACTL_GETWINDOWINFO,i)
        if CInf.Type==Inf.Type and CInf.Name==Inf.Name then Ind=i; break end
      end
      if Ind then far.AdvControl(F.ACTL_SETCURRENTWINDOW,Ind); far.AdvControl(F.ACTL_COMMIT) end
    end
  )
  return true
end

local function Exec(CMD)
  if not CMD then return false end
  local Inf=far.AdvControl(F.ACTL_GETWINDOWINFO)
  local Ind=0
  for i=1,far.AdvControl(F.ACTL_GETWINDOWCOUNT) do
    if far.AdvControl(F.ACTL_GETWINDOWINFO,i).Type==1 then Ind=i; break end
  end
  far.AdvControl(F.ACTL_SETCURRENTWINDOW,Ind); far.AdvControl(F.ACTL_COMMIT)
  if Area.Shell then
    _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
    SimSU.Common_Exec.Prompt(CMD); Keys("Enter")
    _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.RestoreLater and SimSU.Shell_RememberSelected.RestoreLater(APanel)
    SimSU.Common_Exec.ReturnLater(Inf)
    return true
  else
    return false
  end
end

local function CmdLine()
  if not(SimSU.Shell_Aliases and SimSU.Shell_Aliases.Work and SimSU.Shell_Aliases.Work()) then
    local cmd=mf.trim(_G.CmdLine.Value)
    if cmd:find(S.CmdLinePrefix,1,true)==1 then
      cmd=cmd:sub(S.CmdLinePrefix:len()+1)
      Keys("CtrlY"); SimSU.Common_Exec.Exec(cmd)
    else
      _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
      mmode(1,mmode(1,0),Keys("Enter"))
      _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.RestoreLater and SimSU.Shell_RememberSelected.RestoreLater(APanel)
    end
  end
end

-------------------------------------------------------------------------------
local Common_Exec={
  Prompt      = Prompt     ;
  ReturnLater = ReturnLater;
  Exec        = Exec       ;
  CmdLine     = CmdLine    ;
}
local function filename() SimSU.Common_Exec.Prompt() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Common_Exec=Common_Exec} end
SimSU.Common_Exec=Common_Exec; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="a116558f-987c-40e4-bfb7-0707bde5c238";
  area="Shell"; key=S.Key; priority=S.Prior; sortpriority=S.Sort; description=M.Descr; flags="NotEmptyCommandLine";
  action=function() return CmdLine() end;
}
