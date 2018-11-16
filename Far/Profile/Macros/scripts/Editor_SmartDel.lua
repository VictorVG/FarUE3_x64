-------------------------------------------------------------------------------
-- Умный Del. © SimSU
-------------------------------------------------------------------------------
-- Умное удаление перевода строки (если курсор находится за последним символом,
-- то после объединения строк первый печатный символ следующей строки будет в позиции курсора)

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_SmartDel.cfg
return{
  Key="Del"; --Prior=50; --Sort=50;
}
-- Конец файла Profile\SimSU\Editor_SmartDel.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_SmartDelRussian.lng
return{
  Descr="Умное удаление перевода строки. © SimSU";
}
-- Конец файла Profile\SimSU\Editor_SmartDelRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_SmartDelEnglish.lng
return{
  Descr="Умное удаление перевода строки. © SimSU";
}
-- End of file Profile\SimSU\Editor_SmartDelEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SmartDel"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_SmartDel.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SmartDel.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------

local function Editor_SmartDel()
  local tEdt=editor.GetInfo()
  local ID=tEdt.EditorID
  local Line=tEdt.CurLine
  local str1=editor.GetString(ID,Line,3)
  local str2=editor.GetString(ID,Line+1,3)
  local Pos=tEdt.CurPos
  local Len=str1:len()
  if Pos<=Len and not str1:sub(Pos):find("%S") then
    editor.SetString(ID,Line,str1:sub(1,Pos-1))
  elseif str1 and str2 then
    if Pos>Len+1 then
      str1=str1..(" "):rep(Pos-Len-1)
    elseif Pos<=Len and mf.trim(str1:sub(Pos))=="" then
      str1=str1:sub(1,Pos-1)
    end
    editor.UndoRedo(ID,0)
    if Pos~=1 then str2=mf.trim(str2,1) end
    editor.DeleteString(ID)
    editor.SetString(ID,Line,str1..str2)
    editor.SetPosition(ID,nil,Pos)
    editor.UndoRedo(ID,1)
  end
end

-------------------------------------------------------------------------------
local function filename() return Editor_SmartDel() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Editor_SmartDel=Editor_SmartDel} end
SimSU.Editor_SmartDel=Editor_SmartDel; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="030c1eb2-ce0d-47e3-b470-0f8f65d55c9b";
  area="Editor"; key=S.Key; priority=S.Prior; sortpriority=S.Sort; description=M.Descr;
  condition=function() return Editor.Sel(0,4)==0 and Editor.RealPos>mf.trim(Editor.Value,2):len() end;
  action=Editor_SmartDel;
}
