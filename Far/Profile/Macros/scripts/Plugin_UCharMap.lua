--[[ ВНИМАНИЕ! Правые и левые модификаторы не проверяются для упрощения скрипта
     и улучшения его совместимости с ноутбучными клавиатурами, но вы можете сами
     это сделать назначив макрос к примеру на "CtrlAltH" чтобы для его вызова хватало
     пальцев одной руки что собственно и было задумано - минимум неудобства, максимум
     простоты вызова.

     Идея макроса "Unicode Charmap: show char on cursor" взята из сообщения Max Rusov
     от 14.03.2018 21:11 https://forum.farmanager.com/viewtopic.php?p=148881#p148881 ,
     реализация чуток иная

     v1.1, рефакторинг, макрос "Unicode Charmap: show char on cursor"
     15.03.2018 10:05:28 +0300 /VictorVG @ VikSoft.Ru/
--]]

local UCHID="59223378-9DCD-45FC-97C9-AD0251A3C53F"
local UCHMID="5D95C31A-A452-4EA4-ACC6-8C371F4F1E8F"

Macro {
  id="815BF960-6822-44DC-81C7-FB5D6112117D";
   description="Unicode CharMap";
   area="Shell Editor";
   key="CtrlAltH";
   action=function()
   Plugin.Menu(UCHID,UCHMID)
  end;
}

Macro
{
  id="73B9D4EE-8F41-43BF-B0CE-9132DAD6CC35";
  description="Unicode Charmap: show char on cursor";
  area="Editor";
  key="CtrlP";
  action=function()
    local char = Editor.Value:sub(Editor.CurPos,Editor.CurPos)
    Plugin.Menu(UCHID)
    Keys(char)
  end;
}