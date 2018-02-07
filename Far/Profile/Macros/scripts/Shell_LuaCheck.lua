local Made4FAR = "Intended to run in Far Manager environment"

local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info { _filename or ...,
  name        = "luacheck commandline";
  description = "Using luacheck in FAR cmdline [tool for linting and static analysis of Lua code]";
  version     = "1.4"; --http://semver.org/lang/ru/
  author      = "jd";
  url         = "http://forum.farmanager.com/viewtopic.php?f=15&t=9650";
  id          = "08AE8FB9-940C-4679-9EC7-0D3C8BA25E59";
  parent_id   = "73924F99-3AE6-4B3E-9981-ABC0ECB199EC";
  minfarversion = {3,0,0,4371,0}; --CommandLine (luamacro/luafar build 513)
  require     = "luacheck v0.19 or newer: https://github.com/mpeterv/luacheck";
  options     = {
    --lua     = "luajit.exe",
    --luapath = assert(os.getenv"FARHOME",Made4FAR)

    --cfgpath = os.getenv"LOCALAPPDATA".."\\Luacheck\\",
    --cfgname = ".luacheckrc",
  };
  --disabled = true;
}
if not nfo or nfo.disabled then return end
local O = nfo.options

local files = {
  far_stds="far_standards.lua.cfg",
  cfg_name=".luacheckrc",
  lua="luajit.exe",
  ansicon="ansicon.exe",
}
local ptn_path = "^.+[\\/]"
if CommandLine then --loaded as macrofile
  local function norm(path)
    if path:sub(-1,-1)~="\\" then path = path.."\\" end
    return path
  end
  local function q(str,force) --quote
    return (force or str:find(" ",1,"plain")) and '"'..str..'"' or str
  end

  local lua = O.lua or files.lua
  lua = O.luapath and norm(O.luapath)..lua or win.SearchPath(nil,lua)
  local command
  if lua then
    local self = ...
    local cfgpath = O.cfgpath and norm(O.cfgpath) or self:match(ptn_path)
    local cfgfile = cfgpath..(O.cfgname or files.cfg_name)
    command = ('%s %s --default-config %s'):format(q(lua),q(self),q(cfgfile))
  end
  local Oem = win.Utf8ToOem
  CommandLine {
    description=nfo.name;
    prefixes="luacheck";
    action=function(prefix,text)
      if not command or not win.GetFileAttr(lua) then
        far.Message(("lua interpreter not found: %s"):format(q(lua or O.lua or files.lua)),nfo.name,nil,"w")
        return
      end
      local cmdline = command.." "..text
      if text:find"[>]" then --redirection detected
        cmdline = cmdline.." --no-color"
      elseif not win.GetEnv"ANSICON" then --color support provided by ansicon or ConEmu
        local ansicon = win.SearchPath(nil,files.ansicon)
        if ansicon then --adding COMSPEC call, otherwise os.getenv fails (or we can assign os.getenv = win.GetEnv)
          cmdline = ('%s %s /c "%s"'):format(q(ansicon),q(win.GetEnv"COMSPEC"),cmdline)
          --cmdline = ('%s %s'):format(q(ansicon),cmdline)
        end
      end
      local _dir = win.GetCurrentDir()
      local fardir = far.GetCurrentDirectory()
      panel.GetUserScreen()
      local ok,msg = pcall(io.write,Oem(("\n%s>%s:%s\n\n"):format(fardir,prefix,text)))
      if not ok then
        far.Message(msg,"Error",nil,"w")
      elseif not win.SetCurrentDir(fardir) then
        io.write("Internal error: unable to set directory: ",Oem(fardir))
      else
        --io.write(Oem(cmdline),"\n")
        win.system(q(cmdline,true))
        win.SetCurrentDir(_dir)
      end
      panel.SetUserScreen()
    end;
  }
elseif ... then --executed from commandline
  if unicode then
    print("Error:","Unicode environment is not supported\n","Use plain lua/luajit (instead of lflua/lfjit)")
    return
  end
  local modules_path = assert(os.getenv"FARPROFILE",Made4FAR).."\\Macros\\modules\\"
  package.path = modules_path.."?.lua;"..modules_path.."?\\init.lua"

  local luacheck_min_version = "0.19.0"
  local luacheck = require "luacheck"
  if luacheck._VERSION<luacheck_min_version then
    print("Error:",("luacheck version %s or newer expected\n"):format(luacheck_min_version),
                   ("Your version:    %s"):format(luacheck._VERSION))
    return
  end

  local path = arg[0]:match(ptn_path)
  require "luacheck.config".load_config(path..files.far_stds) --https://github.com/mpeterv/luacheck/issues/107
  require "luacheck.main"
end