-- shmuz,  22:41 19-02-2015
-- http://forum.ru-board.com/topic.cgi?forum=5&topic=31718&start=6280#13
-- изменения: для совместимости с установленными макросами FarUE3 изменён
-- вызов скрипта с "CtrlShiftR" на "AltShiftR"

Macro {
  description="Reload macros";
  area="Common"; key="AltShiftR";
  action=function()
    local msg = win.GetEnv("farlang")=="Russian" and "Перезагрузка макросов" or "Reload macros"
    far.Message(msg,"","")
    far.MacroLoadAll()
    win.Sleep(200)
    far.AdvControl("ACTL_REDRAWALL")
  end;
}
