-- Open current graphics or video file at active panel in to Review.
--
-- v1.0, Initial version
-- VictorVG, 14.08.2019 01:07:44 +0300
-- v1.1, Refactoring
-- VictorVG, 14.08.2019 06:41:47 +0300
-- v1.2, Add on/off flags (bulean): on=true , off=nil
-- VictorVG, 14.08.2019 16:43:23 +0300
-- v1.3, Refactoring
-- VictorVG, 17.08.2019 06:51:16 +0300
-- v1.4, used FuncLib module, refactoring
-- VictorVG, 24.08.2019 19:15:59 +0300
-- v1.5, remove unised code, small refactoring
-- VictorVG, 25.08.2019 11:49:23 +0300
-- v1.6, Add SVG support for Review v1.18 or newer!
-- VictorVG, 24.03.2021 23:58:52 +0300

local RVId="0364224C-A21A-42ED-95FD-34189BA4B204"
local MaskV="/.+\\.(3gp|avi|flv|m2t|mkv|mov|mp4|mp4v|mp4a|mpg|mpeg|mts|ts|wbem|wmv)/i"
local MaskG="/.+\\.(svg)$/i";

local FV=true

Macro{
  id="3A7772FB-E33D-4239-A67F-4B4800787C16";
  area="Shell";
  key="F3 CtrlPgDn";
  description="Review: Open video files";
  priority=60;
  condition=function() return (FV and Plugin.Exist(RVId) and mf.fmatch(APanel.Current,MaskV)==1) end;
  action=function()
  Far.DisableHistory(-1) Plugin.Command(RVId,APanel.Current);
end;
}

Macro{
  id="05C53C84-9CFF-43A2-80B5-3176F1C67171";
  area="Shell";
  key="F3 CtrlPgDn";
  priority=60;
  description="Review: view SVG";
  condition=function() return (FV and Plugin.Exist(RVId) and mf.fmatch(APanel.Current,MaskG)==1) end;
  action=function()Far.DisableHistory(-1)  Plugin.Command(RVId,APanel.Current) end;
}