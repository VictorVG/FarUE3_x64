-- 2useven10, Tue 08 Nov, 2016 16:20
-- http://forum.farmanager.com/viewtopic.php?p=141490#p141490

local ffi = require("ffi")
local nls = ffi.load("normaliz.dll")
local NormalizationC, ERROR_SUCCESS, RenameGUID = 1, 0, '431A2F37-AC01-4ECD-BB6F-8CDE584E5A03'

ffi.cdef([[
int NormalizeString(int NormForm, const wchar_t* src, int slen, wchar_t* dst, int dlen);
BOOL IsNormalizedString(int NormForm, const wchar_t* name, int len);
DWORD GetLastError(void);
void SetLastError(DWORD);
]])

local function need_normalize(name)
  local need = false
  if (nls ~= nil and #name > 0) then
    local namew = win.Utf8ToUtf16(name .. "\0")
    local ptrw = ffi.new("wchar_t[?]", #namew/2)
    ffi.copy(ptrw, namew)
    ffi.C.SetLastError(ERROR_SUCCESS)
    local norm = nls.IsNormalizedString(NormalizationC, ptrw, -1)
    local errc = ffi.C.GetLastError()
    return norm ~= 1 and errc == ERROR_SUCCESS
  end
  return need
end

local function normalize(name)
  local nname = ""
  if (nls ~= nil and #name > 0) then
    local namew = win.Utf8ToUtf16(name)
    local ptrw = ffi.new("wchar_t[?]", #namew/2)
    ffi.copy(ptrw, namew)
    local outw = ffi.new("wchar_t[?]", #namew)
    local len = nls.NormalizeString(NormalizationC, ptrw, #namew/2, outw, #namew)
    if len > 0 then
      nname = win.Utf16ToUtf8(ffi.string(outw, len*2))
    end
  end
  return nname
end

Macro {
  area="Shell"; key="CtrlShiftN"; flags="NoPluginPanels"; description="Rename with NFC normalization";
  condition = function()
    return APanel.FilePanel and APanel.Visible and need_normalize(APanel.Current)
  end;
  action = function()
    local nname = normalize(APanel.Current)
    Keys 'ShiftF6'
    if Area.Dialog and Dlg.Id == RenameGUID and #nname > 0 then
      Keys 'CtrlY'
      print(nname)
      --Keys 'Enter'
    end
  end;
}