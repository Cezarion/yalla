#!/usr/bin/env bash

### Current user mail
EMAIL=$(git config user.email)
if [ -z "${EMAIL}" ]; then EMAIL="admin@local.host"; fi

export EMAIL;

# Folder path where application code is located
export APPLICATION_PATH_NAME='app'

# export current path
export _SRC_="$(pwd)/yalla"

# Icons
export CHECKMARK=$'\xE2\x9C\x93'
export CROSSMARK=$'\xE2\x9D\x8C'
export INFOMARK=$'\xE2\x84\xB9'
export WARNINGMARK=$'\xE2\x9A\xA0'

# Colors
export RED=$'\e[31;01m'
export BLUE=$'\e[36;01m'
export YELLOW=$'\e[33;01m'
export NORMAL=$'\e[0m'
export GREEN=$'\e[32;01m'
