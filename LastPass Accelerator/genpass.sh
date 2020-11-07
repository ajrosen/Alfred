#!/bin/bash

LEN=${1:-20}

${lppath} generate ${symbols} -c lpa.$$ ${LEN}
${lppath} rm lpa.$$
