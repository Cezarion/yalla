#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

setup() {
  setupYallaEnv
  echo $YALLA_HOME
  ln -s "$(pwd)/src/cli/yalla" "${YALLA_HOME}/yalla"
}

teardown() {
  teardownYallaEnv
}

yalla="./yalla/src/cli/yalla"

@test "YALLA should be created if it doesn't exist" {
  skip
  rm -r $HOME/
  mkdir -p $HOME/yalla
  rsync -avz . $HOME/yalla --exclude=.git

  cd $HOME

  run $yalla install

  echo $output

  assert_success
  assert_exists "yalla/main"
}
