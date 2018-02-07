-- ------------------------------------------------------------------ --
-- ������ ����������� ����� ����������� � ������������� �� ��������   --
-- ��������� ������������� (� ���� �/��� ����� ������ �               --
-- ��������������� ���������                                          --
-- ------------------------------------------------------------------ --
local rio = {}
local lib = require "lib"

-- ���������� ��������� �����
rio.fh = nil
-- ���� ������ � ����
rio.infile = false
-- ���� ���������� � ����
rio.appendinfile = false
rio.charset = 'OEM'
-- ���� ������ � ����� ������
rio.inclipboard=false
-- ���������� ������ ������
rio.clipboard_text=""
-- ------------------------------------------------------------------
-- @brief �������� �����
-- @details � ����������� �� �������� ��������� ���� (��� ��
--   ���������) �������� ��� ���� ����� ���� ��� ��������
--   ������������ ���� ��� ���������� ����� ���������� (� �����������
--   �� �������� �� �������)
-- @param d dlg ��������� �� ��������� ������ �������
-- @return
--   - filehandler - ��������� �� �������� ����, ���� � ����������
--     ������� ���������� � ����
--   - nil - ��� ������ �������� �����, ���� � ���������� �������
--     ���������� � ����
--   - -1 - ���� � ���������� ������� �� ���������� � ����
-- ------------------------------------------------------------------
function rio.open(d)
	local drive,path, name, ext=lib.ParseFileName(d.filename)

    filename=d.filename
	if path=="" and drive=="" and not filename:match("^\\") then
		path=far.GetCurrentDirectory()
    elseif path:match("^%.") then
		path=far.GetCurrentDirectory().."\\"..path
	end

	filename=drive..path.."\\"..name..(ext ~= "" and "."..ext or "")

    if d.infile==1 then
        rio.charset = d.charset
        rio.infile  = true
        if d.appendinfile==1 then
            rio.appendinfile = true
        	rio.fh=io.open(filename,"a")
        else
            rio.appendinfile = false
        	rio.fh=io.open(filename,"w")
        end
    else
        rio.infile=false
        rio.fh = -1
    end

    if d.inclipboard==1 then
        rio.inclipboard=true
        rio.clipboard_text=""
    else
        rio.inclipboard=false
    end

	return rio.fh
end

-- �����/������� ������ � ����, � ����������� �� ��������
function rio.write(s)
    if rio.infile then
        if rio.charset=="UTF-8" then
            rio.fh:write(s)
        else
            rio.fh:write(win.Utf8ToOem(s))
        end
    end
    if rio.inclipboard then
        rio.clipboard_text=rio.clipboard_text..s
    end
end

-- �����/������� ����� � ����, � ����������� �� ��������
function rio.writeln(s)
    rio.write(s.."\n")
end

-- ����� ��������� ���� �� ����
function rio.flush()
    if rio.infile then
        rio.fh:flush()
    end
    if rio.inclipboard then
        far.CopyToClipboard(rio.clipboard_text)
    end
end

-- �������� �����
function rio.close()
    if rio.infile then
        rio.fh:close()
    end
    if rio.inclipboard then
        rio.clipboard_text=""
    end
end

return rio
