#!/bin/bash

# works with a file called VERSION in the current directory,
# the contents of which should be a semantic version number
# such as "1.2.3"

# this script will display the current version, automatically
# suggest a "minor" version update, and ask for input to use
# the suggestion, or a newly entered value.

# once the new version number is determined, the script will
# pull a list of changes from git history, prepend this to
# a file called CHANGES (under the title of the new version
# number) and create a GIT tag.

BASE_VERSION=`sed -n -e '/YALLA_VERSION/ s/.*\= *//p' src/lib/variables.sh`


if [ ! -a BASE_VERSION ]; then
    echo fetch origin
    git fetch origin

    BASE_LIST=(`echo $BASE_VERSION | tr '.' ' '`)
    V_MAJOR=${BASE_LIST[0]}
    V_MINOR=${BASE_LIST[1]}
    V_PATCH=${BASE_LIST[2]}
    echo "Current version : $BASE_VERSION"
    V_MINOR=$((V_MINOR + 1))
    V_PATCH=0
    SUGGESTED_VERSION="$V_MAJOR.$V_MINOR.$V_PATCH"
    read -p "Enter a version number [$SUGGESTED_VERSION]: " INPUT_STRING
    if [ "$INPUT_STRING" = "" ]; then
        INPUT_STRING=$SUGGESTED_VERSION
    fi
    echo "Will set new version to be $INPUT_STRING"
    echo "${INPUT_STRING}" > VERSION
    echo "Version $INPUT_STRING:" > tmpfile
    git log --pretty=format:" - %s" "v$BASE_VERSION"...HEAD >> tmpfile
    echo "" >> tmpfile
    echo "" >> tmpfile
    cat CHANGELOG >> tmpfile
    sed -i '' "s/YALLA_VERSION=${BASE_VERSION}/YALLA_VERSION=${INPUT_STRING=}/g" src/lib/variables.sh
    sed -i '' "s/YALLA_VERSION=${BASE_VERSION}/YALLA_VERSION=${INPUT_STRING=}/g" src/cli/yalla
    mv tmpfile CHANGELOG
    git add CHANGELOG
    git commit -m "Version bump to $INPUT_STRING" VERSION src/cli/yalla src/lib/variables.sh
    git tag -a -m "Tagging version $INPUT_STRING" "v$INPUT_STRING"
    git push origin --tags
else
    echo "Could not find a VERSION file"
    read -p "Do you want to create a version file and start from scratch? [y]" RESPONSE
    if [ "$RESPONSE" = "" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "Y" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "Yes" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "yes" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "YES" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "y" ]; then
        echo "0.1.0" > VERSION
        echo "Version 0.1.0" > CHANGES
        git log --pretty=format:" - %s" >> CHANGES
        echo "" >> CHANGES
        echo "" >> CHANGES
        git add VERSION CHANGES
        git commit -m "Added VERSION and CHANGES files, Version bump to v0.1.0"
        git tag -a -m "Tagging version 0.1.0" "v0.1.0"
        git push origin --tags
    fi

fi
