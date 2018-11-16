-------------------------------------------------------------------------------
--       Получение названия клавиши. © SimSU   Благодарность: Shmuel.
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Common_KeyName.cfg
return{
  Key="Ctrl/"; --Prior=50; --Sort=50; -- Получение названия клавиши.

  Format="%s: %d (0x%X)"; --Формат строки приглашения (до пяти повторений кодов клавишь)
}
-- Конец файла Profile\SimSU\Common_KeyName.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
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

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
S.Format = S.Format==nil and Settings().CmdLinePrefix or S.Format

local function Common_KeyName() -- Получение названия клавиши.
  far.Message(M.Press,"","")
  local VK=mf.waitkey(0,1)
  VK=prompt(M.Name,S.Format:format(M.Code,VK,VK,VK,VK,VK),0x01+0x10,mf.key(VK))
  return VK
end

-------------------------------------------------------------------------------
local function filename() return print(Common_KeyName() or "")   end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Common_KeyName=Common_KeyName} end
SimSU.Common_KeyName=Common_KeyName; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="7c2dcdba-f16b-4933-8b26-ae3e7e94b44a";
  area="Common"; key=S.Key; priority=S.Prior; sortpriority=S.Sort; description=M.Descr;
  action=function() local VK=Common_KeyName(); if VK then print(VK) end end;
}
