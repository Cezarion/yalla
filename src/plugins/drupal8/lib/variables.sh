#!/bin/bash

### Directory webroot & Prodile name
DIRECTORY="htdocs"

ROOT=$(dirname $(dirname "${SRC}"))

### Working directory.
REPOSITORY="${ROOT}/app"
WEBROOT="${ROOT}/app/${DIRECTORY}"
SHARED="${ROOT}/shared"

### Release directory
RELEASE_DIR="${ROOT}/backup/releases"