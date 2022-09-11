#!/bin/bash

. ./env.sh

lpass mv ${lpitem} "$*"
lpass show --name ${lpitem}
