#!/bin/bash

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR

SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/src/lib/variables.sh"
. "${SRC}/src/lib/colors.sh"
. "${SRC}/src/lib/helpers.sh"
. "${SRC}/src/lib/functions.sh"
. "${SRC}/src/lib/yalla.functions.sh"
