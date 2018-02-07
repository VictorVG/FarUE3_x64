--[[
   Удаление временных файлов *.tmp, *.~tmp,*.tmp~,*.temp, *.tmp.cpp, *.tmp.hpp
   *.log, *.dir на активной панели. В основе лежит скрипт Shell_DelBak.lua © SimSU
   адаптированный под новые задачи VictorVG после консультации с shmuel

   Внимание! Файлы удаляются минуя Корзину т.к. скрипт изначально предназначен
   для чистки мусора, а удаляемые им временные файлы собственно и есть мусор.
--]]

local function Settings()

return{
  Key="AltT";

  Mask="/.+\\.(tmp|temp|(~|\\s?)tmp(~|\\s?)|log|dir|xml|c|h|(c|h)pp|txt|tmp\\.(\\w?|\\s?|(c|h)pp|c|h|rc))$/i";
}

end

_G.far.lang=far.lang or win.GetEnv("farlang")

local function Messages()
if far.lang=="Russian" then

return{
  Descr="Удаление временных файлов.";
  Title="Удаление временных файлов";
  Question="Вы хотите удалить (%d шт.) временных файлов?";
}

else

return{
  Descr="Delete temporary files.";
  Title="Delete temporary files";
  Question="You want to remove (%d units) temporary files?";
}

end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\Scripts\\Shell_DelTmp"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\Scripts\\Shell_DelTmp.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\Scripts\\Shell_DelTmp.cfg") or Settings)()

local SimSU=SimSU or {}

local Mask=Mask or "/.+\\.(tmp|temp|(~|\\s?)tmp(~|\\s?)|log|dir|xml|c|h|(c|h)pp|txt|tmp\\.(\\w?|\\s?|(c|h)pp|c|h|rc))$/i"

function SimSU.Shell_DelTmp()
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
  Panel.Select(0);Panel.Select(0,1,3,Mask)
  if APanel.Selected and msgbox(M.Title,M.Question:format(APanel.SelCount),0x20000)==1 then
    Keys("ShiftDel Enter")
  end
  far.Timer(100, function(h) if Area.Shell then h:Close(); _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel) end end)
end

if not Macro then return {Shell_DelTmp=SimSU.Shell_DelTmp} end

local ok, mod = pcall(require,"SimSU.Shell_DelTmp"); if ok then SimSU=mod else _G.SimSU=SimSU end
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end

Macro {area="Shell"; key=S.Key; priority=S.Prior; description=M.Descr;
  action=SimSU.Shell_DelTmp;
}
