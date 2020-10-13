#!/bin/bash

export LPASS_DISABLE_PINENTRY=1

echo "${lppass}" | ${lppath} login "${lpuser}"
