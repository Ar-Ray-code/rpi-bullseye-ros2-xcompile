#!/bin/bash

cd $(dirname $0)
touch ~/.bashrc
echo "alias xcompile_rpi_ros2='bash $(pwd)/xcompile_rpi_ros2.bash'" >> ~/.bashrc
source ~/.bashrc

echo "create alias done"
echo ""

echo "To use this alias, please enter the following command in the terminal:"
echo "xcompile_rpi_ros2 [ROS2_WS] [OPERATE_BASH (optional)]"
