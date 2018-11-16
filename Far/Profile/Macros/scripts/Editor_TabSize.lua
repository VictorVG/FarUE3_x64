-------------------------------------------------------------------------------
-- Лёгкое изменение размеров табуляции. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_TabSize.cfg
return{
  KeyInc="AltAdd";      --PriorInc=50; --SortInc=50;
  KeyDec="AltSubtract"; --PriorDec=50; --SortDec=50;
  KeyExp="AltMultiply"; --PriorExp=50; --SortExp=50;
}
-- Конец файла Profile\SimSU\Editor_TabSize.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_TabSizeRussian.lng
return{
  DescrInc="Увеличить размер табуляции. © SimSU";
  DescrDec="Уменьшить размер табуляции. © SimSU";
  DescrExp="Превратить табы в пробелы. © SimSU";
}
-- Конец файла Profile\SimSU\Editor_TabSizeRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_TabSizeEnglish.lng
return{
  DescrInc="Increase Tab size. © SimSU";
  DescrDec="Decrease Tab size. © SimSU";
  DescrExp="Expand Tab to Space. © SimSU";
}
-- End of file Profile\SimSU\Editor_TabSizeEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_TabSize"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_TabSize.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_TabSize.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local F=far.Flags

local function Set(Size)
  local OldSize = editor.GetInfo().TabSize
  local _= Size and editor.SetParam(nil,F.ESPT_TABSIZE,Size)
  return OldSize
end

local function Expand()
  editor.ExpandTabs(nil,editor.GetInfo().CurLine)
end

local function Increase()
  return Set(Set()+1)
end

local function Decrease()
  return Set(Set()-1)
end

-------------------------------------------------------------------------------
local Editor_TabSize={
  Set      = Set     ;
  Increase = Increase;
  Decrease = Decrease;
  Expand   = Expand  ;
}
local function filename(args)
  if args[1]=="+" then return Increase() end
  if args[1]=="-" then return Decrease() end
end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Editor_TabSize=Editor_TabSize} end
SimSU.Editor_TabSize=Editor_TabSize; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="5b1bdd12-57c3-492b-a3c6-c4ed0eaf9ba7";
  area="Editor"; key=S.KeyInc; priority=S.PriorInc; sortpriority=S.SortInc; description=M.DescrInc;
  action=Increase;
}
Macro {id="9497500d-0157-4c57-9912-068ceb7d913c";
  area="Editor"; key=S.KeyDec; priority=S.PriorDec; sortpriority=S.SortDec; description=M.DescrDec;
  action=Decrease;
}
Macro {id="9dc17b62-736c-4665-99f2-353871551467";
  area="Editor"; key=S.KeyExp; priority=S.PriorExp; sortpriority=S.SortExp; description=M.DescrExp;
  action=Expand;
}
