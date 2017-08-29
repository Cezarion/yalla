#!/bin/bash

PROJECT_TYPE=symfony

SRC=$(cd $(dirname "$0"); pwd)

. "${SRC}/../lib/common.sh"


# Download symfony sources
while true; do
    read -p "Do you wish to fully re/install, it will delete ${PWD}/application directory ?" yn
    case $yn in
        [Yy]* ) printf "Ok, let's go ! \n"; break;;
        [Nn]* )
            printf "Ok, bye ! \n";
            exit;
            break;;
        * ) printf "Please answer yes or no. \n";;
    esac
done

# Download symfony sources
rm -Rf "${APPLICATION_PATH_NAME}/";
symfony new "${APPLICATION_PATH_NAME}"
echo '' > "${APPLICATION_PATH_NAME}/.gitkeep"

# Create symlink htdocs to web/ directory
echo "${GREEN} [ok] ${NORMAL}Create symlink htdocs/"
ln -s "${APPLICATION_PATH_NAME}/web" htdocs

# Create symlink parameters.yml to shared/local.yml
echo "${GREEN} [ok] ${NORMAL}Create symlink local.yml from symfony parameters.yml"
ln -s "../${application}/app/config/parameters.yml" shared/local.yml


sh "${SRC}/bundles.sh"

sh "${SRC}/unit-tests.sh"

echo "${GREEN} [ok] ${NORMAL}Install precommit"
sh "${SRC}/../install-precommit.sh"


# First commit with application content, only if current repo not skeleton
if [ `git config --get remote.origin.url | cut -d / -f 2` != "project-skeleton.git" ]; then
    git add .
    git commit -m "Initialisation ${PROJECT_TYPE} project"
    git push origin master
    echo "${GREEN} [ok] ${NORMAL}Push first commit with project init"
fi
