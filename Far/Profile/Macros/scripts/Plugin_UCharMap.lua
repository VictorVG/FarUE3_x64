--[[ ВНИМАНИЕ! Правые и левые модификаторы не проверяются для упрощения скрипта
     и улучшения его совместимости с ноутбучными клавиатурами, но вы можете сами
     это сделать назначив макрос к примеру на "CtrlAltH" чтобы для его вызова хватало
     пальцев одной руки что собственно и было задумано - минимум неудобства, максимум
     простоты вызова. /VictorVG @ VikSoft.Ru/
--]]

local UCHID="59223378-9DCD-45FC-97C9-AD0251A3C53F"
local UCHMID="5D95C31A-A452-4EA4-ACC6-8C371F4F1E8F"

Macro {
  description="Unicode CharMap"; area="Shell Editor"; key="CtrlAltH"; action=function()
   Plugin.Menu(UCHID,UCHMID)
  end;
}
