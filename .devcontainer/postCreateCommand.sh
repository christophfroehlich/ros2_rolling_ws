#!/bin/bash
source /opt/ros/humble/setup.bash
sudo apt-get update
rosdep update --rosdistro $ROS_DISTRO
source /opt/ros/humble/setup.bash
set -xeu
vcs import src < ros_control.repos
rosdep install -riy --from-paths src
# if the repo is cloned from windows
# git config --global --add safe.directory /workspaces/ros2_humble_ws
# install pre-commit hooks
(cd src/ros2_controllers && pre-commit install)
(cd src/ros2_control && pre-commit install)
(cd src/ros2_control_demos && pre-commit install)
(cd src/control_toolbox && pre-commit install)
(cd src/control_msgs && pre-commit install)
(cd src/control.ros.org && pre-commit install)
touch src/control.ros.org/COLCON_IGNORE
echo "*.pyc" > ~/.gitignore
echo "*__pycache__*" >> ~/.gitignore