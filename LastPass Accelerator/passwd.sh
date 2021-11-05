#!/bin/bash

. ./env.sh

export CURRENT=
export NEW="x"
export CONFIRM=

# Get current password
CURRENT=$(osascript -e 'text returned of (display dialog "Current Master Password for '"${lpuser}"'" default answer "" with title "Enter Current Password" with hidden answer)')
[ "${CURRENT}" == "" ] && exit

# Get new password
while [ "${NEW}" != "${CONFIRM}" ]; do
    NEW=$(osascript -e 'text returned of (display dialog "Enter New Master Password for '"${lpuser}"'" default answer "" with title "Enter New Password" with hidden answer)')
    [ "${NEW}" == "" ] && exit

    CONFIRM=$(osascript -e 'text returned of (display dialog "Confirm New Master Password for '"${lpuser}"'" default answer "" with title "Confirm New Password" with hidden answer)')
    [ "${CONFIRM}" == "" ] && exit

    # Check for mismatch
    if [ "${NEW}" != "${CONFIRM}" ]; then
	B=$(osascript -e 'button returned of (display alert "Password mismatch" as critical buttons { "Cancel", "Try Again" } default button "Try Again" cancel button "Cancel")')
	[ "${B}" == "Try Again" ] || exit
    fi
done

# Change password
expect <<'EOF'
log_user 0
spawn "$env(lppath)" passwd

expect {
    "Current Master Password" { send "$env(CURRENT)\r"; exp_continue }
    "Confirm New Master Password" { send "$env(CONFIRM)\r"; exp_continue }
    "New Master Password" { send "$env(NEW)\r"; exp_continue }

    "Fetching data..." { exec ./alert.sh Fetching data; exp_continue }
    "Re-encrypting" { exec ./alert.sh Re-encrypting }
}

expect {
    "Uploading..." { exec ./alert.sh Uploading; exp_continue }

    eof { send_user [ regsub -all {\e\[[[:digit:]]+[AJm]|:.\r|[\r\n]} $expect_out(buffer) "" ] }
}
EOF
