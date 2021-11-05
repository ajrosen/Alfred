#!/bin/bash

. ./env.sh

cd "${alfred_workflow_cache}"

trap "rm -f pb" EXIT

icondir="${alfred_preferences}/workflows/${alfred_workflow_uid}"
icon="${icondir}/icon.png"

# Get the item
item=$(echo "${lppass}" | 2>&- lpass show ${lpitem})

while [ $? != 0 ]; do
    lppass=$(${alfred_preferences}/workflows/${alfred_workflow_uid}/reprompt.applescript)
    [ "${lppass}" == "" ] && exit
    item=$(echo "${lppass}" | 2>&- lpass show ${lpitem})
done

echo "${item}" | grep -v "\[id: ${lpitem}]$" > pb

# Look for an icon that matches the note type
type=$(grep '^NoteType: ' pb | sed 's/^NoteType: //')
if [ -f "${icondir}/sn/${type}.png" ]; then icon="${icondir}/sn/${type}.png"; fi

# Look for an icon that matches the credit card type
if [ "${type}" == "Credit Card" ]; then
    type=$(grep '^Type: ' pb | sed 's/^Type: //')
    if [ -f "${icondir}/sn/${type}.png" ]; then icon="${icondir}/sn/${type}.png"; fi
fi

osascript -e 'tell application "System Events"' \
	  -e 'set t to (do shell script "cat pb")' \
	  -e 'set i to "'"${icon}"'"' \
	  -e 'display dialog t buttons {"OK"} default button "OK" with title "LastPass Accelerator" with icon posix file i' \
	  -e 'end tell'
