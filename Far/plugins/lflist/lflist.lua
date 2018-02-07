-- Укажем где искать вспомогательные  модули
package.path = far.PluginStartupInfo().ModuleDir .. "modules\\?.lua;" .. package.path
local main=require "main"
local mTitle = 0
local F = far.Flags
local M = far.GetMsg

local myGuid = win.Uuid("5BC883B2-3FED-4960-8DAD-58E748176967")

function export.GetPluginInfo()
  return {
    Flags = F.PF_NONE,
    PluginMenuGuids   = myGuid.."",
    PluginMenuStrings = { M(mTitle) },
  }
end

function export.Open(OpenFrom, Guid, Item)
    main.Open(OpenFrom, Guid, Item)
end
