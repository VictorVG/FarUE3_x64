﻿-- author shmuz publish in to http://forum.ru-board.com/topic.cgi?forum=5&topic=31718&start=7660#14
-- updated by Capushon in to http://forum.ru-board.com/topic.cgi?forum=5&topic=31718&start=7660#17
-- v1.1, required Far3 b4423 or letter
--
Macro {
  description="Show dialog/menu ID";
  area="Dialog Menu";  key="CtrlG";
  action=function()
    local Id = Area.Dialog and Dlg.Id or Menu.Id
    local quotId = '"' .. Id .. '"'
    local fullname, text
    for name,guid in pairs(far.Guids or {}) do
      if guid == Id then
        fullname = "far.Guids." .. name
        break
      end
    end
    if fullname then
      local res = far.Message(fullname.."\n"..Id.."\n".."Type:"..Dlg.ItemType, "Dialog/Menu ID", "Copy &Name;Copy &GUID;Cancel")
      text = res==1 and fullname or res==2 and quotId
    else
      local res = far.Message(Id, "Dialog/Menu ID", "Copy &GUID;Cancel")
      text = res==1 and quotId
    end
    if text then far.CopyToClipboard(text) end
  end;
}