#!/bin/bash

### Current user mail
EMAIL=$(git config user.email)
if [ -z "${EMAIL}" ]; then EMAIL="admin@local.host"; fi

export EMAIL;

export APPLICATION_PATH_NAME='app'

# Icons
export CHECKMARK=$'\xE2\x9C\x93'
export CROSSMARK=$'\xE2\x9D\x8C'
export INFOMARK=$'\xE2\x84\xB9'

# Colors
export RED=$'\e[31;01m'
export BLUE=$'\e[36;01m'
export YELLOW=$'\e[33;01m'
export NORMAL=$'\e[0m'
export GREEN=$'\e[32;01m'
