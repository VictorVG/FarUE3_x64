-- started: 2015-11-23

local F = far.Flags
local VK = win.GetVirtualKeys()
local Title    = "Post macro"
local DlgGuid  = "2C4EFD54-A419-47E5-99B6-C9FD2D386AEC"
local HelpGuid = "59154DF0-40D8-495C-BDF2-B97803745D8F"
local DB_Key   = "Post macro utility"
local DB_Name  = "Options"

-- Options
local DefaultOpt = {
  lang = "lua";   -- "lua" or "moonscript"
  reuse = false;  -- true: reuse environment
  loop = false;   -- true: call the dialog again after the macro execution is finished
}
local Env = {}

local Help = [[
Controls:
  Sequence   - either Lua/MoonScript chunk or @<filename>
               if it begins with an '=' then far.Show() is called on it.
  Parameters - comma separated list of Lua/MoonScript expressions
  [x] Reuse environment - use the previous Lua environment for the new run
  [x] Loop this dialog  - call this dialog again after the execution

Preset "global" variables:
  F       = far.Flags
  Message = far.Message
  Show    = far.Show
  WI      = far.AdvControl("ACTL_GETWINDOWINFO") -- window info
  API     = panel.GetPanelInfo(nil,1)            -- active panel info
  PPI     = panel.GetPanelInfo(nil,0)            -- passive panel info
  EI      = editor.GetInfo()                     -- editor info
  VI      = viewer.GetInfo()                     -- viewer info
  Cnt     = automatic counter of runs in the current Lua environment]]

local function GetText (aOpt)
  local edtFlags = F.DIF_HISTORY + F.DIF_USELASTHISTORY + F.DIF_MANUALADDHISTORY
  local Items =
  {
--[[01]] {F.DI_DOUBLEBOX,   3, 1,72,12, 0, 0, 0, 0,Title},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2, 0, 0, 0, 0,"&Sequence:"},
--[[03]] {F.DI_EDIT,        5, 3,70, 3, 0, "PostMacroSequence", 0, edtFlags, ""},
--[[04]] {F.DI_TEXT,        5, 4, 0, 0, 0, 0, 0, 0,"&Parameters:"},
--[[05]] {F.DI_EDIT,        5, 5,70, 0, 0, "PostMacroParams", 0, edtFlags, ""},
--[[06]] {F.DI_RADIOBUTTON, 5, 7, 0, 0, 0, 0, 0, "DIF_GROUP", "&Lua"},
--[[07]] {F.DI_RADIOBUTTON, 5, 8, 0, 0, 0, 0, 0, 0,           "&MoonScript"},
--[[08]] {F.DI_CHECKBOX,   35, 7, 0, 0, 0, 0, 0, 0, "&Reuse environment"},
--[[09]] {F.DI_CHECKBOX,   35, 8, 0, 0, 0, 0, 0, 0, "Loop this &dialog"},
--[[10]] {F.DI_TEXT,       -1,10, 0, 0, 0, 0, 0, F.DIF_SEPARATOR,""},
--[[11]] {F.DI_BUTTON,      0,11, 0, 0, 0, 0, 0, F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,"OK"},
--[[12]] {F.DI_BUTTON,      0,11, 0, 0, 0, 0, 0, F.DIF_CENTERGROUP,"Cancel"},
  }
  local edtSequence, lblParams, edtParams, rbLua, rbMoon, cbReuse, cbLoop, btnOK = 3,4,5,6,7,8,9,11
  local f, f2, msg

  local function EditInTmpFile(hDlg, itempos, ext)
    local fname = win.GetEnv("TEMP").."\\far3-"..win.Uuid(win.Uuid()):sub(1,8)..ext
    local fp = io.open(fname, "w")
    if fp then
      local txt = hDlg:send("DM_GETTEXT", itempos)
      fp:write(txt or "")
      fp:close()
      local flags = {EF_DISABLEHISTORY=1,EF_DISABLESAVEPOS=1}
      if editor.Editor(fname,nil,nil,nil,nil,nil,flags,nil,nil,65001) == F.EEC_MODIFIED then
        fp = io.open(fname)
        if fp then
          txt = fp:read("*all")
          fp:close()
          hDlg:send("DM_SETTEXT", itempos, txt)
        end
      end
      win.DeleteFile(fname)
      far.AdvControl("ACTL_REDRAWALL")
    end
  end

  local function DlgProc (hDlg,Msg,Param1,Param2)
    if Msg == F.DN_CONTROLINPUT and Param2.EventType == F.KEY_EVENT and Param2.KeyDown then
      if Param2.VirtualKeyCode == VK.F1 and band(Param2.ControlKeyState,0x1F)==0 then
        far.Message(Help, Title.." HELP", nil, "l",nil,win.Uuid(HelpGuid))
      elseif Param1 == edtSequence or Param1 == edtParams then
        if Param2.VirtualKeyCode == VK.F4 and band(Param2.ControlKeyState,0x1F)==0 then
          local ext = hDlg:send("DM_GETCHECK",rbMoon)==F.BSTATE_CHECKED and ".moon" or ".lua"
          EditInTmpFile(hDlg, Param1, ext)
        end
      end
    elseif Msg == F.DN_CLOSE and Param1 == btnOK then
      local sequence = hDlg:send("DM_GETTEXT",edtSequence)
      local params = hDlg:send("DM_GETTEXT",edtParams)
      local ms = hDlg:send("DM_GETCHECK",rbMoon)==F.BSTATE_CHECKED and require "moonscript"
      if sequence:find("^@") then
        local fname = sequence:sub(2):gsub("%%(.-)%%", win.GetEnv)
        fname  = far.ConvertPath(fname, "CPM_NATIVE") or fname
        f, msg = (ms and ms.loadfile or loadfile)(fname)
      else
        local s = sequence:find("^=") and "far.Show("..sequence:sub(2)..")"
        f, msg = (ms and ms.loadstring or loadstring)(s or sequence)
      end
      if not f then far.Message(msg, Title, nil, "w"); return 0; end
      f2, msg = (ms and ms.loadstring or loadstring)("return "..params)
      if not f2 then far.Message(msg, Title, nil, "w"); return 0; end
      hDlg:send("DM_ADDHISTORY", edtSequence, sequence)
      hDlg:send("DM_ADDHISTORY", edtParams, params)
    end
  end

  Items[rbLua   ][6] = aOpt.lang=="moonscript" and 0 or 1
  Items[rbMoon  ][6] = aOpt.lang=="moonscript" and 1 or 0
  Items[cbReuse ][6] = aOpt.reuse and 1 or 0
  Items[cbLoop  ][6] = aOpt.loop and 1 or 0
  if far.Dialog (win.Uuid(DlgGuid),-1,-1,76,14,nil,Items,nil,DlgProc) == btnOK then
    aOpt.lang   = Items[rbLua   ][6] ~= 0 and "lua" or "moonscript"
    aOpt.reuse  = Items[cbReuse ][6] ~= 0
    aOpt.loop   = Items[cbLoop  ][6] ~= 0
    return f, f2
  end
end

local function LoadOptions()
  local Opt = mf.mload(DB_Key, DB_Name)
  if type(Opt) ~= "table" then Opt = {} end
  for k,v in pairs(DefaultOpt) do -- set invalid option values to defaults
    if type(Opt[k]) ~= type(v) then Opt[k]=v end
  end
  return Opt
end

local function SaveOptions(aOpt)
  for k,v in pairs(aOpt) do -- remove invalid key-value pairs
    if type(v) ~= type(DefaultOpt[k]) then aOpt[k]=DefaultOpt[k] end
  end
  mf.msave(DB_Key, DB_Name, aOpt)
end

local function Execute()
  local Opt = LoadOptions()
  local oldReuse = Opt.reuse
  local f, f2 = GetText(Opt)
  if not f then return end
  SaveOptions(Opt)

  Env = oldReuse and Opt.reuse and Env or {}
  setmetatable(Env, {__index=_G})
  setfenv(f, Env)
  setfenv(f2, Env)

  Env.F = far.Flags
  Env.Cnt = (type(Env.Cnt)=="number" and Env.Cnt or 0) + 1
  Env.Message = far.Message
  Env.Show = far.Show
  Env.WI = far.AdvControl("ACTL_GETWINDOWINFO")
  Env.EI = Area.Editor and editor.GetInfo() or nil
  Env.VI = Area.Viewer and viewer.GetInfo() or nil
  if panel.CheckPanelsExist() then Env.API, Env.PPI = panel.GetPanelInfo(nil,1), panel.GetPanelInfo(nil,0) end

  mf.postmacro(f, f2())
  if Opt.loop then mf.postmacro(Execute) end
end

Macro {
  description=Title; area="Common"; key="LAltShiftM";
  condition=function() return (not Area.Dialog) or (Dlg.Id~=DlgGuid and Dlg.Id~=HelpGuid) end;
  action=Execute;
}
