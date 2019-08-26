-- v1.1 21.11.2018 17:55:41 +0300 Refactoring

local Mask="/.+\\.(rar|r[00-99])/i";

Macro{
  id="88AC9500-D03A-4697-BAB1-4BFF7C49C1D3";
  area="Shell";
  key="Enter NumEnter CtrlPgDn";
  description="Open Rar use MultiArc";
  flags="NoSendKeysToPlugins NoFolders";
  priority=60;
  condition=function() return mf.fmatch(APanel.Current,Mask)==1 end;
  action=function() Far.DisableHistory(-1); Keys("ma:APanel.Current Enter")end;
}