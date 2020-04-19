-- FarColorer: Refresh coloring
-- v1.0 Init version
-- VictorVG @ Vicsoft.Ru, 24.01.2019 04:29:36 +0300
-- v1.2 Refactoring, support FarColorer v1.3.4.
-- VictorVG @ Vicsoft.Ru, 17.04.2020 22:40:28 +0300

local CID = "D2F36B62-A470-418D-83A3-ED7A3710E5B5"
local CMID = "45453CAC-499D-4B37-82B8-0A77F7BD087C"
require ("FuncLib")
Macro{
  id="43C9B0AA-70A1-4492-9A4D-1BC7BCBF6286";
  area="Editor";
  key="CtrlF5";
  description="FarColorer: Refresh coloring";
  priority=60;
  condition = function()
    return Plugin.Exist(CID);
  end;
  action=function()
  if vCmp("1.3.4.0",PlugVer(CID,1,1),2) then
   Plugin.Call(CID,"Editor","Refresh")
  else
   Plugin.Menu(CID,CMID) Keys("9")
  end;
 end;
 }
