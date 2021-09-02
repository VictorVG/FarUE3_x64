local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {... or _filename,
  name          = "LuaManager macros";
  description   = "Набор макросов и пункт меню плагинов для LuaManager";
  version       = "1.1.0"; --в формате semver: http://semver.org/lang/ru/
  author        = "IgorZ";
  url           = "http://forum.farmanager.com/viewtopic.php?t=7936";
  id            = "2062CE37-181E-4721-95A4-ED1019E61586";
  parent_id     = "180EE412-CBDE-40C7-9AE6-37FC64673CBD";
  minfarversion = {3,0,0,5210,0}; --при несоответствии скрипт завершится
  helptxt       = [[
Имеющиеся макросы:
  - Менеджер Lua/Moon-скриптов;
  - Вставка Lua/Moon-скрипта в редактируемый .Lua/Moon файл;
  - Вставка Lua/Moon-макроса в редактируемый .Lua/Moon файл;
  - Вставка Lua/Moon-обработчика событий в редактируемый .Lua/Moon файл;
  - Вставка Lua/Moon-пункта меню плагинов в редактируемый .Lua/Moon файл;
  - Вставка Lua/Moon-префикса командной строки в редактируемый .Lua/Moon файл;
  - Вставка Lua/Moon-панельного плагина в редактируемый .Lua/Moon файл;
  - Редактирование Lua/Moon-скрипта под курсором;
  - Вставка guid в редактируемый .Lua/Moon файл;
  - Перезагрузка всех скриптов.
Добавляется пункт в меню плагинов.
]];
}
if not nfo then return nfo end
--
local OK_LM,LM = pcall(require,"LuaManager") -- найдём LuaManager
if not OK_LM then far.Message("Cannot find LuaManager module:\n"..LM,nfo.name,";Ok","w") return end -- не нашли - ничего не будет
local PathName = (...):match("^(.*)%.[^%.\\]+$") -- путь и имя без расширения
local LF = loadfile(PathName..Far.GetConfig("Language.Main"):sub(1,3)..".lng") or loadfile(PathName.."Eng.lng") -- функция загрузки языка
local FM,L,G,K = "*.lua,*.moon",(LF and LF()) or {},{ -- файловая маска, языковые данные, guid-ы, клавиши вызова макросов
  UidMacro = "C06F184D-5126-457E-BC61-D2B9163B681D", -- guid макроса генерации и вставки guid-ов
  InsScriptMacro = "7A20FFA3-C3C2-4CD6-A086-70B2D093D56B", -- guid макроса вставки скриптов
  InsMacroMacro = "099E939C-A997-43C6-8542-67CF34DE8C12", -- guid макроса вставки макросов
  InsEventMacro = "1776FD94-AFE8-447B-9E90-6C506C199BAF", -- guid макроса вставки обработчиков событий
  InsMIMacro = "A21C70C7-86B1-4BE0-85B6-868271FD2B38", -- guid макроса вставки пункта меню плагинов
  InsPrefixMacro = "C275B229-75B8-44AA-9615-3DD22DD6CFF8", -- guid макроса вставки префикса командной строки
  InsPanelMacro = "EC6643CD-0B85-4C81-A069-1E089AF3C887", -- guid макроса вставки панельного модуля
  EditScriptMacro = "D403B2B0-0ADB-4100-BCEA-16AD93CBE0E8", -- guid макроса редактирования скрипта под курсором
  MMEMacro = "06C265AA-7147-4007-88DA-379793DEFD5C", -- guid меню макроса менеджера скриптов
  ReloadMacro = "AF149264-4BED-492C-8093-473796CAC60C", -- guid макроса перезагрузки скриптов
  PlugMenu = "151E6FE6-DDB2-4CBD-B2C2-21A8D0E135BD", -- guid меню плагинов
},{
  Manager="AltShiftF11",
  Reload="CtrlF9",
  InsUid="RCtrlU",
  InsScript="LCtrlF11",
  EditScript="CtrlF12",
  InsMacro="RCtrlF11",
  InsEvent="RCtrlF11",
  InsMI="RCtrlF11",
  InsPrefix="RCtrlF11",
  InsPanel="RCtrlF11",
}
-- +
--[==[Макросы]==]
-- -
Macro{
  description=L.Uid; area="Editor"; filemask=FM; key=K.InsUid; id=G.UidMacro; action=LM.InsUid;
}
Macro{
  description=L.Insert; area="Editor"; filemask=FM; key=K.InsScript; id=G.InsScriptMacro; action=function() LM.InsertScript() end;
}
Macro{
  description=L.InsertMacro; area="Editor"; filemask=FM; key=K.InsMacro; id=G.InsMacroMacro; action=function() LM.InsertScript(1) end;
}
Macro{
  description=L.InsertEvent; area="Editor"; filemask=FM; key=K.InsEvent; id=G.InsEventMacro; action=function() LM.InsertScript(2) end;
}
Macro{
  description=L.InsertMI; area="Editor"; filemask=FM; key=K.InsMI; id=G.InsMIMacro; action=function() LM.InsertScript(3) end;
}
Macro{
  description=L.InsertPrefix; area="Editor"; filemask=FM; key=K.InsPrefix; id=G.InsPrefixMacro; action=function() LM.InsertScript(4) end;
}
Macro{
  description=L.InsertPanel; area="Editor"; filemask=FM; key=K.InsPanel; id=G.InsPanelMacro; action=function() LM.InsertScript(5) end;
}
Macro{
  description=L.Edit; area="Editor"; filemask=FM; key=K.EditScript; id=G.EditScriptMacro; action=function() LM.EditScript() end;
}
Macro{
  description=L.Reload; area="Editor"; filemask=FM; key=K.Reload; id=G.ReloadMacro; action=function() LM.Reload() end;
}
Macro{
  description=L.Macro; area="Common"; key=K.Manager; id=G.MMEMacro; action=function() LM.Main() end;
}
-- +
--[==[Пункт меню]==]
-- -
MenuItem{
  description = L.Macro; menu = "Plugins Config"; area = "Common"; guid = G.PlugMenu; text = L.Macro;
  action = function(OpenFrom) if OpenFrom then LM() else LM.Config() end end;
}
