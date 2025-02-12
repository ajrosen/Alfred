#!/bin/bash

export PATH=/bin:/usr/bin

KEY=$(sqlite3 "${OTP}" "select replace(otpauth,' ','%20') from totp where secret_key = '${1}'")
ITEM=$(sqlite3 "${OTP}" "select item from totp where secret_key = '${1}'")

echo -n "${1}" | pbcopy

echo "${ITEM}"
echo
${QRENCODE} -o - -t asciii "${KEY}"
