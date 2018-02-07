-------------------------------------------------------------------------------
--        Простое импортирование макроса FAR. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_IntegrateMacro.cfg
return{
  Key="F9"; --Prior=50;
}
-- Конец файла Profile\SimSU\Editor_IntegrateMacro.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_IntegrateMacroRussian.lng
return{
  Descr="Простое импортирование макроса FAR. © SimSU";
}
-- Конец файла Profile\SimSU\Editor_IntegrateMacroRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_IntegrateMacroEnglish.lng
return{
  Descr="Easy import macro FAR. © SimSU";
};
-- End of file Profile\SimSU\Editor_IntegrateMacroEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_IntegrateMacro"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_IntegrateMacro.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_IntegrateMacro.cfg") or Settings)()

local SimSU=SimSU or {}
-------------------------------------------------------------------------------
function SimSU.Editor_IntegrateMacro()
  if band(Editor.State,0x8)~=0 then editor.SaveFile() end
  if band(Editor.State,0x1)==0 and band(Editor.State,0x8)==0 then
    local  Func,Err = loadfile(Editor.FileName) --Проверка синтаксиса.
    if Err then msgbox(M.Descr,Err,0x1) else far.MacroLoadAll() end
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Editor_IntegrateMacro=SimSU.Editor_IntegrateMacro} end

local ok, mod = pcall(require,"SimSU.Editor_IntegrateMacro"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro{area="Editor"; filemask="*.lua"; key=S.Key; priority=S.Prior; description=M.Descr;
  action=SimSU.Editor_IntegrateMacro;
}
