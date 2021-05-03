#!/bin/bash

${lppath} status -q

# Not logged in
if [ $? != 0 ]; then
    subtitle="Default ${lpuser}"

    echo '{"items":[{"title":"Login to LastPass","subtitle":"'${subtitle}'"'
    [ $# != 0 ] && echo ',"variables":{"lpuser": "'${*}'"}'
    echo ',"mods":{'
    for mod in "command" "control" "function" "option" "shift"; do
	echo '"'${mod}'":{"valid":"false","subtitle":"'${subtitle}'"},'
    done
    echo '}}]}'

    exit
fi

# No filter argument (first run)
if [ $# == 0 ]; then
    mkdir -p "${alfred_workflow_cache}"

    ${lppath} ls --format %ai,%au | sort | sed 's/["\\]/\\&/g' > "${alfred_workflow_cache}/id"
    ${lppath} ls --format %ai,%aN | sort | cut -d, -f2- | sed 's/\\/\//g;s/"/\\"/g' > "${alfred_workflow_cache}/path"
    ${lppath} ls --format %ai,%al | sort | cut -d, -f2- | sed 's/["\\]/\\&/g' > "${alfred_workflow_cache}/url"
fi

awk -v arg="$*" \
    -v f_path="${alfred_workflow_cache}/path" \
    -v f_url="${alfred_workflow_cache}/url" \
    -f list_items.awk < "${alfred_workflow_cache}/id" > "${alfred_workflow_cache}/items"

echo '{ "items": [ {}'
grep '"type":"group"' "${alfred_workflow_cache}/items" | sort -u
grep -v '"type":"group"' "${alfred_workflow_cache}/items"
echo ']}'
