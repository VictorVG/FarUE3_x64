-------------------------------------------------------------------------------
-- Перемещение строк в редакторе. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_MoveStr.cfg
return{
  KeyDown="CtrlShiftDown"; --PriorDown=50; --SortDown=50;
  KeyUp  ="CtrlShiftUp";   --PriorUp  =50; --SortUp  =50;

  ExpandFile=true; --Расширять файл при перемещении строк за начало/конец файла.
}
-- Конец файла Profile\SimSU\Editor_MoveStr.cfg
end

_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
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

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local F=far.Flags
S.ExpandFile = S.ExpandFile==nil and Settings().ExpandFile or S.ExpandFile

local function Down()
  local tSel=editor.GetSelection()
  local tEdt=editor.GetInfo()
  local ID=tEdt.EditorID
  local Beg = tSel and tSel.StartLine or tEdt.CurLine
  local End = tSel and tSel.EndLine-(tSel and tSel.EndPos==0 and tSel.BlockType~=F.BTYPE_COLUMN and 1 or 0) or tEdt.CurLine
  if (tEdt.CurLine>=Beg and tEdt.CurLine<=End+(tSel and tSel.EndPos==0 and tSel.BlockType~=F.BTYPE_COLUMN and 1 or 0)) or (tSel and tSel.EndPos==-1 and tEdt.CurLine==tSel.EndLine+1) then
    editor.UndoRedo(ID,0)
    if End<tEdt.TotalLines then
      local Str,Eol=editor.GetString(ID,End+1,2)
      local StrLast,EolLast=editor.GetString(ID,End,2)
      editor.SetPosition(ID,Beg,1); editor.InsertString(ID); editor.SetString(ID,Beg,Str,Eol)
      editor.SetPosition(ID,End+1,1); editor.DeleteString(ID); editor.SetString(ID,End+1,StrLast,EolLast)
      if tSel then editor.Select(ID, tSel.BlockType, tSel.StartLine+1, tSel.StartPos,tSel.EndPos-tSel.StartPos+1, tSel.EndLine-tSel.StartLine+1) end
      local Scr= tEdt.CurLine > tEdt.WindowSizeY/2+tEdt.TopScreenLine and tEdt.TopScreenLine+1 or nil
      editor.SetPosition(ID,tEdt.CurLine+1,tEdt.CurPos,nil,Scr)
    elseif S.ExpandFile then
      editor.SetPosition(ID,Beg,1); editor.InsertString(ID)
      editor.SetPosition(ID,tEdt.CurLine+1,tEdt.CurPos)
    end
    editor.UndoRedo(ID,1)
  end
end

local function Up()
  local tSel=editor.GetSelection()
  local tEdt=editor.GetInfo()
  local ID=tEdt.EditorID
  local Beg = tSel and tSel.StartLine or tEdt.CurLine
  local End = tSel and tSel.EndLine-(tSel and tSel.EndPos==0 and tSel.BlockType~=F.BTYPE_COLUMN and 1 or 0) or tEdt.CurLine
  if (tEdt.CurLine>=Beg and tEdt.CurLine<=End+(tSel and tSel.EndPos==0 and tSel.BlockType~=F.BTYPE_COLUMN and 1 or 0)) or (tSel and tSel.EndPos==-1 and tEdt.CurLine==tSel.EndLine+1) then
    editor.UndoRedo(ID,0)
    if Beg>1 then
      local Str,Eol=editor.GetString(ID,Beg-1,2); editor.DeleteString(ID)
      local StrLast,EolLast=editor.GetString(ID,End-1,2); editor.SetString(ID,End-1,Str,Eol)
      editor.SetPosition(ID,End-1,1); editor.InsertString(ID); editor.SetString(ID,End-1,StrLast,EolLast)
      if tSel then editor.Select(ID,tSel.BlockType,tSel.StartLine-1,tSel.StartPos,tSel.EndPos-tSel.StartPos+1,tSel.EndLine-tSel.StartLine+1) end
      local Scr= tEdt.CurLine < tEdt.WindowSizeY/2+tEdt.TopScreenLine and tEdt.TopScreenLine-1 or nil
      editor.SetPosition(ID,tEdt.CurLine-1,tEdt.CurPos,nil,Scr)
    elseif S.ExpandFile then
      editor.SetPosition(ID,End+1,1); editor.InsertString(ID)
      editor.SetPosition(ID,tEdt.CurLine,tEdt.CurPos)
    end
    editor.UndoRedo(ID,1)
  end
end

-------------------------------------------------------------------------------
local Editor_MoveStr={
  Down = Down;
  Up   = Up  ;
}

local function filename(args)
  if args[1]=="Up"   then return Up() end
  if args[1]=="Down" then return Down() end
end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Editor_MoveStr=Editor_MoveStr} end
SimSU.Editor_MoveStr=Editor_MoveStr; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="eecbc57b-b419-428b-956a-73890374ab13";
  area="Editor"; key=S.KeyDown; priority=S.PriorDown; sortpriority=S.SortDown; description=M.DescrDown;
  action=Down;
}

Macro {id="22a066e5-1f2f-4248-b4fc-15b2c4f35405";
  area="Editor"; key=S.KeyUp;   priority=S.PriorUp;   sortpriority=S.SortUp;   description=M.DescrUp;
  action=Up;
}
