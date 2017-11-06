#!/bin/bash
# Bash script to deploy to dev3 from Bitbucket Pipelines (or any other build system, with
# some simple modifications)

echo "Make git archive for commit ${BITBUCKET_COMMIT}"
git archive --format=tar.gz -o deploy.tgz $BITBUCKET_COMMIT
version=`git diff HEAD^..HEAD -- "$(git rev-parse --show-toplevel)"/src/cli/yalla | grep '^\+.*YALLA_VERSION' | sed -E 's/[^0-9\.]//g'` | echo $version
version=`git diff HEAD^..HEAD -- "$(git rev-parse --show-toplevel)"/src/cli/yalla | grep '^\+.*YALLA_VERSION' | sed -s 's/[^0-9\.]//g'` | echo $version

echo "Transfert archive"

if [ "$version" != "" ]; then
    echo "Created a new tag, v$version"
else
    echo "No new version"
fi

scp deploy.tgz deploy@37.187.57.175:/home/webdev/yalla/site/dl/
