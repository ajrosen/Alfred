#!/bin/bash

${lppath} generate --sync=no ${symbols} -c lpa.$$ ${1:-20}
