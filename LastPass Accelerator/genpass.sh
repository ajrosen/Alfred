#!/bin/bash

trap "${lppath} rm lpa.$$" EXIT

LEN=${1:-20}

${lppath} generate ${symbols} -c lpa.$$ ${LEN}
