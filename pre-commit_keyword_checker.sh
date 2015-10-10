#!/bin/sh

# Place keywords file first => .git/hooks/pre-commit_keywords
# The keywords file can contain lines of keywords.
# Each line should be RegEx formatted which can be used with grep command.

# definition of colors
COLOR_RED=$'\e[0;31m'
COLOR_BLUE=$'\e[0;34m'
CLOSE_TAG=$'\e[m'

# Find git diff target
if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

# Find the keywords file
KEYWORDS_FILE=`dirname $0`/pre-commit_keywords
if [ ! -e ${KEYWORDS_FILE} ];
then
  # If keywords file is not found, just quit this check script
  exit
fi

# Load the keywords file into array of keyword-line
# 1. remove comment lines
# 2. remove empty lines
IFS=$'\n'
KEYWORDS=($(cat ${KEYWORDS_FILE}| sed 's/#.*//' | sed '/^\s*$/d'))

CHECK_NG=false

# For each file in diff
for FILE in `git diff-index --name-status $against -- | grep '\.cs$'| cut -c3-` ; do

  # Run seaching for each keyword
  for keyword in ${KEYWORDS[@]}; do

    # Grep only in git-diff addition lines and put matching result in $grep-result.
    # 1. remove line starting with "+++"
    # 2. pick only added lines (starting with "+")
    # 3. remove "+" substring at the beginning of line
    grep_result=`git diff $against $FILE | sed '/^\+\+\+.*/d' | sed -n '/^\+.*/p' | sed 's/^\+\s*\(.\)/\1/' |  grep -E $keyword`
    if [ -n "${grep_result}" ]
    then
      echo  "$COLOR_BLUE"$FILE"$CLOSE_TAG": $keyword
      CHECK_NG=true
    fi
  done
done

if ${CHECK_NG};
then
  echo Your commit contains above keywords defined in ${KEYWORDS_FILE}
  echo "$COLOR_RED"COMMIT ABORTED!!!"$CLOSE_TAG"
  exit 1
fi
