-------------------------------------------------------------------------------
-- Удаление резервных и временных файлов. © SimSU
-------------------------------------------------------------------------------
-- Мелкий рефакторинг VictorVG, 16.11.2018 04:40:47 +0300
---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_DelBak.cfg
return{
  {id="23264cfd-e9a7-4acd-8c23-5136ce32a33a";
  Key="AltB"; --Prior=50; --Sort=50;
  Mask="/.+\\.(bak\\d*)$/i"; -- Маска для старых файлов (регулярное выражение).
  };
  {id="c7eda6df-3e65-4eec-b50a-7bc6d4dd8ce1";
  Key="AltT"; --Prior=50;  --Sort=50;
  Mask="/.+\\.(tmp|temp|(~\\w?|\\s?)tmp(~|\\s?)|\\w?log|dir|xml|c|h|(c|h)pp|txt|(h|i)\\.(\\w?|\\s?|(c|h)pp|c|h|rc))$/i"; -- Маска для временных файлов (регулярное выражение).
  };
}
-- Конец файла Profile\SimSU\Shell_DelBak.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
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

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local Mask="/.+\\.(bak\\d*)$/i"
local _
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end

local function Shell_DelBak(mask)
  mask = mask or Mask
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel)
  Panel.Select(0); Panel.Select(0,1,3,mask) -- Выделяем по маске bak файлы.
  if APanel.Selected and msgbox(M.Title,M.Question:format(APanel.SelCount),0x20000)==1 then
    Keys("ShiftDel Enter")
  end
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.RestoreLater and SimSU.Shell_RememberSelected.RestoreLater(APanel)
  return true
end
-------------------------------------------------------------------------------
local function filename() return Shell_DelBak() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Shell_DelBak=Shell_DelBak} end
SimSU.Shell_DelBak=Shell_DelBak; _G.SimSU=SimSU
-------------------------------------------------------------------------------
for i=1,#S do
  Macro {id=S[i].id;
    area="Shell"; key=S[i].Key; priority=S[i].Prior; sortpriority=S[i].Sort; description=M.Descr;
    action=function() SimSU.Shell_DelBak(S[i].Mask) end;
  }
end
