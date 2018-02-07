--[[ Maco Debug tools. Source - Far Encyclopedia, Macroapi Manual, Examples

Данный макрос сначала сохраняет содержимое редактора (если оно не было сохранено),
затем исполняет редактируемый файл как Lua-скрипт.

This macro saves the editor contents (if it was modified)
 then runs the edited file as Lua-script.

--]]
Macro {
  description="Save and run script from editor";
  area="Editor"; key="CtrlF10";
  action=function()
    for k=1,2 do
      local info=editor.GetInfo()
      if bit64.band(info.CurState, far.Flags.ECSTATE_SAVED)~=0 then
        far.MacroPost('@"' .. info.FileName .. '"')
        break
      end
      if k==1 then editor.SaveFile(); end
    end
  end;
}
