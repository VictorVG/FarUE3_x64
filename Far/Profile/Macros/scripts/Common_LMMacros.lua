local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {... or _filename,
  name          = "LuaManager macros";
  description   = "Набор макросов и пункт меню плагинов для LuaManager";
  version       = "1.0.2"; --в формате semver: http://semver.org/lang/ru/
  author        = "IgorZ";
  url           = "http://forum.farmanager.com/viewtopic.php?t=7936";
  id            = "2062CE37-181E-4721-95A4-ED1019E61586";
  parent_id     = "180EE412-CBDE-40C7-9AE6-37FC64673CBD";
  minfarversion = {3,0,0,4000,0}; --при несоответствии скрипт завершится
  helptxt       = [[
Клавиши вызова макросов по умолчанию:
  AltShiftF11 - Менеджер Lua/Moon-скриптов
  LCtrlF11    - Вставка Lua/Moon-скрипта в редактируемый .Lua/Moon файл
  RCtrlF11    - Вставка Lua/Moon-макроса в редактируемый .Lua/Moon файл;
                Вставка Lua/Moon-обработчика событий в редактируемый .Lua/Moon файл;
                Вставка Lua/Moon-пункта меню плагинов в редактируемый .Lua/Moon файл;
                Вставка Lua/Moon-префикса командной строки в редактируемый .Lua/Moon файл
  CtrlF12     - Редактирование Lua/Moon-скрипта под курсором
  RCtrlU      - Вставка guid в редактируемый .Lua/Moon файл
  CtrlF9      - Перезагрузка всех скриптов
]];
}
if not nfo then return nfo end
--
local OK_LM,LM = pcall(require,"LuaManager") -- найдём LuaManager
if not OK_LM then far.Message("Cannot find LuaManager module ",nfo.name,";Ok","w") return end -- не нашли - ничего не будет
local L,G,K = LM.__MData() -- языковые данные, guid-ы, клавиши вызова
local LMBuild = far.GetPluginInformation(far.FindPlugin(far.Flags.PFM_GUID,G.LuaMacro)).GInfo.Version[4] -- запомним версию LuaMacro
-- +
--[==[Макросы]==]
-- -
Macro{
  description=L.UidDesc; area="Editor"; filemask="*.lua,*.moon"; key=K.InsUid;
  [(LMBuild<579 and "u" or "").."id"]=G.UidMacro; action=LM.InsUid;
}
Macro{
  description=L.InsertDesc; area="Editor"; filemask="*.lua,*.moon"; key=K.InsScript;
  [(LMBuild<579 and "u" or "").."id"]=G.InsScriptMacro; action=LM.InsertScript;
}
Macro{
  description=L.InsertMacroDesc; area="Editor"; filemask="*.lua,*.moon"; key=K.InsMacro;
  [(LMBuild<579 and "u" or "").."id"]=G.InsMacroMacro; action=function() LM.InsertScript(1) end;
}
Macro{
  description=L.InsertEventDesc; area="Editor"; filemask="*.lua,*.moon"; key=K.InsEvent;
  [(LMBuild<579 and "u" or "").."id"]=G.InsEventMacro; action=function() LM.InsertScript(2) end;
}
Macro{
  description=L.InsertMIDesc; area="Editor"; filemask="*.lua,*.moon"; key=K.InsMI;
  [(LMBuild<579 and "u" or "").."id"]=G.InsMIMacro; action=function() LM.InsertScript(3) end;
}
Macro{
  description=L.InsertPrefixDesc; area="Editor"; filemask="*.lua,*.moon"; key=K.InsPrefix;
  [(LMBuild<579 and "u" or "").."id"]=G.InsPrefixMacro; action=function() LM.InsertScript(4) end;
}
Macro{
  description=L.EditDesc; area="Editor"; filemask="*.lua,*.moon"; key=K.EditScript;
  [(LMBuild<579 and "u" or "").."id"]=G.EditScriptMacro; action=LM.EditScript;
}
Macro{
  description=L.ReloadDesc; area="Editor"; filemask="*.lua,*.moon"; key=K.Reload;
  [(LMBuild<579 and "u" or "").."id"]=G.ReloadMacro; action=LM.Reload;
}
Macro{
  description=L.MacroDesc; area="Common"; key=K.Manager;
  [(LMBuild<579 and "u" or "").."id"]=G.MMEMacro; action=LM.Main;
}
-- +
--[==[Пункт меню]==]
-- -
MenuItem{
  description = L.MacroDesc; menu = "Plugins Config"; area = "Common";
  guid = G.PlugMenu; text = function() return L.MacroDesc end;
  action = function(OpenFrom) if OpenFrom then LM() else LM.Config() end end;
}
