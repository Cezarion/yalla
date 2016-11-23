#!/bin/bash

# remove other initialize project
remove_other_project_init(){
    TYPE=$1

    case $TYPE in
        "symfony")
            rm -Rf bin/drupal7
            rm -Rf bin/drupal8
            rm -Rf bin/wordpress
        ;;
        "wordpress")
            rm -Rf bin/symfony
            rm -Rf bin/drupal7
            rm -Rf bin/drupal8
        ;;
        "drupal7")
            rm -Rf bin/symfony
            rm -Rf bin/drupal8
            rm -Rf bin/wordpress
        ;;
        "drupal8")
            rm -Rf bin/symfony
            rm -Rf bin/drupal7
            rm -Rf bin/wordpress
        ;;
    esac
}