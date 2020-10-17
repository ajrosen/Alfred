#!/bin/bash

export PATH=/usr/local/bin:$PATH

oathtool -b --totp $1
