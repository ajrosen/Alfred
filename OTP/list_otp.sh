#!/bin/bash

echo '{ "items": ['

if [ "${db}" == "" ]; then
    echo '{ "title": "Choose folder for OTP database", "arg": "config", "subtitle": "'${db}'" }'
else
    file -b ${db} | grep -iq SQLite

    if [ $? != 0 ]; then
	echo '{ "title": "Create new OTP database", "arg": "new", "subtitle": "'${db}'" }'
    else
	echo '{}'
	if [ "${1}" == "" ]; then
	    echo ',{ "title": "Add new MFA device", "arg": "add", "subtitle": "'${db}'" }'
	fi
	sqlite3 ${db} 'select alfred from totp order by alfred;' | grep -i '"title": "[^"]*'${1}'[^"]*"'
    fi
fi

echo '] }'
