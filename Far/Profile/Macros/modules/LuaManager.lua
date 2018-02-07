local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {... or _filename,
  name        = "fake LuaManader";
  description = "Заглушка для модуля 'Менеджер Lua/Moon-скриптов для Fara'";
  author      = "IgorZ";
  id          = "4C8B51D7-CE51-42C0-B169-F2AF76BA3588";
  parent_id   = "180EE412-CBDE-40C7-9AE6-37FC64673CBD";
  helptxt     = [[
Необязательный модуль-заглушка для LuaManager. Если LuaManager не запрашивается как модуль при первичной загрузке скриптов, может быть удалён.
]];
}
if not nfo then return nfo end
--
local function idx(self,key)
return function(...) local fun = rawget(self,key) if fun then fun(...) else far.Message("LuaManager: not loaded yet or bad function name") end end
end
return setmetatable({},{__index=idx; __call=function(self,...) return self.Main(...) end;})
