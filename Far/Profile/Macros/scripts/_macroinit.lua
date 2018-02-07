local STP = require "StackTracePlus"
debug.traceback = function(...) return STP.stacktrace(...):gsub("\r\n","\n") end

------------------------
-- English
------------------------

-- add this command to your _macroinit.lua
require"rebind"

-- it's possible to set some options
-- or/and load custom bindigs from file (default: "bindings")
local rebind = require"rebind"
if rebind then
  rebind.Setup {auto_uids=true,no_warnings=true}
  rebind.LoadBindings()
end

------------------------
-- Russian
------------------------

local rebind = require"rebind"
if type(rebind)=="table" then
  rebind.Setup {auto_uids=true,no_warnings=true} -- опционально: разрешаем автоназначение идентификаторов, без вывода ошибок
  rebind.LoadBindings()                          -- опционально: загружаем настройки из файла "bindings"
end
