#!/bin/bash
SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/lib/include.sh"

$DRUSH "$@"