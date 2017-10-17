#!/usr/bin/env bash

set -e
trap 'echo "Aborting due to errexit on line $LINENO. File $(cd $(dirname "$0"); pwd)/$(basename "$0"). Exit code: $?" >&2' ERR

# Folder path where application code is located
readonly APPLICATION_PATH_NAME='application'

# Yalla setting file
readonly YALLA_SETTINGS_FILE='yalla.settings'

# Yalla setting file
readonly DOCKER_VERSION_MIN='17.*'

# export current path
readonly _SRC_="./yalla"

# Skeleton required foilders
declare -a FOLDERS=(application shared logs test vaults)
export FOLDERS

# Icons
readonly CHECKMARK=$'\xE2\x9C\x93'
readonly CROSSMARK=$'\xE2\x9C\x97'
readonly INFOMARK=$'\xE2\x84\xB9'
readonly WARNINGMARK=$'\xE2\x9A\xA0'
readonly ARROWMARK=$'\xE2\x9E\xA5'
readonly LAMPMARK=$'\xF0\x9F\x92\xA1'

# Colors
readonly RED=$'\e[31;01m'
readonly BLUE=$'\e[36;01m'
readonly YELLOW=$'\e[33;01m'
readonly NORMAL=$'\e[0m'
readonly GREEN=$'\e[32;01m'
