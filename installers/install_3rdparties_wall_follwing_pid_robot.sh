#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

echo "Installing 3rdparty debs ..."

# Install ROS packages
apt_get_update_and_install \
    ros-${ROS_DISTRO}-control-toolbox \
    ros-${ROS_DISTRO}-joystick-drivers \
    ros-${ROS_DISTRO}-realtime-tools \
    ros-${ROS_DISTRO}-ros-control \
    ros-${ROS_DISTRO}-gazebo-ros-control \
    ros-${ROS_DISTRO}-ros-controllers \
    ros-${ROS_DISTRO}-interactive-markers \
    ros-${ROS_DISTRO}-roslint \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-polled-camera \
    ros-${ROS_DISTRO}-camera-info-manager