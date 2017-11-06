#!/bin/bash
# Bash script to deploy to dev3 from Bitbucket Pipelines (or any other build system, with
# some simple modifications)

echo "Make git archive for commit ${BITBUCKET_COMMIT}"
#git archive --format=tar.gz -o deploy.tgz $BITBUCKET_COMMIT
version1=`git diff HEAD^..HEAD -- "$(git rev-parse --show-toplevel)"/src/cli/yalla | grep '^\+.*YALLA_VERSION' | sed -E 's/[^0-9\.]//g'` | echo $version1
version2=`git diff HEAD^..HEAD -- "$(git rev-parse --show-toplevel)"/src/cli/yalla | grep '^\+.*YALLA_VERSION' | sed -s 's/[^0-9\.]//g'` | echo $version2

if [ "$version" != "" ]; then
    git tag -a "v$version" -m "`git log -1 --format=%s`"
    echo "Created a new tag, v$version"
    git push && git push --tags
else
    echo "No new version"
fi

#echo "Transfert archive"
#scp deploy.tgz deploy@37.187.57.175:/home/webdev/yalla/site/dl/
