#!/bin/bash

### Current user mail
EMAIL=$(git config user.email)
if [ -z "${EMAIL}" ]; then EMAIL="admin@local.host"; fi

export EMAIL;

# Colors
export RED=$'\e[31;01m'
export BLUE=$'\e[36;01m'
export YELLOW=$'\e[33;01m'
export NORMAL=$'\e[0m'
export GREEN=$'\e[32;01m'