-- Colorer: call type list for selections needed.
-- modified for v1.2.1.8 Fri Jan 23 14:53:19 +0300 2015
-- VictorVG @ VikSoft.Ru Mon Oct 06 02:46:16 +0300 2014
-- v1.2, refactoring
-- VictorVG @ VikSoft.Ru, Sun Mar 20 20:29:27 +0300 2016
-- v1.3, Support v1.3.4
-- VictorVG @ VikSoft.Ru, 04/18/2020 02:46:04 AM +0300
--
-- Written to quickly enable the desired coloring of the code,
-- uses the free key F5 in the editor for now.

local CID = "D2F36B62-A470-418D-83A3-ED7A3710E5B5"
require ("FuncLib")

Macro{
  id="6A32FBB4-E47C-4318-98F0-C3501DC922AF";
  area="Editor";
  key="F5";
  description="Colorer: list types select";
  priority=60;
  condition=function() return Plugin.Exist(CID) end;
  action=function()
   if vCmp("1.3.4.0",PlugVer(CID,1,1),2) then
    Plugin.Call(CID,"Types","Menu")
   else
    Plugin.Call(CID,1)
   end
 end;
}