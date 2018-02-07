--
-- Копирование/перенос данных скриптов авторства IgorZ в новое место в БД (c) IgorZ
--
-- Командная строка:
--  lua:@LMDataMove.lua - скопировать/перенести данные в новое место
--  lmdatacopymove: - скопировать/перенести данные в новое место; требуется установка в папку скриптов LuaMacro
--
-- История версий
--  2016/05/20 v1.0.0 - Первый релиз.
-- +
--[==[Константы]==]
-- -
local F,Author,Scripts = far.Flags,"IgorZ",{BookmarkManager={"BookmarkManagerData","BookmarkManagerConfig"},CtrlAltMenuDisk={"CASArrowsDiskSwitch"},
                                         EnvManager={"EnvManager"},LuaManager={"LuaManager"}}
--
local function GetTree(obj,id) --[[прочитаем поддерево]]
local list,res = obj:Enum(id),{} -- список элементов поддерева, результат
for _,v in ipairs(list) do -- переберём все
  local item = v.Type==F.FST_SUBKEY and GetTree(obj,obj:OpenSubkey(id,v.Name)) or obj:Get(id,v.Name,v.Type) -- очередной элемент
  res[v.Name] = {name=v.Name,type=v.Type,value=item} -- запишем в таблицу
end
return res -- вернём результат
end
-- 
local function PutElem(obj,key,elem) --[[запишем элемент или поддерево]]
if elem.type==F.FST_SUBKEY then -- таблица?
  key = obj:CreateSubkey(key,elem.name) -- откроем/создадим раздел
  for _,v in pairs(elem.value) do PutElem(obj,key,v) end -- вызовем себя с каждым элементом таблицы
else -- переменная
  obj:Set(key,elem.name,elem.type,elem.value) -- запишем её, если не было иного мнения
end
end
--
local function Main()
for n,t in pairs(Scripts) do
  local move -- признак наличия данных
  for _,psl in ipairs({F.PSL_LOCAL,F.PSL_ROAMING}) do -- для локальных и глобальных настроек
    local obj = far.CreateSettings(nil,psl) -- откроем настройки
    for _,p in ipairs(t) do
      local key = obj:OpenSubkey(0,p) -- раздел
      if key then move = true break end -- есть раздел?
    end
    obj:Free()
  end
  if move then
    local cmd = far.Message("Process "..n.."?","Move script data","Copy;Move;Skip")
    if cmd==1 or cmd==2 then
      for _,psl in ipairs({F.PSL_LOCAL,F.PSL_ROAMING}) do -- для локальных и глобальных настроек
        local obj = far.CreateSettings(nil,psl) -- откроем настройки
        for _,p in ipairs(t) do
          local key = obj:OpenSubkey(0,p) -- раздел
          if key then -- есть раздел?
            local tbl = GetTree(obj,key) -- прочитаем
            if cmd==2 then obj:Delete(key) end -- удалим его
            key = obj:CreateSubkey(obj:CreateSubkey(0,Author),p) -- новое место раздела
            for _,v in pairs(tbl) do PutElem(obj,key,v) end -- запишем
          end
        end
        obj:Free()
      end
    end
  end
end
end
--
if not Macro then Main() return end
--
CommandLine{
  description = "Копирование/перенос данных скриптов авторства IgorZ в новое место в БД";
  prefixes = "lmdatacopymove"; action = Main;
}
