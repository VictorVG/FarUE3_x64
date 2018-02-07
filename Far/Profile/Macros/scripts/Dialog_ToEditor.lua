-------------------------------------------------------------------------------
-- Редактирование поля ввода диалога в редакторе. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Dialog_ToEditor.cfg
return{
  Key="F4"; --Prior=50;
}
-- Конец файла Profile\SimSU\Dialog_ToEditor.cfg
end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\SimSU\Dialog_ToEditorRussian.lng
return{
  Descr="Редактирование поля ввода диалога в редакторе. © SimSU";
  Title="Возврат в диалог";
  Question="Текст содержит управляющие символы, заменить их на пробелы?";
}
-- Конец файла Profile\SimSU\Dialog_ToEditorRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Dialog_ToEditorEnglish.lng
return{
  Descr="Editing of entry field of dialog in the editor. © SimSU";
  Title="Return to dialog";
  Question="The text contains operating symbols, to replace them with space?";
}
-- End of file Profile\SimSU\Dialog_ToEditorEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Dialog_ToEditor"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Dialog_ToEditor.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Dialog_ToEditor.cfg") or Settings)()

local SimSU=SimSU or {}
-------------------------------------------------------------------------------
function SimSU.Dialog_ToEditor()
  local Title="   "..Dlg.GetValue(1,0).."->"..Dlg.GetValue(Dlg.CurPos-1,0)
  local Text=Dlg.GetValue(-1) -- Забираем весь текст из строки ввода.
  local FileName=far.MkTemp() -- Запрашиваем имя временного файла.
  local File=io.open(FileName,"w+b") -- Открываем временный файл в режиме записи.
  if File then -- Файл открылся нормально.
    File:write(Text); File:close() --Записываем в него наш текст и закрываем.
    local ss=far.SaveScreen() -- Сохраняем экран, а то после закрытия редактора перерисовывается только диалог.
    local EditorResult=editor.Editor(FileName,Title,0,0,-1,-1,far.Flags.EF_DISABLEHISTORY,1,1,nil) -- Запускаем редактор с нашим файлом и работаем в нём.
    far.RestoreScreen(ss) -- Восстановим фон.
    if EditorResult==far.Flags.EEC_MODIFIED then -- Редактор отработал нормально и файл изменился.
      File=io.open(FileName,"rb") -- Опять открываем наш файл, но для чтения
      if File then -- Файл открылся.
        Text=File:read("*a"); File:close() -- Читаем всё из файла и закрываем.
        if Text then -- Есть данные.
          if Text:find("%c") and msgbox(M.Title,M.Question,0x40000)==1 then
            -- Заменяем управляющие символы пробелами.
            Text=Text:gsub("%c+"," ")
          end
          Keys("CtrlY"); print(Text) -- Вставляем данные в поле ввода с заменой.
        end
      end
    end
    win.DeleteFile(FileName) -- Удаляем наш временный фай.
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Dialog_ToEditor=SimSU.Dialog_ToEditor} end

local ok, mod = pcall(require,"SimSU.Dialog_ToEditor"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Dialog"; key=S.Key; priority=S.Prior; description=M.Descr;
  condition=function() return Dlg.ItemType==4 end;
  action=SimSU.Dialog_ToEditor;
}
