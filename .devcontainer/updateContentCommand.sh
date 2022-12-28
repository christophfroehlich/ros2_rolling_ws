#!/bin/bash
echo "export DISPLAY=\"\$(host host.docker.internal | awk '/has address/ { print \$4 ; exit }'):0.0\"" >> "/home/vscode/.bashrc"
export AMENT_CPPCHECK_ALLOW_SLOW_VERSIONS=true