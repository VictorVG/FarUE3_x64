-- Visual Compare files or folders for panels: Files, Branch, Arclite, Netbox, Observer.
-- v.1.1
local ffi = require("ffi")

ffi.cdef([[
typedef struct {
  void*          hwnd;
  uint32_t       wFunc;
  const wchar_t* pFrom;
  const wchar_t* pTo;
  unsigned short fFlags;
  int            fAnyOperationsAborted;
  void*          hNameMappings;
  const wchar_t* lpszProgressTitle;
} SHFILEOPSTRUCTW;
int SHFileOperationW(SHFILEOPSTRUCTW *);
]])

local FO_DELETE          = 0x0003
local FOF_SILENT         = 0x0004
local FOF_NOCONFIRMATION = 0x0010

local function utf16(str)
  local strw = win.Utf8ToUtf16(str)
  local result = ffi.new("wchar_t[?]", #strw/2+1)
  ffi.copy(result, strw)
  return result
end

local function remove(fname)
  local fileopw = ffi.new("SHFILEOPSTRUCTW")
  fileopw.wFunc = FO_DELETE
  fileopw.pFrom = utf16(fname.."\0\0")
  fileopw.pTo = utf16("\0\0")
  fileopw.fFlags = FOF_SILENT+FOF_NOCONFIRMATION
  return 0 == ffi.load("shell32").SHFileOperationW(fileopw)
end

local function f(p,f) if f:match("^[A-Z]:") then p=f elseif p=="" then p="\\" elseif f~=".." then p=p.."\\"..f end return '"'..p..'"' end
local function e(p,f)
  local h=Far.DisableHistory(-1)
  if f==".." then Panel.Select(0,1) end
  Keys("F5"); p=p.."\\"
  if Area.Dialog and Dlg.ItemType==4 and (Dlg.Id==CopyDl1 or Dlg.Id==CopyDl2 or Dlg.Id==CopyDl3) then print(p) Keys("Enter") if Area.Dialog and Dlg.Owner==TorrDlg then print(p) Keys("Enter") end end
  if Area.Dialog and (Dlg.ItemType==4 or Dlg.ItemType==8) and (Dlg.Id==CopyDl1 or Dlg.Id==CopyDl3) then print(p) Keys("Enter") end
  if Area.Dialog and Dlg.ItemType==7 and Dlg.Id==CopyDl1 then Keys("Enter") end
  if Area.Dialog and Dlg.ItemType==4 and Dlg.Id==ExtrDlg then print(p) Keys("AltO Enter") end
  Far.DisableHistory(h)
end


Arclite = "65642111-AA69-4B84-B4B8-9249579EC4FA"
VisComp = "AF4DAB38-C00A-4653-900E-7A8230308010"
CopyDl1 = "42E4AEB1-A230-44F4-B33C-F195BB654931"
CopyDl2 = "FCEF11C4-5490-451D-8B4A-62FA03F52759"
CopyDl3 = "2430BA2F-D52E-4129-9561-5E8B1C3BACDB"
ExtrDlg = "97877FD0-78E6-4169-B4FB-D76746249F4D"
TorrDlg = "00000000-0000-0000-546F-7272656E7400"

Macro {
 description="VC: Визуальное сравнение файлов"; area="Shell"; key="CtrlAltC";
condition = function() return APanel.SelCount<=2 end;
action = function()
  local AP,PP,AC,PC,AF,PF,ePF,APD,PPD,TMP,S2 = APanel.Path0,PPanel.Path0,APanel.Current,PPanel.Current,APanel.Format,PPanel.Format,regex.new"netbox|observe|torrent","\\AP","\\PP",win.GetEnv("Temp").."\\~arc"
  if APanel.SelCount==2 then
    S2,PC,AC = true,panel.GetSelectedPanelItem(nil,1,1).FileName,panel.GetSelectedPanelItem(nil,1,2).FileName
    -- if not APanel.Left then AC,PC = PC,AC end
  elseif APanel.SelCount==1 then S2,PC = true,panel.GetSelectedPanelItem(nil,1,1).FileName
  end
  local eAP,ePP = AF=="arc" or ePF:match(APanel.Prefix or ""),PF=="arc" or ePF:match(PPanel.Prefix or "")
  remove(TMP)
  if S2 and eAP then
    AP=TMP..APD PP=AP e(AP,AC)
  elseif S2 then
    PF,PP = AF,AP
  else
    if eAP then AP=TMP..APD e(AP,AC) end
    if ePP then PP=TMP..PPD Keys("Tab") e(PP,PC) Keys("Tab") end
  end
  AP,PP = f(AP,AC),f(PP,PC)
  if AP==PP then
    msgbox("Visual Compare","it's the same object")
  else
    if APanel.Left then Plugin.Command(VisComp,AP.." "..PP) else Plugin.Command(VisComp,PP.." "..AP) Keys("Tab") end
  end
end
}