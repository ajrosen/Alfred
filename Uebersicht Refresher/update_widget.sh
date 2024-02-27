#!/bin/bash

if [ "${1}" == "quit" ]; then
    osascript -e 'tell application id "tracesOf.Uebersicht" to quit'
    pkill -f Übersicht
    exit
fi

if [ "${1}" == "all" ]; then
    osascript -e 'tell application id "tracesOf.Uebersicht" to refresh'
    exit
fi

S=$(osascript -e 'tell application id "tracesOf.Uebersicht" to get hidden of widget id "'"${1}"'"')

[ "${S}" == "false" ] && osascript -e 'tell application id "tracesOf.Uebersicht" to set hidden of widget id "'"${1}"'" to true'
[ "${S}" == "true" ] && osascript -e 'tell application id "tracesOf.Uebersicht" to set hidden of widget id "'"${1}"'" to false'
