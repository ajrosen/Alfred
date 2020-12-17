#!/usr/bin/osascript
# *-*- apples -*-*

on run q
    if q = "" then
	display alert "No username specified and no default" as critical buttons {"Cancel"}
    else
	set t to "Enter LastPass password"
	set p to "Enter password for " & q
	set a to (display dialog p buttons {"OK", "Cancel"} default answer "" default button "OK" with title t with icon stop with hidden answer)
	set r to text returned of a

	if r is "" then return

	try
	    tell application "System Events"
		set lpass_home to (get system attribute "LPASS_HOME")
		if lpass_home = "" then
		    set lpdir to first item of (get folders of home folder whose name is ".lpass")
		    get first item of (get files of lpdir whose name is "trusted_id")
		else
		    if not exists file (lpass_home & "/trusted_id") then error
		end if
	    end tell
	on error
	    set t to "Enter MFA code"
	    set p to "Leave empty if not using MFA"
	    set a to (display dialog p buttons {"OK", "Cancel"} default answer "" default button "OK" with title t with icon caution)
	    set r to r & "\n" & text returned of a
	end try

	return r
    end if
end run
