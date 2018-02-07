--[[ ВНИМАНИЕ! Правые и левые модификаторы не проверяются для упрощения скрипта
     и улучшения его совместимости с ноутбучными клавиатурами, но вы можете сами
     это сделать назначив макрос к примеру на "LAltLCtrlV" чтобы для его вызова хватало
     пальцев одной руки что собственно и было задумано - минимум неудобства, максимум
     простоты вызова. /VictorVG @ VikSoft.Ru/
--]]

local FVID="F9AF80C3-54AC-4924-B607-FE05A3866A88"
local FVMID="736D23A8-E1F1-41E1-ACD8-AB6B49EE4CD5"

Macro {
  description="File Version"; area="Shell View"; key="LAltLCtrlV"; action=function()
   Plugin.Menu(FVID,FVMID)
  end;
}
