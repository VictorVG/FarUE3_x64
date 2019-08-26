-------------------------------------------------------------------------------
--         Выделение файлов мышкой аля проводник. © SimSU
-------------------------------------------------------------------------------
function InAPanel()
  return APanel.Left and Mouse.X<APanel.Width-1 and Mouse.Y>0 and Mouse.Y<APanel.Height-1 or
    not APanel.Left and Mouse.X>APanel.Width and Mouse.X<APanel.Width+PPanel.Width-1 and Mouse.Y>0 and Mouse.Y<APanel.Height-1
end

function InPPanel()
  return APanel.Left and Mouse.X>APanel.Width and Mouse.X<APanel.Width+PPanel.Width-1 and Mouse.Y>0 and Mouse.Y<PPanel.Height-1 or
    not APanel.Left and Mouse.X<PPanel.Width-1 and Mouse.Y>0 and Mouse.Y<PPanel.Height-1
end

Macro {
area="Shell"; key="CtrlMsLClick"; description="Добавить/Убрать из выделенных файлов, аля Explorer. © SimSU";
action = function()
  Keys("MsLClick") if InAPanel or InPPanel then Panel.Select(0,2,1) end
end;
}

Macro {
area="Shell"; key="ShiftMsLClick"; description="Выделение последовательности файлов, аля Explorer. © SimSU";
action = function()
  local CurPos=APanel.CurPos -- Запомним какое было положение курсора.
  Keys("MsLClick") -- Кликнем, чтобы Фар изменил положение курсора.
  if InAPanel then -- Если кликнули в пассивную панель, то ничего больше делать не будем.
    Panel.Select(0,0) -- Полностью снимем выделение.
    for i=CurPos,APanel.CurPos,(CurPos<=APanel.CurPos and 1 or -1) do -- Побежали от бывшего положения к новому положению курсора, вперед(1) или назад(-1) зависит от CurPos и APanel.CurPos.
      Panel.Select(0,1,1,i) -- Выделяем.
    end
  end
end;
}
