#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

target_branch="develop";

if [[ $1 ]]; then    
    target_branch="$1";
fi

commit=$(git rev-parse HEAD); \
current_branch=$(git status | head -n 1 | awk '{ print $3 }'); \
git checkout "${target_branch}" \
&& git pull \
&& git cherry-pick "${commit}" \
&& git push \
&& git checkout "${current_branch}" \
&& echo "Commit ${commit} was successfully cherry picked";
