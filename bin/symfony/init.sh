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
ln -s ../app/app/config/parameters.yml shared/local.yml

# Remove all other initialisation project
remove_other_project_init $PROJECT_TYPE
echo "${GREEN} [ok] ${NORMAL}Remove others project initialisation files"

# Add some usefull bundles
BUNDLES_LIST=`cat bundles_list_usefull`
for entry in $BUNDLES_LIST
do
    app/composer require $entry
done

# Ask developer to add some suggested bundles
BUNDLES_LIST=`cat bundles_list_suggestion`
for entry in $BUNDLES_LIST
do
	read -p "Do you need bundle ${entry}: ? [Y/n]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "${GREEN} [ok] ${NORMAL}Add ${entry} to your project"
        app/composer require $entry
    fi
done

# First commit with app content, only if current repo not skeleton
if [ `git config --get remote.origin.url | cut -d / -f 2` != "project-skeleton.git" ]; then
    git add .
    git commit -m "Initialisation ${PROJECT_TYPE} project"
    git push origin master
    echo "${GREEN} [ok] ${NORMAL}Push first commit with project init"
fi
