-- Макрос вызывает Git для файла под курсором и если тот был изменён,
-- Git восстановит его к последнему коммиту для исправления ошибок.
-- макрос работает только в репозитории Git, в любом ином месте выводится
-- сообщение Git об ошибке. Также макрос не вызывается для каталогов.

-- v1.0 Initial release
-- 28.03.2019 07:41:27 +0300, VictoVG

Macro{
  id="0B07B700-6B84-412B-AA1B-7E06CED36325";
  area="Shell";
  key="CtrlAltR";
  description="Git: Check file under cursor";
  condition=function() return not APanel.Folder end;
  action=function() Far.DisableHistory(-1); mf.print("git checkout "..APanel.Current) Keys("Enter") end;
}
