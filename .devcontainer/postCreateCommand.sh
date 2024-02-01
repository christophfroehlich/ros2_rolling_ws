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
git config --global core.excludesfile ~/.gitignore
# defaults for colcon mixins
mkdir ~/.colcon && cp .devcontainer/defaults.yaml ~/.colcon/
colcon mixin add default \
  https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
  colcon mixin update && \
  colcon metadata add default \
  https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
  colcon metadata update
# Install generate_parameter_library as python package
cd
git clone https://github.com/PickNikRobotics/generate_parameter_library.git
cd generate_parameter_library/generate_parameter_library_py/
python3 -m pip install pyyaml
python3 -m pip install .

