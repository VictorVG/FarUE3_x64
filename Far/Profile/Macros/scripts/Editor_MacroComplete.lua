-------------------------------------------------------------------------------
-- Список завершения LuaMacro. © SimSU
-------------------------------------------------------------------------------

---- Настройки
local function Settings()
-- Начало файла Profile\SimSU\Editor_MacroComplete.cfg
return{
  Key="ShiftSpace"; --Prior=50;

  Addon=[[
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
  ]]; -- Дополнительные завершения.
  Aliases={
    -- Флаги
    F="far.Flags.";
    -- editor.GetInfo
    tEdt={EditorID=0;FileName="";WindowSizeX=0;WindowSizeY=0;TotalLines=0;CurLine=0;CurPos=1;CurTabPos=1;TopScreenLine=1;LeftPos=1;Overtype=0;BlockType=0;BlockStartLine=1;Options=0;TabSize=8;BookmarkCount=0;SessionBookmarkCount=0;CurState=0;CodePage=65001};
    -- editor.GetString
    tStr={StringNumber=1;StrinText='';StringEOL='';StringLength=0;SelStart=0;SelEnd=0};
    -- editor.GetSelection
    tSel={BlockType=0;StartLine=1;StartPos=1;EndLine=1;EndPos=0};
    -- editor.GetColor
    tFarColor={Flags=0;ForegroundColor=0x0;BackgroundColor=0x0};
    tClr={StartPos=1;EndPos=1;Priority=0;Flags=0;Color={Flags=0;ForegroundColor=0x0;BackgroundColor=0x0};Owner="00000000-0000-0000-0000-000000000000"};
    -- editor.GetBookmarks
    tBkm={Line=1;Cursor=1;ScreenLine=1;LeftPos=1};
    -- editor.ReadInput
    tInp={EventType=0;
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
    }
  };  -- Псевдонимы.
}
-- Конец файла Profile\SimSU\Editor_MacroComplete.cfg     tStr. tClr.Color.  _G. tBkm.

end

---- Локализация
_G.far.lang=far.lang or win.GetEnv("farlang")
-- Встроенные языки / Buildin laguages
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

local SimSU=SimSU or {}
SimSU.Editor_MacroComplete={}
-------------------------------------------------------------------------------
local Addon=S.Addon or ""
local Aliases=S.Aliases or {}

function SimSU.Editor_MacroComplete.GetLuaWord(str,pos)
  local str=str or Editor.Value; local pos= pos or Editor.CurPos
  local b,e = str:cfind("^[a-zA-Z_0-9]+",pos); e= e or pos-1
  local b,e,w=str:sub(1,e):cfind("([a-zA-Z_0-9]+)$"); return w,b,e
end

function SimSU.Editor_MacroComplete.GetChain(str,pos,Chain)
  local str=str or Editor.Value; local pos= pos or Editor.CurPos
  local Chain= Chain or {}
  local w,b,e = SimSU.Editor_MacroComplete.GetLuaWord(str,pos); w= w or ""; b=b and b-1 or pos-1; Chain[#Chain+1]=w
  if str:sub(b,b)=="." then SimSU.Editor_MacroComplete.GetChain(str,b,Chain) end
end

function SimSU.Editor_MacroComplete.ItField(Table,Prop)
  for k in pairs(Table) do if Prop==k then return true end end
end

function SimSU.Editor_MacroComplete.Fields(Chain)
  local Chain= Chain or {}
  local Table=_G
  for i=#Chain,2,-1 do if SimSU.Editor_MacroComplete.ItField(Table,Chain[i]) then Table=Table[Chain[i]] else Table=nil break end end
  if not Table then
    Table=Aliases
    for i=#Chain,2,-1 do if SimSU.Editor_MacroComplete.ItField(Table,Chain[i]) then Table=Table[Chain[i]] else return end end
  end
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

function SimSU.Editor_MacroComplete.Complete()
  local str=Editor.Value; local pos=Editor.CurPos
  local w,b,e = SimSU.Editor_MacroComplete.GetLuaWord(str,pos)
  local Chain={}; SimSU.Editor_MacroComplete.GetChain(str,pos,Chain)
  if #Chain==2 and Aliases[Chain[2]] and type(Aliases[Chain[2]])=="string" then --Подстановки
    local s=Aliases[Chain[2]]..Chain[1]
    Chain={}; SimSU.Editor_MacroComplete.GetChain(s,s:len()+1,Chain)
  end
  local Items,G = SimSU.Editor_MacroComplete.Fields(Chain)
  Items=Items and table.concat(Items,"\n"); if G then Items=Items..Addon end
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
if not Macro then return {Editor_MacroComplete=SimSU.Editor_MacroComplete} end

local ok, mod = pcall(require,"SimSU.Editor_MacroComplete"); if ok then SimSU=mod else _G.SimSU=SimSU end
-------------------------------------------------------------------------------

Macro {area="Editor"; filemask="*.lua"; key=S.Key; priority=S.Prior; description=M.Descr;
  action=SimSU.Editor_MacroComplete.Complete;
}
