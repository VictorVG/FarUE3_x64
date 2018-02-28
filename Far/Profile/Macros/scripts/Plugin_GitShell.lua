-- VictorVG @ VikSoft.Ru, 1996 - 2018
--
-- v1.0, Initial release
-- 19.02.2018  02:01:28 +0300
--
-- v1.1, Refactoring, add macro for delete branch
-- 26.02.2018 21:01:45 +0300

local GSID="BE0B1498-4234-4BE1-B257-7653CAF4F091"
local GSMID="0B7813BD-DEC1-4866-B20E-F5C49FF4AFA0"
local GSBID="6204962D-3F32-4D81-A39C-79D0E9315328"

Macro {
  description="GitShell";
  area="Shell";
  key="CtrlAltG";
  action=function()
   Plugin.Menu(GSID,GSMID)
  end;
}

Macro {
  description="Delete branch";
  area="Dialog";
  key="Del";
  condition=function() return Dlg.Id==GSBID end;
  action=function()
   Keys("F8")
  end;
}
