-------------------------------------------------------------------------------
-- Подсказки к файлам (FarHints.dll © Максим Русов). © SimSU, ©VictorVG
--
-- После консультации с shmuel устранён конфликт хоткеев в управлении размером
-- хинта с клавиатуры путём замены Num+/Num- на RAltUp/RAltDown. Иначе выделение
-- файлов и каталогов работает только после гашения хинта - конфликт.
-- Рефакторинг с добавлением функций управления размером подсказки колесом мыши
-- v1.1, Sun Sep 20 18:09:34 +0300 2015 /VictorVG/
-- v1.2, 20.02.2019 07:59:56 +0300 запретим хинт в контекстном меню шелла
-------------------------------------------------------------------------------
local FHID = "CDF48DA0-0334-4169-8453-69048DD3B51C"

if not Plugin.Exist(FHID) then return end

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Plugin_FarHint.cfg
return{
  KeyShow="Alt"; PriorShow=51;
  KeyHide="Alt Esc Apps MsRClick"; PriorHide=51;
  KeyIncrese="RAltUp"; PriorIncrese=51;
  KeyDecrese="RAltDown"; PriorDecrese=51;
  KeyMsIncrese="MsWheelUp"; PriorMsIncrese=51;
  KeyMsDecrese="MsWheelDown"; PriorMsDecrese=51;
}
-- Конец файла Profile\SimSU\Plugin_FarHint.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Plugin_FarHintRussian.lng
return{
  DescrShow="FarHints: показать подсказку (клавиатура)";
  DescrHide="FarHints: скрыть подсказку (клавиатура)";
  DescrIncrese="FarHints: увеличить эскиз (клавиатура)";
  DescrDecrese="FarHints: уменьшить эскиз (клавиатура)";
  DescrMsIncrese="FarHints: увеличить эскиз (колесо мыши)";
  DescrMsDecrese="FarHints: уменьшить эскиз (колесо мыши)";

}
-- Конец файла Profile\SimSU\Plugin_FarHintRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Plugin_FarHintEnglish.lng
return{
   DescrShow = "FarHints: show hint (keyboard)";
   DescrHide = "FarHints: hide hint (keyboard)";
   DescrIncrese = "FarHints: increase thumbnail (keyboard)";
   DescrDecrese = "FarHints: decrees thumbnail (keyboard)";
   DescrMsIncrese = "FarHints: increase thumbnail (mouse wheel)";
   DescrMsDecrese = "FarHints: decrees thumbnail (mouse wheel)";

}
-- End of file Profile\SimSU\Plugin_FarHintEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Plugin_FarHint"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Plugin_FarHint.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Plugin_FarHint.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Plugin_FarHint={}
-------------------------------------------------------------------------------
function SimSU.Plugin_FarHint.Show()
  Plugin.Call(FHID,"Show",2)
end

function SimSU.Plugin_FarHint.Hide()
  Plugin.Call(FHID,"Hide")
end

function SimSU.Plugin_FarHint.Increse()
  Plugin.Call(FHID,"Size",1)
end

function SimSU.Plugin_FarHint.Decrese()
  Plugin.Call(FHID,"Size",-1)
end

function SimSU.Plugin_FarHint.Text(Text,X,Y,Time,Font)
  local Text= Text or ""
  local X= X or -1
  local Y= Y or -1
  local Time= Time and Time*1000 or 3000
  if Font then
    Plugin.Call(FHID,"Info","")
    Plugin.Call(FHID,"FontSize", Font)
  end
  Plugin.Call(FHID,"Info",Text,X,Y,Time)
end

-------------------------------------------------------------------------------
if not Macro then return {Plugin_FarHint=SimSU.Plugin_FarHint} end

local ok, mod = pcall(require,"SimSU.Plugin_FarHint"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Shell Tree"; key=S.KeyShow; priority=S.PriorShow; description=M.DescrShow;
--  condition=function() return Plugin.Exist(FHID) end;
  action=SimSU.Plugin_FarHint.Show;
}

Macro {area="Shell Tree"; key=S.KeyHide; priority=S.PriorHide; description=M.DescrHide;
  condition=function() return win.GetEnv("FarHint")=="1" end;
  action=SimSU.Plugin_FarHint.Hide;
}

Macro {area="Shell Tree"; key=S.KeyIncrese; priority=S.PriorIncrese; description=M.DescrIncrese;
  condition=function() return win.GetEnv("FarHint")=="1" end;
  action=SimSU.Plugin_FarHint.Increse;
}
Macro {area="Shell Tree"; key=S.KeyDecrese; priority=S.PriorDecrese; description=M.DescrDecrese;
  condition=function() return win.GetEnv("FarHint")=="1"  end;
  action=SimSU.Plugin_FarHint.Decrese;
}

-- добавим управление размера подсказки колесом мыши

Macro {area="Shell Tree"; key=S.KeyMsIncrese; priority=S.PriorMsIncrese; description=M.DescrMsIncrese;
  condition=function() return win.GetEnv("FarHint")=="1" end;
  action=SimSU.Plugin_FarHint.Increse;
}

Macro {area="Shell Tree"; key=S.KeyMsDecrese; priority=S.PriorMsDecrese; description=M.DescrMsDecrese;
  condition=function() return win.GetEnv("FarHint")=="1" end;
  action=SimSU.Plugin_FarHint.Decrese;
}