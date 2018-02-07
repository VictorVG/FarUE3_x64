-------------------------------------------------------------------------------
-- Перемещение строк в редакторе. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_MoveStr.cfg
return{
  KeyDown="CtrlShiftDown"; --Prior=50;
  KeyUp="CtrlShiftUp";

  ExpandFile=false; --Расширять файл при перетамещении строк за начало/конец файла.
}
-- Конец файла Profile\SimSU\Editor_MoveStr.cfg
end

_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_MoveStrRussian.lng
return{
  DescrDown="Перемещение строк в редакторе вниз. © SimSU";
  DescrUp="Перемещение строк в редакторе вверх. © SimSU";
}
-- Конец файла Profile\SimSU\Editor_MoveStrRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_MoveStrEnglish.lng
return{
  DescrDown="Move down the current line or all lines of the selected block. © SimSU";
  DescrUp="Move up the current line or all lines of the selected block. © SimSU";
}
-- End of file Profile\SimSU\Editor_MoveStrEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_MoveStr"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_MoveStr.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_MoveStr.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Editor_MoveStr={}
-------------------------------------------------------------------------------

function SimSU.Editor_MoveStr.Down()
  local Sel=editor.GetSelection()
  local Inf=editor.GetInfo()
  local Beg = Sel and Sel.StartLine or Inf.CurLine
  local End = Sel and Sel.EndLine or Inf.CurLine
  if (Inf.CurLine>=Beg and Inf.CurLine<=End) or (Sel and Sel.EndPos==-1 and Inf.CurLine==Sel.EndLine+1) then
    editor.UndoRedo(nil,0)
    if End<Inf.TotalLines then
      local Str,Eol=editor.GetString(nil,End+1,2)
      local StrLast,EolLast=editor.GetString(nil,End,2)
      editor.SetPosition(nil,Beg,1); editor.InsertString(); editor.SetString(nil,Beg,Str,Eol)
      editor.SetPosition(nil,End+1,1); editor.DeleteString(); editor.SetString(nil,End+1,StrLast,EolLast)
      if Sel then editor.Select(nil, Sel.BlockType, Sel.StartLine+1, Sel.StartPos,Sel.EndPos-Sel.StartPos+1, Sel.EndLine-Sel.StartLine+1) end
      local Scr= Inf.CurLine > Inf.WindowSizeY/2+Inf.TopScreenLine and Inf.TopScreenLine+1 or nil
      editor.SetPosition(nil,Inf.CurLine+1,Inf.CurPos,nil,Scr)
    elseif ExpandFile then
      editor.SetPosition(nil,Beg,1); editor.InsertString()
      editor.SetPosition(nil,Inf.CurLine+1,Inf.CurPos)
    end
    editor.UndoRedo(nil,1)
  end
end

function SimSU.Editor_MoveStr.Up()
  local Sel=editor.GetSelection()
  local Inf=editor.GetInfo()
  local Beg = Sel and Sel.StartLine or Inf.CurLine
  local End = Sel and Sel.EndLine or Inf.CurLine
  if (Inf.CurLine>=Beg and Inf.CurLine<=End) or (Sel and Sel.EndPos==-1 and Inf.CurLine==Sel.EndLine+1) then
    editor.UndoRedo(nil,0)
    if Beg>1 then
      local Str,Eol=editor.GetString(nil,Beg-1,2); editor.DeleteString()
      local StrLast,EolLast=editor.GetString(nil,End-1,2); editor.SetString(nil,End-1,Str,Eol)
      editor.SetPosition(nil,End-1,1); editor.InsertString(); editor.SetString(nil,End-1,StrLast,EolLast)
      if Sel then editor.Select(nil,Sel.BlockType,Sel.StartLine-1,Sel.StartPos,Sel.EndPos-Sel.StartPos+1,Sel.EndLine-Sel.StartLine+1) end
      local Scr= Inf.CurLine < Inf.WindowSizeY/2+Inf.TopScreenLine and Inf.TopScreenLine-1 or nil
      editor.SetPosition(nil,Inf.CurLine-1,Inf.CurPos,nil,Scr)
    elseif ExpandFile then
      editor.SetPosition(nil,End+1,1); editor.InsertString()
      editor.SetPosition(nil,Inf.CurLine,Inf.CurPos)
    end
    editor.UndoRedo(nil,1)
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Editor_MoveStr=SimSU.Editor_MoveStr} end

local ok, mod = pcall(require,"SimSU.Editor_MoveStr"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Editor"; key=S.KeyDown; priority=S.Prior; description=M.DescrDown;
  action=SimSU.Editor_MoveStr.Down;
}
Macro {area="Editor"; key=S.KeyUp; priority=S.Prior; description=M.DescrUp;
  action=SimSU.Editor_MoveStr.Up;
}
