#!/bin/sh
set -eu

# destination of the final changelog file
OUTPUT_FILE=CHANGE.md

echo '## Changelog' >> $OUTPUT_FILE
git tag --sort=taggerdate | tail -1 >> $OUTPUT_FILE
echo '## Commits' >> $OUTPUT_FILE 
# generate the changelog
#GIT_LOG=`git log --pretty="- %s (%h)" $(git tag --sort=-taggerdate | head -2)...$(git tag --sort=-taggerdate | head -1)`
GIT_LOG=`git log --pretty="*%s" $(git tag --sort=-taggerdate | head -2)...$(git tag --sort=-taggerdate | head -1)`
echo $GIT_LOG

features=()
fixes=()
releases=()

##Split commits uppon * character and save to arrays depending on commit message##
IFS=* commits=($GIT_LOG)
for i in "${commits[@]}"; do
  if [[ $i = feat:* ]]
  then
    features+=($i)
  elif [[ $i = fix:* ]] 
  then
    fixes+=($i)
  elif [[ $i = release:* ]]  
  then
    releases+=($i)
  fi  
done

printf "%s\n" "${features[@]}"
printf "%s\n" "${fixes[@]}"
printf "%s\n" "${releases[@]}"


#[[ $GIT_LOG = feat:* ]] && echo '### Features' >> $OUTPUT_FILE 
#git log --pretty="- %s (%h)" $(git tag --sort=-taggerdate | head -2)...$(git tag --sort=-taggerdate | head -1) >> $OUTPUT_FILE