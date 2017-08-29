#!/bin/bash

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/lib/include.sh"

if [ -z $2 ];then
	echo "${RED}USAGE:${NORMAL} $0 environment profilename"
	exit;
else
	echo "${GREEN}Installing an instance of Drupal8 with profile name $1...${NORMAL}"
fi

# Run install
# Usage install_actions ENV(prod|dev) PROFILE_NAME
install_actions $1 $2