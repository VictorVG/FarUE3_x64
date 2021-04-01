
local FarHints = "CDF48DA0-0334-4169-8453-69048DD3B51C" 
local ReviewID = "0364224C-A21A-42ED-95FD-34189BA4B204"
local ViewDlgID = "FAD3BD72-2641-4D00-8F98-5467EEBCE827"
local ThumbDlgID = "ABDFD3DF-FE59-4714-8068-9F944022EA50"


function ShowHint(Mess)
  if Mess ~= "" then
    Plugin.Call(FarHints, "Info", Mess)
  else
    Plugin.Call(FarHints, "Hide")
  end
end


local ID = ReviewID;

local Review = {}

function Review.Installed()
  return Plugin.Exist(ID)
end;

function Review.Loaded()
  return far.IsPluginLoaded(ID)
end;

function Review.IsView()
  return Area.Dialog and Dlg.Id == ViewDlgID
end;

function Review.IsThumbView()
  return Area.Dialog and Dlg.Id == ThumbDlgID
end;

function Review.IsQuickView()
  return Review.Loaded() and Plugin.SyncCall(ID, "IsQuickView")
end;

function Review.IsActive()
  return Review.IsView() or Review.IsQuickView()
end;

function Review.Update(Delay)
  return Plugin.SyncCall(ID, "Update", Delay)
end;


-- ������� � ���������� ����������� � ������ ������
-- Orig=0, Next=1 - � ����������
-- Orig=0, Next=0 - � �����������
-- Orig=1         - � �������
-- Orig=2         - � ����������
-- ����������: ������� ���������� ��������

function Review.Goto(Orig, Next)
  return Plugin.Call(ID, "Goto", Orig, Next)
end;

-- ��������� �������� �����������
-- Mode=0  - �������������� �������
--   Val=1 - �� ������������� �������
--   Val=2 - �� ������
--   Val=3 - �� ������
-- Mode=1  - ��������� ��������� ��������
--   Val   - ���������� ����������� (������������ �����), 1 - 100%
-- Mode=2  - ��������� ���������������� ��������
--   Val   - ��� ���������. ��� 100% �������� 1 ������������� 1%
-- Mode=3  - ��-��, ��� Mode=2, ������������ ������� ����
-- ����������: �����, �����������

function Review.Scale(Mode, Val)
  return Plugin.Call(ID, "Scale", Mode, Val)
end;

-- ��������� ������� �������� ��� ���������������� �����������
-- ����������: ������� ��������, ���������� �������

function Review.Page(Number)
  return Plugin.Call(ID, "Page", Number)
end;


-- ��������� ������������� ����������� � ������� ������������� ��������
-- Mode=0 - ��-�� �������
-- Mode=1 - ������� �� ���������
-- Mode=2 - ��������� �������
-- Mode=3 - ���������� �������
-- ���������� ��� ������ ��������

function Review.Decoder(Mode)
  return Plugin.Call(ID, "Decoder", Mode)
end;


-- �������/��������� �����������
-- Mode=0  - ������������� �������
--   Val=1 - ������� +90
--   Val=2 - ������� -90
--   Val=3 - ��������� �� �����������
--   Val=4 - ��������� �� ���������

function Review.Rotate(Mode, Val)
  return Plugin.Call(ID, "Rotate", Mode, Val)
end;


-- ���������� ����������� �����������
-- Flags&1 - ������� ����� ��������� EXIF ��������� (���� ��������)
-- Flags&2 - ������� ����� �������������
-- Flags&4 - ��������� ������������� � ������� ��������
-- ���������� ������� ���������� ����������

function Review.Save(Flags)
  return Plugin.Call(ID, "Save", Flags)
end;


-- ��������/��������� ����� �������������� �����������
-- ���� ������� �������� ������ - ���������� ������� ���������

function Review.Fullscreen(On)
  return Plugin.Call(ID, "Fullscreen", On)
end;


-- ����������� ������� 

function Review.Thumbs(...)
  return Plugin.Call(ID, "Thumbs", ...)
end;


-- ������������� ������ ������, ���� ������ Val
-- ����������: ����� ������ ������

function Review.Size(Val)
  return Plugin.Call(ID, "Size", Val)
end;


-------------------------------------------------------------------------------

Macro 
{ 
  description="Review: QuickView Helper"; area="Shell"; 
    key="CtrlO CtrlU CtrlF1 CtrlF2 Esc CtrlUp CtrlDown CtrlLeft CtrlRight";

  condition=function()
    if Review.IsQuickView() then
      Review.Update(0)
    end
    return false;
  end;

  action=function()
  end;
}


Macro 
{ 
  description="Review: Scale QuickView with mouse"; area="Shell";
    key="MsWheelUp MsWheelDown";

  condition=function()
    return (Review.Loaded() and Review.IsQuickView()) and 999 or False
  end;

  action=function()
    Review.Scale(3, akey(1):sub(-2) == "Up" and 5 or -5)
  end;
}


Macro 
{ 
  description="Review: Scale 0.N%"; area="Dialog"; key="/\\d/"; condition=Review.IsView;

  action=function()
    n = tonumber("0." .. mf.akey(2))
    n = n > 0 and n or 1
    Review.Scale(1, n)
  end;
}


Macro 
{ 
  description="Review: Goto Next Image"; area="Dialog"; key="PgDn Num3 CtrlMsWheelDown"; condition=Review.IsView; priority=99; EnableOutput=true;

  action=function()
    if Review.Goto(0, 1) then
      ShowHint("")
    else
      mf.beep(0)
      ShowHint("Last image")
    end
  end;
}

Macro 
{ 
  description="Review: Goto Prev Image"; area="Dialog"; key="PgUp Num9 CtrlMsWheelUp"; condition=Review.IsView; priority=99; EnableOutput=true;

  action=function()
    if Review.Goto(0, 0) then
      ShowHint("")
    else
      mf.beep(0)
      ShowHint("First image")
    end;
  end;
}


local LastFile

Macro 
{ 
  description="Review: Goto First Image"; area="Dialog"; key="Home"; condition=Review.IsView; EnableOutput=true;

  action=function()
    local File = APanel.Current
    if Review.Goto(1) then
      LastFile = File
      ShowHint("")
    else
      mf.beep(0)
      ShowHint("First image")
    end
  end;
}

Macro 
{ 
  description="Review: Goto Last Image"; area="Dialog"; key="End"; condition=Review.IsView; EnableOutput=true;

  action=function()
    local File = APanel.Current
    if Review.Goto(2) then
      LastFile = File
      ShowHint("")
    else
      mf.beep(0)
      ShowHint("Last image")
    end
  end;
}


Macro 
{ 
  description="Review: Goto back Image"; area="Dialog"; key="BS"; condition=Review.IsView; EnableOutput=true;

  action=function()
    if LastFile then
      if Review.Goto(3, LastFile) then
        LastFile = nil
      else
        mf.beep(0)
      end
    end
  end;
}



Macro 
{ 
  description="Review: Goto Next Page"; area="Dialog Shell"; key="CtrlPgDn CtrlMsWheelDown"; condition=Review.IsActive;

  action=function()
    Review.Page(Review.Page() + 1)
  end;
}

Macro 
{ 
  description="Review: Goto Prev Page"; area="Dialog Shell"; key="CtrlPgUp CtrlMsWheelUp"; condition=Review.IsActive;

  action=function()
    Review.Page(Review.Page() - 1)
  end;
}

Macro 
{ 
  description="Review: Goto First Page"; area="Dialog Shell"; key="CtrlHome"; condition=Review.IsActive;

  action=function()
    Review.Page(1)
  end;
}

Macro 
{ 
  description="Review: Goto Last Page"; area="Dialog Shell"; key="CtrlEnd"; condition=Review.IsActive;

  action=function()
    local Page, Pages = Review.Page()
    Review.Page(Pages)
  end;
}


Macro 
{ 
  description="Review: Next Decoder"; area="Dialog Shell"; key="AltPgDn"; condition=Review.IsActive;

  action=function()
    Review.Decoder(2)
  end;
}

Macro 
{ 
  description="Review: Prev Decoder"; area="Dialog Shell"; key="AltPgUp"; condition=Review.IsActive;

  action=function()
    Review.Decoder(3)
  end;
}

Macro 
{ 
  description="Review: Default Decoder"; area="Dialog Shell"; key="AltHome"; condition=Review.IsActive;

  action=function()
    Review.Decoder(1)
  end;
}


Macro 
{ 
  description="Review: Fullscreen mode On/Off"; area="Dialog"; key="F CtrlF"; condition=Review.IsView;

  action=function()
    Review.Fullscreen(not Review.Fullscreen())
  end;
}


Macro 
{ 
  description="Review: Rotate +90"; area="Dialog"; key=". ] AltMsWheelDown"; condition=Review.IsView;

  action=function()
    Review.Rotate(0, 1);
  end;
}

Macro 
{ 
  description="Review: Rotate -90"; area="Dialog"; key=", [ AltMsWheelUp"; condition=Review.IsView;

  action=function()
    Review.Rotate(0, 2);
  end;
}

Macro 
{ 
  description="Review: Swap horz"; area="Dialog"; key="Ctrl]"; condition=Review.IsView;

  action=function()
    Review.Rotate(0, 3);
  end;
}

Macro 
{ 
  description="Review: Swap vert"; area="Dialog"; key="Ctrl["; condition=Review.IsView;

  action=function()
    Review.Rotate(0, 4);
  end;
}

--Macro 
--{ 
--  description="Review: Save picture"; area="Dialog"; key="F2"; condition=Review.IsView;
--
--  action=function()
--    if Review.Save(1+2+8) then
----    ShowHint("Saved")
--    end
--  end;
--}



------------------------------------------------------------------------------
-- ������


Macro 
{ 
  description="Review: Scale Thumbs"; area="Dialog"; 
    key="CtrlMsWheelUp CtrlMsWheelDown ShiftMsWheelUp ShiftMsWheelDown"; 
    condition=Review.IsThumbView; priority=99;

  action=function()
    local Delta = akey(1):sub(-2) == "Up" and 1 or -1
    if akey(1):sub(1,4) == "Ctrl" then
      Delta = Delta * 16
    end
    Review.Size( Review.Size() + Delta )
  end;
}


Macro 
{ 
  description="Review: Thumbs Size"; area="Dialog"; key="/\\d/"; condition=Review.IsThumbView;

  action=function()
    n = tonumber(mf.akey(2))
    Review.Size(96 + n * 32)
  end;
}

