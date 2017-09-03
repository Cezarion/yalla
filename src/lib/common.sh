#!/bin/bash

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR


# Load common vars and functions
. "$(pwd)/yalla/src/lib/variables.sh"
. "$(pwd)/yalla/src/lib/colors.sh"
. "$(pwd)/yalla/src/lib/helpers.sh"
. "$(pwd)/yalla/src/lib/functions.sh"
. "$(pwd)/yalla/src/lib/yalla.functions.sh"