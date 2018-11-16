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
  -- Клавиши выполнения:
  KeyCalc="AltNumLock";   --PriorCalc=50; --SortCalc=50; -- Окно с запросом выражения.
  KeyClip="CtrlNumLock";  --PriorClip=50; --SortClip=50; -- Вычисляет математическое выражение находящееся в буфере обмена, результат помещает в буфер обмена.
  KeySel ="ShiftNumLock"; --PriorSel =50; --SortSel =50; -- Вычисляет выделенное математическое выражение, результат вставляется обратно.

  SelectResult=true; -- Выделять результат при вычислении выделенного текста?
  -- Сокращения и Переименование математических функций
  Aliases=[[
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
    local id         = win.Uuid(win.Uuid())
  ]]
}
-- Конец файла Profile\SimSU\Common_Calculator.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\SimSU\Common_CalculatorRussian.lng
return{
CalcDescr="Калькулятор. © SimSU";
ClipDescr="Калькулятор буфера обмена. © SimSU";
SelDescr ="Калькулятор выделенного текста. © SimSU";
Title    ="Калькулятор";
Prompt   ="Введите математическое выражение и нажмите Enter";
}
-- Конец файла Profile\SimSU\Common_CalculatorRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Common_CalculatorEnglish.lng
return{
CalcDescr="Calculator © SimSU";
ClipDescr="Clipbord Calculator. © SimSU";
SelDescr ="Select text Calculator. © SimSU";
Title    ="Calculator";
Prompt   ="Enter a mathematical expression and press Enter";
}
-- End of file Profile\SimSU\Common_CalculatorEnglish.lng
end end

-------------------------------------------------------------------------------
local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Common_Calculator"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Common_Calculator.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Common_Calculator.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local F,msg = far.Flags,far.SendDlgMessage
S.SelectResult = S.SelectResult==nil and Settings().SelectResult or S.SelectResult
S.Aliases      = S.Aliases     ==nil and Settings().Aliases      or S.Aliases

local _

local function Calc(Expression) -- Функция вычисления математического выражения. © SimSU
  local function CALC(Expr) -- Обёртка для обработки ошибок интерпретатора.
    return loadstring(S.Aliases.."local Result="..Expr.." return Result")()
  end
  --
  local state, err = pcall(CALC,Expression)
  if not state then _, err = pcall(CALC,mf.trim(Expression):gsub("[%c%s]+","%+")) end -- Попробуем просто просуммировать.
  return err
end

local function RestoreNumLock(Key) -- Если сочетание клавиш меняет состояние NumLock, то вернём обратно.
  if Key=="AltNumLock" or Key=="ShiftNumLock" or Key=="CtrlShiftNumLock" or Key=="CtrlAltNumLock" or Key=="RCtrlShiftNumLock" or Key=="RCtrlAltNumLock" or Key=="CtrlRAltNumLock" or Key=="RCtrlRAltNumLock" then
    local o=mf.flock(0,-1); local n=o
    while n==o do n=mf.flock(0,2) end
  end
end

local function Prompt() -- Окно с запросом выражения.
  SimSU.Common_Calculator.RestoreNumLock(akey(1))
  local Expression=true
  local Result=0
  while Expression do
    Expression=prompt(M.Title, M.Prompt,0x10,tostring(Result),"SimSU_Calc")
    if Expression then Result=SimSU.Common_Calculator.Calc(Expression) end
  end
end

local function ClipCalc() -- Вычисляет математическое выражение находящееся в буфере обмена, результат помещает в буфер обмена.
  SimSU.Common_Calculator.RestoreNumLock(akey(1))
  mf.clip(1,tostring(SimSU.Common_Calculator.Calc(mf.clip(0))))
end

local function SelCalc() -- Вычисляет выделенное математическое выражение, результат вставляется обратно.
  SimSU.Common_Calculator.RestoreNumLock(akey(1))
  if Object.Selected then
    if Area.Editor then
      local Result=tostring(SimSU.Common_Calculator.Calc(Editor.SelValue))
      local EdSel=editor.GetSelection()
      if editor.DeleteBlock() then
        local str=editor.GetString().StringText
        local start=EdSel.BlockType==2 and (editor.RealToTab(nil,EdSel.StartLine,EdSel.StartPos)) or (EdSel.StartPos)
        editor.SetString(nil, EdSel.StartLine, str:sub(1,start-1)..Result..str:sub(start))
        if S.SelectResult then
          EdSel.BlockStartLine= EdSel.StartLine
          EdSel.BlockStartPos = start
          EdSel.BlockWidth    = Result:len()
          EdSel.BlockHeight   = 1
          editor.Select(nil,EdSel)
        end
      end
    elseif Area.Dialog then
      local Id=far.AdvControl(F.ACTL_GETWINDOWINFO).Id
      local Index=msg(Id,F.DM_GETFOCUS)
      local Sel=msg(Id,F.DM_GETSELECTION,Index)
      local str=msg(Id,F.DM_GETTEXT,Index)
      local Result=tostring(SimSU.Common_Calculator.Calc(str:sub(Sel.BlockStartPos, Sel.BlockStartPos+Sel.BlockWidth)))
      msg(Id,F.DM_SETTEXT,Index,str:sub(1,Sel.BlockStartPos-1)..Result..str:sub(Sel.BlockStartPos+Sel.BlockWidth+1))
      Sel.BlockWidth=Result:len()
      msg(Id,F.DM_SETCURSORPOS,Index,{X=Sel.BlockStartPos-1})
      msg(Id,F.DM_SETSELECTION,Index,Sel)
    elseif Area.Shell then
      local SelStart, SelEnd = panel.GetCmdLineSelection()
      local str=panel.GetCmdLine()
      local Result=tostring(SimSU.Common_Calculator.Calc(str:sub(SelStart, SelEnd)))
      panel.SetCmdLine(nil,str:sub(1,SelStart-1)..Result..str:sub(SelEnd+1))
      panel.SetCmdLinePos(nil,SelStart)
      panel.SetCmdLineSelection(nil,SelStart,SelStart+Result:len()-1)
    end
  end
end
-------------------------------------------------------------------------------
local Common_Calculator={
  Calc           = Calc          ;
  RestoreNumLock = RestoreNumLock;
  Prompt         = Prompt        ;
  ClipCalc       = ClipCalc      ;
  SelCalc        = SelCalc       ;
}
local function filename() Prompt() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Common_Calculator=Common_Calculator} end
SimSU.Common_Calculator=Common_Calculator; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="c14ec47b-10b4-4e20-9a24-c1276d62513e";
  area="Common"; key=S.KeyCalc; priority=S.PriorCalc; sortpriority=S.SortCalc; description=M.CalcDescr;
  action=Prompt;
}
Macro {id="13ae2551-c8ed-49cb-8f23-587485a5f7af";
  area="Common"; key=S.KeyClip; priority=S.PriorClip; sortpriority=S.SortClip; description=M.ClipDescr;
  action=ClipCalc;
}
Macro {id="f0e8628e-c2b9-4f2a-b4f8-1f7ef76ab7d6";
  area="Common"; key=S.KeySel;  priority=S.PriorSel;  sortpriority=S.SortSel;  description=M.SelDescr;
  action=SelCalc;
}
