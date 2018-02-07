-------------------------------------------------------------------------------
--        Набор макросов для математических вычислений. © SimSU
-------------------------------------------------------------------------------
-- Умеет:
--   выводить окно запроса выражения и вычислять его;
--   вычислять содержимое буфера обмена;
--   вычислять выделенный текст;
--   если то что требуется вычислить не математическое выражение, то суммирует. (1 2 3 = 6).

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Common_Calculator.cfg
return{
  SelectResult=true; -- Выделять результат при вычислении выделенного текста?
  -- Клавиши выполнения:
  CalcKey="AltNumLock"; --CalcPrior=50; -- Окно с запросом выражения.
  ClipKey="CtrlNumLock"; --ClipPrior=50; -- Вычисляет математическое выражение находящееся в буфере обмена, результат помещает в буфер обмена.
  SelKey ="ShiftNumLock"; --SelPrior=50; -- Вычисляет выделенное математическое выражение, результат вставляется обратно.
}
-- Конец файла Profile\SimSU\Common_Calculator.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\SimSU\Common_CalculatorRussian.lng
return{
CalcDescr="Калькулятор. © SimSU";
Title="Калькулятор";
Prompt="Введите математическое выражение и нажмите Enter";
ClipDescr="Калькулятор буфера обмена. © SimSU";
SelDescr="Калькулятор выделенного текста. © SimSU";
}
-- Конец файла Profile\SimSU\Common_CalculatorRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Common_CalculatorEnglish.lng
return{
CalcDescr="Calculator © SimSU";
Title="Calculator";
Prompt="Enter a mathematical expression and press Enter";
ClipDescr="Clipbord Calculator. © SimSU";
SelDescr="Select text Calculator. © SimSU";
}
-- End of file Profile\SimSU\Common_CalculatorEnglish.lng
end end

-------------------------------------------------------------------------------
local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Common_Calculator"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Common_Calculator.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Common_Calculator.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Common_Calculator={}
-------------------------------------------------------------------------------
function SimSU.Common_Calculator.Calc(Expression) -- Функция вычисления математического выражения. © SimSU
  local func=-- Переименование математических функций
    [[-- Calculator © SimSU
    local abs        = math.abs
    local acos       = math.acos
    local asin       = math.asin
    local atan       = math.atan
    local atan2      = math.atan2
    local ceil       = math.ceil
    local cos        = math.cos
    local cosh       = math.cosh
    local deg        = math.deg
    local exp        = math.exp
    local floor      = math.floor
    local fmod       = math.fmod
    local frexp      = math.frexp
    local huge       = math.huge
    local ldexp      = math.ldexp
    local log        = math.log
    local log10      = math.log10
    local max        = math.max
    local min        = math.min
    local modf       = math.modf
    local pi         = math.pi
    local pow        = math.pow
    local rad        = math.rad
    local random     = math.random
    local randomseed = math.randomseed
    local sin        = math.sin
    local sinh       = math.sinh
    local sqrt       = math.sqrt
    local tan        = math.tan
    local tanh       = math.tanh
    ]]
  --
  local function Calc(Expression) -- Обёртка для обработки ошибок интерпретатора.
    return loadstring(func.."local Result="..Expression.." return Result")()
  end
  --
  local state, err = pcall(Calc,Expression)
  if not state then state, err = pcall(Calc,mf.trim(Expression):gsub("[%c%s]+","%+")) end -- Попробуем просто просуммировать.
  return err
end

function SimSU.Common_Calculator.RestoreNumLock(Key) -- Если сочетание клавиш меняет состояние NumLock, то вернём обратно.
  if Key=="AltNumLock" or Key=="ShiftNumLock" or Key=="CtrlShiftNumLock" or Key=="CtrlAltNumLock" or Key=="RCtrlShiftNumLock" or Key=="RCtrlAltNumLock" or Key=="CtrlRAltNumLock" or Key=="RCtrlRAltNumLock" then
    local o=mf.flock(0,-1); local n=o
    while n==o do n=mf.flock(0,2) end
  end
end

function SimSU.Common_Calculator.Prompt() -- Окно с запросом выражения.
  SimSU.Common_Calculator.RestoreNumLock(akey(1))
  local Expression=true
  local Result=0
  while Expression do
    Expression=prompt(M.Title, M.Prompt,0x10,tostring(Result),"SimSU_Calc")
    if Expression then Result=SimSU.Common_Calculator.Calc(Expression) end
  end
end

function SimSU.Common_Calculator.ClipCalc() -- Вычисляет математическое выражение находящееся в буфере обмена, результат помещает в буфер обмена.
  SimSU.Common_Calculator.RestoreNumLock(akey(1))
  mf.clip(1,tostring(SimSU.Common_Calculator.Calc(mf.clip(0))))
end

function SimSU.Common_Calculator.SelCalc() -- Вычисляет выделенное математическое выражение, результат вставляется обратно.
  SimSU.Common_Calculator.RestoreNumLock(akey(1))
  if Object.Selected then
    local BlockType, Expression
    if Area.Editor then
      Expression=Editor.SelValue
      BlockType=Editor.Sel(0,4)
    elseif Area.Dialog then
      local Id=far.AdvControl("ACTL_GETWINDOWINFO").Id
      local Index=far.SendDlgMessage(Id,"DM_GETFOCUS")
      local Sel=far.SendDlgMessage(Id,"DM_GETSELECTION",Index)
      Expression=far.SendDlgMessage(Id,"DM_GETTEXT",Index):sub(Sel.BlockStartPos, Sel.BlockStartPos+Sel.BlockWidth)
    elseif Area.Shell then
      local SelStart, SelEnd = panel.GetCmdLineSelection()
      Expression=panel.GetCmdLine():sub(SelStart, SelEnd)
    end
    local Result=tostring(SimSU.Common_Calculator.Calc(Expression))
    print(Result)
    if S.SelectResult then -- !!TODO:: надо бы, всё таки разобраться как через апи выделять в строках ввода!
      local l=Result:len()
      for i=1,l do Keys("Left") end
      for i=1,l do Keys("ShiftRight") end
    end
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Common_Calculator=SimSU.Common_Calculator; Calc=SimSU.Calc} end

local ok, mod = pcall(require,"SimSU.Common_Calculator"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Common"; key=S.CalcKey; priority=S.CalcPrior; description=M.CalcDescr;
  action=SimSU.Common_Calculator.Prompt;
}
Macro {area="Common"; key=S.ClipKey; priority=S.ClipPrior; description=M.ClipDescr;
  action=SimSU.Common_Calculator.ClipCalc;
}
Macro {area="Common"; key=S.SelKey; priority=S.SelPrior; description=M.SelDescr;
  action=SimSU.Common_Calculator.SelCalc;
}
