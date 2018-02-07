-------------------------------------------------------------------------------
--   Удаление конечных пробелов и символов табуляции и пустых строк. © SimSU
-------------------------------------------------------------------------------
-- Умеет:
--   работать во всём или только в выделенном
--   удалять пробелы из окончаний строк
--   удалять все или только последние пустые строки

--   Исправлена ошибка зацикливания на файлах нулевой длины (c)shmuz

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_Trimmer.cfg
return{
  Key="AltDel"; --Prior=50;

  EndLn=true; -- Установить "Пустые строки из конца файла" по умолчанию.
}
-- Конец файла Profile\SimSU\Editor_Trimmer.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_TrimmerRussian.lng
return{
  Descr="Удаление конечных пробелов и символов табуляции и пустых строк. © SimSU";

  Title="Удаление пустот";
  InSelect="Только в выделенном";
  Blanks="Пробелы из окончаний строк";
  AllEmpty="Все пустые строки";
  EndEmpty="Пустые строки из конца файла";
  Footer="Insert - пометить нужные действия";
}
-- Конец файла Profile\SimSU\Editor_TrimmerRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_TrimmerEnglish.lng
return{
  Descr="Removal of final blanks and empty lines. © SimSU";

  Title="Removal of emptiness";
  InSelect="Only in selected";
  Blanks="Blanks from terminations of lines";
  AllEmpty="All empty lines";
  EndEmpty="Empty lines from file end";
  Footer="Insert - mark necessary actions";
}
-- End of file Profile\SimSU\Editor_TrimmerEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_Trimmer"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_Trimmer.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_Trimmer.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Editor_Trimmer={}
-------------------------------------------------------------------------------
local State

function SimSU.Editor_Trimmer.DelBlanks(From,To)
  From= From or 1; To= To or Editor.Lines
  local str,eol,trm
  for i=From,To do str,eol = editor.GetString(nil,i,3); trm=mf.trim(str,2); if str~=trm then editor.SetString(nil,i,trm,eol) end end
end

function SimSU.Editor_Trimmer.DelEmpty(From,To)
  From= From or 1; To= To or Editor.Lines
  for i=To,From,-1 do
    if editor.GetString(nil,i,2)=="" then
      editor.DeleteString()
      if State and State.BlockStartLine and State.BlockHeight then
        if i<State.BlockStartLine then State.BlockStartLine=State.BlockStartLine-1
        elseif i<State.BlockStartLine+State.BlockHeight then State.BlockHeight=State.BlockHeight-1
        end
      end
      if State and i<State.CurLine then State.CurLine=State.CurLine-1 end
      if State and i<State.TopScreenLine then State.TopScreenLine=State.TopScreenLine-1 end
    end
  end
end

function SimSU.Editor_Trimmer.LastLine()
  local i=Editor.Lines
-- while editor.GetString(nil,i,3)=="" do i=i-1 end
-- исправление ошибки зацикливания скрипта на пустых файлах (с)shmuz
  while i>0 and editor.GetString(nil,i,3)=="" do i=i-1 end
  return i
end

function SimSU.Editor_Trimmer.Trim()
  local Items={}
  Items[1]= Object.Selected and ("\2 "..M.InSelect) or M.InSelect
  Items[2]="\2 "..M.Blanks
  Items[3]=M.AllEmpty
  Items[4]= S.EndLn and ("\2 "..M.EndEmpty) or M.EndEmpty

  Items=Menu.Show(table.concat(Items,"\n"),M.Title.."\n"..M.Footer,0x8+0x10,2)

  if Items~=0 then
    local From,To = 1, Editor.Lines
    State = SimSU.Editor_Retentive and SimSU.Editor_Retentive.GetState and SimSU.Editor_Retentive.GetState()
    editor.UndoRedo(nil,far.Flags.EUR_BEGIN)
    if Items:find("1",1,true) then From=Editor.Sel(0,4)==0 and Editor.Pos(0,1) or Editor.Sel(0,0); To= Editor.Sel(0,4)==0 and Editor.Pos(0,1) or Editor.Sel(0,3)==1 and Editor.Sel(0,2)-1 or Editor.Sel(0,2) end
    if Items:find("2",1,true) then SimSU.Editor_Trimmer.DelBlanks(From,To) end
    if Items:find("3",1,true) then SimSU.Editor_Trimmer.DelEmpty(From,To) end
    if Items:find("4",1,true) then SimSU.Editor_Trimmer.DelEmpty(SimSU.Editor_Trimmer.LastLine()+1,Editor.Lines-1) end
    editor.UndoRedo(nil,far.Flags.EUR_END)
    State = SimSU.Editor_Retentive and SimSU.Editor_Retentive.SetState and SimSU.Editor_Retentive.SetState(State)
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Editor_Trimmer=SimSU.Editor_Trimmer} end

local ok, mod = pcall(require,"SimSU.Editor_Trimmer"); if ok then SimSU=mod else _G.SimSU=SimSU end
local ok, mod = pcall(require,"SimSU.Editor_Retentive"); if ok then SimSU.Editor_Retentive=mod.Editor_Retentive end
-------------------------------------------------------------------------------

Macro {area="Editor"; key=S.Key; priority=S.Prior; description=M.Descr;
  action=SimSU.Editor_Trimmer.Trim;
}
