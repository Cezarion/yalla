#!/bin/bash
# Bash script to deploy to dev3 from Bitbucket Pipelines (or any other build system, with
# some simple modifications)

echo "Make git archive for commit ${BITBUCKET_COMMIT}"
#git archive --format=tar.gz -o deploy.tgz $BITBUCKET_COMMIT

user=`git --no-pager show -s --format='%an'`
userEmail=`git --no-pager show -s --format='%ae'`

git config --global user.email "${userEmail}"
git config --global user.name "${user}"
#Darwin
#version=`git diff HEAD^..HEAD -- "$(git rev-parse --show-toplevel)"/src/cli/yalla | grep '^\+.*YALLA_VERSION' | sed -E 's/[^0-9\.]//g'`

# Lnux
version=`git diff HEAD^..HEAD -- "$(git rev-parse --show-toplevel)"/src/cli/yalla | grep '^\+.*YALLA_VERSION' | sed -s 's/[^0-9\.]//g'`

if [ "$version" != "" ]; then
    git tag -a "v$version" -m "`git log -1 --format=%s`"
    echo "Created a new tag, v$version"
    git push --tags
else
    echo "No new version"
fi

#echo "Transfert archive"
#scp deploy.tgz deploy@37.187.57.175:/home/webdev/yalla/site/dl/
