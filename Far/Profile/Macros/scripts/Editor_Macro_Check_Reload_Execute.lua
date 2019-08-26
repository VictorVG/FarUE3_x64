--http://forum.farmanager.com/viewtopic.php?f=60&t=8008
--requires FAR 3 build >3784

local function le_error()
far.Message([[
Lua Explorer „Advanced“ is required for this function.
http://forum.farmanager.com/viewtopic.php?f=60&t=7988]],"")
end
local le_success,le = pcall(require,"le")
le = le_success and le or le_error

local F = far.Flags

local function sandbox(f,env,mt)
	return setfenv(f,setmetatable(env or {}, mt or {__index=_G}))
end

local function env_prompt(Title,Prompt,History,Src)
	repeat
		local expr = far.InputBox(nil,Title,Prompt,History or Title,Src,nil,nil,F.FIB_ENABLEEMPTY)
		if not expr then	return	end
		local f,err = loadstring(expr)
		if f then
			local success,err = pcall(sandbox(f,env))
			if success then	return getfenv(f)
			else	far.Message(err,'Error',nil,'w')
			end
		else
			far.Message(err,'Error in expression',nil,'wl')
		end
	until false
end

local function inspectRet(...)
	if select("#",...)>0 then
		local sel = far.Show(...)
		if sel then	le (sel.arg)	end
	else
		return 0
	end
end

local function evalSelection()
	local src = Editor.SelValue
	src = src:find"return " and src or "return "..src
	local f,Err = loadstring(src)
	if Err then
		far.Message(Err,"Error",nil,"lw")
	else
		local env = env_prompt("call: "..src,"env: ... (type as Lua code or leave empty)","evalSelection")
		if 0==inspectRet(sandbox(f,env)()) then	far.Message("no values returned")	end
	end
end

local function getAllLocals(level)
	local locals = {}
	for i=1,1000 do
		local k,v = debug.getlocal (level+1, i)
		if not k then	return locals, i-1	end
		locals[k] = v
	end
end

local function inspectVars(f)
	local function hook()
		if f==debug.getinfo(2, "f").func then
			debug.sethook()
			local locals,env = getAllLocals(2),getfenv(f)
			if next(locals) then	le(locals,"locals")	end
			if next(env) then	le(env,"environment")	end
		end
	end
	debug.sethook(hook,"r")
	inspectRet(f())
	debug.sethook()
end

local function checkMacro()
	local EditorInfo = editor.GetInfo()
	local info = editor.GetSelection()
	             or {StartLine=1,EndLine=EditorInfo.TotalLines}
	local str = {}
	for ii=info.StartLine,info.EndLine do
		local cur=editor.GetString(-1,ii)
		str[ii]=cur.StringText:sub(cur.SelStart~=0 and cur.SelStart or 1,
		                           cur.SelEnd~=0 and cur.SelEnd or -1)
	end
	local src = table.concat(str,"\n",info.StartLine,info.EndLine)
	local f,Err = loadstring(src)
	if Err then
		far.Message(Err,"Error",nil,"lw")
	else
		f = sandbox(f)
		if not (string.match(src,"%f[%w]Macro%s*{")
		       or string.match(src,"%f[%w]Event%s*{")) then	far.MacroPost("Keys'Tab'")	end
		local ans = far.Message("Syntax is Ok","Macro","Reload &All;&Execute;&Variables")
		if ans==1 then
			if band(EditorInfo.CurState,F.ECSTATE_SAVED)==0 then	editor.SaveFile()	end
			if Area.Editor then	far.MacroLoadAll()	end --если при сохранении не возникло вопросов
		elseif ans==2 then
			inspectRet(f())
		elseif ans==3 then
			if le_success then	inspectVars(f)	else le_error()	end
		end
	end
end

Macro { description="Check macro in editor [Reload/Execute/Variables]";
	area="Editor";	key="CtrlEnter";	filemask="*.lua";
	action=checkMacro;
}

Macro { description="Eval selected text and inspect returned values";
	area="Editor";	key="CtrlShiftEnter";	flags="EVSelection";	filemask="*.lua";
	action=evalSelection;
}
