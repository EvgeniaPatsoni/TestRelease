#!/bin/sh
set -eu

TYPE=$(git ls-remote --get-url)
if [[ "$TYPE" =~ .*"git.eurodyn.com".* ]];
then
	TAG1=`git tag --sort=taggerdate | tail -1`
	TAG2_2=`git tag --sort=taggerdate | tail -2`
	TAG2=`echo $TAG2_2 | cut -d' ' -f1`

	URL_REMOTE=`git config --get remote.origin.url`
	URL_GIT_ENDING=${URL_REMOTE::-4}
	#URL2=$(echo "$URL" | sed 's|://[^@]*@||g')
	URL_CREDENTIALS=$(echo "$URL_GIT_ENDING" | sed -e 's/\(:\/\/\).*\(@\)/\1\2/')
	URL=`echo "${URL_CREDENTIALS//@}"`

	REPLACE=`echo "$URL" | sed -r 's|/r/+|/compare/|g'`
	CONCAT="$REPLACE/$TAG1..$TAG2"
	echo $CONCAT
elif [[ "$TYPE" =~ .*"github.com".* ]];
then
	TAG1=`git tag --sort=taggerdate | tail -1`
	TAG2_2=`git tag --sort=taggerdate | tail -2`
	TAG2=`echo $TAG2_2 | cut -d' ' -f1`

	URL_REMOTE=`git config --get remote.origin.url`
	URL_GIT_ENDING=${URL_REMOTE::-4}
	URL_CREDENTIALS=$(echo "$URL_GIT_ENDING" | sed -e 's/\(:\/\/\).*\(@\)/\1\2/')
	URL=`echo "${URL_CREDENTIALS//@}"`	
	
	CONCAT="$URL/compare/$TAG1...$TAG2"
	echo $CONCAT
fi