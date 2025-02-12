#!/bin/bash

# shellcheck disable=2154

export PATH=/bin:/usr/bin

case ${app} in
    "SMS")
	echo "${1}"
	;;
    *)
	${OATHTOOL} -b --totp "${1}"
esac
