--[[
     True Branch r1.0 - скрипт работает с двумя плагинами True-BRANCH v3.0.0.16
     и выше написанным Александром Назаренко и стандартным TmpPanel из дистрибутива
     Far3 посему как минимум один из них должен у вас присутствовать или скрипт не
     станет работать. Особых хитростей в нё нет, за локализацию спасибо SimSU,
     а код специально написан максимально просто чтобы не мог дров наломать.

     ВНИМАНИЕ! Правые и левые модификаторы не проверяются для упрощения скрипта
     и улучшения его совместимости с ноутбучными клавиатурами, но вы можете сами
     это сделать назначив макрос к примеру на "RCtrlRAltB" чтобы для его вызова хватало
     пальцев одной руки что собственно и было задумано - минимум неудобства, максимум
     простоты вызова. /VictorVG @ VikSoft.Ru/
--]]
local TBID="148FE5E0-7129-4269-B30F-A1A866DD009A"
local TMPID="B77C964B-E31E-4d4c-8FE5-D6B0C6853E7C"
local TMPCMD="<dir /b /s /a-d"

_G.far.lang=far.lang or win.GetEnv("farlang")
local function Messages()
if far.lang=="Russian" then
return{
  Descr="Ветвь папки";
}
else
return{
  Descr="True Branch";
}
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\Script\\Plugin_TrueBranch"..far.lang..".lng") or Messages)()

Macro {area="Shell MainMenu UserMenu"; key="CtrlAltB"; description=M.Descr;
action=function()
if not Plugin.Exist(TBID) then Plugin.Command(TMPID,TMPCMD) else Plugin.Menu(TBID,TBMID) end end;
}