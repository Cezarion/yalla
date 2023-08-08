#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

setup() {
  setupYallaFullEnv
  pwd
}

teardown() {
  teardownYallaEnv
}

yalla="./src/cli/yalla"


@test "[YALLA] Test init" {

  #yalla="${YALLA_HOME}/${yalla}"
  echo $YALLA_HOME
  echo 'popo'
  exit 1
  run $(which $yalla)

  assert_success
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: yalla dr [options]" ]
}
