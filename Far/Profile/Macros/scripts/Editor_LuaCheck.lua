local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info { _filename or ...,
  name        = "Luacheck FAR scripts";
  description = "Using luacheck in FAR editor [tool for linting and static analysis of Lua code]";
  version     = "1.4.4-far5505.lm712"; --http://semver.org/lang/ru/
  author      = "jd"; -- Update up to support lm738+ VictorVG, 18.04.2020 19:41:30 +0300
  url         = "http://forum.farmanager.com/viewtopic.php?f=15&t=9650";
  id          = "73924F99-3AE6-4B3E-9981-ABC0ECB199EC";
  minfarversion = {3,0,0,5106,0}; --luamacro/luafar build 634 (Panel.SetPath)
  require     = "luacheck v0.19 or newer: https://github.com/mpeterv/luacheck";
  --config
  --execute
  --help
  files = "luacheck_far.ru.hlf;scriptscfg.Luacheck.ins;",--more
  options     = {
    --cfgpath=win.GetEnv"LOCALAPPDATA".."\\Luacheck\\",
    --cfgname=".luacheckrc",
    --allow_G   = true, --undocumented

    macrokey  = "CtrlShiftF7",
    filemask  = "*.lua;*.moon;*.lua.cfg",
    menuitem  = "Luacheck",
    configitem= "Luacheck: edit config",

    AutoPos   = true,
    MaxHeight = 10,
    InitPos   = "Bottom", --Top,Bottom or Center
    CycleMode = "ping-pong",

    --debug = true,
  };
  --disabled = true;
}
local function IsLmVer(num)
local lmvr,rt,bld = far.GetPluginInformation(far.FindPlugin("PFM_GUID",win.Uuid("4EBBEFC8-2084-4B7F-94C0-692CE136894D")))
  if lmvr.GInfo.Version[4] >= num then rt=true else rt=false end
  return rt
end

if not nfo or nfo.disabled then return end

local luacheck_min_version = "0.19.0"
local O = nfo.options
O.MaxHeight = O.MaxHeight or 10
O.InitPos = O.InitPos or "Bottom"
local PosCycle ={["Top"]="Bottom",["Bottom"]="Center",["Center"]="Top"}
if not PosCycle[O.InitPos] then O.InitPos = "Bottom" end
if O.CycleMode~="ping-pong" then O.CycleMode = false end

local F = far.Flags
local ptn_path = "^.+[\\/]"

local _path = (...):match(ptn_path)
local files = {
  far_stds="far_standards.lua.cfg",
  cfg_sample=".luacheckrc.sample",
  cfg_name=".luacheckrc",
}
local files_str = nfo.files; for _,v in pairs(files) do files_str = files_str..v..";" end
local function norm(path)
  if path:sub(-1,-1)~="\\" then path = path.."\\" end
  return path
end
local cfgpath = O.cfgpath and norm(O.cfgpath) or _path
local cfgfile = cfgpath..(O.cfgname or files.cfg_name)
if (O.cfgpath or O.cfgname) then files_str = files_str..cfgfile end
nfo.files = files_str
local Check,Config --fwd decl

function nfo.execute() Check() end

function nfo.config() Config() end

local function showHelp(topic)
  far.ShowHelp(_path,topic,F.FHELP_CUSTOMPATH)
end
local function HelpTopic(s)
  return ("<%s>%s"):format(_path,s)
end
function nfo.help() showHelp() end

local function MessagePopup(msg,title,flags,delay)
  local s = far.SaveScreen()
  far.Message(msg,title or "","",flags)
  local key = mf.waitkey(delay or 500); far.RestoreScreen(s)
  return key~="" and key
end

local function traverse(path)
  return function(_,updir)
    return updir:match"^(.+[\\/]).-[\\/]"
  end,nil,path.."\\"
end
local function findLocalCfg(path) --nb! path with trailing \ expected
  for dir in traverse(path) do
    local file = dir..files.cfg_name
    local attr = win.GetFileAttr(file)
    if attr and not attr:find"d" then return file end
  end
end

local luacheck --fwd decl
local function validateCfg(options)
  local res,msg = pcall(luacheck.check_strings,{},options)
  if not res then
    msg = msg:match"#2 to 'luacheck.check_strings' %((.+)%)" or msg
    return nil,msg
  end
  return options
end

local function msgErrCfg(errmsg)
  far.Message("Error in config\n"..errmsg,nfo.name,nil,"w")
end
local mt = {__index=_G}
local luacheck_builtin_standards
local function loadCfgFile(def_file,path) --default file XOR path to local config must be specified
  local file = path and findLocalCfg(path)
  if not file then
    file = def_file
    if not file or not win.GetFileAttr(file) then
      return nil,"no configuration file"..(file and ": "..file or "")
    end
  end
  local f,err = loadfile(file)
  if not f then msgErrCfg(err); return end
  local env = {stds=luacheck_builtin_standards}
  local success,res = pcall(setfenv(f,setmetatable(env,mt)))
  if not success then msgErrCfg(res); return end
  if res~=nil then
    if type(res)~="table" then
      mf.postmacro(msgErrCfg,file.."\nReturned value ignored (must be table)")
    else
      for k,v in pairs(res) do env[k] = v end
    end
  end
  local options,err2 = validateCfg(setmetatable(env,nil))
  if not options then
    mf.postmacro(msgErrCfg,file.."\n"..err2)
  else
    return options
  end
end

local _flags = {EF_ENABLE_F6=1} --http://bugs.farmanager.com/view.php?id=3043
local function editCfg(filename)
  local function MacroAdd(area,flags,key,descr,f)
    local id = far.MacroAdd(
      area or F.MACROAREA_EDITOR,
      flags or F.KMFLAGS_NONE,
      key,
      "--",
      descr or "luacheck temp",
      function()
        return f()
      end,
      100
    )
    return id
  end
  local function Label(Key,Text,LongText)
    local rec = far.NameToInputRecord(Key)
    return {VirtualKeyCode=rec.VirtualKeyCode,ControlKeyState=rec.ControlKeyState,Text=Text,LongText=LongText or Text}
  end

  local err,edited
  local tmp = MacroAdd(nil,nil,"F10","luacheck error config quit",function() err = false end) --or Event?
  local keybar = {Label("F1","HELP"),Label("F5","TEMPLATE"),Label("F10","QUIT"),}
  repeat
    mf.postmacro(function()
      local ei = editor.GetInfo()
      if ei then editor.SetKeyBar(ei.EditorID,keybar) end
    end)
    if F.EEC_MODIFIED==editor.Editor(filename,nil,nil,nil,nil,nil,_flags) or err then
      --todo?? exit if msgErrCfg OK/Ignore
      if loadCfgFile(filename) then edited = true; break end --validate config
      err = true
    end
  until not err
  far.MacroDelete(tmp)
  return edited
end

local function makeNewCfgItem(dir,name,notcurrent)
  local file = dir..name
  local exist = win.GetFileAttr(file) and true
  local default = file==cfgfile and "[default]"
  local current = not notcurrent and exist
  return {
    text = default or exist and file or dir,
    checked = current and true or default and "*" or exist and "+",
    file = file,
    dir = dir,
    name = name,
    selected = current,
    default = default,
  }
end
local props = {
  Title="Choose config location to edit:",
  Bottom="Enter, Ctrl-PgUp, F1",
  HelpTopic=HelpTopic"ConfigList",
  Id=win.Uuid"83B40481-8965-4760-B1F3-409104761A74",
}
local restorePos --fwd decl
local function newCfg(path)
  local items = {}
  local has_current,has_default
  for dir in traverse(path) do
    local t = makeNewCfgItem(dir,files.cfg_name,has_current)
    has_current = has_current or t.selected
    has_default = has_default or t.default
    items[#items+1] = t
  end
  if not has_default then
    table.insert(items,makeNewCfgItem(cfgpath,(O.cfgname or files.cfg_name),has_current))
  end
  local item,pos = far.Menu(props,items,"CtrlPgUp CtrlNum9 Ctrl9")
  if not item then
    return
  elseif item.BreakKey then
    local item = items[pos] --luacheck: no redefined
    Panel.SetPath(0,item.dir,item.name)  --alt: see mbrowser.lua/LocateFile
    local w = far.AdvControl(F.ACTL_GETWINDOWINFO)
    if w.Type==F.WTYPE_PANELS then
      return
    elseif band(w.Flags,F.WIF_MODAL)==0 then
      restorePos()
      for i=1,far.AdvControl(F.ACTL_GETWINDOWCOUNT) do
        if far.AdvControl(F.ACTL_GETWINDOWINFO,i).Type==F.WTYPE_PANELS then
          far.AdvControl(F.ACTL_SETCURRENTWINDOW,i)
          return "break"
        end
      end
    else
      MessagePopup("Unable to leave modal window",nfo.name)
    end
  else
    return editCfg(item.file)
  end
end

function Config()
  local eid = editor.GetInfo()
  newCfg(eid and eid.FileName:match(ptn_path) or far.GetCurrentDirectory().."\\")
end

local Id = "CFD31C22-0D17-4D87-829A-14561B529D34"
local function expandBreakKeys(BreakKeysArr)
  local newBreakKeysArr = {}
  for _,item in ipairs(BreakKeysArr) do
    if item and item.BreakKey then
      for key in item.BreakKey:gmatch("%S+") do
        local newitem = {}
        for k,v in pairs(item) do newitem[k]=v end
        newitem.BreakKey = key
        table.insert(newBreakKeysArr,newitem)
      end
    end
  end
  return newBreakKeysArr
end

local function setEditorPos(info) editor.SetPosition(info.EditorID,info); --[[editor.Redraw()]] end

local bak_pos
function restorePos()
  if bak_pos then
    editor.Select(bak_pos.EditorID,bak_pos)
    setEditorPos(bak_pos)
  end
end

local function scrollEditor(dir)
  local ei = editor.GetInfo()
  ei.TopScreenLine = ei.TopScreenLine+dir
  if ei.TopScreenLine<1 or ei.TopScreenLine>ei.TotalLines-ei.WindowSizeY+1 then mf.beep(); return end
  if ei.CurLine-ei.TopScreenLine-(dir==1 and -1 or ei.WindowSizeY)==0 then
    ei.CurLine = ei.CurLine+dir
  end
  setEditorPos(ei)
end

local list = {}
function list:calcProps(Items,Props)
  self.Pos = self.Pos or O.InitPos
  Items = assert(Items or self.Items,"Items not set")
  local nItems = #Items
  Props = assert(Props or self.Props,"Props not set")
  -- calculate required list's dimensions and position
  local r = far.AdvControl(F.ACTL_GETFARRECT)
  local xSize,ySize = r.Right-r.Left,r.Bottom-r.Top --Far size
  local MaxItems = ySize-3 --max items n to fit
  local X,Y
  X = Items.maxlen<xSize-4 and (xSize-Items.maxlen)/2-2 or -1
  local nLines = math.min(nItems,O.MaxHeight,MaxItems) --actual list lines n
  local Pos = self.Pos or O.InitPos
  local isMaximizable = nItems>nLines and nLines<MaxItems
  local isMaximized = self.isMaximized and isMaximizable
  if Pos=="Center" or isMaximized then
    X,Y = -1,-1
  elseif Pos=="Top" then
    Y = 0
  elseif Pos=="Bottom" then
    Y = MaxItems-nLines>0 and MaxItems-nLines+1+1 or -1
  end
  -- set properties
  Props.X,Props.Y,Props.MaxHeight = X,Y,isMaximized and 0 or O.MaxHeight
  self.Props,self.Items,self.nItems = Props,Items,nItems
  self.nLines,self.isMaximized = nLines,isMaximized
  self.EditorShiftTop = Far.GetConfig"Editor.ShowTitleBar" and 0 or 1
  self.EditorShiftBottom = Far.KeyBar_Show()-1
end
function list:maximize(state)
  self.isMaximized = state==nil and not self.isMaximized or state
  self:calcProps()
end
function list:setPos(Pos)
  if Pos==self.Pos then
    return list:maximize()
  elseif Pos=="ping-pong" then
    if self.Pos=="Center" then
      Pos = self.prevPos=="Top" and "Bottom" or "Top"
    else
      Pos = "Center"
    end
  elseif not Pos then
    Pos = PosCycle[self.Pos] or "Top"
  end
  self.prevPos = Pos~="Center" and Pos or self.prevPos
  self.Pos = Pos
  self.isMaximized = false
  self:calcProps()
end
function list:gotoWarning(pos,to_prev,force_top)
  --??TabToReal
  if pos==0 then return end --https://forum.farmanager.com/viewtopic.php?p=146932#p146932
  local w = self.Items[pos]
  local line = to_prev and w.prev_line or w.line
  if not line then return end
  local column = to_prev and w.prev_column or w.column
  local end_column = not to_prev and w.end_column
  --select
  local width
  if end_column then
    width = end_column-column+1
  elseif w.name then
    width = w.name:len()
  else
    local str = editor.GetString(nil,line)
    if not str then return end
    local a,b = str.StringText:find("^%S+",column)
    width = a and b-a+1 or str.StringLength-column+1
  end
  editor.Select(nil,F.BTYPE_STREAM,line,column,width,1)
  local nLines,TopScreenLine = self.nLines
  if nLines then --trying to correct TopScreenLine in order not to let cursor be hidden behind list
    local ei = editor.GetInfo()
    local y = line-ei.TopScreenLine --calculated screen line of warning
    local a,b = 0,ei.WindowSizeY    --valid screen lines (a..b)
    if self.Pos=="Top" then
      a = a+nLines+3+self.EditorShiftTop
    elseif self.Pos=="Bottom" then
      b = b-nLines-4+1+self.EditorShiftBottom
    end
    TopScreenLine = (y<a or force_top) and math.max(line-a,1)
                 or (y>b)              and line-b
    --win.OutputDebugString(("%s…%s = %s = %s"):format(a,b,y,TopScreenLine or '-'))
  end
  setEditorPos{CurLine=line,CurPos=column,TopScreenLine=TopScreenLine}
end
local _calcpos = {
  Up  =function(pos,last) return pos-1>=1 and pos-1 or last end;
  Down=function(pos,last) return pos+1<=last and pos+1 or 1 end;
}
function list:go(dir,pos,autopos)
  local Items = self.Items
  repeat
    pos = _calcpos[dir](pos,self.nItems)
    --far.Show(pos,Items[pos].hidden)
  until not Items[pos].hidden
  if autopos then self:gotoWarning(pos) end
  return pos
end

local bKeys = expandBreakKeys {
  --main
  {BreakKey="Enter",            action=function(pos)
    if list.Props.SelectIndex~=pos then list:gotoWarning(pos) end
    return "break"
  end},
  {BreakKey="Esc",              action=function() restorePos(); return "break" end},
  {BreakKey="CtrlEnter CtrlPgDn CtrlNum3 Ctrl3",action=function(pos) list:gotoWarning(pos) end},
  {BreakKey="CtrlShiftEnter",   action=function(pos) list:gotoWarning(pos,nil,true) end},
  {BreakKey="CtrlPgUp CtrlNum9 Ctrl9",action=function(pos) list:gotoWarning(pos,true) end},

  --list pos
  {BreakKey="CtrlHome Num7 7",  action=function() list:setPos("Top") end},
  {BreakKey="CtrlEnd  Num1 1",  action=function() list:setPos("Bottom") end},
  {BreakKey="Num4 4",           action=function() list:setPos("Center") end},
  {BreakKey="F6 Divide",        action=function() list:setPos(O.CycleMode) end},
  {BreakKey="F5 Clear 5",       action=function() list:maximize() end},

  --config
  {BreakKey="F9",               action=function()
    local path = editor.GetFileName():match(ptn_path)
    if editCfg(findLocalCfg(path) or cfgfile) then
      mf.postmacro(Check)
      restorePos()
      return "break"
    end
  end},
  {BreakKey="CtrlF9",           action=function()
    local ret = newCfg(editor.GetFileName():match(ptn_path))
    if ret then
      if ret~="break" then
        mf.postmacro(Check)
      end
      restorePos()
      return "break"
    end
  end},

  --editor pos / bookmarks (like @FindAllMenu)
  {BreakKey="CtrlUp CtrlNum8 Ctrl8",action=function() scrollEditor(-1) end}, --??also CtrlLeft/CtrlRight

  {BreakKey="CtrlDown CtrlNum2 Ctrl2",action=function() scrollEditor(1) end},
  {BreakKey="Add",              action=function() editor.AddSessionBookmark() end},
  {BreakKey=[[CS+1 CS+2 CS+3 CS+4 CS+5 CS+6 CS+7 CS+8 CS+9 CS+0
              C+1  C+2  C+3  C+4  C+5  C+6  C+7  C+8  C+9  C+0]],keys=true},

  --{BreakKey="F1",               action=function() showHelp "Editor" end},
  --http://bugs.farmanager.com/view.php?id=1301#c12736
  {BreakKey="Up",               action=function(pos) return list:go("Up",pos,O.AutoPos) end},
  {BreakKey="ShiftUp Num8 8",   action=function(pos) return list:go("Up",pos,not O.AutoPos) end},
  {BreakKey="Down",             action=function(pos) return list:go("Down",pos,O.AutoPos) end},
  {BreakKey="ShiftDown Num2 2", action=function(pos) return list:go("Down",pos,not O.AutoPos) end},

  --debug
  {BreakKey=O.debug and "F3",   action=function(pos) require"le"(list.Items[pos],"Event") end},
  {BreakKey=O.debug and "ShiftF9",action=function() require"le"(O,"Options");list:calcProps() end},
}

local moon_line do
  --[[
  local function get_line(str,pos)
    return = select(3,str:find("([^\n]+)",pos))
  end
  --]]
  local function countLines(str)
    return select(2,str:gsub("\n","\n"))+1
  end
  local function pos2line(str,pos)
    return select(2,str:sub(1,pos):gsub("\n","\n"))+1
  end
  function moon_line(s,lua_line,name)
    for i = lua_line, 0, -1 do
      if s.moon_map[i] then
        local start = pos2line(s.moon_text,s.moon_map[i])
        if name and i~=lua_line then
          for j=i,countLines(s.lua_text) do
            if s.moon_map[j] then
              for l = start,pos2line(s.moon_text,s.moon_map[j])-1 do
                if editor.GetString(nil,l).StringText:find(name) then
                  start = l
                end
              end
            end
          end
        end
        return start
      end
    end
    for i=lua_line+1,countLines(s.lua_text) do
      if s.moon_map[i] then
        return pos2line(s.moon_text,s.moon_map[i])
      end
    end
    return 1
  end
end

local function xform(s,line,name)
  line = moon_line(s,line,name)
  local column,end_column,no_line
  if name then
    --column,end_column = s.source[line]:find(name)
    column,end_column = string.find(s.source[line],"%f[%a_]"..name.."%f[^%w_]")
    no_line = not column or nil
  end
  if not name or not column then
    column,end_column = s.source[line]:find"%S.+$"
    if not column then column,end_column=1,-1 end
  end
  return line,column,end_column,no_line
end
local function moon_form(s,w)
  w.line,w.column,w.end_column,w.no_line = xform(s,w.line,w.name)
  if w.prev_line then
    local _
    w.prev_line,w.prev_column,_,w.no_prev_line = xform(s,w.prev_line,w.name)
  end
end

local dlgTitle
local function loadLuacheck()
  if not luacheck then
    local _luacheck = require "luacheck"
    if _luacheck._VERSION<luacheck_min_version then
      package.loaded.luacheck = nil
      far.Message(("luacheck version %s or newer expected"):format(luacheck_min_version),
                  nfo.name,nil,"w")
      return
    end
    luacheck = _luacheck
    dlgTitle = ("%s v%s [%s]"):format(nfo.name,nfo.version,luacheck._VERSION)
  end
  -- import far_standards
  --https://github.com/mpeterv/luacheck/issues/120
  luacheck_builtin_standards = require "luacheck.builtin_standards"
  if not luacheck_builtin_standards.luafar then
    local ret = loadCfgFile(_path..files.far_stds)
    if ret and ret.stds then
      for k,v in pairs(ret.stds) do
        luacheck_builtin_standards[k] = v
      end
    --else far.Message("Far standards not loaded",nfo.name,nil,"w")
    end
  end
  return true
end

local function filterWarn(w)
  local remove --todo
  --[[
  if w.secondary then
    w.checked = "²"--http://luacheck.readthedocs.io/en/stable/warnings.html#secondaryvaluesandvariables
  end
  --]]
  if (w.no_line or w.no_prev_line) then
    w.checked = "¬"
  end
  if w.code:sub(1,2)=="11" then --todo cache,init
    assert(w.name)
    local var = _G[w.name]
    if var and w.field then
      for field in w.field:gmatch"[^.]+" do
        var = type(var)=="table" and var
        if not var then break end
        var = var[field]
      end
    end
    if var then
      w.checked = "?"
      if O.allow_G then w.hidden = true end
      --todo what if list gets empty
    end
  end
  return not remove
end

local Props = {
  Bottom="Ctrl-Enter, Ctrl-Up/Down, F5, F6, [Ctrl]F9, F1";
  HelpTopic=HelpTopic"Editor",
  Id=win.Uuid(Id);
}
local function ProcessName(mask,file)
  return far.ProcessName(F.PN_CMPNAMELIST,mask,file,F.PN_SKIPPATH)
end

function Check()
  if not loadLuacheck() then return end
  local ei,ConvertToAnsi = editor.GetInfo()
  if not ei then return end
  local sel = editor.GetSelection()
  if sel then --save for further restoring
    ei.BlockStartPos = sel.StartPos
    ei.BlockWidth = sel.EndPos-sel.StartPos+1
    ei.BlockHeight = sel.EndLine-sel.StartLine+1
  end
  bak_pos = ei
  local source = {}
  for i=1,ei.TotalLines do source[i] = editor.GetString(nil,i).StringText end
  local text = table.concat(source,"\n")

  -- Make BugFix for https://github.com/mpeterv/luacheck/issues/45 compatible this LuaMacro b738 or newer.
  if IsLmVer(738) then
   if not utf8.utf8valid(text) then ConvertToAnsi = true else ConvertToAnsi = false end
  else
   ConvertToAnsi = true
  end

  if ConvertToAnsi then text = win.WideCharToMultiByte(win.Utf8ToUtf16(text),win.GetACP()) end
  local isMoon = ProcessName("*.moon",ei.FileName)
  local moon_info
  if isMoon then
    local to_lua = require"moonscript.base".to_lua
    local lua_text,v = to_lua(text)
    if lua_text then
      moon_info = {
        moon_text =text,
        lua_text  =lua_text,
        moon_map  =v,
        source    =source,
      }
      text = lua_text
    else
      local err = v
      local err1,line,err2 = err:match"^(.-) %[(%d+)%] >>%s*(.+)$"
      if line then
        editor.Select(nil,F.BTYPE_STREAM,line,1,-1,1)
        setEditorPos{CurLine=line}
        err = err1..err2
      end
      if -1==far.Message(err,nfo.name,nil,"lw") and line then
        restorePos()
      end
      return
    end
  end
  local options = loadCfgFile(cfgfile,ei.FileName:match(ptn_path)) or {}
  local report = luacheck.check_strings({text}, options)[1]
  if not report then
    far.Message("Internal error: unable to get report",dlgTitle,nil,"w")
  elseif #report==0 then
    local key = MessagePopup("No warnings\n\1\nF1,F9,CtrlF9",dlgTitle,nil,2000)
    if not key then --luacheck: ignore 542
      --
    elseif key=="F9" then
      if editCfg(findLocalCfg(ei.FileName:match(ptn_path)) or cfgfile) then
        mf.postmacro(Check)
      end
    elseif key=="CtrlF9" then
      local res = newCfg(ei.FileName:match(ptn_path))
      if res and res~="break" then mf.postmacro(Check) end
    elseif key=="F1" then
      showHelp()
    elseif key~="Esc" then
      mf.postmacro(Keys,key)
    end
  else -- proceed with warnings list
    local Items,pos,maxlen,err = {},nil,0
    for i,w in ipairs(report) do
      if O.debug then --?? always store w separately, but copy needed values to list item
        local r = {}
        for k,v in pairs(w) do r[k] = v end
        w.report = r
      end
      if isMoon then moon_form(moon_info,w) end
      local rtype = w.code:sub(1,1)
      w.checked = ({['0']="‼",['1']="!"})[rtype]
      err = rtype=="0"
      w.text =  ("%4u:%-3u "):format(w.line,w.column)..
                ("│ %s%s │ "):format(err and "E" or "W",w.code)..
                luacheck.get_message(w)
      local len = w.text:len()
      maxlen = len>maxlen and len or maxlen
      if err or filterWarn(w) then
        --todo select item with position nearest to current editor cursor pos
        if not pos and not w.hidden and
           w.line==ei.CurLine and w.column==ei.CurPos then
          pos = i
        end
        Items[#Items+1] = w
        if O.debug then
          if not w.end_column then mf.beep() end
          if not w.report.end_column then w.error = "no end_column" end
          if w.line>ei.TotalLines then w.error = "line > TotalLines" end
          if w.error then w.checked ="?" end
        end
      end
    end
    Items.maxlen = maxlen
    if err then mf.beep(); mf.postmacro(MessagePopup,"Errors found!",nfo.name,"w",300) end
    Props.Title = dlgTitle
    list:calcProps(Items,Props)
    if not O.AutoPos then --luacheck: ignore 542
      --nop
    elseif pos then
      list:gotoWarning(pos)
    else
      list:go("Down",0,true)
    end

    repeat --todo use dialog instead of menu
      -- show list
      Props.SelectIndex = pos
      local item
      item,pos = far.Menu(Props,Items,bKeys)
      -- process breakkeys
      if not item then
        break
      elseif item.keys then
        --bookmarks
        Keys(item.BreakKey:gsub("^CS%+","CtrlShift"):gsub("^C%+","Ctrl"))
      elseif not item.action then
        list:gotoWarning(pos)
      else
        pos = item.action(pos) or pos
        if pos=="break" then break end
      end
    until false
  end
  bak_pos = false
end

Event { description="luacheck menu handler";
  group="DialogEvent";
  id="DCAC7C0A-273E-4124-AAAD-66EDE3E6A695";
  action=function(Event,param)
    local hDlg,Msg = param.hDlg,param.Msg
    if Msg==F.DN_RESIZECONSOLE then
      if Event==F.DE_DLGPROCINIT and Menu.Id==Id then
        hDlg:send(F.DM_CLOSE,-1,0)
        list:calcProps()
      end
    elseif Msg==F.DN_INITDIALOG and Event==F.DE_DLGPROCINIT then
      local info = hDlg:send(F.DM_GETDIALOGINFO)
      if info and info.Id==win.Uuid(Id) then
        local r = hDlg:send(F.DM_GETITEMPOSITION,1)
        hDlg:send(F.DM_SETITEMPOSITION,1,{Left=r.Left-2,Top=r.Top-1,Right=r.Right-2,Bottom=r.Bottom-1})
        r = hDlg:send(F.DM_GETDLGRECT)
        hDlg:send(F.DM_RESIZEDIALOG,0,{Y=r.Bottom-r.Top-1,X=r.Right-r.Left-3})
        hDlg:send(F.DM_MOVEDIALOG,0,{X=2,Y=list.Pos=="Bottom" and 1 or 0})
      end
    end
  end;
}

Macro { description="luacheck menu helper";
  area="Menu";  key="ShiftUp ShiftDown";  flags="NoSendKeysToPlugins";
  id="60596FEB-E7C5-47A5-A3C9-B782C8F8EF93";
  condition=function() return O.AutoPos and Menu.Id==Id end;
  action=function()
    Keys(mf.akey(1,1):match"Up" and "Num8" or "Num2")
  end;
}

if O.macrokey then Macro { description="luacheck: process current editor";
  area="Editor";  key=O.macrokey;  filemask=O.filemask;
  id="CE634ECE-1039-43F3-80CC-8BB17B1FDB05";
  action=Check;
}end

MenuItem { description="luacheck: process current editor";
  menu="Plugins"; area="Editor";
  text=function()
    if O.menuitem and not O.filemask or ProcessName(O.filemask,editor.GetFileName()) then
      return O.menuitem
    end
  end;
  guid="65A8DFFA-C1D8-402E-AC70-41888DC9849D";
  action=function() mf.postmacro(Check) end;
}

MenuItem { description="luacheck: edit config";
  menu="Config"; text=O.configitem;
  guid="A0389309-4E3E-4020-A72D-5B2145E7FF48";
  action=Config;
}

Macro { description="Help on .luacheckrc editing";
  area="Editor"; key="F1";
  priority=60;
  filemask=files.cfg_name;files.cfg_sample;
  id="956F6E8E-502D-4DE1-A47D-BFDC3590F033";
  action=function()
    showHelp"Edit.luacheckrc"
  end;
}

Macro { description="Insert .luacheckrc template";
  area="Editor"; key="F5";
  priority=60;
  filemask=files.cfg_name;
  id="21878EEF-5AE5-4A08-B1B3-EDCDD2BD0AFD";
  action=function()
    local ei = editor.GetInfo()
    if ei.CurLine~=1 or ei.CurPos~=1 then
      far.Message("File need to be empty to insert template",nfo.name,nil,"w")
    else
      local id = ei.EditorID
      local file = io.open(_path..files.cfg_sample)
      local template = file:read("*a")
      editor.UndoRedo(id,F.EUR_BEGIN)
      editor.InsertText(id,template)
      editor.UndoRedo(id,F.EUR_END)
      editor.SetPosition(id,1,1)
    end
  end;
}
