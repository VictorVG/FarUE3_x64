-- This macro may pastes into your editor or dialog newly generated GUI
-- It adds two menu items to the F11 plugin menu
--   Paste GUID: simple format
--   Paste GUID: struct format
-- ©Shmuel Zeigerman, 23/09/2014
-- URL: http://forum.farmanager.com/viewtopic.php?f=15&p=123220#p123220

MenuItem{
  guid="0A28B8CB-6DC4-4D8E-A8D8-A2FC713567F6";
  menu="Plugins";
  area="Editor Dialog";
  description="Paste GUID: simple format";
  text=function(menu,area) return "Paste GUID: simple format" end;
  action=function(OpenFrom,Item)
  guid = win.Uuid(win.Uuid()):upper()
  mf.postmacro(mf.print,guid)
end;
}

--Example
--// {F40F2EB8-246C-4F25-817D-57A093094B2C}
--static GUID guid_PluginC0 =
--{ 0xf40f2eb8, 0x246c, 0x4f25, { 0x81, 0x7d, 0x57, 0xa0, 0x93, 0x9, 0x4b, 0x2c } };

MenuItem{
  guid="089E91B2-D9BD-4A88-B8FD-472799F40156";
  menu="Plugins";
  area="Editor";
  description="Paste GUID: struct format";
  text=function(menu,area) return "Paste GUID: struct format" end;
  action=function(OpenFrom,Item)
  guid = win.Uuid(win.Uuid())
  cstr = ([[
// {%s}
static GUID <<name>> =
{ 0x%s, 0x%s, 0x%s, { 0x%s, 0x%s, 0x%s, 0x%s, 0x%s, 0x%s, 0x%s, 0x%s } };
]]):format(guid:upper(),
    guid:match("(%w+).(%w+).(%w+).(%w%w)(%w%w).(%w%w)(%w%w)(%w%w)(%w%w)(%w%w)(%w%w)"))
  mf.postmacro(mf.print,cstr)
end;
}