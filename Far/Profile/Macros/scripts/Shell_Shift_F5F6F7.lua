local far,F,msg = far,far.Flags,far.SendDlgMessage
------------------------------------------------------------------------------
-- Расширение возможностей копирования, переноса и создания папок. © SimSU
-- версия от 06.09.2015
--
-- Изменения и исправления:
--
-- исправлен баг с вызовом SimSU.Shell_Shift_F5F6F7.MkDir() на временной панели
-- за подсказку спасибо Shmuel. Баг существовал с версии скрипта от 21.07.2013.
-- закомментированы макросы для F5 и F6 ибо вечно чудят создавая ошибочную
-- рекурсию каталогов при операциях COPY/MOVE.
-- /авторы изменений и исправлений VictorVG и Shmuel/
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_Shift_F5F6F7.cfg
return{
  KeyCopy="F5"; --PriorCopy=50;
  KeyMove="F6"; --PriorMove=50;
  KeyMkDir="F7"; --PriorMkDir=50;
  KeyDuplicate="ShiftF5"; --PriorDuplicate=50;
  KeyRename="ShiftF6"; --PriorRename=50;
  KeyNameDir="ShiftF7"; --PriorNameDir=50;

  NameFormat="%Y_%m_%d";

  DisableHistory=true; --ProirDisableHistory=50;
}
-- Конец файла Profile\SimSU\Shell_Shift_F5F6F7.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_Shift_F5F6F7Russian.lng
return{
  DescrCopy="Копирование с возможностью изменения имени. © SimSU";
  DescrMove="Перемещение с возможностью изменения имени. © SimSU";
  DescrMkDir="Создание папки с именем = текущая дата. © SimSU";
  DescrDuplicate="Дублирование с сохранением расширения. © SimSU";
  DescrRename="Переименование с сохранением расширения. © SimSU";
  DescrNameDir="Создание папки на пассивной с именем как у файла под курсором. © SimSU";
  DescrDisableHistory="Не сохранять в истории созданные макросом значения. © SimSU";
}
-- Конец файла Profile\SimSU\Shell_Shift_F5F6F7Russian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_Shift_F5F6F7English.lng
return{
  DescrCopy="Копирование с возможностью изменения имени. © SimSU";
  DescrMove="Перемещение с возможностью изменения имени. © SimSU";
  DescrMkDir="Создание папки с именем = текущая дата. © SimSU";
  DescrDuplicate="Дублирование с сохранением расширения. © SimSU";
  DescrRename="Переименование с сохранением расширения. © SimSU";
  DescrNameDir="Создание папки на пассивной с именем как у файла под курсором. © SimSU";
  DescrDisableHistory="Не сохранять в истории созданные макросом значения. © SimSU";
}
-- End of file Profile\SimSU\Shell_Shift_F5F6F7English.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_Shift_F5F6F7"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_Shift_F5F6F7.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_Shift_F5F6F7.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Shell_Shift_F5F6F7={}
-------------------------------------------------------------------------------
S.NameFormat= S.NameFormat or "%Y_%m_%d"
local Hdlg,Id
local _

function SimSU.Shell_Shift_F5F6F7.CopyMove(Key)
  Key=Key or "F5"
  if APanel.SelCount<2 and APanel.Path~=PPanel.Path and PPanel.Visible and PPanel.Type==0 and not APanel.Bof then
    Keys(Key.." End")
    local CP=Dlg.GetValue(-1,0):len()
    print(panel.GetSelectedPanelItem(nil,1,1).FileName)
    Keys("Home") for _=1,CP do Keys("Right") end
    Keys("ShiftEnd") if mf.fsplit(Dlg.GetValue(-1,0),0x8)~="" then Keys("CtrlShiftLeft ShiftLeft") end -- Выделяем только имя файла
  else
    Keys(Key)
  end
  return true
end

function SimSU.Shell_Shift_F5F6F7.MkDir()
  Keys("F7")--; print(os.date(NameFormat)); Keys("Home ShiftEnd")
    Hdlg=far.AdvControl(F.ACTL_GETWINDOWINFO).Id
    Id=msg(Hdlg,F.DM_GETFOCUS)
    msg(Hdlg,F.DM_SETTEXT,Id,os.date(S.NameFormat))
    local Value=msg(Hdlg,F.DM_GETTEXT,Id,os.date(S.NameFormat))
    msg(Hdlg,F.DM_EDITUNCHANGEDFLAG,Id,1)
  return Value
end

function SimSU.Shell_Shift_F5F6F7.DupRen(Key)
  Key=Key or "ShiftF5"
  Keys(Key)
  if mf.fsplit(Dlg.GetValue(-1,0),0x8)~="" then
    Keys("Home ShiftEnd CtrlShiftLeft ShiftLeft")
  end
  return true
end

function SimSU.Shell_Shift_F5F6F7.NameDir()
  local path=PPanel.Path.."\\"..mf.fsplit(APanel.Current,0x4)
  win.CreateDir(path)
  Panel.SetPath(1,path)
  return true
end

--function SimSU.Shell_Shift_F5F6F7.DisableHistory(Event,Param)
--  local tId=msg(Hdlg,F.DM_GETFOCUS)
--  if Id==tId then
--    local tValue=msg(Hdlg,F.DM_GETTEXT,Id,os.date(NameFormat))
--    if Value==tValue then
--      local item = far.GetDlgItem(Hdlg,Id)
--      item[9] = bor(item[9],F.DIF_MANUALADDHISTORY)
--      item = far.SetDlgItem(Hdlg,Id,item)
----      Far.DisableHistory(-1)
--    end
--  end
--  return true
--end

-------------------------------------------------------------------------------
if not Macro then return {Shell_Shift_F5F6F7=SimSU.Shell_Shift_F5F6F7} end

local ok, mod = pcall(require,"SimSU.Shell_Shift_F5F6F7"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------
--[[
Macro {area="Shell Tree Search"; key=S.KeyCopy; priority=S.PriorCopy; description=M.DescrCopy; flags="NoPluginPanels NoPluginPPanels";
  action=function()  SimSU.Shell_Shift_F5F6F7.CopyMove("F5") end;
}
Macro {area="Shell Tree Search"; key=S.KeyMove; priority=S.PriorMove; description=M.DescrMove; flags="NoPluginPanels NoPluginPPanels";
  action=function()  SimSU.Shell_Shift_F5F6F7.CopyMove("F6") end;
}
--]]
Macro {area="Shell Tree Search"; key=S.KeyMkDir; priority=S.PriorMkDir; description=M.DescrMkDir; flags="NoPluginPanels";
  action=SimSU.Shell_Shift_F5F6F7.MkDir;
}
Macro {area="Shell Tree Search"; key=S.KeyDuplicate; priority=S.PriorDuplicate; description=M.DescrDuplicate; flags="NoPluginPanels";
  action=function()  SimSU.Shell_Shift_F5F6F7.DupRen("ShiftF5") end;
}
Macro {area="Shell Tree Search"; key=S.KeyRename; priority=S.PriorRename; description=M.DescrRename; flags="NoPluginPanels";
  action=function()  SimSU.Shell_Shift_F5F6F7.DupRen("ShiftF6") end;
}
Macro {area="Shell Tree Search"; key=S.KeyNameDir; priority=S.PriorNameDir; description=M.DescrNameDir; flags="NoPluginPanels";
  action=SimSU.Shell_Shift_F5F6F7.NameDir;
}

--Event {group="DialogEvent"; priority=S.ProirDisableHistory; description=M.DescrDisableHistory;
--  condition=function(Event,Param) return S.DisableHistory==true and Event==F.DE_DLGPROCINIT and Param.Msg==F.DN_CLOSE and Param.Param1>1 and Hdlg==far.AdvControl(F.ACTL_GETWINDOWINFO).Id end;
--  action=SimSU.Shell_Shift_F5F6F7.DisableHistory;
--}
