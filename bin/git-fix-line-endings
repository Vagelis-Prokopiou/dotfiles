#!/usr/bin/env bash

# Fix the '^M' in git diffs. See: http://stackoverflow.com/questions/1889559/git-diff-to-ignore-m
git config --global core.autocrlf true;
git rm --cached -r .;
git diff --cached --name-only -z | xargs -0 git add;
git commit -m "Fix CRLF";
echo -e "\n\tRun it per branch.\n";