-- Colorer: call type list for selections needed.
-- VictorVG @ VikSoft.Ru Mon Oct 06 02:46:16 +0300 2014
-- модифицирован под v1.2.1.8 Fri Jan 23 14:53:19 +0300 2015
-- v1.2 Sun Mar 20 20:29:27 +0300 2016
-- рефакторинг
-- Написан для быстрого включения нужной раскраски кода,
-- использует пока свободную клавишу F5 в редакторе.

local ColorerGUID = "D2F36B62-A470-418D-83A3-ED7A3710E5B5";

Macro{
  id="6A32FBB4-E47C-4318-98F0-C3501DC922AF";
  area="Editor";
  description="Colorer: list types select";
  key="F5";
  priority=60;
  sortpriority=60;
  condition = function()
    return Plugin.Exist(ColorerGUID);
  end;
  action= function()
    Plugin.Call(ColorerGUID,1);
  end;
}