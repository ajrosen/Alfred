#!/bin/bash

. ./env.sh

echo "${lppass}" | 2>&- lpass show --$(echo ${field} | tr '[A-Z]' '[a-z]') $1
