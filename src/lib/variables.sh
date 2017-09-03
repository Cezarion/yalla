#!/usr/bin/env bash

set -e
trap 'echo "Aborting due to errexit on line $LINENO. file $(cd $(dirname "$0"); pwd)/$(basename "$0"). Exit code: $?" >&2' ERR

# Folder path where application code is located
APPLICATION_PATH_NAME='application'

# export current path
_SRC_="./yalla"

# Icons
CHECKMARK=$'\xE2\x9C\x93'
CROSSMARK=$'\xE2\x9C\x97'
INFOMARK=$'\xE2\x84\xB9'
WARNINGMARK=$'\xE2\x9A\xA0'

# Colors
RED=$'\e[31;01m'
BLUE=$'\e[36;01m'
YELLOW=$'\e[33;01m'
NORMAL=$'\e[0m'
GREEN=$'\e[32;01m'
