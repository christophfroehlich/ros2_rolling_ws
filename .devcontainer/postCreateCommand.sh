#!/bin/bash
source /opt/ros/rolling/setup.bash
sudo apt-get update
rosdep update --rosdistro $ROS_DISTRO
source /opt/ros/rolling/setup.bash
set -xeu
vcs import src < ros_control.repos
# install stuff for control.ros.org
(cd src/control.ros.org/ && python3 -m pip install -r requirements.txt)
# Install generate_parameter_library as python package
# python3 -m pip install pyyaml
# pip3 install typeguard==4.0.0
(cd src/generate_parameter_library/generate_parameter_library_py/ && python3 -m pip install .)
# install other dependencies
rosdep install -riy --from-paths src
# if the repo is cloned from windows
# git config --global --add safe.directory /workspaces/ros2_rolling_ws
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
git config --global core.excludesfile ~/.gitignore
#
echo "alias gitprune='git fetch --prune fork && git fetch --prune origin && git removed-branches --prune --force -r fork && git removed-branches --prune --force -r fork'" >> ~/.bashrc
