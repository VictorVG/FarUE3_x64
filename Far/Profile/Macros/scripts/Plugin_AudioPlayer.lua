-- HaRT, Sat 26 May, 2018 00:13
-- https://forum.farmanager.com/viewtopic.php?p=149864#p149864
-- Fixed message box missing flags definition, small refactoring. /VictorVG/
-- v1.01

local APUUID = '9C3A61FC-F349-48E8-9B78-DAEBD821694B'
local MSGFLG = '0x00010008'

Macro {
  description = "AudioPlayer: key bindings help by F1";
  area = 'Dialog';
  key = 'F1';
  condition = function() return Dlg.Id == APUUID end;
  action = function()
     msgbox( 'Key bindings', [[

Space,            VK_PLAY_PAUSE
Enter           Next|Play/Pause
Home               Rev to start
Shift-/Left           Rev 5s/5%
Shift-/Right          FF  5s/5%
Ctrl Left , PgUp,  VK_PLAY_NEXT
Ctrl Right, PgDn,  VK_PLAY_PREV
Up                 Volume Up
Down               Volume Down
Esc                Stop & close
Ctrl PgUp/PgDn       First/Last
Ctrl Home/End        First/Last

]], MSGFLG )
  end
}