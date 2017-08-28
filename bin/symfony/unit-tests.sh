#!/bin/bash

# Download PHPUnit
cd "${APPLICATION_PATH_NAME}/"
composer global require "phpunit/phpunit"
echo "${GREEN} [ok] ${NORMAL}PHP Unit downloaded"

# Run PHPUnit tests
phpunit -c phpunit.xml.dist tests

cd ..
