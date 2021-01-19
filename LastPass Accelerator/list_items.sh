#!/bin/bash

${lppath} status -q

if [ $? != 0 ]; then
    echo '{ "items": [ { "title": "Login to LastPass", "subtitle": "'${lpuser}'" } ] }'
    exit
fi

if [ $# == 0 ]; then
    ${lppath} ls --format %ai | sort > id
    ${lppath} ls --format %ai,%au | sort | cut -d, -f2- | sed 's/["\\]/\\&/g' > user
    ${lppath} ls --format %ai,%aN | sort | cut -d, -f2- | sed 's/["\\]/\\&/g' > path
    ${lppath} ls --format %ai,%al | sort | cut -d, -f2- | sed 's/["\\]/\\&/g' > url
fi

awk -v arg=$1 -f list_items.awk < id
