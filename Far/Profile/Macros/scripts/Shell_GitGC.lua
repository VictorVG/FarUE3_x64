-- v1.0, Initial release
-- VictorVG @ Viksoft.Ru, 02.03.2018 21:53:58 +0300
--
-- v1.1, Save and restore command prompt, customize git-gc(1) parameters, refactoring
-- VictorVG @ Viksoft.Ru, 06.03.2018 04:33:21 +0300

Macro{
  id="13B9E07D-B81D-458F-800E-C5E7DFCA0637";
  area="Shell";
  key="AltShiftG";
  description="Cleanup unnecessary files and optimize the local repository";
  flags="EnableOutput NoSendKeysToPlugins";
  action=function()
  local bcmd=mf.trim(CmdLine.Value);
   if not CmdLine.Empty then bcmd=mf.trim(CmdLine.Value) Keys("Esc") end;
     Far.DisableHistory(-1) mf.print("git gc"..mf.prompt("Parameters","",0x00000001,"","Prm")) Keys("Enter")
   mf.print(bcmd)
  end;
}
