#!/bin/bash

# shellcheck disable=2012

TRASH="${HOME}/.Trash/"
MOBILE="${HOME}/Library/Mobile Documents/.Trash/"

ITEMS=$(find "${TRASH}" "${MOBILE}" -depth 1 | wc -l)
BYTES=$(du -sk "${TRASH}" "${MOBILE}" | awk '{ t = t + $1 } END { print t }')

DU="${BYTES} KB"
[ "${BYTES}" -gt 1024 ] && DU="$((BYTES / 1024)) MB"
[ "${BYTES}" -gt 1048576 ] && DU="$((BYTES / 1048576)) GB"
[ "${BYTES}" -gt 1073741824 ] && DU="$((BYTES / 1073741824)) TB"
[ "${BYTES}" -gt 1099511627776 ] && DU="$((BYTES / 1099511627776)) PB"

echo '{ "items": ['

printf ' { "title": "Open Trash in Finder (%d items)", "arg": "open"' "${ITEMS}"
echo ',"mods":{"alt":{"valid":"false","subtitle":""},"cmd":{"valid":"true","subtitle":"Empty Trash"}}}'

printf ', { "title": "Empty Trash (%s)", "arg": "empty"' "${DU}"
echo ',"mods":{"alt":{"valid":"false","subtitle":""},"cmd":{"valid":"false","subtitle":""}}}'

cd "${TRASH}" && ls -1 | while read -r; do
    echo ', { "title": "'"${REPLY}"'", "icon": { "path": "/dev/null" }'
    echo ',"mods":{"alt":{"valid":"false","subtitle":""},"cmd":{"valid":"false","subtitle":""}}}'
done

cd "${MOBILE}" && ls -1 | while read -r; do
    echo ', { "title": "'"${REPLY}"'", "icon": { "path": "/dev/null" }'
    echo ',"mods":{"alt":{"valid":"false","subtitle":""},"cmd":{"valid":"false","subtitle":""}}}'
done

echo ' ] }'
