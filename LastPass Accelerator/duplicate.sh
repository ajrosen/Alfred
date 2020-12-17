#!/bin/bash

${lppath} duplicate ${lpitem}

echo Duplicated $(${lppath} show --name ${lpitem})
