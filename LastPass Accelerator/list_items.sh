#!/bin/bash

trap clean EXIT

clean () {
    rm -f id user
}

${lppath} status -q

if [ $? != 0 ]; then
    echo '{ "items": [ { "title": "Login to LastPass" } ] }'
else
    ${lppath} ls --format %ai > id
    ${lppath} ls --format %au | sed 's/["\\]/\\&/g' > user
    ${lppath} ls --format %aN | sed 's/["\\]/\\&/g' | awk -f list_items.awk
fi
