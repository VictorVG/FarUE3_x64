-------------------------------------------------------------------------------
-- Редактирование описания файла в редакторе. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Shell_Description.cfg
return{
  Key="CtrlZ"; --Prior=50;
}
-- Конец файла Profile\SimSU\Shell_Description.cfg
end

_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Shell_DescriptionRussian.lng
return{
  Descr="Редактирование описания файла в редакторе. © SimSU";
}
-- Конец файла Profile\SimSU\Shell_DescriptionRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Shell_DescriptionEnglish.lng
return{
  Descr="Editing the description of a file in the editor. © SimSU";
}
-- End of file Profile\SimSU\Shell_DescriptionEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_Description"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Shell_Description.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Shell_Description.cfg") or Settings)()

local SimSU=SimSU or {}
-------------------------------------------------------------------------------
function SimSU.Shell_Description()
--
--  panel.GetCurrentPanelItem(nil,1).Shell_Description НЕ РАБОТАЕТ если у панели не включен режим описаний :(, а Panel.Item(0,0,11) РАБОТАЕТ :)
--
--  local Item=panel.GetCurrentPanelItem(nil,1) far.Show(panel.GetCurrentPanelItem(nil,1).Shell_Description)
--  local File=Item.FileName
--  if not Item.Shell_Description then Keys("CtrlZ Space Enter") end
  local File=Panel.Item(0,0,0)
  if Panel.Item(0,0,11)=="" then Keys("CtrlZ Space Enter") end
--
  local quot="[%s"..Far.Cfg_Get("System","QuotedSymbols"):gsub("%S","%%%0").."]"
  if File:find(quot) then File='"'..File..'"' end File=File..' '
  local path=panel.GetPanelDirectory(nil,1).Name
  local ListNames=Far.Cfg_Get("Descriptions","ListNames")
  local DescrName
  for Name in ListNames:gmatch("[^,]+") do
    if win.GetFileAttr(path.."\\"..Name) then DescrName=Name break end
  end
  editor.Editor(DescrName,nil,nil,nil,nil,nil,far.Flags.EF_NONMODAL+far.Flags.EF_IMMEDIATERETURN)
  local Text
  for i=0,editor.GetInfo(nil).TotalLines-1 do
    Text=editor.GetString(-1,i,3)
    if Text:find(File,1,true)==1 then
      editor.SetPosition(-1,i,File:len()+1,-1,i)
      break
    end
  end
end
-------------------------------------------------------------------------------
if not Macro then return {Shell_Description=SimSU.Shell_Description} end

local ok, mod = pcall(require,"SimSU.Shell_Description"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Shell"; key=S.Key; priority=S.Prior; description=M.Descr; flags="NoPluginPanels";
  action=SimSU.Shell_Description;
}
