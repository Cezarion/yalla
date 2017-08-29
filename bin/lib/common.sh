#!/bin/bash

# Exit immediately on error
set -e

SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/bin/lib/variables.sh"
. "${SRC}/bin/lib/colors.sh"
. "${SRC}/bin/lib/helpers.sh"
. "${SRC}/bin/lib/functions.sh"
