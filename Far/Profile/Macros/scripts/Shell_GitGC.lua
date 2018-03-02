-- v1.0, Initial release
-- VictorVG @ Viksoft.Ru, 02.03.2018 21:53:58 +0300

Macro{
  id="13B9E07D-B81D-458F-800E-C5E7DFCA0637";
  area="Shell";
  key="AltShiftG";
  description="Cleanup unnecessary files and optimize the local repository";
  flags="EnableOutput NoSendKeysToPlugins";
  priority=50;
  action=function() Far.DisableHistory(-1) mf.print("git gc") Keys("Enter") end;
}
