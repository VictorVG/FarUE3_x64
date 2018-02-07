Plug-in "Sniffer" for Far Manager 3.0
*************************************

The simple network sniffer that runs as a plugin for Far Manager.
Intercepted IP4 packets are represented as files in the emulated file system.

On MS Vista and higher systems with built-in firewall it adds a
rule allowing admission to all packages executable Sniffer (this action can be
undone in the plugins settings).

Pros and cons compared to the systems of Wireshark/WinDump/Microsoft
Network Monitor, etc.:
Pros:
 - No need to install additional drivers, all the work concentrated in
   user mode;
 - Plug-in is completely portable-program in the system except Plugins settings
   and rules on the firewall (optional) nothing prescribed.
Cons:
 - Intercepted only your network traffic and broadcasts;
 - Do not intercept network packets on loopback 127.0.0.1;
 - Do not intercept network packets discarded by system or firewall in the
   kernel mode;
 - Theoretically possible to pass packets at very high network load.


Install:
  Unpack the archive to the Far plugins directory (...Far\Plugins).

Warning:
  This plugin is provided "as is". The author is not responsible for the
  consequences of use of this software.

Artem Senichev (artemsen@gmail.com)
               https://sourceforge.net/projects/farplugs/
