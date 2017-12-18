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

yalla="./yalla/src/cli/yalla"

@test "YALLA should be created if it doesn't exist" {
  skip
  
  run $yalla install

  echo $output

  assert_success
  assert_exists "yalla/main"
}
