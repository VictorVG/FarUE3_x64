  -- Toggle (word) wrap with Plugin.Call
  -- Arg#1: Plugin GUID
  -- Arg#2: Command ID, `2` is the same as hotkey in the plugin menu
  -- Arg#3: (Optional) cell count of the right border padding
local VWID = "580F7F4F-7E64-4367-84C1-5A6EB66DAB1F"

Macro
{
  area="Editor"; key="ShiftF5"; description="Wrap/unwrap lines virtually";
  action=function()
  Plugin.Call(VWID,2)
  end;
}
