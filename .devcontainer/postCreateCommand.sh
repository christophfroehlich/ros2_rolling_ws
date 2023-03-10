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
# install pre-commit hooks
(cd src/ros2_controllers && pre-commit install)
(cd src/ros2_control && pre-commit install)
(cd src/ros2_control_demos && pre-commit install)
(cd src/control_toolbox && pre-commit install)
(cd src/control_msgs && pre-commit install)
# install clang-format-10 (old pre-commit hooks)
# curl -LO http://archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-8_amd64.deb
# sudo dpkg -i libffi6_3.2.1-8_amd64.deb
# wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# echo 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main' | sudo tee -a /etc/apt/sources.list
# echo 'deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main' | sudo tee -a /etc/apt/sources.list
# sudo apt update
# sudo apt install -y clang-format-10