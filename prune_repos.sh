#! /bin/bash
START_PWD=$(pwd)
for dir in src/*/ ros2_control_ci control.ros.org
do
    echo "-- pruning: $dir"
    cd "$dir"
    git fetch --prune origin
    git removed-branches --prune --force -r origin
    if git remote | grep -q '^fork$'; then
      git fetch --prune fork
      git removed-branches --prune --force -r fork
    fi
    git gc
    cd "$START_PWD"
done