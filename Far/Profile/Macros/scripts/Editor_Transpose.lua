-------------------------------------------------------------------------------
-- Транспонирование (строки превращаются в столбцы) текста. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_Transpose.cfg
return{
  Key="AltT"; --Prior=50;

  Seporator="\t";
  EOL=nil;
  NotSeporator="%S+";
  NotEOL="[^\r\n]+";
}
-- Конец файла Profile\SimSU\Editor_Transpose.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_TransposeRussian.lng
return{
  Descr="Транспонирование (строки превращаются в столбцы) текста. © SimSU";
}
-- Конец файла Profile\SimSU\Editor_TransposeRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_TransposeEnglish.lng
return{
  Descr="Транспонирование (строки превращаются в столбцы) текста. © SimSU";
}
-- End of file Profile\SimSU\Editor_TransposeEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_Transpose"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_Transpose.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_Transpose.cfg") or Settings)()

local SimSU=SimSU or {}
SimSU.Editor_Transpose={}
-------------------------------------------------------------------------------
function SimSU.Editor_Transpose.Text(txt,notsep,noteol,sep,eol)
  local notsep= notsep or "%S+"
  local noteol= noteol or "[^\r\n]+"
  local sep= sep or "\t"
  local eol= eol or "\r\n"
  local i,j = 1,1
  local res={}
  for str in txt:gmatch(noteol) do
    i=1
    for wrd in str:gmatch(notsep) do
      if not res[i] then res[i]={} end
      res[i][j]=wrd
      i=i+1
    end
    j=j+1
  end
  for i=1,#res do res[i]=table.concat(res[i],sep) end
  return table.concat(res,eol)..eol
end

function SimSU.Editor_Transpose.Sel()
  local Sel=editor.GetSelection()
  local Inf=editor.GetInfo()
  local Beg= Sel and Sel.StartLine or Inf.CurLine
  local End= Sel and Sel.EndLine or Inf.CurLine
  if (Inf.CurLine>=Beg and Inf.CurLine<=End) or (Inf.CurLine==End+1 and Sel and Sel.EndPos==-1) then
    local _,EOL=editor.GetString(nil,Beg,3)
    local txt=Editor.SelValue
    txt=SimSU.Editor_Transpose.Text(txt,S.NotSeparator,S.NotEOL,S.Seporator,S.EOL or EOL)
    Editor.Undo(0) editor.DeleteBlock() print(txt) Editor.Undo(1)
  end
end;
-------------------------------------------------------------------------------
if not Macro then return {Editor_Transpose=SimSU.Editor_Transpose} end

local ok, mod = pcall(require,"SimSU.Editor_Transpose"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Editor"; key=S.Key; priority=S.Prior; description=M.Descr; flags="";
  condition=function() return true end;
  action=SimSU.Editor_Transpose.Sel;
}
