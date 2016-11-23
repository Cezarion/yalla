#!/bin/bash

composer global require "squizlabs/php_codesniffer=*"

#php ~/.composer/vendor/bin/phpcs -h ~/Sites/www/code/www/Fleurus-presse

ln -s ../../hooks/pre-commit .git/hooks/pre-commit

chmod a+x hooks/pre-commit