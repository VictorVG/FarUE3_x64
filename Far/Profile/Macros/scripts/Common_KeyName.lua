-------------------------------------------------------------------------------
--       Получение названия клавиши. © SimSU   Благодарность: Shmuel.
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Common_KeyName.cfg
return{
  Key="Ctrl/"; --Prior=50; -- Получение названия клавиши.
}
-- Конец файла Profile\SimSU\Common_KeyName.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\SimSU\Common_KeyNameRussian.lng
return{
  Descr="Получение названия клавиши. © SimSU";
  Press=" Нажмите клавишу... ";
  Name="Название клавиши";
  Code="Код клавиши";
}
-- Конец файла Profile\SimSU\Common_KeyNameRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Common_KeyNameEnglish.lng
return{
  Descr="Get name of key. © SimSU";
  Press=" Press key... ";
  Name="Key name";
  Code="Key code";
}
-- End of file Profile\SimSU\Common_KeyNameEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Common_KeyName"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Common_KeyName.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Common_KeyName.cfg") or Settings)()

local SimSU=SimSU or {}
-------------------------------------------------------------------------------
function SimSU.Common_KeyName() -- Получение названия клавиши.
  far.Message(M.Press,"","")
  local VK=mf.waitkey(0,1)
  VK=prompt(M.Name,("%s: %d (0x%X)"):format(M.Code,VK,VK),0x01+0x10,mf.key(VK))
  return VK
end
-------------------------------------------------------------------------------
if not Macro then return {Common_KeyName=SimSU.Common_KeyName} end
local ok, mod = pcall(require,"SimSU.Common_KeyName"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Common"; key=S.Key; priority=S.Prior; description=M.Descr;
  action=function() local VK=SimSU.Common_KeyName(); if VK then print(VK) end end;
}
