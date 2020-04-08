-------------------------------------------------------------------------------
-- Расширенная работа с пометкой файлов. © SimSU
-- + правки © BAX
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_SelectingEx.cfg
return{
  Key       = "AltS";         --Prior       = 50; --Sort       = 50;
  KeyToEdit = "CtrlShiftE";   --PriorToEdit = 50; --SortToEdit = 50;
  KeyMark   = "CtrlShiftM";   --PriorMark   = 50; --SortMark   = 50;
  KeyUnMark = "CtrlShiftR";   --PriorUnMark = 50; --SortUnMark = 50;
  KeySync   = "Divide";       --PriorSync   = 50; --SortSync   = 50;
  KeyFirst  = "AltHome";      --PriorFirst  = 50; --SortFirst  = 50;
  KeyPrev   = "AltUp";        --PriorPrev   = 50; --SortPrev   = 50;
  KeyNext   = "AltDown";      --PriorNext   = 50; --SortNext   = 50;
  KeyLast   = "AltEnd";       --PriorLast   = 50; --SortLast   = 50;
  KeyDay    = "CtrlAltD";     --PriorDay    = 50; --SortDay    = 50;

  FileName = "Files.bbs"; -- Имя Файла с именами Файлов.
  EOL      = "\r\n"; -- Перевод строк при вставке списка в редактор.
  SEP      = "%,%;\r\""; -- Что считать разделителями имён файлов в буфере обмена.
}
-- Конец файла Profile\SimSU\Shell_SelectingEx.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_SelectingExRussian.lng
return{
  Descr       = "Расширенная работа с пометкой файлов. © SimSU";
  DescrToEdit = "Копирование имён помеченных файлов в редактор. © SimSU";
  DescrMark   = "Пометка файлов имена которых находятся в буфере обмена. © SimSU";
  DescrUnMark = "Снятие пометки с файлов имена которых находятся в буфере обмена. © SimSU";
  DescrSync   = "Пометка одинаковых файлов на обоих панелях. © SimSU";
  DescrFirst  = "Переход на первый помеченный файл. © SimSU";
  DescrPrev   = "Переход на предыдущий помеченный файл. © SimSU";
  DescrNext   = "Переход на следующий помеченный файл. © SimSU";
  DescrLast   = "Переход на последний помеченный файл. © SimSU";
  DescrDay    = "Пометка файлов с днём записи равным дню записи файла под курсором. © SimSU";

  mTitle   = "Работа с пометкой";
  mToEdit  = "&E Имена в редактор";
  mClip    = "Буфер обмена";
  mCopy    = "&C Копировать в буфер";
  mMark    = "&M Пометить из буфера";
  mRemMark = "&R Снять пометку из буфера";
  mPanels  = "Панели";
  mSync    = "&S Синхронизировать";
  mAddName = "&A +Имена";
  mAddExt  = "&T +Расширения";
  mUnName  = "&B -Имена";
  mUnExt   = "&U -Расширения";
  mAddMark = "&+ Добавить к помеченным...";
  mUnMark  = "&- Убрать из помеченных...";
  mAddAll  = "&! Пометить все";
  mUnAll   = "&% Снять пометку со всех";
  mInvert  = "&* Инвертировать";
  mDay     = "&D Отметить файлы за день";
  mMove    = "Позиционироваться на";
  mFirst   = "&F Первый";
  mPrev    = "&P Предыдущий";
  mNext    = "&N Следующий";
  mLast    = "&L Последний";
}
-- Конец файла Profile\SimSU\Shell_SelectingExRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_SelectingExEnglish.lng
return{
  Descr       = "The expanded work with selection of files. © SimSU";
  DescrToEdit = "Копирование имён помеченных файлов в редактор. © SimSU";
  DescrMark   = "Пометка файлов имена которых находятся в буфере обмена. © SimSU";
  DescrUnMark = "Снятие пометки с файлов имена которых находятся в буфере обмена. © SimSU";
  DescrSync   = "Пометка одинаковых файлов на обоих панелях. © SimSU";
  DescrFirst  = "Переход на первый помеченный файл. © SimSU";
  DescrPrev   = "Переход на предыдущий помеченный файл. © SimSU";
  DescrNext   = "Переход на следующий помеченный файл. © SimSU";
  DescrLast   = "Переход на последний помеченный файл. © SimSU";
  DescrDay    = "Пометка файлов с днём записи равным дню записи файла под курсором. © SimSU";

  mTitle   = "Operations on selection";
  mToEdit  = "&E Bring selection to editor";
  mClip    = "Clipboard";
  mCopy    = "&C Copy to clipboard";
  mMark    = "&M Select from clipboard";
  mRemMark = "&R Unselect from clipboard";
  mPanels  = "Panels";
  mSync    = "&S Synchronize";
  mAddName = "&A +Names";
  mAddExt  = "&T +Extensions";
  mUnName  = "&B -Names";
  mUnExt   = "&U -Extensions";
  mAddMark = "&+ Add to selection...";
  mUnMark  = "&- Subtract from selection...";
  mAddAll  = "&! Select all";
  mUnAll   = "&% Unselect all";
  mInvert  = "&* Reverse selection";
  mDay     = "&D Select files for a day";
  mMove    = "Position to";
  mFirst   = "&F First";
  mPrev    = "&P Previous";
  mNext    = "&N Next";
  mLast    = "&L Last";
}
-- End of file Profile\SimSU\Shell_SelectingExEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_SelectingEx"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_SelectingEx.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_SelectingEx.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
local F=far.Flags
S.FileName = S.FileName==nil and Settings().FileName or S.FileName
S.EOL      = S.EOL     ==nil and Settings().EOL      or S.EOL
S.SEP      = S.SEP     ==nil and Settings().SEP      or S.SEP

local LastItem=1

local function ToEditor()
  local Files={}
  for i=1, panel.GetPanelInfo(nil,1).SelectedItemsNumber do
    Files[i]=panel.GetSelectedPanelItem(nil,1,i).FileName
  end
  local Names=table.concat(Files,S.EOL)..S.EOL
  editor.Editor(S.FileName,nil,nil,nil,nil,nil,F.EF_NONMODAL+F.EF_IMMEDIATERETURN)
  print(Names)
  return Files
end

local function ClipboardMark(Mark)
  Mark= Mark and 1 or 0
  -- panel.select(0,0,2,clip(0)) -- FAR не проверяет пути если они есть.
  -- panel.select(0,1,2,clip(0)) -- FAR не проверяет пути если они есть.
  -- Делаем работу за FAR.
  local FileList=mf.clip(0)
  FileList=(FileList:gsub("["..S.SEP.."]","\n"):upper().."\n"):gsub("\\\n","\n")
  local PanelPath=APanel.Path:upper()
  for FullFileName in FileList:gmatch("[^\n]+") do
    local FilePath=mf.fsplit(FullFileName,0x1+0x2):gsub("\\$","")
    local Name=mf.fsplit(FullFileName,0x4+0x8)
    if FilePath=="" or FilePath==PanelPath then
      --Panel.Select(0,Mark,2,Name)
      Panel.Select(0,Mark,3,Name)
    end
  end
  return true
end

local function Synchronize()
  local AFiles = {}
  for i=1,panel.GetPanelInfo(nil,1).ItemsNumber do
    AFiles[i]=panel.GetPanelItem(nil,1,i).FileName
  end
  local PFiles = {}
  for i=1,panel.GetPanelInfo(nil,0).ItemsNumber do
    PFiles[i]=panel.GetPanelItem(nil,0,i).FileName
  end
  Panel.Select(0,0); Panel.Select(0,1,2,table.concat(PFiles,"\n"))
  Panel.Select(1,0); Panel.Select(1,1,2,table.concat(AFiles,"\n"))
  return AFiles, PFiles
end

local function DayMark()
  local mSecInDay=1000*60*60*24
  local PanelItem=panel.GetCurrentPanelItem(nil,1)
  local Sel=(band(PanelItem.Flags,F.PPIF_SELECTED)==0)
  local DateMin= PanelItem.FileName == ".." and win.GetSystemTimeAsFileTime() or PanelItem.LastWriteTime
  DateMin=math.floor(DateMin/mSecInDay)*mSecInDay
  local DateMax=DateMin+mSecInDay
  for i=1,panel.GetPanelInfo(nil,1).ItemsNumber do
    PanelItem=panel.GetPanelItem(nil,1,i)
    if PanelItem.LastWriteTime>DateMin and PanelItem.LastWriteTime<DateMax then
      panel.SetSelection(nil,1,i,Sel)
    end
  end
  panel.RedrawPanel(nil,1)
end

local function GoFirst()
  return Panel.SetPosIdx(0,1,1)
end

local function GoPrevious()
--  return Panel.SetPosIdx(0,0,1)==1 and Panel.SetPosIdx(0,APanel.SelCount,1) or Panel.SetPosIdx(0,Panel.SetPosIdx(0,0,1)-1,1)
  local PanelInfo=panel.GetPanelInfo(nil,1)
  local CI=PanelInfo.CurrentItem
  for i=CI-1,1,-1 do
    if panel.GetPanelItem(nil,1,i).Flags==F.PPIF_SELECTED then CI=i; Panel.SetPosIdx(0,CI,0); break end
  end
  if CI==PanelInfo.CurrentItem then Panel.SetPosIdx(0,APanel.SelCount,1) end
end

local function GoNext()
--  return Panel.SetPosIdx(0,0,1)==APanel.SelCount and Panel.SetPosIdx(0,1,1) or Panel.SetPosIdx(0,Panel.SetPosIdx(0,0,1)+1,1)
  local PanelInfo=panel.GetPanelInfo(nil,1)
  local CI=PanelInfo.CurrentItem
  for i=CI+1,PanelInfo.ItemsNumber do
    if band(panel.GetPanelItem(nil,1,i).Flags,F.PPIF_SELECTED)~=0 then CI=i; Panel.SetPosIdx(0,CI,0); break end
  end
  if CI==PanelInfo.CurrentItem then Panel.SetPosIdx(0,1,1) end
end

local function GoLast()
  return Panel.SetPosIdx(0,APanel.SelCount,1)
end

local function Select()
  -- + идеи BAX, 23.02.2019
  local mi={ -- far.Menu
    {text=M.mToEdit ; AccelKey=(S.KeyToEdit or "");  Action=ToEditor                          };
    {text=M.mClip   ;                    separator=true                                       };
    {text=M.mCopy   ; AccelKey="CtrlShiftIns"                                                 };
    {text=M.mMark   ; AccelKey=(S.KeyMark   or "");  Action=function() return ClipboardMark(true )end};
    {text=M.mRemMark; AccelKey=(S.KeyUnMark or "");  Action=function() return ClipboardMark(false)end};
    {text=M.mPanels ;                    separator=true                                       };
    {text=M.mSync   ; AccelKey=(S.KeySync   or "");  Action=Synchronize                       };
    {text=M.mAddName; AccelKey="AltAdd"                                                       };
    {text=M.mAddExt ; AccelKey="CtrlAdd"                                                      };
    {text=M.mUnName ; AccelKey="AltSubtract"                                                  };
    {text=M.mUnExt  ; AccelKey="CtrlSubtract"                                                 };
    {text=M.mAddMark; AccelKey="Add"                                                          };
    {text=M.mUnMark ; AccelKey="Subtract"                                                     };
    {text=M.mAddAll ; AccelKey="ShiftAdd"                                                     };
    {text=M.mUnAll  ; AccelKey="ShiftSubtract"                                                };
    {text=M.mInvert ; AccelKey="Multiply"                                                     };
    {text=M.mDay    ; AccelKey=(S.KeyDay    or "");  Action=DayMark                           };
    {text=M.mMove   ;                    separator=true                                       };
    {text=M.mFirst  ; AccelKey=(S.KeyFirst  or "");  Action=GoFirst                           };
    {text=M.mPrev   ; AccelKey=(S.KeyPrev   or "");  Action=GoPrevious                        };
    {text=M.mNext   ; AccelKey=(S.KeyNext   or "");  Action=GoNext                            };
    {text=M.mLast   ; AccelKey=(S.KeyLast   or "");  Action=GoLast                            };
  }
  local len = 0
  for i,v in ipairs(mi) do len = (v.separator~=true) and (len < v.text:len()) and   v.text:len() or len end
  len = len + 2
  for i,v in ipairs(mi) do
    v.text = (v.separator~=true) and   ((v.text .. (' '):rep(len)):sub(1,len) .. v.AccelKey) or v.text
    v.selected = (i==LastItem)
  end
  local it, pos = far.Menu({Title=M.mTitle}, mi)
  if it then
    LastItem=pos
    return it.Action and it.Action() or Keys(it.AccelKey)
  end
end

-------------------------------------------------------------------------------
local Shell_SelectingEx={
  ToEditor      = ToEditor     ;
  ClipboardMark = ClipboardMark;
  Synchronize   = Synchronize  ;
  DayMark       = DayMark      ;
  GoFirst       = GoFirst      ;
  GoPrevious    = GoPrevious   ;
  GoNext        = GoNext       ;
  GoLast        = GoLast       ;
  Select        = Select       ;
}
local function filename() return Select() end -- Меню
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Shell_SelectingEx=Shell_SelectingEx} end
SimSU.Shell_SelectingEx=Shell_SelectingEx; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="7ff37302-a606-4a17-972d-b51c006c4da7";
  area="Shell"; key=S.Key;       priority=S.Prior;       sortpriority=S.Sort;       description=M.Descr;
  action=function() return Select() end;
}
Macro {id="5fb1e2d0-87fc-4eda-a398-28e20a3eaf2f";
  area="Shell"; key=S.KeyToEdit; priority=S.PriorToEdit; sortpriority=S.SortToEdit; description=M.DescrToEdit;
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() return ToEditor() end;
}
Macro {id="6c556f56-da67-4a52-a490-90430947d7c2";
  area="Shell"; key=S.KeyMark;   priority=S.PriorMark;   sortpriority=S.SortMark;   description=M.DescrMark;
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() return ClipboardMark(true) end;
}
Macro {id="db6e5645-0053-4598-94d7-cf6bb133c20f";
  area="Shell"; key=S.KeyUnMark; priority=S.PriorUnMark; sortpriority=S.SortUnMark; description=M.DescrUnMark;
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() return ClipboardMark(false) end;
}
Macro {id="512a4220-7018-4d02-9ca7-833c01269575";
  area="Shell"; key=S.KeySync;   priority=S.PriorSync;   sortpriority=S.SortSync;   description=M.DescrSync;
  condition = function() return APanel.Visible and APanel.FilePanel and PPanel.Visible and PPanel.FilePanel end;
  action=function() return Synchronize() end;
}
Macro {id="bf643ce8-5cec-41b9-803b-e794a0a3e97b";
  area="Shell"; key=S.KeyFirst;  priority=S.PriorFirst;  sortpriority=S.SortFirst;  description=M.DescrFirst; flags="Selection";
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() return GoFirst() end;
}
Macro {id="a67c3e04-7061-4f6c-a525-bbde0ad7fe0d";
  area="Shell"; key=S.KeyPrev;   priority=S.PriorPrev;   sortpriority=S.SortPrev;   description=M.DescrPrev; flags="Selection";
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() return GoPrevious() end;
}
Macro {id="904c717f-5e8b-4da4-bd1b-63dbf464094b";
  area="Shell"; key=S.KeyNext;   priority=S.PriorNext;   sortpriority=S.SortNext;   description=M.DescrNext; flags="Selection";
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() return GoNext() end;
}
Macro {id="8e60772c-2a38-41f2-9f75-49335df9ee63";
  area="Shell"; key=S.KeyLast;   priority=S.PriorLast;   sortpriority=S.SortLast;   description=M.DescrLast; flags="Selection";
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() return GoLast() end;
}
Macro {id="4afe7929-4974-49e6-8db2-59e3822e457f";
  area="Shell"; key=S.KeyDay;    priority=S.PriorDay;    sortpriority=S.SortDay;    description=M.DescrDay;
  condition = function() return APanel.Visible and APanel.FilePanel end;
  action=function() return DayMark() end;
}
