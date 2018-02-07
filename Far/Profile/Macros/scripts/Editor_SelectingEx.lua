-------------------------------------------------------------------------------
-- Работа с выделенным блоком в редакторе. © SimSU
-------------------------------------------------------------------------------
-- Умеет:
--   Переход в начало выделенного блока.
--   Переход в конец выделенного блока.
--   Сохранение позиции выделенного блока.
--   Восстановление позиции выделенного блока.
--   Изменение типа.
--   Копировать (буфер обмена).
--   Вставить (буфер обмена).
--   Удалить.
--   Вырезать (буфер обмена).
--   Добавить (буфер обмена).
--   Добавить и вырезать (буфер обмена).
--   Обменять (буфер обмена).
--   Дублировать.

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_SelectingEx.cfg
return{
  Key="AltS"; --Prior=50;
  KeyDuplicate="CtrlAltD"; --PriorDuplicate=50;
  KeyInBegin="CtrlAltB"; --PriorInBegin=50;
  KeyInEnd="CtrlAltE"; --PriorInEnd=50;
  KeySavePos="CtrlAltS"; --PriorSavePos=50;
  KeyRestorePos="CtrlAltR"; --PriorRestorePos=50;
  KeySwitchType="CtrlAltT"; --PriorSwitchType=50;
  KeyClipExchange="CtrlAltX"; --PriorClipExchange=50;
}
-- Конец файла Profile\SimSU\Editor_SelectingEx.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_SelectingExRussian.lng
return{
  Descr       ="Работа с выделенным блоком в редакторе. © SimSU";

  Title       ="Работа с выделенным блоком";
  Duplicate   ="&A Дублировать";
  Jamp        ="Перейти";
  JampInBeg   ="&B В начало блока";
  JampInEnd   ="&E В конец блока";
  Pos         ="Позиция выделения";
  SavePos     ="&S Сохранить";
  RestorePos  ="&R Восстановить";
  Type        ="Тип блока";
  SwitchType  ="&T Изменить";
  Clip        ="Буфер обмена";
  ClipCopy    ="&C Копировать";
  ClipPaste   ="&P Вставить";
  ClipDel     ="&D Удалить";
  ClipCut     ="&U Вырезать";
  ClipAdd     ="&A Добавить";
  ClipAddDel  ="&N Добавить и удалить";
  ClipExchange="&X Обменять";

  DescrDuplicate="Работа с выделенным блоком в редакторе - дублировать блок. © SimSU";
  DescrInBegin="Работа с выделенным блоком в редакторе - перейти в начало блока. © SimSU";
  DescrInEnd="Работа с выделенным блоком в редакторе - перейти в конец блока. © SimSU";
  DescrSavePos="Работа с выделенным блоком в редакторе - сохранить позицию блока. © SimSU";
  DescrRestorePos="Работа с выделенным блоком в редакторе - восстановить позицию блока. © SimSU";
  DescrSwitchType="Работа с выделенным блоком в редакторе - переключить тип блока (строчный/вертикальный). © SimSU";
  DescrClipExchange="Работа с выделенным блоком в редакторе - обменять блок с буфером обмена. © SimSU";

}
-- Конец файла Profile\SimSU\Editor_SelectingExRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_SelectingExEnglish.lng
return{
  Descr       ="Work with the selectetd block in the editor. © SimSU";

  Title       ="Work with selectetd block";
  Duplicate   ="Duplicate";
  Jamp        ="Jamp";
  JampInBeg   ="&B In block beginning";
  JampInEnd   ="&E In block end";
  Pos         ="Allocation position";
  SavePos     ="&S Save";
  RestorePos  ="&R Restore";
  Type        ="Block type";
  SwitchType  ="&T Change";
  Clip        ="Clipboard";
  ClipCopy    ="&C Copy";
  ClipPaste   ="&P Paste";
  ClipDel     ="&D Delete";
  ClipCut     ="&U Cut";
  ClipAdd     ="&A Add";
  ClipAddDel  ="&N Add and delete";
  ClipExchange="&X Exchange";

  DescrDuplicate="Работа с выделенным блоком в редакторе - дублировать блок. © SimSU";
  DescrInBegin="Работа с выделенным блоком в редакторе - перейти в начало блока. © SimSU";
  DescrInEnd="Работа с выделенным блоком в редакторе - перейти в конец блока. © SimSU";
  DescrSavePos="Работа с выделенным блоком в редакторе - сохранить позицию блока. © SimSU";
  DescrRestorePos="Работа с выделенным блоком в редакторе - восстановить позицию блока. © SimSU";
  DescrSwitchType="Работа с выделенным блоком в редакторе - переключить тип блока (строчный/вертикальный). © SimSU";
  DescrClipExchange="Работа с выделенным блоком в редакторе - обменять блок с буфером обмена. © SimSU";
}
-- End of file Profile\SimSU\Editor_SelectingExEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SelectingEx"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_SelectingEx.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SelectingEx.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Editor_SelectingEx={}
-------------------------------------------------------------------------------
local SelBlock={}
local LastItem=1

function SimSU.Editor_SelectingEx.Duplicate()
  Editor.Set(2,Editor.Set(2,1), Keys("CtrlP"))
end

function SimSU.Editor_SelectingEx.JampInBegin()
  Editor.Sel(1,0)
end

function SimSU.Editor_SelectingEx.JampInEnd()
  Editor.Sel(1,1)
end

function SimSU.Editor_SelectingEx.SavePos()
  SelBlock[Editor.FileName] = Object.Selected and editor.GetSelection() or nil
end

function SimSU.Editor_SelectingEx.RestorePos()
  local Sel=SelBlock[Editor.FileName]
  if Sel then
    Sel.BlockStartLine=Sel.StartLine
    Sel.BlockStartPos= Sel.BlockType==2 and editor.RealToTab(nil,Sel.StartLine,Sel.StartPos) or Sel.StartPos
    Sel.BlockWidth= Sel.BlockType==2 and (editor.RealToTab(nil,Sel.EndLine,Sel.EndPos)-Sel.BlockStartPos+1) or Sel.EndPos-Sel.StartPos+1
    Sel.BlockHeight= Sel.EndLine-Sel.StartLine+1
    editor.Select(nil,Sel)
  end
end

function SimSU.Editor_SelectingEx.SwitchType()
  if Object.Selected then
    local Sel=editor.GetSelection()
    Sel.BlockType= Sel.BlockType==1 and 2 or 1
    Sel.BlockStartLine=Sel.StartLine
    Sel.BlockStartPos= Sel.BlockType==2 and editor.RealToTab(nil,Sel.StartLine,Sel.StartPos) or Sel.StartPos
    Sel.BlockWidth= Sel.BlockType==2 and (editor.RealToTab(nil,Sel.EndLine,Sel.EndPos)-Sel.BlockStartPos+1) or Sel.EndPos-Sel.StartPos+1
    Sel.BlockHeight= Sel.EndLine-Sel.StartLine+1
    editor.Select(nil,Sel)
  end
end

function SimSU.Editor_SelectingEx.ClipExchange()
  mf.clip(1,Editor.SelValue,Keys("CtrlD CtrlV"))
end

function SimSU.Editor_SelectingEx.Select()
  local item={}
  local len=0
  item[01]=M.Duplicate
  item[02]="\1  "..M.Jamp
  item[03]=M.JampInBeg
  item[04]=M.JampInEnd
  item[05]="\1  "..M.Pos
  item[06]=M.SavePos
  item[07]=M.RestorePos
  item[08]="\1  "..M.Type
  item[09]=M.SwitchType
  item[10]="\1  "..M.Clip
  item[11]=M.ClipCopy
  item[12]=M.ClipPaste
  item[13]=M.ClipDel
  item[14]=M.ClipCut
  item[15]=M.ClipAdd
  item[16]=M.ClipAddDel
  item[17]=M.ClipExchange
  for i=1,#item do len= item[i]:len()>len and item[i]:find("\1",1,true)~=1 and item[i]:len() or len end
  len=len+2
  for i=1,#item do item[i]= item[i]:find("\1",1,true)~=1 and item[i]..(' '):rep(len-item[i]:len()) or item[i] end
  --
  item[01]=item[01]..(S.KeyDuplicate or "")
  --
  item[03]=item[03]..(S.KeyInBegin or "")
  item[04]=item[04]..(S.KeyInEnd or "")
  --
  item[06]=item[06]..(S.KeySavePos or "")
  item[07]=item[07]..(S.KeyRestorePos or "")
  --
  item[09]=item[09]..(S.KeySwitchType or "")
  --
  item[11]=item[11].."CtrlC"
  item[12]=item[12].."CtrlV"
  item[13]=item[13].."CtrlD"
  item[14]=item[14].."CtrlX"
  item[15]=item[15].."CtrlAdd"
  item[16]=item[16].."CtrlAdd CtrlD"
  item[17]=item[17]..(S.KeyClipExchange or "")

  LastItem=Menu.Show(table.concat(item,"\n"),M.Title,0x8,LastItem)
  _ =
  LastItem==01 and SimSU.Editor_SelectingEx.Duplicate() or
  --
  LastItem==03 and SimSU.Editor_SelectingEx.JampInBegin() or
  LastItem==04 and SimSU.Editor_SelectingEx.JampInEnd() or
  --
  LastItem==06 and SimSU.Editor_SelectingEx.SavePos() or
  LastItem==07 and SimSU.Editor_SelectingEx.RestorePos() or
  --
  LastItem==09 and SimSU.Editor_SelectingEx.SwitchType() or
  --
  LastItem==11 and Keys("CtrlC") or
  LastItem==12 and Keys("CtrlV") or
  LastItem==13 and Keys("CtrlD") or
  LastItem==14 and Keys("CtrlX") or
  LastItem==15 and Keys("CtrlAdd") or
  LastItem==16 and Keys("CtrlAdd CtrlD") or
  LastItem==17 and SimSU.Editor_SelectingEx.ClipExchange()
end
-------------------------------------------------------------------------------
if not Macro then return {Editor_SelectingEx=SimSU.Editor_SelectingEx} end

local ok, mod = pcall(require,"SimSU.Editor_SelectingEx"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Editor"; key=S.Key; priority=S.Prior; description=M.Descr;
  action=SimSU.Editor_SelectingEx.Select;
}
Macro {area="Editor"; key=S.KeyDuplicate; priority=S.PriorDuplicate; description=M.DescrDuplicate;
  action=SimSU.Editor_SelectingEx.Duplicate;
}
Macro {area="Editor"; key=S.KeyInBegin; priority=S.PriorInBegin; description=M.DescrInBegin;
  action=SimSU.Editor_SelectingEx.JampInBegin;
}
Macro {area="Editor"; key=S.KeyInEnd; priority=S.PriorInEnd; description=M.DescrInEnd;
  action=SimSU.Editor_SelectingEx.JampInEnd;
}
Macro {area="Editor"; key=S.KeySavePos; priority=S.PriorSavePos; description=M.DescrSavePos;
  action=SimSU.Editor_SelectingEx.SavePos;
}
Macro {area="Editor"; key=S.KeyRestorePos; priority=S.PriorRestorePos; description=M.DescrRestorePos;
  action=SimSU.Editor_SelectingEx.RestorePos;
}
Macro {area="Editor"; key=S.KeySwitchType; priority=S.PriorSwitchType; description=M.DescrSwitchType;
  action=SimSU.Editor_SelectingEx.SwitchType;
}
Macro {area="Editor"; key=S.KeyClipExchange; priority=S.PriorClipExchange; description=M.DescrClipExchange;
  action=SimSU.Editor_SelectingEx.ClipExchange;
}
