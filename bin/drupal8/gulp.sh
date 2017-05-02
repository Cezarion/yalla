#!/bin/bash

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/lib/include.sh"

# Run gulp outside theme folder
gulp --gulpfile "${THEME_PATH}/gulpfile.js" $1
