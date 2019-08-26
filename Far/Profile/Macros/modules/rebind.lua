local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {
  name        = "module: rebind";
  description = "easy control of macro bindings etc";
  version     = "1.1";
  author      = "jd";
  url         = "http://forum.farmanager.com/viewtopic.php?f=15&t=10376";
  id          = "C0C38A84-1F6D-436D-96D6-7053AC7BEA4F";
  minfarversion = {3,0,0,4743,0}; --LuaMacro 580
  files       = "~\\bindings;~\\bindings.sample;~\\_macroinit.lua.rebind.sample;~\\FarMenu.rebind.ini;";
}

local F = far.Flags
if not nfo then
  return
elseif not nfo.index and select(4,far.AdvControl(F.ACTL_GETFARMANAGERVERSION,true))<=nfo.minfarversion[4] then
  error("requires FAR 3 build>"..nfo.minfarversion[4])
end

local def_file = win.GetEnv"FARPROFILE".."\\Macros\\scripts\\bindings"
local loaded_file
nfo.config    = function(nfo)
  editor.Editor(loaded_file or def_file,nil,nil,nil,nil,nil,"EF_OPENMODE_QUERY",nil,nil,65001)
  far.AdvControl"ACTL_REDRAWALL"--bug??
end;

local _NAME = nfo.name
local _KEY = "REBIND" -- default key name in luamacro db

for i=1,math.huge do
  local m = mf.GetMacroCopy(i)
  if m then -- ensure that loaded before any macro
    if m.FileName then error(_NAME.." should be loaded in '_macroinit.lua'",2) end
  else
    break
  end
end

local REBIND --loaded settings

local usedUids = {}
local auto_uids,no_warnings

local function MakeUid(file,descr)
  return ("≈%s: %s"):format(file:match"[^\\]+$",descr or 'nil') -- ±≠≡∞ƒ≈
end

local editall
local function editBadUid(id,file,pos)
  local msg = ("%s:%s: id is not unique:\n%q"):format(file,pos,id)
  local buttons = "Skip;&Skip all;&Edit;Edit &all"
  local ans = editall or far.Message(msg,"Warning",buttons,"wl")
  if ans==4 then editall = bor(F.EF_NONMODAL,F.EF_IMMEDIATERETURN) end
  if editall or ans==3 then editor.Editor(file,nil,nil,nil,nil,nil,editall,pos) end
  if ans==2 then no_warnings = true end
end

local LoadedMacros --array, forward decl.

local new_fields = {"rebinded","defline","disabled","bindfrom"} --info to store
local function AddMacroNew(m,filename)
  if type(m)~="table" then return end
  if not filename then return mf.AddMacro(m) end
  local currentline = debug.getinfo(3,"l").currentline --todo check timings
  --if currentline==-1 then le(debug.getinfo(3)) end --fixme
  m.defline = currentline~=-1 and currentline
  m.id = m.id or m.uid or auto_uids and MakeUid(filename,m.description)
  if not m.id or type(m.id)~="string" then --luacheck: ignore 542
    --just skip
  elseif not usedUids[m.id:lower()] then          --check if id is unique
    local Binding = REBIND[m.id:lower()] or {}
    if Binding.key then m.rebinded,m.key = m.key,Binding.key end
    m.disabled = Binding.disabled
    m.bindfrom = Binding.bindfrom
  else
    if not no_warnings then editBadUid(m.id,filename,currentline) end
    m.id = nil
  end
  local Macro = mf.AddMacro(m,filename)
  if Macro and Macro.id and Macro.id~="<no id>" then
    for _,field in ipairs(new_fields) do Macro[field] = Macro[field] or m[field] end
    usedUids[Macro.id:lower()] = Macro.index
  end
  return Macro
end

local function AddEventNew(m,filename)
  if type(m)~="table" then return end
  local currentline = debug.getinfo(3,"l").currentline
  m.defline = currentline~=-1 and currentline
  m.id = m.id or m.uid or auto_uids and MakeUid(filename,m.description)
  if not m.id or type(m.id)~="string" then --luacheck: ignore 542
    --just skip
  elseif not usedUids[m.id:lower()] then          --check if id is unique
    local Binding = REBIND[m.id:lower()] or {}
    m.disabled = Binding.disabled
    m.bindfrom = Binding.bindfrom
  else
    if not no_warnings then editBadUid(m.id,filename,currentline) end
    m.id = nil
  end
  local Event = mf.AddEvent(m,filename)
  if Event and Event.id and Event.id~="<no id>" then
    Event.original_condition = Event.condition
    local prio = Event.priority or 50
    Event.condition = function(...)
      if not Event.disabled then
        return not Event.original_condition and prio or Event.original_condition(...)
      end
    end
    for _,field in ipairs(new_fields) do Event[field] = Event[field] or m[field] end
    usedUids[Event.id:lower()] = Event.index
  end
  return Event
end

do --get LoadedMacros, set AddMacro
  local function getUpvalue(f,name)
    for i=1,1000 do
      local k,v = debug.getupvalue (f,i)
      if k==nil then
        error("unable to get upvalue: "..name)
      end
      if k==name then return v,i end
    end
  end
  LoadedMacros = getUpvalue(mf.GetMacroCopy,"LoadedMacros")
  local LoadMacros = getUpvalue(eval,"utils").LoadMacros
  local AddMacro,iAddMacro = getUpvalue(LoadMacros,"AddRegularMacro")
  local AddEvent,iAddEvent = getUpvalue(LoadMacros,"AddEvent")
  if not mf.AddMacro then mf.AddMacro,mf.AddEvent = AddMacro,AddEvent end --luacheck: new globals mf
  debug.setupvalue (LoadMacros,iAddMacro,assert(AddMacroNew))
  debug.setupvalue (LoadMacros,iAddEvent,assert(AddEventNew))
end

---------------------------------------
-- public functions [common]

local function Setup(options)
  assert(type(options)=="table")
  auto_uids = options.auto_uids or auto_uids
  no_warnings = options.no_warnings or no_warnings
end

---------------------------------------
-- public functions [settings in files]

local function Rebind(m)
  local id = m.id or m.uid or m.FileName and m.description and
              MakeUid(m.FileName, m.description)
  local err = type(m)~="table" and "arg must be table"
              or not id and "macro id must be specified"
  local info = debug.getinfo(2,"lS")
  local bindfrom = {FileName=info.source:match"@?(.+)", defline=info.currentline} --names must match
  if err then
    err = ("%s\n%s:%s"):format(err,bindfrom.FileName,bindfrom.defline)
    far.Message(err,_NAME,nil,"w")
  else
    REBIND[id:lower()] = { disabled=m.disabled, key=m.key, bindfrom=bindfrom }
  end
end

local mloadkey --fwd decl.
local function LoadBindings(profile,db)
  assert(not profile or type(profile)=="string")
  if db then
    REBIND = mloadkey(profile or _KEY) or {}
    _KEY = profile
  else
    profile = profile or def_file
    loaded_file = profile
    local f,err = loadfile(profile)
    if err then far.Message(err,_NAME,nil,"w"); return end
    local success,res = pcall(setfenv(f, {Rebind=Rebind, NoRebind=function()end}))
    if not success then far.Message(res,_NAME,nil,"w"); return end
  end
  --le(REBIND)
end

--[[
do
REBIND = {}
return {
  Setup=Setup,
  Rebind=Rebind,
  LoadBindings=LoadBindings,
}
end
--]]

-------------------------------------
-- private functions [settings in db]

function mloadkey(key)
  local obj = far.CreateSettings()
  local tbl
  local subkey = obj:OpenSubkey(0, key)
  if subkey then
    tbl = {}
    local enum = obj:Enum(subkey)
    for i = 1,enum.Count do
      local name = enum[i].Name
      local chunk = obj:Get(subkey, name, F.FST_DATA)
      tbl[name:lower()] = assert(loadstring(chunk))()
    end
  end
  obj:Free()
  return tbl
end
REBIND = mloadkey(_KEY) or {}

local function GetMacroIdx(id)
  assert(id,"macro id not specified")
  local idx = usedUids[id:lower()]
  return idx, not idx and "specified macro not found" or nil
end

local function GetMacro(id)
  local idx,err = GetMacroIdx(id)
  return idx and LoadedMacros[idx], err
end

local function SaveMacro(m,keys) --expects correct args
  local Binding
  --if keys is not specified then look for current key (if rebinded)
  keys = keys or (keys==nil) and m.rebinded and m.key
  if m.disabled or keys then
    Binding = { key         = keys or nil, -- false == revert to original
                disabled    = m.disabled or nil,
                description = m.description,
                FileName    = m.FileName }
    mf.msave(_KEY,m.id,Binding)
  else
    mf.mdelete(_KEY,m.id)
  end
  REBIND[m.id] = Binding
  mf.msave(_KEY,"RebindProfile",_KEY) --http://forum.farmanager.com/viewtopic.php?p=139818#p139818
end

------------------------------------
-- public functions [settings in db]

local function MacroRebind(id,keys)
  assert(type(keys or nil)=="string","'key' must be string")
  local m,err = GetMacro(id)               --macro with specified id must be loaded
  if err                                   --id not found
         or keys=="" and not m.rebinded    --nothing to do: empty keys
         or keys==m.key then               --nothing to do: unchanged keys
    return nil,err or "nothing to do"
  elseif keys=="" or keys==m.rebinded then --if keys are empty or match to original
    keys = false                           --THEN need to delete record from base
  end                                      --(false == revert to original)
  SaveMacro(m,keys)
  return true --!! macros reload needed to apply rebind
end

local function MacroDisable(id,disable)
  local m,err = GetMacro(id)
  if err then
    return nil,err
  elseif type(disable)=="boolean" then
    m.disabled = disable        --set if true|false
  else
    m.disabled = not m.disabled --otherwise toggle
  end
  SaveMacro(m)
  return m.disabled
end

-----------------------------------
-- extra functions [settings in db]

local function MessagePopup(msg,title,flags,delay) --private
  local s = far.SaveScreen()
  far.Message(msg,title or "","",flags)
  win.Sleep(delay or 500); far.RestoreScreen(s)
end

local function MacroRebind_Prompt(id)
  local idx,err = GetMacroIdx(id)
  if err then far.Message(id or "nil",err,nil,"w"); return end --todo
  local m = mf.GetMacroCopy(idx)
  local title = "Enter new key"..
                (m.rebinded and (" [orig.: %s]"):format(m.rebinded) or "")
  local msg = ("Macro: %q"):format(m.description or "index="..m.index)
  local flags = F.FIB_ENABLEEMPTY + F.FIB_BUTTONS
  local keys = far.InputBox(nil,title,msg,id,m.key,nil,nil,flags)
  if not keys then return end
  local success,err = MacroRebind(id,keys) --luacheck: ignore 411/err
  if err then mf.postmacro(MessagePopup,err) else return success end
end

local function MacroDisable_Msg(id,disable)
  local disabled,err = MacroDisable(id,disable)
  if err then
    far.Message(id or "nil",err,nil,"w")
  else
    mf.postmacro(MessagePopup,disabled and "disabled" or "enabled")
  end
  return not err and disabled,err
end

return {
  _NAME=_NAME,
  _VERSION=nfo.version,
  _URL=nfo.url,
  getCurProfile = function() return _KEY end,

  Setup=Setup,
--[settings in files]
  Rebind=Rebind,
  LoadBindings=LoadBindings,
--[settings in db]
  MacroRebind=MacroRebind,    --(id), return: (true) or (nil,err)
  MacroDisable=MacroDisable,  --(id[,disable]), return (current status) or (nil,err)
--sample helpers [settings in db]
  MacroRebind_Prompt=MacroRebind_Prompt,
  MacroDisable_Msg=MacroDisable_Msg,
--  GetMacroIdx,
}
