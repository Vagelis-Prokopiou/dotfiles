#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

if [[ ! "$1" ]]; then
    echo "Usage: $0 <branch_name>";
    exit 1;    
fi

branch_name="$1";

git checkout master;

echo "Deleting local $branch_name branch...";
git branch -D "$branch_name";

echo "Deleting remote $branch_name branch...";
git push origin --delete "$branch_name";

# Updates all local branch references.
git remote prune origin;

# If the develop branch is available switch to it.
git checkout develop 2> /dev/null;

echo "Your current branches are:";
git branch -a;
