local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {... or _filename,
  name          = "LuaManager macros";
  description   = "Набор макросов и пункт меню плагинов для LuaManager";
  version       = "1.0.7"; --в формате semver: http://semver.org/lang/ru/
  author        = "IgorZ";
  url           = "http://forum.farmanager.com/viewtopic.php?t=7936";
  id            = "2062CE37-181E-4721-95A4-ED1019E61586";
  parent_id     = "180EE412-CBDE-40C7-9AE6-37FC64673CBD";
  minfarversion = {3,0,0,5210,0}; --при несоответствии скрипт завершится
  helptxt       = [[
Клавиши вызова макросов по умолчанию:
  AltShiftF11 - Менеджер Lua/Moon-скриптов
  LCtrlF11    - Вставка Lua/Moon-скрипта в редактируемый .Lua/Moon файл
  RCtrlF11    - Вставка Lua/Moon-макроса в редактируемый .Lua/Moon файл;
                Вставка Lua/Moon-обработчика событий в редактируемый .Lua/Moon файл;
                Вставка Lua/Moon-пункта меню плагинов в редактируемый .Lua/Moon файл;
                Вставка Lua/Moon-префикса командной строки в редактируемый .Lua/Moon файл
                Вставка Lua/Moon-панельного плагина в редактируемый .Lua/Moon файл
  CtrlF12     - Редактирование Lua/Moon-скрипта под курсором
  RCtrlU      - Вставка guid в редактируемый .Lua/Moon файл
  CtrlF9      - Перезагрузка всех скриптов
]];
}
if not nfo then return nfo end
--
local OK_LM,LM = pcall(require,"LuaManager") -- найдём LuaManager
if not OK_LM then far.Message("Cannot find LuaManager module:\n"..LM,nfo.name,";Ok","w") return end -- не нашли - ничего не будет
local FM,L,G,K = "*.lua,*.moon",LM.__MData() -- файловая маска, языковые данные, guid-ы, клавиши вызова
-- +
--[==[Макросы]==]
-- -
Macro{
  description=L.UidDesc; area="Editor"; filemask=FM; key=K.InsUid; id=G.UidMacro; action=LM.InsUid;
}
Macro{
  description=L.InsertDesc; area="Editor"; filemask=FM; key=K.InsScript; id=G.InsScriptMacro; action=function() LM.InsertScript() end;
}
Macro{
  description=L.InsertMacroDesc; area="Editor"; filemask=FM; key=K.InsMacro; id=G.InsMacroMacro; action=function() LM.InsertScript(1) end;
}
Macro{
  description=L.InsertEventDesc; area="Editor"; filemask=FM; key=K.InsEvent; id=G.InsEventMacro; action=function() LM.InsertScript(2) end;
}
Macro{
  description=L.InsertMIDesc; area="Editor"; filemask=FM; key=K.InsMI; id=G.InsMIMacro; action=function() LM.InsertScript(3) end;
}
Macro{
  description=L.InsertPrefixDesc; area="Editor"; filemask=FM; key=K.InsPrefix; id=G.InsPrefixMacro; action=function() LM.InsertScript(4) end;
}
Macro{
  description=L.InsertPanelDesc; area="Editor"; filemask=FM; key=K.InsPanel; id=G.InsPanelMacro; action=function() LM.InsertScript(5) end;
}
Macro{
  description=L.EditDesc; area="Editor"; filemask=FM; key=K.EditScript; id=G.EditScriptMacro; action=function() LM.EditScript() end;
}
Macro{
  description=L.ReloadDesc; area="Editor"; filemask=FM; key=K.Reload; id=G.ReloadMacro; action=function() LM.Reload() end;
}
Macro{
  description=L.MacroDesc; area="Common"; key=K.Manager; id=G.MMEMacro; action=function() LM.Main() end;
}
-- +
--[==[Пункт меню]==]
-- -
MenuItem{
  description = L.MacroDesc; menu = "Plugins Config"; area = "Common"; guid = G.PlugMenu; text = L.MacroDesc;
  action = function(OpenFrom) if OpenFrom then LM() else LM.Config() end end;
}
