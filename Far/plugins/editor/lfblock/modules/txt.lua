local txt={}
-- @brief �������� �������� � ������
-- @param s string ������
-- @return string - ������ ��� �������� � ������
function txt.ltrim(s)
    return s:gsub("^%s*","")
end

-- @brief �������� �������� � ����� ������
-- @param s string ������
-- @return string - ������ ��� �������� � �����
function txt.rtrim(s)
    return s:gsub("%s*$","")
end

-- @brief �������� �������� � ������ � ����� ������
-- @param s string ������
-- @return string - ������ ��� �������� � ������ � �����
function txt.trim(s)
    return txt.rtrim(txt.ltrim(s))
end

-- @brief �������� ����������� ��������
-- @details � ������-��������� ������ ��������� ��������, ������
--   ������ � ���������� �� ���� ������
-- @param s string ������
-- @return string - ������ ��� ����������� ��������
function txt.cleanspaces(s)
    return s:gsub("%s+"," ")
end

-- @brief ������� ���������� ���������� ���������.
-- @details � �������� ��������� ����� �������������� ������ 
--   ����������� ���������
-- @param s string ������, � ������� ������ ��������� p
-- @param p string ��������� (������), ������� ������ � s
-- @return integer - ���������� ���������
function txt.countSubStrs(s,p)
    local i=1
    local c=0

    while i do
        _, i = s:find(p, i)
        if i then
            c = c + 1
            i = i+1
        end
    end

    return c
end

-- @brief ������������ ������ �� ������ ������
-- @details ����������� ������ � ������� ����� ���������
--   ����������� �� ������ ������ ������ �������������
--   �������������. ����� ������� ������ ���������� ����������� ��
--   ������ � ������� ���� ������������.
-- @param t string �����
-- @param w integer ������ ������
-- @return integer - ����������� �� ������ ������
function txt.alignJustify(t, w)
    local spaces=txt.countSubStrs(t,"%s+")
    local row=""

    if spaces==0 then
        row=t
    else
        local delta=math.floor((w-t:len())/spaces)+1
        local mod=(w-t:len())%spaces
        local i=1
        local tw

        for tw in t:gmatch("%S+") do
            row=row..tw
            if (i<=spaces) then 
                row=row..string.rep(" ", delta)

                if (spaces-i)<mod then
                    row=row.." "
                end
            end

            i=i+1
        end
    end
    return row
end

-- @brief ������������ ������ � ������ �� ������
-- @details ����������� ������ � ������� ����� ��������� �����������
--   �����, ��������� ����� ������� ������ �� ������ ������
-- @param t string �����
-- @param w integer ������ ������
-- @return integer - ����������� �� ������ ������
function txt.alignCenter(t, w)
    return string.rep(" ", math.floor((w-t:len())/2))..t
end

-- @brief ������������ ������ � ������ �� ������� ����
-- @details ����������� ������ � ������� ����� ��������� �����������
--   �����, ���������� ����� ������� ������ �� ������� ����
-- @param t string �����
-- @param w integer ������ ������
-- @return integer - ����������� �� ������� ���� ������
function txt.alignRight(t, w)
    return string.rep(" ", w-t:len())..t
end

return txt