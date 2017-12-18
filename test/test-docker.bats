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

@test "[DOCKER] Should print help successfully if requested" {
  run $YALLA_CLI dr --help

  assert_success
  assert_line "Usage: yalla dr [options]"
}

@test "[DOCKER] Should print help if no arguments are provided, and exit unsuccessfully" {
  run $YALLA_CLI dr

  assert_failure
  assert_line "Usage: yalla dr [options]"
}

@test "[DOCKER] Should print help if an unrecognized command is used, and exit unsuccessfully" {
  run $YALLA_CLI dr imaginary-command

  assert_failure
  assert_line "Usage: yalla dr [options]"
}
