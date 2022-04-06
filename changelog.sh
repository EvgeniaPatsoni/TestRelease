#!/bin/sh
set -eu

# Define OUTPUT_FILE variable as CHANGELOG.md, which is the final changelog file.
OUTPUT_FILE=CHANGELOG.md

# If a CHANGELOG.md file is not present in the current directory, then it creates an empty one.
if [ ! -f $OUTPUT_FILE ] 
then
  touch $OUTPUT_FILE
  echo "Created CHANGELOG.md"
fi

# Define TEMP_FILE variable as TEMP.md.
# This will be used as a temporary file that will hold only the latest changelog updates, in order to paste them at the beginning of the existing CHANGELOG.md file.
TEMP_FILE=TEMP.md

# Retrieve the last git tag and store it in TAG variable.
TAG=`git tag --sort=taggerdate | tail -1`

# Retrieve the date the git tag was generated at, and store it in DATE variable.
DATE=`git log -1 --format=%ci | awk '{print $1; }'`

# Print the release version along with its date as a heading, in the temporary changelog file.
echo "# RELEASE ${TAG} - ${DATE}" >> $TEMP_FILE

# Retrieve the commits that occured between the latest tag and the previous one in chronological order, and store them in GIT_LOG variable. 
# Commits are separated using the * character.
GIT_LOG=`git log --reverse --pretty="*%s (%h)" $(git tag --sort=-taggerdate | head -2)...$(git tag --sort=-taggerdate | head -1)`

# If GIT_LOG variable is empty, i.e. the only tag in the repository is the last one, then retrieve only the commits that occured before the last tag.
# This convention will be triggered e.g. during the first version release of a project.
if [ -z "$GIT_LOG" ]
then
  GIT_LOG=`git log --reverse --pretty="*%s (%h)" $(git tag --sort=-taggerdate | head -1)`
fi

# Define arrays that will be filled with each commit category.
fix=() #A bug Fix
feature=() # A new feature
build=() # Changes that affect the build system or external dependencies
chore=() # Other changes that don't modify src or test files
ci=() # Changes to CI configuration files and scripts
doc=() # Documentation only changes
style=() # Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
refactor=() # A code change that neither fixes a bug nor adds a feature
perf=() # A code change that improves performance
test=() # Adding missing tests or correcting existing tests

# Split commits uppon * character and save to arrays depending on their message
IFS=* commits=($GIT_LOG)

for i in "${commits[@]}"; do
  if [[ $i = feat:* ]]
  then
    feature+=($i)
  elif [[ $i = fix:* ]] 
  then
    fix+=($i)
  elif [[ $i = build:* ]]   
  then
    build+=($i)
  elif [[ $i = chore:* ]]   
  then
    chore+=($i)    
  elif [[ $i = ci:* ]]   
  then
    ci+=($i)     
  elif [[ $i = doc:* ]]   
  then
    doc+=($i) 
  elif [[ $i = style:* ]]   
  then
    style+=($i) 
  elif [[ $i = refactor:* ]]   
  then
    refactor+=($i) 
  elif [[ $i = perf:* ]]   
  then
    perf+=($i) 
  elif [[ $i = test:* ]]   
  then
    test+=($i)                      
  fi  
done

# Parse each array and print their contents (commit messages) under the corresponding category (e.g. Fixes, Features, etc.) in the temporary changelog file. 
# If no commits occured for a specific category, then it prints nothing.
if [ ${#feature[@]} -eq 0 ]; then
  :
else
  echo '### ✨ Features' >> $TEMP_FILE
  for i in "${feature[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done
fi

if [ ${#fix[@]} -eq 0 ]; then
  :
else
  echo '### 🐛 Fixes' >> $TEMP_FILE
  for i in "${fix[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done  
fi

if [ ${#build[@]} -eq 0 ]; then
  :
else
  echo '### 🛠 Builds' >> $TEMP_FILE
  for i in "${build[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done   
fi

if [ ${#chore[@]} -eq 0 ]; then
  :
else
  echo '### ♻️ Chores' >> $TEMP_FILE
  for i in "${chore[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done   
fi

if [ ${#ci[@]} -eq 0 ]; then
  :
else
  echo '### ⚙️ Continuous Integrations' >> $TEMP_FILE
  for i in "${ci[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done   
fi

if [ ${#doc[@]} -eq 0 ]; then
  :
else
  echo '### 📚 Documentation' >> $TEMP_FILE
  for i in "${doc[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done   
fi

if [ ${#style[@]} -eq 0 ]; then
  :
else
  echo '### 💎 Styles' >> $TEMP_FILE
  for i in "${style[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done   
fi

if [ ${#refactor[@]} -eq 0 ]; then
  :
else
  echo '### 📦 Code Refactoring' >> $TEMP_FILE
  for i in "${refactor[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done   
fi

if [ ${#perf[@]} -eq 0 ]; then
  :
else
  echo '### 🚀 Performance Improvements' >> $TEMP_FILE
  for i in "${perf[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done   
fi

if [ ${#test[@]} -eq 0 ]; then
  :
else
  echo '### 🚨 Tests' >> $TEMP_FILE
  for i in "${test[@]}"
  do
    echo "- $i" >> $TEMP_FILE
  done   
fi

# Print the contents of TEMP_FILE and OUTPUT_FILE inside a third tmp folder and then move tmp file to the final OUTPUT_FILE.
# This way, the latest changelog updates will be appended at the begging of the file and not at the end.
cat $TEMP_FILE $OUTPUT_FILE > tmp && mv tmp $OUTPUT_FILE

# Delete the temporary changelog file
rm $TEMP_FILE