--[[ ВНИМАНИЕ! Макрос назначен на "AltShiftF" /"CtrlShiftF" чтобы для его
     вызова хватало пальцев одной руки что собственно и было задумано - минимум
     неудобства, максимум простоты вызова. /VictorVG @ VikSoft.Ru/
--]]

local LFBID="23C16506-38EE-48D1-9874-CD1736408867"
local LFBMID="8C31052C-ADBE-4254-9B4B-DFDCAA9A42CE"

-- вызовем меню плагина - тут мы можем выбрать нужные действия
Macro{
    description="LUA Format Block for Editor by Ladserg (menu)"; area="Editor"; key="AltShiftF"; action=function()
      Plugin.Menu(LFBID,LFBMID)
    end;
}

-- повторим последнюю операцию или если это первый вызов то выполним ту, что задана в настройках
Macro{
    description="LUA Format Block for Editor by Ladserg (redo)"; area="Editor"; key="CtrlShiftF"; action=function()
      Plugin.Call(LFBID,1)
    end;
}
