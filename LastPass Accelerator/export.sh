#!/bin/bash

. ./env.sh

# Get password
P=$(osascript -e 'text returned of (display dialog "Enter password for '"${lpuser}"'" default answer "" with title "Enter LastPass Password" with hidden answer)')
[ "${P}" == "" ] && exit

# Choose file
F=/$(osascript -e 'choose file name' | tr : / | cut -d/ -f2-)
[ "${F}" == "/" ] && exit

# Run export
X=$(echo "${P}" | lpass export 2>&1 > "${F}")

until [ $? == 0 ]; do
    # Incorrect password
    if [[ "$X" == *"Incorrect"* ]]; then
	P=$(osascript -e 'text returned of (display dialog "Incorrect password for '"${lpuser}"'" default answer "" with title "Enter LastPass Password" with hidden answer)')
    else
	# Unknown error
	Y=$(osascript -e 'display alert "Unknown error in LastPass export" message "'"${X}"'" as critical')
	exit
    fi

    X=$(echo "${P}" | lpass export 2>&1 > "${F}")
done

echo "${F}"
