-------------------------------------------------------------------------------
-- Умный Del. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_SmartDel.cfg
return{
  Key="Del"; --Prior=50;
}
-- Конец файла Profile\SimSU\Editor_SmartDel.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_SmartDelRussian.lng
return{
  Descr="Умное удаление перевода строки (если курсор находится за последним печатным символом, то после объединения строк первый печатный символ следующей строки будет в позиции курсора).";
}
-- Конец файла Profile\SimSU\Editor_SmartDelRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_SmartDelEnglish.lng
return{
  Descr="Умное удаление перевода строки (если курсор находится за последним печатным символом, то после объединения строк первый печатный символ следующей строки будет в позиции курсора).";
}
-- End of file Profile\SimSU\Editor_SmartDelEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SmartDel"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_SmartDel.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_SmartDel.cfg") or Settings)()

local SimSU=SimSU or {}
-------------------------------------------------------------------------------
function SimSU.Editor_SmartDel()
  local StringNumber=Editor.CurLine
  local str1=editor.GetString(nil,StringNumber,3)
  local str2=editor.GetString(nil,StringNumber+1,3)
  if str1 and str2 then
    local Pos=Editor.RealPos
    local Len=str1:len()
    if Pos>Len+1 then
      str1=str1..(" "):rep(Pos-Len-1)
    elseif Pos<=Len and mf.trim(str1:sub(Pos))=="" then
      str1=str1:sub(1,Pos-1)
    end
    Editor.Undo(0)
    if Pos~=1 then str2=mf.trim(str2,1) end
    editor.DeleteString(nil)
    editor.SetString(nil,StringNumber,str1..str2)
    Editor.Pos(1,2,Pos)
    Editor.Undo(1)
  else
    Keys("AKey")
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Editor_SmartDel=SimSU.Editor_SmartDel} end

local ok, mod = pcall(require,"SimSU.Editor_SmartDel"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Editor"; key=S.Key; priority=S.Prior; description=M.Descr;
  condition=function() return Editor.Sel(0,4)==0 and Editor.RealPos>mf.trim(Editor.Value,2):len() end;
  action=SimSU.Editor_SmartDel;
}
