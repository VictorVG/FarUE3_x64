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

local function PlugVer(plg)
local Info,PVer,A,P
  P=far.FindPlugin("PFM_GUID",win.Uuid(plg))
       Info=far.GetPluginInformation(P);
           A=Info.GInfo.Version;
           PVer=A[1].."."..A[2].."."..A[3]
  return PVer
end

local IVId,RVId="9D4A59D9-AD2D-478C-8F66-7D233CBB788D","0364224C-A21A-42ED-95FD-34189BA4B204"
local MaskG,MaskV="/.+\\.(pcx|psd)/i","/.+\\.(3gp|avi|flv|m2t|mkv|mov|mp4|mp4v|mp4a|mpg|mpeg|mts|ts|wbem|wmv)/i"
local FV=true
local sem="3467"
local ver=mf.replace(PlugVer(IVId),".","",0,0)

Macro{
  id="12FA2EAA-E5B0-4F4B-8C02-E8B008490D47";
  area="Shell Viewer";
  key="F3 Enter NumEnter MsM1Click";
  description="Review: Open graphics files";
  condition=function() return (ver <= sem and Plugin.Exist(RVId) and mf.fmatch(APanel.Current,MaskG)==1) end;
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
  condition=function() return (FV and Plugin.Exist(RVId) and mf.fmatch(APanel.Current,MaskV)==1) end;
  action=function()
  Far.DisableHistory(-1) Plugin.Command(RVId,APanel.Current);
end;
}