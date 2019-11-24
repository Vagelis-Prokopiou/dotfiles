#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

my_branches_prefix="vp_";

if [[ ! $1 ]]; then
    echo "Usage: git-cherry-pick <commitHash>";
    exit 1;
fi

commit="$1";
current_branch=$(git rev-parse --abbrev-ref HEAD);

git branch --all | grep remotes | grep -v ${current_branch} | grep -v HEAD | grep ${my_branches_prefix} | sed 's|remotes/origin/||g' | while read branch; do
    git checkout "${branch}";
    git pull 2> /dev/null;
    git cherry-pick "${commit}";
    git push 2> /dev/null;
done;

# Allowing for any branch handling, when explicitly applied. Todo: Add documentation.
if [[ $2 ]]; then
    git checkout "${2}";
    git pull 2> /dev/null;
    git cherry-pick "${commit}";
    git push 2> /dev/null;    
fi

git checkout "${current_branch}";
