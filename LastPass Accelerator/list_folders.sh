#!/bin/bash

echo '{ "items": [ {}'

${lppath} ls --format %aN,%al | grep ',http://group$' | cut -d, -f1 | sort -u | sed 's:/$::g;s:\\:/:g' | while read; do
    echo ',{ "title": "'${REPLY}'", "arg": "'${REPLY}'", "icon": { "path": "group.png" } }'
done

echo '] }'

exit

[ ! -f items ] && ${lppath} ls --format %aN | tr \\\\ / > items

echo '{ "variables": { "next": "" }, "items": [ {}'

if [ "${bf}" == "" ]; then
    cut -d/ -f1 items | sort -u | while read; do
	grep "^${REPLY}" items | awk -F/ '{ if (NF > 2) exit 1 }'
	if [ $? == 0 ]; then
	    echo ',{ "title": "'$REPLY'", "arg": "'$REPLY'", "variables": { "bf": "'$REPLY'" } }'
	else
	    echo ',{ "title": "'$REPLY'", "arg": "'$REPLY'", "subtitle": "contains sub-folders", "variables": { "next": "sub" } }'
	fi
    done
else
    grep -i "^${bf}/" items | sed 's:/[^/]*$::' | sort -u | while read; do
	echo ',{ "title": "'$REPLY'", "arg": "'$REPLY'", "variables": { "bf": "'$REPLY'" } }'
    done
fi

echo '] }'
