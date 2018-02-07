-- John Doe » Tue 03 Feb, 2015 11:44
-- http://forum.farmanager.com/viewtopic.php?p=127776#p127776

Macro { description="Selection in viewer";
  area="Viewer"; key="CtrlAltIns";
  id="99FBBBD4-146F-412F-BC04-79A8778ADCC9";
  action=function()
    local start = viewer.GetInfo().FilePos
    local len = 1
    repeat
      viewer.Select (nil, start, len)
      local key = mf.waitkey()
      if key=="CtrlIns" then Keys(key); break end
      start = key=="Right" and start+1 or key=="Left" and start-1 or start
      len = key=="ShiftRight" and len+1 or key=="ShiftLeft" and len-1 or len
    until key=="Esc"
  end;
}
