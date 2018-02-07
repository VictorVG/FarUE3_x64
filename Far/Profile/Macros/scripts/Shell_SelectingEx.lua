-------------------------------------------------------------------------------
-- Расширенная работа с выделением файлов. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_SelectingEx.cfg
return{
  Key="AltS"; --Prior=50;
  KeyToEdit="CtrlShiftE"; --PriorToEdit=50;
  KeyMark="CtrlShiftM"; --PriorMark=50;
  KeyUnMark="CtrlShiftR"; --PriorUnMark=50;
  KeySync="Divide"; --PriorSync=50;
  KeyFirst="AltHome"; --PriorFirst=50;
  KeyPrev="AltUp"; --PriorPrev=50;
  KeyNext="AltDown"; --PriorNext=50;
  KeyLast="AltEnd"; --PriorLast=50;

  FileName="Files.bbs"; -- Имя Файла с именами Файлов.
  EOL="\r\n"; -- Перевод строк.
}
-- Конец файла Profile\SimSU\Shell_SelectingEx.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_SelectingExRussian.lng
return{
  Descr="Расширенная работа с выделением файлов. © SimSU";
  DescrToEdit="Копирование имён помеченных файлов в редактор. © SimSU";
  DescrMark="Пометка файлов имена которых находятся в буфере обмена. © SimSU";
  DescrUnMark="Снятие пометки с файлов имена которых находятся в буфере обмена. © SimSU";
  DescrSync="Пометка одинаковых файлов на обоих панелях. © SimSU";
  DescrFirst="Переход на первый выделенный файл. © SimSU";
  DescrPrev="Переход на предыдущий выделенный файл. © SimSU";
  DescrNext="Переход на следующий выделенный файл. © SimSU";
  DescrLast="Переход на последний выделенный файл. © SimSU";

  mTitle="Работа с пометкой";
  mToEdit ="&E Имена в редактор";
  mClip   ="Буфер обмена";
  mCopy   ="&C Копировать";
  mMark   ="&M Пометить";
  mRemMark="&R Снять пометку";
  mPanels ="Панели";
  mSync   ="&S Синхронизировать";
  mAddName="&A +Имена";
  mAddExt ="&T +Расширения";
  mUnName ="&B -Имена";
  mUnExt  ="&U -Расширения";
  mAddMark="&+ Выделить";
  mUnMark ="&- Снять выделение";
  mAddAll ="&! Выделить все";
  mUnAll  ="&% Снять выделение со всех";
  mInvert ="&* Инвертировать";
  mMove   ="Передвижение";
  mFirst  ="&F Первый";
  mPrev   ="&P Предыдущий";
  mNext   ="&N Следующий";
  mLast   ="&L Последний";
}
-- Конец файла Profile\SimSU\Shell_SelectingExRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_SelectingExEnglish.lng
return{
  Descr="The expanded work with selection of files. © SimSU";
  DescrToEdit="Копирование имён помеченных файлов в редактор. © SimSU";
  DescrMark="Пометка файлов имена которых находятся в буфере обмена. © SimSU";
  DescrUnMark="Снятие пометки с файлов имена которых находятся в буфере обмена. © SimSU";
  DescrSync="Пометка одинаковых файлов на обоих панелях. © SimSU";
  DescrFirst="Переход на первый выделенный файл. © SimSU";
  DescrPrev="Переход на предыдущий выделенный файл. © SimSU";
  DescrNext="Переход на следующий выделенный файл. © SimSU";
  DescrLast="Переход на последний выделенный файл. © SimSU";

  mTitle="Work with mark";
  mToEdit ="&E Name to editor";
  mClip   ="Clipboard";
  mCopy   ="&C Copy";
  mMark   ="&M Mark";
  mRemMark="&R Remove mark";
  mPanels ="Panels";
  mSync   ="&S Synchronize";
  mAddName="&A +Names";
  mAddExt ="&T +Expansions";
  mUnName ="&B -Names";
  mUnExt  ="&U -Expansions";
  mAddMark="&+ Add mark";
  mUnMark ="&- Remove mark";
  mAddAll ="&! Mark all";
  mUnAll  ="&% Unmark all";
  mInvert ="&* Reverse";
  mMove   ="Movement";
  mFirst  ="&F First";
  mPrev   ="&P Previous";
  mNext   ="&N Next";
  mLast   ="&L Last";
}
-- End of file Profile\SimSU\Shell_SelectingExEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_SelectingEx"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_SelectingEx.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_SelectingEx.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Shell_SelectingEx={}
-------------------------------------------------------------------------------
local FileName=S.FileName or "Files.bbs"
local EOL=S.EOL or "\r\n"
local LastItem=1

function SimSU.Shell_SelectingEx.ToEditor()
  local Files={}
  for i=1, panel.GetPanelInfo(nil,1).SelectedItemsNumber do
    Files[i]=panel.GetSelectedPanelItem(nil,1,i).FileName
  end
  Files=table.concat(Files,EOL)
  editor.Editor(FileName,nil,nil,nil,nil,nil,far.Flags.EF_NONMODAL+far.Flags.EF_IMMEDIATERETURN); print(Files..EOL)
end

function SimSU.Shell_SelectingEx.ClipboardMark(Mark)
  local Mark= Mark==nil and true or Mark
  -- panel.select(0,0,2,clip(0)) -- FAR не проверяет пути если они есть.
  -- panel.select(0,1,2,clip(0)) -- FAR не проверяет пути если они есть.
  -- Делаем работу за FAR.
  local FileList=mf.clip(0)
  FileList=FileList:gsub("[%,%;\r\"]","\n"):upper().."\n"
  local PanelPath=APanel.Path:upper()
  for FullFileName in FileList:gmatch("[^\n]+") do
    local FilePath=mf.fsplit(FullFileName,0x1+0x2)
    local FileName=mf.fsplit(FullFileName,0x4+0x8)
    far.Show("'"..FilePath.."'","'"..FileName.."'")
    if FilePath=="" or FilePath==PanelPath then
      Panel.Select(0,Mark and 1 or 0,2,FileName)
    end
  end
end

function SimSU.Shell_SelectingEx.Synchronize()
  local AFiles={}
  for i=1,panel.GetPanelInfo(nil,1).ItemsNumber do
    AFiles[i]=panel.GetPanelItem(nil,1,i).FileName
  end
  AFiles=table.concat(AFiles,"\n")
  local PFiles={} for i=1,panel.GetPanelInfo(nil,0).ItemsNumber do
    PFiles[i]=panel.GetPanelItem(nil,0,i).FileName
  end
  PFiles=table.concat(PFiles,"\n")
  Panel.Select(0,0) Panel.Select(0,1,2,PFiles)
  Panel.Select(1,0) Panel.Select(1,1,2,AFiles)
end

function SimSU.Shell_SelectingEx.GoFirst()
  Panel.SetPosIdx(0,1,1)
end

function SimSU.Shell_SelectingEx.GoPrevious()
  _ = Panel.SetPosIdx(0,0,1)==1 and Panel.SetPosIdx(0,APanel.SelCount,1) or Panel.SetPosIdx(0,Panel.SetPosIdx(0,0,1)-1,1)
end

function SimSU.Shell_SelectingEx.GoNext()
  _ = Panel.SetPosIdx(0,0,1)==APanel.SelCount and Panel.SetPosIdx(0,1,1) or Panel.SetPosIdx(0,Panel.SetPosIdx(0,0,1)+1,1)
end

function SimSU.Shell_SelectingEx.GoLast()
  Panel.SetPosIdx(0,APanel.SelCount,1)
end

function SimSU.Shell_SelectingEx.Select()
  local item={}
  local len,l = 0,0
  item[01]=M.mToEdit
  item[02]="\1 "..M.mClip
  item[03]=M.mCopy
  item[04]=M.mMark
  item[05]=M.mRemMark
  item[06]="\1 "..M.mPanels
  item[07]=M.mSync
  item[08]=M.mAddName
  item[09]=M.mAddExt
  item[10]=M.mUnName
  item[11]=M.mUnExt
  item[12]=M.mAddMark
  item[13]=M.mUnMark
  item[14]=M.mAddAll
  item[15]=M.mUnAll
  item[16]=M.mInvert
  item[17]="\1 "..M.mMove
  item[18]=M.mFirst
  item[19]=M.mPrev
  item[20]=M.mNext
  item[21]=M.mLast
  for i=1,#item do len= item[i]:len()>len and item[i]:find("\1",1,true)~=1 and item[i]:len() or len end
  len=len+2
  for i=1,#item do item[i]= item[i]:find("\1",1,true)~=1 and item[i]..(' '):rep(len-item[i]:len()) or item[i] end
  item[01]=item[01]..(S.KeyToEdit or "")
  --
  item[03]=item[03].."CtrlShiftIns"
  item[04]=item[04]..(S.KeyMark or "")
  item[05]=item[05]..(S.KeyUnMark or "")
  --
  item[ 7]=item[07]..(S.KeySync or "")
  item[ 8]=item[08].."AltAdd"
  item[09]=item[09].."CtrlAdd"
  item[10]=item[10].."AltSubtract"
  item[11]=item[11].."CtrlSubtract"
  item[12]=item[12].."Add"
  item[13]=item[13].."Subtract"
  item[14]=item[14].."ShiftAdd"
  item[15]=item[15].."ShiftSubtract"
  item[16]=item[16].."Multiply"
  --
  item[18]=item[18]..(S.KeyFirst or "")
  item[19]=item[19]..(S.KeyPrev or "")
  item[20]=item[20]..(S.KeyNext or "")
  item[21]=item[21]..(S.KeyLast or "")

  LastItem=Menu.Show(table.concat(item,"\n"),M.mTitle,0x8,LastItem)
  _=
  LastItem==01 and SimSU.Shell_SelectingEx.ToEditor() or

  LastItem==03 and Keys("CtrlShiftIns") or
  LastItem==04 and SimSU.Shell_SelectingEx.ClipboardMark(true) or
  LastItem==05 and SimSU.Shell_SelectingEx.ClipboardMark(false) or

  LastItem==07 and SimSU.Shell_SelectingEx.Synchronize() or
  LastItem==08 and Keys("AltAdd") or
  LastItem==09 and Keys("CtrlAdd") or
  LastItem==10 and Keys("AltSubtract") or
  LastItem==11 and Keys("CtrlSubtract") or
  LastItem==12 and Keys("Add") or
  LastItem==13 and Keys("Subtract") or
  LastItem==14 and Keys("ShiftAdd") or
  LastItem==15 and Keys("ShiftSubtract") or
  LastItem==16 and Keys("Multiply") or

  LastItem==18 and SimSU.Shell_SelectingEx.GoFirst() or
  LastItem==19 and SimSU.Shell_SelectingEx.GoPrevious() or
  LastItem==20 and SimSU.Shell_SelectingEx.GoNext() or
  LastItem==21 and SimSU.Shell_SelectingEx.GoLast()
end
-------------------------------------------------------------------------------
if not Macro then return {Shell_SelectingEx=SimSU.Shell_SelectingEx} end

local ok, mod = pcall(require,"SimSU.Shell_SelectingEx"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Shell"; key=S.KeyToEdit; priority=S.PriorToEdit; description=M.DescrToEdit;
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=SimSU.Shell_SelectingEx.ToEditor;
}
Macro {area="Shell"; key=S.KeyMark; priority=S.PriorMark; description=M.DescrMark;
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=SimSU.Shell_SelectingEx.ClipboardMark;
}
Macro {area="Shell"; key=S.KeyUnMark; priority=S.PriorUnMark; description=M.DescrUnMark;
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() SimSU.Shell_SelectingEx.ClipboardMark(false) end;
}
Macro {area="Shell"; key=S.KeySync; priority=S.PriorSync; description=M.DescrSync;
  condition = function() return APanel.Visible and APanel.FilePanel and PPanel.Visible and PPanel.FilePanel end;
  action=SimSU.Shell_SelectingEx.Synchronize;
}
Macro {area="Shell"; key=S.KeyFirst; priority=S.PriorFirst; description=M.DescrFirst; flags="Selection";
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=SimSU.Shell_SelectingEx.GoFirst;
}
Macro {area="Shell"; key=S.KeyPrev; priority=S.PriorPrev; description=M.DescrPrev; flags="Selection";
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=SimSU.Shell_SelectingEx.GoPrevious;
}
Macro {area="Shell"; key=S.KeyNext; priority=S.PriorNext; description=M.DescrNext; flags="Selection";
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=SimSU.Shell_SelectingEx.GoNext;
}
Macro {area="Shell"; key=S.KeyLast; priority=S.PriorLast; description=M.DescrLast; flags="Selection";
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=SimSU.Shell_SelectingEx.GoLast;
}
Macro {area="Shell"; key=S.Key; priority=S.Prior; description=M.Descr;
  action=SimSU.Shell_SelectingEx.Select;
}
