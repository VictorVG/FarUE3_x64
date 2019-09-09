-------------------------------------------------------------------------------
-- Умные Home & End. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_SmartHomeEnd.cfg
return{
  KeyHome     ="Home";                 --PriorHome     =50; --SortHome     =50;
  KeyEnd      ="End";                  --PriorEnd      =50; --SortEnd      =50;
  KeyShiftHome="ShiftHome";            --PriorShiftHome=50; --SortShiftHome=50;
  KeyAltHome  ="AltHome AltShiftHome"; --PriorAltHome  =50; --SortAltHome  =50;
  KeyShiftEnd ="ShiftEnd";             --PriorShiftEnd =50; --SortShiftEnd =50;
  KeyAltEnd   ="AltEnd AltShiftEnd";   --PriorAltEnd   =50; --SortAltEnd   =50;
}
-- Конец файла Profile\SimSU\Editor_SmartHomeEnd.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_SmartHomeEndRussian.lng
return{
  DescrHome="В начало строки или на первую букву. © SimSU";
  DescrEnd="В конец строки или за последнюю букву. © SimSU";
  DescrShiftHome="В начало строки или на первую букву с выделением строчного блока. © SimSU";
  DescrAltHome="В начало строки или на первую букву с выделением вертикального блока. © SimSU";
  DescrShiftEnd="В конец строки или за последнюю букву с выделением строчного блока. © SimSU";
  DescrAltEnd="В конец строки или за последнюю букву с выделением вертикального блока. © SimSU";
}
-- Конец файла Profile\SimSU\Editor_SmartHomeEndRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_SmartHomeEndEnglish.lng
return{
  DescrHome="В начало строки или на первую букву.";
  DescrEnd="В конец строки или за последнюю букву.";
  DescrShiftHome="В начало строки или на первую букву с выделением строчного блока. © SimSU";
  DescrAltHome="В начало строки или на первую букву с выделением вертикального блока. © SimSU";
  DescrShiftEnd="В конец строки или за последнюю букву с выделением строчного блока. © SimSU";
  DescrAltEnd="В конец строки или за последнюю букву с выделением вертикального блока. © SimSU";
}
-- End of file Profile\SimSU\Editor_SmartHomeEndEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SmartHomeEnd"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_SmartHomeEnd.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SmartHomeEnd.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------

local function Home()
  Editor.Pos(1,5,1); if Editor.Set(2,-1)==0 and band(Editor.State,0x30)~=0 then Editor.Sel(4) end
  local First=(Editor.Value):find("%S")
  Editor.Pos(1,2,Editor.RealPos~=First and First or 1)
end

local function End()
  if Editor.Set(2,-1)==0 and band(Editor.State,0x30)~=0 then Editor.Sel(4) end
  local Last=(Editor.Value):find("%s+$")
  local Len=(Editor.Value):len()+1
  Editor.Pos(1,2,Editor.RealPos>Len and Len or Editor.RealPos~=Last and Last or Len)
end

local function Select(HomeOrEnd,BlockType)
  BlockType= BlockType or 1
  local Line=Editor.CurLine; local Pos=Editor.RealPos; local Pos2= BlockType==2 and Editor.CurPos or nil
  local Sel=editor.GetSelection()
  if HomeOrEnd then Home() else End() end
  local NewPos=Editor.RealPos; local NewPos2= BlockType==2 and Editor.CurPos or nil
  if Sel and BlockType==2 then Sel.StartPos2=editor.RealToTab(nil,Sel.StartLine,Sel.StartPos); Sel.EndPos2=editor.RealToTab(nil,Sel.EndLine,Sel.EndPos) end
  if not Sel or BlockType~=Sel.BlockType or -- Нет выделения или другой тип блока или
    not ((BlockType==1 and ((Line==Sel.StartLine and Pos==Sel.StartPos) or (Line==Sel.EndLine and Pos==Sel.EndPos+1  or (Sel.EndPos==-1 and Pos==1)))) or (BlockType==2 and (Line==Sel.StartLine or Line==Sel.EndLine) and (Pos==Sel.StartPos or Pos==Sel.EndPos+1))) -- не продолжение (курсос не в углах).
    --and not BlockType==2
  then -- Новое выделение.
    editor.Select(nil,BlockType,Line,NewPos>Pos and (Pos2 or Pos) or (NewPos2 or NewPos),NewPos>Pos and (NewPos2 and NewPos2-Pos2 or NewPos-Pos) or (NewPos2 and Pos2-NewPos2 or Pos-NewPos),1)
  elseif Line==Sel.StartLine and Sel.StartLine==Sel.EndLine and Pos==Sel.StartPos then -- Корректируем начало в однострочном блоке.
    editor.Select(nil,BlockType,Sel.StartLine,NewPos2 or NewPos,NewPos2 and Sel.EndPos2-NewPos2+1 or Sel.EndPos-NewPos+1,1)
  elseif (Line==Sel.StartLine and Pos==Sel.StartPos) then                              -- Корректируем начало в многострочном блоке.
    editor.Select(nil,BlockType,Sel.StartLine,NewPos2 or NewPos,NewPos2 and Sel.EndPos2-NewPos2+1 or Sel.EndPos-NewPos+1,Sel.EndLine-Sel.StartLine+1)
  elseif Line==Sel.EndLine and Sel.StartLine==Sel.EndLine then                         -- Корректируем конец в однострочном блоке.
    editor.Select(nil,BlockType,Sel.StartLine,Pos2 and Sel.StartPos2 or Sel.StartPos,NewPos2 and NewPos2-Sel.StartPos2 or NewPos-Sel.StartPos,1)
  elseif BlockType==2 and Line==Sel.EndLine and Pos~=Sel.EndPos+1 then                 -- Дополнительные приседания с вертикальным блоком, когда начало блока невозможно правильно опредлить (начало может попасть на середину табуляции...).
    editor.Select(nil,2,Sel.StartLine,NewPos2,Sel.EndPos2-NewPos2+1,Sel.EndLine-Sel.StartLine+1)
  else                                                                                 -- Корректируем конец в многострочном блоке.
    editor.Select(nil,BlockType,Sel.StartLine,Pos2 and Sel.StartPos2 or Sel.StartPos,NewPos2 and NewPos2-Sel.StartPos2 or NewPos-Sel.StartPos,Sel.EndLine-Sel.StartLine+1+(Sel.EndPos==-1 and Pos==1 and 1 or 0))
  end
end

-------------------------------------------------------------------------------
local Editor_SmartHomeEnd={
  Home   = Home  ;
  End    = End   ;
  Select = Select;
}
local function filename() return end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Editor_SmartHomeEnd=Editor_SmartHomeEnd} end
SimSU.Editor_SmartHomeEnd=Editor_SmartHomeEnd; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="aee06b9b-f428-4d8e-93b3-71176e6c6a79";
  area="Editor"; key=S.KeyHome;      priority=S.PriorHome;      sortpriority=S.SortHome;      description=M.DescrHome;
  action=Home;
}
Macro {id="4b9a2144-5468-44fe-9fef-ce690488eec3";
  area="Editor"; key=S.KeyEnd;       priority=S.PriorEnd;       sortpriority=S.SortEnd;       description=M.DescrEnd;
  action=End;
}
Macro {id="a2fd702e-cc45-4bdd-9104-895ef64938dc";
  area="Editor"; key=S.KeyShiftHome; priority=S.PriorShiftHome; sortpriority=S.SortShiftHome; description=M.DescrShiftHome;
  action=function() Select(true,1) end;
}
Macro {id="06bc096b-df42-469b-b144-0d49b4b5112b";
  area="Editor"; key=S.KeyAltHome;   priority=S.PriorAltHome;   sortpriority=S.SortAltHome;   description=M.DescrAltHome;
  action=function() Select(true,2) end;
}
Macro {id="edd0e9e0-633d-428b-a50a-4ba025a96c8b";
  area="Editor"; key=S.KeyShiftEnd;  priority=S.PriorShiftEnd;  sortpriority=S.SortShiftEnd;  description=M.DescrShiftEnd;
  action=function() Select(false,1) end;
}
Macro {id="c32cf6fa-cefe-4c0e-92b9-e7a0a16875a5";
  area="Editor"; key=S.KeyAltEnd;    priority=S.PriorAltEnd;    sortpriority=S.SortAltEnd;    description=M.DescrAltEnd;
  action=function() Select(false,2) end;
}
