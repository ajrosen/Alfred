#!/bin/bash

# shellcheck disable=2181

export PATH=/bin:/usr/bin

T=$(sqlite3 "${OTP}" "SELECT item FROM totp WHERE secret_key = '${1}';" | sed 's/ ()$//')

1>- osascript -e 'display dialog "Are you sure you want to delete this token?' \
    -e "\n${T}" \
    -e '" buttons { "Cancel", "Delete Token" } default button "Cancel" cancel button "Cancel" with title "Confirm Token Deletion" with icon stop'

[ $? != 0 ] && exit

sqlite3 "${OTP}" "DELETE FROM totp WHERE secret_key = '${1}';"
echo "${T}" deleted
