#!/usr/bin/osascript

tell application "TextEdit"
    set x to 0
	
    repeat while x is 0
	set x to 1
	delay 0.5
		
	repeat with d in documents
	    if name of d starts with "lpass." then
		set x to 0
	    end if
	end repeat
    end repeat
end tell
