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


@test "[YALLA] Should print help successfully if requested" {
  run $YALLA_CLI --help

  assert_success
  assert_line "Main commands :"
}

@test "[YALLA] Should print help if no arguments are provided, and exit unsuccessfully" {
  run $YALLA_CLI

  assert_failure
  assert_line "Main commands :"
}

@test "[YALLA] Should print help if an unrecognized command is used, and exit unsuccessfully" {
  run $YALLA_CLI imaginary-command

  assert_failure
  assert_line "Main commands :"
}
