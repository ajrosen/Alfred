#!/bin/bash

osascript -e 'tell application id "com.runningwithcrayons.Alfred" to display notification "'"${*}"'" with title "Change LastPass password"'
