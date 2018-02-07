-- ВНИМАНИЕ! Переформатирование параграфа согласно текущим настройкам
-- редактора. Для работы нужен плагин [ESC] v2.9+.
-- Своих настроек плагин не имеет, макрос назначен на CtrlShiftR.
-- /VictorVG @ VikSoft.Ru/

local RWID = "F6E77027-05BA-4ECF-A8D3-7D57B2D80C53"
local RWMID = "34040B7C-FE0D-401B-8862-E328BD85D857"

Macro {
  description="Reformat paragraph based on ESC plugin settings"; area="Editor"; key="CtrlShiftR"; action=function()
   Plugin.Menu(RWID,RWMID)
  end;
}