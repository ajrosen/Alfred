#!/bin/bash

echo '{ "items": [ {},'
if [ $# == 0 ]; then
    echo '  { "title": "Refresh All Widgets ", "arg": "all" }'
    echo ','
fi

VISIBLE=$(osascript -e 'tell application id "tracesOf.Uebersicht" to get widgets where hidden is false' \
	      | sed 's/«[^»]*» id //g' \
	      | awk 'BEGIN { RS=", " } tolower($0) ~ /'"${*}"'/ { print $0 }')

HIDDEN=$(osascript -e 'tell application id "tracesOf.Uebersicht" to get widgets where hidden is true' \
	      | sed 's/«[^»]*» id //g' \
	      | awk 'BEGIN { RS=", " } tolower($0) ~ /'"${*}"'/ { print $0 }')

for W in ${VISIBLE}; do
    T=${W/%-jsx/}
    echo '{ "title": "'"${T}"'", "subtitle": "Return to refresh.  ^-return to hide.", "arg": "'"${W}"'" },'
done

for W in ${HIDDEN}; do
    T=${W/%-jsx/}
    echo '{ "title": "'"${T}"'", "subtitle": "^-return to show.", "arg": "'"${W}"'" },'
done

echo '{ "title": "Quit", "arg": "quit" }'
echo '] }'
