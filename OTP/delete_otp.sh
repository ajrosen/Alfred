#!/bin/bash

T=$(sqlite3 ${db} "SELECT item FROM totp WHERE secret_key = '${1}';" | sed 's/ ()$//')

1>- osascript -e 'display dialog "Are you sure you want to delete this token?' -e "\n${T}" -e '" buttons { "Cancel", "Delete Token" } default button "Cancel" cancel button "Cancel" with title "Confirm Token Deletion" with icon stop'

[ $? != 0 ] && exit

sqlite3 ${db} "DELETE FROM totp WHERE secret_key = '${1}';"
echo ${T} deleted
