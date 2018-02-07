-------------------------------------------------------------------------------
--     Назад/вперед по папкам используя историю. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_HistoryPath.cfg
return{
  KeyBack ="AltBS"; --PriorBack=50;
  KeyForward ="ShiftBS"; --PriorForward=50;
}
-- Конец файла Profile\SimSU\Shell_HistoryPath.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
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

-------------------------------------------------------------------------------
local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_HistoryPath"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_HistoryPath.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_HistoryPath.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Shell_HistoryPath={}
-------------------------------------------------------------------------------
function SimSU.Shell_HistoryPath.Back()
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
  far.Timer(100, function(h) if Area.Shell then h:Close(); _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel) end end)
--  while not Area.Shell do mmode(1,mmode(1,0),Keys(mf.waitkey(100))) end -- Вопросы...
--  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel)
end

function SimSU.Shell_HistoryPath.Forward()
  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Save and SimSU.Shell_RememberSelected.Save(APanel); Panel.Select(0)
  Keys("AltF12")
  if Object.ItemCount==0 or Object.CurPos==Object.ItemCount then -- Некуда переходить.
    mf.beep(0x30); Keys("Esc")
  else
    Keys("Down ShiftEnter") -- Перешли и сменили положение в истории.
  end
  far.Timer(100, function(h) if Area.Shell then h:Close(); _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel) end end)
--  while not Area.Shell do mmode(1,mmode(1,0),Keys(mf.waitkey(100))) end -- Вопросы...
--  _ = SimSU.Shell_RememberSelected and SimSU.Shell_RememberSelected.Restore and SimSU.Shell_RememberSelected.Restore(APanel)
end

-------------------------------------------------------------------------------
if not Macro then return {Shell_HistoryPath=SimSU.Shell_HistoryPath} end

local ok, mod = pcall(require,"SimSU.Shell_HistoryPath"); if ok then SimSU=mod else _G.SimSU=SimSU end
local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU.Shell_RememberSelected=mod.Shell_RememberSelected end
-------------------------------------------------------------------------------

Macro {area="Shell"; key=S.KeyBack; priority=S.PriorBack; description=M.DescrBack;
  action=SimSU.Shell_HistoryPath.Back;
}
Macro {area="Shell"; key=S.KeyForward; priority=S.PriorForward; description=M.DescrForward;
  action=SimSU.Shell_HistoryPath.Forward;
}
