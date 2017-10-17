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

yalla="./src/cli/yalla"

@test "[YALLA] Should print help successfully if requested" {
  run $yalla --help

  assert_success
  assert_line "Main commands :"
}

@test "[YALLA] Should print help if no arguments are provided, and exit unsuccessfully" {
  run $yalla

  assert_failure
  assert_line "Main commands :"
}

@test "[YALLA] Should print help if an unrecognized command is used, and exit unsuccessfully" {
  run $yalla imaginary-command

  assert_failure
  assert_line "Main commands :"
}
