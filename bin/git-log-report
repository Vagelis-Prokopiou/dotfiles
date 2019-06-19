#!/usr/bin/env bash

# Report from git log.
if [[ "$1" ]]; then
    git log --since="$1" --no-merges --date=format:'%Y-%m-%d, %H:%M' --format='%ad: %s.' > report.txt;
    sed -i 's|\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(, \)\([0-9]\{2\}:[0-9]\{2\}\)\(: \)\(.*\)|Date: \1 on \3. Task: \5|g' report.txt;
    echo "";
    echo "\"report.txt\" is ready.";
else
    echo 'Usage: git-create-report <date>';
fi
