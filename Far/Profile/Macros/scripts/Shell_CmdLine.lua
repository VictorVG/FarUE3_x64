-------------------------------------------------------------------------------
-- Работа в командной строке. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_CmdLine.cfg
return{
  KeyHome="Home"; --PriorHome=50;
  KeyEnd="End"; --PriorEnd=50;
  KeyShiftHome="ShiftHome"; --PriorShiftHome=50;
  KeyShiftEnd="ShiftEnd"; --PriorShiftEnd=50;
}
-- Конец файла Profile\SimSU\Shell_CmdLine.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_CmdLineRussian.lng
return{
  DescrHome="В начало командной строки. © SimSU";
  DescrEnd="В конец командной строки. © SimSU";
  DescrShiftHome="В начало командной строки с выделением. © SimSU";
  DescrShiftEnd="В конец командной строки с выделением. © SimSU";
}
-- Конец файла Profile\SimSU\Shell_CmdLineRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_CmdLineEnglish.lng
return{
  DescrHome="В начало командной строки. © SimSU";
  DescrEnd="В конец командной строки. © SimSU";
  DescrShiftHome="В начало командной строки с выделением. © SimSU";
  DescrShiftEnd="В конец командной строки с выделением. © SimSU";
}
-- End of file Profile\SimSU\Shell_CmdLineEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_CmdLine"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_CmdLine.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_CmdLine.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Shell_CmdLine={}
-------------------------------------------------------------------------------
function SimSU.Shell_CmdLine.Home()
  panel.SetCmdLineSelection(nil,-1,-1)
  panel.SetCmdLinePos(nil,1)
end

function SimSU.Shell_CmdLine.End()
  panel.SetCmdLineSelection(nil,-1,-1)
  panel.SetCmdLinePos(nil,panel.GetCmdLine():len()+1)
end

function SimSU.Shell_CmdLine.ShiftHome()
  local Beg,End = panel.GetCmdLineSelection()
  local Pos=panel.GetCmdLinePos()
  Pos= Pos==Beg and End+1 or Pos==End+1 and Beg or Pos
  panel.SetCmdLineSelection(nil,1,Pos-1)
  panel.SetCmdLinePos(nil,1)
end

function SimSU.Shell_CmdLine.ShiftEnd()
  local Beg,End = panel.GetCmdLineSelection()
  local Pos=panel.GetCmdLinePos()
  local Len=panel.GetCmdLine():len()
  Pos= Pos==Beg and End+1 or Pos==End+1 and Beg or Pos
  panel.SetCmdLineSelection(nil,Pos,Len)
  panel.SetCmdLinePos(nil,Len+1)
end

function SimSU.Shell_CmdLine.Save()
  local Cmd={}
  Cmd.Text=panel.GetCmdLine()
  Cmd.Pos=panel.GetCmdLinePos()
  Cmd.SelStart,Cmd.SelEnd = panel.GetCmdLineSelection()
  return Cmd
end

function SimSU.Shell_CmdLine.Restore(Cmd)
  if Cmd then
    panel.SetCmdLine(Cmd.Text)
    panel.SetCmdLinePos(Cmd.Pos)
    panel.GetCmdLineSelection(Cmd.SelStart,Cmd.SelEnd)
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Shell_CmdLine=SimSU.Shell_CmdLine} end

local ok, mod = pcall(require,"SimSU.Shell_CmdLine"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Shell Info QView Tree"; key=S.KeyHome; priority=S.PriorHome; description=M.DescrHome; flags="NotEmptyCommandLine";
  action=SimSU.Shell_CmdLine.Home;
}
Macro {area="Shell Info QView Tree"; key=S.KeyEnd; priority=S.PriorEnd; description=M.DescrEnd; flags="NotEmptyCommandLine";
  action=SimSU.Shell_CmdLine.End;
}
Macro {area="Shell Info QView Tree"; key=S.KeyShiftHome; priority=S.PriorShiftHome; description=M.DescrShiftHome; flags="NotEmptyCommandLine";
  action=SimSU.Shell_CmdLine.ShiftHome;
}
Macro {area="Shell Info QView Tree"; key=S.KeyShiftEnd; priority=S.PriorShiftEnd; description=M.DescrShiftEnd; flags="NotEmptyCommandLine";
  action=SimSU.Shell_CmdLine.ShiftEnd;
}
