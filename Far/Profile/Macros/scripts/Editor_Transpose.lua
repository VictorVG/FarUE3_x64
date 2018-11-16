-------------------------------------------------------------------------------
-- Транспонирование (строки превращаются в столбцы) текста. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_Transpose.cfg
return{
  Key="AltT"; --Prior=50; --Sort=50;

  Seporator   ="\t";
  EOL         ="\r\n";
  NotSeporator="%S+";
  NotEOL      ="[^\r\n]+";
}
-- Конец файла Profile\SimSU\Editor_Transpose.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_TransposeRussian.lng
return{
  Descr="Транспонирование (строки превращаются в столбцы) текста. © SimSU";
  Err="Матрица не прямоугольная, результат получится с искажениями."
}
-- Конец файла Profile\SimSU\Editor_TransposeRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_TransposeEnglish.lng
return{
  Descr="Транспонирование (строки превращаются в столбцы) текста. © SimSU";
  Err="Матрица не прямоугольная, результат получится с искажениями."
}
-- End of file Profile\SimSU\Editor_TransposeEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_Transpose"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_Transpose.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_Transpose.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
S.Seporator   = S.Seporator    or "\t"
S.EOL         = S.EOL          or "\r\n"
S.NotSeporator= S.NotSeporator or "%S+"
S.NotEOL      = S.NotEOL       or "[^\r\n]+"

local function Text(txt,notsep,noteol,sep,eol)
  notsep= notsep~=nil and notsep or S.NotSeporator
  noteol= noteol~=nil and noteol or S.NotEOL
  sep   = sep   ~=nil and sep    or S.Seporator
  eol   = eol   ~=nil and eol    or S.EOL
  local j,mi,i = 1, 0
  local res,Err = {},false
  for str in txt:gmatch(noteol) do
    i=1
    for wrd in str:gmatch(notsep) do
      if not res[i] then res[i]={} end
      res[i][j]=wrd
      i=i+1
    end i=i-1
    mi=math.max(i,mi)
    j=j+1
  end j=j-1
  for k=1,mi do for l=1,j do if not res[k][l] then res[k][l]=""; Err=true end end end
  for k=1,#res do res[k]=table.concat(res[k],sep) end
  return table.concat(res,eol)..eol, Err
end

local function Sel()
  local tSel=editor.GetSelection()
  local tEdt=editor.GetInfo()
  local ID=tEdt.EditorID
  local Beg= tSel and tSel.StartLine or tEdt.CurLine
  local End= tSel and tSel.EndLine   or tEdt.CurLine
  if (tEdt.CurLine>=Beg and tEdt.CurLine<=End) or (tEdt.CurLine==End+1 and tSel and tSel.EndPos==0) then
    local _,eol=editor.GetString(ID,Beg,3)
    local txt, Err=Editor.SelValue
    txt,Err=Text(txt,S.NotSeporator,S.NotEOL,S.Seporator,eol)
    if not(Err and far.Message(M.Err,M.Descr,";OkCancel","w")~=1) then
      editor.UndoRedo(ID,0); editor.DeleteBlock(); print(txt); editor.UndoRedo(ID,1)
    end
  end
end

-------------------------------------------------------------------------------
local Editor_Transpose={
  Text = Text;
  Sel  = Sel ;
}
local function filename() Sel() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Editor_Transpose=Editor_Transpose} end
SimSU.Editor_Transpose=Editor_Transpose; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="62ac13e3-d49b-4335-b8b5-00bb8830fed5";
  area="Editor"; key=S.Key; priority=S.Prior; sortpriority=S.Sort; description=M.Descr;
  action=Sel;
}
