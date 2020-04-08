-------------------------------------------------------------------------------
-- Список завершения LuaMacro. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_MacroComplete.cfg
return{
  Key="ShiftSpace"; --Prior=50; --Sort=50;

  Addon=[[.
local
break
return
function()  end
in pairs()
if  then  elseif  then  else  end
for =, do  end
for  in  do  end
while  do  end
repeat  until
EdInf
EdStr
EdSel
EdClr
FarColor
EdBkm
EdInp
PlMnI
PlInf
PanelItem
PanelInfo
FPD
  ]]; -- Дополнительные завершения.
  Aliases={
    -- Флаги
    F="far.Flags.";
    -- editor.GetInfo
    EdInf={EditorID=0;FileName="";WindowSizeX=0;WindowSizeY=0;TotalLines=0;CurLine=0;CurPos=1;CurTabPos=1;TopScreenLine=1;LeftPos=1;Overtype=0;BlockType=0;BlockStartLine=1;Options=0;TabSize=8;BookmarkCount=0;SessionBookmarkCount=0;CurState=0;CodePage=65001};
    -- editor.GetString
    EdStr={StringNumber=1;StringText='';StringEOL='';StringLength=0;SelStart=0;SelEnd=0};
    -- editor.GetSelection
    EdSel={BlockType=0;StartLine=1;StartPos=1;EndLine=1;EndPos=0};
    -- editor.GetColor
    FarColor={Flags=0;ForegroundColor=0x0;BackgroundColor=0x0};
    EdClr={StartPos=1;EndPos=1;Priority=0;Flags=0;FarColor={Flags=0;ForegroundColor=0x0;BackgroundColor=0x0};Owner="00000000-0000-0000-0000-000000000000"};
    -- editor.GetBookmarks
    EdBkm={Line=1;Cursor=1;ScreenLine=1;LeftPos=1};
    -- editor.ReadInput
    EdInp={EventType=0;
      --if EventType is KEY_EVENT or FARMACRO_KEY_EVENT:
      KeyDown=false;RepeatCount=0;VirtualKeyCode=0x0;VirtualScanCode=0x0;UnicodeChar=0;ControlKeyState=0;
      --if EventType is MOUSE_EVENT:
      MousePositionX=0;MousePositionY=0;ButtonState=0;ControlKeyState=0;EventFlags=0;
      --if EventType is WINDOW_BUFFER_SIZE_EVENT:
      SizeX=80;SizeY=25;
      --if EventType is MENU_EVENT:
      CommandId=0;
      --if EventType is FOCUS_EVENT:
      SetFocus=0;
    };
    -- tPluginMenuItem
    PlMnI={Count=0;Guids={"binary"};Strings={""};};
    -- far.GetPluginInformation
    PlInf={
      ModuleName="";
      Flags=0;
      PInfo={
        Flags="";
        DiskMenu    ={Count=0;Guids={"binary"};Strings={""};};
        PluginMenu  ={Count=0;Guids={"binary"};Strings={""};};
        PluginConfig={Count=0;Guids={"binary"};Strings={""};};
        CommandPrefix="";
      };
      GInfo={
        MinFarVersion={0,0,0,0,0};
        Version={0,0,0,0,0};
        Guid="binary";
        Title="";
        Description="";
        Author="";
      };
    };
    -- panel.GetPanelItem, panel.GetCurrentPanelItem
    PanelItem={LastWriteTime=0;LastAccessTime=0;CreationTime=0;ChangeTime=0;FileSize=0;AllocationSize=0;FileName="";AlternateFileName="";FileAttributes="";Flags="";NumberOfLinks=0;CRC32=0;Description="";Owner="";CustomColumnData={};UserData=0;};
    -- panel.GetPanelInfo
    PanelInfo={OwnerGuid="";PluginHandle=0;PanelType=0;PanelRect={left=0;top=0;right=0;bottom=0;};ItemsNumber=0;SelectedItemsNumber=0;CurrentItem=0;TopPanelItem=0;ViewMode=0;SortMode=0;Flags=0;};
    --tFarPanelDirectory
    FPD={Name="";Param="";PluginId="";File="";}
  };  -- Псевдонимы.
}
-- Конец файла Profile\SimSU\Editor_MacroComplete.cfg

end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Built-in laguages
local function Messages()
if far.lang=="Russian" then
-- Начало файла Profile\SimSU\Editor_MacroCompleteRussian.lng
return{
  Descr="Список завершения LuaMacro. © SimSU";
}
-- Конец файла Profile\SimSU\Editor_MacroCompleteRussian.lng
else--if far.lang=="English" then
-- Begin of file Profile\SimSU\Editor_MacroCompleteEnglish.lng
return{
  Descr="Список завершения LuaMacro. © SimSU";
}
-- End of file Profile\SimSU\Editor_MacroCompleteEnglish.lng
end end

local M=(loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_MacroComplete"..far.lang..".lng") or Messages)()
local S=(loadfile(win.GetEnv("FARLOCALPROFILE").."\\SimSU\\Editor_MacroComplete.cfg") or loadfile(win.GetEnv("FARPROFILE").."\\SimSU\\Editor_MacroComplete.cfg") or Settings)()

local SimSU=_G.SimSU or {}
-------------------------------------------------------------------------------
S.Addon   = S.Addon  ==nil and Settings().Addon   or S.Addon
S.Aliases = S.Aliases==nil and Settings().Aliases or S.Aliases

local function GetLuaWord(String,Position)
  local str=String or Editor.Value; local pos= Position or Editor.RealPos
  local _,b,e,w
  w,e = str:find("^[a-zA-Z_0-9]+",pos); e= e or pos-1
  b,e,w=str:sub(1,e):find("([a-zA-Z_0-9]+)$")
  return w,b,e
end

local function GetChain(String,Position,Chain)
  local str=String or Editor.Value; local pos= Position or Editor.RealPos; local chain= Chain or {}
  local w,b = GetLuaWord(str,pos); w = w or ""; b = b and b-1 or pos-1; chain[#chain+1]=w
  if str:sub(b,b)=="." then GetChain(str,b,chain) end
end

local function Fields(Chain)
  local function ItField(Table,Prop) for k in pairs(Table) do if Prop==k then return true end end end
  local chain= Chain or {}
  local Table=_G
  for i=#chain,2,-1 do if ItField(Table,chain[i]) then Table=Table[chain[i]] else Table=nil break end end
  if not Table then
    Table=S.Aliases
    for i=#chain,2,-1 do if ItField(Table,chain[i]) then Table=Table[chain[i]] else return end end
  end
  if type(Table)=="string" then Table={Table} end
  local Prop={}
  for k in pairs(Table) do
    local t=type(Table[k])
    if t=="table" then Prop[#Prop+1]=k.."."
    elseif t=="function" then Prop[#Prop+1]=k.."()"
    else Prop[#Prop+1]=k
    end
  end
  if type(Table.properties)=="table" then
    for k in pairs(Table.properties) do Prop[#Prop+1]=k end
  end
  return Prop,Table==_G
end

local function Complete()
  local str=Editor.Value; local pos=Editor.RealPos
  local w,b,e = GetLuaWord(str,pos)
  local chain={}; GetChain(str,pos,chain)
  if #chain==2 and S.Aliases[chain[2]] and type(S.Aliases[chain[2]])=="string" then --Подстановки
    local s=S.Aliases[chain[2]]..chain[1]
    chain={}; GetChain(s,s:len()+1,chain)
  end
  local Items,G = Fields(chain)
  Items=Items and table.concat(Items,"\n"); if G then Items=Items..S.Addon end
  if w then editor.Select(nil,1,0,b,e-b+1,1) else w="" end
  Items=Menu.Show(Items,nil,0x3+0x10+0x20+0x40+0x100,w)
  if Items~="" then
    Editor.Undo(0)
    editor.DeleteBlock(); print(Items)
    Editor.Undo(1)
  else
    Editor.Sel(4)
  end
end
-------------------------------------------------------------------------------
local Editor_MacroComplete={
  GetLuaWord = GetLuaWord;
  GetChain   = GetChain  ;
  Fields     = Fields    ;
  Complete   = Complete  ;
}
local function filename() return Complete() end
-------------------------------------------------------------------------------
if _filename then return filename(...) end
if not Macro then return {Editor_MacroComplete=Editor_MacroComplete} end
SimSU.Editor_MacroComplete=Editor_MacroComplete; _G.SimSU=SimSU
-------------------------------------------------------------------------------

Macro {id="a55f1a7c-e357-43ae-8e13-5386f1f4116e";
  area="Editor"; filemask="*.lua"; key=S.Key; priority=S.Prior; sortpriority=S.Sort; description=M.Descr;
  action=function() return Complete() end;
}
