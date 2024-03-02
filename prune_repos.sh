#! /bin/bash
START_PWD=$(pwd)
for dir in src/*/
do
    cd "$dir"
    git fetch --prune origin
    git removed-branches --prune --force -r origin
    if git remote | grep -q '^fork$'; then
      git fetch --prune fork
      git removed-branches --prune --force -r fork
    fi
    cd "$START_PWD"
done