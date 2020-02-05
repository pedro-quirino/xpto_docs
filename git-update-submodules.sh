#!/bin/bash

BRANCH=$1
shift

if [ -z $BRANCH ]; then
  echo "Missing argument (branch name)";
  exit 1;
fi

git checkout $BRANCH

git submodule sync
git submodule init
git submodule update --init --recursive

# for i in $(git submodule foreach --quiet 'echo $path')
# do
  # echo "Adding $i to root repo"
  # git add "$i"
# done

git add .
git commit -m "Updated $BRANCH branch of deployment repo to point to latest head of submodules"
git push origin $BRANCH


