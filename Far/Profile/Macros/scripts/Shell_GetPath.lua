-- Показывает путь на реальной ФС для элемента под курсором на активной панели
-- VictorVG @ VikSoft.Ru (Russia, Moscow, 1996 - 2019)
-- v1.0.1, рефакторинг
-- 02.08.2019 18:37:00 +0300
-- v1.1. Добавим копирование UNC пути в Windows ClipBoard по кнопке Copy;
--       Рефакторинг
-- 09.08.2019 13:07:09 +0300

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
  if far.Message(APP(),"UNC path for current item","OK ; Copy") == 2 then mf.clip(1,APP()) end;
 end;
}