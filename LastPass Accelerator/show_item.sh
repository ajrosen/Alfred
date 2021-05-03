#!/bin/bash

export LPASS_DISABLE_PINENTRY=1

icondir="${alfred_preferences}/workflows/${alfred_workflow_uid}"
icon="${icondir}/icon.png"

# Get the item
pb=$(echo "${lppass}" | 2>&- ${lppath} show ${lpitem})

while [ $? != 0 ]; do
    lppass=$(${alfred_preferences}/workflows/${alfred_workflow_uid}/reprompt.applescript)
    [ "${lppass}" == "" ] && exit
    pb=$(echo "${lppass}" | 2>&- ${lppath} show ${lpitem})
done

# Copy it to the clipboard
echo "${pb}" | grep -v "\[id: ${lpitem}]$" | pbcopy

# Look for an icon that matches the note type
type=$(pbpaste | grep '^NoteType: ' | sed 's/^NoteType: //')
if [ -f "${icondir}/sn/${type}.png" ]; then icon="${icondir}/sn/${type}.png"; fi

# Look for an icon that matches the credit card type
if [ "${type}" == "Credit Card" ]; then
    type=$(pbpaste | grep '^Type: ' | sed 's/^Type: //')
    if [ -f "${icondir}/sn/${type}.png" ]; then icon="${icondir}/sn/${type}.png"; fi
fi

osascript -e 'tell application "System Events"' \
	  -e 'set i to "'"${icon}"'"' \
	  -e 'display dialog (the clipboard) buttons {"OK"} default button "OK" with title "LastPass Accelerator" with icon posix file i' \
	  -e 'end tell'
