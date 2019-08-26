--[[ ВНИМАНИЕ! Макрос назначен на LCtrlLShiftB чтобы для его вызова хватало
     пальцев одной руки что собственно и было задумано - минимум неудобства,
     максимум  простоты вызова. /VictorVG @ VikSoft.Ru/
--]]

local FCID = "0785F214-65B9-47B6-B9D8-F24FADC60AA0"
local FMID = "5BC883B2-3FED-4960-8DAD-58E748176967"
Macro {
  description="File List"; area="Shell"; key="LCtrlShiftB"; action=function()
   Plugin.Menu(FCID,FMID)
  end;
}