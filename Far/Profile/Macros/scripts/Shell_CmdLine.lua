-------------------------------------------------------------------------------
-- Работа в командной строке. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_CmdLine.cfg
return{
  KeyHome     ="Home"     ; --PriorHome     =50;  --SortHome     =50;
  KeyEnd      ="End"      ; --PriorEnd      =50;  --SortEnd      =50;
  KeyShiftHome="ShiftHome"; --PriorShiftHome=50;  --SortShiftHome=50;
  KeyShiftEnd ="ShiftEnd" ; --PriorShiftEnd =50;  --SortShiftEnd =50;
}
-- Конец файла Profile\SimSU\Shell_CmdLine.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
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

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------

local function Home()
  panel.SetCmdLineSelection(nil,-1,-1)
  panel.SetCmdLinePos(nil,1)
end

local function End()
  panel.SetCmdLineSelection(nil,-1,-1)
  panel.SetCmdLinePos(nil,panel.GetCmdLine():len()+1)
end

local function ShiftHome()
  local BEG,END = panel.GetCmdLineSelection()
  local Pos=panel.GetCmdLinePos()
  Pos= Pos==BEG and END+1 or Pos==END+1 and BEG or Pos
  panel.SetCmdLineSelection(nil,1,Pos-1)
  panel.SetCmdLinePos(nil,1)
end

local function ShiftEnd()
  local BEG,END = panel.GetCmdLineSelection()
  local Pos=panel.GetCmdLinePos()
  local Len=panel.GetCmdLine():len()
  Pos= Pos==BEG and END+1 or Pos==END+1 and BEG or Pos
  panel.SetCmdLineSelection(nil,Pos,Len)
  panel.SetCmdLinePos(nil,Len+1)
end

local function Save()
  local Cmd={}
  Cmd.Text=panel.GetCmdLine()
  Cmd.Pos=panel.GetCmdLinePos()
  Cmd.SelStart,Cmd.SelEnd = panel.GetCmdLineSelection()
  return Cmd
end

local function Restore(Cmd)
  return Cmd and panel.SetCmdLine(nil,Cmd.Text) and panel.SetCmdLinePos(nil,Cmd.Pos) and panel.SetCmdLineSelection(nil,Cmd.SelStart,Cmd.SelEnd)
end

-------------------------------------------------------------------------------
local Shell_CmdLine={
Home      = Home     ;
End       = End      ;
ShiftHome = ShiftHome;
ShiftEnd  = ShiftEnd ;
Save      = Save     ;
Restore   = Restore  ;
}
local function filename() return Restore() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Shell_CmdLine=Shell_CmdLine} end
SimSU.Shell_CmdLine=Shell_CmdLine; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="a36290a5-3f43-4e4f-831e-b8ed917dc295";
  area="Shell Info QView Tree"; key=S.KeyHome;      priority=S.PriorHome;      sortpriority=S.SortHome;      description=M.DescrHome;      flags="NotEmptyCommandLine";
  action=Home;
}
Macro {id="50ef7206-187e-47ec-93bb-c34ef8fe617c";
  area="Shell Info QView Tree"; key=S.KeyEnd;       priority=S.PriorEnd;       sortpriority=S.SortEnd;       description=M.DescrEnd;       flags="NotEmptyCommandLine";
  action=End;
}
Macro {id="0a75f866-4c10-463d-8ff4-4d158a55b4cc";
  area="Shell Info QView Tree"; key=S.KeyShiftHome; priority=S.PriorShiftHome; sortpriority=S.SortShiftHome; description=M.DescrShiftHome; flags="NotEmptyCommandLine";
  action=ShiftHome;
}
Macro {id="04cce125-359f-4ebc-87f5-c6ca204124d7";
  area="Shell Info QView Tree"; key=S.KeyShiftEnd;  priority=S.PriorShiftEnd;  sortpriority=S.SortShiftEnd;  description=M.DescrShiftEnd;  flags="NotEmptyCommandLine";
  action=ShiftEnd;
}
