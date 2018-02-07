Plug-in "Sudo" for Far Manager 3.0
**********************************

Plugin that allows you to run processes with various privileges.
Analogue command "sudo" / "su" in linux. Relevant for MS Vista/Seven
systems with enabled UAC.

Usage:
  The plugin handles the following prefixes:

  - Start the process with elevated privileges:
    sudo: {Application} [Options]

  - Launch a new instance of the console with elevated privileges and execute
    specified command. Console after executing commands is not closed:
    su: [Command [Options]]

  - Start the process with reduced privileges:
    sudown: {Application} [Options]

Install:
  Unpack the archive to the Far plugins directory (...Far\Plugins).

Warning:
  This plugin is provided "as is". The author is not responsible for the
  consequences of use of this software.

Artem Senichev (artemsen@gmail.com)
               https://sourceforge.net/projects/farplugs/
