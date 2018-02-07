--[[
  This is hot-filx for Disks menu for restore panel item works
  using Mouse Wheel Click or Msouse Left Click on selected item.
  This Far.exe bug is found build's after 2798+, 4063+ ...

  Это исправление для дискового меню Far3 восстанавливает работу
  дискового меню при нажатии левой кнопки или колеса мыши на его
  элементе. Ошибка Far.exe была обнаружена в билдах после 2798+, 4063+ ...

  VictorVG @ VikSoft.Ru, Wed Sep 17 04:17:04 +0400 2014
--]]

Macro {
   area="Disks"; key="MsLClick MsWheelClick MsM1Click MsM2Click"; description="MsLeft or MsWheel click disk select"; action = function()
     Keys('Enter')
  end;
}