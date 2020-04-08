------------------------------------------------------------------------------
-- Расширение возможностей копирования, переноса и создания папок. © SimSU
-------------------------------------------------------------------------------
local win,far,F,msg = win,far,far.Flags,far.SendDlgMessage

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_Shift_F5F6F7.cfg
return{
  KeyCopy     ="F5";      --PriorCopy=50;       --SortCopy=50;
  KeyMove     ="F6";      --PriorMove=50;       --SortMove=50;
  KeyMkDir    ="F7";      --PriorMkDir=50;      --SortMkDir=50;
  KeyDuplicate="ShiftF5"; --PriorDuplicate=50;  --SortDuplicate=50;
  KeyRename   ="ShiftF6"; --PriorRename=50;     --SortRename=50;
  KeyNameDir  ="ShiftF7"; --PriorNameDir=50;    --SortNameDir=50;

  NameFormat="%Y_%m_%d";

  DisableHistory=true; --ProirDisableHistory=50;
}
-- Конец файла Profile\SimSU\Shell_Shift_F5F6F7.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
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

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
S.NameFormat = S.NameFormat==nil and Settings().NameFormat or S.NameFormat

local _

local function CopyMove(Key)
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

local function MkDir()
  Keys("F7")--; print(os.date(NameFormat)); Keys("Home ShiftEnd")
    local Hdlg=far.AdvControl(F.ACTL_GETWINDOWINFO).Id
    local Id=msg(Hdlg,F.DM_GETFOCUS)
    msg(Hdlg,F.DM_SETTEXT,Id,os.date(S.NameFormat))
    local Value=msg(Hdlg,F.DM_GETTEXT,Id,os.date(S.NameFormat))
    msg(Hdlg,F.DM_EDITUNCHANGEDFLAG,Id,1)
  return Value
end

local function DupRen(Key)
  Key=Key or "ShiftF5"
  Keys(Key)
  if mf.fsplit(Dlg.GetValue(-1,0),0x8)~="" then Keys("Home ShiftEnd CtrlShiftLeft ShiftLeft") end
  return true
end

local function NameDir()
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
local Shell_Shift_F5F6F7={
  CopyMove = CopyMove;
  MkDir    = MkDir   ;
  DupRen   = DupRen  ;
  NameDir  = NameDir ;
}
local function filename() return MkDir() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Shell_Shift_F5F6F7=Shell_Shift_F5F6F7} end
SimSU.Shell_Shift_F5F6F7=Shell_Shift_F5F6F7; _G.SimSU=SimSU
-------------------------------------------------------------------------------

-- Macro {id="1d93d055-e220-4b6b-aa73-2783b2c16947";
--   area="Shell Tree Search"; key=S.KeyCopy;      priority=S.PriorCopy;      sortpriority=S.SortCopy;      description=M.DescrCopy;      flags="NoPluginPanels NoPluginPPanels";
--   action=function() return CopyMove("F5") end;
-- }
-- Macro {id="d1a184d8-3b4a-4f70-bbc5-9f0bc4cdd8c0";
--   area="Shell Tree Search"; key=S.KeyMove;      priority=S.PriorMove;      sortpriority=S.SortMove;      description=M.DescrMove;      flags="NoPluginPanels NoPluginPPanels";
--   action=function() return CopyMove("F6") end;
-- }
Macro {id="0ee8ac37-1fd4-4986-b4b6-446c5aaf7be8";
  area="Shell Tree Search"; key=S.KeyMkDir;     priority=S.PriorMkDir;     sortpriority=S.SortMkDir;     description=M.DescrMkDir;     flags="NoPluginPanels";
  action=function() return MkDir() end;
}
Macro {id="e54df8c5-7f87-41d1-a43e-927df827e48e";
  area="Shell Tree Search"; key=S.KeyDuplicate; priority=S.PriorDuplicate; sortpriority=S.SortDuplicate; description=M.DescrDuplicate; flags="NoPluginPanels";
  action=function() return DupRen("ShiftF5") end;
}
Macro {id="1415735a-c181-4909-be96-d7b8d8195772";
  area="Shell Tree Search"; key=S.KeyRename;    priority=S.PriorRename;    sortpriority=S.SortRename;    description=M.DescrRename;    flags="NoPluginPanels";
  action=function() return DupRen("ShiftF6") end;
}
Macro {id="faa66e8f-0d9f-44fd-bbc1-dae556e0d169";
  area="Shell Tree Search"; key=S.KeyNameDir;   priority=S.PriorNameDir;   sortpriority=S.SortNameDir;   description=M.DescrNameDir;   flags="NoPluginPPanels";
  action=function() return NameDir() end;
}

--Event {group="DialogEvent"; priority=S.ProirDisableHistory; description=M.DescrDisableHistory;
--  condition=function(Event,Param) return S.DisableHistory==true and Event==F.DE_DLGPROCINIT and Param.Msg==F.DN_CLOSE and Param.Param1>1 and Hdlg==far.AdvControl(F.ACTL_GETWINDOWINFO).Id end;
--  action=SimSU.Shell_Shift_F5F6F7.DisableHistory;
--}
