# Git pre-commit Keyword Checker

## Overview

This pre-commit script checks if the commit contains keywords listed in keywords file to prevent from undesired changes.

If the commit contains keyword listed in the keywords file, it will simply fails the commit and show error messages.

## How to set up

1. Put files in git hooks directory

  * `pre-commit_keyword_checker.sh` --> `.git/hooks/pre-commit`  
  * `pre-commit_keywords` --> `.git/hooks/pre-commit_keywords`  

2. Modify `pre-commit_keywords` file

  * Each line contains RegEx formatted keyword definition.
  * Lines starting with '#' is comment line.(the line will be ignored)

## Example

If you use the sample keywords file like below,
```
# The line starting with '#' is comment line.
Foo.Bar
^FooBar
```  

The commit will fail if the added lines contain lines like  
```
Hello Foo-Bar
FooBar World
```
