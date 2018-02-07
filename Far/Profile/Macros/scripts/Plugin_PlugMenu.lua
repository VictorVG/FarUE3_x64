-- По F11 вызываем PlugMenu, по ShiftF11 зовём стандартное меню плагинов Far.
-- VictorVG @ VikSoft.Ru, v1.1, Thu Sep 25 00:00:16 +0300 2014

local PMID="AB9578B3-3107-4E28-BB00-3C13D47382AC"
local PMMID="FABF7469-F4EC-4BDE-9D27-21AE224B3BF8"
Macro{
  id="DE27E6AC-292B-4447-B0F4-FC78FFE5D4F9";
  area="Common";
  key="F11";
  description="Advanced plugin menu";
  action=function()
  if not Plugin.Call(PMID,0) then Keys("F11") end
  end;
}


Macro {
  id="A50FF3AA-5761-44B2-8149-6497239EF075";
  description="Standard plugin menu";
  area="Common";
  key="ShiftF11";
  action=function()
   Keys("F11")
  end;
}
