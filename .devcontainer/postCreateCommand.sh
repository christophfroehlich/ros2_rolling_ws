#!/bin/bash
source /opt/ros/rolling/setup.bash
sudo apt-get update
rosdep update --rosdistro $ROS_DISTRO
source /opt/ros/rolling/setup.bash
set -xeu
vcs import src < ros_control.repos
rosdep install -riy --from-paths src
# if the repo is cloned from windows
# git config --global --add safe.directory /workspaces/ros2_rolling_ws