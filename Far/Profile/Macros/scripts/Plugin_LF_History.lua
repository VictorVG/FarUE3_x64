local LFHistory = "a745761d-42b5-4e67-83da-f07af367ae86"
local function LFH_exist() return Plugin.Exist(LFHistory) end
local function LFH_run(key) Plugin.Menu(LFHistory) Keys(key) end

Macro {
  description="LuaFAR History: commands";
  area="Shell Info QView Tree"; key="AltF8";
  condition=LFH_exist; action=function() LFH_run"1" end;
}

Macro {
  description="LuaFAR History: view/edit";
  area="Shell Editor Viewer"; key="AltF11";
  condition=LFH_exist; action=function() LFH_run"2" end;
}
-- Change default key is "AltF12" up to "CtrlAltF12" for use
-- both Far and LF_History folder history managed tools;

Macro {
  description="LuaFAR History: folders";
  area="Shell"; key="CtrlAltF12";
  condition=LFH_exist; action=function() LFH_run"3" end;
}

Macro {
  description="LuaFAR History: locate file";
  area="Shell"; key="CtrlShiftSpace";
  condition=LFH_exist; action=function() LFH_run"5" end;
}
