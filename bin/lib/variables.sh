#!/bin/bash

### Current user mail
EMAIL=$(git config user.email)
if [ -z "${EMAIL}" ]; then EMAIL="admin@local.host"; fi

# Colors
RED=$'\e[31;01m'
BLUE=$'\e[36;01m'
YELLOW=$'\e[33;01m'
NORMAL=$'\e[0m'
GREEN=$'\e[32;01m'