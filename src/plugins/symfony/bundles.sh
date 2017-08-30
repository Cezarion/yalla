#!/bin/bash

#TODO: mutualiser ce script pour les techno WP, Drupal7, Drupal8, etc.

# Add some usefull bundles
cd "${APPLICATION_PATH_NAME}/"
BUNDLES_LIST_USEFULL=`cat ../bin/symfony/bundles_list_usefull`
for entry in $BUNDLES_LIST_USEFULL
do
    composer require $entry
done
echo "${GREEN} [ok] ${NORMAL}Usefull bundles installed"

# Ask developer to add some suggested bundles
BUNDLES_LIST_SUGGESTION=`cat ../bin/symfony/bundles_list_suggestion`
for entry in $BUNDLES_LIST_SUGGESTION
do
	read -p "Do you need bundle ${entry}: ? [y/n]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        composer require $entry
    fi
done
cd ..
echo "${GREEN} [ok] ${NORMAL}Bundles suggested"
