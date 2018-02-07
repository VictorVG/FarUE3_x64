-- NetBox recursive dirlist by zg required Far b4499+ and NetBox v2.1.45.420+
-- original macros and idea find in to http://forum.farmanager.com/viewtopic.php?p=134735#p134735
-- updated for prevent usage error by VictorVG  Fri Jan 01 09:44:26 +0300 2016
-- Happy New Year!

local NBWID="42e4aeb1-a230-44f4-b33c-f195bb654931"

Macro {
  area="Shell"; key="CtrlShiftZ"; description="NetBox recursive dir list";
  condition=function() return APanel.Plugin and win.Uuid(panel.GetPanelInfo(nil,1).OwnerGuid) == NBWID end;
  action=function()
    local result,strings=far.GetPluginDirList(nil,APanel.Path),{}
    for ii=1,#result do
      strings[ii]=result[ii].FileName
    end
    far.Show(unpack(strings))
  end
}
