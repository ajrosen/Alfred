#!/bin/bash

export PATH=/opt/homebrew/bin:$PATH

KEY=$(sqlite3 ${db} "select replace(otpauth,' ','%20') from totp where secret_key = '${1}'")
ITEM=$(sqlite3 ${db} "select item from totp where secret_key = '${1}'")

echo "${ITEM}"
echo
qrencode -o - -t asciii "${KEY}"
