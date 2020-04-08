local STP = require "StackTracePlus"
debug.traceback = function(...) return STP.stacktrace(...):gsub("\r\n","\n") end