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

declare -x -f remove_other_project_init;

# Preserve original arguments with quotes
# @see : https://stackoverflow.com/questions/3755772/how-to-preserve-double-quotes-in-in-a-shell-script/26733366#26733366
args_list(){
    argList=""
    #iterate on each argument
    for arg in "$@"
    do
      #if an argument contains a white space, enclose it in double quotes and append to the list
      #otherwise simply append the argument to the list
      if echo $arg | grep -q " "; then
       argList="$argList \"$arg\""
      else
       argList="$argList $arg"
      fi
    done

    #remove a possible trailing space at the beginning of the list
    argList=$(echo $argList | sed 's/^ *//')

    echo "$argList"
}

declare -x -f args_list;

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

declare -x -f gi;
