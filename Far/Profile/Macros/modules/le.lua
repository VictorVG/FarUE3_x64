local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info { _filename or ...,
	name        = "Lua Explorer Advanced";
	description = "Explore Lua environment in your Far manager";
	version     = "2.3";
	author      = "jd";
	url         = "http://forum.farmanager.com/viewtopic.php?f=60&t=7988";
	id          = "C61B1E8D-71D4-445C-85A6-35EA1D5B6EF3";
	licence     = [[
based on Lua Explorer by EGez http://forum.farmanager.com/viewtopic.php?f=15&t=7521

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
ANY USE IS AT YOUR OWN RISK.]];
	help = function(nfo)
		far.Message(nfo.helpstr, ('%s v%s'):format(nfo.name,nfo.version),nil,"l")
	end;
	options     = {
		tables_first = true,
		ignore_case = true,
	};
}
if not nfo or nfo.disabled then return end
local O = nfo.options

assert(far,'This is LuaExplorer for Far manager')

local uuid	= win.Uuid('7646f761-8954-42ca-9cfc-e3f98a1c54d3')
nfo.helpstr	= [[

There are some keys available:

F1              Show this help
F4              Edit selected object
Del             Delete selected object
Ins             Add an object to current table
Ctrl+M          Show metatable
Ctrl+F          Show/hide functions
Ctrl+T          Toggle sort by type
Ctrl+I          Toggle ignore case

for functions:

Enter           Call function (params prompted)
F3              Show some function info
Shift+F3        Show some function info (LuaJIT required)
Alt+F4          Open function definition (if available) in editor
Ctrl+Up         Show upvalues (editable)
Ctrl+Down       Show environment (editable)


Copy to clipboard:

Ctrl+Ins        value
Ctrl+Shift+Ins  key
]]

local omit = {}
local brkeys = {}

-- format values for menu items and message boxes
local function valfmt(val,mode)
	local t = type(val)
	if t == 'string' then
		val = val:utf8valid() and val or ('!! invalid utf8 [%q]'):format(win.Utf16ToUtf8(win.MultiByteToWideChar (val,win.GetACP())))
		if val:match'%z' or mode=='edit' then
			val = ('%q'):format(val)
		elseif mode~='view' and (mode~='list' or val=='' or val:sub(-1,-1)==" ") then
			val = '"'..val..'"'
		end
		return val,t
	elseif t == 'number' then
		return (mode=='edit' and '0x%x --[[ %s ]]' or '0x%08x (%s)'):format(val, val),t
	end
	return tostring(val),t
end

-- make menu item for far.Menu(...)
local key_w = 30
local item_fmt = ('%%-%s.%ss'):format(key_w,key_w)..'%s%-8s │%-25s'
local function makeItem(key, sval, vt)
	local k = valfmt(key,'list')
	local border = k:len()<=key_w and '│' or '…'
	return {
		text    = item_fmt:format(k, border, vt, sval),
		key     = key,
		type    = vt,
		checked = vt=='table' and '≡'        --⁞≡•·÷»›►
		          or vt=='function' and '˜'  --ᶠ¨˝˜
	}
end

-- create sorted menu items with associated keys
local function makeMenuItems(obj)
	local items = {}

	-- grab all 'real' keys
	for key in pairs(obj) do
		local sval, vt = valfmt(obj[key],'list')
		if not omit[vt] then
			table.insert(items, makeItem(key, sval, vt))
		end
	end

	-- Far uses some properties that in fact are functions in obj.properties
	-- but they logically belong to the object itself. It's all Lua magic ;)

	--if getmetatable(obj)=="access denied" then ...
	local success,props = pcall(function()return obj.properties end)
	--if not success then far.Message(props,'Error in __index metamethod',nil,'wl') end
	if type(props) == 'table' and not rawget(obj, 'properties') then
	--if type(obj.properties) == 'table' and not rawget(obj, 'properties') then
	--todo use list of APanel Area BM CmdLine Dlg Drv Editor Far Help Menu Mouse Object PPanel Panel Plugin Viewer
		for key in pairs(obj.properties) do
			local sval, vt = valfmt(obj[key],'list')
			if not omit[vt] then
				table.insert(items, makeItem(key, sval, vt))
			end
		end
	end

--	table.sort(items, function(v1, v2)	return v1.text < v2.text end)
--[[
	table.sort(items, function(v1, v2)
		if O.tables_first and (v1.type=='table') ~= (v2.type=='table') then
			return v1.type=='table'
		else
			return v1.text < v2.text
		end
	end)
--]]
---[[
	table.sort(items, function(v1, v2)
		if O.tables_first and v1.type~=v2.type then
			return v1.type=='table' or v2.type~='table' and v1.type<v2.type
		else
			if O.ignore_case then
				return v1.text:lower() < v2.text:lower()
			else
				return v1.text < v2.text
			end
		end
	end)
--]]
	return items
end

local function getres(stat,...)
	return stat, stat and {...} or (...) and tostring(...) or '', select('#',...)
end

local function checknil(t,n)
	for i=1,n do
		if t[i]==nil then	return true	end
	end
end

local function concat(t,delim,i,j) --custom concat (applies 'tostring' to each item)
	--assert(delim and i and j)
	local s = j>0 and tostring(t[i]) or ''
	for ii=i+1,j do s = s..delim..tostring(t[ii]) end
	return s
end

local function luaexp_prompt(Title,Prompt,Src,nArgs)
	repeat
		local expr = far.InputBox (nil, Title:gsub('&','&&',1), Prompt,
		                           Title, Src, nil, nil, far.Flags.FIB_ENABLEEMPTY)
		if not expr then	break	end
		local f,err = loadstring('return '..expr)
		if f then
			local stat,res,n = getres(pcall(f))
			if stat then
				if not nArgs or (nArgs==n and not checknil(res,n)) then
					return res, n, expr
				else
					err = ([[
%d argument(s) required

  Expression entered: %q
  Evaluated as %d arg(s): %s]]):format(nArgs,expr,n,concat(res,',',1,n))
				end
			else
				err = res
			end
		end
		far.Message(err,'Error',nil,'wl')
	until false
end

-- edit or remove object at obj[key]
local function editValue(obj, key, title, del)
	if del then
	local message = ('%s is a %s, do you want to remove it?')
		:format(valfmt(key), type(obj[key]):upper())
		if 1 == far.Message(message, 'REMOVE: ' .. title,';YesNo','w') then
			obj[key] = nil
		end
	else
		local v, t = valfmt(obj[key], 'edit')
		if t == 'table' or t == 'function' then	v = ''	end
		local prompt = ('%s is a %s, type new value as Lua code'):format(valfmt(key),t:upper())
		local res = luaexp_prompt('EDIT: ' .. title, prompt, v, 1)
		if res then	obj[key] = res[1]	end
	end
end

-- add new element to obj
local function insertValue(obj, title)
	local res = luaexp_prompt('INSERT: ' .. title,
	                          'type the key and value comma separated as Lua code',nil,2)
	if res then	obj[res[1]] = res[2]	end
end

local function getfParamsNames(f)
	if not jit then	return '...'	end--check _VERSION>"Lua 5.1"
	local info = debug.getinfo(f)
	local params = {}
	for i=1,(info.nparams or 1000) do
		params[i] = debug.getlocal(f,i)
		         or ("<%i>"):format(i) -- C?
	end
	if info.isvararg then	params[#params+1] = '...'	end
	local paramstr = #params>0 and table.concat(params,', ') or '<none>'
	return paramstr,params
end

-- show a menu whose items are associated with the members of given object
local function process(obj, title, action)
	title = type(title)=="string" and title or ''
	if action and  brkeys[action] then brkeys[action]({obj}, 1, title);	return	end

	local mprops = {Id = uuid, Bottom = 'F1, F3, F4, Del, Ctrl+M',
	                Flags={FMENU_SHOWAMPERSAND=1,FMENU_WRAPMODE=1}}
	local otype = type(obj)
	local item, index

	-- some member types, need specific behavior:
	-- tables are submenus

	-- functions can be called
	if otype == 'function' then
		local args,n,expr = luaexp_prompt('CALL:'..title,
		                      ('arguments: %s (type as Lua code or leave empty)')
		                      :format(getfParamsNames(obj)))
		if not args then	return	end
		-- overwrite the function object with its return values
		local stat,res = getres(pcall(obj, unpack(args,1,n)))
		if not stat then
			far.Message(('%s\n  CALL: %s (%s)\n  argument(s): %d'..
			            (n>0 and ', evaluated as: %s' or ''))
			            :format(res,title,expr,n,concat(args,',',1,n)),'Error',nil,'wl')
			return
		end

		obj = res
		title = ('%s(%s)'):format(title,expr)

	-- other values are simply displayed in a message box
	elseif otype ~= 'table' then
		local value = valfmt(obj,'view')
		far.Message(value, title:gsub('&','&&',1), nil, value:match'\n' and 'l' or '')
		return
	end

	-- show this menu level again after each return from a submenu/function call ...
	repeat
		local items = makeMenuItems(obj)
		mprops.Title = title .. '  (' .. #items .. ')' .. (omit['function'] and '*' or '')

		item, index = far.Menu(mprops, items, brkeys)
		mprops.SelectIndex = index

		-- show submenu/call function ...
		if item then
			local key = item.key or (index > 0 and items[index].key)
			local childtitle = (title~='' and title .. '.' or title) .. tostring(key)
			if item.key ~= nil then
				process(obj[key], childtitle)
			elseif item.action then
				if "break"==item.action(obj, key, childtitle) then	return	end
			end
		end
		-- until the user is bored and goes back ;)
	until not item
end

local function getAllUpvalues(f,n)
	local upvalues = {}
	for i=1,(n or 1000) do -- n - debug.getinfo(f).nups
		local k,v = debug.getupvalue (f, i)
		if not k then	n = i-1; break	end
		upvalues[k] = v
	end
	return upvalues, n
end

local function syncUpvalues(f,t,n)
	for i = (n or -1),n and 1 or -1000,-1 do --debug.getinfo(f).nups
		local k,v = debug.getupvalue (f, i)
		if not k then break end
		if t[k]~=v then
			assert(k == debug.setupvalue (f, i, t[k]))
		end
	end
end

brkeys = {
	{BreakKey = 'F9',	action = function(info)
		process(debug.getregistry(), 'debug.getregistry:')
	end;	name = 'registry'},

	{BreakKey = 'Ctrl+Insert',	action = function(obj, key)
		far.CopyToClipboard ((valfmt(obj[key]))) --todo escape slashes etc
	end},

	{BreakKey = 'CtrlShift+Insert',	action = function(obj, key)
		far.CopyToClipboard ((valfmt(key,'list')))
	end},

	{BreakKey = 'CtrlAlt+Insert',	action = function(obj, key, kpath)
		far.CopyToClipboard (kpath:gsub('^_G%.','')..(valfmt(key,'list')))
	end},

	{BreakKey = 'Ctrl+Up',	action = function(obj, key, kpath)
		local f = obj[key]
		if type(f) == 'function' and debug.getinfo(f).what~='C' then --todo
			local t,n = getAllUpvalues(f)
			if n>0 then
				process(t, 'upvalues: ' .. kpath)
				syncUpvalues(f,t,n)
			end
		end
	end;	name = 'upvalues'},

	{BreakKey = 'Ctrl+Down',	action = function(obj, key, kpath)
		local f = obj[key]; local t = type(f)
		if t=='function' or t=='userdata' or t=='thread' then
			local env = debug.getfenv(f)
			if (env~=_G or 1==far.Message('Show global environment?','_G',';OkCancel'))
				  and env and next(env) then
				process(env, 'getfenv: ' .. kpath)
			end
		end
	end;	name = 'env'},

	{BreakKey = 'Ctrl+Right',	action = function(obj, key, kpath)
		local f = obj[key]
		if type(f) == 'function' then
			local args,t = getfParamsNames(f)
			if args:len()>0 then
				process(t, 'params (f): ' .. kpath)
				local name = debug.getinfo(f).name
				--far.Message(('%s (%s)'):format(name or kpath,args), 'params')
			end
		end
	end;	name = 'params'},

	{BreakKey = 'Alt+F4',	action = function(obj, key, kpath)
		local f = obj[key]
		if type(f) == 'function' then
			local info = debug.getinfo(f,'S')
			local filename = info.source:match("^@(.+)$")
			if filename then
				editor.Editor(filename,nil,nil,nil,nil,nil,nil,info.linedefined)
			end
		end
	end;	name = 'edit'},

	{BreakKey = 'F3',	action = function(obj, key, kpath)
		local f = obj[key]
		if type(f) == 'function' then
			process(debug.getinfo(f), 'debug.getinfo: ' .. kpath)
		elseif type(f) == 'thread' then
			far.Message(debug.traceback(f,"level 0",0):gsub('\n\t','\n   '),'debug.traceback: ' .. kpath,nil,"l")
			--far.Show('debug.traceback: ' .. kpath .. debug.traceback(f,", level 0",0))
		end
	end;	name = 'info'},

	{BreakKey = 'F4',	action = function(obj, key, kpath)
		return key ~= nil and editValue(obj, key, kpath)
	end},

	{BreakKey = 'Ctrl+F',	action = function()	omit['function'] = not omit['function']	end},

	{BreakKey = 'Ctrl+T',	action = function()	O.tables_first = not O.tables_first	end},

	{BreakKey = 'Ctrl+I',	action = function()	O.ignore_case = not O.ignore_case	end},

	{BreakKey = 'Ctrl+M',	action = function(obj, key, kpath)
		local mt = key ~= nil and debug.getmetatable(obj[key])
		return mt and process(mt, 'METATABLE: ' .. kpath)
	end;	name = 'mt'},

	{BreakKey = 'DELETE',	action = function(obj, key, kpath)
		return key ~= nil and editValue(obj, key, kpath, true)
	end},

	{BreakKey = 'INSERT',	action = function(obj, key, kpath)
		insertValue(obj, kpath:sub(1, -(#tostring(key) + 2)))
	end},

	{BreakKey = 'F1',	action = function()	nfo:help()	end},

	{action=function(obj, key)
		local addbrkeys = obj[key]
		for i=1,#addbrkeys do
			local bk = addbrkeys[i]
			local BreakKey = bk.BreakKey
			local pos
			for i=1,#brkeys do	if brkeys[i].BreakKey==BreakKey then	pos = i;	break	end	end
			if pos then
				brkeys[pos] = bk
			else
				table.insert(brkeys,bk)
				if bk.name then	brkeys[bk.name] = bk.action	end
			end
		end
		return 'break'
	end;	name='addBrKeys'}
}

-- if LuaJIT is used, maybe we can show some more function info
if jit then
	table.insert(brkeys, 	{BreakKey = 'Shift+F3',	action = function(obj, key, kpath)
		if key ~= nil and type(obj[key]) == 'function' then
			process(jit.util.funcinfo(obj[key]), 'jit.util.funcinfo: ' .. kpath)
		end
	end;	name = 'jitinfo'})
end

for i=1,#brkeys do
	local bk = brkeys[i];	if bk.name then	brkeys[bk.name] = bk.action	end
end

nfo.execute = function()
	process(_G,'')
	--require"le"(_G,'_G')
end
if Macro then
	Macro { description = "Lua Explorer";
		area="Common";	key="CtrlShiftF12";	action=nfo.execute
	}
elseif _filename then
	process(_G,'')
else--if ...=="le" then
	return process
end


-- it's possible to call via lua:, e.g. from user menu:
-- lua:dofile(win.GetEnv("FARPROFILE")..[[\Macros\scripts\le.lua]])(_G,'_G')
-- lua:require"le"(_G,'_G')
