-------------------------------------------------------------------------------
--             Список завершения LuaMacro. © SimSU
-------------------------------------------------------------------------------
Macro {
area="Editor"; key="ShiftSpace"; description="Список завершения LuaMacro. © SimSU";
condition=function() return editor.GetInfo(nil).FileName:lower():find("%.lua$") end;
action = function()
  local InitPos=Editor.RealPos
  local s=Editor.Value
  local End=InitPos while s:sub(End,End):find("[a-zA-Z_0-9]") do End=End+1 end -- Ищем конец слова c курсором.
  local Beg=InitPos while s:sub(Beg-1,Beg-1):find("[a-zA-Z_0-9]") do Beg=Beg-1 end -- Ищем начало слова c курсором.
  -- Выделяем найденное слово, если слово не нашли, то выделение просто снимется из-за равенства Beg и End.
  Editor.Pos(1,2,Beg) Editor.Sel(2,0)
  Editor.Pos(1,2,End) Editor.Sel(2,1)
  Editor.Pos(1,2,InitPos)
  -- Если перед словом стоит точка, будем искать таблицы.
  local Table={} local i=Beg local EndTable
  while i>2 and s:sub(i-2,i-1):find("[a-zA-Z_0-9]%.") do -- Собираем цепочку таблиц. Типа _G._G. ... APanel.
    EndTable=i i=i-1
    while s:sub(i-1,i-1):find("[a-zA-Z_0-9]") do i=i-1 end
    Table[#Table+1]= i~=EndTable and s:sub(i,EndTable-2) or nil
  end
  -- Ищем таблицу
  local CurTable=_G
  for i=#Table,1,-1 do
    local ExistProp=false for k in pairs(CurTable) do if k==Table[i] then ExistProp=true break end end -- type(Area.["dd"]) вызывает ошибку вместо возвращения "nil".
    if ExistProp and type(CurTable[Table[i]])=="table" then
      CurTable=CurTable[Table[i]]
    else
      CurTable=nil break
    end
  end
  -- Строим список вариантов.
  local Items={}
  if type(CurTable)=="table" then
    for k in pairs(CurTable) do
      local t=type(CurTable[k])
      if t=="table" then Items[#Items+1]=k.."."
      elseif t=="function" then Items[#Items+1]=k.."()"
      else Items[#Items+1]=k
      end
    end
    if CurTable==_G then
      Items[#Items+1]="if then elseif then else end"
      Items[#Items+1]="for in do end"
      Items[#Items+1]="while do end"
      Items[#Items+1]="repeat until "
    end
    if type(CurTable.properties)=="table" then
      for k in pairs(CurTable.properties) do
        Items[#Items+1]=k
      end
    end
  end
  Items=table.concat(Items,"\n")
  -- Выводим меню
  local Selected=Menu.Show(Items,nil,0x3+0x20+0x100,Editor.SelValue)
  -- Обрабатываем выбор
  if Selected~="" then
    Editor.Undo(0)
    Keys("CtrlD") print(Selected)
    Editor.Undo(1)
  else
    Editor.Sel(4)
  end
end;
}
