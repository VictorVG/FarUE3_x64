local Mask="/.+\\.(rar|r[00-99])/i";

Macro{
  id="88AC9500-D03A-4697-BAB1-4BFF7C49C1D3";
  area="Common";
  key="Enter NumEnter CtrlPgDn";
  description="Open Rar use MultiArc";
  flags="NoSendKeysToPlugins NoFolders";
  priority=60;
  condition=function() if Panel.Item(0,0,0)==Mask then return true else return nil end; end;
  action=function() Keys("ma:APanel.Current Enter")end;
}
