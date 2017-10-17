#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

setup() {
  setupYallaFullEnv
}

teardown() {
  teardownYallaEnv
}

yalla="./src/cli/yalla"


@test "[YALLA] Test init" {

  #yalla="${YALLA_HOME}/${yalla}"

  run { echo Y; Y;} | $yalla init

  assert_success
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: yalla dr [options]" ]
}
