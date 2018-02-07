-- Укажем где искать вспомогательные  модули
package.path = far.PluginStartupInfo().ModuleDir .. "modules\\?.lua;" .. package.path
local main  = require "main"
-- -----------------------------------------------------------------
local mTitle = 0
local F = far.Flags
local M = far.GetMsg

function export.GetPluginInfo()
  return {
    Flags = F.PF_DISABLEPANELS+F.PF_EDITOR,
    PluginMenuGuids   = win.Uuid("8C31052C-ADBE-4254-9B4B-DFDCAA9A42CE"),
    PluginMenuStrings = { M(mTitle) },
  }
end

function export.Open(OpenFrom, Guid, Item)
    main.Open(OpenFrom, Guid, Item)
end
