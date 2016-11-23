#!/bin/bash

PROJECT_TYPE=symfony

SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/../lib/variables.sh"
. "${SRC}/../lib/helpers.sh"
. "${SRC}/../lib/functions.sh"

# Download symfony sources
rm -Rf app/
composer create-project symfony/framework-standard-edition app/
echo '' > app/.gitkeep

# Create symlink htdocs to web/ directory
echo "${GREEN} [ok] ${NORMAL}Create symlink htdocs/"
ln -s web app/htdocs

# Create symlink parameters.yml to shared/local.yml
echo "${GREEN} [ok] ${NORMAL}Create symlink local.yml from symfony parameters.yml"
ln ../app/app/config/parameters.yml shared/local.yml

#remove all other initialisation project
remove_project_init $PROJECT_TYPE
echo "${GREEN} [ok] ${NORMAL}Remove others project initialisation files"
