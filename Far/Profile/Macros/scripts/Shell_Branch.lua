-- Макрос модифицирован с использованием скрипта сортировки
-- от Alexyz21 http://forum.ru-board.com/topic.cgi?forum=5&topic=48136&start=1200#19
-- из которого выкинута измерительная часть за ненужностью. Он строит на Временной
-- панели Far дерево каталогов и сортирует похожие по именам файлы вместе. Сработает
-- только если не существует плагин TRUE-Branch - так задумано, вызов AltShiftB.
--
-- v1.1
-- Mon May 02 10:56:50 +0300 2016
-- v1.2 - выкинем случайно оставшийся far.FarClock()
-- Mon May 02 11:21:07 +0300 2016
-- v1.3 - подчистим мусор оставив только реально нужное. Поразвлекались и хватит.
-- Mon May 02 13:25:31 +0300 2016
--
local TBID="148FE5E0-7129-4269-B30F-A1A866DD009A"
Macro {
  description="DirTree branch"; flags="EnableOutput";
  area="Shell"; key="AltShiftB";
  id="E567C945-6F38-4517-BCD2-DD2C58EC3618";
  condition=function() if (Plugin.Exist(TBID)~=1) then return true else return false end end;
  action=function()
    Keys"AltF7"
    if not Area.Dialog then return end
    Keys"* Enter"
    local lastitem = Dlg.ItemCount
    local STOP_BUTTON = Dlg.GetValue(lastitem)
    far.Timer(50,function(timer)
      if not Area.Dialog then
        timer:Close()
      elseif Dlg.GetValue(lastitem)~=STOP_BUTTON then
        timer:Close()
        Dlg.SetFocus(lastitem-1)
        far.MacroPost[[Keys ("Enter")]]
      end
    end)
  end;
}