--[[ ВНИМАНИЕ! Макрос назначен на RAltL чтобы для его вызова хватало
     пальцев одной руки что собственно и было задумано - минимум неудобства,
     максимум  простоты вызова.
     Выбор функции производится в меню - дадим оператору время подумать.

     /VictorVG @ VikSoft.Ru/
--]]

local LFID = "8E11EA75-0303-4374-AC60-D1E38F865449"
Macro {
  description="LuaFAR Search"; area="Shell Editor"; key="RAltL"; action=function()
   Plugin.Menu(LFID)
  end;
}
--[[
  Далее идёт модификация по хоткеям стандартного скрипта из поставки плагина
  которые были подобраны по принципу сохранения возможностей управления Far,
  имеющихся скриптов и плагинов.

     /VictorVG @ VikSoft.Ru/
--]]

local Guid = "8E11EA75-0303-4374-AC60-D1E38F865449"
local function LFS_Editor(...) Plugin.Call(Guid, "own", "editor", ...) end
local function LFS_Panels(...) Plugin.Call(Guid, "own", "panels", ...) end
local function LFS_Exist() return Plugin.Exist(Guid) end

Macro {
  description="LuaFAR Search: Editor Find";
  area="Editor"; key="AltF3"; condition=LFS_Exist;
  action = function() LFS_Editor "search" end
}

Macro {
  description="LuaFAR Search: Editor Replace";
  area="Editor"; key="CtrlF3"; condition=LFS_Exist;
  action = function() LFS_Editor "replace" end
}

Macro {
  description="LuaFAR Search: Editor Repeat";
  area="Editor"; key="AltShiftF3"; condition=LFS_Exist;
  action = function() LFS_Editor "repeat" end
}

Macro {
  description="LuaFAR Search: Editor Repeat reverse";
  area="Editor"; key="CtrlShiftF3"; condition=LFS_Exist;
  action = function() LFS_Editor "repeat_rev" end
}

Macro {
  description="LuaFAR Search: Editor search word";
  area="Editor"; key="AltShift6"; condition=LFS_Exist;
  action = function() LFS_Editor "searchword" end
}

Macro {
  description="LuaFAR Search: Editor search word reverse";
  area="Editor"; key="AltShift5"; condition=LFS_Exist;
  action = function() LFS_Editor "searchword_rev" end
}

-- Uncomment this macro if it is needed.
-- Macro {
--   description="LuaFAR Search: Reset Highlight";
--   area="Editor"; key="Alt7"; condition=LFS_Exist;
--   action = function() LFS_Editor "resethighlight" end
-- }

Macro {
  description="LuaFAR Search: Toggle Highlight";
  area="Editor"; key="Alt7"; condition=LFS_Exist;
  action = function() LFS_Editor "togglehighlight" end
}

Macro {
  description="LuaFAR Search: Editor Multi-line replace";
  area="Editor"; key="AltCtrlF3"; condition=LFS_Exist;
  action = function() LFS_Editor "mreplace" end
}

Macro {
  description="LuaFAR Search: Panel Find";
  area="Shell QView Tree Info"; key="CtrlShiftF"; condition=LFS_Exist;
  action = function() LFS_Panels "search" end
}

Macro {
  description="LuaFAR Search: Panel Replace";
  area="Shell QView Tree Info"; key="CtrlShiftG"; condition=LFS_Exist;
  action = function() LFS_Panels "replace" end
}

Macro {
  description="LuaFAR Search: Panel Grep";
  area="Shell QView Tree Info"; key="CtrlShiftH"; condition=LFS_Exist;
  action = function() LFS_Panels "grep" end
}


Macro {
  description="LuaFAR Search: Panel Rename";
  area="Shell QView Tree Info"; key="CtrlShiftJ"; condition=LFS_Exist;
  action = function() LFS_Panels "rename" end
}

Macro {
  description="LuaFAR Search: Show Panel";
  area="Shell QView Tree Info"; key="CtrlShiftK"; condition=LFS_Exist;
  action = function() LFS_Panels "panel" end
}

Macro {
  description="Jump from Grep results to file and position under cursor";
  area="Editor"; key="CtrlShiftG";
  action=function()
    local lnum = editor.GetString(nil,nil,3):match("^(%d+)[:-]")
    if lnum == nil then return end
    local EI = editor.GetInfo()
    for n = EI.CurLine-1,1,-1 do
      local fname = editor.GetString(nil,n,3):match("^%[%d+%]%s+(.+)")
      if fname then
        editor.Editor(fname,nil,nil,nil,nil,nil,
          {EF_NONMODAL=1,EF_IMMEDIATERETURN=1,EF_ENABLE_F6=1,EF_OPENMODE_USEEXISTING=1},
          lnum, math.max(1, EI.CurPos-lnum:len()-1))
        break
      end
    end
  end;
}
