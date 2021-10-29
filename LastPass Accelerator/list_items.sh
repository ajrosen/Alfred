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

    b=$(./get_url.applescript)
    browser=$(echo ${b} | awk -F\| '{ print $1 }')
    url=$(echo ${b} | awk 'BEGIN { FS="|" } { x = $2 } END { FS="/" ; $0 = x ; print $3}')

    ${lppath} ls --sync=auto --format %ai,%au | sort | sed 's/["\\]/\\&/g' > "${alfred_workflow_cache}/id"
    ${lppath} ls --sync=no --format %ai,%aN | sort | cut -d, -f2- | sed 's/\\/\//g;s/"/\\"/g' > "${alfred_workflow_cache}/path"
    ${lppath} ls --sync=no --format %ai,%al | sort | cut -d, -f2- | sed 's/["\\]/\\&/g' > "${alfred_workflow_cache}/url"
fi

awk -v arg="$*" \
    -v browser="${browser}" \
    -v url="${url}" \
    -v f_path="${alfred_workflow_cache}/path" \
    -v f_url="${alfred_workflow_cache}/url" \
    -f list_items.awk < "${alfred_workflow_cache}/id" > "${alfred_workflow_cache}/items"

# If there are no uid fields, show browser matches first and groups last
echo '{"items":[{}'
grep -v '"type":"group"' "${alfred_workflow_cache}/items"
grep '"type":"group"' "${alfred_workflow_cache}/items" | sort -u
echo ']}'
