--[[
   ВНИМАНИЕ!

   Сетевые переходы вида "//СЕРВЕР\шара" -> "//СЕРВЕР /" не поддерживаются в ОС
   семейства Windows и в пакете Samba под ОС UNIX/LINUX !

   Если вам необходим такой переход, то осуществите его вручную или это приведёт к ошибке!

   WARNING!

   Network transitions of the form "//SERVER/share" -> "//SERVER /" is not supported in OS
   family of Windows and Samba package for OS UNIX/LINUX!

   If you need such a transition, then implement it manually or it will fail!

--]]

local function FillTable(t, path)
  while true do
    path = path:match("(.*)\\[^\\]+$")
    if path==nil then break end
    t[#t+1] = {path=path.."\\"}
  end
end

local function ShowMenu()
  local items = {}
  if APanel.Plugin then
    FillTable(items, APanel.Path)
    if items[1] then items[#items+1] = { separator=true } end
    items[#items+1] = { path=APanel.Path0 }
  end
  FillTable(items, APanel.Path0)
  if items[1] then
    for k,v in ipairs(items) do
      if v.path then
        local extra = v.path:len() - Far.Width + 8
        v.text = extra<=0 and v.path or "..."..v.path:sub(extra+4)
      end
    end
    local item = far.Menu({Title="Go to ..."}, items)
    if item then Panel.SetPath(0, item.path) end
  end
end

Macro {
  description="Menu with list of parent directories (CD up)";
  area="Shell"; key="CtrlShiftA";
  condition=function() return CmdLine.Empty and APanel.Visible end;
  action=ShowMenu;
}