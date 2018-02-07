local lib = {}
-- "Hello World" - FAR plugin in Lua --
-- ����� � ������� ��������, � ������ ����������
-- ���������� ������ ������� ���������� ��������
-- ����� nil
lib.array_find = function  (a, v)
	local key
	local val
	for key, val in pairs(a) do
		if val == v then
			return key
		end
	end
	return nil
end

-- ������� ����� �����, �� ����� ���_�����
-- �� ������ {����, ����, ���, ����������}
lib.ParseFileName = function(str)
	local drive, path, name, ext
	if str == nil then str="" end

	drive = string.match(str, "^%s*([^:]+:)")
	str=str:gsub("^%s*([^:]+:)","")

	path=string.match(str, "^(.*)[\\/]")
	str=str:gsub("^(.*)[\\/]","")

	ext=string.match(str, "%.([^%.]+)$")
	name=str:gsub("%.([^%.]+)$","")

	if name == nil then name="" end
	if ext == nil then ext="" end
	if path == nil then path="" end
	if drive == nil then drive="" end
	
	return drive, path, name, ext
end

-- ������ ������ � ������� Far Manager
-- ������� � ������
function lib.printToFARConsole(txt)
    local hScr;
    panel.GetUserScreen();
    -- �.�. ������� ������� ����� � ������� OEM (866), 
    -- �� ������������ ��� �������
    io.write(win.Utf8ToOem (txt));
    panel.SetUserScreen();
end
lib.coalesce = {}

-- @brief ��������� ������ �� �������
-- @details ���������� ������ �� ����������������� ������� (str),
--   ������ �� ���������������� ������������� (patterns). �.�.
--   �������� �� ������� ������ ��� ���������, ����������� � ����� ����
--   �������� �� ������� �� ������ ���������, �� �������� �������� �������
--   � �������� ��������� � ��������� ����������
-- @param str string ������ ������
-- @param patterns array ������ ���� {"����� ������"="������"} �������������, 
--   �.�. ��� �� ��� ������. ��� ���� ����� ������, ��� <����� ������> ��������
--   ���������� ���������� � ������ ���������� � ��������������� ������� (�.�.
--   ����� '%' � ����� ������ ����������� ��� '%%'.
-- @return string - ��������� �� ������� � ������������� ������
function lib.repl(s, patterns)
    local res = ""
    local p = patterns or {}

    local matched

    while s:len() > 0 do
        m=false

        for k,v in pairs(p) do
            m = s:match("^"..k)
            if m then
                res = res .. v
                s = s:gsub("^"..k,"")
                break
            end
        end

        if not m then
            res = res .. s:sub(1,1)
            s = s:gsub("^.","")
        end
    end
    return res
end

-- ���������� ������ ������, ���� �������� �� ��������� (a == nil)
function lib.coalesce.str(a)
    return a or ""
end
-- ������� ��� ������ � �����/�������� � ������� FileTime
lib.FileTime = {}

-- ��������������� ���� � ������� FileTime � ������ ���� "����.��.��"
function lib.FileTime.date(d)
    local ft=win.FileTimeToSystemTime(win.FileTimeToLocalFileTime(d))
    return string.format("%04d-%02d-%02d", ft.wYear, ft.wMonth, ft.wDay)
end

-- ��������������� GMT ���� � ������� FileTime � ������ ���� "����.��.��"
function lib.FileTime.gdate(d)
    local ft=win.FileTimeToSystemTime(d)
    return string.format("%04d-%02d-%02d", ft.wYear, ft.wMonth, ft.wDay)
end

-- ��������������� ����� � ������� FileTime � ������ ���� "��.��.��"
function lib.FileTime.time(d)
    local ft=win.FileTimeToSystemTime(win.FileTimeToLocalFileTime(d))
    return string.format("%02d:%02d:%02d", ft.wHour, ft.wMinute, ft.wSecond)
end

-- ��������������� GMT ����� � ������� FileTime � ������ ���� "��.��.��"
function lib.FileTime.gtime(d)
    local ft=win.FileTimeToSystemTime(d)
    return string.format("%02d:%02d:%02d", ft.wHour, ft.wMinute, ft.wSecond)
end

return lib
