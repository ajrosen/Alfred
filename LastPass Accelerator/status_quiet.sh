#!/bin/bash

. ./env.sh

lpass status -q
echo -n $?
