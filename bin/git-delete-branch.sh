#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# The "git branch -rd origin/<branchName>" removed the local branch reference, when all other failed.
if [[ $1 ]]; then
    git checkout master 2> /dev/null;
    branch_name="$1";
    
    echo "Deleting local $branch_name branch...";
    git branch -D "$branch_name";
    
    echo "Deleting remote $branch_name branch...";
    git push origin --delete "$branch_name";
    
    # If the develop branch is available switch to it.
    git checkout develop 2> /dev/null;
	
	# Updates all local branch references.
    git remote prune origin;
    
    echo "Your current branches are:";
    git branch -a;
else
    echo "Usage: git-delete-branch <branch_name>";
fi