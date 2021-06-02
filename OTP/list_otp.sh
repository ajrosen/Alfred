#!/bin/bash

export PATH=/usr/local/bin:$PATH

CHATS=~/Library/Messages/chat.db
MSG_AGE=600			# 10 minutes

function clean() {
    rm -f "${alfred_workflow_cache}/messages" "${alfred_workflow_cache}/tokens"
}

trap clean EXIT


##################################################
# Choose folder for database

if [ "${db}" == "" ]; then
    echo -n '{ "items": [ {}'
    echo -n ', { "title": "Choose folder for OTP database", "arg": "config", "subtitle": "'${db}'" }'
    echo '] }'
    exit
fi


##################################################
# Create new database

file -b ${db} | grep -iq SQLite
if [ $? != 0 ]; then
    echo -n '{ "items": [ {}'
    echo -n ', { "title": "Create new OTP database", "arg": "new", "subtitle": "'${db}'" }'
    echo -n '] }'
    exit
fi


##################################################
# Look for tokens in Messages

mkdir -p "${alfred_workflow_cache}"

if [ -r "${CHATS}" ]; then
    sqlite3 "${CHATS}" 'SELECT handle.id, message.text FROM message JOIN handle ON (handle.rowid = message.handle_id) WHERE (strftime("%s", "now") - strftime("%s", message.date/1000000000 + 978307200, "unixepoch") < '${MSG_AGE}') ORDER BY message.date DESC;' | grep -E '\<\d{5,8}\>' > "${alfred_workflow_cache}/messages"
fi


##################################################
# Get tokens in database

sqlite3 ${db} "SELECT alfred FROM totp WHERE item LIKE '%${*}%' ORDER BY item" | sed 's/}//' > "${alfred_workflow_cache}/tokens"


##################################################
# Spit it all out

echo -n '{ "items": [ {}'

if [ ! -z "${alfred_workflow_cache}/tokens" ]; then
    # Time until tokens rotate
    R=$((60 - $(date +%S)))
    if [ ${R} -ge 30 ]; then R=$((${R} - 30)); fi
    if [ ${R} == 0 ]; then R=30; fi

    ST="TOKENS ROTATE IN ${R} SECONDS"
    if [ ${R} -gt 5 ]; then
	ST="Tokens rotate in ${R} seconds"
	R=$((${R}-5))
    fi

    echo -n ', { "title": "Add new MFA device", "arg": "add", "subtitle": "'${ST}'"'
    echo -n ', "mods": { "command": { "valid": "false", "subtitle": "'${ST}'" }'
    echo -n ', "function": { "valid": "false", "subtitle": "'${ST}'" }'
    echo -n ', "control": { "valid": "false", "subtitle": "'${ST}'" }'
    echo -n ', "shift": { "valid": "false", "subtitle": "'${ST}'" }'
    echo -n ', "control+shift": { "valid": "false", "subtitle": "'${ST}'" }'
    echo -n '} }'
fi

cat "${alfred_workflow_cache}/messages" | while read; do
    H=$(echo ${REPLY} | cut -d\| -f1)
    R=$(echo ${REPLY} | cut -d\| -f2-)
    C=$(echo ${R} | grep -o -E '\<\d{5,8}\>')

    if [ $? == 0 ]; then
	ST="${H}: ${R}"

	echo -n ', { "title": "'${C}'", "subtitle": "'${ST}'"'
	echo -n ', "icon": { "type": "fileicon", "path": "/System/Applications/Messages.app" }'
	echo -n ', "variables": { "app": "SMS" }'
	echo -n ', "mods": { "command": { "valid": "false", "subtitle": "'${ST}'" }'
	echo -n ', "function": { "valid": "false", "subtitle": "'${ST}'" } }'
	echo ', "arg": "'${C}'" }'
    fi
done

cat "${alfred_workflow_cache}/tokens" | while read; do
    echo ${REPLY}, '"subtitle": "'$(oathtool -b --totp $(echo ${REPLY} | cut -d'"' -f8))'" }'
done

echo '], "rerun": "'${R}'" }'
