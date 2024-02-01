#! /bin/bash
START_PWD=$(pwd)
for dir in src/*/
do
    cd "$dir"
    git fetch --prune fork
    git fetch --prune origin
    git removed-branches --prune --force -r fork
    git removed-branches --prune --force -r origin
    cd "$START_PWD"
done