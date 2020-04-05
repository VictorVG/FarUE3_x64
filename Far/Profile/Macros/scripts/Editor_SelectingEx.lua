-------------------------------------------------------------------------------
-- Работа с помеченным блоком в редакторе. © SimSU
-------------------------------------------------------------------------------
-- Умеет:
--   Перейти в начало блока.
--   Перейти в конец блока.
--   Сохранить позиции блока.
--   Восстановить позицию блока.
--   Двигать позицию блока.
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
  Key            ="AltS"          ; --Prior             =50; --Sort             =50;
  KeyDuplicate   ="CtrlAltD"      ; --PriorDuplicate    =50; --SortDuplicate    =50;
  KeyInBegin     ="CtrlAltB"      ; --PriorInBegin      =50; --SortInBegin      =50;
  KeyInEnd       ="CtrlAltE"      ; --PriorInEnd        =50; --SortInEnd        =50;
  KeySavePos     ="CtrlAltS"      ; --PriorSavePos      =50; --SortSavePos      =50;
  KeyRestorePos  ="CtrlAltR"      ; --PriorRestorePos   =50; --SortRestorePos   =50;
  KeySwitchType  ="CtrlAltT"      ; --PriorSwitchType   =50; --SortSwitchType   =50;
  KeyClipExchange="CtrlAltX"      ; --PriorClipExchange =50; --SortClipExchange =50;
  KeyMoveLeft    ="RCtrlLeft"     ; --PriorMoveLeft     =50; --SortMoveLeft     =50;
  KeyMoveRight   ="RCtrlRight"    ; --PriorMoveRight    =50; --SortMoveRight    =50;
  KeyMoveUp      ="RCtrlUp"       ; --PriorMoveUp       =50; --SortMoveUp       =50;
  KeyMoveDown    ="RCtrlDown"     ; --PriorMoveDown     =50; --SortMoveDown     =50;
  KeyShiftUp     ="RCtrlAltUp"    ; --PriorShiftUp      =50; --SortShiftUp      =50;
  KeyShiftDown   ="RCtrlAltDown"  ; --PriorShiftDown    =50; --SortShiftDown    =50;
  KeyShiftLeft   ="RCtrlAltLeft"  ; --PriorShiftLeft    =50; --SortShiftLeft    =50;
  KeyShiftRight  ="RCtrlAltRight" ; --PriorShiftRight   =50; --SortShiftRight   =50;
  KeyAutoBeg     ="Left"          ; --PriorKeyAutoBeg   =50; --SortKeyAutoBeg   =50;
  KeyAutoEnd     ="Right"         ; --PriorKeyAutoEnd   =50; --SortKeyAutoEnd   =50;
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
  Duplicate   ="&W Дублировать"            ;
  Shift       ="Переместить блок"          ;
  ShiftLeft   ="&4 Переместить влево"      ;
  ShiftRight  ="&6 Переместить вправо"     ;
  ShiftUp     ="&8 Переместить вверх"      ;
  ShiftDown   ="&2 Переместить вниз"       ;
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
  DescrShiftLeft   ="Выделенные блоки - переместить блок влево. © SimSU"                               ;
  DescrShiftRight  ="Выделенные блоки - переместить блок вправо. © SimSU"                              ;
  DescrShiftUp     ="Выделенные блоки - переместить блок вверх. © SimSU"                               ;
  DescrShiftDown   ="Выделенные блоки - переместить блок вниз. © SimSU"                                ;
  DescrAutoBeg     ="Выделенные блоки - если в конце, то перевым делом перейти в начало блока. © SimSU";
  DescrAutoEnd     ="Выделенные блоки - если в Начале, то перевым делом перейти в конец блока. © SimSU";

}
-- Конец файла Profile\SimSU\Editor_SelectingExRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_SelectingExEnglish.lng
return{
  Descr       ="Work with the selected block in the editor. © SimSU";

  Title       ="Work with selected block";
  Duplicate   ="&W Duplicate"            ;
  Shift       ="Shift"                   ;
  ShiftLeft   ="&4 Shift Left"           ;
  ShiftRight  ="&6 Shift Right"          ;
  ShiftUp     ="&8 Shift Up"             ;
  ShiftDown   ="&2 Shift Down"           ;
  Jump        ="Jump"                    ;
  JumpInBeg   ="&B To block beginning"   ;
  JumpInEnd   ="&E To block end"         ;
  Pos         ="Block position"          ;
  SavePos     ="&S Save"                 ;
  RestorePos  ="&R Restore"              ;
  MoveLeft    ="&G Move Left"            ;
  MoveRight   ="&J Move Right"           ;
  MoveUp      ="&Y Move Up"              ;
  MoveDown    ="&H Move Down"            ;
  Type        ="Block type"              ;
  SwitchType  ="&T Switch"               ;
  Clip        ="Clipboard"               ;
  ClipCopy    ="&C Copy"                 ;
  ClipPaste   ="&P Paste"                ;
  ClipDel     ="&D Delete"               ;
  ClipCut     ="&U Cut"                  ;
  ClipAdd     ="&A Add"                  ;
  ClipAddDel  ="&N Add and delete"       ;
  ClipExchange="&X Exchange"             ;

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
  DescrAutoBeg     ="Выделенные блоки - если в конце, то перевым делом перейти в начало блока. © SimSU";
  DescrAutoEnd     ="Выделенные блоки - если в Начале, то перевым делом перейти в конец блока. © SimSU";
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
  return Editor.Set(2,Editor.Set(2,1), Editor.Sel(1,0) and Keys("CtrlP"))
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

local function ShiftRight()
  local EdSel = Object.Selected and Get2Sel(editor.GetSelection()) or nil
  if EdSel and EdSel.BlockType==1 then
    Keys("AltI")
  elseif EdSel then
    Editor.Undo(0)
    EdSel.BlockStartPos = EdSel.BlockStartPos+1
    mf.clip(5,0) Keys("CtrlX Right CtrlV") mf.clip(5,0)
    editor.Select(nil,EdSel)
    Editor.Undo(1)
  end
end;

local function ShiftLeft()
  local EdSel = Object.Selected and Get2Sel(editor.GetSelection()) or nil
  if EdSel and EdSel.BlockType==1 then
    Keys("AltU")
  elseif EdSel and EdSel.BlockStartPos > 1  then
    Editor.Undo(0)
    EdSel.BlockStartPos = EdSel.BlockStartPos-1
    mf.clip(5,0) Keys("CtrlX Left CtrlV") mf.clip(5,0)
    editor.Select(nil,EdSel)
    Editor.Undo(1)
  end
end;

local function ShiftDown()
  local EdSel = Object.Selected and Get2Sel(editor.GetSelection()) or nil
  if EdSel and EdSel.BlockType==1 then
    Editor.Undo(0)
    EdSel.BlockStartLine = EdSel.BlockStartLine+1
    mf.clip(5,0)
    if EdSel.EndLine+1 > Editor.Lines then Keys("CtrlX Enter Down CtrlV") else Keys("CtrlX Down CtrlV") end
    mf.clip(5,0)
    editor.Select(nil,EdSel)
    Editor.Undo(1)
  elseif EdSel then
    Editor.Undo(0)
    EdSel.BlockStartLine = EdSel.BlockStartLine+1
    mf.clip(5,0) Keys("CtrlX Down CtrlV") mf.clip(5,0)
    editor.Select(nil,EdSel)
    Editor.Undo(1)
  end
end;

local function ShiftUp()
  local EdSel = Object.Selected and Get2Sel(editor.GetSelection()) or nil
  if EdSel and EdSel.BlockType==1 and EdSel.BlockStartLine > 1 then
    Editor.Undo(0)
    EdSel.BlockStartLine = EdSel.BlockStartLine-1
    mf.clip(5,0) Keys("CtrlX Up CtrlV") mf.clip(5,0)
    editor.Select(nil,EdSel)
    Editor.Undo(1)
  elseif EdSel and EdSel.BlockStartLine > 1 then
    Editor.Undo(0)
    EdSel.BlockStartLine = EdSel.BlockStartLine-1
    mf.clip(5,0) Keys("CtrlX Up CtrlV") mf.clip(5,0)
    editor.Select(nil,EdSel)
    Editor.Undo(1)
  end
end;

local function JumpAutoBeg()
  local EdSel = Object.Selected and band(Editor.State,0x00000400)==0 and editor.GetSelection()
  return EdSel and band(editor.GetInfo().Options,F.EOPT_PERSISTENTBLOCKS)==0 and not (Editor.RealPos==EdSel.StartPos and Editor.CurLine==EdSel.StartLine)
end

local function JumpAutoEnd()
  local  EdSel = Object.Selected and band(Editor.State,0x00000400)==0 and editor.GetSelection() or nil
  return EdSel and band(editor.GetInfo().Options,F.EOPT_PERSISTENTBLOCKS)==0 and not (Editor.RealPos==EdSel.EndPos+1 and Editor.CurLine==EdSel.EndLine)
end

local function ClipExchange()
  return Editor.Undo(0),mf.clip(5,0),Keys("CtrlX"),mf.clip(5,0),Keys("CtrlV"),mf.clip(4),Editor.Undo(1)
  --return mf.clip(1,Editor.SelValue,Keys("CtrlD CtrlV"))
end

local function Select()
  local mi={ -- far.Menu (ala BAX)
    {text=M.Duplicate   ; AccelKey=(S.KeyDuplicate       or "");     Action=Duplicate    };
    {text=M.Shift       ;                             separator=true                     };
    {text=M.ShiftLeft   ; AccelKey=(S.KeyShiftLeft       or "");     Action=ShiftLeft    };
    {text=M.ShiftRight  ; AccelKey=(S.KeyShiftRight      or "");     Action=ShiftRight   };
    {text=M.ShiftUp     ; AccelKey=(S.KeyShiftUp         or "");     Action=ShiftUp      };
    {text=M.ShiftDown   ; AccelKey=(S.KeyShiftDown       or "");     Action=ShiftDown    };
    {text=M.Jump        ;                             separator=true                     };
    {text=M.JumpInBeg   ; AccelKey=(S.KeyInBegin         or "");     Action=JumpInBegin  };
    {text=M.JumpInEnd   ; AccelKey=(S.KeyInEnd           or "");     Action=JumpInEnd    };
    {text=M.Pos         ;                             separator=true                     };
    {text=M.SavePos     ; AccelKey=(S.KeySavePos         or "");     Action=SavePos      };
    {text=M.RestorePos  ; AccelKey=(S.KeyRestorePos      or "");     Action=RestorePos   };
    {text=M.MoveLeft    ; AccelKey=(S.KeyMoveLeft        or "");     Action=MoveLeft     };
    {text=M.MoveRight   ; AccelKey=(S.KeyMoveRight       or "");     Action=MoveRight    };
    {text=M.MoveUp      ; AccelKey=(S.KeyMoveUp          or "");     Action=MoveUp       };
    {text=M.MoveDown    ; AccelKey=(S.KeyMoveDown        or "");     Action=MoveDown     };
    {text=M.Type        ;                             separator=true                     };
    {text=M.SwitchType  ; AccelKey=(S.KeySwitchType      or "");     Action=SwitchType   };
    {text=M.Clip        ;                             separator=true                     };
    {text=M.ClipCopy    ; AccelKey="CtrlC"                                               };
    {text=M.ClipPaste   ; AccelKey="CtrlV"                                               };
    {text=M.ClipDel     ; AccelKey="CtrlD"                                               };
    {text=M.ClipCut     ; AccelKey="CtrlX"                                               };
    {text=M.ClipAdd     ; AccelKey="CtrlAdd"                                             };
    {text=M.ClipAddDel  ; AccelKey="CtrlAdd CtrlD"                                       };
    {text=M.ClipExchange; AccelKey=(S.KeyClipExchange    or "");     Action=ClipExchange };
  }
  local len = 0
  for _,v in ipairs(mi) do len = (v.separator~=true) and (len < v.text:len()) and   v.text:len() or len end
  len = len + 2
  for i,v in ipairs(mi) do
    v.text = (v.separator~=true) and   ((v.text .. (' '):rep(len)):sub(1,len) .. v.AccelKey) or v.text
    v.selected = (i==LastItem)
  end
  local it, pos = far.Menu({Title=M.mTitle}, mi)
  if it then
    LastItem=pos
    return it.Action and it.Action() or Keys(it.AccelKey)
  end
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
  ShiftLeft   =ShiftLeft   ;
  ShiftRight  =ShiftRight  ;
  ShiftUp     =ShiftUp     ;
  ShiftDown   =ShiftDown   ;
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
  action=function() return Select() end;
}
Macro {id="3411986f-6037-4a64-b100-1f21021c5123";
  area="Editor"; key=S.KeyDuplicate;    priority=S.PriorDuplicate   ; sortpriority=S.SortDuplicate   ; description=M.DescrDuplicate   ; flags="EVSelection";
  action=function() return Duplicate() end;
}
Macro {id="d8037967-a3c8-4098-bb7f-7045422cb80f";
  area="Editor"; key=S.KeyInBegin;      priority=S.PriorInBegin     ; sortpriority=S.SortInBegin     ; description=M.DescrInBegin     ; flags="EVSelection";
  action=function() return JumpInBegin() end;
}
Macro {id="722bcbd0-3b12-40bb-9044-d6240b1152fe";
  area="Editor"; key=S.KeyInEnd;        priority=S.PriorInEnd       ; sortpriority=S.SortInEnd       ; description=M.DescrInEnd       ; flags="EVSelection";
  action=function() return JumpInEnd() end;
}
Macro {id="8c4d5ab-6bca-4d87-b635-8c02834e6cdb";
  area="Editor"; key=S.KeySavePos;      priority=S.PriorSavePos     ; sortpriority=S.SortSavePos     ; description=M.DescrSavePos     ; flags="EVSelection";
  action=function() return SavePos() end;
}
Macro {id="a137c379-d5d2-41cb-9acc-08b8084576fc";
  area="Editor"; key=S.KeyRestorePos;   priority=S.PriorRestorePos  ; sortpriority=S.SortRestorePos  ; description=M.DescrRestorePos  ;
  action=function() return RestorePos() end;
}
Macro {id="b8655db5-b109-451f-b9dc-ec1f9b305a2a";
  area="Editor"; key=S.KeyMoveLeft;     priority=S.PriorMoveLeft    ; sortpriority=S.SortMoveLeft    ; description=M.DescrMoveLeft    ; flags="EVSelection";
  action=function() return MoveLeft() end;
}
Macro {id="a8ad3832-97ea-4427-9fea-5e8c6e0aefe9";
  area="Editor"; key=S.KeyMoveRight;    priority=S.PriorMoveRight   ; sortpriority=S.SortMoveRight   ; description=M.DescrMoveRight   ; flags="EVSelection";
  action=function() return MoveRight() end;
}
Macro {id="cd9f7beb-a340-45c3-8985-de4794a3be5a";
  area="Editor"; key=S.KeyMoveUp;       priority=S.PriorMoveUp      ; sortpriority=S.SortMoveUp      ; description=M.DescrMoveUp      ; flags="EVSelection";
  action=function() return MoveUp() end;
}
Macro {id="7e0193ec-a727-4576-9277-688825844af7";
  area="Editor"; key=S.KeyMoveDown;     priority=S.PriorMoveDown    ; sortpriority=S.SortMoveDown    ; description=M.DescrMoveDown    ; flags="EVSelection";
  action=function() return MoveDown() end;
}
Macro {id="50c27c33-a056-44fb-9ede-186f3d4388e8";
  area="Editor"; key=S.KeySwitchType;   priority=S.PriorSwitchType  ; sortpriority=S.SortSwitchType  ; description=M.DescrSwitchType  ; flags="EVSelection";
  action=function() return SwitchType() end;
}
Macro {id="499c2169-f904-4b74-8422-9adc614aa8e6";
  area="Editor"; key=S.KeyClipExchange; priority=S.PriorClipExchange; sortpriority=S.SortClipExchange; description=M.DescrClipExchange; flags="EVSelection";
  action=function() return ClipExchange() end;
}
Macro {id="7eea99fb-7bbb-412b-906e-1c6c335d0a6c";
  area="Editor"; key=S.KeyAutoBeg;      priority=S.PriorAutoBeg     ; sortpriority=S.SortAutoBeg     ; description=M.DescrAutoBeg     ; flags="EVSelection";
  condition=function() return JumpAutoBeg() end;
  action=function() return JumpInBegin() end;
}
Macro {id="e69db4dd-c2b7-4beb-88b1-b0f0faa2cb71";
  area="Editor"; key=S.KeyAutoEnd;      priority=S.PriorAutoEnd     ; sortpriority=S.SortAutoEnd     ; description=M.DescrAutoEnd     ; flags="EVSelection";
  condition=function() JumpAutoEnd() end;
  action   =function() return JumpInEnd() end;
}
Macro {id="51cd448d-a611-47fb-9acf-1d702a432c26";
  area="Editor"; key=S.KeyShiftLeft;     priority=S.PriorShiftLeft    ; sortpriority=S.SortShiftLeft    ; description=M.DescrShiftLeft    ; flags="EVSelection";
  action=function() return ShiftLeft() end;
}
Macro {id="208d3e8b-68c0-48cd-b953-718bbc74b82f";
  area="Editor"; key=S.KeyShiftRight;    priority=S.PriorShiftRight   ; sortpriority=S.SortShiftRight   ; description=M.DescrShiftRight   ; flags="EVSelection";
  action=function() return ShiftRight() end;
}
Macro {id="b24f8843-ccd8-49d3-8fc1-b6f618adb523";
  area="Editor"; key=S.KeyShiftUp;       priority=S.PriorShiftUp      ; sortpriority=S.SortShiftUp      ; description=M.DescrShiftUp      ; flags="EVSelection";
  action=function() return ShiftUp() end;
}
Macro {id="644fee61-0698-4899-8d5d-3310745e8f23";
  area="Editor"; key=S.KeyShiftDown;     priority=S.PriorShiftDown    ; sortpriority=S.SortShiftDown    ; description=M.DescrShiftDown    ; flags="EVSelection";
  action=function() return ShiftDown() end;
}
