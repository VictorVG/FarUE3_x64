local lua_explorer = require"le"

local function getAllLocals(level)
	local locals = {}
	for i=1,1000 do
		local k,v = debug.getlocal (level+1, i)
		if not k then	return locals, i-1	end
		locals[k] = v
	end
end

local function syncLocals(level,t,n)
	level = level + 1
	for i=n,1,-1 do
		local k,v = debug.getlocal (level, i)
		if t[k]~=v then
			assert(k == debug.setlocal (level, i, t[k]))
		end
	end
end

local function getVararg(level)
	local vararg = {}
	for i=1,1000 do
		local k,v = debug.getlocal (level+1, -i)
		if not k then	return vararg	end--(*vararg)
		vararg[i] = v
	end
end

local function syncVararg(level,t)
	for i=1,#t do
		local k,v = debug.getlocal (level+1, -i)
		if v~=t[i] then	debug.setlocal (level+1, -i, t[i])	end
	end
end

local function getLocalsAndParams(level)
	local locals,n = getAllLocals(level+1)
	local info = debug.getinfo(level+1)
	local vararg = getVararg(level+1)
	vararg = vararg[1] and vararg
	locals['(*vararg)'] = locals['(*vararg)'] or vararg or nil
	local info = debug.getinfo(level+1)
	local name = ('(*func: %s)'):format(info.name or '<noname>')
	locals[name] = locals[name] or info.func
	return locals,n,vararg
end

local function showLocals(level,shift)
	--far.Show(level,shift)
	if not shift then
		shift = 0
		for i = 1,1000 do
			local info = debug.getinfo(i,'f')
			if not info then	break	end
			if info.func==lua_explorer then	shift = i
			elseif info.func==showTraceback then	shift = i
			end
		end
		if shift>900 then	return	end
	end
	level = level + shift
	local info = debug.getinfo(level,'')
	if not info then	mf.beep() return	end
	local locals,n,vararg = getLocalsAndParams(level)
	if n>0 or vararg  then
		lua_explorer(locals, ('locals [%d]: %s'):format(level-shift,info.name or 'main chunk'))
		syncLocals(level,locals,n)
		if vararg then	syncVararg(level,vararg)	end
		return 'break'
	end
end

local function ExpandBreakKeys(bkeys)
	for i=1,#bkeys do
		local t = bkeys[i]
		if t.BreakKey:match("%w%s+%w") then
			local g = t.BreakKey:gmatch("%S+")
			t.BreakKey = g()
			for key in g do
				local new = {}; for k,v in pairs(t) do	new[k]=v	end
				new.BreakKey = key
				table.insert(bkeys,new)
			end
		end
	end
end

local function showTraceback(level,shift)
	if level then	showLocals(level,shift);	return	end
	local TB_bkeys = {
		{BreakKey = 'F3',	action = function(getinfo)
			lua_explorer(getinfo, 'getinfo:')
		end},

		{BreakKey = 'RETURN',	action = function(info,shift)
			showLocals(info.level,shift)
		end},

		{BreakKey = 'Ctrl+Numpad2 Ctrl+Down',	action = function(getinfo)
			local f = getinfo.func
			if not f then return end
			lua_explorer(f,nil,'env')
		end},

		{BreakKey = 'Ctrl+Numpad8 Ctrl+Up',	action = function(getinfo)
			local f = getinfo.func
			if not f then return end
			lua_explorer(f,nil,'upvalues')
		end},

		{BreakKey = 'Alt+F4',	action = function(getinfo)
			local FileName = getinfo.source:match"^@(.+)"
			if not FileName then	far.Show(getinfo.source);	return	end
			local flags = far.Flags.EN_NONE
			editor.Editor(FileName,nil,nil,nil,nil,nil,flags,getinfo.linedefined)
		end},
	}
	ExpandBreakKeys(TB_bkeys)

	local stack = {}
	local str = debug.traceback("",0):match("stack traceback:\n(.+)"):gmatch("[^\n]+")
	local shift = 0
	for i=0,1000 do
		local info = debug.getinfo(i)
		if not info then break end
		info.level = i
		info.text = str()
		stack[i+1] = info
		if info.func==lua_explorer or info.func==showTraceback then	shift = i	end
	end
	for i = 1,shift+1 do	stack[i].hidden = true	end
	--if shift>0 then stack[1].hidden = true end
	local props = {
		Title="Traceback of the call stack:",
		Bottom="Enter: locals | CtrlUp: upvalues | CtrlDown: env | Other: see help (F1)",
		Flags={FMENU_SHOWAMPERSAND=1,FMENU_WRAPMODE=1},
	}
	local pos,level --= shift
	repeat
		props.SelectIndex=pos
		level,pos = far.Menu(props,stack,TB_bkeys)
		if level then
			if level.action then
				if "break"==level.action(stack[pos],shift) then	break	end
			end
		end
	until not level
	--return 'break'
end

local addbrkeys = {
	{BreakKey = 'Ctrl+1',	action = function()	return showLocals(1)	end;	name = 'locals'},
	{BreakKey = 'Ctrl+2',	action = function()	return showLocals(2)	end;	name = 'locals2'},
	{BreakKey = 'Ctrl+3',	action = function()	return showLocals(3)	end;	name = 'locals3'},
	{BreakKey = 'Ctrl+4',	action = function()	return showLocals(4)	end;	name = 'locals4'},
	{BreakKey = 'Ctrl+5',	action = function()	return showLocals(5)	end;	name = 'locals5'},
	{BreakKey = 'Ctrl+6',	action = function()	return showLocals(6)	end;	name = 'locals6'},
	{BreakKey = 'Ctrl+7',	action = function()	return showLocals(7)	end;	name = 'locals7'},
	{BreakKey = 'Ctrl+8',	action = function()	return showLocals(8)	end;	name = 'locals8'},
	{BreakKey = 'Ctrl+9',	action = function()	return showLocals(9)	end;	name = 'locals9'},
	{BreakKey = 'Ctrl+0',	action = function()	return showLocals(0)	end;},
	{BreakKey = 'OEM_3',	action = function()	return showTraceback()	end;},
	{BreakKey = 'Ctrl+G',	action = function()	lua_explorer(_G,'_G');	return "break"	end},

	{BreakKey = 'CtrlShift+F',	action = function()	lua_explorer(far.Flags,'far.Flags')	end},
	{BreakKey = 'CtrlShift+V',	action = function()	lua_explorer(win.GetVirtualKeys(),'VK')	end},
	{BreakKey = 'CtrlShift+U',	action = function()	lua_explorer(win.Uuid(win.Uuid()):upper())	end},
	{BreakKey = 'CtrlShift+M',	action = function()	lua_explorer(debug.getregistry()._LOADED,'_LOADED')	end},

}
lua_explorer(addbrkeys,nil,'addBrKeys')
