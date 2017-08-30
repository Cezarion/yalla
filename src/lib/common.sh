#!/bin/bash

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR


# Load common vars and functions
. "${APP_YALLA_LIB}/variables.sh"
. "${APP_YALLA_LIB}/colors.sh"
. "${APP_YALLA_LIB}/helpers.sh"
. "${APP_YALLA_LIB}/functions.sh"
. "${APP_YALLA_LIB}/yalla.functions.sh"
