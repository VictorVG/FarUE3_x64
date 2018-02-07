--http://forum.farmanager.com/viewtopic.php?p=126474#p126474

local function norm(name)
  name = mf.fsplit(name,0x4):match("%a.*")
  return name and name:upper() or nil
end

Macro {
  key="ShiftDivide";
  area="Shell Search";
  description="Select files with the same names without numeric prefix and extension";
  condition=function()
    return APanel.Visible and PPanel.Visible and not APanel.Empty and not PPanel.Empty
  end;
  action=function()
    Panel.Select(0,0); Panel.Select(1,0)
    local PTable={}
    for ip=1,PPanel.ItemCount do
      PTable[ip]=norm(Panel.Item(1,ip,0))
    end
    local a,p = {},{}
    for ia=1,APanel.ItemCount do
      local ANameOnly=norm(Panel.Item(0,ia,0))
      if ANameOnly then
        for ip,PNameOnly in pairs(PTable) do
          if ANameOnly==PNameOnly then
            a[#a+1],p[#p+1] = ia, ip
          end
        end
      end
    end
    panel.SetSelection(nil,0,p,true)
    panel.SetSelection(nil,1,a,true)
    panel.RedrawPanel(nil,0)
    panel.RedrawPanel(nil,1)
  end;
}

