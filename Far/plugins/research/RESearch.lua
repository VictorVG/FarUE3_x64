-- Updated Fri Mar 13 19:25:19 +0300 2015 VictorVG
-- added description and removed unused Flags.

local function RESearchExists ()
  return Plugin.Exist("F250C12A-78E2-4ABC-A784-3FDD3156E415")
end

local function CallRS(...)
  return Plugin.Call("F250C12A-78E2-4ABC-A784-3FDD3156E415", ...)
end

local function CallRSS(...)
  return Plugin.SyncCall("F250C12A-78E2-4ABC-A784-3FDD3156E415", ...)
end

Macro {
  description="Shell: Search"; area="Shell"; key="AltF7"; condition=RESearchExists;
  action=function() CallRS("Search") end;
}

Macro {
  description="Shell: Replace"; area="Shell"; key="ShiftF7"; condition=RESearchExists;
  action=function() CallRS("Replace") end;
}

Macro {
  description="Shell: Grep"; area="Shell"; key="CtrlAltF7"; condition=RESearchExists;
  action=function() CallRS("Grep") end;
}

Macro {
  description="Shell: Rename Selected"; area="Shell"; key="AltF6"; condition=RESearchExists;
  action=function() CallRS("RenameSelected") end;
}

Macro {
  description="Shell: Rename"; area="Shell"; key="CtrlAltF6"; condition=RESearchExists;
  action=function() CallRS("Rename") end;
}

Macro {
  description="Shell: Select"; area="Shell"; key="AltAdd"; condition=RESearchExists;
  action=function() CallRS("Select") end;
}

Macro {
  description="Shell: Unselect"; area="Shell"; key="AltSubtract"; condition=RESearchExists;
  action=function() CallRS("Unselect") end;
}

Macro {
  description="Shell: Flip Selection"; area="Shell"; key="AltMultiply"; condition=RESearchExists;
  action=function() CallRS("FlipSelection") end;
}

Macro {
  description="Editor: Search"; area="Editor"; key="F7"; condition=RESearchExists;
  action=function() CallRS("Search") end;
}

Macro {
  description="Editor: Replace"; area="Editor"; key="CtrlF7"; condition=RESearchExists;
  action=function() CallRS("Replace") end;
}

Macro {
  description="Editor:  Revers search again"; area="Editor"; key="ShiftF7"; condition=RESearchExists;
  action=function() CallRS("SRAgain") end;
}

Macro {
  description="Editor: Filter"; area="Editor"; key="AltF7"; condition=RESearchExists;
  action=function() CallRS("Filter") end;
}

Macro {
  description="Viewer: Search"; area="Viewer"; key="F7"; condition=RESearchExists;
  action=function() CallRS("Search") end;
}

Macro {
  description="Viewer: Revers search again"; area="Viewer"; key="ShiftF7"; condition=RESearchExists;
  action=function() CallRS("SRAgain") end;
}
