#!/bin/bash

. ./env.sh

echo "${lppass}" | lpass login "${lpuser}"
