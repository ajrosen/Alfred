#!/bin/bash

osascript -e 'tell application "Alfred 4" to display notification "'"${*}"'" with title "Change LastPass password"'
