-- http://forum.farmanager.com/viewtopic.php?f=15&p=144542#p144542
-- v1.1 Refactoring VictorVG
-- v1.2 Refactoring and code clean, VictorVG, Fri Jun 23 12:51:30 +0300 2017
-- v1.3 More refactoring, VictorVG, Sat Jul 08 03:29:00 +0300 2017
-- v1.4 Call editor mode is "Non Modal = True", VictorVG, Mon Jul 10 05:10:43 +0300 2017

local sep = "\n\n"..string.rep("=", 73).."\n\n";
local codepage = 65001;
local title = " <<< Notebook >>> ";
local notebook_path = win.GetEnv("FARLOCALPROFILE") .. "\\Notebook.txt";
local flags = { EF_NONMODAL = 1, EF_IMMEDIATERETURN = 1 };

Macro
{
  id="8C60C308-5940-4F5E-BB8D-5AC85D98D739";
  area = "Common";
  key = "AltShiftF12";
  description = "Notebook";
  priority=70;
  action = function()
        editor.Editor(notebook_path, title, nil, nil, nil, nil, flags , nil, nil, codepage)
  end;
}

Macro{
  id="3570D3B9-DE3E-46D0-9DA8-C673D422E4D7";
  area="Editor";
  key="CtrlAltBS";
  description="Separator";
  filemask="Notebook.txt";
  priority=70;
  action=function() Keys("End") print(sep) Keys("Home") end;
}
