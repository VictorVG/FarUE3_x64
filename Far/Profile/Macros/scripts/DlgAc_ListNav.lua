-- Навигация по секциям списков
-- John Doe » Tue 10 Oct, 2017 07:01
--http://forum.farmanager.com/viewtopic.php?f=15&t=9596
--
-- Updated

local F = far.Flags
local areas = "ShellAutoCompletion DialogAutoCompletion Menu UserMenu MainMenu Dialog"

local DELAY = 300
local AR_DELAY = 500*1000
local not_positionable = bor(F.LIF_SEPARATOR,F.LIF_DISABLE,F.LIF_HIDDEN)
local lasttime = 0
local function Jump(dir)
  local ID = Area.Dialog and Dlg.CurPos or 1
  local sep_found,sep_positionable,firstitem
  local hDlg = far.AdvControl(F.ACTL_GETWINDOWINFO).Id
  local list = far.GetDlgItem(hDlg,ID)[6]
  for i=list.SelectIndex+dir,dir<0 and 1 or #list, dir do
    local flags = list[i].Flags
    local cur_positionable = band(flags,not_positionable)==0
    if dir<0 then
      firstitem = cur_positionable and i or firstitem
    end
    if sep_found then
      if cur_positionable then
        sep_positionable = true
        break
      end
    elseif band(flags,F.LIF_SEPARATOR)~=0 then
      sep_found = i
    end
  end
  local destination = sep_positionable and sep_found or firstitem
  if destination then
    hDlg:send(F.DM_LISTSETCURPOS,ID,{SelectPos=destination,TopPos=destination})
    lasttime = far.FarClock()
  elseif far.FarClock()-lasttime>AR_DELAY and mf.waitkey(DELAY)==mf.akey(1,1) then
    Keys(dir>0 and "Home" or "End")
  else
    mf.beep()
  end
  lasttime = far.FarClock()
end

Macro { description="Navigate to prev/next section";
  area=areas; key="/[LR]CtrlShift(Up|Down)/";
  id="1BAED6ED-E6F0-4313-BDC3-F8466BEEDB68";
  condition=function()
    return not Area.Dialog or (Dlg.ItemType==F.DI_LISTBOX)
  end;
  action=function()
    if Area.MainMenu and Object.Height==1 then --HMenu
      Keys "Up"
    else
      Jump(mf.akey(1,1):match"Up$" and -1 or 1)
    end
  end;
}