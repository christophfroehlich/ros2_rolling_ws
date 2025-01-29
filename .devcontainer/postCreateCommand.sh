#!/bin/bash
echo 'export PATH="/usr/lib/ccache:$PATH"' | tee -a ~/.bashrc
# user was not created in docker file yet
sudo addgroup kvm \
  && sudo usermod -aG video ${USERNAME} \
  && sudo usermod -aG 1000 ${USERNAME} \
  && sudo usermod -aG dialout ${USERNAME} \
  && sudo usermod -aG kvm ${USERNAME} # joystick
source /opt/ros/rolling/setup.bash
sudo apt-get update
rosdep update --rosdistro $ROS_DISTRO
set -xeu
vcs import src < ros_control.repos
# https://www.makeuseof.com/fix-pip-error-externally-managed-environment-linux/
sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED || true
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
(cd src/realtime_tools && pre-commit install)
(cd src/gz_ros2_control && pre-commit install)
(cd src/control_toolbox && pre-commit install)
(cd src/control_msgs && pre-commit install)
(cd src/control.ros.org && pre-commit install)
touch src/control.ros.org/COLCON_IGNORE
echo "*.pyc" > ~/.gitignore
echo "*__pycache__*" >> ~/.gitignore
git config --global core.excludesfile ~/.gitignore
echo ".ccache" > ~/.gitignore
echo ".work" > ~/.gitignore
# defaults for colcon mixins
colcon mixin add default \
  https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
  colcon mixin update && \
  colcon metadata add default \
  https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
  colcon metadata update
mkdir -p ~/.colcon && cp .devcontainer/defaults.yaml ~/.colcon/defaults.yaml
# alias to prune fork and origin
echo "alias gitprune='git fetch --prune fork && git fetch --prune origin && git removed-branches --prune --force -r fork && git removed-branches --prune --force -r origin'" >> ~/.bashrc
echo "source /opt/ros/rolling/setup.bash" >> ~/.bashrc
echo "export AMENT_CPPCHECK_ALLOW_SLOW_VERSIONS=true" >> ~/.bashrc