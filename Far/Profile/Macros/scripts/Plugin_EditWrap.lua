local VWID = "580F7F4F-7E64-4367-84C1-5A6EB66DAB1F"

Macro
{
  area="Editor"; key="ShiftF5"; description="Wrap/unwrap lines virtually"; action=function()
  Plugin.Call(VWID,2)
end
}
