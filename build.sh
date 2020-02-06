#!/bin/bash

PARAMETER_PANDOC=""

for i in $(git submodule foreach --quiet 'echo $path')
do
	PARAMETER_PANDOC="$PARAMETER_PANDOC$i/README.md "
	echo "Adding $i to root repo"
	git add "$i"
done

echo "Compiling markdown files..."
#echo "pandoc -f markdown-yaml_metadata_block -o README.md $PARAMETER_PANDOC"
pandoc -f markdown-yaml_metadata_block -o README.md $PARAMETER_PANDOC