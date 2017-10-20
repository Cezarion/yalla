#!/usr/bin/env bash

# _          _
# | |__   ___| |_ __   ___ _ __ ___
# | '_ \ / _ \ | '_ \ / _ \ '__/ __|
# | | | |  __/ | |_) |  __/ |  \__ \
# |_| |_|\___|_| .__/ \___|_|  |___/
#             |_|
#
# Helper functions.
#
# These functions are primarily intended to be used within scripts. Each name
# starts with a leading underscore to indicate that it is an internal
# function and avoid collisions with gloablly defined names.
#
# Bash Boilerplate: https://github.com/alphabetum/bash-boilerplate
#
# Copyright (c) 2016 William Melody • hi@williammelody.com
###############################################################################


###############################################################################
# _command_exists()
#
# Usage:
#   _command_exists <command-name>
#
# Returns:
#   0  If a command with the given name is defined in the current environment.
#   1  If not.
#
# Information on why `hash` is used here:
# http://stackoverflow.com/a/677212
_command_exists() {
  hash "${1}" 2>/dev/null
}

###############################################################################
# _contains()
#
# Usage:
#   _contains <item> <list>
#
# Example:
#   _contains "$item" "${list[*]}"
#
# Returns:
#   0  If the item is included in the list.
#   1  If not.
_contains() {
  local _test_list=(${*:2})
  for __test_element in "${_test_list[@]:-}"
  do
    if [[ "${__test_element}" == "${1}" ]]
    then
      return 0
    fi
  done
  return 1
}

###############################################################################
# _ask()
#
# Usage:
#   _ask "Your question"
#
#   This is a general-purpose function to ask Yes/No questions in Bash, either
#   with or without a default answer. It keeps repeating the question until it
#   gets a valid answer.
#
# Example:
#   if _ask "Do you want to do such-and-such?"; then
#       echo "Yes"
#   else
#       echo "No"
#   fi
#
#   Or if you prefer the shorter version:
#   _ask "Do you want to do such-and-such?" && said_yes
#   _ask "Do you want to do such-and-such?" || said_no
#


_ask() {
    # https://djm.me/ask
    local prompt default reply

    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}


###############################################################################
# _interactive_input()
#
# Usage:
#   _interactive_input
#
# Returns:
#   0  If the current input is interactive (eg, a shell).
#   1  If the current input is stdin / piped input.
_interactive_input() {
  [[ -t 0 ]]
}

###############################################################################
# _join()
#
# Usage:
#   _join <separator> <array>
#
# Examples:
#   _join , a "b c" d     => a,b c,d
#   _join / var local tmp => var/local/tmp
#   _join , "${FOO[@]}"   => a,b,c
#
# More Information:
#   http://stackoverflow.com/a/17841619
_join() {
  local IFS="${1}"
  shift
  printf "%s\n" "${*}"
}

###############################################################################
# _toupper()
#
# Usage:
#   _toupper <string>
#

_toupper() {
  local str="${*:-}"
  echo "${str}" | awk '{print toupper($0)}'
}

###############################################################################
# _tolower()
#
# Usage:
#   _tolower <string>
#

_tolower() {
  local str="${*:-}"
  echo "${str}" | awk '{print tolower($0)}'
}

###############################################################################
# _readlink()
#
# Usage:
#   _readlink [-e|-f|<options>] <path/to/symlink>
#
# Options:
#   -f  All but the last component must exist.
#   -e  All components must exist.
#
# Wrapper for `readlink` that provides portable versions of GNU `readlink -f`
# and `readlink -e`, which canonicalize by following every symlink in every
# component of the given name recursively.
#
# More Information:
#   http://stackoverflow.com/a/1116890
_readlink() {
  local _target_path
  local _target_file
  local _final_directory
  local _final_path
  local _option

  for __arg in "${@:-}"
  do
    case "${__arg}" in
      -e|-f)
        _option="${__arg}"
        ;;
      -*|--*)
        # do nothing
        # ':' is bash no-op
        :
        ;;
      *)
        if [[ -z "${_target_path:-}" ]]
        then
          _target_path="${__arg}"
        fi
        ;;
    esac
  done

  if [[ -z "${_option}" ]]
  then
    readlink "${@}"
  else
    if [[ -z "${_target_path:-}" ]]
    then
      printf "_readlink: missing operand\n"
      return 1
    fi

    cd "$(dirname "${_target_path}")" || return 1
    _target_file="$(basename "${_target_path}")"

    # Iterate down a (possible) chain of symlinks
    while [[ -L "${_target_file}" ]]
    do
      _target_file="$(readlink "${_target_file}")"
      cd "$(dirname "${_target_file}")" || return 1
      _target_file="$(basename "${_target_file}")"
    done

    # Compute the canonicalized name by finding the physical path
    # for the directory we're in and appending the target file.
    _final_directory="$(pwd -P)"
    _final_path="${_final_directory}/${_target_file}"

    if [[ "${_option}" == "-f" ]]
    then
      printf "%s\n" "${_final_path}"
      return 0
    elif [[ "${_option}" == "-e" ]]
    then
      if [[ -e "${_final_path}" ]]
      then
        printf "%s\n" "${_final_path}"
        return 0
      else
        return 1
      fi
    else
      return 1
    fi
  fi
}

###############################################################################
# _spinner()
#
# Usage:
#   _spinner <pid>
#
# Description:
#   Display an ascii spinner while <pid> is running.
#
# Example Usage:
#   ```
#   _spinner_example() {
#     printf "Working..."
#     (sleep 1) &
#     _spinner $!
#     printf "Done!\n"
#   }
#   (_spinner_example)
#   ```
#
# More Information:
#   http://fitnr.com/showing-a-bash-spinner.html
_spinner() {
  local _pid="${1:-}"
  local _delay=0.75
  local _spin_string="|/-\\"

  if [[ -z "${_pid}" ]]
  then
    printf "Usage: _spinner <pid>\n"
    return 1
  fi

  while ps a | awk '{print $1}' | grep -q "${_pid}"
  do
    local _temp="${_spin_string#?}"
    printf " [%c]  " "${_spin_string}"
    _spin_string="${_temp}${_spin_string%${_temp}}"
    sleep ${_delay}
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

###############################################################################
# _step_counter
#
# Usage:
#   _step_counter [--reset]
#
# Description:
#   An autocrement counter
#   Init _step_counter --init [ step number ]
#
# Example Usage:
#   _step_counter --init 10
#   _step_counter
#

_step_counter(){
    if [ "${1}" == "--init" ] && ! [ -z "$2" ]; then
      export YALLA_STEP_NUMBER=$2
      export YALLA_STEP_COUNTER=0
    else
      YALLA_STEP_COUNTER=$((YALLA_STEP_COUNTER+1))
      export YALLA_STEP="${YALLA_STEP_COUNTER}/${YALLA_STEP_NUMBER})"
    fi
}

###############################################################################
# _success() _info() _notice() _error()
#
# Usage:
#   _success <message>
#
# Description:
#   Display a message with color and ascii symbols
#
# Example Usage:
#   _info 'Yalla is now intalled'
#

_success() {
  clr_green "[${CHECKMARK}]" -n; clr_reset clr_green " ${1}" >&2;
}
#declare -x -f _success;

_warning(){
    clr_brown clr_bold "${WARNINGMARK} " -n; clr_reset clr_brown " ${1}" >&2;
}

#declare -x -f _warning;

_info(){
    clr_cyan clr_bold "[${INFOMARK}]" -n; clr_reset clr_cyan " ${1}" >&2;
}
#declare -x -f _info;

_notice(){
  #echo "${BLUE}[ ! ]${NORMAL} ${1} \n" >&2;
  clr_blue clr_bold "[!]" -n; clr_reset clr_blue " ${1}" >&2;
}
#declare -x -f _notice;

_error(){
  clr_red clr_bold "[${CROSSMARK}]" -n; clr_reset clr_red " ${1}" >&2;
}
#declare -x -f _error;

_line(){
  _br
  printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${1--}}
  _br
}

_br(){
  printf "\n"
}

_h1(){
    _line .
    clr_magenta clr_bold "${UNICORN}" -n; clr_reset clr_magenta clr_bold _toupper "${1}"
    _br
}

_h1_step(){
    _line $(clr_bright .)
    _step_counter
    clr_magenta "${YALLA_STEP} ${1} "
    _br
}

# exit functions
_bad_exit() {
    # echo ;
    # echo "${RED} ERROR: ${1}" >&2;
    # echo "${NORMAL}" >&2;
    _error "${1}"
    exit 1;
}
#declare -x -f _bad_exit;
