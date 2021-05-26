on getURL()
    set t to "current-tab"
    set wf to "net.deanishe.alfred.firefox-assistant"
    set p to ((system attribute "TMPDIR") & "alfred-firefox")

    try
	do shell script "mkfifo " & p
    end try

    try
	tell application id "com.runningwithcrayons.Alfred"
	    run trigger t in workflow wf with argument p
	    do shell script "json_pp < " & p & " | awk -F'\"' '/FF_URL/ { print $4 }'"
	end tell
    end try
end getURL
