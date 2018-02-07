-- Вставить текущую дату и время в текущий редактор в формате
-- dd.mm.yyyy HH:MM:SS UTC для Far b5014 и новее.
-- V1.1 - рефакторинг с форматированием вывода VictorVG @ VikSoft.ru
-- 27.08.2017 11:16:07 +0300

Macro {
  id="1686D952-B67D-4BA5-A6F8-6221D141EF42";
  description="Вставить текущую дату и время";
  area="Editor";
  key="AltD";
  flags="NoSendKeysToPlugins";
  action=function()
   print(mf.date("%d.%m0.%Y %H:%M:%S %z"))
  end;
}