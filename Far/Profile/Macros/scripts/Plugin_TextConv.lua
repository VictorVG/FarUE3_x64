--[[ ВНИМАНИЕ! Правые и левые модификаторы не проверяются для упрощения скрипта
     и улучшения его совместимости с ноутбучными клавиатурами, но вы можете сами
     это сделать назначив макрос к примеру на "Ctrl-" чтобы для его вызова хватало
     пальцев одной руки что собственно и было задумано - минимум неудобства, максимум
     простоты вызова. /VictorVG @ VikSoft.Ru/
--]]

local TCVID="DD10A9C6-ECAC-4BFA-BB07-4A1E92744162"
local TCVMID="DD10A9C6-ECAC-4BFA-BB07-4A1E92744162"

Macro {
  description="Text file converter"; area="Shell Editor"; key="Ctrl-"; action=function()
   Plugin.Menu(TCVID,TCVMID)
  end;
}