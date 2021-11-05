#!/bin/bash

. ./env.sh

lpass duplicate ${lpitem}

echo Duplicated $(lpass show --name ${lpitem})
