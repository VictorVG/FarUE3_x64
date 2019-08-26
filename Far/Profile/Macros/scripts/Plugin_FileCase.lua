--[[ ВНИМАНИЕ! ПМакрос назначен на LAltR чтобы для его вызова хватало
     пальцев одной руки что собственно и было задумано - минимум неудобства,
     максимум  простоты вызова. /VictorVG @ VikSoft.Ru/
--]]

local FCID = "ADAC3050-56E8-45FE-9CB1-A737623CC4A6"
local FMID = "46F02D4D-6D83-42D8-B828-3C02EDF6E35C"
Macro {
  description="File Case"; area="Shell"; key="LAltR"; action=function()
   Plugin.Menu(FCID,FMID)
  end;
}