#!/bin/bash

export LPASS_DISABLE_PINENTRY=1

echo "${lppass}" | 2>&- ${lppath} show --$(echo ${field} | tr '[A-Z]' '[a-z]') $1
