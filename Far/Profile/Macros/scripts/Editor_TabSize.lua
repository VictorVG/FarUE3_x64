-------------------------------------------------------------------------------
-- Лёкое изменение размеров табуляции. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_TabSize.cfg
return{
  KeyInc="AltAdd"; --PriorInc=50;
  KeyDec="AltSubtract"; --PriorDec=50;
}
-- Конец файла Profile\SimSU\Editor_TabSize.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_TabSizeRussian.lng
return{
  DescrInc="Увеличить размер табуляции. © SimSU";
  DescrDec="Уменьшить размер табуляции. © SimSU";
}
-- Конец файла Profile\SimSU\Editor_TabSizeRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_TabSizeEnglish.lng
return{
  DescrInc="Увеличить размер табуляции. © SimSU";
  DescrDec="Уменьшить размер табуляции. © SimSU";
}
-- End of file Profile\SimSU\Editor_TabSizeEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_TabSize"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_TabSize.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_TabSize.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Editor_TabSize={}
-------------------------------------------------------------------------------
function SimSU.Editor_TabSize.Set(Size)
  Size=Size and editor.SetParam(nil,far.Flags.ESPT_TABSIZE,Size) or editor.GetInfo().TabSize
  return Size
end

function SimSU.Editor_TabSize.Increase()
  SimSU.Editor_TabSize.Set(SimSU.Editor_TabSize.Set()+1)
end

function SimSU.Editor_TabSize.Decrease()
  SimSU.Editor_TabSize.Set(SimSU.Editor_TabSize.Set()-1)
end
-------------------------------------------------------------------------------
if not Macro then return {Editor_TabSize=SimSU.Editor_TabSize} end

local ok, mod = pcall(require,"SimSU.Editor_TabSize"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Editor"; key=S.KeyInc; priority=S.PriorInc; description=M.DescrInc;
  action=SimSU.Editor_TabSize.Increase;
}
Macro {area="Editor"; key=S.KeyDec; priority=S.PriorDec; description=M.DescrDec;
  action=SimSU.Editor_TabSize.Decrease;
}
