#!/bin/bash

2>&- ${lppath} show --$(echo ${field} | tr '[A-Z]' '[a-z]') -G $1
