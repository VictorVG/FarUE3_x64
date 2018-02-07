-- По F11 вызываем PluMenu, по ShiftF11 зовём стандартное меню плагинов Far.
-- VictorVG @ VikSoft.Ru, v1.1, Thu Sep 25 00:00:16 +0300 2014

local PMID="AB9578B3-3107-4E28-BB00-3C13D47382AC"
local PMMID="FABF7469-F4EC-4BDE-9D27-21AE224B3BF8"
Macro {
  description="Advanced plugin menu"; area="Common"; key="F11"; action=function()
  if not Plugin.Call(PMID,0) then Keys("F11") end
  end;
}

Macro {
  description="Standard plugin menu"; area="Common"; key="ShiftF11"; action=function()
   Keys("F11")
  end;
}
