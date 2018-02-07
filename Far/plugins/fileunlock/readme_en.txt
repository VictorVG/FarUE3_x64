Plug-in "File unlock" for Far Manager 3.0
*****************************************

Plugin that allows forced to force  close the files and directories
(including a recursive search mode) used by other applications.

Limitations:
  1. Files-modules (library dll), loaded applications by calling the
     LoadLibrary available for viewing only and can not be closed forcibly.
  2. Far should be run with user rights, not less than the process that
     opened the file. For exmple, if the file is opened by the administrator,
     and the plugin is called from a regular user - the handle will not be
     found.
  3. You can not keep track of files used by system services or drivers.
  4. Operating system: MS Windows Vista/7 or MS Windows Server 2008.

Known bugs:
  After using the plug-in Far application may "freeze" at exit.

Install:
  Unpack the archive to the Far plugins directory (...Far\Plugins).

Warning:
  This plugin is provided "as is". The author is not responsible for the
  consequences of use of this software.

Artem Senichev (artemsen@gmail.com)
               https://sourceforge.net/projects/farplugs/
