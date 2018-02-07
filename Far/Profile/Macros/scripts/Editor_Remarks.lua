-------------------------------------------------------------------------------
-- Набор макросов для работы со строчным комментированием в редакторе. © SimSU
-------------------------------------------------------------------------------
-- Умеет:
--   комментировать строку и выделенные строки;
--   понимает различные расширения файлов;
--   самонастраивается :)
-- Если вызвать комментирование/разкомментирование в новом(ранее не определённом расширении) файле, то
-- появится меню выбора типа(расширения) файла, в котором можно выбрать нужный тип или создать новый.
-- После этого появится диалог настройки, в котором надо задать список расширений (по правилам FAR),
-- Символы строчного комментирования которые будут вставляться в начало строки и, если хотите, комментарий.
-- Настройки можно переопределять/изменять/добавять/удалять по средствам самого макроса.

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_Remarks.cfg
return{
  KeyOptions="CtrlAltR"; --Prior=50; -- Настройка комментирования для различных типов файлов.
  KeyComment="AltR"; --Prior=50;  -- Комментирование текущей строки или выделенного блока.
  KeyUnComment= "CtrlR"; --Prior=50;  -- Снятие комментирования текущей строки или выделенного блока.
  KeyTab="Tab"; --Prior=50;  -- Табулирование строк выделенного блока.
  KeyUnTab= "ShiftTab"; --Prior=50;  -- Отмена табулирования строк выделенного блока.
}
-- Конец файла Profile\SimSU\Editor_Remarks.cfg
end

_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_RemarksRussian.lng
return{
  DescrOptions="Настройка комментирования помеченного блока. © SimSU";
  DescrComment="Комментирование помеченного блока. © SimSU";
  DescrUnComment= "Разкомментирование помеченного блока. © SimSU";
  DescrTab="Табулирование строк выделенного блока. © SimSU";
  DescrUnTab= "Отмена табулирования строк выделенного блока. © SimSU";

  MenuTitle="Комментирование";
  DlgTitle="Настройка комментирования";
  Mask="&Маска файлов";
  Symbol="&Символы строчного комментирования";
  description="&Описание";
  Yes="&Да";
  No="&Нет";
  Delete="&Удалить";
}
-- Конец файла Profile\SimSU\Editor_RemarksRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_RemarksEnglish.lng
return{
  DescrOptions="Настройка комментирования помеченного блока. © SimSU";
  DescrComment="Комментирование помеченного блока. © SimSU";
  DescrUnComment= "Разкомментирование помеченного блока. © SimSU";
  DescrTab="Табулирование строк выделенного блока. © SimSU";
  DescrUnTab= "Отмена табулирования строк выделенного блока. © SimSU";

  MenuTitle="Commenting";
  DlgTitle="Comment setings";
  Mask="&Mask of files";
  Symbol="&String comment symbols";
  description="D&escription";
  Yes="&Yes";
  No="&No";
  Delete="&Delete"
}
-- End of file Profile\SimSU\Editor_RemarksEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_Remarks"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_Remarks.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_Remarks.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Editor_Remarks={}
-------------------------------------------------------------------------------
local Rem=mf.mload("SimSU","Remarks") or {}

function SimSU.Editor_Remarks.Options()
-- Функция настройки символов комментирования.
  local FileName=editor.GetFileName(nil)
  local Mask local Data={}
  local Items,Index={},{} local Idx
  for Mask,Data in pairs(Rem) do
    Items[#Items+1]=(Mask or ""):sub(1,20)..(" "):rep(20-((Mask or ""):len())).."  │  "..(Data.Desc or "")
    Index[#Index+1]=Mask
    if mf.fmatch(FileName,Mask)==1 then
      Idx=Idx or #Items
    end
  end
  Items[#Items+1]="                      │                     "
  Items=table.concat(Items,"\n")
  Idx=Menu.Show(Items,M.MenuTitle,0x8+0x80,Idx)

  if Idx>0 then
    Mask=Index[Idx]
    Data=Mask and Rem[Mask] or {}
    Items={
      --[[01]]  {"DI_DOUBLEBOX", 3, 1,40,10, 0,nil,nil,0,M.DlgTitle,nil,nil},
      --[[02]]  {"DI_TEXT",      5, 2,38, 2, 0,nil,nil,0,M.Mask,nil,nil},
      --[[03]]  {"DI_EDIT",      5, 3,38, 3, 0,nil,nil,0,Mask,nil,nil},
      --[[04]]  {"DI_TEXT",      5, 4,38, 4, 0,nil,nil,0,M.Symbol,nil,nil},
      --[[05]]  {"DI_EDIT",      5, 5,38, 5, 0,nil,nil,0,Data.Symb,nil,nil},
      --[[06]]  {"DI_TEXT",      5, 6,38, 4, 0,nil,nil,0,M.description,nil,nil},
      --[[07]]  {"DI_EDIT",      5, 7,38, 5, 0,nil,nil,0,Data.Desc,nil,nil},
      --[[08]]  {"DI_TEXT",      3, 8,40, 8, 0,nil,nil,"DIF_SEPARATOR",nil,nil,nil},
      --[[09]]  {"DI_BUTTON",    0, 9, 0, 6, 0,nil,nil,{DIF_CENTERGROUP=1, DIF_DEFAULTBUTTON=1},M.Yes,nil,nil},
      --[[10]]  {"DI_BUTTON",    0, 9, 0, 6, 0,nil,nil,"DIF_CENTERGROUP",M.No,nil,nil},
      --[[11]]  {"DI_BUTTON",    0, 9, 0, 6, 0,nil,nil,"DIF_CENTERGROUP",M.Delete,nil,nil},
    }
    local result=far.Dialog("",-1,-1,44,12,nil,Items,nil,nil)
    if result==9 then
      Mask=Items[3][10]
      Data.Symb=Items[5][10]
      Data.Desc=Items[7][10]
      if Index[Idx] then Rem[Index[Idx]]=nil end
      Rem[Mask]=Data
    elseif result==11 and Index[Idx] then
      Rem[Mask]=nil
      Data={}
    end
    mf.msave("SimSU","Remarks",Rem)
  else
    Data.Symb=nil
  end
  return Data.Symb
end

function SimSU.Editor_Remarks.CommUnComm(Comm,Symb)
  local FileName=editor.GetFileName()
  if not Symb then
    for Mask in pairs(Rem) do
      if mf.fmatch(FileName,Mask)==1 then
        Symb=Rem[Mask].Symb
        break
      end
    end
  end
  if not Symb then Symb=SimSU.Editor_Remarks.Options() end
  local len=Symb and Symb:len()+1 or 1
  if len>1 then
    local Inf=editor.GetInfo() local Sel=editor.GetSelection(Inf.EditorID)
    local Beg = Sel and Sel.StartLine or Inf.CurLine
    local End = Sel and Sel.EndLine-(Sel.EndPos==0 and 1 or 0) or Inf.CurLine
    if (Inf.CurLine>=Beg and Inf.CurLine<=End) or (Sel and Sel.EndPos==0 and Inf.CurLine==Sel.EndLine+0) then
      editor.UndoRedo(Inf.EditorID,0)
      local Str,Eol
      for i=Beg,End do
        Str,Eol=editor.GetString(Inf.EditorID,i,3)
        if Comm then
          editor.SetString(Inf.EditorID,i,Symb..Str,Eol)
        elseif Str:find(Symb,1,true)==1 then
          editor.SetString(Inf.EditorID,i,Str:sub(len),Eol)
        end
      end
      editor.UndoRedo(Inf.EditorID,1)
    end
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Editor_Remarks=SimSU.Editor_Remarks} end

local ok, mod = pcall(require,"SimSU.Editor_Remarks"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Editor"; key=S.KeyOptions; priority=S.Prior; description=M.DescrOptions;
  action=SimSU.Editor_Remarks.Options;
}
Macro {area="Editor"; key=S.KeyComment; priority=S.Prior; description=M.DescrComment;
  action=function() SimSU.Editor_Remarks.CommUnComm(true) end;
}
Macro {area="Editor"; key=S.KeyUnComment; priority=S.Prior; description=M.DescrUnComment;
  action=function() SimSU.Editor_Remarks.CommUnComm(false) end;
}
Macro {area="Editor"; key=S.KeyTab; priority=S.Prior; description=M.DescrTab; flags="EVSelection";
  action=function() SimSU.Editor_Remarks.CommUnComm(true,"\t") end;
}
Macro {area="Editor"; key=S.KeyUnTab; priority=S.Prior; description=M.DescrUnTab; flags="EVSelection";
  action=function() SimSU.Editor_Remarks.CommUnComm(false,"\t") end;
}
