﻿--[[This scrip update for use shared dictionaries whit plug-in Hunspell by Artem Senichev
    plug-in find by patch '%FARHOME%\plug-ins\editor\hunspell'.
    For running this script press Shift+F3 button, then use F3 button for spell check
    highlighted word and then operation is completed press Shift+F3 again.

    This script modifed by VictorVG for progects Far Manager UE3 at Thu Jun 16 02:10:33 +0300 2016
    Git commit ad293542f9f5389c7144d16f96a13175e957481b, 15.06.2016, updated zg

    Rus

    /* инструкция написана t-rex  */

    для работы нужны:

1.  dll от проекта http://nhunspell.sourceforge.net/
    отсюда http://sourceforge.net/projects/nhunspell/files/ берётся архив с последней версией
    и из него нужны либо Hunspellx86.dll, либо Hunspellx64.dll - именно эти dll чисто нативные,
    никакого .net-а в них нет. положить их нужно куда-нибудь, откуда они загрузятся, например в
    папку с фаром.
2.  словари. по умолчанию макрос настроен на вот этот
    http://extensions.openoffice.org/en/project/russian-dictionary-%D1%91 русский словарь
    (нужны файлы ru_RU_yo.aff и ru_RU_yo.dic),
    и вот этот http://extensions.openoffice.org/en/project/english-dictionaries-apache-openoffice
    английский словарь (нужны файлы en_US.aff и en_US.dic).
    по умолчанию словари ожидаются в %FARHOME%\plugins\editor\hunspell\dict .
--]]

local F=far.Flags
local config=
{
  --ru
  {
    dictionary=[[%FARHOME%\plugins\editor\hunspell\dict\ru_RU_yo.dic]],
    affix=[[%FARHOME%\plugins\editor\hunspell\dict\ru_RU_yo.aff]],
    regexstr=[[/[а-яёА-ЯЁ]+/]],
    color={Flags=bit64.bor(F.FCF_FG_4BIT,F.FCF_BG_4BIT),ForegroundColor=0xff00000f,BackgroundColor=0xff000004},
    active=true
  },

  {
    dictionary=[[%FARHOME%\plugins\editor\hunspell\dict\ru_RU.dic]],
    affix=[[%FARHOME%\plugins\editor\hunspell\dict\ru_RU.aff]],
    regexstr=[[/[а-яёА-ЯЁ]+/]],
    color={Flags=bit64.bor(F.FCF_FG_4BIT,F.FCF_BG_4BIT),ForegroundColor=0xff00000f,BackgroundColor=0xff000004},
    active=true
  },

  --en
  {
    dictionary=[[%FARHOME%\plugins\editor\hunspell\dict\en_US.dic]],
    affix=[[%FARHOME%\plugins\editor\hunspell\dict\en_US.aff]],
    regexstr=[[/[a-zA-Z]+/]],
    color={Flags=bit64.bor(F.FCF_FG_4BIT,F.FCF_BG_4BIT),ForegroundColor=0xff00000f,BackgroundColor=0xff000002},
    active=true
  }
}

local editors={}
local colorguid=win.Uuid("46CCE102-965A-4e2d-8263-B59F268C74C8")
local active=false
local ffi=require("ffi")
local C=ffi.C
ffi.cdef[[
void* HunspellInit(void* affixBuffer,size_t affixBufferSize,void* dictionaryBuffer,size_t dictionaryBufferSize,wchar_t* key);
void HunspellFree(void* handle);
bool HunspellSpell(void* handle,const wchar_t* word);
wchar_t** HunspellSuggest(void* handle,const wchar_t* word);
int lstrlenW(wchar_t* lpString);
]]
local hunspell=ffi.load("hunspell"..(win.GetEnv("PROCESSOR_ARCHITECTURE"):gsub("AMD64","x64")))

local function LoadFile(filename)
  local file=io.open(filename,"rb")
  local data
  if file then
    data=file:read("*a")
    file:close()
    local result=ffi.new("uint8_t[?]",#data)
    ffi.copy(result,data,#data)
    return result,#data
  end
end

local function ExpandEnv(str) return (str:gsub("%%(.-)%%",win.GetEnv)) end

local function Init()
  for _,v in ipairs(config) do
    v.dict_data,v.dict_len=LoadFile(ExpandEnv(v.dictionary))
    v.affix_data,v.affix_len=LoadFile(ExpandEnv(v.affix))
    if v.dict_data and v.affix_data then
      v.handle=hunspell.HunspellInit(v.affix_data,v.affix_len,v.dict_data,v.dict_len,nil)
      v.regex=regex.new(v.regexstr)
    else
      v.active=false
    end
  end
  Init=function() end
end

local function GetData(id)
  local data=editors[id]
  if not data then
    editors[id]={start=0,finish=-1}
    data=editors[id]
  end
  return data
end

local function ToWChar(str)
  str=win.Utf8ToUtf16(str)
  local result=ffi.new("wchar_t[?]",#str/2+1)
  ffi.copy(result,str)
  return result
end

local function ShowMenu(strings,wordLen)
  local info=editor.GetInfo()
  local menuShadowWidth=2
  local menuOverheadWidth=menuShadowWidth+4 --6 => 2 рамка, 2 тень, 2 место для чекмарка
  local menuOverheadHeight=3 --3 => 2 рамка, 1 тень
  local menuWidth=0
  local listItems={}
  for _,v in ipairs(strings) do
    menuWidth=math.max(menuWidth,v:len())
    table.insert(listItems,{Flags=0,Text=v})
  end
  local menuHeight=1
  local coorX=info.CurTabPos-info.LeftPos
  local coorY=info.CurLine-info.TopScreenLine
  local menuX=math.max(0,coorX-menuWidth-menuOverheadWidth+menuShadowWidth)
  menuX=(info.WindowSizeX-coorX)>(coorX+2-wordLen) and (coorX+1) or menuX --меню справа или слева от слова?
  local menuY=0
  if (info.WindowSizeY-coorY-1)>coorY+1 then --меню сверху или снизу?
    --снизу
    menuY=coorY+2
    menuHeight=info.WindowSizeY-menuY+1-menuOverheadHeight
    menuHeight=math.min(menuHeight,#strings)
  else
    --сверху
    menuY=coorY-#strings-1
    if menuY<1 then menuY=1 end
    menuHeight=coorY-menuY-1
  end

  --fix menu width
  if (menuX+menuWidth+menuOverheadWidth)>info.WindowSizeX then
    menuWidth=info.WindowSizeX-menuX-menuOverheadWidth
  end

  local items={
    {"DI_LISTBOX",0,0,menuWidth+3,menuHeight+1,listItems,0,0,0,""}
  }
  local function DlgProc(dlg,msg,param1,param2)
  end
  local dialog=far.DialogInit(win.Uuid("ECD10910-8CC6-4685-AA8D-7D7413DD7D06"),menuX,menuY,menuX+menuWidth+3,menuY+menuHeight+1,nil,items,0,DlgProc)
  local result=far.DialogRun(dialog)>0 and far.SendDlgMessage(dialog,F.DM_LISTGETCURPOS,1).SelectPos or nil
  far.DialogFree(dialog)
  return result
end

local function CheckSpell()
  Init()
  local pos,pos2=editor.GetInfo(-1).CurPos,0
  local line=editor.GetString(-1,-1)
  local linestr=line.StringText
  local word=""
  if pos<=linestr:len()+1 then
    local slab=pos>1 and linestr:sub(1,pos-1):match('[%w_]+$') or ""
    local tail=linestr:sub(pos):match('^[%w_]+') or ""
    pos2=pos-slab:len()
    word=slab..tail
  end
  if word~="" then
    local word_data=ToWChar(word)
    for _,v in ipairs(config) do
      if v.active and v.regex:match(word) and not hunspell.HunspellSpell(v.handle,word_data) then
        local suggestions=hunspell.HunspellSuggest(v.handle,word_data)
        local ii,items=0,{}
        while suggestions[ii]~=ffi.NULL do
          table.insert(items,win.Utf16ToUtf8(ffi.string(suggestions[ii],2*C.lstrlenW(suggestions[ii]))))
          ii=ii+1
        end
        if #items>0 then
          local sel=ShowMenu(items,word:len())
          if sel then
            linestr=line.StringText:sub(1,pos2-1)..items[sel]..line.StringText:sub(pos2+word:len())
            editor.SetString(-1,0,linestr,line.StringEol)
          end
        end
        break
      end
    end
  end
end

local function CheckSpellAll(ei)
  Init()
  local start,finish=ei.TopScreenLine,math.min(ei.TopScreenLine+ei.WindowSizeY-1,ei.TotalLines)
  local regex=regex.new([[/\b\i+\b/]])
  for ii=start,finish do
    local line=editor.GetString(ei.EditorID,ii).StringText
    local pos=1
    while true do
      local sbegin,send=regex:find(line,pos)
      if not sbegin then break end
      pos=send+1
      local word=line:sub(sbegin,send)
      for _,v in ipairs(config) do
        if v.active and v.regex:match(word) and not hunspell.HunspellSpell(v.handle,ToWChar(word)) then
          editor.AddColor(ei.EditorID,ii,sbegin,send,F.ECF_AUTODELETE,v.color,199,colorguid)
          break
        end
      end
    end
  end
end

Event
{
  group="EditorEvent";
  action=function(id,event,param)
    if event==F.EE_READ then
      editors[id]={start=0,finish=-1}
    end
    if event==F.EE_CLOSE then
      editors[id]=nil
    end
    if event==F.EE_REDRAW then
      if active then
        CheckSpellAll(editor.GetInfo(id))
      end
    end
  end
}

Event
{
  group="ExitFAR";
  action=function()
    for _,v in ipairs(config) do
      if v.active and v.handle then
        hunspell.HunspellFree(v.handle)
      end
    end
  end
}

Macro
{
  area="Editor";key="F3";description="Spell Checker";
  action=CheckSpell
}

Macro
{
  area="Editor";key="ShiftF3";description="highlight spell errors";
  action=function()
    active=not active
    editor.Redraw(-1)
  end
}
