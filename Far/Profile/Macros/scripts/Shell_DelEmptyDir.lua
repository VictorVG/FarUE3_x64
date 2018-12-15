-- Recursive deletion of empty directories under the
-- cursor. The console utility DelEmptyFolder.exe is
-- used. The name of the directory under the cursor
-- is passed as the only parameter it takes. If run
-- without a parameter, it will delete all empty
-- directories below the current one. The utility
-- is written in C#, it works in the background and
-- does not display messages, it requires .NET 4.0
--
-- VictorVG @ VikSoft.Ru (Russia, Moscow, 1996 - 2018)
-- v1.0 , 12.12.2018 04:09:03 +0300 - Initial release.
-- v1.1 , 15.12.2018 06:22:27 +0300
-- Refactoring, fixed long patch error, screen echo off

local CmdStr,dfl,sm,qt,at="",win.GetEnv("FARHOME").."\\DelEmptyFolder.exe",0,'"',"@";
local function rdef() mf.print(at..qt..dfl..qt.." "..qt..APanel.Current..qt) Keys("Enter"); end;
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
