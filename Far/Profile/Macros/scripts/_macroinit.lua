local STP = require("StackTracePlus")
if STP then debug.traceback = function(...) return string.gsub(STP.stacktrace(...), "\r\n", "\n") end end
