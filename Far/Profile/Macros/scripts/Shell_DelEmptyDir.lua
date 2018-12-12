-- Delete empty folder;
-- VictorVG @ VikSoft.Ru (Russia, Moscow, 1996 - 2018)
-- v1.0 , 12.12.2018 04:09:03 +0300 - Initial release.

local CmdStr,dfl,sm="",win.GetEnv("FARHOME").."\\DelEmptyFolder.exe",0;
local function rdef() mf.print(dfl.." "..APanel.Current) Keys("Enter"); end;
local function rst() Keys("ESC") mf.print(CmdStr) end;

Macro {
area = "Shell";
key = "CtrlShiftD";
description = "Delete empty folder";
action = function() Far.DisableHistory(-1);
          if (not CmdLine.Empty) then CmdStr=CmdLine.Value Keys("ESC") sm=1; end;
            rdef()
          if sm == 1 then rst() end;
  end;
}
