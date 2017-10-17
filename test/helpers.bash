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
  export YALLA_DIRECTORY="$(mktemp -d)"
  export YALLA_HOME="$(mktemp -d)"
  #export HOME=$YALLA_HOME
}

setupYallaFullEnv() {
  setupYallaEnv

  mkdir -p $HOME/yalla
  rsync -az . $HOME/yalla --exclude=.git

  cd $HOME
}

teardownYallaEnv() {
  if [ $BATS_TEST_COMPLETED ]; then
    rm -rf $YALLA_DIRECTORY
    rm -rf $YALLA_HOME
  else
    echo "** Did not delete $YALLA_DIRECTORY, as test failed **"
  fi
}
