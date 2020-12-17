#!/bin/bash

trap "rm -f items" EXIT

${lppath} mv ${lpitem} "$*"
${lppath} show --name ${lpitem}
