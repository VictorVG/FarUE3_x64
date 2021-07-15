-- Shell_DelBak.lua - script for delete temporary and backup unused files by mask.
-- VictorVG, VikSoft.Ru©, Russia, Moscow. All Right Reserved. 1996 - 2021
-- 
-- Script used configuaration variables: Msk1, Msk2, Excl .
--
-- Include Msk1 mask (PCRE regexp) is backup files mask,
-- Include Msk2 mask (PCRE regexp) is temporary file type mask
-- Exclude Excl mask (PCRE regexp) protected filetype;
-- 
-- v1.0 Initial release
-- 08.07.2021 18:55:41 +0300
-- v1.1, Update clear()
-- 14.07.2021 03:21:58 +0300
-- v1.2, Refactoring
-- 14.07.2021 19:16:17 +0300
-- v1.3, Use API for redraw panel, refactoring
-- 15.07.2021 01:47:01 +0300


local Msk1,Excl = "/.+\\.(ba(c|k))$/i","/.+\\.(bat|btm|cmd|lua|moon|whs|ps1)$/i";
local Msk2 = "/.+\\.(log|temp|lock|(\\~|\\w?{1})tmp|(\\~|\\w?{1})log|dir|xml|c|h|(c|h)pp|svn|txt|rc)$/i";

local function fd(Mask)
  local Q,T,p = "\nDo you like delete all (%d units) files?","Delete unused files";
   Panel.Select(0,1,3,Mask)
   Panel.Select(0,0,3,Excl)
   if APanel.Selected and msgbox(T,Q:format(APanel.SelCount),0x20000)==1 then
    p =  Panel.SetPosIdx(0,0)
   for j=1,APanel.SelCount do
    Panel.SetPosIdx(0,j,1)
    win.DeleteFile(APanel.Current)
   end
    panel.UpdatePanel(nil,1)
    panel.RedrawPanel(nil,1)
    Panel.SetPosIdx(0,p)
   end
  end;

Macro{
  id="3CCFF979-B268-4983-A00E-C3003086807A";
  area="Shell";
  key="AltB";
  description="Delete backup files";
  priority=60;
  condition=function() return not APanel.Empty end;
  action=function() fd(Msk1) end;
}

Macro{
  id="E446E62C-1BC3-4CDF-8E54-1A5C1FF32663";
  area="Shell";
  key="AltT";
  description="Delete temporary files";
  priority=60;
  condition=function() return not APanel.Empty end;
  action=function() fd(Msk2) end;
}
