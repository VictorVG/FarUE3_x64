-- autor w17 redetct CP and reopen file

Macro {
  area="Editor Shell"; key="ShiftF4"; description="Shift-F4 current";
  action = function()
    local name = nil
    if Area.Shell and not APanel.Folder then
      name = APanel.Current
    elseif Area.Editor then
      name = Editor.FileName
    end
    Keys('ShiftF4')
     if name and Area.Dialog then
       Keys('CtrlY'); print(name); Keys('Home ShiftEnd')
    end
  end
}