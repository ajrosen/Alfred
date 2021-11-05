#!/bin/bash

. ./env.sh

I=$(lpass show --name ${lpitem})

X=$(osascript -e 'button returned of (display dialog "Are you sure you want to remove this item?\n\n\t'"${I}"'\n\nTHIS ACTION CANNOT BE UNDONE" buttons { "No", "Yes" } default button "No" cancel button "No" with title "Remove LastPass Item" with icon 0)')

if [ "${X}" == "Yes" ]; then
    lpass rm ${lpitem}
    echo "${I}"
fi
