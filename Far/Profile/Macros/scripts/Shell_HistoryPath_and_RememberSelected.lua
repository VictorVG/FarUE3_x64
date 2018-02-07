-------------------------------------------------------------------------------
-- Назад/вперед по папкам используя историю с сохранением пометки файлов. © SimSU
-------------------------------------------------------------------------------
-- Требуется макрос SimSU.Shell.HistoryPath.lua  20130101
-- Требуется макрос SimSU.Shell.RememberSelected.lua  20130101
-------------------------------------------------------------------------------
Macro {
area="Shell"; key="AltBS"; description="Возврат в предыдущую папку с сохранением выделения. © SimSU";
priority=51;
action = function()
  eval("Shell/SimSUSaveSelection",2)
  eval("Shell/SimSUPathBack",2)
  eval("Shell/SimSURestoreSelection",2)
end;
}

Macro {
area="Shell"; key="ShiftBS"; description="Отмена возврата в предыдущую папку с сохранением выделения. © SimSU";
priority=51;
action = function()
  eval("Shell/SimSUSaveSelection",2)
  eval("Shell/SimSUPathForward",2)
  eval("Shell/SimSURestoreSelection",2)
end;
}
