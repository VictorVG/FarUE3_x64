-- Ver 3.1. VictorVG, обновлён Tue Dec 15 16:07:31 +0300 2015
-- Ver 3.1.1, rename uid to id, VictorVG, Thu Aug 04 15:01:14 +0300 2016

Macro{
  id="719EF12F-05C7-4162-9C63-EAC21E72FD04";
  area="Common Shell";
  description="Switch panel visible after Far start";
  flags="RunAfterFARStart NoSendKeysToPlugins";
  condition=function() return (not PPanel.Visible) end;
  action=function() Keys("CtrlP") end;
}

Macro{
  id="AA429C65-09D6-4328-9F30-56394F204A12";
  area="Common Shell";
  description="Switch all panel visible after Far start";
  flags="RunAfterFARStart NoSendKeysToPlugins";
  condition=function() return (not (PPanel.Visible and APanel.Visible)) end;
  action=function() Keys("CtrlO") end;
}

Macro{
  id="B4475F5D-0A3A-47AF-8835-7C9EA4F06DDD";
  area="Common Shell";
  description="Restore all panel visible after Far start";
  flags="RunAfterFARStart NoSendKeysToPlugins";
  condition=function() return (PPanel.Visible and not APanel.Visible) end;
  action=function() Keys("CtrlO CtrlP") end;
}