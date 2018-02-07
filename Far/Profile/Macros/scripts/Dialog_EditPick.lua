﻿-- Started: 2016-02-28
-- Goal: pick some text from current editor line into dialog input field
-- What is picked:
--   (a) if some text in the line is selected - that text is picked
--   (b) else the word under cursor,
--       else the nearest word in the forward direction,
--       else the nearest word in the backward direction.
-- If the text in the input field is equal to (a) then (b) is picked and vice versa.

-- SETTINGS
local pattern = regex.new("(\\w+)")
-- END OF SETTINGS

local F = far.Flags

local function GetTextFromEditor (curtext)
  local line = editor.GetString()
  if line then
    local sel = line.SelStart>=1 and
                line.SelStart<=line.StringLength and
                line.StringText:sub(line.SelStart,line.SelEnd)
    if sel=="" then sel=nil end

    local word
    local pos = editor.GetInfo().CurPos
    local offset,last = pattern:find(line.StringText, pos==1 and 1 or pos-1)
    if offset then
      word = pattern:match(line.StringText:reverse(), line.StringLength-last+1):reverse()
    else
      local rword = pattern:match(line.StringText:reverse())
      word = rword and rword:reverse()
    end
    if word=="" then word=nil end

    if curtext == sel and word then return word end
    if curtext == word and sel then return sel end
    return sel or word
  end
end

Macro {
  description="Pick word under editor cursor";
  area="Dialog"; key="CtrlShiftW";
  action=function()
    local dinfo = far.AdvControl("ACTL_GETWINDOWINFO", nil)
    if dinfo then
      local nfocus = dinfo.Id:send("DM_GETFOCUS")
      local ditem = dinfo.Id:send("DM_GETDLGITEM", nfocus)
      if ditem and (ditem[1]==F.DI_EDIT or ditem[1]==F.DI_FIXEDIT or ditem[1]==F.DI_COMBOBOX) then
        local text = GetTextFromEditor(ditem[10])
        if text then dinfo.Id:send("DM_SETTEXT", nfocus, text) end
      end
    end
  end;
}