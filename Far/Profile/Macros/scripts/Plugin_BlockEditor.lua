
-- This is sample macro-file for MacroLib plugin for Far Manager 3.x
-- You can download plugin here:
-- http://code.google.com/p/far-plugins/wiki/MacroLib

local MBlockEditor = "D82D6847-0C7B-4BF4-9A31-B0B929707854"

Macro
{ area="Editor"; key="RCtrlMultiply"; description="Comment selection (auto mode)";
action=function()
  Plugin.Call(MBlockEditor,3)
end;
}

Macro
{ area="Editor"; key="RAltRCtrlMultiply"; description="Comment block";
action=function()
  Plugin.Call(MBlockEditor,5)
end;
}

Macro
{ area="Editor"; key="RAltShiftMultiply"; description="Comment stream";
action=function()
  Plugin.Call(MBlockEditor,6)
end;
}


Macro
{ area="Editor"; key="RCtrlShiftMultiply"; description="Uncomment selection";
action=function()
  Plugin.Call(MBlockEditor,4)
end;
}

Macro
{ area="Editor"; key="RCtrlBackSlash"; description="Tabulate selection rightward"; flags="EVSelection";
action=function()
  Plugin.Call(MBlockEditor,1)
end;
}

Macro
{ area="Editor"; key="RCtrlShiftBackSlash"; description="Tabulate selection leftward";
action=function()
  Plugin.Call(MBlockEditor,2)
end;
}
