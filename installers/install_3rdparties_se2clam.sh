#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

apt_get_update_and_install \
    libeigen3-dev \
    libsuitesparse-dev \
    libcholmod3

# Install ROS packages
apt_get_update_and_install \
    ros-${ROS_DISTRO}-geometry-msgs \
    ros-${ROS_DISTRO}-nav-msgs \
    ros-${ROS_DISTRO}-tf \
    ros-${ROS_DISTRO}-roslib \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-cmake-modules \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-rviz

bash ${CURR_DIR}/install_g2o.sh
bash ${CURR_DIR}/install_opencv.sh

# Clean up cache to reduce layer size.
apt-get clean &&
    rm -rf /var/lib/apt/lists/*
