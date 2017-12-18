#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

setup() {
  setupYallaEnv
}

teardown() {
  teardownYallaEnv
}

@test "[YALLA] Test init" {
  skip
  run echo { Y; Y; } | $YALLA_CLI init

  assert_success
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: yalla dr [options]" ]
}
