-------------------------------------------------------------------------------
-- Удаление резервных временных файлов. © SimSU
-- Скрипт модифицирван - резервные файлы удаляются минуя Корзину!
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_DelBak.cfg
return{
  Key="AltB"; --Prior=50;

  Mask="/.+\\.(bak\\d*)$/i"; -- Маска для старых файлов (регулярное выражение).
}
-- Конец файла Profile\SimSU\Shell_DelBak.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_DelBakRussian.lng
return{
  Descr="Удаление резервных и временных файлов. © SimSU";
  Title="Удаление резервных и временных файлов";
  Question="Вы хотите удалить все (%d шт.) файлов?";
}
-- Конец файла Profile\SimSU\Shell_DelBakRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_DelBakEnglish.lng
return{
  Descr="Removal of backup and temporary files. © SimSU";
  Title="Removal of backup and temporary files";
  Question="You want to remove all (%d units) files?";
}
-- End of file Profile\SimSU\Shell_DelBakEnglish.lng
end end

-------------------------------------------------------------------------------
local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_DelBak"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_DelBak.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_DelBak.cfg") or Settings)()

local SimSU=SimSU or {}
-------------------------------------------------------------------------------
local Mask=S.Mask or "/.+\\.(bak\\d*)$/i"

function SimSU.Shell_DelBak(mask)
  local mask = mask or Mask
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
  Panel.Select(0); Panel.Select(0,1,3,mask) -- Выделяем по маске bak файлы.
  if APanel.Selected and msgbox(M.Title,M.Question:format(APanel.SelCount),0x20000)==1 then
    Keys("ShiftDel Enter") --if Area.Dialog then Keys("Enter") end -- Удаляем, при подтверждении говорим 'Ок'.
--1    while not Area.Shell do mmode(1,mmode(1,0),Keys(mf.waitkey(100))) end -- Вопросы...
  end
  far.Timer(100, function(h) if Area.Shell then h:Close(); _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel) end end)
--1  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel)
end
-------------------------------------------------------------------------------
if not Macro then return {Shell_DelBak=SimSU.Shell_DelBak} end

local ok, mod = pcall(require,"SimSU.Shell_DelBak"); if ok then SimSU=mod else _G.SimSU=SimSU end
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end
-------------------------------------------------------------------------------

Macro {area="Shell"; key=S.Key; priority=S.Prior; description=M.Descr;
  action=SimSU.Shell_DelBak;
}
