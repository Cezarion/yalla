#!/bin/bash

SRC=$(cd $(dirname "$0"); pwd)

#TODO: mutualiser ce script pour les techno WP, Drupal7, Drupal8, etc.
echo ${SRC}
sh "${SRC}/../install-precommit.sh"