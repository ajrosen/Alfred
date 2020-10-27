#!/bin/bash

lppath=/usr/local/bin/lpass
${lppath} status -q

if [ $? != 0 ]; then
  echo '{ "items": [ { "title": "Login to LastPass" } ] }'
else
  echo '{ "items": [ {}' $(${lppath} ls --format ',{ "uid": "%ai", "title": "%aN", "arg": "%ai", "subtitle": "%au", "autocomplete": "%an", "match": "%an" }' --color=never | tr -d "\\" ) '] }'
fi
