#!/bin/bash

# Download PHPUnit
cd app/
composer global require "phpunit/phpunit"
echo "${GREEN} [ok] ${NORMAL}PHP Unit downloaded"

# Run PHPUnit tests
phpunit -c phpunit.xml.dist tests

cd ..