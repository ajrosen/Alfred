#!/bin/bash

# shellcheck disable=2002,2181

export PATH=/bin:/usr/bin

# SMS
CHATS=~/Library/Messages/chat.db
MSG_AGE=$((MAX_AGE * 60))

alfred_workflow_cache=${alfred_workflow_cache:-.}

TOKENS="${alfred_workflow_cache}/tokens"
MESSAGES="${alfred_workflow_cache}/messages"

function clean() {
    rm -f "${MESSAGES}" "${TOKENS}"
}

trap clean EXIT


##################################################
# Choose folder for database
#
# This should never happen because the workflow has a default setting

if [ "${OTP}" == "" ]; then
    echo -n '{ "items": [ {}'
    echo -n ', { "title": "Choose folder for OTP database", "arg": "config"'
    echo -n ', "subtitle": "'"${OTP}"'" }'
    echo '] }'
    exit
fi


##################################################
# Create new database

file -b "${OTP}" | grep -iq SQLite

if [ $? != 0 ]; then
    echo -n '{ "items": [ {}'
    echo -n ', { "title": "Create new OTP database", "arg": "new",'
    echo -n '"subtitle": "'"${OTP}"'" }'
    echo -n '] }'
    exit
fi


##################################################
# Check database permissions

PERM=$(stat -f %A "${OTP}")

if [ "${PERM}" != "600" ]; then
    echo -n '{ "items": [ {}'
    echo -n ', { "title": "OTP database permissions error", "arg": "chmod",'
    echo -n '"subtitle": "'"${OTP}"' permissions must be 600 (rw-------)" }'
    echo -n '] }'
    exit
fi


mkdir -p "${alfred_workflow_cache}"


##################################################
# Look for tokens in Messages

# (hex.length / 2).times { |i| print hex.slice(i*2, 2).hex.chr }
2>&- sqlite3 -init /dev/null "${CHATS}" 'SELECT handle.id, message.text, HEX(message.attributedBody) FROM message JOIN handle ON (handle.rowid = message.handle_id) WHERE (strftime("%s", "now") - strftime("%s", message.date/1000000000 + 978307200, "unixepoch") < '"${MSG_AGE}"') ORDER BY message.date DESC;' \
    | grep -E '\<\d{5,8}\>' > "${MESSAGES}"


##################################################
# Get tokens in database

2>&- sqlite3 -init /dev/null "${OTP}" "SELECT alfred FROM totp WHERE item LIKE '%${*}%' ORDER BY item" \
    | sed 's/}//' > "${TOKENS}"


##################################################
# Spit it all out

echo -n '{ "items": [ {}'

cat "${MESSAGES}" | while read -r; do
    H=$(echo "${REPLY}" | cut -d\| -f1)
    R=$(echo "${REPLY}" | cut -d\| -f2-)
    C=$(echo "${R}" | grep -o -E '\<\d{5,8}\>')

    if [ $? == 0 ]; then
	ST="${H}: ${R}"

	echo -n ', { "title": "'"${C}"'", "subtitle": "'"${ST}"'"'
	echo -n ', "icon": { "type": "fileicon", "path": "/System/Applications/Messages.app" }'
	echo -n ', "variables": { "app": "SMS" }'
	echo -n ', "mods": { "command": { "valid": "false", "subtitle": "'"${ST}"'" }'
	echo -n ', "function": { "valid": "false", "subtitle": "'"${ST}"'" } }'
	echo ', "arg": "'"${C}"'" }'
    fi
done

if [ -n "${TOKENS}" ]; then
    # Time until tokens rotate
    R=$((60 - $(date +%S)))
    if [ ${R} -ge 30 ]; then R=$((R - 30)); fi
    if [ ${R} == 0 ]; then R=30; fi

    ST="TOKENS ROTATE IN ${R} SECONDS"
    if [ ${R} -gt 5 ]; then
	ST="Tokens rotate in ${R} seconds"
	R=$((R-5))
    fi

    if [ "${1}" == "" ]; then
	echo -n ', { "title": "Add new MFA device", "arg": "add", "subtitle": "'"${ST}"'"'
	echo -n ', "mods": { "command": { "valid": "false", "subtitle": "'"${ST}"'" }'
	echo -n ', "function": { "valid": "false", "subtitle": "'"${ST}"'" }'
	echo -n ', "control": { "valid": "false", "subtitle": "'"${ST}"'" }'
	echo -n ', "option": { "valid": "false", "subtitle": "'"${ST}"'" }'
	echo -n ', "shift": { "valid": "false", "subtitle": "'"${ST}"'" }'
	echo -n ', "control+shift": { "valid": "false", "subtitle": "'"${ST}"'" }'
	echo -n '} }'
    fi
fi

cat "${TOKENS}" | while read -r; do
    KEY="$(echo "${REPLY}" | cut -d'"' -f8)"
    VAL="$(${OATHTOOL} -b --totp "${KEY}")"

    echo "${REPLY}", '"subtitle": "'"${VAL}"'" }'
done

echo ']'
echo ', "rerun": "'"${R}"'"'
echo '}'
