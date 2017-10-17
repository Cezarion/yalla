#!/bin/bash

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. File $(cd $(dirname "$0"); pwd)/$(basename "$0"). Exit code: $?" >&2' ERR

# Load common vars and functions
. "./yalla/src/lib/variables.sh"
. "./yalla/src/lib/colors.sh"
. "./yalla/src/lib/helpers.sh"
. "./yalla/src/lib/functions.sh"
. "./yalla/src/lib/docker.cmd.sh"
. "./yalla/src/lib/yalla.functions.sh"
. "./yalla/src/lib/mysql.functions.sh"
