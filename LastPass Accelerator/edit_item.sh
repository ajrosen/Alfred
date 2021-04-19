#!/bin/bash

export EDITOR="open -eWn"
export EDITOR="nano -UmR"

${lppath} edit ${lpitem} &
./edit_item.applescript
kill %1
