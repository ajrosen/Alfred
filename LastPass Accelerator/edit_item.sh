#!/bin/bash

. env.sh


# Make "url" uppercase
FIELD="${1}"
[ "${FIELD}" == "url" ] && FIELD=$(echo ${FIELD} | tr '[a-z]' '[A-Z]')


# Build display dialog command
dialog () {
    s='"'${1}' '${FIELD}'"'
    s+=' default answer ""'
    s+=' buttons { "OK", "Cancel" }'
    s+=' default button { "OK" }'
    s+=' with title "Edit '${lpname}'"'
    s+=' with icon posix file "icon.png"'
    [ "${FIELD}" == "password" ] && s+="with hidden answer"
}


# Prompt for new value
dialog "Enter new"
X=$(osascript -e "text returned of (display dialog ${s})")


# Reprompt if password
if [ "${FIELD}" == "password" ]; then
    dialog "Re-enter"
    Y=$(osascript -e "text returned of (display dialog ${s})")
    if [ "${X}" != "${Y}" ]; then
	echo "Password mismatch"
	echo "${X} -> ${Y}"
	exit
    fi
fi


# Submit change
if [ "${X}" != "" ]; then
    echo "${X}" | lpass edit --non-interactive --${FIELD} ${lpitem}
    echo "Changed ${FIELD}"
    [ "${FIELD}" != "password" ] && echo "${X}"
else
    echo "No changes"
fi
