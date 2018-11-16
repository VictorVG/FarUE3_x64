-------------------------------------------------------------------------------
--     Сохранение/востановление пометки вайлов. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_RememberSelected.cfg
return{
  Key        ="AltM"          ; --Prior        =50; --Sort        =50;
  KeyExecute ="Enter NumEnter"; --PriorExecute =50; --SortExecute =50;
  KeyRoot    ="CtrlBackSlash" ; --PriorRoot    =50; --SortRoot    =50;
  KeyIn      ="CtrlPgDn"      ; --PriorIn      =50; --SortIn      =50;
  KeyInForce ="CtrlShiftPgDn" ; --PriorInForce =50; --SortInForce =50;
  KeyOut     ="CtrlPgUp"      ; --PriorOut     =50; --SortOut     =50;
  KeyOutSpace="Space"         ; --PriorOutSpace=50; --SortOutSpace=50;
  KeyLeftDrv ="AltF1"         ; --PriorLeftDrv =50; --SortLeftDrv =50;
  KeyRightDrv="AltF2"         ; --PriorRightDrv=50; --SortRightDrv=50;
}
-- Конец файла Profile\SimSU\Shell_RememberSelected.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_RememberSelectedRussian.lng
return{
  Descr="Сохранение/востановление пометки файлов. © SimSU";
  DescrExecute="Запуск, смена папки, вход в архив c сохранением выделения файлов. © SimSU";
  DescrRoot="Сменить папку на корневую c сохранением выделения файлов. © SimSU";
  DescrIn="Смена папки, вход в архив c сохранением выделения файлов. © SimSU";
  DescrInForce="Смена папки, вход в архив c сохранением выделения файлов. © SimSU";
  DescrIn="Смена папки, вход в архив c сохранением выделения файлов. © SimSU";
  DescrOut="Перейти в папку уровнем выше c сохранением выделения файлов. © SimSU";
  DescrOutSpace="Перейти в папку уровнем выше c сохранением выделения файлов. © SimSU";
  DescrLeftDrv="Изменить текущий диск в левой панели c сохранением выделения файлов. © SimSU";
  DescrRightDrv="Изменить текущий диск в правой панели c сохранением выделения файлов. © SimSU";
}
-- Конец файла Profile\SimSU\Shell_RememberSelectedRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_RememberSelectedEnglish.lng
return{
  Descr="Saving/restoring of a selection of files. © SimSU";
  DescrExecute="Execute, change folder, enter to an archive with preservation of a selection of files. © SimSU";
  DescrRoot="Change to the root folder with preservation of a selection of files. © SimSU";
  DescrIn="Change folder, enter an archive with preservation of a selection of files. © SimSU";
  DescrInForce="Change folder, enter an archive with preservation of a selection of files. © SimSU";
  DescrOut="Change to the parent folder with preservation of a selection of files. © SimSU";
  DescrOutSpace="Change to the parent folder with preservation of a selection of files. © SimSU";
  DescrLeftDrv="Change the current drive for left panel with preservation of a selection of files. © SimSU";
  DescrRightDrv="Change the current drive for right panel with preservation of a selection of files. © SimSU";
}
-- End of file Profile\SimSU\Shell_RememberSelectedEnglish.lng
end end

-------------------------------------------------------------------------------
local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_RememberSelected"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_RememberSelected.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_RememberSelected.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local FileSelected = {}

local function Save(PANEL)
  PANEL=PANEL or APanel
  if PANEL.FilePanel then
    local Path=PANEL.UNCPath
    if PANEL.SelCount>0 then
      local Files={}
      for i=1,PANEL.SelCount do
        Files[i]=panel.GetSelectedPanelItem(nil,(PANEL==APanel and 1 or 0),i).FileName
      end
      FileSelected[Path]=table.concat(Files,"\n")
    else
      FileSelected[Path]=nil
    end
    return FileSelected
  end
end

local function Restore(PANEL)
  PANEL=PANEL or APanel
  if PANEL.FilePanel then
    local Path=PANEL.UNCPath
    local FileSel= FileSelected[Path]
    Panel.Select(PANEL==APanel and 0 or 1,0);
    if FileSel then Panel.Select((PANEL==APanel and 0 or 1),1,2,FileSel) end
    return FileSelected
  end
end

local function Turn(PANEL)
  PANEL=PANEL or APanel
  if PANEL.FilePanel then
    local Path=PANEL.UNCPath
    local FileSel= FileSelected[Path]
    if PANEL.SelCount>0 then Save(PANEL) end
    if FileSel then Panel.Select(0,0); Panel.Select((PANEL==APanel and 0 or 1),1,2,FileSel) end
    return FileSelected
  end
end

local function RestoreLater(PANEL)
  far.Timer(100, function(h) if Area.Shell then h:Close(); Restore(PANEL) end end)
--  while not Area.Shell do
--    local mm=mmode(1,0)
--    local VK=mf.waitkey(100)
--    if Area.Disks and VK:find("MsLClick") then
--      Keys("MsLClick Enter")
--    else
--      Keys(VK)
--    end
--    mmode(1,mm)
--  end -- Вопросы...
  return FileSelected
end

local function Auto(PANEL,KEY)
  PANEL=PANEL or APanel; KEY=KEY or ""
  Save(PANEL)
  Keys(KEY)
  RestoreLater(PANEL)
  return FileSelected
end

-------------------------------------------------------------------------------
local Shell_RememberSelected={
Save         = Save        ;
Restore      = Restore     ;
Turn         = Turn        ;
RestoreLater = RestoreLater;
Auto         = Auto        ;
}
local function filename() return Restore() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return{Shell_RememberSelected=SimSU.Shell_RememberSelected} end
SimSU.Shell_RememberSelected=Shell_RememberSelected; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {
  area="Shell"; key=S.Key;         priority=S.Prior;         sortpriority=S.Sort;         description=M.Descr;
  action = function() Turn(APanel) end;
}
Macro {
  area="Shell"; key=S.KeyExecute;  priority=S.PriorExecute;  sortpriority=S.SortExecute;  description=M.DescrExecute;
  action = function() Auto(APanel,"Enter") end;
}
Macro {
  area="Shell"; key=S.KeyRoot;     priority=S.PriorRoot;     sortpriority=S.SortRoot;     description=M.DescrRoot;
  action = function() Auto(APanel,"CtrlBackSlash") end;
}
Macro {
  area="Shell"; key=S.KeyIn;       priority=S.PriorIn;       sortpriority=S.SortIn;       description=M.DescrIn;
  action = function() Auto(APanel,"CtrlPgDn") end;
}
Macro {
  area="Shell"; key=S.KeyInForce;  priority=S.PriorInForce;  sortpriority=S.SortInForce;  description=M.DescrInForce;
  action = function() Auto(APanel,"CtrlShiftPgDn") end;
}
Macro {
  area="Shell"; key=S.KeyOut;      priority=S.PriorOut;      sortpriority=S.SortOut;      description=M.DescrOut;
  action = function() Auto(APanel,"CtrlPgUp") end;
}
Macro {
  area="Shell"; key=S.KeyOutSpace; priority=S.PriorOutSpace; sortpriority=S.SortOutSpace; description=M.DescrOutSpace; flags="EmptyCommandLine";
  action = function() Auto(APanel,"CtrlPgUp") end;
}
Macro {
  area="Shell"; key=S.KeyLeftDrv;  priority=S.PriorLeftDrv;  sortpriority=S.SortLeftDrv;  description=M.DescrLeftDrv;
  action = function() Auto(APanel.Left and APanel or PPanel,"AltF1") end;
}
Macro {
  area="Shell"; key=S.KeyRightDrv; priority=S.PriorRightDrv; sortpriority=S.SortRightDrv; description=M.DescrRightDrv;
  action = function() Auto(APanel.Left and PPanel or APanel,"AltF2") end;
}
