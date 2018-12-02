local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {
  name        = "fake DBEdit";
  description = "Заглушка для модуля 'Импорт/экспорт/редактирование данных плагинов'";
  author      = "IgorZ";
  id          = "EE4CF295-4E60-4732-A39C-D602AC8DA052";
  parent_id   = "51465236-592A-4C28-A047-929FCBFD8672";
  helptxt     = [[
Необязательный модуль-заглушка для DBEdit. Если DBEdit не запрашивается как модуль при первичной загрузке скриптов, может быть удалён.
]];
}
if not nfo then return nfo end
--
local function idx(self,key)
return function(...) local fun = rawget(self,key) if fun then fun(...) else far.Message("DBEdit: not loaded yet or bad function name") end end
end
return setmetatable({},{__index=idx; __call=function(self,...) return self.Main(...) end;})
