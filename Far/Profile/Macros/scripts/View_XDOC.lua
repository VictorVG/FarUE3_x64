-- Просмотр документов XDOC как текста используя xdoc2txt v2.0.11.0 (UNICODE.)
-- Вызов AltF3 выбран специально чтобы конвертор не портил выходной текст
-- ибо по умолчанию его внутренняя кодировка ShiftJIS (Япония), а на больших
-- файлах его работа заметна по задержке просмотра, да и его временный файл
-- пишется в %TEMP%. HTML файлы через конвертер лучше не смотреть - он
-- игнорирует в них строку <meta ... content="text/html; charset=...">
-- и в итоге если встречает не UTF-8 файл на экран выводится мусор. Посему
-- маски XHTM, HTM, HTML, SHTM выкинуты - если надо смотрите их в браузере.
--
-- History:
-- v1.2 - refactoring.
-- Sun Jun 14 10:00:02 +0300 2015
-- v1.2.1 - contunue and fix typo
-- Mon Jun 15 01:33:25 +0300 2015
-- v1.2.2 - refactoring
-- Tue Jun 16 17:10:08 +0300 2015
-- v1.2.3 - fix typo
--Tue Jun 16 23:24:22 +0300 2015
--
-- VictorVG @ VikSoft.Ru, 1996 -2015
--

local Cmds="view:<xdoc2txt -8 -o=0 "
local Mask="/.+\\.(sx(c|d|i|w)|od(g|p|s|t)|do(c|cm|cx)|xl(s|sm|sx)|pp(t|tm|tx)|rtf|j(a|b|f|t|u|v)w|jt(d|t)|oa(s|2|3)|bun|wj(2|3)|wk(3|4)|123|wri|pdf|mht|eml)/i"

Macro{
  id="65BB8A9F-7AC6-48F3-8F17-E00F34235D1E";
  area="Shell";
  key="AltF3";
  description="View XDOC's as plain text";
  filemask=Mask;
  flags="NoFolders";
  priority=50;
  condition=function() return mf.fmatch(APanel.Current,Mask)==1 end;
  action=function()
  Far.DisableHistory(-1); mf.print(Cmds..'"'..APanel.Current..'"') Keys("Enter");
end;
}
