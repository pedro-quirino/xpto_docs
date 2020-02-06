#!/bin/bash

BRANCH=$1

if [ -z $BRANCH ]; then
  echo "Missing argument (branch name)";
  exit 1;
fi

git checkout $BRANCH && git pull --ff origin $BRANCH

git submodule sync
git submodule init
git submodule update
git submodule foreach "(git checkout $BRANCH && git pull --ff origin $BRANCH && git push origin $BRANCH) || true"


PARAMETER_PANDOC_EXT=""
PARAMETER_PANDOC_INT=""

for i in $(git submodule foreach --quiet 'echo $path')
do
	PARAMETER_PANDOC_EXT="$PARAMETER_PANDOC$i/ext/README.md "
	PARAMETER_PANDOC_INT="$PARAMETER_PANDOC$i/int/README.md "
	echo "Adding $i to root repo"
	git add "$i"
done


echo "Compiling markdown files:"

echo "Merging external files..."
pandoc -f markdown-yaml_metadata_block -o ext/README.md $PARAMETER_PANDOC_EXT

echo "Merging internal files..."
pandoc -f markdown-yaml_metadata_block -o int/README.md $PARAMETER_PANDOC_INT

echo "Merging all files..."
pandoc -f markdown-yaml_metadata_block -o int/README.md ext/README.md

echo "Markdown files compiled successfully."


git add .
git commit -m "Updated $BRANCH branch of deployment repo to point to latest head of submodules"
git push origin $BRANCH
