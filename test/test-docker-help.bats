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

yalla="$(pwd)/src/cli/yalla"

@test "[DOCKER] Should print help successfully if requested" {
  run $yalla dr --help

  assert_success
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Usage: yalla dr [options]" ]
}

@test "[DOCKER] Should print help if no arguments are provided, and exit unsuccessfully" {
  run $yalla dr

  assert_failure
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Usage: yalla dr [options]" ]
}

@test "[DOCKER] Should print help if an unrecognized command is used, and exit unsuccessfully" {
  run $yalla dr imaginary-command
  echo $status
  assert_failure
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Usage: yalla dr [options]" ]
}
