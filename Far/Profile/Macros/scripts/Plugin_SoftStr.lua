--[[
     ВНИМАНИЕ! Правые и левые модификаторы не проверяются для упрощения скрипта
     и улучшения его совместимости с ноутбучными клавиатурами, но вы можете
     сами это сделать назначив макрос к примеру на "CtrlT" чтобы для его вызова
     хватало пальцев одной руки что собственно и было задумано - минимум
     неудобства, максимум простоты вызова. /VictorVG @ VikSoft.Ru/
--]]

local SSID="5FE4D394-2FE5-453F-8DB9-D63C32E01D13"
local SSMID="8F24402E-6080-4497-84D2-EA60FB360815"

Macro {
  description="SortString menu"; area="Editor"; key="CtrlT"; action=function()
   Plugin.Menu(SSID,SSMID)
  end;
}

Macro {
  description="Thin out duplicates"; area="Editor"; key="AltShiftT"; action=function()
   Plugin.Call(SSID,"operation:2")
  end;
}