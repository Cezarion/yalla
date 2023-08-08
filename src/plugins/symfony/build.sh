#!/bin/bash

SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/../lib/variables.sh"

cd "${APPLICATION_PATH_NAME}"
composer build
cd ..
