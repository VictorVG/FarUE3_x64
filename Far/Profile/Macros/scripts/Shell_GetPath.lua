-- Показывает путь на реальной ФС для элемента под курсором на активной панели
-- v1.0.1, рефакторинг
-- VictorVG @ VikSoft.Ru (Russia, Moscow, 1996 - 2019)
-- 02.08.2019 18:37:00 +0300

local function APP ()
  local UNC = APanel.UNCPath;
  if mf.rindex(UNC,"/") then UNC = mf.replace(UNC,"/","") end;
  return (UNC.."\\"..APanel.Current);
  end;

Macro{
  id="4C4C45CA-8F68-4791-8941-5FAD1DC07920";
  area="Shell";
  key="AltEnter";
  description="Display UNC path for current panel item";
  action=function()
  far.Message(APP())
 end;
}