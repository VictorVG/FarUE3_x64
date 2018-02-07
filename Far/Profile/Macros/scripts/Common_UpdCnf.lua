Macro{
  id="AFFAEF10-B760-4D6D-BF96-44DF7A22AEA6";
  area="Common";
  description="Update location IgorZ scripts in to LuaMacro DB";
  flags="EnableOutput RunAfterFARStart";
  action=function() Far.DisableHistory(-1) mf.print("lmdatacopymove:") Keys("Enter"); end;
}
