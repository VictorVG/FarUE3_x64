-- v1.0.0, Initial release
-- VictorVG @ VikSoft.Ru, 26.12.2020 05:32:35 +0300

Macro{
 id="942B3B5B-2994-4698-9D3F-03CE80686454";
 area="Shell";
 key="Enter NumEnter MsM1Click";
 description="AudiPlayer";
 priority=60;
 condition=function() return (mf.fmatch(APanel.Current,"/.+\\.(web(a|m))/i")==1) end;
 action=function() Plugin.Call("9C3A61FC-F349-48E8-9B78-DAEBD821694B",APanel.Current) end;
}
