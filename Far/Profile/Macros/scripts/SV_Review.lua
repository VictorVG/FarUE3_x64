-- Open current graphics or video file at active panel in to Review.
--
-- v1.0, Initial version
-- VictorVG, 14.08.2019 01:07:44 +0300
-- v1.1, Refactoring
-- VictorVG, 14.08.2019 06:41:47 +0300

local RVId="0364224C-A21A-42ED-95FD-34189BA4B204"
local MaskG,MaskV="/.+\\.(pcx|psd)/i","/.+\\.(3gp|avi|flv|m2t|mkv|mov|mp4|mp4v|mp4a|mpg|mpeg|mts|ts|wbem|wmv)/i"

Macro{
  id="12FA2EAA-E5B0-4F4B-8C02-E8B008490D47";
  area="Shell Viewer";
  key="F3 Enter NumEnter MsM1Click";
  description="Review: Open graphics files";
  condition=function() return (Plugin.Exist(RVId) and mf.fmatch(APanel.Current,MaskG)==1) end;
  action=function()
  Far.DisableHistory(-1) Plugin.Command(RVId,APanel.Current);
end;
}

Macro{
  id="3A7772FB-E33D-4239-A67F-4B4800787C16";
  area="Shell";
  key="F3 CtrlPgDn";
  description="Review: Open video files";
  priority=60;
  condition=function() return (Plugin.Exist(RVId) and mf.fmatch(APanel.Current,MaskV)==1) end;
  action=function()
  Far.DisableHistory(-1) Plugin.Command(RVId,APanel.Current);
end;
}