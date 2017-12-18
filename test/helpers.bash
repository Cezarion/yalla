assert_exists() {
  assert [ -e "$1" ]
}

refute_exists() {
  assert [ ! -e "$1" ]
}

assert_contains() {
  local item
  for item in "${@:2}"; do
    if [[ "$item" == "$1" ]]; then
      return 0
    fi
  done

  batslib_print_kv_single_or_multi 8 \
        'expected' "$1" \
        'actual'   "$(echo ${@:2})" \
      | batslib_decorate 'item was not found in the array' \
      | fail
}

setupYallaEnv() {
  if ! [ -f "${HOME}/.devilbox" ]; then
    echo "Devilbox settings are missing in ${HOME}"
    echo "Install devilbox"
    exit 1
  fi

  . "${HOME}/.devilbox"

  # Create a test directory
  mkdir -p $HOST_PATH_HTTPD_DATADIR/yalla-test
  export YALLA_HOME="${HOST_PATH_HTTPD_DATADIR}/yalla-test"

  # Put yalla code
  rsync -az . $YALLA_HOME/yalla --exclude=.git
  export YALLA_DIRECTORY="${YALLA_HOME}/yalla"

  # Setup Yalla cli script
  export YALLA_CLI="$YALLA_DIRECTORY/src/cli/yalla"

  cd $YALLA_HOME
}

teardownYallaEnv() {
  if [ $BATS_TEST_COMPLETED ]; then
    rm -r $YALLA_DIRECTORY
    rm -r $YALLA_HOME
  else
    echo "** Did not delete $YALLA_DIRECTORY, as test failed **"
  fi
}
