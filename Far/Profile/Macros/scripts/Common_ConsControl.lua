-- Far console init v1.1 (с) VictorVG @ VikSoft.Ru
-- Установка размеров окна (80х35) и шрифта (Lucida Console,15) при старте Far
-- Задача поставлена iNNOKENTIY21 в
-- http://forum.ru-board.com/topic.cgi?forum=5&topic=31718&start=7440#13
-- v1.1 рефакторинг
-- Sun Sep 06 05:08:57 +0300 2015

require "ConsoleControl"
local CCID="94624B7B-FFDB-435F-B955-F99DBBC3BFE0"

Macro {
  area="Shell Viewer Editor"; key="auto"; description="Far console init window"; flags="RunAfterFARStart";
  condition=function() return (ConsoleControl.Installed() and not Far.FullScreen) end;
  action=function()
     Plugin.Call(CCID,"WindowSize",80,35);
     Plugin.Call(CCID,"BufferSize",80,35);
     Plugin.Call(CCID,"FontName","Lucida Console",15);
  end;
}

Macro {
  area="Shell Viewer Editor"; key="auto"; description="Far console init full screen"; flags="RunAfterFARStart";
  condition=function() return (ConsoleControl.Installed() and Far.FullScreen) end;
  action=function()
     Plugin.Call(CCID,"FontName","Lucida Console",15);
  end;
}
