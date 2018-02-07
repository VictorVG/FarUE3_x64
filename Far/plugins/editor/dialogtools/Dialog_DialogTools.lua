-- See http:// forum.farmanager.com/viewtopic.php?p=136132#p136132
-- We complete password copy function to the clipboard directly
-- from under the asterisks (based on John Doe code and idea). /VictorVG/

local DLGITEMTYPE_EDIT, DLGITEMTYPE_PSWEDIT, DLGITEMTYPE_FIXEDIT = 4, 5, 6

local DialogTools_MainGuid = "B2EC2264-0F55-4B86-87F7-F1392B8FC5DC"
local DialogTools_SrchGuid = "40E53FB1-6291-45a1-9DDF-B4A2048CA6BA"
local DialogTools_RplcGuid = "F4C58B97-BA69-4814-9FC9-DAB9307C0E88"
local DialogTools_UndoGuid = "1117C0E3-76BA-443D-90E3-89D20C45F364"
local DialogTools_EditGuid = "D0C5118D-E750-4E00-A4D4-0E0E0063571F"
local DialogTools_PwShGuid = "C8D4D4A4-943B-436F-8414-D36CBAF37C53"

local F = far.Flags

local function inEditField()
  return Dlg.ItemType == DLGITEMTYPE_EDIT or Dlg.ItemType == DLGITEMTYPE_FIXEDIT
end

local function callUndoRedo( stepKey )
  Plugin.Menu( DialogTools_MainGuid, DialogTools_UndoGuid )
  Keys( stepKey .. ' ' .. 'Enter' )
end

local function copyPwd()
local pwd,hDlg,CurPos
   Plugin.Menu( DialogTools_MainGuid, DialogTools_EditGuid )
   hDlg = far.AdvControl(F.ACTL_GETWINDOWINFO).Id
   CurPos = hDlg:send(F.DM_GETFOCUS)
   local item = hDlg:send(F.DM_GETDLGITEM,CurPos)
   if item and item[1]==F.DI_PSWEDIT then
     pwd = hDlg:send(F.DM_GETTEXT,CurPos);
   end
    far.CopyToClipboard(pwd)
end

Macro {
  description = "DialogTools: Search";
  area = "Dialog"; key = "F7";
  condition = inEditField;
  action = function() Plugin.Menu( DialogTools_MainGuid, DialogTools_SrchGuid ) end
}

Macro {
  description = "DialogTools: Replace";
  area = "Dialog"; key = "CtrlF7";
  condition = inEditField;
  action = function() Plugin.Menu( DialogTools_MainGuid, DialogTools_RplcGuid ) end
}

Macro {
  description = "DialogTools: Undo";
  area = "Dialog"; key = "CtrlZ AltBS";
  condition = inEditField;
  action = function() callUndoRedo( '' ) end
}

Macro {
  description = "DialogTools: Redo";
  area = "Dialog"; key = "CtrlShiftZ AltShiftBS";
  condition = inEditField;
  action = function() callUndoRedo( 'Up' ) end
}

Macro {
  description = "DialogTools: Edit";
  area = "Dialog"; key = "F4";
  condition = inEditField;
  action = function() Plugin.Menu( DialogTools_MainGuid, DialogTools_EditGuid ) end
}

Macro {
  description = "DialogTools: Show password";
  area = "Dialog"; key = "F3";
  condition = function() return Dlg.ItemType == DLGITEMTYPE_PSWEDIT end;
  action = function() Plugin.Menu( DialogTools_MainGuid, DialogTools_PwShGuid ) end
}

Macro{
  description="DialogTools: Copy pasword";
  area="Dialog"; key="CtrlIns";
  condition=function() return Dlg.ItemType == DLGITEMTYPE_PSWEDIT end;
  action=function() copyPwd() end;

}
