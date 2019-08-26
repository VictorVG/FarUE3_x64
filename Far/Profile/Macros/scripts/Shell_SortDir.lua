-- Always sort folder use alphabet order. (c) Alexey Samlyukov 21.082013 03:04
-- Required Far 3.0 b3620 + LuaMacro b230 or newer.
local ffi = require "ffi"
local C = ffi.C
local shlwapi=ffi.load("shlwapi")

ffi.cdef [[
  int StrCmpLogicalW(const wchar_t*, const wchar_t*);
]]

Panel.LoadCustomSortMode (100, {
  Description = "Sort files with StrCmpLogicalW";
  Compare = function(pi1,pi2,opt)
    return shlwapi.StrCmpLogicalW(pi1.FileName, pi2.FileName)
  end;
  Indicator = "+-";
})

Macro {
  description="Sort files with StrCmpLogicalW";
  area="Shell";
  key="CtrlShiftF12";
  action=function()
    Panel.CustomSortMenu()
  end;
}