#!/bin/bash

# Exit immediately on error
set -e
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR


# Load common vars and functions
for file in "${APP_YALLA_LIB}/*"
do
    . $file
done

