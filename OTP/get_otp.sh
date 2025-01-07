#!/bin/bash

export PATH=/opt/homebrew/bin:$PATH

case ${app} in
    "SMS")
	echo $1	
	;;
    *)
	oathtool -b --totp $1
esac
