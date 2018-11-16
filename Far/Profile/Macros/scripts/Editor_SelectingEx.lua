-------------------------------------------------------------------------------
-- Работа с помеченным блоком в редакторе. © SimSU
-------------------------------------------------------------------------------
-- Умеет:
--   Перейти в начало блока.
--   Перейти в конец блока.
--   Сохранить позиции блока.
--   Восстановить позиции блока.
--   Изменить типа блока строчный/вертикальный.
--   Копировать в буфер обмена.
--   Вставить из буфера обмена.
--   Удалить.
--   Вырезать в буфер обмена.
--   Добавить в буфер обмена.
--   Вырезать и добавить в буфер обмена.
--   Обменять с буфером обмена.
--   Дублировать.
--   Двигать блок.

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_SelectingEx.cfg
return{
  Key            ="AltS"      ; --Prior            =50; --Sort            =50;
  KeyDuplicate   ="CtrlAltD"  ; --PriorDuplicate   =50; --SortDuplicate   =50;
  KeyInBegin     ="CtrlAltB"  ; --PriorInBegin     =50; --SortInBegin     =50;
  KeyInEnd       ="CtrlAltE"  ; --PriorInEnd       =50; --SortInEnd       =50;
  KeySavePos     ="CtrlAltS"  ; --PriorSavePos     =50; --SortSavePos     =50;
  KeyRestorePos  ="CtrlAltR"  ; --PriorRestorePos  =50; --SortRestorePos  =50;
  KeySwitchType  ="CtrlAltT"  ; --PriorSwitchType  =50; --SortSwitchType  =50;
  KeyClipExchange="CtrlAltX"  ; --PriorClipExchange=50; --SortClipExchange=50;
  KeyMoveLeft    ="RCtrlLeft" ; --PriorMoveLeft    =50; --SortMoveLeft    =50;
  KeyMoveRight   ="RCtrlRight"; --PriorMoveRight   =50; --SortMoveRight   =50;
  KeyMoveUp      ="RCtrlUp"   ; --PriorMoveUp      =50; --SortMoveUp      =50;
  KeyMoveDown    ="RCtrlDown" ; --PriorMoveDown    =50; --SortMoveDown    =50;
  KeyAutoBeg     ="Left"      ; --PriorKeyAutoBeg  =50; --SortKeyAutoBeg  =50;
  KeyAutoEnd     ="Right"     ; --PriorKeyAutoEnd  =50; --SortKeyAutoEnd  =50;
}
-- Конец файла Profile\SimSU\Editor_SelectingEx.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_SelectingExRussian.lng
return{
  Descr       ="Работа с помеченным блоком в редакторе. © SimSU";

  Title       ="Работа с помеченным блоком";
  Duplicate   ="&A Дублировать"            ;
  Jump        ="Перейти"                   ;
  JumpInBeg   ="&B В начало блока"         ;
  JumpInEnd   ="&E В конец блока"          ;
  Pos         ="Позиция блока"             ;
  SavePos     ="&S Сохранить"              ;
  RestorePos  ="&R Восстановить"           ;
  MoveLeft    ="&G Сдвинуть влево"         ;
  MoveRight   ="&J Сдвинуть вправо"        ;
  MoveUp      ="&Y Сдвинуть вверх"         ;
  MoveDown    ="&H Сдвинуть вниз"          ;
  Type        ="Тип блока"                 ;
  SwitchType  ="&T Изменить"               ;
  Clip        ="Буфер обмена"              ;
  ClipCopy    ="&C Копировать"             ;
  ClipPaste   ="&P Вставить"               ;
  ClipDel     ="&D Удалить"                ;
  ClipCut     ="&U Вырезать"               ;
  ClipAdd     ="&A Добавить"               ;
  ClipAddDel  ="&N Добавить и удалить"     ;
  ClipExchange="&X Обменять"               ;

  DescrDuplicate   ="Выделенные блоки - дублировать блок. © SimSU"                                     ;
  DescrInBegin     ="Выделенные блоки - перейти в начало блока. © SimSU"                               ;
  DescrInEnd       ="Выделенные блоки - перейти в конец блока. © SimSU"                                ;
  DescrSavePos     ="Выделенные блоки - сохранить позицию блока. © SimSU"                              ;
  DescrRestorePos  ="Выделенные блоки - восстановить позицию блока. © SimSU"                           ;
  DescrMoveLeft    ="Выделенные блоки - сдвинуть позицию блока влево. © SimSU"                         ;
  DescrMoveRight   ="Выделенные блоки - сдвинуть позицию блока вправо. © SimSU"                        ;
  DescrMoveUp      ="Выделенные блоки - сдвинуть позицию блока вверх. © SimSU"                         ;
  DescrMoveDown    ="Выделенные блоки - сдвинуть позицию блока вниз. © SimSU"                          ;
  DescrSwitchType  ="Выделенные блоки - переключить тип блока (строчный/вертикальный). © SimSU"        ;
  DescrClipExchange="Выделенные блоки - обменять блок с буфером обмена. © SimSU"                       ;
  DescrAutoBeg     ="Выделенные блоки - если в конце, то первым делом перейти в начало блока. © SimSU" ;
  DescrAutoEnd     ="Выделенные блоки - если в начале, то первым делом перейти в конец блока. © SimSU" ;

}
-- Конец файла Profile\SimSU\Editor_SelectingExRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_SelectingExEnglish.lng
return{
  Descr       ="Work with the selected block in the editor. © SimSU";

  Title       ="Work with selected block"  ;
  Duplicate   ="Duplicate"                 ;
  Jump        ="Jump"                      ;
  JumpInBeg   ="&B To block beginning"     ;
  JumpInEnd   ="&E To block end"           ;
  Pos         ="Block position"            ;
  SavePos     ="&S Save"                   ;
  RestorePos  ="&R Restore"                ;
  MoveLeft    ="&G Move Left"              ;
  MoveRight   ="&J Move Right"             ;
  MoveUp      ="&Y Move Up"                ;
  MoveDown    ="&H MoveDown"               ;
  Type        ="Block type"                ;
  SwitchType  ="&T Switch"                 ;
  Clip        ="Clipboard"                 ;
  ClipCopy    ="&C Copy"                   ;
  ClipPaste   ="&P Paste"                  ;
  ClipDel     ="&D Delete"                 ;
  ClipCut     ="&U Cut"                    ;
  ClipAdd     ="&A Add"                    ;
  ClipAddDel  ="&N Add and delete"         ;
  ClipExchange="&X Exchange"               ;

  DescrDuplicate   ="Выделенные блоки - дублировать блок. © SimSU"                             ;
  DescrInBegin     ="Выделенные блоки - перейти в начало блока. © SimSU"                       ;
  DescrInEnd       ="Выделенные блоки - перейти в конец блока. © SimSU"                        ;
  DescrSavePos     ="Выделенные блоки - сохранить позицию блока. © SimSU"                      ;
  DescrRestorePos  ="Выделенные блоки - восстановить позицию блока. © SimSU"                   ;
  DescrMoveLeft    ="Выделенные блоки - сдвинуть позицию блока влево. © SimSU"                 ;
  DescrMoveRight   ="Выделенные блоки - сдвинуть позицию блока вправо. © SimSU"                ;
  DescrMoveUp      ="Выделенные блоки - сдвинуть позицию блока вверх. © SimSU"                 ;
  DescrMoveDown    ="Выделенные блоки - сдвинуть позицию блока вниз. © SimSU"                  ;
  DescrSwitchType  ="Выделенные блоки - переключить тип блока (строчный/вертикальный). © SimSU";
  DescrClipExchange="Выделенные блоки - обменять блок с буфером обмена. © SimSU"               ;
  DescrAutoBeg     ="Выделенные блоки - если в конце, то первым делом перейти в начало блока. © SimSU";
  DescrAutoEnd     ="Выделенные блоки - если в начале, то первым делом перейти в конец блока. © SimSU";
}
-- End of file Profile\SimSU\Editor_SelectingExEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SelectingEx"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_SelectingEx.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SelectingEx.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local F=far.Flags
local SelBlock={}
local LastItem=1
local _

local function Duplicate()
  return Editor.Set(2,Editor.Set(2,1), Keys("CtrlP"))
end

local function JumpInBegin()
  return Editor.Sel(1,0)
end

local function JumpInEnd()
  return Editor.Sel(1,1)
end

local function SavePos()
  SelBlock[Editor.FileName] = Object.Selected and editor.GetSelection() or nil
  return SelBlock[Editor.FileName]
end

local function Get2Sel(EdSel)
  if EdSel then
    EdSel.BlockStartLine= EdSel.StartLine
    EdSel.BlockStartPos = EdSel.BlockType==2 and (editor.RealToTab(nil,EdSel.StartLine,EdSel.StartPos)                      ) or (EdSel.StartPos               )
    EdSel.BlockWidth    = EdSel.BlockType==2 and (editor.RealToTab(nil,EdSel.EndLine  ,EdSel.EndPos  )-EdSel.BlockStartPos+1) or (EdSel.EndPos-EdSel.StartPos+1)
    EdSel.BlockHeight   = EdSel.EndLine-EdSel.StartLine+1
  end
  return EdSel
end

local function RestorePos()
  local EdSel=SelBlock[Editor.FileName]
  return EdSel and editor.Select(nil,Get2Sel(EdSel))
end

local function MoveLeft()
  local EdSel = Object.Selected and editor.GetSelection() or nil
  if EdSel then
    EdSel = Get2Sel(EdSel)
    EdSel.BlockStartPos = EdSel.BlockStartPos > 1 and EdSel.BlockStartPos-1 or EdSel.BlockStartPos
    editor.Select(nil,EdSel)
    return JumpInBegin()
  end
end

local function MoveRight()
  local EdSel = Object.Selected and editor.GetSelection() or nil
  if EdSel then
    EdSel = Get2Sel(EdSel)
    EdSel.BlockStartPos = EdSel.BlockStartPos+1
    editor.Select(nil,EdSel)
    return JumpInEnd()
  end
end

local function MoveUp()
  local EdSel = Object.Selected and editor.GetSelection() or nil
  if EdSel then
    EdSel = Get2Sel(EdSel)
    EdSel.BlockStartLine = EdSel.BlockStartLine > 1 and EdSel.BlockStartLine-1 or EdSel.BlockStartLine
    editor.Select(nil,EdSel)
    return JumpInBegin()
  end
end

local function MoveDown()
  local EdSel = Object.Selected and editor.GetSelection() or nil
  if EdSel then
    EdSel = Get2Sel(EdSel)
    EdSel.BlockStartLine = EdSel.BlockStartLine+1
    editor.Select(nil,EdSel)
    return JumpInEnd()
  end
end

local function SwitchType()
  local EdSel = Object.Selected and editor.GetSelection() or nil
  if EdSel then
    EdSel.BlockType = EdSel.BlockType==1 and 2 or 1
    EdSel = Get2Sel(EdSel)
    return editor.Select(nil,EdSel)
  end
end

local function JumpAutoBeg()
  local EdSel = Object.Selected and editor.GetSelection() or nil
  return EdSel and band(editor.GetInfo().Options,F.EOPT_PERSISTENTBLOCKS)==0 and not (Editor.RealPos==EdSel.StartPos and Editor.CurLine==EdSel.StartLine)
end

local function JumpAutoEnd()
  local EdSel = Object.Selected and editor.GetSelection() or nil
  return EdSel and band(editor.GetInfo().Options,F.EOPT_PERSISTENTBLOCKS)==0 and not (Editor.RealPos==EdSel.EndPos+1 and Editor.CurLine==EdSel.EndLine)
end

local function ClipExchange()
  return mf.clip(1,Editor.SelValue,Keys("CtrlD CtrlV"))
end

local function Select()
  local item={}
  local len=0
  item[01]=M.Duplicate
  item[02]="\1  "..M.Jump
  item[03]=M.JumpInBeg
  item[04]=M.JumpInEnd
  item[05]="\1  "..M.Pos
  item[06]=M.SavePos
  item[07]=M.RestorePos
  item[08]=M.MoveLeft
  item[09]=M.MoveRight
  item[10]=M.MoveUp
  item[11]=M.MoveDown
  item[12]="\1  "..M.Type
  item[13]=M.SwitchType
  item[14]="\1  "..M.Clip
  item[15]=M.ClipCopy
  item[16]=M.ClipPaste
  item[17]=M.ClipDel
  item[18]=M.ClipCut
  item[19]=M.ClipAdd
  item[20]=M.ClipAddDel
  item[21]=M.ClipExchange
  for i=1,#item do len= item[i]:len()>len and item[i]:find("\1",1,true)~=1 and item[i]:len() or len end
  len=len+2
  for i=1,#item do item[i]= item[i]:find("\1",1,true)~=1 and item[i]..(' '):rep(len-item[i]:len()) or item[i] end
  --
  item[01]=item[01]..(S.KeyDuplicate  or "")
  --[ [02] ]
  item[03]=item[03]..(S.KeyInBegin    or "")
  item[04]=item[04]..(S.KeyInEnd      or "")
  --[ [05] ]
  item[06]=item[06]..(S.KeySavePos    or "")
  item[07]=item[07]..(S.KeyRestorePos or "")
  item[08]=item[08]..(S.KeyMoveLeft   or "")
  item[09]=item[09]..(S.KeyMoveRight  or "")
  item[10]=item[10]..(S.KeyMoveUp     or "")
  item[11]=item[11]..(S.KeyMoveDown   or "")
  --[ [12] ]
  item[13]=item[13]..(S.KeySwitchType or "")
  --[ [14] ]
  item[15]=item[15].."CtrlC"
  item[16]=item[16].."CtrlV"
  item[17]=item[17].."CtrlD"
  item[18]=item[18].."CtrlX"
  item[19]=item[19].."CtrlAdd"
  item[20]=item[20].."CtrlAdd CtrlD"
  item[21]=item[21]..(S.KeyClipExchange or "")

  LastItem=Menu.Show(table.concat(item,"\n"),M.Title,0x8,LastItem)
  return
  LastItem==01 and Duplicate()   or
  --        02
  LastItem==03 and JumpInBegin() or
  LastItem==04 and JumpInEnd()   or
  --        05
  LastItem==06 and SavePos()     or
  LastItem==07 and RestorePos()  or
  LastItem==08 and MoveLeft()    or
  LastItem==09 and MoveRight()   or
  LastItem==10 and MoveUp()      or
  LastItem==11 and MoveDown()    or
  --        12
  LastItem==13 and SwitchType()  or
  --        14
  LastItem==15 and Keys("CtrlC") or
  LastItem==16 and Keys("CtrlV") or
  LastItem==17 and Keys("CtrlD") or
  LastItem==18 and Keys("CtrlX") or
  LastItem==19 and Keys("CtrlAdd") or
  LastItem==20 and Keys("CtrlAdd CtrlD") or
  LastItem==21 and ClipExchange()
end

-------------------------------------------------------------------------------
local Editor_SelectingEx={
  Duplicate   =Duplicate   ;
  JumpInBegin =JumpInBegin ;
  JumpInEnd   =JumpInEnd   ;
  SavePos     =SavePos     ;
  Get2Sel     =Get2Sel     ;
  RestorePos  =RestorePos  ;
  MoveLeft    =MoveLeft    ;
  MoveRight   =MoveRight   ;
  MoveUp      =MoveUp      ;
  MoveDown    =MoveDown    ;
  SwitchType  =SwitchType  ;
  ClipExchange=ClipExchange;
  JumpAutoBeg =JumpAutoBeg ;
  JumpAutoEnd =JumpAutoEnd ;
}
-------------------------------------------------------------------------------
local function filename() return Select() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Editor_SelectingEx=Editor_SelectingEx} end
SimSU.Editor_SelectingEx=Editor_SelectingEx; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="63bd0f2c-51e9-41d4-b206-39c8387a6d64";
  area="Editor"; key=S.Key;             priority=S.Prior            ; sortpriority=S.Sort            ; description=M.Descr            ;
  action=Select        ;
}
Macro {id="3411986f-6037-4a64-b100-1f21021c5123";
  area="Editor"; key=S.KeyDuplicate;    priority=S.PriorDuplicate   ; sortpriority=S.SortDuplicate   ; description=M.DescrDuplicate   ; flags="EVSelection";
  action=Duplicate     ;
}
Macro {id="d8037967-a3c8-4098-bb7f-7045422cb80f";
  area="Editor"; key=S.KeyInBegin;      priority=S.PriorInBegin     ; sortpriority=S.SortInBegin     ; description=M.DescrInBegin     ; flags="EVSelection";
  action=JumpInBegin   ;
}
Macro {id="722bcbd0-3b12-40bb-9044-d6240b1152fe";
  area="Editor"; key=S.KeyInEnd;        priority=S.PriorInEnd       ; sortpriority=S.SortInEnd       ; description=M.DescrInEnd       ; flags="EVSelection";
  action=JumpInEnd     ;
}
Macro {id="8c4d5ab-6bca-4d87-b635-8c02834e6cdb";
  area="Editor"; key=S.KeySavePos;      priority=S.PriorSavePos     ; sortpriority=S.SortSavePos     ; description=M.DescrSavePos     ; flags="EVSelection";
  action=SavePos       ;
}
Macro {id="a137c379-d5d2-41cb-9acc-08b8084576fc";
  area="Editor"; key=S.KeyRestorePos;   priority=S.PriorRestorePos  ; sortpriority=S.SortRestorePos  ; description=M.DescrRestorePos  ;
  action=RestorePos    ;
}
Macro {id="b8655db5-b109-451f-b9dc-ec1f9b305a2a";
  area="Editor"; key=S.KeyMoveLeft;     priority=S.PriorMoveLeft    ; sortpriority=S.SortMoveLeft    ; description=M.DescrMoveLeft    ; flags="EVSelection";
  action=MoveLeft      ;
}
Macro {id="a8ad3832-97ea-4427-9fea-5e8c6e0aefe9";
  area="Editor"; key=S.KeyMoveRight;    priority=S.PriorMoveRight   ; sortpriority=S.SortMoveRight   ; description=M.DescrMoveRight   ; flags="EVSelection";
  action=MoveRight     ;
}
Macro {id="cd9f7beb-a340-45c3-8985-de4794a3be5a";
  area="Editor"; key=S.KeyMoveUp;       priority=S.PriorMoveUp      ; sortpriority=S.SortMoveUp      ; description=M.DescrMoveUp      ; flags="EVSelection";
  action=MoveUp        ;
}
Macro {id="7e0193ec-a727-4576-9277-688825844af7";
  area="Editor"; key=S.KeyMoveDown;     priority=S.PriorMoveDown    ; sortpriority=S.SortMoveDown    ; description=M.DescrMoveDown    ; flags="EVSelection";
  action=MoveDown      ;
}
Macro {id="50c27c33-a056-44fb-9ede-186f3d4388e8";
  area="Editor"; key=S.KeySwitchType;   priority=S.PriorSwitchType  ; sortpriority=S.SortSwitchType  ; description=M.DescrSwitchType  ; flags="EVSelection";
  action=SwitchType    ;
}
Macro {id="499c2169-f904-4b74-8422-9adc614aa8e6";
  area="Editor"; key=S.KeyClipExchange; priority=S.PriorClipExchange; sortpriority=S.SortClipExchange; description=M.DescrClipExchange; flags="EVSelection";
  action=ClipExchange  ;
}
Macro {id="7eea99fb-7bbb-412b-906e-1c6c335d0a6c";
  area="Editor"; key=S.KeyAutoBeg;      priority=S.PriorAutoBeg     ; sortpriority=S.SortAutoBeg     ; description=M.DescrAutoBeg     ; flags="EVSelection";
  condition=JumpAutoBeg;
  action=JumpInBegin   ;
}
Macro {id="e69db4dd-c2b7-4beb-88b1-b0f0faa2cb71";
  area="Editor"; key=S.KeyAutoEnd;      priority=S.PriorAutoEnd     ; sortpriority=S.SortAutoEnd     ; description=M.DescrAutoEnd     ; flags="EVSelection";
  condition=JumpAutoEnd;
  action   =JumpInEnd  ;
}
