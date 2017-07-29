#!/bin/bash

SRC=$(cd $(dirname "$0"); pwd)
echo $SRC

cd app
composer build
cd ..