#!/usr/bin/env bash

set -e
trap 'echo "Aborting due to errexit on line $LINENO. file $(cd $(dirname "$0"); pwd)/$(basename "$0"). Exit code: $?" >&2' ERR

# Folder path where application code is located
readonly APPLICATION_PATH_NAME='application'

# export current path
readonly _SRC_="./yalla"

# Icons
readonly CHECKMARK=$'\xE2\x9C\x93'
readonly CROSSMARK=$'\xE2\x9C\x97'
readonly INFOMARK=$'\xE2\x84\xB9'
readonly WARNINGMARK=$'\xE2\x9A\xA0'

# Colors
readonly RED=$'\e[31;01m'
readonly BLUE=$'\e[36;01m'
readonly YELLOW=$'\e[33;01m'
readonly NORMAL=$'\e[0m'
readonly GREEN=$'\e[32;01m'
