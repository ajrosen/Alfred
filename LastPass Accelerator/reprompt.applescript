#!/usr/bin/osascript
# *-*- apples -*-*

on run q
    set lpuser to (get system attribute "lpuser")

    set t to "Enter LastPass password"
    set p to "Enter password for " & lpuser
    set a to (display dialog p buttons {"OK", "Cancel"} default answer "" default button "OK" with title t with icon stop with hidden answer)
    set r to text returned of a

    if r is "" then
	return
    else
	return r
    end if
end run
