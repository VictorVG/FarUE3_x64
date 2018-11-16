-------------------------------------------------------------------------------
--     Назад/вперед по папкам используя историю. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_HistoryPath.cfg
return{
  KeyBack    ="AltBS"  ; --SortBack   =50;  --PriorBack   =50;
  KeyForward ="ShiftBS"; --SortForward=50;  --PriorForward=50;
}
-- Конец файла Profile\SimSU\Shell_HistoryPath.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_HistoryPathRussian.lng
return{
  DescrBack="Возврат в предыдущую папку. © SimSU";
  DescrForward="Отмена возврата в предыдущую папку. © SimSU";
}
-- Конец файла Profile\SimSU\Shell_HistoryPathRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_HistoryPathEnglish.lng
return{
  DescrBack="Возврат в предыдущую папку. © SimSU";
  DescrForward="Отмена возврата в предыдущую папку. © SimSU";
}
-- End of file Profile\SimSU\Shell_HistoryPathEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_HistoryPath"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_HistoryPath.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_HistoryPath.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local _
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end

local function Backward()
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel);
  Keys("AltF12")
  if Object.ItemCount==0 or (Object.ItemCount~=1 and Object.CurPos==1) then -- Некуда возвращаться.
    mf.beep(0x30); Keys("Esc")
  else
    if Object.CurPos == Object.ItemCount then
      Keys("Enter") -- Перешли и занесли текущую позицию в историю.
      Keys("AltF12 Up ShiftEnter") -- Сменили положение в истории.
    else
      Keys("Up ShiftEnter") -- Перешли и сменили положение в истории.
    end
  end
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.RestoreLater and SimSU.Shell_RememberSelected.RestoreLater(APanel)
  return true
end

local function Forward()
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel); Panel.Select(0)
  Keys("AltF12")
  if Object.ItemCount==0 or Object.CurPos==Object.ItemCount then -- Некуда переходить.
    mf.beep(0x30); Keys("Esc")
  else
    Keys("Down ShiftEnter") -- Перешли и сменили положение в истории.
  end
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.RestoreLater and SimSU.Shell_RememberSelected.RestoreLater(APanel)
  return true
end

-------------------------------------------------------------------------------
local Shell_HistoryPath={
  Back    = Back   ;
  Forward = Forward;
}
local function filename() return Back() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Shell_HistoryPath=Shell_HistoryPath} end
SimSU.Shell_HistoryPath=Shell_HistoryPath; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="2453f255-aae4-4414-9190-1d37a74c6ff1";
  area="Shell"; key=S.KeyBack;    priority=S.PriorBack;    sortpriority=S.SortBack;    description=M.DescrBack;
  action=Backward;
}
Macro {id="81c14ac1-83eb-4107-acbe-01f60f789d53";
  area="Shell"; key=S.KeyForward; priority=S.PriorForward; sortpriority=S.SortForward; description=M.DescrForward;
  action=Forward;
}
