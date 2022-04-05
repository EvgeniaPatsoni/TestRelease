#!/bin/sh
set -eu

# destination of the final changelog file
OUTPUT_FILE=CHANGELOG.md
TAG=`git tag --sort=taggerdate | tail -1`
DATE=`git log -1 --format=%ci | awk '{print $1; }'`

# print Changelog in the output file
echo "## RELEASE ${TAG} - ${DATE}" >> $OUTPUT_FILE

# generate the changelog
GIT_LOG=`git log --reverse --pretty="*%s (%h)" $(git tag --sort=-taggerdate | head -2)...$(git tag --sort=-taggerdate | head -1)`
echo $GIT_LOG

features=()
fixes=()
deletions=()

# Split commits uppon * character and save to arrays depending on commit message#
IFS=* commits=($GIT_LOG)
for i in "${commits[@]}"; do
  if [[ $i = feat:* ]]
  then
    features+=($i)
  elif [[ $i = fix:* ]] 
  then
    fixes+=($i)
  elif [[ $i = delete:* ]]   
  then
    deletions+=($i) 
  fi  
done


if [ ${#features[@]} -eq 0 ]; then
  echo ""
else
  echo '### Features' >> $OUTPUT_FILE
  for i in "${features[@]}"
  do
    echo "- $i" >> $OUTPUT_FILE
  done
fi

if [ ${#fixes[@]} -eq 0 ]; then
  echo ""
else
  echo '### Fixes' >> $OUTPUT_FILE
  for i in "${fixes[@]}"
  do
    echo "- $i" >> $OUTPUT_FILE
  done  
fi

if [ ${#deletions[@]} -eq 0 ]; then
  echo ""
else
  echo '### Deletions' >> $OUTPUT_FILE
  for i in "${deletions[@]}"
  do
    echo "- $i" >> $OUTPUT_FILE
  done   
fi