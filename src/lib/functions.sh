#!/usr/bin/env bash



###############################################################################
# _arg_list()
#
# Usage:
#   _arg_list $@
#
# Preserve original arguments with quotes
# @see : https://stackoverflow.com/questions/3755772/how-to-preserve-double-quotes-in-in-a-shell-script/26733366#26733366

_args_list(){
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

declare -x -f _args_list;


###############################################################################
# _gi()
#
# Usage:
#   _gi linux,osx,windows
#
# Use github.io api to generate .gitignore
# @see : https://www.gitignore.io/docs

function _gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

declare -x -f _gi;

###############################################################################
# _version()
#
# Usage:
#   _version 0.2.1
#
# transform string to allow number comparaisons
# @see : https://apple.stackexchange.com/questions/83939/compare-multi-digit-version-numbers-in-bash/123408#123408

function _version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }


