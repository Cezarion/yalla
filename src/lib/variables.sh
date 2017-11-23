#!/usr/bin/env bash

set -e
trap 'echo "Aborting due to errexit on line $LINENO. File $(cd $(dirname "$0"); pwd)/$(basename "$0"). Exit code: $?" >&2' ERR

## Never edit manually this line.
## Run sh ci/bumversion.sh instead
readonly YALLA_VERSION=0.1.5

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

# Ansible available remote env name
declare -a REMOTE_ENV_TYPE=(staging preprod live)
export REMOTE_ENV_NAMES

# Icons
readonly CHECKMARK=$'\xE2\x9C\x93'
readonly CROSSMARK=$'\xE2\x9C\x97'
readonly INFOMARK=$'\xE2\x84\xB9'
readonly WARNINGMARK=$'\xE2\x9A\xA0'
readonly ARROWMARK=$'\xE2\x9E\xA5'
readonly ARROWMARK2=$'\xE2\x86\x92'
readonly LAMPMARK=$'\xF0\x9F\x92\xA1'
readonly ALIEN=$'\xE2\x98\xA0'
readonly ALIEN2=$'\xF0\x9F\x91\xBE'
readonly UNICORN="🦄  "
readonly JOYSTICK="🕹️  "

# Colors
readonly RED=$'\e[31;01m'
readonly BLUE=$'\e[36;01m'
readonly YELLOW=$'\e[33;01m'
readonly NORMAL=$'\e[0m'
readonly GREEN=$'\e[32;01m'
