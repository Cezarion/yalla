#!/bin/bash

# remove other initialize project
remove_project_init(){
    TYPE=$1

    case $TYPE in
        "symfony")
            rm bin/drupal7-init.sh
            rm bin/drupal8-init.sh
            rm bin/wordpress-init.sh
        ;;
        "wordpress")
            rm bin/symfony-init.sh
            rm bin/drupal7-init.sh
            rm bin/drupal8-init.sh
        ;;
        "drupal7")
            rm bin/symfony-init.sh
            rm bin/drupal8-init.sh
            rm bin/wordpress-init.sh
        ;;
        "drupal8")
            rm bin/symfony-init.sh
            rm bin/drupal7-init.sh
            rm bin/wordpress-init.sh
        ;;
    esac
}