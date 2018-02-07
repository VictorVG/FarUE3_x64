-- По RAltBackSlash ("RAlt\") зовём меню команд NetBox-а не дёргая F11.
-- Скрипт работает только в панели NetBox-а чтобы другим не мешал (by design).
--
-- v1.0 ©VictorVG, 19.11.2014 06:34:52 +0300
--

local NBID="42E4AEB1-A230-44F4-B33C-F195BB654931"
local NBCID="FE360D25-5004-40C1-97D5-54A2EED8E675"
local NBWID="42e4aeb1-a230-44f4-b33c-f195bb654931"

Macro{
  id="BD77EA4F-C982-4ADB-BDE9-B4AD257ADC7E";
  area="Shell";
  key="RAltBackSlash";
  description="Show NetBox command panel";
  flags="NoFilePanels";
  condition=function() return APanel.Plugin and win.Uuid(panel.GetPanelInfo(nil, 1).OwnerGuid) == NBWID end;
  action=function() Plugin.Menu(NBID,NBCID) end;
}
