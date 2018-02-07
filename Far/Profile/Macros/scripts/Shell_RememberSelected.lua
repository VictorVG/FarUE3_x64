-------------------------------------------------------------------------------
--     Сохранение/востановление пометки файлов. © SimSU
-------------------------------------------------------------------------------
-- В скрипт внесены изменения для устранения проблем  с графикой, сменными,
-- оптическими и неподключёнными дисками (см. комментарии).
-- /VictorVG @ VikSoft.Ru, Tue Jun 23 04:42:32 +0300 2015/
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_RememberSelected.cfg
return{
  Key="AltM"; --Prior=50;
  KeyCommon_Execute="Enter NumEnter"; --PriorCommon_Execute=50;
  KeyRoot="CtrlBackSlash"; --PriorRoot=50;
  KeyIn="CtrlPgDn"; --PriorIn=50;
  KeyInForce="CtrlShiftPgDn"; --PriorInForce=50;
  KeyOut="CtrlPgUp"; --PriorOut=50;
  KeyOutSpace="Space"; --PriorOutSpace=50;
  KeyLeftDrv="AltF1"; --PriorLeftDrv=50;
  KeyRightDrv="AltF2"; --PriorRightDrv=50;
}
-- Конец файла Profile\SimSU\Shell_RememberSelected.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_RememberSelectedRussian.lng
return{
  Descr="Сохранение/востановление пометки файлов. © SimSU";
  DescrCommon_Execute="Запуск, смена папки, вход в архив c сохранением выделения файлов. © SimSU";
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
  DescrCommon_Execute="Common_Execute, change folder, enter to an archive with preservation of a selection of files. © SimSU";
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

local SimSU=SimSU or {}
SimSU.Shell_RememberSelected={}
-------------------------------------------------------------------------------
local FileSelected

function SimSU.Shell_RememberSelected.Save(PANEL)
  PANEL=PANEL or APanel
  if PANEL.FilePanel then
    FileSelected= FileSelected or {}
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
  end
end

function SimSU.Shell_RememberSelected.Restore(PANEL)
  PANEL=PANEL or APanel
  if PANEL.FilePanel then
    local Path=PANEL.UNCPath
    local FileSel= FileSelected and FileSelected[Path]
    Panel.Select(PANEL==APanel and 0 or 1,0);
    if FileSel then Panel.Select((PANEL==APanel and 0 or 1),1,2,FileSel) end
  end
end

function SimSU.Shell_RememberSelected.Turn(PANEL)
  PANEL=PANEL or APanel
  if PANEL.FilePanel then
    local Path=PANEL.UNCPath
    local FileSel= FileSelected and FileSelected[Path]
    if PANEL.SelCount>0 then SimSU.Shell_RememberSelected.Save(PANEL) end
    if FileSel then Panel.Select(0,0); Panel.Select((PANEL==APanel and 0 or 1),1,2,FileSel) end
  end
end

function SimSU.Shell_RememberSelected.Auto(PANEL,KEY)
  PANEL=PANEL or APanel; KEY=KEY or ""
  SimSU.Shell_RememberSelected.Save(PANEL)
  Keys(KEY)
  far.Timer(100, function(h) if Area.Shell then h:Close(); SimSU.Shell_RememberSelected.Restore(PANEL) end end)
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
--  SimSU.Shell_RememberSelected.Restore(PANEL)
end
-------------------------------------------------------------------------------
if not Macro then return{Shell_RememberSelected=SimSU.Shell_RememberSelected} end

local ok, mod = pcall(require,"SimSU.Shell_RememberSelected"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------
--   маска графики  /VictorVG @ VikSoft.Ru/
local Mask="/.+\\.(cut|dds|(e|j)xr|g3|fax|hd(r|ri)|ico|b(lk|mp)|j(ng|p2|pc|pe|pf|pm|pr|peg|px)|(gi|jfi|ji|if)f|j|k(l|o)a|gg|pc(d|x|t)|mng|rp(b|g|n)m|p(b|g|f|n)m|(rp|p)pm|p(ng|sd)|pic(t|t2)|ra(w|s|st)|s(un|r|cr)|rs|rg(b|ba)|bw|iris|sgi|in(t|ta)|(t|tar)ga|(pi|bp)x|ivb|ti(f|if|m)|wb(m|pp)|w(ap|eb|ebp)|x(bm|pm)|(b|p)m|(mj|j)2(c|k))/i"
local DSA=mf.string(APanel.DriveType);
local DSP=mf.string(PPanel.DriveType);
local MSk="/(0|2|5)"

Macro {area="Shell"; key=S.Key; description=M.Descr;
  action = function() SimSU.Shell_RememberSelected.Turn(APanel) end;
}
Macro {area="Shell"; key=S.KeyCommon_Execute; priority=S.PriorCommon_Execute; description=M.DescrCommon_Execute;
-------------------------------------------------------------------------------
--  добавим проверку для устранения проблем с графикой, сменными, оптическими и неподключёнными дисками /VictorVG @ VikSoft/
  condition=function() return (mf.fmatch(DSA,MSk)==0 and mf.fmatch(DSP,MSk)==0 and mf.fmatch(APanel.Current,Mask)==0) end;
  action = function() SimSU.Shell_RememberSelected.Auto(APanel,"Enter") end;
}
Macro {area="Shell"; key=S.KeyRoot; priority=S.PriorRoot; description=M.DescrRoot;
  action = function() SimSU.Shell_RememberSelected.Auto(APanel,"CtrlBackSlash") end;
}
Macro {area="Shell"; key=S.KeyIn; priority=S.PriorIn; description=M.DescrIn;
  action = function() SimSU.Shell_RememberSelected.Auto(APanel,"CtrlPgDn") end;
}
Macro {area="Shell"; key=S.KeyInForce; priority=S.PriorInForce; description=M.DescrInForce;
  action = function() SimSU.Shell_RememberSelected.Auto(APanel,"CtrlShiftPgDn") end;
}
Macro {area="Shell"; key=S.KeyOut; priority=S.PriorOut; description=M.DescrOut;
  action = function() SimSU.Shell_RememberSelected.Auto(APanel,"CtrlPgUp") end;
}
Macro {area="Shell"; key=S.KeyOutSpace; priority=S.PriorOutSpace; description=M.DescrOutSpace; flags="EmptyCommandLine";
  action = function() SimSU.Shell_RememberSelected.Auto(APanel,"CtrlPgUp") end;
}
--[[Macro {area="Shell"; key=S.KeyLeftDrv; priority=S.PriorLeftDrv; description=M.DescrLeftDrv;
  action = function() SimSU.Shell_RememberSelected.Auto(APanel.Left and APanel or PPanel,"AltF1") end;
}
Macro {area="Shell"; key=S.KeyRightDrv; priority=S.PriorRightDrv; description=M.DescrRightDrv;
  action = function() SimSU.Shell_RememberSelected.Auto(APanel.Left and PPanel or APanel,"AltF2") end;
}
--]]