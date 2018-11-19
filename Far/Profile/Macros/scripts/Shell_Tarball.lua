--[[ ������ ��������� ����� � ������� � ����� �� ���� �� ������ ���������� ��������.
     �� ������ �������� �������� ���� ������. ������� ��� ������ ������� ������������
     ��������� tar �������������� �� ���� �������� ���� ���������� ����� ���������
     �������� ������� �� ����� ������������ ���������� � ������ ���- � ����������,
     � ���� ������� � ������ � ���������. � Windows ��� ���������� ������������ ���
     ������ � UNIX ������� ������ ��� �������, � � ����������� � ����������� ���
     ������������ ��� ��������� ������, ��� �������� ��������� tar ��� ��������� ���
     �� ����������������� ��� �����.

     �� �������� "����� � �������" �������� ������ "Open tarball" ������� ������������
     ���������������� ������� ����� �� �������� ������� ���������� ���������� tar.

     �������� �������� "����� �� ��������" ����������� �������� "CdUp tarball" ���
     ������������ �������� ���������� ����� � ������� ��� ��������� ������ ����������
     �� ���� � ����� ����� ������ ��������� �������� �� ���������.

     � ������� �� ������ ������� Shell_DeepTarball.lua (c) siberia-man ������ ������
     ��������� ����� � �������� ������ �� ������ ����������� ��������, � �.�. ����� ���
     �������� ����� ����������� ��� ���� *.tbz, *.tgz, *.tlz, *.trz, *.txz, *.tz ���
     ����� ����������� � UNIX ��������, �������� � ������ FreeBSD UNIX �������� �������
     ����� ����� ���� *.tbz ��� *.txz.

     ToDo:

     ��� ���������� ������ ������� ���� ������������ ��������� ������������ ��������
     (�������� ArcLite � MultiArc) ���������� ����� � �������� tar ������� ������ ���� ��
     ���. � ������� ������� ���� ��������� ��� Tar �������� �� CtrlPgDn. ���� �� ����������
     ������� ���������� � ���� ����, �� �������� � ��� �������.

     VictorVG @ VikSoft.Ru (Russia, Moscow, 1996 - 2018)

     ������� ������:

     v1.0, 19.11.2018 07:41:29 +0300 - ������ ��������� ������, �������� "� ����" � �
     ������ �������� ����������� Shell_DeepTarball.lua.
--]]

local Mask="/.+\\.(t(bz|bz2|gz|lz|rz|xz|z)|tar\\.(gz|bz2|lz|lzma|rz|xz|z))/i";
local Msk="/.+(tar)/i";

Macro {
area = "Shell";
key = "Enter CtrlPgDn";
priority=60;
description = "Open tarball";
condition = function() return (mf.fmatch(APanel.Current,Mask)==1 and not APanel.Folder) end;
action = function() Far.DisableHistory(-1); Keys("CtrlPgDn Down CtrlPgDn")
 end;
}

Macro {
area = "Shell";
key = "CtrlPgUp";
priority=60;
description = "CdUp tarball";
condition = function() return
 (APanel.Plugin and (mf.fmatch(APanel.HostFile,Mask)==1 or mf.fmatch(APanel.HostFile,Msk)==1 )) end;
action = function() Far.DisableHistory(-1);
  local m1="/.+\\.(tbz|tbz2|tgz|tlz|trz|txz|tz)/i";
       while (mf.fmatch(APanel.HostFile,Msk)==1) do Keys("Home Enter") end;
        if mf.fmatch(APanel.HostFile,m1)==1 then Keys("Home Enter") end;
 end;
}