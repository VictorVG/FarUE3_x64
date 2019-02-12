-- VictorVG @ VikSoft.Ru, 1996 - 2019
--
-- v1.0, Initial release
-- 19.02.2018  02:01:28 +0300
--
-- v1.1, Refactoring, add macro for delete branch
-- 26.02.2018 21:01:45 +0300
--
-- v1.2, Add new macros for GitShell command, refactoring.
-- 06.03.2018 06.03.2018 06:10:12 +0300
--
-- v1.3, BugFix, update copyright
-- 12.02.2019 03:56:59 +0300

local GSID  = "BE0B1498-4234-4BE1-B257-7653CAF4F091";
local GSMID = "0B7813BD-DEC1-4866-B20E-F5C49FF4AFA0";
local GSBID = "6204962D-3F32-4D81-A39C-79D0E9315328";

Macro {
  description="GitShell menu";
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

Macro{
  id="C83316CF-E1E9-429E-9552-C0F295158274";
  area="Shell";
  key="AltShiftN";
  description="GiShell branch tools";
  action=function()Far.DisableHistory(-1) Plugin.Command(GSID,'branch') end;
}

Macro{
  id="43EDB414-789E-4760-823E-19638DDA52D9";
  area="Shell";
  key="CtrlShiftC";
  description="GitShell commit tools";
  action=function() Far.DisableHistory(-1) Plugin.Command(GSID,'commit') end;
}

Macro{
  id="8F9AA142-3456-423C-8034-325AE7ED6050";
  area="Shell";
  key="AltShiftH";
  description="GitShell view history";
  action=function() Far.DisableHistory(-1) Plugin.Command(GSID,'log') end;
}

Macro{
  id="2F49ED7B-5719-45C5-B801-CDBCE32D3EF1";
  area="Shell";
  key="AltShiftL";
  description="GitShell current file history";
  action=function() Far.DisableHistory(-1) Plugin.Command(GSID,'log '..APanel.Current) end;
}
