#!/bin/sh
set -eu

# destination of the final changelog file
OUTPUT_FILE=CHANGE.md

echo '## Changelog' >> $OUTPUT_FILE
git tag --sort=taggerdate | tail -1 >> $OUTPUT_FILE
echo '## Commits' >> $OUTPUT_FILE 
# generate the changelog
git log --pretty="- %s (%h)" $(git tag --sort=-creatordate | head -2)...$(git tag --sort=-creatordate | head -1) >> $OUTPUT_FILE