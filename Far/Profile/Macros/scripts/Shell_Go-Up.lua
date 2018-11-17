--quick mod by JD

--[[ Go up in the file system by AltPgUp, version 2016.05.11.2
See https://forum.farmanager.com/viewtopic.php?p=149195#p149195
Based on CDup http://forum.farmanager.com/viewtopic.php?p=83477#p83477
History:
 Version 2016.05.09.1:
  1. Menu items are prefixed with hotkeys from 0 to Z, further items are just padded with spaces.
  2. Selecting an item means positioning onto that directory rather than jumping into it --
     absence of the separator (‘\’) at the paths' ends reminds of that.
  3. The macro is assigned the AltPgUp shortcut.
 Version 2016.05.09.2:
  1. Fixed the host-file (pre-separator) item.
  2. Added opening the Disks menu when trying to jump onto the drive letter item.
  3. Internal: fixed how hotkeys are prepended to the items.
 Version 2016.05.10.1:
  1. Docs: added the History to the source code.
  2. Fixed handling of the plugin-FS-topmost (pre-separator) item for plugins with no host file.
  3. Internal: improved code decomposition.
 Version 2016.05.11.1:
  1. Added an option to only display the last path component. ON by default.
  2. Added an option to display the directories top-down from root to current. ON by default.
  3. Added menu GUID.
  4. Added ability to go onto the chosen item on the passive panel by ShiftEnter.
     It's only implemented for real paths (as opposed to virtual plugin-FS ones).
  5. Docs: added TODO 1 (see below).
  6. Internal: improved code decomposition, removed some redundant code, added diagnostics.
 Version 2016.05.11.2:
  1. Removed trailing white space.
  2. Docs: added TODO 2 (see below).
  3. Published at https://forum.farmanager.com/viewtopic.php?p=149195#p149195.
TODO:
 1. Support jumping onto virtual plugin-FS items on the passive panel (the SameFolder plugin can).
 2. Support plugin panels using '/' as a separator, e.g. NetBox.
]]
 
local Options = {
  displayLastComponentOnly = true;
  displayDirsRootToCurrent = false;
}
 
local GUID = win.Uuid('B301ACCB-36CB-4961-B353-05E8A5FC5CA6')
 
--{ Utilities
local function mapped( tbl, func )  -- can be used as foreach if func mutates its arg
  local res = {}
  for k,v in pairs(tbl) do
    res[k] = func(v)  -- TODO maybe pass key as an optional argument?
  end
  return res
end
 
local function reverse( arr )
  for i = 1, #arr / 2 do
    arr[i], arr[#arr - i + 1] = arr[#arr - i + 1], arr[i]
  end
end
 
local function concat( tbl, delim )
  return table.concat( mapped( tbl, tostring ), delim )
end
 
-- Based on https://rosettacode.org/wiki/Non-decimal_radices/Convert#Lua
local function num2base( n, base )
  local result = n == 0 and 0 or ''
  while n > 0 do
    local digit = n % base
    if digit > 9 then
      digit = string.char(digit + 87)
    end
    n = math.floor( n / base )
    result = digit .. result
  end
  return result
end
--}
 
local function appendPaths( items, path, plugin )
  while path ~= nil do
    local idx = #items
    for _,item in pairs(items) do
      idx = idx - ( item.separator and 1 or 0 )
    end
    -- 36 is the number of characters in [0-9A-Z]
    local hotkey = idx < 36 and num2base( idx, 36 ) or ' '
    items[ #items + 1 ] = { hotkey = hotkey; path = path; plugin = plugin; }
    path = path:match('(.*)\\[^\\]+$')
  end
end
 
local symbol = Options.displayDirsRootToCurrent and "└" or "┌"
local function attachText( v )
  local path = v.path
  if path then
    if Options.displayLastComponentOnly then
      path = path:match('([^\\]+)$') or '\\'  -- root is required e.g. for FarReg
    end
    local extra = path:len() - Far.Width + 11  -- TODO get rid of magic constants
    path = extra <= 0 and path or '...' .. path:sub( extra + 4 )
    local level = select(2,v.path:gsub("\\","\\"))
    local branch = level==0 and "" or (" "):rep(level-1)..symbol
    v.text = '&' .. v.hotkey .. ' ' .. branch .. path
  end
end
 
local function jumpOntoItem( item, panel )
  local dir, file = item.path:match('(.*)\\([^\\]+)$')
  dir = dir or item.path  -- for paths like 'D:'
  local realPaths = true
  if item.plugin > 0 then
    realPaths = band( APanel.OPIFlags, 0x20 ) ~= 0
    -- For plugin panels with no host file, e.g. Registry browser (a.k.a. FarReg)
    if not file then
      dir, file = '\\', dir  -- for paths like 'HKEY_CURRENT_USER'
    end
  end
  local _ = concat --far.Message( concat( { item.path, dir, file }, '\n' ) )
  if file then
    if realPaths or panel == 0 then
      Panel.SetPath( panel, dir:match('\\') and dir or dir .. '\\', file )
    else
      far.Message( 'Jumping onto virtual paths in the passive panel '..
                   'is not implemented yet.\n'..
                   'Sorry for the inconvenience.', 'Go Up' )
    end
  else
    Keys('F9 ' .. ( panel > 0 and 'Tab' or '' ) .. ' Down Up Enter')  -- opens the Drives menu
  end
end
 
local function formAndExecMenu()
  local items = {}
  if APanel.Plugin then
    appendPaths( items, APanel.Path, 1 )
    if items[1] then
      if APanel.HostFile then
        items[ #items ].path = APanel.HostFile
        items[ #items ].plugin = 0;  -- for it to be usable for the passive panel
      end
      items[ #items + 1 ] = { separator = true }
    end
  end
  appendPaths( items, APanel.Path0, 0 )
  mapped( items, attachText )
  local currDirIdx = 1
  if Options.displayDirsRootToCurrent then
    reverse( items )
    currDirIdx = #items
  end
  local props = { Title = 'Go up to ...'; Bottom = 'Shift-/Enter' }
  props.SelectIndex = currDirIdx; props.Id = GUID;
  if items[1] then
    local item, idx = far.Menu( props, items, { { BreakKey = 'S+RETURN'; panel = 1 } } )
    local _ = item and jumpOntoItem( item.text and item or items[idx], item.panel or 0 )
  end
end
 
if not Macro then return formAndExecMenu() end --!!added by jd

Macro {
  description = 'Go up in the File System';
  area = 'Shell'; key = 'AltPgUp';
  condition = function() return APanel.Visible end;
  action = formAndExecMenu;
}
