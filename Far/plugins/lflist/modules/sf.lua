local M = far.GetMsg
local sf= {}
local lib = require "lib"
-- �������� ���������� ��� ����������� ������
local hScr
local widthText=66
-- ���������� ���������� ������
local selCount=0

-- ��������������� ��������� ����� ���������� � �����
local function prepItem(item)
    item.FileName = far.ConvertPath(item.FileName)
    item.Time={
        Change     = lib.FileTime.time(item.ChangeTime),
        Creation   = lib.FileTime.time(item.CreationTime),
        LastAccess = lib.FileTime.time(item.LastAccessTime),
        LastWrite  = lib.FileTime.time(item.LastWriteTime),
    }
    item.Date={
        Change     = lib.FileTime.date(item.ChangeTime),
        Creation   = lib.FileTime.date(item.CreationTime),
        LastAccess = lib.FileTime.date(item.LastAccessTime),
        LastWrite  = lib.FileTime.date(item.LastWriteTime),
    }
    item.GTime={
        Change     = lib.FileTime.gtime(item.ChangeTime),
        Creation   = lib.FileTime.gtime(item.CreationTime),
        LastAccess = lib.FileTime.gtime(item.LastAccessTime),
        LastWrite  = lib.FileTime.gtime(item.LastWriteTime),
    }
    item.GDate={
        Change     = lib.FileTime.gdate(item.ChangeTime),
        Creation   = lib.FileTime.gdate(item.CreationTime),
        LastAccess = lib.FileTime.gdate(item.LastAccessTime),
        LastWrite  = lib.FileTime.gdate(item.LastWriteTime),
    }
    item.Attributes = sf.fa2str(item.FileAttributes)

    return item
end
-- ------------------------------------------------------------------------- --
-- @brief ��������� ������ ������ ��������
-- @details ��������� ������ ������ ������ �� ��������
-- @param fpath string ��������� ������� ������
-- @param opt sf.flags ����� ������
-- @return table ������ ��������� ���� tPluginPanelItem, �����������  ��
--   ��������� �����
-- ------------------------------------------------------------------------- --
local function getFileList(fpath, opt)
    local res={}
    local options=tonumber(opt) or 0

    local function find(fpath)
        -- ������� �� ����� �������������� �������,  ���  ��  ������  ��  ������,
        -- �������� � ������ ��������� �� widthText ��������.
        local tfpath=(far.TruncPathStr(fpath, widthText)..string.rep(" ", widthText)):sub(1,widthText)
        far.Message (tfpath, "","", "k");

        -- ������ ���������� ������������ ��� ����������� ������, ���
        -- ���������, ���� �� � �������� �������� ����� ��� �� ����.
        local scount=0
        local ssize=0
        local sasize=0
        local sdflag=0
        local function userfunc(item, fullname)
            local lsdflag=0
            if item.FileAttributes:match("d") then
                local count=0
                local size=0
                local asize=0
                sdflag=1
                if opt.recurse==1 and not item.FileAttributes:match("e") then
                    count,size, asize, lsdflag=find(far.ConvertPath(fullname))
                    scount=scount+count
                end

                if opt.skipempty==1 and count==0 then return end
                if opt.skipdir==1   and count >0 then return end
                item.FileSize=size
                item.AllocationSize=asize
            end
            item.FileName=fullname
            scount=scount+1
            ssize=ssize+item.FileSize
            sasize=sasize+item.AllocationSize
            if not (opt.skipfiles==1 and not item.FileAttributes:match("d")) then
                if  not(opt.skipidirs==1 and lsdflag==1 and item.FileAttributes:match("d")) then
                    res[#res+1] = prepItem(item)
                end
            end
        end

        far.RecursiveSearch(fpath, "*", userfunc)
        return scount, ssize, sasize, sdflag
    end

    local count, size, asize, sdflag=find(fpath)
    return res, size, asize, sdflag
end

-- ------------------------------------------------------------------------- --
-- @brief ��������� ������ ������
-- @details ��������� ������ ������ ��  ����������  �  ��������  ������.
--   ���� ���������� ���� ��������� ���������  ���������,  ��  ���������
--   ��� ���������� �������� ����������. ���� �� ���� ����  ��  �������,
--   �� ������� ���� ��� ��������.
-- @param recurse bool ���� ��������� ��������� ���������
--   - recurse=true  - ������������ ��������� ��������
--   - recurse=false - �� ������������ ��������� ��������
-- @return array - ������ ��������� ����  tPluginPanelItem,  �����������
--   �� ��������� �����
-- ------------------------------------------------------------------------- --
function  sf.get_selected_files(opt)
    local sdflag=0
    -- ��������� ������ ���� Far'� � �������� ������ ������
    local farRect=far.AdvControl("ACTL_GETFARRECT")
    if farRect then
        local widthNew=farRect["Right"]-farRect["Left"]-13
        if widthNew > widthText then
            widthText = widthNew
        end
    end

    hScr = far.SaveScreen(0, 0, -1, -1);
    local msg=(M(22)..string.rep(" ", widthText)):sub(1,widthText)
    far.Message(msg, M(5), "");

	local i, item
    -- ������ ��������� ������
	local res={}

    -- ������� ������ ���������� ����
	item=panel.GetSelectedPanelItem(nil,1,1)
    -- ���� ���������, ��� �� ���� ���� �� �������,
    -- �� ������ �� ���� ��� ��������
	if item == nil then
		item=panel.GetCurrentPanelItem (nil, 1)
	end

	i = 1
    -- �������� ����� �������� ��������, ���� ������ ����� �� �������� ".."
    local allfiles=false
    if item.FileName==".." then
        allfiles=true
        item=panel.GetPanelItem(nil, 1, 2)
        i = i + 1
    end

	while item ~= nil do
        sdflag=0
        -- �������� ���������� ���������� ������ �� 1
		selCount = selCount + 1
        -- ���� ���� �������� ��������� � ���������� ���� ���������
        -- ��������� ���������, �� ��������� ������� ���������� � 
        -- ������ �������� �������� � ������ ���������� � ��� ����������
        local isdir=string.find(item.FileAttributes, "d") ~= nil
		if isdir and opt.recurse==1 then
            local list, size, asize, sdflag=getFileList(far.ConvertPath(item.FileName), opt)

            local k,v
            for k,v in pairs(list) do
            	res[#res+1] = v
            end

            item.FileSize=size
            item.AllocationSize=asize

            if  not(opt.skipidirs==1 and sdflag==1) then
    			-- ���� ������� ���� � skipempty~=1, �� ������� � ������ ���
    			if #list==0 and opt.skipempty~=1 then
        			res[#res+1] = prepItem(item)
    			end
    			-- ���� ������� �� ���� � skipdir~=1, �� ������� � ������ ���
    			if #list>0 and opt.skipdir~=1 then
        			res[#res+1] = prepItem(item)
    			end
			end
		else
            if not isdir or opt.skipempty~=1 then
                if not (opt.skipfiles==1 and not item.FileAttributes:match("d")) then
        		    res[#res+1] = prepItem(item)
                end
            end
		end
		i = i + 1
        -- ������� �������� ���������� ����������� �����
        if allfiles then
            item = panel.GetPanelItem(nil, 1, i)
        else
    		item = panel.GetSelectedPanelItem(nil,1,i)
        end
	end

    local function comp_name_asc(w1,w2)
        if (w2.FileName > w1.FileName) then
            return true
        end
    end

    local function comp_name_desc(w1,w2)
        if (w2.FileName < w1.FileName) then
            return true
        end
    end

    local function comp_size_asc(w1,w2)
        if (w2.FileSize > w1.FileSize) then
            return true
        end
    end

    local function comp_size_desc(w1,w2)
        if (w2.FileSize < w1.FileSize) then
            return true
        end
    end

    local function comp_cdate_asc(w1,w2)
        if (w2.CreationTime > w1.CreationTime) then
            return true
        end
    end

    local function comp_cdate_desc(w1,w2)
        if (w2.CreationTime < w1.CreationTime) then
            return true
        end
    end

    local function comp_mdate_asc(w1,w2)
        if (w2.ChangeTime > w1.ChangeTime) then
            return true
        end
    end

    local function comp_mdate_desc(w1,w2)
        if (w2.ChangeTime < w1.ChangeTime) then
            return true
        end
    end

    if opt.sortres==M(24) then
        table.sort(res,comp_name_asc)
    elseif opt.sortres==M(25) then
        table.sort(res,comp_name_desc)
    elseif opt.sortres==M(26) then
        table.sort(res,comp_size_asc)
    elseif opt.sortres==M(27) then
        table.sort(res,comp_size_desc)
    elseif opt.sortres==M(28) then
        table.sort(res,comp_cdate_asc)
    elseif opt.sortres==M(29) then
        table.sort(res,comp_cdate_desc)
    elseif opt.sortres==M(30) then
        table.sort(res,comp_mdate_asc)
    elseif opt.sortres==M(31) then
        table.sort(res,comp_mdate_desc)
    end

    far.RestoreScreen(hScr);
	return res
end
-- ������� ��������� � ������, ��� ����� ����������� � ������������ ������� 
-- ------------------------------------------------------------------------- --
-- @brief ������ ��������� � ������
-- @details ������� ��������� � ������, ��� ����� ����������� � ������������
--   �������. 
-- @param sfiles array - ������ ��� ���������� ������
-- ------------------------------------------------------------------------- --
function sf.unselected_files()
	local i
    for i=1, selCount do
        panel.ClearSelection(nil,1,1)
    end
    selCount=0
    panel.RedrawPanel(nil,1)
end
-- ------------------------------------------------------------------------- --
-- ��������������� �������. ��������������� ���� FileAttributes ����� �
-- ������ ���� 'RAHSC', ��� ������ ������ ���������� ������� 
-- ���������������� ��������. � ������ ���������� ��������, ������ �������
-- �������� '-'.
-- ------------------------------------------------------------------------- --
function sf.fa2str(a)
    return --
        (a:match("d") and "D" or "-") .. --
        (a:match("r") and "R" or "-") .. --
        (a:match("a") and "A" or "-") .. --
        (a:match("h") and "H" or "-") .. --
        (a:match("s") and "S" or "-") .. --
        (a:match("c") and "C" or "-") .. --
        (a:match("e") and "E" or "-") .. --
        (a:match("p") and "P" or "-")
end
return sf
