-- Usage: add string in header to yur script:
--
-- require("FuncLib") or local FuncLib = require("FuncLib")
--
-- and place FuncLib.lua in %FARHOME%\Profile\Macros\modules\
-- See demo.lua for more examples.
--
-- This module is exported function:
--
-- PlugVerD(),PlugVer() - return Far plug-ins version string,
-- vCmp() - return digital (Mod=1) or boolean (Mod=2);
--
-- Input parameters:
--
-- PlugVer(), PlugVer(): (plg,mod[,fmt])
--
-- plg - GUID or full path to the plug-in DLL
-- mod - 1 or 2 find plug use: 1 - GUID, 2 - full path in to plug-in DLL,
-- fmt - response line format: 0 - Major.Minor.Build.Revision; 1 - Major.Minor.Build.
-- By default, or if the fmt parameter is omitted then Major.Minor.Build.Revision
--
-- vCmp(): (arg1,arg2,mod)
-- arg1 and arg2 - compare stryng as digital format;
-- mod - 1 or 2 compare as:
-- mod == 1: arg1 < arg2, arg1 = arg2, arg > arg2 and return digital result;
-- mod == 2: arg1 < arg2, arg1 >= arg2 and return boolean result;
--
-- IsLmVer(): (build number), integer
--
-- Returns:
--
-- PlugVer() - return version string of the plug-in in to format
-- "Major.Minor.Build [.Revision]" or "nil" if error.
-- PlugVerD() - return is decimal version string "Major Minor Build [Revision]" w/o space.
-- vCmp() - return digital for mod=1 or boolean for mod=2 value is:
-- arg1 < arg2 return "-1", arg1 = arg2 return "0", arg1 = arg2 return "1"
-- or boolean: arg1 < arg2 return "false", arg1 >= arg2 return "true";
-- IsLmVer(): boolean - equivalents or newer - true, lowest - false
--
-- Notes:
--
-- PlugVer(), PlugVerD() and IsLmVer() can retrieve version info only for installed Far plug-in's!
--
-- Usage:
--
-- PlugVer("GUID",1[,0|1]) receiving the plug-in version with the specified GUID;
-- PlugVer("Path",2[,0|1]) getting the plug-in version with the full path to the DLL
-- vCmp(arg1,arg2,1) or vCmp(arg1,arg2,2) - compare version
-- IsLmVer(build) check LuaMacro version
--
-- Examples:
---
-- far.Message(PlugVer("9D4A59D9-AD2D-478C-8F66-7D233CBB788D",1,0),"Version:")
-- far.Message(PlugVer(win.GetEnv("FARHOME").."\\plug-ins\\imageview\\ImageView.dll",2,1),"Version:")
--
-- History:
--
-- Initial release, add PlugVer()
-- v1.0, VictorVG, 08.2019 22:53:34 +0300
-- Refactoring
-- v1.1, VictorVG, 16.08.2019 22:53:34 +0300
-- Refactoring
-- v1.2, VictorVG, 17.08.2019 06:16:44 +0300
-- Add KbdLayout() by 2useven10, https://forum.farmanager.com/viewtopic.php?p=154808#p154808
-- Add PlugVerD()
-- v1.3, VictorVG, 24.08.2019 14:02:09 +0300
-- Add vCmp()
-- v1.4, VictorVG, 25.08.2019 08:33:38 +0300
-- Small cosmetics
-- v1.4.1, VictorVG, 17.04.2020 22:16:03 +0300

function _G.PlugVer(plg,mod,fmt)
local Info,PVer,A,P
  if mod == 1 then P=far.FindPlugin("PFM_GUID",win.Uuid(plg)) else P=far.FindPlugin("PFM_MODULENAME",plg) end
       Info=far.GetPluginInformation(P);
           A=Info.GInfo.Version;
   if fmt == 1 then PVer=A[1].."."..A[2].."."..A[3] else PVer=A[1].."."..A[2].."."..A[3].."."..A[4] end
  return PVer
end

function _G.PlugVerD(plg,mod,fmt)
local Info,PVD,AD,PD
  if mod == 1 then PD=far.FindPlugin("PFM_GUID",win.Uuid(plg)) else PD=far.FindPlugin("PFM_MODULENAME",plg) end
       Info=far.GetPluginInformation(PD);
           AD=Info.GInfo.Version;
   if fmt == 1 then PVD=mf.atoi(AD[1]..AD[2]..AD[3],10) else PVD=mf.atoi(AD[1]..AD[2]..AD[3]..AD[4],10) end
  return PVD
end

function _G.vCmp(v1,v2,mod)
local rt
 if mod == 1 then rt=win.wcscmp(v1,v2) elseif mod >= 2 then if win.wcscmp(v1,v2) >= 0 then rt=true else rt=false end end
 return rt
end

local function IsLmVer(num)
local lmvr,rt,bld = far.GetPluginInformation(far.FindPlugin("PFM_GUID",win.Uuid("4EBBEFC8-2084-4B7F-94C0-692CE136894D")))
  if lmvr.GInfo.Version[4] >= num then rt=true else rt=false end
  return rt
end

local ffi = require("ffi")
local kernel = ffi.C
local user = ffi.load("user32.dll")
local INVALID_HANDLE_VALUE = ffi.cast("HANDLE", -1)
local TH32CS_SNAPPROCESS = 0x00000002
local TH32CS_SNAPTHREAD  = 0x00000004

ffi.cdef([[
DWORD GetCurrentProcessId(void);
HANDLE CreateToolhelp32Snapshot(DWORD dwFlags, DWORD th32ProcessID);
BOOL CloseHandle(HANDLE hObject);
typedef struct {
  DWORD  dwSize;
  DWORD  cntUsage;
  DWORD  th32ProcessID;
  intptr_t th32DefaultHeapID;
  DWORD  th32ModuleID;
  DWORD  cntThreads;
  DWORD  th32ParentProcessID;
  LONG   pcPriClassBase;
  DWORD  dwFlags;
  CHAR   szExeFile[260];
} PROCESSENTRY32;
BOOL Process32First(HANDLE hSnapshot, PROCESSENTRY32 *pe);
BOOL Process32Next(HANDLE hSnapshot, PROCESSENTRY32 *pe);
typedef struct {
  DWORD  dwSize;
  DWORD  cntUsage;
  DWORD  th32ThreadID;
  DWORD  th32OwnerProcessID;
  LONG   tpBasePri;
  LONG   tpDeltaPri;
  DWORD  dwFlags;
} THREADENTRY32;
BOOL Thread32First(HANDLE hSnapshot, THREADENTRY32 *te);
BOOL Thread32Next(HANDLE hSnapshot, THREADENTRY32 *te);
HANDLE GetKeyboardLayout(DWORD threadId);
DWORD GetWindowThreadProcessId(HWND hWnd, LPDWORD lpdwProcessId);
HWND GetForegroundWindow(void);
]])

function _G.KbdLayout()
  local layout = tonumber(Far.KbdLayout())
  if layout ~= 0 then return band(0xFFFF, layout) end

  local pe = ffi.new("PROCESSENTRY32"); pe.dwSize = ffi.sizeof("PROCESSENTRY32")
  local sh = kernel.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
  if sh == INVALID_HANDLE_VALUE then return 0 end
  local far_pid = kernel.GetCurrentProcessId()
  local far_conhost_pid = 0
  local work = kernel.Process32First(sh, pe)
  while work ~= 0 do
    if pe.th32ParentProcessID == far_pid then
      local name = ffi.string(pe.szExeFile)
      if name == "conhost.exe" then
        far_conhost_pid = pe.th32ProcessID
        break
      end
    end
    work = kernel.Process32Next(sh, pe);
  end
  kernel.CloseHandle(sh)
  if far_conhost_pid == 0 then
    local wnd = user.GetForegroundWindow()
    local thw = user.GetWindowThreadProcessId(wnd, ffi.NULL)
    return band(0xFFFF, tonumber(ffi.cast("intptr_t",kernel.GetKeyboardLayout(thw))))
  end

  local te = ffi.new("THREADENTRY32"); te.dwSize = ffi.sizeof("THREADENTRY32")
  sh = kernel.CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
  if sh == INVALID_HANDLE_VALUE then return 0 end
  local lng0 = tonumber(ffi.cast("intptr_t", user.GetKeyboardLayout(0)))
  local lng = 0
  work = kernel.Thread32First(sh, te)
  while work ~= 0 do
    if te.th32OwnerProcessID == far_conhost_pid then
      lng = tonumber(ffi.cast("intptr_t", user.GetKeyboardLayout(te.th32ThreadID)))
      if lng ~=0 and lng ~= lng0 then break end
    end
    work = kernel.Thread32Next(sh, te)
  end
  kernel.CloseHandle(sh)
  if lng == 0 then lng = lng0 end
  return band(0xFFFF, lng)
end