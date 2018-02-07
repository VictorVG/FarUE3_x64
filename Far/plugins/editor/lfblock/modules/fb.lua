local F=far.Flags
local lib = require "lib"
local txt = require "txt"
local fb={}

-- @brief �������� �� ������������� ������� ����� ������
-- @param t string ������
-- @param s array ������ ��������
-- @return bool
--   - true - ����� ������ �����
--   - false - ����� ������ �� �����
function fb.IsNewLine(t, s)
    if s.paragraph==2 then
        return true
    elseif s.paragraph==3 then
        if txt.trim(t) == "" then
            return true
        end
    elseif s.paragraph==4 then
        if t:match("^%s+") then
            return true
        end
    elseif s.paragraph==5 then
        if txt.trim(t) == "" or t:match("^%s+") then
            return true
        end
    end
    return false
end

-- @brief ��������� ���������� � ����� ������
-- @details ���� ����� �������, �� ������������ ����������
--   � ���������� �����, � ���� ������ �� ���� �������
--   ������� ������.
-- @return StartLine, EndLine
--   - StartLine - ����� ������ ������ �����
--   - EndLine - ����� ��������� ������ �����
function fb.GetSelPos()
    local Info = editor.GetInfo()
    local Sel  = editor.GetSelection(Info.EditorId)

    if Sel~=nil then
        if Sel.EndPos>0 then
            return Sel.StartLine, Sel.EndLine
        else
            return Sel.StartLine, Sel.EndLine-1
        end
    else
        return Info.CurLine, Info.CurLine
    end
end

-- @brief ��������� ������ ������ ������� ������ �� ������� �������.
-- @details ��������� ������� �� ������ ������, �.�. � ������ ������
--   � � ����������� ����� ������� ������.
-- @param n integer ����� ������
-- @param s array ������ ��������
-- @return integer - ������ ������ ������� ������
function fb.getWidth(n,s)
    return s.right-fb.getMargin(n,s)
end

-- @brief ��������� ������� ������� ������.
-- @details ��������� ������� �� ������ ������, �.�. � ������ ������
--   � � ����������� ����� ������� ������.
-- @param n integer ����� ������
-- @param s array ������ ��������
-- @return integer - ������ ������� ������
function fb.getMargin(n,s)
    if n==1 then
        return s.first-1
    end
    return s.left-1
end

-- @brief ��������� ���������� ������� ������.
-- @details ����������� �� ��������, ���������� ������� �����
--   �������� ������� ������� ������. ������������ ��� ��������
--   ������� ������ �������� ���������������� ����������
-- @param n integer ����� ������
-- @param s array ������ ��������
-- @return integer - ������� ��� �������
function fb.getSpaces(n,s)
    return string.rep(" ", fb.getMargin(n, s))
end

-- @brief �������������� ������� ������ � �����
-- @details ���� ������� ������ ����������� �� ������ 
--   �������� ������� �� ����������� ��������� � 
--   ����������.
-- @param t string ������������� ������
-- @param s array ������ ��������
-- @return array - ������ �����, ���������� �����
function fb.FormatString(t,s)
    local rows={""}
    local w

    for w in t:gmatch("%S+") do
        if #rows==1 and rows[#rows]:len()==0 then
            rows[#rows]=w
        else
            if (rows[#rows]:len()+w:len()+1) <= fb.getWidth(#rows,s) then
                rows[#rows]=rows[#rows].." "..w
            else
                rows[#rows+1]=w
            end
        end
    end

    return rows
end

-- @brief ������������ ������ � ����������� �� ����������
-- @param t string �����
-- @param w integer ������ ������
-- @param a integer ��� ������������
--   - 1 - �� ������ ����
--   - 2 - �� ������� ����
--   - 3 - �� ������
--   - 4 - �� ������, ��������� ������ �� ������ ����
--   - 5 - �� ������, ������� ��������� ������
-- @param l bool ���� ��������� ������
--   - true - ����� � ��������� t �������� ��������� �������
--   - false - ����� � ��������� t �� �������� ��������� �������
--   ������������ ��� ������������ �� ������, ��� ������������ 
--   ��������� ������
-- @return string - ����������� �����
function fb.alignText(t, w, a, l)
    local row=""

    if     a==2 then
        row=row..txt.alignRight(t, w)
    elseif a==3 then
        row=row..txt.alignCenter(t, w)
    elseif a==4 and not l then
        row=row..txt.alignJustify(t, w)
    elseif a==5 then
        row=row..txt.alignJustify(t, w)
    else
        row=row..t
    end
    return row
end
-- @brief ����� ����������������� �����
-- @param s array ������ ��������
-- @param StringBuffer array ������ �����
function fb.OutStrings(StringBuffer, s)
    for k,v in pairs(StringBuffer) do
        if v~="" then
            local rows=fb.FormatString(v,s)

            for i=1, #rows do
                local w=fb.getWidth(i,s)
                lib.write(fb.getSpaces(i,s))
                lib.writeln(fb.alignText(rows[i],w,s.align, i==#rows))
            end

            if s.insertline==1 then
                lib.writeln()
            end
        end
    end
end

-- @brief ��������� ����� �� ����������� �����
-- @param b integer ������ ������ �����
-- @param e integer ��������� ������ �����
-- @param s array ������ ��������
function fb.GetStrings(b, e, s)
    local row, r
    local rows={""}

    for i=b, e do
        row, _ = editor.GetString(nil, i, 3)

        if rows[#rows]~="" and fb.IsNewLine(row, s) then
            rows[#rows+1]=""
        end

        if rows[#rows]~="" then
            rows[#rows]=rows[#rows].." "
        end

        rows[#rows]=rows[#rows]..row

    end
    return rows, 0
end
-- @brief �������������� ����������� ����� ������
-- @param s array ������ ��������
function fb.FormatedBlock(s)
    local Info = editor.GetInfo()
    local StartLine, EndLine = fb.GetSelPos()
    local StringBuffer=fb.GetStrings(StartLine, EndLine, s)
    -- ������ ������� ��������
    editor.UndoRedo(nil, F.EUR_BEGIN)

    editor.Select(nil, "BTYPE_STREAM", StartLine, 1, -1, EndLine-StartLine+1)
    editor.DeleteBlock()
    editor.SetPosition(nil, StartLine, 1)

    if StringBuffer[#StringBuffer]=="" then
        StringBuffer[#StringBuffer]=nil
    end

    fb.OutStrings(StringBuffer, s)

    -- ����� ������� ��������
    editor.UndoRedo(nil, F.EUR_END)
end

return fb