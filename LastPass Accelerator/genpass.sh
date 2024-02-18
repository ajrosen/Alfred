#!/bin/bash

. ./env.sh

lpass generate --sync=no ${symbols} -c lpa.$$ ${1:-20}
