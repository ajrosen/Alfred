#!/usr/bin/osascript

try
    set u to ""
    tell application "System Events" to set p to first process whose frontmost is true
    tell (load script (system attribute "PWD") & "/" & (bundle identifier of p)) to set u to its getURL()
on error e
end try

return (posix path of (file of p as alias)) & "|" & u
