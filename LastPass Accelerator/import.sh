#!/bin/bash

. ./env.sh

# Choose file
F=/$(osascript -e 'tell application "Finder"' -e 'activate' -e '(choose file with prompt "Choose file to import" showing package contents true) as text' -e 'end tell' | tr : / | cut -d/ -f2-)
[ "${F}" == "/" ] && exit

# Run import
2>&1 lpass import "${F}"
